# ChatView Updates - Testing Guide

## 🧪 Comprehensive Testing Guide

This guide provides step-by-step instructions for testing all ChatView updates to ensure proper functionality and user experience.

---

## 📋 Pre-Testing Setup

### Requirements
- Xcode with iOS 17.0+ simulator
- Jelly app installed and running
- User account created and logged in
- At least 2-3 active games with different opponents (for conversation testing)
- Some messages sent/received in those games

### Test Account Setup
1. Launch the app
2. Sign up with a test account
3. Create 2-3 games with different opponents
4. Send/receive messages in each game
5. Leave some messages unread

---

## ✅ Test Cases

### Test Suite 1: Conversations List View

#### TC1.1: Display All Conversations
**Priority**: High  
**Requirement**: Show all user conversations

**Steps:**
1. Open the app and log in
2. Tap the chat icon in navigation bar (any main view)
3. Observe the conversations list

**Expected Result:**
- ✅ Sheet opens with "Messages" title
- ✅ All conversations displayed
- ✅ Each conversation shows opponent name
- ✅ Each conversation shows last message preview
- ✅ Each conversation shows timestamp
- ✅ Conversations sorted by most recent activity
- ✅ "Done" button visible in top-right

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.2: Empty Conversations State
**Priority**: High  
**Requirement**: Handle no conversations gracefully

**Steps:**
1. Use a fresh test account with no games/messages
2. Navigate to any main view
3. Tap the chat icon

**Expected Result:**
- ✅ Empty state appears
- ✅ Message bubble icon displayed
- ✅ "No conversations yet" text shown
- ✅ Helpful subtext displayed
- ✅ Centered layout
- ✅ No error messages

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.3: Conversation Row Content
**Priority**: High  
**Requirement**: Each row shows complete information

**Steps:**
1. Open conversations list with active conversations
2. Examine the first conversation row carefully

**Expected Result:**
- ✅ Avatar circle with initials visible
- ✅ Opponent name displayed
- ✅ Last message preview (2 lines max)
- ✅ Timestamp (relative format like "2h", "1d")
- ✅ All text readable and not clipped
- ✅ Row has adequate touch target size

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.4: Conversation Sorting
**Priority**: High  
**Requirement**: Conversations sorted by recent activity

**Steps:**
1. Create multiple conversations
2. Send a message in an older conversation
3. Return to conversations list

**Expected Result:**
- ✅ Conversations in descending order by activity
- ✅ Most recent conversation at top
- ✅ Oldest conversation at bottom
- ✅ Unread conversations prioritized (if implemented)
- ✅ Sorting updates when new message arrives

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.5: Tapping Conversation Opens Chat
**Priority**: High  
**Requirement**: Navigate to individual chat

**Steps:**
1. Open conversations list
2. Tap on any conversation row

**Expected Result:**
- ✅ ChatView opens with messages
- ✅ Correct opponent shown in nav title
- ✅ Messages load properly
- ✅ Input box visible at bottom
- ✅ Can send messages
- ✅ Back button returns to conversations list

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 2: Navigation Bar Chat Icon

#### TC2.1: Icon Visible on HomeView
**Priority**: High  
**Requirement**: Chat icon in navigation bar

**Steps:**
1. Navigate to HomeView
2. Look at the navigation bar

**Expected Result:**
- ✅ Chat icon visible in top-right
- ✅ Icon is message.circle.fill symbol
- ✅ Orange brand color applied
- ✅ Icon sized appropriately
- ✅ Touch target adequate

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.2: Icon Visible on ProfileView
**Priority**: High  
**Requirement**: Chat icon in navigation bar

**Steps:**
1. Navigate to ProfileView
2. Look at the navigation bar

**Expected Result:**
- ✅ Chat icon visible in top-right
- ✅ Same icon styling as HomeView
- ✅ Tappable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.3: Icon Visible on LeaderboardView
**Priority**: High  
**Requirement**: Chat icon in navigation bar

