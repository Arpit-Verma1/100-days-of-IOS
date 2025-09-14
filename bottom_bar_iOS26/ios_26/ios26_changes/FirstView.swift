//
//  FirstView.swift
//  ios_26
//
//  Created by Arpit Verma on 7/9/25.
//


import SwiftUI

struct FirstView: View {
    @State private var textInput: String = ""
    @State private var isToggleOn: Bool = false
    @State private var stepperValue: Int = 0
    @State private var showSecondView: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Text Field Section
                Section(header: Text("Text Input")) {
                    TextField("Enter your text here", text: $textInput)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Toggle Section
                Section(header: Text("Toggle Setting")) {
                    Toggle("Enable Feature", isOn: $isToggleOn)
                        .tint(.blue)
                }
                
                // Stepper Section
                Section(header: Text("Quantity Selector")) {
                    Stepper(value: $stepperValue, in: 0...10) {
                        Text("Quantity: \(stepperValue)")
                    }
                }
                
                // Button Section
                Section {
                    Button(action: {
                        showSecondView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Continue")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationTitle("Input Screen")
            .navigationDestination(isPresented: $showSecondView) {
                SecondView()
            }
        }
    }
}