import Foundation
import SwiftUI

// MARK: - App Constants
struct AppConstants {
    static let appName = "Document ChatBot"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        static let animationDuration: Double = 0.3
        static let slowAnimationDuration: Double = 0.5
        
        static let maxMessageWidth: CGFloat = UIScreen.main.bounds.width * 0.75
        static let maxDocumentContentLength = 50000 // 50KB
    }
    
    // MARK: - AI Constants
    struct AI {
        static let maxContextLength = 4000
        static let minConfidenceThreshold: Double = 0.3
        static let maxResponseTime: TimeInterval = 30.0
    }
    
    // MARK: - Document Constants
    struct Document {
        static let maxFileSize = 10 * 1024 * 1024 // 10MB
        static let supportedPDFExtensions = ["pdf"]
        static let supportedTextExtensions = ["txt", "rtf", "md"]
        
        static let defaultTags = [
            "Important",
            "Work",
            "Personal",
            "Research",
            "Notes",
            "Reference"
        ]
    }
    
    // MARK: - Storage Constants
    struct Storage {
        static let documentsDirectory = "ChatBotDocuments"
        static let documentsFile = "documents.json"
        static let sessionsFile = "sessions.json"
        static let settingsFile = "settings.json"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let networkError = "Network connection error. Please check your internet connection."
        static let aiModelError = "AI model is not available. Please try again later."
        static let documentProcessingError = "Failed to process document. Please try again."
        static let fileTooLarge = "File is too large. Maximum size is 10MB."
        static let unsupportedFileType = "Unsupported file type. Please use PDF or text files."
        static let noDocumentsLoaded = "No documents are loaded. Please add some documents first."
        static let emptyQuery = "Please enter a question to ask the AI."
    }
    
    // MARK: - Success Messages
    struct SuccessMessages {
        static let documentAdded = "Document added successfully"
        static let documentDeleted = "Document deleted successfully"
        static let documentUpdated = "Document updated successfully"
        static let responseGenerated = "AI response generated successfully"
    }
}

// MARK: - Color Constants
struct AppColors {
    static let primary = Color.blue
    static let secondary = Color(.systemGray)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.systemGray6)
    static let tertiaryBackground = Color(.systemGray5)
    
    // Document type colors
    static let pdfColor = Color.red
    static let textColor = Color.teal
    static let articleColor = Color.blue
    static let noteColor = Color.green
}

// MARK: - Font Constants
struct AppFonts {
    static let largeTitle = Font.largeTitle
    static let title = Font.title
    static let title2 = Font.title2
    static let title3 = Font.title3
    static let headline = Font.headline
    static let subheadline = Font.subheadline
    static let body = Font.body
    static let callout = Font.callout
    static let caption = Font.caption
    static let caption2 = Font.caption2
    static let footnote = Font.footnote
}

// MARK: - Animation Constants
struct AppAnimations {
    static let easeInOut = Animation.easeInOut(duration: AppConstants.UI.animationDuration)
    static let easeOut = Animation.easeOut(duration: AppConstants.UI.animationDuration)
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let slowEaseInOut = Animation.easeInOut(duration: AppConstants.UI.slowAnimationDuration)
}

// MARK: - Layout Constants
struct AppLayout {
    static let maxWidth: CGFloat = 600
    static let minHeight: CGFloat = 44
    static let standardSpacing: CGFloat = 16
    static let compactSpacing: CGFloat = 8
    static let largeSpacing: CGFloat = 24
}

// MARK: - Validation Constants
struct ValidationConstants {
    static let minTitleLength = 1
    static let maxTitleLength = 100
    static let minContentLength = 10
    static let maxContentLength = 50000
    
    static let minQueryLength = 3
    static let maxQueryLength = 1000
    
    static let maxTagsPerDocument = 10
    static let maxTagLength = 20
}

// MARK: - Performance Constants
struct PerformanceConstants {
    static let maxConcurrentOperations = 3
    static let documentProcessingTimeout: TimeInterval = 60.0
    static let aiResponseTimeout: TimeInterval = 30.0
    static let searchDebounceTime: TimeInterval = 0.3
    static let autoSaveInterval: TimeInterval = 30.0
}

// MARK: - Accessibility Constants
struct AccessibilityConstants {
    static let minimumTapTargetSize: CGFloat = 44
    static let minimumTextSize: CGFloat = 11
    static let highContrastEnabled = true
    static let reduceMotionEnabled = true
} 