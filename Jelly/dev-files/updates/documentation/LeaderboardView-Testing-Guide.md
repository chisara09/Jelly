# LeaderboardView Updates - Testing Guide

## 🧪 Comprehensive Testing Guide

This guide provides step-by-step instructions for testing all LeaderboardView updates to ensure proper functionality and user experience.

---

## 📋 Pre-Testing Setup

### Requirements
- Xcode with iOS 17.0+ simulator
- Jelly app installed and running
- User account created and logged in
- Mock leaderboard data generated (happens automatically on first load)

### Test Account Setup
1. Launch the app
2. Sign up with a test account
3. Complete profile setup
4. Navigate to Leaderboard tab

---

## ✅ Test Cases

### Test Suite 1: Default State & Initial Load

#### TC1.1: Default Scope is Global
**Priority**: High  
**Requirement**: Global leaderboard by default

**Steps:**
1. Open the app and log in
2. Navigate to Leaderboard tab
3. Observe the scope picker (top segmented control)

**Expected Result:**
- ✅ "Global" option is selected by default
- ✅ Leaderboard displays all players
- ✅ Multiple players visible in list
- ✅ No empty state message

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.2: Default Metric is Rating
**Priority**: High  
**Requirement**: Rating sort by default

**Steps:**
1. Open LeaderboardView (fresh load)
2. Observe the metric picker (second segmented control)

**Expected Result:**
- ✅ "Rating" option is selected by default
- ✅ Players sorted by rating (highest first)
- ✅ Rating values descending order
- ✅ Top player has highest rating

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.3: Dual Picker Layout
**Priority**: High  
**Requirement**: Two pickers stacked vertically

**Steps:**
1. Open LeaderboardView
2. Examine the top section of the view

**Expected Result:**
- ✅ Two segmented pickers visible
- ✅ Scope picker (Global/Local) on top
- ✅ Metric picker (Rating/Wins/Streak) below it
- ✅ Both pickers full width
- ✅ Clear visual separation
- ✅ Proper padding and spacing

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 2: Global Scope Functionality

#### TC2.1: Global + Rating Sort
**Priority**: High  
**Requirement**: Global leaderboard sorted by rating

**Steps:**
1. Ensure Global scope selected
2. Select Rating metric
3. Observe player list

**Expected Result:**
- ✅ All players displayed
- ✅ Sorted by rating (descending)
- ✅ Highest rated player at #1
- ✅ Rating values decrease down the list

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.2: Global + Wins Sort
**Priority**: High  
**Requirement**: Global leaderboard sorted by wins

**Steps:**
1. Ensure Global scope selected
2. Tap "Wins" in metric picker
3. Observe player list

**Expected Result:**
- ✅ List updates immediately
- ✅ Sorted by wins (descending)
- ✅ Player with most wins at #1
- ✅ Win counts decrease down the list
- ✅ Global scope remains selected

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.3: Global + Streak Sort
**Priority**: High  
**Requirement**: Global leaderboard sorted by streak

**Steps:**
1. Ensure Global scope selected
2. Tap "Streak" in metric picker
3. Observe player list

**Expected Result:**
- ✅ List updates immediately
- ✅ Sorted by current streak (descending)
- ✅ Player with highest streak at #1
- ✅ Streak values decrease down the list
- ✅ Positive streaks rank above negative

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 3: Local Scope Functionality

#### TC3.1: Switch to Local Scope
**Priority**: High  
**Requirement**: Local toggle filters by proximity

**Steps:**
1. Start with Global scope selected
2. Note the number of players displayed
3. Tap "Local" in scope picker
4. Observe changes

**Expected Result:**
- ✅ List updates immediately
- ✅ Fewer or equal players than global
- ✅ Only nearby players shown (within 25 miles)
- ✅ Metric selection preserved
- ✅ Smooth transition

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.2: Local + Rating Sort
**Priority**: High  
**Requirement**: Local players sorted by rating

**Steps:**
1. Select Local scope
2. Select Rating metric
3. Observe player list

**Expected Result:**
- ✅ Only local players displayed
- ✅ Sorted by rating (descending)
- ✅ Highest rated local player at #1
- ✅ All players within 25-mile radius

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.3: Local + Wins Sort
**Priority**: High  
**Requirement**: Local players sorted by wins

**Steps:**
1. Select Local scope
2. Select Wins metric
3. Observe player list

**Expected Result:**
- ✅ Only local players displayed
- ✅ Sorted by wins (descending)
- ✅ Local player with most wins at #1
- ✅ Win counts decrease down the list

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.4: Local + Streak Sort
**Priority**: High  
**Requirement**: Local players sorted by streak

