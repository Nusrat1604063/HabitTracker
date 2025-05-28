//
//  QuoteManager.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 21/4/25.
//

import Foundation
struct QuoteManager {
    static func getRandomQuote() -> Quote {
        let quotes = QuoteSeeder.quotes
        return quotes.randomElement() ?? Quote(text: "Keep going!", author: "Anonymous")
    }
}

