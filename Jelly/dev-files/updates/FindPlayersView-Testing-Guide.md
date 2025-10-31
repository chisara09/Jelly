# FindPlayersView Updates - Testing Guide

## 🧪 Comprehensive Testing Guide

This guide provides step-by-step instructions for testing all FindPlayersView updates to ensure proper functionality and user experience.

---

## 📋 Pre-Testing Setup

### Requirements
- Xcode with iOS 17.0+ simulator
- Jelly app installed and running
- User account created and logged in
- Location permissions granted
- Google Maps app installed (for full testing)
- Apple Maps available (built-in)

### Test Account Setup
1. Launch the app
2. Sign up with a test account
3. Navigate to Find Players tab
4. Grant location permissions when prompted

### Test Environment Preparation
- Install Google Maps on test device/simulator
- Enable location services in Settings
- Set location to NYC or area with test courts
- Ensure internet connectivity for maps

---

## ✅ Test Cases

### Test Suite 1: Map Marker Visualization

#### TC1.1: Small Dot Appearance
**Priority**: High  
**Requirement**: Show courts as small dots on the map for clarity

**Steps:**
1. Open the app and log in
2. Navigate to Find Players tab
3. View the map section (top of screen)
4. Observe court markers

**Expected Result:**
- ✅ Court markers appear as small circular dots
- ✅ Dots are approximately 8pt in diameter
- ✅ Dots are orange (app brand color)
- ✅ White border visible around each dot (2pt)
- ✅ Subtle shadow visible for depth
- ✅ Multiple courts visible without visual clutter

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.2: Marker Visibility on Different Map Types
**Priority**: High  
**Requirement**: Dots should be visible on all map backgrounds

**Steps:**
1. View map with court dots
2. Pan around to see different areas
3. Observe dots on:
   - Streets and roads
   - Parks and green spaces
   - Water bodies
   - Dense urban areas

**Expected Result:**
- ✅ White borders make dots visible on all backgrounds
- ✅ Orange color stands out clearly
- ✅ Shadow provides depth on light backgrounds
- ✅ No visibility issues on any terrain type

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.3: Multiple Courts Display
**Priority**: High  
**Requirement**: Dots provide clarity with multiple courts

**Steps:**
1. Ensure test data has 5+ courts in view
2. View map showing multiple courts
3. Zoom in to see close courts
4. Zoom out to see distant courts

**Expected Result:**
- ✅ All courts visible as individual dots
- ✅ No overlapping that obscures courts
- ✅ Clean appearance even with many courts
- ✅ Dots maintain size while zooming
- ✅ Better clarity than large MapMarkers

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC1.4: Dot Size Consistency
**Priority**: Medium  
**Requirement**: Consistent appearance across screens

**Steps:**
1. View map on different device sizes
2. Rotate device (if applicable)
3. Check dot appearance after navigation and return

**Expected Result:**
- ✅ Dots remain 8pt diameter on all screens
- ✅ No scaling issues
- ✅ Border width consistent (2pt)
- ✅ Shadow consistent

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 2: Google Maps Integration

#### TC2.1: Open Google Maps - Map Dot Tap (Google Maps Installed)
**Priority**: High  
**Requirement**: Clicking court should open Google Maps with location pinned

**Pre-requisite**: Google Maps app installed

**Steps:**
1. View map with court dots
2. Tap on any court dot
3. Observe app transition

**Expected Result:**
- ✅ Google Maps app opens immediately
- ✅ Court location pinned in Google Maps
- ✅ Map centered on court coordinates
- ✅ Appropriate zoom level (street level, ~zoom 15)
- ✅ Smooth transition between apps
- ✅ Can return to Jelly app via back button

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.2: Fallback to Apple Maps (Google Maps NOT Installed)
**Priority**: High  
**Requirement**: Graceful fallback when Google Maps unavailable

**Pre-requisite**: Google Maps app NOT installed/uninstalled

**Steps:**
1. Ensure Google Maps not on device
2. View map with court dots
3. Tap on any court dot
4. Observe app transition

**Expected Result:**
- ✅ Apple Maps opens (fallback works)
- ✅ Court location pinned in Apple Maps
- ✅ Court name included in search
- ✅ Map centered on court coordinates
- ✅ Appropriate zoom level
- ✅ No error messages or crashes

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.3: Correct Location Pinning
**Priority**: High  
**Requirement**: Exact court coordinates used

**Steps:**
1. Note court coordinates from code/debug
   - Central Park Courts: 40.785091, -73.968285
2. Tap court dot
3. Open in Google/Apple Maps
4. Verify coordinates in maps app

**Expected Result:**
- ✅ Exact coordinates match
- ✅ Pin placed at correct location
- ✅ Court visible at pinned location
- ✅ No coordinate drift or errors

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.4: Multiple Courts - Different Locations
**Priority**: High  
**Requirement**: Each court opens correct location

