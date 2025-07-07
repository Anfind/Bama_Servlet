@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo BagStore Build Script (Without Ant)
echo ==========================================

set PROJECT_DIR=%~dp0
set SRC_DIR=%PROJECT_DIR%src\main\java
set WEB_DIR=%PROJECT_DIR%src\main\webapp
set RESOURCES_DIR=%PROJECT_DIR%src\main\resources
set LIB_DIR=%PROJECT_DIR%lib
set BUILD_DIR=%PROJECT_DIR%build
set BUILD_CLASSES_DIR=%BUILD_DIR%\classes
set BUILD_WEB_DIR=%BUILD_DIR%\web
set DIST_DIR=%PROJECT_DIR%dist

if "%1"=="clean" goto clean
if "%1"=="compile" goto compile
if "%1"=="war" goto war
if "%1"=="all" goto all
if "%1"=="help" goto help

echo Usage: build.bat [clean|compile|war|all|help]
goto end

:clean
echo Cleaning build directories...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
echo Clean completed.
goto end

:compile
echo Creating build directories...
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%BUILD_CLASSES_DIR%" mkdir "%BUILD_CLASSES_DIR%"
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"

echo Building classpath...
set CLASSPATH=
for %%i in ("%LIB_DIR%\*.jar") do (
    set CLASSPATH=!CLASSPATH!;%%i
)

echo Compiling Java sources...
javac -cp "!CLASSPATH!" -d "%BUILD_CLASSES_DIR%" -sourcepath "%SRC_DIR%" -encoding UTF-8 "%SRC_DIR%\com\bagstore\**\*.java"

if errorlevel 1 (
    echo Compilation failed!
    goto end
)

echo Copying resources...
if exist "%RESOURCES_DIR%" (
    xcopy "%RESOURCES_DIR%\*" "%BUILD_CLASSES_DIR%\" /s /y /q
)

echo Compilation completed.
goto end

:war
call :compile

echo Creating web directory...
if not exist "%BUILD_WEB_DIR%" mkdir "%BUILD_WEB_DIR%"

echo Copying web content...
xcopy "%WEB_DIR%\*" "%BUILD_WEB_DIR%\" /s /y /q

echo Copying compiled classes...
if not exist "%BUILD_WEB_DIR%\WEB-INF\classes" mkdir "%BUILD_WEB_DIR%\WEB-INF\classes"
xcopy "%BUILD_CLASSES_DIR%\*" "%BUILD_WEB_DIR%\WEB-INF\classes\" /s /y /q

echo Copying libraries...
if not exist "%BUILD_WEB_DIR%\WEB-INF\lib" mkdir "%BUILD_WEB_DIR%\WEB-INF\lib"
for %%i in ("%LIB_DIR%\*.jar") do (
    set filename=%%~ni%%~xi
    if not "!filename!"=="servlet-api-6.0.0.jar" (
        if not "!filename!"=="jsp-api-3.1.0.jar" (
            copy "%%i" "%BUILD_WEB_DIR%\WEB-INF\lib\" > nul
        )
    )
)

echo Creating WAR file...
cd /d "%BUILD_WEB_DIR%"
jar -cvf "%DIST_DIR%\BagStore.war" .
cd /d "%PROJECT_DIR%"

echo WAR file created: %DIST_DIR%\BagStore.war
goto end

:all
call :clean
call :war
echo Build completed successfully!
goto end

:help
echo Available commands:
echo   clean      - Clean build directories
echo   compile    - Compile Java sources
echo   war        - Create WAR file
echo   all        - Clean, compile and create WAR
echo   help       - Show this help
goto end

:end
endlocal
