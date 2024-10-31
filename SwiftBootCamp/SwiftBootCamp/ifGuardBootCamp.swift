//
//  ifGuardBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct ifGuardBootCamp: View {
    @State var isLoading : Bool = false
    @State var currentUserId : String? = nil
    @State var displayText : String? = nil
    var body: some View {
        NavigationView {
            VStack {
                if let text = displayText {
                    Text(text)
                }
                if isLoading {
                    ProgressView()
                }
            }
            .onAppear(
                perform: {
                    loadData2()
                })
            
        }
    }
    func loadData () {
        if let userId = currentUserId {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                displayText = "this is new data \(userId)"
                isLoading = false
            })
        }
        else {
            displayText = "error "
        }
    }
    func loadData2 () {
        guard let userId = currentUserId else {
            displayText = "there is error"
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            displayText = "this is new data \(userId)"
            isLoading = false
        })
        
        
    }
}

#Preview {
    ifGuardBootCamp()
}
