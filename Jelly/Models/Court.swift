//
//  Court.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import CoreLocation

// D-004: Court List – courts with name, address, map pin.
struct Court: Identifiable, Codable, Equatable, Hashable {
    /// Stable identifier that maps directly to the Firestore document ID.
    let id: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    init(
        id: String,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
