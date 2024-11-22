//
//  ContentView.swift
//  coreDataBootCamp
//
//  Created by Arpit Verma on 16/11/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @FetchRequest(entity: FruitEntity.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \FruitEntity.name, ascending: false)
        
    ])
    private var fruits: FetchedResults<FruitEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(fruits) { fruit in
                    Text(fruit.name ?? "")
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("fruits")
            .navigationBarItems(leading:  Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            })
            
            
        }
    }

    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = "apple"
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }
    private func saveItems () {
        

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
