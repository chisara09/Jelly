//
//  FirebaseIntegrationTests.swift
//  Jelly
//
//  Integration tests using Firebase Emulator Suite
//  These tests require Firebase emulators to be running
//  Run: firebase emulators:start
//

import XCTest
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
@testable import Jelly

/// Integration tests for Firebase operations
/// NOTE: These tests require Firebase Emulator Suite to be running
/// Run `firebase emulators:start` before running these tests
final class FirebaseIntegrationTests: XCTestCase {
    
    var authManager: AuthenticationManager!
    var gameManager: GameManager!
    var statsManager: StatsManager!
    var profileManager: ProfileManager!
    
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
        
        // Wait for Firebase to initialize
        // In a real test, you might want to use expectations
        sleep(1)
        
        authManager = AuthenticationManager()
        gameManager = GameManager()
        statsManager = StatsManager()
        profileManager = ProfileManager()
    }
    
    override func tearDown() {
        // Clean up: Sign out any authenticated users
        if Auth.auth().currentUser != nil {
            try? Auth.auth().signOut()
        }
        
        authManager = nil
        gameManager = nil
        statsManager = nil
        profileManager = nil
        
        super.tearDown()
    }
    
    // MARK: - Authentication Integration Tests
    
    func testSignUpFlow() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        let error = await authManager.signUp(email: email, password: password, name: name)
        
        XCTAssertNil(error, "Sign up should succeed without error")
        XCTAssertTrue(authManager.isAuthenticated, "User should be authenticated after sign up")
        XCTAssertNotNil(authManager.currentUser, "Current user should be set")
        XCTAssertEqual(authManager.currentUser?.email, email, "User email should match")
        XCTAssertEqual(authManager.currentUser?.name, name, "User name should match")
    }
    
    func testLoginFlow() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // First, sign up a user
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        let signUpError = await authManager.signUp(email: email, password: password, name: name)
        XCTAssertNil(signUpError, "Sign up should succeed")
        
        // Sign out
        authManager.logout()
        XCTAssertFalse(authManager.isAuthenticated, "User should be logged out")
        
        // Login
        let loginError = await authManager.login(email: email, password: password)
        
        XCTAssertNil(loginError, "Login should succeed without error")
        XCTAssertTrue(authManager.isAuthenticated, "User should be authenticated after login")
        XCTAssertEqual(authManager.currentUser?.email, email, "User email should match")
    }
    
    func testLoginWithWrongPassword() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // Sign up a user
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        _ = await authManager.signUp(email: email, password: password, name: name)
        authManager.logout()
        
        // Try to login with wrong password
        let error = await authManager.login(email: email, password: "wrongpassword")
        
        XCTAssertNotNil(error, "Login with wrong password should fail")
        XCTAssertFalse(authManager.isAuthenticated, "User should not be authenticated")
    }
    
    // MARK: - Profile Integration Tests
    
    func testGetProfile() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // Sign up a user
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        _ = await authManager.signUp(email: email, password: password, name: name)
        guard let userId = authManager.currentUser?.id else {
            XCTFail("User ID should be available")
            return
        }
        
        // Get profile
        let profile = try await profileManager.getProfile(userId: userId)
        
        XCTAssertNotNil(profile, "Profile should exist after sign up")
        XCTAssertEqual(profile?.name, name, "Profile name should match")
    }
    
    func testUpdateProfile() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // Sign up a user
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        _ = await authManager.signUp(email: email, password: password, name: name)
        guard let userId = authManager.currentUser?.id else {
            XCTFail("User ID should be available")
            return
        }
        
        // Update profile
        let newBio = "Updated bio"
        try await profileManager.updateProfile(userId: userId, name: nil, bio: newBio, homeCourtID: nil)
        
        // Get updated profile
        let updatedProfile = try await profileManager.getProfile(userId: userId)
        
        XCTAssertEqual(updatedProfile?.bio, newBio, "Bio should be updated")
    }
    
    // MARK: - Stats Integration Tests
    
    func testGetStats() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // Sign up a user
        let email = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        let name = "Test User"
        
        _ = await authManager.signUp(email: email, password: password, name: name)
        guard let userId = authManager.currentUser?.id else {
            XCTFail("User ID should be available")
            return
        }
        
        // Get stats
        let stats = try await statsManager.getStats(userId: userId)
        
        XCTAssertEqual(stats.wins, 0, "Initial wins should be 0")
        XCTAssertEqual(stats.losses, 0, "Initial losses should be 0")
        XCTAssertEqual(stats.rating, 1000.0, "Initial rating should be 1000")
    }
    
    func testUpdateStatsAfterGame() async throws {
        // Skip if emulators not configured
        try await skipIfEmulatorsNotRunning()
        
        // Sign up two users
        let email1 = "test\(UUID().uuidString.prefix(8))@example.com"
        let email2 = "test\(UUID().uuidString.prefix(8))@example.com"
        let password = "password123"
        
        _ = await authManager.signUp(email: email1, password: password, name: "Player 1")
        let winnerId = authManager.currentUser!.id
        
        authManager.logout()
        
        _ = await authManager.signUp(email: email2, password: password, name: "Player 2")
        let loserId = authManager.currentUser!.id
        
        // Update stats after game
        try await statsManager.updateStatsAfterGame(winnerID: winnerId, loserID: loserId)
        
        // Check winner stats
        let winnerStats = try await statsManager.getStats(userId: winnerId)
        XCTAssertEqual(winnerStats.wins, 1, "Winner should have 1 win")
        XCTAssertGreaterThan(winnerStats.rating, 1000.0, "Winner rating should increase")
        XCTAssertEqual(winnerStats.currentStreak, 1, "Winner should have winning streak of 1")
        
        // Check loser stats
        let loserStats = try await statsManager.getStats(userId: loserId)
        XCTAssertEqual(loserStats.losses, 1, "Loser should have 1 loss")
        XCTAssertLessThan(loserStats.rating, 1000.0, "Loser rating should decrease")
        XCTAssertEqual(loserStats.currentStreak, -1, "Loser should have losing streak of -1")
    }
    
    // MARK: - Helper Methods
    
    /// Skip test if Firebase emulators are not running
    private func skipIfEmulatorsNotRunning() async throws {
        // Try to connect to Firestore
        // If it fails, assume emulators are not running
        let db = Firestore.firestore()
        
        // Simple check: try to read a non-existent document
        // If emulators are not running, this will fail quickly
        do {
            _ = try await db.collection("_test").document("_check").getDocument()
        } catch {
            throw XCTSkip("Firebase emulators not running. Start with: firebase emulators:start")
        }
    }
}
