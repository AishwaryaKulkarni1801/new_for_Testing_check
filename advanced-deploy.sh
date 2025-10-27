#!/bin/bash

# 🚀 Advanced CI/CD Script with Coverage Validation and Conditional Deployment
# This script runs tests, validates coverage, builds, and conditionally deploys to GitHub Pages

# ============================================================================
# 📋 CONFIGURATION - Update these variables for your project
# ============================================================================
USERNAME="AishwaryaKulkarni1801"
REPO_NAME="new_for_Testing_check"
BRANCH_NAME="main"
COVERAGE_THRESHOLD=80

# ============================================================================
# 🎨 Color codes and formatting
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ============================================================================
# 📊 Helper Functions
# ============================================================================

print_header() {
    echo -e "${BLUE}${BOLD}"
    echo "============================================================================"
    echo "🚀 Advanced CI/CD Pipeline with Coverage Validation"
    echo "📦 Project: $REPO_NAME"
    echo "👤 User: $USERNAME"
    echo "🌿 Branch: $BRANCH_NAME"
    echo "📊 Coverage Threshold: $COVERAGE_THRESHOLD%"
    echo "============================================================================"
    echo -e "${NC}"
}

print_step() {
    echo ""
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${CYAN}$(printf '%.0s─' {1..60})${NC}"
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

print_build_success() {
    echo -e "${PURPLE}🏗️  $1${NC}"
}

# ============================================================================
# 🧪 Test and Coverage Functions
# ============================================================================

run_tests_with_coverage() {
    print_step "🧪 Step 1: Running Jest Tests with Coverage"
    
    # Run tests with coverage
    print_info "Executing: npm run test -- --coverage"
    
    if npm run test -- --coverage --watchAll=false --passWithNoTests; then
        print_success "All tests passed successfully!"
        return 0
    else
        print_error "One or more tests failed!"
        return 1
    fi
}

open_coverage_report() {
    print_step "📊 Step 2: Opening Coverage Report"
    
    local coverage_report="coverage/lcov-report/index.html"
    
    if [ -f "$coverage_report" ]; then
        print_info "Opening coverage report: $coverage_report"
        
        # Cross-platform way to open the coverage report
        if command -v xdg-open > /dev/null; then
            # Linux
            xdg-open "$coverage_report" &
        elif command -v open > /dev/null; then
            # macOS
            open "$coverage_report"
        elif command -v start > /dev/null; then
            # Windows (Git Bash, WSL)
            start "$coverage_report"
        elif [ -n "$BROWSER" ]; then
            # Use environment variable
            "$BROWSER" "$coverage_report" &
        else
            print_warning "Could not detect browser. Please manually open: $coverage_report"
        fi
        
        print_success "Coverage report opened successfully!"
        sleep 2  # Give time for browser to open
    else
        print_warning "Coverage report not found at: $coverage_report"
        print_info "Coverage may still be available in other formats"
    fi
}

validate_coverage() {
    print_step "🔍 Step 3: Validating Coverage Threshold"
    
    local coverage_summary="coverage/coverage-summary.json"
    local coverage_percentage=0
    
    if [ -f "$coverage_summary" ]; then
        # Extract coverage from JSON summary
        coverage_percentage=$(node -p "
            try {
                const fs = require('fs');
                const coverage = JSON.parse(fs.readFileSync('$coverage_summary', 'utf8'));
                Math.round(coverage.total.lines.pct || 0);
            } catch (e) {
                console.error('Error reading coverage:', e.message);
                0;
            }
        " 2>/dev/null)
        
        print_info "Current coverage: ${coverage_percentage}%"
        print_info "Required threshold: ${COVERAGE_THRESHOLD}%"
        
        if [ "$coverage_percentage" -ge "$COVERAGE_THRESHOLD" ]; then
            print_success "Coverage validation passed! (${coverage_percentage}% ≥ ${COVERAGE_THRESHOLD}%)"
            return 0
        else
            print_error "Coverage below threshold! (${coverage_percentage}% < ${COVERAGE_THRESHOLD}%)"
            return 1
        fi
    else
        # Fallback: try to extract from lcov-report HTML
        local lcov_report="coverage/lcov-report/index.html"
        if [ -f "$lcov_report" ]; then
            coverage_percentage=$(grep -oP 'Total.*?(\d+\.?\d*)%' "$lcov_report" | grep -oP '\d+\.?\d*' | head -1 2>/dev/null || echo "0")
            local coverage_int=$(echo "$coverage_percentage" | cut -d'.' -f1)
            
            print_info "Current coverage: ${coverage_percentage}%"
            print_info "Required threshold: ${COVERAGE_THRESHOLD}%"
            
            if [ "$coverage_int" -ge "$COVERAGE_THRESHOLD" ]; then
                print_success "Coverage validation passed! (${coverage_percentage}% ≥ ${COVERAGE_THRESHOLD}%)"
                return 0
            else
                print_error "Coverage below threshold! (${coverage_percentage}% < ${COVERAGE_THRESHOLD}%)"
                return 1
            fi
        else
            print_warning "Coverage summary not found. Proceeding with caution..."
            print_info "Please check coverage manually in the opened report"
            return 1
        fi
    fi
}

# ============================================================================
# 🏗️ Build Functions
# ============================================================================

detect_framework_and_build() {
    print_step "🏗️ Step 4: Building Application"
    
    local build_command=""
    local framework=""
    
    # Detect framework and set appropriate build command
    if [ -f "angular.json" ]; then
        framework="Angular"
        build_command="npm run build -- --base-href '/$REPO_NAME/'"
        print_info "Detected: $framework project"
        print_info "Build command: $build_command"
    elif [ -f "package.json" ] && grep -q "react" package.json; then
        framework="React"
        build_command="npm run build"
        print_info "Detected: $framework project"
        print_info "Build command: $build_command"
        # Set PUBLIC_URL for React GitHub Pages
        export PUBLIC_URL="/$REPO_NAME"
    elif [ -f "package.json" ] && grep -q "vue" package.json; then
        framework="Vue"
        build_command="npm run build"
        print_info "Detected: $framework project"
        print_info "Build command: $build_command"
    else
        framework="Generic"
        build_command="npm run build"
        print_warning "Framework not detected, using generic build command"
        print_info "Build command: $build_command"
    fi
    
    # Execute build command
    print_info "Starting build process..."
    
    if eval "$build_command"; then
        print_build_success "Build completed successfully!"
        print_info "Framework: $framework"
        
        # Show build output directory
        if [ -d "dist" ]; then
            print_info "Build output: dist/ directory"
        elif [ -d "build" ]; then
            print_info "Build output: build/ directory"
        fi
        
        return 0
    else
        print_error "Build failed!"
        return 1
    fi
}

# ============================================================================
# 🚀 Deployment Functions
# ============================================================================

deploy_to_github() {
    print_step "🚀 Step 5: Deploying to GitHub Pages"
    
    # Check if there are changes to commit
    if git diff-index --quiet HEAD --; then
        # Check for untracked files
        if [ -z "$(git ls-files --others --exclude-standard)" ]; then
            print_info "No changes detected. Proceeding with deployment trigger..."
        else
            print_info "Untracked files detected. Adding them..."
        fi
    else
        print_info "Changes detected in tracked files."
    fi
    
    # Add all changes
    print_info "Adding all changes to Git..."
    git add .
    
    # Check if there's anything to commit after adding
    if git diff-index --quiet HEAD --; then
        print_info "No new changes to commit."
    else
        print_info "Committing changes..."
    fi
    
    # Create commit with timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local commit_message="Auto deploy: $timestamp"
    
    print_info "Commit message: $commit_message"
    
    if git commit -m "$commit_message" || true; then  # Allow commit to "fail" if nothing to commit
        print_success "Changes committed successfully!"
        
        # Push to remote
        print_info "Pushing to origin/$BRANCH_NAME..."
        
        if git push origin "$BRANCH_NAME"; then
            print_success "Code pushed to GitHub successfully!"
            
            # Provide useful URLs
            local repo_url="https://github.com/$USERNAME/$REPO_NAME"
            local actions_url="$repo_url/actions"
            local pages_url="https://${USERNAME,,}.github.io/$REPO_NAME"
            
            echo ""
            echo -e "${GREEN}${BOLD}🎉 Deployment initiated successfully!${NC}"
            echo -e "${BLUE}📁 Repository: $repo_url${NC}"
            echo -e "${BLUE}⚡ Actions: $actions_url${NC}"
            echo -e "${BLUE}🌐 Live Site: $pages_url${NC}"
            echo ""
            echo -e "${CYAN}Next steps:${NC}"
            echo -e "${CYAN}1. GitHub Actions workflow will start automatically${NC}"
            echo -e "${CYAN}2. Check build progress at: $actions_url${NC}"
            echo -e "${CYAN}3. Site will be live in 2-3 minutes at: $pages_url${NC}"
            
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
# 📋 Main Execution Flow
# ============================================================================

main() {
    print_header
    
    # Variables to track state
    local tests_passed=false
    local coverage_passed=false
    local build_completed=false
    
    # Step 1: Run tests with coverage
    if run_tests_with_coverage; then
        tests_passed=true
        
        # Step 2: Open coverage report
        open_coverage_report
        
        # Step 3: Validate coverage
        if validate_coverage; then
            coverage_passed=true
        fi
    fi
    
    # Step 4: Build (always run, regardless of test/coverage results)
    if detect_framework_and_build; then
        build_completed=true
        print_build_success "Build artifacts generated successfully!"
    else
        print_error "Build failed - cannot proceed with deployment"
        exit 1
    fi
    
    # Step 5: Conditional deployment logic
    echo ""
    echo -e "${YELLOW}${BOLD}📊 Pipeline Summary:${NC}"
    echo -e "${YELLOW}$(printf '%.0s─' {1..30})${NC}"
    
    if [ "$tests_passed" = true ]; then
        echo -e "${GREEN}✅ Tests: PASSED${NC}"
    else
        echo -e "${RED}❌ Tests: FAILED${NC}"
    fi
    
    if [ "$coverage_passed" = true ]; then
        echo -e "${GREEN}✅ Coverage: PASSED (≥${COVERAGE_THRESHOLD}%)${NC}"
    else
        echo -e "${RED}❌ Coverage: FAILED (<${COVERAGE_THRESHOLD}%)${NC}"
    fi
    
    if [ "$build_completed" = true ]; then
        echo -e "${GREEN}✅ Build: COMPLETED${NC}"
    else
        echo -e "${RED}❌ Build: FAILED${NC}"
    fi
    
    echo ""
    
    # Decision logic
    if [ "$tests_passed" = true ] && [ "$coverage_passed" = true ]; then
        print_success "All conditions met! Proceeding with deployment..."
        if deploy_to_github; then
            echo ""
            echo -e "${GREEN}${BOLD}✨ SUCCESS: Full pipeline completed! ✨${NC}"
            echo -e "${GREEN}🚀 Your application has been deployed to GitHub Pages!${NC}"
        else
            print_error "Deployment failed!"
            exit 1
        fi
    else
        echo ""
        echo -e "${RED}${BOLD}❌ Tests failed or coverage below 80%. Build generated but deployment aborted.${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}📋 What happened:${NC}"
        echo -e "${YELLOW}• Build artifacts were created successfully${NC}"
        echo -e "${YELLOW}• However, deployment was stopped due to:${NC}"
        
        if [ "$tests_passed" = false ]; then
            echo -e "${RED}  - Test failures${NC}"
        fi
        
        if [ "$coverage_passed" = false ]; then
            echo -e "${RED}  - Coverage below ${COVERAGE_THRESHOLD}% threshold${NC}"
        fi
        
        echo ""
        echo -e "${CYAN}${BOLD}🔧 To deploy:${NC}"
        echo -e "${CYAN}1. Fix failing tests (if any)${NC}"
        echo -e "${CYAN}2. Improve test coverage to ≥${COVERAGE_THRESHOLD}%${NC}"
        echo -e "${CYAN}3. Run this script again${NC}"
        
        exit 1
    fi
}

# ============================================================================
# 🏃‍♂️ Script Execution with Validation
# ============================================================================

# Pre-flight checks
print_info "Running pre-flight checks..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a Git repository! Please run this script from your project root."
    exit 1
fi

# Check if package.json exists
if [ ! -f "package.json" ]; then
    print_error "package.json not found! Please run this script from your project root."
    exit 1
fi

# Check if required npm scripts exist
if ! npm run | grep -q "test"; then
    print_error "No 'test' script found in package.json!"
    exit 1
fi

if ! npm run | grep -q "build"; then
    print_error "No 'build' script found in package.json!"
    exit 1
fi

print_success "Pre-flight checks completed!"

# Run main function
main

# End of script
