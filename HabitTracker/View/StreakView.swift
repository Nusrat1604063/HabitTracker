//
//  StreakView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 14/5/25.
//

import SwiftUI


struct StreakView: View {
    @State var habit: Habit
    var body: some View {
        VStack {
        ProgressBar(progress: showprogress())
        }
    }
    
    func showprogress() -> Double {
        let completeDays = habit.streakCount
        let totalWeekdays = 7
        let progress = completeDays == 0 ? 0 : Double(completeDays) / Double(totalWeekdays)
        return progress
    }
    

    
}

#Preview {
    //StreakView()
}