**Steps:**
1. Navigate to LeaderboardView
2. Look at the navigation bar

**Expected Result:**
- ✅ Chat icon visible
- ✅ Consistent styling

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.4: Icon Visible on FindPlayersView
**Priority**: High  
**Requirement**: Chat icon in navigation bar

**Steps:**
1. Navigate to FindPlayersView
2. Look at the navigation bar

**Expected Result:**
- ✅ Chat icon visible
- ✅ Consistent styling

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.5: Tapping Icon Opens Conversations
**Priority**: High  
**Requirement**: Icon navigates to conversations list

**Steps:**
1. From any main view, tap the chat icon
2. Observe the result

**Expected Result:**
- ✅ Sheet slides up from bottom
- ✅ ConversationsListView appears
- ✅ Smooth animation
- ✅ Can dismiss with "Done" button
- ✅ Can dismiss with swipe-down

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 3: Unread Message Indicators

#### TC3.1: Unread Badge on Conversation Row
**Priority**: High  
**Requirement**: Show unread count per conversation

**Steps:**
1. Have opponent send you messages (simulate or use another account)
2. Don't open the conversation
3. View conversations list

**Expected Result:**
- ✅ Unread badge appears on conversation row
- ✅ Badge shows correct count (e.g., "3")
- ✅ Badge is orange/red color
- ✅ Badge positioned on right side
- ✅ Opponent name in bold
- ✅ Preview text darker/more prominent

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.2: Unread Badge on Navigation Icon
**Priority**: High  
**Requirement**: Show total unread count

**Steps:**
1. Have unread messages in multiple conversations
2. View any main screen
3. Look at chat icon in navigation bar

**Expected Result:**
- ✅ Badge overlay appears on chat icon
- ✅ Shows total unread count
- ✅ Red/orange background
- ✅ White text
- ✅ Positioned at top-right of icon
- ✅ Count accurate (sum of all unread)

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.3: Badge Updates When Message Read
**Priority**: High  
**Requirement**: Badge disappears when messages read

**Steps:**
1. Have unread messages in a conversation
2. Note the badge count on nav icon
3. Open the conversation
4. Return to conversations list

**Expected Result:**
- ✅ Badge removed from conversation row
- ✅ Opponent name no longer bold
- ✅ Preview text lighter
- ✅ Navigation icon badge count decreased
- ✅ Badge disappears if count reaches 0

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.4: High Unread Count Display
**Priority**: Medium  
**Requirement**: Handle large numbers gracefully

**Steps:**
1. Simulate 100+ unread messages
2. View conversations list and nav icon

**Expected Result:**
- ✅ Badge shows "99+" for 100+ messages
- ✅ Badge doesn't overflow or break layout
- ✅ Text remains readable
- ✅ Badge size adjusts appropriately

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.5: Multiple Unread Conversations
**Priority**: High  
**Requirement**: Track unread per conversation

**Steps:**
1. Have unread messages in 3 different conversations
2. Conversation A: 2 unread
3. Conversation B: 5 unread
4. Conversation C: 1 unread
5. View conversations list

**Expected Result:**
- ✅ Each conversation shows correct unread count
- ✅ All three have badges
- ✅ Navigation icon shows total (8)
- ✅ Counts independent per conversation
- ✅ Opening one doesn't affect others

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 4: Mark as Read Functionality

#### TC4.1: Opening Chat Marks as Read
**Priority**: High  
**Requirement**: Auto-mark read when chat opened

**Steps:**
1. Have unread messages in conversation
2. Note the unread badge
3. Open the conversation
4. Immediately close it
5. Return to conversations list

**Expected Result:**
- ✅ Badge disappears from conversation row
- ✅ Badge count updated on nav icon
- ✅ Happens instantly on open
- ✅ Persists after closing chat

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.2: Read Status Persists
**Priority**: High  
**Requirement**: Read status saved

