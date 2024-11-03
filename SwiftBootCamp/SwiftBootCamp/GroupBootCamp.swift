//
//  GroupBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct GroupBootCamp: View {
    var body: some View {
        VStack{
            Text("text1")
            Group{
                Text("text")
                Text("text")
            }
            .foregroundColor(.red)
            .padding()
            .background(.green)
        }
    }
}

#Preview {
    GroupBootCamp()
}
