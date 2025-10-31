//
//  ChatManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import SwiftUI
import Combine

class ChatManager: ObservableObject {
    @Published var messages: [Message] = []
    @Published var conversations: [Conversation] = []
    @Published var unreadCounts: [UUID: Int] = [:]
    @Published var totalUnreadCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Mock data for development
    private var mockMessages: [Message] = []
    
    init() {
        loadMockData()
    }
    
    func getMessages(for gameID: UUID) -> [Message] {
        return messages.filter { $0.gameID == gameID }
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func sendMessage(gameID: UUID, senderID: UUID, senderName: String, text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Message not sent."
            return
        }
        
        errorMessage = nil
        
        let newMessage = Message(
            gameID: gameID,
            senderID: senderID,
            senderName: senderName,
            text: text
        )
        
        messages.append(newMessage)
        
        // In production, this would make an API call
        // For demo purposes, we'll simulate a potential error
        // In a real implementation, you'd handle API errors here
        if let error = trySaveMessage(newMessage) {
            errorMessage = "Message not sent."
            messages.removeLast()
        }
    }
    
    private func trySaveMessage(_ message: Message) -> String? {
        // Simulate network error occasionally for demo purposes
        // In production, this would be a real API call
        let shouldFail = arc4random_uniform(100) < 10 // 10% chance of failure
        return shouldFail ? "Network error" : nil
    }
    
    func deleteMessage(_ messageID: UUID) {
        messages.removeAll { $0.id == messageID }
    }
    
    private func loadMockData() {
        // Add some initial mock messages for demo
        let gameID1 = UUID()
        let senderID1 = UUID()
        let senderID2 = UUID()
        
        mockMessages = [
            Message(
                gameID: gameID1,
                senderID: senderID1,
                senderName: "Current User",
                text: "Hey! Looking forward to our game tomorrow.",
                timestamp: Date().addingTimeInterval(-3600) // 1 hour ago
            ),
            Message(
                gameID: gameID1,
                senderID: senderID2,
                senderName: "Marcus Johnson",
                text: "Me too! See you at 6 PM.",
                timestamp: Date().addingTimeInterval(-3300)
            ),
            Message(
                gameID: gameID1,
                senderID: senderID1,
                senderName: "Current User",
                text: "Perfect. Bring your A-game! 🏀",
                timestamp: Date().addingTimeInterval(-3000)
            )
        ]
        
        messages = mockMessages
        updateConversations()
    }
    
    // MARK: - Conversation Management
    
    func getAllConversations() -> [Conversation] {
        return conversations.sorted { $0.lastActivity > $1.lastActivity }
    }
    
    func updateConversations() {
        // Group messages by gameID to create conversations
        let groupedMessages = Dictionary(grouping: messages) { $0.gameID }
        
        conversations = groupedMessages.compactMap { (gameID, messages) in
            guard let lastMessage = messages.max(by: { $0.timestamp < $1.timestamp }) else {
                return nil
            }
            
            // Get opponent info from messages
            let currentUserID = UUID() // Mock - in production from auth
            let opponentMessage = messages.first { $0.senderID != currentUserID }
            let opponentName = opponentMessage?.senderName ?? "Unknown"
            let opponentID = opponentMessage?.senderID ?? UUID()
            
            // Calculate unread count (messages from opponent that are "unread")
            // For now, mock as 0 - in production would track read status
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


