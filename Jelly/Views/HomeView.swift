//
//  HomeView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to 1v1 Hoops!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Logged in as: \(authManager.currentUser?.name ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    authManager.logout()
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.orange)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationManager())
}
