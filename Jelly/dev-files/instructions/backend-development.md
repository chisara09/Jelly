# Backend Development Guide — 1v1 Hoops (Firebase)

This document outlines the complete steps to build a functioning Firebase backend for the 1v1 Hoops app.

---

## Overview

Your app currently uses local storage (UserDefaults) for data. To make it fully functional with real users, you need a Firebase backend that handles:
- User authentication and authorization
- Persistent data storage (Cloud Firestore)
- Real-time messaging
- Push notifications (Firebase Cloud Messaging)
- Location-based queries
- Score verification and leaderboard calculations
- Multi-user synchronization

**Technology Stack**: Firebase (Authentication, Firestore, Cloud Storage, Cloud Functions, Cloud Messaging)

---

## Step 1: Set Up Firebase Project

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" or "Create a project"
3. Enter project name: "1v1-Hoops" (or your preferred name)
4. Enable Google Analytics (optional, recommended)
5. Complete project creation

### 1.2 Add iOS App to Firebase
1. In Firebase console, click "Add app" → iOS
2. Enter iOS bundle ID (find in Xcode project settings)
3. Register app
4. Download `GoogleService-Info.plist`
5. Add `GoogleService-Info.plist` to your Xcode project:
   - Drag file into Xcode project navigator
   - Make sure "Copy items if needed" is checked
   - Add to target: Jelly

### 1.3 Install Firebase SDK
1. In Xcode, go to **File → Add Packages...**
2. Enter package URL: `https://github.com/firebase/firebase-ios-sdk`
3. Select version (latest stable)
4. Add these products to your project:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseMessaging
   - FirebaseFunctions (optional, for server-side logic)

### 1.4 Initialize Firebase in Your App
In `JellyApp.swift` or similar entry point, add:

```swift
import SwiftUI
import FirebaseCore

@main
struct JellyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 1.5 Enable Firebase Services

#### Authentication:
1. Go to Firebase Console → Authentication
2. Click "Get Started"
3. Enable "Email/Password" sign-in method
4. Click "Save"

#### Cloud Firestore:
1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose a location (closest to your users)
5. Click "Enable"

#### Cloud Storage:
1. Go to Firebase Console → Storage
2. Click "Get started"
3. Start in **test mode** (for development)
4. Choose same location as Firestore
5. Click "Done"

#### Cloud Messaging:
1. Go to Firebase Console → Cloud Messaging
2. Set up APNs authentication:
   - Go to your Apple Developer account
   - Create APNs Authentication Key (.p8 file)
   - Upload to Firebase Console under Cloud Messaging → Apple app configuration
   - Enter your Team ID and Key ID

---

## Step 2: Design Firestore Database Schema

Firestore uses collections (similar to tables) and documents (rows). Here's the structure:

### Collections Structure:

```
Firestore Root
├── users/{userId}
│   ├── email: String
│   ├── name: String
│   ├── createdAt: Timestamp
│   └── lastLoginAt: Timestamp
│
├── profiles/{userId}
│   ├── name: String
│   ├── photoURL: String?
│   ├── bio: String
│   ├── homeCourtID: String?
│   ├── location: {
│   │     latitude: Double,
│   │     longitude: Double,
│   │     lastUpdated: Timestamp
│   │   }
│   └── settings: {
│         notificationsEnabled: Boolean,
│         darkMode: Boolean
│       }
│
├── courts/{courtId}
│   ├── name: String
│   ├── address: String
│   ├── latitude: Double
│   ├── longitude: Double
│   └── createdAt: Timestamp
│
├── games/{gameId}
│   ├── challengerID: String (references users/{userId})
│   ├── opponentID: String (references users/{userId})
│   ├── courtID: String (references courts/{courtId})
│   ├── scheduledDate: Timestamp
│   ├── rules: String
│   ├── status: String ("pending", "accepted", "completed", "canceled", "disputed")
│   ├── challengerScore: Int?
│   ├── opponentScore: Int?
│   ├── winnerID: String?
│   ├── loserID: String?
│   ├── isConfirmed: Boolean
│   ├── createdAt: Timestamp
│   └── updatedAt: Timestamp
│
├── messages/{messageId}
│   ├── gameID: String (references games/{gameId})
│   ├── senderID: String (references users/{userId})
│   ├── senderName: String
│   ├── text: String
│   ├── timestamp: Timestamp
│   └── isRead: Map<String, Boolean> (userId → isRead)
│
├── stats/{userId}
│   ├── wins: Int
│   ├── losses: Int
│   ├── currentStreak: Int
│   ├── bestStreak: Int
│   ├── totalGames: Int
│   ├── rating: Double
│   └── lastGameDate: Timestamp
│
├── blocked/{blockerId}/blocked/{blockedId}
│   └── createdAt: Timestamp
│
└── reports/{reportId}
    ├── reporterID: String
    ├── reportedID: String
    ├── reason: String
    ├── description: String
    ├── createdAt: Timestamp
    └── status: String ("pending", "reviewed", "resolved")
