@echo off
REM 🚀 Angular CI/CD Deployment Script for Windows
REM Pre-configured for: AishwaryaKulkarni1801/new_for_Testing_check

REM ============================================================================
REM 📋 PROJECT CONFIGURATION (Pre-filled)
REM ============================================================================
set USERNAME=AishwaryaKulkarni1801
set REPO_NAME=new_for_Testing_check
set BRANCH_NAME=main
set COVERAGE_THRESHOLD=80
set LIVE_URL=https://aishwaryakulkarni1801.github.io/new_for_Testing_check

echo ============================================================================
echo 🚀 Angular CI/CD Pipeline with Jest Coverage Validation
echo ============================================================================
echo 📦 Repository: %USERNAME%/%REPO_NAME%
echo 🌿 Branch: %BRANCH_NAME%
echo 📊 Coverage Threshold: %COVERAGE_THRESHOLD%%%
echo 🌐 Live URL: %LIVE_URL%
echo ============================================================================

echo.
echo 🧪 Step 1: Running Jest Tests with Coverage
echo ─────────────────────────────────────────────────────
call npm run test -- --coverage --watchAll=false --passWithNoTests
if %errorlevel% neq 0 (
    echo ❌ One or more Jest tests failed!
    set TESTS_PASSED=false
) else (
    echo ✅ All Jest tests passed successfully!
    set TESTS_PASSED=true
)

echo.
echo 📊 Step 2: Opening Coverage Report
echo ─────────────────────────────────────────────────────
if exist "coverage\lcov-report\index.html" (
    echo ℹ️  Opening coverage report: coverage\lcov-report\index.html
    start coverage\lcov-report\index.html
    echo ✅ Coverage report opened in browser!
    timeout /t 2 > nul
) else (
    echo ⚠️  Coverage report not found at: coverage\lcov-report\index.html
)

echo.
echo 🔍 Step 3: Validating Coverage Threshold (≥%COVERAGE_THRESHOLD%%%)
echo ─────────────────────────────────────────────────────
if exist "coverage\coverage-summary.json" (
    for /f %%i in ('node -p "try{Math.round(JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json')).total.lines.pct)}catch{0}"') do set COVERAGE=%%i
    echo ℹ️  Current overall coverage: !COVERAGE!%%
    echo ℹ️  Required threshold: %COVERAGE_THRESHOLD%%%
    
    if !COVERAGE! GEQ %COVERAGE_THRESHOLD% (
        echo ✅ Coverage validation PASSED! (!COVERAGE!%% ≥ %COVERAGE_THRESHOLD%%%)
        set COVERAGE_PASSED=true
    ) else (
        echo ❌ Coverage validation FAILED! (!COVERAGE!%% ^< %COVERAGE_THRESHOLD%%%)
        set COVERAGE_PASSED=false
    )
) else (
    echo ❌ Coverage summary file not found: coverage\coverage-summary.json
    set COVERAGE_PASSED=false
)

echo.
echo 🏗️ Step 4: Building Angular Application
echo ─────────────────────────────────────────────────────
echo ℹ️  Build command: npm run build -- --base-href "/new_for_Testing_check/"
echo ℹ️  Building for GitHub Pages deployment...

call npm run build -- --base-href "/new_for_Testing_check/"
if %errorlevel% equ 0 (
    echo ✅ Angular build completed successfully!
    set BUILD_COMPLETED=true
    if exist "dist\cicd-demo4" (
        echo ℹ️  Build output available in: dist\cicd-demo4\ directory
    ) else if exist "dist" (
        echo ℹ️  Build output available in: dist\ directory
    )
) else (
    echo ❌ Angular build failed!
    set BUILD_COMPLETED=false
    echo ❌ Build failed - cannot proceed further
    pause
    exit /b 1
)

echo.
echo 📊 Pipeline Execution Summary
echo ════════════════════════════════════════════
if "%TESTS_PASSED%"=="true" (
    echo ✅ Jest Tests: PASSED
) else (
    echo ❌ Jest Tests: FAILED
)

if "%COVERAGE_PASSED%"=="true" (
    echo ✅ Coverage (≥%COVERAGE_THRESHOLD%%%): PASSED
) else (
    echo ❌ Coverage (≥%COVERAGE_THRESHOLD%%%): FAILED
)

if "%BUILD_COMPLETED%"=="true" (
    echo ✅ Angular Build: COMPLETED
) else (
    echo ❌ Angular Build: FAILED
)

echo.

REM Check if deployment should proceed
if "%TESTS_PASSED%"=="true" if "%COVERAGE_PASSED%"=="true" (
    echo ✅ All conditions met! Proceeding with GitHub deployment...
    echo.
    echo 🚀 Step 5: Deploying to GitHub Pages
    echo ─────────────────────────────────────────────────────
    
    echo ℹ️  Adding all changes to Git...
    git add .
    
    REM Create commit with timestamp
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
    set commit_message=Auto deploy: %mydate% %mytime%
    
    echo ℹ️  Committing changes: !commit_message!
    git commit -m "!commit_message!"
    
    if %errorlevel% equ 0 (
        echo ✅ Changes committed successfully!
        echo ℹ️  Pushing to origin/%BRANCH_NAME%...
        
        git push origin %BRANCH_NAME%
        if %errorlevel% equ 0 (
            echo ✅ Code pushed to GitHub successfully!
            echo.
            echo 🎉 Deployment Initiated Successfully!
            echo 📁 Repository: https://github.com/%USERNAME%/%REPO_NAME%
            echo ⚡ Actions: https://github.com/%USERNAME%/%REPO_NAME%/actions
            echo 🌐 Live Site: %LIVE_URL%
            echo.
            echo 🚀 GitHub Actions workflow will now:
            echo 1. Automatically trigger the deployment
            echo 2. Build and deploy to GitHub Pages
            echo 3. Make your site live in 2-3 minutes
            echo.
            echo ✨ SUCCESS: Complete pipeline executed successfully!
            echo 🚀 Your Angular application is being deployed to GitHub Pages!
            echo 🌐 Visit: %LIVE_URL% (available in 2-3 minutes)
        ) else (
            echo ❌ Failed to push changes to GitHub!
            pause
            exit /b 1
        )
    ) else (
        echo ❌ Failed to commit changes!
        pause
        exit /b 1
    )
) else (
    echo.
    echo ❌ Tests failed or coverage below 80%%. Build generated but deployment aborted.
    echo.
    echo 📋 What happened:
    echo • Angular build was created successfully in dist\ folder
    echo • However, deployment was prevented because:
    
    if "%TESTS_PASSED%"=="false" (
        echo   - One or more Jest tests failed
    )
    
    if "%COVERAGE_PASSED%"=="false" (
        echo   - Test coverage is below %COVERAGE_THRESHOLD%%% threshold
    )
    
    echo.
    echo 🔧 To enable deployment:
    echo 1. Fix any failing Jest tests
    echo 2. Improve test coverage to reach ≥%COVERAGE_THRESHOLD%%%
    echo 3. Run this script again
    echo 4. Check opened coverage report for details
    
    pause
    exit /b 1
)

pause
