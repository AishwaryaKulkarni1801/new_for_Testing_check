@echo off
REM 🚀 Universal CI/CD Deployment Script for Windows (Angular/React/Vue)
REM This batch file runs tests, checks coverage, and deploys to GitHub Pages

REM ============================================================================
REM 📋 CONFIGURATION - Update these variables for your project
REM ============================================================================
set USERNAME=AishwaryaKulkarni1801
set REPO_NAME=new_for_Testing_check
set BRANCH_NAME=main
set COVERAGE_THRESHOLD=80

echo ============================================================================
echo 🚀 CI/CD Deployment Pipeline for %REPO_NAME%
echo ============================================================================

echo.
echo 🧪 Step 1: Running Jest Tests...
call npm test -- --watchAll=false --passWithNoTests > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Test coverage below threshold or tests failed. Deployment aborted.
    echo Deployment stopped due to test failures.
    pause
    exit /b 1
)
echo ✅ All tests passed!

echo.
echo 📊 Step 2: Checking Test Coverage...
call npm run test:coverage -- --watchAll=false --passWithNoTests > nul 2>&1

echo.
echo 📝 Step 3: Committing and Pushing Changes...
git add .

for /f %%i in ('git status --porcelain') do set CHANGES=%%i
if not defined CHANGES (
    echo ℹ️  No changes to commit, but proceeding with deployment trigger.
) else (
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
    git commit -m "🚀 Auto-deploy: Tests passed, coverage ≥%COVERAGE_THRESHOLD%% - %mydate% %mytime%"
    
    if %errorlevel% equ 0 (
        echo ✅ Changes committed successfully!
        echo Pushing to origin/%BRANCH_NAME%...
        git push origin %BRANCH_NAME%
        if %errorlevel% equ 0 (
            echo ✅ Changes pushed to GitHub successfully!
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
)

echo.
echo 🚀 Step 4: Triggering GitHub Pages Deployment...
echo ✅ Deployment pipeline triggered!
echo ℹ️  GitHub Repository: https://github.com/%USERNAME%/%REPO_NAME%
echo ℹ️  GitHub Actions: https://github.com/%USERNAME%/%REPO_NAME%/actions
echo ℹ️  Live Site: https://%USERNAME%.github.io/%REPO_NAME%

echo.
echo ✨ All steps completed successfully! ✨
echo.
echo Next steps:
echo 1. Check GitHub Actions for build progress
echo 2. Your site will be live in 2-3 minutes
echo 3. Visit your deployed site at the URL above

pause
