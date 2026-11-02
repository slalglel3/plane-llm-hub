@echo off
rem ==============================================================================
rem Plane LLM Hub - One-Click Launch Script for Windows
rem ==============================================================================
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

echo ==================================================================
echo   Plane LLM Hub - Enterprise Web UI Sample
echo   Vue2 + Spring Boot 2.7 + MyBatis XML + Embedded H2
echo ==================================================================
echo.

rem 1. Check if java is in PATH
where java >nul 2>&1
if %ERRORLEVEL% EQU 0 goto :JAVA_FOUND

rem 2. Check if JAVA_HOME contains java.exe
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\java.exe" (
        set "PATH=%JAVA_HOME%\bin;%PATH%"
        goto :JAVA_FOUND
    )
)

rem 3. Search common JDK 17+ installation directories on Windows
for %%D in (
    "C:\Program Files\Eclipse Adoptium\jdk-17*"
    "C:\Program Files\Java\jdk-17*"
    "C:\Program Files\Java\jdk-21*"
    "C:\Program Files\Amazon Corretto\jdk17*"
    "C:\Program Files\Zulu\zulu-17*"
    "C:\Program Files\Microsoft\jdk-17*"
) do (
    for /d %%P in (%%D) do (
        if exist "%%P\bin\java.exe" (
            set "JAVA_HOME=%%P"
            set "PATH=%%P\bin;!PATH!"
            goto :JAVA_FOUND
        )
    )
)

rem If Java is still not found, display clear setup guide
echo [ERROR] Java 17 or higher was not detected on this system.
echo.
echo Please follow these steps to set up Java:
echo   1. Download Eclipse Temurin JDK 17:
echo      https://adoptium.net/temurin/releases/?version=17
echo   2. Run the installer and check 'Add to PATH' and 'Set JAVA_HOME'.
echo   3. Re-run run.bat.
echo.
pause
exit /b 1

:JAVA_FOUND
echo [INFO] Java detected successfully.
java -version
echo.

rem Prefer system Maven if available, otherwise use Maven Wrapper
set "MVN_CMD=mvnw.cmd"
where mvn >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "MVN_CMD=mvn"
    echo [INFO] Using installed Maven: mvn
) else (
    echo [INFO] Using Maven Wrapper: mvnw.cmd
)

echo [INFO] Starting Spring Boot Application on port 8080...
echo [INFO] Once started, open your web browser at: http://localhost:8080/
echo ------------------------------------------------------------------
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
