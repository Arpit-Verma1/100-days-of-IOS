//
//  bottomNavBar.swift
//  Real State App
//
//  Created by Arpit Verma on 1/4/26.
//

import SwiftUI

enum TabItem {
    case home
    case saved
    case favorites
    case profile
}

struct BottomNavBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            
            // Home Tab
            Button(action: {
                selectedTab = .home
            }) {
                Image(systemName: "house.fill")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(selectedTab == .home ? .black : .white.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(selectedTab == .home ? Color.white : Color.black)
                            .stroke(selectedTab == .home ? Color.white :
                                Color.gray.opacity(0.4), lineWidth: 1)

                    )
                    
            }
            
           
            
            // Saved/Bookmark Tab
            Button(action: {
                selectedTab = .saved
            }) {
                Image(systemName: "map")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(selectedTab == .saved ? .black : .white.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(selectedTab == .saved ? Color.white : Color.black)
                            .stroke(selectedTab == .saved ? Color.white :
                                Color.gray.opacity(0.4), lineWidth: 1)

                    )
            }
            
            
            
            // Favorites Tab
            Button(action: {
                selectedTab = .favorites
            }) {
                Image(systemName: "heart")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(selectedTab == .favorites ? .black : .white.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(selectedTab == .favorites ? Color.white : Color.black)
                            .stroke(selectedTab == .favorites ? Color.white :
                                Color.gray.opacity(0.4), lineWidth: 1)

                    )
            }
            
          
            
            // Profile Tab
            Button(action: {
                selectedTab = .profile
            }) {
                Image(systemName: "person")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(selectedTab == .profile ? .black : .white.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(selectedTab == .profile ? Color.white : Color.black)
                            .stroke(selectedTab == .profile ? Color.white :
                                Color.gray.opacity(0.4), lineWidth: 1)

                    )
            }
            
            
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
    }
}


#Preview {
    ZStack {
        Color.gray.opacity(0.2)
        VStack {
            Spacer()
            BottomNavBar(selectedTab: .constant(.home))
        }
    }
}
