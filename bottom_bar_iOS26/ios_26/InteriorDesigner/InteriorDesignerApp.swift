import SwiftUI

struct InteriorDesignerApp: View {
    @StateObject private var viewModel = InteriorDesignViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.showingResult {
                DesignResultView(viewModel: viewModel)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                InputFormView(viewModel: viewModel)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.showingResult)
    }
}

#Preview {
    InteriorDesignerApp()
}