//
//  ThaliTestView.swift
//  ios_26
//
//  Created by Arpit Verma on 6/27/25.
//

import SwiftUI
import AppIntents

struct ThaliTestView: View {
    var body: some View {
        VStack(spacing: 25) {
            // Header with thali preview
            VStack(spacing: 15) {
                HStack(spacing: 20) {
                    // Main dish preview
                    Image(.butterChicken)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    // Bread preview
                    Image(.naan)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    // Rice preview
                    Image(.rice)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                Text("Thali Combo Builder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Interactive Indian Thali Ordering")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            // Order button
            Button(intent: OrderThaliIntent()) {
                HStack(spacing: 12) {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.orange)
                        .font(.title2)
                    Text("Order Thali Combo")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    LinearGradient(colors: [.orange.opacity(0.1), .red.opacity(0.1)], 
                                 startPoint: .leading, 
                                 endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.orange.opacity(0.3), lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            
            // Side dishes preview
            VStack(spacing: 10) {
                Text("Customize Your Thali")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(["Raita", "Pickle", "Papad", "Salad", "Curd", "Chutney"], id: \.self) { dish in
                        VStack(spacing: 4) {
                            Image(systemName: "circle.fill")
                                .font(.title3)
                                .foregroundStyle(.orange.opacity(0.6))
                            Text(dish)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 50)
                    }
                }
            }
            .padding(.horizontal)
            
            Text("Tap to start building your perfect thali!")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ThaliTestView()
} 