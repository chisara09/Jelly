# NewChallengeView Testing Guide

## 🧪 Testing Overview

This guide provides comprehensive testing instructions for the updated NewChallengeView feature.

---

## ✅ Manual Testing Checklist

### 1. **Court Selection - Home Courts**

#### Test Case 1.1: View Home Courts
- [ ] Open NewChallengeView from a player profile
- [ ] Tap "Select Court" button
- [ ] Verify "Home Courts" section appears at the top
- [ ] Verify "Your Home Court" is listed
- [ ] Verify "Opponent's Home Court" is listed (if different)
- [ ] Verify orange house icon appears next to home courts
- [ ] Verify home court descriptions are clear

**Expected Result**: Home courts section displays with proper labels and icons

#### Test Case 1.2: Select Your Home Court
- [ ] Tap on "Your Home Court" option
- [ ] Verify court selection sheet dismisses automatically
- [ ] Verify selected court name appears in main form
- [ ] Verify court address appears below name
- [ ] Verify "Send" button becomes enabled

**Expected Result**: User's home court is selected and form is ready to submit

#### Test Case 1.3: Select Opponent's Home Court
- [ ] Open court selection again
- [ ] Tap on "Opponent's Home Court" option
- [ ] Verify opponent's court is selected correctly
- [ ] Verify sheet dismisses
- [ ] Verify form updates with opponent's court

**Expected Result**: Opponent's home court is properly selected

#### Test Case 1.4: Same Home Court
- [ ] Challenge a player with the same home court as you
- [ ] Open court selection
- [ ] Verify only one home court appears (not duplicated)

**Expected Result**: No duplicate home courts shown

---

### 2. **Court Selection - Search Functionality**

#### Test Case 2.1: View All Courts
- [ ] Open court selection
- [ ] Scroll down to "All Courts" section
- [ ] Verify multiple courts are listed
- [ ] Verify each court shows name and address
- [ ] Verify courts are clearly formatted

**Expected Result**: All available courts displayed in organized list

#### Test Case 2.2: Search by Court Name
- [ ] Tap on search bar
- [ ] Type "Central Park"
- [ ] Verify only matching courts appear
- [ ] Verify home courts section disappears during search
- [ ] Verify section header changes to "Search Results"

**Expected Result**: Search filters courts by name in real-time

#### Test Case 2.3: Search by Address
- [ ] Clear search
- [ ] Type "Brooklyn"
- [ ] Verify courts in Brooklyn appear
- [ ] Verify search works on address field

**Expected Result**: Search works for both name and address

#### Test Case 2.4: Case-Insensitive Search
- [ ] Search for "central park" (lowercase)
- [ ] Verify "Central Park Courts" still appears
- [ ] Try "HARLEM" (uppercase)
- [ ] Verify "Harlem Courts" appears

**Expected Result**: Search is case-insensitive

#### Test Case 2.5: No Search Results
- [ ] Search for "zzzzz" (non-existent court)
- [ ] Verify "No courts found" message appears
- [ ] Verify magnifying glass icon shows
- [ ] Verify message is centered and clear

**Expected Result**: Helpful empty state displayed

#### Test Case 2.6: Clear Search
- [ ] Enter a search query
- [ ] Tap "X" button to clear search
- [ ] Verify all courts reappear
- [ ] Verify home courts section returns

**Expected Result**: Search clears and full list returns

---

### 3. **Court Selection - Selection Flow**

#### Test Case 3.1: Select Court from Search
- [ ] Search for a specific court
- [ ] Tap on a court from search results
- [ ] Verify sheet dismisses
- [ ] Verify selected court appears in form
- [ ] Verify "Send" button is enabled

**Expected Result**: Court selected successfully from search results

#### Test Case 3.2: Cancel Court Selection
- [ ] Open court selection
- [ ] Tap "Cancel" button
- [ ] Verify sheet dismisses
- [ ] Verify previous selection (if any) remains
- [ ] Verify no changes to form

**Expected Result**: Court selection cancelled without changes

#### Test Case 3.3: Change Court Selection
- [ ] Select a court
- [ ] Open court selection again
- [ ] Select a different court
- [ ] Verify new court replaces old selection
- [ ] Verify form updates correctly

**Expected Result**: Court selection can be changed multiple times

---

### 4. **Form Validation**

#### Test Case 4.1: Initial State
- [ ] Open NewChallengeView
- [ ] Verify "Send" button is disabled
- [ ] Verify "Select Court" placeholder is shown
- [ ] Verify no court address is displayed

**Expected Result**: Form starts in disabled state without court

#### Test Case 4.2: Enable Send Button
- [ ] Select any court
- [ ] Verify "Send" button becomes enabled
- [ ] Verify button is visually active (not grayed out)

**Expected Result**: Send button enabled after court selection

#### Test Case 4.3: Court Display
- [ ] Select "Central Park Courts"
- [ ] Verify court name displays in primary text
- [ ] Verify address displays in smaller, secondary text
- [ ] Verify chevron icon remains visible

**Expected Result**: Selected court displays with proper formatting

---

### 5. **Challenge Creation Flow**

#### Test Case 5.1: Complete Challenge Creation
- [ ] Select a court
- [ ] Select date and time
- [ ] Select rules
- [ ] Tap "Send" button
- [ ] Verify loading indicator appears
- [ ] Verify view dismisses after successful creation
- [ ] Verify challenge appears in games list

