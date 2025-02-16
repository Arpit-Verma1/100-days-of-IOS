//
//  ProductCellView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 16/02/25.
//

import SwiftUI

struct ProductCellView: View {
    let prouct : Product
    var body: some View {
        
        HStack(alignment: .top){
            AsyncImage(url: URL(string: prouct.thumbnail ?? "")){ image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            }
            ProgressView()
        }
        .frame(width: 75, height: 75)
        .shadow(color: Color.black.opacity(0.3), radius: 4,x:0,y:2)
        
        VStack(alignment: .leading) {
            Text(prouct.title ?? "N/a")
                .font(.headline )
                .foregroundColor(.primary)
            Text("$" + String(prouct.price ?? 0) )
            Text(String(prouct.rating ?? 0))
            Text(prouct.category ?? "N/a")
            Text(prouct.title ?? "N/a")
            Text(prouct.brand ?? "N/a")
            
            
        }.font(.callout)
            .foregroundColor(.secondary)
        
        
    }
}

#Preview {
    ProductCellView(prouct: Product(id: 1, title: "a", description: "a", price: 1, discountPercentage: 0, rating: 0, stock: 0, brand: "a", category: "a", thumbnail: "a", images: []))
}
