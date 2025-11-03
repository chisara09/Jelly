//
//  SafetyManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

// F-013: Safety Tools – Block/report users
// D-010: Safety – blocked users, reports
class SafetyManager: ObservableObject {
    @Published var blockedUsers: [UUID] = []
    @Published var reportedUsers: [UUID] = []
    
    static let shared = SafetyManager()
    
    private let db = Firestore.firestore()
    
    private init() {
        // Load blocked users from Firestore on init
        Task {
            await loadBlockedUsers()
        }
    }
    
    // MARK: - Block User
    
    func blockUser(blockedID: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        // Add to blocked collection
        try await db.collection("blocked")
            .document(currentUserID)
            .collection("blocked")
            .document(blockedID)
            .setData([
                "createdAt": Timestamp(date: Date())
            ])
        
        // Update local state
        if let blockedUUID = UUID(uuidString: blockedID) {
            await MainActor.run {
                if !self.blockedUsers.contains(blockedUUID) {
                    self.blockedUsers.append(blockedUUID)
                }
            }
        }
        
        // Cancel any pending games between users
        let pendingGames = try await db.collection("games")
            .whereField("status", isEqualTo: "pending")
            .getDocuments()
        
        let batch = db.batch()
        for doc in pendingGames.documents {
            let gameData = doc.data()
            let challengerID = gameData["challengerID"] as? String ?? ""
            let opponentID = gameData["opponentID"] as? String ?? ""
            
            // Check if this game involves both users
            if (challengerID == currentUserID && opponentID == blockedID) ||
               (challengerID == blockedID && opponentID == currentUserID) {
                batch.updateData([
                    "status": "canceled",
                    "updatedAt": Timestamp(date: Date())
                ], forDocument: doc.reference)
            }
        }
        try await batch.commit()
    }
    
    func unblockUser(blockedID: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        try await db.collection("blocked")
            .document(currentUserID)
            .collection("blocked")
            .document(blockedID)
            .delete()
        
        // Update local state
        if let blockedUUID = UUID(uuidString: blockedID) {
            await MainActor.run {
                self.blockedUsers.removeAll(where: { $0 == blockedUUID })
            }
        }
    }
    
    func isBlocked(userID: String) async -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        do {
            let doc = try await db.collection("blocked")
                .document(currentUserID)
                .collection("blocked")
                .document(userID)
                .getDocument()
            return doc.exists
        } catch {
            return false
        }
    }
    
    // MARK: - Report User
    
    func reportUser(reportedID: String, reason: String, description: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        let reportData: [String: Any] = [
            "reporterID": currentUserID,
            "reportedID": reportedID,
            "reason": reason,
            "description": description,
            "createdAt": Timestamp(date: Date()),
            "status": "pending"
        ]
        
        try await db.collection("reports").addDocument(data: reportData)
        
        // Update local state
        if let reportedUUID = UUID(uuidString: reportedID) {
            await MainActor.run {
                if !self.reportedUsers.contains(reportedUUID) {
                    self.reportedUsers.append(reportedUUID)
                }
            }
        }
    }
    
    func getBlockedUsers() async throws -> [String] {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let snapshot = try await db.collection("blocked")
            .document(currentUserID)
            .collection("blocked")
            .getDocuments()
        
        return snapshot.documents.map { $0.documentID }
    }
    
    private func loadBlockedUsers() async {
        do {
            let blockedIDs = try await getBlockedUsers()
            await MainActor.run {
                self.blockedUsers = blockedIDs.compactMap { UUID(uuidString: $0) }
            }
        } catch {
            print("Error loading blocked users: \(error)")
        }
    }
    
    // MARK: - Filter Messages
    
    func filterBadWords(_ text: String) -> String {
        // Simple bad word filter - in production, use more sophisticated filtering
        let badWords = ["badword", "hate", "spam"]
        var filteredText = text
        
        for word in badWords {
            filteredText = filteredText.replacingOccurrences(
                of: word,
                with: String(repeating: "*", count: word.count),
                options: .caseInsensitive
            )
        }
        
        return filteredText
    }
    
    func containsBadWords(_ text: String) -> Bool {
        let filtered = filterBadWords(text)
        return filtered != text
    }
}

enum ReportReason: String, CaseIterable {
    case harassment = "Harassment"
    case spam = "Spam"
    case inappropriateContent = "Inappropriate Content"
    case fakeProfile = "Fake Profile"
    case other = "Other"
    
    var description: String {
        return self.rawValue
    }
}

