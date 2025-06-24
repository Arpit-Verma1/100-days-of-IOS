//
//  foundationModel2.swift
//  ios_26
//
//  Created by Arpit Verma on 24/06/25.
//

import SwiftUI
import FoundationModels

struct foundationModel2: View {
    @State private var todos : [Todo] = []
    @State private var isWriting : Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos){ todo in
                    Text(todo.task)
                }
            }.navigationTitle("Todo")
                .toolbar {
                    ToolbarItem(placement : .topBarTrailing) {
                        Button("", systemImage: "apple.intelligence"){
                            let prompt = "Create 10 todo list item"
                            Task {
                                do {
                                    let session = LanguageModelSession()
                                    let response = session.streamResponse( generating: [Todo].self) {
                                        prompt
                                    }
                                    isWriting = true
                                    
                                    for try await chunkTodos in response {
                                        self.todos = chunkTodos.compactMap( {
                                            if let id = $0.id , let task = $0.task {
                                                return .init(id: id, task : task)
                                            }
                                            return nil
                                                
                                        })
                                    }
                                }
                                catch {
                                    print("error is \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
        }
    }
}

@Generable
struct Todo: Identifiable {
    var id : String
    var task : String
}

#Preview {
    foundationModel2()
}
