# 🚀 Advanced CI/CD One-Liner Commands with Coverage Validation

# ============================================================================
# 📋 QUICK COMMANDS - Copy and paste these ready-to-run commands
# ============================================================================

# Update these variables for your project:
# USERNAME="AishwaryaKulkarni1801"
# REPO_NAME="new_for_Testing_check" 
# BRANCH_NAME="main"
# COVERAGE_THRESHOLD=80

# ============================================================================
# 🔥 ULTIMATE ONE-LINER (Linux/Mac/Git Bash)
# ============================================================================

# Complete pipeline with coverage validation and conditional deployment:
npm run test -- --coverage --watchAll=false && (COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && echo "Coverage: $COVERAGE%" && [ "$COVERAGE" -ge "80" ] && echo "✅ All conditions met!" && npm run build -- --base-href '/new_for_Testing_check/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || (npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")) || echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted."

# ============================================================================
# 🪟 WINDOWS POWERSHELL VERSION
# ============================================================================

# PowerShell one-liner for Windows users:
if (npm run test -- --coverage --watchAll=false) { $coverage = node -p "try{Math.round(JSON.parse((Get-Content 'coverage/coverage-summary.json')).total.lines.pct)}catch{0}"; Write-Host "Coverage: $coverage%"; if ($coverage -ge 80) { Write-Host "✅ All conditions met!"; npm run build -- --base-href '/new_for_Testing_check/'; git add .; git commit -m "Auto deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"; git push origin main; Write-Host "🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" } else { npm run build -- --base-href '/new_for_Testing_check/'; Write-Host "❌ Tests failed or coverage below 80%. Build generated but deployment aborted." } } else { Write-Host "❌ Tests failed or coverage below 80%. Build generated but deployment aborted." }

# ============================================================================
# 🎯 STEP-BY-STEP COMMANDS (For manual execution)
# ============================================================================

# Step 1: Run tests with coverage
npm run test -- --coverage --watchAll=false

# Step 2: Open coverage report (choose your OS)
# Linux:
xdg-open coverage/lcov-report/index.html
# macOS:
open coverage/lcov-report/index.html  
# Windows:
start coverage/lcov-report/index.html

# Step 3: Check coverage programmatically
node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}"

# Step 4: Build (always runs regardless of test results)
npm run build -- --base-href '/new_for_Testing_check/'

# Step 5: Deploy (only if tests pass and coverage ≥ 80%)
git add .
git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

# ============================================================================
# 🔧 CUSTOMIZABLE TEMPLATE
# ============================================================================

# Replace these placeholders with your details:
# <USERNAME> = Your GitHub username
# <REPO_NAME> = Your repository name  
# <BRANCH_NAME> = Your target branch
# <THRESHOLD> = Your coverage threshold (default: 80)

# Generic template:
npm run test -- --coverage --watchAll=false && (COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "<THRESHOLD>" ] && npm run build -- --base-href '/<REPO_NAME>/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin <BRANCH_NAME> && echo "🎉 Deployed: https://<USERNAME>.github.io/<REPO_NAME>" || (npm run build -- --base-href '/<REPO_NAME>/' && echo "❌ Tests failed or coverage below <THRESHOLD>%. Build generated but deployment aborted.")) || echo "❌ Tests failed or coverage below <THRESHOLD>%. Build generated but deployment aborted."

# ============================================================================
# ⚡ FRAMEWORK-SPECIFIC VARIANTS
# ============================================================================

# Angular Project:
npm run test -- --coverage --watchAll=false && (COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && ng build --base-href '/new_for_Testing_check/' && git add . && git commit -m "Auto deploy: $(date)" && git push origin main) || (ng build --base-href '/new_for_Testing_check/' && echo "❌ Build generated but deployment aborted.")

# React Project:
npm run test -- --coverage --watchAll=false && (COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && PUBLIC_URL='/new_for_Testing_check' npm run build && git add . && git commit -m "Auto deploy: $(date)" && git push origin main) || (PUBLIC_URL='/new_for_Testing_check' npm run build && echo "❌ Build generated but deployment aborted.")

# Vue Project:
npm run test -- --coverage --watchAll=false && (COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && npm run build && git add . && git commit -m "Auto deploy: $(date)" && git push origin main) || (npm run build && echo "❌ Build generated but deployment aborted.")

# ============================================================================
# 🚀 READY-TO-USE FOR YOUR CURRENT PROJECT
# ============================================================================

# Copy this command for immediate use:
npm run test -- --coverage --watchAll=false && (echo "Opening coverage report..." && (xdg-open coverage/lcov-report/index.html 2>/dev/null || open coverage/lcov-report/index.html 2>/dev/null || start coverage/lcov-report/index.html 2>/dev/null || echo "Please open: coverage/lcov-report/index.html") && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && echo "Current coverage: $COVERAGE%" && [ "$COVERAGE" -ge "80" ] && echo "✅ All conditions met! Deploying..." && npm run build -- --base-href '/new_for_Testing_check/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Successfully deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || (npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")) || (npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")

# ============================================================================
# 💡 USAGE EXAMPLES
# ============================================================================

# Example 1: Full pipeline
./advanced-deploy.sh

# Example 2: Quick deployment
npm run deploy:advanced

# Example 3: Manual step-by-step
npm run test -- --coverage
npm run build
git add . && git commit -m "Deploy" && git push

# Example 4: With custom coverage threshold
COVERAGE_THRESHOLD=90 ./advanced-deploy.sh
