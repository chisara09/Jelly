//
//  ProfileView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

// S-012: My Profile – My photo, record, streak, recent games.
struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var gameManager = GameManager()
    @State private var showSettings = false
    @State private var profile: PlayerProfile
    
    // Mock stats
    @State private var stats = PlayerStats(
        playerID: UUID(),
        wins: 12,
        losses: 3,
        currentStreak: 5,
        bestStreak: 8,
        totalGames: 15,
        rating: 1250.5
    )
    
    init() {
        // Initialize with default profile
        _profile = State(initialValue: PlayerProfile(
            name: "",
            bio: "Hooper since 2020. Always ready for a game.",
            homeCourt: "Central Park Courts",
            email: ""
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Photo
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Text(getInitials())
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        // Name
                        Text(authManager.currentUser?.name ?? "Player")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Home Court
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.orange)
                            Text(profile.homeCourt)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGroupedBackground))
                    
                    // Bio Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)
                        
                        Text(profile.bio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stats")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatRow(title: "Record", value: stats.displayRecord, icon: "chart.bar", color: .blue)
                            StatRow(title: "Win Rate", value: String(format: "%.0f%%", stats.winPercentage), icon: "star.fill", color: .green)
                            StatRow(title: "Streak", value: stats.streakDisplay, icon: "flame.fill", color: .orange)
                            StatRow(title: "Rating", value: String(format: "%.0f", stats.rating), icon: "crown.fill", color: .purple)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Detailed Stats
                        VStack(spacing: 16) {
                            StatDetailRow(label: "Wins", value: "\(stats.wins)", icon: "checkmark.circle.fill", color: .green)
                            StatDetailRow(label: "Losses", value: "\(stats.losses)", icon: "xmark.circle.fill", color: .red)
                            StatDetailRow(label: "Best Streak", value: "\(stats.bestStreak)", icon: "trophy.fill", color: .orange)
                            StatDetailRow(label: "Total Games", value: "\(stats.totalGames)", icon: "basketball.fill", color: .blue)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    // Recent Games
                    let completedGames = gameManager.getCompletedGames()
                    
                    if !completedGames.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Games")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top, 16)
                            
                            ForEach(completedGames.prefix(3)) { game in
                                CompletedGameRow(game: game)
                            }
                            
                            if completedGames.count > 3 {
                                Button(action: {}) {
                                    HStack {
                                        Text("View All Games")
                                            .fontWeight(.medium)
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.orange)
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                            }
                        }
                        .padding(.bottom, 16)
                        .background(Color(.systemBackground))
                    }
                }
            }
            .navigationTitle("Profile")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(authManager)
            }
            .onAppear {
                // Load profile data if available
                if let user = authManager.currentUser {
                    profile = PlayerProfile(
                        name: user.name,
                        bio: profile.bio,
                        homeCourt: profile.homeCourt,
                        email: user.email
                    )
                }
            }
        }
    }
    
    private func getInitials() -> String {
        guard let name = authManager.currentUser?.name else { return "?" }
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

// Stat Row Component
struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Stat Detail Row
struct StatDetailRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
    }
}

