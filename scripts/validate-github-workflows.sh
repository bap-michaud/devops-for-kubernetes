#!/bin/bash

# GitHub Actions Workflow Validation Script
# This script validates GitHub Actions workflow files for syntax and best practices

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_FILES=0
VALID_FILES=0
WARNINGS=0

echo "🔍 Validating GitHub Actions workflows..."
echo "========================================"

# Function to validate YAML syntax
validate_yaml() {
    local file="$1"
    if command -v yq >/dev/null 2>&1; then
        if yq eval '.' "$file" >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    elif command -v python3 >/dev/null 2>&1; then
        if python3 -c "import yaml; yaml.safe_load(open('$file'))" >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  Warning: No YAML validator found (yq or python3). Skipping syntax validation.${NC}"
        return 0
    fi
}

# Function to check workflow best practices
check_best_practices() {
    local file="$1"
    local warnings=0
    
    # Check for required fields
    if ! grep -q "^name:" "$file"; then
        echo -e "  ${YELLOW}⚠️  Missing 'name' field${NC}"
        ((warnings++))
    fi
    
    # Check for on triggers
    if ! grep -q "^on:" "$file"; then
        echo -e "  ${RED}❌ Missing 'on' triggers${NC}"
        ((warnings++))
    fi
    
    # Check for jobs
    if ! grep -q "^jobs:" "$file"; then
        echo -e "  ${RED}❌ Missing 'jobs' section${NC}"
        ((warnings++))
    fi
    
    # Check for checkout action version
    if grep -q "actions/checkout@v[12]" "$file"; then
        echo -e "  ${YELLOW}⚠️  Consider upgrading checkout action to v4${NC}"
        ((warnings++))
    fi
    
    # Check for setup-node action version
    if grep -q "actions/setup-node@v[12]" "$file"; then
        echo -e "  ${YELLOW}⚠️  Consider upgrading setup-node action to v4${NC}"
        ((warnings++))
    fi
    
    # Check for hardcoded secrets
    if grep -qi "password\|token\|key" "$file" | grep -v "secrets\." | grep -v "github.token"; then
        echo -e "  ${YELLOW}⚠️  Potential hardcoded secrets detected${NC}"
        ((warnings++))
    fi
    
    # Check for permissions
    if ! grep -q "permissions:" "$file"; then
        echo -e "  ${YELLOW}⚠️  Consider adding explicit permissions${NC}"
        ((warnings++))
    fi
    
    # Check for timeout-minutes
    if ! grep -q "timeout-minutes:" "$file"; then
        echo -e "  ${YELLOW}⚠️  Consider adding timeout-minutes to prevent hanging jobs${NC}"
        ((warnings++))
    fi
    
    return $warnings
}

# Function to validate a single workflow file
validate_workflow() {
    local file="$1"
    echo -n "📄 $(basename "$file"): "
    
    ((TOTAL_FILES++))
    
    # Check YAML syntax
    if validate_yaml "$file"; then
        echo -e "${GREEN}✅ Valid YAML${NC}"
        ((VALID_FILES++))
        
        # Check best practices
        local file_warnings
        file_warnings=$(check_best_practices "$file")
        if [ "$file_warnings" -gt 0 ]; then
            ((WARNINGS += file_warnings))
        fi
    else
        echo -e "${RED}❌ Invalid YAML syntax${NC}"
    fi
}

# Find and validate all workflow files
find_workflows() {
    local search_paths=(
        "examples/monorepo/.github/workflows"
        "examples/multi-repo/web-app/.github/workflows"
        "examples/multi-repo/api-service/.github/workflows"
        "examples/multi-repo/shared-lib/.github/workflows"
        ".github/workflows"
    )
    
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            echo -e "\n📁 Checking workflows in: ${path}"
            echo "----------------------------------------"
            
            find "$path" -name "*.yml" -o -name "*.yaml" | while read -r file; do
                validate_workflow "$file"
            done
        fi
    done
}

# Main execution
main() {
    find_workflows
    
    echo -e "\n📊 Validation Summary"
    echo "===================="
    echo -e "Total files: ${TOTAL_FILES}"
    echo -e "Valid files: ${GREEN}${VALID_FILES}${NC}"
    echo -e "Warnings: ${YELLOW}${WARNINGS}${NC}"
    
    if [ "$VALID_FILES" -eq "$TOTAL_FILES" ] && [ "$WARNINGS" -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All workflows are valid with no warnings!${NC}"
        exit 0
    elif [ "$VALID_FILES" -eq "$TOTAL_FILES" ]; then
        echo -e "\n${YELLOW}⚠️  All workflows are valid but have warnings. Consider addressing them.${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ Some workflows have syntax errors. Please fix them before proceeding.${NC}"
        exit 1
    fi
}

# Check for required tools
check_dependencies() {
    local missing_tools=()
    
    if ! command -v yq >/dev/null 2>&1 && ! command -v python3 >/dev/null 2>&1; then
        missing_tools+=("yq or python3 (for YAML validation)")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Missing optional tools:${NC}"
        for tool in "${missing_tools[@]}"; do
            echo "   - $tool"
        done
        echo -e "\nValidation will continue with limited functionality.\n"
    fi
}

# Help function
show_help() {
    cat << EOF
GitHub Actions Workflow Validation Script

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help     Show this help message
    -v, --verbose  Enable verbose output

This script validates GitHub Actions workflow files for:
- YAML syntax correctness
- Required workflow fields
- Best practice recommendations
- Security considerations

The script searches for workflow files in:
- examples/monorepo/.github/workflows/
- examples/multi-repo/*/\.github/workflows/
- .github/workflows/

Exit codes:
- 0: All workflows valid
- 1: Syntax errors found
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run the validation
check_dependencies
main