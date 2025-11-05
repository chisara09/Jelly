# Adding Test Targets to Xcode Project

Follow these step-by-step instructions to add test targets and test files to your Xcode project.

## Method 1: Using Xcode UI (Recommended)

### Step 1: Add a Test Target

1. **Open your project in Xcode**: `Jelly.xcodeproj`

2. **Add a Test Target**:
   - In Xcode, click on the project name in the Project Navigator (top item)
   - Select the project (not the target) in the editor
   - Click the **"+"** button at the bottom of the TARGETS list
   - Choose **"Unit Testing Bundle"** or **"Test Bundle"**
   - Click **Next**
   - Product Name: `JellyTests`
   - Bundle Identifier: `com.chisara.JellyTests` (should auto-populate)
   - Language: **Swift**
   - Leave "Include UI Tests" unchecked (we'll add integration tests separately if needed)
   - Click **Finish**

### Step 2: Add Test Files to the Test Target

1. **Select all test files in the Project Navigator**:
   - `Jelly/Tests/UnitTests/AuthenticationManagerTests.swift`
   - `Jelly/Tests/UnitTests/StatsManagerTests.swift`
   - `Jelly/Tests/UnitTests/GameManagerTests.swift`
   - `Jelly/Tests/IntegrationTests/FirebaseEmulatorConfig.swift`
   - `Jelly/Tests/IntegrationTests/FirebaseIntegrationTests.swift`
   - `Jelly/Tests/EndToEndTests/EndToEndFirebaseTests.swift`

2. **For each file**:
   - Select the file in Project Navigator
   - Open the **File Inspector** (right panel, or press `Cmd+Option+1`)
   - Under **"Target Membership"**, check the box for **`JellyTests`**
   - This adds the file to the test target

   **OR** Select multiple files at once (hold `Cmd` while clicking), then:
   - Right-click → **Show File Inspector**
   - Check **`JellyTests`** under Target Membership

### Step 3: Link Firebase Frameworks to Test Target

1. **Select the test target**:
   - Click on the project name in Project Navigator
   - Select **`JellyTests`** target
   - Go to **"Build Phases"** tab

2. **Add Firebase frameworks**:
   - Expand **"Link Binary With Libraries"**
   - Click **"+"** button
   - Add these frameworks (if not already present):
     - `FirebaseAuth.xcframework` (or `FirebaseAuth.framework`)
     - `FirebaseFirestore.xcframework`
     - `FirebaseCore.xcframework`
     - `FirebaseStorage.xcframework` (if needed)
   - Make sure they're set to **"Required"**

3. **Framework Search Paths** (SKIP THIS - Swift Package Manager handles it automatically):
   - If using Swift Package Manager (which you are), you can **ignore** the "Framework Search Paths" setting
   - SPM automatically manages framework paths
   - Leaving it empty is correct and expected

### Step 4: Configure Test Target Build Settings

1. **Select `JellyTests` target** → **Build Settings**

2. **Swift Compiler - Custom Flags** (usually already correct):
   - Search for **"Other Swift Flags"**
   - For Swift Package Manager projects, this is often **empty** (which is fine)
   - If you see errors, you can add `-enable-testing`, but it's usually not needed
   - **Note**: Your current empty setting is correct - modern Xcode handles this automatically

3. **Verify Product Bundle Identifier**:
   - Should be: `com.chisara.JellyTests` (already set ✓)

4. **Verify Deployment Target**:
   - Should match your main app target (iOS 26.0 - already set ✓)

5. **Verify Test Host** (should already be configured):
   - Should be: `$(BUILT_PRODUCTS_DIR)/Jelly.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Jelly`

### Step 5: Enable Test Host (if needed)

1. **Select `JellyTests` target** → **Build Settings**
2. Search for **"Test Host"**
3. Set to: `$(BUILT_PRODUCTS_DIR)/Jelly.app/Jelly`
4. Set **"Bundle Loader"** to: `$(TEST_HOST)`

### Step 6: Verify Test Files Can Access App Code

For test files to access your app's classes, they need to be able to import them:

1. **Select your app target** (`Jelly`) → **Build Settings**
2. Search for **"Defines Module"**
3. Set to **"Yes"**
4. Search for **"Product Module Name"**
5. Should be `Jelly` (default)

In your test files, you should have:
```swift
@testable import Jelly
```

### Step 7: Run Tests

1. Press **`Cmd+U`** to run all tests
2. Or use **Product → Test** from the menu
3. Or click the **diamond icon** next to individual test methods

## Method 2: Using Xcode Command Line (Advanced)

You can also add files using command line, but it's more complex. The UI method above is recommended.

## Troubleshooting

### Issue: "No such module 'Jelly'"
- **Solution**: Make sure `@testable import Jelly` is at the top of test files
- Verify "Defines Module" is set to "Yes" in app target
- Clean build folder: `Product → Clean Build Folder` (`Cmd+Shift+K`)

### Issue: "Cannot find type 'AuthenticationManager'"
- **Solution**: Verify test files are added to the test target
- Check that `@testable import Jelly` is present
- Rebuild the project

### Issue: Firebase frameworks not found
- **Solution**: Make sure Firebase packages are linked to test target
- Go to project settings → Package Dependencies
- Verify Firebase packages are added
- Check test target has access to them

### Issue: Tests don't run
- **Solution**: 
  - Verify test target is selected in scheme
  - Check scheme settings: `Product → Scheme → Edit Scheme → Test`
  - Ensure test target is checked

## Verification Checklist

After setup, verify:

- [ ] Test target `JellyTests` exists
- [ ] All test files are added to test target (check Target Membership)
- [ ] Firebase frameworks are linked to test target
- [ ] `@testable import Jelly` is in test files
- [ ] App target has "Defines Module" = "Yes"
- [ ] Tests can be run (`Cmd+U`)
- [ ] Individual tests show diamond icons in code editor

## Quick Reference: Keyboard Shortcuts

- `Cmd+U`: Run all tests
- `Cmd+Option+U`: Run tests for current scheme
- `Cmd+Option+1`: Show File Inspector
- `Cmd+Shift+K`: Clean Build Folder
- `Cmd+B`: Build project

## Next Steps

Once test targets are set up:
1. Run unit tests first (they don't need Firebase)
2. Set up Firebase Emulator Suite for integration tests
3. Configure environment variable `USE_FIREBASE_EMULATOR=YES` for emulator tests
4. See `Tests/README.md` for running different test types
