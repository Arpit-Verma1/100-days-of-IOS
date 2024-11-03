//
//  listSwipeActionBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct listSwipeActionBootCamp: View {
    @State var items : [String] = ["a", "b" , "c"]
    var body: some View {
        List {
            ForEach(items, id: \.self) {
                Text($0.capitalized)
                    .swipeActions(
                    edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/,allowsFullSwipe: true
                    ) {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("archive")
                        })
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("junk")
                        
                        })
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("delete")
                        })
                    }
            }
        }
    }
}

#Preview {
    listSwipeActionBootCamp()
}
