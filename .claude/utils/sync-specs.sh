#!/bin/bash

# Specification Synchronization Post-Edit Hook
# This hook automatically synchronizes specifications when files are modified

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SPEC_DIR="./specs"
PROJECT_ROOT="."
LOG_FILE=".claude/logs/sync-specs.log"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $status in
        "ERROR")
            echo -e "${RED}❌ ERROR: $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  WARNING: $message${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
    
    # Log to file if log directory exists
    if [ -d "$(dirname "$LOG_FILE")" ]; then
        echo "[$timestamp] [$status] $message" >> "$LOG_FILE"
    fi
}

# Function to detect what type of files were modified
detect_changes() {
    local modified_files=()
    
    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Get recently modified files from git
        modified_files=($(git diff --name-only HEAD~1 HEAD 2>/dev/null || git diff --name-only --cached 2>/dev/null || true))
    else
        # Fallback: check recently modified files (last 5 minutes)
        modified_files=($(find "$PROJECT_ROOT" -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.md" -type f -mmin -5 2>/dev/null || true))
    fi
    
    echo "${modified_files[@]}"
}

# Function to analyze if specifications need updates
analyze_spec_sync_needs() {
    local modified_files=("$@")
    local needs_sync=false
    local sync_reasons=()
    
    for file in "${modified_files[@]}"; do
        case "$file" in
            *.js|*.ts|*.jsx|*.tsx)
                if grep -q "export\|function\|class\|interface" "$file" 2>/dev/null; then
                    needs_sync=true
                    sync_reasons+=("API/Component changes detected in $file")
                fi
                ;;
            *.py)
                if grep -q "def\|class\|@app.route" "$file" 2>/dev/null; then
                    needs_sync=true
                    sync_reasons+=("API/Class changes detected in $file")
                fi
                ;;
            package.json|requirements.txt|Cargo.toml|go.mod)
                needs_sync=true
                sync_reasons+=("Dependency changes detected in $file")
                ;;
            *migration*|*schema*)
                needs_sync=true
                sync_reasons+=("Database schema changes detected in $file")
                ;;
            *config*|*.env|*.yaml|*.yml)
                needs_sync=true
                sync_reasons+=("Configuration changes detected in $file")
                ;;
        esac
    done
    
    if [ "$needs_sync" = true ]; then
        print_status "INFO" "Specification synchronization triggered by:"
        for reason in "${sync_reasons[@]}"; do
            print_status "INFO" "  - $reason"
        done
        return 0
    else
        return 1
    fi
}

# Function to update specifications with sync timestamps
update_spec_timestamps() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    for spec_file in "$SPEC_DIR"/*.md; do
        if [ -f "$spec_file" ]; then
            local filename=$(basename "$spec_file")
            
            if ! grep -q "Last Sync:" "$spec_file"; then
                echo "" >> "$spec_file"
                echo "---" >> "$spec_file" 
                echo "*Last Sync: $timestamp*" >> "$spec_file"
            else
                sed -i.bak "s/Last Sync:.*/Last Sync: $timestamp*/" "$spec_file"
                rm -f "$spec_file.bak"
            fi
            
            print_status "SUCCESS" "Updated sync timestamp for $filename"
        fi
    done
}

# Main execution
main() {
    print_status "INFO" "Starting specification synchronization..."
    
    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # Detect what files were modified
    modified_files=($(detect_changes))
    
    if [ ${#modified_files[@]} -eq 0 ]; then
        print_status "INFO" "No recent file modifications detected"
        exit 0
    fi
    
    print_status "INFO" "Detected ${#modified_files[@]} modified files"
    
    # Check if specifications need synchronization
    if analyze_spec_sync_needs "${modified_files[@]}"; then
        print_status "INFO" "Proceeding with specification synchronization..."
        
        # Update specification timestamps
        update_spec_timestamps
        
        print_status "SUCCESS" "Specification synchronization completed"
        print_status "INFO" "For comprehensive updates, run: /spec-update"
    else
        print_status "INFO" "No specification synchronization needed for current changes"
    fi
}

# Run main function
main "$@"