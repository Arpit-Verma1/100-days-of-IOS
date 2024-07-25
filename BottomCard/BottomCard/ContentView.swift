//
//  ContentView.swift
//  BottomCard
//
//  Created by arpit verma on 25/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var cardDismissable = false
    @State var showCard = false
    var body: some View {
        ZStack{
            Button(action: {
                cardDismissable.toggle()
                showCard.toggle()
                
            }, label: {
                Text("Show Card").bold().foregroundColor(.white).padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            BottomCard(cardShown: $showCard, cardDismissal: $cardDismissable ){
                CardContent()
            }
        }
    }
}
struct CardContent:View{
    var body:some View{
        VStack{
            Text("Hello World")
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct BottomCard<Content:View>:View{

    @Binding var cardShown:Bool
    @Binding var cardDismissal:Bool
    let content:Content
    init(cardShown:Binding<Bool>, cardDismissal:Binding<Bool>,@ViewBuilder content:()->Content){
    _cardShown = cardShown
        _cardDismissal = cardDismissal
        self.content = content()
    }
    var body:some View{
        ZStack{
            GeometryReader{ _ in
                EmptyView()
            }.background(Color.red.opacity(cardShown ? 0.5 : 0))
                .animation(Animation.easeInOut).onTapGesture{
                    cardShown.toggle()
                }
            VStack{
                Spacer()
                VStack(spacing:0){
                    content
                }.background(Color.white)
            }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
