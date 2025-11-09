//
//  CourtCatalog.swift
//  Jelly
//
//  Centralized catalog of predefined courts used across the app.
//  Keeping the list in one place ensures the app, seeding script,
//  and any mock data stay in sync and share the same Firestore IDs.
//

import Foundation

enum CourtCatalog {
    /// Default set of popular courts available in the app.
    static let defaultCourts: [Court] = [
        // New York City Courts
        Court(
            id: "rucker-park",
            name: "Rucker Park",
            address: "155th St & Frederick Douglass Blvd, New York, NY 10039",
            latitude: 40.8276,
            longitude: -73.9442
        ),
        Court(
            id: "the-cage",
            name: "The Cage",
            address: "6th Ave & W 4th St, New York, NY 10014",
            latitude: 40.7319,
            longitude: -74.0011
        ),
        Court(
            id: "west-4th-street-courts",
            name: "West 4th Street Courts",
            address: "6th Ave & W 4th St, New York, NY 10014",
            latitude: 40.7319,
            longitude: -74.0011
        ),
        Court(
            id: "dyckman-park",
            name: "Dyckman Park",
            address: "Dyckman St & Nagle Ave, New York, NY 10040",
            latitude: 40.8653,
            longitude: -73.9265
        ),
        
        // Los Angeles Courts
        Court(
            id: "venice-beach-courts",
            name: "Venice Beach Courts",
            address: "1800 Ocean Front Walk, Venice, CA 90291",
            latitude: 34.0492,
            longitude: -118.4694
        ),
        Court(
            id: "hoover-street-courts",
            name: "Hoover Street Courts",
            address: "Hoover St & 48th St, Los Angeles, CA 90011",
            latitude: 34.0003,
            longitude: -118.2857
        ),
        Court(
            id: "pan-pacific-park",
            name: "Pan Pacific Park",
            address: "7600 Beverly Blvd, Los Angeles, CA 90036",
            latitude: 34.0740,
            longitude: -118.3618
        ),
        
        // Chicago Courts
        Court(
            id: "chicago-state-university-courts",
            name: "Chicago State University Courts",
            address: "9501 S Martin Luther King Dr, Chicago, IL 60628",
            latitude: 41.7209,
            longitude: -87.6068
        ),
        Court(
            id: "union-park",
            name: "Union Park",
            address: "1501 W Randolph St, Chicago, IL 60607",
            latitude: 41.8847,
            longitude: -87.6644
        ),
        
        // Philadelphia Courts
        Court(
            id: "mallery-playground",
            name: "Mallery Playground",
            address: "2600 W Thompson St, Philadelphia, PA 19121",
            latitude: 39.9811,
            longitude: -75.1653
        ),
        Court(
            id: "fairmount-park",
            name: "Fairmount Park",
            address: "Fairmount Park, Philadelphia, PA 19130",
            latitude: 39.9740,
            longitude: -75.2090
        ),
        
        // Boston Courts
        Court(
            id: "roxbury-ymca",
            name: "Roxbury YMCA",
            address: "285 Martin Luther King Blvd, Boston, MA 02119",
            latitude: 42.3292,
            longitude: -71.0795
        ),
        
        // Atlanta Courts
        Court(
            id: "chastain-park",
            name: "Chastain Park",
            address: "Chastain Park, Atlanta, GA 30342",
            latitude: 33.8749,
            longitude: -84.3794
        ),
        Court(
            id: "peachtree-battle-courts",
            name: "Peachtree Battle Courts",
            address: "2612 Peachtree Rd NW, Atlanta, GA 30305",
            latitude: 33.8431,
            longitude: -84.3919
        ),
        
        // Miami Courts
        Court(
            id: "south-beach-courts",
            name: "South Beach Courts",
            address: "Ocean Dr & 6th St, Miami Beach, FL 33139",
            latitude: 25.7753,
            longitude: -80.1300
        ),
        
        // Houston Courts
        Court(
            id: "fonde-recreation-center",
            name: "Fonde Recreation Center",
            address: "110 Sabine St, Houston, TX 77007",
            latitude: 29.7594,
            longitude: -95.3617
        ),
        
        // San Francisco Courts
        Court(
            id: "golden-gate-park-courts",
            name: "Golden Gate Park Courts",
            address: "Golden Gate Park, San Francisco, CA 94117",
            latitude: 37.7694,
            longitude: -122.4862
        ),
        
        // Washington DC Courts
        Court(
            id: "barry-farms",
            name: "Barry Farms",
            address: "Sumner Rd SE & Firth Sterling Ave SE, Washington, DC 20020",
            latitude: 38.8483,
            longitude: -76.9883
        ),
        
        // Seattle Courts
        Court(
            id: "green-lake-community-center",
            name: "Green Lake Community Center",
            address: "7201 E Green Lake Dr N, Seattle, WA 98115",
            latitude: 47.6817,
            longitude: -122.3302
        ),
        
        // Portland Courts
        Court(
            id: "portland-community-center",
            name: "Portland Community Center",
            address: "740 SE 106th Ave, Portland, OR 97216",
            latitude: 45.5152,
            longitude: -122.5610
        )
    ]
    
    /// Quick lookup map keyed by Firestore document ID.
    static let courtsByID: [String: Court] = {
        Dictionary(uniqueKeysWithValues: defaultCourts.map { ($0.id, $0) })
    }()
}

