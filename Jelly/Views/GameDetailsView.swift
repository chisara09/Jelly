//
//  GameDetailsView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

// S-007: Game Details – Opponent, court, date/time, chat, "Record Score"
struct GameDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let game: Game
    
    @State private var showChat = false
    @State private var showRecordScore = false
    @State private var showCancelAlert = false
    
    private var isGamePast: Bool {
        game.scheduledDate < Date()
    }
    
    private var isGameCanceled: Bool {
        game.status == .canceled
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 8) {
                    Text("vs")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(game.opponentName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if game.status != .completed && game.status != .canceled {
                        Text(game.status.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                game.status == .accepted ?
                                Color.green.opacity(0.2) :
                                Color.orange.opacity(0.2)
                            )
                            .foregroundColor(
                                game.status == .accepted ? .green : .orange
                            )
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
                
                // Game Information Card
                VStack(alignment: .leading, spacing: 20) {
                    // Court Info
                    InfoRow(
                        icon: "mappin.circle.fill",
                        label: "Court",
                        value: game.courtName,
                        color: .orange
                    )
                    
                    Divider()
                    
                    // Address
                    InfoRow(
                        icon: "location.fill",
                        label: "Address",
                        value: game.courtAddress,
                        color: .blue
                    )
                    
                    Divider()
                    
                    // Date & Time
                    InfoRow(
                        icon: "calendar.circle.fill",
                        label: "Date & Time",
                        value: game.formattedDate,
                        color: .purple
                    )
                    
                    Divider()
                    
                    // Rules
                    InfoRow(
                        icon: "basketball.fill",
                        label: "Rules",
                        value: game.rules,
                        color: .green
                    )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
                .padding(.horizontal)
                
                // Action Buttons
                if game.status == .completed {
                    VStack(spacing: 12) {
                        if let winnerID = game.winnerID {
                            VStack(spacing: 8) {
                                Text("Game Completed")
                                    .font(.headline)
                                
                                if game.isConfirmed {
                                    Text("✓ Score Confirmed")
                                        .foregroundColor(.green)
                                } else {
                                    Text("Awaiting Confirmation")
                                        .foregroundColor(.orange)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                } else if game.status != .canceled {
                    VStack(spacing: 12) {
                        // Chat Button
                        Button(action: {
                            showChat = true
                        }) {
                            HStack {
                                Image(systemName: "message.bubble.fill")
                                Text("Chat with \(game.opponentName)")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(16)
                        }
                        
                        // Record Score Button (only show if game is past)
                        if isGamePast && game.status == .accepted {
                            Button(action: {
                                showRecordScore = true
                            }) {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                    Text("Record Score")
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
                        }
                        
                        // Cancel Game Button (if pending or accepted)
                        if game.status == .pending || game.status == .accepted {
                            Button(action: {
                                showCancelAlert = true
                            }) {
                                Text("Cancel Game")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Error Message Display
                if game.status == .disputed {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        Text("Score Disputed")
                            .font(.headline)
                        
                        Text("Both players reported different scores")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { dismiss() }
            }
        }
        .sheet(isPresented: $showChat) {
            ChatView(game: game, opponentName: game.opponentName)
        }
        .sheet(isPresented: $showRecordScore) {
            RecordScoreView(game: game)
                .environmentObject(gameManager)
        }
        .alert("Cancel Game", isPresented: $showCancelAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Cancel Game", role: .destructive) {
                gameManager.updateGameStatus(game.id, status: .canceled)
            }
        } message: {
            Text("Are you sure you want to cancel this game?")
        }
    }
}

// Info Row Component
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

// Record Score View
struct RecordScoreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let game: Game
    
    @State private var myScore: String = ""
    @State private var opponentScore: String = ""
    @State private var errorMessage: String?
    @State private var isRecording = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Opponent") {
                    Text(game.opponentName)
                        .foregroundColor(.secondary)
                }
                
                Section("Score") {
                    TextField("Your Score", text: $myScore)
                        .keyboardType(.numberPad)
                    
                    TextField("\(game.opponentName)'s Score", text: $opponentScore)
                        .keyboardType(.numberPad)
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Record Score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: recordScore) {
                        if isRecording { ProgressView() } else { Text("Submit") }
                    }
                    .disabled(isRecording || myScore.isEmpty || opponentScore.isEmpty)
                }
            }
        }
    }
    
    private func recordScore() {
        guard let myIntScore = Int(myScore),
              let opponentIntScore = Int(opponentScore) else {
            errorMessage = "Please enter valid numbers"
            return
        }
        
        guard myIntScore >= 0 && opponentIntScore >= 0 else {
            errorMessage = "Scores cannot be negative"
            return
        }
        
        isRecording = true
        errorMessage = nil
        
        // Determine winner
        let currentUserID = UUID() // In production, get from auth
        let opponentID = game.opponentID
        
        let (winnerID, loserID, winnerScore, loserScore) = myIntScore > opponentIntScore ?
            (currentUserID, opponentID, myIntScore, opponentIntScore) :
            (opponentID, currentUserID, opponentIntScore, myIntScore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            gameManager.recordScore(
                gameID: game.id,
                winnerID: winnerID,
                loserID: loserID,
                winnerScore: winnerScore,
                loserScore: loserScore
            )
            
            isRecording = false
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        GameDetailsView(
            game: Game(
                challengerID: UUID(),
                opponentID: UUID(),
                opponentName: "Marcus Johnson",
                courtName: "Central Park Courts",
                courtAddress: "Central Park, NYC",
                scheduledDate: Date().addingTimeInterval(86400 * 2),
                rules: "First to 21",
                status: .accepted
            )
        )
        .environmentObject(GameManager())
    }
}


