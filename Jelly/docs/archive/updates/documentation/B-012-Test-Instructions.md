# B-012: End-to-End Test Instructions

## Overview
B-012 is the final build step that verifies the complete user flow:
**Two users → challenge → chat → record score → confirm → leaderboard update**

## What the Test Validates

### 1. User Creation ✅
- Creates two test users (User 1 and User 2)
- Simulates authentication flow

### 2. Challenge Flow ✅
- User 1 sends a challenge to User 2
- Challenge includes: court, date, time, rules
- Challenge status is properly tracked

### 3. Chat Exchange ✅
- Both users can send messages in the game chat
- Messages are properly associated with the game
- Message history is correctly maintained

### 4. Score Recording ✅
- Game is played and scores are entered
- Winner/loser are correctly determined
- Scores are stored with the game

### 5. Score Confirmation ✅
- Opponent confirms the recorded score
- Game status updates to "confirmed"
- Fair play verification mechanism works

### 6. Leaderboard Update ✅
- Leaderboard refreshes with new results
- Player ratings and stats update correctly
- Displays top players by various metrics

## How to Run the Test

### Option 1: Through the App UI (Recommended)

1. Open the Jelly app
2. Sign in or create an account
3. Go to your **Profile** tab
4. Tap the gear icon to open **Settings**
5. Scroll to the bottom and find the **"About"** section
6. Tap on **"Version 1.0.0"** three times (quickly)
7. A new "Debug - B-012 Test" section will appear
8. Tap **"Run End-to-End Test"** to execute the test
9. Check the console output for detailed results
10. An alert will appear when the test completes

### Option 2: Direct Code Execution

You can also call the test directly from code:

```swift
import SwiftUI

// In your app initialization or view
EndToEndTest.runTest()
```

## Test Output

The test will print detailed information to the console:

```
🏀 Starting B-012 End-to-End Test...

✅ User 1 created: Test User 1
✅ User 2 created: Test User 2

📤 Step 1: User 1 sends challenge to User 2...
✅ Challenge created: Game ID [UUID]
   Court: Central Park Courts
   Date: [tomorrow]
   Status: pending

✉️ Step 2: Challenge accepted...
✅ Challenge accepted. Status: accepted

💬 Step 3: Chat exchange...
✅ User 1: 'Hey! Looking forward to our game tomorrow. See you at the court!'
✅ User 2: 'Sounds good! See you there at 6 PM. 🏀'
✅ Total messages in game chat: 2

🏆 Step 4: Recording final score...
✅ Score recorded: 21 - 18
   Winner: Test User 1
   Status: completed
   Is Confirmed: false

✓ Step 5: User 2 confirms the score...
✅ Score confirmed!
   Is Confirmed: true
   Status: completed

📊 Step 6: Checking leaderboard update...
✅ Leaderboard updated with 10 top players

📈 Top 3 Players (by Rating):
   1. Marcus Johnson - Rating: 1450, Wins: 32, Losses: 8
   2. Jamal Smith - Rating: 1420, Wins: 28, Losses: 5
   3. Test User 1 - Rating: 1225, Wins: 13, Losses: 4
```

## Alternative Test: Dispute Flow

The test suite also includes a dispute scenario:

1. Follow steps 1-6 above
2. When prompted, tap **"Run Dispute Test"**
3. This validates the scenario where scores don't match
4. Game should be marked as "disputed" with "No result"

## What Success Looks Like

When the test completes successfully, you should see:

- ✅ All 6 steps executed without errors
- ✅ Game created and tracked properly
- ✅ Chat messages stored correctly
- ✅ Score recorded and confirmed
- ✅ Leaderboard updated
- ✅ No "Couldn't..." error messages

## Troubleshooting

### Test doesn't appear in Settings
- Make sure you tap on "Version 1.0.0" exactly 3 times rapidly
- The debug section should appear at the bottom of the settings list

### Error messages appear
- Check console output for specific error details
- Verify that all managers (GameManager, ChatManager, LeaderboardManager) are properly instantiated
- Ensure app is running in a simulator or real device

### Test runs but no output
- Open Xcode console window to see print statements
- Look for messages starting with "🏀" emoji
- Check that the test alert appears on screen

## Implementation Files

- `Jelly/EndToEndTest.swift` - Main test implementation
- `Jelly/Views/ProfileView.swift` - Settings integration
- `Jelly/Models/GameManager.swift` - Game logic
- `Jelly/Models/ChatManager.swift` - Chat functionality
- `Jelly/Managers/LeaderboardManager.swift` - Leaderboard updates

## Notes

- This test runs in the app environment, not as a unit test
- All data is simulated/mock data for testing purposes
- The test does not persist beyond the current session
- Network calls are simulated with the mock implementations
- Error handling is tested with the 5-10% random failure simulation

---

**Build Step B-012: Complete ✅**

This test ensures that all the features built in B-001 through B-011 work together seamlessly.