**Steps:**
1. Select Local scope
2. Select Streak metric
3. Observe player list

**Expected Result:**
- ✅ Only local players displayed
- ✅ Sorted by streak (descending)
- ✅ Local player with best streak at #1
- ✅ All players nearby

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.5: Local Empty State
**Priority**: Medium  
**Requirement**: Handle no local players gracefully

**Steps:**
1. Modify mock data or user location to ensure no local players
2. Select Local scope
3. Observe result

**Expected Result:**
- ✅ Empty state displayed
- ✅ "No leaderboard data" message shown
- ✅ Helpful subtext visible
- ✅ No crash or error
- ✅ Can switch back to Global

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 4: Scope Switching

#### TC4.1: Global → Local → Global
**Priority**: High  
**Requirement**: Smooth switching between scopes

**Steps:**
1. Start with Global scope
2. Tap Local
3. Observe changes
4. Tap Global again
5. Observe changes

**Expected Result:**
- ✅ Each tap updates list immediately
- ✅ No lag or stuttering
- ✅ Metric selection preserved throughout
- ✅ Returns to original global list
- ✅ Smooth animations

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.2: Scope Change Preserves Metric
**Priority**: High  
**Requirement**: Metric selection stays when scope changes

**Steps:**
1. Select Global scope
2. Select Wins metric
3. Switch to Local scope
4. Observe metric picker

**Expected Result:**
- ✅ "Wins" still selected after scope change
- ✅ Local list sorted by wins
- ✅ Combined filter works correctly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.3: Multiple Rapid Scope Changes
**Priority**: Medium  
**Requirement**: Handle rapid toggling

**Steps:**
1. Rapidly tap between Global and Local 10 times
2. Observe behavior

**Expected Result:**
- ✅ No crashes
- ✅ No lag buildup
- ✅ Final state reflects last selection
- ✅ List updates correctly
- ✅ No duplicate entries

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 5: Combined Filtering

#### TC5.1: All Scope + Metric Combinations
**Priority**: High  
**Requirement**: All 6 combinations work

**Test Matrix:**
| Scope | Metric | Expected Result |
|-------|--------|----------------|
| Global | Rating | All players by rating |
| Global | Wins | All players by wins |
| Global | Streak | All players by streak |
| Local | Rating | Local players by rating |
| Local | Wins | Local players by wins |
| Local | Streak | Local players by streak |

**Steps:**
1. Test each combination above
2. Verify correct filtering and sorting

**Expected Result:**
- ✅ All 6 combinations work correctly
- ✅ Scope filters the dataset
- ✅ Metric sorts the filtered data
- ✅ Results are logical and consistent

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 6: Player Profile Navigation

#### TC6.1: Tap Player from Global List
**Priority**: High  
**Requirement**: Navigate to player profile

**Steps:**
1. Select Global scope
2. Tap on any player in the list
3. Observe navigation

**Expected Result:**
- ✅ Player profile view opens
- ✅ Correct player's information shown
- ✅ Can navigate back to leaderboard
- ✅ Scope/metric selection preserved on return

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.2: Tap Player from Local List
**Priority**: High  
**Requirement**: Navigate to player profile

**Steps:**
1. Select Local scope
2. Tap on any local player
3. Observe navigation

**Expected Result:**
- ✅ Player profile view opens
- ✅ Correct player's information shown
- ✅ Can navigate back to leaderboard
- ✅ Local scope still selected on return

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 7: Refresh Functionality

#### TC7.1: Refresh Global Leaderboard
**Priority**: Medium  
**Requirement**: Refresh updates data

**Steps:**
1. View global leaderboard
2. Tap refresh button (circular arrow)
3. Observe loading state and update

**Expected Result:**
- ✅ Progress indicator shows while loading
- ✅ Data regenerates
- ✅ List updates with new data
- ✅ Scope and metric preserved
- ✅ Smooth transition

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.2: Refresh Local Leaderboard
**Priority**: Medium  
**Requirement**: Refresh updates local data

**Steps:**
1. View local leaderboard
2. Tap refresh button
3. Observe loading state and update

**Expected Result:**
- ✅ Progress indicator shows
- ✅ Data regenerates
- ✅ Local filtering reapplied
- ✅ List updates correctly
- ✅ Still shows only local players

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 8: Visual & Layout Testing

#### TC8.1: Portrait Orientation
**Priority**: High  
**Requirement**: Proper layout in portrait mode

**Steps:**
1. Hold device in portrait
2. Open LeaderboardView
3. Test both scopes

**Expected Result:**
- ✅ Both pickers visible and usable
- ✅ Player list scrolls smoothly
- ✅ All text readable
- ✅ No clipping or overflow
- ✅ Proper spacing throughout

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.2: Landscape Orientation (iPad)
**Priority**: Low  
**Requirement**: Proper layout in landscape mode

