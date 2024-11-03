//
//  ContentUnavailableViewBootcamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

struct ContentUnavailableViewBootcamp: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                
                    "No internet",
                    systemImage : "wifi.slash",
                    description : Text("no internet availbale")
                )
        }
        else {
            
        }
    }
}

#Preview {
    ContentUnavailableViewBootcamp()
}
