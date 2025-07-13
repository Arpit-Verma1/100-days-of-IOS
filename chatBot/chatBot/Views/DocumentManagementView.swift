import SwiftUI
import UniformTypeIdentifiers
import Combine
import Foundation

struct DocumentManagementView: View {
    @StateObject private var viewModel = DocumentManagementViewModel()
    @State private var showingDocumentPicker = false
    @State private var showingDocumentDetail = false
    @State private var selectedDocument: Document?
    @State private var searchText = ""
    
    var body: some View {
            VStack(spacing: 0) {
                // Search bar
                searchBarView
                
                // Documents list
                if viewModel.documents.isEmpty {
                    emptyStateView
                } else {
                    documentsListView
                }
            }
            .navigationTitle("Documents")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingDocumentPicker = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingDocumentPicker,
                allowedContentTypes: [UTType.pdf, UTType.plainText],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .sheet(isPresented: $showingDocumentDetail) {
                if let document = selectedDocument {
                    DocumentDetailView(document: document)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadDocuments()
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search documents...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Documents")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Upload your first document to get started with AI-powered analysis and Q&A.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingDocumentPicker = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Upload Document")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Documents List
    private var documentsListView: some View {
        List {
            ForEach(filteredDocuments) { document in
                DocumentRowView(document: document) {
                    selectedDocument = document
                    showingDocumentDetail = true
                } onDelete: {
                    Task {
                        await viewModel.deleteDocument(id: document.id)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: - Filtered Documents
    private var filteredDocuments: [Document] {
        if searchText.isEmpty {
            return viewModel.documents
        } else {
            return viewModel.documents.filter { document in
                document.title.localizedCaseInsensitiveContains(searchText) ||
                document.content.localizedCaseInsensitiveContains(searchText) ||
                document.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    // MARK: - File Import Handler
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                Task {
                    await viewModel.uploadDocument(from: url)
                }
            }
        case .failure(let error):
            viewModel.errorMessage = "Error selecting file: \(error.localizedDescription)"
        }
    }
}

// MARK: - Document Row View
struct DocumentRowView: View {
    let document: Document
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Document icon
            Image(systemName: document.type.icon)
                .font(.title2)
                .foregroundColor(Color(hex: document.type.color))
                .frame(width: 40, height: 40)
                .background(Color(hex: document.type.color).opacity(0.1))
                .cornerRadius(8)
            
            // Document info
            VStack(alignment: .leading, spacing: 4) {
                Text(document.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label("\(document.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count) words", systemImage: "text.word.spacing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
//                    Label(document.dateAdded, labelstyle: .date)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
                }
                
                if !document.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(document.tags.prefix(3), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            // Actions
            Menu {
                Button("View Details") {
                    onTap()
                }
                
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Document Detail View
struct DocumentDetailView: View {
    let document: Document
    @State private var analysis: DocumentAnalysis?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Document header
                    documentHeaderView
                    
                    // Document analysis
                    if let analysis = analysis {
                        documentAnalysisView(analysis)
                    }
                    
                    // Document content preview
                    documentContentView
                }
                .padding()
            }
            .navigationTitle("Document Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            analysis = DocumentService.shared.analyzeDocument(document)
        }
    }
    
    private var documentHeaderView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: document.type.icon)
                    .font(.title)
                    .foregroundColor(Color(hex: document.type.color))
                
                VStack(alignment: .leading) {
                    Text(document.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(document.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
        }
    }
    
    private func documentAnalysisView(_ analysis: DocumentAnalysis) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Document Analysis")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(title: "Words", value: "\(analysis.wordCount)", icon: "text.word.spacing")
                StatCard(title: "Sentences", value: "\(analysis.sentenceCount)", icon: "text.quote")
                StatCard(title: "Paragraphs", value: "\(analysis.paragraphCount)", icon: "text.alignleft")
                StatCard(title: "Reading Time", value: "\(analysis.estimatedReadingTime) min", icon: "clock")
            }
            
            if !analysis.keyTopics.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Topics")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100))
                    ], spacing: 8) {
                        ForEach(analysis.keyTopics.prefix(8), id: \.self) { topic in
                            Text(topic)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var documentContentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content Preview")
                .font(.headline)
            
            Text(document.content.prefix(500) + (document.content.count > 500 ? "..." : ""))
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(10)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Document Management ViewModel
@MainActor
class DocumentManagementViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let documentService = DocumentService.shared
    
    func loadDocuments() async {
        do {
            documents = try await documentService.loadDocuments()
        } catch {
            errorMessage = "Failed to load documents: \(error.localizedDescription)"
        }
    }
    
    func uploadDocument(from url: URL) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try documentService.validateFileSize(url: url)
            let documentType = try documentService.validateDocument(url: url)
            
            let content: String
            if documentType == .pdf {
                content = try await documentService.parsePDF(from: url)
            } else {
                content = try String(contentsOf: url)
            }
            
            let document = Document(
                title: url.deletingPathExtension().lastPathComponent,
                content: content,
                type: documentType,
                source: "File Upload"
            )
            
            try await documentService.saveDocument(document)
            await loadDocuments()
            
        } catch {
            errorMessage = "Failed to upload document: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteDocument(id: String) async {
        do {
            try await documentService.deleteDocument(id: id)
            await loadDocuments()
        } catch {
            errorMessage = "Failed to delete document: \(error.localizedDescription)"
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    DocumentManagementView()
} 
