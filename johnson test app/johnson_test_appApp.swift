//
//  johnson_test_appApp.swift
//  johnson test app
//
//  Created by johnson on 31/08/24.
//

import SwiftUI

@main
struct johnson_test_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
