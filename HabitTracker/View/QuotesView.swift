//
//  QuotesView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 21/4/25.
//

import SwiftUI

struct QuotesView: View {
    
    @State private var animate = false
    let quote = QuoteManager.getRandomQuote()
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🌟 Quote of the Day")
                .font(.title3).bold()

            Text("“\(quote.text)”")
                .italic()
                .bold()
                .font(.body)

            Text("- \(quote.author)")
                .font(.caption)
                .foregroundColor(.primary.opacity(0.98))
        }
        .padding()
        .background(Color(red: 1.0, green: 0.98, blue: 0.94))
        .cornerRadius(10)
        .padding(.horizontal)
        .opacity(animate ? 1 : 0)
                .scaleEffect(animate ? 1 : 0.5)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8)) {
                        animate = true
                    }
                }
    }
}


#Preview {
    QuotesView()
}

