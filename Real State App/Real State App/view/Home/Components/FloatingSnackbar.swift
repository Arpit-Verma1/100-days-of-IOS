//
//  FloatingSnackbar.swift
//  Real State App
//
//  Created by Arpit Verma on 1/12/26.
//

import SwiftUI

struct FloatingSnackbar: View {
    let text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(text)
                .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                .foregroundColor(.black)
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isVisible = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.5))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .offset(y: isVisible ? 0 : 100)
        .opacity(isVisible ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isVisible)
    }
}

#Preview {
    VStack {
        Spacer()
        FloatingSnackbar(text: "Showing 64 results", isVisible: .constant(true))
            .padding(.bottom, 40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
}