// Completed Game Row
struct CompletedGameRow: View {
    let game: Game
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(game.opponentName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(game.courtName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let winnerID = game.winnerID, let loserID = game.loserID {
                    Text(game.challengerID == winnerID ? "W" : "L")
                        .font(.headline)
                        .foregroundColor(game.challengerID == winnerID ? .green : .red)
                }
                
                Text(game.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// S-013: Settings – Notifications, dark mode, account controls
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var settingsManager = SettingsManager.shared
    @StateObject private var safetyManager = SafetyManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    @State private var showEditProfile = false
    @State private var showBlockedUsers = false
    @State private var showDeleteAccountAlert = false
    @State private var editingName = ""
    @State private var editingBio = ""
    @State private var editingHomeCourt = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Profile Section
                Section("Profile") {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(authManager.currentUser?.email ?? "")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        if let user = authManager.currentUser {
                            editingName = user.name
                            showEditProfile = true
                        }
                    }) {
                        HStack {
                            Text("Edit Profile")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    Toggle(isOn: $settingsManager.notificationsEnabled) {
                        Label("Allow Notifications", systemImage: "bell.badge")
                    }
                    
                    if settingsManager.notificationsEnabled {
                        Toggle(isOn: $settingsManager.gameReminderEnabled) {
                            Label("Game Reminders", systemImage: "calendar")
                        }
                        
                        Toggle(isOn: $settingsManager.challengeNotificationsEnabled) {
                            Label("Challenge Alerts", systemImage: "trophy")
                        }
                        
                        Toggle(isOn: $settingsManager.chatNotificationsEnabled) {
                            Label("Chat Messages", systemImage: "message")
                        }
                    }
                    
                    if !notificationManager.isPermissionGranted {
                        Text("Turn on Location.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                // Appearance Section
                Section("Appearance") {
                    Toggle(isOn: $settingsManager.darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    Toggle(isOn: $settingsManager.showDistanceInMiles) {
                        Label("Distance in Miles", systemImage: "location")
                    }
                }
                
                // Safety Section
                Section("Safety & Privacy") {
                    Button(action: { showBlockedUsers = true }) {
                        Label("Blocked Users", systemImage: "person.crop.circle.badge.xmark")
                            .foregroundColor(.primary)
                    }
                    
                    NavigationLink {
                        ReportHistoryView()
                    } label: {
                        Label("Report History", systemImage: "exclamationmark.triangle")
                    }
                }
                
                // Account Section
                Section("Account") {
                    Button(role: .destructive) {
                        showDeleteAccountAlert = true
                    } label: {
                        Label("Delete Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        authManager.logout()
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Log Out", systemImage: "arrow.right.square")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(settingsManager.preferredColorScheme)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(
                    name: $editingName,
                    bio: $editingBio,
                    homeCourt: $editingHomeCourt
                )
            }
            .sheet(isPresented: $showBlockedUsers) {
                BlockedUsersView()
                    .environmentObject(safetyManager)
            }
            .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    authManager.logout()
                    authManager.resetAllData()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
        }
    }
}

// Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var name: String
    @Binding var bio: String
    @Binding var homeCourt: String
    @State private var tempName: String
    @State private var tempBio: String
    @State private var tempHomeCourt: String
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(name: Binding<String>, bio: Binding<String>, homeCourt: Binding<String>) {
        self._name = name
        self._bio = bio
        self._homeCourt = homeCourt
        self._tempName = State(initialValue: name.wrappedValue)
        self._tempBio = State(initialValue: bio.wrappedValue)
        self._tempHomeCourt = State(initialValue: homeCourt.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Enter your name", text: $tempName)
                }
                
                Section("Bio") {
                    TextField("Tell us about yourself", text: $tempBio, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Home Court") {
                    TextField("Your favorite court", text: $tempHomeCourt)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(tempName.isEmpty)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveChanges() {
        guard !tempName.isEmpty else {
            errorMessage = "Save failed."
            showError = true
            return
        }
        
        name = tempName
        bio = tempBio
        homeCourt = tempHomeCourt
        
        dismiss()
    }
}

// Blocked Users View
struct BlockedUsersView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var safetyManager: SafetyManager
    @State private var blockedUsernames: [UUID: String] = [:]
    
    var body: some View {
        NavigationStack {
            List {
                if safetyManager.blockedUsers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.largeTitle)
                            .foregroundColor(.secondary.opacity(0.5))
                        Text("No blocked users")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(safetyManager.blockedUsers, id: \.self) { userID in
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text(blockedUsernames[userID] ?? "Blocked User")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: {
                                safetyManager.unblockUser(userID)
                            }) {
                                Text("Unblock")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Blocked Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Report History View
struct ReportHistoryView: View {
    @EnvironmentObject var safetyManager: SafetyManager
    
    var body: some View {
        List {
            if safetyManager.reportedUsers.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.shield")
                        .font(.largeTitle)
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No reports")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listRowSeparator(.hidden)
            } else {
                ForEach(safetyManager.reportedUsers, id: \.self) { userID in
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Reported User")
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationTitle("Report History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}

