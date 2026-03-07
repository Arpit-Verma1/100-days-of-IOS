//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

struct PawSliderView: View {

    let title: String
    let onCompleted: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var isCompleted: Bool = false

    private let knobSize: CGFloat = 75
    private let horizontalPadding: CGFloat = 6
    private let trackCornerRadius: CGFloat = 28

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let maxOffset = totalWidth - (horizontalPadding * 2)
            let fillWidth = min(horizontalPadding + dragOffset + knobSize / 2, totalWidth)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: trackCornerRadius, style: .continuous)
                    .fill(Color.theme.petStripe2)
                    
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: fillWidth,alignment: dragOffset == 0 ? .center : .trailing)
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, horizontalPadding)
                        .background(
                            RoundedRectangle.init(cornerRadius:trackCornerRadius).fill(Color.black)
                            )
                        .padding(4)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translation = value.translation.width
                                    let newOffset = min(max(0, translation), maxOffset)
                                    dragOffset = newOffset
                                }
                                .onEnded { _ in
                                    guard !isCompleted else { return }
                                    let threshold = maxOffset * 0.7

                                    if dragOffset >= threshold {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            dragOffset = maxOffset
                                            isCompleted = true
                                        }
                                        onCompleted()
                                    } else {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(Font.typography.calloutBold)
                        .foregroundColor(Color.theme.ntextColor)
                    Spacer()
                }
                
            }

        }
        .frame(height: 64)
    }
}

#Preview {
    PawSliderView(title: "Get Started") { }
        .padding()
}

