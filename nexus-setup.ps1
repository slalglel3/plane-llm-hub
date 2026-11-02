# ==============================================================================
# Plane LLM Hub - Corporate Nexus Auto-Inspection & Configuration Script
# ==============================================================================
$ErrorActionPreference = "Continue"

Set-Location -Path $PSScriptRoot

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  Plane LLM Hub - 사내 Nexus 연동 및 모듈 버전 확인/설정 도구" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[안내] 사내 폐쇄망 환경에서 Nexus에 등록된 모듈 버전을 확인하고," -ForegroundColor Yellow
Write-Host "      pom.xml에 Nexus 저장소 URL 및 호환 버전을 자동으로 반영합니다." -ForegroundColor Yellow
Write-Host ""

# 1. Input Nexus URL
$nexusInput = Read-Host "1. 사내 Nexus 주소를 입력하세요`n   (예: http://nexus.company.com:8081 또는 http://nexus.company.com/repository/maven-public)"
if (-not $nexusInput) {
    Write-Host "[ERROR] Nexus 주소가 입력되지 않았습니다." -ForegroundColor Red
    Read-Host "엔터를 누르면 종료합니다..."
    exit 1
}

$nexusUrl = $nexusInput.Trim().TrimEnd('/')
if (-not $nexusUrl.StartsWith("http://") -and -not $nexusUrl.StartsWith("https://")) {
    $nexusUrl = "http://" + $nexusUrl
}

# 2. Optional Credentials
$useAuth = Read-Host "`n2. Nexus 접근 시 로그인 인증이 필요합니까? (y/N)"
$headers = @{}
if ($useAuth -eq 'y' -or $useAuth -eq 'Y') {
    $user = Read-Host "   - Nexus 사용자 아이디 (Username)"
    $pass = Read-Host "   - Nexus 비밀번호 (Password)" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)
    $plainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    $pair = "$user`:$plainPass"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $headers["Authorization"] = "Basic $base64"
}

Write-Host ""
Write-Host "[INFO] 사내 Nexus에서 필수 모듈 버전 탐색 중..." -ForegroundColor Cyan

function Get-NexusVersions {
    param (
        [string]$baseUrl,
        [string]$groupId,
        [string]$artifactId,
        [hashtable]$reqHeaders
    )

    $foundVersions = [System.Collections.Generic.List[string]]::new()

    # 1. Try Nexus 3 REST API (/service/rest/v1/search)
    $api3Url = "$baseUrl/service/rest/v1/search?group=$groupId&name=$artifactId"
    try {
        $res = Invoke-RestMethod -Uri $api3Url -Headers $reqHeaders -TimeoutSec 6 -ErrorAction Stop
        if ($res.items) {
            foreach ($item in $res.items) {
                if ($item.version -and -not $foundVersions.Contains($item.version)) {
                    $foundVersions.Add($item.version)
                }
            }
        }
    } catch {}

    # 2. Try Nexus 2 Lucene API (/service/local/lucene/search)
    if ($foundVersions.Count -eq 0) {
        $api2Url = "$baseUrl/service/local/lucene/search?g=$groupId&a=$artifactId"
        try {
            $xmlRes = Invoke-RestMethod -Uri $api2Url -Headers $reqHeaders -TimeoutSec 6 -ErrorAction Stop
            if ($xmlRes.searchNGResponse.data.artifact) {
                foreach ($art in $xmlRes.searchNGResponse.data.artifact) {
                    if ($art.version -and -not $foundVersions.Contains($art.version)) {
                        $foundVersions.Add($art.version)
                    }
                }
            }
        } catch {}
    }

    # 3. Try Maven Metadata (maven-metadata.xml)
    if ($foundVersions.Count -eq 0) {
        $groupPath = $groupId.Replace('.', '/')
        $metaUrl = "$baseUrl/$groupPath/$artifactId/maven-metadata.xml"
        try {
            [xml]$metaXml = Invoke-RestMethod -Uri $metaUrl -Headers $reqHeaders -TimeoutSec 6 -ErrorAction Stop
            if ($metaXml.metadata.versioning.versions.version) {
                foreach ($v in $metaXml.metadata.versioning.versions.version) {
                    if (-not $foundVersions.Contains($v)) {
                        $foundVersions.Add($v)
                    }
                }
            }
        } catch {}
    }

    return $foundVersions.ToArray()
}

# Inspect Spring Boot
Write-Host "  - [1/2] spring-boot-starter-parent 확인 중..." -NoNewline
$bootVersions = Get-NexusVersions -baseUrl $nexusUrl -groupId "org.springframework.boot" -artifactId "spring-boot-starter-parent" -reqHeaders $headers
if ($bootVersions.Count -gt 0) {
    Write-Host " [성공: $($bootVersions.Count)개 버전 발견]" -ForegroundColor Green
    Write-Host "    Nexus 등록 버전: $($bootVersions -join ', ')" -ForegroundColor Gray
} else {
    Write-Host " [자동 검색 불가 (사내 보안 정책으로 REST API 제한됨)]" -ForegroundColor Yellow
}

