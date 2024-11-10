//  MyScrollViewReader.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 10/11/24.
//

import SwiftUI

struct MyScrollViewReader: View {
    @State var text: String = ""
    @State var scrollToIndex: Int = 0

    var body: some View {
        
        VStack {
            TextField("Enter a value", text: $text)
                .frame(height: 55)
                .border(Color.gray)
                .padding(.horizontal)
                .keyboardType(.numberPad)
                .onSubmit {
                    withAnimation {
                        if let index = Int(text) {
                            scrollToIndex = index
                        }
                    }
                }
            
            Button {
                withAnimation {
                    if let index = Int(text) {
                        scrollToIndex = index
                    }
                }
            } label: {
                Text("Scroll now")
            }
            
            ScrollView {
                ScrollViewReader { proxy in
                    
                    ForEach(0..<50) { index in
                        Text("This is item \(index)")
                            .font(.headline)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .padding()
                            .id(index)
                    }
                    .onChange(of: scrollToIndex) { value in
                        withAnimation(.spring()) {
                            proxy.scrollTo(value, anchor: .top)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MyScrollViewReader()
}

