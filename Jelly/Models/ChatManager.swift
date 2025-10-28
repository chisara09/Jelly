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
    }
}


