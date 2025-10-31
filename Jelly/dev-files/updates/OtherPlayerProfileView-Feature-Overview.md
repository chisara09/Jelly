# OtherPlayerProfileView Feature Overview

## 📋 Feature Summary

**OtherPlayerProfileView** is a comprehensive profile screen that allows users to view detailed information about other players in the Jelly basketball app. This view enables users to explore player stats, review match history, and quickly initiate challenges or conversations.

---

## 🎯 Core Requirements

From `updates.md`:

> **OtherPlayerProfileView** — View another user's profile  
> - Show player's rating, match history, and mutual games.  
> - Option to **send challenge** or **message** directly.

---

## ✨ Implemented Features

### 1. Profile Header Section
- **Player Avatar** - Gradient circle with player initials
- **Player Name** - Prominently displayed full name
- **Home Court** - Shows player's favorite court location
- **Distance Indicator** - Displays how far away the player is (in miles)

### 2. Action Buttons
- **Challenge Button** 
  - Primary action button with gradient background (orange → red)
  - Trophy icon for visual clarity
  - Opens NewChallengeView to set up a match
  - Disabled if user has blocked this player
  
- **Message Button**
  - Secondary action button with gray background
  - Message icon for easy recognition
  - Opens ChatView for direct communication
  - Disabled if user has blocked this player

### 3. Player Stats Display

#### Stats Grid (2x2)
Four interactive stat cards displaying:
- **Record** - Win-loss record (e.g., "18 - 7")
- **Win Rate** - Percentage of games won (e.g., "72%")
- **Streak** - Current win/loss streak with emoji indicators
- **Rating** - Numerical skill rating (e.g., "1325")

#### Detailed Stats List
Additional stats shown in a list format:
- **Wins** - Total number of wins
- **Losses** - Total number of losses
- **Best Streak** - Longest winning streak
- **Total Games** - Total games played

### 4. Match History Section

Shows mutual games between current user and the viewed player:

**When Games Exist:**
- Match list showing up to 3 recent mutual games
- Each game displays:
  - Opponent name with "vs" prefix
  - Court location
  - Date and time
  - Result badge (Win/Loss/Disputed)
  - Final score
- Game count indicator in section header

**Empty State:**
- Basketball icon
- "No mutual games yet" message
- Encouraging subtext to challenge the player

### 5. Safety & Privacy Features
- **Block User** - Prevents all interaction
- **Report User** - Allows reporting inappropriate behavior
- Both accessible via toolbar menu (three dots)

---

## 🎨 Design Highlights

### Visual Hierarchy
1. **Profile Header** - Most prominent, establishes context
2. **Action Buttons** - Clear call-to-action placement
3. **Stats Section** - Easy-to-scan grid layout
4. **Match History** - Scrollable, detailed information

### Color Coding
- **Orange/Red Gradient** - Primary actions, branding
- **Green** - Wins, positive stats
- **Red** - Losses, negative outcomes
- **Orange** - Disputed games, warnings
- **Purple** - Rating indicator
- **Blue** - Record stats
- **Gray** - Secondary actions, neutral info

### Typography
- **Title2 Bold** - Player name
- **Headline** - Section headers, button text
- **Title3 Bold** - Stat values
- **Subheadline** - Secondary information
- **Caption** - Tertiary details, timestamps

---

## 🔄 User Flow

### Primary Flow
```
FindPlayersView → Select Player → OtherPlayerProfileView
                                   ↓
                    ┌──────────────┼──────────────┐
                    ↓              ↓              ↓
            Challenge Button  Message Button  View Stats
                    ↓              ↓
          NewChallengeView    ChatView
```

### Alternative Entry Points
- Leaderboard tap on player
- Search results selection
- Chat conversation profile link
- Game history opponent tap

---

## 🛠️ Technical Implementation

### Components Created

#### OtherPlayerStatCard
```swift
struct OtherPlayerStatCard: View
```
- Reusable stat card component
- Parameters: title, value, icon, color
- 2-column grid layout compatible

#### OtherPlayerStatDetailRow
```swift
struct OtherPlayerStatDetailRow: View
```
- List-style stat row
- Icon, label, value display
- Color-coded indicators

#### MutualGameRow
```swift
struct MutualGameRow: View
```
- Displays individual mutual game
- Shows result, score, location, date
- Color-coded win/loss/disputed states

### State Management
```swift
@State private var showNewChallenge = false
@State private var showChat = false
@State private var showBlockAlert = false
@State private var showReportSheet = false
@State private var playerStats = PlayerStats(...)
```

### Data Flow
- **Input**: `NearbyPlayer` object passed from parent view
- **Environment**: `GameManager` for game data
- **Singleton**: `SafetyManager` for blocking/reporting

---

## 🎭 User Experience Enhancements

### 1. Contextual Information
- Distance indicator helps users understand proximity
- Home court shows player's preferred location
- Stats provide skill level context before challenging

