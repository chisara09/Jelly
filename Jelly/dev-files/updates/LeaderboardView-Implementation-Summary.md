# LeaderboardView Updates - Implementation Summary

## 📝 Quick Summary

LeaderboardView has been updated to include a global/local toggle feature, allowing users to filter the leaderboard by geographic proximity. Players can now view both worldwide rankings (global) and nearby player ratings (local), with seamless switching between the two views.

---

## 🔨 Changes Made

### 1. **LeaderboardView.swift - Main Updates**

#### Added LeaderboardScope State Variable
**Location**: Line 15

```swift
@State private var selectedScope: LeaderboardManager.LeaderboardScope = .global
```

**Purpose**: Tracks whether user is viewing global or local leaderboard. Defaults to `.global` as specified in requirements.

#### Added Scope Picker (Global/Local Toggle)
**Location**: Lines 20-28

**Before:**
```swift
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
```

**After:**
```swift
var body: some View {
    NavigationStack {
        VStack(spacing: 0) {
            // Scope Picker (Global/Local)
            Picker("Scope", selection: $selectedScope) {
                ForEach(LeaderboardManager.LeaderboardScope.allCases) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top)
            
            // Metric Picker (Rating/Wins/Streak)
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
```

**Changes:**
- Added new scope picker above metric picker
- Added clarifying comments for both pickers
- Adjusted padding for visual hierarchy

#### Updated topEntries Call
**Location**: Line 99

**Before:**
```swift
let entries = leaderboardManager.topEntries(sortedBy: selectedMetric, limit: 50)
```

**After:**
```swift
let entries = leaderboardManager.topEntries(sortedBy: selectedMetric, scope: selectedScope, limit: 50)
```

**Changes:**
- Added `scope: selectedScope` parameter
- Passes user's scope selection to filtering logic

---

### 2. **LeaderboardManager.swift - Data Management Updates**

#### Added CoreLocation Import
**Location**: Line 10

```swift
import CoreLocation
```

**Purpose**: Enables distance calculations for local filtering.

#### Updated LeaderboardEntry Model
**Location**: Lines 22-23

**Before:**
```swift
struct LeaderboardEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let rating: Double
    let wins: Int
    let losses: Int
    let currentStreak: Int
    let homeCourt: String
}
```

**After:**
```swift
struct LeaderboardEntry: Identifiable, Codable, Equatable, Hashable {
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

**Changes:**
- Added `latitude` field (optional)
- Added `longitude` field (optional)
- Supports location-based filtering

#### Added LeaderboardScope Enum
**Location**: Lines 83-88

```swift
enum LeaderboardScope: String, CaseIterable, Identifiable {
    case global = "Global"
    case local = "Local"
    
