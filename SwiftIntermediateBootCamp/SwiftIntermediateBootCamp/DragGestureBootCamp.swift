//
//  DragGestureBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 10/11/24.
//

import SwiftUI

struct DragGestureBootCamp: View {
    @State var offset : CGSize = .zero
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 300,height :500)
            .offset(offset)
            .scaleEffect(getScaleAmount())
            .rotationEffect(Angle(degrees: getAngleAmount()))
            .gesture(
                
                DragGesture()
                    .onChanged({ value in
                        withAnimation {
                            offset = value.translation
                        }
                    })
                    .onEnded({ value in
                        offset = CGSize(width: 0, height: 0)
                    })
            )
    }
    func getScaleAmount () -> CGFloat {
        let max = UIScreen.main.bounds.width/2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage,0.5)*0.5
    }
    func getAngleAmount () -> Double {
        
        let max = UIScreen.main.bounds.width/2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle : Double = 10
        return percentageAsDouble*maxAngle
        
    }
}


struct DragGestureBootCamp2  : View {
    @State var startingOffsetY : CGFloat = UIScreen.main.bounds.height*0.85
    @State var currentDragOffset : CGFloat = 0
    @State var endingDragOffset : CGFloat = 0
    
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            SignUpView()
                .offset(y:startingOffsetY)
                .offset(y : currentDragOffset)
                .offset(y:endingDragOffset)
                .gesture(DragGesture(
                    
                )
                    .onChanged({ value in
                        withAnimation(.spring) {
                            currentDragOffset = value.translation.height
                        }
                    })
                        .onEnded({ value in
                            withAnimation(.spring) {
                                if currentDragOffset < -150
                                {
                                    endingDragOffset = -startingOffsetY
                                    currentDragOffset = 0
                                }
                                else if endingDragOffset != 0 && currentDragOffset > 150
                                {
                                    endingDragOffset = 0
                                    currentDragOffset = 0
                                }
                                else {
                                    currentDragOffset = 0
                                }
                                
                            }
                        })
                )
            
            
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SignUpView : View {
    var body: some View {
        VStack {
            Image(systemName: "chevron.up")
                .padding(.top)
            Text("Sign up")
                .font(.headline)
                .fontWeight(.semibold)
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("this is sample text")
                Text("create an account")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .background(Color.black.cornerRadius(10))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
       
    }
}


#Preview {
    DragGestureBootCamp2()
}
