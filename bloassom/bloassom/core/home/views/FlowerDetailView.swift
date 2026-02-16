//
//  FlowerDetailView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct FlowerDetailView: View {
    let flower: Flower
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var quantity: Int = 1
    @State private var showOrderComplete = false
    @State private var hasAppeared = false
    @State private var addToCartPressed = false

    private let thumbnailSize: CGFloat = 72
    private let deliveryFee: Double = 8
    private let bonusPoints: Double = 2.97

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    mainImageSection
                        .padding(.top, -geometry.safeAreaInsets.top)
                        .opacity(hasAppeared ? 1 : 0)
                        .scaleEffect(hasAppeared ? 1 : 0.92)
                        .animation(.easeOut(duration: 0.5), value: hasAppeared)
                    thumbnailGallery
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 16)
                        .animation(.easeOut(duration: 0.45).delay(0.06), value: hasAppeared)
                    infoCards
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.45).delay(0.12), value: hasAppeared)
                    quantityAndPrice
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 16)
                        .animation(.easeOut(duration: 0.45).delay(0.18), value: hasAppeared)
                    addToCartButton
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 24)
                        .animation(.easeOut(duration: 0.45).delay(0.24), value: hasAppeared)
                }
                .padding(.bottom, 32)
            }
            .background(Color.theme.ntextColor)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    hasAppeared = true
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showOrderComplete) {
            OrderCompleteView(onBackToMenu: {
                showOrderComplete = false
                dismiss()
            })
        }
    }

    private var mainImageSection: some View {
        ZStack(alignment: .topTrailing) {
            Color.theme.cardColor
            Image(flower.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .padding(.top, 60)
            heartButton(isSelected: viewModel.isFavourite(flower)) {
                viewModel.toggleFavourite(flower)
            }
            .padding(20)
            .padding(.top, 40)
        }
        .frame(minHeight: 280)
        .ignoresSafeArea(edges: .top)
    }

   

    private var thumbnailGallery: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(FlowerSample.list.prefix(4).enumerated()), id: \.element.id) { index, item in
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: thumbnailSize, height: thumbnailSize)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardColor)
                                    .stroke(Color.theme.borderColor, lineWidth: 0.5)
                            )
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(x: hasAppeared ? 0 : -20)
                            .animation(
                                .easeOut(duration: 0.4)
                                .delay(Double(index) * 0.06),
                                value: hasAppeared
                            )
                    }
                }
                .padding(.horizontal, 20)
            }
            HStack {
                Spacer()
                Button { } label: {
                    Text("See All")
                        .font(.typography.footnoteMedium)
                        .foregroundStyle(Color.theme.subTitleTexColor)
                }
                .padding(.trailing, 20)
            }
        }
    }

    private var infoCards: some View {
        VStack(spacing: 12) {
            ForEach(Array([0, 1, 2].enumerated()), id: \.offset) { index, _ in
                Group {
                    switch index {
                    case 0:
                        detailCard(
                            icon: "shippingbox",
                            lines: [
                                "Delivery Slot: Tomorrow 14:00 - 14:30",
                                "Delivery Fee: $\(Int(deliveryFee))"
                            ]
                        )
                    case 1:
                        detailCard(
                            icon: "heart",
                            lines: ["1 More Community Members Added To Collections"]
                        )
                    default:
                        detailCard(
                            icon: "star",
                            lines: ["You Will Receive **\(String(format: "%.2f", bonusPoints))** Bonus Points"]
                        )
                    }
                }
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)
                .animation(.easeOut(duration: 0.4).delay(0.2 + Double(index) * 0.06), value: hasAppeared)
            }
        }
        .padding(.horizontal, 20)
    }

    private func detailCard(icon: String, lines: [String]) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.theme.tabBarBackground)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(lines, id: \.self) { line in
                    Text(line.replacingOccurrences(of: "**", with: ""))
                        .font(.typography.footnote)
                        .foregroundStyle(Color.theme.textColor)
                }
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardColor)
                .stroke(Color.theme.borderColor, lineWidth: 0.5)
        )
    }

    private var quantityAndPrice: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(String(format: "$%.0f", flower.price * 1.2))
                        .font(.typography.body)
                        .strikethrough()
                        .foregroundStyle(Color.theme.subTitleTexColor)
                    Text(String(format: "$%.0f", flower.price))
                        .font(.typography.subheadline)
                        .foregroundStyle(Color.theme.subTitleTexColor)
                }
                Text(String(format: "$%.0f", flower.price * Double(quantity)))
                    .font(.typography.title2Bold)
                    .foregroundStyle(Color.theme.textColor)
                    .contentTransition(.numericText())
            }
            Spacer()
            HStack(spacing: 16) {
                QuantityStepperButton(systemImage: "minus") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if quantity > 1 { quantity -= 1 }
                    }
                }
                .disabled(quantity <= 1)
                Text(quantity, format: .number)
                    .font(.typography.title3)
                    .foregroundStyle(Color.theme.textColor)
                    .frame(minWidth: 24)
                    .contentTransition(.numericText())
                QuantityStepperButton(systemImage: "plus") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        quantity += 1
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var addToCartButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                addToCartPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                viewModel.addToCart(flower: flower, quantity: quantity)
                showOrderComplete = true
                addToCartPressed = false
            }
        } label: {
            Text("Add To Cart")
                .font(.typography.headline)
                .foregroundStyle(Color.theme.ntextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.theme.tabBarBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .scaleEffect(addToCartPressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}

// MARK: - Quantity stepper button with tap animation
private struct QuantityStepperButton: View {
    let systemImage: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.12)) {
                isPressed = true
            }
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.12)) {
                    isPressed = false
                }
            }
        }) {
            Image(systemName: systemImage)
                .font(.typography.body)
                .foregroundStyle(Color.theme.textColor)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.theme.cardColor)
                        .stroke(Color.theme.borderColor, lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.88 : 1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        FlowerDetailView(flower: FlowerSample.list[0], viewModel: HomeViewModel())
    }
}
