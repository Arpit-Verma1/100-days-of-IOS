import Foundation
import FoundationModels

class AIService {
    static let shared = AIService()
    private init() {}
    
    // MARK: - Main AI Answer Function
    func answer(question: String, document: Document?) async throws -> String {
        // Create context-aware prompt
        let prompt = createContextAwarePrompt(question: question, document: document)
        
        // Debug logging
        if let document = document {
            print("📄 Using document: \(document.title)")
            print("📄 Document content length: \(document.content.count) characters")
            print("📄 Document text preview: \(String(document.content.prefix(100)))...")
            print("📄 Question: \(question)")
            print("📄 Using extracted document text as prompt context")
        } else {
            print("❓ General question (no document): \(question)")
        }
        
        do {
            // Generate response using Foundation Models
            let response = try await generateResponse(prompt: prompt)
            
            // Check if the response indicates rejection
            if response.lowercased().contains("sorry") && response.lowercased().contains("cannot") {
                print("⚠️ AI model rejected request, using fallback response")
                return generateFallbackResponse(question: question, document: document)
            }
            
            print("✅ AI response generated successfully")
            return response
        } catch {
            print("❌ AI generation failed: \(error)")
            // Fallback to intelligent response if Foundation Models fail
            return generateFallbackResponse(question: question, document: document)
        }
    }
    
    // MARK: - Foundation Models Response Generation (Streaming)
    private func generateResponse(prompt: String) async throws -> String {
        let session = LanguageModelSession { prompt }
        var result = ""
        for try await partial in session.streamResponse(to: "", generating: String.self) {
            result = partial // Only keep the latest chunk to avoid repeated text
        }
        return result
    }
    
    // MARK: - Context-Aware Prompt Creation
    private func createContextAwarePrompt(question: String, document: Document?) -> String {
        if let document = document, !document.content.isEmpty {
            // Always use the full document content as the primary context
            let documentContent = document.content.count > 8000 ? 
                String(document.content.prefix(8000)) + "..." : 
                document.content
            
            return """
            Document: \(document.title)
            
            Content: \(documentContent)
            
            Question: \(question)
            
            Please answer the question based on the document content above. If the question asks about what the document contains, provide the document content or a summary of it.
            """
        } else {
            return """
            Question: \(question)
            
            Please provide a helpful and informative answer to this question.
            """
        }
    }
    
    // MARK: - Document Analysis
    func analyzeDocument(_ document: Document) async throws -> DocumentAnalysis {
        let analysisPrompt = """
        Analyze the following document and provide a comprehensive summary:
        
        DOCUMENT:
        \(document.content.prefix(2000))
        
        Please provide:
        1. Main topics and themes
        2. Key points and insights
        3. Document structure
        4. Summary (2-3 sentences)
        5. Suggested questions users might ask about this document
        
        ANALYSIS:
        """
        
        let session = LanguageModelSession { analysisPrompt }
        var result = ""
        for try await partial in session.streamResponse(to: "", generating: String.self) {
            result += partial
        }
        // Compute stats for DocumentAnalysis
        let words = document.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let sentences = document.content.components(separatedBy: [".", "!", "?"]).filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let paragraphs = document.content.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let keyTopics = extractKeyTopics(from: document.content)
        let readingTime = calculateReadingTime(content: document.content)
        let complexity = calculateComplexity(content: document.content)
        return DocumentAnalysis(

           
            wordCount: words.count,
            sentenceCount: sentences.count,
            paragraphCount: paragraphs.count,
            characterCount: document.content.count,
            estimatedReadingTime: readingTime,
            keyTopics: keyTopics,
            complexity: complexity
        )
    }
    
    // MARK: - Relevant Section Finding
    private func findRelevantSections(query: String, in content: String) -> [String] {
        let sentences = content.components(separatedBy: [".", "!", "?"])
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        let queryWords = query.lowercased().components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 2 }
        
        var relevantSentences: [(sentence: String, score: Int)] = []
        
        for sentence in sentences {
            let sentenceLower = sentence.lowercased()
            var score = 0
            
            for word in queryWords {
                if sentenceLower.contains(word) {
                    score += 1
                }
            }
            
            if score > 0 {
                relevantSentences.append((sentence: sentence.trimmingCharacters(in: .whitespacesAndNewlines), score: score))
            }
        }
        
