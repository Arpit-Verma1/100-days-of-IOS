//
//  RecordView.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct RecordView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "doc.text")
                    .font(.system(size: 60))
                    .foregroundColor(Color.theme.accent)
                
                Text("Record")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
                
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
        }
        .background(Color.theme.background)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
