# HomeView - Feature Overview & User Guide

## 🎯 What's New in HomeView

### Feature 1: Interactive Stats with Match History
**What it does**: Tap any stat box to view your complete match history with before/after stats for each game.

**How to use**:
1. Tap any of the 4 stat boxes on HomeView
2. View your match history with details
3. Tap "Stats" on any match to see before/after comparison
4. See how each game affected your ratings

**Visual Guide**:
```
HomeView Stat Cards
┌─────────────────────────────────────────────┐
│  [Record]  [Win %]  [Streak]  [Rating]      │
│   12-3      80%      🔥 5      1250          │
│   ↓ Tap any card                             │
└─────────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────────┐
│          Match History                       │
├─────────────────────────────────────────────┤
│  Current Stats: 12-3 | 80% | 1250          │
├─────────────────────────────────────────────┤
│  [W] vs Marcus Johnson      21-18           │
│  📍 Central Park • Oct 29, 2025             │
│  [Stats ▼] ← Tap to expand                  │
│                                              │
│  [W] vs Sarah Williams      21-15           │
│  📍 Riverside Courts • Oct 26, 2025         │
│  [Stats ▼]                                   │
└─────────────────────────────────────────────┘
```

**Expanded Stats View**:
```
┌─────────────────────────────────────────────┐
│  [W] vs Marcus Johnson      21-18           │
│  📍 Central Park • Oct 29, 2025             │
│  [Stats ▲]                                   │
│                                              │
│  Stats Comparison                            │
│  ┌───────────────────────────────────────┐  │
│  │ Before    Stat        After           │  │
│  │ 11-3      Record      12-3      ↑     │  │
│  │ 1238      Rating      1250      ↑     │  │
│  │ 4         Streak      5         ↑     │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

---

### Feature 2: Smart Player Selection for Challenges
**What it does**: When creating a challenge, quickly find players from your recent opponents or nearby players.

**How to use**:
1. Tap "Create Challenge" button on HomeView
2. See recent opponents at the top for quick rematches
3. Browse nearby players by distance
4. Use search to find specific players
5. Tap a player to create a challenge

**Visual Guide**:
```
HomeView
┌─────────────────────────────────────────────┐
│  [+ Create Challenge]                        │
│  ↓ Tap button                                │
└─────────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────────┐
│          Select Player                       │
├─────────────────────────────────────────────┤
│  [🔍 Search players...]                      │
├─────────────────────────────────────────────┤
│  Recent Opponents                            │
│                                              │
│  [T] Tyler Brown                             │
│      📍 West Side Park • 2.1 mi       >      │
│                                              │
│  [A] Alex Rivera                             │
│      📍 East Courts • 3.5 mi          >      │
├─────────────────────────────────────────────┤
│  Nearby Players                              │
│                                              │
│  [M] Marcus Johnson                          │
│      📍 Central Park • 0.5 mi         >      │
│                                              │
│  [S] Sarah Williams                          │
│      📍 Riverside Courts • 1.2 mi     >      │
│                                              │
│  [J] James Chen                              │
│      📍 Downtown Gym • 1.8 mi         >      │
└─────────────────────────────────────────────┘
              ↓ Tap any player
