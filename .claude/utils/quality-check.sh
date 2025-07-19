#!/bin/bash
# Auto Quality Check Hook
# Validates quality gates when tasks are marked as completed and auto-fixes issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SPEC_DIR="./specs"
LOG_FILE=".claude/logs/auto-quality-check.log"
TEMP_FILE="/tmp/claude_completion_check.tmp"

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

# Function to validate task ID format
validate_task_id() {
    local task_id="$1"
    if [[ "$task_id" =~ ^(Epic|Task)\ [0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to detect project type and return appropriate commands
detect_project_commands() {
    local project_type=""
    local compile_cmd=""
    local test_cmd=""
    local lint_cmd=""
    local format_cmd=""
    local type_check_cmd=""
    
    # Detect project type and set commands
    if [ -f "package.json" ]; then
        project_type="Node.js/TypeScript"
        compile_cmd="npm run build"
        test_cmd="npm test"
        lint_cmd="npm run lint"
        format_cmd="npm run format"
        type_check_cmd="npx tsc --noEmit"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        project_type="Python"
        compile_cmd="python -m py_compile *.py"
        test_cmd="python -m pytest"
        lint_cmd="flake8 ."
        format_cmd="black ."
        type_check_cmd="mypy ."
    elif [ -f "Cargo.toml" ]; then
        project_type="Rust"
        compile_cmd="cargo check"
        test_cmd="cargo test"
        lint_cmd="cargo clippy"
        format_cmd="cargo fmt"
    elif [ -f "go.mod" ]; then
        project_type="Go"
        compile_cmd="go build"
        test_cmd="go test ./..."
        lint_cmd="golangci-lint run"
        format_cmd="go fmt ./..."
    elif [ -f "pom.xml" ]; then
        project_type="Java (Maven)"
        compile_cmd="mvn compile"
        test_cmd="mvn test"
        lint_cmd="mvn checkstyle:check"
    elif [ -f "build.gradle" ]; then
        project_type="Java (Gradle)"
        compile_cmd="./gradlew build"
        test_cmd="./gradlew test"
        lint_cmd="./gradlew check"
    elif [ -f "mix.exs" ]; then
        project_type="Elixir/Phoenix"
        compile_cmd="mix compile"
        test_cmd="mix test"
        lint_cmd="mix credo"
        format_cmd="mix format"
        type_check_cmd="mix dialyzer"
    fi
    
    echo "$project_type|$compile_cmd|$test_cmd|$lint_cmd|$format_cmd|$type_check_cmd"
}

# Function to run quality gates and auto-fix issues
run_quality_gates() {
    local task_id="$1"
    
    print_status "INFO" "Running quality gates for task: $task_id"
    
    # Get project commands
    local project_info=$(detect_project_commands)
    IFS='|' read -r project_type compile_cmd test_cmd lint_cmd format_cmd type_check_cmd <<< "$project_info"
    
    if [ -z "$project_type" ]; then
        print_status "WARNING" "No supported project type detected - skipping quality gates"
        return 0
    fi
    
    print_status "INFO" "Detected project type: $project_type"
    
    local quality_failed=false
    local fix_attempts=0
    local max_fix_attempts=3
    
    while [ $fix_attempts -lt $max_fix_attempts ]; do
        fix_attempts=$((fix_attempts + 1))
        print_status "INFO" "Quality gate validation attempt $fix_attempts/$max_fix_attempts"
        
        # 1. Code Formatting (auto-fix)
        if [ -n "$format_cmd" ]; then
            print_status "INFO" "Running code formatting..."
            if eval "$format_cmd" >/dev/null 2>&1; then
                print_status "SUCCESS" "Code formatting completed"
            else
                print_status "WARNING" "Code formatting failed or not available"
            fi
        fi
        
        # 2. Compilation Check
        if [ -n "$compile_cmd" ]; then
            print_status "INFO" "Checking compilation..."
            if eval "$compile_cmd" >/dev/null 2>&1; then
                print_status "SUCCESS" "Code compiles successfully"
            else
                print_status "ERROR" "Compilation failed"
                quality_failed=true
                break
            fi
        fi
        
        # 3. Test Suite
        if [ -n "$test_cmd" ]; then
            print_status "INFO" "Running test suite..."
            if eval "$test_cmd" >/dev/null 2>&1; then
                print_status "SUCCESS" "All tests pass"
            else
                print_status "ERROR" "Tests are failing"
                quality_failed=true
                break
            fi
        fi
        
        # 4. Linting (with auto-fix attempt)
        if [ -n "$lint_cmd" ]; then
            print_status "INFO" "Running code linting..."
            if eval "$lint_cmd" >/dev/null 2>&1; then
                print_status "SUCCESS" "Code linting passed"
            else
                print_status "WARNING" "Linting issues detected - attempting auto-fix"
                
                # Try auto-fix for common linters
                case "$project_type" in
                    "Node.js/TypeScript")
                        eval "npm run lint -- --fix" >/dev/null 2>&1 || true
                        ;;
                    "Python")
                        eval "autopep8 --in-place --recursive ." >/dev/null 2>&1 || true
                        ;;
                    "Rust")
                        eval "cargo clippy --fix --allow-dirty" >/dev/null 2>&1 || true
                        ;;
                    "Go")
                        eval "go fmt ./..." >/dev/null 2>&1 || true
                        ;;
                    "Elixir/Phoenix")
                        eval "mix format" >/dev/null 2>&1 || true
                        ;;
                esac
                
                # Re-check linting
                if eval "$lint_cmd" >/dev/null 2>&1; then
                    print_status "SUCCESS" "Linting issues auto-fixed"
                else
                    print_status "WARNING" "Some linting issues remain"
                fi
            fi
        fi
        
        # 5. Type Checking (if applicable)
        if [ -n "$type_check_cmd" ]; then
            print_status "INFO" "Running type checking..."
            if eval "$type_check_cmd" >/dev/null 2>&1; then
                print_status "SUCCESS" "Type checking passed"
            else
                print_status "ERROR" "Type checking failed"
                quality_failed=true
                break
            fi
        fi
        
        # 6. Additional project-specific checks
        case "$project_type" in
            "Elixir/Phoenix")
                # Phoenix-specific checks
                if command -v mix >/dev/null 2>&1; then
                    if mix phx.routes >/dev/null 2>&1; then
                        print_status "SUCCESS" "Phoenix routes compile"
                    fi
                    
                    if mix ecto.migrate --dry-run >/dev/null 2>&1; then
                        print_status "SUCCESS" "Database migrations valid"
                    fi
                    
                    if mix deps.get >/dev/null 2>&1; then
                        print_status "SUCCESS" "Dependencies satisfied"
                    fi
                fi
                ;;
        esac
        
        # If we get here without failures, quality gates passed
        if [ "$quality_failed" = false ]; then
            print_status "SUCCESS" "All quality gates passed!"
            return 0
        fi
    done
    
    if [ "$quality_failed" = true ]; then
        print_status "ERROR" "Quality gates failed after $max_fix_attempts attempts"
        return 1
    fi
    
    return 0
}

