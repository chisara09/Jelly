//
//  PlayerProfile.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation

// D-002: Player Profile – name, photo, bio, home court.
struct PlayerProfile: Identifiable, Codable {
    let id: UUID
    var name: String
    var photoURL: String? // For now just a string, could be image data
    var bio: String
    var homeCourt: String
    var email: String
    
    init(
        id: UUID = UUID(),
        name: String,
        photoURL: String? = nil,
        bio: String = "",
        homeCourt: String = "",
        email: String
    ) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
        self.bio = bio
        self.homeCourt = homeCourt
        self.email = email
    }
}

