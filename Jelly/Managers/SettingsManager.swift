//
//  SettingsManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI
import Combine

// D-011: Settings – notifications, dark mode, units
class SettingsManager: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet { saveSettings() }
    }
    @Published var darkModeEnabled: Bool {
        didSet { saveSettings() }
    }
    @Published var showDistanceInMiles: Bool {
        didSet { saveSettings() }
    }
    @Published var gameReminderEnabled: Bool {
        didSet { saveSettings() }
    }
    @Published var chatNotificationsEnabled: Bool {
        didSet { saveSettings() }
    }
    @Published var challengeNotificationsEnabled: Bool {
        didSet { saveSettings() }
    }
    
    static let shared = SettingsManager()
    
    private let settingsKey = "appSettings"
    
    private init() {
        // Load saved settings or use defaults
        let savedSettings = UserDefaults.standard.object(forKey: settingsKey) as? [String: Any]
        
        self.notificationsEnabled = savedSettings?["notificationsEnabled"] as? Bool ?? true
        self.darkModeEnabled = savedSettings?["darkModeEnabled"] as? Bool ?? false
        self.showDistanceInMiles = savedSettings?["showDistanceInMiles"] as? Bool ?? true
        self.gameReminderEnabled = savedSettings?["gameReminderEnabled"] as? Bool ?? true
        self.chatNotificationsEnabled = savedSettings?["chatNotificationsEnabled"] as? Bool ?? true
        self.challengeNotificationsEnabled = savedSettings?["challengeNotificationsEnabled"] as? Bool ?? true
    }
    
    private func saveSettings() {
        let settings: [String: Any] = [
            "notificationsEnabled": notificationsEnabled,
            "darkModeEnabled": darkModeEnabled,
            "showDistanceInMiles": showDistanceInMiles,
            "gameReminderEnabled": gameReminderEnabled,
            "chatNotificationsEnabled": chatNotificationsEnabled,
            "challengeNotificationsEnabled": challengeNotificationsEnabled
        ]
        
        UserDefaults.standard.set(settings, forKey: settingsKey)
    }
    
    // MARK: - Color Scheme
    
    var preferredColorScheme: ColorScheme? {
        return darkModeEnabled ? .dark : .light
    }
    
    // MARK: - Notification Settings
    
    var effectiveNotificationsEnabled: Bool {
        return notificationsEnabled && NotificationManager.shared.notificationsEnabled
    }
}

