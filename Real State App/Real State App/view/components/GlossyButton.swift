//
//  GlossyBlackButton.swift
//  Real State App
//
//  Created by Arpit Verma on 1/14/26.
//


import SwiftUI

struct GlossyButton: View {
    var title: String = "Show 64 results"
    var text : String
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                .foregroundColor(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(#colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)),
                                        Color.black
                                    ]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )

                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.05),
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                            .padding(.top, 2)
                            .mask(
                                RoundedRectangle(cornerRadius: 28)
                            )
                    }
                )
        }
    }
}
