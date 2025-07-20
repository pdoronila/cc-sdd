#!/bin/bash
# Spec-Driven Development Auto-Installer for Claude Code
# Usage: curl -sSL https://raw.githubusercontent.com/pdoronila/cc-sdd/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/pdoronila/cc-sdd/main"
VERSION="1.0.0"
TEMP_DIR="/tmp/claude-sdd-install"

# Global variables
INSTALL_DIR=""
BACKUP_DIR=""
ERRORS=0
WARNINGS=0

print_header() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║               🚀 SPEC-DRIVEN DEVELOPMENT                        ║"
    echo "║                    Auto-Installer for Claude Code               ║"
    echo "║                                                                  ║"
    echo "║                        Version $VERSION                            ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_status() {
    local status=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')
    
    case $status in
        "INFO")
            echo -e "${CYAN}[$timestamp] ℹ️  $message${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[$timestamp] ✅ $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[$timestamp] ⚠️  $message${NC}"
            WARNINGS=$((WARNINGS + 1))
            ;;
        "ERROR")
            echo -e "${RED}[$timestamp] ❌ $message${NC}"
            ERRORS=$((ERRORS + 1))
            ;;
        "STEP")
            echo -e "${BLUE}[$timestamp] 🔧 $message${NC}"
            ;;
    esac
}

check_system() {
    print_status "STEP" "Checking system requirements..."
    
    # Check operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "INFO" "Detected: Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "INFO" "Detected: macOS"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        print_status "INFO" "Detected: Windows (Git Bash/Cygwin)"
    else
        print_status "WARNING" "Unknown OS: $OSTYPE - proceeding anyway"
    fi
    
    # Check for required tools
    local required_tools=("curl" "mkdir" "chmod" "grep")
    for tool in "${required_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            print_status "SUCCESS" "Found required tool: $tool"
        else
            print_status "ERROR" "Missing required tool: $tool"
            return 1
        fi
    done
    
    # Check for optional tools
    local optional_tools=("git" "npm" "node")
    for tool in "${optional_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            print_status "INFO" "Found optional tool: $tool"
        fi
    done
    
    return 0
}

detect_project_type() {
    print_status "STEP" "Detecting project type..."
    
    local project_types=()
    
    # Check for different project types
    if [ -f "package.json" ]; then
        project_types+=("Node.js/JavaScript")
        print_status "SUCCESS" "Detected Node.js project (package.json)"
    fi
    
    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        project_types+=("Python")
        print_status "SUCCESS" "Detected Python project"
    fi
    
    if [ -f "Cargo.toml" ]; then
        project_types+=("Rust")
        print_status "SUCCESS" "Detected Rust project (Cargo.toml)"
    fi
    
    if [ -f "go.mod" ]; then
        project_types+=("Go")
        print_status "SUCCESS" "Detected Go project (go.mod)"
    fi
    
    if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        project_types+=("Java")
        print_status "SUCCESS" "Detected Java project"
    fi
    
    if [ -f ".gitignore" ]; then
        print_status "INFO" "Found .gitignore file"
    fi
    
    if [ ${#project_types[@]} -eq 0 ]; then
        print_status "WARNING" "No specific project type detected - installing generic templates"
        echo ""
        echo -e "${YELLOW}This doesn't look like a standard project directory.${NC}"
        echo -e "${YELLOW}Continue installation anyway? (y/N): ${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_status "INFO" "Installation cancelled by user"
            exit 0
        fi
    else
        print_status "INFO" "Project types detected: ${project_types[*]}"
    fi
}

check_existing_claude_setup() {
    print_status "STEP" "Checking for existing Claude Code setup..."
    
    if [ -d ".claude" ]; then
        print_status "WARNING" "Existing .claude directory found"
        
        # Check what's already there
        if [ -d ".claude/commands" ]; then
            local cmd_count=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l)
            print_status "INFO" "Found $cmd_count existing commands"
        fi
        
        if [ -f ".claude/settings.local.json" ]; then
            print_status "WARNING" "Existing settings.local.json found"
        fi
        
        echo ""
        echo -e "${YELLOW}Existing Claude Code setup detected.${NC}"
        echo -e "${YELLOW}How would you like to proceed?${NC}"
        echo "1) Backup existing and install fresh (recommended)"
        echo "2) Merge with existing setup"
        echo "3) Cancel installation"
        echo ""
        echo -n "Enter your choice (1-3): "
        read -r choice
        
        case $choice in
            1)
                BACKUP_DIR=".claude-backup-$(date +%Y%m%d-%H%M%S)"
                print_status "INFO" "Will backup existing .claude to $BACKUP_DIR"
                ;;
            2)
                print_status "INFO" "Will merge with existing setup"
                ;;
            3)
                print_status "INFO" "Installation cancelled by user"
                exit 0
                ;;
            *)
                print_status "ERROR" "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi
}

