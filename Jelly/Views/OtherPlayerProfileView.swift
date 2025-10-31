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
    
    var body: some View {
        ScrollView {
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
                .padding(.top)
                
                Text(player.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.orange)
                    Text(player.homeCourt)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Label(player.skillLevel, systemImage: "star.fill")
                    Label(String(format: "%.1f mi", player.distanceMiles), systemImage: "location")
                }
                .foregroundColor(.secondary)
                
                Button(action: { showNewChallenge = true }) {
                    Text("Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(14)
                        .padding(.horizontal)
                }
                .padding(.top)
                .disabled(safetyManager.isBlocked(player.id))
            }
        }
        .navigationTitle("Player")
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
