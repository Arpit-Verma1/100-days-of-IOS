//
//  ContentView.swift
//  orderWidget
//
//  Created by Arpit Verma on 9/7/25.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @StateObject private var viewModel = DeliveryViewModel()
    @State private var quantity: Int = 1

    var body: some View {
        ZStack {
            
            VStack {
                Image(.momo2)
                    .resizable()
                    .frame(width: 410, height: 250)
                    .ignoresSafeArea()
                Spacer()
            }
            
             VStack(spacing: 0) {
                 // Top rounded corner container with restaurant info
                 VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("WOW! Momo")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "info.circle")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("3.9")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("By 900+")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("2.4 km • Ardee City")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("25-30 mins • Schedule for later")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Items starting @ ₹99 only")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("8 offers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
                
                // Static delivery time
               
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("Estimated delivery: 25-30 minutes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(Color(.systemBackground))
                
                // Food item card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            // Non-veg indicator
                            HStack {
                                Rectangle()
                                    .fill(Color.brown)
                                    .frame(width: 8, height: 8)
                                    .cornerRadius(2)
                                Text("Chicken Darjeeling Steam Momo")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            
                            // Highly reordered indicator
                            HStack {
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 20, height: 3)
                                    .cornerRadius(1.5)
                                Text("Highly reordered")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Price section
                            HStack {
                                Text("₹259")
                                    .font(.subheadline)
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                                Text("Get for ₹99")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            // Description
                            Text("Momo stuffed with mix of soft juicy boneless chicken, onion & coriander cooked in bamboo steamer...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            
                            // Coupon eligibility
                            Text("NOT ELIGIBLE FOR COUPONS")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Food image placeholder
                        
                            Image(.momo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100) // square size
                                
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.orange)
                       
                        .overlay(
                            // Quantity selector
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    HStack(spacing: 8) {
                                        Button(action: { quantity = max(1, quantity - 1) }) {
                                            Image(systemName: "minus")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text("\(quantity)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(minWidth: 20)
                                        
                                        Button(action: { quantity += 1 }) {
                                            Image(systemName: "plus")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red)
                                    .cornerRadius(8)
                                }
                                .offset(y: 20)
                                .padding(10)
                                
                            }
                        )
                    }
                    
                    Text("customisable")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer()
                
                // Bottom order button
                
                Button(action: { viewModel.startDemo(quantity: quantity) }) {
                    HStack {
                        Text("\(quantity) item added")
                            .fontWeight(.medium)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                
                .disabled(!ActivityAuthorizationInfo().areActivitiesEnabled)
                 .padding(.horizontal, 20)
                 
             }
             .frame(height: UIScreen.main.bounds.height * 0.6)
             .background(Color(.systemBackground))
             .cornerRadius(20, corners: [.topLeft, .topRight])
             .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
             .overlay(content: {
                 Image(.wow)
                     .resizable()
                         .scaledToFill()
                         .frame(width: 60, height: 60) // square size
                         .clipShape(RoundedRectangle(cornerRadius: 12)) // rounded corners
                         .overlay(
                             RoundedRectangle(cornerRadius: 12)
                                 .stroke(Color.white, lineWidth: 2) // optional border
                         )
                         .offset(y:-280)
             })
           
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView()
}
