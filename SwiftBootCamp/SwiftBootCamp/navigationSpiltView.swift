//
//  navigationSpiltView.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

enum FoodCategory : String, CaseIterable {
    case fruits, vegitables, meats
}
enum Fruit: String, CaseIterable {
    case apple, banana, orange
}

struct navigationSpiltView: View {
    @State private var visibility : NavigationSplitViewVisibility = .all
    @State private var selectedCategory : FoodCategory? = nil
    @State private var selectedFruit : Fruit? = nil
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            List{
                ForEach(FoodCategory.allCases, id: \.rawValue) { category in
                    Text(category.rawValue.capitalized)
                }
            }
        } content: {
            if let selectedCategory {
                Group {
                    switch selectedCategory {
                    case .fruits:
                        List{
                            ForEach(Fruit.allCases, id: \.rawValue) { fruit in
                                Button(action: 
                                        {
                                    selectedFruit = fruit
                                }
                                       , label: {
                                    Text(fruit.rawValue.capitalized)
                                })
                            }
                        }
                    case .vegitables:
                    EmptyView()
                    case .meats:
                    EmptyView()
                    }
                }
                .navigationTitle(selectedCategory.rawValue.capitalized)
            }
            else {
                Text("select a category to begin")
            }
        }
    
    
    detail: {
           Text("select")
        }

    }
}

#Preview {
    navigationSpiltView()
}


