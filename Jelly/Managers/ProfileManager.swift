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
        do {
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
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "getProfile")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Profile", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func updateProfile(userId: String, name: String?, bio: String?, homeCourtID: String?) async throws {
        do {
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
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "updateProfile")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Profile", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func uploadPhoto(userId: String, imageData: Data) async throws -> String {
        do {
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
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "uploadPhoto")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Profile", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
    
    func updateLocation(userId: String, latitude: Double, longitude: Double) async throws {
        do {
            try await db.collection("profiles").document(userId).updateData([
                "location": [
                    "latitude": latitude,
                    "longitude": longitude,
                    "lastUpdated": Timestamp(date: Date())
                ]
            ])
        } catch {
            // Log error for debugging
            FirebaseErrorHandler.logError(error, context: "updateLocation")
            // Re-throw with user-friendly message
            let friendlyMessage = FirebaseErrorHandler.userFriendlyMessage(for: error)
            throw NSError(domain: "Profile", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: friendlyMessage])
        }
    }
}

