//
//  GameManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class GameManager: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let statsManager = StatsManager()
    
    init() {
        // Will be initialized when user logs in
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
    
    func createChallenge(
        opponentID: String, // Firebase String ID
        opponentName: String,
        courtID: String,
        scheduledDate: Date,
        rules: String
    ) async throws -> String {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "You need to be logged in to create a challenge."])
            FirebaseErrorHandler.logError(error, context: "createChallenge - not authenticated")
            throw error
        }
        
        do {
            // Check if opponent is blocked
            let isBlocked = try await checkIfBlocked(blockerID: currentUserID, blockedID: opponentID)
            if isBlocked {
                let error = NSError(domain: "Game", code: 403, userInfo: [NSLocalizedDescriptionKey: "Cannot challenge blocked user"])
                FirebaseErrorHandler.logError(error, context: "createChallenge - blocked user")
                throw error
            }
            
            // Get court info
            let courtDoc = try await db.collection("courts").document(courtID).getDocument()
            guard courtDoc.exists else {
                let error = NSError(domain: "Game", code: 404, userInfo: [NSLocalizedDescriptionKey: "Court not found. Please select a different court."])
                FirebaseErrorHandler.logError(error, context: "createChallenge - court not found")
                throw error
            }
            
            let courtData = courtDoc.data() ?? [:]
            let courtName = courtData["name"] as? String ?? "Unknown Court"
            let courtAddress = courtData["address"] as? String ?? ""
            
            let gameData: [String: Any] = [
                "challengerID": currentUserID,
                "opponentID": opponentID,
                "courtID": courtID,
                "scheduledDate": Timestamp(date: scheduledDate),
                "rules": rules,
                "status": "pending",
                "isConfirmed": false,
                "createdAt": Timestamp(date: Date()),
                "updatedAt": Timestamp(date: Date())
            ]
            
            let docRef = try await db.collection("games").addDocument(data: gameData)
            
            // Send push notification (implement in Step 12)
            // await sendChallengeNotification(to: opponentID, gameId: docRef.documentID)
            
            return docRef.documentID
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "createChallenge")
            // Re-throw with user-friendly message if it's a generic error
            if let nsError = error as? NSError, nsError.domain == "Game" || nsError.domain == "Auth" {
                throw error
            }
            // Convert Firebase errors to user-friendly messages
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func listenToGames(userId: String) {
        listener?.remove()
        
        // Listen to games where user is challenger or opponent
        let challengerQuery = db.collection("games")
            .whereField("challengerID", isEqualTo: userId)
        
        let opponentQuery = db.collection("games")
            .whereField("opponentID", isEqualTo: userId)
        
        // Combine both queries by listening to both and merging
        var allGames: [Game] = []
        
        challengerQuery.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                // Log error for debugging
                FirebaseErrorHandler.logError(error, context: "listenToGames")
                // Update error message on main thread
                DispatchQueue.main.async {
                    self?.errorMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
                }
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            var games = documents.compactMap { doc -> Game? in
                self?.parseGameDocument(doc)
            }
            
            // Also get opponent games
            opponentQuery.getDocuments { snapshot, error in
                if let error = error {
                    // Log error for debugging
                    FirebaseErrorHandler.logError(error, context: "listenToGames - opponent query")
                    // Still show challenger games even if opponent query fails
                    DispatchQueue.main.async {
                        self?.games = games
                        self?.errorMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
                    }
                    return
                }
                
                guard let opponentDocs = snapshot?.documents else {
                    DispatchQueue.main.async {
                        self?.games = games
                    }
                    return
                }
                
                let opponentGames = opponentDocs.compactMap { doc -> Game? in
                    self?.parseGameDocument(doc)
                }
                
                // Merge and deduplicate
                allGames = games + opponentGames
                var uniqueGames: [Game] = []
                var seenIds: Set<UUID> = []
                
                for game in allGames {
                    if !seenIds.contains(game.id) {
                        uniqueGames.append(game)
                        seenIds.insert(game.id)
                    }
                }
                
                DispatchQueue.main.async {
                    self?.games = uniqueGames
                }
            }
        }
    }
    
    func acceptGame(gameId: String) async throws {
        do {
            try await db.collection("games").document(gameId).updateData([
                "status": "accepted",
                "updatedAt": Timestamp(date: Date())
            ])
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "acceptGame")
            // Convert to user-friendly error
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func cancelGame(gameId: String) async throws {
        do {
            try await db.collection("games").document(gameId).updateData([
                "status": "canceled",
                "updatedAt": Timestamp(date: Date())
            ])
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "cancelGame")
            // Convert to user-friendly error
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func submitScore(gameId: String, myScore: Int, opponentScore: Int) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "You need to be logged in to submit scores."])
            FirebaseErrorHandler.logError(error, context: "submitScore - not authenticated")
            throw error
        }
        
        do {
            let gameDoc = try await db.collection("games").document(gameId).getDocument()
            guard gameDoc.exists, let gameData = gameDoc.data() else {
                let error = NSError(domain: "Game", code: 404, userInfo: [NSLocalizedDescriptionKey: "Game not found."])
                FirebaseErrorHandler.logError(error, context: "submitScore - game not found")
                throw error
            }
            
            let challengerID = gameData["challengerID"] as? String ?? ""
            let opponentID = gameData["opponentID"] as? String ?? ""
            
            var updates: [String: Any] = [
                "updatedAt": Timestamp(date: Date())
            ]
            
            if currentUserID == challengerID {
                updates["challengerScore"] = myScore
                updates["opponentScore"] = opponentScore
            } else {
                updates["opponentScore"] = myScore
                updates["challengerScore"] = opponentScore
            }
            
            // Check if scores match
            let existingChallengerScore = gameData["challengerScore"] as? Int
            let existingOpponentScore = gameData["opponentScore"] as? Int
            
            if let existingChallenger = existingChallengerScore,
               let existingOpponent = existingOpponentScore {
                // Both scores submitted
                let challengerScore = updates["challengerScore"] as? Int ?? existingChallenger
                let opponentScore = updates["opponentScore"] as? Int ?? existingOpponent
                
                if challengerScore == existingChallenger && opponentScore == existingOpponent {
                    // Scores match - auto-confirm
                    let winnerID = challengerScore > opponentScore ? challengerID : opponentID
                    let loserID = winnerID == challengerID ? opponentID : challengerID
                    
                    updates["status"] = "completed"
                    updates["winnerID"] = winnerID
                    updates["loserID"] = loserID
                    updates["isConfirmed"] = true
                    
                    // Update stats
                    try await statsManager.updateStatsAfterGame(winnerID: winnerID, loserID: loserID)
                } else {
                    // Scores don't match
                    updates["status"] = "disputed"
                }
            }
            
            try await db.collection("games").document(gameId).updateData(updates)
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "submitScore")
            // Convert to user-friendly error
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func confirmScore(gameId: String) async throws {
        do {
            try await db.collection("games").document(gameId).updateData([
                "isConfirmed": true,
                "updatedAt": Timestamp(date: Date())
            ])
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "confirmScore")
            // Convert to user-friendly error
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func disputeScore(gameId: String) async throws {
        do {
            try await db.collection("games").document(gameId).updateData([
                "status": "disputed",
                "isConfirmed": false,
                "updatedAt": Timestamp(date: Date())
            ])
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "disputeScore")
            // Convert to user-friendly error
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Game", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    // MARK: - Helpers
    
    private func parseGameDocument(_ doc: QueryDocumentSnapshot) -> Game? {
        let data = doc.data()
        guard let challengerID = data["challengerID"] as? String,
              let opponentID = data["opponentID"] as? String,
              let scheduledDate = (data["scheduledDate"] as? Timestamp)?.dateValue(),
              let statusString = data["status"] as? String else {
            return nil
        }
        
        let status = Game.GameStatus(rawValue: statusString) ?? .pending
        
        // Get court info
        let courtID = data["courtID"] as? String ?? ""
        let courtName = "" // Will be fetched separately if needed
        let courtAddress = "" // Will be fetched separately if needed
        
        // Get opponent name from profile (could be cached)
        let opponentName = "" // Will be fetched separately if needed
        
        // Convert String IDs to UUIDs
        let gameId = UUID(uuidString: doc.documentID) ?? UUID()
        let challengerUUID = UUID(uuidString: challengerID) ?? UUID()
        let opponentUUID = UUID(uuidString: opponentID) ?? UUID()
        
        return Game(
            id: gameId,
            challengerID: challengerUUID,
            opponentID: opponentUUID,
            opponentName: opponentName,
            courtName: courtName,
            courtAddress: courtAddress,
            scheduledDate: scheduledDate,
            rules: data["rules"] as? String ?? "First to 21",
            status: status,
            winnerID: (data["winnerID"] as? String).flatMap { UUID(uuidString: $0) },
            loserID: (data["loserID"] as? String).flatMap { UUID(uuidString: $0) },
            challengerScore: data["challengerScore"] as? Int,
            opponentScore: data["opponentScore"] as? Int,
            isConfirmed: data["isConfirmed"] as? Bool ?? false,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
    
    private func checkIfBlocked(blockerID: String, blockedID: String) async throws -> Bool {
        do {
            let doc = try await db.collection("blocked")
                .document(blockerID)
                .collection("blocked")
                .document(blockedID)
                .getDocument()
            
            return doc.exists
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "checkIfBlocked")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Safety", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }
}

