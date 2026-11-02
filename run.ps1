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

# ------------------------------------------------------------------
# Step 1: Detect and validate JAVA_HOME
# ------------------------------------------------------------------
$validJavaHome = $null

if ($env:JAVA_HOME) {
    $cleanPath = $env:JAVA_HOME.Trim('"').Trim().TrimEnd('\')
    if ($cleanPath.EndsWith('\bin', [System.StringComparison]::OrdinalIgnoreCase)) {
        $cleanPath = Split-Path $cleanPath
    }
    if (Test-Path "$cleanPath\bin\java.exe") {
        $validJavaHome = $cleanPath
    }
}

if (-not $validJavaHome) {
    # Try deriving from 'where java'
    $javaCmd = Get-Command java -ErrorAction SilentlyContinue
    if ($javaCmd -and $javaCmd.Source) {
        $binDir = Split-Path $javaCmd.Source
        if ((Split-Path $binDir -Leaf) -eq "bin") {
            $parentDir = Split-Path $binDir
            if (Test-Path "$parentDir\bin\java.exe") {
                $validJavaHome = $parentDir
            }
        }
    }
}

if (-not $validJavaHome) {
    # Search common JDK directories
    $searchPatterns = @(
        "C:\Program Files\Eclipse Adoptium\jdk-*",
        "C:\Program Files\Java\jdk-*",
        "C:\Program Files\Amazon Corretto\jdk*",
        "C:\Program Files\Zulu\zulu-*",
        "C:\Program Files\Microsoft\jdk-*",
        "$env:USERPROFILE\.jdks\*",
        "C:\Program Files\BellSoft\LibericaJDK-*"
    )
    foreach ($pat in $searchPatterns) {
        $dirs = Get-Item $pat -ErrorAction SilentlyContinue
        if ($dirs) {
            foreach ($d in $dirs) {
                if (Test-Path "$($d.FullName)\bin\java.exe") {
                    $validJavaHome = $d.FullName
                    break
                }
            }
        }
        if ($validJavaHome) { break }
    }
}

if (-not $validJavaHome) {
    Write-Host "[ERROR] Could not find a valid Java 17+ installation or JAVA_HOME." -ForegroundColor Red
    Write-Host "Maven requires the JAVA_HOME environment variable to be set." -ForegroundColor Yellow
    Write-Host "Please install OpenJDK 17/20/21 from: https://adoptium.net/temurin/releases/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Export JAVA_HOME and ensure bin is in PATH
$env:JAVA_HOME = $validJavaHome
$env:PATH = "$validJavaHome\bin;" + $env:PATH

Write-Host "[INFO] JAVA_HOME set to: $env:JAVA_HOME" -ForegroundColor Green
$javaVer = & "$validJavaHome\bin\java.exe" -version 2>&1 | Select-Object -First 1
Write-Host "[INFO] Detected Java: $javaVer" -ForegroundColor Green
Write-Host ""

# Check if pre-built standalone JAR exists
$jarPath = Join-Path $PSScriptRoot "plane-llm-hub-1.0.0.jar"
if (Test-Path $jarPath) {
    Write-Host "[INFO] 사전 빌드된 단일 Fat JAR (plane-llm-hub-1.0.0.jar) 감지됨." -ForegroundColor Green
    Write-Host "[INFO] Maven/Nexus 다운로드 없이 Java 단독으로 즉시 기동합니다..." -ForegroundColor Cyan
    Write-Host "[INFO] 서버 기동 완료 후 브라우저 접속: http://localhost:8080/" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    & "$validJavaHome\bin\java.exe" -jar $jarPath
    exit $LASTEXITCODE
}

# ------------------------------------------------------------------
# Step 2: Choose Maven runner
# ------------------------------------------------------------------
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

try {
    & $execCmd spring-boot:run
} catch {
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Red
    Write-Host "[사내 폐쇄망 / Nexus 환경 문제 해결 가이드]" -ForegroundColor Yellow
    Write-Host " 1. 사내 Nexus 주소 및 모듈 버전을 확인/설정하려면:" -ForegroundColor Yellow
    Write-Host "    .\nexus-setup.ps1 (또는 nexus-setup.bat)을 실행하세요." -ForegroundColor White
    Write-Host " 2. Nexus 빌드 과정 없이 즉시 실행하려면:" -ForegroundColor Yellow
    Write-Host "    GitHub Releases에서 'plane-llm-hub-1.0.0.jar'를 다운로드하여" -ForegroundColor White
    Write-Host "    본 폴더에 넣고 .\run.ps1을 실행하시면 Nexus 없이 즉시 구동됩니다." -ForegroundColor White
    Write-Host "==================================================================" -ForegroundColor Red
    Read-Host "엔터를 누르면 종료합니다..."
}
