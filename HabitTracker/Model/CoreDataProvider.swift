//
//  HabitDataManager.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 25/4/25.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataProvider : ObservableObject {
   
    let persistentContainer : NSPersistentContainer //coredata container that managese model
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview : CoreDataProvider = {
        let provider  = CoreDataProvider(inMemory: true)
        let viewContext = provider.viewContext
        
        let habit1 = Habit(context: viewContext)
        habit1.name = "Reading"
        habit1.id = UUID()
       
        let habit2 = Habit(context: viewContext)
        habit2.name = "Cooking"
        habit2.id = UUID()
       
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        
        return provider
    }()
    
    init (inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "HabitModel")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
    persistentContainer.loadPersistentStores { desccription, error in
            if let error = error {
                fatalError("Core Data store failed to load:  \(error)")
            }
        }
    }
    
    
}



//inmemory true ==> Data is stored in RAM(memory only)
//it’s deleted when the app quits
//→ Used for testing, previews, or demo data

//inMemory = false → ✅ Normal mode (Default)
//→ Your data is stored on the device’s storage (e.g., saved between app launches, real database file on disk)