**Steps:**
1. Mark conversation as read by opening it
2. Close the app completely
3. Reopen the app
4. View conversations list

**Expected Result:**
- ✅ Conversation still marked as read
- ✅ No unread badge appears
- ✅ Read status persisted correctly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.3: New Message After Read
**Priority**: High  
**Requirement**: New messages create unread state

**Steps:**
1. Open and read all messages in conversation
2. Have opponent send new message
3. Return to conversations list

**Expected Result:**
- ✅ Unread badge reappears
- ✅ Badge shows "1"
- ✅ Conversation moved to top
- ✅ Nav icon badge incremented

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 5: Individual Chat View

#### TC5.1: Message Display
**Priority**: High  
**Requirement**: Messages displayed correctly

**Steps:**
1. Open a conversation with existing messages
2. Scroll through messages

**Expected Result:**
- ✅ Messages in chronological order
- ✅ Sender messages on right (orange gradient)
- ✅ Receiver messages on left (gray gradient)
- ✅ Timestamps below each message
- ✅ Sender name shown for receiver messages
- ✅ All text readable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.2: Sending Messages
**Priority**: High  
**Requirement**: Can send messages

**Steps:**
1. Open a conversation
2. Type a message in input box
3. Tap send button

**Expected Result:**
- ✅ Message appears in chat
- ✅ Aligned to right
- ✅ Orange gradient background
- ✅ Timestamp added
- ✅ Input box clears
- ✅ Auto-scroll to new message
- ✅ Conversation list updates

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.3: Empty Chat State
**Priority**: Medium  
**Requirement**: Handle new conversations

**Steps:**
1. Start a conversation with no messages
2. View the empty chat

**Expected Result:**
- ✅ Empty state appears
- ✅ Message bubble icon shown
- ✅ "No messages yet" text
- ✅ "Start the conversation!" subtext
- ✅ Centered layout
- ✅ Input box still accessible

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.4: Multi-line Messages
**Priority**: Medium  
**Requirement**: Support multi-line text

**Steps:**
1. Open chat
2. Type a long message that requires multiple lines
3. Send it

**Expected Result:**
- ✅ Input box expands (up to 4 lines)
- ✅ Text wraps properly
- ✅ Send button remains visible
- ✅ Message bubble wraps text correctly
- ✅ Readable formatting

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.5: Bad Word Filtering
**Priority**: High  
**Requirement**: Filter inappropriate content

**Steps:**
1. Open chat
2. Type a message with bad words
3. Send it

**Expected Result:**
- ✅ Message filtered before sending
- ✅ Bad words replaced with asterisks
- ✅ Message still sent
- ✅ No error displayed
- ✅ Recipient sees filtered version

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 6: Safety Features

#### TC6.1: Block User
**Priority**: High  
**Requirement**: Can block users

**Steps:**
1. Open a conversation
2. Tap menu icon (ellipsis)
3. Select "Block User"
4. Confirm action

**Expected Result:**
- ✅ Confirmation alert appears
- ✅ Alert explains consequences
- ✅ Can cancel or confirm
- ✅ After blocking, chat dismissed
- ✅ Conversation removed from list
- ✅ Can't receive messages from blocked user

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.2: Report User
**Priority**: High  
**Requirement**: Can report users

**Steps:**
1. Open a conversation
2. Tap menu icon
3. Select "Report"
4. Fill out report form
5. Submit

**Expected Result:**
- ✅ Report sheet appears
- ✅ Can select reason
- ✅ Can add description
- ✅ Can submit or cancel
- ✅ Confirmation shown on submit
- ✅ Sheet dismisses

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.3: Cancel Block Action
**Priority**: Medium  
**Requirement**: Can cancel block

**Steps:**
1. Open conversation
2. Attempt to block user
3. Tap "Cancel" on alert

**Expected Result:**
- ✅ Alert dismisses
- ✅ User not blocked
- ✅ Chat remains open
- ✅ Can continue conversation

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 7: Navigation & Dismissal

