//
//  ContentView.swift
//  FormSwift
//
//  Created by arpit verma on 14/07/24.
//

import SwiftUI
class FormViewModel: ObservableObject {
    @State var FirstName=""
    @State var SecondName=""
    @State var passworrd=""
    @State var passwordAgain=""
}

struct ContentView: View {
    @StateObject var viewModel = FormViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section{
                        TextField("First Name", text: $viewModel.FirstName)
                        TextField("First Name", text: $viewModel.FirstName)
                        }
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
