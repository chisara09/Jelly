//
//  StatsManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore

class StatsManager {
    private let db = Firestore.firestore()
    
    func getStats(userId: String) async throws -> PlayerStats {
        let doc = try await db.collection("stats").document(userId).getDocument()
        
        guard let data = doc.data() else {
            // Return default stats if not found
            let playerId = UUID(uuidString: userId) ?? UUID()
            return PlayerStats(playerID: playerId)
        }
        
        let playerId = UUID(uuidString: userId) ?? UUID()
        
        return PlayerStats(
            playerID: playerId,
            wins: data["wins"] as? Int ?? 0,
            losses: data["losses"] as? Int ?? 0,
            currentStreak: data["currentStreak"] as? Int ?? 0,
            bestStreak: data["bestStreak"] as? Int ?? 0,
            totalGames: data["totalGames"] as? Int ?? 0,
            rating: data["rating"] as? Double ?? 1000.0
        )
    }
    
    func updateStatsAfterGame(winnerID: String, loserID: String) async throws {
        do {
            // Get current ratings
            let winnerDoc = try await db.collection("stats").document(winnerID).getDocument()
            let loserDoc = try await db.collection("stats").document(loserID).getDocument()
            
            let winnerData = winnerDoc.data() ?? [:]
            let loserData = loserDoc.data() ?? [:]
            
            let winnerRating = winnerData["rating"] as? Double ?? 1000.0
            let loserRating = loserData["rating"] as? Double ?? 1000.0
            
            // Calculate ELO rating change
            let kFactor = 32.0
            let expectedWinner = 1.0 / (1.0 + pow(10.0, (loserRating - winnerRating) / 400.0))
            let expectedLoser = 1.0 - expectedWinner
            
            let winnerChange = kFactor * (1.0 - expectedWinner)
            let loserChange = kFactor * (0.0 - expectedLoser)
            
            let newWinnerRating = winnerRating + winnerChange
            let newLoserRating = loserRating + loserChange
            
            // Update winner stats
            let winnerWins = (winnerData["wins"] as? Int ?? 0) + 1
            let winnerStreak = (winnerData["currentStreak"] as? Int ?? 0)
            let newWinnerStreak = winnerStreak >= 0 ? winnerStreak + 1 : 1
            let winnerBestStreak = max(newWinnerStreak, winnerData["bestStreak"] as? Int ?? 0)
            
            try await db.collection("stats").document(winnerID).updateData([
                "wins": winnerWins,
                "currentStreak": newWinnerStreak,
                "bestStreak": winnerBestStreak,
                "totalGames": (winnerData["totalGames"] as? Int ?? 0) + 1,
                "rating": newWinnerRating,
                "lastGameDate": Timestamp(date: Date())
            ])
            
            // Update loser stats
            let loserLosses = (loserData["losses"] as? Int ?? 0) + 1
            let loserStreak = (loserData["currentStreak"] as? Int ?? 0)
            let newLoserStreak = loserStreak <= 0 ? loserStreak - 1 : -1
            let loserBestStreak = loserData["bestStreak"] as? Int ?? 0
            
            try await db.collection("stats").document(loserID).updateData([
                "losses": loserLosses,
                "currentStreak": newLoserStreak,
                "bestStreak": loserBestStreak,
                "totalGames": (loserData["totalGames"] as? Int ?? 0) + 1,
                "rating": newLoserRating,
                "lastGameDate": Timestamp(date: Date())
            ])
        } catch let nsError as NSError where nsError.domain == FirestoreErrorDomain && nsError.code == FirestoreErrorCode.permissionDenied.rawValue {
            FirebaseErrorHandler.logError(nsError, context: "updateStatsAfterGame - permission")
        }
    }
}

