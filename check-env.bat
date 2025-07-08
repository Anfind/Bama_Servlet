@echo off
echo ========================================
echo   BagStore Environment Check
echo ========================================
echo.

echo Checking Java...
java -version
if %errorlevel% neq 0 (
    echo ERROR: Java not found! Please install JDK 11 or higher.
    pause
    exit /b 1
)
echo ✓ Java OK
echo.

echo Checking Ant...
ant -version
if %errorlevel% neq 0 (
    echo ERROR: Ant not found! Please install Apache Ant.
    pause
    exit /b 1
)
echo ✓ Ant OK
echo.

echo Checking Tomcat path...
if exist "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin\catalina.bat" (
    echo ✓ Tomcat found at default location
) else (
    echo WARNING: Tomcat not found at default location
    echo Please check build.properties file
)
echo.

echo Checking MySQL (optional)...
mysql --version 2>nul
if %errorlevel% equ 0 (
    echo ✓ MySQL found
) else (
    echo WARNING: MySQL not in PATH (may be OK if installed elsewhere)
)
echo.

echo Checking lib directory...
if exist "lib\" (
    echo ✓ lib directory exists
    dir /b lib\*.jar | find /c ".jar" > temp_count.txt
    set /p jarcount=<temp_count.txt
    del temp_count.txt
    echo Found %jarcount% JAR files
) else (
    echo WARNING: lib directory not found
    echo Run download-deps.bat first
)
echo.

echo ========================================
echo Environment check completed!
echo ========================================
pause
