# GitHub Workflow Setup - Combined Memory

## 🎯 Overview

This setup makes **GitHub the single source of truth** for your LibreChat configuration. Any changes pushed to GitHub automatically deploy to Railway.

## 🔐 Secrets Protection

### .gitignore Configuration
The following files are protected from accidental commits:
- `.env` and `.env.local` - Environment variables with API keys
- `*.p8` - Apple authentication keys
- `.mcp-auth/` - MCP authentication tokens
- Backup files (`*.backup`, `*.bak`)

### Pre-Commit Hook
A local pre-commit hook (`.githooks/pre-commit`) checks for:
- Sensitive files (.env, .p8)
- API keys in file contents
- Prevents accidental secret exposure

**Activate the hook:**
```bash
git config core.hooksPath .githooks
```

## 🤖 GitHub Actions

### 1. Auto Commit Workflow (`.github/workflows/auto-commit.yml`)
- Triggers on push to main branch
- Checks for uncommitted changes
- Auto-commits and pushes changes
- Can be manually triggered via GitHub UI

### 2. Watch Local Changes (`.github/workflows/watch-local-changes.yml`)
- Runs every 15 minutes via cron schedule
- Pulls latest changes from main
- Auto-commits any new local changes
- Syncs your repository automatically

**Note**: This workflow runs on GitHub servers, not locally. For local file watching, use the watch script below.

## 📂 Local File Watcher

### watch-and-commit.sh
Monitors local file changes and auto-commits to GitHub.

**Start the watcher:**
```bash
./watch-and-commit.sh
```

**Run in background:**
```bash
nohup ./watch-and-commit.sh > watcher.log 2>&1 &
```

**Stop the watcher:**
```bash
pkill -f watch-and-commit.sh
```

**Monitored files:**
- `librechat.yaml`
- `docker-compose.override.yml`
- `client/public/assets/*`
- `client/index.html`
- `client/src/components/Auth/AuthLayout.tsx`

**Requirements:**
```bash
brew install fswatch  # Optional, for instant file detection
```

## 🚀 Workflow Summary

1. **Local Changes** → Edit files on your machine
2. **Auto-Commit** → watch-and-commit.sh detects changes
3. **Push to GitHub** → Changes pushed to main branch
4. **Railway Deploy** → Railway auto-deploys from GitHub
5. **Live Update** → https://chat.combinedmemory.com updated

## 🛠️ Manual Operations

### Commit and push manually:
```bash
git add -A
git commit -m "Update configuration"
git push origin main
```

### Check watcher status:
```bash
ps aux | grep watch-and-commit
```

### View watcher logs:
```bash
tail -f watcher.log
```

## ⚠️ Important Notes

1. **Never commit .env files** - They're blocked by .gitignore and pre-commit hook
2. **GitHub is the source of truth** - Railway deploys from main branch
3. **Local Docker syncs from repository** - Volume mounts reflect git-tracked files
4. **Railway auto-deploys on push** - Usually takes 2-3 minutes

## 🔗 Railway Integration

Railway watches the main branch and automatically:
- Builds the Docker image
- Deploys to production
- Updates https://chat.combinedmemory.com

**Railway dashboard:** https://railway.app/project/[your-project-id]

## 📋 Checklist

- [x] .gitignore configured for secrets
- [x] Pre-commit hook installed
- [x] GitHub Actions workflows created
- [x] Local file watcher script ready
- [ ] fswatch installed (optional)
- [ ] Watcher script running in background
- [ ] Test workflow by making a config change