**Expected Result**: Challenge created successfully with selected court

#### Test Case 5.2: Error Handling
- [ ] (Simulated) Create API error condition
- [ ] Try to send challenge
- [ ] Verify error message appears
- [ ] Verify "Send" button re-enables
- [ ] Verify form remains open
- [ ] Verify user can retry

**Expected Result**: Errors handled gracefully with retry option

---

### 6. **UI/UX Testing**

#### Test Case 6.1: Visual Hierarchy
- [ ] Open court selection
- [ ] Verify home courts visually distinct from all courts
- [ ] Verify search bar is prominent
- [ ] Verify icons enhance understanding
- [ ] Verify spacing and padding feel comfortable

**Expected Result**: Visual hierarchy guides user effectively

#### Test Case 6.2: Transitions and Animations
- [ ] Open court selection sheet
- [ ] Verify smooth sheet presentation
- [ ] Select a court
- [ ] Verify smooth dismissal
- [ ] Verify no jarring transitions

**Expected Result**: Smooth, native-feeling animations

#### Test Case 6.3: Accessibility
- [ ] Enable VoiceOver
- [ ] Navigate court selection
- [ ] Verify all elements are announced
- [ ] Verify actions are clear
- [ ] Disable VoiceOver

**Expected Result**: All features accessible via VoiceOver

#### Test Case 6.4: Dark Mode
- [ ] Enable Dark Mode
- [ ] Open court selection
- [ ] Verify colors adapt properly
- [ ] Verify text remains readable
- [ ] Verify no visual issues

**Expected Result**: Dark mode fully supported

---

### 7. **Edge Cases**

#### Test Case 7.1: No Home Courts
- [ ] (Mock scenario) User with no home court set
- [ ] Open court selection
- [ ] Verify "Home Courts" section doesn't appear
- [ ] Verify only "All Courts" section shows

**Expected Result**: Graceful handling of missing home courts

#### Test Case 7.2: Empty Court Database
- [ ] (Mock scenario) No courts available
- [ ] Open court selection
- [ ] Verify appropriate message displays
- [ ] Verify user is informed clearly

**Expected Result**: Empty state handled gracefully

#### Test Case 7.3: Very Long Court Names
- [ ] (Mock data) Add court with very long name
- [ ] Select that court
- [ ] Verify text doesn't overflow
- [ ] Verify layout remains intact

**Expected Result**: Long text handled with ellipsis or wrapping

#### Test Case 7.4: Special Characters in Court Names
- [ ] Search for courts with special characters
- [ ] Verify search works correctly
- [ ] Verify selection works correctly
- [ ] Verify display is clean

**Expected Result**: Special characters handled properly

---

## 🔄 Regression Testing

### Existing Functionality to Verify

#### Challenge Creation
- [ ] Opponent selection still works
- [ ] Date/time picker still functions
- [ ] Rules picker still works
- [ ] Cancel button still works
- [ ] Error handling still works

#### Navigation
- [ ] Can navigate to NewChallengeView from player profile
- [ ] Can navigate back without issues
- [ ] Sheet presentations work correctly

#### Integration Points
- [ ] GameManager integration still works
- [ ] Challenge appears in HomeView
- [ ] Challenge appears in game lists
- [ ] All game data saved correctly

---

## 📊 Performance Testing

### Test Case P.1: Search Performance
- [ ] Type rapidly in search bar
- [ ] Verify no lag or stuttering
- [ ] Verify results update smoothly

### Test Case P.2: List Scrolling
- [ ] Scroll through court list rapidly
- [ ] Verify smooth scrolling
- [ ] Verify no frame drops

### Test Case P.3: Sheet Presentation
- [ ] Open and close sheet multiple times
- [ ] Verify consistent performance
- [ ] Verify no memory leaks

---

## 🐛 Known Issues / Future Improvements

### Current Limitations
1. Mock court data only
2. Home court is hardcoded (not from user profile)
3. No court distance calculation
4. No court favorites/recent courts

### Future Testing Needs
1. API integration testing
2. Real user profile integration
3. Location-based court sorting
4. Court favorites functionality

---

## ✅ Test Results Template

```
Date: __________
Tester: __________
Build Version: __________
Device: __________
iOS Version: __________

Test Results:
- Home Courts: ☐ Pass ☐ Fail
- Search: ☐ Pass ☐ Fail
- Selection Flow: ☐ Pass ☐ Fail
- Form Validation: ☐ Pass ☐ Fail
- Challenge Creation: ☐ Pass ☐ Fail
- UI/UX: ☐ Pass ☐ Fail
- Edge Cases: ☐ Pass ☐ Fail

Issues Found:
1. __________
2. __________
3. __________

Notes:
__________
```

---

## 🎯 Success Criteria

All tests pass when:
- ✅ Home courts display correctly
- ✅ Search filters courts in real-time
- ✅ Court selection updates form
- ✅ Form validation works properly
- ✅ Challenge creation succeeds with selected court
- ✅ UI is polished and responsive
- ✅ No crashes or errors occur
- ✅ Edge cases handled gracefully

---

## 🚀 Ready for Production Checklist

Before deploying to production:
- [ ] All manual tests passed
- [ ] Performance is acceptable
- [ ] Dark mode tested
- [ ] Accessibility verified
- [ ] Edge cases handled
- [ ] Error states tested
- [ ] API integration complete
- [ ] Real user data integrated
- [ ] No known critical bugs

