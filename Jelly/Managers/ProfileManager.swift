//
//  ProfileManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

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
        
        // Convert String ID to UUID for PlayerProfile model
        let profileId = UUID(uuidString: userId) ?? UUID()
        
        return PlayerProfile(
            id: profileId,
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
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await ref.putDataAsync(imageData, metadata: metadata)
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

