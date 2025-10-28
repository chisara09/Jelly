//
//  SafetyManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI
import Combine

// F-013: Safety Tools – Block/report users
// D-010: Safety – blocked users, reports
class SafetyManager: ObservableObject {
    @Published var blockedUsers: [UUID] = []
    @Published var reportedUsers: [UUID] = []
    
    static let shared = SafetyManager()
    
    private let blockedUsersKey = "blockedUsers"
    private let reportedUsersKey = "reportedUsers"
    
    private init() {
        loadData()
    }
    
    // MARK: - Block User
    
    func blockUser(_ userID: UUID) -> String? {
        guard !blockedUsers.contains(userID) else {
            return "User already blocked."
        }
        
        blockedUsers.append(userID)
        saveData()
        
        return nil // No error
    }
    
    func unblockUser(_ userID: UUID) {
        blockedUsers.removeAll(where: { $0 == userID })
        saveData()
    }
    
    func isBlocked(_ userID: UUID) -> Bool {
        return blockedUsers.contains(userID)
    }
    
    // MARK: - Report User
    
    func reportUser(_ userID: UUID, reason: ReportReason) -> String? {
        guard !reportedUsers.contains(userID) else {
            return "User already reported."
        }
        
        reportedUsers.append(userID)
        saveData()
        
        // In production, this would send to backend
        print("Reported user \(userID) for reason: \(reason)")
        
        return nil
    }
    
    func isReported(_ userID: UUID) -> Bool {
        return reportedUsers.contains(userID)
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
    
    // MARK: - Data Persistence
    
    private func loadData() {
        // Load blocked users
        if let data = UserDefaults.standard.data(forKey: blockedUsersKey),
           let users = try? JSONDecoder().decode([UUID].self, from: data) {
            blockedUsers = users
        }
        
        // Load reported users
        if let data = UserDefaults.standard.data(forKey: reportedUsersKey),
           let users = try? JSONDecoder().decode([UUID].self, from: data) {
            reportedUsers = users
        }
    }
    
    private func saveData() {
        // Save blocked users
        if let data = try? JSONEncoder().encode(blockedUsers) {
            UserDefaults.standard.set(data, forKey: blockedUsersKey)
        }
        
        // Save reported users
        if let data = try? JSONEncoder().encode(reportedUsers) {
            UserDefaults.standard.set(data, forKey: reportedUsersKey)
        }
    }
    
    // MARK: - Error Handling
    
    var errorMessage: String? {
        if blockedUsers.isEmpty && reportedUsers.isEmpty {
            return nil
        }
        return "Couldn't update."
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

