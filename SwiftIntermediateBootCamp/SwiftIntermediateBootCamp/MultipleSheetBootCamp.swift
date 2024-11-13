//
//  MultipleSheetBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 14/11/24.
//

import SwiftUI

class RandomModel: Identifiable {
   let id  = UUID().uuidString
    var title: String
    init(title: String) {
        self.title = title
    }
}

struct MultipleSheetBootCamp: View {
    
    /// when we try to update content of sheet to show but the sheet show updated content on 2nd sime
    /// this is becuase sheet build first
    /// to solve this we have 3option
    /// 1) use binding
    /// 2) attach sheeet with each button
    /// 3) use $item
    
    
    
    @State var selectedModel: RandomModel?
    var body: some View {
        ScrollView
        {
            VStack(spacing: 20) {
                ForEach(0..<50) {
                    index in
                    Button {
                        selectedModel = RandomModel(title: "\(index)")
                    } label: {
                    Text("\(index)")
                    }

                }
            }.sheet(item: $selectedModel) { model in
                NextScreen(model: model)
            }
        }
    }
}
struct NextScreen :View {
    let  model:RandomModel
    var body: some View {
        Text(model.title)
    }
}


#Preview {
    MultipleSheetBootCamp()
}
