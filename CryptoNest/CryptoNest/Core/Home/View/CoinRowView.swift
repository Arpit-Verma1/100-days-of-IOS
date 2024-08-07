//
//  CoinRowView.swift
//  CryptoNest
//
//  Created by arpit verma on 07/08/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin : CoinModel
    let showHodingCoulumn :Bool
    var body: some View {
       HStack (spacing:0){
        leftColumn
        Spacer()
        if showHodingCoulumn {
            centerColumn
        }
        rightColumn
       }.font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHodingCoulumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHodingCoulumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
extension CoinRowView {
    private var centerColumn : some View {
        VStack(alignment:.trailing){
            Text(coin.currentHoldingsValue.asCurrencyWithDecials())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text((coin.currentHoldings ?? 0).asNumberString())
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    private var rightColumn : some View {
        VStack {
            Text(coin.currentPrice.asCurrencyWithDecials())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text((coin.marketCap?.asCurrencyWithDecials())!)
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(.trailing)
    }
    
    
    private var leftColumn : some View {
        HStack {
            Text("\(coin.rank)")
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 40)
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.theme.accent)
               
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
        }
    }
}

