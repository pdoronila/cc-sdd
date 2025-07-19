#!/bin/bash
# Local Testing Script for Spec-Driven Development Installation
# Usage: ./test-local.sh [test-directory-name]

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
SOURCE_DIR=$(pwd)
TEST_DIR=${1:-"../sdd-test-$(date +%s)"}
ABS_TEST_DIR=$(cd "$(dirname "$TEST_DIR")" && pwd)/$(basename "$TEST_DIR")

echo -e "${PURPLE}🧪 Local Testing: Spec-Driven Development Installation${NC}"
echo -e "Source: ${YELLOW}$SOURCE_DIR${NC}"
echo -e "Test directory: ${YELLOW}$ABS_TEST_DIR${NC}"
echo ""

# Function to create a local HTTP server for testing curl downloads
start_local_server() {
    local port=${1:-8080}
    
    echo -e "${YELLOW}🌐 Starting local HTTP server on port $port...${NC}"
    
    # Try different methods to start HTTP server
    if command -v python3 >/dev/null 2>&1; then
        cd "$SOURCE_DIR"
        python3 -m http.server $port >/dev/null 2>&1 &
        SERVER_PID=$!
        echo -e "${GREEN}✅ Python HTTP server started (PID: $SERVER_PID)${NC}"
    elif command -v python >/dev/null 2>&1; then
        cd "$SOURCE_DIR"
        python -m SimpleHTTPServer $port >/dev/null 2>&1 &
        SERVER_PID=$!
        echo -e "${GREEN}✅ Python HTTP server started (PID: $SERVER_PID)${NC}"
    elif command -v node >/dev/null 2>&1; then
        # Create a simple Node.js server
        cat > "$SOURCE_DIR/temp-server.js" << 'EOF'
const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
    const filePath = path.join(__dirname, req.url);
    
    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(404);
            res.end('Not found');
            return;
        }
        res.writeHead(200);
        res.end(data);
    });
});

server.listen(8080, () => {
    console.log('Server running on port 8080');
});
EOF
        node "$SOURCE_DIR/temp-server.js" >/dev/null 2>&1 &
        SERVER_PID=$!
        echo -e "${GREEN}✅ Node.js HTTP server started (PID: $SERVER_PID)${NC}"
    else
        echo -e "${RED}❌ No HTTP server available (python/node required for curl testing)${NC}"
        return 1
    fi
    
    # Wait for server to start
    sleep 2
    
    # Test server
    if curl -s "http://localhost:$port/README.md" >/dev/null; then
        echo -e "${GREEN}✅ Local server is responding${NC}"
        return 0
    else
        echo -e "${RED}❌ Local server failed to start properly${NC}"
        return 1
    fi
}

stop_local_server() {
    if [ -n "$SERVER_PID" ]; then
        kill $SERVER_PID 2>/dev/null || true
        rm -f "$SOURCE_DIR/temp-server.js" 2>/dev/null || true
        echo -e "${GREEN}✅ Local server stopped${NC}"
    fi
}

# Method 1: Direct file copy (no HTTP server needed)
test_direct_copy() {
    echo -e "${BLUE}📋 Method 1: Testing direct file copy installation${NC}"
    
    mkdir -p "$ABS_TEST_DIR"
    cd "$ABS_TEST_DIR"
    
    # Create mock project
    echo '{"name": "test-project", "version": "1.0.0"}' > package.json
    echo "# Test Project" > README.md
    git init >/dev/null 2>&1 || true
    
    echo -e "${YELLOW}📁 Created test project in $ABS_TEST_DIR${NC}"
    
    # Create local installer that copies files directly
    cat > local-install.sh << EOF
#!/bin/bash
set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

echo -e "\${B}🚀 Installing Spec-Driven Development (Local Copy Method)...\${NC}"

SOURCE_DIR="$SOURCE_DIR"

# Create directories
mkdir -p .claude/{commands,hooks,mcp-servers} specs

# Copy commands
echo -e "\${Y}📝 Installing commands...\${NC}"
for cmd in spec-init.md spec-tasks.md spec-validate.md spec-work.md spec-done.md; do
    cp "\$SOURCE_DIR/.claude/commands/\$cmd" ".claude/commands/"
    echo -e "\${G}✅ \$cmd\${NC}"
done

# Copy optional utilities
echo -e "\${Y}🔧 Installing optional utilities...\${NC}"
mkdir -p .claude/utils
for util in validate-specs.sh sync-specs.sh quality-check.sh task-state-manager.sh; do
    cp "\$SOURCE_DIR/.claude/utils/\$util" ".claude/utils/"
    chmod +x ".claude/utils/\$util"
    echo -e "\${G}✅ \$util\${NC}"
done

# Copy configuration and MCP server
echo -e "\${Y}⚙️ Installing configuration...\${NC}"
cp "\$SOURCE_DIR/.claude/settings.local.json" ".claude/"
cp "\$SOURCE_DIR/.claude/mcp-servers/spec-sync-server.js" ".claude/mcp-servers/"

# Copy templates (only if they don't exist)
echo -e "\${Y}📋 Installing templates...\${NC}"
for template in requirements.md design.md tasks.md api-spec.md; do
    if [ ! -f "specs/\$template" ]; then
        cp "\$SOURCE_DIR/specs/\$template" "specs/"
        echo -e "\${G}✅ \$template\${NC}"
    else
        echo -e "\${B}ℹ️ Skipping existing: specs/\$template\${NC}"
    fi
done

# Install npm dependencies if available
if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    echo -e "\${Y}📦 Installing dependencies...\${NC}"
    npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1 || true
fi

echo -e "\${G}🎉 Installation complete!\${NC}"
echo -e "Next steps:"
echo -e "1. claude /spec-init"
echo -e "2. claude /spec-validate"
EOF

    chmod +x local-install.sh
    ./local-install.sh
    
    # Verify installation
    verify_installation "$ABS_TEST_DIR"
}

