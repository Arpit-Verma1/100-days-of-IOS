//
//  ExtractSubview.swift
//  Buttons
//
//  Created by arpit verma on 26/10/24.
//

import SwiftUI

struct ExtractSubview: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            
            content
        }
    }
    var content :some View {
        HStack {
            SubView(no: 1, fruit: "apple")
            SubView(no: 3, fruit: "mango")
        }
    }
}

#Preview {
    ExtractSubview()
}

struct SubView: View {
    let no:Int
    let fruit: String
    var body: some View {
        VStack{
            Text("\(no)")
            Text("\(fruit)")
    
            
        }
        .padding()
        .background(Color.blue)
    }
}
