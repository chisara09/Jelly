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
    
    // Mock nearby players
    @State private var players: [NearbyPlayer] = [
        NearbyPlayer(name: "Marcus Johnson", skillLevel: "Advanced", homeCourt: "Central Park", distanceMiles: 2.3),
        NearbyPlayer(name: "Jamal Smith", skillLevel: "Intermediate", homeCourt: "Brooklyn Heights", distanceMiles: 4.1),
        NearbyPlayer(name: "Eric Lee", skillLevel: "Beginner", homeCourt: "Harlem Courts", distanceMiles: 1.2)
    ]
    
    var filteredCourts: [Court] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            return courts
        }
        return courts.filter { court in
            court.name.lowercased().contains(query) || court.address.lowercased().contains(query)
        }
    }
    
    var filteredPlayers: [NearbyPlayer] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            return players
        }
        return players.filter { player in
            player.name.lowercased().contains(query) || player.homeCourt.lowercased().contains(query)
        }
    }
    
    private func openInGoogleMaps(court: Court) {
        let coordinateString = "\(court.coordinate.latitude),\(court.coordinate.longitude)"
        
        if let googleMapsURL = URL(string: "comgooglemaps://?q=\(coordinateString)&center=\(coordinateString)&zoom=15"),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL)
        } else if let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(court.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&ll=\(coordinateString)&z=15") {
            UIApplication.shared.open(appleMapsURL)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Use user location if available, otherwise center on NYC (where courts are)
                let mapCenter = locationManager.lastLocation?.clLocationCoordinate ?? CLLocationCoordinate2D(latitude: 40.7812, longitude: -73.9665)
                
                let mapRegion = Binding<MKCoordinateRegion>(
                    get: {
                        MKCoordinateRegion(
                            center: mapCenter,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    },
                    set: { region = $0 }
                )
                
                Map(coordinateRegion: mapRegion, annotationItems: filteredCourts, annotationContent: { court in
                    MapMarker(coordinate: court.coordinate, tint: .orange)
                })
                .frame(height: 280)
                .onAppear {
                    // Request location permission when map appears
                    if locationManager.lastLocation == nil {
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
                
                // Show location status message below map
                if locationManager.permissionError != nil {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orange)
                        Text("Location services disabled. Showing NYC area.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                }
                
                List {
                    Section(header: Text("Players Near You")) {
                        if filteredPlayers.isEmpty && !searchText.isEmpty {
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                    Text("No matches found.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 20)
                                Spacer()
                            }
                        } else {
                            ForEach(filteredPlayers) { player in
                                NavigationLink(value: player) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 36, height: 36)
                                            Text(initials(from: player.name))
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(player.name)
                                            Text("\(player.skillLevel) • \(String(format: "%.1f mi", player.distanceMiles))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle())
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Courts Near You")) {
                        if filteredCourts.isEmpty && !searchText.isEmpty {
                            HStack {
                                Spacer()
                                Text("No matches found.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                        } else {
                            ForEach(filteredCourts) { court in
                                Button(action: {
                                    openInGoogleMaps(court: court)
                                }) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(court.name)
                                            .font(.headline)
                                        Text(court.address)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .searchable(text: $searchText, prompt: "Search players, courts")
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
            .navigationDestination(for: NearbyPlayer.self) { player in
                OtherPlayerProfileView(player: player)
                    .environmentObject(GameManager())
            }
        }
    }
    
    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 { return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased() }
        return String(name.prefix(2)).uppercased()
    }
}

#Preview {
    FindPlayersView()
}
