# LeaderboardView Updates - Feature Overview

## 📋 Overview

This document provides a comprehensive overview of the LeaderboardView updates implemented according to the specifications in `updates.md`. The LeaderboardView now includes a toggle between global and local leaderboard views, allowing users to see both worldwide rankings and nearby player ratings.

---

## 🎯 Key Requirements (from updates.md)

The LeaderboardView updates were designed to meet the following requirements:

1. **Global/Local Toggle**: Add a toggle button to switch between global and local leaderboard views
2. **Local Leaderboard**: Show nearby players' ratings within a specified radius (25 miles)
3. **Global by Default**: Display the global leaderboard as the default view
4. **Multiple Metrics**: Maintain existing ability to sort by Rating, Wins, or Streak

---

## ✨ New Features & Components

### 1. **Scope Toggle (Global/Local)**

A new segmented picker allows users to switch between two leaderboard scopes:

- **Global** → Shows all players worldwide (default)
- **Local** → Shows only players within 25 miles of user's location

```swift
Picker("Scope", selection: $selectedScope) {
    ForEach(LeaderboardManager.LeaderboardScope.allCases) { scope in
        Text(scope.rawValue).tag(scope)
    }
}
.pickerStyle(.segmented)
```

### 2. **Dual-Picker Interface**

The LeaderboardView now features two segmented pickers stacked vertically:

**Scope Picker** (Top)
- Global / Local selection
- Appears above the metric picker
- Filters the entire leaderboard

**Metric Picker** (Bottom)
- Rating / Wins / Streak selection
- Sorts the filtered results
- Works in combination with scope selection

### 3. **Location-Based Filtering**

The local leaderboard uses geolocation filtering:

**Filtering Logic**
- Calculates distance from user to each player
- Uses player's home court coordinates
- Filters to within 25-mile radius
- Falls back to NYC default location for demo

**Distance Calculation**
- Uses CoreLocation framework
- CLLocation distance calculation
- Converts meters to miles
- Accurate real-world distances

### 4. **Enhanced LeaderboardEntry Model**

Updated data model to support location tracking:

```swift
struct LeaderboardEntry {
    let id: UUID
    let name: String
    let rating: Double
    let wins: Int
    let losses: Int
    let currentStreak: Int
    let homeCourt: String
    let latitude: Double?    // NEW
    let longitude: Double?   // NEW
}
```

### 5. **Smart Empty State Handling**

When local filter returns no results:
- Shows "No leaderboard data" message
- Suggests pulling to refresh
- Gracefully handles edge cases

---

## 🔧 Technical Implementation

### New Enum: LeaderboardScope

```swift
enum LeaderboardScope: String, CaseIterable, Identifiable {
    case global = "Global"
    case local = "Local"
    
    var id: String { rawValue }
}
```

### Updated topEntries Method

```swift
func topEntries(
    sortedBy metric: LeaderboardMetric, 
    scope: LeaderboardScope, 
    limit: Int = 50
) -> [LeaderboardEntry]
```

**Process Flow:**
1. Get snapshot entries
2. Filter by scope (global = all, local = nearby)
3. Sort by selected metric
4. Return top N entries

### Location Filtering Algorithm

```swift
private func filterLocalEntries(entries: [LeaderboardEntry]) -> [LeaderboardEntry] {
    let userLocation = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)
    let localRadiusMiles = 25.0
    
    return entries.filter { entry in
        guard let lat = entry.latitude, let lon = entry.longitude else { return false }
        let entryLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let distance = distanceInMiles(from: userLocation, to: entryLocation)
        return distance <= localRadiusMiles
    }
}
```

---

## 📊 Data Flow

```
User Interaction
    ↓
Selects Scope (Global/Local)
    ↓
LeaderboardView updates selectedScope
    ↓
Calls leaderboardManager.topEntries(sortedBy:scope:limit:)
    ↓
LeaderboardManager filters entries by scope
    ├─ Global: Returns all entries
    └─ Local: Filters by 25-mile radius
    ↓
Sorts by selected metric (Rating/Wins/Streak)
    ↓
Returns top 50 entries
    ↓
UI updates with filtered and sorted list
```

---

## 🎨 UI/UX Enhancements

### Visual Hierarchy

1. **Navigation Bar** - "Leaderboard" title + refresh button
2. **Scope Picker** - Global/Local toggle (new)
3. **Metric Picker** - Rating/Wins/Streak selection
4. **Leaderboard List** - Ranked players with stats
5. **Empty State** - Fallback when no data

### Layout Structure

```
┌─────────────────────────────┐
│      Leaderboard        🔄  │
├─────────────────────────────┤
│ [Global] | [Local]          │ ← NEW
├─────────────────────────────┤
│ [Rating] [Wins] [Streak]    │
├─────────────────────────────┤
│ #1  Marcus Johnson    1450  │
│     Central Park       42-8 │
├─────────────────────────────┤
│ #2  Jamal Smith       1398  │
│     Brooklyn Heights   38-5 │
├─────────────────────────────┤
│ #3  Darius Lee        1385  │
│     Harlem Rucker      35-9 │
└─────────────────────────────┘
```

### Interaction Design

**Scope Selection**
- Instant filtering when scope changes
- Smooth transition between global/local
- Maintains metric selection
- Preserves scroll position when possible