### 2. Quick Actions
- Challenge and Message buttons side-by-side
- No navigation required for primary actions
- One-tap access to core functionality

### 3. Empty State Handling
- Graceful empty state when no mutual games exist
- Encouraging message to start rivalry
- Clear call-to-action

### 4. Safety First
- Easy access to block and report functions
- Confirmation alerts for destructive actions
- Blocked users can't be challenged or messaged

### 5. Visual Feedback
- Color-coded game results for quick scanning
- Icon-driven UI for intuitive understanding
- Disabled state for blocked user actions

---

## 📊 Component Breakdown

### Profile Header (VStack)
```
┌─────────────────────────────┐
│      [Avatar Circle]        │
│      Player Name            │
│   📍 Home Court             │
│   📍 2.3 mi away            │
│                             │
│  [Challenge] [Message]      │
└─────────────────────────────┘
```

### Stats Grid (LazyVGrid 2x2)
```
┌──────────┬──────────┐
│  Record  │ Win Rate │
│  18 - 7  │   72%    │
├──────────┼──────────┤
│  Streak  │  Rating  │
│ 🔥 3 wins│   1325   │
└──────────┴──────────┘
```

### Match History (VStack)
```
┌─────────────────────────────┐
│ Match History      3 games  │
├─────────────────────────────┤
│ vs Marcus                   │
│ Central Park       [Win]    │
│ Oct 28, 2025       21 - 18  │
├─────────────────────────────┤
│ vs Marcus                   │
│ Brooklyn Courts   [Loss]    │
│ Oct 20, 2025       18 - 21  │
└─────────────────────────────┘
```

---

## 🔐 Safety & Privacy

### Block User Flow
1. Tap menu (⋯) in toolbar
2. Select "Block User"
3. Confirmation alert appears
4. If confirmed:
   - User is blocked via SafetyManager
   - View dismisses
   - Challenge and Message buttons disabled

### Report User Flow
1. Tap menu (⋯) in toolbar
2. Select "Report"
3. Report sheet presents
4. Select reason from list
5. Submit report
6. Confirmation shown

---

## 🚀 Future Enhancement Opportunities

### Short Term (v1.1)
1. **Head-to-Head Stats**
   - Win/loss record specifically against this player
   - Average score differential
   - Favorite court for matches

2. **Recent Activity**
   - Last game played date
   - Current availability status
   - Active streak info

### Medium Term (v1.2)
1. **Comparative Stats**
   - Side-by-side stat comparison
   - Skill level differential
   - Mutual friends/opponents

2. **Match Timeline**
   - Visual timeline of all matches
   - Score progression over time
   - Court location map

### Long Term (v2.0)
1. **Advanced Analytics**
   - Win probability calculator
   - Performance trends
   - Playing style indicators

2. **Social Features**
   - Add to favorites
   - Share profile
   - Request rematch button

---

## 🎯 Success Metrics

### User Engagement
- ✅ Quick access to challenge creation
- ✅ Direct messaging capability
- ✅ Comprehensive stat visibility

### Information Architecture
- ✅ Clear visual hierarchy
- ✅ Logical content grouping
- ✅ Minimal cognitive load

### Safety & Trust
- ✅ Easy access to safety features
- ✅ Clear feedback on actions
- ✅ Respects user boundaries (blocking)

---

## 📱 Platform Considerations

### iOS Compatibility
- Requires iOS 17.0+
- SwiftUI framework
- Native UI components

### Device Support
- iPhone (all sizes)
- iPad (optimized layout)
- Dark mode compatible

### Accessibility
- Dynamic type support
- VoiceOver compatible
- Sufficient color contrast

---

## 🔗 Integration Points

### Connects To
- **NewChallengeView** - Challenge creation
- **ChatView** - Direct messaging
- **GameManager** - Match data retrieval
- **SafetyManager** - Blocking/reporting
- **FindPlayersView** - Player discovery

### Receives From
- NearbyPlayer object
- GameManager environment object

### Provides To
- Player context to NewChallengeView
- Game context to ChatView
- User ID to SafetyManager

---

## 📝 Notes

### Mock Data
Currently uses mock data for:
- Player stats (wins, losses, rating, etc.)
- Mutual game filtering
- Random game selection for demonstration

In production, this would:
- Fetch real player stats from API
- Query actual mutual games from database
- Calculate real-time statistics

### Performance
- Lazy loading for game list
- Efficient state management
- Minimal re-renders

### Code Quality
- Modular component design
- Clear naming conventions
- Comprehensive comments
- Type-safe implementations

---

## ✅ Requirements Checklist

- [x] Show player's rating
- [x] Show match history
- [x] Show mutual games
- [x] Option to send challenge
- [x] Option to message directly
- [x] Empty state handling
- [x] Safety features (block/report)
- [x] Visual polish and UX refinements

---

**Status:** ✅ **COMPLETE**  
**Version:** 1.0  
**Date:** October 31, 2025

