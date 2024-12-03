//
//  coredataBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 01/12/24.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [FruitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits() {
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }
    }
    
    func addFruit(text: String) {
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveFruits()
    }
    func deleteFruit(indexset : IndexSet) {
    guard let index = indexset.first else { return }
        let fruitToDelete = savedEntities[index]
        container.viewContext.delete(fruitToDelete)
        saveFruits()
    }
    
    func updateFruit(entity: FruitEntity) {
        let currentName = entity.name ?? ""
        entity.name = currentName + "!" 
        saveFruits()
    }
    
    func saveFruits() {
        do {
            try container.viewContext.save()
            fetchFruits()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
}

struct coredataBootCamp: View {
    @StateObject var vm = CoreDataViewModel()
    @State private var textFieldText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding()
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                }) {
                    Text("Add Fruit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(vm.savedEntities) { entity in
                        Text(entity.name ?? "Unknown Fruit"  )
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }.onDelete(perform: vm.deleteFruit)
                }
            }
            .navigationTitle("Fruits")
        }
    }
}

#Preview {
    coredataBootCamp()
}

