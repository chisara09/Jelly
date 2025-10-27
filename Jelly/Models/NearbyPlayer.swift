//
//  NearbyPlayer.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import CoreLocation

struct NearbyPlayer: Identifiable {
    let id: UUID
    var name: String
    var skillLevel: String // e.g., Beginner, Intermediate, Advanced
    var homeCourt: String
    var distanceMiles: Double
    var coordinate: CLLocationCoordinate2D?
    
    init(
        id: UUID = UUID(),
        name: String,
        skillLevel: String,
        homeCourt: String,
        distanceMiles: Double,
        coordinate: CLLocationCoordinate2D? = nil
    ) {
        self.id = id
        self.name = name
        self.skillLevel = skillLevel
        self.homeCourt = homeCourt
        self.distanceMiles = distanceMiles
        self.coordinate = coordinate
    }
}

extension NearbyPlayer: Equatable {
    static func == (lhs: NearbyPlayer, rhs: NearbyPlayer) -> Bool {
        return lhs.id == rhs.id
    }
}

extension NearbyPlayer: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
