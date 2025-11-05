//
//  EndToEndFirebaseTests.swift
//  Jelly
//
//  End-to-end tests for complete Firebase flow
//  Tests: Sign up → Create profile → Find players → Create challenge → Chat → Record score → Confirm → Leaderboard update
//  NOTE: Requires Firebase Emulator Suite to be running
//

import XCTest
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
@testable import Jelly

/// End-to-end tests simulating complete user flows with Firebase
final class EndToEndFirebaseTests: XCTestCase {
    
    var authManager: AuthenticationManager!
    var gameManager: GameManager!
    var chatManager: ChatManager!
    var profileManager: ProfileManager!
    var statsManager: StatsManager!
    var leaderboardManager: LeaderboardManager!
    
    var user1Id: String?
    var user2Id: String?
    var courtId: String?
    
    override func setUp() {
        super.setUp()
        
        // Configure emulators BEFORE initializing Firebase
        FirebaseEmulatorConfig.configureEmulators()
        
        // Initialize Firebase (only if not already initialized)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Configure emulator-specific settings AFTER Firebase is initialized
        FirebaseEmulatorConfig.configureFirestoreEmulator()
        FirebaseEmulatorConfig.configureAuthEmulator()
        
        sleep(1) // Wait for Firebase initialization
        
        authManager = AuthenticationManager()
        gameManager = GameManager()
        chatManager = ChatManager()
        profileManager = ProfileManager()
        statsManager = StatsManager()
        leaderboardManager = LeaderboardManager()
    }
    
    override func tearDown() {
        // Clean up
        if Auth.auth().currentUser != nil {
            try? Auth.auth().signOut()
        }
        
        authManager = nil
        gameManager = nil
        chatManager = nil
        profileManager = nil
        statsManager = nil
        leaderboardManager = nil
        
        user1Id = nil
        user2Id = nil
        courtId = nil
        
        super.tearDown()
    }
    
    // MARK: - Complete Flow Test
    