**Steps:**
1. Rotate device to landscape
2. View LeaderboardView
3. Test scope switching

**Expected Result:**
- ✅ Layout adapts appropriately
- ✅ Pickers remain accessible
- ✅ List items properly sized
- ✅ No overlapping elements

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.3: Different Screen Sizes
**Priority**: Medium  
**Requirement**: Works on all iPhone sizes

**Test Devices:**
- iPhone SE (small)
- iPhone 14 (medium)
- iPhone 14 Pro Max (large)

**Expected Result:**
- ✅ Pickers adapt to width
- ✅ List items properly sized
- ✅ Text remains readable
- ✅ Touch targets adequate
- ✅ No content cutoff

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.4: Dark Mode
**Priority**: Medium  
**Requirement**: Proper appearance in dark mode

**Steps:**
1. Enable dark mode in Settings
2. Open LeaderboardView
3. Test both scopes and all metrics

**Expected Result:**
- ✅ Proper contrast throughout
- ✅ Segmented pickers readable
- ✅ Player rows properly styled
- ✅ Rank colors still distinguishable
- ✅ No white backgrounds bleeding

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 9: Data Accuracy

#### TC9.1: Global Count
**Priority**: High  
**Requirement**: Global shows all players

**Steps:**
1. Select Global scope
2. Scroll to bottom of list
3. Count total players

**Expected Result:**
- ✅ Shows all 30 mock players
- ✅ No duplicates
- ✅ No missing entries
- ✅ All players accounted for

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.2: Local Count
**Priority**: High  
**Requirement**: Local shows subset

**Steps:**
1. Select Local scope
2. Count players shown
3. Compare to global count

**Expected Result:**
- ✅ Local count ≤ Global count
- ✅ All local players are nearby
- ✅ No distant players included
- ✅ Consistent with 25-mile radius

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.3: Sort Order Accuracy
**Priority**: High  
**Requirement**: Sorting is correct

**Steps:**
1. For each metric (Rating, Wins, Streak):
2. Check first 5 players
3. Verify values descend

**Expected Result:**
- ✅ Rating: Higher → Lower
- ✅ Wins: More → Fewer
- ✅ Streak: Higher → Lower
- ✅ No out-of-order entries

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.4: Rank Numbers
**Priority**: Medium  
**Requirement**: Ranks numbered correctly

**Steps:**
1. View leaderboard (any scope/metric)
2. Check rank numbers from top to bottom

