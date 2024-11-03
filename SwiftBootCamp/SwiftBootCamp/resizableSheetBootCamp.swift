//
//  resizableSheetBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct resizableSheetBootCamp: View {
    @State var showSheet : Bool = false
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }, label: {
            Text("click me")
        })
        .sheet(isPresented: $showSheet) {
        scndScreen()
                .presentationDetents([.medium , .large])
//                .presentationDragIndicator(.hidden)
//                .interactiveDismissDisabled()
        }
    }
}

struct scndScreen : View {
    var body : some View {
        ZStack {
            Color.red.ignoresSafeArea()
        }
    }
}

#Preview {
    resizableSheetBootCamp()
}
