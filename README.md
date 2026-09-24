# 🕐 Claude Session Tracker

**Real-time monitoring of your Claude Code 5-hour usage blocks with live notifications and menu bar integration.**

---

## 🎯 What It Does

Claude Session Tracker monitors your active Claude sessions in real-time and:

- ✅ **Automatically detects** when you start using Claude
- ⏰ **Tracks elapsed time** from your first message
- 🔔 **Sends notifications** at key milestones (30min, 10min, session end)
- 📊 **Shows live countdown** in menu bar (optional)
- 📈 **Provides usage statistics** and session history
- 🔄 **Auto-starts on boot** via macOS LaunchAgent

---

## 🆚 What Changed from v1.0

### Old Approach (Future Scheduler) ❌
- Scheduled FUTURE sessions in Calendar.app
- Required manual planning ahead
- No tracking of ACTUAL usage
- Calendar-based notifications

### New Approach (Real-Time Tracker) ✅
- Monitors ACTIVE sessions in real-time
- Automatic detection via file watching
- Tracks actual time elapsed
- Smart milestone notifications
- Menu bar countdown widget
- Usage analytics

---

## 📦 Installation

### Quick Install

```bash
git clone https://github.com/Organized-AI/cc-session-manager.git
cd cc-session-manager
bash setup.sh
```

The installer will:
1. Create `~/.claude-session-tracker/` directory
2. Install Python dependencies
3. Set up auto-start (LaunchAgent)
4. Create `claude-session` command-line tool
5. Start monitoring in background

### Manual Install

```bash
# Install dependencies
pip3 install -r requirements.txt --break-system-packages

# Copy files
mkdir -p ~/.claude-session-tracker
cp -r src ~/.claude-session-tracker/

# Make executable
chmod +x ~/.claude-session-tracker/src/*.py

# Create CLI link
sudo ln -s ~/.claude-session-tracker/src/cli.py /usr/local/bin/claude-session
```

---

## 🚀 Usage

### Automatic Monitoring (Recommended)

The session monitor runs automatically in the background. It detects Claude activity by watching:
- `/Users/YOUR_USERNAME/Library/Application Support/Claude/IndexedDB/`
- `/Users/YOUR_USERNAME/Library/Caches/com.anthropic.claudefordesktop/`

When you start using Claude, it automatically:
1. Detects first message = session start
2. Begins tracking elapsed time
3. Sends notification: "🟢 Session started!"

### Manual Control (Backup Method)

Use the CLI if automatic detection isn't working:

```bash
# Start tracking manually
claude-session start

# Check current status
claude-session status

# View statistics
claude-session stats

# End current session
claude-session stop

# View history
claude-session history
```

### Menu Bar Widget (Optional)

For a persistent countdown display:

```bash
python3 ~/.claude-session-tracker/src/menu_bar.py &
```

The menu bar shows:
- 🕐 Claude: 3h 45m (green, >1 hour remaining)
- ⏰ Claude: 42m (yellow, <1 hour remaining)
- ⚠️ Claude: 7m (red, <10 minutes remaining)
- 🔴 Claude: Ended (session expired)
- 🟢 Claude: Ready! (new block available)

---

## 🔔 Notification Timeline

```
Timeline View:
═══════════════════════════════════════════════════════════

0:00    🟢 "Session started"
│       └─> Shows: "5 hours available"
│
├── Working...
│
│
4:30    ⏰ "30 minutes remaining"
│       └─> Shows: "Session ends at 7:00 PM"
│              "Save important conversations"
│       
├── Wrapping up...
│
│
4:50    ⚠️  "10 minutes remaining"
│       └─> Shows: "Wrap up your work"
│              "Next block available after 7:00 PM"
│
├── Final minutes...
│
│
5:00    🔴 "Session ended"
│       └─> Shows: "5-hour limit reached"
│              "New session available now"
│
│
5:00+   🟢 "New block ready!"
        └─> Shows: "Fresh 5-hour session available"

═══════════════════════════════════════════════════════════
```

---

## 📊 Statistics & Analytics

### Daily Stats

```bash
claude-session stats
```

Output:
```
📊 Daily Statistics
   Sessions:     3
   Total Time:   12h 35m
   Average:      4h 11m
   Messages:     247
   Tokens:       67,234

📝 Recent Sessions
   🟢 10/23 02:00 PM - 4h 45m
   🔴 10/23 08:00 AM - 3h 20m
   🔴 10/22 02:00 PM - 5h 0m
```

### Session History

```bash
claude-session history
```

