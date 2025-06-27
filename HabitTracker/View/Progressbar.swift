//
//  Progressbar.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 24/4/25.
//


import SwiftUI

struct ProgressBar: View {
    var progress: Double // value from 0.0 to 1.0
    
    private let totalWidth = UIScreen.main.bounds.width * 0.8

    var body: some View {
        ZStack (alignment: .leading){
            Capsule()
                .frame(width: totalWidth, height: 30)
                .foregroundColor(Color.gray.opacity(0.2))
                
            Capsule()
                .frame(width: totalWidth * progress, height:30)
                .foregroundColor(.green)
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .padding(.horizontal) // Keeps it centered
    }
}


#Preview {
    ProgressBar(progress: 2.0)
}

