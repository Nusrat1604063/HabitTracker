///
//  HabitRow.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 21/4/25.
//
//https://www.youtube.com/watch?v=eshbZrGOHC8
import SwiftUI

struct HabitRow: View {
    @ObservedObject var habit: Habit
    var onToggle: () -> Void

    var body: some View {
        HStack {
            Text("✨ \(habit.name ?? "No name")")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                if !habit.isCompleted {
                    print("✅ Toggled: \(habit.name ?? "Unknown")")
                    print("✅ Toggled to : \(habit.isCompleted)")
                    onToggle()
                }
            }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(habit.isCompleted ? .green : .gray)
                    .scaleEffect(habit.isCompleted ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: habit.isCompleted)
            }
            .buttonStyle(PlainButtonStyle()) // Prevents default button tap area interference
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}


#Preview {
   // HabitRow(habit: Habit("Pray Fajr", isCompleted: false), onToggle: { }, )
}

