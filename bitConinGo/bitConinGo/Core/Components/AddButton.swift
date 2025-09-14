//
//  AddButton.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color.theme.blue)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton {}
            .padding()
            .background(Color.theme.background)
            .previewLayout(.sizeThatFits)
    }
}