create_backup() {
    if [ -n "$BACKUP_DIR" ] && [ -d ".claude" ]; then
        print_status "STEP" "Creating backup of existing Claude setup..."
        
        if cp -r ".claude" "$BACKUP_DIR"; then
            print_status "SUCCESS" "Backup created: $BACKUP_DIR"
        else
            print_status "ERROR" "Failed to create backup"
            return 1
        fi
    fi
}

setup_temp_directory() {
    print_status "STEP" "Setting up temporary directory..."
    
    # Clean up any existing temp directory
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    
    mkdir -p "$TEMP_DIR"
    print_status "SUCCESS" "Created temporary directory: $TEMP_DIR"
}

download_file() {
    local source_path=$1
    local dest_path=$2
    local description=$3
    local url="$GITHUB_REPO/$source_path"
    
    # Create destination directory
    mkdir -p "$(dirname "$dest_path")"
    
    # Try curl first, then wget
    if command -v curl >/dev/null 2>&1; then
        if curl -sSL "$url" -o "$dest_path" --fail --connect-timeout 10; then
            print_status "SUCCESS" "Downloaded: $description"
            return 0
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q "$url" -O "$dest_path" --timeout=10; then
            print_status "SUCCESS" "Downloaded: $description"
            return 0
        fi
    fi
    
    print_status "ERROR" "Failed to download: $description"
    return 1
}

