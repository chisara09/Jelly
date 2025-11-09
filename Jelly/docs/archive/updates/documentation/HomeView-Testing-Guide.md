# HomeView Updates - Testing Guide

## 🧪 Quick Test Instructions

### Prerequisites
- Build and run the Jelly app on iOS Simulator or device
- Navigate to the HomeView (main dashboard after login)

---

## Test Case 1: Stat Box Navigation to Match History

### Steps
1. On HomeView, locate the "Your Stats" section with 4 stat cards
2. **Tap the "Record" stat box** (shows wins-losses, e.g., "12 - 3")
   - ✅ Verify: Match History modal opens
   - ✅ Verify: Current stats are displayed at the top
   - ✅ Verify: List of previous matches appears below

3. In the Match History view:
   - ✅ Verify: Each match shows opponent name, score, and result (W/L)
   - ✅ Verify: Wins have green "W" badge, losses have red "L" badge
   - ✅ Verify: Court name and date are visible

4. **Tap the "Stats" button** on any match card
   - ✅ Verify: Card expands to show before/after stats comparison
   - ✅ Verify: Stats include Record, Rating, and Streak
   - ✅ Verify: Arrows indicate improvements (green up) or declines (red down)

5. **Tap "Stats" button again**
   - ✅ Verify: Card collapses back to summary view

6. **Tap "Done"** in top-right corner
   - ✅ Verify: Returns to HomeView

7. **Repeat steps 2-6** for other stat boxes:
   - Win % stat box
   - Streak stat box
   - Rating stat box
   - ✅ Verify: All open the same Match History view

---

## Test Case 2: Create Challenge with Player Selection

### Steps
1. On HomeView, scroll to the **"Create Challenge"** button (orange/red gradient)
2. **Tap "Create Challenge"**
   - ✅ Verify: Player Selection modal opens
   - ✅ Verify: "Select Player" title appears at top
   - ✅ Verify: Search bar is visible

3. In Player Selection view:
   - ✅ Verify: "Recent Opponents" section appears (if applicable)
   - ✅ Verify: "Nearby Players" section appears
   - ✅ Verify: Each player shows:
     - Player name
     - Home court location with pin icon
     - Distance in miles
     - Avatar circle with initial

4. **Type in the search bar** (e.g., "Marcus")
   - ✅ Verify: Player list filters to matching names
   - ✅ Verify: Non-matching players are hidden

5. **Clear the search** (delete all text)
   - ✅ Verify: All players reappear

6. **Tap "Cancel"**
   - ✅ Verify: Returns to HomeView

7. **Tap "Create Challenge"** again
8. **Tap any player** from the list
   - ✅ Verify: NewChallengeView opens
   - ✅ Verify: Selected player's name appears in "Opponent" section
   - ✅ Verify: Court, Date & Time, and Rules sections are editable

9. **Tap "Cancel"** in NewChallengeView
   - ✅ Verify: Returns to Player Selection view

10. **Tap "Cancel"** in Player Selection view
    - ✅ Verify: Returns to HomeView

---

## Test Case 3: UI/UX Polish

### Visual Checks
- ✅ Stat cards have consistent styling
- ✅ Colors match app theme (orange, green, blue, purple)
- ✅ All text is readable
- ✅ Icons are properly aligned
- ✅ Spacing and padding look balanced

### Interaction Checks
- ✅ Tap gestures respond immediately
- ✅ Modal transitions are smooth
- ✅ Buttons have appropriate tap targets
- ✅ No UI elements overlap or cut off

### Edge Cases
- ✅ Long player names don't overflow
- ✅ Long court names don't overflow
- ✅ Search with no results shows empty state (if implemented)
- ✅ All modals can be dismissed properly

---

## Test Case 4: Navigation Flow

### Complete User Journey
1. Start at HomeView
2. Tap any stat box → Match History opens
3. Expand a match card → See detailed stats
4. Tap "Done" → Return to HomeView
5. Tap "Create Challenge" → Player Selection opens
6. Search for a player → See filtered results
7. Select a player → NewChallengeView opens
8. Cancel → Back to Player Selection
9. Cancel → Back to HomeView

**Expected Result**: Smooth navigation with no crashes or UI glitches

---

## 📊 Test Results Template

### Date: _____________
### Tester: _____________
### Device/Simulator: _____________

| Test Case | Status | Notes |
|-----------|--------|-------|
| Stat Box - Record | ⬜ Pass / ⬜ Fail | |
| Stat Box - Win % | ⬜ Pass / ⬜ Fail | |
| Stat Box - Streak | ⬜ Pass / ⬜ Fail | |
| Stat Box - Rating | ⬜ Pass / ⬜ Fail | |
| Match History - Expand/Collapse | ⬜ Pass / ⬜ Fail | |
| Match History - Done Button | ⬜ Pass / ⬜ Fail | |
| Create Challenge Button | ⬜ Pass / ⬜ Fail | |
| Player Selection - Recent Opponents | ⬜ Pass / ⬜ Fail | |
| Player Selection - Nearby Players | ⬜ Pass / ⬜ Fail | |
| Player Selection - Search | ⬜ Pass / ⬜ Fail | |
| Player Selection - Cancel | ⬜ Pass / ⬜ Fail | |
| Player Selection → NewChallenge | ⬜ Pass / ⬜ Fail | |
| Full Navigation Flow | ⬜ Pass / ⬜ Fail | |

---

## 🐛 Known Issues / Limitations

### Current Mock Data
- **Nearby Players**: 3 mock players (Marcus Johnson, Sarah Williams, James Chen)
- **Recent Opponents**: 2 mock players (Tyler Brown, Alex Rivera)
- **Match History**: 3 mock matches with predetermined stats

### Not Yet Implemented
- Real-time location-based player discovery
- Actual match history from database
- Loading states for async operations
- Error handling for network failures
- Empty states for no matches or no nearby players

---

## ✅ Success Criteria

All tests should pass with:
- ✅ No crashes
- ✅ No UI glitches or overlaps
- ✅ Smooth navigation between screens
- ✅ Proper data display in all views
- ✅ Responsive tap gestures
- ✅ Correct modal presentations and dismissals

---

## 📝 Notes for Testers

- If a test fails, note the specific behavior and steps to reproduce
- Take screenshots of any UI issues
- Test on multiple device sizes if possible (iPhone SE, iPhone 15, iPad)
- Test in both light and dark mode
- Check accessibility features (VoiceOver, Dynamic Type)

---

*Happy Testing! 🏀*

