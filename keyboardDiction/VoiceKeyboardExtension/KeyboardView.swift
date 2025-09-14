//
//  KeyboardView.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import SwiftUI

struct KeyboardView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: KeyboardViewModel
    @State private var isPressed = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Error message
                if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage)
                }
                
                Spacer()
                
                // Main recording button
                RecordingButton(
                    isPressed: $isPressed,
                    recordingState: viewModel.recordingState,
                    isProcessing: viewModel.isProcessing
                ) {
                    // Button pressed
                    viewModel.startRecording()
                } onRelease: {
                    // Button released
                    viewModel.stopRecording()
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Recording Button
struct RecordingButton: View {
    
    // MARK: - Properties
    @Binding var isPressed: Bool
    let recordingState: RecordingState
    let isProcessing: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: {}) {
            ZStack {
                // Background circle
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 120, height: 120)
                    .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
                
                // Icon
                Image(systemName: iconName)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(iconColor)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                // Processing indicator
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
            }
        }
        .buttonStyle(RecordingButtonStyle(
            isPressed: $isPressed,
            onPress: onPress,
            onRelease: onRelease
        ))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        switch recordingState {
        case .idle:
            return .blue
        case .recording:
            return .red
        case .processing:
            return .orange
        case .completed:
            return .green
        }
    }
    
    private var iconName: String {
        switch recordingState {
        case .idle:
            return "mic.fill"
        case .recording:
            return "mic.fill"
        case .processing:
            return "waveform"
        case .completed:
            return "checkmark"
        }
    }
    
    private var iconColor: Color {
        return .white
    }
    
    private var shadowColor: Color {
        switch recordingState {
        case .idle:
            return .blue.opacity(0.3)
        case .recording:
            return .red.opacity(0.3)
        case .processing:
            return .orange.opacity(0.3)
        case .completed:
            return .green.opacity(0.3)
        }
    }
}

// MARK: - Recording Button Style
struct RecordingButtonStyle: ButtonStyle {
    
    @Binding var isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onLongPressGesture(
                minimumDuration: 0,
                maximumDistance: .infinity,
                pressing: { pressing in
                    isPressed = pressing
                    if pressing {
                        onPress()
                    } else {
                        onRelease()
                    }
                },
                perform: {}
            )
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - Preview
#Preview {
    KeyboardView(viewModel: KeyboardViewModel(textDocumentProxy: MockTextDocumentProxy()))
}
