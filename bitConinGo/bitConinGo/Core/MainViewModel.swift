//
//  MainViewModel.swift
//  bitCionGo
//
//  Created by arpit verma on 04/08/24.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .analytics
    @Published var showAddSheet: Bool = false
    
    enum TabItem: CaseIterable {
        case analytics, exchange, record, wallet
        
        var title: String {
            switch self {
            case .analytics:
                return "Analytics"
            case .exchange:
                return "Exchange"
            case .record:
                return "Record"
            case .wallet:
                return "Wallet"
            }
        }
        
        var icon: String {
            switch self {
            case .analytics:
                return "chart.line.uptrend.xyaxis"
            case .exchange:
                return "arrow.left.arrow.right"
            case .record:
                return "doc.text"
            case .wallet:
                return "wallet.pass"
            }
        }
    }
}
