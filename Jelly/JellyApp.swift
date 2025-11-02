//
//  JellyApp.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI
import UserNotifications
import FirebaseCore
import UIKit

// MARK: - App Delegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Setup notifications
        setupNotifications()
        
        return true
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        // Register notification categories with actions
        let acceptChallengeCategory = UNNotificationCategory(
            identifier: "NEW_CHALLENGE",
            actions: [
                UNNotificationAction(identifier: "ACCEPT", title: "Accept", options: [.foreground]),
                UNNotificationAction(identifier: "DECLINE", title: "Decline", options: [])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let chatCategory = UNNotificationCategory(
            identifier: "CHAT_MESSAGE",
            actions: [
                UNNotificationAction(identifier: "REPLY", title: "Reply", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let gameReminderCategory = UNNotificationCategory(
            identifier: "GAME_REMINDER",
            actions: [
                UNNotificationAction(identifier: "VIEW_GAME", title: "View Game", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            acceptChallengeCategory,
            chatCategory,
            gameReminderCategory
        ])
    }
}

// MARK: - App

@main
struct JellyApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .task {
                    _ = await notificationManager.requestPermission()
                }
        }
    }
}

// MARK: - Notification Delegate

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    // Handle notification while app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is open
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification tap and actions
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let type = userInfo["type"] as? String {
            switch type {
            case "new_challenge":
                // Navigate to challenge detail
                print("Navigate to challenge")
            case "chat_message":
                // Navigate to chat
                print("Navigate to chat")
            case "game_reminder":
                // Navigate to game details
                print("Navigate to game")
            default:
                break
            }
        }
        
        completionHandler()
    }
}
