# Testing Guide for Jelly App

This directory contains all tests for the Jelly app, organized by test type.

## Test Structure

```
Tests/
├── UnitTests/              # Unit tests with mock data
│   ├── AuthenticationManagerTests.swift
│   ├── StatsManagerTests.swift
│   └── GameManagerTests.swift
│
├── IntegrationTests/       # Integration tests with Firebase Emulators
│   ├── FirebaseEmulatorConfig.swift
│   └── FirebaseIntegrationTests.swift
│
└── EndToEndTests/          # End-to-end flow tests
    └── EndToEndFirebaseTests.swift
```

## Running Tests

### Unit Tests (No Firebase Required)

Unit tests use mock data and don't require Firebase to be running.

**In Xcode:**
1. Select the test target
2. Press `Cmd+U` or go to Product > Test
3. Or run individual tests by clicking the diamond icon next to each test

**Command Line:**
```bash
xcodebuild test -scheme Jelly -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Integration Tests (Requires Firebase Emulator Suite)

Integration tests require Firebase Emulator Suite to be running.

#### Prerequisites

1. Install Node.js (if not already installed)
2. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
3. Login to Firebase:
   ```bash
   firebase login
   ```

#### Setting Up Emulators

1. Initialize Firebase Emulators (if not already done):
   ```bash
   firebase init emulators
   ```
   Select:
   - Authentication Emulator
   - Firestore Emulator
   - (Optional) Storage Emulator

2. Start Emulators:
   ```bash
   firebase emulators:start
   ```
   This will start emulators and open the Emulator Suite UI at http://localhost:4000

#### Configure iOS App to Use Emulators

**Option 1: Environment Variable (Recommended)**

1. In Xcode, go to **Product > Scheme > Edit Scheme**
2. Select **Run > Arguments**
3. Add Environment Variable:
   - Name: `USE_FIREBASE_EMULATOR`
   - Value: `YES`

**Option 2: Build Settings**

Add to your Debug build configuration:
- `USE_FIREBASE_EMULATOR=YES`

#### Running Integration Tests

1. **Start Firebase Emulators:**
   ```bash
   firebase emulators:start
   ```

2. **In Xcode:**
   - Select the test target
   - Press `Cmd+U` or go to Product > Test
   - Integration tests will automatically use emulators when `USE_FIREBASE_EMULATOR=YES` is set

3. **Command Line:**
   ```bash
   # Terminal 1: Start emulators
   firebase emulators:start
   
   # Terminal 2: Run tests
   xcodebuild test -scheme Jelly -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

### End-to-End Tests (Requires Firebase Emulator Suite)

End-to-end tests test complete user flows and require Firebase Emulator Suite.

**Setup:**
1. Follow the same setup as Integration Tests above
2. Start Firebase Emulators: `firebase emulators:start`

**Running:**
- Same as Integration Tests above
- Or run the specific test class in Xcode

## Test Coverage

### Unit Tests
- ✅ Authentication validation logic
- ✅ Email/password validation
- ✅ ELO rating calculations
- ✅ Stats update logic
- ✅ Game filtering and status transitions
- ✅ Business logic with mock data

### Integration Tests
- ✅ Sign up flow
- ✅ Login flow
- ✅ Profile management
- ✅ Stats retrieval and updates
- ✅ Firebase Firestore operations
- ✅ Firebase Auth operations

### End-to-End Tests
- ✅ Complete game flow: Sign up → Challenge → Accept → Chat → Score → Confirm → Leaderboard
- ✅ Dispute flow: Score mismatch handling
- ✅ Multi-user interactions
- ✅ Real-time updates
- ✅ Stats and leaderboard updates

## Troubleshooting

### Emulators Not Running
If you see errors like "Connection refused" or "Emulator not found":
1. Check that emulators are running: `firebase emulators:start`
2. Verify environment variable is set: `USE_FIREBASE_EMULATOR=YES`
3. Check emulator ports (default: Firestore 8080, Auth 9099)

### Tests Timing Out
- Increase timeout values in test methods
- Check network connectivity
- Verify Firebase initialization completed before tests run

### Clean Emulator Data
To start fresh between test runs:
```bash
firebase emulators:start --clear
```

### Export/Import Test Data
```bash
# Export current emulator data
firebase emulators:export ./test-data

# Import test data
firebase emulators:start --import=./test-data
```

## Continuous Integration

For CI/CD pipelines:

1. Install Firebase CLI in CI environment
2. Start emulators in background:
   ```bash
   firebase emulators:start --only firestore,auth
   ```
3. Set environment variable: `USE_FIREBASE_EMULATOR=YES`
4. Run tests: `xcodebuild test ...`
5. Stop emulators after tests complete

## Best Practices

1. **Unit Tests**: Fast, isolated, no external dependencies
2. **Integration Tests**: Test actual Firebase operations with emulators
3. **End-to-End Tests**: Test complete user flows, use sparingly (slower)
4. **Mock Data**: Only in unit tests, never in integration/E2E tests
5. **Clean Up**: Always clean up test data between runs
6. **Isolation**: Each test should be independent and not rely on others

## Resources

- [Firebase Emulator Suite Documentation](https://firebase.google.com/docs/emulator-suite)
- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Firebase iOS SDK](https://firebase.google.com/docs/ios/setup)
