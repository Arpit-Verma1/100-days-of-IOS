//
//  ZupetBottomNavBar.swift
//  Zupet
//
//  Created by Arpit Verma on 3/1/26.
//
import SwiftUI

struct ZupetBottomNavBar: View {
    
    @Binding var selectedTab: ZupetTab
    
    var body: some View {
        HStack(spacing: 20) {
            tabButton(tab: .home, systemImage: "house.fill")
            tabButton(tab: .featured, systemImage: "pawprint.fill")
            tabButton(tab: .collection, systemImage: "heart.fill")
            tabButton(tab: .profile, systemImage: "person.fill")
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.theme.buttonTextColor)
        )
    }
    
    private func tabButton(tab: ZupetTab, systemImage: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            ZStack {
                
                if selectedTab == tab {
                    Circle()
                        .fill(Color.theme.textColor)
                        .offset(x:1, y:1)
                    Circle()
                        .fill(selectedTab == tab ?  Color.theme.petStripe2: Color.theme.buttonTextColor)
                }
                Image(systemName: systemImage)
                   
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color.theme.textColor)
                    .padding(10)
            }
            .frame(width: 40, height: 40)
            
        }
    }
}
