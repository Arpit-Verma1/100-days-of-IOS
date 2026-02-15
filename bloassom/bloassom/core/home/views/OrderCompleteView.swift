//
//  OrderCompleteView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct OrderCompleteView: View {
    var onBackToMenu: () -> Void
    var onTrackOrder: (() -> Void)?

    var body: some View {
        ZStack {
            Color.theme.cardColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                illustrationSection
                textSection
                Spacer(minLength: 24)
                buttonsSection
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }

    private var illustrationSection: some View {
        Image("order_complete")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            
    }

    private var textSection: some View {
        VStack(spacing: 8) {
            Text("Flowers are arriving soon")
                .font(.typography.title1Bold)
                .foregroundStyle(Color.theme.textColor)
                .multilineTextAlignment(.center)

            Text("Thank you for your order! You can track your order now.")
                .font(.typography.body)
                .foregroundStyle(Color.theme.subTitleTexColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        
    }

    private var buttonsSection: some View {
        VStack(spacing: 12) {
            Button {
                onTrackOrder?()
            } label: {
                Text("TRACK MY ORDER")
                    .font(.typography.headline)
                    .foregroundStyle(Color.theme.ntextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.theme.trackOrderButtonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
            .buttonStyle(.plain)

            Button(action: onBackToMenu) {
                Text("BACK TO MENU")
                    .font(.typography.headline)
                    .foregroundStyle(Color.theme.textColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(
                        Color.theme.ntextColor)
                            .stroke(Color.theme.borderColor, lineWidth: 1)
                    )
                    
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OrderCompleteView(onBackToMenu: {})
}
