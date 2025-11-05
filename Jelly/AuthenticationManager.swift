//
//  AuthenticationManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var authError: String?
    
    struct User: Identifiable, Codable {
        let id: String // Firebase uses String IDs
        var email: String
        var name: String
        var createdAt: Date
        
        init(id: String, email: String, name: String, createdAt: Date = Date()) {
            self.id = id
            self.email = email
            self.name = name
            self.createdAt = createdAt
        }
    }
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        // Listen for auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                if let firebaseUser = firebaseUser {
                    await self?.loadUserProfile(firebaseUser: firebaseUser)
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) async -> String? {
        do {
            // Validate inputs
            guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
                return "Please fill in all fields."
            }
            
            guard email.contains("@") else {
                return "Please enter a valid email."
            }
            
            guard password.count >= 6 else {
                return "Password must be at least 6 characters."
            }
            
            // Create Firebase Auth user
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            // Create user document in Firestore
            let userData: [String: Any] = [
                "email": email,
                "name": name,
                "createdAt": Timestamp(date: Date()),
                "lastLoginAt": Timestamp(date: Date())
            ]
            
            try await db.collection("users").document(userId).setData(userData)
            
            // Create profile document
            let profileData: [String: Any] = [
                "name": name,
                "bio": "",
                "homeCourtID": "",
                "location": [
                    "latitude": 0.0,
                    "longitude": 0.0,
                    "lastUpdated": Timestamp(date: Date())
                ],
                "settings": [
                    "notificationsEnabled": true,
                    "darkMode": false
                ]
            ]
            
            try await db.collection("profiles").document(userId).setData(profileData)
            
            // Create stats document
            let statsData: [String: Any] = [
                "wins": 0,
                "losses": 0,
                "currentStreak": 0,
                "bestStreak": 0,
                "totalGames": 0,
                "rating": 1000.0,
                "lastGameDate": Timestamp(date: Date())
            ]
            
            try await db.collection("stats").document(userId).setData(statsData)
            
            // Load user profile
            await loadUserProfile(firebaseUser: authResult.user)
            
            return nil // Success
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "signUp")
            // Return user-friendly error message
            return FirebaseErrorHandler.userFriendlyMessage(for: error)
        }
    }
    
    func login(email: String, password: String) async -> String? {
        do {
            guard !email.isEmpty, !password.isEmpty else {
                return "Please enter your email and password."
            }
            
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Update lastLoginAt
            try await db.collection("users").document(authResult.user.uid).updateData([
                "lastLoginAt": Timestamp(date: Date())
            ])
            
            await loadUserProfile(firebaseUser: authResult.user)
            
            return nil // Success
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "login")
            // Return user-friendly error message
            return FirebaseErrorHandler.userFriendlyMessage(for: error)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "logout")
            // Set user-friendly error message
            authError = FirebaseErrorHandler.userFriendlyMessage(for: error)
        }
    }
    
    // MARK: - Private Helpers
    
    private func loadUserProfile(firebaseUser: FirebaseAuth.User) async {
        do {
            let userDoc = try await db.collection("users").document(firebaseUser.uid).getDocument()
            
            guard let data = userDoc.data(),
                  let email = data["email"] as? String,
                  let name = data["name"] as? String else {
                return
            }
            
            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
            
            await MainActor.run {
                self.currentUser = User(
                    id: firebaseUser.uid,
                    email: email,
                    name: name,
                    createdAt: createdAt
                )
                self.isAuthenticated = true
            }
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "loadUserProfile")
            await MainActor.run {
                // Set user-friendly error message
                self.authError = FirebaseErrorHandler.userFriendlyMessage(for: error)
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
