@echo off
echo ==========================================
echo Downloading JAR dependencies for BagStore
echo ==========================================

set LIB_DIR=lib
if not exist "%LIB_DIR%" mkdir "%LIB_DIR%"

echo.
echo [1/7] Downloading Servlet API...
curl -L -o "%LIB_DIR%/servlet-api-6.0.0.jar" "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar"

echo.
echo [2/7] Downloading JSP API...
curl -L -o "%LIB_DIR%/jsp-api-3.1.0.jar" "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jakarta.servlet.jsp-api/3.1.0/jakarta.servlet.jsp-api-3.1.0.jar"

echo.
echo [3/7] Downloading JSTL...
curl -L -o "%LIB_DIR%/jstl-3.0.0.jar" "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.0/jakarta.servlet.jsp.jstl-3.0.0.jar"

echo.
echo [4/7] Downloading MySQL Connector...
curl -L -o "%LIB_DIR%/mysql-connector-java-8.0.33.jar" "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar"

echo.
echo [5/7] Downloading Jackson Core...
curl -L -o "%LIB_DIR%/jackson-core-2.15.2.jar" "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.2/jackson-core-2.15.2.jar"

echo.
echo [6/7] Downloading Jackson Databind...
curl -L -o "%LIB_DIR%/jackson-databind-2.15.2.jar" "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.2/jackson-databind-2.15.2.jar"

echo.
echo [7/8] Downloading Jackson Annotations...
curl -L -o "%LIB_DIR%/jackson-annotations-2.15.2.jar" "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.2/jackson-annotations-2.15.2.jar"

echo.
echo [8/8] Downloading BCrypt for password hashing...
curl -L -o "%LIB_DIR%/jbcrypt-0.4.jar" "https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar"

echo.
echo ==========================================
echo Download completed! 
echo All JAR files are in the lib/ directory
echo ==========================================
echo.
echo Next steps:
echo 1. ant clean
echo 2. ant compile  
echo 3. ant war
echo.
pause
