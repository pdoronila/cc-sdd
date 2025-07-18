#!/bin/bash

# Specification Validation Pre-Commit Hook
# This hook validates specification consistency before allowing commits

set -e

echo "🔍 Running specification validation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SPEC_DIR="./specs"
ERRORS=0
WARNINGS=0

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "ERROR")
            echo -e "${RED}❌ ERROR: $message${NC}"
            ERRORS=$((ERRORS + 1))
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  WARNING: $message${NC}"
            WARNINGS=$((WARNINGS + 1))
            ;;
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "INFO")
            echo -e "ℹ️  $message"
            ;;
    esac
}

# Check if specs directory exists
if [ ! -d "$SPEC_DIR" ]; then
    print_status "ERROR" "Specs directory not found: $SPEC_DIR"
    exit 1
fi

print_status "INFO" "Validating specifications in $SPEC_DIR"

# Validate required specification files exist
required_files=("requirements.md" "design.md" "tasks.md")
for file in "${required_files[@]}"; do
    if [ ! -f "$SPEC_DIR/$file" ]; then
        print_status "ERROR" "Required specification file missing: $file"
    else
        print_status "SUCCESS" "Found required file: $file"
    fi
done

# Check for empty specification files
for file in "$SPEC_DIR"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Check if file is effectively empty (less than 100 characters of content)
        content_size=$(grep -v '^#' "$file" | grep -v '^$' | wc -c)
        if [ "$content_size" -lt 100 ]; then
            print_status "WARNING" "Specification file appears to be mostly empty: $filename"
        fi
    fi
done

# Validate requirements.md structure
if [ -f "$SPEC_DIR/requirements.md" ]; then
    print_status "INFO" "Validating requirements.md structure..."
    
    # Check for required sections
    required_sections=("Project Overview" "User Stories" "Functional Requirements" "Non-Functional Requirements")
    for section in "${required_sections[@]}"; do
        if grep -q "$section" "$SPEC_DIR/requirements.md"; then
            print_status "SUCCESS" "Found required section: $section"
        else
            print_status "WARNING" "Missing recommended section in requirements.md: $section"
        fi
    done
    
    # Check for EARS format user stories
    if grep -q "WHEN.*THE SYSTEM SHALL" "$SPEC_DIR/requirements.md"; then
        print_status "SUCCESS" "Found EARS format user stories"
    else
        print_status "WARNING" "No EARS format user stories found (WHEN...THE SYSTEM SHALL...WHERE)"
    fi
fi

# Validate design.md structure  
if [ -f "$SPEC_DIR/design.md" ]; then
    print_status "INFO" "Validating design.md structure..."
    
    required_sections=("Architecture Overview" "Technology Stack" "Component Design" "Data Models")
    for section in "${required_sections[@]}"; do
        if grep -q "$section" "$SPEC_DIR/design.md"; then
            print_status "SUCCESS" "Found required section: $section"
        else
            print_status "WARNING" "Missing recommended section in design.md: $section"
        fi
    done
fi

# Validate tasks.md structure
if [ -f "$SPEC_DIR/tasks.md" ]; then
    print_status "INFO" "Validating tasks.md structure..."
    
    # Check for task status indicators
    if grep -q "\[\s*\]" "$SPEC_DIR/tasks.md"; then
        print_status "SUCCESS" "Found task checkboxes"
    else
        print_status "WARNING" "No task checkboxes found in tasks.md"
    fi
    
    # Check for effort estimates
    if grep -q -i "effort\|hours\|points" "$SPEC_DIR/tasks.md"; then
        print_status "SUCCESS" "Found effort estimates"
    else
        print_status "WARNING" "No effort estimates found in tasks.md"
    fi
fi

# Validate API specification if it exists
if [ -f "$SPEC_DIR/api-spec.md" ]; then
    print_status "INFO" "Validating api-spec.md structure..."
    
    api_sections=("Authentication" "Error Handling" "API Endpoints")
    for section in "${api_sections[@]}"; do
        if grep -q "$section" "$SPEC_DIR/api-spec.md"; then
            print_status "SUCCESS" "Found API section: $section"
        else
            print_status "WARNING" "Missing recommended API section: $section"
        fi
    done
fi

# Final validation summary
echo ""
echo "📊 Validation Summary:"
echo "   Errors: $ERRORS"
echo "   Warnings: $WARNINGS"

if [ $ERRORS -gt 0 ]; then
    print_status "ERROR" "Specification validation failed with $ERRORS errors"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    print_status "WARNING" "Specification validation completed with $WARNINGS warnings"
else
    print_status "SUCCESS" "All specifications validated successfully!"
fi

exit 0