#### TC7.1: Done Button (Conversations List)
**Priority**: High  
**Requirement**: Can dismiss conversations list

**Steps:**
1. Open conversations list
2. Tap "Done" button

**Expected Result:**
- ✅ Sheet dismisses smoothly
- ✅ Returns to previous view
- ✅ Previous view state preserved

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.2: Swipe Down Dismissal
**Priority**: Medium  
**Requirement**: Gesture dismissal works

**Steps:**
1. Open conversations list
2. Swipe down from top

**Expected Result:**
- ✅ Sheet follows finger
- ✅ Dismisses on release
- ✅ Smooth animation

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.3: Back Navigation from Chat
**Priority**: High  
**Requirement**: Can return to conversations

**Steps:**
1. Open conversations list
2. Tap a conversation
3. Tap back button

**Expected Result:**
- ✅ Returns to conversations list
- ✅ List state preserved
- ✅ Unread status updated
- ✅ Can select different conversation

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.4: Multiple Open/Close Cycles
**Priority**: Medium  
**Requirement**: No performance issues

**Steps:**
1. Open conversations list
2. Close it
3. Repeat 10 times
4. Open conversations, then chats
5. Navigate back and forth multiple times

**Expected Result:**
- ✅ Smooth performance throughout
- ✅ No lag or stuttering
- ✅ No crashes
- ✅ Views load quickly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 8: Visual & Layout Testing

#### TC8.1: Portrait Orientation
**Priority**: High  
**Requirement**: Proper layout in portrait

**Steps:**
1. Hold device in portrait
2. View conversations list
3. Open individual chat

**Expected Result:**
- ✅ All elements visible
- ✅ No clipping or overflow
- ✅ Proper spacing
- ✅ Readable text
- ✅ Badges positioned correctly

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.2: Landscape Orientation (iPad)
**Priority**: Low  
**Requirement**: Adapts to landscape

**Steps:**
1. Rotate device to landscape
2. View conversations list
3. Open chat

**Expected Result:**
- ✅ Layout adapts appropriately
- ✅ No overlapping elements
- ✅ Content remains accessible
- ✅ Message bubbles sized well

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
- ✅ Layouts adapt properly
- ✅ Text remains readable
- ✅ Touch targets adequate
- ✅ No content cutoff
- ✅ Badges visible

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.4: Dark Mode
**Priority**: Medium  
**Requirement**: Proper appearance in dark mode

**Steps:**
1. Enable dark mode
2. View conversations list
3. Open chat
4. Check all UI elements

**Expected Result:**
- ✅ Proper contrast
- ✅ Colors adapt correctly
- ✅ Text readable
- ✅ Icons visible
- ✅ Badges stand out
- ✅ Message bubbles distinguishable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 9: Edge Cases & Stress Testing

#### TC9.1: Many Conversations
**Priority**: Medium  
**Requirement**: Handle large number

**Steps:**
1. Create 20+ conversations
2. View conversations list
3. Scroll through entire list

**Expected Result:**
- ✅ Smooth scrolling
- ✅ All conversations render
- ✅ No performance degradation
- ✅ No crashes
- ✅ Lazy loading works

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.2: Long Messages
**Priority**: Low  
**Requirement**: Handle long text

**Steps:**
1. Send a very long message (500+ characters)
2. View in chat

**Expected Result:**
- ✅ Message wraps properly
- ✅ Bubble expands vertically
- ✅ No layout breaking
- ✅ Readable
- ✅ Scrollable if needed

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.3: Long Opponent Names
**Priority**: Low  
**Requirement**: Handle long names

**Steps:**
1. Create conversation with very long opponent name
2. View in list and chat

**Expected Result:**
- ✅ Name truncates gracefully
- ✅ Ellipsis shows truncation
- ✅ Layout doesn't break
- ✅ Other elements unaffected

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.4: Rapid Message Sending
**Priority**: Medium  
**Requirement**: Handle rapid actions

