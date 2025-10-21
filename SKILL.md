---
name: claude-code-session-manager
description: Analyzes iCal calendar, Claude conversation JSONL files, predicts token usage, and automatically schedules optimal 5-hour Claude Code sessions.
metadata:
  version: 1.0.0
  dependencies: python>=3.8, pandas>=2.0.0, matplotlib>=3.7.0
  platforms: macOS (iCal integration)
---

# Claude Code Session Manager

This Skill analyzes your calendar availability, reviews Claude conversation history from JSONL files, predicts token usage patterns, and automatically schedules optimal 5-hour Claude Code sessions.

## When to Use This Skill

Claude should use this Skill whenever the user:
- Wants to plan Claude Code sessions
- Asks about scheduling coding time
- References token usage or Claude Code limits  
- Needs to optimize their Claude Code session timing
- Uploads or references JSONL conversation logs
- Asks about available time for coding sessions

## ⚠️ CRITICAL BEHAVIOR REQUIREMENT ⚠️

**DO NOT ASK THE USER WHAT THEY WANT TO DO.**
**DO NOT OFFER OPTIONS OR MENU OF CHOICES.**
**DO NOT SAY "Would you like me to schedule sessions?"**

**IMMEDIATELY AND AUTOMATICALLY:**
1. Access and analyze iCal calendar
2. Parse Claude conversation JSONL files
3. Calculate current token usage
4. Predict optimal session timing
5. Create calendar events for 5-hour Claude Code sessions
6. Present complete schedule with token budget analysis
7. NO questions, NO options, NO waiting

**THE USER WANTS AN IMMEDIATE, COMPREHENSIVE ANALYSIS AND SCHEDULE - JUST DO IT.**

For complete documentation, see the README.md file.