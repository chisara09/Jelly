//
//  LocationManager.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: UserLocation?
    @Published var permissionError: String?
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Court Management
    
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
            
            // Convert String ID to UUID for Court model
            let courtId = UUID(uuidString: document.documentID) ?? UUID()
            
            let court = Court(
                id: courtId,
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
    
    // MARK: - Nearby Players
    
    func findNearbyPlayers(
        latitude: Double,
        longitude: Double,
        radius: Double = 10.0, // miles
        limit: Int = 50
    ) async throws -> [NearbyPlayer] {
        let db = Firestore.firestore()
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
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
                
                // Convert String ID to UUID for NearbyPlayer model
                let playerId = UUID(uuidString: userId) ?? UUID()
                
                let player = NearbyPlayer(
                    id: playerId,
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
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            permissionError = nil
            startUpdatingLocation()
        case .denied, .restricted:
            permissionError = "Turn on Location."
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = location.coordinate
        
        // Reverse geocode city name
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            let city = placemarks?.first?.locality
            DispatchQueue.main.async {
                self?.lastLocation = UserLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    city: city,
                    updatedAt: Date()
                )
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        permissionError = "Turn on Location."
    }
}
