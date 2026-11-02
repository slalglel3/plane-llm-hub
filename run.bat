@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

title Plane LLM Hub

echo ==================================================================
echo   Plane LLM Hub - Enterprise Web UI Sample
echo   Vue2 + Spring Boot 2.7 + MyBatis XML + Embedded H2
echo ==================================================================
echo.

rem 1. Check if java command is available
set "JAVA_EXE="

where java >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "JAVA_EXE=java"
    goto :JAVA_CHECK_DONE
)

if defined JAVA_HOME (
    set "CLEAN_JH=%JAVA_HOME:"=%"
    if exist "!CLEAN_JH!\bin\java.exe" (
        set "JAVA_EXE=!CLEAN_JH!\bin\java.exe"
        goto :JAVA_CHECK_DONE
    )
)

for %%D in (
    "C:\Program Files\Eclipse Adoptium\jdk-*"
    "C:\Program Files\Java\jdk-*"
    "C:\Program Files\Amazon Corretto\jdk*"
    "C:\Program Files\Zulu\zulu-*"
    "C:\Program Files\Microsoft\jdk-*"
    "C:\Users\%USERNAME%\.jdks\*"
    "C:\Program Files\BellSoft\LibericaJDK-*"
) do (
    for /d %%P in (%%D) do (
        if not defined JAVA_EXE (
            if exist "%%P\bin\java.exe" (
                set "JAVA_EXE=%%P\bin\java.exe"
            )
        )
    )
)

if not defined JAVA_EXE (
    echo [ERROR] Java 17+ or Java 20/21 is required but was not found.
    echo Please install OpenJDK and ensure java is in your PATH.
    echo.
    pause
    exit /b 1
)

:JAVA_CHECK_DONE
echo [INFO] Java detected:
"%JAVA_EXE%" -version
echo.

rem 2. Launch Standalone Fat JAR if present (Zero-dependency mode)
if exist "plane-llm-hub-1.0.0.jar" (
    echo [INFO] Pre-built JAR (plane-llm-hub-1.0.0.jar) detected.
    echo [INFO] Starting Spring Boot application directly on port 8080...
    echo [INFO] Once started, open your browser at: http://localhost:8080/
    echo ------------------------------------------------------------------
    echo.
    "%JAVA_EXE%" -jar "plane-llm-hub-1.0.0.jar"
    echo.
    echo [INFO] Application process terminated.
    pause
    exit /b !ERRORLEVEL!
)

rem 3. Fallback: Build and run via Maven
set "MVN_CMD=mvnw.cmd"
where mvn >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "MVN_CMD=mvn"
)

echo [INFO] Starting application via Maven: %MVN_CMD%
echo [INFO] Once started, open your browser at: http://localhost:8080/
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
