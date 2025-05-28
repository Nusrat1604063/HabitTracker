//
//  CoreDataProvider+HabitLogic.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 7/5/25.
//

import Foundation
import CoreData

extension CoreDataProvider {
    func storeCompletedDays(for habit: Habit) {
        let calendar = Calendar.current
        let today = Date()

        // 1. Pull out your completeDates as a Swift [Date], or start with []
        var datesArray = (habit.completeDates as? [Date]) ?? []

        // 2. Check if today is already in that array
        let alreadyMarked = datesArray.contains {
            calendar.isDate($0, inSameDayAs: today)
        }

        // 3. If not, append today and write back to the Core Data property
        if !alreadyMarked {
            datesArray.append(today)
            habit.completeDates = datesArray as NSObject
            habit.lastCompletedDate = today
            objectWillChange.send()      // This is because SwiftUI doesn't know that viewModel.habits changed. As @published var on;y triggers Ui when the array reference itself chnages. That's why progressbar wasn't updating, this is the solution to it.
            habit.isCompleted = true

            // 4. Save context
            do {
                try viewContext.save()
            } catch {
                print("Failed to save completed date: \(error)")
            }
        }
    }
    
    func updateStreakCount(for habit: Habit) {
            let calendar = Calendar.current
            // Normalize “today” to midnight to compare only dates
            let today = calendar.startOfDay(for: Date())

            // Grab your stored dates (or empty array if nil), normalized to midnight
            let rawDates = (habit.completeDates as? [Date]) ?? []
            let completedDays: Set<Date> = Set(rawDates.map { calendar.startOfDay(for: $0) })

            var streak = 0
            var dayToCheck = today

            // Count backwards while the set contains each consecutive day
            while completedDays.contains(dayToCheck) {
                streak += 1
                guard let previous = calendar.date(byAdding: .day, value: -1, to: dayToCheck) else {
                    streak = 0
                    break
                }
                dayToCheck = previous
            }

            // Assign the result
            habit.streakCount = Int16(streak)
           
            // Persist
            do {
                try viewContext.save()
            } catch {
                print("Failed to save updated streakCount: \(error)")
            }
        }
}

/* habit.completeDates = NSMutableArray()

Core Data stores transformable attributes as NSObject under the hood, so when you assign something like [Date], it complains because [Date] is a Swift struct array, not an Objective-C class like NSArray.
 */

