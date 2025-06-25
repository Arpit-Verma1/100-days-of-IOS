//
//  AppIntents.swift
//  ios_26
//
//  Created by Arpit Verma on 6/25/25.
//

import SwiftUI

struct AppIntents: View {
    var body: some View {
        LatteOrderView()
    }
}

#Preview {
    AppIntents()
}

struct LatteOrderView: View  {
    var body : some View  {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 15) {
                Image(.latte)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                VStack(alignment: .leading,spacing: 4) {
                    
                    Text("Coffee")
                        .fontWeight(.semibold)
                        .font(.title)
                    Group {
                        Text("Large")
                        Text(
                            "20% Milk"
                        )
                    }
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    
                }
                .foregroundStyle(Color.white)
                
                
            }
            HStack(spacing: 8) {
                Text("2 Shots")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                ActionButton(false)
                ActionButton(true)
                
            }.foregroundStyle(Color.white)
            
        }.padding(15)
            .background {
                LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                    .clipShape(.containerRelative)
            }
    }
    
    
    @ViewBuilder
    func ActionButton(_ isIncrement : Bool) -> some View  {
        Button  {
        
        } label: {
            Image(systemName:  isIncrement ? "plus" : "minus")
            
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(width: 100)
                .frame(height: 40)
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: isIncrement ? 10 : 30,
                        
                        bottomLeadingRadius: isIncrement ?  10 : 30,
                        
                        bottomTrailingRadius: isIncrement ? 30 : 10,
                        
                        topTrailingRadius : isIncrement ? 30 : 10,
                        style : .continuous
        
                    ).fill(.ultraThinMaterial)
                }
        }
        .buttonStyle(.plain)

    }
    
}
