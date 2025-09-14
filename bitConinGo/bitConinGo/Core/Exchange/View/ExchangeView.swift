//
//  ExchangeView.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct ExchangeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 60))
                    .foregroundColor(Color.theme.accent)
                
                Text("Exchange")
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

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView()
    }
}
