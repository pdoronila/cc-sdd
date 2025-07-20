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
mkdir -p .claude/{commands,utils,mcp-servers} specs

# Copy commands
echo -e "${Y}📝 Installing slash commands...${NC}"
for cmd in spec-init.md spec-feat.md spec-validate.md spec-work.md spec-done.md; do
    if [ -f "$SOURCE_DIR/.claude/commands/$cmd" ]; then
        cp "$SOURCE_DIR/.claude/commands/$cmd" ".claude/commands/"
        echo -e "${G}✅ $cmd${NC}"
    else
        echo -e "${R}❌ Missing: $cmd${NC}"
    fi
done

# Copy optional utilities
echo -e "${Y}🔧 Installing optional utilities...${NC}"
mkdir -p .claude/utils
for util in validate-specs.sh sync-specs.sh quality-check.sh task-state-manager.sh; do
    if [ -f "$SOURCE_DIR/.claude/utils/$util" ]; then
        cp "$SOURCE_DIR/.claude/utils/$util" ".claude/utils/"
        chmod +x ".claude/utils/$util"
        echo -e "${G}✅ $util${NC}"
    else
        echo -e "${R}❌ Missing: $util${NC}"
    fi
done

# Copy configuration and MCP server
echo -e "${Y}⚙️ Installing configuration...${NC}"
if [ -f "$SOURCE_DIR/.claude/settings.local.json" ]; then
    cp "$SOURCE_DIR/.claude/settings.local.json" ".claude/"
    echo -e "${G}✅ settings.local.json${NC}"
fi

if [ -f "$SOURCE_DIR/.claude/mcp-servers/spec-sync-server.js" ]; then
    cp "$SOURCE_DIR/.claude/mcp-servers/spec-sync-server.js" ".claude/mcp-servers/"
    echo -e "${G}✅ spec-sync-server.js${NC}"
fi

# Copy templates (only if they don't exist)
echo -e "${Y}📋 Installing specification templates...${NC}"
for template in requirements.md design.md tasks.md api-spec.md; do
    if [ ! -f "specs/$template" ]; then
        if [ -f "$SOURCE_DIR/specs/$template" ]; then
            cp "$SOURCE_DIR/specs/$template" "specs/"
            echo -e "${G}✅ $template${NC}"
        else
            echo -e "${R}❌ Missing source: $template${NC}"
        fi
    else
        echo -e "${B}ℹ️ Already exists: specs/$template${NC}"
    fi
done

# Install npm dependencies if package.json exists
if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    echo -e "${Y}📦 Installing MCP SDK...${NC}"
    if npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1; then
        echo -e "${G}✅ @modelcontextprotocol/sdk installed${NC}"
    else
        echo -e "${Y}⚠️ Could not install MCP SDK (install manually if needed)${NC}"
    fi
fi

# Update .gitignore
if [ -f ".gitignore" ]; then
    if ! grep -q ".claude/logs/" .gitignore; then
        echo "" >> .gitignore
        echo "# Spec-driven development" >> .gitignore
        echo ".claude/logs/" >> .gitignore
        echo "*.spec.log" >> .gitignore
        echo -e "${G}✅ Updated .gitignore${NC}"
    fi
fi

echo ""
echo -e "${G}🎉 Installation complete!${NC}"
echo ""
echo -e "${B}Quick start:${NC}"
echo -e "1. ${Y}claude /spec-init${NC}     - Initialize your project specifications"
echo -e "2. ${Y}claude /spec-work${NC}     - Start working (auto-selects task + quality validation)"
echo -e "3. ${Y}claude /spec-done${NC}     - Complete task + start next (seamless flow)"
echo -e ""
echo -e "${B}🚀 Hook-Free Workflow: /spec-work → /spec-done → /spec-done...${NC}"
echo -e "${B}✨ No hooks, no interference, no background processes!${NC}"
echo ""
echo -e "${B}Streamlined 5-Command Workflow:${NC}"
echo -e "  ${Y}/spec-init${NC}     - Initialize project specifications (setup)"
echo -e "  ${Y}/spec-tasks${NC}    - Generate implementation tasks from requirements"
echo -e "  ${Y}/spec-validate${NC} - Validate specifications and traceability"
echo -e "  ${Y}/spec-work${NC}     - Auto-select and start next task"
echo -e "  ${Y}/spec-done${NC}     - Complete task + start next (with quality gates)"
echo ""
echo -e "${B}Optional utilities (manual use):${NC}"
echo -e "  ${Y}./.claude/utils/validate-specs.sh${NC}     - Manual spec validation"
echo -e "  ${Y}./.claude/utils/sync-specs.sh${NC}         - Manual spec sync"
echo -e "  ${Y}./.claude/utils/quality-check.sh${NC}      - Manual quality validation"
echo -e "  ${Y}./.claude/utils/task-state-manager.sh${NC} - Manual task state management"
echo ""