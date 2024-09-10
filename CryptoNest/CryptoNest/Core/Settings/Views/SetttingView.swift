//
//  SetttingView.swift
//  CryptoNest
//
//  Created by arpit verma on 31/08/24.
//

import SwiftUI

struct SettingView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let personalURL = URL(string: "https://arpit-verma1.github.io/ArpitVerma.dev/")!
    let coingecoURL = URL (string : "https://www.coingecko.com/")!
    let repoURL = URL( string: "https://github.com/Arpit-Verma1/100-days-of-IOS/tree/master/CryptoNest")!
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.theme.background.ignoresSafeArea()
                List{
                    aboutSection.listRowBackground(Color.theme.background.opacity(0.5))
                    coingeckoSection.listRowBackground(Color.theme.background.opacity(0.5))
                    developerSection.listRowBackground(Color.theme.background.opacity(0.5))
                }
            }
            
            .font(.headline)
            .accentColor(Color.theme.accent)
            .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        XmarkView()
                    }
                }
        }
    }
}

#Preview {
    SettingView()
}

extension SettingView {
    private var aboutSection : some View{
        Section(header: Text("About App")){
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(
                        width: 100,
                        height: 100
                    ).clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is made with Swift using SwiftUI Framework. It uses MVVM architecture pattern and Combine Framework for data fetching.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }.padding(.vertical)
            Link(destination: repoURL, label: {
                Text("App Repo Link")
            })
            
        }
    }
    
    private var coingeckoSection : some View{
        Section(header: Text("Coin Gecko")){
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(
                    
                        height: 100
                    ).clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app contain API data from CoinGecko Free API")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }.padding(.vertical)
            Link(destination: coingecoURL, label: {
                Text("Visit CoinGecko 🦎")
            })
            
        }
    }
    
    private var developerSection : some View{
        Section(header: Text("About Developer")){
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(
                    
                        height: 100
                    ).clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is made by Arpit Verma with 🩵 swift & Flutter")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }.padding(.vertical)
            Link(destination: personalURL, label: {
                Text("Visit  Portfolio 😎")
            })
            
        }
    }
    
}
