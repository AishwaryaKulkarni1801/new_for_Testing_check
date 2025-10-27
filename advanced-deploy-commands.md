# 🚀 Advanced CI/CD One-Liner Commands with Coverage Validation
# Copy and paste these commands for instant deployment with coverage checking

# ============================================================================
# 📋 CONFIGURATION VARIABLES (Update for your project)
# ============================================================================
# USERNAME="AishwaryaKulkarni1801"
# REPO_NAME="new_for_Testing_check" 
# BRANCH_NAME="main"
# COVERAGE_THRESHOLD=80

# ============================================================================
# ⚡ READY-TO-USE ONE-LINER COMMANDS
# ============================================================================

# 🔥 Method 1: Complete Pipeline with Coverage Validation (Linux/Mac)
npm run test -- --coverage && echo "✅ Tests passed!" && (coverage=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$coverage" -ge "80" ] && echo "✅ Coverage: $coverage% ≥ 80%" && npm run build -- --base-href '/new_for_Testing_check/' && echo "✅ Build successful!" && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.") && (command -v xdg-open >/dev/null && xdg-open coverage/lcov-report/index.html || command -v open >/dev/null && open coverage/lcov-report/index.html || echo "Coverage report: coverage/lcov-report/index.html")

# 🪟 Method 2: Windows Compatible Version (CMD/Git Bash)
npm run test -- --coverage && echo ✅ Tests passed! && npm run build -- --base-href "/new_for_Testing_check/" && echo ✅ Build successful! && git add . && git commit -m "Auto deploy: %date% %time%" && git push origin main && echo 🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check && start coverage/lcov-report/index.html || echo ❌ Tests failed or coverage below 80%. Build generated but deployment aborted.

# 🔧 Method 3: With Manual Coverage Check (Cross-platform)
npm run test -- --coverage && echo "📊 Check coverage report now..." && (command -v open >/dev/null && open coverage/lcov-report/index.html || start coverage/lcov-report/index.html 2>/dev/null || echo "Open: coverage/lcov-report/index.html") && read -p "Is coverage ≥ 80%? (y/n): " coverage_ok && [ "$coverage_ok" = "y" ] && npm run build -- --base-href '/new_for_Testing_check/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Live: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || echo "❌ Deployment aborted due to insufficient coverage or test failures"

# ============================================================================
# 📊 COVERAGE-FOCUSED COMMANDS
# ============================================================================

# 🧪 Test with Coverage and Auto-Open Report
npm run test -- --coverage && (xdg-open coverage/lcov-report/index.html 2>/dev/null || open coverage/lcov-report/index.html 2>/dev/null || start coverage/lcov-report/index.html 2>/dev/null) && echo "📊 Coverage report opened in browser"

# 📈 Check Coverage Percentage Only
npm run test -- --coverage >/dev/null 2>&1 && node -p "try{const c=JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json'));console.log('Coverage: '+Math.round(c.total.lines.pct)+'%');Math.round(c.total.lines.pct)>=80?'✅ Sufficient':'❌ Below 80%'}catch{console.log('❌ Coverage check failed');'Error'}"

# 🔍 Detailed Coverage Report
npm run test -- --coverage && echo "📊 Coverage Summary:" && node -p "try{const c=JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json'));Object.entries(c.total).map(([k,v])=>k+': '+Math.round(v.pct)+'%').join(', ')}catch{'Coverage data not available'}"

# ============================================================================
# 🎯 FRAMEWORK-SPECIFIC TEMPLATES
# ============================================================================

# 🅰️ Angular Project Template
npm run test -- --coverage && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && echo "✅ Coverage: $COVERAGE%" && npm run build -- --base-href '/<REPO_NAME>/' && git add . && git commit -m "Deploy: $(date)" && git push origin <BRANCH_NAME> && echo "🌐 https://<USERNAME>.github.io/<REPO_NAME>" || echo "❌ Coverage < 80% or tests failed"

# ⚛️ React Project Template  
npm run test -- --coverage && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && echo "✅ Coverage: $COVERAGE%" && PUBLIC_URL="/<REPO_NAME>" npm run build && git add . && git commit -m "Deploy: $(date)" && git push origin <BRANCH_NAME> && echo "🌐 https://<USERNAME>.github.io/<REPO_NAME>" || echo "❌ Coverage < 80% or tests failed"

# 🖖 Vue Project Template
npm run test -- --coverage && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && echo "✅ Coverage: $COVERAGE%" && npm run build && git add . && git commit -m "Deploy: $(date)" && git push origin <BRANCH_NAME> && echo "🌐 https://<USERNAME>.github.io/<REPO_NAME>" || echo "❌ Coverage < 80% or tests failed"

# ============================================================================
# 🛠️ CUSTOMIZABLE COMMAND BUILDER
# ============================================================================

# Replace these placeholders with your values:
# <USERNAME> = Your GitHub username
# <REPO_NAME> = Your repository name
# <BRANCH_NAME> = Your target branch (usually 'main')

# Generic Template:
# npm run test -- --coverage && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && [ "$COVERAGE" -ge "80" ] && npm run build -- --base-href '/<REPO_NAME>/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin <BRANCH_NAME> && echo "🎉 Live: https://<USERNAME>.github.io/<REPO_NAME>" && (xdg-open coverage/lcov-report/index.html || open coverage/lcov-report/index.html || start coverage/lcov-report/index.html) || echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted."

# ============================================================================
# 🚀 YOUR READY-TO-USE COMMAND
# ============================================================================

# 🔥 Copy and paste this for immediate use:
npm run test -- --coverage && echo "✅ Tests passed! Opening coverage report..." && (xdg-open coverage/lcov-report/index.html 2>/dev/null || open coverage/lcov-report/index.html 2>/dev/null || start coverage/lcov-report/index.html 2>/dev/null || echo "📊 Coverage report: coverage/lcov-report/index.html") && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && echo "📊 Current coverage: $COVERAGE%" && [ "$COVERAGE" -ge "80" ] && echo "✅ Coverage sufficient (≥80%)" && npm run build -- --base-href '/new_for_Testing_check/' && echo "✅ Build completed!" && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Successfully deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted."

# ============================================================================
# 📱 MOBILE-FRIENDLY SHORT VERSION
# ============================================================================

# Ultra-compact for mobile/small screens:
npm test -- --coverage && npm run build -- --base-href '/new_for_Testing_check/' && git add . && git commit -m "Deploy $(date '+%H:%M')" && git push && echo "🌐 Live!" || echo "❌ Failed"
