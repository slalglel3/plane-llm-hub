# ==============================================================================
# Plane LLM Hub - One-Click Launch Script for Windows PowerShell
# ==============================================================================
$ErrorActionPreference = "Stop"

Set-Location -Path $PSScriptRoot

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Plane LLM Hub - Enterprise Web UI Sample" -ForegroundColor Cyan
Write-Host "  Vue2 + Spring Boot 2.7 + MyBatis XML + Embedded H2" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Check Java in PATH
$javaCmd = Get-Command java -ErrorAction SilentlyContinue

# Check JAVA_HOME if not in PATH
if (-not $javaCmd) {
    if ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin\java.exe")) {
        $env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
        $javaCmd = Get-Command java -ErrorAction SilentlyContinue
    }
}

# Check common JDK directories
if (-not $javaCmd) {
    $searchPaths = @(
        "C:\Program Files\Eclipse Adoptium\jdk-17*\bin\java.exe",
        "C:\Program Files\Java\jdk-17*\bin\java.exe",
        "C:\Program Files\Java\jdk-21*\bin\java.exe",
        "C:\Program Files\Amazon Corretto\jdk17*\bin\java.exe",
        "C:\Program Files\Zulu\zulu-17*\bin\java.exe",
        "C:\Program Files\Microsoft\jdk-17*\bin\java.exe"
    )
    foreach ($p in $searchPaths) {
        $found = Get-Item $p -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $binDir = Split-Path $found.FullName
            $env:PATH = "$binDir;" + $env:PATH
            $javaCmd = Get-Command java -ErrorAction SilentlyContinue
            break
        }
    }
}

if (-not $javaCmd) {
    Write-Host "[ERROR] Java 17+ is required but 'java' was not found in PATH." -ForegroundColor Red
    Write-Host "Please install OpenJDK 17 (e.g., Eclipse Temurin 17) and try again." -ForegroundColor Yellow
    Write-Host "Download: https://adoptium.net/temurin/releases/?version=17" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

$javaVer = & java -version 2>&1 | Select-Object -First 1
Write-Host "[INFO] Detected Java: $javaVer" -ForegroundColor Green
Write-Host ""

# Prefer system Maven if available
$mvnCmd = Get-Command mvn -ErrorAction SilentlyContinue
if ($mvnCmd) {
    Write-Host "[INFO] Using installed Maven: mvn" -ForegroundColor Gray
    $execCmd = "mvn"
} else {
    Write-Host "[INFO] Using Maven Wrapper: mvnw.cmd" -ForegroundColor Gray
    $execCmd = ".\mvnw.cmd"
}

Write-Host "[INFO] Starting Spring Boot Application on port 8080..." -ForegroundColor Cyan
Write-Host "[INFO] Once started, access: http://localhost:8080/" -ForegroundColor Green
Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

& $execCmd spring-boot:run
