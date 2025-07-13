# Document ChatBot - iOS App with Foundation Models

A sophisticated iOS chatbot application that uses Apple's FoundationModels for on-device AI to answer questions based on uploaded documents. Built with SwiftUI, following MVVM architecture and clean architecture principles.

## 🚀 Features

### Core Functionality
- **On-Device AI Processing**: Uses Apple's FoundationModels for privacy-first, offline AI responses
- **Document Upload & Management**: Support for PDF and text documents with intelligent processing
- **Context-Aware Q&A**: AI answers questions based on uploaded document content using Foundation Models
- **Document Analysis**: Automatic analysis and summarization of documents
- **Multi-Document Support**: Chat with multiple documents simultaneously
- **Advanced Text Extraction**: Enhanced PDF parsing with better text quality

### Technical Features
- **FoundationModels Integration**: Real on-device AI using Apple's latest framework
- **MVVM Architecture**: Clean separation of concerns with ViewModels
- **Clean Architecture**: Modular design with reusable components
- **Singleton Services**: Efficient service management
- **Error Handling**: Comprehensive error handling and user feedback
- **Offline-First**: Works completely offline without external APIs
- **Modern UI**: Beautiful, responsive SwiftUI interface with tab navigation

## 🏗️ Architecture

### Project Structure
```
chatBot/
├── Models/
│   └── Document.swift              # Data models with FoundationModels integration
├── Services/
│   ├── DocumentService.swift       # Enhanced document processing and management
│   └── AIService.swift            # FoundationModels AI integration
├── ViewModels/
│   ├── ChatViewModel.swift         # Enhanced chat interaction logic
│   └── DocumentManagementViewModel.swift # Document management logic
├── Views/
│   ├── ChatView.swift             # Enhanced chat interface
│   ├── DocumentManagementView.swift # Document management interface
│   └── DocumentDetailView.swift   # Document detail view
├── Utilities/
│   ├── Constants.swift            # App-wide constants
│   ├── Extensions.swift           # Swift extensions
│   └── Logger.swift              # Logging utilities
└── Assets/
    └── Assets.xcassets           # App assets
```

### Architecture Layers

#### 1. Presentation Layer (Views)
- **ChatView**: Main chat interface with message bubbles and document upload
- **DocumentManagementView**: Document upload, management, and organization
- **DocumentDetailView**: Detailed document analysis and statistics

#### 2. Business Logic Layer (ViewModels)
- **ChatViewModel**: Manages chat sessions, messages, and AI interactions
- **DocumentManagementViewModel**: Handles document operations and analysis

#### 3. Data Layer (Services)
- **DocumentService**: Enhanced PDF parsing, text extraction, document persistence
- **AIService**: FoundationModels integration for on-device AI processing

#### 4. Domain Layer (Models)
- **Document**: Core document model with metadata and analysis
- **ChatMessage**: Message model for chat interactions
- **DocumentAnalysis**: Document analysis results

## 🛠️ Key Components

### Foundation Models Integration
```swift
// Initialize Foundation Models
func initializeModel() async throws {
    languageModel = try await LanguageModel.loadDefault()
    isModelLoaded = true
}

// Generate AI responses
func generateResponse(with model: LanguageModel, prompt: String) async throws -> String {
    let configuration = LanguageModel.Configuration(
        temperature: 0.7,
        topP: 0.9,
        maxTokens: 1000
    )
    
    let result = try await model.generateText(prompt, configuration: configuration)
    return result.text
}
```

### Enhanced Document Processing
```swift
// PDF parsing with better quality
func parsePDF(from url: URL) async throws -> String {
    guard let pdf = PDFDocument(url: url) else {
        throw DocumentError.invalidPDF
    }
    
    var extractedText = ""
    for i in 0..<pdf.pageCount {
        if let page = pdf.page(at: i), let pageText = page.string {
            let cleanedText = cleanText(pageText)
            extractedText += cleanedText + "\n\n"
        }
    }
    
    return extractedText.trimmingCharacters(in: .whitespacesAndNewlines)
}

// Document analysis
func analyzeDocument(_ document: Document) -> DocumentAnalysis {
    let words = document.content.components(separatedBy: .whitespacesAndNewlines)
    let keyTopics = extractKeyTopics(from: document.content)
    let complexity = calculateComplexity(content: document.content)
    
    return DocumentAnalysis(
        wordCount: words.count,
        keyTopics: keyTopics,
        complexity: complexity
    )
}
```

### Context-Aware AI Responses
```swift
// Create context-aware prompts
private func createContextAwarePrompt(question: String, document: Document?) -> String {
    var prompt = "You are an intelligent AI assistant..."
    
    if let document = document, !document.content.isEmpty {
        let relevantSections = findRelevantSections(query: question, in: document.content)
        
        prompt += """
        DOCUMENT CONTEXT:
        Title: \(document.title)
        
        RELEVANT DOCUMENT SECTIONS:
        \(relevantSections.joined(separator: "\n\n"))
        
        USER QUESTION: \(question)
        
        ANSWER:
        """
    }
    
    return prompt
}
```

