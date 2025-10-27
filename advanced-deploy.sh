#!/bin/bash

# 🚀 Advanced CI/CD Deployment Script with Coverage Validation
# Runs tests, checks coverage, builds, and conditionally deploys to GitHub Pages

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
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ============================================================================
# 📊 Helper Functions
# ============================================================================

print_header() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 CI/CD Pipeline with Coverage Validation                ║"
    echo "║                          Repository: $REPO_NAME                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}${BOLD}🔹 $1${NC}"
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
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_separator() {
    echo -e "${PURPLE}${BOLD}────────────────────────────────────────────────────────────────${NC}"
}

# ============================================================================
# 🧪 Test Execution and Coverage Functions
# ============================================================================

run_tests_with_coverage() {
    print_step "Step 1: Running Jest Tests with Coverage..."
    print_separator
    
    # Remove existing coverage directory to ensure fresh results
    if [ -d "coverage" ]; then
        rm -rf coverage
        print_info "Cleaned previous coverage reports"
    fi
    
    # Run tests with coverage
    echo -e "${WHITE}${BOLD}Executing: npm run test -- --coverage${NC}"
    echo ""
    
    if npm run test -- --coverage; then
        print_success "All Jest tests passed!"
        return 0
    else
        print_error "Jest tests failed!"
        return 1
    fi
}

open_coverage_report() {
    print_step "Step 2: Opening Coverage Report..."
    print_separator
    
    local coverage_report="coverage/lcov-report/index.html"
    
    if [ -f "$coverage_report" ]; then
        print_success "Coverage report generated successfully"
        print_info "Opening coverage report: $coverage_report"
        
        # Cross-platform way to open the coverage report
        if command -v xdg-open > /dev/null; then
            # Linux
            xdg-open "$coverage_report" 2>/dev/null &
        elif command -v open > /dev/null; then
            # macOS
            open "$coverage_report"
        elif command -v start > /dev/null; then
            # Windows (Git Bash)
            start "$coverage_report"
        else
            print_warning "Could not automatically open coverage report"
            print_info "Please manually open: $coverage_report"
        fi
        
        print_success "Coverage report opened in browser"
        return 0
    else
        print_error "Coverage report not found at: $coverage_report"
        return 1
    fi
}

