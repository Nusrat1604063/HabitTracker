//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 9/5/25.
//

import SwiftUI
import UserNotifications

struct HabitDetailView: View {
    @ObservedObject var habit: Habit
    @State private var showCongrats = false
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("✨ \(habit.name ?? "No name")")
                    .font(.largeTitle)
                    .bold()
                    .ignoresSafeArea(.keyboard)
                
                Text("🔥 Streak: \(habit.streakCount) day\(habit.streakCount == 1 ? "" : "s")")
                    .font(.headline)
                    .foregroundColor(.green)
                
                StreakView(habit: habit)
                
                if let link = habit.videoLink,
                   let embedURL = getYouTubeEmbedURL(from: link) {
                    GeometryReader { geometry in
                        VideoWebView(videoURL: embedURL)
                            .frame(width: geometry.size.width, height: geometry.size.width * 9 / 16)
                            .clipped()
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .frame(height: UIScreen.main.bounds.width * 9 / 16)
                    .padding(.horizontal, 16) // 👈 Left and right padding
                    .padding(.vertical)
                    
                    
                }
                
                let completed = (habit.completeDates as? [Date]) ?? []
                MonthlyCalendarView(completeDates: completed)
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showCongrats) {
                StreakCelebrationView(isPresented: $showCongrats)
            }
            .onAppear {
                
                if habit.streakCount == 7 && UIApplication.shared.applicationState == .active {
                    showCongrats = true
                    print("Triggered from onAppear — showing streak celebration")
                }
                
                
                print("Habit streak at appear: \(habit.streakCount)")
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound]) { _, _ in }
            }
        }
    }

    // MARK: Helpers

    private func getYouTubeEmbedURL(from urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }

        if url.absoluteString.contains("embed") {
            return url
        }
        if url.host?.contains("youtu.be") == true {
            let videoID = url.lastPathComponent
            return URL(string: "https://www.youtube.com/embed/\(videoID)")
        }
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems,
           let videoID = queryItems.first(where: { $0.name == "v" })?.value {
            return URL(string: "https://www.youtube.com/embed/\(videoID)")
        }
        return nil
    }

    private func sendStreakNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎊 7-Day Streak!"
        content.body = "You nailed a week of consistency. Keep up the great work!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "streak7Notification",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}

