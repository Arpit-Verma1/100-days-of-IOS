import Foundation
import os.log

// MARK: - Logger Utility
class AppLogger {
    static let shared = AppLogger()
    
    private let subsystem = Bundle.main.bundleIdentifier ?? "com.chatbot.app"
    private let category = "ChatBot"
    
    private let osLog: OSLog
    private let dateFormatter: DateFormatter
    
    private init() {
        self.osLog = OSLog(subsystem: subsystem, category: category)
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    // MARK: - Logging Methods
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let logMessage = formatMessage(message, level: "DEBUG", file: file, function: function, line: line)
        os_log(.debug, log: osLog, "%{public}@", logMessage)
        print("🔍 [DEBUG] \(logMessage)")
        #endif
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let logMessage = formatMessage(message, level: "INFO", file: file, function: function, line: line)
        os_log(.info, log: osLog, "%{public}@", logMessage)
        print("ℹ️ [INFO] \(logMessage)")
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let logMessage = formatMessage(message, level: "WARNING", file: file, function: function, line: line)
        os_log(.error, log: osLog, "%{public}@", logMessage)
        print("⚠️ [WARNING] \(logMessage)")
    }
    
    func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        var fullMessage = message
        if let error = error {
            fullMessage += " - Error: \(error.localizedDescription)"
        }
        
        let logMessage = formatMessage(fullMessage, level: "ERROR", file: file, function: function, line: line)
        os_log(.fault, log: osLog, "%{public}@", logMessage)
        print("❌ [ERROR] \(logMessage)")
    }
    
    func critical(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        var fullMessage = message
        if let error = error {
            fullMessage += " - Error: \(error.localizedDescription)"
        }
        
        let logMessage = formatMessage(fullMessage, level: "CRITICAL", file: file, function: function, line: line)
        os_log(.fault, log: osLog, "%{public}@", logMessage)
        print("🚨 [CRITICAL] \(logMessage)")
    }
    
    // MARK: - Performance Logging
    func performance(_ operation: String, duration: TimeInterval) {
        let message = "Performance: \(operation) took \(String(format: "%.3f", duration))s"
        info(message)
    }
    
    func startTimer(_ operation: String) -> PerformanceTimer {
        return PerformanceTimer(operation: operation, logger: self)
    }
    
    // MARK: - AI Specific Logging
    func aiRequest(_ question: String, documentCount: Int) {
        info("AI Request - Question: '\(question)', Documents: \(documentCount)")
    }
    
    func aiResponse(_ response: String, confidence: Double, duration: TimeInterval) {
        info("AI Response - Confidence: \(String(format: "%.2f", confidence)), Duration: \(String(format: "%.3f", duration))s")
        debug("AI Response Content: \(response)")
    }
    
    func documentProcessed(_ title: String, type: String, size: Int) {
        info("Document Processed - Title: '\(title)', Type: \(type), Size: \(size) bytes")
    }
    
    // MARK: - Private Methods
    private func formatMessage(_ message: String, level: String, file: String, function: String, line: Int) -> String {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        return "[\(timestamp)] [\(level)] [\(fileName):\(line)] \(function): \(message)"
    }
}

// MARK: - Performance Timer
class PerformanceTimer {
    private let operation: String
    private let logger: AppLogger
    private let startTime: CFAbsoluteTime
    
    init(operation: String, logger: AppLogger) {
        self.operation = operation
        self.logger = logger
        self.startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() {
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        logger.performance(operation, duration: duration)
    }
}

// MARK: - Convenience Extensions
extension AppLogger {
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.debug(message, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.info(message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.warning(message, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        shared.error(message, error: error, file: file, function: function, line: line)
    }
    
    static func critical(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        shared.critical(message, error: error, file: file, function: function, line: line)
    }
    
    static func performance(_ operation: String, duration: TimeInterval) {
        shared.performance(operation, duration: duration)
    }
    
    static func startTimer(_ operation: String) -> PerformanceTimer {
        return shared.startTimer(operation)
    }
}

// MARK: - Usage Examples
/*
 // Basic logging
 AppLogger.info("App started successfully")
 AppLogger.debug("Processing document: \(document.title)")
 AppLogger.warning("Low memory detected")
 AppLogger.error("Failed to save document", error: saveError)
 
 // Performance logging
 let timer = AppLogger.startTimer("Document Processing")
 // ... perform operation
 timer.stop()
 
 // AI specific logging
 AppLogger.aiRequest("What is the main topic?", documentCount: 3)
 AppLogger.aiResponse("The main topic is...", confidence: 0.85, duration: 2.3)
 AppLogger.documentProcessed("Report.pdf", type: "PDF", size: 1024000)
 */ 