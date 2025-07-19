#!/bin/bash
# Task State Manager
# Manages task state transitions: empty -> started -> completed -> checked -> done

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
SPEC_DIR="./specs"
STATE_FILE=".claude/logs/task-states.json"
LOG_FILE=".claude/logs/task-state-manager.log"

# Ensure required directories exist
mkdir -p "$(dirname "$STATE_FILE")"
mkdir -p "$(dirname "$LOG_FILE")"

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
        "STATE")
            echo -e "${PURPLE}🔄 $message${NC}"
            ;;
    esac
    
    # Log to file
    echo "[$timestamp] [$status] $message" >> "$LOG_FILE"
}

# Initialize state file if it doesn't exist
init_state_file() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{}' > "$STATE_FILE"
        print_status "INFO" "Initialized task state file"
    fi
}

# Get current state of a task
get_task_state() {
    local task_id="$1"
    
    if [ ! -f "$STATE_FILE" ]; then
        echo "empty"
        return
    fi
    
    # Use jq if available, otherwise parse manually
    if command -v jq >/dev/null 2>&1; then
        local state=$(jq -r ".\"$task_id\".state // \"empty\"" "$STATE_FILE" 2>/dev/null)
        echo "${state:-empty}"
    else
        # Fallback: simple grep-based parsing
        if grep -q "\"$task_id\"" "$STATE_FILE" 2>/dev/null; then
            local state=$(grep -A 1 "\"$task_id\"" "$STATE_FILE" | grep "state" | sed 's/.*"state": *"\([^"]*\)".*/\1/')
            echo "${state:-empty}"
        else
            echo "empty"
        fi
    fi
}

# Set task state
set_task_state() {
    local task_id="$1"
    local new_state="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    init_state_file
    
    # Validate state transition
    local current_state=$(get_task_state "$task_id")
    if ! validate_state_transition "$current_state" "$new_state"; then
        print_status "ERROR" "Invalid state transition: $current_state -> $new_state for task $task_id"
        return 1
    fi
    
    # Update state using jq if available
    if command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq --arg task_id "$task_id" --arg state "$new_state" --arg timestamp "$timestamp" \
           '.[$task_id] = {state: $state, timestamp: $timestamp, previous_state: (.[$task_id].state // "empty")}' \
           "$STATE_FILE" > "$temp_file" && mv "$temp_file" "$STATE_FILE"
    else
        # Fallback: manual JSON construction
        local temp_file=$(mktemp)
        {
            echo "{"
            # Copy existing entries except the current task
            if [ -s "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" != "{}" ]; then
                grep -v "\"$task_id\"" "$STATE_FILE" | sed '1d;$d' | sed '$s/,$//'
                echo ","
            fi
            echo "  \"$task_id\": {"
            echo "    \"state\": \"$new_state\","
            echo "    \"timestamp\": \"$timestamp\","
            echo "    \"previous_state\": \"$current_state\""
            echo "  }"
            echo "}"
        } > "$temp_file"
        mv "$temp_file" "$STATE_FILE"
    fi
    
    print_status "STATE" "Task $task_id: $current_state -> $new_state"
    
    # Trigger state-specific actions
    trigger_state_actions "$task_id" "$new_state" "$current_state"
    
    return 0
}

# Validate state transitions
validate_state_transition() {
    local from_state="$1"
    local to_state="$2"
    
    case "$from_state -> $to_state" in
        "empty -> started"|"empty -> completed"|"empty -> checked"|"empty -> done")
            return 0
            ;;
        "started -> completed"|"started -> checked"|"started -> done")
            return 0
            ;;
        "completed -> checked"|"completed -> done")
            return 0
            ;;
        "checked -> done")
            return 0
            ;;
        # Allow same-state transitions (idempotent)
        "$from_state -> $from_state")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Trigger actions based on state changes
trigger_state_actions() {
    local task_id="$1"
    local new_state="$2"
    local previous_state="$3"
    
    case "$new_state" in
        "started")
            print_status "INFO" "Task $task_id started - ready for implementation"
            update_task_symbol "$task_id" "🔄"
            ;;
        "completed")
            print_status "INFO" "Task $task_id completed - triggering quality check"
            update_task_symbol "$task_id" "📝"
            trigger_quality_check "$task_id"
            ;;
        "checked")
            print_status "SUCCESS" "Task $task_id passed quality gates - ready for completion"
            update_task_symbol "$task_id" "✅"
            ;;
        "done")
            print_status "SUCCESS" "Task $task_id marked as done"
            update_task_symbol "$task_id" "🎉"
            ;;
    esac
}

