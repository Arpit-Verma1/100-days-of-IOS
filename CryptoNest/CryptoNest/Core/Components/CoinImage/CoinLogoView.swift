//
//  CoinLogoView.swift
//  CryptoNest
//
//  Created by arpit verma on 16/08/24.
//

import SwiftUI

struct CoinLogoView: View {
    let coin : CoinModel
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

    struct CoinLogoView_Preview : PreviewProvider {
        static var previews: some View {
            CoinLogoView(coin: dev.coin)
        }
    }

