//
//  TranscriptionService.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import Foundation

// MARK: - Transcription Service Protocol
protocol TranscriptionServiceProtocol {
    func transcribeAudio(from audioURL: URL) async throws -> String
}

// MARK: - Transcription Service Implementation
class TranscriptionService: TranscriptionServiceProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    private let apiKeyManager: APIKeyManagerProtocol
    
    // MARK: - Constants
    private let baseURL = "https://api.groq.com/openai/v1/audio/transcriptions"
    
    // MARK: - Initialization
    init(session: URLSession = .shared, apiKeyManager: APIKeyManagerProtocol = APIKeyManager()) {
        self.session = session
        self.apiKeyManager = apiKeyManager
    }
    
    // MARK: - Transcription Method
    func transcribeAudio(from audioURL: URL) async throws -> String {
        guard let apiKey = apiKeyManager.getAPIKey() else {
            throw TranscriptionError.missingAPIKey
        }
        
        // Create multipart form data
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Prepare form data
        var body = Data()
        
        // Add file data
        let audioData = try Data(contentsOf: audioURL)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add model parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-large-v3\r\n".data(using: .utf8)!)
        
        // Add language parameter (optional, for better accuracy)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
        body.append("en\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Make request
        let (data, response) = try await session.data(for: request)
        
        // Handle response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranscriptionError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw TranscriptionError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        // Parse response
        let transcriptionResponse = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
        return transcriptionResponse.text
    }
}

// MARK: - Response Models
struct TranscriptionResponse: Codable {
    let text: String
}

// MARK: - Transcription Errors
enum TranscriptionError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case apiError(statusCode: Int, message: String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key not found. Please add your Groq API key in Settings."
        case .invalidResponse:
            return "Invalid response from transcription service"
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        case .decodingError:
            return "Failed to decode transcription response"
        }
    }
}
