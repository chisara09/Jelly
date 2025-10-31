//
//  LeaderboardManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/28/25.
//

import Foundation
import Combine

// D-008: Leaderboard Snapshot – cached top players.
struct LeaderboardEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let rating: Double
    let wins: Int
    let losses: Int
    // currentStreak: positive for win streak, negative for loss streak
    let currentStreak: Int
    let homeCourt: String
}

struct LeaderboardSnapshot: Codable, Equatable {
    let generatedAt: Date
    let entries: [LeaderboardEntry]
}

final class LeaderboardManager: ObservableObject {
    @Published private(set) var snapshot: LeaderboardSnapshot?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let storageKey = "leaderboard_snapshot_v1"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSnapshot()
        if snapshot == nil {
            // Seed with mock data on first run
            regenerateMockSnapshot()
        }
    }
    
    // MARK: - Public API
    func topEntries(sortedBy metric: LeaderboardMetric, limit: Int = 50) -> [LeaderboardEntry] {
        guard let snapshot else { return [] }
        let sorted = sort(entries: snapshot.entries, by: metric)
        return Array(sorted.prefix(limit))
    }
    
    func regenerateMockSnapshot() {
        isLoading = true
        errorMessage = nil
        
        // Simulate a quick async refresh
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            let mock = self.generateMockEntries(count: 30)
            let snap = LeaderboardSnapshot(generatedAt: Date(), entries: mock)
            DispatchQueue.main.async {
                self.snapshot = snap
                self.isLoading = false
                self.saveSnapshot()
            }
        }
    }
    
    // MARK: - Sorting
    enum LeaderboardMetric: String, CaseIterable, Identifiable {
        case rating = "Rating"
        case wins = "Wins"
        case streak = "Streak"
        
        var id: String { rawValue }
    }
    
    private func sort(entries: [LeaderboardEntry], by metric: LeaderboardMetric) -> [LeaderboardEntry] {
        switch metric {
        case .rating:
            return entries.sorted { lhs, rhs in
                if lhs.rating == rhs.rating { return lhs.wins > rhs.wins }
                return lhs.rating > rhs.rating
            }
        case .wins:
            return entries.sorted { lhs, rhs in
                if lhs.wins == rhs.wins { return lhs.rating > rhs.rating }
                return lhs.wins > rhs.wins
            }
        case .streak:
            // Higher positive streaks rank first; then rating tiebreaker
            return entries.sorted { lhs, rhs in
                if lhs.currentStreak == rhs.currentStreak { return lhs.rating > rhs.rating }
                return lhs.currentStreak > rhs.currentStreak
            }
        }
    }
    
    // MARK: - Persistence (cached snapshot)
    private func saveSnapshot() {
        guard let snapshot else { return }
        do {
            let data = try JSONEncoder().encode(snapshot)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            errorMessage = "Failed to cache leaderboard."
        }
    }
    
    private func loadSnapshot() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            snapshot = try JSONDecoder().decode(LeaderboardSnapshot.self, from: data)
        } catch {
            snapshot = nil
        }
    }
    
    // MARK: - Mock Data
    private func generateMockEntries(count: Int) -> [LeaderboardEntry] {
        let names = [
            "Marcus Johnson", "Jamal Smith", "Darius Lee", "Andre Clark", "Kenny Brown",
            "Chris Taylor", "Jordan Davis", "Isaiah Walker", "Trey Williams", "Malik Harris",
            "Devon Brooks", "Evan Carter", "Nate Allen", "Quincy Moore", "Jalen Thompson",
            "RJ Miller", "Ty Reed", "Cole Martin", "Omar Young", "Shawn Baker",
            "Luis Ramirez", "Noah Foster", "Caleb Ward", "Eli Turner", "Mason Sanchez",
            "Leo Rivera", "Aiden Torres", "Jace Flores", "Bo Bennett", "Zion Parker"
        ]
        var entries: [LeaderboardEntry] = []
        for i in 0..<min(count, names.count) {
            let wins = Int.random(in: 5...40)
            let losses = Int.random(in: 0...max(1, wins / 2))
            let rating = Double(1000 + wins * 10 + Int.random(in: 0...120))
            let streakPool = [-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6]
            let entry = LeaderboardEntry(
                id: UUID(),
                name: names[i],
                rating: rating,
                wins: wins,
                losses: losses,
                currentStreak: streakPool.randomElement() ?? 0,
                homeCourt: randomCourt()
            )
            entries.append(entry)
        }
        return entries
    }
    
    private func randomCourt() -> String {
        let courts = [
            "Central Park Courts", "Brooklyn Heights", "Harlem Rucker Park", "Queensbridge Courts",
            "Sunset Park", "Prospect Park", "Riverside Courts", "Chelsea Piers"
        ]
        return courts.randomElement() ?? "Local Court"
    }
}


