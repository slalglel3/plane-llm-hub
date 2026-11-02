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

rem ------------------------------------------------------------------
rem Step 1: Detect and validate JAVA_HOME
rem ------------------------------------------------------------------

rem Clean up any quotes or trailing backslashes from existing JAVA_HOME
if defined JAVA_HOME (
    set "JAVA_HOME=%JAVA_HOME:"=%"
    if "!JAVA_HOME:~-1!"=="\" set "JAVA_HOME=!JAVA_HOME:~0,-1!"
    if "!JAVA_HOME:~-4!"=="\bin" set "JAVA_HOME=!JAVA_HOME:~0,-4!"
    if exist "!JAVA_HOME!\bin\java.exe" goto :JAVA_HOME_SET
    rem If existing JAVA_HOME was invalid, unset it so auto-detection can find the real one
    set "JAVA_HOME="
)

rem Try to derive JAVA_HOME from where java
for /f "delims=" %%F in ('where java 2^>nul') do (
    if not defined JAVA_HOME (
        set "J_BIN=%%~dpF"
        if "!J_BIN:~-1!"=="\" set "J_BIN=!J_BIN:~0,-1!"
        for %%P in ("!J_BIN!") do (
            if /i "%%~nxP"=="bin" (
                set "CANDIDATE=%%~dpP"
                if "!CANDIDATE:~-1!"=="\" set "CANDIDATE=!CANDIDATE:~0,-1!"
                if exist "!CANDIDATE!\bin\java.exe" (
                    set "JAVA_HOME=!CANDIDATE!"
                )
            )
        )
    )
)

if defined JAVA_HOME if exist "!JAVA_HOME!\bin\java.exe" goto :JAVA_HOME_SET

rem Search common JDK directories
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
        if not defined JAVA_HOME (
            if exist "%%P\bin\java.exe" (
                set "JAVA_HOME=%%P"
            )
        )
    )
)

if defined JAVA_HOME if exist "!JAVA_HOME!\bin\java.exe" goto :JAVA_HOME_SET

rem If still not found:
echo [ERROR] Could not find a valid Java 17+ installation or JAVA_HOME.
echo.
echo Maven requires the JAVA_HOME environment variable to be set.
echo Please follow these steps:
echo   1. Download and install Eclipse Temurin JDK 17 (or JDK 20/21):
echo      https://adoptium.net/temurin/releases/
echo   2. During installation, ensure 'Set JAVA_HOME' and 'Add to PATH' are checked.
echo   3. Re-open terminal and run run.bat again.
echo.
pause
exit /b 1

:JAVA_HOME_SET
rem Ensure PATH includes JAVA_HOME\bin
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo [INFO] JAVA_HOME is set to: %JAVA_HOME%
"%JAVA_HOME%\bin\java.exe" -version
echo.

rem Check if pre-built standalone JAR exists in project folder
if exist "plane-llm-hub-1.0.0.jar" (
    echo [INFO] 사전 빌드된 단일 Fat JAR (plane-llm-hub-1.0.0.jar) 감지됨.
    echo [INFO] Maven/Nexus 다운로드 과정 없이 Java 단독으로 즉시 기동합니다...
    echo [INFO] 서버 기동 완료 후 브라우저 접속: http://localhost:8080/
    echo ------------------------------------------------------------------
    echo.
    "%JAVA_HOME%\bin\java.exe" -jar plane-llm-hub-1.0.0.jar
    if !ERRORLEVEL! NEQ 0 pause
    exit /b !ERRORLEVEL!
)

rem ------------------------------------------------------------------
rem Step 2: Choose Maven runner
rem ------------------------------------------------------------------
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
    echo [사내 폐쇄망 / Nexus 환경 문제 해결 가이드]
    echo  1. 사내 Nexus 주소 및 모듈 버전을 확인/설정하려면:
    echo     'nexus-setup.bat' 을 실행하세요.
    echo  2. Nexus 빌드 과정 없이 즉시 실행하려면:
    echo     GitHub Releases에서 'plane-llm-hub-1.0.0.jar'를 다운로드하여
    echo     본 폴더에 넣고 run.bat을 실행하시면 Nexus 없이 즉시 구동됩니다.
    echo.
    pause
)
