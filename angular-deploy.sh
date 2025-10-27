#!/bin/bash

# 🚀 Angular CI/CD Deployment Script with Coverage Validation
# Pre-configured for: AishwaryaKulkarni1801/new_for_Testing_check
# This script runs Jest tests, validates coverage, builds, and conditionally deploys

# ============================================================================
# 📋 PROJECT CONFIGURATION (Pre-filled)
# ============================================================================
USERNAME="AishwaryaKulkarni1801"
REPO_NAME="new_for_Testing_check"
BRANCH_NAME="main"
COVERAGE_THRESHOLD=80
LIVE_URL="https://aishwaryakulkarni1801.github.io/new_for_Testing_check"
GITHUB_REPO_URL="https://github.com/AishwaryaKulkarni1801/new_for_Testing_check"

# ============================================================================
# 🎨 Colors and Formatting
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
    echo "🚀 Angular CI/CD Pipeline with Jest Coverage Validation"
    echo "============================================================================"
    echo "📦 Repository: $USERNAME/$REPO_NAME"
    echo "🌿 Branch: $BRANCH_NAME"
    echo "📊 Coverage Threshold: $COVERAGE_THRESHOLD%"
    echo "🌐 Live URL: $LIVE_URL"
    echo "============================================================================"
    echo -e "${NC}"
}

