# ✈️ Plane LLM Hub (Enterprise Web UI Sample)

> **Plane Web UI** 디자인 시스템을 기반으로 구성된 **Vue2 + Spring Boot 2.7 + MyBatis XML + H2** 풀스택 엔터프라이즈 레퍼런스 애플리케이션입니다.  
> 세련된 2단 내비게이션, 4~5열 횡방향 호버 플라이아웃 트리 메뉴, 기업용 데이터 그리드(**AUIGrid**) 및 웹 에디터(**Namo CrossEditor**), 전역 즐겨찾기(★) 및 사이드바 접기/펼치기 기능을 완벽히 탑재하고 있습니다.

---

## 🌟 주요 특징 및 UI/UX 구성

### 1. 🧭 좌측 글로벌 레일 내비게이션 (Global Icon Rail)
- **즐겨찾기 (`★`)**: 사용자가 별표로 등록한 메뉴들로만 사이드바를 즉시 재구성하는 전용 뷰
- **소문자 4종 모듈**:
  - `c` (`c-TTTM`): 최신 프론티어 LLM (OpenAI, Anthropic Claude, Google DeepMind, Meta AI, DeepSeek, Specialized 등)
  - `i` (`i-TTTM`): 유명 인터넷 포털 및 기술 사이트 (Search Engines, Tech Platforms, Cloud Providers, Dev Communities)
  - `f` (`fdc-TTTM`): 유명 AI 도구 (생성형 아트/미디어, 코딩/개발 어시스턴트, 생산성/글쓰기, 연구/지식)
  - `o` (`output-TTTM`): 유명 SNS 및 커뮤니티 (숏폼/비디오, 마이크로블로깅, 비즈니스 네트워킹, 메신저/커뮤니티)
- **대문자 4종 모듈 (`C`, `I`, `F`, `O`)**:
  - `c, i, f, o`의 메뉴 구조를 완벽히 계승하면서 독립적인 컴포넌트로 분리된 엔터프라이즈 전용 센터 모듈

### 2. 🌳 4~5열 횡방향 호버 트리 메뉴 (Horizontal Flyout Tree)
- 대메뉴에 마우스를 올리면 각 카테고리별 4~5개 모델/사이트/도구가 **가로 4~5열(Horizontal Columns)**로 정갈하게 펼쳐집니다.
- 각 열 아래로 6가지 핵심 부메뉴가 세로(Vertical)로 나열됩니다:
  1. 📌 **소개 및 개요**: 시스템 아키텍처 및 개요
  2. 💡 **주요 특징 & 사용법**: 핵심 스펙 및 사용 가이드
  3. 📊 **성능 분석 시트 (AUIGrid)**: 기업용 데이터 그리드 (컬럼 정렬, 다이나믹 필터링, 페이징, CSV 내보내기)
  4. 📝 **운영 가이드 (CrossEditor)**: 웹 위지윅 에디터 (글자 서식, 표 삽입, Design / HTML 소스 보기 전환)
  5. ⚖️ **장단점 비교**: 엔터프라이즈 환경에서의 강점과 한계점 분석
  6. 🔗 **공식 링크**: 공식 문서 및 플랫폼 리소스

### 3. 🎯 철저한 사용자 중심 단일 뷰 (Single Dedicated View)
- 부메뉴를 클릭하면 화면 상단의 중복 헤더와 불필요한 탭을 완전히 제거하고, **해당 부메뉴 전용 100% 독립 뷰**로 화면을 깔끔하게 채웁니다.
- 개발자 중심의 용어를 일체 배제하고 실제 사용자의 직관적인 업무 경험을 보장합니다.

### 4. ⭐ 스마트 즐겨찾기 & 사이드바 접기/펼치기
- **원클릭 즐겨찾기**: 모든 부메뉴 제목 좌측의 `[★] / [☆]` 버튼으로 즉시 즐겨찾기를 토글하며, 브라우저 `localStorage`에 영구 보존됩니다.
- **사이드바 접기/펼치기**: 사이드바 상단 `▼ 접기` / `▶ 펼치기` 토글을 통해 작업 화면을 최대화할 수 있습니다.

---

## 🛠️ 기술 스택 (Tech Stack)

| 구분 | 기술 스택 | 설명 |
| :--- | :--- | :--- |
| **Backend** | **Java 17 (LTS)** | Eclipse Temurin / OpenJDK 17 |
| | **Spring Boot 2.7.18** | 경량 웹 프레임워크 |
| | **MyBatis 2.3.2** | `*Mapper.xml` 기반 완전한 SQL 분리 아키텍처 |
| | **H2 Database 2.1.214** | 인메모리 내장형 DB (별도 RDBMS 설치 불필요, 구동 시 자동 초기화) |
| **Frontend** | **Vue.js 2.7** | 가볍고 안정적인 엔터프라이즈 SPA 프레임워크 |
| | **Node.js 24.18.0** | 표준 프론트엔드 툴체인 (빌드 산출물은 Spring Boot JAR에 사전 번들링) |
| | **AUIGrid & CrossEditor** | 엔터프라이즈 업무용 그리드 및 위지윅 에디터 시뮬레이션 |
| **Build & Tool** | **Maven Wrapper (`mvnw`)** | 별도의 Maven 설치 없이 모든 OS에서 원클릭 빌드 지원 |

