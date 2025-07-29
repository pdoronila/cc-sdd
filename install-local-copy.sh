#!/bin/bash
# Simple local installer that copies files directly
# Usage: ../cc-sdd/install-local-copy.sh

set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

# Get the source directory (where this script is located)
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${B}🚀 Installing Spec-Driven Development (Local Copy)...${NC}"
echo -e "${Y}Source: $SOURCE_DIR${NC}"
echo -e "${Y}Target: $(pwd)${NC}"
echo ""

# Check if we're in the source directory
if [ "$(pwd)" = "$SOURCE_DIR" ]; then
    echo -e "${R}❌ Cannot install in source directory${NC}"
    echo -e "${Y}Please run this from your target project directory${NC}"
    exit 1
fi

# Check if source files exist
if [ ! -d "$SOURCE_DIR/.claude" ]; then
    echo -e "${R}❌ Source .claude directory not found at: $SOURCE_DIR/.claude${NC}"
    exit 1
fi

# Create directories
echo -e "${Y}📁 Creating directories...${NC}"
mkdir -p .claude/commands/cc-sdd specs

# Copy namespaced commands (overwrite if they exist)
echo -e "${Y}📝 Installing cc-sdd slash commands...${NC}"
for cmd in spec.md requirements.md design.md task.md start-task.md; do
    if [ -f "$SOURCE_DIR/.claude/commands/cc-sdd/$cmd" ]; then
        cp "$SOURCE_DIR/.claude/commands/cc-sdd/$cmd" ".claude/commands/cc-sdd/"
        echo -e "${G}✅ cc-sdd/$cmd${NC}"
    else
        echo -e "${R}❌ Missing: cc-sdd/$cmd${NC}"
    fi
done

# Copy agents (overwrite if they exist)
echo -e "${Y}🤖 Installing cc-sdd AI agents...${NC}"
mkdir -p .claude/agents
for agent in requirements-specialist.md design-architect.md task-planner.md; do
    if [ -f "$SOURCE_DIR/.claude/agents/$agent" ]; then
        cp "$SOURCE_DIR/.claude/agents/$agent" ".claude/agents/"
        echo -e "${G}✅ $agent${NC}"
    else
        echo -e "${R}❌ Missing: $agent${NC}"
    fi
done

# Copy state management files (only if they don't exist)
echo -e "${Y}📋 Installing state management...${NC}"
for state_file in PROJECT_STATE.md WORKFLOW_CONTEXT.md; do
    if [ ! -f ".claude/$state_file" ] && [ -f "$SOURCE_DIR/.claude/$state_file" ]; then
        cp "$SOURCE_DIR/.claude/$state_file" ".claude/"
        echo -e "${G}✅ $state_file${NC}"
    elif [ -f ".claude/$state_file" ]; then
        echo -e "${B}ℹ️ Preserving existing: $state_file${NC}"
    else
        echo -e "${Y}⚠️ Source not found: $state_file${NC}"
    fi
done

# Preserve existing CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    echo -e "${B}ℹ️ Preserving existing: CLAUDE.md${NC}"
else
    echo -e "${Y}ℹ️ No existing CLAUDE.md found - will be created by /cc-sdd/spec${NC}"
fi


# Copy configuration (merge with existing if present)
echo -e "${Y}⚙️ Installing configuration...${NC}"
if [ -f ".claude/settings.local.json" ]; then
    # Create backup of existing settings
    BACKUP_FILE=".claude/settings.local.json.backup-$(date +%Y%m%d-%H%M%S)"
    cp ".claude/settings.local.json" "$BACKUP_FILE"
    echo -e "${B}ℹ️ Backup created: $BACKUP_FILE${NC}"
    echo -e "${B}ℹ️ Merging with existing .claude/settings.local.json${NC}"
    
    if grep -q "spec-init" ".claude/settings.local.json"; then
        echo -e "${G}✅ Spec commands already configured${NC}"
    else
        echo -e "${Y}📝 Adding spec commands to permissions...${NC}"
        if command -v jq >/dev/null 2>&1; then
            jq -s '
                .[0] as $existing | .[1] as $new |
                $existing * $new |
                .permissions.allow = (($existing.permissions.allow // []) + ($new.permissions.allow // []) | unique)
            ' ".claude/settings.local.json" "$SOURCE_DIR/.claude/settings.local.json" > ".claude/settings.merged.json"
            mv ".claude/settings.merged.json" ".claude/settings.local.json"
            echo -e "${G}✅ Successfully merged settings${NC}"
        else
            echo -e "${Y}⚠️ jq not found, manual merge recommended${NC}"
        fi
    fi
else
    if [ -f "$SOURCE_DIR/.claude/settings.local.json" ]; then
        cp "$SOURCE_DIR/.claude/settings.local.json" ".claude/"
        echo -e "${G}✅ settings.local.json${NC}"
    fi
fi




# Note: .gitignore management left to user preference
echo -e "${B}ℹ️ .gitignore management left to user preference${NC}"

echo ""
echo -e "${G}🎉 Installation complete!${NC}"
echo ""
echo -e "${B}Quick start:${NC}"
echo -e "1. ${Y}claude /cc-sdd/spec \"Your project description\"${NC} - Generate complete specifications"
echo -e "2. ${Y}claude /cc-sdd/requirements \"Additional requirements\"${NC} - Refine requirements"
echo -e "3. ${Y}claude /cc-sdd/design \"Architecture focus\"${NC} - Update technical design"
echo -e "4. ${Y}claude /cc-sdd/task \"Component focus\"${NC} - Modify task breakdown"
echo -e "5. ${Y}claude /cc-sdd/start-task \"Implementation planning\"${NC} - Create integrated todo list"
echo -e ""
echo -e "${B}🤖 Agent-Powered Workflow: Requirements → Design → Tasks → Todo Planning${NC}"
echo -e "${B}✨ AI agents handle specification generation automatically!${NC}"
echo ""
echo -e "${B}Agent-Powered 5-Command System:${NC}"
echo -e "  ${Y}/cc-sdd/spec${NC}         - Master orchestrator (complete workflow)"
echo -e "  ${Y}/cc-sdd/requirements${NC} - EARS-format requirements generation"
echo -e "  ${Y}/cc-sdd/design${NC}       - Technical architecture and design"
echo -e "  ${Y}/cc-sdd/task${NC}         - Development task breakdown"
echo -e "  ${Y}/cc-sdd/start-task${NC}   - Integrated todo planning"
echo ""
