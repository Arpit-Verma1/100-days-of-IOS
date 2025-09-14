//
//  toolBar.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI

struct toolBar: View {
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Todo's")
            .toolbar {
                ToolbarItem (placement: .topBarTrailing){
                    HStack {
                        Button("", systemImage: "suit.heart.fill") {
                            
                        }
                        Button("", systemImage: "magnifyingglass") {
                            
                        }
                    }
                }
                ToolbarSpacer(.fixed,placement: .topBarTrailing)
                ToolbarItem(placement:.topBarTrailing) {
                    Button("",systemImage: "person.fill") {
                        
                    }
                    
                }
            }
        }
    }
}

#Preview {
    toolBar()
}
