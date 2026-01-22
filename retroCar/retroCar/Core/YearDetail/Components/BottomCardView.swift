//
//  BottomCardView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/18/26.
//

import SwiftUI

struct BottomCardView: View {
    @State var yearModel: YearModel
    var body: some View {
        HStack {
            VStack(spacing: 10) {
                Rectangle()
                    .frame(height: 2)
                Rectangle()
                    .frame(height: 2)
            }
            .padding(20)
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex:"#bc1d2f"))
                   
            )
            
           
            HStack(spacing: 0) {
                VStack(alignment: .leading,spacing: 0) {
                    Text("Artwork & story by")
                        .font(.system(size: 12))
                        
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(yearModel.user.fname.prefix(1))
                            .font(Font.custom("rolf", size: 25))
                        Text(yearModel.user.fname.dropFirst())
                            .font(Font.custom("rolf", size: 22))
                        Spacer()
                            .frame(width: 5)
                        Text(yearModel.user.sname.prefix(1))
                            .font(Font.custom("rolf", size: 25))
                        Text(yearModel.user.sname.dropFirst())
                        .font(Font.custom("rolf", size: 22))}
                    
                }
                Spacer()
                Image(yearModel.user.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60,height: 60)
                    .clipShape(.circle)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 80)
            .frame(width: .infinity, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(yearModel.color)
            )
        }
    }
}


#Preview {
    BottomCardView(yearModel:  sampleYear)
}
