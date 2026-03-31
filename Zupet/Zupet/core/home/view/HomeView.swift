//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

import Combine
struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject var store = Store()
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State var activeIndex: Int = 0
    @State private var selectedPet: PetItem?
    @State private var showCart: Bool = false
    @State private var animateContent: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.85),
                            value: animateContent
                        )
                    
                    searchBar
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.85)
                                .delay(0.08),
                            value: animateContent
                        )
                    
                    categoriesSection
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.85)
                                .delay(0.16),
                            value: animateContent
                        )
                    
                    carouselSection
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.7, dampingFraction: 0.9)
                                .delay(0.24),
                            value: animateContent
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .navigationDestination(item: $selectedPet, destination: { pet in
                PetDetailView(pet: pet)
            })
            .navigationDestination(isPresented: $showCart, destination: {
                EmptyCartView()
            })
            .background(Color.theme.backgroundColor.ignoresSafeArea())
            .onAppear {
                animateContent = true
            }
        }
        .background(Color.theme.backgroundColor)
    }
    private func getDragGesture() -> some Gesture {
           
           DragGesture()
               .onChanged { value in
                   draggingItem = snappedItem + value.translation.width / 100
               }
               .onEnded { value in
                   withAnimation {
                       draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                       draggingItem = round(draggingItem).remainder(dividingBy: Double(store.items.count))
                       snappedItem = draggingItem
                       
                       self.activeIndex = store.items.count + Int(draggingItem)
                       if self.activeIndex > store.items.count || Int(draggingItem) >= 0 {
                           self.activeIndex = Int(draggingItem)
                       }
                   }
               }
       }
       
       func distance(_ item: Int) -> Double {
           return (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
       }
       
       func myXOffset(_ item: Int) -> Double {
           let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
           return sin(angle) * 200
       }
    
    func opacityForItem(_ index: Int) -> Double {
        
        let dist = abs(round(distance(index)))
        
        if dist == 0 {
            return 1.0
        }
        else if dist == 1 {
            return 0.4        // left and right item
        }
        else {
            return 0.0        // hide all others
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 6) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Let's Find a")
                    .font(.custom("HollaBear-Regular", size: 25))
                    .foregroundColor(Color.theme.textColor)
                
                Text("Cute Friend")
                    .font(.custom("HollaBear-Regular", size: 34))
                    .foregroundColor(Color.theme.textColor)
            }
            Spacer()
            Button {
                showCart = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .padding()
                    .background(Color.theme.buttonTextColor)
                    .foregroundColor(Color.black)
                    .clipShape(.circle)
            }
            
        }
        .padding(.top, 24)
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.theme.subTitleTexColor)
                Text("Search here....")
                    .font(Font.typography.body)
                    .foregroundStyle(Color.theme.subTitleTexColor)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            
            
            Button { } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundStyle(Color.theme.textColor)
                    .padding(10)
                    .background(Color.theme.petStripe2)
                    .clipShape(.circle)
            }
        }
        .padding(2)
        .background(Color.theme.buttonTextColor)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Categories")
                    .font(Font.typography.headlineBold)
                    .foregroundColor(Color.theme.textColor)
                Spacer()
                Button(action: {}) {
                    Text("See all")
                        .font(Font.typography.footnoteMedium)
                        .foregroundColor(Color.theme.subTitleTexColor)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(PetCategoryType.allCases) { category in
                        categoryChip(for: category)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private func categoryChip(for category: PetCategoryType) -> some View {
        let isSelected = viewModel.selectedCategory == category
        
        return Button {
            viewModel.selectedCategory = category
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    
                    
                    Circle()
                        .fill(Color.theme.textColor)
                        .offset(x:2, y:2)
                    Circle()
                        .fill(isSelected ? Color.theme.petStripe2: Color.theme.buttonTextColor)
                    if category == .all {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(isSelected ? Color.theme.petStripe2 : Color.theme.textColor)
                    } else {
                        Image(category.iconName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: category.height, height:category.height)
                    }
                }
                .frame(width: 56, height: 56)
                
                Text(category.displayName)
                    .font(Font.typography.captionMedium)
                    .foregroundColor(isSelected ? Color.theme.textColor : Color.theme.subTitleTexColor)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var carouselSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Near By")
                    .font(Font.typography.headlineBold)
                    .foregroundColor(Color.theme.textColor)
                Spacer()
                Text("See all")
                    .font(Font.typography.footnoteMedium)
                    .foregroundColor(Color.theme.subTitleTexColor)
            }

            
            
            ZStack {
                ForEach(Array(viewModel.filteredPets.enumerated()), id: \.offset) { index, pet in
                    
                    petCard(pet)
                        .frame(width: 300, height: 350)
                        .scaleEffect(1.0 - abs(distance(index)) * 0.2)
                        .opacity(opacityForItem(index))
                        .offset(x: myXOffset(index), y: 0)
                        .zIndex(1.0 - abs(distance(index)) * 0.1)
                        .onTapGesture {
                            withAnimation {
                                draggingItem = Double(index)
                                snappedItem = Double(index)
                                activeIndex = index
                                selectedPet = pet
                            }
                        }
                }
            }
            .gesture(getDragGesture())
           
            
        }
    }
    
    private func petCard(_ pet: PetItem) -> some View {
        
        ZStack  {
            
            Image(pet.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                
            
            VStack(alignment: .leading) {
                
               
                HStack {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.typography.body)
                        Text("Distance")
                            .font(.typography.body)
                        Text(pet.distanceText)
                            .font(.typography.bodyBold)
                        
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.1))
                    )
                    
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.typography.body)
                        .foregroundColor(Color.black.opacity(0.5))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black.opacity(0.1))
                        )
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text(pet.name)
                        .font(.custom("HollaBear-Regular", size: 18))
                        .foregroundColor(Color.theme.textColor)
                    Text("\(pet.gender) • \(pet.ageDescription)")
                        .font(Font.typography.captionBold)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.theme.buttonTextColor)
                .stroke(Color.white, lineWidth: 1)
                
        )
        
        
        
    }
}

#Preview {
    HomeView()
}


struct Item: Identifiable {
    var id: Int
    var title: String
    var color: Color
}

class Store: ObservableObject {
    @Published var items: [Item]
    
    let colors: [Color] = [.red, .orange, .blue, .teal, .mint, .green, .gray, .indigo, .black]
    
    // dummy data
    init() {
        items = []
        for i in 0...7 {
            let new = Item(id: i, title: "Item \(i)", color: colors[i])
            items.append(new)
        }
    }
}
