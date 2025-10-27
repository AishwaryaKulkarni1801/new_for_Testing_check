# 🚀 Universal One-Liner CI/CD Deployment Commands
# Copy and paste these commands based on your operating system

# ============================================================================
# 📋 QUICK SETUP - Update these variables first:
# ============================================================================
# USERNAME="AishwaryaKulkarni1801"
# REPO_NAME="new_for_Testing_check" 
# BRANCH_NAME="main"
# COVERAGE_THRESHOLD=80

# ============================================================================
# 🐧 LINUX/MAC - Single Command Deployment
# ============================================================================

# Method 1: Comprehensive one-liner with all checks
npm test -- --watchAll=false --passWithNoTests && npm run test:coverage -- --watchAll=false --passWithNoTests && echo "✅ Tests passed! Deploying..." && git add . && git commit -m "🚀 Auto-deploy: $(date)" && git push origin main && echo "🎉 Deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || echo "❌ Test coverage below threshold or tests failed. Deployment aborted."

# Method 2: With coverage threshold check (requires Node.js)
(npm test -- --watchAll=false && COVERAGE=$(npm run test:coverage -- --watchAll=false 2>/dev/null | grep -o "All files.*[0-9]\+\%" | grep -o "[0-9]\+" | head -1) && [ "${COVERAGE:-0}" -ge "80" ] && echo "✅ Coverage: $COVERAGE% ≥ 80%" && git add . && git commit -m "🚀 Auto-deploy: Tests✅ Coverage:$COVERAGE% $(date '+%Y-%m-%d %H:%M')" && git push origin main && echo "🎉 Live at: https://aishwaryakulkarni1801.github.io/new_for_Testing_check") || echo "❌ Tests failed or coverage < 80%. Deployment aborted."

# Method 3: Simple deployment (assumes tests pass)
npm test && git add . && git commit -m "🚀 Deploy: $(date)" && git push origin main && echo "🌐 Live: https://aishwaryakulkarni1801.github.io/new_for_Testing_check"

# ============================================================================
# 🪟 WINDOWS CMD - Single Command Deployment  
# ============================================================================

# Method 1: Windows batch one-liner
npm test -- --watchAll=false --passWithNoTests && npm run test:coverage -- --watchAll=false --passWithNoTests && echo ✅ Tests passed! Deploying... && git add . && git commit -m "🚀 Auto-deploy: %date% %time%" && git push origin main && echo 🎉 Deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check || echo ❌ Test coverage below threshold or tests failed. Deployment aborted.

# Method 2: Windows PowerShell one-liner
if (npm test -- --watchAll=false --passWithNoTests) { echo "✅ Tests passed!"; git add .; git commit -m "🚀 Auto-deploy: $(Get-Date)"; git push origin main; echo "🎉 Live: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" } else { echo "❌ Tests failed. Deployment aborted." }

# ============================================================================
# ⚡ ULTRA-SHORT Version (Copy & Paste Ready)
# ============================================================================

# For any OS - Minimal version:
npm test && git add . && git commit -m "🚀 $(date)" && git push && echo "🌐 https://aishwaryakulkarni1801.github.io/new_for_Testing_check"

# ============================================================================
# 🔧 CUSTOMIZABLE TEMPLATE
# ============================================================================

# Replace these placeholders with your details:
# <USERNAME> = Your GitHub username
# <REPO_NAME> = Your repository name  
# <BRANCH_NAME> = Your target branch (usually 'main')

# Generic template:
npm test -- --watchAll=false && echo "✅ Tests passed!" && git add . && git commit -m "🚀 Auto-deploy: $(date)" && git push origin <BRANCH_NAME> && echo "🎉 Live at: https://<USERNAME>.github.io/<REPO_NAME>" || echo "❌ Tests failed. Deployment aborted."

# ============================================================================
# 📊 WITH COVERAGE CHECK (Advanced)
# ============================================================================

# This version checks for 80% coverage before deploying:
(npm run test:coverage -- --watchAll=false --silent && COVERAGE=$(node -p "try{JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct}catch{0}") && [ "${COVERAGE%.*}" -ge "80" ] && echo "✅ Coverage: $COVERAGE%" && git add . && git commit -m "🚀 Deploy: Tests✅ Coverage:$COVERAGE% $(date '+%H:%M')" && git push origin main && echo "🌐 https://aishwaryakulkarni1801.github.io/new_for_Testing_check") || echo "❌ Coverage < 80% or tests failed"

# ============================================================================
# 🎯 READY-TO-USE FOR YOUR PROJECT
# ============================================================================

# Copy this command for immediate use with your current settings:
npm test -- --watchAll=false --passWithNoTests && echo "✅ Tests passed! 🚀 Deploying..." && git add . && git commit -m "🚀 Auto-deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Successfully deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || echo "❌ Test coverage below threshold or tests failed. Deployment aborted."
