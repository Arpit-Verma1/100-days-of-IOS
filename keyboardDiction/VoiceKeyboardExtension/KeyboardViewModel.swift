//
//  KeyboardViewModel.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import Foundation
import AVFoundation
import Combine
import UIKit

@MainActor
class KeyboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var recordingState: RecordingState = .idle
    @Published var isRecording = false
    @Published var isProcessing = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let textDocumentProxy: TextDocumentProxyProtocol
    private let audioRecorder: AudioRecorderProtocol
    private let transcriptionService: TranscriptionServiceProtocol
    private let hapticFeedback: HapticFeedbackProtocol
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        textDocumentProxy: TextDocumentProxyProtocol,
        audioRecorder: AudioRecorderProtocol = AudioRecorder(),
        transcriptionService: TranscriptionServiceProtocol = TranscriptionService(),
        hapticFeedback: HapticFeedbackProtocol = HapticFeedback()
    ) {
        self.textDocumentProxy = textDocumentProxy
        self.audioRecorder = audioRecorder
        self.transcriptionService = transcriptionService
        self.hapticFeedback = hapticFeedback
        
        setupBindings()
    }
    
    // MARK: - Public Methods
    func requestMicrophonePermission() {
        audioRecorder.requestPermission { [weak self] granted in
            if !granted {
                self?.errorMessage = "Microphone permission is required for voice recording"
            }
        }
    }
    
    func startRecording() {
        Task {
            do {
                try await audioRecorder.startRecording()
                recordingState = .recording
                isRecording = true
                hapticFeedback.impact(.medium)
            } catch {
                errorMessage = "Failed to start recording: \(error.localizedDescription)"
            }
        }
    }
    
    func stopRecording() {
        Task {
            do {
                let audioURL = try await audioRecorder.stopRecording()
                recordingState = .processing
                isRecording = false
                isProcessing = true
                hapticFeedback.impact(.light)
                
                await transcribeAudio(from: audioURL)
            } catch {
                errorMessage = "Failed to stop recording: \(error.localizedDescription)"
                recordingState = .idle
                isRecording = false
                isProcessing = false
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Clear error message after 3 seconds
        $errorMessage
            .compactMap { $0 }
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    private func transcribeAudio(from audioURL: URL) async {
        do {
            let transcribedText = try await transcriptionService.transcribeAudio(from: audioURL)
            
            // Insert text at cursor position
            textDocumentProxy.insertText(transcribedText)
            
            recordingState = .completed
            isProcessing = false
            hapticFeedback.impact(.light)
            
            // Reset to idle state after brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.recordingState = .idle
            }
            
        } catch {
            errorMessage = "Transcription failed: \(error.localizedDescription)"
            recordingState = .idle
            isProcessing = false
        }
    }
}

// MARK: - Recording State
enum RecordingState {
    case idle
    case recording
    case processing
    case completed
}
