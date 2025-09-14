//
//  DeliveryAttributes.swift
//  orderWidget (App target)
//
//  Defines Live Activity attributes and content state mirrored in the widget target.
//

import Foundation
import ActivityKit

struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var latitude: Double
        var longitude: Double
        var showMap: Bool
        var isArrived: Bool
        var progress: Double // 0.0 to 1.0
        var startTime: Date
        var progressIndex : Int
    }

    var orderId: String
}



