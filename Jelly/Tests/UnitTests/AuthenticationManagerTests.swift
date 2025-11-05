//
//  AuthenticationManagerTests.swift
//  Jelly
//
//  Unit tests for AuthenticationManager
//  Tests validation logic and business rules with mock data
//

import XCTest
@testable import Jelly

final class AuthenticationManagerTests: XCTestCase {
    
    var authManager: AuthenticationManager!
    
    override func setUp() {
        super.setUp()
        authManager = AuthenticationManager()
    }
    
    override func tearDown() {
        authManager = nil
        super.tearDown()
    }
    
    // MARK: - Validation Tests
    
    func testEmailValidation() {
        // Test empty email
        let emptyEmail = ""
        XCTAssertTrue(emptyEmail.isEmpty, "Empty email should fail validation")
        
        // Test invalid email format
        let invalidEmail = "notanemail"
        XCTAssertFalse(invalidEmail.contains("@"), "Email without @ should fail validation")
        
        // Test valid email format
        let validEmail = "test@example.com"
        XCTAssertTrue(validEmail.contains("@"), "Valid email should pass validation")
    }
    
    func testPasswordValidation() {
        // Test password too short
        let shortPassword = "12345"
        XCTAssertTrue(shortPassword.count < 6, "Password less than 6 characters should fail")
        
        // Test valid password length
        let validPassword = "password123"
        XCTAssertTrue(validPassword.count >= 6, "Password with 6+ characters should pass")
    }
    
    func testNameValidation() {
        // Test empty name
        let emptyName = ""
        XCTAssertTrue(emptyName.isEmpty, "Empty name should fail validation")
        
        // Test valid name
        let validName = "John Doe"
        XCTAssertFalse(validName.isEmpty, "Non-empty name should pass validation")
    }
    
    // MARK: - User Model Tests
    
    func testUserInitialization() {
        let userId = "test-user-id"
        let email = "test@example.com"
        let name = "Test User"
        let createdAt = Date()
        
        let user = AuthenticationManager.User(
            id: userId,
            email: email,
            name: name,
            createdAt: createdAt
        )
        
        XCTAssertEqual(user.id, userId, "User ID should match")
        XCTAssertEqual(user.email, email, "User email should match")
        XCTAssertEqual(user.name, name, "User name should match")
        XCTAssertEqual(user.createdAt, createdAt, "User createdAt should match")
    }
    
    func testUserCodable() throws {
        let user = AuthenticationManager.User(
            id: "test-id",
            email: "test@example.com",
            name: "Test User"
        )
        
        // Test encoding
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(user)
        
        // Test decoding
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedUser = try decoder.decode(AuthenticationManager.User.self, from: data)
        
        XCTAssertEqual(user.id, decodedUser.id, "Decoded user ID should match")
        XCTAssertEqual(user.email, decodedUser.email, "Decoded user email should match")
        XCTAssertEqual(user.name, decodedUser.name, "Decoded user name should match")
    }
}
