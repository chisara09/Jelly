//
//  NotificationManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Combine
import Foundation
import SwiftUI
import UserNotifications
import FirebaseFirestore
import FirebaseAuth

// F-007: Reminders & Notifications – alerts for new challenges, chat, game times
class NotificationManager: ObservableObject {
    @Published var isPermissionGranted = false
    @Published var notificationsEnabled = true
    
    static let shared = NotificationManager()
    
    private let db = Firestore.firestore()
    private var messageListener: ListenerRegistration?
    private var challengeListener: ListenerRegistration?
    
    private init() {
        checkNotificationPermission()
    }
    
    // MARK: - Permission Management
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            
            await MainActor.run {
                isPermissionGranted = granted
            }
            
            return granted
        } catch {
            print("Failed to request notification permission: \(error)")
            return false
        }
    }
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Game Reminders
    
    func scheduleGameReminder(for game: Game, title: String, reminderTime: NotificationReminderTime) {
        let triggerDate = getTriggerDate(for: game.scheduledDate, reminderTime: reminderTime)
        
        Task {
            await scheduleNotification(
                title: "🏀 Game Reminder",
                body: "You have a game vs \(game.opponentName) at \(game.formattedDate)",
                identifier: "game_reminder_\(game.id.uuidString)",
                date: triggerDate,
                userInfo: [
                    "gameID": game.id.uuidString,
                    "type": "game_reminder"
                ]
            )
        }
    }
    
    /// Schedule a game reminder with specific date (for Firestore games)
    func scheduleGameReminder(gameId: String, gameDate: Date, opponentName: String) async {
        let reminderDate = gameDate.addingTimeInterval(-3600) // 1 hour before
        
        await scheduleNotification(
            title: "Game Reminder",
            body: "Your game with \(opponentName) starts in 1 hour!",
            identifier: "game_reminder_\(gameId)",
            date: reminderDate,
            userInfo: ["type": "game_reminder", "gameId": gameId]
        )
    }
    
    func scheduleNewChallengeNotification(from challengerName: String, gameID: UUID) {
        Task {
            await scheduleNotification(
                title: "🎯 New Challenge!",
                body: "\(challengerName) has challenged you to a game!",
                identifier: "challenge_\(gameID.uuidString)",
                userInfo: [
                    "gameID": gameID.uuidString,
                    "type": "new_challenge"
                ]
            )
        }
    }
    
    func scheduleChatNotification(from senderName: String, gameID: UUID, message: String) {
        Task {
            await scheduleNotification(
                title: "💬 New Message",
                body: "\(senderName): \(message)",
                identifier: "chat_\(gameID.uuidString)_\(UUID().uuidString)",
                userInfo: [
                    "gameID": gameID.uuidString,
                    "type": "chat_message"
                ]
            )
        }
    }
    
    // MARK: - Generic Notification Scheduling
    
    /// Generic method to schedule a local notification
    func scheduleNotification(
        title: String,
        body: String,
        identifier: String,
        date: Date? = nil,
        userInfo: [AnyHashable: Any] = [:]
    ) async {
        guard notificationsEnabled && isPermissionGranted else {
            print("Notifications disabled or permission not granted")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo
        content.categoryIdentifier = userInfo["type"] as? String ?? "GENERAL"
        
        var trigger: UNNotificationTrigger?
        
        if let date = date, date > Date() {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        } else {
            // Trigger immediately (0.1 seconds from now)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }
    
    // MARK: - Firestore Listeners for Real-time Notifications
    
    /// Listen to Firestore for new unread messages and show notifications
    func listenForNewMessages(userId: String) {
        guard !userId.isEmpty else { return }
        
        messageListener?.remove()
        
        messageListener = db.collection("messages")
            .whereField("isRead.\(userId)", isEqualTo: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    if let error = error {
                        print("Error listening to messages: \(error)")
                    }
                    return
                }
                
                for doc in documents {
                    let data = doc.data()
                    let senderID = data["senderID"] as? String ?? ""
                    
                    // Don't notify for messages sent by current user
                    if senderID == userId {
                        continue
                    }
                    
                    let senderName = data["senderName"] as? String ?? "Someone"
                    let text = data["text"] as? String ?? ""
                    let gameId = data["gameID"] as? String ?? ""
                    
                    Task {
                        await self?.scheduleNotification(
                            title: "New message from \(senderName)",
                            body: text,
                            identifier: "message_\(doc.documentID)",
                            userInfo: [
                                "type": "chat_message",
                                "gameId": gameId,
                                "messageId": doc.documentID
                            ]
                        )
                    }
                }
            }
    }
    
    /// Listen to Firestore for new challenges and show notifications
    func listenForNewChallenges(userId: String) {
        guard !userId.isEmpty else { return }
        
        challengeListener?.remove()
        
        challengeListener = db.collection("games")
            .whereField("opponentID", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    if let error = error {
                        print("Error listening to challenges: \(error)")
                    }
                    return
                }
                
                for doc in documents {
                    let data = doc.data()
                    let gameId = doc.documentID
                    let challengerID = data["challengerID"] as? String ?? ""
                    let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    
                    // Only notify for recently created challenges (within last 5 minutes)
                    // This prevents old challenges from triggering notifications
                    guard createdAt.timeIntervalSinceNow > -300 else {
                        continue
                    }
                    
                    // Get challenger name
                    Task {
                        do {
                            let challengerDoc = try await self?.db.collection("profiles")
                                .document(challengerID)
                                .getDocument()
                            
                            let challengerName = challengerDoc?.data()?["name"] as? String ?? "Someone"
                            
                            await self?.scheduleNotification(
                                title: "New Challenge!",
                                body: "\(challengerName) has challenged you to a game!",
                                identifier: "challenge_\(gameId)",
                                userInfo: [
                                    "type": "new_challenge",
                                    "gameId": gameId
                                ]
                            )
                        } catch {
                            print("Error fetching challenger name: \(error)")
                        }
                    }
                }
            }
    }
    
    /// Start listening for all real-time notifications
    func startListening(userId: String) {
        guard !userId.isEmpty else { return }
        listenForNewMessages(userId: userId)
        listenForNewChallenges(userId: userId)
    }
    
    /// Stop all Firestore listeners
    func stopListening() {
        messageListener?.remove()
        messageListener = nil
        challengeListener?.remove()
        challengeListener = nil
    }
    
    // MARK: - Helper Methods
    
    private func getTriggerDate(for gameDate: Date, reminderTime: NotificationReminderTime) -> Date {
        switch reminderTime {
        case .oneHourBefore:
            return gameDate.addingTimeInterval(-3600)
        case .oneDayBefore:
            return gameDate.addingTimeInterval(-86400)
        case .thirtyMinutesBefore:
            return gameDate.addingTimeInterval(-1800)
        case .fifteenMinutesBefore:
            return gameDate.addingTimeInterval(-900)
        }
    }
    
    private func createCalendarTrigger(date: Date) -> UNCalendarNotificationTrigger? {
        guard date > Date() else {
            return nil // Don't schedule past notifications
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    // MARK: - Cancel Notifications
    
    func cancelGameReminders(for gameID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["game_reminder_\(gameID.uuidString)"]
        )
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllGameReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Error Handling
    
    var errorMessage: String? {
        if !notificationsEnabled {
            return "Notifications off"
        }
        if !isPermissionGranted {
            return "Notifications off"
        }
        return nil
    }
}

enum NotificationReminderTime {
    case oneDayBefore
    case oneHourBefore
    case thirtyMinutesBefore
    case fifteenMinutesBefore
    
    var displayName: String {
        switch self {
        case .oneDayBefore: return "1 day before"
        case .oneHourBefore: return "1 hour before"
        case .thirtyMinutesBefore: return "30 minutes before"
        case .fifteenMinutesBefore: return "15 minutes before"
        }
    }
}


