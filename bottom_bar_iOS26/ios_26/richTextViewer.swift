//
//  richTextViewer.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI

struct richTextViewer: View {
    @State private var richText  = AttributedString()
    var body: some View {
        TextEditor(text: $richText)
            .frame(height: 300)
            .padding(15)
    }
}

#Preview {
    richTextViewer()
}
