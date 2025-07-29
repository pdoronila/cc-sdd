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
mkdir -p .claude/commands/cc-sdd specs

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
echo -e "${Y}⬇️  Downloading cc-sdd commands...${NC}"

# Commands (Agent-Powered 5-Command Set)
dl ".claude/commands/cc-sdd/spec.md" "Master orchestrator"
dl ".claude/commands/cc-sdd/requirements.md" "EARS-format requirements generation"
dl ".claude/commands/cc-sdd/design.md" "Technical architecture and design"
dl ".claude/commands/cc-sdd/task.md" "Development task breakdown"
dl ".claude/commands/cc-sdd/start-task.md" "Integrated todo planning"

# AI Agents
echo -e "${Y}🤖 Downloading AI agents...${NC}"
mkdir -p .claude/agents
dl ".claude/agents/requirements-specialist.md" "Requirements specialist agent"
dl ".claude/agents/design-architect.md" "Design architect agent"
dl ".claude/agents/task-planner.md" "Task planner agent"

# State management (only if they don't exist)
echo -e "${Y}📋 Installing state management...${NC}"
for state_file in PROJECT_STATE.md WORKFLOW_CONTEXT.md; do
    if [ ! -f ".claude/$state_file" ]; then
        if curl -sSL "$REPO/.claude/$state_file" -o ".claude/$state_file" --fail; then
            echo -e "${G}✅ $state_file${NC}"
        else
            echo -e "${Y}⚠️ Optional file not available: $state_file${NC}"
        fi
    else
        echo -e "${B}ℹ️ Preserving existing: $state_file${NC}"
    fi
done


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




# Note: .gitignore management left to user preference

echo -e "${G}🎉 Installation complete!${NC}"
echo -e "\n${B}Quick start:${NC}"
echo -e "1. ${Y}claude /cc-sdd/spec \"Your project description\"${NC} - Generate complete specifications"
echo -e "2. ${Y}claude /cc-sdd/requirements \"Additional requirements\"${NC} - Refine requirements"
echo -e "3. ${Y}claude /cc-sdd/design \"Architecture focus\"${NC} - Update technical design"
echo -e "4. ${Y}claude /cc-sdd/task \"Component focus\"${NC} - Modify task breakdown"
echo -e "5. ${Y}claude /cc-sdd/start-task \"Implementation planning\"${NC} - Create integrated todo list"
echo -e "\n${B}🤖 Agent-Powered Workflow: Requirements → Design → Tasks → Todo Planning${NC}"
echo -e "${B}📋 Features: EARS-format requirements, technical architecture, structured tasks${NC}"
echo -e "${B}✨ AI agents handle specification generation automatically!${NC}"
echo -e "${B}5 Agent-powered commands: /cc-sdd/spec, /cc-sdd/requirements, /cc-sdd/design, /cc-sdd/task, /cc-sdd/start-task${NC}"