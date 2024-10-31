//
//  onAppearBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct onAppearBootCamp: View {
    @State var count : Int = 0
    @State var myText : String = "Start text"
    var body: some View {
        NavigationView{
            ScrollView{
                Text(myText)
                LazyVStack{
                    ForEach(0..<50
                    ) {
                        _ in RoundedRectangle(cornerRadius: 25)
                            .frame(height:200
                            )
                            .padding()
                            .onAppear {
                                count += 1
                            }
                    }
                    
                }
                
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                    myText = "this is new Text"
                })
            }
            .navigationTitle("count is:\(count) ")
        }
        
        
    }
}

#Preview {
    onAppearBootCamp()
}
