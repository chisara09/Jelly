//
//  AuthenticationManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    struct User: Identifiable, Codable {
        let id: UUID
        var email: String
        var name: String
        var createdAt: Date
        
        init(id: UUID = UUID(), email: String, name: String, createdAt: Date = Date()) {
            self.id = id
            self.email = email
            self.name = name
            self.createdAt = createdAt
        }
    }
    
    init() {
        // Reset all stored users on startup (for development)
        // loadUser()  // Commented out to start fresh - app will always show login screen
    }
    
    func signUp(email: String, password: String, name: String) -> String? {
        // Validation
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            return "Please fill in all fields."
        }
        
        guard email.contains("@") else {
            return "Please enter a valid email."
        }
        
        guard password.count >= 6 else {
            return "Password must be at least 6 characters."
        }
        
        // In a real app, this would make an API call
        // For now, we'll save locally
        let user = User(email: email, name: name)
        self.currentUser = user
        self.isAuthenticated = true
        
        saveUser()
        
        return nil // No error
    }
    
    func login(email: String, password: String) -> String? {
        guard !email.isEmpty, !password.isEmpty else {
            return "Please enter your email and password."
        }
        
        // In a real app, this would make an API call
        // For now, we'll simulate a successful login
        // In production, you'd validate against a backend
        
        // For demo purposes, we'll check if user data exists
        if let savedUser = getSavedUser() {
            self.currentUser = savedUser
            self.isAuthenticated = true
            return nil
        }
        
        return "Check your email or password."
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        clearUser()
    }
    
    // MARK: - Private helpers
    
    func resetAllData() {
        // Clear all stored user data
        UserDefaults.standard.removeObject(forKey: "currentUser")
        currentUser = nil
        isAuthenticated = false
    }
    
    private func saveUser() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
    
    private func loadUser() {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    private func getSavedUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    
    private func clearUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
