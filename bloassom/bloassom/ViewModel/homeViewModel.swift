//
//  homeViewModel.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import Foundation
import Combine

struct CartItem: Identifiable {
    let id = UUID()
    let flower: Flower
    var quantity: Int
}

final class HomeViewModel: ObservableObject {
    @Published var favourites: [Flower] = []
    @Published var cartList: [CartItem] = []

    init(favourites: [Flower] = [], cartList: [CartItem] = []) {
        self.favourites = favourites
        self.cartList = cartList
    }

    var favouriteFlowers: [Flower] {
        favourites
    }
    func isFavourite(_ flower: Flower) -> Bool {
        favourites.contains { $0.id == flower.id }
    }

    func toggleFavourite(_ flower: Flower) {
        if let index = favourites.firstIndex(where: { $0.id == flower.id }) {
            favourites.remove(at: index)
        } else {
            favourites.append(flower)
        }
    }

    func addToCart(flower: Flower, quantity: Int = 1) {
        if let index = cartList.firstIndex(where: { $0.flower.id == flower.id }) {
            cartList[index].quantity += quantity
        } else {
            cartList.append(CartItem(flower: flower, quantity: quantity))
        }
    }
}
