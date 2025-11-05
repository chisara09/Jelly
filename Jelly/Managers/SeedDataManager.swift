//
//  SeedDataManager.swift
//  Jelly
//
//  Seed Data Manager - Utility to seed initial data into Firestore
//  Run this once to populate initial courts data
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class SeedDataManager {
    private let db = Firestore.firestore()
    
    /// Seeds initial courts data into Firestore
    /// Call this method once to populate the database with popular basketball courts
    func seedCourts() async throws {
        let courts: [[String: Any]] = [
            // New York City Courts
            [
                "name": "Rucker Park",
                "address": "155th St & Frederick Douglass Blvd, New York, NY 10039",
                "latitude": 40.8276,
                "longitude": -73.9442,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "The Cage",
                "address": "6th Ave & W 4th St, New York, NY 10014",
                "latitude": 40.7319,
                "longitude": -74.0011,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "West 4th Street Courts",
                "address": "6th Ave & W 4th St, New York, NY 10014",
                "latitude": 40.7319,
                "longitude": -74.0011,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Dyckman Park",
                "address": "Dyckman St & Nagle Ave, New York, NY 10040",
                "latitude": 40.8653,
                "longitude": -73.9265,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Los Angeles Courts
            [
                "name": "Venice Beach Courts",
                "address": "1800 Ocean Front Walk, Venice, CA 90291",
                "latitude": 34.0492,
                "longitude": -118.4694,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Hoover Street Courts",
                "address": "Hoover St & 48th St, Los Angeles, CA 90011",
                "latitude": 34.0003,
                "longitude": -118.2857,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Pan Pacific Park",
                "address": "7600 Beverly Blvd, Los Angeles, CA 90036",
                "latitude": 34.0740,
                "longitude": -118.3618,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Chicago Courts
            [
                "name": "Chicago State University Courts",
                "address": "9501 S Martin Luther King Dr, Chicago, IL 60628",
                "latitude": 41.7209,
                "longitude": -87.6068,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Union Park",
                "address": "1501 W Randolph St, Chicago, IL 60607",
                "latitude": 41.8847,
                "longitude": -87.6644,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Philadelphia Courts
            [
                "name": "Mallery Playground",
                "address": "2600 W Thompson St, Philadelphia, PA 19121",
                "latitude": 39.9811,
                "longitude": -75.1653,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Fairmount Park",
                "address": "Fairmount Park, Philadelphia, PA 19130",
                "latitude": 39.9740,
                "longitude": -75.2090,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Boston Courts
            [
                "name": "Roxbury YMCA",
                "address": "285 Martin Luther King Blvd, Boston, MA 02119",
                "latitude": 42.3292,
                "longitude": -71.0795,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Atlanta Courts
            [
                "name": "Chastain Park",
                "address": "Chastain Park, Atlanta, GA 30342",
                "latitude": 33.8749,
                "longitude": -84.3794,
                "createdAt": Timestamp(date: Date())
            ],
            [
                "name": "Peachtree Battle Courts",
                "address": "2612 Peachtree Rd NW, Atlanta, GA 30305",
                "latitude": 33.8431,
                "longitude": -84.3919,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Miami Courts
            [
                "name": "South Beach Courts",
                "address": "Ocean Dr & 6th St, Miami Beach, FL 33139",
                "latitude": 25.7753,
                "longitude": -80.1300,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Houston Courts
            [
                "name": "Fonde Recreation Center",
                "address": "110 Sabine St, Houston, TX 77007",
                "latitude": 29.7594,
                "longitude": -95.3617,
                "createdAt": Timestamp(date: Date())
            ],
            
            // San Francisco Courts
            [
                "name": "Golden Gate Park Courts",
                "address": "Golden Gate Park, San Francisco, CA 94117",
                "latitude": 37.7694,
                "longitude": -122.4862,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Washington DC Courts
            [
                "name": "Barry Farms",
                "address": "Sumner Rd SE & Firth Sterling Ave SE, Washington, DC 20020",
                "latitude": 38.8483,
                "longitude": -76.9883,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Seattle Courts
            [
                "name": "Green Lake Community Center",
                "address": "7201 E Green Lake Dr N, Seattle, WA 98115",
                "latitude": 47.6817,
                "longitude": -122.3302,
                "createdAt": Timestamp(date: Date())
            ],
            
            // Portland Courts
            [
                "name": "Portland Community Center",
                "address": "740 SE 106th Ave, Portland, OR 97216",
                "latitude": 45.5152,
                "longitude": -122.5610,
                "createdAt": Timestamp(date: Date())
            ]
        ]
        
        var successCount = 0
        var errorCount = 0
        
        for courtData in courts {
            do {
                try await db.collection("courts").addDocument(data: courtData)
                successCount += 1
                print("✅ Seeded court: \(courtData["name"] as? String ?? "Unknown")")
            } catch {
                errorCount += 1
                print("❌ Error seeding court \(courtData["name"] as? String ?? "Unknown"): \(error.localizedDescription)")
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

