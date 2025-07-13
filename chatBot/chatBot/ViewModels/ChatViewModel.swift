import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentDocument: Document?
    @Published var userInput = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isProcessingDocument = false
    @Published var documentAnalysis: DocumentAnalysis?
    
    private let documentService = DocumentService.shared
    private let aiService = AIService.shared
    
    init() {
        // Initialize AI model on app start
        Task {
            await initializeAI()
        }
    }
    
    // MARK: - AI Initialization
    private func initializeAI() async {
//        do {
//            try await aiService.initializeModel()
//            print("✅ AI model initialized successfully")
//        } catch {
//            print("❌ Failed to initialize AI model: \(error)")
//            await MainActor.run {
//                errorMessage = "Failed to initialize AI model. Some features may not work properly."
//            }
//        }
    }
    
    // MARK: - Message Handling
    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            content: userInput.trimmingCharacters(in: .whitespacesAndNewlines),
            sender: .user
        )
        
        messages.append(userMessage)
        let question = userMessage.content
        userInput = ""
        
        // Debug logging
        if let document = currentDocument {
            print("🤖 Sending question with document context:")
            print("🤖 Document: \(document.title)")
            print("🤖 Document text available: \(document.content.count) characters")
            print("🤖 Question: \(question)")
        } else {
            print("🤖 Sending general question: \(question)")
        }
        
        // Get AI response asynchronously
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let aiResponse = try await aiService.answer(question: question, document: currentDocument)
                
                let aiMessage = ChatMessage(
                    content: aiResponse,
                    sender: .assistant
                )
                
                messages.append(aiMessage)
                
            } catch {
                errorMessage = "Failed to get AI response: \(error.localizedDescription)"
                
                let errorMessage = ChatMessage(
                    content: "Sorry, I couldn't generate a response. Please try again.",
                    sender: .assistant
                )
                messages.append(errorMessage)
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Document Upload
    func uploadPDF(from url: URL) {
        isProcessingDocument = true
        errorMessage = nil
        
        Task {
            do {
                // Validate file
                try documentService.validateFileSize(url: url)
                let documentType = try documentService.validateDocument(url: url)
                
                // Parse PDF
                let pdfText = try await documentService.parsePDF(from: url)
                
                // Create document object
                let document = Document(
                    title: url.deletingPathExtension().lastPathComponent,
                    content: pdfText,
                    type: documentType,
                    source: "PDF Upload"
                )
                
                // Analyze document
                let analysis = documentService.analyzeDocument(document)
                
                // Save document
                try await documentService.saveDocument(document)
                
                await MainActor.run {
                    currentDocument = document
                    documentAnalysis = analysis
                    isProcessingDocument = false
                    
                    // Add system message with document info
                    let systemMessage = ChatMessage(
                        content: """
                        📄 Document uploaded: \(document.title)
                        
                        📊 Document Analysis:
                        • \(analysis.wordCount) words
                        • \(analysis.sentenceCount) sentences
                        • \(analysis.paragraphCount) paragraphs
                        • Estimated reading time: \(analysis.estimatedReadingTime) minutes
                        • Complexity: \(analysis.complexity.rawValue)
                        
                        🔑 Key Topics:
                        \(analysis.keyTopics.prefix(5).map { "• \($0)" }.joined(separator: "\n"))
                        
                        You can now ask questions about this document!
                        """,
                        sender: .system
                    )
                    messages.append(systemMessage)
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "Error processing PDF: \(error.localizedDescription)"
                    isProcessingDocument = false
                }
            }
        }
    }
    
    // MARK: - Document Management
    func clearDocument() {
        currentDocument = nil
        documentAnalysis = nil
        let systemMessage = ChatMessage(
            content: "🗑️ Document cleared. You can now ask general questions or upload a new document.",
            sender: .system
        )
        messages.append(systemMessage)
    }
    
    func loadSavedDocuments() async {
        do {
            let documents = try await documentService.loadDocuments()
            if let lastDocument = documents.last {
                await MainActor.run {
                    currentDocument = lastDocument
                    documentAnalysis = documentService.analyzeDocument(lastDocument)
                    
                    let systemMessage = ChatMessage(
                        content: "📄 Loaded previous document: \(lastDocument.title)",
                        sender: .system
                    )
                    messages.append(systemMessage)
                }
            }
        } catch {
            print("Failed to load saved documents: \(error)")
        }
    }
    
    func deleteCurrentDocument() async {
        guard let document = currentDocument else { return }
        
        do {
            try await documentService.deleteDocument(id: document.id)
            await MainActor.run {
                clearDocument()
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to delete document: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Document Analysis
    func analyzeCurrentDocument() async {
        guard let document = currentDocument else { return }
        
        isLoading = true
        
        do {
            let analysis = try await aiService.analyzeDocument(document)
            
            let analysisMessage = ChatMessage(
                content: """
                📊 **Document Analysis**
                
                \(analysis)
                
                **Key Topics:**
                \(analysis.keyTopics.prefix(8).map { "• \($0)" }.joined(separator: "\n"))
                
                **Document Statistics:**
                • Words: \(analysis.wordCount)
                • Reading Time: \(analysis.estimatedReadingTime) minutes
                
                Ask me specific questions about any of these topics!
                """,
                sender: .assistant
            )
            
            messages.append(analysisMessage)
            
        } catch {
            errorMessage = "Failed to analyze document: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Chat Management
    func clearChat() {
        messages.removeAll()
        let welcomeMessage = ChatMessage(
            content: """
            👋 **Welcome to Document ChatBot!**
            
            I'm your AI assistant that can help you with:
            
            **📄 Document Analysis**
            • Upload PDF documents and ask questions about them
            • Get summaries and key insights
            • Find specific information within documents
            
            **💬 General Questions**
            • Ask about programming, technology, or any topic
            • Get explanations of complex concepts
            • Receive helpful guidance and recommendations
            
            **🚀 Getting Started**
            • Tap the document icon to upload a PDF
            • Ask questions about the uploaded document
            • Or ask me anything else!
            
            How can I help you today?
            """,
            sender: .assistant
        )
        messages.append(welcomeMessage)
    }
    
    // MARK: - Utility Functions
    func getDocumentStats() -> String? {
        guard let analysis = documentAnalysis else { return nil }
        
        return """
        📊 Document Statistics:
        • Words: \(analysis.wordCount)
        • Sentences: \(analysis.sentenceCount)
        • Paragraphs: \(analysis.paragraphCount)
        • Reading Time: \(analysis.estimatedReadingTime) minutes
        • Complexity: \(analysis.complexity.rawValue)
        """
    }
    
    func getKeyTopics() -> [String] {
        return documentAnalysis?.keyTopics ?? []
    }
} 
