//
//  AppIntents.swift
//  ios_26
//
//  Created by Arpit Verma on 6/25/25.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    var body: some View {
      Text("Hey")
    }
}

#Preview {
    ContentView()
}


enum  LatteOrderPage : String  {
    case page1 = "Updating Milk Percetage"
    case page2 =  "Updatig Latte Ammount"
    case page3 = "Order Finished"
        
}


struct LatteOrderView: View  {
    var count : Int
    var milkPercentage : Int
    var page : LatteOrderPage
    var choice: LocalizedStringResource
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
                        Text(choice)
                        if page == .page2 {
                            Text(
                                "\(milkPercentage)% Milk"
                            )
                        }
                        if page == .page3 {
                            HStack {
                                Text(
                                    "\(milkPercentage)% Milk"
                                )
                                Text(
                                    " | \(count)% Shots"
                                )
                            }
                        }
                    }
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    
                }
                .foregroundStyle(Color.white)
                
                
                
            }
            
            if page == .page3 {
                Label("Order Placed", systemImage:"checkmark")
                    .frame(height: 40)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial, in:.capsule)
            }
            HStack(spacing: 8) {
                Group {
                    if page == .page2 {
                        Text("\(count) shots")
                    }
                    if page == .page1 {
                        Text("\(milkPercentage)% milk")
                    }
                }
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
        Button (intent: LatteActionIntent(isUpdatingPercentage: page == .page1, isIncremental: isIncrement))
    {
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