**Steps:**
1. Tap Central Park Courts dot → Note location
2. Return to app
3. Tap Brooklyn Heights Courts dot → Note location
4. Return to app
5. Tap Harlem Courts dot → Note location

**Expected Result:**
- ✅ Each court opens different location
- ✅ All locations accurate
- ✅ No mix-ups between courts
- ✅ Consistent behavior for all courts

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC2.5: Special Characters in Court Names
**Priority**: Medium  
**Requirement**: Handle special characters in URLs

**Steps:**
1. Create court with special name (e.g., "Mike's Court & Gym")
2. Tap court dot
3. Check maps opens correctly

**Expected Result:**
- ✅ Maps opens without error
- ✅ Special characters encoded properly
- ✅ Court name displays correctly in maps
- ✅ No URL parsing errors

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 3: Court List Integration

#### TC3.1: Court List Items Tappable
**Priority**: High  
**Requirement**: Court list items open maps

**Steps:**
1. Scroll down to "Courts Near You" section
2. Tap on first court in list
3. Observe behavior

**Expected Result:**
- ✅ Maps app opens (Google or Apple)
- ✅ Same behavior as tapping map dot
- ✅ Correct court location shown
- ✅ Smooth transition

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.2: Court List Visual Appearance
**Priority**: Medium  
**Requirement**: List items look unchanged despite being tappable

**Steps:**
1. Compare court list items with previous version
2. Check for visual changes
3. Verify styling intact

**Expected Result:**
- ✅ Court name still headline font
- ✅ Address still subheadline font
- ✅ No blue button tint (PlainButtonStyle)
- ✅ Padding unchanged
- ✅ List appearance identical to before

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.3: All Court List Items Work
**Priority**: High  
**Requirement**: Every court in list opens maps

**Steps:**
1. View all courts in list
2. Tap each court one by one
3. Verify each opens maps correctly

**Expected Result:**
- ✅ All courts open maps
- ✅ Correct location for each
- ✅ No courts unresponsive
- ✅ Consistent behavior

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC3.4: Filtered Courts
**Priority**: High  
**Requirement**: Search doesn't break functionality

**Steps:**
1. Use search bar to filter courts
2. Verify filtered courts appear on map as dots
3. Tap filtered court dot → Opens maps
4. Tap filtered court in list → Opens maps

**Expected Result:**
- ✅ Filtered courts show as dots
- ✅ Non-matching courts hidden
- ✅ Tapping filtered courts works
- ✅ Same behavior as unfiltered

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 4: Interaction & Responsiveness

#### TC4.1: Touch Target Size
**Priority**: High  
**Requirement**: Dots are tappable despite small size

**Steps:**
1. View map with courts
2. Attempt to tap court dots
3. Try tapping:
   - Directly on center
   - On edge of dot
   - Just outside dot (1-2pt away)

**Expected Result:**
- ✅ Center tap always works
- ✅ Edge taps work reliably
- ✅ Touch target feels adequate
- ✅ No difficulty tapping
- ✅ Works with finger (not just stylus)

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.2: Tap Accuracy with Close Courts
**Priority**: Medium  
**Requirement**: Can distinguish between nearby courts

**Steps:**
1. Find/create two courts close together
2. Attempt to tap each individually
3. Verify correct court opens

**Expected Result:**
- ✅ Can tap desired court
- ✅ Correct court opens in maps
- ✅ No accidental taps on wrong court
- ✅ Dots don't overlap in a confusing way

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.3: Rapid Tapping
**Priority**: Medium  
**Requirement**: Handle rapid user interaction

**Steps:**
1. Rapidly tap same court dot 5 times
2. Rapidly tap different court dots
3. Observe behavior

**Expected Result:**
- ✅ Maps opens once (not multiple times)
- ✅ No crashes or errors
- ✅ Smooth handling of rapid input
- ✅ App remains responsive

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC4.4: App Switching
**Priority**: High  
**Requirement**: Smooth transition between apps

**Steps:**
1. Tap court dot to open maps
2. Use device back button to return to Jelly
3. Tap different court
4. Return again
5. Repeat several times

**Expected Result:**
- ✅ Smooth transitions both ways
- ✅ Jelly app state preserved
- ✅ Map position preserved
- ✅ No crashes or freezes
- ✅ No memory issues

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 5: Edge Cases & Error Handling

#### TC5.1: No Courts Available
**Priority**: Medium  
**Requirement**: Handle empty state gracefully

**Steps:**
1. Create test scenario with no courts
2. View map
3. Check "Courts Near You" section

**Expected Result:**
- ✅ Map loads normally
- ✅ No dots displayed (expected)
- ✅ "No matches found" in court section
- ✅ No crashes or errors

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.2: Single Court
**Priority**: Low  
**Requirement**: Works with minimum data

