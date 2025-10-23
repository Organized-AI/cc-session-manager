# Claude Session Tracker Skill

**Real-time monitoring and management of Claude Code 5-hour usage blocks.**

---

## Purpose

This skill enables real-time tracking of Claude session usage with automatic notifications, menu bar countdown, and usage analytics. Unlike traditional calendar-based schedulers, this tool monitors ACTIVE sessions as they happen.

---

## Key Capabilities

### 1. **Automatic Session Detection**
- Watches Claude's IndexedDB files for activity
- Detects first message = session start
- No manual intervention required

### 2. **Real-Time Tracking**
- Calculates elapsed time from first message
- Computes remaining time (5 hours - elapsed)
- Updates every 60 seconds

### 3. **Smart Notifications**
- 🟢 Session start: "5 hours available"
- ⏰ 30 minutes remaining
- ⚠️ 10 minutes remaining
- 🔴 Session ended
- 🟢 New block ready

### 4. **Menu Bar Widget** (Optional)
- Live countdown display
- Click for detailed stats
- Color-coded status indicators

### 5. **Usage Analytics**
- Daily/weekly/monthly statistics
- Session history
- Token and message tracking

---

## Installation

### For Users

```bash
git clone https://github.com/Organized-AI/cc-session-manager.git
cd cc-session-manager
bash setup.sh
```

### For Claude (via MCP)

This skill can be integrated as an MCP tool to provide session awareness:

```python
# MCP Tool: check_session_status
def check_session_status():
    """Get current Claude session status"""
    state = SessionStateManager()
    session = state.get_active_session()
    
    if not session:
        return {"status": "inactive", "message": "No active session"}
    
    elapsed = (datetime.now() - session['start_time']).total_seconds()
    remaining = 18000 - elapsed
    
    return {
        "status": "active",
        "elapsed_seconds": elapsed,
        "remaining_seconds": remaining,
        "elapsed_readable": format_time(elapsed),
        "remaining_readable": format_time(remaining)
    }
```

---

## How It Works

### Detection Method

The tracker monitors file system changes in:
```
/Users/USERNAME/Library/Application Support/Claude/IndexedDB/
```

When Claude's IndexedDB files are modified:
1. Timestamp is recorded
2. Session state is checked
3. If new session → start tracking
4. If existing → update activity

### Session State Machine

```
┌─────────────┐
│  INACTIVE   │
│  (Ready)    │
└─────┬───────┘
      │
      │ File Activity Detected
      ↓
┌─────────────┐
│   ACTIVE    │
│  (Tracking) │────────┐ 5 hours elapsed
└─────┬───────┘        │
      │                ↓
      │           ┌─────────────┐
      │           │   ENDED     │
      └───────────│ (New Block  │
   Resume         │  Available) │
                  └─────────────┘
```

### Notification Logic

```python
def should_notify(remaining_seconds, notification_type):
    # 30-minute warning: 29.5-30.5 min window
    if notification_type == '30_min':
        return 1770 <= remaining_seconds <= 1830
    
    # 10-minute warning: 9.5-10.5 min window
    if notification_type == '10_min':
        return 570 <= remaining_seconds <= 630
    
    # Session ended
    if notification_type == 'ended':
        return remaining_seconds <= 0
```

---

## Usage Examples

### 1. Automatic Mode (Default)

Just use Claude normally. The tracker detects activity automatically:

```
User types first message
    ↓
Tracker detects IndexedDB modification
    ↓
Session starts automatically
    ↓
Notification: "🟢 Session started! 5 hours available"
```

### 2. Manual Control

```bash
# Start session manually
claude-session start

# Check status anytime
claude-session status
# Output:
# 🕐 Active Session
#    Started:    02:00 PM
#    Elapsed:    3h 45m
#    Remaining:  1h 15m

# View daily stats
claude-session stats

# End session early
claude-session stop
```

### 3. Menu Bar Widget

```bash
# Start menu bar app
python3 ~/.claude-session-tracker/src/menu_bar.py &

# Shows in menu bar:
# 🕐 Claude: 1h 15m

# Click for details:
# - Session start time
# - Elapsed/remaining time
# - Token usage
# - Message count
```

---

