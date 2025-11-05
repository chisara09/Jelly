//
//  ChatManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class ChatManager: ObservableObject {
    @Published var messages: [Message] = []
    @Published var conversations: [Conversation] = []
    @Published var unreadCounts: [UUID: Int] = [:]
    @Published var totalUnreadCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var messageListener: ListenerRegistration?
    
    init() {
        // Will be initialized when user logs in
    }
    
    func getMessages(for gameID: UUID) -> [Message] {
        return messages.filter { $0.gameID == gameID }
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func listenToMessages(gameId: String) {
        messageListener?.remove()
        
        messageListener = db.collection("messages")
            .whereField("gameID", isEqualTo: gameId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    // Log error for debugging
                    FirebaseErrorHandler.logError(error, context: "listenToMessages")
                    // Update error message on main thread
                    DispatchQueue.main.async {
                        self?.errorMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
                    }
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                let messages = documents.compactMap { doc -> Message? in
                    self?.parseMessageDocument(doc)
                }
                
                DispatchQueue.main.async {
                    self?.messages = messages
                }
            }
    }
    
    func sendMessage(gameId: String, text: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "You need to be logged in to send messages."])
            FirebaseErrorHandler.logError(error, context: "sendMessage - not authenticated")
            throw error
        }
        
        do {
            // Get user's name from profile
            let profileDoc = try? await db.collection("profiles").document(currentUserID).getDocument()
            let currentUserName = profileDoc?.data()?["name"] as? String ?? "Unknown"
            
            // Verify user is part of the game
            let gameDoc = try await db.collection("games").document(gameId).getDocument()
            guard gameDoc.exists, let gameData = gameDoc.data() else {
                let error = NSError(domain: "Game", code: 404, userInfo: [NSLocalizedDescriptionKey: "Game not found."])
                FirebaseErrorHandler.logError(error, context: "sendMessage - game not found")
                throw error
            }
            
            let challengerID = gameData["challengerID"] as? String ?? ""
            let opponentID = gameData["opponentID"] as? String ?? ""
            
            guard currentUserID == challengerID || currentUserID == opponentID else {
                let error = NSError(domain: "Permission", code: 403, userInfo: [NSLocalizedDescriptionKey: "Not authorized to send messages in this game"])
                FirebaseErrorHandler.logError(error, context: "sendMessage - unauthorized")
                throw error
            }
            
            let messageData: [String: Any] = [
                "gameID": gameId,
                "senderID": currentUserID,
                "senderName": currentUserName,
                "text": text,
                "timestamp": Timestamp(date: Date()),
                "isRead": [
                    currentUserID: true
                ]
            ]
            
            try await db.collection("messages").addDocument(data: messageData)
            
            // Mark as unread for recipient
            let recipientID = currentUserID == challengerID ? opponentID : challengerID
            // Send push notification (implement in Step 12)
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "sendMessage")
            // Re-throw with user-friendly message if it's a custom error
            if let nsError = error as? NSError, nsError.domain == "Game" || nsError.domain == "Auth" || nsError.domain == "Permission" {
                throw error
            }
            // Convert Firebase errors to user-friendly messages
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Chat", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func markMessagesAsRead(gameId: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("messages")
                .whereField("gameID", isEqualTo: gameId)
                .getDocuments()
            
            let batch = db.batch()
            for doc in snapshot.documents {
                var isRead = doc.data()["isRead"] as? [String: Bool] ?? [:]
                isRead[currentUserID] = true
                batch.updateData([
                    "isRead": isRead
                ], forDocument: doc.reference)
            }
            
            try await batch.commit()
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "markMessagesAsRead")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Chat", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
        
        // Update local unread counts
        if let gameUUID = UUID(uuidString: gameId) {
            DispatchQueue.main.async {
                self.unreadCounts[gameUUID] = 0
                self.updateTotalUnreadCount()
            }
        }
    }
    
    private func parseMessageDocument(_ doc: QueryDocumentSnapshot) -> Message? {
        let data = doc.data()
        guard let gameID = data["gameID"] as? String,
              let senderID = data["senderID"] as? String,
              let senderName = data["senderName"] as? String,
              let text = data["text"] as? String,
              let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
            return nil
        }
        
        // Convert String IDs to UUIDs
        let messageId = UUID(uuidString: doc.documentID) ?? UUID()
        let gameUUID = UUID(uuidString: gameID) ?? UUID()
        let senderUUID = UUID(uuidString: senderID) ?? UUID()
        
        return Message(
            id: messageId,
            gameID: gameUUID,
            senderID: senderUUID,
            senderName: senderName,
            text: text,
            timestamp: timestamp
        )
    }
    
    func stopListening() {
        messageListener?.remove()
        messageListener = nil
    }
    
    // MARK: - Conversation Management
    
    func getAllConversations() -> [Conversation] {
        return conversations.sorted { $0.lastActivity > $1.lastActivity }
    }
    
    func updateConversations() {
        // Group messages by gameID to create conversations
        let groupedMessages = Dictionary(grouping: messages) { $0.gameID }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let currentUserUUID = UUID(uuidString: currentUserID) ?? UUID()
        
        conversations = groupedMessages.compactMap { (gameID, messages) in
            guard let lastMessage = messages.max(by: { $0.timestamp < $1.timestamp }) else {
                return nil
            }
            
            // Get opponent info from messages
            let opponentMessage = messages.first { $0.senderID != currentUserUUID }
            let opponentName = opponentMessage?.senderName ?? "Unknown"
            let opponentID = opponentMessage?.senderID ?? UUID()
            
            // Calculate unread count
            let unreadCount = unreadCounts[gameID] ?? 0
            
            return Conversation(
                gameID: gameID,
                opponentID: opponentID,
                opponentName: opponentName,
                lastMessage: lastMessage,
                unreadCount: unreadCount,
                lastActivity: lastMessage.timestamp
            )
        }
        
        updateTotalUnreadCount()
    }
    
    func markAsRead(conversationID: UUID) {
        unreadCounts[conversationID] = 0
        
        // Update conversation
        if let index = conversations.firstIndex(where: { $0.gameID == conversationID }) {
            conversations[index].unreadCount = 0
        }
        
        updateTotalUnreadCount()
    }
    
    func getUnreadCount(for conversationID: UUID) -> Int {
        return unreadCounts[conversationID] ?? 0
    }
    
    func updateUnreadCount(for conversationID: UUID, increment: Bool = true) {
        if increment {
            unreadCounts[conversationID] = (unreadCounts[conversationID] ?? 0) + 1
        }
        
        // Update conversation
        if let index = conversations.firstIndex(where: { $0.gameID == conversationID }) {
            conversations[index].unreadCount = unreadCounts[conversationID] ?? 0
        }
        
        updateTotalUnreadCount()
    }
    
    func updateConversationActivity(gameID: UUID) {
        if let index = conversations.firstIndex(where: { $0.gameID == gameID }) {
            conversations[index].lastActivity = Date()
            if let lastMessage = messages.filter({ $0.gameID == gameID }).max(by: { $0.timestamp < $1.timestamp }) {
                conversations[index].lastMessage = lastMessage
            }
        } else {
            updateConversations()
        }
    }
    
    private func updateTotalUnreadCount() {
        totalUnreadCount = unreadCounts.values.reduce(0, +)
    }
}