```

### Firestore Indexes to Create:
1. **games collection**:
   - `challengerID` (Ascending) + `status` (Ascending)
   - `opponentID` (Ascending) + `status` (Ascending)
   - `scheduledDate` (Ascending)

2. **messages collection**:
   - `gameID` (Ascending) + `timestamp` (Descending)

3. **stats collection**:
   - `rating` (Descending) - for leaderboard

4. **profiles collection** (for geospatial queries):
   - `location.latitude` + `location.longitude` (if using geohash)
   - Or use Firestore GeoPoint queries

**Note**: Firestore will prompt you to create indexes when you run queries that need them. You can also create them manually in the Firebase Console.

---

## Step 3: Implement Authentication

Firebase Authentication handles signup/login/logout automatically. You'll update your `AuthenticationManager.swift` to use Firebase.

### 3.1 Update AuthenticationManager.swift

Replace your current `AuthenticationManager.swift` with Firebase integration:

```swift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var authError: String?
    
    struct User: Identifiable, Codable {
        let id: String
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
            return error.localizedDescription
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
            return "Check your email or password."
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            authError = error.localizedDescription
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
            await MainActor.run {
                self.authError = error.localizedDescription
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
```

### 3.2 Update Views to Use Async Functions

Update your `LoginView.swift` and `SignUpView.swift` to handle async authentication:

```swift
// Example for LoginView
Button("Log In") {
    Task {
        if let error = await authManager.login(email: email, password: password) {
            showError = true
            errorMessage = error
        }
    }
}
```

---

## Step 4: Implement Profile Management

### 4.1 Create ProfileManager.swift

Create a new file `Managers/ProfileManager.swift`:

```swift
import Foundation
import FirebaseFirestore
import FirebaseStorage
import Combine

class ProfileManager: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func getProfile(userId: String) async throws -> PlayerProfile? {
        let doc = try await db.collection("profiles").document(userId).getDocument()
        guard let data = doc.data() else { return nil }
        
        return PlayerProfile(
            id: userId,
            name: data["name"] as? String ?? "",
            photoURL: data["photoURL"] as? String,
            bio: data["bio"] as? String ?? "",
            homeCourt: data["homeCourtID"] as? String ?? "",
            email: "" // Will be fetched separately if needed
        )
    }
    
    func updateProfile(userId: String, name: String?, bio: String?, homeCourtID: String?) async throws {
        var updates: [String: Any] = [:]
        
        if let name = name {
            updates["name"] = name
        }
        if let bio = bio {
            updates["bio"] = bio
        }
        if let homeCourtID = homeCourtID {
            updates["homeCourtID"] = homeCourtID
        }
        
        try await db.collection("profiles").document(userId).updateData(updates)
    }
    
    func uploadPhoto(userId: String, imageData: Data) async throws -> String {
        let ref = storage.reference().child("profile_photos/\(userId).jpg")
        
        _ = try await ref.putDataAsync(imageData, metadata: nil)
        let downloadURL = try await ref.downloadURL()
        
        // Update profile with photo URL
        try await db.collection("profiles").document(userId).updateData([
            "photoURL": downloadURL.absoluteString
        ])
        
        return downloadURL.absoluteString
    }
    
    func updateLocation(userId: String, latitude: Double, longitude: Double) async throws {
        try await db.collection("profiles").document(userId).updateData([
            "location": [
                "latitude": latitude,
                "longitude": longitude,
                "lastUpdated": Timestamp(date: Date())
            ]
        ])
    }
}
```

---

## Step 5: Implement Courts Management

### 5.1 Update LocationManager.swift

Add court fetching to your existing `LocationManager.swift`:

```swift
import Foundation
import FirebaseFirestore
import CoreLocation

extension LocationManager {
    func fetchCourts(near location: CLLocationCoordinate2D?, radius: Double = 10.0) async throws -> [Court] {
        let db = Firestore.firestore()
        var courts: [Court] = []
        
        let snapshot = try await db.collection("courts").getDocuments()
        
        for document in snapshot.documents {
            guard let data = document.data(),
                  let name = data["name"] as? String,
                  let address = data["address"] as? String,
                  let latitude = data["latitude"] as? Double,
                  let longitude = data["longitude"] as? Double else {
                continue
            }
            
            let court = Court(
                id: UUID(uuidString: document.documentID) ?? UUID(),
                name: name,
                address: address,
                latitude: latitude,
                longitude: longitude
            )
            
            // Filter by radius if location provided
            if let location = location {
                let courtLocation = CLLocation(latitude: latitude, longitude: longitude)
                let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let distance = courtLocation.distance(from: userLocation) / 1609.34 // Convert to miles
                
                if distance <= radius {
                    courts.append(court)
                }
            } else {
                courts.append(court)
            }
        }
        
        return courts
    }
    
    func createCourt(name: String, address: String, latitude: Double, longitude: Double) async throws -> String {
        let db = Firestore.firestore()
        
        let courtData: [String: Any] = [
            "name": name,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "createdAt": Timestamp(date: Date())
        ]
        
        let docRef = try await db.collection("courts").addDocument(data: courtData)
        return docRef.documentID
    }
}
```

---

## Step 6: Implement Games/Challenges

### 6.1 Update GameManager.swift

Update your `Models/GameManager.swift` to use Firestore:

```swift
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class GameManager: ObservableObject {
    @Published var games: [Game] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func createChallenge(
        opponentID: String,
        courtID: String,
        scheduledDate: Date,
        rules: String
    ) async throws -> String {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        // Check if opponent is blocked
        let isBlocked = try await checkIfBlocked(blockerID: currentUserID, blockedID: opponentID)
        if isBlocked {
            throw NSError(domain: "Game", code: 403, userInfo: [NSLocalizedDescriptionKey: "Cannot challenge blocked user"])
        }
        
        // Get opponent name
        let opponentDoc = try await db.collection("profiles").document(opponentID).getDocument()
        let opponentName = opponentDoc.data()?["name"] as? String ?? "Unknown"
        
        // Get court info
        let courtDoc = try await db.collection("courts").document(courtID).getDocument()
        let courtData = courtDoc.data() ?? [:]
        let courtName = courtData["name"] as? String ?? "Unknown Court"
        let courtAddress = courtData["address"] as? String ?? ""
        
        let gameData: [String: Any] = [
            "challengerID": currentUserID,
            "opponentID": opponentID,
            "courtID": courtID,
            "scheduledDate": Timestamp(date: scheduledDate),
            "rules": rules,
            "status": "pending",
            "isConfirmed": false,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date())
        ]
        
        let docRef = try await db.collection("games").addDocument(data: gameData)
        
        // Send push notification (implement in Step 12)
        // await sendChallengeNotification(to: opponentID, gameId: docRef.documentID)
        
        return docRef.documentID
    }
    
    func listenToGames(userId: String) {
        listener?.remove()
        
        listener = db.collection("games")
            .whereField("challengerID", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let games = documents.compactMap { doc -> Game? in
                    self?.parseGameDocument(doc)
                }
                
                DispatchQueue.main.async {
                    self?.games = games
                }
            }
    }
    
    func acceptGame(gameId: String) async throws {
        try await db.collection("games").document(gameId).updateData([
            "status": "accepted",
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    func cancelGame(gameId: String) async throws {
        try await db.collection("games").document(gameId).updateData([
            "status": "canceled",
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    func submitScore(gameId: String, myScore: Int, opponentScore: Int) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let gameDoc = try await db.collection("games").document(gameId).getDocument()
        guard let gameData = gameDoc.data() else {
            throw NSError(domain: "Game", code: 404)
        }
        
        let challengerID = gameData["challengerID"] as? String ?? ""
        let opponentID = gameData["opponentID"] as? String ?? ""
        
        var updates: [String: Any] = [
            "updatedAt": Timestamp(date: Date())
        ]
        
        if currentUserID == challengerID {
            updates["challengerScore"] = myScore
            updates["opponentScore"] = opponentScore
        } else {
            updates["opponentScore"] = myScore
            updates["challengerScore"] = opponentScore
        }
        
        // Check if scores match
        let existingChallengerScore = gameData["challengerScore"] as? Int
        let existingOpponentScore = gameData["opponentScore"] as? Int
        
        if let existingChallenger = existingChallengerScore,
           let existingOpponent = existingOpponentScore {
            // Both scores submitted
            let challengerScore = updates["challengerScore"] as? Int ?? existingChallenger
            let opponentScore = updates["opponentScore"] as? Int ?? existingOpponent
            
            if challengerScore == existingChallenger && opponentScore == existingOpponent {
                // Scores match - auto-confirm
                let winnerID = challengerScore > opponentScore ? challengerID : opponentID
                let loserID = winnerID == challengerID ? opponentID : challengerID
                
                updates["status"] = "completed"
                updates["winnerID"] = winnerID
                updates["loserID"] = loserID
                updates["isConfirmed"] = true
                
                // Update stats (implement in Step 10)
                try await updateGameStats(winnerID: winnerID, loserID: loserID)
            } else {
                // Scores don't match
                updates["status"] = "disputed"
            }
        }
        
        try await db.collection("games").document(gameId).updateData(updates)
    }
    
    // MARK: - Helpers
    
    private func parseGameDocument(_ doc: QueryDocumentSnapshot) -> Game? {
        let data = doc.data()
        guard let challengerID = data["challengerID"] as? String,
              let opponentID = data["opponentID"] as? String,
              let scheduledDate = (data["scheduledDate"] as? Timestamp)?.dateValue(),
              let statusString = data["status"] as? String else {
            return nil
        }
        
        let status = Game.GameStatus(rawValue: statusString) ?? .pending
        
        return Game(
            id: UUID(uuidString: doc.documentID) ?? UUID(),
            challengerID: UUID(uuidString: challengerID) ?? UUID(),
            opponentID: UUID(uuidString: opponentID) ?? UUID(),
            opponentName: data["opponentName"] as? String ?? "",
            courtName: data["courtName"] as? String ?? "",
            courtAddress: data["courtAddress"] as? String ?? "",
            scheduledDate: scheduledDate,
            rules: data["rules"] as? String ?? "First to 21",
            status: status,
            winnerID: (data["winnerID"] as? String).flatMap { UUID(uuidString: $0) },
            loserID: (data["loserID"] as? String).flatMap { UUID(uuidString: $0) },
            challengerScore: data["challengerScore"] as? Int,
            opponentScore: data["opponentScore"] as? Int,
            isConfirmed: data["isConfirmed"] as? Bool ?? false,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
    
    private func checkIfBlocked(blockerID: String, blockedID: String) async throws -> Bool {
        let doc = try await db.collection("blocked")
            .document(blockerID)
            .collection("blocked")
            .document(blockedID)
            .getDocument()
        
        return doc.exists
    }
    
    private func updateGameStats(winnerID: String, loserID: String) async throws {
        // Implement in Step 10
    }
}
```

---

## Step 7: Implement Real-time Messaging

### 7.1 Update ChatManager.swift

Update your `Models/ChatManager.swift` to use Firestore real-time listeners:

```swift
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class ChatManager: ObservableObject {
    @Published var messages: [Message] = []
    private let db = Firestore.firestore()
    private var messageListener: ListenerRegistration?
    
    func listenToMessages(gameId: String) {
        messageListener?.remove()
        
        messageListener = db.collection("messages")
            .whereField("gameID", isEqualTo: gameId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    if let error = error {
                        print("Error listening to messages: \(error)")
                    }
                    return
                }
                
                let messages = documents.compactMap { doc -> Message? in
                    self?.parseMessageDocument(doc)
                }
                
                DispatchQueue.main.async {
                    self?.messages = messages
                }
            }
    }
    
    func sendMessage(gameId: String, text: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid,
              let currentUserName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        // Verify user is part of the game
        let gameDoc = try await db.collection("games").document(gameId).getDocument()
        guard let gameData = gameDoc.data() else {
            throw NSError(domain: "Game", code: 404)
        }
        
        let challengerID = gameData["challengerID"] as? String ?? ""
        let opponentID = gameData["opponentID"] as? String ?? ""
        
        guard currentUserID == challengerID || currentUserID == opponentID else {
            throw NSError(domain: "Permission", code: 403)
        }
        
        let messageData: [String: Any] = [
            "gameID": gameId,
            "senderID": currentUserID,
            "senderName": currentUserName,
            "text": text,
            "timestamp": Timestamp(date: Date()),
            "isRead": [
                currentUserID: true
            ]
        ]
        
        try await db.collection("messages").addDocument(data: messageData)
        
        // Mark as unread for recipient
        let recipientID = currentUserID == challengerID ? opponentID : challengerID
        // Send push notification (implement in Step 12)
    }
    
    func markMessagesAsRead(gameId: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await db.collection("messages")
            .whereField("gameID", isEqualTo: gameId)
            .whereField("isRead.\(currentUserID)", isEqualTo: false)
            .getDocuments()
        
        let batch = db.batch()
        for doc in snapshot.documents {
            batch.updateData([
                "isRead.\(currentUserID)": true
            ], forDocument: doc.reference)
        }
        
        try await batch.commit()
    }
    
    private func parseMessageDocument(_ doc: QueryDocumentSnapshot) -> Message? {
        let data = doc.data()
        guard let gameID = data["gameID"] as? String,
              let senderID = data["senderID"] as? String,
              let senderName = data["senderName"] as? String,
              let text = data["text"] as? String,
              let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
            return nil
        }
        
        return Message(
            id: UUID(uuidString: doc.documentID) ?? UUID(),
            gameID: UUID(uuidString: gameID) ?? UUID(),
            senderID: UUID(uuidString: senderID) ?? UUID(),
            senderName: senderName,
            text: text,
            timestamp: timestamp
        )
    }
    
    func stopListening() {
        messageListener?.remove()
        messageListener = nil
    }
}
```

---

## Step 8: Implement Leaderboard

### 8.1 Update LeaderboardManager.swift

Update your `Managers/LeaderboardManager.swift`:

```swift
import Foundation
import FirebaseFirestore
import Combine

class LeaderboardManager: ObservableObject {
    @Published var leaderboard: [LeaderboardEntry] = []
    private let db = Firestore.firestore()
    
    struct LeaderboardEntry: Identifiable {
        let id: String
        let rank: Int
        let name: String
        let rating: Double
        let wins: Int
        let losses: Int
        let streak: Int
    }
    
    func fetchLeaderboard(sortBy: SortOption = .rating, limit: Int = 100) async throws {
        let query = db.collection("stats")
            .order(by: sortBy.field, descending: true)
            .limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        
        var entries: [LeaderboardEntry] = []
        var rank = 1
        
        for document in snapshot.documents {
            let data = document.data()
            let userId = document.documentID
            
            // Fetch profile for name
            let profileDoc = try? await db.collection("profiles").document(userId).getDocument()
            let name = profileDoc?.data()?["name"] as? String ?? "Unknown"
            
            let entry = LeaderboardEntry(
                id: userId,
                rank: rank,
                name: name,
                rating: data["rating"] as? Double ?? 1000.0,
                wins: data["wins"] as? Int ?? 0,
                losses: data["losses"] as? Int ?? 0,
                streak: data["currentStreak"] as? Int ?? 0
            )
            
            entries.append(entry)
            rank += 1
        }
        
        await MainActor.run {
            self.leaderboard = entries
        }
    }
    
    enum SortOption {
        case rating
        case wins
        case streak
        
        var field: String {
            switch self {
            case .rating: return "rating"
            case .wins: return "wins"
            case .streak: return "currentStreak"
            }
        }
    }
}
```

---

## Step 9: Implement Nearby Players

### 9.1 Add to LocationManager.swift

Add nearby players query to `LocationManager.swift`:

```swift
func findNearbyPlayers(
    latitude: Double,
    longitude: Double,
    radius: Double = 10.0, // miles
    limit: Int = 50
) async throws -> [NearbyPlayer] {
    let db = Firestore.firestore()
    guard let currentUserID = Auth.auth().currentUser?.uid else {
        throw NSError(domain: "Auth", code: 401)
    }
    
    // Get blocked users
    let blockedSnapshot = try? await db.collection("blocked")
        .document(currentUserID)
        .collection("blocked")
        .getDocuments()
    
    let blockedIDs = Set(blockedSnapshot?.documents.map { $0.documentID } ?? [])
    
    // Get all profiles with locations
    let profilesSnapshot = try await db.collection("profiles").getDocuments()
    
    var nearbyPlayers: [NearbyPlayer] = []
    let userLocation = CLLocation(latitude: latitude, longitude: longitude)
    
    for profileDoc in profilesSnapshot.documents {
        let userId = profileDoc.documentID
        
        // Skip self and blocked users
        if userId == currentUserID || blockedIDs.contains(userId) {
            continue
        }
        
        guard let data = profileDoc.data(),
              let location = data["location"] as? [String: Any],
              let lat = location["latitude"] as? Double,
              let lon = location["longitude"] as? Double else {
            continue
        }
        
        let playerLocation = CLLocation(latitude: lat, longitude: lon)
        let distance = userLocation.distance(from: playerLocation) / 1609.34 // Convert to miles
        
        if distance <= radius {
            // Get stats for rating
            let statsDoc = try? await db.collection("stats").document(userId).getDocument()
            let rating = statsDoc?.data()?["rating"] as? Double ?? 1000.0
            
            let player = NearbyPlayer(
                id: UUID(uuidString: userId) ?? UUID(),
                name: data["name"] as? String ?? "Unknown",
                rating: rating,
                homeCourt: data["homeCourtID"] as? String ?? "",
                distanceMiles: distance,
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
            )
            
            nearbyPlayers.append(player)
        }
    }
    
    // Sort by distance and limit
    nearbyPlayers.sort { $0.distanceMiles < $1.distanceMiles }
    return Array(nearbyPlayers.prefix(limit))
}
```

---

## Step 10: Implement Stats and Rating System

### 10.1 Create StatsManager.swift

Create `Managers/StatsManager.swift`:

```swift
import Foundation
import FirebaseFirestore

class StatsManager {
    private let db = Firestore.firestore()
    
    func getStats(userId: String) async throws -> PlayerStats {
        let doc = try await db.collection("stats").document(userId).getDocument()
        
        guard let data = doc.data() else {
            // Return default stats if not found
            return PlayerStats(playerID: UUID(uuidString: userId) ?? UUID())
        }
        
        return PlayerStats(
            playerID: UUID(uuidString: userId) ?? UUID(),
            wins: data["wins"] as? Int ?? 0,
            losses: data["losses"] as? Int ?? 0,
            currentStreak: data["currentStreak"] as? Int ?? 0,
            bestStreak: data["bestStreak"] as? Int ?? 0,
            totalGames: data["totalGames"] as? Int ?? 0,
            rating: data["rating"] as? Double ?? 1000.0
        )
    }
    
    func updateStatsAfterGame(winnerID: String, loserID: String) async throws {
        // Get current ratings
        let winnerDoc = try await db.collection("stats").document(winnerID).getDocument()
        let loserDoc = try await db.collection("stats").document(loserID).getDocument()
        
        let winnerData = winnerDoc.data() ?? [:]
        let loserData = loserDoc.data() ?? [:]
        
        let winnerRating = winnerData["rating"] as? Double ?? 1000.0
        let loserRating = loserData["rating"] as? Double ?? 1000.0
        
        // Calculate ELO rating change
        let kFactor = 32.0
        let expectedWinner = 1.0 / (1.0 + pow(10.0, (loserRating - winnerRating) / 400.0))
        let expectedLoser = 1.0 - expectedWinner
        
        let winnerChange = kFactor * (1.0 - expectedWinner)
        let loserChange = kFactor * (0.0 - expectedLoser)
        
        let newWinnerRating = winnerRating + winnerChange
        let newLoserRating = loserRating + loserChange
        
        // Update winner stats
        let winnerWins = (winnerData["wins"] as? Int ?? 0) + 1
        let winnerStreak = (winnerData["currentStreak"] as? Int ?? 0)
        let newWinnerStreak = winnerStreak >= 0 ? winnerStreak + 1 : 1
        let winnerBestStreak = max(newWinnerStreak, winnerData["bestStreak"] as? Int ?? 0)
        
        try await db.collection("stats").document(winnerID).updateData([
            "wins": winnerWins,
            "currentStreak": newWinnerStreak,
            "bestStreak": winnerBestStreak,
            "totalGames": (winnerData["totalGames"] as? Int ?? 0) + 1,
            "rating": newWinnerRating,
            "lastGameDate": Timestamp(date: Date())
        ])
        
        // Update loser stats
        let loserLosses = (loserData["losses"] as? Int ?? 0) + 1
        let loserStreak = (loserData["currentStreak"] as? Int ?? 0)
        let newLoserStreak = loserStreak <= 0 ? loserStreak - 1 : -1
        let loserBestStreak = loserData["bestStreak"] as? Int ?? 0
        
        try await db.collection("stats").document(loserID).updateData([
            "losses": loserLosses,
            "currentStreak": newLoserStreak,
            "bestStreak": loserBestStreak,
            "totalGames": (loserData["totalGames"] as? Int ?? 0) + 1,
            "rating": newLoserRating,
            "lastGameDate": Timestamp(date: Date())
        ])
    }
}
```

Update `GameManager.swift` to call this:

```swift
private func updateGameStats(winnerID: String, loserID: String) async throws {
    let statsManager = StatsManager()
    try await statsManager.updateStatsAfterGame(winnerID: winnerID, loserID: loserID)
}
```

---

## Step 11: Implement Safety Features

### 11.1 Create SafetyManager.swift

Update your existing `Managers/SafetyManager.swift`:

```swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

class SafetyManager {
    private let db = Firestore.firestore()
    
    func blockUser(blockedID: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        // Add to blocked collection
        try await db.collection("blocked")
            .document(currentUserID)
            .collection("blocked")
            .document(blockedID)
            .setData([
                "createdAt": Timestamp(date: Date())
            ])
        
        // Cancel any pending games between users
        let pendingGames = try await db.collection("games")
            .whereField("status", isEqualTo: "pending")
            .whereFilter(Filter.orFilter([
                Filter.andFilter([
                    Filter.whereField("challengerID", isEqualTo: currentUserID),
                    Filter.whereField("opponentID", isEqualTo: blockedID)
                ]),
                Filter.andFilter([
                    Filter.whereField("challengerID", isEqualTo: blockedID),
                    Filter.whereField("opponentID", isEqualTo: currentUserID)
                ])
            ]))
            .getDocuments()
        
        let batch = db.batch()
        for doc in pendingGames.documents {
            batch.updateData([
                "status": "canceled",
                "updatedAt": Timestamp(date: Date())
            ], forDocument: doc.reference)
        }
        try await batch.commit()
    }
    
    func reportUser(reportedID: String, reason: String, description: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let reportData: [String: Any] = [
            "reporterID": currentUserID,
            "reportedID": reportedID,
            "reason": reason,
            "description": description,
            "createdAt": Timestamp(date: Date()),
            "status": "pending"
        ]
        
        try await db.collection("reports").addDocument(data: reportData)
    }
    
    func getBlockedUsers() async throws -> [String] {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let snapshot = try await db.collection("blocked")
            .document(currentUserID)
            .collection("blocked")
            .getDocuments()
        
        return snapshot.documents.map { $0.documentID }
    }
    
    func isBlocked(userID: String) async -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        do {
            let doc = try await db.collection("blocked")
                .document(currentUserID)
                .collection("blocked")
                .document(userID)
                .getDocument()
            return doc.exists
        } catch {
            return false
        }
    }
}
```

---

## Step 12: Set Up Push Notifications

### 12.1 Configure iOS App for Notifications

1. In Xcode, go to **Signing & Capabilities**
2. Add **Push Notifications** capability
3. Add **Background Modes** capability
4. Enable **Remote notifications**

### 12.2 Update NotificationManager.swift

Update your `Managers/NotificationManager.swift`:

```swift
import Foundation
import UserNotifications
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore

class NotificationManager: NSObject, ObservableObject {
    @Published var deviceToken: String?
    private let db = Firestore.firestore()
    
    override init() {
        super.init()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() async -> Bool {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            
            if granted {
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
            return granted
        } catch {
            return false
        }
    }
    
    func registerDeviceToken(_ token: Data) {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        deviceToken = tokenString
        
        // Save FCM token to Firestore
        Messaging.messaging().token { [weak self] token, error in
            if let token = token, let userId = Auth.auth().currentUser?.uid {
                Task {
                    try? await self?.db.collection("users")
                        .document(userId)
                        .collection("tokens")
                        .document(token)
                        .setData([
                            "platform": "ios",
                            "createdAt": Timestamp(date: Date())
                        ])
                }
            }
        }
    }
    
    func sendChallengeNotification(to userId: String, gameId: String, challengerName: String) async throws {
        // Get recipient's FCM tokens
        let tokensSnapshot = try await db.collection("users")
            .document(userId)
            .collection("tokens")
            .getDocuments()
        
        let tokens = tokensSnapshot.documents.map { $0.documentID }
        
        // Send via Cloud Functions (see Step 12.3) or use Firebase Admin SDK
        // For now, store notification to be sent by Cloud Function
        try await db.collection("notifications").addDocument(data: [
            "userId": userId,
            "type": "challenge",
            "title": "New Challenge from \(challengerName)",
            "body": "You've been challenged to a game!",
            "gameId": gameId,
            "createdAt": Timestamp(date: Date()),
            "sent": false
        ])
    }
}

extension NotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken, let userId = Auth.auth().currentUser?.uid {
            Task {
                try? await db.collection("users")
                    .document(userId)
                    .collection("tokens")
                    .document(token)
                    .setData([
                        "platform": "ios",
                        "createdAt": Timestamp(date: Date())
                    ])
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap
        let userInfo = response.notification.request.content.userInfo
        
        if let gameId = userInfo["gameId"] as? String {
            // Navigate to game details
            // Use NotificationCenter or a coordinator to handle navigation
        }
        
        completionHandler()
    }
}
```

### 12.3 Create Cloud Function for Notifications (Optional)

If you want server-side notification sending, create a Cloud Function:

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Initialize Functions: `firebase init functions`
4. Create function in `functions/index.js`:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    
    // Get user's FCM tokens
    const tokensSnapshot = await admin.firestore()
      .collection('users')
      .doc(data.userId)
      .collection('tokens')
      .get();
    
    const tokens = tokensSnapshot.docs.map(doc => doc.id);
    
    if (tokens.length === 0) return;
    
    const message = {
      notification: {
        title: data.title,
        body: data.body,
      },
      data: {
        gameId: data.gameId || '',
        type: data.type || '',
      },
      tokens: tokens,
    };
    
    await admin.messaging().sendMulticast(message);
    
    // Mark as sent
    await snap.ref.update({ sent: true });
  });
```

5. Deploy: `firebase deploy --only functions`

---

## Step 13: Set Up Firestore Security Rules

### 13.1 Configure Security Rules

Go to Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the resource
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
      
      match /tokens/{tokenId} {
        allow read, write: if isOwner(userId);
      }
    }
    
    // Profiles collection
    match /profiles/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    // Courts collection
    match /courts/{courtId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if false; // Only admins can update/delete (use Cloud Functions)
    }
    
    // Games collection
    match /games/{gameId} {
      allow read: if isAuthenticated() && 
        (resource.data.challengerID == request.auth.uid || 
         resource.data.opponentID == request.auth.uid);
      
      allow create: if isAuthenticated();
      
      allow update: if isAuthenticated() && 
        (resource.data.challengerID == request.auth.uid || 
         resource.data.opponentID == request.auth.uid);
    }
    
    // Messages collection
    match /messages/{messageId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && 
        resource.data.senderID == request.auth.uid;
    }
    
    // Stats collection
    match /stats/{userId} {
      allow read: if isAuthenticated();
      allow write: if false; // Only updated via Cloud Functions
    }
    
    // Blocked users
    match /blocked/{blockerId} {
      allow read, write: if isOwner(blockerId);
      
      match /blocked/{blockedId} {
        allow read, write: if isOwner(blockerId);
      }
    }
    
    // Reports
    match /reports/{reportId} {
      allow create: if isAuthenticated();
      allow read, update: if false; // Only admins (use Cloud Functions)
    }
  }
}
```

**Important**: Start with test mode during development, then implement proper security rules before production.

---

## Step 14: Set Up Cloud Storage Security Rules

Go to Firebase Console → Storage → Rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile photos
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Game photos (if you add photo proof for scores)
    match /game_photos/{gameId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## Step 15: Seed Initial Data

### 15.1 Create Seed Script (Optional)

You can seed courts data manually in Firebase Console or create a Swift script:

```swift
// SeedCourts.swift - Run once to populate initial courts
import Foundation
import FirebaseCore
import FirebaseFirestore

func seedCourts() async {
    FirebaseApp.configure()
    let db = Firestore.firestore()
    
    let courts: [[String: Any]] = [
        [
            "name": "Rucker Park",
            "address": "155th St & Frederick Douglass Blvd, New York, NY",
            "latitude": 40.8276,
            "longitude": -73.9442,
            "createdAt": Timestamp(date: Date())
        ],
        // Add more courts...
    ]
    
    for courtData in courts {
        try? await db.collection("courts").addDocument(data: courtData)
    }
    
    print("Courts seeded successfully!")
}
```

---

## Step 16: Error Handling

Firebase automatically handles network errors. Wrap all Firestore operations in do-catch blocks:

```swift
do {
    try await db.collection("games").addDocument(data: gameData)
} catch {
    // Handle error
    print("Error creating game: \(error.localizedDescription)")
    // Show user-friendly message
}
```

### Common Error Codes:
- `permission-denied`: Check security rules
- `not-found`: Document doesn't exist
- `unavailable`: Network issue, retry
- `invalid-argument`: Data validation issue

---

## Step 17: Testing

### 17.1 Unit Tests
Test your manager classes with mock data before integrating with Firebase.

### 17.2 Integration Tests
1. Use Firebase Emulator Suite for local testing
2. Install: `npm install -g firebase-tools`
3. Start emulators: `firebase emulators:start`
4. Configure your app to use emulators in debug mode

### 17.3 End-to-End Tests
Test full flows:
- Sign up → Create profile → Find players → Create challenge → Chat → Record score → Confirm → Leaderboard update

---

## Step 18: Performance Optimization

### 18.1 Firestore Best Practices:
1. **Use indexes**: Firestore will prompt you to create composite indexes
2. **Limit queries**: Always use `.limit()` on queries
3. **Pagination**: Use `startAfter()` for pagination
4. **Cache reads**: Firestore automatically caches offline
5. **Batch writes**: Use `batch()` for multiple writes
6. **Listeners**: Remove listeners when not needed to save reads

### 18.2 Example Optimized Query:

```swift
let query = db.collection("games")
    .whereField("challengerID", isEqualTo: userId)
    .whereField("status", isEqualTo: "pending")
    .order(by: "createdAt", descending: true)
    .limit(to: 10)
```

---

## Step 19: Monitoring and Analytics

### 19.1 Firebase Analytics
1. Firebase Analytics is automatically enabled
2. View in Firebase Console → Analytics
3. Track custom events for key actions

### 19.2 Firestore Usage
Monitor in Firebase Console → Firestore → Usage
- Document reads/writes
- Storage usage
- Network egress

### 19.3 Set Up Alerts
In Firebase Console → Project Settings → Usage and billing
- Set budget alerts
- Monitor quota usage

---

## Step 20: Production Deployment Checklist

- [ ] Update Firestore security rules (remove test mode)
- [ ] Update Storage security rules
- [ ] Enable Firebase App Check (prevents abuse)
- [ ] Set up proper indexes
- [ ] Configure error monitoring (Firebase Crashlytics)
- [ ] Test push notifications on real device
- [ ] Verify APNs configuration
- [ ] Set up backup strategy (Firestore backups)
- [ ] Configure billing alerts
- [ ] Review Firebase pricing plans
- [ ] Test offline functionality
- [ ] Performance test with multiple users

---

## Step 21: iOS App Integration Checklist

- [ ] Update `AuthenticationManager` to use Firebase Auth
- [ ] Update `GameManager` to use Firestore
- [ ] Update `ChatManager` to use Firestore real-time listeners
- [ ] Update `LeaderboardManager` to fetch from Firestore
- [ ] Update `ProfileManager` to use Firestore and Storage
- [ ] Update `LocationManager` to save location to Firestore
- [ ] Update `NotificationManager` to use FCM
- [ ] Remove all UserDefaults data persistence (except settings)
- [ ] Add offline support (Firestore handles this automatically)
- [ ] Test authentication flow
- [ ] Test real-time updates
- [ ] Test push notifications

---

## Additional Resources

- **Firebase iOS Documentation**: https://firebase.google.com/docs/ios/setup
- **Firestore Documentation**: https://firebase.google.com/docs/firestore
- **Firebase Auth**: https://firebase.google.com/docs/auth/ios/start
- **Cloud Messaging**: https://firebase.google.com/docs/cloud-messaging/ios/client
- **Security Rules**: https://firebase.google.com/docs/firestore/security/get-started
- **Firebase Pricing**: https://firebase.google.com/pricing

---

## Next Steps

1. ✅ Step 1: Set up Firebase project
2. ✅ Step 2: Design Firestore schema
3. ✅ Step 3: Implement authentication
4. ✅ Step 4: Implement profile management
5. ✅ Step 5: Implement courts
6. ✅ Step 6: Implement games/challenges
7. ✅ Step 7: Implement messaging
8. ✅ Step 8: Implement leaderboard
9. ✅ Step 9: Implement nearby players
10. ✅ Step 10: Implement stats
11. ✅ Step 11: Implement safety features
12. ✅ Step 12: Set up push notifications
13. ✅ Step 13: Set up security rules
14. ✅ Step 14: Set up storage rules
15. ✅ Step 15: Seed data
16. ✅ Step 16: Error handling
17. ✅ Step 17: Testing
18. ✅ Step 18: Performance optimization
19. ✅ Step 19: Monitoring
20. ✅ Step 20: Production deployment
21. ✅ Step 21: iOS app integration

**Start with Step 1 and work through each step sequentially. Test thoroughly after each step before moving to the next.**

---

**Last Updated**: 2025-01-XX
