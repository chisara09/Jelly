//
//  LeaderboardView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/28/25.
//

import SwiftUI

// S-011: Leaderboard – Ranked list with tabs for rating, wins, streak.
struct LeaderboardView: View {
    @StateObject private var leaderboardManager = LeaderboardManager()
    @State private var selectedMetric: LeaderboardManager.LeaderboardMetric = .rating
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(LeaderboardManager.LeaderboardMetric.allCases) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                content
            }
            .navigationTitle("Leaderboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if leaderboardManager.isLoading {
                        ProgressView()
                    } else {
                        Button {
                            leaderboardManager.regenerateMockSnapshot()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .accessibilityLabel("Refresh Leaderboard")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if let error = leaderboardManager.errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                Text("Leaderboard offline.")
                    .font(.headline)
                Text(error)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button("Retry") {
                    leaderboardManager.regenerateMockSnapshot()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            .padding()
        } else {
            let entries = leaderboardManager.topEntries(sortedBy: selectedMetric, limit: 50)
            if entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "crown")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                    Text("No leaderboard data")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Pull to refresh or try again later.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List {
                    Section(header: headerView) {
                        ForEach(0..<entries.count) { index in
                            let entry = entries[index]
                            LeaderboardRowView(rank: index + 1, entry: entry)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Rank").font(.caption).foregroundColor(.secondary).frame(width: 44, alignment: .leading)
            Text("Player").font(.caption).foregroundColor(.secondary)
            Spacer()
            switch selectedMetric {
            case .rating:
                Text("Rating").font(.caption).foregroundColor(.secondary)
            case .wins:
                Text("Wins").font(.caption).foregroundColor(.secondary)
            case .streak:
                Text("Streak").font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

private struct LeaderboardRowView: View {
    let rank: Int
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.subheadline)
                .frame(width: 44, alignment: .leading)
                .foregroundColor(rank <= 3 ? .orange : .secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .fontWeight(.semibold)
                Text(entry.homeCourt)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.0f", entry.rating))
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("\(entry.wins)-\(entry.losses) • \(streakText)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
    
    private var streakText: String {
        if entry.currentStreak > 0 { return "W\(entry.currentStreak)" }
        if entry.currentStreak < 0 { return "L\(abs(entry.currentStreak))" }
        return "-"
    }
}

#Preview {
    LeaderboardView()
}


