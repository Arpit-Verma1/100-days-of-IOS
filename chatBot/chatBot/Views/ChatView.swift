import SwiftUI
import UniformTypeIdentifiers

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showingDocumentPicker = false
    @State private var showingDocumentMenu = false
    // @Published var documentAnalysis: DocumentAnalysis?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with document info and controls
            headerView
            
            // Document processing indicator
            if viewModel.isProcessingDocument {
                processingIndicatorView
            }
            
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            loadingIndicatorView
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            inputAreaView
        }
        .onAppear {
            if viewModel.messages.isEmpty {
                viewModel.clearChat()
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [UTType.pdf, UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
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
        .confirmationDialog("Document Options", isPresented: $showingDocumentMenu) {
            Button("Analyze Document") {
                Task {
                    await viewModel.analyzeCurrentDocument()
                }
            }
            .disabled(viewModel.currentDocument == nil)
            
            Button("Delete Document", role: .destructive) {
                Task {
                    await viewModel.deleteCurrentDocument()
                }
            }
            .disabled(viewModel.currentDocument == nil)
            
            Button("Clear Chat") {
                viewModel.clearChat()
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Document ChatBot")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if viewModel.currentDocument != nil {
                    Button(action: {
                        showingDocumentMenu = true
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            
            if let document = viewModel.currentDocument {
                documentInfoView(document)
            }
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
    }
    
    private func documentInfoView(_ document: Document) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: document.type.icon)
                    .foregroundColor(.blue)
                
                Text(document.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Button("Clear") {
                    viewModel.clearDocument()
                }
                .foregroundColor(.red)
                .font(.caption)
            }
            
            if let analysis = viewModel.documentAnalysis {
                HStack(spacing: 16) {
                    Label("\(analysis.wordCount) words", systemImage: "text.word.spacing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(analysis.estimatedReadingTime) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(analysis.complexity.rawValue, systemImage: "brain")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Processing Indicator
    private var processingIndicatorView: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Processing document...")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    // MARK: - Loading Indicator
    private var loadingIndicatorView: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Thinking...")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Input Area
    private var inputAreaView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Document upload button
                Button(action: {
                    showingDocumentPicker = true
                }) {
                    Image(systemName: "doc.badge.plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.isProcessingDocument)
                
                // Text input field
                TextField("Ask a question...", text: $viewModel.userInput, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1...4)
                    .disabled(viewModel.isLoading || viewModel.isProcessingDocument)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                // Send button
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .disabled(
                    viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    viewModel.isLoading ||
                    viewModel.isProcessingDocument
                )
                .foregroundColor(
                    viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue
                )
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - File Import Handler
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                viewModel.uploadPDF(from: url)
            }
        case .failure(let error):
            print("Error selecting file: \(error.localizedDescription)")
            viewModel.errorMessage = "Error selecting file: \(error.localizedDescription)"
        }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.sender == .user {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 4) {
                // Message content
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(backgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(18)
                    .textSelection(.enabled)
                
                // Timestamp
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if message.sender != .user {
                Spacer(minLength: 50)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch message.sender {
        case .user:
            return .blue
        case .assistant:
            return Color(.systemGray5)
        case .system:
            return Color(.systemOrange).opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch message.sender {
        case .user:
            return .white
        case .assistant, .system:
            return .primary
        }
    }
}

#Preview {
    ChatView()
} 
