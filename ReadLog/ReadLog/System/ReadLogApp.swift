//
//  ReadLogApp.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI

@main
struct ReadLogApp: App {
    var body: some Scene {
        WindowGroup {
            BookDetailFull("newBook3")
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