    var id: String { rawValue }
}
```

**Purpose**: Defines the two leaderboard scope options.

#### Updated topEntries Method
**Location**: Lines 48-59

**Before:**
```swift
func topEntries(sortedBy metric: LeaderboardMetric, limit: Int = 50) -> [LeaderboardEntry] {
    guard let snapshot else { return [] }
    let sorted = sort(entries: snapshot.entries, by: metric)
    return Array(sorted.prefix(limit))
}
```

**After:**
```swift
func topEntries(sortedBy metric: LeaderboardMetric, scope: LeaderboardScope, limit: Int = 50) -> [LeaderboardEntry] {
    guard let snapshot else { return [] }
    var filteredEntries = snapshot.entries
    
    // Filter by scope
    if scope == .local {
        filteredEntries = filterLocalEntries(entries: filteredEntries)
    }
    
    let sorted = sort(entries: filteredEntries, by: metric)
    return Array(sorted.prefix(limit))
}
```

**Changes:**
- Added `scope` parameter
- Filter entries by scope before sorting
- Global scope returns all entries (no filtering)
- Local scope filters by proximity

#### Added filterLocalEntries Method
**Location**: Lines 61-74

```swift
private func filterLocalEntries(entries: [LeaderboardEntry]) -> [LeaderboardEntry] {
    // Get user's location from LocationManager if available
    // For now, we'll filter by proximity to a mock user location
    // In production, this would use actual user location
    let userLocation = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855) // NYC default
    let localRadiusMiles = 25.0
    
    return entries.filter { entry in
        guard let lat = entry.latitude, let lon = entry.longitude else { return false }
        let entryLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let distance = distanceInMiles(from: userLocation, to: entryLocation)
        return distance <= localRadiusMiles
    }
}
```

**Key Features:**
- Uses 25-mile radius for "local" definition
- Defaults to NYC coordinates for demo (40.7580, -73.9855)
- Filters out entries without coordinates
- Calculates real-world distance using helper method

**Production Note**: Will integrate with LocationManager to use actual user location.

#### Added distanceInMiles Helper Method
**Location**: Lines 76-81

```swift
private func distanceInMiles(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
    let distanceInMeters = fromLocation.distance(from: toLocation)
    return distanceInMeters / 1609.34 // Convert meters to miles
}
```

**Purpose**: 
- Calculates accurate distance between two coordinates
- Uses CLLocation's built-in distance calculation
- Converts meters to miles (1609.34 meters = 1 mile)

#### Updated Mock Data Generation
**Location**: Lines 173, 190-202

**Before:**
```swift
let entry = LeaderboardEntry(
    id: UUID(),
    name: names[i],
    rating: rating,
    wins: wins,
    losses: losses,
    currentStreak: streakPool.randomElement() ?? 0,
    homeCourt: randomCourt()
)
```

**After:**
```swift
let (court, lat, lon) = randomCourtWithLocation()
let entry = LeaderboardEntry(
    id: UUID(),
    name: names[i],
    rating: rating,
    wins: wins,
    losses: losses,
    currentStreak: streakPool.randomElement() ?? 0,
    homeCourt: court,
    latitude: lat,
    longitude: lon
)
```

**Changes:**
- Now generates coordinates along with court name
- All mock entries include location data

#### Added randomCourtWithLocation Method
**Location**: Lines 190-202

**Before:**
```swift
private func randomCourt() -> String {
    let courts = [
        "Central Park Courts", "Brooklyn Heights", "Harlem Rucker Park", "Queensbridge Courts",
        "Sunset Park", "Prospect Park", "Riverside Courts", "Chelsea Piers"
    ]
    return courts.randomElement() ?? "Local Court"
}
```

**After:**
```swift
private func randomCourtWithLocation() -> (name: String, latitude: Double, longitude: Double) {
    let courts = [
        ("Central Park Courts", 40.7829, -73.9654),
        ("Brooklyn Heights", 40.6961, -73.9969),
        ("Harlem Rucker Park", 40.8303, -73.9389),
        ("Queensbridge Courts", 40.7575, -73.9486),
        ("Sunset Park", 40.6564, -74.0106),
        ("Prospect Park", 40.6602, -73.9690),
        ("Riverside Courts", 40.7957, -73.9712),
        ("Chelsea Piers", 40.7467, -74.0073)
    ]
    return courts.randomElement() ?? ("Local Court", 40.7580, -73.9855)
}
```

**Changes:**
- Returns tuple with (name, latitude, longitude)
- Uses real NYC court coordinates
- All courts within ~10-mile radius of default user location
- Enables realistic local filtering for testing

---

## 📊 Component Breakdown

### Files Modified
- ✏️ `LeaderboardView.swift` (updated)
- ✏️ `LeaderboardManager.swift` (updated)

### New Enums Created
- ✨ `LeaderboardScope` (in LeaderboardManager)

### New Methods Created
- ✨ `filterLocalEntries(entries:)` - Filters by proximity
- ✨ `distanceInMiles(from:to:)` - Calculates distance
- ✨ `randomCourtWithLocation()` - Mock data with coordinates

### Updated Methods
- 🔄 `topEntries(sortedBy:scope:limit:)` - Added scope parameter
- 🔄 `generateMockEntries(count:)` - Now includes coordinates

### Existing Components Preserved
- ✅ `LeaderboardMetric` enum (unchanged)
- ✅ `sort(entries:by:)` method (unchanged)
- ✅ `LeaderboardRowView` (unchanged)
- ✅ Navigation to player profiles (unchanged)
- ✅ Refresh functionality (unchanged)

---

## 🎯 Specific Updates by Section

### UI Layer (LeaderboardView)
**Status**: Enhanced
- ✅ Added scope picker above metric picker
- ✅ Both pickers work in combination
- ✅ Default scope is global
- ✅ Seamless switching between scopes

### Data Layer (LeaderboardManager)
**Status**: Enhanced
- ✅ Added location fields to model
- ✅ Added filtering logic for local scope
- ✅ Distance calculation implementation
- ✅ Mock data includes coordinates

### Navigation & Interaction
**Status**: Unchanged
- ✅ Tap player to view profile
- ✅ Refresh button functionality
- ✅ Error state handling
- ✅ Empty state handling

---

## 🔄 Data Flow Details

### When User Selects Global Scope

```
1. User taps "Global" in scope picker
   ↓
