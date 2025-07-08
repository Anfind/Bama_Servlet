@echo off
echo ========================================
echo   BagStore Application Setup
echo ========================================
echo.

echo Step 1: Checking environment...
call check-env.bat
if %errorlevel% neq 0 (
    echo.
    echo Setup failed at environment check!
    pause
    exit /b 1
)

echo.
echo Step 2: Downloading dependencies...
call download-deps.bat
if %errorlevel% neq 0 (
    echo.
    echo Setup failed at downloading dependencies!
    pause
    exit /b 1
)

echo.
echo Step 3: Building application...
call build.bat
if %errorlevel% neq 0 (
    echo.
    echo Setup failed at building application!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Setup Completed Successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Configure database in src/main/webapp/META-INF/context.xml
echo 2. Start Tomcat server
echo 3. Access application at: http://localhost:8080/BagStore/
echo.
echo For detailed instructions, see HUONG-DAN-CHAY.md
echo.
pause
