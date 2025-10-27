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

// F-007: Reminders & Notifications – alerts for new challenges, chat, game times
class NotificationManager: ObservableObject {
    @Published var isPermissionGranted = false
    @Published var notificationsEnabled = true
    
    static let shared = NotificationManager()
    
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
        guard notificationsEnabled && isPermissionGranted else {
            print("Notifications off")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "🏀 Game Reminder"
        content.body = "You have a game vs \(game.opponentName) at \(game.formattedDate)"
        content.sound = .default
        content.categoryIdentifier = "GAME_REMINDER"
        content.userInfo = [
            "gameID": game.id.uuidString,
            "type": "game_reminder"
        ]
        
        let triggerDate = getTriggerDate(for: game.scheduledDate, reminderTime: reminderTime)
        guard let calendarTrigger = createCalendarTrigger(date: triggerDate) else {
            print("Couldn't schedule reminder")
            return
        }
        
        let request = UNNotificationRequest(
            identifier: "game_reminder_\(game.id.uuidString)",
            content: content,
            trigger: calendarTrigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNewChallengeNotification(from challengerName: String, gameID: UUID) {
        guard notificationsEnabled && isPermissionGranted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🎯 New Challenge!"
        content.body = "\(challengerName) has challenged you to a game!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "NEW_CHALLENGE"
        content.userInfo = [
            "gameID": gameID.uuidString,
            "type": "new_challenge"
        ]
        
        // Send immediately (when received from backend in production)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "challenge_\(gameID.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleChatNotification(from senderName: String, gameID: UUID, message: String) {
        guard notificationsEnabled && isPermissionGranted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "💬 New Message"
        content.body = "\(senderName): \(message)"
        content.sound = .default
        content.categoryIdentifier = "CHAT_MESSAGE"
        content.userInfo = [
            "gameID": gameID.uuidString,
            "type": "chat_message"
        ]
        
        // Send immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "chat_\(gameID.uuidString)_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
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
    
    func cancelAllGameReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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


