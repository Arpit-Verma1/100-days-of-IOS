//
//  StateProperty.swift
//  Buttons
//
//  Created by arpit verma on 26/10/24.
//

import SwiftUI

struct StateProperty: View {
    @State var backgroundColor:Color = Color.green
    @State var title :String = "this is smaple title"
    @State var count : Int = 1
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea(.all)
            VStack{
                Text("count is \(count)")
                Button("changecolor"){
                    self.backgroundColor = Color.red
                    self.count=count+1;
                }
            }.background(backgroundColor)
        }
    }
}

#Preview {
    StateProperty()
}
