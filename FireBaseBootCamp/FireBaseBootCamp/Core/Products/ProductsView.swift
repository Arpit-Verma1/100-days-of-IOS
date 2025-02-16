//
//  ProductsView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 16/02/25.
//

import SwiftUI


@MainActor
final class  ProductDetailViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
        
    }
    
    
    func downloadProductsAndUploadFirebase () {
        guard let url  = URL(string: "https://dummyjson.com/products") else {
            return
        }
        Task {
            do {
                let (data, _ ) = try await URLSession.shared.data(from: url)
                let products = try JSONDecoder().decode(ProductArray.self, from: data)
                let productsArray = products.products
                
                for product in productsArray {
                    try? await   ProductsManager.shared.uploadProduct(product: product)
                }
                print("success")
                print("len is \(products.products.count)")
            }
            catch {
                print(error)
            }
        }
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductDetailViewModel()
    
    var body: some View {
        List{
            
            //            Text("hee")
            ForEach(viewModel.products) { prouct   in
                ProductCellView(prouct: prouct)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
//        .onAppear() {
//            viewModel.downloadProductsAndUploadFirebase()
//        }
    }
}

#Preview {
    ProductsView()
}
