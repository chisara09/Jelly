//
//  ContentView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    
                    FindPlayersView()
                        .tabItem {
                            Label("Find", systemImage: "map.fill")
                        }
                    
                    LeaderboardView()
                        .tabItem {
                            Label("Leaders", systemImage: "crown.fill")
                        }

                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
                .environmentObject(authManager)
                .onChange(of: authManager.isAuthenticated) { _, isAuthenticated in
                    if isAuthenticated {
                        // Start listening for real-time notifications when user is authenticated
                        if let userId = authManager.currentUser?.id {
                            notificationManager.startListening(userId: userId)
                        }
                    } else {
                        // Stop listening when user logs out
                        notificationManager.stopListening()
                    }
                }
                .task {
                    // Start listening for real-time notifications when user is authenticated
                    if let userId = authManager.currentUser?.id {
                        notificationManager.startListening(userId: userId)
                    }
                }
            } else {
                WelcomeView()
                    .environmentObject(authManager)
                    .onAppear {
                        // Stop listening when user logs out
                        notificationManager.stopListening()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
