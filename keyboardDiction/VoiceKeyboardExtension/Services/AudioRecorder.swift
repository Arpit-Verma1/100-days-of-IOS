//
//  AudioRecorder.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import Foundation
import AVFoundation

// MARK: - Audio Recorder Protocol
protocol AudioRecorderProtocol {
    func requestPermission(completion: @escaping (Bool) -> Void)
    func startRecording() async throws
    func stopRecording() async throws -> URL
}

// MARK: - Audio Recorder Implementation
class AudioRecorder: NSObject, AudioRecorderProtocol {
    
    // MARK: - Properties
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try audioSession.setActive(true)
    }
    
    // MARK: - Permission Request
    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // MARK: - Recording Methods
    func startRecording() async throws {
        try setupAudioSession()
        
        // Create temporary file URL
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")
        recordingURL = audioFilename
        
        // Configure recording settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // Create and start recorder
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    func stopRecording() async throws -> URL {
        guard let recorder = audioRecorder, let url = recordingURL else {
            throw AudioRecorderError.notRecording
        }
        
        recorder.stop()
        audioRecorder = nil
        
        // Verify file exists and has content
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: url.path) else {
            throw AudioRecorderError.fileNotFound
        }
        
        let attributes = try fileManager.attributesOfItem(atPath: url.path)
        guard let fileSize = attributes[.size] as? Int64, fileSize > 0 else {
            throw AudioRecorderError.emptyFile
        }
        
        return url
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Audio recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recording error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Audio Recorder Errors
enum AudioRecorderError: LocalizedError {
    case notRecording
    case fileNotFound
    case emptyFile
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .notRecording:
            return "No active recording session"
        case .fileNotFound:
            return "Recording file not found"
        case .emptyFile:
            return "Recording file is empty"
        case .permissionDenied:
            return "Microphone permission denied"
        }
    }
}
