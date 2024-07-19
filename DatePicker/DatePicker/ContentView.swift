//
//  ContentView.swift
//  DatePicker
//
//  Created by arpit verma on 19/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedDate = Date()
    var body: some View {
        VStack {
            DatePicker("Date picker",selection:$selectedDate, in: Date()... )
                .datePickerStyle(
                    .wheel
                ).padding()
        
            DatePicker("Date picker",selection:$selectedDate, in: Date()... )
                .datePickerStyle(
                    .graphical
                ).padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
