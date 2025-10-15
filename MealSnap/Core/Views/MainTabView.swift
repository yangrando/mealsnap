//
//  MainTabView.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 06/10/25.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    let context: NSManagedObjectContext

    var body: some View {
        TabView {
            MealEntryView(context: context)
                .tabItem {
                    Label("tab_new_meal", systemImage: "plus.circle.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("tab_history", systemImage: "list.bullet")
                }
        }
    }
}

