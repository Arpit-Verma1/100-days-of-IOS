//
//  filterSheetView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/10/26.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: HomePageViewModel
    @Environment(\.dismiss) var dismiss
    
    let bedRoomOptions = ["Any", "1", "2", "3", "4+"]
    @State private var selectedBedRoom : String = "Any"
    let bathRoomOptions = ["Any", "1", "2", "3", "4+"]
    @State private var selectedbathRoom : String = "Any"
    private let barData: [CGFloat] = {
        var data: [CGFloat] = []
        for i in 0..<35 {
            let x = Double(i - 25) / 5.0
            let height = exp(-pow(x, 2) / 2.0) * 0.8 + Double.random(in: 0.1...0.2)
            data.append(CGFloat(height))
        }
        return data
    }()
    
    private var filteredCount: Int {
        viewModel.allProperties.filter { property in
//             Bedrooms filter
            if let beds = viewModel.selectedBedrooms {
                if beds >= 4 {
                    if property.bedCount < 4 { return false }
                } else {
                    if property.bedCount != beds { return false }
                }
            }
            
            // Bathrooms filter
            if let baths = viewModel.selectedBathrooms {
                if baths >= 4 {
                    if property.bathCount < 4 { return false }
                } else {
                    if property.bathCount != baths { return false }
                }
            }
            
            // Price range filter
            if property.monthlyRent < viewModel.minPrice || property.monthlyRent > viewModel.maxPrice {
                return false
            }
            
//             FHA eligible filter
            if viewModel.fhaEligibleOnly && !property.fhaEnable {
                return false
            }
            
            // Single story filter
            if viewModel.singleStoryOnly && !property.singleSotry {
                return false
            }
            
            return true
        }.count
    }
    
    var body: some View {
        
        
        VStack(alignment:.leading ,spacing: 10) {
            HStack(alignment: .center) {
                Text("Filters")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 28))
                    .foregroundColor(.black)
                Spacer()
                Button {
                    viewModel.showFilterSheet = false
                } label: {
                    Image(systemName: "xmark")
                        
                        .foregroundColor(.black)
                }
                .padding(.trailing , 10)
            }
                
           
                Text("Bedrooms")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                    .foregroundColor(.black.opacity(0.5))
                
                SlidingSegmentedControlView(selected: $selectedBedRoom, options: bedRoomOptions)
                
                Text("Bathrooms")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                    .foregroundColor(.black.opacity(0.5))
                
                SlidingSegmentedControlView(selected: $selectedbathRoom, options: bathRoomOptions)
                Spacer()
                .frame(height: 10)
                HStack {
                    Text("Price range")
                        .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                        .foregroundColor(.black.opacity(0.5))
                    
                    Spacer()
                    
                    Text("Avg. price is $\(viewModel.averagePrice.formatted())")
                        .font(.custom("HelveticaNowDisplay-Bold", size: 13))
                        .foregroundColor(.black.opacity(0.3))
                }
            Spacer()
                .frame(height: 20)
            PropertyPriceSlider(barData: barData)
                .frame(height: 150)
            Spacer()
                .frame(height: 20)
                Text("More options")
                    .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                    .foregroundColor(.black)
                HStack {
                    Text("FHA eligible only")
                        .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                        .foregroundColor(.black.opacity(0.3))
                    
                    Toggle("", isOn: $viewModel.fhaEligibleOnly)
                        .toggleStyle(SwitchToggleStyle(tint: .black))
                }
                HStack {
                    Text("Single story only")
                        .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                        .foregroundColor(.black.opacity(0.3))
                    
                    Toggle("", isOn: $viewModel.singleStoryOnly)
                        .toggleStyle(SwitchToggleStyle(tint: .black))
                }
            Spacer()
                .frame(height: 10)
           
            GlossyButton(text: "Show \(filteredCount) results", action: {
                viewModel.applyFilters()
                viewModel.showFilterSheet = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.showSnackbar = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        viewModel.showSnackbar = false
                    }
                }
            })
            
                
            }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        
    }
}


#Preview {
    FilterSheetView(viewModel: HomePageViewModel())
        .padding()
}

import SwiftUI
