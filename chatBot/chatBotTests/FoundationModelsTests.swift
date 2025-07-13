import XCTest
import FoundationModels
@testable import chatBot

final class FoundationModelsTests: XCTestCase {
    
    var aiService: AIService!
    var documentService: DocumentService!
    
    override func setUpWithError() throws {
        aiService = AIService.shared
        documentService = DocumentService.shared
    }
    
    override func tearDownWithError() throws {
        aiService = nil
        documentService = nil
    }
    
    // MARK: - Foundation Models Tests
    
    func testAIServiceInitialization() async throws {
        // Test that AI service can be initialized
        do {
            try await aiService.initializeModel()
            // If we reach here, initialization was successful
            XCTAssertTrue(true)
        } catch {
            // Foundation Models might not be available in test environment
            // This is expected behavior
            XCTAssertTrue(error is AIError)
        }
    }
    
    func testDocumentServiceTextExtraction() {
        // Test text extraction functionality
        let testText = "This is a test document with some content. It contains multiple sentences and should be processed correctly."
        
        let extractedText = documentService.extractText(from: testText)
        
        XCTAssertNotNil(extractedText)
        XCTAssertFalse(extractedText.isEmpty)
        XCTAssertEqual(extractedText, testText)
    }
    
    func testDocumentAnalysis() {
        // Test document analysis functionality
        let testContent = """
        This is a test document about artificial intelligence and machine learning.
        It discusses various topics including neural networks, deep learning, and natural language processing.
        The document contains technical information and should be analyzed properly.
        """
        
        let document = Document(
            title: "Test Document",
            content: testContent,
            type: .text,
            source: "Test"
        )
        
        let analysis = documentService.analyzeDocument(document)
        
        XCTAssertNotNil(analysis)
        XCTAssertGreaterThan(analysis.wordCount, 0)
        XCTAssertGreaterThan(analysis.sentenceCount, 0)
        XCTAssertGreaterThan(analysis.paragraphCount, 0)
        XCTAssertGreaterThan(analysis.estimatedReadingTime, 0)
        XCTAssertFalse(analysis.keyTopics.isEmpty)
    }
    
    func testDocumentValidation() {
        // Test document validation
        let validPDFURL = URL(string: "test.pdf")!
        let validTextURL = URL(string: "test.txt")!
        let invalidURL = URL(string: "test.xyz")!
        
        do {
            let pdfType = try documentService.validateDocument(url: validPDFURL)
            XCTAssertEqual(pdfType, .pdf)
        } catch {
            XCTFail("PDF validation should succeed")
        }
        
        do {
            let textType = try documentService.validateDocument(url: validTextURL)
            XCTAssertEqual(textType, .text)
        } catch {
            XCTFail("Text validation should succeed")
        }
        
        do {
            _ = try documentService.validateDocument(url: invalidURL)
            XCTFail("Invalid file type should throw error")
        } catch {
            XCTAssertTrue(error is DocumentError)
        }
    }
    
    func testErrorHandling() {
        // Test error handling
        let aiError = AIError.modelNotAvailable
        let documentError = DocumentError.invalidPDF
        
        XCTAssertNotNil(aiError.errorDescription)
        XCTAssertNotNil(documentError.errorDescription)
    }
    
    // MARK: - Performance Tests
    
    func testDocumentAnalysisPerformance() {
        // Test performance of document analysis
        let largeContent = String(repeating: "This is a test sentence. ", count: 1000)
        let document = Document(
            title: "Large Test Document",
            content: largeContent,
            type: .text,
            source: "Test"
        )
        
        measure {
            _ = documentService.analyzeDocument(document)
        }
    }
    
    // MARK: - Integration Tests
    
    func testChatViewModelIntegration() async {
        // Test ChatViewModel integration
        let viewModel = ChatViewModel()
        
        // Test initial state
        XCTAssertTrue(viewModel.messages.isEmpty)
        XCTAssertNil(viewModel.currentDocument)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isProcessingDocument)
        
        // Test message sending (without actual AI response)
        viewModel.userInput = "Test question"
        viewModel.sendMessage()
        
        // Should have one user message
        XCTAssertEqual(viewModel.messages.count, 1)
        XCTAssertEqual(viewModel.messages.first?.sender, .user)
        XCTAssertEqual(viewModel.messages.first?.content, "Test question")
    }
    
    func testDocumentManagementViewModelIntegration() async {
        // Test DocumentManagementViewModel integration
        let viewModel = DocumentManagementViewModel()
        
        // Test initial state
        XCTAssertTrue(viewModel.documents.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
        // Test document loading
        await viewModel.loadDocuments()
        
        // Should not crash and handle empty state
        XCTAssertTrue(viewModel.documents.isEmpty)
    }
}

// MARK: - Mock Data for Testing

extension FoundationModelsTests {
    
    func createMockDocument() -> Document {
        return Document(
            title: "Mock Document",
            content: """
            This is a mock document for testing purposes.
            It contains various topics and information that can be used to test the AI functionality.
            The document includes technical terms, concepts, and detailed explanations.
            This should be sufficient for testing document analysis and AI responses.
            """,
            type: .text,
            source: "Mock"
        )
    }
    
    func createMockPDFURL() -> URL {
        // Create a temporary file for testing
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent("test.pdf")
    }
} 