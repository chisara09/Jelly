# Firestore Collection Audit Report

## Complete Analysis of Each Collection

### ✅ 1. USERS Collection
**Status**: ✅ **CORRECT**

**Your Structure**:
- `email`: String ✅
- `name`: String ✅
- `createdAt`: Timestamp ✅
- `lastLoginAt`: Timestamp ✅

**Verdict**: Perfect match with specification. No issues.

---

### ⚠️ 2. PROFILES Collection
**Status**: ⚠️ **NEEDS FIXES**

**Your Structure**:
- `name`: String ✅
- `bio`: String ✅
- `homeCourtID`: String ✅
- `photoURL`: String ✅
- `location`: Map ❌ **INCORRECT STRUCTURE**
  - You have: `location.coords: [0° N, 0° E]` (array/string)
  - Should be: `location.latitude: Double` and `location.longitude: Double` (numbers)
- `lastUpdated`: Timestamp ❌ **MISSING AT ROOT LEVEL**
  - Should be at root: `lastUpdated: Timestamp`
  - Currently inside `location.lastUpdated` (which is fine, but root level is also expected)
- `settings`: Map ✅
  - `darkMode`: Boolean ✅
  - `notificationsEnabled`: Boolean ✅

**Issues Found**:
1. ❌ `location.coords` is wrong format - should be `location.latitude` and `location.longitude` as **numbers**
2. ⚠️ `lastUpdated` should be at root level (though having it in location is also acceptable per code)

**Fix Required**:
```
Change:
  location.coords: [0° N, 0° E]

To:
  location.latitude: 0.0 (number)
  location.longitude: 0.0 (number)
  location.lastUpdated: Timestamp (keep this)
  
Also add at root:
  lastUpdated: Timestamp (same value or separate)
```

---

### ❌ 3. COURTS Collection
**Status**: ❌ **INCORRECT**

**Your Structure**:
- `name`: String ✅
- `address`: String ✅
- `createdAt`: Timestamp ✅
- `coords`: ❌ **WRONG FIELD** - should be `latitude` and `longitude` as separate number fields

**Specification Requires**:
- `latitude`: Double (number)
- `longitude`: Double (number)

**Issues Found**:
1. ❌ Missing `latitude` field
2. ❌ Missing `longitude` field
3. ❌ Has incorrect `coords` field (appears to be string/array `[0° N, 0° E]`)

**Fix Required**:
```
Delete: coords
Add: latitude: 40.8276 (as number, not string)
Add: longitude: -73.9442 (as number, not string)
```

---

### ❌ 4. GAMES Collection
**Status**: ❌ **MULTIPLE ISSUES**

**Your Structure**:
- `challengerID`: String ✅
- `opponentID`: String ✅
- `courtID`: String ✅
- `scheduledDate`: Timestamp ✅
- `rules`: String ✅
- `challengerScore`: Int ✅
- `opponentScore`: Int ✅
- `loserID`: String ✅
- `isConfirmed`: Boolean ✅
- `createdAt`: Timestamp ✅
- `status`: ❌ **WRONG TYPE** - stored as array/map instead of String
- `updatedAt`: ❌ **MISSING**
- `winnerID`: ❌ **MISSING**

**Issues Found**:
1. ❌ `status` field is stored as an array/map: `{0: "pending", 1: "accepted", 2: "completed", 3: "canceled", 4: "disputed"}`
   - Should be: Single String value like `"pending"`, `"accepted"`, `"completed"`, `"canceled"`, or `"disputed"`
2. ❌ Missing `updatedAt: Timestamp` field (required by spec)
3. ❌ Missing `winnerID: String?` field (optional, but should exist when game is completed)

**Fix Required**:
```
Change status from:
  status: {0: "pending", 1: "accepted", ...}

To:
  status: "pending" (single string value)

Add missing fields:
  updatedAt: Timestamp
  winnerID: String? (optional, only when completed)
```

---

### ⚠️ 5. MESSAGES Collection
**Status**: ⚠️ **MINOR ISSUES**

**Your Structure**:
- `gameID`: String ✅
- `senderID`: String ✅
- `senderName`: String ✅
- `text`: String ✅
- `timestamp`: Timestamp ✅
- `isRead`: Boolean ❌ **WRONG TYPE** - should be Map<String, Boolean>
- `userId`: String ❌ **EXTRA FIELD** - not in spec (redundant with senderID)

**Specification Requires**:
- `isRead`: Map<String, Boolean> where key is userId and value is isRead boolean
- Example: `isRead: {"user1": true, "user2": false}`

