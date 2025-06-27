//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 21/4/25.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let provider = CoreDataProvider()
    
    var body: some Scene {
        WindowGroup {
          NavigationStack {
              Contentview(
                context: provider.viewContext,
                dataProvider: provider
              )
            }
        }
    }
}

