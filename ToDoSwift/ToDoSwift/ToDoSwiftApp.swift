//
//  ToDoSwiftApp.swift
//  ToDoSwift
//
//  Created by arpit verma on 16/07/24.
//

import SwiftUI

@main
struct ToDoSwiftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
