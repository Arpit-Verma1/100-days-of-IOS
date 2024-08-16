//
//  PortfolioView.swift
//  CryptoNest
//
//  Created by arpit verma on 16/08/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText : String = ""
    @State private var showCheckmark: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XmarkView()
                }
                ToolbarItem(placement : .navigationBarTrailing){
                   trailingNavBarViewButton
                }
            })
            
        }
    }
}



struct Portfolio_Preview : PreviewProvider {
    static var previews: some View {
        PortfolioView().environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var  coinLogoList : some View {
        ScrollView(.horizontal , showsIndicators: false, content: {
            LazyHStack(spacing: 10){
                ForEach(vm.AllCoins) { coin in
                    CoinLogoView(coin : coin).frame(
                        width: 75
                    ).padding(  4).onTapGesture {
                        withAnimation(.easeIn) {
                            selectedCoin = coin
                        }
                    }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.green : Color.clear, lineWidth: 1)
                            
                        )
                
                }
            }.frame(height : 120)
                .padding(.leading)
    
        })
    }
    private func  getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return (quantity * (selectedCoin?.currentPrice ?? 0))
    }
    
    private var portfolioInputSection :some View {
        VStack (spacing : 20 ) {
            HStack {
                Text( "Current price of \(selectedCoin!.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWithDecials() ?? "")
            }
            Divider()
            HStack {
                Text("Amount Holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                   
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWithDecials())
            }
            .animation(.none)
            .padding()
            .font(.headline)
            
        }
    }
    
    private var trailingNavBarViewButton : some View {
        HStack (spacing : 10){
            Image(systemName: "checkmark").opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {}, label:{ Text("Sava".uppercased())}).opacity((selectedCoin != nil && selectedCoin?.currentHoldings  != Double(quantityText)) ? 1.0 : 0.0)
         
        }.font(.headline)
    }
    
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        showCheckmark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
               
            }
        }
    }
    
    private func removeSelectedCoin () {
        selectedCoin = nil
        quantityText = ""
    }
    
    
}
            

