#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="$HOME/yousivar-ai-content-studio"
APP="$ROOT/apps/studio"
WORKFLOW="$ROOT/.github/workflows"

echo "========================================"
echo " YOUSIVAR - GITHUB ANDROID BUILDER"
echo "========================================"

cd "$ROOT"

if [ ! -f "$APP/package.json" ]; then
  echo "ERROR: Studio package.json not found."
  exit 1
fi

if [ ! -d "$APP/android" ]; then
  echo "ERROR: Android platform not found."
  echo "Run repair-capacitor.sh first."
  exit 1
fi

mkdir -p "$WORKFLOW"

cat > "$WORKFLOW/android-apk.yml" <<'YAML'
name: YOUSIVAR Android APK

on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths:
      - 'apps/studio/**'
      - '.github/workflows/android-apk.yml'

permissions:
  contents: read

jobs:
  build-android:
    name: Build Android APK
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: apps/studio/package-lock.json

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '21'

      - name: Setup Android SDK
        uses: android-actions/setup-android@v3

      - name: Install Node dependencies
        working-directory: apps/studio
        run: npm ci

      - name: Build web application
        working-directory: apps/studio
        run: npm run build

      - name: Sync Capacitor Android
        working-directory: apps/studio
        run: npx cap sync android

      - name: Build Debug APK
        working-directory: apps/studio/android
        run: |
          chmod +x gradlew
          ./gradlew --no-daemon assembleDebug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: YOUSIVAR-Android-Debug
          path: apps/studio/android/app/build/outputs/apk/debug/app-debug.apk
          if-no-files-found: error
          retention-days: 14
YAML

echo
echo "========================================"
echo " GITHUB WORKFLOW CREATED"
echo "========================================"
echo "$WORKFLOW/android-apk.yml"
echo
echo "Next: push the project to GitHub."
