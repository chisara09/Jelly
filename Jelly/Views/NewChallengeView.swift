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
    
    // Court selection state
    @State private var showCourtSelection = false
    @State private var selectedCourt: Court?
    @State private var courtName: String = ""
    @State private var courtAddress: String = ""
    
    // Other challenge details
    @State private var selectedDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var rules: String = "First to 21"
    @State private var isSending = false
    @State private var errorMessage: String?
    
    // Mock current user's homecourt (in production, fetch from user profile)
    private let currentUserHomeCourt = "Central Park Courts"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Opponent") {
                    Text(player.name)
                        .foregroundColor(.secondary)
                }
                
                Section("Court") {
                    Button(action: { showCourtSelection = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(courtName.isEmpty ? "Select Court" : courtName)
                                    .foregroundColor(courtName.isEmpty ? .secondary : .primary)
                                if !courtAddress.isEmpty {
                                    Text(courtAddress)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
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
                    .disabled(isSending || courtName.isEmpty)
                }
            }
            .sheet(isPresented: $showCourtSelection) {
                CourtSelectionView(
                    selectedCourt: $selectedCourt,
                    courtName: $courtName,
                    courtAddress: $courtAddress,
                    currentUserHomeCourt: currentUserHomeCourt,
                    opponentHomeCourt: player.homeCourt
                )
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
            
            if let err = gameManager.errorMessage {
                errorMessage = err
                isSending = false
            } else if newGame == nil {
                errorMessage = "Couldn't send."
                isSending = false
            } else {
                dismiss()
            }
        }
    }
}

// Court Selection View
struct CourtSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCourt: Court?
    @Binding var courtName: String
    @Binding var courtAddress: String
    
    let currentUserHomeCourt: String
    let opponentHomeCourt: String
    
    @State private var searchText = ""
    
    // Mock courts data (in production, fetch from database)
    @State private var courts: [Court] = [
        Court(name: "Central Park Courts", address: "Central Park, NYC", latitude: 40.785091, longitude: -73.968285),
        Court(name: "Brooklyn Heights Courts", address: "Brooklyn, NYC", latitude: 40.6960, longitude: -73.9967),
        Court(name: "Harlem Courts", address: "Harlem, NYC", latitude: 40.8116, longitude: -73.9465),
        Court(name: "Chelsea Piers", address: "Chelsea, NYC", latitude: 40.7489, longitude: -74.0090),
        Court(name: "Riverside Park Courts", address: "Upper West Side, NYC", latitude: 40.7956, longitude: -73.9719),
        Court(name: "McCarren Park", address: "Williamsburg, Brooklyn", latitude: 40.7197, longitude: -73.9516),
        Court(name: "Tompkins Square Park", address: "East Village, NYC", latitude: 40.7264, longitude: -73.9818),
        Court(name: "Fort Greene Park", address: "Fort Greene, Brooklyn", latitude: 40.6925, longitude: -73.9742)
    ]
    
    // Filter courts based on search text
    var filteredCourts: [Court] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            return courts
        }
        return courts.filter { court in
            court.name.lowercased().contains(query) || court.address.lowercased().contains(query)
        }
    }
    
    // Get homecourts for quick selection
    var homeCourtsList: [(name: String, description: String)] {
        var homeCourts: [(String, String)] = []
        
        // Add current user's homecourt
        if !currentUserHomeCourt.isEmpty {
            homeCourts.append((currentUserHomeCourt, "Your Home Court"))
        }
        
        // Add opponent's homecourt if different from current user
        if !opponentHomeCourt.isEmpty && opponentHomeCourt != currentUserHomeCourt {
            homeCourts.append((opponentHomeCourt, "Opponent's Home Court"))
        }
        
        return homeCourts
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Home Courts Section
                if !homeCourtsList.isEmpty && searchText.isEmpty {
                    Section("Home Courts") {
                        ForEach(homeCourtsList, id: \.name) { homeCourt in
                            Button(action: {
                                selectHomeCourt(name: homeCourt.name)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(homeCourt.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(homeCourt.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "house.fill")
                                        .foregroundColor(.orange)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // All Courts Section with Search
                Section(searchText.isEmpty ? "All Courts" : "Search Results") {
                    if filteredCourts.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                Text("No courts found")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 20)
                            Spacer()
                        }
                    } else {
                        ForEach(filteredCourts) { court in
                            Button(action: {
                                selectCourt(court)
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(court.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(court.address)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search courts")
            .navigationTitle("Select Court")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func selectHomeCourt(name: String) {
        // Find the full court details or use the name directly
        if let court = courts.first(where: { $0.name == name }) {
            selectCourt(court)
        } else {
            // If not in courts list, use the name directly
            courtName = name
            courtAddress = "Home Court"
            dismiss()
        }
    }
    
    private func selectCourt(_ court: Court) {
        selectedCourt = court
        courtName = court.name
        courtAddress = court.address
        dismiss()
    }
}

#Preview {
    NewChallengeView(player: NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 2.3))
        .environmentObject(GameManager())
}
