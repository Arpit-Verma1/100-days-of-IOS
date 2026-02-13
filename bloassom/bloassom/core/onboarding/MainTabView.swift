//
//  MainTabView.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var homeViewModel = HomeViewModel()

    enum Tab: Int, CaseIterable {
        case home, messages, collections, profile

        var title: String {
            switch self {
            case .home: return "Home"
            case .messages: return "Messages"
            case .collections: return "Collections"
            case .profile: return "Profile"
            }
        }

        var systemImageFill: String {
            switch self {
            case .home: return "house.fill"
            case .messages: return "bubble.left.and.bubble.right.fill"
            case .collections: return "heart.fill"
            case .profile: return "person.fill"
            }
        }
        var systemImageUnfill: String {
            switch self {
            case .home: return "house"
            case .messages: return "bubble.left.and.bubble.right"
            case .collections: return "heart"
            case .profile: return "person"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                    Group {
                        switch selectedTab {
                        case .home:
                            HomeView(viewModel: homeViewModel)
                        case .messages:
                            placeholderView(title: Tab.messages.title)
                        case .collections:
                            CollectionsView(viewModel: homeViewModel)
                        case .profile:
                            placeholderView(title: Tab.profile.title)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(spacing: 0) {
                    Spacer()
                    customTabBar
                }
                
                .navigationBarBackButtonHidden()
                .ignoresSafeArea(.keyboard)
            }
        }
        .onAppear {
            for family in UIFont.familyNames.sorted() {
                print("Font Family: \(family)")
                
                for font in UIFont.fontNames(forFamilyName: family) {
                    print("   \(font)")
                }
            }

        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                tabBarItem(tab: tab)
            }
        }
        .padding(.top, 12)
        .background(Color.theme.tabBarBackground)
//        .ignoresSafeArea(edges: .bottom)
    }

    private func tabBarItem(tab: Tab) -> some View {
        let isSelected = selectedTab == tab
        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.systemImageFill : tab.systemImageUnfill)
                    .font(.system(size: 22))
                Text(tab.title)
                    .font(isSelected ? .typography.captionBold : .typography.caption)
            }
            .foregroundStyle(Color.theme.ntextColor)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private func placeholderView(title: String) -> some View {
        Text(title)
            .font(.typography.title2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainTabView()
}
