//
//  Conversation.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/31/25.
//

import Foundation

struct Conversation: Identifiable, Codable {
    let id: UUID
    let gameID: UUID
    let opponentID: UUID
    let opponentName: String
    var lastMessage: Message?
    var unreadCount: Int
    var lastActivity: Date
    
    init(
        id: UUID = UUID(),
        gameID: UUID,
        opponentID: UUID,
        opponentName: String,
        lastMessage: Message? = nil,
        unreadCount: Int = 0,
        lastActivity: Date = Date()
    ) {
        self.id = id
        self.gameID = gameID
        self.opponentID = opponentID
        self.opponentName = opponentName
        self.lastMessage = lastMessage
        self.unreadCount = unreadCount
        self.lastActivity = lastActivity
    }
    
    var opponentInitials: String {
        let components = opponentName.split(separator: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastActivity, relativeTo: Date())
    }
}