Shows detailed breakdown of all sessions including:
- Start time
- Duration
- Message count
- Token count (if manually tracked)
- Status (active/ended)

---

## 🔧 Configuration

### Machine-Specific Paths

The tracker automatically detects your machine and uses the correct paths:

**MacBook M1 Pro** (`/Users/supabowl`):
- Application Support: `/Users/supabowl/Library/Application Support/Claude/`
- Cache: `/Users/supabowl/Library/Caches/com.anthropic.claudefordesktop/`

**M4 Mac Mini** (`/Users/jordaaan`):
- Application Support: `/Users/jordaaan/Library/Application Support/Claude/`
- Cache: `/Users/jordaaan/Library/Caches/com.anthropic.claudefordesktop/`

### Custom Configuration

Edit `~/.claude-session-tracker/config.yaml` (optional):

```yaml
session_duration: 18000  # 5 hours in seconds
check_interval: 60       # Check every 60 seconds
log_level: INFO          # DEBUG, INFO, WARNING, ERROR

notifications:
  enabled: true
  warnings: [1800, 600]  # 30min, 10min in seconds
  sound: Glass           # macOS notification sound
```

---

## 📁 File Structure

```
cc-session-manager/
├── README.md                   # This file
├── SKILL.md                    # MCP skill documentation
├── requirements.txt            # Python dependencies
├── setup.sh                    # Installation script
│
├── src/
│   ├── __init__.py
│   ├── session_monitor.py      # Main background daemon
│   ├── session_state.py        # SQLite database manager
│   ├── notification_manager.py # Notification system
│   ├── menu_bar.py             # rumps menu bar widget
│   └── cli.py                  # Command-line interface
│
└── resources/
    ├── QUICKSTART.md
    └── ARCHITECTURE.md
```

---

## 🗄️ Data Storage

All data is stored locally in `~/.claude-session-tracker/`:

- `sessions.db` - SQLite database with session history
- `logs/monitor.log` - Activity logs
- `logs/monitor-error.log` - Error logs

### Database Schema

**sessions** table:
- `id` - Session ID
- `start_time` - When session started
- `end_time` - When session ended
- `last_activity` - Last detected activity
- `duration_seconds` - Total elapsed time
- `token_count` - Tokens used (if tracked)
- `message_count` - Messages sent
- `status` - 'active' or 'ended'

**notifications** table:
- `id` - Notification ID
- `session_id` - Related session
- `notification_type` - Type (30_min, 10_min, ended, etc.)
- `sent_at` - When notification was sent

---

## 🐛 Troubleshooting

### Monitor Not Starting

```bash
# Check if LaunchAgent is loaded
launchctl list | grep claude-session-tracker

# View logs
tail -f ~/.claude-session-tracker/logs/monitor.log

# Manually restart
launchctl unload ~/Library/LaunchAgents/ai.organized.claude-session-tracker.plist
launchctl load ~/Library/LaunchAgents/ai.organized.claude-session-tracker.plist
```

### Notifications Not Appearing

```bash
# Test notification system
osascript -e 'display notification "Test" with title "Claude Tracker"'

# Check notification permissions
# System Preferences → Notifications → Terminal/Python
```

### Activity Not Detected

```bash
# Verify paths exist
ls -la ~/Library/Application\ Support/Claude/IndexedDB/
ls -la ~/Library/Caches/com.anthropic.claudefordesktop/

# Use manual mode instead
claude-session start
```

---

## 🔄 Updating

```bash
cd cc-session-manager
git pull
bash setup.sh
```

The installer preserves your database and configuration.

---

## 🗑️ Uninstallation

```bash
# Stop and remove LaunchAgent
launchctl unload ~/Library/LaunchAgents/ai.organized.claude-session-tracker.plist
rm ~/Library/LaunchAgents/ai.organized.claude-session-tracker.plist

# Remove files
rm -rf ~/.claude-session-tracker
rm /usr/local/bin/claude-session
```

Your session history will be permanently deleted.

---

## 🤝 Contributing

This is part of the [Organized AI](https://github.com/Organized-AI) project ecosystem.

---

## 📝 License

MIT License - See LICENSE file for details

---

## ✨ Credits

Created by [Organized AI](https://github.com/Organized-AI) for optimal Claude Code usage tracking.

**Version:** 2.0.0 (Real-Time Tracker)  
**Previous:** 1.0.0 (Future Scheduler)

---

Maintained by Jordaaan Hill ([LinkedIn](https://www.linkedin.com/in/jordaaanhill)).
