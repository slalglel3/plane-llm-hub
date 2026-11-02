@echo off
rem ==============================================================================
rem Plane LLM Hub - One-Click Launch Script for Windows
rem ==============================================================================
chcp 65001 >nul
cd /d "%~dp0"

echo ==================================================================
echo  Plane LLM Hub (Vue2 + Spring Boot + MyBatis XML)
echo ==================================================================

where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java 17+ is required but 'java' was not found in your PATH.
    echo Please install OpenJDK 17 or higher (e.g. Eclipse Temurin 17) and try again.
    pause
    exit /b 1
)

echo [INFO] Starting Spring Boot Application via Maven Wrapper...
echo [INFO] Once started, open your web browser at: http://localhost:8080
echo ------------------------------------------------------------------

call mvnw.cmd spring-boot:run

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Application terminated with error code %ERRORLEVEL%.
    pause
)