check_coverage_threshold() {
    print_step "Step 3: Validating Coverage Threshold (≥${COVERAGE_THRESHOLD}%)..."
    print_separator
    
    local coverage_summary="coverage/coverage-summary.json"
    local coverage_percentage=0
    
    if [ -f "$coverage_summary" ]; then
        # Extract coverage percentage from JSON summary
        coverage_percentage=$(node -p "
            try {
                const fs = require('fs');
                const coverage = JSON.parse(fs.readFileSync('$coverage_summary', 'utf8'));
                Math.round(coverage.total.lines.pct || 0);
            } catch (e) {
                console.error('Error parsing coverage:', e.message);
                0;
            }
        " 2>/dev/null)
        
        if [ -z "$coverage_percentage" ] || [ "$coverage_percentage" = "undefined" ]; then
            coverage_percentage=0
        fi
        
        print_info "Current coverage: ${coverage_percentage}%"
        print_info "Required threshold: ${COVERAGE_THRESHOLD}%"
        
        if [ "$coverage_percentage" -ge "$COVERAGE_THRESHOLD" ]; then
            print_success "Coverage threshold met: ${coverage_percentage}% ≥ ${COVERAGE_THRESHOLD}%"
            return 0
        else
            print_error "Coverage below threshold: ${coverage_percentage}% < ${COVERAGE_THRESHOLD}%"
            return 1
        fi
    else
        print_error "Coverage summary not found: $coverage_summary"
        print_warning "Cannot validate coverage threshold"
        return 1
    fi
}

# ============================================================================
# 🏗️ Build Functions
# ============================================================================

detect_framework_and_build() {
    print_step "Step 4: Detecting Framework and Building Project..."
    print_separator
    
    local build_command=""
    local framework=""
    
    # Detect framework and set appropriate build command
    if [ -f "angular.json" ]; then
        framework="Angular"
        build_command="npm run build -- --base-href '/$REPO_NAME/'"
        print_info "Detected: $framework project"
        print_info "Using Angular build with GitHub Pages base-href"
        
    elif [ -f "package.json" ] && grep -q "react" package.json; then
        framework="React"
        # Set PUBLIC_URL for React GitHub Pages deployment
        export PUBLIC_URL="/$REPO_NAME"
        build_command="npm run build"
        print_info "Detected: $framework project"
        print_info "Set PUBLIC_URL=/$REPO_NAME for GitHub Pages"
        
    elif [ -f "package.json" ] && grep -q "vue" package.json; then
        framework="Vue"
        build_command="npm run build"
        print_info "Detected: $framework project"
        
    else
        framework="Generic"
        build_command="npm run build"
        print_info "Framework not specifically detected, using generic build"
    fi
    
    echo ""
    echo -e "${WHITE}${BOLD}Executing: $build_command${NC}"
    echo ""
    
    # Execute build command
    if eval $build_command; then
        print_success "$framework project built successfully!"
        
        # Show build output directory info
        if [ -d "dist" ]; then
            local dist_size=$(du -sh dist 2>/dev/null | cut -f1)
            print_info "Build output: dist/ (Size: ${dist_size:-'Unknown'})"
        elif [ -d "build" ]; then
            local build_size=$(du -sh build 2>/dev/null | cut -f1)
            print_info "Build output: build/ (Size: ${build_size:-'Unknown'})"
        fi
        
        return 0
    else
        print_error "$framework build failed!"
        return 1
    fi
}

# ============================================================================
# 🚀 Deployment Functions
# ============================================================================

deploy_to_github() {
    print_step "Step 5: Deploying to GitHub Pages..."
    print_separator
    
    # Check if there are changes to commit
    if git diff-index --quiet HEAD --; then
        print_info "No changes detected in working directory"
        
        # Check for untracked files
        if [ -z "$(git ls-files --others --exclude-standard)" ]; then
            print_warning "No new files to commit"
            print_info "Proceeding with deployment trigger..."
        else
            print_info "Untracked files found, adding them..."
        fi
    else
        print_info "Changes detected, preparing for commit..."
    fi
    
    # Add all changes
    print_info "Adding all changes to git..."
    git add .
    
    # Check if there's anything to commit after adding
    if git diff-index --quiet HEAD --; then
        print_info "No changes to commit after adding files"
        print_info "Repository is up to date"
    else
        # Create commit with timestamp
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local commit_message="Auto deploy: $timestamp"
        
        print_info "Creating commit: '$commit_message'"
        
        if git commit -m "$commit_message"; then
            print_success "Changes committed successfully!"
        else
            print_error "Failed to commit changes!"
            return 1
        fi
    fi
    
    # Push to GitHub
    print_info "Pushing to origin/$BRANCH_NAME..."
    echo -e "${WHITE}${BOLD}Executing: git push origin $BRANCH_NAME${NC}"
    
    if git push origin "$BRANCH_NAME"; then
        print_success "Code pushed to GitHub successfully!"
        
        # Provide deployment information
        local repo_url="https://github.com/$USERNAME/$REPO_NAME"
        local actions_url="$repo_url/actions"
        local pages_url="https://${USERNAME,,}.github.io/$REPO_NAME"
        
        echo ""
        print_success "🎉 Deployment pipeline triggered successfully!"
        echo ""
        print_info "📊 Deployment Details:"
        print_info "   Repository: $repo_url"
        print_info "   Actions: $actions_url"
        print_info "   Live Site: $pages_url"
        echo ""
        print_info "⏱️  Deployment typically takes 2-3 minutes to complete"
        print_info "🔍 Check GitHub Actions for real-time build progress"
        
        return 0
    else
        print_error "Failed to push to GitHub!"
        return 1
    fi
}

# ============================================================================
# 📋 Main Execution Flow
# ============================================================================

main() {
    print_header
    
    # Variables to track status
    local tests_passed=false
    local coverage_sufficient=false
    local build_successful=false
    
    echo -e "${WHITE}${BOLD}Starting CI/CD pipeline...${NC}"
    echo ""
    
    # Step 1: Run tests with coverage
    if run_tests_with_coverage; then
        tests_passed=true
        echo ""
        
        # Step 2: Open coverage report
        open_coverage_report
        echo ""
        
        # Step 3: Check coverage threshold
        if check_coverage_threshold; then
            coverage_sufficient=true
        fi
    fi
    
    echo ""
    
    # Step 4: Build (always execute, regardless of coverage)
    if detect_framework_and_build; then
        build_successful=true
    fi
    
    echo ""
    print_separator
    
    # Step 5: Conditional deployment logic
    if [ "$tests_passed" = true ] && [ "$coverage_sufficient" = true ]; then
        print_success "✅ All conditions met for deployment!"
        print_info "Tests: ✅ Passed"
        print_info "Coverage: ✅ ≥ ${COVERAGE_THRESHOLD}%"
        print_info "Build: ✅ Successful"
        echo ""
        
        # Deploy to GitHub
        if deploy_to_github; then
            echo ""
            echo -e "${GREEN}${BOLD}"
            echo "╔══════════════════════════════════════════════════════════════════════════════╗"
            echo "║                          🎉 DEPLOYMENT SUCCESSFUL! 🎉                        ║"
            echo "║                                                                              ║"
            echo "║   Your application has been deployed to GitHub Pages successfully!          ║"
            echo "║   Visit: https://${USERNAME,,}.github.io/$REPO_NAME"
            echo "║                                                                              ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════╝"
            echo -e "${NC}"
        else
            print_error "Deployment failed despite meeting all conditions!"
            exit 1
        fi
    else
        # Show detailed failure reasons
        echo -e "${RED}${BOLD}❌ Tests failed or coverage below ${COVERAGE_THRESHOLD}%. Build generated but deployment aborted.${NC}"
        echo ""
        print_error "Deployment conditions not met:"
        
        if [ "$tests_passed" = false ]; then
            print_error "   • Tests: ❌ Failed"
        else
            print_success "   • Tests: ✅ Passed"
        fi
        
        if [ "$coverage_sufficient" = false ]; then
            print_error "   • Coverage: ❌ < ${COVERAGE_THRESHOLD}%"
        else
            print_success "   • Coverage: ✅ ≥ ${COVERAGE_THRESHOLD}%"
        fi
        
        if [ "$build_successful" = true ]; then
            print_success "   • Build: ✅ Generated successfully"
        else
            print_error "   • Build: ❌ Failed"
        fi
        
        echo ""
        print_warning "Build artifacts created but not deployed"
        print_info "Fix the issues above and run the script again"
        
        exit 1
    fi
}

# ============================================================================
# 🔧 Pre-flight Checks
# ============================================================================

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

# Check if npm is available
if ! command -v npm > /dev/null 2>&1; then
    print_error "npm is not installed or not in PATH!"
    exit 1
fi

# Check if git is configured
if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
    print_warning "Git user not configured. This might cause commit issues."
    print_info "Configure with: git config --global user.name 'Your Name'"
    print_info "Configure with: git config --global user.email 'your.email@example.com'"
fi

# ============================================================================
# 🏃‍♂️ Script Execution
# ============================================================================

# Trap to handle script interruption
trap 'echo -e "\n${RED}${BOLD}Script interrupted by user${NC}"; exit 130' INT

# Run main function
main

# End of script
