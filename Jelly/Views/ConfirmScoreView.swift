//
//  ConfirmScoreView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/28/25.
//

import SwiftUI

// S-010: Confirm Score – Result with "Confirm" or "Dispute."
struct ConfirmScoreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let game: Game
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Confirm Final Score")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("vs \(game.opponentName)")
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                ScoreSummaryCard(game: game)
                    .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: confirm) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Confirm Score")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(16)
                    }
                    
                    Button(action: dispute) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Dispute Score")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Confirm Score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func confirm() {
        gameManager.confirmScore(gameID: game.id)
        dismiss()
    }
    
    private func dispute() {
        gameManager.disputeScore(gameID: game.id)
        dismiss()
    }
}

private struct ScoreSummaryCard: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Court")
                    .foregroundColor(.secondary)
                Spacer()
                Text(game.courtName)
                    .fontWeight(.medium)
            }
            Divider()
            HStack {
                Text("Date")
                    .foregroundColor(.secondary)
                Spacer()
                Text(game.formattedDate)
                    .fontWeight(.medium)
            }
            Divider()
            if let cScore = game.challengerScore, let oScore = game.opponentScore {
                VStack(spacing: 8) {
                    HStack {
                        Text("Challenger")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(cScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Opponent")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(oScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            } else {
                Text("No score found")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

#Preview {
    ConfirmScoreView(
        game: Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Marcus Johnson",
            courtName: "Central Park Courts",
            courtAddress: "Central Park, NYC",
            scheduledDate: Date().addingTimeInterval(-3600),
            rules: "First to 21",
            status: .completed,
            winnerID: UUID(),
            loserID: UUID(),
            challengerScore: 21,
            opponentScore: 16
        )
    )
    .environmentObject(GameManager())
}