    func testCompleteGameFlow() async throws {
        print("\n🏀 Starting Complete End-to-End Firebase Test...\n")
        
        // Step 1: Sign up two users
        print("📝 Step 1: Creating two users...")
        let email1 = "user1\(UUID().uuidString.prefix(8))@test.com"
        let email2 = "user2\(UUID().uuidString.prefix(8))@test.com"
        let password = "password123"
        
        var error1 = await authManager.signUp(email: email1, password: password, name: "Test User 1")
        XCTAssertNil(error1, "User 1 sign up should succeed")
        XCTAssertNotNil(authManager.currentUser, "User 1 should be created")
        user1Id = authManager.currentUser?.id
        print("✅ User 1 created: \(authManager.currentUser?.name ?? "Unknown")")
        
        // Sign out user 1
        authManager.logout()
        
        // Sign up user 2
        var error2 = await authManager.signUp(email: email2, password: password, name: "Test User 2")
        XCTAssertNil(error2, "User 2 sign up should succeed")
        XCTAssertNotNil(authManager.currentUser, "User 2 should be created")
        user2Id = authManager.currentUser?.id
        print("✅ User 2 created: \(authManager.currentUser?.name ?? "Unknown")")
        
        // Step 2: Create a court (prerequisite for creating challenges)
        print("\n🏟️ Step 2: Creating a test court...")
        let db = Firestore.firestore()
        let courtData: [String: Any] = [
            "name": "Central Park Courts",
            "address": "123 Main St, NYC",
            "latitude": 40.785091,
            "longitude": -73.968285,
            "createdAt": Timestamp(date: Date())
        ]
        
        let courtRef = try await db.collection("courts").addDocument(data: courtData)
        courtId = courtRef.documentID
        print("✅ Court created: Central Park Courts")
        
        // Step 3: User 1 logs in and creates a challenge for User 2
        print("\n📤 Step 3: User 1 creates challenge for User 2...")
        authManager.logout()
        error1 = await authManager.login(email: email1, password: password)
        XCTAssertNil(error1, "User 1 login should succeed")
        guard let challengerId = authManager.currentUser?.id,
              let opponentId = user2Id,
              let courtID = courtId else {
            XCTFail("Required IDs should be available")
            return
        }
        
        let scheduledDate = Date().addingTimeInterval(86400) // Tomorrow
        let gameId = try await gameManager.createChallenge(
            opponentID: opponentId,
            opponentName: "Test User 2",
            courtID: courtID,
            scheduledDate: scheduledDate,
            rules: "First to 21"
        )
        
        print("✅ Challenge created: Game ID \(gameId)")
        
        // Step 4: User 2 logs in and accepts the challenge
        print("\n✉️ Step 4: User 2 accepts the challenge...")
        authManager.logout()
        error2 = await authManager.login(email: email2, password: password)
        XCTAssertNil(error2, "User 2 login should succeed")
        
        try await gameManager.acceptGame(gameId: gameId)
        print("✅ Challenge accepted")
        
        // Step 5: Chat exchange
        print("\n💬 Step 5: Chat exchange...")
        chatManager.listenToMessages(gameId: gameId)
        
        // User 1 sends a message (switch to user 1)
        authManager.logout()
        _ = await authManager.login(email: email1, password: password)
        
        try await chatManager.sendMessage(gameId: gameId, text: "Hey! Looking forward to our game tomorrow. See you at the court!")
        print("✅ User 1 sent message")
        
        // Wait a bit for message to be written
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // User 2 sends a reply (switch to user 2)
        authManager.logout()
        _ = await authManager.login(email: email2, password: password)
        
        try await chatManager.sendMessage(gameId: gameId, text: "Sounds good! See you there at 6 PM. 🏀")
        print("✅ User 2 sent message")
        
        // Wait for messages to sync
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        XCTAssertGreaterThanOrEqual(chatManager.messages.count, 2, "Should have at least 2 messages")
        print("✅ Total messages: \(chatManager.messages.count)")
        
        // Step 6: Record scores (simulate game completion)
        print("\n🏆 Step 6: Recording final scores...")
        
        // User 1 submits score
        authManager.logout()
        _ = await authManager.login(email: email1, password: password)
        
        try await gameManager.submitScore(gameId: gameId, myScore: 21, opponentScore: 18)
        print("✅ User 1 submitted score: 21 - 18")
        
        // User 2 submits score (matching)
        authManager.logout()
        _ = await authManager.login(email: email2, password: password)
        
        try await gameManager.submitScore(gameId: gameId, myScore: 18, opponentScore: 21)
        print("✅ User 2 submitted score: 18 - 21")
        
        // Wait for score processing
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Verify game is completed
        let db = Firestore.firestore()
        let gameDoc = try await db.collection("games").document(gameId).getDocument()
        let gameData = gameDoc.data()
        
        let status = gameData?["status"] as? String
        let isConfirmed = gameData?["isConfirmed"] as? Bool ?? false
        
        XCTAssertEqual(status, "completed", "Game should be completed")
        XCTAssertTrue(isConfirmed, "Game should be confirmed")
        print("✅ Game completed and confirmed")
        
        // Step 7: Verify stats were updated
        print("\n📊 Step 7: Verifying stats updates...")
        
        // Check winner stats (User 1)
        authManager.logout()
        _ = await authManager.login(email: email1, password: password)
        let winnerStats = try await statsManager.getStats(userId: challengerId)
        
        XCTAssertEqual(winnerStats.wins, 1, "Winner should have 1 win")
        XCTAssertGreaterThan(winnerStats.rating, 1000.0, "Winner rating should increase")
        print("✅ Winner stats: \(winnerStats.wins) wins, Rating: \(winnerStats.rating)")
        
        // Check loser stats (User 2)
        authManager.logout()
        _ = await authManager.login(email: email2, password: password)
        let loserStats = try await statsManager.getStats(userId: opponentId)
        
        XCTAssertEqual(loserStats.losses, 1, "Loser should have 1 loss")
        XCTAssertLessThan(loserStats.rating, 1000.0, "Loser rating should decrease")
        print("✅ Loser stats: \(loserStats.losses) losses, Rating: \(loserStats.rating)")
        
        // Step 8: Check leaderboard
        print("\n📈 Step 8: Checking leaderboard...")
        try await leaderboardManager.fetchLeaderboard(sortBy: .rating, limit: 10)
        
        // Wait for leaderboard to update
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        XCTAssertGreaterThanOrEqual(leaderboardManager.leaderboard.count, 2, "Leaderboard should have at least 2 players")
        
        // Verify User 1 (winner) has higher rating than User 2 (loser)
        let user1Entry = leaderboardManager.leaderboard.first { $0.id == challengerId }
        let user2Entry = leaderboardManager.leaderboard.first { $0.id == opponentId }
        
        if let user1 = user1Entry, let user2 = user2Entry {
            XCTAssertGreaterThan(user1.rating, user2.rating, "Winner should have higher rating than loser")
            print("✅ Leaderboard shows User 1 (\(user1.rating)) > User 2 (\(user2.rating))")
        }
        
        // Summary
        print("\n" + String(repeating: "=", count: 60))
        print("✅ End-to-End Test Complete - All Steps Passed!")
        print(String(repeating: "=", count: 60))
        print("\nTest Flow Summary:")
        print("  1. ✅ Two users created and authenticated")
        print("  2. ✅ Court created")
        print("  3. ✅ Challenge created")
        print("  4. ✅ Challenge accepted")
        print("  5. ✅ Chat messages exchanged")
        print("  6. ✅ Scores recorded and confirmed")
        print("  7. ✅ Stats updated for both players")
        print("  8. ✅ Leaderboard updated")
        print("\n" + String(repeating: "=", count: 60) + "\n")
    }
    
