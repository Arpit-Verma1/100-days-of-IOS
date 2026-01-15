//
//  homePageView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/4/26.
//

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = HomePageViewModel()
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image("profile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            Spacer()
                            Button(action: {
                                viewModel.showFilterSheet = true
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor( .black)
                                
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(.white)
                                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                        }
                        .padding(.horizontal, 5)
                        .padding(.bottom, 30)
                        Text("Start your home")
                            .font(.custom("HelveticaNowDisplay-Bold", size: 42))
                        Text("search now")
                            .font(.custom("HelveticaNowDisplay-Bold", size: 45))
                            .offset(y : -15)
                        VStack(spacing: 20) {
                            ForEach(viewModel.filteredProperties) { property in
                                PropertyCardView(property: property)
                            }
                        }
                        .padding(.bottom, 100)
                        
                        
                    }
                    .padding(
                        .horizontal, 15
                    )
                }
                .scrollIndicators(.hidden)
                VStack {
                    Spacer()
                    BottomNavBar(selectedTab: $selectedTab)
                        .ignoresSafeArea(edges: .bottom)
                        .opacity(viewModel.showSnackbar ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showSnackbar)
                }
                
                if viewModel.showSnackbar {
                    VStack {
                        Spacer()
                        FloatingSnackbar(
                            text: "Showing \(viewModel.filteredProperties.count) results",
                            isVisible: $viewModel.showSnackbar
                        )
                        .padding(.bottom, 40)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showFilterSheet) {
                ZStack(alignment: .topTrailing) {
                    FilterSheetView(viewModel: viewModel)
                        .presentationDetents([.fraction(0.9)])
                        .presentationDragIndicator(.visible)
                }
            }
            .onAppear{
                viewModel.applyFilters()
            }
        }}
    
}

#Preview {
    HomePageView()
}
