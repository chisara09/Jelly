//
//  SeedDataManager.swift
//  Jelly
//
//  Seed Data Manager - Utility to seed initial data into Firestore
//  Run this once to populate initial courts data
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SeedDataManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    enum SeedError: Error, LocalizedError {
        case requiresAuthentication
        case permissionDenied
        
        var errorDescription: String? {
            switch self {
            case .requiresAuthentication:
                return "Firestore courts seeding requires an authenticated user."
            case .permissionDenied:
                return "Missing or insufficient permissions while seeding courts."
            }
        }
    }
    
    /// Seeds initial courts data into Firestore
    /// Call this method once to populate the database with popular basketball courts
    func seedCourts() async throws {
        guard auth.currentUser != nil else {
            throw SeedError.requiresAuthentication
        }
        
        let courts = CourtCatalog.defaultCourts
        
        var successCount = 0
        var errorCount = 0
        
        for court in courts {
            let courtData: [String: Any] = [
                "name": court.name,
                "address": court.address,
                "latitude": court.latitude,
                "longitude": court.longitude,
                "createdAt": Timestamp(date: Date())
            ]
            
            do {
                try await db.collection("courts")
                    .document(court.id)
                    .setData(courtData, merge: false)
                successCount += 1
                print("✅ Seeded court: \(court.name)")
            } catch {
                if let firestoreError = error as NSError?,
                   firestoreError.code == FirestoreErrorCode.permissionDenied.rawValue {
                    throw SeedError.permissionDenied
                }
                errorCount += 1
                print("❌ Error seeding court \(court.name): \(error.localizedDescription)")
            }
        }
        
        print("\n📊 Seeding complete!")
        print("✅ Successfully seeded: \(successCount) courts")
        if errorCount > 0 {
            print("❌ Errors: \(errorCount)")
        }
    }
    
    /// Helper method to check if courts already exist in the database
    /// Useful to prevent duplicate seeding
    func courtsExist() async -> Bool {
        guard auth.currentUser != nil else {
            return false
        }
        
        do {
            let snapshot = try await db.collection("courts").limit(to: 1).getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            print("Error checking if courts exist: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Seeds courts only if they don't already exist
    func seedCourtsIfNeeded() async throws {
        let exists = await courtsExist()
        
        if exists {
            print("⚠️ Courts already exist in database. Skipping seed.")
            return
        }
        
        try await seedCourts()
    }
}