┌─────────────────────────────────────────────┐
│          New Challenge                       │
├─────────────────────────────────────────────┤
│  Opponent: Marcus Johnson                   │
│  Court: [Enter court name]                  │
│  Date: [Select date/time]                   │
│  Rules: [First to 21]                       │
│                                              │
│  [Send Challenge]                            │
└─────────────────────────────────────────────┘
```

---

## 📱 User Benefits

### Better Stat Tracking
- **See your progress**: View how each match affects your stats
- **Identify trends**: Notice winning/losing streaks
- **Track improvements**: See rating changes over time
- **Contextual history**: Remember where and when you played

### Faster Challenge Creation
- **Quick rematches**: Recent opponents are readily available
- **Location-based**: Find players nearby for convenient matches
- **Easy search**: Quickly find specific players
- **Less friction**: Fewer steps to create a challenge

---

## 🎨 Design Features

### Visual Hierarchy
- **Color coding**: Green for wins, red for losses, orange for actions
- **Clear sections**: Separated content areas with headers
- **Iconography**: Map pins, search icons, chevrons for navigation
- **Consistent styling**: Matches overall app design

### User Experience
- **Tappable cards**: Clear affordance that stats are interactive
- **Expandable details**: Progressive disclosure of information
- **Search functionality**: Quick filtering of player lists
- **Modal presentations**: Clear entry/exit points

---

## 🔄 User Flows

### Flow 1: Check Match History from Wins
```
HomeView → Tap "Record" stat
         → View match list
         → Tap "Stats" on a match
         → See before/after comparison
         → Tap "Done"
         → Back to HomeView
```

### Flow 2: Challenge a Recent Opponent
```
HomeView → Tap "Create Challenge"
         → See "Recent Opponents" section
         → Tap opponent name
         → Fill challenge details
         → Send challenge
         → Back to HomeView
```

### Flow 3: Find Nearby Player
```
HomeView → Tap "Create Challenge"
         → Browse "Nearby Players"
         → See players by distance
         → Select player
         → Create challenge
         → Back to HomeView
```

### Flow 4: Search for Specific Player
```
HomeView → Tap "Create Challenge"
         → Type in search bar
         → See filtered results
         → Select player
         → Create challenge
         → Back to HomeView
```

---

## 💡 Tips for Users

### Making the Most of Match History
- Check your stats after each game to see improvement
- Look for patterns in wins/losses by opponent or location
- Use streak information to build confidence
- Review rating changes to understand your skill progression

### Finding the Right Opponent
- **Recent Opponents**: Great for rematches and building rivalries
- **Nearby Players**: Best for same-day or spontaneous games
- **Search**: Perfect when you know who you want to play
- **Check distance**: Plan based on your availability and travel time

---

## 📊 Data Displayed

### Match History Shows:
- **Match result**: Win or Loss with color coding
- **Opponent name**: Who you played against
- **Score**: Final game score
- **Court location**: Where the match took place
- **Date**: When the match occurred
- **Stats before**: Your stats at the time of the match
- **Stats after**: Your updated stats post-match
- **Stat changes**: Visual indicators of improvements

### Player Selection Shows:
- **Player name**: Full name of potential opponent
- **Home court**: Their usual playing location
- **Distance**: How far away they are from you
- **Player initial**: Visual avatar with first letter of name

---

## 🚀 What's Coming Next

### Planned Enhancements
- **Filters**: Filter match history by date range, opponent, or outcome
- **Charts**: Visual graphs showing rating progression over time
- **Achievements**: Badges for milestones and streaks
- **Player stats**: See opponent's stats before challenging
- **Favorites**: Save favorite players for quick access
- **Court details**: More info about courts and availability

### Backend Integration
- Real-time location updates for nearby players
- Live match history from server
- Push notifications for challenge responses
- Player profiles with detailed stats
- Court reviews and ratings

---

## ❓ FAQ

**Q: Can I see more than 3 matches in history?**  
A: Currently showing recent matches. Future updates will include pagination for full history.

**Q: How is distance calculated for nearby players?**  
A: Based on straight-line distance from your current location (requires location permission).

**Q: Can I filter the player list by rating or skill level?**  
A: Not yet, but this is planned for a future update.

**Q: What if I don't see any recent opponents?**  
A: The section only appears if you have previous matches. New users won't see it initially.

**Q: Can I see my opponent's match history?**  
A: Currently no, but viewing other player profiles is planned.

---

## 📞 Support

If you encounter issues with:
- Stats not updating correctly
- Match history not displaying
- Player selection not working
- Search functionality issues

Please report through the app's feedback system or contact support.

---

*Enjoy your enhanced Jelly experience! 🏀*

