# 🚀 Angular CI/CD One-Liner Commands (Pre-configured)
# Repository: AishwaryaKulkarni1801/new_for_Testing_check

# ============================================================================
# 🔥 READY-TO-USE ONE-LINER COMMANDS
# ============================================================================

# Complete Angular CI/CD pipeline with coverage validation:
npm run test -- --coverage --watchAll=false && (echo "Opening coverage report..." && (start coverage/lcov-report/index.html 2>/dev/null || open coverage/lcov-report/index.html 2>/dev/null || xdg-open coverage/lcov-report/index.html 2>/dev/null) && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && echo "Coverage: $COVERAGE%" && [ "$COVERAGE" -ge "80" ] && echo "✅ All conditions met! Deploying..." && npm run build -- --base-href '/new_for_Testing_check/' && git add . && git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" || (npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")) || (npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")

# ============================================================================
# 🪟 WINDOWS CMD VERSION
# ============================================================================

# Windows Command Prompt / PowerShell:
npm run test -- --coverage --watchAll=false && (echo Opening coverage report... && start coverage/lcov-report/index.html && for /f %%i in ('node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}"') do set COVERAGE=%%i && echo Coverage: %COVERAGE%% && if %COVERAGE% GEQ 80 (echo ✅ All conditions met! Deploying... && npm run build -- --base-href "/new_for_Testing_check/" && git add . && git commit -m "Auto deploy: %date% %time%" && git push origin main && echo 🎉 Deployed: https://aishwaryakulkarni1801.github.io/new_for_Testing_check) else (npm run build -- --base-href "/new_for_Testing_check/" && echo ❌ Tests failed or coverage below 80%%. Build generated but deployment aborted.)) || (npm run build -- --base-href "/new_for_Testing_check/" && echo ❌ Tests failed or coverage below 80%%. Build generated but deployment aborted.)

# ============================================================================
# ⚡ STEP-BY-STEP COMMANDS
# ============================================================================

# Step 1: Run Jest tests with coverage
npm run test -- --coverage

# Step 2: Open coverage report (Windows)
start coverage/lcov-report/index.html

# Step 3: Check coverage programmatically
node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}"

# Step 4: Build Angular app (always runs)
npm run build -- --base-href '/new_for_Testing_check/'

# Step 5: Deploy (only if tests pass and coverage ≥ 80%)
git add .
git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

# ============================================================================
# 📦 NPM SCRIPT SHORTCUTS
# ============================================================================

# Use pre-configured NPM scripts:
npm run deploy:angular      # Full Angular CI/CD pipeline
npm run deploy:coverage     # Simple coverage-based deployment
npm run deploy              # Basic deployment

# ============================================================================
# 🚀 READY-TO-COPY COMMAND FOR YOUR PROJECT
# ============================================================================

# Copy this exact command for immediate use:
npm run test -- --coverage --watchAll=false && (echo "🧪 Tests completed! Opening coverage report..." && start coverage/lcov-report/index.html && COVERAGE=$(node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}") && echo "📊 Current coverage: $COVERAGE%" && echo "📊 Required threshold: 80%" && [ "$COVERAGE" -ge "80" ] && echo "✅ All conditions met! Building and deploying..." && npm run build -- --base-href '/new_for_Testing_check/' && echo "🏗️ Build completed successfully!" && git add . && git commit -m "🚀 Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')" && git push origin main && echo "🎉 Successfully deployed to: https://aishwaryakulkarni1801.github.io/new_for_Testing_check" && echo "⚡ GitHub Actions will complete deployment in 2-3 minutes" || (echo "⚠️ Coverage below 80% - building but not deploying..." && npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")) || (echo "⚠️ Tests failed - building but not deploying..." && npm run build -- --base-href '/new_for_Testing_check/' && echo "❌ Tests failed or coverage below 80%. Build generated but deployment aborted.")

# ============================================================================
# 🎯 USAGE INSTRUCTIONS
# ============================================================================

# Method 1: Run the comprehensive script
./angular-deploy.sh

# Method 2: Use NPM script
npm run deploy:angular

# Method 3: Copy and paste the one-liner above

# Method 4: Manual execution
# Run each step individually to debug issues
