#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

APP="$HOME/yousivar-ai-content-studio/apps/studio"

echo "========================================"
echo " YOUSIVAR - CAPACITOR REPAIR"
echo "========================================"

cd "$APP"

echo "[1/7] Checking web build..."
test -f dist/index.html || {
  echo "ERROR: dist/index.html missing. Run npm run build first."
  exit 1
}

echo "[2/7] Installing Capacitor packages..."
npm install @capacitor/core@^8 @capacitor/android@^8
npm install -D @capacitor/cli@^8

echo "[3/7] Checking Capacitor CLI..."
node -e '
const p = require("./node_modules/@capacitor/cli/package.json");
console.log("Capacitor CLI:", p.version);
console.log("Binary:", JSON.stringify(p.bin));
'

echo "[4/7] Locating CLI executable..."
CAP_TARGET="$(node -e '
const p = require("./node_modules/@capacitor/cli/package.json");
const b = typeof p.bin === "string" ? p.bin : p.bin.cap;
if (!b) process.exit(2);
console.log(require("path").resolve("node_modules/@capacitor/cli", b));
')"

test -f "$CAP_TARGET" || {
  echo "ERROR: Capacitor executable not found: $CAP_TARGET"
  exit 1
}

echo "[5/7] Fixing Termux executable path..."
if head -n 1 "$CAP_TARGET" | grep -q '/usr/bin/env'; then
  sed -i '1s|^#!/usr/bin/env node$|#!/data/data/com.termux/files/usr/bin/env node|' "$CAP_TARGET"
fi

echo "[6/7] Testing CLI..."
node "$CAP_TARGET" --version

echo "[7/7] Adding Android platform..."
if [ ! -d android ]; then
  node "$CAP_TARGET" add android
else
  echo "Android platform already exists. Skipping add."
fi

echo
echo "========================================"
echo " CAPACITOR REPAIR COMPLETED"
echo "========================================"
echo "Project: $APP"
echo "Android: $APP/android"
echo
echo "Next command:"
echo "bash ~/yousivar-ai-content-studio/sync-android.sh"
