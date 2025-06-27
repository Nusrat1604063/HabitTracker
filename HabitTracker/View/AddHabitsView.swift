//
//  AddHabitsView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 22/4/25.
//

import SwiftUI
import CoreData

struct AddHabitsView: View {
    
    let viewContext: NSManagedObjectContext
    
    @State private var habitName: String = ""
    @State private var showVideoField = false
    @State private var videoLink: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    private func saveHabits() {
        let newHabit = Habit(context: viewContext)
        newHabit.name = habitName
        newHabit.isCompleted = false
        newHabit.id = UUID()
        newHabit.videoLink = videoLink
        
        
        do {
            try viewContext.save()
            print("Successfully Saved \(newHabit.name ?? "No Name")")
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("LightGreen")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("Habit Details").bold()) {
                        TextField("Enter your habit name", text: $habitName)
                            .padding(18)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                        Button(action: {
                            print("Added videoLink")
                            showVideoField.toggle()
                        }) {
                            HStack {
                                Text("You can add Video Link to boost motivation")
                                Spacer()
                                Image(systemName: "link")
                            }
                        }
                        if showVideoField {
                            TextField("Paste video link here", text: $videoLink)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                        }
                        Button(action: {
                            
                            saveHabits()
                            dismiss()
                            
                        }) {
                            Text("Save Habit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Gold")) // Make sure "Gold" is in your assets
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        Spacer()
                    }
                    .padding(10)
                    
                    //TODO add a video preview on the habit details.
                    
                    
                }
                
            }
            
        }
    }
}

#Preview {
    AddHabitsView(viewContext: .init())
}

