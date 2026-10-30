# ✈️ Plane LLM Hub (Vue2 + Spring Boot + MyBatis XML)

> **Plane Web UI** 디자인 시스템을 적용하여 현재 세상에 존재하는 주요 프론티어 LLM(대형 언어 모델)들의 아키텍처, 사용법, 장단점, 벤치마크 및 공식 리소스를 체계적으로 구성한 풀스택 프로젝트입니다.

---

## 🌟 프로젝트 개요

- **UI/UX 디자인**: Mobbin에서 큐레이션된 **Plane Web**의 최신 인터페이스 적용
  - 좌측 글로벌 아이콘 레일 (Projects, Wiki, AI Advisor, Settings, Trial Badge)
  - 2단 계층형 내비게이션 사이드바 (LLM 제공사별 아코디언 메뉴 & 실시간 검색)
  - **Ask Pi / LLM Advisor** 반응형 AI 질의응답 배너
  - **5대 서브 메뉴 탭 시스템**:
    1. 📌 **소개 및 개요 (Overview)**: 아키텍처 및 토크나이저 특징
    2. 💡 **주요 특징 & 사용법 (Usage)**: Python/REST SDK 예제 및 파라미터 가이드
    3. ⚖️ **장단점 비교 (Pros & Cons)**: 실무 강점과 한계점 카드 분할 뷰
    4. 📊 **벤치마크 및 스펙 (Specs)**: SWE-bench, MATH, MMLU 게이지 바 시각화
    5. 🔗 **공식 링크 & 리소스 (Links)**: 공식 문서, 플레이그라운드, 연구 논문
  - **Customize Navigation** 모달 팝업

- **백엔드 기술 스택**:
  - **Java 17** + **Spring Boot 2.7.18**
  - **MyBatis 2.3.2** (`*Mapper.xml` 기반 완전한 XML SQL 분리 구조)
  - **Embedded H2 Database** (별도 DB 설치 없이 즉시 실행 가능, `schema.sql` / `data.sql` 자동 적재)
  - **RESTful API** (`/api/categories`, `/api/models`, `/api/stats` 등)

- **프론트엔드 기술 스택**:
  - **Vue 2 (Vue 2.7)**
  - **Node.js 24.18.0** 표준 (`frontend/package.json`, `.nvmrc` 명시)
  - **Marked.js** & **Highlight.js** (마크다운 파싱 및 코드 블록 하이라이트)

---

## 📂 프로젝트 구조

```
plane-llm-hub/
├── pom.xml                               # Maven 의존성 및 빌드 설정
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/plane/llmhub/
│   │   │   ├── PlaneLlmHubApplication.java # Spring Boot 메인 클래스
│   │   │   ├── controller/               # REST API & SPA 포워딩 컨트롤러
│   │   │   ├── mapper/                   # MyBatis 매퍼 인터페이스
│   │   │   ├── model/                    # 도메인 DTO/Entity
│   │   │   └── service/                  # 비즈니스 로직 서비스
│   │   └── resources/
│   │       ├── application.yml           # H2 및 MyBatis XML 경로 설정
│   │       ├── schema.sql                # DDL 테이블 스키마
│   │       ├── data.sql                  # 주요 LLM 초기 데이터
│   │       ├── mapper/                   # MyBatis XML 쿼리 매퍼 (핵심)
│   │       │   ├── CategoryMapper.xml
│   │       │   ├── ModelMapper.xml
│   │       │   ├── ContentMapper.xml
│   │       │   └── MetricMapper.xml
│   │       └── static/                   # Plane UI Vue 2 웹 애플리케이션
│   │           ├── index.html            # 메인 SPA 뷰
│   │           ├── css/plane.css         # Plane Web 전용 디자인 CSS
│   │           └── js/app.js             # Vue 2 인스턴스 & 비즈니스 로직
└── frontend/                             # Node 24.18.0 기반 프론트엔드 환경
    ├── package.json                      # "engines": { "node": "24.18.0" }
    ├── .nvmrc                            # v24.18.0
    └── vite.config.js                    # Vite + Vue 2 빌드 설정
```

---

## 🚀 빠른 시작 가이드 (Quick Start)

### 1. 백엔드 빌드 및 서버 실행 (원클릭)
별도의 데이터베이스나 복잡한 설정 없이 내장된 Maven과 H2로 즉시 실행할 수 있습니다.

```bash
cd /home/slalglel/workspace/plane-llm-hub
mvn spring-boot:run
```

- 웹 브라우저 접속: `http://localhost:8080`
- H2 데이터베이스 콘솔: `http://localhost:8080/h2-console`
  - JDBC URL: `jdbc:h2:mem:llmhub`
  - Username: `sa` (Password: 없음)

### 2. 프론트엔드 개발 모드 실행 (Node 24.18.0 기준)
```bash
cd /home/slalglel/workspace/plane-llm-hub/frontend
node24 -v # v24.18.0 확인
npm24 install
npm24 run dev
```
- 프론트엔드 개발 서버: `http://localhost:3000` (백엔드 8080 포트와 자동 프록시 연동)

---

## 🤖 등록된 주요 LLM 라인업

1. **OpenAI**: `GPT-4o (Omni)`, `OpenAI o1 (Full Reasoning)`
2. **Anthropic Claude**: `Claude 3.7 Sonnet (Hybrid Thinking)`, `Claude 3.5 Sonnet (Agentic Coding)`
3. **Google DeepMind**: `Gemini 2.0 Flash (Realtime Multimodal)`, `Gemini 1.5 Pro (2M Massive Context)`
4. **Meta AI (Open Source)**: `Llama 3.3 70B Instruct (Open Weights)`
5. **DeepSeek**: `DeepSeek-R1 (Open Reasoning / MIT)`, `DeepSeek-V3 (671B MoE)`
6. **Specialized**: `Qwen 2.5 Coder 32B Instruct (Code Specialist)`
