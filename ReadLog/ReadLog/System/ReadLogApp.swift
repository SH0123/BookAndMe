//
//  ReadLogApp.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI

@main
struct ReadLogApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
