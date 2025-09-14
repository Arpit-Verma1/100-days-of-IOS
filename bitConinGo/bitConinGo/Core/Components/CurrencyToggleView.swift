//
//  CurrencyToggleView.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct CurrencyToggleView: View {
    @Binding var isBitcoinMode: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 0) {
                // Bitcoin Icon
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(isBitcoinMode ? .white : .white.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(isBitcoinMode ? Color.theme.blue : Color.clear)
                    )
                
                // Dollar Icon
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(!isBitcoinMode ? .white : .white.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(!isBitcoinMode ? Color.theme.blue : Color.clear)
                    )
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CurrencyToggleView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CurrencyToggleView(isBitcoinMode: .constant(true)) {}
            CurrencyToggleView(isBitcoinMode: .constant(false)) {}
        }
        .padding()
        .background(Color.theme.blue)
        .previewLayout(.sizeThatFits)
    }
}