print_step() {
    echo ""
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${CYAN}$(printf '%.0s─' {1..50})${NC}"
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
# 🧪 Step 1: Run Jest Tests with Coverage
# ============================================================================
run_jest_tests_with_coverage() {
    print_step "🧪 Step 1: Running Jest Tests with Coverage"
    
    print_info "Executing: npm run test -- --coverage"
    
    # Run Jest tests with coverage
    if npm run test -- --coverage --watchAll=false --passWithNoTests; then
        print_success "All Jest tests passed successfully!"
        return 0
    else
        print_error "One or more Jest tests failed!"
        return 1
    fi
}

# ============================================================================
# 📊 Step 2: Open Coverage Report
# ============================================================================
open_coverage_report() {
    print_step "📊 Step 2: Opening Coverage Report"
    
    local coverage_report="coverage/lcov-report/index.html"
    
    if [ -f "$coverage_report" ]; then
        print_info "Opening coverage report: $coverage_report"
        
        # Cross-platform coverage report opening
        if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
            # Windows (Git Bash, WSL, Cygwin)
            start "$coverage_report" 2>/dev/null || cmd.exe /c start "$coverage_report" 2>/dev/null
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            open "$coverage_report"
        else
            # Linux
            xdg-open "$coverage_report" 2>/dev/null &
        fi
        
        print_success "Coverage report opened in browser!"
        sleep 2  # Give browser time to open
    else
        print_warning "Coverage report not found at: $coverage_report"
        print_info "Coverage generation may have failed"
    fi
}

# ============================================================================
# 🔍 Step 3: Validate Coverage Threshold
# ============================================================================
validate_coverage_threshold() {
    print_step "🔍 Step 3: Validating Coverage Threshold (≥${COVERAGE_THRESHOLD}%)"
    
    local coverage_summary="coverage/coverage-summary.json"
    local coverage_percentage=0
    
    if [ -f "$coverage_summary" ]; then
        # Extract coverage percentage from JSON summary
        coverage_percentage=$(node -p "
            try {
                const fs = require('fs');
                const coverage = JSON.parse(fs.readFileSync('$coverage_summary', 'utf8'));
                Math.round(coverage.total.lines.pct || 0);
            } catch (error) {
                console.error('Error reading coverage summary:', error.message);
                0;
            }
        " 2>/dev/null)
        
        print_info "Current overall coverage: ${coverage_percentage}%"
        print_info "Required threshold: ${COVERAGE_THRESHOLD}%"
        
        if [ "$coverage_percentage" -ge "$COVERAGE_THRESHOLD" ]; then
            print_success "Coverage validation PASSED! (${coverage_percentage}% ≥ ${COVERAGE_THRESHOLD}%)"
            return 0
        else
            print_error "Coverage validation FAILED! (${coverage_percentage}% < ${COVERAGE_THRESHOLD}%)"
            return 1
        fi
    else
        print_error "Coverage summary file not found: $coverage_summary"
        print_warning "Cannot validate coverage threshold"
        return 1
    fi
}

# ============================================================================
# 🏗️ Step 4: Build Angular Application
# ============================================================================
build_angular_application() {
    print_step "🏗️ Step 4: Building Angular Application"
    
    local build_command="npm run build -- --base-href '/new_for_Testing_check/'"
    
    print_info "Build command: $build_command"
    print_info "Building for GitHub Pages deployment..."
    
    if eval "$build_command"; then
        print_success "Angular build completed successfully!"
        
        # Check if dist directory was created
        if [ -d "dist" ]; then
            print_info "Build output available in: dist/ directory"
        fi
        
        return 0
    else
        print_error "Angular build failed!"
        return 1
    fi
}

# ============================================================================
# 🚀 Step 5: Deploy to GitHub (Conditional)
# ============================================================================
deploy_to_github() {
    print_step "🚀 Step 5: Deploying to GitHub Pages"
    
    print_info "Adding all changes to Git..."
    git add .
    
    # Create commit with timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local commit_message="Auto deploy: $timestamp"
    
    print_info "Committing changes: $commit_message"
    
    if git commit -m "$commit_message" || git diff-index --quiet HEAD --; then
        print_success "Changes committed successfully!"
        
        print_info "Pushing to origin/$BRANCH_NAME..."
        
        if git push origin "$BRANCH_NAME"; then
            print_success "Code pushed to GitHub successfully!"
            
            echo ""
            echo -e "${GREEN}${BOLD}🎉 Deployment Initiated Successfully!${NC}"
            echo -e "${BLUE}📁 Repository: $GITHUB_REPO_URL${NC}"
            echo -e "${BLUE}⚡ Actions: $GITHUB_REPO_URL/actions${NC}"
            echo -e "${BLUE}🌐 Live Site: $LIVE_URL${NC}"
            echo ""
            echo -e "${CYAN}🚀 GitHub Actions workflow will now:${NC}"
            echo -e "${CYAN}1. Automatically trigger the deployment${NC}"
            echo -e "${CYAN}2. Build and deploy to GitHub Pages${NC}"
            echo -e "${CYAN}3. Make your site live in 2-3 minutes${NC}"
            
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
# 📋 Main Execution Pipeline
# ============================================================================
main() {
    print_header
    
    # Pipeline state variables
    local tests_passed=false
    local coverage_passed=false
    local build_completed=false
    local deployment_allowed=false
    
    # Step 1: Run Jest tests with coverage
    if run_jest_tests_with_coverage; then
        tests_passed=true
        
        # Step 2: Open coverage report
        open_coverage_report
        
        # Step 3: Validate coverage threshold
        if validate_coverage_threshold; then
            coverage_passed=true
        fi
    fi
    
    # Step 4: Build application (ALWAYS runs, regardless of test results)
    print_info "Building application regardless of test/coverage results..."
    if build_angular_application; then
        build_completed=true
    else
        print_error "Build failed - cannot proceed further"
        exit 1
    fi
    
    # Determine if deployment should proceed
    if [ "$tests_passed" = true ] && [ "$coverage_passed" = true ]; then
        deployment_allowed=true
    fi
    
    # Display pipeline summary
    echo ""
    echo -e "${YELLOW}${BOLD}📊 Pipeline Execution Summary${NC}"
    echo -e "${YELLOW}$(printf '%.0s═' {1..40})${NC}"
    
    if [ "$tests_passed" = true ]; then
        echo -e "${GREEN}✅ Jest Tests: PASSED${NC}"
    else
        echo -e "${RED}❌ Jest Tests: FAILED${NC}"
    fi
    
    if [ "$coverage_passed" = true ]; then
        echo -e "${GREEN}✅ Coverage (≥${COVERAGE_THRESHOLD}%): PASSED${NC}"
    else
        echo -e "${RED}❌ Coverage (≥${COVERAGE_THRESHOLD}%): FAILED${NC}"
    fi
    
    if [ "$build_completed" = true ]; then
        echo -e "${GREEN}✅ Angular Build: COMPLETED${NC}"
    else
        echo -e "${RED}❌ Angular Build: FAILED${NC}"
    fi
    
    echo ""
    
    # Step 5: Conditional deployment
    if [ "$deployment_allowed" = true ]; then
        print_success "All conditions met! Proceeding with GitHub deployment..."
        
        if deploy_to_github; then
            echo ""
            echo -e "${GREEN}${BOLD}✨ SUCCESS: Complete pipeline executed successfully! ✨${NC}"
            echo -e "${GREEN}🚀 Your Angular application is being deployed to GitHub Pages!${NC}"
            echo -e "${GREEN}🌐 Visit: $LIVE_URL (available in 2-3 minutes)${NC}"
        else
            print_error "Deployment to GitHub failed!"
            exit 1
        fi
    else
        echo ""
        echo -e "${RED}${BOLD}❌ Tests failed or coverage below 80%. Build generated but deployment aborted.${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}📋 What happened:${NC}"
        echo -e "${YELLOW}• Angular build was created successfully in dist/ folder${NC}"
        echo -e "${YELLOW}• However, deployment was prevented because:${NC}"
        
        if [ "$tests_passed" = false ]; then
            echo -e "${RED}  - One or more Jest tests failed${NC}"
        fi
        
        if [ "$coverage_passed" = false ]; then
            echo -e "${RED}  - Test coverage is below ${COVERAGE_THRESHOLD}% threshold${NC}"
        fi
        
        echo ""
        echo -e "${CYAN}${BOLD}🔧 To enable deployment:${NC}"
        echo -e "${CYAN}1. Fix any failing Jest tests${NC}"
        echo -e "${CYAN}2. Improve test coverage to reach ≥${COVERAGE_THRESHOLD}%${NC}"
        echo -e "${CYAN}3. Run this script again${NC}"
        echo -e "${CYAN}4. Check opened coverage report for details${NC}"
        
        exit 1
    fi
}

# ============================================================================
# 🏁 Pre-execution Validation
# ============================================================================

echo -e "${BLUE}Running pre-execution checks...${NC}"

# Validate Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Not in a Git repository!${NC}"
    echo -e "${YELLOW}Please run this script from your Angular project root directory.${NC}"
    exit 1
fi

# Validate package.json
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found!${NC}"
    echo -e "${YELLOW}Please run this script from your Angular project root directory.${NC}"
    exit 1
fi

# Validate required npm scripts
if ! npm run 2>/dev/null | grep -q "test"; then
    echo -e "${RED}❌ Error: No 'test' script found in package.json!${NC}"
    exit 1
fi

if ! npm run 2>/dev/null | grep -q "build"; then
    echo -e "${RED}❌ Error: No 'build' script found in package.json!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Pre-execution checks completed successfully!${NC}"

# Execute main pipeline
main

# End of script