# Function to update task status in specs/tasks.md
update_task_status() {
    local task_id="$1"
    local task_title="$2"
    local completion_date=$(date '+%Y-%m-%d')
    
    if [ ! -f "$SPEC_DIR/tasks.md" ]; then
        print_status "WARNING" "tasks.md not found, cannot update task status"
        return 1
    fi
    
    # Check if task is already completed to avoid conflicts with /spec-done
    if grep -A 2 "$task_id" "$SPEC_DIR/tasks.md" | grep -q "✅\|Completed:"; then
        print_status "INFO" "Task $task_id already completed (possibly by /spec-done)"
        return 0
    fi
    
    print_status "INFO" "Updating task status for: $task_id"
    
    # Create backup
    cp "$SPEC_DIR/tasks.md" "$SPEC_DIR/tasks.md.backup"
    
    # Update task status from pending/in-progress to completed
    # Look for the task pattern and update it
    if grep -q "$task_id" "$SPEC_DIR/tasks.md"; then
        # Replace [ ] or [x] with [x] and update status symbols
        sed -i.tmp "
            /$task_id/ {
                s/- \[ \]/- [x]/
                s/⚪/✅/g
                s/🔄/✅/g
                s/📝/✅/g
            }
        " "$SPEC_DIR/tasks.md"
        
        # Add completion timestamp if not already present
        if ! grep -A 3 "$task_id" "$SPEC_DIR/tasks.md" | grep -q "Completed:"; then
            # Find the line with task_id and add completion info after it
            awk -v task_id="$task_id" -v completion_date="$completion_date" '
                $0 ~ task_id { 
                    print $0
                    print "  - **Completed**: " completion_date
                    next 
                }
                { print }
            ' "$SPEC_DIR/tasks.md" > "$SPEC_DIR/tasks.md.new"
            mv "$SPEC_DIR/tasks.md.new" "$SPEC_DIR/tasks.md"
        fi
        
        rm -f "$SPEC_DIR/tasks.md.tmp"
        print_status "SUCCESS" "Updated task status for $task_id"
        return 0
    else
        print_status "WARNING" "Task $task_id not found in tasks.md"
        return 1
    fi
}

