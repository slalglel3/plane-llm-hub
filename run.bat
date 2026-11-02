@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
title Plane LLM Hub

echo ==================================================================
echo   Plane LLM Hub - Enterprise Web UI Sample
echo   Vue2 + Spring Boot 2.7 + MyBatis XML + Embedded H2
echo ==================================================================
echo.

rem Step 1: Detect Java executable
set "JAVA_EXE="

where java >nul 2>&1
if %ERRORLEVEL% EQU 0 set "JAVA_EXE=java"
if defined JAVA_EXE goto :FOUND_JAVA

if defined JAVA_HOME (
    set "CLEAN_JH=%JAVA_HOME:"=%"
    if exist "%CLEAN_JH%\bin\java.exe" set "JAVA_EXE=%CLEAN_JH%\bin\java.exe"
)
if defined JAVA_EXE goto :FOUND_JAVA

for %%D in ("C:\Program Files\Eclipse Adoptium\jdk-*" "C:\Program Files\Java\jdk-*" "C:\Program Files\Amazon Corretto\jdk*" "C:\Program Files\Zulu\zulu-*" "C:\Program Files\Microsoft\jdk-*" "C:\Users\%USERNAME%\.jdks\*") do (
    for /d %%P in (%%D) do (
        if exist "%%P\bin\java.exe" set "JAVA_EXE=%%P\bin\java.exe"
    )
)
if defined JAVA_EXE goto :FOUND_JAVA

echo [ERROR] Java 17+ or Java 20/21 is required but was not found.
echo Please install OpenJDK and ensure java is in your PATH.
echo.
pause
exit /b 1

:FOUND_JAVA
echo [INFO] Java runtime:
"%JAVA_EXE%" -version
echo.

rem Step 2: Check for standalone JAR
if not exist "plane-llm-hub-1.0.0.jar" goto :RUN_MAVEN

echo [INFO] Pre-built JAR detected: plane-llm-hub-1.0.0.jar
echo [INFO] Starting Spring Boot application on port 8080...
echo ==================================================================
echo [INFO] Web Browser Access URL:
echo [INFO]   http://127.0.0.1:8080/  (RECOMMENDED: Bypasses 사내 Edge IE Mode)
echo [INFO]   http://localhost:8080/
echo ------------------------------------------------------------------
echo [TIP] 사내 PC Edge 주소창에 파란색 Internet Explorer(e) 아이콘이 뜨며
echo       화면이 깨질 경우 반드시 http://127.0.0.1:8080/ 으로 접속하세요.
echo ==================================================================
echo.

"%JAVA_EXE%" -jar "plane-llm-hub-1.0.0.jar"

echo.
echo [INFO] Application process terminated.
pause
exit /b 0

:RUN_MAVEN
set "MVN_CMD=mvnw.cmd"
where mvn >nul 2>&1
if %ERRORLEVEL% EQU 0 set "MVN_CMD=mvn"

echo [INFO] Starting application via Maven: %MVN_CMD%
echo ==================================================================
echo [INFO] Web Browser Access URL:
echo [INFO]   http://127.0.0.1:8080/  (RECOMMENDED: Bypasses 사내 Edge IE Mode)
echo [INFO]   http://localhost:8080/
echo ------------------------------------------------------------------
echo [TIP] 사내 PC Edge 주소창에 파란색 Internet Explorer(e) 아이콘이 뜨며
echo       화면이 깨질 경우 반드시 http://127.0.0.1:8080/ 으로 접속하세요.
echo ==================================================================
echo.

call %MVN_CMD% spring-boot:run

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==================================================================
    echo [ERROR] Application terminated with error code %ERRORLEVEL%.
    echo ==================================================================
    echo.
    pause
)
