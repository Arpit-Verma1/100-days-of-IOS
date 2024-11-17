//
//  coreDataBootCampApp.swift
//  coreDataBootCamp
//
//  Created by Arpit Verma on 16/11/24.
//

import SwiftUI

@main
struct coreDataBootCampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