# Function to generate completion summary
generate_completion_summary() {
    local task_id="$1"
    local task_title="$2"
    
    local summary_file=".claude/logs/quality-check-summary-$(date +%Y%m%d-%H%M%S).md"
    mkdir -p "$(dirname "$summary_file")"
    
    cat > "$summary_file" << EOF
# Quality Check and Task Completion Summary

**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Task**: $task_id - $task_title
**Status**: ✅ Quality Gates Passed and Task Completed

## Actions Taken
- [x] Quality gates validated (compile, test, lint, format)
- [x] Auto-fixes applied where possible
- [x] Task marked as completed in specs/tasks.md
- [x] Completion timestamp added
- [x] Backup created of tasks.md

## Next Steps
Run these commands to continue:
1. \`claude /spec-status\` - View updated progress
2. \`claude /spec-validate\` - Validate specifications
3. \`claude /spec-next\` - Get next task

## Files Modified
- $SPEC_DIR/tasks.md (task status updated)
- $summary_file (this summary)

---
*Auto-generated by spec-driven development auto-quality-check hook*
EOF

    print_status "SUCCESS" "Completion summary created: $summary_file"
}

# Function to suggest next actions after successful quality check
suggest_next_actions_success() {
    local task_id="$1"
    echo ""
    echo -e "${BLUE}🎉 Quality validation completed successfully!${NC}"
    echo ""
    echo -e "${GREEN}Task: $task_id${NC}"
    echo -e "${GREEN}Status: completed → checked ✅${NC}"
    echo ""
    echo -e "${YELLOW}Ready to continue? Choose next step:${NC}"
    echo -e "1. ${GREEN}claude /spec-done${NC}      - Mark task as done + start next task (recommended)"
    echo -e "2. ${GREEN}claude /spec-work${NC}      - Auto-select and start next task"
    echo -e "3. ${GREEN}claude /spec-status${NC}    - View updated progress overview"
    echo ""
    echo -e "${BLUE}✅ Quality gates passed - task is ready for completion!${NC}"
    echo ""
}

# Function to suggest next actions after failed quality check
suggest_next_actions_failure() {
    local task_id="$1"
    echo ""
    echo -e "${RED}❌ Quality validation failed${NC}"
    echo ""
    echo -e "${YELLOW}Task: $task_id${NC}"
    echo -e "${YELLOW}Status: completed (quality check failed)${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "1. ${YELLOW}Fix the issues reported above${NC}"
    echo -e "2. ${YELLOW}Test your fixes locally${NC}"
    echo -e "3. ${GREEN}claude /spec-completed${NC} - Retry quality validation"
    echo ""
    echo -e "${BLUE}ℹ️  The task remains in 'completed' state until quality gates pass${NC}"
    echo ""
}

# Main execution
main() {
    local task_id="${1:-}"
    
    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"
    
    if [ -z "$task_id" ]; then
        print_status "ERROR" "Task ID required. Usage: $0 <task_id>"
        echo ""
        echo "Example: $0 \"Epic 1.2\""
        return 1
    fi
    
    # Validate task ID format
    if ! validate_task_id "$task_id"; then
        print_status "ERROR" "Invalid task ID format: $task_id"
        print_status "INFO" "Expected format: 'Epic X.Y' or 'Task X.Y'"
        return 1
    fi
    
    print_status "INFO" "Running quality validation for task: $task_id"
    
    # Run quality gates
    if run_quality_gates "$task_id"; then
        print_status "SUCCESS" "Quality gates passed for task $task_id"
        
        # Update task status in specs/tasks.md
        if update_task_status "$task_id" "Quality gates passed"; then
            # Generate completion summary
            generate_completion_summary "$task_id" "Quality validation completed"
            
            print_status "SUCCESS" "Task $task_id passed quality validation"
            
            # Suggest next actions
            suggest_next_actions_success "$task_id"
        else
            print_status "ERROR" "Failed to update task status for $task_id"
        fi
        
        return 0
    else
        print_status "ERROR" "Quality gates failed for task $task_id"
        suggest_next_actions_failure "$task_id"
        return 1
    fi
}

# Run main function
main "$@"