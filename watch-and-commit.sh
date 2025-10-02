#!/bin/bash

# Local file watcher for auto-committing changes
# Run this script in the background to automatically commit local changes

WATCH_DIR="/Users/quinnmay/librechat-app"
WATCH_FILES="librechat.yaml docker-compose.override.yml client/public/assets client/index.html client/src/components/Auth/AuthLayout.tsx"

echo "🔍 Watching for changes in $WATCH_DIR"
echo "📂 Monitoring: $WATCH_FILES"
echo ""

# Function to commit changes
commit_changes() {
    cd "$WATCH_DIR" || exit 1

    # Check if there are any changes
    if [[ -z $(git status --porcelain) ]]; then
        return
    fi

    echo "📝 Changes detected! Committing..."

    # Add all changes
    git add -A

    # Commit with timestamp
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-commit: Configuration update $TIMESTAMP"

    # Push to GitHub
    echo "⬆️  Pushing to GitHub..."
    git push origin main

    if [ $? -eq 0 ]; then
        echo "✅ Successfully pushed changes to GitHub!"
        echo "🚀 Railway will auto-deploy in a few moments..."
    else
        echo "❌ Failed to push changes. Please check your git configuration."
    fi

    echo ""
}

# Initial check
commit_changes

# Watch for file changes using fswatch (install with: brew install fswatch)
if command -v fswatch &> /dev/null; then
    echo "👀 Using fswatch to monitor file changes..."
    fswatch -o $WATCH_FILES | while read -r num; do
        echo "🔔 File change detected at $(date +'%H:%M:%S')"
        sleep 5  # Wait 5 seconds to batch changes
        commit_changes
    done
else
    echo "⚠️  fswatch not found. Install with: brew install fswatch"
    echo "📌 Falling back to polling every 60 seconds..."

    while true; do
        sleep 60
        commit_changes
    done
fi