        // Sort by relevance score and return more sections (up to 10 instead of 5)
        return relevantSentences
            .sorted { $0.score > $1.score }
            .prefix(10)
            .map { $0.sentence }
    }
    
    // MARK: - Fallback Response Generation
    private func generateFallbackResponse(question: String, document: Document?) -> String {
        let lowerQuestion = question.lowercased()
        
        if let document = document, !document.content.isEmpty {
            return generateDocumentBasedFallback(question: question, document: document)
        } else {
            return generateGeneralFallback(question: question)
        }
    }
    
    private func generateDocumentBasedFallback(question: String, document: Document) -> String {
        let lowerQuestion = question.lowercased()
        
        // If user is asking about document content, return it directly
        if lowerQuestion.contains("document") && (lowerQuestion.contains("contain") || lowerQuestion.contains("text") || lowerQuestion.contains("content")) {
            return """
            📄 **Document Content**
            
            The document "\(document.title)" contains the following text:
            
            \(document.content)
            
            This is the extracted content from your uploaded document.
            """
        }
        
        let relevantSections = findRelevantSections(query: question, in: document.content)
        let keyTopics = extractKeyTopics(from: document.content)
        
        return """
        📄 **Document-Based Answer**
        
        Based on the uploaded document "\(document.title)", here's what I found:
        
        **Relevant Information:**
        \(relevantSections.prefix(3).map { "• \($0)" }.joined(separator: "\n"))
        
        **Key Topics in Document:**
        \(keyTopics.prefix(5).map { "• \($0)" }.joined(separator: "\n"))
        
        **Analysis:**
        The document contains information related to your question. The content covers \(keyTopics.count) main topics and provides detailed information about the subject matter.
        
        **Recommendations:**
        • Ask specific questions about particular topics mentioned in the document
        • Request detailed explanations of concepts found in the document
        • Ask for summaries of specific sections
        
        The document appears to be a comprehensive resource for understanding this topic.
        """
    }
    
    private func generateGeneralFallback(question: String) -> String {
        let lowerQuestion = question.lowercased()
        
        if lowerQuestion.contains("swift") || lowerQuestion.contains("ios") {
            return """
            🚀 **Swift & iOS Development**
            
            Swift is Apple's modern programming language for iOS, macOS, watchOS, and tvOS development.
            
            **Key Features:**
            • Modern and safe programming language
            • Automatic memory management with ARC
            • Strong type system with type inference
            • Protocol-oriented programming
            • Built-in error handling
            
            **iOS Development:**
            • Latest version: iOS 18
            • Development tools: Xcode, SwiftUI, UIKit
            • App Store with over 2 million apps
            • Strong privacy and security features
            
            **Getting Started:**
            • Install Xcode from Mac App Store
            • Learn Swift fundamentals
            • Start with simple projects
            • Join Apple Developer Program
            
            Would you like me to elaborate on any specific aspect of Swift or iOS development?
            """
        } else if lowerQuestion.contains("programming") || lowerQuestion.contains("coding") {
            return """
            💻 **Programming Fundamentals**
            
            Programming is the process of creating instructions for computers to follow.
            
            **Core Concepts:**
            • Variables: Store and manipulate data
            • Functions: Reusable blocks of code
            • Loops: Repeat actions efficiently
            • Conditionals: Make decisions in code
            • Data Structures: Organize and manage data
            
            **Popular Languages:**
            • Python: Great for beginners, data science, AI
            • JavaScript: Web development
            • Swift: iOS and macOS development
            • Java: Android development
            • C++: System programming
            
            **Learning Path:**
            1. Start with basics
            2. Choose a language
            3. Build projects
            4. Learn frameworks
            5. Join communities
            
            Programming opens doors to countless career opportunities in technology!
            """
        } else {
            return """
            🤖 **AI Assistant Ready to Help**
            
            I'm here to assist you with:
            
            **My Capabilities:**
            • Document analysis and Q&A
            • Programming and technology help
            • General knowledge questions
            • Technical explanations
            
            **How to Use Me:**
            • Upload PDF documents and ask questions about them
            • Ask about programming languages and frameworks
            • Get help with technical concepts
            • Request explanations of complex topics
            
            **Popular Topics:**
            • Swift and iOS development
            • Programming fundamentals
            • Document analysis
            • Technology trends
            
            Feel free to ask me anything or upload a document to get started!
            """
        }
    }
    
    // MARK: - Utility Functions
    private func extractKeyTopics(from text: String) -> [String] {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
        
        var wordCount: [String: Int] = [:]
        for word in words {
            if word.count > 3 {
                wordCount[word, default: 0] += 1
            }
        }
        
        let sortedWords = wordCount.sorted { $0.value > $1.value }
        return Array(sortedWords.prefix(8).map { $0.key.capitalized })
    }
    
    private func calculateReadingTime(content: String) -> Int {
        let words = content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let wordsPerMinute = 225
        return max(1, words.count / wordsPerMinute)
    }
    
    private func calculateComplexity(content: String) -> DocumentComplexity {
        let sentences = content.components(separatedBy: [".", "!", "?"])
        let words = content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        let avgWordsPerSentence = words.count / max(sentences.count, 1)
        let longWords = words.filter { $0.count > 6 }.count
        let longWordPercentage = Double(longWords) / Double(max(words.count, 1)) * 100
        
        switch (avgWordsPerSentence, longWordPercentage) {
        case (0..<15, 0..<20):
            return .easy
        case (15..<25, 20..<30):
            return .medium
        default:
            return .difficult
        }
    }
}

// MARK: - AI Error Types
enum AIError: LocalizedError {
    case generationFailed(Error)
    case invalidInput
    
    var errorDescription: String? {
        switch self {
        case .generationFailed(let error):
            return "Failed to generate response: \(error.localizedDescription)"
        case .invalidInput:
            return "Invalid input provided"
        }
    }
}