**Steps:**
1. Open chat
2. Rapidly type and send multiple messages
3. Send 10 messages in quick succession

**Expected Result:**
- ✅ All messages sent
- ✅ Appear in correct order
- ✅ No duplicates
- ✅ No crashes
- ✅ Smooth scrolling

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.5: Rapid Conversation Switching
**Priority**: Medium  
**Requirement**: Handle rapid navigation

**Steps:**
1. Open conversations list
2. Rapidly tap different conversations
3. Quickly navigate back and forth

**Expected Result:**
- ✅ No crashes
- ✅ Correct conversations load
- ✅ No mixed messages
- ✅ Read status updates correctly
- ✅ Performance remains smooth

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 10: Data Accuracy

#### TC10.1: Unread Count Accuracy
**Priority**: High  
**Requirement**: Counts are accurate

**Steps:**
1. Receive 5 new messages in conversation A
2. Receive 3 new messages in conversation B
3. Check badges

**Expected Result:**
- ✅ Conversation A badge shows "5"
- ✅ Conversation B badge shows "3"
- ✅ Navigation icon shows "8"
- ✅ Counts match actual unread messages
- ✅ No counting errors

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.2: Message Timestamps
**Priority**: High  
**Requirement**: Accurate time display

**Steps:**
1. Send messages at different times
2. Check timestamps in chat
3. Check "time ago" in conversations list

**Expected Result:**
- ✅ Timestamps accurate
- ✅ Relative time correct ("2h ago", "1d ago")
- ✅ Updates as time passes
- ✅ Consistent formatting

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC10.3: Last Message Preview
**Priority**: High  
**Requirement**: Shows correct preview

**Steps:**
1. Send different messages in conversations
2. View conversations list
3. Check preview text

**Expected Result:**
- ✅ Shows most recent message
- ✅ Truncates to 2 lines
- ✅ Updates when new message sent
- ✅ Matches actual message content

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 11: Integration Testing

#### TC11.1: Works Across All Views
**Priority**: High  
**Requirement**: Icon on all main views

**Steps:**
1. Navigate to HomeView → tap icon
2. Navigate to ProfileView → tap icon
3. Navigate to LeaderboardView → tap icon
4. Navigate to FindPlayersView → tap icon

**Expected Result:**
- ✅ Icon present on all views
- ✅ All icons functional
- ✅ Same conversations list opens
- ✅ Badge count consistent
- ✅ Seamless experience

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC11.2: Game Integration
**Priority**: High  
**Requirement**: Conversations linked to games

**Steps:**
1. Create a new game
2. Accept game challenge
3. Check if conversation created

**Expected Result:**
- ✅ Conversation auto-created
- ✅ Linked to correct game
- ✅ Opponent info correct
- ✅ Can send messages immediately

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC11.3: Blocked Users Hidden
**Priority**: High  
**Requirement**: Blocked conversations removed

**Steps:**
1. Have active conversation
2. Block the user
3. Return to conversations list

**Expected Result:**
- ✅ Conversation removed from list
- ✅ Can't receive messages from blocked user
- ✅ Unread count updated
- ✅ No errors or crashes

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
| Conversations List View | 5 | | | |
| Navigation Bar Chat Icon | 5 | | | |
| Unread Message Indicators | 5 | | | |
| Mark as Read Functionality | 3 | | | |
| Individual Chat View | 5 | | | |
| Safety Features | 3 | | | |
| Navigation & Dismissal | 4 | | | |
| Visual & Layout | 4 | | | |
| Edge Cases & Stress | 5 | | | |
| Data Accuracy | 3 | | | |
| Integration Testing | 3 | | | |
| **TOTAL** | **45** | | | |

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

---

**Document Version:** 1.0  
**Last Updated:** October 31, 2025  
**Status:** Ready for Testing

