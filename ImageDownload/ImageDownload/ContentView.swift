//
//  ContentView.swift
//  ImageDownload
//
//  Created by arpit verma on 20/07/24.
//

import SwiftUI
import SwiftUI
import SwURL

struct ContentView: View {
    init(){
        SwURL.setImageCache(
            type: .persistent
        )
    }
    var body: some View {
        NavigationView{
            VStack{
                SwURLImage(
                    url: URL(
                        string: "https://share.ftimg.com/aff/flamingtext/2013/09/10/flamingtext__23132978028750356.png"
                    )!
                ).progress(
                    {
                        progress in return Text("\(Int(progress * 100))%"
                        )
                    }
                )
                .frame(
                    width: 300,
                    height: 300
                )
                .clipShape(
                    Rectangle()
                )                    .overlay(
                    Rectangle().stroke(
                        Color.white
                        ,
                        lineWidth: 4
                    )
                )
                .shadow(
                    radius: 10
                )
                Text(
                    "Hello, World!"
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
