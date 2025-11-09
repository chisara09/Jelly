//
//  LeaderboardManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/28/25.
//

import Foundation
import FirebaseFirestore
import Combine
import CoreLocation

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
    let latitude: Double?
    let longitude: Double?
}

struct LeaderboardSnapshot: Codable, Equatable {
    let generatedAt: Date
    let entries: [LeaderboardEntry]
}

final class LeaderboardManager: ObservableObject {
    @Published private(set) var snapshot: LeaderboardSnapshot?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private let storageKey = "leaderboard_snapshot_v1"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSnapshot()
        if snapshot == nil {
            // Try to fetch from Firestore, fallback to mock if needed
            Task {
                await fetchLeaderboard()
            }
        }
    }
    
    // MARK: - Public API
    func topEntries(sortedBy metric: LeaderboardMetric, scope: LeaderboardScope, limit: Int = 50) -> [LeaderboardEntry] {
        guard let snapshot else { return [] }
        var filteredEntries = snapshot.entries
        
        // Filter by scope
        if scope == .local {
            filteredEntries = filterLocalEntries(entries: filteredEntries)
        }
        
        let sorted = sort(entries: filteredEntries, by: metric)
        return Array(sorted.prefix(limit))
    }
    
    private func filterLocalEntries(entries: [LeaderboardEntry]) -> [LeaderboardEntry] {
        // Get user's location from LocationManager if available
        // For now, we'll filter by proximity to a mock user location
        // In production, this would use actual user location
        let userLocation = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855) // NYC default
        let localRadiusMiles = 25.0
        
        return entries.filter { entry in
            guard let lat = entry.latitude, let lon = entry.longitude else { return false }
            let entryLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let distance = distanceInMiles(from: userLocation, to: entryLocation)
            return distance <= localRadiusMiles
        }
    }
    
    private func distanceInMiles(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let distanceInMeters = fromLocation.distance(from: toLocation)
        return distanceInMeters / 1609.34 // Convert meters to miles
    }
    
    enum LeaderboardScope: String, CaseIterable, Identifiable {
        case global = "Global"
        case local = "Local"
        
        var id: String { rawValue }
    }
    
    // MARK: - Firestore Integration
    
    func fetchLeaderboard(sortBy: LeaderboardMetric = .rating, limit: Int = 100) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let field = sortBy.field
            let query = db.collection("stats")
                .order(by: field, descending: true)
                .limit(to: limit)
            
            let snapshot = try await query.getDocuments()
            
            var entries: [LeaderboardEntry] = []
            
            for document in snapshot.documents {
                let data = document.data()
                let userId = document.documentID
                
                // Fetch profile for name and location
                let profileDoc = try? await db.collection("profiles").document(userId).getDocument()
                let profileData = profileDoc?.data() ?? [:]
                let name = profileData["name"] as? String ?? "Unknown"
                let homeCourtID = profileData["homeCourtID"] as? String ?? ""
                
                // Get location from profile
                var latitude: Double? = nil
                var longitude: Double? = nil
                if let location = profileData["location"] as? [String: Any] {
                    latitude = location["latitude"] as? Double
                    longitude = location["longitude"] as? Double
                }
                
                // Get home court name if available
                var homeCourtName = ""
                if !homeCourtID.isEmpty {
                    let courtDoc = try? await db.collection("courts").document(homeCourtID).getDocument()
                    homeCourtName = courtDoc?.data()?["name"] as? String ?? ""
                }
                
                // Convert String ID to UUID
                let entryId = UUID(uuidString: userId) ?? UUID()
                
                let entry = LeaderboardEntry(
                    id: entryId,
                    name: name,
                    rating: data["rating"] as? Double ?? 1000.0,
                    wins: data["wins"] as? Int ?? 0,
                    losses: data["losses"] as? Int ?? 0,
                    currentStreak: data["currentStreak"] as? Int ?? 0,
                    homeCourt: homeCourtName,
                    latitude: latitude,
                    longitude: longitude
                )
                
                entries.append(entry)
            }
            
            let snap = LeaderboardSnapshot(generatedAt: Date(), entries: entries)
            
            await MainActor.run {
                self.snapshot = snap
                self.isLoading = false
                self.saveSnapshot()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load leaderboard."
                self.isLoading = false
                // Fallback to cached snapshot or mock data
                if self.snapshot == nil {
                    self.regenerateMockSnapshot()
                }
            }
        }
    }
    
    // MARK: - Sorting
    enum LeaderboardMetric: String, CaseIterable, Identifiable {
        case rating = "Rating"
        case wins = "Wins"
        case streak = "Streak"
        
        var id: String { rawValue }
        
        var field: String {
            switch self {
            case .rating: return "rating"
            case .wins: return "wins"
            case .streak: return "currentStreak"
            }
        }
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
    
    // MARK: - Mock Data (fallback)
    private func regenerateMockSnapshot() {
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
            let (court, lat, lon) = randomCourtWithLocation()
            let entry = LeaderboardEntry(
                id: UUID(),
                name: names[i],
                rating: rating,
                wins: wins,
                losses: losses,
                currentStreak: streakPool.randomElement() ?? 0,
                homeCourt: court,
                latitude: lat,
                longitude: lon
            )
            entries.append(entry)
        }
        return entries
    }
    
    private func randomCourtWithLocation() -> (name: String, latitude: Double, longitude: Double) {
        if let court = CourtCatalog.defaultCourts.randomElement() {
            return (court.name, court.latitude, court.longitude)
        }
        return ("Local Court", 40.7580, -73.9855)
    }
}


