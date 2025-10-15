//
//  MealSnapApp.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 23/09/25.
//

import SwiftUI
import CoreData

@main
struct MealSnapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
