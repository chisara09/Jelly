//
//  FirebaseEmulatorConfig.swift
//  Jelly
//
//  Firebase Emulator Suite Configuration
//  Configure your app to use Firebase Emulators for local testing
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

/// Configuration for Firebase Emulator Suite
/// Use this in debug/test builds to connect to local Firebase emulators
struct FirebaseEmulatorConfig {
    
    /// Configure Firebase to use emulators
    /// Call this BEFORE FirebaseApp.configure() in your app initialization
    /// ONLY in DEBUG builds
    static func configureEmulators() {
        #if DEBUG
        // Check if we should use emulators (set via environment variable or build setting)
        // You can set this via Xcode scheme: Product > Scheme > Edit Scheme > Run > Arguments > Environment Variables
        // Add: USE_FIREBASE_EMULATOR = YES
        
        let useEmulator = ProcessInfo.processInfo.environment["USE_FIREBASE_EMULATOR"] == "YES"
        
        if useEmulator {
            // IMPORTANT: Configure emulators BEFORE FirebaseApp.configure()
            // Configure Firestore Emulator
            // Default: localhost:8080 (adjust if needed)
            let firestoreHost = ProcessInfo.processInfo.environment["FIRESTORE_EMULATOR_HOST"] ?? "localhost:8080"
            
            // Set environment variable for Firestore to detect emulator
            setenv("FIRESTORE_EMULATOR_HOST", firestoreHost, 1)
            
            // Configure Auth Emulator
            // Default: localhost:9099 (adjust if needed)
            let authHost = ProcessInfo.processInfo.environment["AUTH_EMULATOR_HOST"] ?? "localhost:9099"
            
            // Set environment variable for Auth to detect emulator
            setenv("FIREBASE_AUTH_EMULATOR_HOST", authHost, 1)
            
            print("🔥 Firebase Emulators configured:")
            print("   Firestore: \(firestoreHost)")
            print("   Auth: \(authHost)")
            print("   NOTE: Call FirebaseApp.configure() after this method")
        }
        #endif
    }
    
    /// Configure Firestore settings for emulator (call AFTER FirebaseApp.configure())
    static func configureFirestoreEmulator() {
        #if DEBUG
        let useEmulator = ProcessInfo.processInfo.environment["USE_FIREBASE_EMULATOR"] == "YES"
        
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
        #endif
    }
    
    /// Configure Auth for emulator (call AFTER FirebaseApp.configure())
    static func configureAuthEmulator() {
        #if DEBUG
        let useEmulator = ProcessInfo.processInfo.environment["USE_FIREBASE_EMULATOR"] == "YES"
        
        if useEmulator {
            Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        }
        #endif
    }
}

// MARK: - Emulator Setup Instructions
/*
 
 ## Setting Up Firebase Emulator Suite
 
 ### Prerequisites
 1. Install Node.js (if not already installed)
 2. Install Firebase CLI: `npm install -g firebase-tools`
 3. Login to Firebase: `firebase login`
 
 ### Initialize Firebase Emulators
 1. In your project root directory, run: `firebase init emulators`
 2. Select the emulators you want to use:
    - Authentication Emulator
    - Firestore Emulator
    - (Optional) Storage Emulator
 3. Choose ports (defaults are fine):
    - Firestore: 8080
    - Auth: 9099
    - Storage: 9199
 
 ### Start Emulators
 Run: `firebase emulators:start`
 
 This will start all configured emulators and open the Emulator Suite UI at http://localhost:4000
 
 ### Configure iOS App to Use Emulators
 
 #### Option 1: Environment Variable (Recommended)
 1. In Xcode, go to Product > Scheme > Edit Scheme
 2. Select "Run" > "Arguments"
 3. Add Environment Variable:
    - Name: `USE_FIREBASE_EMULATOR`
    - Value: `YES`
 
 #### Option 2: Build Settings
 Add to your Debug build configuration:
 - `USE_FIREBASE_EMULATOR=YES`
 
 #### Option 3: Code Configuration
 Call `FirebaseEmulatorConfig.configureEmulators()` in your app initialization (DEBUG only)
 
 ### Import Test Data (Optional)
 You can import seed data to emulators:
 1. Export data from production: `firebase firestore:export ./backup`
 2. Import to emulator: `firebase emulators:start --import=./backup`
 
 ### Clean Emulator Data
 To start fresh, delete the emulator data:
 `firebase emulators:start --clear`
 
 ### Useful Commands
 - Start emulators: `firebase emulators:start`
 - Start with UI: `firebase emulators:start --ui`
 - Export data: `firebase emulators:export ./export`
 - Import data: `firebase emulators:start --import=./export`
 
 */
