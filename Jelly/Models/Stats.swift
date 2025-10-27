//
//  Stats.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation

// D-007: Stats – wins, losses, rating, streak, history.
struct PlayerStats: Codable {
    let playerID: UUID
    var wins: Int
    var losses: Int
    var currentStreak: Int
    var bestStreak: Int
    var totalGames: Int
    var rating: Double
    
    init(
        playerID: UUID,
        wins: Int = 0,
        losses: Int = 0,
        currentStreak: Int = 0,
        bestStreak: Int = 0,
        totalGames: Int = 0,
        rating: Double = 1000.0 // Starting rating
    ) {
        self.playerID = playerID
        self.wins = wins
        self.losses = losses
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.totalGames = totalGames
        self.rating = rating
    }
    
    var winPercentage: Double {
        guard totalGames > 0 else { return 0 }
        return Double(wins) / Double(totalGames) * 100
    }
    
    var displayRecord: String {
        return "\(wins) - \(losses)"
    }
    
    var streakDisplay: String {
        if currentStreak > 0 {
            return "🔥 \(currentStreak) wins"
        } else if currentStreak < 0 {
            return "❄️ \(abs(currentStreak)) losses"
        }
        return "No streak"
    }
}