**Steps:**
1. Test with only one court in data
2. View map
3. Tap the single court dot

**Expected Result:**
- ✅ Single dot displays correctly
- ✅ Map centers appropriately
- ✅ Tapping opens maps
- ✅ No layout issues

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.3: Many Courts (20+)
**Priority**: Medium  
**Requirement**: Handle large datasets

**Steps:**
1. Add 20+ courts to test data
2. View map showing all courts
3. Verify performance and visibility

**Expected Result:**
- ✅ All dots render smoothly
- ✅ No performance lag
- ✅ Map remains interactive
- ✅ Dots don't clutter excessively
- ✅ Each dot still tappable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.4: Invalid Coordinates
**Priority**: Low  
**Requirement**: Handle edge cases gracefully

**Steps:**
1. Create court with invalid coordinates (if possible)
2. Attempt to tap and open maps

**Expected Result:**
- ✅ No crashes
- ✅ Graceful error handling
- ✅ App remains stable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.5: No Internet Connection
**Priority**: Medium  
**Requirement**: Handle offline state

**Steps:**
1. Turn off Wi-Fi and cellular data
2. View map with court dots
3. Tap court dot

**Expected Result:**
- ✅ Map shows cached tiles (if any)
- ✅ Dots still visible
- ✅ Tap attempts to open maps
- ✅ Maps app handles offline state
- ✅ No crashes in Jelly app

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC5.6: Location Permission Denied
**Priority**: Medium  
**Requirement**: Handle missing permissions

**Steps:**
1. Deny location permissions
2. View Find Players tab
3. Observe map behavior

**Expected Result:**
- ✅ Map shows fallback state
- ✅ Court dots still visible (if using default region)
- ✅ Tapping dots still opens maps
- ✅ Clear message about location access
- ✅ "Use Location" button available

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 6: Visual & Layout Testing

#### TC6.1: Portrait Orientation
**Priority**: High  
**Requirement**: Proper layout in portrait mode

**Steps:**
1. Hold device in portrait
2. View Find Players tab
3. Check map and dots

**Expected Result:**
- ✅ Map visible at top (280pt height)
- ✅ All dots visible and proportional
- ✅ Court list below map accessible
- ✅ No clipping or overflow

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.2: Landscape Orientation (iPad)
**Priority**: Low  
**Requirement**: Proper layout in landscape mode

**Steps:**
1. Rotate device to landscape
2. View Find Players tab
3. Check map and dots

**Expected Result:**
- ✅ Layout adapts appropriately
- ✅ Dots remain proportional
- ✅ Map and list both visible
- ✅ No overlapping elements

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.3: Different Screen Sizes
**Priority**: Medium  
**Requirement**: Works on all iPhone sizes

