//
//  PrimaryCapsuleButton.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//


// MARK: - Custom Primary Button (text + action)
import SwiftUI

struct PrimaryCapsuleButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.typography.headline)
                .foregroundStyle(Color.theme.ntextColor)
                .padding(15)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.green.opacity(0.9))
                )
                
                
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Primary Capsule Button") {
    PrimaryCapsuleButton(title: "GET STARTED") {}
        .padding()
}
