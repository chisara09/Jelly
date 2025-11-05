# Fix: Test Files in Wrong Target

## Problem
Your test files are currently included in **both** the main app target (`Jelly`) and the test target (`JellyTests`). This causes warnings like:
- `File 'AuthenticationManagerTests.swift' is part of module 'Jelly'; ignoring import @testable import Jelly`

## Solution: Remove Test Files from Main App Target

### Method 1: File Inspector (Recommended)

1. **Select all test files** in Project Navigator:
   - Hold `Cmd` and click each test file:
     - `Tests/UnitTests/AuthenticationManagerTests.swift`
     - `Tests/UnitTests/StatsManagerTests.swift`
     - `Tests/UnitTests/GameManagerTests.swift`
     - `Tests/IntegrationTests/FirebaseEmulatorConfig.swift`
     - `Tests/IntegrationTests/FirebaseIntegrationTests.swift`
     - `Tests/EndToEndTests/EndToEndFirebaseTests.swift`

2. **Open File Inspector**:
   - Press `Cmd+Option+1` (or View → Inspectors → File Inspector)

3. **Remove from main target**:
   - Under **"Target Membership"**, you should see two checkboxes:
     - `Jelly` ← **UNCHECK THIS**
     - `JellyTests` ← **KEEP THIS CHECKED**
   
4. **Verify**:
   - Only `JellyTests` should be checked for all test files
   - The main app target (`Jelly`) should NOT be checked

### Method 2: Build Phases

1. **Select `Jelly` target** (main app target)
2. Go to **"Build Phases"** tab
3. Expand **"Compile Sources"**
4. Find and **remove** (select and press `-` button):
   - `AuthenticationManagerTests.swift`
   - `StatsManagerTests.swift`
   - `GameManagerTests.swift`
   - `FirebaseEmulatorConfig.swift`
   - `FirebaseIntegrationTests.swift`
   - `EndToEndFirebaseTests.swift`

5. **Verify**:
   - Select `JellyTests` target → Build Phases → Compile Sources
   - All test files should be listed there

## After Fixing

1. **Clean Build Folder**: `Product → Clean Build Folder` (`Cmd+Shift+K`)
2. **Build**: `Product → Build` (`Cmd+B`)
3. **Run Tests**: `Cmd+U`

The warnings should disappear and `@testable import Jelly` should work correctly.

## Verification

✅ Test files show diamond icons (◇) next to test methods
✅ No warnings about "File is part of module 'Jelly'"
✅ Tests can access app code via `@testable import Jelly`
✅ Tests run successfully (`Cmd+U`)
