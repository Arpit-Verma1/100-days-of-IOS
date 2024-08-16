//
//  XmarkView.swift
//  CryptoNest
//
//  Created by arpit verma on 16/08/24.
//

import SwiftUI

struct XmarkView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark").font(.headline)
        })
    }
}

#Preview {
    XmarkView()
}
