//
//  AppleOnboarding.swift
//  onboardingPage
//
//  Created by Arpit Verma on 7/14/25.
//

import SwiftUI

struct AppleOnboarding: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


struct AppleOnboardingCard : Identifiable {
    var id : String = UUID().uuidString
    var symbol : String
    var title : String
    var subtitle : String
}

@resultBuilder
struct OnBoardingCardResultBuilder {
    static func buildBlock(_ components:AppleOnboardingCard...) ->[AppleOnboardingCard] {
        
        components.compactMap{ $0 }
    }
}

struct AppleOnboardingView <Icon: View , Footer : View> : View {
    var tint : Color
    var title : String
    var icon : Icon
    var cards: [AppleOnboardingCard]
    var footer: Footer
    var onContinue : ()-> ()
    
    init(tint: Color,
         title: String,
         @ViewBuilder icon:   @escaping ()-> Icon,
         @OnBoardingCardResultBuilder cards:@escaping ()-> [AppleOnboardingCard],
         @ViewBuilder footer: @escaping ()-> Footer,
         onContinue: @escaping () -> Void)
    {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.footer = footer()
        self.onContinue = onContinue
        
        self._animatedCards = .init(initialValue: Array(repeating: false, count: self.cards.count))
    }
    
    @State private var animatedIcon : Bool = false
    @State private var animatedTitle : Bool = false
    @State private var animatedCards : [Bool]
    @State private var animatedFooter : Bool = false
    
    
    var body : some View {
        VStack (spacing: 6) {
            ScrollView(.vertical) {
                VStack(alignment: .leading,spacing: 20) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animatedIcon)
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .blurSlide(animatedTitle)
                    
                    CardView()
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
            VStack (spacing: 0) {
                footer
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,4)
                    
                }
                .tint(tint)
                .buttonStyle(.borderedProminent)
                
                
                
            }
            .blurSlide(animatedFooter)
        }
        
        .frame(maxWidth: 330)
        .interactiveDismissDisabled()
        .allowsHitTesting(animatedFooter)
        .task {
            
            guard  !animatedIcon
            else { return }
            await delayedAnimation(0.35) {
                animatedIcon = true
            }
            await delayedAnimation(0.35) {
                animatedTitle = true
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            
            for index in animatedCards.indices {
                let delay = Double(index)*0.1
                await delayedAnimation(delay) {
                    animatedCards[index] = true
                }
            }
            await delayedAnimation(0.35) {
                animatedFooter = true
            }
        }
        
    }
    
    @ViewBuilder
    func CardView () -> some View {
        Group  {
            ForEach (cards.indices , id : \.self) { index in
                HStack (alignment: .top, spacing: 20  ) {
                    let card  = cards [index]
                    HStack (alignment: .top,spacing: 12) {
                        Image(systemName: card.symbol)
                            .font(.title2)
                            .foregroundStyle(tint)
                            .symbolVariant(.fill)
                            .frame(width : 45)
                            .offset(y : 10)
                        
                        VStack (alignment: .leading,spacing: 6){
                            Text(card.title)
                                .font(.title3)
                                .lineLimit(1)
                            
                            Text(card.subtitle)
                                .font(.title3)
                                .lineLimit(2)
                        }
                        
                    }
                    .blurSlide(animatedCards[index])
                    
                  
                }
                
            }
        }
    }
    
    func delayedAnimation(_ delay: Double, action : @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.smooth){
            action()
        }
        
    }
}

extension View {
    @ViewBuilder
    func blurSlide (_ show : Bool ) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y : show ? 0 : 100 )
    }
}


#Preview {
    ContentView()
}
