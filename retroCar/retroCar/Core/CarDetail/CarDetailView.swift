//
//  CarDetailView.swift
//  retroCar
//
//  Created by Arpit Verma on 12/29/25.
//

import Foundation
import SwiftUI

struct CarDetailView : View {
    @State var yearModel : YearModel
    var body : some View {
        ZStack {
            Color.theme.backgrounColor.ignoresSafeArea()
            VStack(spacing: 5) {
                carNamedetailView
                carModelDetailView
                carSimilarityView
                carDescriptionView
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        
    }
    
    private var carNamedetailView : some View {
        HStack(alignment:.lastTextBaseline, spacing: 5) {
            Text(yearModel.ratroCar.carCompany)
                .font(Font.custom("newston", size: 93))
            Text(yearModel.ratroCar.modelName)
                .font(Font.custom("rolf", size: 50))
            Image(systemName: "arrow.down")
                .font(.system(size: 30,weight: .bold))
        }
        .padding(10)
        .padding(.vertical, -10)
        .frame(maxWidth : .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(yearModel.color))
    }
    
    private var carModelDetailView : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Model code/ number")
                    .font(.system(size: 11,weight: .bold))
                Text(yearModel.ratroCar.modelCode)
                    .font(Font.custom("TuskerGrotesk-2500Medium", size: 45))
                
            }
            .padding(20)
            .frame(maxWidth : .infinity,alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#8eab5f")))
            VStack(alignment: .leading) {
                Text("Size of tire")
                    .font(.system(size: 12,weight: .bold))
                Text(yearModel.ratroCar.sizeOfTire)
                    .font(Font.custom("TuskerGrotesk-2500Medium", size:43,))
            }
            .padding(20)
            .frame(maxWidth : .infinity,alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#e77f80")))
        }
    }
    
    private var carSimilarityView : some View {
        VStack(alignment: .leading , spacing: 0) {
            VStack(alignment : .leading,spacing: 0) {
                Text("Similar type")
                    .font(.system(size: 12,weight: .bold))
                Text(yearModel.ratroCar.similarType)
                    .font(Font.custom("rolf", size: 37,))
                
            }
            .padding(.bottom, 15)
            
            Rectangle()
                .fill(.black)
                .frame(height: 2)
            
            HStack {
                VStack(alignment: .leading,spacing: 10) {
                    Text("Similar type")
                        .font(.system(size: 12,weight: .bold))
                    
                    Text(yearModel.ratroCar.similarType2)
                        .font(Font.custom("TuskerGrotesk-2500Medium", size: 50,))
                    
                }
                .padding(.top , 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                Rectangle()
                    .fill(.black)
                    .frame(width: 2, height: 120)
                
                
                VStack(alignment: .leading,spacing: 0){
                    Text("Wheel size")
                        .font(.system(size: 12,weight: .bold))
                    HStack(alignment: .lastTextBaseline) {
                        Text(yearModel.ratroCar.wheelSize)
                            .font(Font.custom("rolf", size: 33,))
                        Text("ROUNDS")
                            .font(Font.custom("rolf", size: 28,))
                    }
                }
                .padding(.top , 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex:"#bc1d2f")))
    }
    private var carDescriptionView : some View {
        DropCappedTextView(dropCap: String(yearModel.ratroCar.description.prefix(1)), remainingText: String(yearModel.ratroCar.description.dropFirst()))
            .padding(20)
            .frame(maxHeight: 400)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(yearModel.color)
            )
            .ignoresSafeArea(.all)
    }
    
}



#Preview {
    CarDetailView(
        yearModel:   sampleYear
    )
}
