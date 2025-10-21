#!/bin/bash

echo "📦 Claude Code Session Manager - Repository Setup"
echo "=================================================="
echo ""
echo "This script will help you organize the files for GitHub."
echo ""
echo "📋 Expected file structure:"
echo "  Root: SKILL.md, README.md, requirements.txt, setup.sh, *.py"
echo "  examples/: sample_conversations.jsonl"  
echo "  resources/: QUICKSTART.md"
echo ""
echo "Please download all files from Claude and place them in this directory."
echo "Then run this script to organize them properly."
echo ""

read -p "Press Enter when files are ready..."

echo ""
echo "🔧 Organizing files..."

# Move files to proper locations
if [ -f "sample_conversations.jsonl" ]; then
    mv sample_conversations.jsonl examples/
    echo "✅ Moved sample_conversations.jsonl to examples/"
fi

if [ -f "QUICKSTART.md" ]; then
    mv QUICKSTART.md resources/
    echo "✅ Moved QUICKSTART.md to resources/"
fi

if [ -f "claude-code-session-manager-SKILL.md" ]; then
    mv claude-code-session-manager-SKILL.md SKILL.md  
    echo "✅ Renamed to SKILL.md"
fi

# Make scripts executable
chmod +x *.py setup.sh 2>/dev/null
echo "✅ Made scripts executable"

echo ""
echo "📁 Current structure:"
ls -la
echo ""
echo "examples/:"
ls -la examples/
echo ""
echo "resources/:"
ls -la resources/

echo ""
echo "✅ Repository is organized and ready!"
echo ""
echo "Next steps:"
echo "  1. git add ."
echo "  2. git commit -m 'Initial commit: Claude Code Session Manager skill'"
echo "  3. git push origin main"
