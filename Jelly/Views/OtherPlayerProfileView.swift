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
    @State private var showNewChallenge = false
    
    var body: some View {
        NavigationStack {
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
                }
            }
            .navigationTitle("Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $showNewChallenge) {
                NewChallengeView(player: player)
                    .environmentObject(gameManager)
            }
        }
    }
    
    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 { return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased() }
        return String(name.prefix(2)).uppercased()
    }
}

#Preview {
    OtherPlayerProfileView(player: NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 2.3))
        .environmentObject(GameManager())
}
