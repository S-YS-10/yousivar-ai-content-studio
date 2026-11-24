#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="$HOME/yousivar-ai-content-studio"
REPO="https://github.com/S-YS-10/yousivar-ai-content-studio.git"

cd "$ROOT"

echo "======================================"
echo " YOUSIVAR - GITHUB CONNECTION"
echo "======================================"

# Initialize Git if necessary
if [ ! -d .git ]; then
    echo "[1/6] Initializing Git..."
    git init
else
    echo "[1/6] Existing Git repository detected."
fi

# Set main branch
git branch -M main

# Configure new remote
if git remote get-url origin >/dev/null 2>&1; then
    echo "[2/6] Updating origin..."
    git remote set-url origin "$REPO"
else
    echo "[2/6] Adding origin..."
    git remote add origin "$REPO"
fi

# Verify remote
echo "[3/6] Verifying remote..."
git remote -v

# Add files
echo "[4/6] Adding project files..."
git add .

# Commit only if changes exist
if ! git diff --cached --quiet; then
    git commit -m "Initialize YOUSIVAR AI Content Studio"
else
    echo "No new changes to commit."
fi

# Push without force
echo "[5/6] Pushing to GitHub..."
git push -u origin main

echo "[6/6] Completed."

echo "======================================"
echo " GITHUB CONNECTION SUCCESSFUL"
echo "======================================"
echo "$REPO"
