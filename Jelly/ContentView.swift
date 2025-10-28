//
//  ContentView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    
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
            } else {
                WelcomeView()
                    .environmentObject(authManager)
            }
        }
    }
}

#Preview {
    ContentView()
}
