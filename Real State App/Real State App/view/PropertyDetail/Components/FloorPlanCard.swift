//
//  FloorPlanCard.swift
//  Real State App
//
//  Created by Arpit Verma on 1/14/26.
//

import SwiftUI

struct FloorPlanCard: View {
    var floorImage: String
    var floorNumber: Int
    var namespace: Namespace.ID
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            if !isSelected {
                Image(floorImage)
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 4)
                    .frame(width: 200, height: 150)
                    .matchedGeometryEffect(id: "floorPlan_\(floorImage)", in: namespace)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray)
                    )
            } else {
                Color.clear
                    .frame(width: 200, height: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray.opacity(0.3))
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
