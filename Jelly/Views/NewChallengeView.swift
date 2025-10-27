//
//  NewChallengeView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

struct NewChallengeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    let player: NearbyPlayer
    
    @State private var courtName: String = "Central Park Courts"
    @State private var courtAddress: String = "Central Park, NYC"
    @State private var selectedDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var rules: String = "First to 21"
    @State private var isSending = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Opponent") {
                    Text(player.name)
                        .foregroundColor(.secondary)
                }
                
                Section("Court") {
                    TextField("Court name", text: $courtName)
                    TextField("Address", text: $courtAddress)
                }
                
                Section("Date & Time") {
                    DatePicker("When", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Rules") {
                    Picker("Rules", selection: $rules) {
                        Text("First to 21").tag("First to 21")
                        Text("Best of 3").tag("Best of 3")
                        Text("Custom...").tag("Custom")
                    }
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Challenge")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: sendChallenge) {
                        if isSending { ProgressView() } else { Text("Send") }
                    }
                    .disabled(isSending)
                }
            }
        }
    }
    
    private func sendChallenge() {
        isSending = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let newGame = gameManager.createChallenge(
                to: player.id,
                opponentName: player.name,
                courtName: courtName,
                courtAddress: courtAddress,
                scheduledDate: selectedDate,
                rules: rules
            )
            
            if newGame == nil {
                errorMessage = "Couldn't send."
                isSending = false
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    NewChallengeView(player: NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 2.3))
        .environmentObject(GameManager())
}