2. selectedScope = .global
   ↓
3. View calls topEntries(sortedBy: .rating, scope: .global, limit: 50)
   ↓
4. LeaderboardManager receives call
   ↓
5. scope == .global → No filtering applied
   ↓
6. All entries sorted by rating
   ↓
7. Returns top 50 entries
   ↓
8. UI updates with global leaderboard
```

### When User Selects Local Scope

```
1. User taps "Local" in scope picker
   ↓
2. selectedScope = .local
   ↓
3. View calls topEntries(sortedBy: .rating, scope: .local, limit: 50)
   ↓
4. LeaderboardManager receives call
   ↓
5. scope == .local → Calls filterLocalEntries()
   ↓
6. For each entry:
   - Check if coordinates exist
   - Calculate distance to user
   - Keep if within 25 miles
   ↓
7. Filtered entries sorted by rating
   ↓
8. Returns top 50 local entries
   ↓
9. UI updates with local leaderboard
```

---

## 🎨 UI Changes Summary

### Layout Changes

**Before:**
```
[Leaderboard Title]
    ↓
[Rating | Wins | Streak]
    ↓
[Player List]
```

**After:**
```
[Leaderboard Title]
    ↓
[Global | Local]  ← NEW
    ↓
[Rating | Wins | Streak]
    ↓
