//
//  Location.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import CoreLocation

// D-003: Location – last known city/coordinates.
struct UserLocation: Codable {
    var latitude: Double
    var longitude: Double
    var city: String?
    var updatedAt: Date
    
    init(latitude: Double, longitude: Double, city: String? = nil, updatedAt: Date = Date()) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.updatedAt = updatedAt
    }
    
    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
