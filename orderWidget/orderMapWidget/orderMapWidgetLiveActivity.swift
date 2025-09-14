//
//  orderMapWidgetLiveActivity.swift
//  orderMapWidget
//
//  Created by Arpit Verma on 9/7/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

// NOTE: DeliveryAttributes is defined in the app target.
// Ensure the file's Target Membership includes the widget extension as well.

private class Dummy {}
struct orderMapWidgetLiveActivity: Widget {
    @State private var showWow = true
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            
            
            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Text(
                        "WoW! MoMo"
                    )
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(.logo)
                        .resizable()
                        .frame(width: 70,height: 15)
                        
                }
                
                // Main status message
                HStack {
                    VStack (alignment: .leading){
                        HStack {
                            if context.state.isArrived {
                                Text("Arrived at your door")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("🏠")
                                    .font(.title2)
                            } else {
                                Text("Arriving in 24 minutes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("🤘")
                                    .font(.title2)
                            }
                        }
                        
                        // Status subtitle
                        Text(
                            context.state.progress < 0.2
                            ? "📋 Restaurant confirmed your order"
                            : context.state.progress < 0.4
                            ? "👨‍🍳 Your meal is being freshly prepared"
                            : context.state.progress < 0.6
                            ? "👜 Order is packed and ready to go"
                            : context.state.progress < 0.99
                            ? "🚴 Rider is on the way"
                            :"🏠 Delivered at your doorstep"
                            
                        )
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    Spacer()
                   
                    Image(context.state.progressIndex % 2 == 0 ? "wow" : "momo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50) // square size
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                       
                        .onAppear {
                                        // Change every 5 seconds
                                        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                                            showWow.toggle()
                                        }
                                    }
                }

                    
                
                // Progress timeline with moving rider
                
                HStack(spacing: 0) {
                    // Restaurant icon - fixed position
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                        Image(systemName: "fork.knife")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    // Fixed spacing between icon and line
                    Spacer()
                        .frame(width: 5)
                    
                    // Progress line with rider position - fixed width container
                    ZStack(alignment: .leading) {
                        // Use the dynamic progress value from context.state.progress
                        let progress = context.state.progress
                        let totalLineWidth: CGFloat = 300 // Fixed total width
                        let riderWidth: CGFloat = 50 // Rider image width
                        let availableLineWidth = totalLineWidth - riderWidth
                        
                        // Background dashed line (full width)
                        HStack(spacing: 4) {
                            let maxLines = 16
                            let lineWidth: CGFloat = 16
                            let lineHeight: CGFloat = 3
                            ForEach(0..<maxLines, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.white.opacity(0.6))
                                    .frame(width: lineWidth, height: lineHeight)
                            }
                        }
                        
                        // Solid line overlay (grows with progress)
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 3)
                            .frame(width: progress * availableLineWidth)
                        if progress > 0.2 {
                            HStack {
                                Spacer()
                                    .frame(width: 0.1 * availableLineWidth)
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                    Image(systemName: "frying.pan")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                        if progress > 0.4 {
                            HStack {
                                Spacer()
                                    .frame(width: 0.3 * availableLineWidth)
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                        // Rider position indicator
                        HStack {
                            Spacer()
                                .frame(width: progress * availableLineWidth)
                            
                            // Rider icon
                            ZStack {
                                Image("rider")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }
                            .offset(y: -13)
                           
                        }
                    }
                    .frame(width: 290, height: 24) // Fixed width container
                    
                    // Fixed spacing between line and icon
                    Spacer()
                        .frame(width: 5)
                    
                    // Delivery destination icon - fixed position
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                        Image(systemName: "house")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Chef Ristoranto")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("zomato")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.isArrived ? "Arrived at your door" : "Arriving in 24 minutes")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(context.state.isArrived ? "🏠" : "🤘")
                    }
                }
            } compactLeading: {
                Image(systemName: "fork.knife")
                    .foregroundColor(.orange)
            } compactTrailing: {
                Text(context.state.isArrived ? "🏠" : "24m")
                    .font(.caption)
                    .fontWeight(.semibold)
            } minimal: {
                Image(systemName: context.state.isArrived ? "checkmark.circle.fill" : "fork.knife")
                    .foregroundColor(context.state.isArrived ? .green : .orange)
            }
            .keylineTint(Color.orange)
        }
    }
}

extension DeliveryAttributes {
    fileprivate static var preview: DeliveryAttributes {
        DeliveryAttributes(orderId: "DEMO")
    }
}

extension DeliveryAttributes.ContentState {
    fileprivate static var previewStart: DeliveryAttributes.ContentState {
        DeliveryAttributes.ContentState(
            latitude: 37.3327, 
            longitude: -122.0053, 
            showMap: false, 
            isArrived: false,
            progress: 0.0,
            startTime: Date(),
            progressIndex: 1
        )
    }
    
    fileprivate static var previewMiddle: DeliveryAttributes.ContentState {
        DeliveryAttributes.ContentState(
            latitude: 37.3338, 
            longitude: -122.0071, 
            showMap: true, 
            isArrived: false,
            progress: 0.5,
            startTime: Date(),
            progressIndex: 0
        )
    }
    
    fileprivate static var previewArrived: DeliveryAttributes.ContentState {
        DeliveryAttributes.ContentState(
            latitude: 37.3349, 
            longitude: -122.0090, 
            showMap: true, 
            isArrived: true,
            progress: 1.0,
            startTime: Date(),
            progressIndex: 1
        )
    }
}

#Preview("Notification", as: .content, using: DeliveryAttributes.preview) {
   orderMapWidgetLiveActivity()
} contentStates: {
    DeliveryAttributes.ContentState.previewStart
    DeliveryAttributes.ContentState.previewMiddle
    DeliveryAttributes.ContentState.previewArrived
}