# Inspect MyBatis
Write-Host "  - [2/2] mybatis-spring-boot-starter 확인 중..." -NoNewline
$myBatisVersions = Get-NexusVersions -baseUrl $nexusUrl -groupId "org.mybatis.spring.boot" -artifactId "mybatis-spring-boot-starter" -reqHeaders $headers
if ($myBatisVersions.Count -gt 0) {
    Write-Host " [성공: $($myBatisVersions.Count)개 버전 발견]" -ForegroundColor Green
    Write-Host "    Nexus 등록 버전: $($myBatisVersions -join ', ')" -ForegroundColor Gray
} else {
    Write-Host " [자동 검색 불가 (사내 보안 정책으로 REST API 제한됨)]" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host " 프로젝트에 적용할 모듈 버전을 선택합니다." -ForegroundColor Cyan
Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan

# Determine default Boot version
$defaultBoot = "2.7.18"
if ($bootVersions.Count -gt 0) {
    $v27 = $bootVersions | Where-Object { $_ -like "2.7.*" } | Select-Object -Last 1
    if ($v27) { $defaultBoot = $v27 } else { $defaultBoot = $bootVersions[-1] }
}

Write-Host "권장 사양: Spring Boot 2.7.x (예: 2.7.18, 2.7.14, 2.7.10 등)" -ForegroundColor Gray
$selectedBoot = Read-Host "Spring Boot Parent 버전 입력 [엔터 시 기본값: '$defaultBoot']"
if (-not $selectedBoot) { $selectedBoot = $defaultBoot }

# Determine default MyBatis version
$defaultMyBatis = "2.3.2"
if ($myBatisVersions.Count -gt 0) {
    $v2 = $myBatisVersions | Where-Object { $_ -like "2.*" } | Select-Object -Last 1
    if ($v2) { $defaultMyBatis = $v2 } else { $defaultMyBatis = $myBatisVersions[-1] }
}

Write-Host "권장 사양: MyBatis Starter 2.x (예: 2.3.2, 2.3.1, 2.2.2 등)" -ForegroundColor Gray
$selectedMyBatis = Read-Host "MyBatis Starter 버전 입력 [엔터 시 기본값: '$defaultMyBatis']"
if (-not $selectedMyBatis) { $selectedMyBatis = $defaultMyBatis }

Write-Host ""
Write-Host "[INFO] pom.xml 파일에 사내 Nexus 설정 및 버전을 주입하는 중..." -ForegroundColor Cyan

$pomPath = Join-Path $PSScriptRoot "pom.xml"
[xml]$pomXml = Get-Content $pomPath -Encoding UTF8

# Update parent version
$pomXml.project.parent.version = $selectedBoot

# Update mybatis version property
if ($pomXml.project.properties.'mybatis-spring-boot.version') {
    $pomXml.project.properties.'mybatis-spring-boot.version' = $selectedMyBatis
}

# Ensure <repositories> node exists and has company-nexus
$ns = $pomXml.DocumentElement.NamespaceURI
$repoNode = $pomXml.SelectSingleNode("//*[local-name()='repositories']")
if (-not $repoNode) {
    $repoNode = $pomXml.CreateElement("repositories", $ns)
    $pomXml.project.AppendChild($repoNode) | Out-Null
}

$oldRepo = $pomXml.SelectSingleNode("//*[local-name()='repository'][*[local-name()='id']='company-nexus']")
if ($oldRepo) { $oldRepo.ParentNode.RemoveChild($oldRepo) | Out-Null }

$newRepo = $pomXml.CreateElement("repository", $ns)
$newRepo.InnerXml = "<id>company-nexus</id><name>Company Nexus</name><url>$nexusUrl</url><releases><enabled>true</enabled></releases><snapshots><enabled>true</enabled></snapshots>"
$repoNode.AppendChild($newRepo) | Out-Null

# Ensure <pluginRepositories> node exists and has company-nexus
$pluginRepoNode = $pomXml.SelectSingleNode("//*[local-name()='pluginRepositories']")
if (-not $pluginRepoNode) {
    $pluginRepoNode = $pomXml.CreateElement("pluginRepositories", $ns)
    $pomXml.project.AppendChild($pluginRepoNode) | Out-Null
}

$oldPluginRepo = $pomXml.SelectSingleNode("//*[local-name()='pluginRepository'][*[local-name()='id']='company-nexus']")
if ($oldPluginRepo) { $oldPluginRepo.ParentNode.RemoveChild($oldPluginRepo) | Out-Null }

$newPluginRepo = $pomXml.CreateElement("pluginRepository", $ns)
$newPluginRepo.InnerXml = "<id>company-nexus</id><name>Company Nexus</name><url>$nexusUrl</url><releases><enabled>true</enabled></releases><snapshots><enabled>true</enabled></snapshots>"
$pluginRepoNode.AppendChild($newPluginRepo) | Out-Null

$pomXml.Save($pomPath)

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
Write-Host " [완료] pom.xml이 사내 환경에 맞게 성공적으로 갱신되었습니다!" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Host "  - Spring Boot Parent 버전 : $selectedBoot" -ForegroundColor Green
Write-Host "  - MyBatis Starter 버전    : $selectedMyBatis" -ForegroundColor Green
Write-Host "  - 사내 Nexus 저장소 URL  : $nexusUrl" -ForegroundColor Green
Write-Host ""

$runNow = Read-Host "지금 바로 run.bat을 실행하여 빌드 및 서버를 기동하시겠습니까? (Y/n)"
if ($runNow -ne 'n' -and $runNow -ne 'N') {
    & "$PSScriptRoot\run.bat"
}
