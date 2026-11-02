@echo off
rem ==============================================================================
rem Plane LLM Hub - Corporate Nexus Auto-Inspection & Configuration Script
rem ==============================================================================
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

echo ==================================================================
echo   Plane LLM Hub - 사내 Nexus 설정 및 모듈 버전 자동 검사기
echo ==================================================================
echo.

rem Delegate to PowerShell for robust HTTP/JSON handling and XML modification
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell이 시스템에서 발견되지 않았습니다.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nexus-setup.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Nexus 설정 중 오류가 발생했습니다.
    pause
)
