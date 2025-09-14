//
//  SecondView.swift
//  ios_26
//
//  Created by Arpit Verma on 7/9/25.
//


import SwiftUI

struct SecondView: View {
    @State private var sliderValue: Double = 50
    @State private var pickerSelection: String = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
        Form {
            // Slider Section
            Section(header: Text("Adjust Intensity")) {
                Slider(value: $sliderValue, in: 0...100, step: 1) {
                    Text("Value")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                Text("Current: \(Int(sliderValue))")
                    .foregroundColor(.blue)
            }
            
            // Picker Section
            Section(header: Text("Select Option")) {
                Picker("Choose an option", selection: $pickerSelection) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Summary Section
            Section(header: Text("Current Selections")) {
                HStack {
                    Text("Selected Option:")
                    Spacer()
                    Text(pickerSelection)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Slider Value:")
                    Spacer()
                    Text("\(Int(sliderValue))")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Selection Screen")
        .navigationBarTitleDisplayMode(.inline)
    }
}