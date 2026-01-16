//
//  homePageViewModal.swift
//  Real State App
//
//  Created by Arpit Verma on 1/10/26.
//

import Foundation
import SwiftUI
import Combine


class HomePageViewModel: ObservableObject {
    @Published var allProperties: [PropertyModel] = sampleProperties
    @Published var filteredProperties: [PropertyModel] = sampleProperties
    
    // Filter properties
    @Published var selectedBedrooms: Int? = nil // nil means "Any"
    @Published var selectedBathrooms: Int? = nil // nil means "Any"
    @Published var minPrice: Int = 300
    @Published var maxPrice: Int = 12000
    @Published var fhaEligibleOnly: Bool = false
    @Published var singleStoryOnly: Bool = false
    
    // UI State
    @Published var showFilterSheet: Bool = false
    @Published var showSnackbar: Bool = false
    
   
    
    // Calculate average price
    var averagePrice: Int {
        guard !filteredProperties.isEmpty else {
            guard !allProperties.isEmpty else { return 0 }
            let total = allProperties.reduce(0) { $0 + $1.monthlyRent }
            return total / allProperties.count
        }
        let total = filteredProperties.reduce(0) { $0 + $1.monthlyRent }
        return total / filteredProperties.count
    }
    
    // Apply filters
    func applyFilters() {
        filteredProperties = allProperties.filter { property in
            // Bedrooms filter
            if let beds = selectedBedrooms {
                if beds >= 4 {
                    if property.bedCount < 4 { return false }
                } else {
                    if property.bedCount != beds { return false }
                }
            }
            
            // Bathrooms filter
            if let baths = selectedBathrooms {
                if baths >= 4 {
                    if property.bathCount < 4 { return false }
                } else {
                    if property.bathCount != baths { return false }
                }
            }
            
            // Price range filter
            if property.monthlyRent < minPrice || property.monthlyRent > maxPrice {
                return false
            }
            
            // FHA eligible filter
            if fhaEligibleOnly && !property.fhaEnable {
                return false
            }
            
            // Single story filter
            if singleStoryOnly && !property.singleSotry {
                return false
            }
            
            return true
        }
    }
    
    // Reset filters
    func resetFilters() {
        selectedBedrooms = nil
        selectedBathrooms = nil
        minPrice = 300
        maxPrice = 12000
        fhaEligibleOnly = false
        singleStoryOnly = false
        applyFilters()
    }
}