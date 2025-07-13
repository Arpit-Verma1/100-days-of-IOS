import Foundation
import PDFKit
import UniformTypeIdentifiers

class DocumentService {
    static let shared = DocumentService()
    private init() {}
    
    // MARK: - PDF Processing
    func parsePDF(from url: URL) async throws -> String {
        guard let pdf = PDFDocument(url: url) else {
            throw DocumentError.invalidPDF
        }
        
        var extractedText = ""
        let pageCount = pdf.pageCount
        
        print("📄 Processing PDF with \(pageCount) pages...")
        
        for i in 0..<pageCount {
            if let page = pdf.page(at: i) {
                if let pageText = page.string {
                    let cleanedText = cleanText(pageText)
                    extractedText += cleanedText + "\n\n"
                } else {
                    print("⚠️ Warning: Could not extract text from page \(i + 1)")
                }
            }
        }
        
        let finalText = extractedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !finalText.isEmpty else {
            throw DocumentError.noTextFound
        }
        
        print("✅ Extracted \(finalText.count) characters from PDF")
        return finalText
    }
    
    // MARK: - Text Processing
    func extractText(from text: String) -> String {
        return cleanText(text)
    }
    
    // MARK: - Document Analysis
    func analyzeDocument(_ document: Document) -> DocumentAnalysis {
        let words = document.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let sentences = document.content.components(separatedBy: [".", "!", "?"]).filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let paragraphs = document.content.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        let keyTopics = extractKeyTopics(from: document.content)
        let readingTime = calculateReadingTime(wordCount: words.count)
        
        return DocumentAnalysis(
            wordCount: words.count,
            sentenceCount: sentences.count,
            paragraphCount: paragraphs.count,
            characterCount: document.content.count,
            estimatedReadingTime: readingTime,
            keyTopics: keyTopics,
            complexity: calculateComplexity(content: document.content)
        )
    }
    
    // MARK: - Document Validation
    func validateDocument(url: URL) throws -> DocumentType {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "pdf":
            return .pdf
        case "txt", "rtf", "md":
            return .text
        default:
            throw DocumentError.unsupportedFileType
        }
    }
    
    func validateFileSize(url: URL) throws {
        let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
        let maxSize = AppConstants.Document.maxFileSize
        
        guard fileSize <= maxSize else {
            throw DocumentError.fileTooLarge
        }
    }
    
    // MARK: - Document Storage
    func saveDocument(_ document: Document) async throws {
        let documents = try await loadDocuments()
        var updatedDocuments = documents
        
        if let existingIndex = updatedDocuments.firstIndex(where: { $0.id == document.id }) {
            updatedDocuments[existingIndex] = document
        } else {
            updatedDocuments.append(document)
        }
        
        try await saveDocuments(updatedDocuments)
    }
    
    func loadDocuments() async throws -> [Document] {
        let documentsURL = try getDocumentsDirectory().appendingPathComponent(AppConstants.Storage.documentsFile)
        
        guard FileManager.default.fileExists(atPath: documentsURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: documentsURL)
        return try JSONDecoder().decode([Document].self, from: data)
    }
    
    func deleteDocument(id: String) async throws {
        var documents = try await loadDocuments()
        documents.removeAll { $0.id == id }
        try await saveDocuments(documents)
    }
    
    // MARK: - Private Helper Methods
    private func cleanText(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\n\\s*\n", with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func extractKeyTopics(from text: String) -> [String] {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .filter { $0.count > 3 && !stopWords.contains($0) }
        
        var wordCount: [String: Int] = [:]
        for word in words {
            wordCount[word, default: 0] += 1
        }
        
        let sortedWords = wordCount.sorted { $0.value > $1.value }
        return Array(sortedWords.prefix(10).map { $0.key.capitalized })
    }
    
    private func calculateReadingTime(wordCount: Int) -> Int {
        let wordsPerMinute = 225
        return max(1, wordCount / wordsPerMinute)
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
    
    private func saveDocuments(_ documents: [Document]) async throws {
        let documentsURL = try getDocumentsDirectory().appendingPathComponent(AppConstants.Storage.documentsFile)
        let data = try JSONEncoder().encode(documents)
        try data.write(to: documentsURL)
    }
    
    private func getDocumentsDirectory() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
    
    // MARK: - Stop Words for Topic Extraction
    private let stopWords: Set<String> = [
        "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "by",
        "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "do", "does", "did",
        "will", "would", "could", "should", "may", "might", "must", "can", "this", "that", "these", "those",
        "i", "you", "he", "she", "it", "we", "they", "me", "him", "her", "us", "them",
        "my", "your", "his", "her", "its", "our", "their", "mine", "yours", "hers", "ours", "theirs"
    ]
}

// MARK: - Document Analysis Model
struct DocumentAnalysis {
    let wordCount: Int
    let sentenceCount: Int
    let paragraphCount: Int
    let characterCount: Int
    let estimatedReadingTime: Int
    let keyTopics: [String]
    let complexity: DocumentComplexity
}

enum DocumentComplexity: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case difficult = "Difficult"
    
    var color: String {
        switch self {
        case .easy: return "#34C759"
        case .medium: return "#FF9500"
        case .difficult: return "#FF3B30"
        }
    }
}

// MARK: - Document Error Types
enum DocumentError: LocalizedError {
    case invalidPDF
    case noTextFound
    case parsingFailed(Error)
    case unsupportedFileType
    case fileTooLarge
    case saveFailed
    case loadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidPDF:
            return "Invalid or corrupted PDF file"
        case .noTextFound:
            return "No text could be extracted from the document"
        case .parsingFailed(let error):
            return "Failed to parse document: \(error.localizedDescription)"
        case .unsupportedFileType:
            return "Unsupported file type. Please use PDF or text files"
        case .fileTooLarge:
            return "File is too large. Maximum size is 10MB"
        case .saveFailed:
            return "Failed to save document"
        case .loadFailed:
            return "Failed to load documents"
        }
    }
} 
