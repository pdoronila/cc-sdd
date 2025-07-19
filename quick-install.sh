#!/bin/bash
# Quick Installer for Spec-Driven Development in Claude Code
# Usage: curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash

set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

# Configuration
REPO="https://raw.githubusercontent.com/your-username/claude-code-sdd/main"

echo -e "${B}🚀 Installing Spec-Driven Development for Claude Code...${NC}"

# Check requirements
command -v curl >/dev/null 2>&1 || { echo -e "${R}❌ curl required${NC}"; exit 1; }

# Create directories
echo -e "${Y}📁 Creating directories...${NC}"
mkdir -p .claude/{commands,utils,mcp-servers} specs

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
dl ".claude/commands/spec-init.md" "Project initialization"
dl ".claude/commands/spec-tasks.md" "Task generation from requirements"
dl ".claude/commands/spec-validate.md" "Validation and traceability"
dl ".claude/commands/spec-work.md" "Start next task"
dl ".claude/commands/spec-done.md" "Complete task + quality gates"

# Optional utilities
mkdir -p .claude/utils
dl ".claude/utils/validate-specs.sh" "Manual validation utility"
dl ".claude/utils/sync-specs.sh" "Manual sync utility"
dl ".claude/utils/quality-check.sh" "Manual quality check utility"
dl ".claude/utils/task-state-manager.sh" "Manual task state manager"
chmod +x .claude/utils/*.sh

# Configuration
dl ".claude/settings.local.json" "Claude configuration"

# MCP Server
dl ".claude/mcp-servers/spec-sync-server.js" "MCP server"

# Templates (only if they don't exist)
echo -e "${Y}📋 Installing templates...${NC}"
for template in requirements.md design.md tasks.md api-spec.md; do
    if [ ! -f "specs/$template" ]; then
        dl "specs/$template" "Template: $template"
    else
        echo -e "${B}ℹ️  Skipping existing: specs/$template${NC}"
    fi
done

# Install npm dependencies if package.json exists
if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    echo -e "${Y}📦 Installing MCP SDK...${NC}"
    npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1 || true
fi

# Update .gitignore
echo -e "\n# Spec-driven development\n.claude/logs/\n*.spec.log" >> .gitignore 2>/dev/null || true

echo -e "${G}🎉 Installation complete!${NC}"
echo -e "\n${B}Quick start:${NC}"
echo -e "1. ${Y}claude /spec-init${NC}     - Initialize your project"
echo -e "2. ${Y}claude /spec-work${NC}     - Start working (auto-selects task + quality validation)"
echo -e "3. ${Y}claude /spec-done${NC}     - Complete task + start next (seamless flow)"
echo -e "\n${B}🚀 Hook-Free Workflow: /spec-init → /spec-tasks → /spec-work → /spec-done...${NC}"
echo -e "${B}📋 Features: Requirement traceability, inline quality gates, emoji-based task states${NC}"
echo -e "${B}✨ No hooks, no interference, all logic in slash commands!${NC}"
echo -e "${B}5 Essential commands: /spec-init, /spec-tasks, /spec-validate, /spec-work, /spec-done${NC}"