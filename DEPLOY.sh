#!/bin/bash

echo "🚀 Claude Code Session Manager - GitHub Deployment"
echo "===================================================="
echo ""

# Check if we're in the right directory  
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

echo "📥 Step 1: Checking for downloaded files..."
echo ""

DOWNLOADS_DIR="$HOME/Downloads"
MISSING_FILES=()

# Check for required files
for file in README.md requirements.txt setup.sh scheduler.py token_analyzer.py calendar_integration.py predictor.py visualizations.py sample_conversations.jsonl QUICKSTART.md; do
    if [ -f "$file" ] || [ -f "$DOWNLOADS_DIR/$file" ]; then
        echo "✅ Found: $file"
    else
        MISSING_FILES+=("$file")
        echo "❌ Missing: $file"
    fi
done

# Check for SKILL.md or the long name
if [ -f "SKILL.md" ] || [ -f "claude-code-session-manager-SKILL.md" ] || [ -f "$DOWNLOADS_DIR/claude-code-session-manager-SKILL.md" ]; then
    echo "✅ Found: SKILL.md"
else
    MISSING_FILES+=("claude-code-session-manager-SKILL.md")
    echo "❌ Missing: SKILL.md"
fi

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Please download missing files from Claude first!"
    echo ""
    echo "Missing files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "Download all files from Claude, then run this script again."
    exit 1
fi

echo ""
echo "📁 Step 2: Copying files from Downloads if needed..."

# Copy files from Downloads if they're there
for file in README.md requirements.txt setup.sh scheduler.py token_analyzer.py calendar_integration.py predictor.py visualizations.py; do
    if [ -f "$DOWNLOADS_DIR/$file" ] && [ ! -f "$file" ]; then
        cp "$DOWNLOADS_DIR/$file" .
        echo "  Copied: $file"
    fi
done

# Handle SKILL.md  
if [ -f "$DOWNLOADS_DIR/claude-code-session-manager-SKILL.md" ] && [ ! -f "SKILL.md" ]; then
    cp "$DOWNLOADS_DIR/claude-code-session-manager-SKILL.md" SKILL.md
    echo "  Copied and renamed: SKILL.md"
fi

# Handle examples
if [ -f "$DOWNLOADS_DIR/sample_conversations.jsonl" ]; then
    cp "$DOWNLOADS_DIR/sample_conversations.jsonl" examples/
    echo "  Copied: examples/sample_conversations.jsonl"
fi

# Handle resources
if [ -f "$DOWNLOADS_DIR/QUICKSTART.md" ]; then
    cp "$DOWNLOADS_DIR/QUICKSTART.md" resources/
    echo "  Copied: resources/QUICKSTART.md"
fi

echo ""
echo "🔧 Step 3: Making scripts executable..."
chmod +x *.py setup.sh 2>/dev/null
echo "✅ Scripts are executable"

echo ""
echo "📊 Step 4: Verifying structure..."
echo ""
echo "Root files:"
ls -1 *.md *.py *.sh *.txt 2>/dev/null | head -10

echo ""
echo "examples/:"
ls -1 examples/

echo ""
echo "resources/:"
ls -1 resources/

echo ""
echo "✅ Step 5: Ready to commit!"
echo ""

read -p "Commit and push to GitHub? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📤 Committing and pushing..."
    
    git add .
    git commit -m "Initial commit: Claude Code Session Manager skill

• Automatic iCal calendar integration for macOS
• JSONL conversation log parsing and analysis
• Token usage prediction with 4 categories (Light/Medium/Heavy/Intensive)
• Intelligent 5-hour session scheduling
• Token budget warnings and safety margins
• Visualization charts and reporting
• AppleScript-based Calendar.app integration
• Comprehensive documentation and examples

Features:
- Analyzes historical token usage patterns
- Finds optimal calendar slots automatically
- Creates calendar events with predictions
- Generates usage visualizations
- Provides actionable recommendations"
    
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 Success! Repository deployed to GitHub!"
        echo ""
        echo "View at: https://github.com/Organized-AI/claude-code-session-manager"
        echo ""
    else
        echo ""
        echo "❌ Push failed. Check your GitHub authentication."
    fi
else
    echo ""
    echo "📝 Commit manually when ready:"
    echo "   git add ."
    echo "   git commit -m 'Initial commit'"
    echo "   git push origin main"
fi

echo ""
echo "✅ Done!"
