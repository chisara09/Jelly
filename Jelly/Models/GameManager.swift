//
//  GameManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Mock data for development
    private let mockGames: [Game] = [
        Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Marcus Johnson",
            courtName: "Central Park Courts",
            courtAddress: "123 Main St, New York",
            scheduledDate: Date().addingTimeInterval(86400 * 2), // 2 days from now
            rules: "First to 21",
            status: .accepted
        ),
        Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Jamal Smith",
            courtName: "Brooklyn Heights",
            courtAddress: "456 Oak Ave, Brooklyn",
            scheduledDate: Date().addingTimeInterval(86400 * 5), // 5 days from now
            rules: "Best of 3",
            status: .accepted
        )
    ]
    
    init() {
        // Load mock data for now
        games = mockGames
    }
    
    func getAllGames() -> [Game] {
        return games
    }
    
    func getUpcomingGames() -> [Game] {
        return games.filter { $0.isUpcoming }
    }
    
    func getCompletedGames() -> [Game] {
        return games.filter { $0.status == .completed }
    }
    
    func getPendingGames() -> [Game] {
        return games.filter { $0.status == .pending }
    }
    
    func createChallenge(to opponentID: UUID, opponentName: String, courtName: String, courtAddress: String, scheduledDate: Date, rules: String) -> Game? {
        errorMessage = nil
        
        // Validate inputs
        guard !courtName.isEmpty, !courtAddress.isEmpty, !rules.isEmpty else {
            errorMessage = "Couldn't send."
            return nil
        }
        
        // In production, this would make an API call
        // For now, create a local game
        let newGame = Game(
            challengerID: UUID(), // Current user's ID
            opponentID: opponentID,
            opponentName: opponentName,
            courtName: courtName,
            courtAddress: courtAddress,
            scheduledDate: scheduledDate,
            rules: rules,
            status: .pending
        )
        
        games.append(newGame)
        return newGame
    }
    
    func updateGameStatus(_ gameID: UUID, status: Game.GameStatus) {
        if let index = games.firstIndex(where: { $0.id == gameID }) {
            games[index].status = status
        }
    }
    
    func recordScore(gameID: UUID, winnerID: UUID, loserID: UUID, winnerScore: Int, loserScore: Int) {
        errorMessage = nil
        
        guard let index = games.firstIndex(where: { $0.id == gameID }) else {
            errorMessage = "Couldn't save score."
            return
        }
        
        // In production, make API call
        // Simulate potential failure
        if let error = tryRecordScore() {
            errorMessage = "Couldn't save score."
            return
        }
        
        games[index].status = .completed
        games[index].winnerID = winnerID
        games[index].loserID = loserID
        games[index].challengerScore = winnerID == games[index].challengerID ? winnerScore : loserScore
        games[index].opponentScore = winnerID == games[index].opponentID ? winnerScore : loserScore
        games[index].isConfirmed = false
    }
    
    func confirmScore(gameID: UUID) {
        errorMessage = nil
        
        guard let index = games.firstIndex(where: { $0.id == gameID }) else {
            errorMessage = "Couldn't send confirmation."
            return
        }
        
        // In production, make API call
        // Simulate potential failure
        if let error = tryConfirmScore() {
            errorMessage = "Couldn't send confirmation."
            return
        }
        
        games[index].isConfirmed = true
    }

    func disputeScore(gameID: UUID) {
        errorMessage = nil
        
        guard let index = games.firstIndex(where: { $0.id == gameID }) else {
            errorMessage = "Couldn't resolve."
            return
        }
        
        // In production, make API call
        // Simulate potential failure
        if let error = tryDisputeScore() {
            errorMessage = "Couldn't resolve."
            return
        }
        
        games[index].status = .disputed
        games[index].isConfirmed = false
    }
    
    // Simulate network failures for demo purposes
    private func tryRecordScore() -> String? {
        let shouldFail = arc4random_uniform(100) < 5 // 5% chance
        return shouldFail ? "Network error" : nil
    }
    
    private func tryConfirmScore() -> String? {
        let shouldFail = arc4random_uniform(100) < 5 // 5% chance
        return shouldFail ? "Network error" : nil
    }
    
    private func tryDisputeScore() -> String? {
        let shouldFail = arc4random_uniform(100) < 5 // 5% chance
        return shouldFail ? "Network error" : nil
    }
}