download_all_files() {
    print_status "STEP" "Downloading spec-driven development files..."
    
    # Create directory structure
    local directories=(
        "$TEMP_DIR/.claude/commands"
        "$TEMP_DIR/.claude/utils"
        "$TEMP_DIR/.claude/mcp-servers"
        "$TEMP_DIR/specs"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
    done
    
    # Download command files (Streamlined 5-Command Set)
    local commands=(
        "spec-init.md:Complete project initialization"
        "spec-feat.md:Interactive feature development"
        "spec-validate.md:Specification validation and traceability"
        "spec-work.md:Start next task with automation"
        "spec-done.md:Complete task with quality gates"
    )
    
    for cmd_info in "${commands[@]}"; do
        IFS=':' read -r cmd_file cmd_desc <<< "$cmd_info"
        download_file ".claude/commands/$cmd_file" "$TEMP_DIR/.claude/commands/$cmd_file" "$cmd_desc"
    done
    
    # Download optional utility scripts
    local utils=(
        "validate-specs.sh:Manual spec validation utility"
        "sync-specs.sh:Manual spec synchronization utility"
        "quality-check.sh:Manual quality validation utility"
        "task-state-manager.sh:Manual task state management utility"
    )
    
    for util_info in "${utils[@]}"; do
        IFS=':' read -r util_file util_desc <<< "$util_info"
        download_file ".claude/utils/$util_file" "$TEMP_DIR/.claude/utils/$util_file" "$util_desc"
    done
    
    # Download configuration (merge with existing if present)
    if [ -f ".claude/settings.local.json" ]; then
        # Create backup of existing settings
        BACKUP_FILE=".claude/settings.local.json.backup-$(date +%Y%m%d-%H%M%S)"
        cp ".claude/settings.local.json" "$BACKUP_FILE"
        print_status "INFO" "Backup created: $BACKUP_FILE"
        print_status "INFO" "Merging with existing .claude/settings.local.json"
        
        download_file ".claude/settings.local.json" "$TEMP_DIR/.claude/settings.temp.json" "Claude Code configuration template"
        # Check if spec commands are already configured
        if grep -q "spec-init" ".claude/settings.local.json"; then
            print_status "SUCCESS" "Spec commands already configured"
            cp ".claude/settings.local.json" "$TEMP_DIR/.claude/settings.local.json"
        else
            print_status "INFO" "Adding spec commands to permissions..."
            if command -v jq >/dev/null 2>&1; then
                jq -s '
                    .[0] as $existing | .[1] as $new |
                    $existing * $new |
                    .permissions.allow = (($existing.permissions.allow // []) + ($new.permissions.allow // []) | unique)
                ' ".claude/settings.local.json" "$TEMP_DIR/.claude/settings.temp.json" > "$TEMP_DIR/.claude/settings.local.json"
                print_status "SUCCESS" "Successfully merged settings"
            else
                print_status "WARNING" "jq not found, manual merge recommended"
                cp "$TEMP_DIR/.claude/settings.temp.json" "$TEMP_DIR/.claude/settings.local.json"
            fi
        fi
        rm -f "$TEMP_DIR/.claude/settings.temp.json"
    else
        download_file ".claude/settings.local.json" "$TEMP_DIR/.claude/settings.local.json" "Claude Code configuration"
    fi
    
    # Download MCP server
    download_file ".claude/mcp-servers/spec-sync-server.js" "$TEMP_DIR/.claude/mcp-servers/spec-sync-server.js" "MCP server for advanced sync"
    
    # Download specification templates
    local specs=(
        "requirements.md:Requirements specification template"
        "design.md:Technical design template"
        "tasks.md:Implementation tasks template"
        "api-spec.md:API specification template"
    )
    
    for spec_info in "${specs[@]}"; do
        IFS=':' read -r spec_file spec_desc <<< "$spec_info"
        download_file "specs/$spec_file" "$TEMP_DIR/specs/$spec_file" "$spec_desc"
    done
    
    # Download documentation
    download_file "README.md" "$TEMP_DIR/README-SDD.md" "Documentation"
    download_file "INSTALL.md" "$TEMP_DIR/INSTALL-SDD.md" "Installation guide"
}

install_files() {
    print_status "STEP" "Installing files to project directory..."
    
    # Install .claude directory
    if [ -d "$TEMP_DIR/.claude" ]; then
        cp -r "$TEMP_DIR/.claude" "."
        print_status "SUCCESS" "Installed .claude directory"
        
        # Make utility scripts executable
        if [ -d ".claude/utils" ]; then
            chmod +x .claude/utils/*.sh 2>/dev/null || true
            print_status "SUCCESS" "Made utility scripts executable"
        fi
    fi
    
    # Install specs directory (only if templates don't exist)
    if [ -d "$TEMP_DIR/specs" ]; then
        if [ ! -d "specs" ]; then
            cp -r "$TEMP_DIR/specs" "."
            print_status "SUCCESS" "Installed specification templates"
        else
            print_status "INFO" "Specs directory exists - copying missing templates only"
            for template in "$TEMP_DIR/specs"/*.md; do
                local template_name=$(basename "$template")
                if [ ! -f "specs/$template_name" ]; then
                    cp "$template" "specs/"
                    print_status "SUCCESS" "Added missing template: $template_name"
                else
                    print_status "INFO" "Template exists, skipping: $template_name"
                fi
            done
        fi
    fi
    
    # Install documentation
    if [ -f "$TEMP_DIR/README-SDD.md" ]; then
        cp "$TEMP_DIR/README-SDD.md" "docs-sdd-README.md" 2>/dev/null || cp "$TEMP_DIR/README-SDD.md" "."
        print_status "SUCCESS" "Installed documentation"
    fi
}

install_dependencies() {
    print_status "STEP" "Installing dependencies..."
    
    # Install Node.js dependencies if package.json exists
    if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
        print_status "INFO" "Installing MCP SDK for Node.js project..."
        if npm install @modelcontextprotocol/sdk --save-dev >/dev/null 2>&1; then
            print_status "SUCCESS" "Installed @modelcontextprotocol/sdk"
        else
            print_status "WARNING" "Failed to install MCP SDK (you can install manually later)"
        fi
    fi
    
    # Update package.json scripts if it exists
    if [ -f "package.json" ] && command -v node >/dev/null 2>&1; then
        print_status "INFO" "Adding spec-driven development scripts to package.json..."
        
        # Create a simple script to add scripts
        cat > "$TEMP_DIR/add-scripts.js" << 'EOF'
const fs = require('fs');
const path = require('path');

try {
    const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    
    if (!packageJson.scripts) {
        packageJson.scripts = {};
    }
    
    const newScripts = {
        'spec:validate': './.claude/utils/validate-specs.sh',
        'spec:sync': './.claude/utils/sync-specs.sh'
    };
    
    let added = 0;
    for (const [key, value] of Object.entries(newScripts)) {
        if (!packageJson.scripts[key]) {
            packageJson.scripts[key] = value;
            added++;
        }
    }
    
    if (added > 0) {
        fs.writeFileSync('package.json', JSON.stringify(packageJson, null, 2));
        console.log(`Added ${added} scripts to package.json`);
    } else {
        console.log('Scripts already exist in package.json');
    }
} catch (error) {
    console.error('Failed to update package.json:', error.message);
}
EOF
        
        if node "$TEMP_DIR/add-scripts.js"; then
            print_status "SUCCESS" "Added npm scripts for spec-driven development"
        else
            print_status "WARNING" "Could not update package.json scripts"
        fi
    fi
}

update_gitignore() {
    print_status "STEP" "Updating .gitignore..."
    
    # Note: .gitignore management left to user preference
    print_status "INFO" "Skipping .gitignore modifications - left to user preference"
    return 0
    
    local gitignore_entries=()
    
    local gitignore_file=".gitignore"
    local needs_update=false
    
    # Check if entries need to be added
    for entry in "${gitignore_entries[@]}"; do
        if [ -n "$entry" ] && [ -f "$gitignore_file" ]; then
            if ! grep -Fq "$entry" "$gitignore_file" 2>/dev/null; then
                needs_update=true
                break
            fi
        elif [ -n "$entry" ]; then
            needs_update=true
            break
        fi
    done
    
    if [ "$needs_update" = true ]; then
        for entry in "${gitignore_entries[@]}"; do
            echo "$entry" >> "$gitignore_file"
        done
        print_status "SUCCESS" "Updated .gitignore with spec-driven development entries"
    else
        print_status "INFO" ".gitignore already contains spec-driven development entries"
    fi
}

verify_installation() {
    print_status "STEP" "Verifying installation..."
    
    local required_files=(
        ".claude/commands/spec-init.md"
        ".claude/commands/spec-validate.md"
        ".claude/utils/validate-specs.sh"
        ".claude/settings.local.json"
        "specs/requirements.md"
    )
    
    local missing_files=0
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_status "SUCCESS" "Verified: $file"
        else
            print_status "ERROR" "Missing: $file"
            missing_files=$((missing_files + 1))
        fi
    done
    
    if [ $missing_files -gt 0 ]; then
        print_status "ERROR" "$missing_files required files are missing"
        return 1
    fi
    
    # Test utility execution
    if [ -x ".claude/utils/validate-specs.sh" ]; then
        if ./.claude/utils/validate-specs.sh >/dev/null 2>&1; then
            print_status "SUCCESS" "Utility validation test passed"
        else
            print_status "INFO" "Utility validation has warnings (normal for new installations)"
        fi
    fi
    
    print_status "SUCCESS" "Installation verification completed"
    return 0
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        print_status "SUCCESS" "Cleaned up temporary files"
    fi
}

print_completion_summary() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  🎉 SPEC-DRIVEN DEVELOPMENT INSTALLATION COMPLETE! 🎉          ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_status "SUCCESS" "Installation completed with $WARNINGS warnings and $ERRORS errors"
    
    if [ -n "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}📁 Backup of previous setup: $BACKUP_DIR${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}🚀 QUICK START GUIDE:${NC}"
    echo ""
    echo -e "${CYAN}1. Initialize your project specifications:${NC}"
    echo -e "   ${YELLOW}claude /spec-init${NC}"
    echo ""
    echo -e "${CYAN}2. Validate your setup:${NC}"
    echo -e "   ${YELLOW}claude /spec-validate${NC}"
    echo ""
    echo -e "${CYAN}3. Start developing with automated spec synchronization!${NC}"
    echo ""
    
    echo -e "${BLUE}📚 STREAMLINED 5-COMMAND WORKFLOW:${NC}"
    local commands=(
        "/spec-init     |Initialize project specifications (setup phase)"
        "/spec-tasks    |Generate implementation tasks from requirements"
        "/spec-validate |Validate specifications and requirement traceability"
        "/spec-work     |Auto-select and start next task"
        "/spec-done     |Complete task and start next (with quality gates)"
    )
    
    for cmd in "${commands[@]}"; do
        IFS='|' read -r cmd_name cmd_desc <<< "$cmd"
        printf "  ${YELLOW}%-15s${NC} - %s\n" "$cmd_name" "$cmd_desc"
    done
    
    echo ""
    echo -e "${BLUE}🔧 OPTIONAL UTILITIES (manual use):${NC}"
    echo -e "  ${YELLOW}./.claude/utils/validate-specs.sh${NC}     - Manual specification validation"
    echo -e "  ${YELLOW}./.claude/utils/sync-specs.sh${NC}         - Manual specification sync"
    echo -e "  ${YELLOW}./.claude/utils/quality-check.sh${NC}      - Manual quality validation"
    echo -e "  ${YELLOW}./.claude/utils/task-state-manager.sh${NC} - Manual task state management"
    
    if [ -f "package.json" ]; then
        echo ""
        echo -e "${BLUE}📦 NPM SCRIPTS (if available):${NC}"
        echo -e "  ${YELLOW}npm run spec:validate${NC} - Validate specifications"
        echo -e "  ${YELLOW}npm run spec:sync${NC}     - Synchronize specifications"
    fi
    
    echo ""
    echo -e "${BLUE}📖 DOCUMENTATION:${NC}"
    echo -e "  Local: ${YELLOW}docs-sdd-README.md${NC} (or README-SDD.md)"
    echo -e "  Online: ${YELLOW}https://github.com/pdoronila/cc-sdd${NC}"
    echo ""
    
    if [ $ERRORS -gt 0 ]; then
        echo -e "${RED}⚠️  Some errors occurred during installation. Check the output above.${NC}"
        echo -e "${RED}   You may need to manually install missing components.${NC}"
        echo ""
    fi
    
    echo -e "${GREEN}Happy spec-driven development! 🚀${NC}"
    echo ""
}

# Error handling
handle_error() {
    local line_number=$1
    print_status "ERROR" "Installation failed at line $line_number"
    cleanup
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR
trap 'print_status "INFO" "Installation interrupted by user"; cleanup; exit 1' INT TERM

# Main installation function
main() {
    print_header
    
    # Pre-installation checks
    check_system || exit 1
    detect_project_type
    check_existing_claude_setup
    
    # Installation process
    create_backup
    setup_temp_directory
    download_all_files
    install_files
    install_dependencies
    update_gitignore
    verify_installation
    cleanup
    
    # Show completion summary
    print_completion_summary
}

# Run the installer
main "$@"