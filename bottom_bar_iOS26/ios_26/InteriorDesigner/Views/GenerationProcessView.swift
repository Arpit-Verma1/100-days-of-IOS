import SwiftUI

struct GenerationProcessView: View {
    @ObservedObject var viewModel: InteriorDesignViewModel
    @State private var showingTerminal = true // Default to true for developers
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                ProcessHeaderView(viewModel: viewModel)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Developer Mode Indicator
                        DeveloperModeIndicator()
                        
                        // Thinking Steps
                        ThinkingStepsView(thinkingProcess: viewModel.thinkingProcess)
                        
                        // Terminal Logs (Collapsible)
                        TerminalLogsView(logs: viewModel.terminalLogs, isVisible: showingTerminal)
                        
                                        // Toggle Terminal Button
                if !viewModel.thinkingProcess.isComplete {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingTerminal.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: showingTerminal ? "terminal.fill" : "terminal")
                            Text(showingTerminal ? "Hide Terminal" : "Show Terminal")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(showingTerminal ? 90 : 0))
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)
                } else {
                    // Show completion message
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Design generation complete!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Preparing results...")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Generating Design")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        viewModel.showingGenerationProcess = false
                        viewModel.isGenerating = false
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
}

// MARK: - Developer Mode Indicator
struct DeveloperModeIndicator: View {
    var body: some View {
        HStack {
            Image(systemName: "laptopcomputer")
                .foregroundStyle(.orange)
            Text("Developer Mode Active")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.orange)
            Spacer()
            Text("Terminal logs visible")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Process Header
struct ProcessHeaderView: View {
    @ObservedObject var viewModel: InteriorDesignViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress Indicator
            ProgressView(value: progressValue)
                .progressViewStyle(.linear)
                .tint(.blue)
                .padding(.horizontal, 20)
            
            // Current Step
            if let currentStep = viewModel.thinkingProcess.currentStep {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: currentStep.type.icon)
                            .foregroundStyle(currentStep.type.color)
                        Text(currentStep.step)
                            .font(.headline)
                        Spacer()
                    }
                    
                    Text(currentStep.message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 20)
            }
            
            // Generation Status
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.orange)
                Text("AI is thinking and creating your design...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(.secondary.opacity(0.1))
    }
    
    private var progressValue: Double {
        let totalSteps = 7.0 // Total number of steps
        let completedSteps = Double(viewModel.thinkingProcess.steps.filter { $0.isCompleted }.count)
        return completedSteps / totalSteps
    }
}

// MARK: - Thinking Steps
struct ThinkingStepsView: View {
    let thinkingProcess: ThinkingProcess
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.purple)
                Text("AI Thinking Process")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 12) {
                ForEach(thinkingProcess.steps) { step in
                    ThinkingStepRow(step: step)
                        .id(step.id)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ThinkingStepRow: View {
    let step: GenerationStep
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    // Status Icon
                    ZStack {
                        Circle()
                            .fill(step.isCompleted ? step.type.color : .gray.opacity(0.3))
                            .frame(width: 32, height: 32)
                        
                        if step.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        } else {
                            Image(systemName: step.type.icon)
                                .font(.caption)
                                .foregroundStyle(step.isCompleted ? .white : .gray)
                        }
                    }
                    
                    // Step Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.step)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(step.isCompleted ? .primary : .secondary)
                        
                        Text(step.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    Spacer()
                    
                    // Expand/Collapse
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            
            // Expanded Details
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text(step.message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 40)
                    
                    HStack {
//                        Text(step.type.rawValue.capitalized)
//                            .font(.caption2)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background(step.type.color.opacity(0.2))
//                            .foregroundStyle(step.type.color)
//                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                    .padding(.leading, 40)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.secondary.opacity(0.1))
        )
    }
}

// MARK: - Terminal Logs
struct TerminalLogsView: View {
    let logs: [TerminalLog]
    let isVisible: Bool
    
    var body: some View {
        if isVisible {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "terminal")
                        .foregroundStyle(.green)
                    Text("Terminal Logs")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                ScrollViewReader { proxy in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(logs) { log in
                            TerminalLogRow(log: log)
                                .id(log.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black.opacity(0.8))
                    )
                    .padding(.horizontal, 20)
                    .onChange(of: logs.count) { _ in
                        if let lastLog = logs.last {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(lastLog.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
}

struct TerminalLogRow: View {
    let log: TerminalLog
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(log.level.prefix)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(log.message)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .fontDesign(.monospaced)
                
                Text(log.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    GenerationProcessView(viewModel: InteriorDesignViewModel())
} 
