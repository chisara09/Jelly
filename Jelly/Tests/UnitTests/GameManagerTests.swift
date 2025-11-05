//
//  GameManagerTests.swift
//  Jelly
//
//  Unit tests for GameManager
//  Tests game filtering, status transitions, and business logic with mock data
//

import XCTest
@testable import Jelly

final class GameManagerTests: XCTestCase {
    
    var gameManager: GameManager!
    
    // Mock games for testing
    var mockGames: [Game] = []
    
    override func setUp() {
        super.setUp()
        gameManager = GameManager()
        
        // Create mock games with different statuses
        let challengerID = UUID()
        let opponentID = UUID()
        let today = Date()
        
        mockGames = [
            Game(
                id: UUID(),
                challengerID: challengerID,
                opponentID: opponentID,
                opponentName: "Player 1",
                courtName: "Court A",
                courtAddress: "123 Main St",
                scheduledDate: today.addingTimeInterval(86400), // Tomorrow
                status: .pending
            ),
            Game(
                id: UUID(),
                challengerID: challengerID,
                opponentID: opponentID,
                opponentName: "Player 2",
                courtName: "Court B",
                courtAddress: "456 Oak Ave",
                scheduledDate: today.addingTimeInterval(172800), // Day after tomorrow
                status: .accepted
            ),
            Game(
                id: UUID(),
                challengerID: challengerID,
                opponentID: opponentID,
                opponentName: "Player 3",
                courtName: "Court C",
                courtAddress: "789 Pine St",
                scheduledDate: today.addingTimeInterval(-86400), // Yesterday
                status: .completed,
                winnerID: challengerID,
                challengerScore: 21,
                opponentScore: 18,
                isConfirmed: true
            ),
            Game(
                id: UUID(),
                challengerID: challengerID,
                opponentID: opponentID,
                opponentName: "Player 4",
                courtName: "Court D",
                courtAddress: "321 Elm St",
                scheduledDate: today.addingTimeInterval(-172800), // Two days ago
                status: .canceled
            ),
            Game(
                id: UUID(),
                challengerID: challengerID,
                opponentID: opponentID,
                opponentName: "Player 5",
                courtName: "Court E",
                courtAddress: "654 Maple Dr",
                scheduledDate: today.addingTimeInterval(259200), // Three days from now
                status: .accepted
            )
        ]
        
        // Set games in manager
        gameManager.games = mockGames
    }
    
    override func tearDown() {
        gameManager = nil
        mockGames = []
        super.tearDown()
    }
    
    // MARK: - Filter Tests
    
    func testGetAllGames() {
        let allGames = gameManager.getAllGames()
        XCTAssertEqual(allGames.count, 5, "Should return all 5 games")
    }
    
    func testGetPendingGames() {
        let pendingGames = gameManager.getPendingGames()
        XCTAssertEqual(pendingGames.count, 1, "Should return 1 pending game")
        XCTAssertEqual(pendingGames.first?.status, .pending, "All returned games should be pending")
    }
    
    func testGetCompletedGames() {
        let completedGames = gameManager.getCompletedGames()
        XCTAssertEqual(completedGames.count, 1, "Should return 1 completed game")
        XCTAssertEqual(completedGames.first?.status, .completed, "Returned game should be completed")
    }
    
    func testGetUpcomingGames() {
        let upcomingGames = gameManager.getUpcomingGames()
        // Upcoming games are accepted or pending with future dates
        XCTAssertGreaterThanOrEqual(upcomingGames.count, 1, "Should return at least 1 upcoming game")
        for game in upcomingGames {
            XCTAssertTrue(game.scheduledDate > Date(), "Upcoming game should have future date")
        }
    }
    
    // MARK: - Game Status Tests
    
    func testGameStatusPending() {
        let game = mockGames[0]
        XCTAssertEqual(game.status, .pending, "Game should be pending")
        XCTAssertEqual(game.status.displayName, "Pending", "Display name should match")
    }
    
    func testGameStatusAccepted() {
        let game = mockGames[1]
        XCTAssertEqual(game.status, .accepted, "Game should be accepted")
        XCTAssertEqual(game.status.displayName, "Scheduled", "Display name should match")
    }
    
    func testGameStatusCompleted() {
        let game = mockGames[2]
        XCTAssertEqual(game.status, .completed, "Game should be completed")
        XCTAssertEqual(game.status.displayName, "Completed", "Display name should match")
        XCTAssertNotNil(game.winnerID, "Completed game should have winner")
        XCTAssertTrue(game.isConfirmed, "Completed game should be confirmed")
    }
    
    func testGameStatusCanceled() {
        let game = mockGames[3]
        XCTAssertEqual(game.status, .canceled, "Game should be canceled")
        XCTAssertEqual(game.status.displayName, "Canceled", "Display name should match")
    }
    
    // MARK: - Game Model Tests
    
    func testGameInitialization() {
        let game = Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Test Opponent",
            courtName: "Test Court",
            courtAddress: "Test Address",
            scheduledDate: Date()
        )
        
        XCTAssertEqual(game.status, .pending, "Default status should be pending")
        XCTAssertEqual(game.rules, "First to 21", "Default rules should be 'First to 21'")
        XCTAssertFalse(game.isConfirmed, "Default isConfirmed should be false")
        XCTAssertNil(game.winnerID, "Default winnerID should be nil")
    }
    
    func testGameIsUpcoming() {
        let futureGame = Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Opponent",
            courtName: "Court",
            courtAddress: "Address",
            scheduledDate: Date().addingTimeInterval(3600), // 1 hour from now
            status: .accepted
        )
        
        XCTAssertTrue(futureGame.isUpcoming, "Future accepted game should be upcoming")
    }
    
    func testGameIsNotUpcoming() {
        let pastGame = Game(
            challengerID: UUID(),
            opponentID: UUID(),
            opponentName: "Opponent",
            courtName: "Court",
            courtAddress: "Address",
            scheduledDate: Date().addingTimeInterval(-3600), // 1 hour ago
            status: .completed
        )
        
        XCTAssertFalse(pastGame.isUpcoming, "Past completed game should not be upcoming")
    }
}
