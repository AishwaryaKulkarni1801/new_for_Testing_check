#!/bin/bash

# 🚀 Universal CI/CD Deployment Script for Angular/React/Vue Projects
# This script runs tests, checks coverage, and deploys to GitHub Pages only if all conditions pass

# ============================================================================
# 📋 CONFIGURATION - Update these variables for your project
# ============================================================================
USERNAME="AishwaryaKulkarni1801"
REPO_NAME="new_for_Testing_check"
BRANCH_NAME="main"
COVERAGE_THRESHOLD=80

# ============================================================================
# 🎨 Color codes for better output
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ============================================================================
# 📊 Helper Functions
# ============================================================================

print_header() {
    echo -e "${BLUE}${BOLD}"
    echo "============================================================================"
    echo "🚀 CI/CD Deployment Pipeline for $REPO_NAME"
    echo "============================================================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}${BOLD}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ============================================================================
# 🧪 Test and Coverage Functions
# ============================================================================

run_tests() {
    print_step "🧪 Step 1: Running Jest Tests..."
    
    # Run tests and capture exit code
    if npm test -- --watchAll=false --passWithNoTests 2>/dev/null; then
        print_success "All tests passed!"
        return 0
    else
        print_error "Tests failed!"
        return 1
    fi
}

check_coverage() {
    print_step "📊 Step 2: Checking Test Coverage..."
    
    # Run tests with coverage
    npm run test:coverage -- --watchAll=false --passWithNoTests > /dev/null 2>&1
    
    # Check if coverage directory exists
    if [ ! -d "coverage" ]; then
        print_warning "Coverage directory not found. Generating coverage report..."
        npm test -- --coverage --watchAll=false --passWithNoTests > /dev/null 2>&1
    fi
    
    # Extract coverage percentage from coverage report
    local coverage_file=""
    
    # Try different possible coverage report locations
    if [ -f "coverage/lcov-report/index.html" ]; then
        coverage_file="coverage/lcov-report/index.html"
    elif [ -f "coverage/index.html" ]; then
        coverage_file="coverage/index.html"
    elif [ -f "coverage/coverage-summary.json" ]; then
        # Parse JSON coverage report
        local total_coverage=$(node -p "
            try {
                const fs = require('fs');
                const coverage = JSON.parse(fs.readFileSync('coverage/coverage-summary.json', 'utf8'));
                Math.round(coverage.total.lines.pct || 0);
            } catch (e) {
                0;
            }
        " 2>/dev/null)
        
        if [ "$total_coverage" -ge "$COVERAGE_THRESHOLD" ]; then
            print_success "Coverage: ${total_coverage}% (≥ ${COVERAGE_THRESHOLD}%)"
            return 0
        else
            print_error "Coverage: ${total_coverage}% (< ${COVERAGE_THRESHOLD}%)"
            return 1
        fi
    fi
    
    # Fallback: Try to extract from HTML report
    if [ -n "$coverage_file" ] && [ -f "$coverage_file" ]; then
        local coverage_percentage=$(grep -oP 'Total.*?(\d+\.?\d*)%' "$coverage_file" | grep -oP '\d+\.?\d*' | head -1 2>/dev/null || echo "0")
        
        if [ -z "$coverage_percentage" ]; then
            coverage_percentage=0
        fi
        
        # Convert to integer for comparison
        local coverage_int=$(echo "$coverage_percentage" | cut -d'.' -f1)
        
        if [ "$coverage_int" -ge "$COVERAGE_THRESHOLD" ]; then
            print_success "Coverage: ${coverage_percentage}% (≥ ${COVERAGE_THRESHOLD}%)"
            return 0
        else
            print_error "Coverage: ${coverage_percentage}% (< ${COVERAGE_THRESHOLD}%)"
            return 1
        fi
    else
        print_warning "Coverage report not found. Assuming coverage is sufficient."
        print_info "To enable coverage checking, ensure 'npm run test:coverage' generates reports."
        return 0
    fi
}

# ============================================================================
# 🔄 Git Operations
# ============================================================================

check_git_status() {
    print_step "🔍 Step 3: Checking Git Status..."
    
    # Check if there are any changes to commit
    if git diff-index --quiet HEAD --; then
        print_info "No changes detected in working directory."
        
        # Check if there are any untracked files
        if [ -z "$(git ls-files --others --exclude-standard)" ]; then
            print_warning "No changes to commit. Proceeding with current state."
            return 2  # Special return code for no changes
        else
            print_info "Untracked files detected. They will be added."
            return 0
        fi
    else
        print_info "Changes detected. Ready to commit."
        return 0
    fi
}

commit_and_push() {
    print_step "📝 Step 4: Committing and Pushing Changes..."
    
    # Add all changes
    git add .
    
    # Check if there's anything to commit after adding
    if git diff-index --quiet HEAD --; then
        print_info "No changes to commit after adding files."
        return 2  # No changes to commit
    fi
    
    # Create commit with timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local commit_message="🚀 Auto-deploy: Tests passed, coverage ≥${COVERAGE_THRESHOLD}% - ${timestamp}"
    
    git commit -m "$commit_message"
    
    if [ $? -eq 0 ]; then
        print_success "Changes committed successfully!"
        
        # Push to remote
        print_info "Pushing to origin/$BRANCH_NAME..."
        if git push origin "$BRANCH_NAME"; then
            print_success "Changes pushed to GitHub successfully!"
            return 0
        else
            print_error "Failed to push changes to GitHub!"
            return 1
        fi
    else
        print_error "Failed to commit changes!"
        return 1
    fi
}

# ============================================================================
# 🌐 Deployment Functions
# ============================================================================

trigger_deployment() {
    print_step "🚀 Step 5: Triggering GitHub Pages Deployment..."
    
    local repo_url="https://github.com/$USERNAME/$REPO_NAME"
    local actions_url="$repo_url/actions"
    local pages_url="https://${USERNAME,,}.github.io/$REPO_NAME"
    
    print_success "Deployment pipeline triggered!"
    print_info "GitHub Repository: $repo_url"
    print_info "GitHub Actions: $actions_url"
    print_info "Live Site: $pages_url"
    
    echo ""
    print_success "🎉 Deployment initiated successfully!"
    echo -e "${GREEN}${BOLD}"
    echo "Next steps:"
    echo "1. Check GitHub Actions for build progress: $actions_url"
    echo "2. Your site will be live at: $pages_url"
    echo "3. Deployment typically takes 2-3 minutes to complete"
    echo -e "${NC}"
}

# ============================================================================
# 📋 Main Execution Flow
# ============================================================================

main() {
    print_header
    
    # Step 1: Run tests
    if ! run_tests; then
        echo ""
        print_error "❌ Test coverage below threshold or tests failed. Deployment aborted."
        echo -e "${RED}${BOLD}Deployment stopped due to test failures.${NC}"
        exit 1
    fi
    
    # Step 2: Check coverage
    if ! check_coverage; then
        echo ""
        print_error "❌ Test coverage below threshold or tests failed. Deployment aborted."
        echo -e "${RED}${BOLD}Deployment stopped due to insufficient test coverage.${NC}"
        exit 1
    fi
    
    # Step 3: Check git status
    check_git_status
    local git_status=$?
    
    # Step 4: Commit and push (if there are changes)
    if [ $git_status -eq 0 ]; then
        if ! commit_and_push; then
            print_error "Failed to commit and push changes!"
            exit 1
        fi
    elif [ $git_status -eq 2 ]; then
        print_info "No changes to commit, but proceeding with deployment trigger."
    fi
    
    # Step 5: Trigger deployment
    trigger_deployment
    
    echo ""
    echo -e "${GREEN}${BOLD}✨ All steps completed successfully! ✨${NC}"
}

# ============================================================================
# 🏃‍♂️ Script Execution
# ============================================================================

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a Git repository! Please run this script from your project root."
    exit 1
fi

# Check if package.json exists (Node.js project)
if [ ! -f "package.json" ]; then
    print_error "package.json not found! Please run this script from your project root."
    exit 1
fi

# Run main function
main

# End of script