**Issues Found**:
1. ❌ `isRead` is stored as single Boolean, but should be a Map where each user's read status is tracked
2. ❌ Extra field `userId: ""` (empty string) - not needed (you have `senderID` already)

**Fix Required**:
```
Change:
  isRead: true (boolean)

To:
  isRead: {
    "senderUserId": true,
    "recipientUserId": false
  } (map/object)

Remove:
  userId: "" (not needed)
```

---

### ✅ 6. STATS Collection
**Status**: ✅ **CORRECT**

**Your Structure**:
- `wins`: Int ✅
- `losses`: Int ✅
- `currentStreak`: Int ✅
- `bestStreak`: Int ✅
- `totalGames`: Int ✅
- `rating`: Double ✅
- `lastGameDate`: Timestamp ✅

**Verdict**: Perfect match with specification. No issues.

---

### ❌ 7. REPORTS Collection
**Status**: ❌ **INCORRECT**

**Your Structure**:
- `createdAt`: Timestamp ✅
- `description`: String ✅
- `reason`: String ✅
- `reportedID`: String ✅
- `reporterID`: String ✅
- `status`: ❌ **WRONG TYPE** - stored as array/map instead of String

**Specification Requires**:
- `status`: String with values `"pending"`, `"reviewed"`, or `"resolved"`

**Issues Found**:
1. ❌ `status` field is stored as an array/map: `{0: "pending", 1: "reviewed", 2: "resolved"}`
   - Should be: Single String value like `"pending"`, `"reviewed"`, or `"resolved"`

**Fix Required**:
```
Change status from:
  status: {0: "pending", 1: "reviewed", 2: "resolved"}

To:
  status: "pending" (single string value)
```

---

### ❌ 8. BLOCKED Collection
**Status**: ❌ **INCORRECT STRUCTURE**

**Your Structure** (from screenshot):
- Collection: `blocked`
- Document: `UMZCdUhcTnKM3sinnb7S`
- Field: `createdAt: Timestamp`

**Specification Requires**:
```
blocked/{blockerId}/blocked/{blockedId}
  └── createdAt: Timestamp
```

**Correct Structure Should Be**:
- Collection: `blocked`
- Document: `{blockerId}` (user who is blocking)
- **Subcollection**: `blocked` (required nested collection)
- Document: `{blockedId}` (user being blocked)
- Field: `createdAt: Timestamp`

**Issues Found**:
1. ❌ Missing the nested subcollection structure
2. ❌ You have a flat structure instead of `blocked/{blockerId}/blocked/{blockedId}`

**Fix Required**:
```
Current (WRONG):
blocked/
  └── UMZCdUhcTnKM3sinnb7S/
      └── createdAt: Timestamp

Should Be (CORRECT):
blocked/
  └── {blockerUserId}/              ← Document with blocker's ID
      └── blocked/                  ← Subcollection (must be named "blocked")
          └── {blockedUserId}/     ← Document with blocked user's ID
              └── createdAt: Timestamp
```

**How to Fix**:
1. Delete the incorrect flat document
2. Create document with blocker's user ID
3. Inside that document, create subcollection named "blocked"
4. Inside subcollection, create document with blocked user's ID
5. Add `createdAt` field to that document

---

## Summary of All Issues

### Critical Issues (Must Fix):
1. ❌ **courts**: Wrong field structure (`coords` instead of `latitude`/`longitude`)
2. ❌ **games**: `status` wrong type (array instead of String), missing `updatedAt` and `winnerID`
3. ❌ **reports**: `status` wrong type (array instead of String)
4. ❌ **blocked**: Missing subcollection structure (flat instead of nested)
5. ❌ **profiles**: `location.coords` wrong format (should be `latitude`/`longitude` numbers)

### Minor Issues (Should Fix):
6. ⚠️ **messages**: `isRead` should be Map, not Boolean; extra `userId` field
7. ⚠️ **profiles**: Consider adding root-level `lastUpdated` (though location.lastUpdated works)

### Correct Collections:
- ✅ **users**: Perfect
- ✅ **stats**: Perfect

---

## Priority Fix Order

1. **HIGH PRIORITY** - Fix before writing any code:
   - `blocked` collection structure (code will fail without subcollection)
   - `games.status` (code expects String, not array)
   - `reports.status` (code expects String, not array)

2. **MEDIUM PRIORITY** - Fix before using these features:
   - `courts` latitude/longitude (code expects these fields)
   - `profiles.location` structure (code expects latitude/longitude numbers)
   - `games.updatedAt` and `games.winnerID` (code uses these)

3. **LOW PRIORITY** - Can fix later:
   - `messages.isRead` Map structure (code can be updated to handle Boolean, but Map is better)
   - Remove extra `messages.userId` field

