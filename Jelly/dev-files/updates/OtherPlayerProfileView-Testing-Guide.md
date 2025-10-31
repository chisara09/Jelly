# OtherPlayerProfileView Testing Guide

## 📋 Overview

This comprehensive testing guide covers all aspects of the OtherPlayerProfileView implementation. Follow these test cases to ensure complete functionality and proper user experience.

**Testing Date:** October 31, 2025  
**Version:** 1.0  
**Total Test Cases:** 35

---

## 🎯 Testing Categories

1. [Profile Display Tests](#profile-display-tests) (8 tests)
2. [Action Button Tests](#action-button-tests) (6 tests)
3. [Stats Display Tests](#stats-display-tests) (6 tests)
4. [Match History Tests](#match-history-tests) (5 tests)
5. [Safety Feature Tests](#safety-feature-tests) (4 tests)
6. [Navigation Tests](#navigation-tests) (3 tests)
7. [UI/UX Tests](#uiux-tests) (3 tests)

---

## Profile Display Tests

### Test 1: Profile Header Display
**Objective:** Verify profile header shows all player information

**Steps:**
1. Navigate to FindPlayersView
2. Select any player from the list
3. Verify OtherPlayerProfileView opens

**Expected Results:**
- ✅ Circular avatar with gradient (orange to red) is displayed
- ✅ Player initials are shown in white (2 letters for 2-word names, first 2 letters for 1-word names)
- ✅ Player full name is displayed below avatar
- ✅ Home court is shown with pin icon
- ✅ Distance is displayed in miles with location icon

**Pass/Fail:** ☐

---

### Test 2: Player Avatar Rendering
**Objective:** Verify avatar renders correctly with initials

**Steps:**
1. Open OtherPlayerProfileView for player "Marcus Johnson"
2. Observe avatar circle

**Expected Results:**
- ✅ Avatar is circular, 100x100pt
- ✅ Shows "MJ" in white, size 40, bold
- ✅ Gradient background (orange → red, top-left to bottom-right)

**Test with different names:**
- Two-word name: "Marcus Johnson" → "MJ"
- One-word name: "Marcus" → "MA"
- Three-word name: "John Paul Smith" → "JP"

**Pass/Fail:** ☐

---

### Test 3: Distance Display
**Objective:** Verify distance is formatted correctly

**Steps:**
1. View player profile with distance = 2.3 miles
2. Check distance text format

**Expected Results:**
- ✅ Displays "2.3 mi away"
- ✅ Location icon is orange
- ✅ Text is secondary color
- ✅ One decimal place precision

**Pass/Fail:** ☐

---

### Test 4: Home Court Display
**Objective:** Verify home court information is shown

**Steps:**
1. View player profile
2. Check home court section

**Expected Results:**
- ✅ Home court name is displayed
- ✅ Pin icon (mappin.circle.fill) is orange
- ✅ Text is secondary color
- ✅ Proper spacing from other elements

**Pass/Fail:** ☐

---

### Test 5: Long Name Handling
**Objective:** Verify long player names don't break layout

**Steps:**
1. View profile for player with long name (e.g., "Christopher Alexander Johnson")
2. Observe name display

**Expected Results:**
- ✅ Name wraps to multiple lines if needed
- ✅ Maintains centered alignment
- ✅ Doesn't overflow container
- ✅ Remains readable

**Pass/Fail:** ☐

---

### Test 6: Long Court Name Handling
**Objective:** Verify long court names display properly

**Steps:**
1. View profile with long court name (e.g., "West Side Community Basketball Courts and Recreation Center")
2. Check display

**Expected Results:**
- ✅ Court name wraps to multiple lines
- ✅ Maintains left alignment with icon
- ✅ Doesn't overflow
- ✅ Icon stays on first line

**Pass/Fail:** ☐

---

### Test 7: Profile in Dark Mode
**Objective:** Verify proper dark mode rendering

**Steps:**
1. Enable dark mode on device
2. Open OtherPlayerProfileView

**Expected Results:**
- ✅ Background colors adapt to dark theme
- ✅ Text remains readable (proper contrast)
- ✅ Gradient maintains visibility
- ✅ Icons remain visible
- ✅ Card backgrounds use system dark colors

**Pass/Fail:** ☐

---

### Test 8: Navigation Title
**Objective:** Verify navigation title displays player name

**Steps:**
1. Open OtherPlayerProfileView for "Marcus Johnson"
2. Check navigation bar

**Expected Results:**
- ✅ Navigation title shows "Marcus Johnson"
- ✅ Title display mode is inline
- ✅ Title truncates gracefully if too long
- ✅ Back button functions correctly

**Pass/Fail:** ☐

---

## Action Button Tests

### Test 9: Challenge Button Functionality
**Objective:** Verify challenge button opens NewChallengeView

**Steps:**
1. Open OtherPlayerProfileView
2. Tap "Challenge" button

**Expected Results:**
- ✅ NewChallengeView sheet presents
- ✅ Player is pre-selected in NewChallengeView
- ✅ Can dismiss sheet and return
- ✅ Button has trophy icon
- ✅ Button has orange→red gradient

**Pass/Fail:** ☐

---

### Test 10: Message Button Functionality
**Objective:** Verify message button opens ChatView

**Steps:**
1. Open OtherPlayerProfileView
2. Tap "Message" button

**Expected Results:**
- ✅ ChatView sheet presents
- ✅ Chat is with correct player
- ✅ Can send messages
- ✅ Can dismiss sheet and return
- ✅ Button has message icon
- ✅ Button has gray background

**Pass/Fail:** ☐

---

### Test 11: Button Layout
**Objective:** Verify buttons are arranged correctly

**Steps:**
1. View OtherPlayerProfileView
2. Observe action buttons

**Expected Results:**
- ✅ Two buttons side-by-side (equal width)
- ✅ 12pt spacing between buttons
- ✅ Both buttons same height (52pt)
- ✅ Buttons fill horizontal space
- ✅ Proper padding from edges

**Pass/Fail:** ☐

---

### Test 12: Blocked User Button State
**Objective:** Verify buttons are disabled for blocked users

**Steps:**
1. Open OtherPlayerProfileView
2. Block the user via menu
3. Return to profile (or reload)

**Expected Results:**
- ✅ Challenge button is disabled (grayed out)
- ✅ Message button is disabled (grayed out)
- ✅ Tapping buttons does nothing
- ✅ Visual indication of disabled state

**Pass/Fail:** ☐

---

### Test 13: Button Tap Feedback
**Objective:** Verify buttons provide visual feedback

**Steps:**
1. Press and hold Challenge button
2. Press and hold Message button

**Expected Results:**
- ✅ Button slightly darkens on press
- ✅ Button returns to normal on release
- ✅ Animation is smooth
- ✅ Feedback is immediate

**Pass/Fail:** ☐

---

### Test 14: Button Icons
**Objective:** Verify correct icons are displayed

**Steps:**
1. View action buttons
2. Check icons

**Expected Results:**
- ✅ Challenge button shows trophy.fill icon
- ✅ Message button shows message.fill icon
- ✅ Icons are properly sized
- ✅ Icons align with text

**Pass/Fail:** ☐

---

## Stats Display Tests

### Test 15: Stats Grid Display
**Objective:** Verify 2x2 stats grid renders correctly

**Steps:**
1. Open OtherPlayerProfileView
2. Scroll to stats section

**Expected Results:**
- ✅ Four stat cards displayed in 2x2 grid
- ✅ Cards: Record, Win Rate, Streak, Rating
- ✅ Equal spacing (16pt) between cards
- ✅ Cards fill available width
- ✅ Cards have gray background
- ✅ 12pt corner radius

**Pass/Fail:** ☐

---

### Test 16: Stat Card Content
**Objective:** Verify each stat card displays correct information

**Steps:**
1. View stats grid
2. Check each card

**Expected Results:**

**Record Card:**
- ✅ Blue chart icon
- ✅ Record format: "18 - 7"
- ✅ "Record" label

**Win Rate Card:**
- ✅ Green star icon
- ✅ Percentage format: "72%"
- ✅ "Win Rate" label

**Streak Card:**
- ✅ Orange flame icon
- ✅ Shows "🔥 3 wins" or "❄️ 2 losses"
- ✅ "Streak" label

**Rating Card:**
- ✅ Purple crown icon
- ✅ Whole number: "1325"
- ✅ "Rating" label

**Pass/Fail:** ☐

---

### Test 17: Detailed Stats List
**Objective:** Verify detailed stats section displays correctly

**Steps:**
1. Scroll below stats grid
2. View detailed stats list

**Expected Results:**
- ✅ Four rows: Wins, Losses, Best Streak, Total Games
- ✅ Each row has icon, label, and value
- ✅ Icons are color-coded (green, red, orange, blue)
- ✅ Values are right-aligned
- ✅ Proper spacing between rows

**Pass/Fail:** ☐

---

### Test 18: Stats Section Header
**Objective:** Verify "Stats" section header

**Steps:**
1. View stats section
2. Check header

**Expected Results:**
- ✅ "Stats" text in headline font
- ✅ Left-aligned
- ✅ 16pt top padding
- ✅ Proper spacing to grid

**Pass/Fail:** ☐

---

### Test 19: Stats Color Coding
**Objective:** Verify consistent color usage

**Steps:**
1. Review all stat displays
2. Check color consistency

**Expected Results:**
- ✅ Wins: Green checkmark icon
- ✅ Losses: Red X icon
- ✅ Streak: Orange flame icon
- ✅ Rating: Purple crown icon
- ✅ Record: Blue chart icon
- ✅ Win Rate: Green star icon
- ✅ Total Games: Blue basketball icon
- ✅ Best Streak: Orange trophy icon

**Pass/Fail:** ☐

---

### Test 20: Stats Formatting
**Objective:** Verify numerical formatting is correct

**Steps:**
1. View all stats
2. Check number formats

**Expected Results:**
- ✅ Wins/Losses: Whole numbers
- ✅ Record: "W - L" format
- ✅ Win Rate: Percentage with % symbol, no decimals
- ✅ Rating: Whole number (no decimals)
- ✅ Streak: Number with win/loss text
- ✅ Proper spacing in all formats

**Pass/Fail:** ☐

---

## Match History Tests

### Test 21: Match History Section Display
**Objective:** Verify match history section renders

**Steps:**
1. Scroll to match history section
2. Check header and content

**Expected Results:**
- ✅ "Match History" header in headline font
- ✅ Game count shows "X games" or "X game" (singular)
- ✅ Count is right-aligned in header
- ✅ Section has proper dividers

**Pass/Fail:** ☐

---

### Test 22: Match History with Games
**Objective:** Verify mutual games display correctly

**Steps:**
1. View profile with mutual games (mock data)
2. Check game rows

**Expected Results:**
- ✅ Each game shows in rounded card
- ✅ "vs [Player Name]" displayed
- ✅ Court name shown
- ✅ Date/time formatted properly
- ✅ Result badge (Win/Loss/Disputed) displayed
- ✅ Score shown (e.g., "21 - 18")
- ✅ Color-coded results (green/red/orange)

**Pass/Fail:** ☐

---

### Test 23: Empty Match History
**Objective:** Verify empty state displays when no mutual games

**Steps:**
1. View profile with no mutual games
2. Check empty state

**Expected Results:**
- ✅ Basketball icon displayed (40pt, gray opacity)
- ✅ "No mutual games yet" text shown
- ✅ Encouraging subtext: "Challenge [Name] to start your rivalry!"
- ✅ Centered layout
- ✅ Proper vertical padding (40pt)

**Pass/Fail:** ☐

---

### Test 24: Match Result Colors
**Objective:** Verify correct color coding for results

**Steps:**
1. View match history with various results
2. Check colors

**Expected Results:**
- ✅ Win: Green text
- ✅ Loss: Red text
- ✅ Disputed: Orange text
- ✅ Colors match app theme
- ✅ Sufficient contrast for readability

**Pass/Fail:** ☐

---

### Test 25: Match History Scrolling
**Objective:** Verify scrolling works with multiple games

**Steps:**
1. View profile with 3+ mutual games
2. Try scrolling

**Expected Results:**
- ✅ Entire view scrolls smoothly
- ✅ No layout issues when scrolling
- ✅ All games are accessible
- ✅ Header remains in place (inline navigation)

**Pass/Fail:** ☐

---

## Safety Feature Tests

### Test 26: Block User Flow
**Objective:** Verify blocking functionality works

**Steps:**
1. Open OtherPlayerProfileView
2. Tap menu (⋯) in navigation bar
3. Select "Block User"
4. Tap "Block" in alert

**Expected Results:**
- ✅ Alert presents with warning message
- ✅ Alert shows player name
- ✅ Cancel button dismisses alert
- ✅ Block button blocks user and dismisses view
- ✅ User is added to blocked list

**Pass/Fail:** ☐

---

### Test 27: Report User Flow
**Objective:** Verify reporting functionality works

**Steps:**
1. Open OtherPlayerProfileView
2. Tap menu (⋯) in navigation bar
3. Select "Report"
4. Choose a reason
5. Submit report

**Expected Results:**
- ✅ Report sheet presents
- ✅ All report reasons are listed
- ✅ Can select a reason (checkmark appears)
- ✅ Submit button becomes enabled
- ✅ Confirmation alert shows
- ✅ Sheet dismisses after confirmation

**Pass/Fail:** ☐

---

### Test 28: Menu Display
**Objective:** Verify toolbar menu appears correctly

**Steps:**
1. Open OtherPlayerProfileView
2. Tap menu icon (⋯)

**Expected Results:**
- ✅ Menu presents with two options
- ✅ "Block User" option with X icon (destructive/red)
- ✅ "Report" option with triangle icon
- ✅ Tapping outside dismisses menu
- ✅ Menu animates smoothly

**Pass/Fail:** ☐

---

### Test 29: Block Confirmation Message
**Objective:** Verify block alert shows correct information

**Steps:**
1. Initiate block user flow
2. Read alert message

**Expected Results:**
- ✅ Alert title is "Block User"
- ✅ Message includes player's name
- ✅ Message explains consequences: "You won't be able to communicate with them"
- ✅ Two buttons: Cancel and Block
- ✅ Block button is red (destructive)

**Pass/Fail:** ☐

---

## Navigation Tests

### Test 30: View Entry
**Objective:** Verify view can be reached from multiple entry points

**Steps:**
1. Navigate from FindPlayersView → Tap player
2. Navigate from LeaderboardView → Tap player
3. Navigate from GameHistoryView → Tap opponent name

**Expected Results:**
- ✅ View opens from all entry points
- ✅ Correct player data is passed
- ✅ Navigation stack is maintained
- ✅ Back button works from all entry points

**Pass/Fail:** ☐

---

### Test 31: View Dismissal
**Objective:** Verify all dismissal methods work

**Steps:**
1. Test back button
2. Test swipe from left edge
3. Test dismissal after blocking

**Expected Results:**
- ✅ Back button returns to previous view
- ✅ Swipe gesture works smoothly
- ✅ View auto-dismisses after successful block
- ✅ Navigation stack updates correctly

**Pass/Fail:** ☐

---

### Test 32: Sheet Presentations
**Objective:** Verify sheets present and dismiss correctly

**Steps:**
1. Open Challenge sheet, dismiss it
2. Open Message sheet, dismiss it
3. Open Report sheet, dismiss it

**Expected Results:**
- ✅ All sheets present with slide-up animation
- ✅ Can dismiss by swiping down
- ✅ Can dismiss via buttons
- ✅ Original view remains visible behind sheet
- ✅ Return to profile after dismissal

**Pass/Fail:** ☐

---

## UI/UX Tests

### Test 33: Layout on Different Devices
**Objective:** Verify layout works on all iPhone sizes

**Steps:**
1. Test on iPhone SE (small)
2. Test on iPhone 14 Pro (standard)
3. Test on iPhone 14 Pro Max (large)

**Expected Results:**
- ✅ Content fits on all screens
- ✅ No horizontal scrolling
- ✅ Text remains readable
- ✅ Buttons remain tappable
- ✅ Spacing scales appropriately

**Pass/Fail:** ☐

---

### Test 34: Dynamic Type Support
**Objective:** Verify layout adapts to text size changes

**Steps:**
1. Set device text size to smallest
2. Open OtherPlayerProfileView
3. Set device text size to largest
4. Reopen OtherPlayerProfileView

**Expected Results:**
- ✅ Text scales appropriately
- ✅ Layout adjusts to accommodate larger text
- ✅ No text truncation (or graceful truncation)
- ✅ Buttons remain tappable at all sizes
- ✅ Overall layout doesn't break

**Pass/Fail:** ☐

---

### Test 35: VoiceOver Accessibility
**Objective:** Verify screen is accessible with VoiceOver

**Steps:**
1. Enable VoiceOver
2. Navigate through OtherPlayerProfileView

**Expected Results:**
- ✅ All elements are announced
- ✅ Buttons have clear labels
- ✅ Stats are readable in logical order
- ✅ Navigation gestures work
- ✅ Sheets are accessible

**Pass/Fail:** ☐

---

## 🐛 Bug Report Template

If you find any issues during testing, please document them using this template:

### Bug Report

**Test Case:** [Number and name]  
**Date:** [Date found]  
**Tester:** [Your name]  

**Description:**
[Clear description of the issue]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happened]

**Screenshots:**
[Attach if applicable]

**Device Info:**
- Device: [e.g., iPhone 14 Pro]
- iOS Version: [e.g., 17.0]
- App Version: [e.g., 1.0]

**Severity:**
- ☐ Critical (blocks usage)
- ☐ Major (important feature broken)
- ☐ Minor (cosmetic or edge case)

**Priority:**
- ☐ High (fix immediately)
- ☐ Medium (fix in next update)
- ☐ Low (fix when convenient)

---

## 📊 Testing Summary

### Test Results

| Category | Total Tests | Passed | Failed | Pass Rate |
|----------|-------------|--------|--------|-----------|
| Profile Display | 8 | ☐ | ☐ | ☐ |
| Action Buttons | 6 | ☐ | ☐ | ☐ |
| Stats Display | 6 | ☐ | ☐ | ☐ |
| Match History | 5 | ☐ | ☐ | ☐ |
| Safety Features | 4 | ☐ | ☐ | ☐ |
| Navigation | 3 | ☐ | ☐ | ☐ |
| UI/UX | 3 | ☐ | ☐ | ☐ |
| **TOTAL** | **35** | **☐** | **☐** | **☐%** |

---

## ✅ Sign-Off Checklist

### Pre-Release Checklist

- [ ] All 35 test cases executed
- [ ] Pass rate ≥ 95% (max 1-2 minor failures)
- [ ] All critical bugs fixed
- [ ] All major bugs fixed
- [ ] Minor bugs documented for future fix
- [ ] Tested on multiple device sizes
- [ ] Tested in dark mode
- [ ] Tested with VoiceOver
- [ ] Tested with different text sizes
- [ ] Performance is acceptable
- [ ] Memory usage is normal
- [ ] No crashes observed
- [ ] Documentation is complete

### Stakeholder Sign-Off

**Developer:** _________________________ Date: _________

**QA Lead:** __________________________ Date: _________

**Product Owner:** _____________________ Date: _________

---

## 📝 Notes for Testers

### Testing Environment
- Use a physical device when possible
- Test in both light and dark mode
- Test with various player names (short, long, special chars)
- Test with and without mutual games
- Test block/unblock multiple times

### Common Issues to Watch For
- Layout breaking on small screens
- Text overflow or truncation
- Button tap targets too small
- Missing or incorrect icons
- Incorrect color usage
- Poor contrast in dark mode
- Slow animations or jank
- Memory leaks (check after multiple opens/closes)

### Performance Benchmarks
- View should load in < 1 second
- Scrolling should be smooth (60fps)
- Button taps should respond instantly
- Sheets should animate smoothly
- No memory leaks after 10+ opens

---

## 🎯 Testing Best Practices

1. **Test Systematically** - Follow test cases in order
2. **Document Everything** - Record pass/fail and notes
3. **Reproduce Bugs** - Verify issues occur consistently
4. **Test Edge Cases** - Long names, no data, many games
5. **Test All Paths** - Every button, every navigation route
6. **Test Accessibility** - Use VoiceOver, Dynamic Type
7. **Test Performance** - Check for lag, memory issues
8. **Regression Test** - Retest after bug fixes

---

**Document Version:** 1.0  
**Last Updated:** October 31, 2025  
**Status:** Ready for Testing  
**Total Test Cases:** 35

