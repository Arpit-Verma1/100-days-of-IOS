//
//  ThaliComboView.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

struct ThaliComboView: View {
    var mainCourse: LocalizedStringResource
    var breadType: LocalizedStringResource
    var riceQuantity: Int
    var sideDishes: [String]
    var page: ThaliOrderPage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 15) {
                // Main dish image based on current page
                Group {
                    if page == .page1 {
                        // Show the selected main course
                        getMainCourseImage()
                    } else if page == .page2 {
                        // Show the selected bread type
                        getBreadImage()
                    } else if page == .page3 {
                        // Show the selected main course
                        getMainCourseImage()
                    } else if page == .page4 {
                        // Show the selected main course
                        getMainCourseImage()
                    } else if page == .page5 {
                        // Show the selected main course
                        getMainCourseImage()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Thali Combo")
                        .fontWeight(.semibold)
                        .font(.title)
                    
                    // Debug text to show actual values
                    Text("MainCourse: \(mainCourse)")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text("Bread: \(breadType)")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    
                    Group {
                        if page == .page1 {
                            Text(mainCourse)
                        } else if page == .page2 {
                            Text(mainCourse)
                            Text("with \(breadType)")
                        } else if page == .page3 {
                            Text(mainCourse)
                            Text("with \(breadType)")
                            Text("\(riceQuantity) rice portion(s)")
                        } else if page == .page4 {
                            Text(mainCourse)
                            Text("with \(breadType)")
                            Text("\(riceQuantity) rice portion(s)")
                            if !sideDishes.isEmpty {
                                Text("+ \(sideDishes.joined(separator: ", "))")
                            }
                        } else if page == .page5 {
                            Text(mainCourse)
                            Text("with \(breadType)")
                            Text("\(riceQuantity) rice portion(s)")
                            if !sideDishes.isEmpty {
                                Text("+ \(sideDishes.joined(separator: ", "))")
                            }
                        }
                    }
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
                .foregroundStyle(Color.white)
            }
            
            if page == .page5 {
                Label("Order Placed", systemImage: "checkmark")
                    .frame(height: 40)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial, in: .capsule)
            }
            
            // Interactive controls based on current page
            if page == .page3 {
                // Rice quantity controls
                HStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Image(.rice)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        Text("\(riceQuantity) portion(s)")
                            .font(.system(size: 14, weight: .semibold))
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    ActionButton(true, isUpdatingRice: true)
                    ActionButton(false, isUpdatingRice: true)
                }
                .foregroundStyle(Color.white)
            } else if page == .page4 {
                // Side dishes selection with images
                VStack(alignment: .leading, spacing: 12) {
                    Text("Side Dishes")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(Self.sideDishOptions, id: \.self) { dish in
                            SideDishButton(
                                dish: dish,
                                isSelected: sideDishes.contains(dish)
                            )
                        }
                    }
                }
            }
        }
        .padding(15)
        .background {
            LinearGradient(colors: [Color(red: 0.91, green: 0.22, blue: 0.22), Color(red: 0.95, green: 0.35, blue: 0.15)], startPoint: .leading, endPoint: .trailing)
                .clipShape(.containerRelative)
        }
    }
    
    @ViewBuilder
    func getMainCourseImage() -> some View {
        if mainCourse == "Butter Chicken" {
            Image(.butterChicken)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if mainCourse == "Paneer Tikka" {
            Image(.paneerTikka)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if mainCourse == "Dal Makhani" {
            Image(.dalMakhani)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if mainCourse == "Chicken Tikka" {
            Image(.chickenTikka)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if mainCourse == "Mixed Vegetables" {
            Image(.mixedVegetables)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else {
            // Fallback for debugging - show a colored circle with text
            ZStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 80, height: 80)
                VStack {
                    Text("?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("\(mainCourse)")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    @ViewBuilder
    func getBreadImage() -> some View {
        if breadType == "Naan" {
            Image(.naan)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if breadType == "Roti" {
            Image(.roti)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if breadType == "Paratha" {
            Image(.paratha)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if breadType == "Kulcha" {
            Image(.kulcha)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else if breadType == "Bhatura" {
            Image(.bhatura)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else {
            // Fallback for debugging - show a colored circle with text
            ZStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 80, height: 80)
                VStack {
                    Text("?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("\(breadType)")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    @ViewBuilder
    func ActionButton(_ isIncrement: Bool, isUpdatingRice: Bool = false) -> some View {
        Button(intent: ThaliActionIntent(isUpdatingRice: isUpdatingRice, isIncremental: isIncrement)) {
            Image(systemName: isIncrement ? "plus" : "minus")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(width: 60)
                .frame(height: 40)
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: isIncrement ? 30 : 10,
                        bottomLeadingRadius: isIncrement ? 30 : 10,
                        bottomTrailingRadius: isIncrement ? 10 : 30,
                        topTrailingRadius: isIncrement ? 10 : 30,
                        style: .continuous
                    ).fill(.ultraThinMaterial)
                }
        }
        .buttonStyle(.plain)
    }
    
    static let sideDishOptions: [String] = [
        "Raita",
        "Pickle", 
        "Papad",
        "Salad",
        "Curd",
        "Chutney"
    ]
}

struct SideDishButton: View {
    var dish: String
    var isSelected: Bool
    
    var body: some View {
        Button(intent: ThaliActionIntent(
            isUpdatingRice: false,
            isIncremental: !isSelected,
            sideDish: dish
        )) {
            VStack(spacing: 4) {
                getSideDishImage()
                
                Text(dish)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .orange : .white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .white.opacity(0.2) : .black.opacity(0.5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .white : .clear, lineWidth: 2)
                    }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func getSideDishImage() -> some View {
        switch dish {
        case "Raita":
            Image(.raita)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        case "Pickle":
            Image(.pickle)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        case "Salad":
            Image(.salad)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        case "Curd":
            Image(.curd)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        case "Chutney":
            Image(.chutney)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        default:
            Image(.raita)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
} 
