//
//  HomeView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

// S-003: Home – Quick stats, upcoming games, "Create Challenge."
struct HomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var gameManager = GameManager()
    @State private var showCreateChallenge = false
    @State private var showStatsError = false
    @State private var isLoadingStats = false
    @State private var showMatchHistory = false
    @State private var selectedStatType: StatType?
    
    // Mock stats - in production this would come from a StatsManager
    @State private var stats = PlayerStats(
        playerID: UUID(),
        wins: 12,
        losses: 3,
        currentStreak: 5,
        bestStreak: 8,
        totalGames: 15,
        rating: 1250.5
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(spacing: 8) {
                        Text("Welcome back, \(authManager.currentUser?.name ?? "Player")!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Ready to hoop?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick Stats Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Stats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                StatCard(title: "Record", value: stats.displayRecord, icon: "chart.bar.fill", color: .blue)
                                    .onTapGesture {
                                        selectedStatType = .record
                                        showMatchHistory = true
                                    }
                                StatCard(title: "Win %", value: String(format: "%.0f%%", stats.winPercentage), icon: "star.fill", color: .green)
                                    .onTapGesture {
                                        selectedStatType = .winPercentage
                                        showMatchHistory = true
                                    }
                                StatCard(title: "Streak", value: stats.streakDisplay, icon: "flame.fill", color: .orange)
                                    .onTapGesture {
                                        selectedStatType = .streak
                                        showMatchHistory = true
                                    }
                                StatCard(title: "Rating", value: String(format: "%.0f", stats.rating), icon: "crown.fill", color: .purple)
                                    .onTapGesture {
                                        selectedStatType = .rating
                                        showMatchHistory = true
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Upcoming Games Section
                    let upcomingGames = gameManager.getUpcomingGames()
                    
                    if !upcomingGames.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Upcoming Games")
                                    .font(.headline)
                                Spacer()
                                if upcomingGames.count > 0 {
                                    Text("\(upcomingGames.count)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(upcomingGames.prefix(2)) { game in
                                NavigationLink(value: game) {
                                    UpcomingGameCard(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    } else {
                        EmptyGameCard()
                    }
                    
                    // Create Challenge Button
                    Button(action: {
                        showCreateChallenge = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Challenge")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Log Out Button
                    Button(action: {
                        authManager.logout()
                    }) {
                        Text("Log Out")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .sheet(isPresented: $showCreateChallenge) {
                PlayerSelectionView()
                    .environmentObject(gameManager)
            }
            .sheet(isPresented: $showMatchHistory) {
                if let statType = selectedStatType {
                    MatchHistoryView(statType: statType, currentStats: stats)
                        .environmentObject(gameManager)
                }
            }
            .alert("Error", isPresented: $showStatsError) {
                Button("OK") { }
            } message: {
                Text("Stats not available.")
            }
            .navigationDestination(for: Game.self) { game in
                GameDetailsView(game: game)
                    .environmentObject(gameManager)
            }
            .onAppear {
                loadStats()
            }
        }
    }
    
    private func loadStats() {
        isLoadingStats = true
        
        // Simulate loading stats with potential failure
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Simulate potential failure (5% chance)
            let shouldFail = arc4random_uniform(100) < 5
            
            if shouldFail {
                showStatsError = true
            }
            
            isLoadingStats = false
        }
    }
}

// Quick Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 100, height: 100)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Upcoming Game Card
struct UpcomingGameCard: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("vs \(game.opponentName)")
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(game.courtName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(game.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(game.status.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(game.status == .accepted ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .foregroundColor(game.status == .accepted ? .green : .orange)
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            HStack(spacing: 16) {
                Label(game.rules, systemImage: "basketball.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3)
    }
}

// Empty State Card
struct EmptyGameCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(.orange.opacity(0.5))
            
            Text("No Upcoming Games")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Challenge someone to start playing!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// Stat Type Enum
enum StatType {
    case record
    case winPercentage
    case streak
    case rating
}

// Player Selection View for Creating Challenges
struct PlayerSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var selectedPlayer: NearbyPlayer?
    @State private var showNewChallenge = false
    
    // Mock data - in production this would come from backend
    private var nearbyPlayers: [NearbyPlayer] {
        [
            NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 0.5),
            NearbyPlayer(name: "Sarah Williams", skillLevel: "Intermediate", homeCourt: "Riverside Courts", distanceMiles: 1.2),
            NearbyPlayer(name: "James Chen", skillLevel: "Advanced", homeCourt: "Downtown Gym", distanceMiles: 1.8)
        ]
    }
    
    private var recentOpponents: [NearbyPlayer] {
        [
            NearbyPlayer(name: "Tyler Brown", skillLevel: "Advanced", homeCourt: "West Side Park", distanceMiles: 2.1),
            NearbyPlayer(name: "Alex Rivera", skillLevel: "Intermediate", homeCourt: "East Courts", distanceMiles: 3.5)
        ]
    }
    
    private var filteredPlayers: [NearbyPlayer] {
        if searchText.isEmpty {
            return nearbyPlayers
        }
        return nearbyPlayers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Search bar section
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search players...", text: $searchText)
                    }
                }
                
                // Recent Opponents
                if !recentOpponents.isEmpty {
                    Section("Recent Opponents") {
                        ForEach(recentOpponents) { player in
                            PlayerSelectionRow(player: player)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedPlayer = player
                                    showNewChallenge = true
                                }
                        }
                    }
                }
                
                // Nearby Players
                Section("Nearby Players") {
                    ForEach(filteredPlayers) { player in
                        PlayerSelectionRow(player: player)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPlayer = player
                                showNewChallenge = true
                            }
                    }
                }
            }
            .navigationTitle("Select Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showNewChallenge) {
                if let player = selectedPlayer {
                    NewChallengeView(player: player)
                        .environmentObject(gameManager)
                }
            }
        }
    }
}

// Player Selection Row
struct PlayerSelectionRow: View {
    let player: NearbyPlayer
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar placeholder
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(player.name.prefix(1))
                        .font(.headline)
                        .foregroundColor(.orange)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(player.homeCourt)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", player.distanceMiles)) mi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// Match History View
struct MatchHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let statType: StatType
    let currentStats: PlayerStats
    
    // Mock match history data
    private var matchHistory: [MatchHistoryItem] {
        [
            MatchHistoryItem(
                id: UUID(),
                opponent: "Marcus Johnson",
                result: .win,
                score: "21-18",
                date: Date().addingTimeInterval(-86400 * 2),
                court: "Central Park",
                statsBefore: PlayerStats(playerID: UUID(), wins: 11, losses: 3, currentStreak: 4, bestStreak: 7, totalGames: 14, rating: 1238.0),
                statsAfter: PlayerStats(playerID: UUID(), wins: 12, losses: 3, currentStreak: 5, bestStreak: 8, totalGames: 15, rating: 1250.5)
            ),
            MatchHistoryItem(
                id: UUID(),
                opponent: "Sarah Williams",
                result: .win,
                score: "21-15",
                date: Date().addingTimeInterval(-86400 * 5),
                court: "Riverside Courts",
                statsBefore: PlayerStats(playerID: UUID(), wins: 10, losses: 3, currentStreak: 3, bestStreak: 7, totalGames: 13, rating: 1225.0),
                statsAfter: PlayerStats(playerID: UUID(), wins: 11, losses: 3, currentStreak: 4, bestStreak: 7, totalGames: 14, rating: 1238.0)
            ),
            MatchHistoryItem(
                id: UUID(),
                opponent: "Tyler Brown",
                result: .loss,
                score: "19-21",
                date: Date().addingTimeInterval(-86400 * 8),
                court: "West Side Park",
                statsBefore: PlayerStats(playerID: UUID(), wins: 10, losses: 2, currentStreak: 7, bestStreak: 7, totalGames: 12, rating: 1240.0),
                statsAfter: PlayerStats(playerID: UUID(), wins: 10, losses: 3, currentStreak: 3, bestStreak: 7, totalGames: 13, rating: 1225.0)
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Current Stats Overview
                Section("Current Stats") {
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            StatSummaryItem(title: "Record", value: currentStats.displayRecord)
                            Divider()
                            StatSummaryItem(title: "Win %", value: String(format: "%.0f%%", currentStats.winPercentage))
                            Divider()
                            StatSummaryItem(title: "Rating", value: String(format: "%.0f", currentStats.rating))
                        }
                        .frame(height: 60)
                    }
                    .padding(.vertical, 8)
                }
                
                // Match History
                Section("Match History") {
                    ForEach(matchHistory) { match in
                        MatchHistoryCard(match: match)
                    }
                }
            }
            .navigationTitle("Match History")
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

// Match History Item Model
struct MatchHistoryItem: Identifiable {
    let id: UUID
    let opponent: String
    let result: MatchResult
    let score: String
    let date: Date
    let court: String
    let statsBefore: PlayerStats
    let statsAfter: PlayerStats
    
    enum MatchResult {
        case win
        case loss
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Match History Card
struct MatchHistoryCard: View {
    let match: MatchHistoryItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Match Overview
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(match.result == .win ? "W" : "L")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(match.result == .win ? Color.green : Color.red)
                            .cornerRadius(6)
                        
                        Text("vs \(match.opponent)")
                            .font(.headline)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(match.court)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(match.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(match.score)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Button(action: { isExpanded.toggle() }) {
                        HStack(spacing: 2) {
                            Text("Stats")
                                .font(.caption)
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.orange)
                    }
                }
            }
            
            // Expanded Stats Comparison
            if isExpanded {
                Divider()
                
                VStack(spacing: 12) {
                    Text("Stats Comparison")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("Before")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Stat")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("After")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    StatComparisonRow(
                        title: "Record",
                        before: match.statsBefore.displayRecord,
                        after: match.statsAfter.displayRecord,
                        improved: match.result == .win
                    )
                    
                    StatComparisonRow(
                        title: "Rating",
                        before: String(format: "%.0f", match.statsBefore.rating),
                        after: String(format: "%.0f", match.statsAfter.rating),
                        improved: match.statsAfter.rating > match.statsBefore.rating
                    )
                    
                    StatComparisonRow(
                        title: "Streak",
                        before: "\(match.statsBefore.currentStreak)",
                        after: "\(match.statsAfter.currentStreak)",
                        improved: match.statsAfter.currentStreak > match.statsBefore.currentStreak
                    )
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}

// Stat Comparison Row
struct StatComparisonRow: View {
    let title: String
    let before: String
    let after: String
    let improved: Bool
    
    var body: some View {
        HStack {
            Text(before)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            HStack(spacing: 4) {
                Text(after)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Image(systemName: improved ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.caption)
                    .foregroundColor(improved ? .green : .red)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// Stat Summary Item
struct StatSummaryItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationManager())
}
