
//
//  Contentview.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 21/4/25.
//

import SwiftUI
import CoreData

struct Contentview: View {

    @StateObject private var viewModel : HabitViewModel
    
    init(context: NSManagedObjectContext, dataProvider: CoreDataProvider) {
            _viewModel = StateObject(wrappedValue: HabitViewModel(context: context, dataProvider: dataProvider))
        }


    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit? = nil
    @Environment(\.scenePhase) var scenePhase   //gives you the current state of your app's UI scene
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                if viewModel.habits.isEmpty {
                    ContentUnavailableView("No Habits Yet!", systemImage: "list.bullet.rectangle",
                                           description:
                                            Text("Add your first habit's to get Started")
                        .bold()
                    )
                    
                } else {
                    ProgressBar(progress: viewModel.showProgress())
                    List {
                        ForEach(viewModel.habits, id: \.id) { habit in
                            NavigationLink(value: habit) {
                                HabitRow(habit: habit) {
                                     //1,2 works as onTogle when the user taps the button
                                    viewModel.completeHabit(habit)
                                    
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: viewModel.deleteHabits)
                    }
                    .navigationDestination(for: Habit.self) { habit in
                        HabitDetailView(habit: habit)
                    }

                    .listStyle(.plain)

                    Spacer()
                    QuotesView()
                        .shadow(color: Color("Gold").opacity(0.3), radius: 8, x: 0, y: 4)
                    Spacer()
                }
            }
            .navigationTitle("Today's Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                            .bold()
                    }
                }
                
            }
            .sheet(isPresented: $showingAddHabit, onDismiss: {
                viewModel.fetchHabits()
            }) {
                AddHabitsView(viewContext: viewModel.context)
            }
            
        }.onChange(of: scenePhase) {oldphase, newPhase in
            if newPhase == .active {
                viewModel.resetHabitsIfNewDay()
            }
        }

  
    }
    
}


#Preview {
    let previewProvider = CoreDataProvider.preview
    let context = previewProvider.viewContext

    NavigationStack {
        Contentview(
            context: context,
            dataProvider: previewProvider
        )
    }
}

    
    /*
     In SwiftUI, if you pass a plain Core Data object (Habit) into a View like this:
     HabitRow(habit: habit) { ... }
     then SwiftUI does not track changes individually inside the list properly,
     because it needs constant IDs and proper data binding (@ObservedObject).
     */
    
    /*Assigning a tag to the NavigationLink solves the pressed effect problem by ensuring the correct navigation occurs based on the selected item, allowing for seamless, programmatic navigation when the item is tapped.*/
    
    /*Save data when going to background
     
     Refresh data when returning to foreground
     
     Reset state or trigger UI updates when active */
    
    
    /*.onAppear only runs when a view appears, not every time the user returns to the app.
     
     scenePhase works even if the app stays on the same screen and just moves in/out of foreground.*/
    
    //viewModel    The actual HabitViewModel instance you use in your views
    
    //_viewModel    The StateObject wrapper that manages the lifecycle and updates



/*
 ViewModel initializer
 @StateObject → tells SwiftUI to manage the lifecycle of the viewModel.
 
 wrappedValue: HabitViewModel(...) → lets you create your view model with needed parameters.
 
 _viewModel = StateObject(...) → necessary workaround because @StateObject can’t be initialized inline with arguments.
 */