# Update task symbol in specs/tasks.md
update_task_symbol() {
    local task_id="$1"
    local new_symbol="$2"
    
    if [ ! -f "$SPEC_DIR/tasks.md" ]; then
        print_status "WARNING" "tasks.md not found, cannot update task symbol"
        return 1
    fi
    
    # Update the symbol for the task
    if grep -q "$task_id" "$SPEC_DIR/tasks.md"; then
        # Create backup
        cp "$SPEC_DIR/tasks.md" "$SPEC_DIR/tasks.md.backup"
        
        # Replace the symbol (⚪ -> 🔄 -> 📝 -> ✅ -> 🎉)
        sed -i.tmp "/$task_id/ s/[⚪🔄📝✅🎉]/$new_symbol/" "$SPEC_DIR/tasks.md"
        
        rm -f "$SPEC_DIR/tasks.md.tmp"
        print_status "SUCCESS" "Updated task $task_id symbol to $new_symbol"
    else
        print_status "WARNING" "Task $task_id not found in tasks.md"
    fi
}

# Trigger quality check for a completed task
trigger_quality_check() {
    local task_id="$1"
    
    print_status "INFO" "Running quality check for task: $task_id"
    
    # Run the quality check hook
    if [ -x ".claude/hooks/auto-quality-check.sh" ]; then
        if ./.claude/hooks/auto-quality-check.sh "$task_id"; then
            print_status "SUCCESS" "Quality check passed for task $task_id"
            set_task_state "$task_id" "checked"
        else
            print_status "ERROR" "Quality check failed for task $task_id"
            # Keep state as 'completed' so user can fix issues and retry
        fi
    else
        print_status "WARNING" "Quality check hook not found - marking as checked"
        set_task_state "$task_id" "checked"
    fi
}

# List all tasks and their states
list_task_states() {
    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" = "{}" ]; then
        print_status "INFO" "No task states recorded yet"
        return
    fi
    
    echo -e "${BLUE}Current Task States:${NC}"
    echo "===================="
    
    if command -v jq >/dev/null 2>&1; then
        jq -r 'to_entries[] | "\(.key): \(.value.state) (\(.value.timestamp))"' "$STATE_FILE"
    else
        # Fallback parsing
        grep -o '"[^"]*": {[^}]*}' "$STATE_FILE" | while IFS= read -r line; do
            local task_id=$(echo "$line" | sed 's/":\s*{.*//' | tr -d '"')
            local state=$(echo "$line" | sed 's/.*"state":\s*"\([^"]*\)".*/\1/')
            local timestamp=$(echo "$line" | sed 's/.*"timestamp":\s*"\([^"]*\)".*/\1/')
            echo "$task_id: $state ($timestamp)"
        done
    fi
}

# Get tasks in a specific state
get_tasks_in_state() {
    local target_state="$1"
    
    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" = "{}" ]; then
        return
    fi
    
    if command -v jq >/dev/null 2>&1; then
        jq -r --arg state "$target_state" 'to_entries[] | select(.value.state == $state) | .key' "$STATE_FILE"
    else
        # Fallback parsing
        grep -o '"[^"]*": {[^}]*}' "$STATE_FILE" | while IFS= read -r line; do
            local task_id=$(echo "$line" | sed 's/":\s*{.*//' | tr -d '"')
            local state=$(echo "$line" | sed 's/.*"state":\s*"\([^"]*\)".*/\1/')
            if [ "$state" = "$target_state" ]; then
                echo "$task_id"
            fi
        done
    fi
}

# Main function for command-line usage
main() {
    case "${1:-}" in
        "set")
            if [ $# -lt 3 ]; then
                echo "Usage: $0 set <task_id> <state>"
                echo "States: empty, started, completed, checked, done"
                exit 1
            fi
            set_task_state "$2" "$3"
            ;;
        "get")
            if [ $# -lt 2 ]; then
                echo "Usage: $0 get <task_id>"
                exit 1
            fi
            get_task_state "$2"
            ;;
        "list")
            list_task_states
            ;;
        "list-state")
            if [ $# -lt 2 ]; then
                echo "Usage: $0 list-state <state>"
                exit 1
            fi
            get_tasks_in_state "$2"
            ;;
        "trigger-quality")
            if [ $# -lt 2 ]; then
                echo "Usage: $0 trigger-quality <task_id>"
                exit 1
            fi
            trigger_quality_check "$2"
            ;;
        *)
            echo "Task State Manager"
            echo "Usage: $0 {set|get|list|list-state|trigger-quality} [args...]"
            echo ""
            echo "Commands:"
            echo "  set <task_id> <state>    - Set task state"
            echo "  get <task_id>           - Get task state"
            echo "  list                    - List all task states"
            echo "  list-state <state>      - List tasks in specific state"
            echo "  trigger-quality <task_id> - Trigger quality check"
            echo ""
            echo "States: empty -> started -> completed -> checked -> done"
            ;;
    esac
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi