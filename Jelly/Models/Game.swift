//
//  Game.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation

// D-005: Game – opponent IDs, court, date/time, rules, status.
struct Game: Identifiable, Codable {
    let id: UUID
    let challengerID: UUID  // Who sent the challenge
    let opponentID: UUID    // Who is being challenged
    let opponentName: String
    let courtName: String
    let courtAddress: String
    let scheduledDate: Date
    let rules: String       // e.g., "First to 21", "Best of 3"
    var status: GameStatus
    var winnerID: UUID?
    var loserID: UUID?
    var challengerScore: Int?
    var opponentScore: Int?
    var isConfirmed: Bool
    var createdAt: Date
    
    enum GameStatus: String, Codable {
        case pending    // Challenge sent, waiting for acceptance
        case accepted   // Accepted, scheduled
        case completed  // Game finished, scores recorded
        case canceled   // Game was canceled
        case disputed   // Scores don't match
        
        var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .accepted: return "Scheduled"
            case .completed: return "Completed"
            case .canceled: return "Canceled"
            case .disputed: return "Disputed"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        challengerID: UUID,
        opponentID: UUID,
        opponentName: String,
        courtName: String,
        courtAddress: String,
        scheduledDate: Date,
        rules: String = "First to 21",
        status: GameStatus = .pending,
        winnerID: UUID? = nil,
        loserID: UUID? = nil,
        challengerScore: Int? = nil,
        opponentScore: Int? = nil,
        isConfirmed: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.challengerID = challengerID
        self.opponentID = opponentID
        self.opponentName = opponentName
        self.courtName = courtName
        self.courtAddress = courtAddress
        self.scheduledDate = scheduledDate
        self.rules = rules
        self.status = status
        self.winnerID = winnerID
        self.loserID = loserID
        self.challengerScore = challengerScore
        self.opponentScore = opponentScore
        self.isConfirmed = isConfirmed
        self.createdAt = createdAt
    }
    
    var isUpcoming: Bool {
        return status == .accepted && scheduledDate > Date()
    }
    
    var isPast: Bool {
        return scheduledDate < Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: scheduledDate)
    }
}