[Player List]
```

### Visual Hierarchy

1. **Navigation Bar** - Title + refresh button
2. **Scope Picker** - Global/Local (new, primary filter)
3. **Metric Picker** - Rating/Wins/Streak (secondary sort)
4. **List Header** - Rank, Player, Value columns
5. **Leaderboard Rows** - Player entries

---

## 🧪 Testing Considerations

### Manual Testing Checklist

#### Scope Toggle
- [ ] Global scope selected by default on load
- [ ] Tapping Local updates leaderboard
- [ ] Tapping Global returns to full list
- [ ] Scope selection persists during metric changes

#### Local Filtering
- [ ] Local view shows fewer or equal players than global
- [ ] All local players are within reasonable distance
- [ ] Players without coordinates excluded from local
- [ ] Empty state if no local players

#### Combined Filtering
- [ ] Local + Rating works correctly
- [ ] Local + Wins works correctly
- [ ] Local + Streak works correctly
- [ ] Global + all metrics work as before

#### Performance
- [ ] Smooth switching between scopes
- [ ] No lag during filtering
- [ ] Distance calculations don't slow UI

### Edge Cases

- [ ] No players in local area (empty state)
- [ ] All players in local area
- [ ] Player with missing coordinates
- [ ] Extreme distances (cross-country)
- [ ] User location unavailable

---

## 🐛 Known Limitations

### Current Mock Data

The user location is currently hardcoded:

```swift
let userLocation = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855) // NYC default
```

**Future Enhancement**: 
- Integrate with LocationManager
- Request user's actual location
- Fall back to home court if location denied

### Persistent Snapshot

LeaderboardEntry now includes location fields, but existing cached snapshots won't have them:

**Mitigation**:
- Fields are optional (Double?)
- Regenerate snapshot on first run after update
- Entries without location excluded from local view

### Fixed Local Radius

The 25-mile radius is hardcoded:

```swift
let localRadiusMiles = 25.0
```

**Future Enhancement**:
- Make radius user-configurable
- Store in SettingsManager
- Provide preset options (10/25/50/100 mi)

---

## 📦 Dependencies

### External Dependencies
- SwiftUI framework
- Foundation framework
- CoreLocation framework (NEW)

### Internal Dependencies
- `LeaderboardEntry` model (updated)
- `LeaderboardSnapshot` model (unchanged)
- `LeaderboardMetric` enum (unchanged)
- `LeaderboardScope` enum (new)

---

## 🔐 State Management

### @State Variables Added
```swift
@State private var selectedScope: LeaderboardManager.LeaderboardScope = .global
```

### @StateObject Variables (Existing)
```swift
@StateObject private var leaderboardManager = LeaderboardManager()
@StateObject private var gameManager = GameManager()
```

### @State Variables (Existing)
```swift
@State private var selectedMetric: LeaderboardManager.LeaderboardMetric = .rating
```

---

## 💡 Design Decisions

### Why Segmented Picker?

Using segmented picker for scope because:
- Clear binary choice (Global/Local)
- Consistent with metric picker below
- iOS standard pattern for filters
- Single-tap switching
- Visual indication of current selection

### Why 25-Mile Radius?

Chose 25 miles as default local radius because:
- Reasonable driving distance (~30 min)
- Large enough to include multiple courts
- Small enough to be "local"
- Covers typical metro area
- Can be adjusted per user in future

### Why Optional Coordinates?

Made latitude/longitude optional because:
- Backwards compatibility with existing data
- Some players may not share location
- Graceful degradation
- Can add coordinates over time
- Doesn't break global leaderboard

### Why Filter Before Sort?

Applied scope filter before metric sort because:
- More efficient (filter reduces set, then sort smaller set)
- Logical flow (scope is broader than metric)
- Matches UI hierarchy (scope picker above metric picker)
- Clearer code separation

---

## 🚦 Status Summary

| Component | Status | Notes |
|-----------|--------|-------|
| Global/Local Toggle | ✅ Complete | Segmented picker implemented |
| Location-Based Filtering | ✅ Complete | 25-mile radius filter |
| Distance Calculation | ✅ Complete | CoreLocation integration |
| Default to Global | ✅ Complete | selectedScope defaults to .global |
| Updated Data Model | ✅ Complete | Coordinates added to LeaderboardEntry |
| Mock Data with Location | ✅ Complete | All entries have coordinates |
| Empty States | ✅ Complete | Handles no local results |
| Linting | ✅ Complete | No errors |

---

## 📚 Code Examples

### Switching Scopes

```swift
// User taps Local
selectedScope = .local

// View automatically updates because of @State
// Triggers body recomputation
// Calls topEntries with new scope
let entries = leaderboardManager.topEntries(
    sortedBy: selectedMetric, 
    scope: selectedScope,  // Now .local
    limit: 50
)
```

### Distance Filtering

```swift
// For each player in the global list
for entry in allEntries {
    // Check if they have location data
    guard let lat = entry.latitude, let lon = entry.longitude else { 
        continue  // Skip entries without location
    }
    
    // Calculate distance from user
    let entryLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    let distance = distanceInMiles(from: userLocation, to: entryLocation)
    
    // Include if within 25 miles
    if distance <= 25.0 {
        localEntries.append(entry)
    }
}
```

### Combined Scope + Metric

```swift
// User selects: Local + Wins
selectedScope = .local
selectedMetric = .wins

// Results in:
// 1. Filter to players within 25 miles
// 2. Sort filtered players by wins
// 3. Show top 50 local players by win count
```

---

## 🎓 Lessons Learned

1. **Dual Filters**: Combining scope and metric provides powerful, intuitive filtering

2. **Location Privacy**: Always make location optional and provide defaults

3. **Performance**: Filter before sort for efficiency with large datasets

4. **User Defaults**: Global scope as default ensures everyone sees content immediately

5. **Visual Hierarchy**: Placing broader filter (scope) above narrower filter (metric) creates clear mental model

---

**Implementation Date**: October 31, 2025  
**Implemented By**: AI Assistant via Cursor  
**Status**: ✅ Complete - All requirements met  
**Linter Status**: ✅ No errors

