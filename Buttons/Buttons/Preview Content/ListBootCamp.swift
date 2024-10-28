//
//  ListBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 27/10/24.
//

import SwiftUI

struct ListBootCamp: View {
    @State var fruits: [String] = ["Apple", "Mango", "Banana"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Fruit List")) {
                    ForEach(fruits, id: \.self) { fruit in
                        Text(fruit)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .navigationTitle("Grocery List")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    fruits.append("coconut")
                }, label: {
                    Text("Add")
                })
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
        fruits.remove(atOffsets: offsets)
    }
    func move ( index :IndexSet, newOffset :Int) {
        fruits.move(fromOffsets: index, toOffset: newOffset)
    }
    
}

#Preview {
    ListBootCamp()
}

