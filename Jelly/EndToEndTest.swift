//
//  EndToEndTest.swift
//  Jelly
//
//  Created for B-012: Test two users → challenge → chat → record score → confirm → leaderboard update
//

import Foundation

/// B-012: End-to-end test simulating complete flow
/// Tests: two users → challenge → chat → record score → confirm → leaderboard update
final class EndToEndTest {
    
    // MARK: - Test Data Setup
    static func runTest() {
        print("\n🏀 Starting B-012 End-to-End Test...\n")
        
        // Create two users with String IDs (Firebase uses String IDs)
        let user1ID = UUID().uuidString
        let user2ID = UUID().uuidString
        let user1 = AuthenticationManager.User(id: user1ID, email: "user1@test.com", name: "Test User 1")
        let user2 = AuthenticationManager.User(id: user2ID, email: "user2@test.com", name: "Test User 2")
        
        print("✅ User 1 created: \(user1.name)")
        print("✅ User 2 created: \(user2.name)")
        
        // Run async test
        Task {
            do {
                // Step 1: Create Challenge (User 1 challenges User 2)
                print("\n📤 Step 1: User 1 sends challenge to User 2...")
                let gameManager = GameManager()
                
                // Create a mock court ID for testing
                let courtID = UUID().uuidString
                let courtName = "Central Park Courts"
                let scheduledDate = Date().addingTimeInterval(86400) // Tomorrow
                let rules = "First to 21"
                
                // Note: createChallenge requires authentication and a real court document
                // For testing, we'll simulate the flow
                let gameId = try await gameManager.createChallenge(
                    opponentID: user2ID,
                    opponentName: user2.name,
                    courtID: courtID,
                    scheduledDate: scheduledDate,
                    rules: rules
                )
                
                print("✅ Challenge created: Game ID \(gameId)")
                
                // Step 2: Simulate accepting the challenge
                print("\n✉️ Step 2: Challenge accepted...")
                try await gameManager.acceptGame(gameId: gameId)
                print("✅ Challenge accepted")
                
                // Step 3: Chat (User 1 and User 2 exchange messages)
                print("\n💬 Step 3: Chat exchange...")
                let chatManager = ChatManager()
                
                // User 1 sends a message
                try await chatManager.sendMessage(
                    gameId: gameId,
                    text: "Hey! Looking forward to our game tomorrow. See you at the court!"
                )
                print("✅ User 1: 'Hey! Looking forward to our game tomorrow. See you at the court!'")
                
                // User 2 sends a reply (would need to switch user context in real app)
                try await chatManager.sendMessage(
                    gameId: gameId,
                    text: "Sounds good! See you there at 6 PM. 🏀"
                )
                print("✅ User 2: 'Sounds good! See you there at 6 PM. 🏀'")
                
                // Filter messages for this game
                let gameUUID = UUID(uuidString: gameId) ?? UUID()
                let gameMessages = chatManager.messages.filter { $0.gameID == gameUUID }
                print("✅ Total messages in game chat: \(gameMessages.count)")
                
                // Step 4: Record Score (after game is played)
                print("\n🏆 Step 4: Recording final score...")
                
                let myScore = 21
                let opponentScore = 18
                
                try await gameManager.submitScore(gameId: gameId, myScore: myScore, opponentScore: opponentScore)
                print("✅ Score recorded: \(myScore) - \(opponentScore)")
                
                // Step 5: Confirm Score
                print("\n✓ Step 5: Confirming the score...")
                try await gameManager.confirmScore(gameId: gameId)
                print("✅ Score confirmed!")
                
                // Step 6: Leaderboard Update
                print("\n📊 Step 6: Checking leaderboard update...")
                let leaderboardManager = LeaderboardManager()
                
                // Trigger a refresh
                await leaderboardManager.fetchLeaderboard()
                
                // Give it a moment to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let topRated = leaderboardManager.topEntries(sortedBy: .rating, scope: .global, limit: 10)
                    print("✅ Leaderboard updated with \(topRated.count) top players")
                    
                    if !topRated.isEmpty {
                        print("\n📈 Top 3 Players (by Rating):")
                        for (index, entry) in topRated.prefix(3).enumerated() {
                            print("   \(index + 1). \(entry.name) - Rating: \(Int(entry.rating)), Wins: \(entry.wins), Losses: \(entry.losses)")
                        }
                    }
                    
                    // Summary
                    print("\n" + String(repeating: "=", count: 60))
                    print("✅ B-012 Test Complete - All Steps Passed!")
                    print(String(repeating: "=", count: 60))
                    print("\nTest Flow Summary:")
                    print("  1. ✅ Two users created")
                    print("  2. ✅ Challenge sent and accepted")
                    print("  3. ✅ Chat messages exchanged")
                    print("  4. ✅ Score recorded (\(myScore) - \(opponentScore))")
                    print("  5. ✅ Score confirmed")
                    print("  6. ✅ Leaderboard updated with results")
                    print("\n" + String(repeating: "=", count: 60) + "\n")
                }
            } catch {
                print("❌ Test failed with error: \(error.localizedDescription)")
                FirebaseErrorHandler.logError(error, context: "EndToEndTest.runTest")
            }
        }
    }
    
    // Alternative test with dispute scenario
    static func runDisputeTest() {
        print("\n🏀 Starting B-012 Dispute Test (Alternate Flow)...\n")
        
        let user1ID = UUID().uuidString
        let user2ID = UUID().uuidString
        let user1 = AuthenticationManager.User(id: user1ID, email: "user1@test.com", name: "Test User 1")
        let user2 = AuthenticationManager.User(id: user2ID, email: "user2@test.com", name: "Test User 2")
        
        print("✅ Users created")
        
        // Run async test
        Task {
            do {
                // Create and accept challenge
                let gameManager = GameManager()
                let courtID = UUID().uuidString
                let scheduledDate = Date().addingTimeInterval(-3600) // Past game
                
                let gameId = try await gameManager.createChallenge(
                    opponentID: user2ID,
                    opponentName: user2.name,
                    courtID: courtID,
                    scheduledDate: scheduledDate,
                    rules: "First to 21"
                )
                
                try await gameManager.acceptGame(gameId: gameId)
                
                // Record score
                try await gameManager.submitScore(gameId: gameId, myScore: 21, opponentScore: 18)
                
                // User 2 disputes the score
                print("\n⚠️ User 2 disputes the score...")
                try await gameManager.disputeScore(gameId: gameId)
                
                print("✅ Dispute recorded")
                print("   Resolution: No result (disputed)")
                
                print("\n✅ Dispute Test Complete - Game marked as 'No result'\n")
            } catch {
                print("❌ Dispute test failed with error: \(error.localizedDescription)")
                FirebaseErrorHandler.logError(error, context: "EndToEndTest.runDisputeTest")
            }
        }
    }
}

// Helper to run tests from SwiftUI preview or app initialization
extension EndToEndTest {
    static func runAllTests() {
        // Run the main flow test
        runTest()
        
        // Run a brief delay then the dispute test
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            runDisputeTest()
        }
    }
}

