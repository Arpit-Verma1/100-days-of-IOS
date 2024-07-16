//
//  ContentView.swift
//  To_do_app
//
//  Created by arpit verma on 16/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    @Environment(
        \.managedObjectContext
    ) var context
    @FetchRequest(
        fetchRequest: ToDoItem.getAllToDoListItems()
    )
    var items:FetchedResults<ToDoItem>
    var body: some View {
        NavigationView {
            List{
                Section(
                    header: Text(
                        "New Item"
                    )
                ){
                    HStack{
                        
                        TextField(
                            "enter new item",
                            text: $text
                        )
                        Button(action: {
                            if !text.isEmpty{
                                let newItem=ToDoItem(
                                    context: context
                                )
                                newItem.name=text
                                newItem.createdAt=Date()
                                do {
                                    try context.save()
                                    text=""
                            
                                }catch{
                                    print(error)
                                }
                            }
                        },
                               label: {
                            /*@START_MENU_TOKEN@*/Text(
                                "Save"
                            )/*@END_MENU_TOKEN@*/
                        })
                        
                    }
                }
                Section{
                    ForEach(
                        items
                    ){
                        toDoItem in
                        VStack (
                            alignment: .leading
                        ) {
                            Text(
                                toDoItem.name!
                            ).font(
                                .headline
                            )
                            Text(
                                "\(toDoItem.createdAt!)"
                            ).font(
                                .headline
                            )
                            
                        }
                    }.onDelete(
                    perform: {
                        indexSet in guard let index=indexSet.first else{
                            return
                        }
                        let itemTodelete = items[index]
                        context.delete(itemTodelete)
                        do {
                            try context.save()
                        }
                        catch {
                            print(error)
                        }
                    })
                }
            }.navigationTitle(
                "To do list"
            )
        }
    }
}

#Preview {
    ContentView()
}

