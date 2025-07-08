import SwiftUI

struct InteriorDesignerApp: View {
    @StateObject private var viewModel = InteriorDesignViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.showingGenerationProcess {
                GenerationProcessView(viewModel: viewModel)
                    .transition(.opacity)
            } else if viewModel.showingResult {
                DesignResultView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                InputFormView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showingResult)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showingGenerationProcess)
    }
}

#Preview {
    InteriorDesignerApp()
}