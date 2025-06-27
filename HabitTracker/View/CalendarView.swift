//
//  CalenderView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 28/4/25.
//

import SwiftUI
import Foundation


struct MonthlyCalendarView: View {
    let calendar = Calendar.current // official  apple calender
    let today = Date() //current date
    
    let completeDates: [Date]
    
    var body: some View {
        let days = generateDaysForCurrentMonth()
        
        VStack {
            // Month title
            Text(currentMonthAndYear())
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            // Days of the week header
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            
            // Dates
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {  //lays out items in a grid, vertically. A flexible column — the width can expand or shrink to fit available space.
                ForEach(days, id: \.self) { date in // Loop through the days array (which contains Date? values — some dates, some nil).
                    if let date = date {    //Check if the current item is a real date (not nil).
                        Text("\(calendar.component(.day, from: date))") //If it’s a real date, show the day number (like 1, 2, 3...)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                calendar.isDate(date, inSameDayAs: today) ? Color.blue.opacity(0.5) :
                                completeDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) ? Color.green.opacity(0.6) :
                                Color.clear
                            )
                            .clipShape(Circle())
                    } else {
                        // Empty placeholder for alignment
                        Text("")
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    
    func generateDaysForCurrentMonth() -> [Date?] {
        var days: [Date?] = [] //because sometimes we will add nil for blank cells (alignment).
        
        let components = calendar.dateComponents([.year, .month], from: today) //Extract the year and month components from today's date.
        guard let startOfMonth = calendar.date(from: components) else { return days } //gives you the first day of the month.
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!  // range of valid days in the month..Example: In April, the days are 1 to 30 ➔ range = 1-30.
        let numberOfDays = range.count
        
        let weekdayOfFirst = calendar.component(.weekday, from: startOfMonth) //Find out which day of the week the month starts on
        
        // Add empty slots before the first day to align
        let leadingEmptyDays = weekdayOfFirst - calendar.firstWeekday //Calculate how many empty spaces to leave before the first date.
        
       // _ means we don't care about the index — we just want to do something X times.
        var numberOfEmptyDays = leadingEmptyDays //First, calculate how many empty days you need (and fix it if it’s negative)
        if numberOfEmptyDays < 0 {
            numberOfEmptyDays += 7
        }

        for _ in 0..<numberOfEmptyDays { //Then use that simple numberOfEmptyDays inside the for loop.
            days.append(nil)
        }

        
        // Add all days of the month
        for day in 1...numberOfDays {           // Now loop through each day of the month: 1, 2, 3, ..., 30.
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    func currentMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyy"
        return formatter.string(from: today)
    }
}


#Preview {
    MonthlyCalendarView(completeDates: [Date(), Date(), Date()])
}


/*
 So for day 1, you need to add 0 days → (1 - 1 = 0)

 For day 2, you add 1 day → (2 - 1 = 1)

 For day 3, you add 2 days → (3 - 1 = 2)

 That’s why we do day - 1, to start at 0 days offset, not 1 day ahead!
 */