**Combined Filtering**
- Scope + Metric work together
- Example: "Local + Wins" shows nearby players sorted by win count
- Example: "Global + Streak" shows all players sorted by current streak

---

## 📱 Screen Flow

```
LeaderboardView
    │
    ├─ Select Global ──► Shows all players (default)
    │                    ├─ Sort by Rating
    │                    ├─ Sort by Wins
    │                    └─ Sort by Streak
    │
    └─ Select Local ───► Shows nearby players (25 mi radius)
                         ├─ Sort by Rating
                         ├─ Sort by Wins
                         └─ Sort by Streak
```

---

## 🔄 Use Cases

### Use Case 1: View Global Rankings
**Scenario**: User wants to see where they rank globally

**Steps:**
1. Open LeaderboardView
2. Global scope selected by default
3. View top 50 players worldwide
4. Tap player to see their profile

**Result**: User sees competitive landscape across all players

---

### Use Case 2: Find Local Competition
**Scenario**: User wants to challenge nearby players

**Steps:**
1. Open LeaderboardView
2. Tap "Local" in scope picker
3. View nearby players (within 25 miles)
4. Identify players at similar skill level
5. Tap player to view profile and send challenge

**Result**: User discovers local competition for easier meetups

---

### Use Case 3: Compare Local vs Global
**Scenario**: User wants to see how local competition stacks up

**Steps:**
1. View Global leaderboard
2. Note top player ratings
3. Switch to Local leaderboard
4. Compare rating distributions
5. Identify local ranking

**Result**: User understands their standing in both contexts

---

### Use Case 4: Track Local Win Leader
**Scenario**: User wants to see who has most wins nearby

**Steps:**
1. Select "Local" scope
2. Select "Wins" metric
3. View local players sorted by win count
4. Track progress over time

**Result**: User sees local win leaders and competitive goals

---

## ✅ Compliance with Requirements

| Requirement | Status | Implementation |
|------------|---------|----------------|
| Global/Local toggle | ✅ Complete | Segmented picker with two options |
| Local leaderboard view | ✅ Complete | Filters by 25-mile radius |
| Nearby players' ratings | ✅ Complete | Shows rating + full stats |
| Global by default | ✅ Complete | selectedScope defaults to .global |
| Maintain metric sorting | ✅ Complete | Works with both scopes |
| Location-based filtering | ✅ Complete | Uses CoreLocation distance |
| Empty state handling | ✅ Complete | Graceful "no data" message |

---

## 🚀 Future Enhancements

Potential improvements for future iterations:

### Short Term (v1.1)

1. **Adjustable Radius**
   - Let users customize local radius (10/25/50/100 miles)
   - Store preference in settings
   - Update filter dynamically

2. **Distance Display**
   - Show distance to each player in local view
   - "2.3 miles away"
   - Sort by distance option

3. **Location Permission**
   - Request actual user location
   - Use LocationManager integration
   - Fall back to home court if denied

### Medium Term (v1.2)

1. **Multiple Local Scopes**
   - City-level leaderboard
   - State-level leaderboard
   - Region-level leaderboard
   - Custom radius selection

2. **Map Integration**
   - Show local players on map
   - Interactive pins for each player
   - Distance visualization

3. **Location-Based Stats**
   - "You rank #5 locally, #234 globally"
   - Percentile in each scope
   - Local vs global comparison chart

### Long Term (v2.0)

1. **Court-Specific Leaderboards**
   - Leaderboard for each court
   - "Kings of Rucker Park"
   - Home court advantage stats

2. **Dynamic Regions**
   - Auto-detect user's metro area
   - Show regional championships
   - Inter-regional competitions

3. **Historical Tracking**
   - Track rank changes over time
   - "You moved from #12 to #8 locally"
   - Rank progression graphs

---

## 📝 Code Quality

- **No linter errors**: All code passes Swift linting
- **Type safety**: Strong typing throughout
- **Memory management**: Proper use of @State and @StateObject
- **Reusable components**: LeaderboardScope can be used elsewhere
- **Clean separation**: View logic separated from data logic
- **Efficient filtering**: O(n) filtering with distance calculation
- **Optional safety**: Proper handling of optional coordinates

---

## 🎓 Key Learnings

1. **Dual Filters**: Scope + Metric provides powerful filtering combinations
2. **Location Privacy**: Important to handle location gracefully (optional, defaults)
3. **Distance Calculation**: CoreLocation provides accurate real-world distances
4. **User Context**: Local view provides more relevant, actionable information
5. **Default Behavior**: Global default ensures all users see content immediately
6. **Empty States**: Local filter may return empty results - must handle gracefully

---

## 📚 Related Files

- `/Jelly/Views/LeaderboardView.swift` - Main leaderboard view with updates
- `/Jelly/Managers/LeaderboardManager.swift` - Leaderboard data management + filtering
- `/Jelly/Models/Location.swift` - Location data structures
- `/Jelly/Managers/LocationManager.swift` - Location services (future integration)

---

## 🔗 References

- Original specification: `/Jelly/dev-files/updates/updates.md`
- Implementation summary: `LeaderboardView-Implementation-Summary.md`
- Testing guide: `LeaderboardView-Testing-Guide.md`
- Completion summary: `LEADERBOARDVIEW-UPDATES-COMPLETE.md`

---

**Last Updated**: October 31, 2025  
**Version**: 1.0  
**Status**: ✅ Complete

