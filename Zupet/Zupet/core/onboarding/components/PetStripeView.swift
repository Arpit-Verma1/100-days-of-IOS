//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI

struct PetStripeView: View {
    
    let pet: Pet
    let index: Int
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 25) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.black)
                        .offset(x: 4, y: 4)
                    RoundedRectangle(cornerRadius: 50)
                        .fill(pet.stripeColor)
                    
                    Image(pet.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
                
                Text(pet.name)
                    .font(.custom("HollaBear-Regular", size: 16))
                    .foregroundColor(Color.theme.textColor)
            }
            .scaleEffect(y: isVisible ? 1 : 0, anchor: .topLeading)
            .opacity(isVisible ? 1 : 0)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.85)
                    .delay(Double(index) * 0.15),
                value: isVisible
            )
            .onAppear {
                isVisible = true
            }
        }
    }
}

#Preview {
    HStack(spacing: 0) {
        PetStripeView(
            pet: Pet(
                name: "Coco",
                imageName: "pet_rocky",
                stripeColor: .orange,
                height: 250
            ),
            index: 0
        )
        PetStripeView(
            pet: Pet(
                name: "Coco",
                imageName: "pet_milo",
                stripeColor: .orange,
                height: 250
            ),
            index: 1
        )
        PetStripeView(
            pet: Pet(
                name: "Coco",
                imageName: "pet_coco",
                stripeColor: .orange,
                height: 250
            ),
            index: 2
        )
        PetStripeView(
            pet: Pet(
                name: "Coco",
                imageName: "pet_luna",
                stripeColor: .orange,
                height: 250
            ),
            index: 3
        )
    }
    .frame(height: 260)
}
