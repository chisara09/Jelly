//
//  OtherPlayerProfileView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

struct OtherPlayerProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let player: NearbyPlayer
    @StateObject private var safetyManager = SafetyManager.shared
    
    @State private var showNewChallenge = false
    @State private var showBlockAlert = false
    @State private var showReportSheet = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showChat = false
    
    // Mock stats for the other player
    @State private var playerStats = PlayerStats(
        playerID: UUID(),
        wins: 18,
        losses: 7,
        currentStreak: 3,
        bestStreak: 9,
        totalGames: 25,
        rating: 1324.5
    )
    
    // Mock games with this player
    private var gamesWithThisPlayer: [Game] {
        // In production, this would filter games where current user played with this player
        // For now, return mock data
        gameManager.getCompletedGames().filter { _ in arc4random_uniform(3) == 0 }.prefix(3).map { $0 }
    }
    
    private var mutualGamesCount: Int {
        gamesWithThisPlayer.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Profile Header
                VStack(spacing: 16) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 100, height: 100)
                        Text(initials(from: player.name))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    Text(player.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Home Court
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.orange)
                        Text(player.homeCourt)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Distance
                    HStack(spacing: 8) {
                        Image(systemName: "location")
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f mi away", player.distanceMiles))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { showNewChallenge = true }) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                Text("Challenge")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(14)
                        }
                        .disabled(safetyManager.isBlocked(player.id))
                        
                        Button(action: { showChat = true }) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Message")
                            }
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                        .disabled(safetyManager.isBlocked(player.id))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.bottom, 16)
                .background(Color(.systemGroupedBackground))
                
                Divider()
                
                // Stats Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Stats")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        OtherPlayerStatCard(title: "Record", value: playerStats.displayRecord, icon: "chart.bar", color: .blue)
                        OtherPlayerStatCard(title: "Win Rate", value: String(format: "%.0f%%", playerStats.winPercentage), icon: "star.fill", color: .green)
                        OtherPlayerStatCard(title: "Streak", value: playerStats.streakDisplay, icon: "flame.fill", color: .orange)
                        OtherPlayerStatCard(title: "Rating", value: String(format: "%.0f", playerStats.rating), icon: "crown.fill", color: .purple)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Detailed Stats
                    VStack(spacing: 16) {
                        OtherPlayerStatDetailRow(label: "Wins", value: "\(playerStats.wins)", icon: "checkmark.circle.fill", color: .green)
                        OtherPlayerStatDetailRow(label: "Losses", value: "\(playerStats.losses)", icon: "xmark.circle.fill", color: .red)
                        OtherPlayerStatDetailRow(label: "Best Streak", value: "\(playerStats.bestStreak)", icon: "trophy.fill", color: .orange)
                        OtherPlayerStatDetailRow(label: "Total Games", value: "\(playerStats.totalGames)", icon: "basketball.fill", color: .blue)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                Divider()
                
                // Mutual Games Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Match History")
                            .font(.headline)
                        Spacer()
                        if mutualGamesCount > 0 {
                            Text("\(mutualGamesCount) \(mutualGamesCount == 1 ? "game" : "games")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    if gamesWithThisPlayer.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "basketball")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary.opacity(0.5))
                            Text("No mutual games yet")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Challenge \(player.name.components(separatedBy: " ").first ?? "them") to start your rivalry!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(gamesWithThisPlayer) { game in
                            MutualGameRow(game: game, currentPlayerID: UUID(), otherPlayerName: player.name)
                        }
                    }
                }
                .padding(.bottom, 16)
                .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(player.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        showBlockAlert = true
                    }) {
                        Label("Block User", systemImage: "person.crop.circle.badge.xmark")
                    }
                    
                    Button(action: {
                        showReportSheet = true
                    }) {
                        Label("Report", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showNewChallenge) {
            NewChallengeView(player: player)
                .environmentObject(gameManager)
        }
        .sheet(isPresented: $showChat) {
            // Create a mock game for chat
            let mockGame = Game(
                challengerID: UUID(),
                opponentID: player.id,
                opponentName: player.name,
                courtName: player.homeCourt,
                courtAddress: player.homeCourt,
                scheduledDate: Date()
            )
            ChatView(game: mockGame, opponentName: player.name)
        }
        .sheet(isPresented: $showReportSheet) {
            ReportUserView(playerID: player.id, playerName: player.name)
        }
        .alert("Block User", isPresented: $showBlockAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Block", role: .destructive) {
                if let error = safetyManager.blockUser(player.id) {
                    errorMessage = error
                    showError = true
                } else {
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to block \(player.name)? You won't be able to communicate with them.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 { return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased() }
        return String(name.prefix(2)).uppercased()
    }
}

// MARK: - Other Player Stat Card Component
struct OtherPlayerStatCard: View {
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

// MARK: - Other Player Stat Detail Row
struct OtherPlayerStatDetailRow: View {
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

// MARK: - Mutual Game Row Component
struct MutualGameRow: View {
    let game: Game
    let currentPlayerID: UUID
    let otherPlayerName: String
    
    private var isWin: Bool {
        game.winnerID == currentPlayerID
    }
    
    private var resultText: String {
        if game.winnerID == nil {
            return "Disputed"
        }
        return isWin ? "Win" : "Loss"
    }
    
    private var resultColor: Color {
        if game.winnerID == nil {
            return .orange
        }
        return isWin ? .green : .red
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("vs \(otherPlayerName)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(game.courtName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(game.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(resultText)
                    .font(.headline)
                    .foregroundColor(resultColor)
                
                if let challengerScore = game.challengerScore, let opponentScore = game.opponentScore {
                    let winnerScore = max(challengerScore, opponentScore)
                    let loserScore = min(challengerScore, opponentScore)
                    Text("\(winnerScore) - \(loserScore)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Report User View
struct ReportUserView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var safetyManager = SafetyManager.shared
    
    let playerID: UUID
    let playerName: String
    @State private var selectedReason: ReportReason? = nil
    @State private var showConfirmation = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Report \(playerName)")
                        .font(.headline)
                }
                
                Section("Reason for Report") {
                    ForEach(ReportReason.allCases, id: \.self) { reason in
                        Button(action: {
                            selectedReason = reason
                        }) {
                            HStack {
                                Text(reason.description)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedReason == reason {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    if selectedReason != nil {
                        Button("Submit Report") {
                            submitReport()
                        }
                        .disabled(selectedReason == nil)
                    }
                }
            }
            .navigationTitle("Report User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Report Submitted", isPresented: $showConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for your report. We will review it shortly.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func submitReport() {
        guard let reason = selectedReason else { return }
        
        if let error = safetyManager.reportUser(playerID, reason: reason) {
            errorMessage = error
            showError = true
        } else {
            showConfirmation = true
        }
    }
}

#Preview {
    OtherPlayerProfileView(player: NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 2.3))
        .environmentObject(GameManager())
}
