//
//  StreakCelebrationView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 14/5/25.
//

import SwiftUI
import UIKit

struct StreakCelebrationView: View {
    @Binding var isPresented: Bool
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.green.opacity(0.8).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🎉🎉🎉")
                    .font(.system(size: animate ? 80 : 50))  //animate is true on appear
                    .scaleEffect(animate ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5).repeatForever(autoreverses: true), value: animate)

                Text("Congratulations!")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                Text("7-Day Streak Unlocked!")
                    .font(.title2).bold()
                    .foregroundColor(.white)

                Button("Keep it going!") {
                    isPresented = false
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
            }
            .onAppear {
                animate = true
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    StreakCelebrationView(isPresented: .constant(true))
}

/*
 response: 0.6 → the stiffness or speed of the spring. Lower values = faster bounce.
 
 dampingFraction: 0.5 → how much it resists bouncing. 0 means infinite bounce, 1 means no bounce.
 
 .repeatForever(autoreverses: true) — this causes the animation to:

 Loop infinitely
 
 */
/*
 Most important -->
 📦 @Binding = shared control
 StreakCelebrationView does not own the isPresented value.

 The parent view owns it, and StreakCelebrationView just gets to read and write it.

 When isPresented = false inside this view → it tells the parent to dismiss this view.
 
 
 */
