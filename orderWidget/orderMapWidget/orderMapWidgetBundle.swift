//
//  orderMapWidgetBundle.swift
//  orderMapWidget
//
//  Created by Arpit Verma on 9/7/25.
//

import WidgetKit
import SwiftUI

@main
struct orderMapWidgetBundle: WidgetBundle {
    var body: some Widget {
        orderMapWidget()
        orderMapWidgetControl()
        orderMapWidgetLiveActivity()
    }
}