## Integration with Claude Workflows

### Prompt-Based Awareness

When this skill is active, Claude can reference session status in responses:

```
User: "How much time do we have left?"

Claude: "Based on the session tracker, we have approximately 
1 hour and 15 minutes remaining in this 5-hour block. 
This should be plenty of time to complete the task."
```

### Automatic Warnings

Claude can proactively mention time constraints:

```
User: "Let's refactor the entire codebase"

Claude: "I notice we have less than 30 minutes remaining 
in this session. Would you like to:
1. Focus on the most critical refactoring first
2. Save this for a fresh 5-hour block
3. Continue and wrap up what we can"
```

---

## Configuration

### Default Settings

```yaml
# ~/.claude-session-tracker/config.yaml

session_duration: 18000  # 5 hours
check_interval: 60       # Check every 60 seconds
log_level: INFO

notifications:
  enabled: true
  warnings: [1800, 600]  # 30min, 10min
  sound: Glass

paths:
  macbook:
    username: supabowl
    indexeddb: "/Users/supabowl/Library/Application Support/Claude/IndexedDB/"
  
  mac_mini:
    username: jordaaan
    indexeddb: "/Users/jordaaan/Library/Application Support/Claude/IndexedDB/"
```

---

## Technical Architecture

### Components

1. **session_monitor.py** - Background daemon using watchdog
2. **session_state.py** - SQLite state management
3. **notification_manager.py** - macOS notification system
4. **menu_bar.py** - rumps menu bar widget
5. **cli.py** - Command-line interface

### Data Flow

```
File System
    ↓
watchdog Observer
    ↓
ClaudeActivityHandler
    ↓
SessionStateManager (SQLite)
    ↓
NotificationManager (osascript)
    ↓
Menu Bar Widget (rumps)
```

### Database Schema

```sql
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    last_activity TIMESTAMP,
    duration_seconds INTEGER,
    token_count INTEGER,
    message_count INTEGER,
    status TEXT
);

CREATE TABLE notifications (
    id INTEGER PRIMARY KEY,
    session_id INTEGER,
    notification_type TEXT,
    sent_at TIMESTAMP
);
```

---

## API Reference

### CLI Commands

| Command | Description |
|---------|-------------|
| `claude-session start` | Manually start tracking |
| `claude-session stop` | End current session |
| `claude-session status` | Show current status |
| `claude-session stats` | Display statistics |
| `claude-session history` | Show session history |
| `claude-session update --tokens N --messages N` | Update counts |

### Python API

```python
from session_state import SessionStateManager

# Get session status
state = SessionStateManager()
session = state.get_active_session()

# Create new session
session_id = state.create_session(datetime.now())

# Update session
state.update_session(
    session_id,
    token_count=1500,
    message_count=25
)

# Get statistics
stats = state.get_daily_stats()
```

---

## Troubleshooting

### Common Issues

**Issue**: Monitor not detecting activity  
**Solution**: Check file paths exist and permissions are correct

**Issue**: Notifications not appearing  
**Solution**: Grant notification permissions in System Preferences

**Issue**: Menu bar not showing  
**Solution**: Install rumps: `pip3 install rumps`

**Issue**: LaunchAgent not starting  
**Solution**: Check logs at `~/.claude-session-tracker/logs/`

---

## Future Enhancements

- [ ] Token usage estimation via message analysis
- [ ] Web dashboard for analytics
- [ ] Multi-machine sync via cloud storage
- [ ] Predictive scheduling based on patterns
- [ ] Integration with calendar apps
- [ ] Slack/Discord notifications
- [ ] Export to CSV/PDF reports

---

## Contributing

This skill is part of the Organized AI ecosystem. Contributions welcome at:
https://github.com/Organized-AI/cc-session-manager

---

## Version History

**v2.0.0** - Real-Time Tracker
- Automatic session detection
- File system monitoring
- Real-time notifications
- Menu bar widget
- Usage analytics

**v1.0.0** - Future Scheduler  
- Calendar integration
- Future session planning
- Token prediction
- iCal scheduling

---

**Maintained by**: Organized AI  
**Repository**: https://github.com/Organized-AI/cc-session-manager  
**Documentation**: See README.md for detailed usage