# Method 2: HTTP server with curl (simulates real usage)
test_curl_method() {
    echo -e "${BLUE}🌐 Method 2: Testing curl-based installation with local server${NC}"
    
    # Start local HTTP server
    if ! start_local_server 8080; then
        echo -e "${RED}❌ Cannot test curl method without HTTP server${NC}"
        return 1
    fi
    
    # Create test directory
    mkdir -p "$ABS_TEST_DIR-curl"
    cd "$ABS_TEST_DIR-curl"
    
    # Create mock project
    echo '{"name": "test-project-curl", "version": "1.0.0"}' > package.json
    echo "# Test Project (Curl)" > README.md
    
    # Create modified quick-install script that uses localhost
    cat > quick-install-local.sh << 'EOF'
#!/bin/bash
set -e

# Colors
G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; R='\033[0;31m'; NC='\033[0m'

# Configuration - use localhost instead of GitHub
REPO="http://localhost:8080"

echo -e "${B}🚀 Installing Spec-Driven Development (Local Curl Test)...${NC}"

# Check requirements
command -v curl >/dev/null 2>&1 || { echo -e "${R}❌ curl required${NC}"; exit 1; }

# Create directories
echo -e "${Y}📁 Creating directories...${NC}"
mkdir -p .claude/{commands,hooks,mcp-servers} specs

# Download function
dl() {
    local file=$1
    local desc=$2
    if curl -sSL "$REPO/$file" -o "$file" --fail --connect-timeout 5; then
        echo -e "${G}✅ $desc${NC}"
    else
        echo -e "${R}❌ Failed: $desc${NC}"
        exit 1
    fi
}

# Download all files
echo -e "${Y}⬇️ Downloading files...${NC}"

# Commands
dl ".claude/commands/spec-init.md" "Project initialization"
dl ".claude/commands/spec-validate.md" "Validation command"
dl ".claude/commands/spec-update.md" "Update command"
dl ".claude/commands/spec-tasks.md" "Task generation"
dl ".claude/commands/spec-review.md" "Review command"
dl ".claude/commands/spec-status.md" "Progress overview"
dl ".claude/commands/spec-next.md" "Next task guidance"
dl ".claude/commands/spec-complete.md" "Task completion"
dl ".claude/commands/spec-check.md" "Auto-completion check"
dl ".claude/commands/spec-work.md" "Streamlined workflow"
dl ".claude/commands/spec-done.md" "Complete and continue with quality gates"

# Hooks
dl ".claude/hooks/validate-specs.sh" "Validation hook"
dl ".claude/hooks/sync-specs.sh" "Sync hook"
chmod +x .claude/hooks/*.sh

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
        echo -e "${B}ℹ️ Skipping existing: specs/$template${NC}"
    fi
done

# Install npm dependencies if package.json exists
if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
    echo -e "${Y}📦 Installing MCP SDK...${NC}"
    npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1 || true
fi

echo -e "${G}🎉 Installation complete!${NC}"
echo -e "\n${B}Quick start:${NC}"
echo -e "1. ${Y}claude /spec-init${NC}     - Initialize your project"
echo -e "2. ${Y}claude /spec-validate${NC} - Validate setup"
echo -e "3. Start coding with automatic spec sync!"
EOF

    chmod +x quick-install-local.sh
    
    echo -e "${YELLOW}🌐 Testing curl installation...${NC}"
    if ./quick-install-local.sh; then
        echo -e "${GREEN}✅ Curl installation succeeded${NC}"
        verify_installation "$ABS_TEST_DIR-curl"
    else
        echo -e "${RED}❌ Curl installation failed${NC}"
    fi
    
    stop_local_server
}

# Method 3: Symlink method (for ongoing development)
test_symlink_method() {
    echo -e "${BLUE}🔗 Method 3: Testing symlink-based development setup${NC}"
    
    mkdir -p "$ABS_TEST_DIR-symlink"
    cd "$ABS_TEST_DIR-symlink"
    
    # Create mock project
    echo '{"name": "test-project-symlink", "version": "1.0.0"}' > package.json
    echo "# Test Project (Symlink)" > README.md
    
    echo -e "${YELLOW}🔗 Creating symlinks for development...${NC}"
    
    # Create .claude directory with symlinks for development
    mkdir -p .claude
    ln -sf "$SOURCE_DIR/.claude/commands" ".claude/commands"
    ln -sf "$SOURCE_DIR/.claude/hooks" ".claude/hooks"
    ln -sf "$SOURCE_DIR/.claude/mcp-servers" ".claude/mcp-servers"
    ln -sf "$SOURCE_DIR/.claude/settings.local.json" ".claude/settings.local.json"
    
    # Copy specs (don't symlink templates since they might be customized)
    cp -r "$SOURCE_DIR/specs" "."
    
    echo -e "${GREEN}✅ Symlink setup complete${NC}"
    echo -e "${BLUE}ℹ️ Changes to source will be reflected immediately${NC}"
    
    verify_installation "$ABS_TEST_DIR-symlink"
}

verify_installation() {
    local test_dir=$1
    
    echo -e "${YELLOW}🔍 Verifying installation in $test_dir...${NC}"
    
    cd "$test_dir"
    
    # Check required files
    local required_files=(
        ".claude/commands/spec-init.md"
        ".claude/commands/spec-validate.md"
        ".claude/hooks/validate-specs.sh"
        ".claude/settings.local.json"
        "specs/requirements.md"
    )
    
    local missing=0
    for file in "${required_files[@]}"; do
        if [ -f "$file" ] || [ -L "$file" ]; then
            echo -e "${GREEN}✅ $file${NC}"
        else
            echo -e "${RED}❌ Missing: $file${NC}"
            missing=$((missing + 1))
        fi
    done
    
    # Test hook execution
    if [ -x ".claude/hooks/validate-specs.sh" ] || [ -L ".claude/hooks/validate-specs.sh" ]; then
        if ./.claude/hooks/validate-specs.sh >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Validation hook works${NC}"
        else
            echo -e "${YELLOW}⚠️ Validation hook has warnings (normal for new installs)${NC}"
        fi
    fi
    
    if [ -x ".claude/hooks/auto-quality-check.sh" ] || [ -L ".claude/hooks/auto-quality-check.sh" ]; then
        echo -e "${GREEN}✅ Auto quality check hook installed${NC}"
    fi
    
    if [ $missing -eq 0 ]; then
        echo -e "${GREEN}🎉 Verification passed!${NC}"
        echo -e "${BLUE}ℹ️ You can now test: claude /spec-init${NC}"
    else
        echo -e "${RED}❌ Verification failed: $missing missing files${NC}"
    fi
    
    echo ""
}

# Main test menu
show_menu() {
    echo -e "${PURPLE}Choose testing method:${NC}"
    echo "1) Direct file copy (fastest, no network)"
    echo "2) HTTP server + curl (simulates real usage)"
    echo "3) Symlink method (for development)"
    echo "4) Run all tests"
    echo "5) Clean up test directories"
    echo "6) Exit"
    echo ""
    echo -n "Enter choice (1-6): "
}

cleanup_test_dirs() {
    echo -e "${YELLOW}🧹 Cleaning up test directories...${NC}"
    
    local dirs_to_clean=(
        "$ABS_TEST_DIR"
        "$ABS_TEST_DIR-curl"
        "$ABS_TEST_DIR-symlink"
    )
    
    for dir in "${dirs_to_clean[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            echo -e "${GREEN}✅ Removed: $dir${NC}"
        fi
    done
    
    # Clean up any leftover server files
    rm -f "$SOURCE_DIR/temp-server.js" 2>/dev/null || true
}

# Trap for cleanup
trap 'stop_local_server; exit 1' INT TERM

# Main execution
main() {
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
            read -r choice
            echo ""
            
            case $choice in
                1)
                    test_direct_copy
                    echo ""
                    ;;
                2)
                    test_curl_method
                    echo ""
                    ;;
                3)
                    test_symlink_method
                    echo ""
                    ;;
                4)
                    test_direct_copy
                    echo ""
                    test_curl_method
                    echo ""
                    test_symlink_method
                    echo ""
                    ;;
                5)
                    cleanup_test_dirs
                    echo ""
                    ;;
                6)
                    echo -e "${GREEN}👋 Goodbye!${NC}"
                    break
                    ;;
                *)
                    echo -e "${RED}❌ Invalid choice${NC}"
                    echo ""
                    ;;
            esac
        done
    else
        # Run specific test if argument provided
        case $1 in
            "copy"|"1")
                test_direct_copy
                ;;
            "curl"|"2")
                test_curl_method
                ;;
            "symlink"|"3")
                test_symlink_method
                ;;
            "all"|"4")
                test_direct_copy
                test_curl_method
                test_symlink_method
                ;;
            "clean"|"5")
                cleanup_test_dirs
                ;;
            *)
                echo -e "${RED}❌ Unknown test method: $1${NC}"
                echo "Available: copy, curl, symlink, all, clean"
                exit 1
                ;;
        esac
    fi
}

main "$@"