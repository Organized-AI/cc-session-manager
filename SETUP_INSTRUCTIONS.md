# GitHub Repository Setup Instructions

## Quick Setup (5 minutes)

### Step 1: Download All Files

Download these files from Claude:

**Root Directory Files:**
- [SKILL.md - rename from claude-code-session-manager-SKILL.md]
- [README.md]
- [requirements.txt]
- [setup.sh]
- [scheduler.py]
- [token_analyzer.py]
- [calendar_integration.py]
- [predictor.py]
- [visualizations.py]

**examples/ Directory:**
- [sample_conversations.jsonl]

**resources/ Directory:**
- [QUICKSTART.md]

### Step 2: Organize Files

```bash
cd /tmp/claude-code-session-manager

# Move downloaded files here
# Then run:
./setup_repo.sh
```

Or manually:
```bash
# Move files to correct locations
mv sample_conversations.jsonl examples/
mv QUICKSTART.md resources/
mv claude-code-session-manager-SKILL.md SKILL.md

# Make scripts executable
chmod +x *.py setup.sh
```

### Step 3: Commit and Push

```bash
git add .
git commit -m "Initial commit: Claude Code Session Manager skill

- Automatic iCal calendar integration
- JSONL conversation log parsing
- Token usage prediction (4 categories)
- Intelligent session scheduling
- Visualization and reporting
- macOS Calendar support"

git push origin main
```

## Verify Structure

Your repo should look like this:

```
claude-code-session-manager/
├── SKILL.md
├── README.md  
├── scheduler.py
├── token_analyzer.py
├── calendar_integration.py
├── predictor.py
├── visualizations.py
├── requirements.txt
├── setup.sh
├── examples/
│   └── sample_conversations.jsonl
└── resources/
    └── QUICKSTART.md
```

## That's it! 🎉

Your skill is now on GitHub at:
https://github.com/Organized-AI/claude-code-session-manager