**Expected Result:**
- ✅ Starts at #1
- ✅ Increments by 1 (#1, #2, #3...)
- ✅ No skipped numbers
- ✅ No duplicate ranks
- ✅ Top 3 ranks in orange color

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 10: Edge Cases & Stress Testing

#### TC10.1: Scroll Performance
**Priority**: Medium  
**Requirement**: Smooth scrolling

**Steps:**
1. View global leaderboard (30 players)
2. Rapidly scroll up and down
3. Observe performance

**Expected Result:**
- ✅ Smooth scrolling
- ✅ No stuttering
- ✅ No lag
- ✅ All rows render correctly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.2: Long Player Names
**Priority**: Low  
**Requirement**: Handle long text

**Steps:**
1. View leaderboard
2. Find player with longest name
3. Observe display

**Expected Result:**
- ✅ Name doesn't overflow
- ✅ Truncates with ... if needed
- ✅ Doesn't break layout
- ✅ Other columns unaffected

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.3: Long Court Names
**Priority**: Low  
**Requirement**: Handle long text

**Steps:**
1. View leaderboard
2. Find player with longest court name
3. Observe display

**Expected Result:**
- ✅ Court name doesn't overflow
- ✅ Truncates appropriately
- ✅ Layout remains intact
- ✅ Readable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.4: Rapid Metric Switching
**Priority**: Medium  
**Requirement**: Handle rapid interaction

**Steps:**
1. Rapidly tap Rating, Wins, Streak repeatedly
2. Do this 20 times quickly
3. Observe behavior

**Expected Result:**
- ✅ No crashes
- ✅ Updates keep pace
- ✅ Final state reflects last tap
- ✅ No frozen UI

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.5: Memory Performance
**Priority**: Medium  
**Requirement**: No memory leaks

**Steps:**
1. Open LeaderboardView
2. Switch scopes 50 times
3. Switch metrics 50 times
4. Navigate to/from profiles 20 times
5. Check memory usage

**Expected Result:**
- ✅ No significant memory increase
- ✅ Memory stabilizes
- ✅ No crash from memory pressure
- ✅ App remains responsive

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 11: Error Handling

#### TC11.1: No Snapshot Data
**Priority**: High  
**Requirement**: Handle missing data

**Steps:**
1. Clear cached snapshot data
2. Launch app without regenerating
3. View LeaderboardView

**Expected Result:**
- ✅ Empty state shown OR
- ✅ Auto-generates mock data
- ✅ No crash
- ✅ Helpful message if empty

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC11.2: Missing Coordinates
**Priority**: Medium  
**Requirement**: Handle entries without location

**Steps:**
1. Add entry with nil coordinates to snapshot
2. Select Local scope
3. Observe behavior

**Expected Result:**
- ✅ Entry excluded from local view
- ✅ No crash
- ✅ No error message
- ✅ Other local players show correctly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 12: Accessibility

#### TC12.1: VoiceOver Support
**Priority**: Medium  
**Requirement**: Screen reader accessible

**Steps:**
1. Enable VoiceOver
2. Navigate through LeaderboardView
3. Test scope and metric pickers

**Expected Result:**
- ✅ Pickers announced correctly
- ✅ Player names readable
- ✅ Stats values readable
- ✅ Ranks announced
- ✅ Clear selection feedback

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC12.2: Dynamic Type
**Priority**: Low  
**Requirement**: Respects text size settings

**Steps:**
1. Increase text size in Settings
2. View LeaderboardView
3. Check all text elements

**Expected Result:**
- ✅ Text scales appropriately
- ✅ Layout adapts
- ✅ No text clipping
- ✅ Still readable and usable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

## 📊 Test Summary Template

### Test Execution Summary

**Test Date:** _____________  
**Tested By:** _____________  
**Device/Simulator:** _____________  
**iOS Version:** _____________

| Test Suite | Total Tests | Passed | Failed | Skipped |
|-----------|-------------|--------|--------|---------|
| Default State & Initial Load | 3 | | | |
| Global Scope Functionality | 3 | | | |
| Local Scope Functionality | 5 | | | |
| Scope Switching | 3 | | | |
| Combined Filtering | 1 | | | |
| Player Profile Navigation | 2 | | | |
| Refresh Functionality | 2 | | | |
| Visual & Layout | 4 | | | |
| Data Accuracy | 4 | | | |
| Edge Cases & Stress | 5 | | | |
| Error Handling | 2 | | | |
| Accessibility | 2 | | | |
| **TOTAL** | **36** | | | |

### Pass Rate
- **Target:** 95%+
- **Actual:** _____%

---

## 🐛 Bug Report Template

**Bug ID:** _____________  
**Test Case:** _____________  
**Priority:** ☐ Critical ☐ High ☐ Medium ☐ Low

**Description:**



**Steps to Reproduce:**
1. 
2. 
3. 

**Expected Behavior:**


**Actual Behavior:**


**Screenshots/Videos:**


**Environment:**
- Device:
- iOS Version:
- App Version:

**Status:** ☐ Open ☐ In Progress ☐ Fixed ☐ Closed

---

## ✅ Sign-Off

### Testing Complete Checklist

- [ ] All test cases executed
- [ ] Test summary filled out
- [ ] Bugs logged (if any)
- [ ] Screenshots taken for documentation
- [ ] Pass rate meets threshold (95%+)
- [ ] Critical bugs resolved
- [ ] Regression testing completed
- [ ] Global scope tested thoroughly
- [ ] Local scope tested thoroughly
- [ ] All 6 scope+metric combinations verified
- [ ] Performance acceptable
- [ ] Dark mode tested
- [ ] Different devices tested

**Tester Signature:** _____________  
**Date:** _____________

**Approval:** _____________  
**Date:** _____________

---

## 🚀 Ready for Production

Once all tests pass and bugs are resolved:

- [ ] Update implementation status to "Complete"
- [ ] Update version documentation
- [ ] Prepare release notes
- [ ] Schedule deployment
- [ ] Update user documentation

---

## 📝 Testing Notes

### Key Focus Areas

1. **Scope Toggle** - Most critical new feature
2. **Local Filtering** - Core functionality to verify
3. **Combined Filters** - Scope + Metric interaction
4. **Data Accuracy** - Ensure correct filtering and sorting
5. **Performance** - No lag when switching

### Common Issues to Watch For

1. **Empty Local List** - Normal if user far from mock data
2. **Scope Not Preserved** - Should maintain selection
3. **Metric Changes** - Should work with both scopes
4. **Sort Order** - Must be correct for all metrics
5. **Navigation** - Profile nav should preserve state

---

**Document Version:** 1.0  
**Last Updated:** October 31, 2025  
**Status:** Ready for Testing