---

## 📂 프로젝트 구조 (Project Structure)

```
plane-llm-hub/
├── plane-llm-hub-1.0.0.jar               # [핵심] 사전 빌드된 단일 Fat JAR (Nexus 없이 즉시 실행 가능)
├── mvnw / mvnw.cmd                       # Maven Wrapper (Linux/macOS/Windows)
├── run.sh                                # Linux / macOS 원클릭 실행 스크립트
├── run.bat                               # Windows CMD 원클릭 실행 스크립트
├── run.ps1                               # Windows PowerShell 실행 스크립트
├── nexus-setup.bat                       # 사내 Nexus 모듈 검사 및 pom.xml 자동 설정기
├── nexus-setup.ps1                       # Nexus 검사 PowerShell 엔진
├── pom.xml                               # Spring Boot 및 MyBatis 의존성 정의
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/plane/llmhub/
│   │   │   ├── PlaneLlmHubApplication.java # Spring Boot 진입점
│   │   │   ├── controller/               # REST API 컨트롤러 (/api/*)
│   │   │   ├── mapper/                   # MyBatis Java 매퍼 인터페이스
│   │   │   ├── model/                    # 도메인 VO/DTO 객체
│   │   │   └── service/                  # 비즈니스 로직 계층
│   │   └── resources/
│   │       ├── application.yml           # Spring Boot, H2, MyBatis 경로 설정
│   │       ├── schema.sql                # 테이블 DDL (Category, Model, Content, Metric)
│   │       ├── data.sql                  # 초기 데이터 적재 SQL
│   │       ├── mapper/                   # MyBatis XML 매퍼
│   │       │   ├── CategoryMapper.xml
│   │       │   ├── ModelMapper.xml
│   │       │   ├── ContentMapper.xml
│   │       │   └── MetricMapper.xml
│   │       └── static/                   # Vue2 웹 클라이언트 리소스 (JAR에 번들링)
│   │           ├── index.html            # 메인 SPA 뷰
│   │           ├── css/plane.css         # Plane UI 테마 및 반응형 레이아웃 CSS
│   │           └── js/app.js             # Vue2 인스턴스, 스토어, 컴포넌트 로직
└── frontend/                             # Node 24.18.0 기반 프론트엔드 소스 환경
    ├── package.json                      # "engines": { "node": "24.18.0" }
    ├── .nvmrc                            # v24.18.0
    └── vite.config.js                    # Vite 빌드 설정
```

---

## 🚀 빌드 및 실행 방법 (Quick Start)

### 📋 사전 준비 사항 (Prerequisites)
- **Java 17 이상** (JDK 17 LTS 필수)
  - Java 설치 여부 확인: `java -version`
  - *참고: Maven이나 Node.js는 사전에 설치되어 있지 않아도 프로젝트 내부 번들 스크립트로 즉시 실행됩니다.*

---

### 방법 1. 원클릭 실행 스크립트 (가장 추천 - 폐쇄망/Nexus 무관 1초 실행)

프로젝트 루트에 모든 라이브러리와 프론트엔드가 포함된 **`plane-llm-hub-1.0.0.jar`가 기본 내장**되어 있으므로, 사내 폐쇄망에서 Maven이나 Nexus 연결 없이도 Java만 있으면 1초 만에 즉시 실행됩니다.

#### 🪟 Windows (사내 업무용 PC)
1. **GitHub에서 ZIP 다운로드** (또는 `git clone`):
   - GitHub 상단의 초록색 **`Code` ➔ `Download ZIP`** 버튼을 눌러 압축을 내려받고 압축을 해제합니다.
2. 탐색기에서 **`run.bat`** 파일을 더블클릭합니다.
   - 스크립트가 내장된 `plane-llm-hub-1.0.0.jar`를 자동 감지하여 Maven/Nexus 다운로드 없이 Java로 즉시 서버를 구동합니다!
   - *(PowerShell 콘솔을 이용하시는 경우 `.\run.ps1`을 입력하셔도 됩니다.)*

#### 🐧 Linux / 🍎 macOS
터미널에서 아래 명령어를 실행합니다:
```bash
git clone https://github.com/slalglel3/plane-llm-hub.git
cd plane-llm-hub
chmod +x run.sh
./run.sh
```

---

### 방법 2. Maven Wrapper를 이용한 수동 실행

#### 🐧 Linux / 🍎 macOS
```bash
./mvnw spring-boot:run
```

#### 🪟 Windows
```cmd
mvnw.cmd spring-boot:run
```

---

### 방법 3. 독립 실행형 JAR 패키징 및 실행

Maven으로 독립 실행형 단일 `jar` 파일을 생성한 후 Java 명령어로 즉시 구동할 수 있습니다.

