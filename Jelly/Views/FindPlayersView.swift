//
//  FindPlayersView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI
import MapKit

struct FindPlayersView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Mock courts
    @State private var courts: [Court] = [
        Court(name: "Central Park Courts", address: "Central Park, NYC", latitude: 40.785091, longitude: -73.968285),
        Court(name: "Brooklyn Heights Courts", address: "Brooklyn, NYC", latitude: 40.6960, longitude: -73.9967),
        Court(name: "Harlem Courts", address: "Harlem, NYC", latitude: 40.8116, longitude: -73.9465)
    ]
    
    var filteredCourts: [Court] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return courts }
        return courts.filter { $0.name.lowercased().contains(query) || $0.address.lowercased().contains(query) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let loc = locationManager.lastLocation {
                    Map(
                        coordinateRegion: Binding(
                            get: {
                                MKCoordinateRegion(
                                    center: loc.clLocationCoordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                )
                            },
                            set: { region = $0 }
                        ),
                        annotationItems: filteredCourts
                    ) { court in
                        MapMarker(coordinate: court.coordinate, tint: .orange)
                    }
                    .frame(height: 280)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemGray6))
                        
                        VStack(spacing: 8) {
                            Image(systemName: "location.slash")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text(locationManager.permissionError ?? "Fetching your location...")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(height: 280)
                }
                
                List {
                    Section(header: Text("Courts Near You")) {
                        ForEach(filteredCourts) { court in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(court.name)
                                    .font(.headline)
                                Text(court.address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .searchable(text: $searchText, prompt: "Search courts or parks")
            .navigationTitle("Find Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Use Location") {
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
}

#Preview {
    FindPlayersView()
}
