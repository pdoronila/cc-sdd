#!/bin/bash
# Quick Installer for Spec-Driven Development in Claude Code
# Usage: curl -sSL https://raw.githubusercontent.com/pdoronila/cc-sdd/main/quick-install.sh | bash

set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

# Configuration
REPO="https://raw.githubusercontent.com/pdoronila/cc-sdd/main"

echo -e "${B}🚀 Installing Spec-Driven Development for Claude Code...${NC}"

# Check requirements
command -v curl >/dev/null 2>&1 || { echo -e "${R}❌ curl required${NC}"; exit 1; }

# Create directories
echo -e "${Y}📁 Creating directories...${NC}"
mkdir -p .claude/commands specs

# Download function
dl() {
    local file=$1
    local desc=$2
    if curl -sSL "$REPO/$file" -o "$file" --fail; then
        echo -e "${G}✅ $desc${NC}"
    else
        echo -e "${R}❌ Failed: $desc${NC}"
        exit 1
    fi
}

# Download all files
echo -e "${Y}⬇️  Downloading files...${NC}"

# Commands (Streamlined 5-Command Set)
dl ".claude/commands/spec-init.md" "Complete project initialization"
dl ".claude/commands/spec-feat.md" "Interactive feature development"
dl ".claude/commands/spec-validate.md" "Validation and traceability"
dl ".claude/commands/spec-work.md" "Start next task"
dl ".claude/commands/spec-done.md" "Complete task + quality gates"


# Configuration (merge with existing if present)
echo -e "${Y}⚙️  Configuring Claude settings...${NC}"
if [ -f ".claude/settings.local.json" ]; then
    # Create backup of existing settings
    BACKUP_FILE=".claude/settings.local.json.backup-$(date +%Y%m%d-%H%M%S)"
    cp ".claude/settings.local.json" "$BACKUP_FILE"
    echo -e "${B}ℹ️  Backup created: $BACKUP_FILE${NC}"
    echo -e "${B}ℹ️  Merging with existing .claude/settings.local.json${NC}"
    
    # Download template to temp file
    curl -sSL "$REPO/.claude/settings.local.json" -o ".claude/settings.temp.json" --fail
    # Check if spec commands are already configured
    if grep -q "spec-init" ".claude/settings.local.json"; then
        echo -e "${G}✅ Spec commands already configured${NC}"
    else
        echo -e "${Y}📝 Adding spec commands to permissions...${NC}"
        # Use jq if available for smart merging
        if command -v jq >/dev/null 2>&1; then
            # Merge permissions arrays without duplicates, merge other properties
            jq -s '
                .[0] as $existing | .[1] as $new |
                $existing * $new |
                .permissions.allow = (($existing.permissions.allow // []) + ($new.permissions.allow // []) | unique)
            ' ".claude/settings.local.json" ".claude/settings.temp.json" > ".claude/settings.merged.json"
            mv ".claude/settings.merged.json" ".claude/settings.local.json"
            echo -e "${G}✅ Successfully merged settings${NC}"
        else
            echo -e "${Y}⚠️  jq not found, manual merge recommended${NC}"
        fi
    fi
    rm -f ".claude/settings.temp.json"
else
    dl ".claude/settings.local.json" "Claude configuration"
fi


# Templates (only if they don't exist)
echo -e "${Y}📋 Installing templates...${NC}"
for template in requirements.md design.md tasks.md api-spec.md; do
    if [ ! -f "specs/$template" ]; then
        dl "specs/$template" "Template: $template"
    else
        echo -e "${B}ℹ️  Skipping existing: specs/$template${NC}"
    fi
done


# Note: .gitignore management left to user preference

echo -e "${G}🎉 Installation complete!${NC}"
echo -e "\n${B}Quick start:${NC}"
echo -e "1. ${Y}claude /spec-init${NC}     - Complete project setup (requirements + design + tasks)"
echo -e "2. ${Y}claude /spec-feat \"Feature\"${NC} - Add new features interactively"
echo -e "3. ${Y}claude /spec-work${NC}     - Start working (auto-selects task + quality validation)"
echo -e "4. ${Y}claude /spec-done${NC}     - Complete task + start next (seamless flow)"
echo -e "\n${B}🚀 Hook-Free Workflow: /spec-init → /spec-feat → /spec-work → /spec-done...${NC}"
echo -e "${B}📋 Features: Complete project setup, interactive feature development, requirement traceability${NC}"
echo -e "${B}✨ No hooks, no interference, all logic in slash commands!${NC}"
echo -e "${B}5 Streamlined commands: /spec-init, /spec-feat, /spec-validate, /spec-work, /spec-done${NC}"