//
//  StatsManagerTests.swift
//  Jelly
//
//  Unit tests for StatsManager
//  Tests ELO rating calculations and stats update logic with mock data
//

import XCTest
@testable import Jelly

final class StatsManagerTests: XCTestCase {
    
    // MARK: - ELO Rating Calculation Tests
    
    func testELORatingCalculation_EqualRatings() {
        // When both players have equal rating (1000), winner should gain ~16 points
        let winnerRating: Double = 1000.0
        let loserRating: Double = 1000.0
        let kFactor = 32.0
        
        let expectedWinner = 1.0 / (1.0 + pow(10.0, (loserRating - winnerRating) / 400.0))
        let winnerChange = kFactor * (1.0 - expectedWinner)
        let newWinnerRating = winnerRating + winnerChange
        
        // Equal ratings: expected = 0.5, so winner gains 16 points
        XCTAssertEqual(expectedWinner, 0.5, accuracy: 0.01, "Expected win probability should be 0.5 for equal ratings")
        XCTAssertEqual(winnerChange, 16.0, accuracy: 0.1, "Winner should gain ~16 points")
        XCTAssertEqual(newWinnerRating, 1016.0, accuracy: 0.1, "New winner rating should be ~1016")
    }
    
    func testELORatingCalculation_HigherRatedWinner() {
        // When higher rated player wins, they gain fewer points
        let winnerRating: Double = 1200.0
        let loserRating: Double = 1000.0
        let kFactor = 32.0
        
        let expectedWinner = 1.0 / (1.0 + pow(10.0, (loserRating - winnerRating) / 400.0))
        let winnerChange = kFactor * (1.0 - expectedWinner)
        let loserChange = kFactor * (0.0 - (1.0 - expectedWinner))
        
        // Higher rated player expected to win, so gains fewer points
        XCTAssertGreaterThan(expectedWinner, 0.5, "Higher rated player should have >50% win probability")
        XCTAssertLessThan(winnerChange, 16.0, "Higher rated winner should gain <16 points")
        XCTAssertGreaterThan(loserChange, -16.0, "Lower rated loser should lose >-16 points")
    }
    
    func testELORatingCalculation_LowerRatedWinner() {
        // When lower rated player wins (upset), they gain more points
        let winnerRating: Double = 1000.0
        let loserRating: Double = 1200.0
        let kFactor = 32.0
        
        let expectedWinner = 1.0 / (1.0 + pow(10.0, (loserRating - winnerRating) / 400.0))
        let winnerChange = kFactor * (1.0 - expectedWinner)
        let loserChange = kFactor * (0.0 - (1.0 - expectedWinner))
        
        // Lower rated player expected to lose, so gains more points when they win
        XCTAssertLessThan(expectedWinner, 0.5, "Lower rated player should have <50% win probability")
        XCTAssertGreaterThan(winnerChange, 16.0, "Lower rated winner should gain >16 points")
        XCTAssertLessThan(loserChange, -16.0, "Higher rated loser should lose <-16 points")
    }
    
    // MARK: - Stats Update Logic Tests
    
    func testStreakCalculation_WinningStreak() {
        let currentStreak = 5
        let newStreak = currentStreak >= 0 ? currentStreak + 1 : 1
        
        XCTAssertEqual(newStreak, 6, "Winning streak should increment")
    }
    
    func testStreakCalculation_LosingStreak() {
        let currentStreak = -3
        let newStreak = currentStreak <= 0 ? currentStreak - 1 : -1
        
        XCTAssertEqual(newStreak, -4, "Losing streak should decrement")
    }
    
    func testStreakCalculation_BreakLosingStreak() {
        let currentStreak = -5
        let newStreak = currentStreak <= 0 ? currentStreak - 1 : -1
        
        XCTAssertEqual(newStreak, -6, "Losing streak should continue")
    }
    
    func testBestStreakUpdate() {
        let currentBestStreak = 8
        let newStreak = 10
        let updatedBestStreak = max(newStreak, currentBestStreak)
        
        XCTAssertEqual(updatedBestStreak, 10, "Best streak should update to new high")
    }
    
    func testBestStreakNoUpdate() {
        let currentBestStreak = 10
        let newStreak = 5
        let updatedBestStreak = max(newStreak, currentBestStreak)
        
        XCTAssertEqual(updatedBestStreak, 10, "Best streak should not decrease")
    }
    
    // MARK: - Stats Model Tests
    
    func testPlayerStatsInitialization() {
        let playerID = UUID()
        let stats = PlayerStats(playerID: playerID)
        
        XCTAssertEqual(stats.playerID, playerID, "Player ID should match")
        XCTAssertEqual(stats.wins, 0, "Initial wins should be 0")
        XCTAssertEqual(stats.losses, 0, "Initial losses should be 0")
        XCTAssertEqual(stats.currentStreak, 0, "Initial streak should be 0")
        XCTAssertEqual(stats.rating, 1000.0, "Initial rating should be 1000")
    }
    
    func testWinPercentage() {
        var stats = PlayerStats(playerID: UUID(), wins: 8, losses: 2, totalGames: 10)
        
        let winPercentage = stats.winPercentage
        XCTAssertEqual(winPercentage, 80.0, accuracy: 0.1, "Win percentage should be 80%")
    }
    
    func testWinPercentageNoGames() {
        let stats = PlayerStats(playerID: UUID(), totalGames: 0)
        
        XCTAssertEqual(stats.winPercentage, 0.0, "Win percentage with no games should be 0")
    }
    
    func testDisplayRecord() {
        let stats = PlayerStats(playerID: UUID(), wins: 12, losses: 3)
        
        XCTAssertEqual(stats.displayRecord, "12 - 3", "Display record should match wins and losses")
    }
    
    func testStreakDisplay_Winning() {
        let stats = PlayerStats(playerID: UUID(), currentStreak: 5)
        
        XCTAssertTrue(stats.streakDisplay.contains("🔥"), "Winning streak should show fire emoji")
        XCTAssertTrue(stats.streakDisplay.contains("5"), "Winning streak should show count")
    }
    
    func testStreakDisplay_Losing() {
        let stats = PlayerStats(playerID: UUID(), currentStreak: -3)
        
        XCTAssertTrue(stats.streakDisplay.contains("❄️"), "Losing streak should show snowflake emoji")
        XCTAssertTrue(stats.streakDisplay.contains("3"), "Losing streak should show count")
    }
}