```bash
# 1. 빌드 및 패키징 (테스트 포함)
./mvnw clean package

# 2. 생성된 Fat JAR 실행
java -jar target/plane-llm-hub-1.0.0.jar
```
*(Windows는 `./mvnw` 대신 `mvnw.cmd` 사용)*

---

### 방법 4. 프론트엔드 개발 서버 실행 (선택 사항, Node 24.18.0)

프론트엔드 소스를 직접 수정하며 실시간 핫 리로딩(HMR) 개발을 원할 경우:
```bash
cd frontend
node -v # v24.18.0 권장
npm install
npm run dev
```
- 프론트엔드 개발 URL: `http://localhost:3000` (백엔드 8080 포트와 자동 프록시 연동)

---

### 🏢 사내 폐쇄망 및 Nexus 환경 실행 가이드

사내 개발망에서 외부 인터넷(Maven Central) 접근이 차단되어 있고 사내 Nexus 프록시만 허용된 경우, 아래 2가지 방법 중 하나를 선택하여 손쉽게 실행할 수 있습니다.

#### 방법 A. 사내 Nexus 설정 도구 실행 (`nexus-setup.bat`)
1. 탐색기에서 **`nexus-setup.bat`**을 더블클릭합니다.
2. 콘솔 프롬프트에 사내 Nexus 전체 주소를 입력합니다 (예: `http://nexus.company.com:8081/repository/maven-public`).
3. 스크립트가 Nexus REST API를 조회하여 사내 Nexus에 캐시된 **Spring Boot** 및 **MyBatis** 버전을 자동으로 검사하고 추천합니다.
4. `pom.xml`에 사내 Nexus 저장소 URL 및 호환 버전이 자동으로 반영되며 즉시 빌드가 진행됩니다.

#### 방법 B. 사전 빌드된 단일 Fat JAR 다운로드 실행 (가장 추천)
사내 Nexus에 Spring Boot 모듈이 없더라도, 이미 모든 라이브러리와 Vue 프론트엔드가 포함된 **단일 실행 JAR**를 사용하면 Nexus 없이 Java만으로 즉시 구동됩니다:
1. GitHub Releases 페이지에서 **`plane-llm-hub-1.0.0.jar`**를 다운로드합니다.
2. 프로젝트 루트 폴더에 해당 `.jar` 파일을 넣고 **`run.bat`**을 실행합니다.
3. `run.bat`이 사전 빌드된 JAR를 감지하여 Maven 다운로드 없이 1초 만에 서버를 즉시 기동합니다.
   ```cmd
   java -jar plane-llm-hub-1.0.0.jar
   ```

---

## 🌐 접속 주소 및 API 엔드포인트

서버가 실행되면 웹 브라우저를 열고 아래 주소로 접속합니다:

- **웹 애플리케이션 메인 화면**:  
  👉 **`http://localhost:8080/`**

- **H2 인메모리 데이터베이스 콘솔**:  
  👉 **`http://localhost:8080/h2-console`**
  - **JDBC URL**: `jdbc:h2:mem:llmhub`
  - **User Name**: `sa`
  - **Password**: *(공백/없음)*

### 주요 REST API
- `GET /api/categories?railType={c|i|f|o|C|I|F|O}`: 특정 모듈의 대메뉴 목록 및 하위 모델/사이트 트리 조회
- `GET /api/models?categoryId={id}`: 카테고리에 속한 세부 모델 목록 조회
- `GET /api/contents?modelId={id}&subKey={overview|features|auigrid|crosseditor|proscons|links}`: 부메뉴별 세부 콘텐츠 조회
- `GET /api/metrics?modelId={id}`: 벤치마크 및 스펙 지표 데이터 조회

---

## 💡 주요 UI 기능 안내

1. **상단 별표(★) 클릭**: 현재 내가 즐겨찾기해 둔 메뉴들만 사이드바에 필터링되어 나타납니다.
2. **좌측 `c`, `i`, `f`, `o` / `C`, `I`, `F`, `O` 클릭**: 각 모듈별 전용 대메뉴 목록으로 전환됩니다.
3. **대메뉴 위 마우스 호버**: 가로 4~5열로 정렬된 부메뉴 플라이아웃 카드가 즉시 나타납니다.
4. **부메뉴 클릭**: 클릭한 부메뉴의 상세 콘텐츠가 메인 화면 전체에 100% 렌더링됩니다.
5. **제목 옆 별표 클릭**: 즐겨찾기가 즉시 등록/해제되며 상단 `★` 메뉴에 실시간 반영됩니다.
6. **AUIGrid 메뉴 클릭**: 실시간 데이터 정렬, 컬럼 필터, 페이지 이동 및 CSV 다운로드 기능을 테스트할 수 있습니다.
7. **CrossEditor 메뉴 클릭**: 글꼴 스타일, 표 생성, 이미지/링크 삽입 및 'Design ↔ HTML' 탭 전환을 체험할 수 있습니다.
8. **사이드바 접기/펼치기**: 상단 토글 버튼을 통해 사이드바 폭을 최소화하여 넓은 작업 화면을 확보할 수 있습니다.

---

## 📄 라이선스 (License)

This project is licensed under the Apache License 2.0.
