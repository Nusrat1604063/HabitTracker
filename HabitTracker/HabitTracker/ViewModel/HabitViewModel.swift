//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 22/5/25.
//

import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    let context: NSManagedObjectContext
    let dataProvider: CoreDataProvider

    init(context: NSManagedObjectContext, dataProvider: CoreDataProvider) {
        self.context = context
        self.dataProvider = dataProvider
        fetchHabits()
    }
    
    func fetchHabits() {
            let request: NSFetchRequest<Habit> = Habit.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.name, ascending: true)]
            do {
                habits = try context.fetch(request)
            } catch {
                print("Failed to fetch habits: \(error)")
                habits = []
            }
        }
    
    // Function to show progress
    func showProgress() -> Double {
        let completedHabits = habits.filter { $0.isCompleted }.count
        let totalHabits = habits.count
        return totalHabits == 0 ? 0 : Double(completedHabits) / Double(totalHabits)
    }

    // Reset habits if it's a new day
    func resetHabitsIfNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for habit in habits {
            if let lastDate = habit.lastCompletedDate {
                let lastCompletedDay = calendar.startOfDay(for: lastDate)
                if lastCompletedDay < today {
                    habit.isCompleted = false
                }
            } else {
                habit.isCompleted = false
            }
        }

        saveContext()
        fetchHabits()
        //showProgress()
    }
 
    // Save context
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

    // Delete habit
    func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            let habitToDelete = habits[index]
            context.delete(habitToDelete)
        }
        saveContext() // Save after deleting
        fetchHabits()  //@Published var habits only notifies the UI when it’s explicitly reassigned
        showProgress()
    }

    // Update streak
    func updateStreakCount(for habit: Habit) {
        dataProvider.updateStreakCount(for: habit)
    }
    
    // Store completion date
    func storeCompletedDays(for habit: Habit) {
        dataProvider.storeCompletedDays(for: habit)
    }
    
    func completeHabit(_ habit: Habit) {
        dataProvider.storeCompletedDays(for: habit)
        dataProvider.updateStreakCount(for: habit)
        fetchHabits()  // Re-fetch habits so updated state is reflected
    }

}

#Preview {
    //HabitViewModel()
}





