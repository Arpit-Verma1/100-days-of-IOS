//
//  DetailRowView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/19/26.
//

import SwiftUI

struct DetailRowView: View {
    @State var yearModel: YearModel
    var body: some View {
        VStack(spacing: 5) {
            // Row 2
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
            
            // Row 3
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
            
            // Row 4
            DropCappedTextView(dropCap: String(yearModel.ratroCar.description.prefix(1)), remainingText: String(yearModel.ratroCar.description.dropFirst()))
                .padding(20)
                .frame(maxHeight: 400)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(yearModel.color)
                )
        }
    }
}


#Preview {
    DetailRowView(yearModel:  sampleYear)
}
