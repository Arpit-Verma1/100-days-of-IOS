//
//  CartView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var hasAppeared = false
    @State private var startShoppingPressed = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if viewModel.cartList.isEmpty {
                    emptyCartContent
                        .padding(.top, -geometry.safeAreaInsets.top)
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                } else {
                    cartItemsContent
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .animation(.easeOut(duration: 0.35), value: viewModel.cartList.isEmpty)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .background(Color.theme.ntextColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Basket")
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                hasAppeared = true
            }
        }
    }

    private var emptyCartContent: some View {
        VStack(spacing: 24) {

            Image("empty_cart")
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(contentMode: .fill)
                .opacity(hasAppeared ? 1 : 0)
                .scaleEffect(hasAppeared ? 1 : 0.9)
                .animation(.easeOut(duration: 0.5), value: hasAppeared)

            VStack(spacing: 10) {
                Text("Your Basket Is Empty")
                    .font(.typography.title2Bold)
                    .foregroundStyle(Color.theme.textColor)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.45).delay(0.1), value: hasAppeared)

                Text("Looks like you haven't added anything to your basket yet.")
                    .font(.typography.body)
                    .foregroundStyle(Color.theme.subTitleTexColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.45).delay(0.18), value: hasAppeared)

                Button {
                    withAnimation(.easeInOut(duration: 0.12)) {
                        startShoppingPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        dismiss()
                    }
                } label: {
                    Text("START SHOPPING")
                        .font(.typography.headline)
                        .foregroundStyle(Color.theme.ntextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.theme.startShoppingButtonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .scaleEffect(startShoppingPressed ? 0.97 : 1)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 16)
                .animation(.easeOut(duration: 0.45).delay(0.26), value: hasAppeared)
            }
            .padding(.bottom, 48)
        }
    }

    private var cartItemsContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.cartList.enumerated()), id: \.element.id) { index, item in
                    cartItemRow(item)
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.4).delay(Double(index) * 0.06),
                            value: hasAppeared
                        )
                }
            }
            .padding()
        }
        .padding(.bottom, 24)
    }

    private func cartItemRow(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            Image(item.flower.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.flower.name)
                    .font(.typography.subheadlineMedium)
                    .foregroundStyle(Color.theme.textColor)
                Text(String(format: "$%.2f × %d", item.flower.price, item.quantity))
                    .font(.typography.caption)
                    .foregroundStyle(Color.theme.subTitleTexColor)
            }

            Spacer()

            Text(String(format: "$%.2f", item.flower.price * Double(item.quantity)))
                .font(.typography.subheadlineBold)
                .foregroundStyle(Color.theme.textColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardColor)
                .stroke(Color.theme.borderColor, lineWidth: 0.5)
        )
    }
}

#Preview("Empty cart") {
    NavigationStack {
        CartView(viewModel: HomeViewModel())
    }
}

#Preview("With items") {
    let vm = HomeViewModel(cartList: [
        CartItem(flower: FlowerSample.list[0], quantity: 2),
        CartItem(flower: FlowerSample.list[1], quantity: 1)
    ])
    return NavigationStack {
        CartView(viewModel: vm)
    }
}
