//
//  envirenmentObjectSwiftBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 01/11/24.
//

import SwiftUI

class appleViewModel: ObservableObject {
    @Published var products: [String] = [
        "iPhone",
        "MacBook"
    ]
}

struct envirenmentObjectSwiftBootCamp: View {
    @StateObject var viewModel: appleViewModel = appleViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.products, id: \.self) { item in
                    NavigationLink(destination: secondScreenView().environmentObject(viewModel)) {
                        Text(item)
                    }
                }
            }
            .environmentObject(viewModel)
        }
    }
}

struct secondScreenView: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            NavigationLink(destination: thirdScreenView()) {
                Text("Go to third screen")
            }
        }
    }
}

struct thirdScreenView: View {
    @EnvironmentObject var viewModel: appleViewModel
    var body: some View {
        List {
            ForEach(viewModel.products, id: \.self) { item in
                Text(item)
            }
        }
    }
}

#Preview {
    envirenmentObjectSwiftBootCamp()
        .environmentObject(appleViewModel())
}
