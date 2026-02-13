//
//  homeView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var hasAppeared = false

    private let categories = [
        ("Flowers", "fl8"),
        ("Edible Bouquets", "fl9"),
        ("Gift", "fl10")
    ]
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return"Good Evening"
        default:
            return"Good Night"
        }
    }
    

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    homeHeaderView
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 10)
                        .animation(.easeOut(duration: 0.45), value: hasAppeared)
                    searchBar
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 12)
                        .animation(.easeOut(duration: 0.45).delay(0.05), value: hasAppeared)
                    categoryPills
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 12)
                        .animation(.easeOut(duration: 0.45).delay(0.1), value: hasAppeared)
                    promoBanner
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 14)
                        .animation(.easeOut(duration: 0.45).delay(0.15), value: hasAppeared)
                    offerScroll
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 16)
                        .animation(.easeOut(duration: 0.45).delay(0.2), value: hasAppeared)
                    sectionHeader(title: "Categories", action: "See All")
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 10)
                        .animation(.easeOut(duration: 0.45).delay(0.25), value: hasAppeared)
                    categoriesScroll
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 14)
                        .animation(.easeOut(duration: 0.45).delay(0.3), value: hasAppeared)
                    sectionHeader(title: "Popular Items", action: "See All")
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 10)
                        .animation(.easeOut(duration: 0.45).delay(0.35), value: hasAppeared)
                    popularItemsGrid
                }
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 20)
            .background(Color.theme.ntextColor)
            .navigationDestination(for: Flower.self) { flower in
                FlowerDetailView(flower: flower, viewModel: viewModel)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    hasAppeared = true
                }
            }
        }
    }
    

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.theme.subTitleTexColor)
                Text("Search")
                    .font(Font.typography.body)
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

    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.0) { name, icon in
                    HStack(spacing: 8) {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .background(Color.theme.cardColor)
                            .clipShape(.circle)
                        Text(name)
                            .font(Font.typography.bodyMedium)
                    }
                    .foregroundStyle(Color.theme.textColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
            
        }
    }

    private var promoBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "tag.fill")
                .font(.title2)
                .foregroundStyle(Color.theme.tabBarBackground)
                .frame(width: 44, height: 44)
                .background(Color.theme.tabBarBackground.opacity(0.2))
                .clipShape(Circle())

            Text("We offer a discount of up to $10.00 for new customers")
                .font(Font.typography.subheadline)
                .foregroundStyle(Color.theme.textColor)
                .multilineTextAlignment(.leading)

            Image(systemName: "chevron.right")
                .font(.callout)
                .foregroundStyle(Color.theme.textColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.ntextColor)
                .stroke(Color.theme.borderColor, lineWidth: 1)
        )
        
    }
    private var offerScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FlowerSample.list.prefix(6)) { flower in
                    inStorePickupCard
                      
                        .frame(width: UIScreen.main.bounds.width - 120, height: 160,alignment: .top)
                            .padding(.trailing, 10)
                                                .scrollTransition { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0.5) // Apply opacity animation
                                                        .scaleEffect(y: phase.isIdentity ? 1 : 0.8) // Apply scale animation
                                                }
                                                
                }
            }.scrollTargetLayout()
            
        }
        .scrollTargetBehavior(.viewAligned)
    }

    private var inStorePickupCard: some View {
        
        
        
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("In-Store Pickup")
                    .font(Font.typography.title3Bold)
                    .foregroundStyle(Color.theme.textColor)
                Text("Get +6% bonuses for in store pickup")
                    .font(Font.typography.footnote)
                    .foregroundStyle(Color.theme.textColor.opacity(0.8))
            }
            Spacer()
            Image("fl2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardColor)
                .stroke(Color.theme.borderColor, lineWidth: 1))    }

    private func sectionHeader(title: String, action: String) -> some View {
        HStack {
            Text(title)
                .font(Font.typography.headlineBold)
                .foregroundStyle(Color.theme.textColor)
            Spacer()
            Button(action: {}) {
                Text(action)
                    .font(Font.typography.footnoteMedium)
                    .foregroundStyle(Color.theme.subTitleTexColor)
            }
        }
    }

    private var categoriesScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FlowerSample.list.prefix(10)) { flower in
                    categoryCard(flower: flower)
                      
                        .frame(width: 90, height: 140,alignment: .top)
                            .padding(.trailing, 10)
                                                .scrollTransition { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0.5) // Apply opacity animation
                                                        .scaleEffect(y: phase.isIdentity ? 1 : 0.8) // Apply scale animation
                                                }
                                                
                }
            }.scrollTargetLayout()
            
        }
        .scrollTargetBehavior(.viewAligned)
    }

    private func categoryCard(flower: Flower) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(flower.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardColor)
                        .stroke(Color.theme.borderColor, lineWidth: 0.5)
                )
            Text(flower.name)
                .font(Font.typography.caption)
                .foregroundStyle(Color.theme.textColor)
                .multilineTextAlignment(.center)
                
        }
        .frame(width: 100)
    }

    private var popularItemsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(Array(FlowerSample.list.enumerated()), id: \.element.id) { index, flower in
                NavigationLink(value: flower) {
                    popularItemCard(flower: flower)
                }
                .buttonStyle(.plain)
                .opacity(hasAppeared ? 1 : 0)
                .scaleEffect(hasAppeared ? 1 : 0.94)
                .animation(
                    .easeOut(duration: 0.4).delay(0.4 + Double(index) * 0.03),
                    value: hasAppeared
                )
            }
        }
    }

    private func popularItemCard(flower: Flower) -> some View {
       
            ZStack(alignment: .topLeading) {
                VStack(alignment:.center) {
                    Image(flower.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                    Text(flower.name)
                        .font(Font.typography.captionMedium)
                        .foregroundStyle(Color.theme.textColor)
                        .lineLimit(2)
                }.padding(.top, 30)
                

                HStack {
                    if flower.acceptsBonuses {
                        Text("15% off")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.theme.textColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(8)
                    }
                    Spacer()
                    heartButton(isSelected: viewModel.isFavourite(flower)) {
                        viewModel.toggleFavourite(flower)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
            Color.theme.cardColor)
                .stroke(Color.theme.borderColor, lineWidth: 0.5)
        )
    }
    
    private var homeHeaderView: some View {
        HStack(spacing: 12) {
            Image("profile")
                .resizable()
                .foregroundColor(Color.theme.textColor.opacity(0.6))
                .frame(width: 40, height: 40)
                .clipShape(.circle)
           
            
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingMessage)
                    .font(Font.typography.caption)
                    .foregroundColor(Color.theme.subTitleTexColor)
                
                Text("Arpit Verma")
                    .font(Font.typography.headlineBold)
                    .foregroundColor(Color.theme.textColor)
            }
            
            Spacer()
            
            NavigationLink {
                CartView(viewModel: viewModel)
            } label: {
                Image(systemName: "cart")
                    .font(Font.typography.subheadline)
                    .foregroundStyle(Color(hex: "935cad"))
            }
            .padding(10)
            .background(Circle().fill(Color(hex: "c9aed6")))
        }
       
        .padding(.top, 8)
    }
}


struct heartButton: View {
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "heart.fill" : "heart")
                .font(.callout)
                .foregroundStyle(Color(hex: "935cad"))
                .padding(5)
                .background(Circle().fill(Color(hex: "c9aed6")))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
