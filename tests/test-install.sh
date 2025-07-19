#!/bin/bash
# Test installer locally
# Usage: ./test-install.sh [target-directory]

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

TEST_DIR=${1:-"/tmp/sdd-test-$(date +%s)"}
CURRENT_DIR=$(pwd)

echo -e "${BLUE}🧪 Testing Spec-Driven Development Installer${NC}"
echo -e "Test directory: ${YELLOW}$TEST_DIR${NC}"
echo ""

# Create test environment
echo -e "${YELLOW}📁 Creating test environment...${NC}"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create a mock project
echo '{"name": "test-project", "version": "1.0.0"}' > package.json
echo "# Test Project" > README.md
git init >/dev/null 2>&1 || true

echo -e "${GREEN}✅ Test environment created${NC}"

# Test the installer using local files
echo -e "${YELLOW}🚀 Running installer with local files...${NC}"

# Create a modified installer that uses local files
cat > local-install.sh << EOF
#!/bin/bash
set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

echo -e "\${B}🚀 Installing Spec-Driven Development (Local Test)...\${NC}"

# Create directories
mkdir -p .claude/{commands,hooks,mcp-servers} specs

# Copy files from source
echo -e "\${Y}📁 Copying files...\${NC}"

# Copy commands
for cmd in spec-init.md spec-validate.md spec-update.md spec-tasks.md spec-review.md; do
    cp "$CURRENT_DIR/.claude/commands/\$cmd" ".claude/commands/"
    echo -e "\${G}✅ Command: \$cmd\${NC}"
done

# Copy hooks
for hook in validate-specs.sh sync-specs.sh; do
    cp "$CURRENT_DIR/.claude/hooks/\$hook" ".claude/hooks/"
    chmod +x ".claude/hooks/\$hook"
    echo -e "\${G}✅ Hook: \$hook\${NC}"
done

# Copy configuration and MCP server
cp "$CURRENT_DIR/.claude/settings.local.json" ".claude/"
cp "$CURRENT_DIR/.claude/mcp-servers/spec-sync-server.js" ".claude/mcp-servers/"
echo -e "\${G}✅ Configuration and MCP server\${NC}"

# Copy templates
for template in requirements.md design.md tasks.md api-spec.md; do
    cp "$CURRENT_DIR/specs/\$template" "specs/"
    echo -e "\${G}✅ Template: \$template\${NC}"
done

# Test npm install
if command -v npm >/dev/null 2>&1; then
    echo -e "\${Y}📦 Installing dependencies...\${NC}"
    npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1 || true
fi

echo -e "\${G}🎉 Local installation complete!\${NC}"
EOF

chmod +x local-install.sh
./local-install.sh

echo ""
echo -e "${YELLOW}🔍 Verifying installation...${NC}"

# Check required files
required_files=(
    ".claude/commands/spec-init.md"
    ".claude/commands/spec-validate.md"
    ".claude/hooks/validate-specs.sh"
    ".claude/settings.local.json"
    "specs/requirements.md"
)

missing=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ Found: $file${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        missing=$((missing + 1))
    fi
done

# Test hook execution
echo -e "${YELLOW}🧪 Testing hooks...${NC}"
if [ -x ".claude/hooks/validate-specs.sh" ]; then
    if ./.claude/hooks/validate-specs.sh >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Validation hook works${NC}"
    else
        echo -e "${YELLOW}⚠️  Validation hook has warnings (expected for empty specs)${NC}"
    fi
else
    echo -e "${RED}❌ Validation hook not executable${NC}"
    missing=$((missing + 1))
fi

# Test directory structure
echo -e "${YELLOW}📁 Checking directory structure...${NC}"
expected_dirs=(
    ".claude/commands"
    ".claude/hooks"
    ".claude/mcp-servers"
    "specs"
)

for dir in "${expected_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ Directory: $dir${NC}"
    else
        echo -e "${RED}❌ Missing directory: $dir${NC}"
        missing=$((missing + 1))
    fi
done

# Count files
cmd_count=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l)
hook_count=$(find .claude/hooks -name "*.sh" 2>/dev/null | wc -l)
spec_count=$(find specs -name "*.md" 2>/dev/null | wc -l)

echo ""
echo -e "${BLUE}📊 Installation Summary:${NC}"
echo -e "Commands installed: ${YELLOW}$cmd_count${NC}/5"
echo -e "Hooks installed: ${YELLOW}$hook_count${NC}/2"
echo -e "Templates installed: ${YELLOW}$spec_count${NC}/4"
echo -e "Missing files: ${YELLOW}$missing${NC}"

# Test quick start commands
echo ""
echo -e "${YELLOW}🧪 Testing quick start workflow...${NC}"

# Mock Claude Code environment by testing markdown parsing
if grep -q "Spec-Driven Development Initialization" .claude/commands/spec-init.md; then
    echo -e "${GREEN}✅ spec-init command structure valid${NC}"
else
    echo -e "${RED}❌ spec-init command structure invalid${NC}"
fi

if grep -q "validation" .claude/commands/spec-validate.md; then
    echo -e "${GREEN}✅ spec-validate command structure valid${NC}"
else
    echo -e "${RED}❌ spec-validate command structure invalid${NC}"
fi

# Final results
echo ""
if [ $missing -eq 0 ]; then
    echo -e "${GREEN}🎉 TEST PASSED: Installation completed successfully!${NC}"
    echo -e "${BLUE}Test directory: $TEST_DIR${NC}"
    echo -e "${BLUE}You can explore the installed files there.${NC}"
    echo ""
    echo -e "${YELLOW}To test in a real project:${NC}"
    echo -e "1. cd /path/to/your/project"
    echo -e "2. curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash"
    echo -e "3. claude /spec-init"
else
    echo -e "${RED}❌ TEST FAILED: $missing files/directories missing${NC}"
    exit 1
fi

# Cleanup option
echo ""
echo -e "${YELLOW}Keep test directory for inspection? (y/N): ${NC}"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    cd "$CURRENT_DIR"
    rm -rf "$TEST_DIR"
    echo -e "${GREEN}✅ Test directory cleaned up${NC}"
else
    echo -e "${BLUE}ℹ️  Test directory preserved: $TEST_DIR${NC}"
fi