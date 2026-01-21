//
//  YearCarView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/18/26.
//
import SwiftUI

struct YearCardView: View {
    let yearModel: YearModel
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(yearModel.year.uppercased())
                .font(Font.custom("rolf", size: 55))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .matchedGeometryEffect(id: "year-\(yearModel.id)", in: namespace)
            Rectangle()
                .fill(.black)
                .frame(height: 2)
                .padding(.top, 5)
                .matchedGeometryEffect(id: "line-\(yearModel.id)", in: namespace)
            Spacer()
            Text(yearModel.ratroCar.carCompany)
                .font(Font.custom("newston", size: 65))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .matchedGeometryEffect(id: "company-\(yearModel.id)", in: namespace)
            Text(yearModel.ratroCar.modelName)
                .font(Font.custom("rolf", size: 40))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .matchedGeometryEffect(id: "model-\(yearModel.id)", in: namespace)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(yearModel.color)
                .matchedGeometryEffect(id: "card-\(yearModel.id)", in: namespace)
        )
    }
}
