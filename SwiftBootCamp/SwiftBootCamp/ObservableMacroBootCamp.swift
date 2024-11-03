//
//  ObservableMacroBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

@Observable class ObservableViewModel {
     var title : String = "some title"
}

struct ObservableMacroBootCamp: View {
    @State private var viewModel = ObservableViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.title = "new title"
            } label: {
            Text("b1")
            }
           someChildView(viewModel: viewModel)
            someotherChildView()
        }
        .environment(viewModel)
    }
}

struct someChildView : View {
    @Bindable var viewModel: ObservableViewModel
    var body: some View {
        Text(viewModel.title)
    }
}
struct someotherChildView :View
{
    @Environment(ObservableViewModel.self) var viewModel
    var body: some View {
        Text(viewModel.title)
    }
}

#Preview {
    ObservableMacroBootCamp()
}