    // MARK: - Dispute Flow Test
    
    func testDisputeFlow() async throws {
        print("\n🏀 Starting Dispute Flow Test...\n")
        
        // Create users and game (similar setup to above)
        let email1 = "user1\(UUID().uuidString.prefix(8))@test.com"
        let email2 = "user2\(UUID().uuidString.prefix(8))@test.com"
        let password = "password123"
        
        _ = await authManager.signUp(email: email1, password: password, name: "Player 1")
        let user1Id = authManager.currentUser!.id
        authManager.logout()
        
        _ = await authManager.signUp(email: email2, password: password, name: "Player 2")
        let user2Id = authManager.currentUser!.id
        
        // Create court
        let db = Firestore.firestore()
        let courtData: [String: Any] = [
            "name": "Test Court",
            "address": "123 Test St",
            "latitude": 40.0,
            "longitude": -73.0,
            "createdAt": Timestamp(date: Date())
        ]
        let courtRef = try await db.collection("courts").addDocument(data: courtData)
        
        // User 1 creates challenge
        authManager.logout()
        _ = await authManager.login(email: email1, password: password)
        
        let gameId = try await gameManager.createChallenge(
            opponentID: user2Id,
            opponentName: "Player 2",
            courtID: courtRef.documentID,
            scheduledDate: Date().addingTimeInterval(-3600), // Past game
            rules: "First to 21"
        )
        
        // Accept game
        authManager.logout()
        _ = await authManager.login(email: email2, password: password)
        try await gameManager.acceptGame(gameId: gameId)
        
        // User 1 submits score
        authManager.logout()
        _ = await authManager.login(email: email1, password: password)
        try await gameManager.submitScore(gameId: gameId, myScore: 21, opponentScore: 18)
        
        // User 2 submits different score (dispute)
        authManager.logout()
        _ = await authManager.login(email: email2, password: password)
        try await gameManager.submitScore(gameId: gameId, myScore: 20, opponentScore: 21) // Disputed
        
        // Wait for processing
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Verify dispute status
        let gameDoc = try await db.collection("games").document(gameId).getDocument()
        let status = gameDoc.data()?["status"] as? String
        
        XCTAssertEqual(status, "disputed", "Game should be marked as disputed")
        print("✅ Dispute recorded - Game status: disputed")
    }
}
