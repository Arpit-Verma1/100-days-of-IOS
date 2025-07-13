import Foundation

// MARK: - Document Models
struct Document: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var type: DocumentType
    var dateAdded: Date
    var size: Int
    var tags: [String]
    var source: String
    
    init(id: String = UUID().uuidString, title: String, content: String, type: DocumentType, source: String = "Manual Input") {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.dateAdded = Date()
        self.size = content.utf8.count
        self.tags = []
        self.source = source
    }
}

enum DocumentType: String, CaseIterable, Codable {
    case pdf = "PDF"
    case text = "Text"
    case article = "Article"
    case note = "Note"
    
    var icon: String {
        switch self {
        case .pdf: return "doc.text.fill"
        case .text: return "doc.text"
        case .article: return "newspaper.fill"
        case .note: return "note.text"
        }
    }
    
    var color: String {
        switch self {
        case .pdf: return "#FF6B6B"
        case .text: return "#4ECDC4"
        case .article: return "#45B7D1"
        case .note: return "#96CEB4"
        }
    }
}

// MARK: - Chat Models
struct ChatMessage: Identifiable, Codable {
    var id: String
    var content: String
    var sender: MessageSender
    var timestamp: Date
    var status: MessageStatus
    var documentContext: String?
    var confidence: Double?
    
    init(id: String = UUID().uuidString, content: String, sender: MessageSender, documentContext: String? = nil) {
        self.id = id
        self.content = content
        self.sender = sender
        self.timestamp = Date()
        self.status = .sent
        self.documentContext = documentContext
        self.confidence = nil
    }
}

enum MessageSender: String, CaseIterable, Codable {
    case user = "User"
    case assistant = "Assistant"
    case system = "System"
    
    var icon: String {
        switch self {
        case .user: return "person.circle.fill"
        case .assistant: return "brain.head.profile"
        case .system: return "gear.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .user: return "#007AFF"
        case .assistant: return "#34C759"
        case .system: return "#FF9500"
        }
    }
}

enum MessageStatus: String, CaseIterable, Codable {
    case sending = "Sending"
    case sent = "Sent"
    case delivered = "Delivered"
    case failed = "Failed"
    
    var icon: String {
        switch self {
        case .sending: return "clock.fill"
        case .sent: return "checkmark.circle.fill"
        case .delivered: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
}

// MARK: - Chat Session
struct ChatSession: Identifiable, Codable {
    var id: String
    var title: String
    var messages: [ChatMessage]
    var createdAt: Date
    var lastActivity: Date
    var documents: [String] // Document IDs
    var tags: [String]
    
    init(id: String = UUID().uuidString, title: String, documents: [String] = []) {
        self.id = id
        self.title = title
        self.messages = []
        self.createdAt = Date()
        self.lastActivity = Date()
        self.documents = documents
        self.tags = []
    }
}

// MARK: - AI Response Context
struct AIResponseContext: Codable {
    var relevantSections: [String]
    var confidence: Double
    var reasoning: String
    var sourceDocuments: [String]
    
    init(relevantSections: [String] = [], confidence: Double = 0.0, reasoning: String = "", sourceDocuments: [String] = []) {
        self.relevantSections = relevantSections
        self.confidence = confidence
        self.reasoning = reasoning
        self.sourceDocuments = sourceDocuments
    }
} 