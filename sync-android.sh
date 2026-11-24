#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

APP="$HOME/yousivar-ai-content-studio/apps/studio"

echo "========================================"
echo " YOUSIVAR - ANDROID SYNC"
echo "========================================"

cd "$APP"

echo "[1/4] Building React application..."
npm run build

echo "[2/4] Checking Android platform..."
if [ ! -d android ]; then
  echo "ERROR: Android platform not found."
  echo "Run repair-capacitor.sh first."
  exit 1
fi

echo "[3/4] Locating Capacitor CLI..."
CAP_TARGET="$(node -e '
const p = require("./node_modules/@capacitor/cli/package.json");
const b = typeof p.bin === "string" ? p.bin : p.bin.cap;
console.log(require("path").resolve("node_modules/@capacitor/cli", b));
')"

echo "[4/4] Synchronizing Android..."
node "$CAP_TARGET" sync android

echo
echo "========================================"
echo " ANDROID SYNC COMPLETED"
echo "========================================"
echo "Android project: $APP/android"
