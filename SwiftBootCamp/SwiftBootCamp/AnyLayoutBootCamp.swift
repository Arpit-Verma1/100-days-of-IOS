//
//  AnyLayoutBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

struct AnyLayoutBootCamp: View {
    @Environment (\.horizontalSizeClass) private var horizonatalClass
    @Environment (\.verticalSizeClass) private var verticalClass
    var body: some View {
        
        let layout : AnyLayout = horizonatalClass == .compact ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        layout {
            Text("a")
            Text("b")
            Text("c")
        }
        
        
        
        
        VStack {
            if horizonatalClass == .compact {
                VStack {
                    Text("a")
                    Text("b")
                    Text("c")
                }
            }
            else {
                HStack {
                    Text("a")
                    Text("b")
                    Text("c")		
                }
            }
        }
    }
}

#Preview {
    AnyLayoutBootCamp()
}
