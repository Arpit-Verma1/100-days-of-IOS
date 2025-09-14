import Foundation
import ActivityKit
import Combine

@MainActor
final class DeliveryViewModel: ObservableObject {
    @Published var isRunning: Bool = false

    private var activity: Activity<DeliveryAttributes>?
    private var timer: Timer?

    // Demo path
    private let startCoordinate = (lat: 37.3327, lon: -122.0053)
    private let endCoordinate = (lat: 37.3349, lon: -122.0090)

    func startDemo(quantity: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        guard activity == nil else { return }

        let startTime = Date()
        let attributes = DeliveryAttributes(orderId: "ORDER-\(quantity)-\(UUID().uuidString.prefix(6))")
        let initialState = DeliveryAttributes.ContentState(
            latitude: startCoordinate.lat,
            longitude: startCoordinate.lon,
            showMap: false,
            isArrived: false,
            progress: 0.0,
            startTime: startTime,
            progressIndex: 0
        )

        do {
            let initialContent = ActivityContent(state: initialState, staleDate: nil)
            activity = try Activity.request(attributes: attributes, content: initialContent, pushType: nil)
            isRunning = true
            startUpdating()
        } catch {
            print("Failed to start activity: \(error)")
        }
    }

    func stopDemo() async {
        timer?.invalidate()
        timer = nil
        isRunning = false

        let endContent = ActivityContent(
            state: DeliveryAttributes.ContentState(
                latitude: endCoordinate.lat,
                longitude: endCoordinate.lon,
                showMap: true,
                isArrived: true,
                progress: 1.0,
                startTime: activity?.content.state.startTime ?? Date(),
                progressIndex: 0
            ),
            staleDate: nil
        )

        await activity?.end(endContent,dismissalPolicy: .default)
        activity = nil
    }

    private func startUpdating() {
        let deliveryDuration: TimeInterval = 30 // 2 minutes total delivery time
        var showMap = false

        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            // Calculate elapsed time and progress
            let elapsedTime = Date().timeIntervalSince(self.activity?.content.state.startTime ?? Date())
            let progress = min(elapsedTime / deliveryDuration, 1.0)
            print("Progress: \(String(format: "%.2f", progress * 100))% - Elapsed: \(String(format: "%.1f", elapsedTime))s")
            
            if progress >= 1.0 { // Arrived
                Task { await self.stopDemo() }
                return
            }

            // Calculate coordinates based on progress
            let lat = self.startCoordinate.lat + (self.endCoordinate.lat - self.startCoordinate.lat) * progress
            let lon = self.startCoordinate.lon + (self.endCoordinate.lon - self.startCoordinate.lon) * progress

            showMap.toggle()

            let updateContent = ActivityContent(
                state: DeliveryAttributes.ContentState(
                    latitude: lat,
                    longitude: lon,
                    showMap: showMap,
                    isArrived: false,
                    progress: progress,
                    startTime: self.activity?.content.state.startTime ?? Date(),
                    progressIndex:Int(elapsedTime / 5.0)
                ),
                staleDate: nil
            )

            Task {
                await self.activity?.update(updateContent)
            }
        }
    }
}

