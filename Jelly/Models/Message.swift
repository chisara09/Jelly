//
//  Message.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation

// D-009: Messages – chat messages (text + time)
struct Message: Identifiable, Codable {
    let id: UUID
    let gameID: UUID
    let senderID: UUID
    let senderName: String
    let text: String
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        gameID: UUID,
        senderID: UUID,
        senderName: String,
        text: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.gameID = gameID
        self.senderID = senderID
        self.senderName = senderName
        self.text = text
        self.timestamp = timestamp
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(timestamp)
    }
    
    var fullTimestamp: String {
        let formatter = DateFormatter()
        if isToday {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        }
        return formatter.string(from: timestamp)
    }
}


