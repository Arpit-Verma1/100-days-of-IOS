//
//  StepperBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct StepperBootCamp: View {
    @State var stepperVlaue : Int = 10
    @State var widthIcrement : CGFloat = 0
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10
            
            ).frame(width: 100 + widthIcrement,height:100)
            Stepper("stepper s",
                    onIncrement: { onChnaged(amount: 10)},
                    onDecrement: {onChnaged(amount: -10)})
            
        }
    }
    func onChnaged(amount: CGFloat) {
        withAnimation() {
            widthIcrement =  widthIcrement + amount;

        }
            }
}

#Preview {
    StepperBootCamp()
}
