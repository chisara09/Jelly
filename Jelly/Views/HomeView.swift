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
                                StatCard(title: "Win %", value: String(format: "%.0f%%", stats.winPercentage), icon: "star.fill", color: .green)
                                StatCard(title: "Streak", value: stats.streakDisplay, icon: "flame.fill", color: .orange)
                                StatCard(title: "Rating", value: String(format: "%.0f", stats.rating), icon: "crown.fill", color: .purple)
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
                CreateChallengeView()
                    .environmentObject(gameManager)
            }
            .navigationDestination(for: Game.self) { game in
                GameDetailsView(game: game)
                    .environmentObject(gameManager)
            }
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

// Create Challenge View (placeholder)
struct CreateChallengeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Challenge")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Feature coming soon...")
                    .foregroundColor(.secondary)
                    .padding()
                
                // TODO: Build actual challenge creation form
            }
            .padding()
            .navigationTitle("New Challenge")
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

#Preview {
    HomeView()
        .environmentObject(AuthenticationManager())
}
