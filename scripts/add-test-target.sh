#!/bin/bash

# Script to add test files to Xcode project
# This is a helper script - you may still need to manually configure some settings in Xcode

set -e

PROJECT_PATH="Jelly.xcodeproj"
SCHEME_NAME="Jelly"

echo "📦 Adding test files to Xcode project..."

# Find test files
TEST_FILES=(
    "Jelly/Tests/UnitTests/AuthenticationManagerTests.swift"
    "Jelly/Tests/UnitTests/StatsManagerTests.swift"
    "Jelly/Tests/UnitTests/GameManagerTests.swift"
    "Jelly/Tests/IntegrationTests/FirebaseEmulatorConfig.swift"
    "Jelly/Tests/IntegrationTests/FirebaseIntegrationTests.swift"
    "Jelly/Tests/EndToEndTests/EndToEndFirebaseTests.swift"
)

# Check if project exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Error: Xcode project not found at $PROJECT_PATH"
    exit 1
fi

echo "✅ Found Xcode project"
echo ""
echo "⚠️  Note: This script provides a starting point."
echo "   You'll still need to:"
echo "   1. Add a Test Target in Xcode (if it doesn't exist)"
echo "   2. Add these files to the test target"
echo "   3. Link Firebase frameworks to the test target"
echo ""
echo "See instructions in Jelly/Tests/README.md for detailed steps."
echo ""

# Check which files exist
echo "Checking test files..."
for file in "${TEST_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "Next steps:"
echo "1. Open Jelly.xcodeproj in Xcode"
echo "2. Follow the manual instructions below to add test target"
echo ""