## 📱 User Interface

### Main Features
1. **Tab-Based Navigation**: Chat and Documents tabs for easy access
2. **Modern Chat Interface**: Message bubbles with typing indicators and auto-scroll
3. **Document Management**: Upload, view, and manage documents with search
4. **Document Analysis**: View detailed statistics and key topics
5. **Settings & Configuration**: App preferences and information

### UI Components
- **MessageBubbleView**: Enhanced chat message bubbles with text selection
- **DocumentRowView**: Document list items with metadata and actions
- **DocumentDetailView**: Comprehensive document analysis and statistics
- **SearchBar**: Real-time document search functionality
- **Loading States**: Progress indicators and skeleton views
- **Error Handling**: User-friendly error messages and alerts

## 🔧 Technical Implementation

### Dependencies
- **FoundationModels**: Apple's on-device AI processing framework
- **PDFKit**: PDF document parsing and text extraction
- **SwiftUI**: Modern UI framework with declarative syntax
- **Combine**: Reactive programming for data binding

### Key Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **Singleton**: Service instances (DocumentService, AIService)
- **Protocol-Oriented**: Service protocols for testability
- **Async/Await**: Modern concurrency for better performance
- **Combine**: Reactive data binding and state management

### Error Handling
```swift
enum AIError: LocalizedError {
    case modelLoadFailed(Error)
    case modelNotAvailable
    case generationFailed(Error)
    case invalidInput
}

enum DocumentError: LocalizedError {
    case invalidPDF
    case noTextFound
    case unsupportedFileType
    case fileTooLarge
}
```

### Constants & Configuration
```swift
struct AppConstants {
    struct AI {
        static let maxContextLength = 4000
        static let minConfidenceThreshold: Double = 0.3
        static let maxResponseTime: TimeInterval = 30.0
    }
    
    struct Document {
        static let maxFileSize = 10 * 1024 * 1024 // 10MB
        static let supportedPDFExtensions = ["pdf"]
        static let supportedTextExtensions = ["txt", "rtf", "md"]
    }
}
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- FoundationModels framework (included in iOS 17+)

### Installation
1. Clone the repository
2. Open `chatBot.xcodeproj` in Xcode
3. Build and run the project

### Usage
1. **Add Documents**: Use the Documents tab to upload PDFs or text files
2. **Start Chatting**: Switch to the Chat tab and ask questions
3. **Document Analysis**: View detailed analysis and key topics
4. **Get AI Answers**: Receive context-aware responses from Foundation Models

## 🔒 Privacy & Security

- **On-Device Processing**: All AI processing happens locally using Foundation Models
- **No External APIs**: No data sent to external servers
- **Local Storage**: Documents stored securely on device
- **No Tracking**: No analytics or user tracking
- **Privacy-First**: Apple's Foundation Models ensure data privacy

## 🧪 Testing

### Unit Tests
- Service layer testing with Foundation Models
- ViewModel logic testing
- Model validation testing
- Document processing testing

### UI Tests
- User interaction testing
- Document upload flow testing
- Chat functionality testing
- Tab navigation testing

## 📈 Performance

### Optimizations
- **Lazy Loading**: Documents loaded on demand
- **Memory Management**: Efficient document processing
- **Background Processing**: AI operations on background threads
- **Caching**: Document analysis results cached
- **Foundation Models**: Optimized on-device AI processing

### Metrics
- Document processing time: < 5 seconds for typical PDFs
- AI response time: < 10 seconds for complex queries
- Memory usage: Optimized for mobile devices
- Foundation Models: Fast on-device inference

## 🔮 Future Enhancements

### Planned Features
- **Voice Input**: Speech-to-text for questions
- **Document Sharing**: Export and share documents
- **Advanced Search**: Full-text search across documents
- **Document Categories**: Organize documents by type/topic
- **Offline Sync**: Cloud sync when online
- **Multi-language Support**: Internationalization
- **Custom Foundation Models**: User-specific model fine-tuning

### Technical Improvements
- **Core Data Integration**: Better data persistence
- **Background Processing**: Document analysis in background
- **Push Notifications**: Document processing updates
- **Widgets**: Quick access to recent documents
- **Siri Integration**: Voice commands for document operations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Apple**: For FoundationModels and iOS development tools
- **FoundationModels**: For on-device AI capabilities
- **SwiftUI**: For modern UI development
- **Community**: For inspiration and feedback

---

**Built with ❤️ using SwiftUI and Apple's FoundationModels** 