**Test Devices:**
- iPhone SE (small - 4.7")
- iPhone 14 (medium - 6.1")
- iPhone 14 Pro Max (large - 6.7")

**Expected Result:**
- ✅ Dots remain 8pt on all screens
- ✅ Map proportional to screen
- ✅ Touch targets adequate on all sizes
- ✅ No content cutoff

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.4: Dark Mode
**Priority**: Medium  
**Requirement**: Proper appearance in dark mode

**Steps:**
1. Enable dark mode in Settings
2. View Find Players tab
3. Check map markers and court list

**Expected Result:**
- ✅ Orange dots visible on dark map
- ✅ White borders stand out
- ✅ Shadow still visible
- ✅ Court list readable
- ✅ Proper contrast throughout

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC6.5: Light Mode
**Priority**: Medium  
**Requirement**: Proper appearance in light mode

**Steps:**
1. Enable light mode in Settings
2. View Find Players tab
3. Check map markers and court list

**Expected Result:**
- ✅ Orange dots visible on light map
- ✅ White borders provide contrast
- ✅ Shadow adds depth
- ✅ Court list readable
- ✅ Colors appropriate

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 7: Integration Testing

#### TC7.1: Player List Unaffected
**Priority**: High  
**Requirement**: Other features remain functional

**Steps:**
1. View "Players Near You" section
2. Tap player to view profile
3. Navigate back
4. Verify functionality

**Expected Result:**
- ✅ Player list works as before
- ✅ Navigation to profiles works
- ✅ No interference from court updates
- ✅ All player features intact

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.2: Search Functionality
**Priority**: High  
**Requirement**: Search works for both players and courts

**Steps:**
1. Enter player name in search
2. Verify player filtering
3. Clear search
4. Enter court name in search
5. Verify court filtering (both map and list)

**Expected Result:**
- ✅ Player search works
- ✅ Court search works
- ✅ Map updates with filtered courts
- ✅ Court list updates with filtered courts
- ✅ Filtered court dots still tappable

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.3: Location Updates
**Priority**: Medium  
**Requirement**: Map updates with user movement

**Steps:**
1. Grant location permissions
2. View map centered on current location
3. Simulate location change (if possible)
4. Observe map updates

**Expected Result:**
- ✅ Map centers on user location initially
- ✅ Court dots displayed relative to user
- ✅ Location updates reflected
- ✅ Dots remain functional

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC7.4: Tab Navigation
**Priority**: High  
**Requirement**: Switching tabs preserves state

**Steps:**
1. View Find Players tab with map
2. Switch to different tab
3. Return to Find Players tab
4. Verify state preserved

**Expected Result:**
- ✅ Map position preserved
- ✅ Search text preserved
- ✅ Court dots still visible
- ✅ No re-rendering issues

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 8: Performance Testing

#### TC8.1: Map Rendering Performance
**Priority**: High  
**Requirement**: Smooth performance

**Steps:**
1. Load Find Players tab
2. Measure time to render map with dots
3. Pan and zoom map
4. Observe frame rate

**Expected Result:**
- ✅ Map loads quickly (< 2 seconds)
- ✅ Dots render immediately
- ✅ Smooth panning (60 fps)
- ✅ Smooth zooming
- ✅ No lag or stuttering

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.2: Tap Response Time
**Priority**: High  
**Requirement**: Immediate response

**Steps:**
1. Tap court dot
2. Measure time until maps opens
3. Repeat for multiple courts

**Expected Result:**
- ✅ Maps opens within 1 second
- ✅ No delay or loading
- ✅ Consistent response time
- ✅ Feels immediate to user

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC8.3: Memory Usage
**Priority**: Medium  
**Requirement**: No memory leaks

**Steps:**
1. Open Find Players tab
2. Tap multiple courts (10+)
3. Switch to maps and back repeatedly
4. Monitor memory usage

**Expected Result:**
- ✅ Memory usage stable
- ✅ No continuous growth
- ✅ No leaks from map transitions
- ✅ App remains responsive

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

### Test Suite 9: Comparison Testing

#### TC9.1: Before vs After - Visual Clarity
**Priority**: High  
**Requirement**: Dots clearer than markers

**Steps:**
1. Compare screenshots of before (MapMarkers) and after (dots)
2. Evaluate visual clarity
3. Test with multiple courts visible

**Expected Result:**
- ✅ Dots less cluttered than markers
- ✅ More courts visible simultaneously
- ✅ Cleaner overall appearance
- ✅ Easier to scan map

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

#### TC9.2: Functionality Comparison
**Priority**: High  
**Requirement**: New functionality added

**Steps:**
1. List before: Markers not tappable for navigation
2. List after: Dots open maps on tap

**Expected Result:**
- ✅ New feature: Tap to navigate
- ✅ All old features preserved
- ✅ No regressions
- ✅ Enhanced functionality

**Actual Result:** _____________

**Status:** ☐ Pass ☐ Fail

---

## 📊 Test Summary Template

### Test Execution Summary

**Test Date:** _____________  
**Tested By:** _____________  
**Device/Simulator:** _____________  
**iOS Version:** _____________  
**Google Maps Installed:** ☐ Yes ☐ No

| Test Suite | Total Tests | Passed | Failed | Skipped |
|-----------|-------------|--------|--------|---------|
| Map Marker Visualization | 4 | | | |
| Google Maps Integration | 5 | | | |
| Court List Integration | 4 | | | |
| Interaction & Responsiveness | 4 | | | |
| Edge Cases & Error Handling | 6 | | | |
| Visual & Layout | 5 | | | |
| Integration Testing | 4 | | | |
| Performance Testing | 3 | | | |
| Comparison Testing | 2 | | | |
| **TOTAL** | **37** | | | |

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
- Google Maps Installed: ☐ Yes ☐ No

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
- [ ] Tested with Google Maps installed
- [ ] Tested without Google Maps (fallback)
- [ ] Performance acceptable

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
- [ ] Document known limitations
- [ ] Update user guide if needed

---

## 📝 Additional Notes

### Testing Tips

1. **Google Maps Testing**: Test both with and without Google Maps installed to verify fallback
2. **Real Device**: Test on real device for accurate touch target testing
3. **Location Simulation**: Use Xcode location simulation for different scenarios
4. **Screenshots**: Take before/after screenshots for visual comparison
5. **Performance**: Monitor Xcode performance tools during testing

### Critical Test Cases

These tests are most critical and should always pass:
- TC1.1: Small Dot Appearance
- TC2.1: Open Google Maps (primary functionality)
- TC2.2: Fallback to Apple Maps (reliability)
- TC3.1: Court List Items Tappable
- TC4.1: Touch Target Size
- TC7.1: Player List Unaffected (no regression)

---

**Document Version:** 1.0  
**Last Updated:** October 31, 2025  
**Status:** Ready for Testing

