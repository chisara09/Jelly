# NewChallengeView Feature Overview

## 📋 Summary

Updated the **NewChallengeView** to provide an improved court selection experience. Users can now quickly select from homecourts or search through a comprehensive list of available courts.

---

## 🎯 Feature Requirements

From `updates.md`:
> **NewChallengeView** — Challenge creation screen  
> - When selecting a court, give players the option to select either of their homecourts and a searchbar for other courts.

---

## ✨ What's New

### 1. **Home Court Quick Selection**
- Users can quickly select from their own home court
- Users can select their opponent's home court
- Both options appear at the top of the court selection view for easy access
- Each homecourt is clearly labeled ("Your Home Court", "Opponent's Home Court")
- Orange house icon indicates homecourt options

### 2. **Comprehensive Court Search**
- Full searchable list of available courts
- Real-time search filtering by court name or address
- Clean, organized list view with court details
- Empty state when no search results are found

### 3. **Improved User Experience**
- Court selection now uses a dedicated sheet interface
- Selected court displays name and address in the main form
- "Select Court" button replaces manual text field entry
- Send button is disabled until a court is selected
- Validation ensures court information is complete

---

## 🎨 UI/UX Improvements

### Court Selection Sheet
- **Home Courts Section**: Quick access to familiar courts with visual distinction
- **All Courts Section**: Complete list of available courts
- **Search Bar**: Real-time filtering of courts
- **Empty States**: Helpful messages when no courts match search
- **Clear Labels**: Court names and addresses clearly displayed
- **Visual Hierarchy**: Icons and typography guide user attention

### Main Challenge Form
- **Court Display**: Shows selected court name and address
- **Chevron Indicator**: Visual cue that court selection opens a new view
- **Placeholder State**: "Select Court" shown when no court is selected
- **Disabled State**: Send button disabled until court is selected

---

## 🔄 User Flow

1. User taps "Challenge" button on another player's profile
2. NewChallengeView opens with opponent pre-selected
3. User taps on "Select Court" button
4. CourtSelectionView sheet appears showing:
   - Home Courts section (if available)
   - All Courts section with search
5. User either:
   - Taps a home court for quick selection, OR
   - Searches and selects from all available courts
6. Selected court automatically populates the form
7. User completes date/time and rules
8. User taps "Send" to create the challenge

---

## 💾 Data Structure

### Court Model
```swift
struct Court: Identifiable, Codable {
    let id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}
```

### Home Court Sources
- **Current User**: Fetched from user profile (mock data for now)
- **Opponent**: Passed from NearbyPlayer object

---

## 🎯 Benefits

1. **Faster Court Selection**: Home courts provide one-tap selection
2. **Better Discovery**: Search helps users find specific courts
3. **Reduced Errors**: Selecting from list prevents typos
4. **Consistent Data**: All courts use standardized names/addresses
5. **Intuitive Interface**: Clear visual hierarchy and labels
6. **Familiar Courts First**: Home courts prioritized for convenience

---

## 🔜 Future Enhancements

- Integrate with real court database API
- Add court favorites/recent courts
- Show distance to courts
- Display court photos/ratings
- Add ability to add new courts
- Show court availability/busy times
- Integration with maps for court preview

