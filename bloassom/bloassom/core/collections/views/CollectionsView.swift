//
//  CollectionsView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct CollectionsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var hasAppeared = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                searchBar
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.45), value: hasAppeared)

                addCartAndGridSection
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
        .background(Color.theme.ntextColor)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                hasAppeared = true
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.theme.subTitleTexColor)
                Text("Search")
                    .font(.typography.body)
                    .foregroundStyle(Color.theme.subTitleTexColor)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.theme.secondaryButtonColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button { } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundStyle(Color.theme.textColor)
            }
        }
    }

    private var flowersAndGiftSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Flowers & Gift")
                    .font(.typography.headlineBold)
                    .foregroundStyle(Color.theme.textColor)
                Spacer()
                Button { } label: {
                    Text("See All")
                        .font(.typography.footnoteMedium)
                        .foregroundStyle(Color.theme.subTitleTexColor)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.favouriteFlowers) { flower in
                        flowersAndGiftCard(flower: flower)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }

    private func flowersAndGiftCard(flower: Flower) -> some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                Image(flower.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Flowers")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.theme.ntextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.theme.textColor)
                    .clipShape(Capsule())
                    .padding(8)
            }
            .frame(width: 140, alignment: .leading)

            Button {
                viewModel.toggleFavourite(flower)
            } label: {
                Image(systemName: viewModel.isFavourite(flower) ? "heart.fill" : "heart")
                    .font(.callout)
                    .foregroundStyle(Color(hex: "935cad"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardColor)
                .stroke(Color.theme.borderColor, lineWidth: 0.5)
        )
    }

    private var addCartAndGridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(Array(viewModel.favouriteFlowers.enumerated()), id: \.element.id) { index, flower in
                    gridCard(flower: flower)
                        .frame(alignment: .top)
                        .opacity(hasAppeared ? 1 : 0)
                        .scaleEffect(hasAppeared ? 1 : 0.92)
                        .animation(
                            .easeOut(duration: 0.4).delay(0.08 + Double(index) * 0.05),
                            value: hasAppeared
                        )
                }
            }
            .animation(.easeOut(duration: 0.3), value: viewModel.favouriteFlowers.count)
        }
    }

    private func gridCard(flower: Flower) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .top) {
                Image(flower.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 20)
                HStack {
                    Spacer()
                    heartButton(isSelected: viewModel.isFavourite(flower)) {
                        viewModel.toggleFavourite(flower)
                    }
                }
            }
            .padding(5)
            
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardColor)
                    .stroke(Color.theme.borderColor, lineWidth: 0.5)
            )
            Text(flower.name)
                .font(.typography.captionMedium)
                .foregroundStyle(Color.theme.textColor)
                .lineLimit(2)
            HStack { Text(String(format: "$%.2f", flower.price))
                    .font(.typography.captionBold)
                    .foregroundStyle(Color.theme.textColor)
                
            }
            
            
        }
        
    }
}

#Preview {
    CollectionsView(viewModel: HomeViewModel(favourites: Array(FlowerSample.list.prefix(4))))
}
