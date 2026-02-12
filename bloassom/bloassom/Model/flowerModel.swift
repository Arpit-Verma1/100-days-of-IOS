//
//  flowerModel.swift
//  bloassom
//
//  Created by Arpit Verma on 2/8/26.
//

import Foundation

struct Flower: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let imageName: String
    let category: String
    let acceptsBonuses: Bool
}


enum FlowerSample {
    static let list: [Flower] = [
        Flower(
            id: "1",
            name: "Florist's Special",
            price: 49.99,
            description: "A curated mixed bouquet with seasonal blooms.",
            imageName: "fl1",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "2",
            name: "Flowers In A Box",
            price: 59.99,
            description: "Elegant red roses in a keepsake box.",
            imageName: "fl2",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "3",
            name: "Flowers In Basket",
            price: 54.99,
            description: "Multi-colored bouquet in a woven basket.",
            imageName: "fl3",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "4",
            name: "Classic Bouquet",
            price: 44.99,
            description: "Timeless arrangement for any occasion.",
            imageName: "fl4",
            category: "Bouquets",
            acceptsBonuses: false
        ),
        Flower(
            id: "5",
            name: "Garden Fresh",
            price: 39.99,
            description: "Fresh-picked garden style arrangement.",
            imageName: "fl5",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "6",
            name: "Pastel Dreams",
            price: 47.99,
            description: "Soft pastel flowers for a gentle touch.",
            imageName: "fl6",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "7",
            name: "Sunshine Mix",
            price: 42.99,
            description: "Bright and cheerful mixed bouquet.",
            imageName: "fl7",
            category: "Bouquets",
            acceptsBonuses: false
        ),
        Flower(
            id: "8",
            name: "Elegant Roses",
            price: 64.99,
            description: "Premium long-stem roses in a vase.",
            imageName: "fl8",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "9",
            name: "Wild Meadow",
            price: 45.99,
            description: "Natural wildflower-style arrangement.",
            imageName: "fl9",
            category: "Bouquets",
            acceptsBonuses: true
        ),
        Flower(
            id: "10",
            name: "Lavender Bliss",
            price: 52.99,
            description: "Calming lavender and soft blooms.",
            imageName: "fl10",
            category: "Bouquets",
            acceptsBonuses: true
        )
    ]
}
