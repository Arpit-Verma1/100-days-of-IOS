//
//  AsyncImageBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 01/11/24.
//

import SwiftUI

struct AsyncImageBootCamp: View {
    let url = URL(string: "https://picsum.photos/200")
    var body: some View {
        AsyncImage(url: url ){
            phase in
            switch phase {
            case .empty : ProgressView()
            case .success(let returnedImage) :
                returnedImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .cornerRadius(15)
            case .failure : Image(systemName: "questionmark")
            default : Image(systemName: "questionmark")
            }
        }
        AsyncImage(url:url, content: { returnedImage in
            returnedImage
                .resizable()
                .scaledToFit()
            .frame(width: 100,height: 100)
                .cornerRadius(15)
        }, placeholder:{ ProgressView()}
        )
    }
}

#Preview {
    AsyncImageBootCamp()
}
