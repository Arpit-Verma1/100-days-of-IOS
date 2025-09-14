//
//  MainView.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content area
                contentView
                
                Spacer()
                
                // Bottom navigation bar with add button
                bottomNavigationBar
            }
        }
    }
}

extension MainView {
    private var contentView: some View {
        Group {
            switch mainViewModel.selectedTab {
            case .analytics:
                AnalyticsView()
            case .exchange:
                ExchangeView()
            case .record:
                RecordView()
            case .wallet:
                WalletView()
            }
        }
    }
    
    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            // Bottom navigation bar (80% of screen width)
            HStack(spacing: 0) {
                ForEach(MainViewModel.TabItem.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: mainViewModel.selectedTab == tab
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mainViewModel.selectedTab = tab
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // Add button (20% of screen width)
            AddButton {
                mainViewModel.showAddSheet.toggle()
            }
            .padding(.trailing, 20)
            .padding(.bottom, 10)
        }
        .frame(height: 80)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainViewModel())
    }
}
