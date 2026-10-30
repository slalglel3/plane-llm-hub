-- Categories
INSERT INTO categories (id, slug, name, icon, tagline, display_order) VALUES
(1, 'openai', 'OpenAI', '⚡', 'Pioneering frontier intelligence & reasoning models', 1),
(2, 'anthropic', 'Anthropic Claude', '🧠', 'Constitutional AI, state-of-the-art coding & agentic reasoning', 2),
(3, 'google', 'Google DeepMind Gemini', '✨', 'Massive context windows & native omni-modal processing', 3),
(4, 'meta', 'Meta Llama (Open Source)', '🦙', 'Leading open-weights foundational models for enterprise self-hosting', 4),
(5, 'deepseek', 'DeepSeek', '🐋', 'Disruptive high-efficiency MoE & pure RL reasoning models', 5),
(6, 'specialized', 'Specialized & Open Weights', '🚀', 'Fine-tuned code generation & multilingual powerhouses', 6);

-- Models
INSERT INTO llm_models (id, category_id, model_key, name, provider, release_date, context_window, max_output, pricing_input, pricing_output, badge, tagline, display_order) VALUES
-- OpenAI
(1, 1, 'gpt-4o', 'GPT-4o (Omni)', 'OpenAI', '2024-05', '128K tokens', '16K tokens', '$2.50 / 1M', '$10.00 / 1M', 'Multimodal', 'Flagship omni-modal model with high speed, vision, and real-time audio.', 1),
(2, 1, 'o1', 'OpenAI o1 (Full Reasoning)', 'OpenAI', '2024-12', '200K tokens', '100K tokens', '$15.00 / 1M', '$60.00 / 1M', 'Reasoning', 'Deliberate chain-of-thought model for complex mathematics, coding, and science.', 2),

-- Anthropic
(3, 2, 'claude-3-7-sonnet', 'Claude 3.7 Sonnet', 'Anthropic', '2025-02', '200K tokens', '64K tokens', '$3.00 / 1M', '$15.00 / 1M', 'Hybrid Thinking', 'State-of-the-art hybrid model combining instant responses with adaptive thinking.', 1),
(4, 2, 'claude-3-5-sonnet', 'Claude 3.5 Sonnet', 'Anthropic', '2024-10', '200K tokens', '8K tokens', '$3.00 / 1M', '$15.00 / 1M', 'Agentic Coding', 'The gold standard benchmark model for complex coding, agent workflows, and nuance.', 2),

-- Google
(5, 3, 'gemini-2-0-flash', 'Gemini 2.0 Flash', 'Google DeepMind', '2024-12', '1M tokens', '8K tokens', '$0.10 / 1M', '$0.40 / 1M', 'Realtime Speed', 'Next-gen native multimodal model built for blazing real-time speeds and agent tools.', 1),
(6, 3, 'gemini-1-5-pro', 'Gemini 1.5 Pro', 'Google DeepMind', '2024-04', '2M tokens', '8K tokens', '$1.25 / 1M', '$5.00 / 1M', '2M Context', 'Revolutionary 2,000,000 token context window for digesting books, codebases, and video.', 2),

-- Meta
(7, 4, 'llama-3-3-70b', 'Llama 3.3 70B Instruct', 'Meta AI', '2024-12', '128K tokens', '4K tokens', 'Open Weights', 'Self-hostable', 'Open Weights', 'Industry-leading 70B open model matching previous 405B capabilities at 1/5 the compute.', 1),

-- DeepSeek
(8, 5, 'deepseek-r1', 'DeepSeek-R1', 'DeepSeek', '2025-01', '128K tokens', '32K tokens', '$0.55 / 1M', '$2.19 / 1M', 'Open Reasoning', 'Reinforcement learning reasoning model rivaling OpenAI o1 with open weights and MIT license.', 1),
(9, 5, 'deepseek-v3', 'DeepSeek-V3', 'DeepSeek', '2024-12', '128K tokens', '8K tokens', '$0.14 / 1M', '$0.28 / 1M', '671B MoE', 'Massive 671B parameter MoE architecture delivering frontier performance at ultra-low inference cost.', 2),

-- Specialized / Qwen
(10, 6, 'qwen-2-5-coder-32b', 'Qwen 2.5 Coder 32B Instruct', 'Alibaba Cloud', '2024-11', '128K tokens', '8K tokens', 'Open Weights', 'Apache 2.0', 'Coding Expert', 'The most capable open-source code LLM, competing head-to-head with proprietary closed models.', 1);

-- Model Contents (Sub-menus for each model)
-- Model 1: GPT-4o
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(1, 'OVERVIEW', 'GPT-4o 개요 및 아키텍처', 
'### GPT-4o: OpenAI의 플래그십 옴니모달 파운데이션 모델

GPT-4o("o"는 omni를 의미)는 텍스트, 비전(이미지), 오디오 입출력을 단일 엔드투엔드 뉴럴 네트워크로 통합 처리하도록 설계된 OpenAI의 핵심 플래그십 모델입니다.

#### 주요 아키텍처 하이라이트
- **통합 멀티모달리티**: 음성을 텍스트로 변환(STT)한 후 다시 TTS로 변환하는 기존 파이프라인과 달리, 음성의 톤, 억양, 배경음, 감정까지 직접 이해하고 즉각 반응합니다.
- **추론 지연 시간(Latency) 대폭 단축**: GPT-4 Turbo 대비 약 2배 빠른 생성 속도를 자랑하며, 실시간 대화형 인터랙션(평균 음성 응답 320ms)에 최적화되었습니다.
- **다국어 토크나이저 최적화**: 새로운 압축 토크나이저를 채택하여 한국어, 일본어 등 비라틴어 계열의 토큰 소모량을 20~30% 절감했습니다.', 
'{"category":"General Multimodal","recommendedTemperature":0.7}'),

(1, 'USAGE', 'GPT-4o 주요 특징 및 API 사용법',
'### API 연동 및 실무 활용 팁

OpenAI 공식 Python SDK(`openai>=1.0.0`) 또는 REST API 엔드포인트를 통해 즉시 호출할 수 있습니다.

```python
from openai import OpenAI

client = OpenAI(api_key="your-api-key")

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "당신은 Plane 프로젝트 매니지먼트 전문가입니다."},
        {"role": "user", "content": "SaaS 아키텍처 설계 시 주요 고려사항을 요약해줘."}
    ],
    temperature=0.7,
    max_tokens=2048,
    response_format={"type": "json_object"} # JSON 모드 지원
)
print(response.choices[0].message.content)
```

#### 추천 파라미터 가이드
- **일반 대화 및 창의적 작성**: `temperature: 0.7~0.8`, `top_p: 0.95`
- **정형 데이터 추출 및 함수 호출 (Tool Calling)**: `temperature: 0.0~0.2`
- **비전 분석**: 고해상도 이미지 전송 시 `detail: "high"` 파라미터 적용 권장',
'{"sdk":"Python, Node.js, cURL","json_mode":true,"function_calling":true}'),

(1, 'PROS_CONS', 'GPT-4o 장단점 및 고려사항',
'### 실무 관점의 핵심 장단점 분석

#### 장점 (Pros)
1. **압도적인 범용 완성도**: 대화, 번역, 텍스트 요약, 코드 보조 등 다방면에서 가장 안정적인 답변 일관성을 유지합니다.
2. **풍부한 서드파티 에코시스템**: LangChain, LlamaIndex, Cursor 등 현존하는 거의 모든 AI 도구가 GPT-4o를 기본 모델로 지원합니다.
3. **고속 Tool Calling(함수 호출)**: 구조화된 JSON Schema 출력 보장(`Strict Structured Outputs`) 기능이 가장 견고합니다.

#### 단점 및 한계점 (Cons)
1. **심층 추론(Math/Complex Logic)의 한계**: o1과 같은 전용 Chain-of-Thought 모델에 비해 다단계 논리 문제나 하드코딩된 경쟁 수학에서 환각(Hallucination)이 발생할 수 있습니다.
2. **200K 이상의 초장문 문서 제약**: Gemini 1.5 Pro(200만 토큰)에 비해 128K 컨텍스트는 대용량 동영상/장편 서적 전체 분석 시 제약이 있습니다.',
'{"rating":4.8,"maturity":"Production-Grade"}'),

(1, 'BENCHMARKS', 'GPT-4o 벤치마크 지표',
'### 공인 벤치마크 및 성능 지표

- **MMLU (대규모 다중작업 언어 이해)**: **88.7%** (대학 수준 전공 지식)
- **HumanEval (파이썬 코딩 능력)**: **90.2%** (함수 구현 정확도)
- **MATH (경시대회급 수학)**: **76.6%**
- **GPQA (박사급 과학 물리/생물/화학)**: **53.6%**
- **Vision MMMU (멀티모달 고난도 추론)**: **69.1%**

| 항목 | 수치 | 비고 |
| :--- | :--- | :--- |
| 입력 가격 (Input) | $2.50 / 1M tokens | 캐시 적중 시 $1.25 |
| 출력 가격 (Output) | $10.00 / 1M tokens | 생성 토큰 기준 |
| Context Window | 128,000 tokens | 약 300페이지 분량 |',
'{"mmlu":88.7,"humaneval":90.2,"math":76.6,"gpqa":53.6}'),

(1, 'LINKS', 'GPT-4o 공식 링크 및 리소스',
'### 공식 연결 링크 모음

- 🌐 [OpenAI 공식 모델 소개 페이지](https://openai.com/index/hello-gpt-4o/)
- 📖 [OpenAI API Reference & Docs](https://platform.openai.com/docs/models/gpt-4o)
- 🎮 [OpenAI Playground 체험하기](https://platform.openai.com/playground)
- 📊 [OpenAI Status & Latency 대시보드](https://status.openai.com/)
- 💡 [Prompt Engineering Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)',
'{"docs":"https://platform.openai.com/docs","playground":"https://platform.openai.com/playground"}');

-- Model 3: Claude 3.7 Sonnet
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(3, 'OVERVIEW', 'Claude 3.7 Sonnet 개요 및 하이브리드 아키텍처',
'### Claude 3.7 Sonnet: 최초의 하이브리드 사고(Hybrid Reasoning) 파운데이션 모델

Claude 3.7 Sonnet은 Anthropic이 발표한 혁신적인 프론티어 모델로, 표준 모드의 빠른 응답성과 깊은 사고(Extended Thinking) 모드를 단일 모델 내에서 유연하게 전환할 수 있는 세계 최초의 하이브리드 추론 아키텍처입니다.

#### 핵심 혁신 사항
- **조절 가능한 사고 예산 (Thinking Budget)**: 사용자가 요청의 난이도에 따라 생각하는 토큰 수(1,024 ~ 64,000 토큰)를 직접 설정할 수 있습니다.
- **소프트웨어 엔지니어링의 정점**: SWE-bench Verified 벤치마크에서 기존 모든 모델을 압도하며 70% 이상의 해결률을 최초로 달성했습니다.
- **컴퓨터 사용(Computer Use) 강화**: GUI 인터페이스를 시각적으로 인식하고 마우스 클릭 및 키보드 입력을 자동 수행하는 자율 에이전트 성능이 극대화되었습니다.',
'{"category":"Hybrid Reasoning","thinkingBudget":true}'),

(3, 'USAGE', 'Claude 3.7 Sonnet 사용법 및 Thinking API',
'### 확장 사고(Extended Thinking) 모드 API 호출 예제

```python
import anthropic

client = anthropic.Anthropic(api_key="your-anthropic-api-key")

response = client.messages.create(
    model="claude-3-7-sonnet-20250219",
    max_tokens=8192,
    thinking={
        "type": "enabled",
        "budget_tokens": 4096 # 사고에 할당할 최대 토큰
    },
    messages=[
        {"role": "user", "content": "Vue2 기반 대규모 레거시 코드를 Vue3 Composition API로 전환하는 단계별 마이그레이션 전략 및 리팩토링 스크립트를 작성해줘."}
    ]
)

# thinking 블록과 실제 텍스트 응답이 분리되어 반환됨
for block in response.content:
    if block.type == "thinking":
        print("🧠 [내부 추론 과정]:", block.thinking[:200], "...")
    elif block.type == "text":
        print("💡 [최종 답변]:", block.text)
```

#### 프롬프트 가이드
- 생각할 필요가 없는 단순 번역이나 빠른 질의응답 시에는 `thinking: {"type": "disabled"}`로 설정하여 초고속 응답을 유도합니다.',
'{"sdk":"Anthropic Python/TS","thinking_tokens":64000}'),

(3, 'PROS_CONS', 'Claude 3.7 Sonnet 장단점 분석',
'### 장점 및 단점

#### 장점 (Pros)
1. **현존 최강의 코딩 능력**: 복잡한 아키텍처 리팩토링, 버그 추적, 전체 파일 단위 수정에서 오류율이 가장 낮습니다.
2. **투명한 추론 과정 검증**: 에이전트가 어떤 가정을 세우고 코드를 검증했는지 Thinking 로그를 통해 개발자가 실시간 검수 가능합니다.
3. **프롬프트 순응성 및 정교한 톤 매너**: "설명 없이 코드만 출력해", "특정 파일 양식 준수" 등의 제약 조건을 가장 완벽하게 지킵니다.

#### 단점 및 고려사항 (Cons)
1. **Thinking 모드 시 토큰 비용 누적**: 내부 사고 토큰도 출력 토큰 요율($15/1M)로 과금되므로 복잡한 질문 시 토큰 소모량이 큽니다.
2. **생성 대기 시간**: 사고 예산을 높게 잡을 경우 첫 토큰이 출력되기까지 수십 초의 딜레이가 발생할 수 있습니다.',
'{"rating":4.9,"maturity":"Frontier State-of-the-art"}'),

(3, 'BENCHMARKS', 'Claude 3.7 Sonnet 벤치마크',
'### 벤치마크 결과 비교

- **SWE-bench Verified (실제 깃허브 버그 해결)**: **70.3%** (업계 1위)
- **GPQA Diamond (박사급 과학 지식)**: **65.3%**
- **MATH 500 (수학적 논리 추론)**: **96.2%**
- **HumanEval (코딩 기본)**: **92.0%**
- **AIME 2024 (미국 수학 올림피아드)**: **84.0%** (Thinking 활성화 기준)',
'{"swe_bench":70.3,"gpqa":65.3,"math_500":96.2,"humaneval":92.0}'),

(3, 'LINKS', 'Claude 3.7 Sonnet 공식 링크',
'### 공식 연결 링크

- 🌐 [Anthropic Claude 3.7 Announcement](https://www.anthropic.com/news/claude-3-7-sonnet)
- 📖 [Anthropic API Documentation](https://docs.anthropic.com/en/docs/about-claude/models)
- 💻 [Claude 콘솔 (Console Playground)](https://console.anthropic.com/)
- 🛠️ [Computer Use Reference Guide](https://docs.anthropic.com/en/docs/build-with-claude/computer-use)',
'{"website":"https://www.anthropic.com","console":"https://console.anthropic.com"}');

-- Model 5: Gemini 2.0 Flash
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(5, 'OVERVIEW', 'Gemini 2.0 Flash 개요 및 차세대 스펙',
'### Google Gemini 2.0 Flash: 차세대 초저지연 실시간 에이전틱 멀티모달

Gemini 2.0 Flash는 Google DeepMind가 구축한 차세대 파운데이션 모델로, "초고속 속도(Sub-second Latency)"와 "고도의 멀티모달 이해도", 그리고 "1백만 토큰 컨텍스트"를 극단적으로 저렴한 단가로 제공합니다.

#### 주요 특징
- **1,000,000 토큰 기본 지원**: 방대한 코드 리포지토리나 책 3~4권 분량의 문서를 단번에 분석합니다.
- **실시간 네이티브 멀티모달 스트리밍 (Multimodal Live API)**: 음성 및 실시간 비디오 입력을 동시 처리하여 양방향 음성 대화를 지원합니다.
- **내장 도구 통합(Built-in Google Search & Code Execution)**: 별도 파이프라인 없이 구글 검색 및 파이썬 코드 실행 샌드박스를 직접 호출합니다.',
'{"category":"High-speed Multimodal","context":"1M Tokens"}'),

(5, 'USAGE', 'Gemini 2.0 Flash API 연동 가이드',
'### Google GenAI SDK 사용법

```python
from google import genai
from google.genai import types

client = genai.Client(api_key="your-gemini-api-key")

response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="다음 SQL 쿼리의 인덱스 최적화 방안을 설명해줘.",
    config=types.GenerateContentConfig(
        temperature=0.3,
        system_instruction="당신은 MyBatis 및 고성능 데이터베이스 DBA입니다.",
        max_output_tokens=2048
    )
)
print(response.text)
```

#### 비용 효율성 극대화 팁
- 입력 1백만 토큰당 $0.10, 출력 $0.40 수준으로 경쟁 모델 대비 1/10 이하의 저렴한 비용으로 대규모 배치 작업 처리가 가능합니다.',
'{"pricing_advantage":"10x cheaper"}'),

(5, 'PROS_CONS', 'Gemini 2.0 Flash 장단점',
'### 장점 및 단점 비교

#### 장점 (Pros)
1. **독보적인 가성비와 속도**: 토큰 단가가 가장 저렴하면서도 토큰 생성 속도가 초당 120~150토큰에 육박합니다.
2. **대용량 컨텍스트 윈도우 (1M Tokens)**: 긴 대화 히스토리나 대용량 로그 분석 시 컨텍스트 유실이 전혀 없습니다.
3. **구글 검색 실시간 접지 (Search Grounding)**: 최신 웹 정보 반영이 가장 자연스럽고 신속합니다.

#### 단점 및 고려사항 (Cons)
1. **극고난도 코드 리팩토링 제약**: 대규모 분산 아키텍처 재설계나 박사급 수학 증명에서는 Claude 3.7이나 o1 대비 정밀도가 소폭 낮을 수 있습니다.',
'{"rating":4.7,"maturity":"High Throughput Production"}'),

(5, 'BENCHMARKS', 'Gemini 2.0 Flash 벤치마크 지표',
'### 주요 벤치마크 지표

- **MMLU Pro**: **77.8%**
- **MATH**: **89.9%**
- **HumanEval (Coding)**: **88.6%**
- **MMMU (Multimodal)**: **68.2%**
- **생성 속도 (Output Speed)**: **평균 135 tokens/sec**',
'{"mmlu_pro":77.8,"math":89.9,"humaneval":88.6}'),

(5, 'LINKS', 'Gemini 2.0 Flash 공식 링크',
'### 공식 연결 링크

- 🌐 [Google DeepMind Gemini 2.0 Announcement](https://blog.google/technology/google-deepmind/google-gemini-ai-update-december-2024/)
- 📖 [Google AI Studio API Docs](https://ai.google.dev/gemini-api/docs)
- 🎮 [Google AI Studio Playground](https://aistudio.google.com/)
- 📊 [Google Vertex AI Console](https://cloud.google.com/vertex-ai)',
'{"studio":"https://aistudio.google.com"}');

-- Model 8: DeepSeek-R1
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(8, 'OVERVIEW', 'DeepSeek-R1 개요 및 강화학습 혁신',
'### DeepSeek-R1: 오픈 가중치 순수 강화학습(Pure RL) 추론 모델

DeepSeek-R1은 지도학습 미세조정(SFT) 없이 대규모 강화학습(Large-Scale RL)만을 적용한 최초의 오픈소스 고난도 추론 모델입니다. 

#### 혁신적인 아키텍처 & 훈련 기법
- **DeepSeek-R1-Zero & R1**: 모델 스스로 사고 과정(Chain of Thought)을 길게 생성하며 자기 검증(Self-Correction)을 수행합니다. "Aha moment"를 자발적으로 발견하는 행동 패턴을 보입니다.
- **MoE (Mixture of Experts)**: 총 6710억 파라미터 중 토큰당 활성 파라미터는 370억(37B) 개에 불과하여 연산 효율이 극대화되었습니다.
- **MIT 오픈 라이선스**: 가중치 및 증류(Distilled) 모델을 상업적 제한 없이 무료로 내려받아 자체 인프라에 배포 가능합니다.',
'{"license":"MIT","architecture":"671B MoE (37B active)"}'),

(8, 'USAGE', 'DeepSeek-R1 사용법 및 로컬 배포(Ollama/vLLM)',
'### 로컬 및 API 연동 예제

#### 1) Ollama를 통한 로컬 인퍼런스
```bash
# 증류 모델 실행 (경량 8B 또는 14B)
ollama run deepseek-r1:14b

# 양자화 풀 모델 실행 (고성능 GPU 서버)
ollama run deepseek-r1:671b-q4_K_M
```

#### 2) 공식 API (OpenAI 호환 포맷)
```python
from openai import OpenAI

client = OpenAI(
    api_key="your-deepseek-api-key",
    base_url="https://api.deepseek.com"
)

response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=[{"role": "user", "content": "N개의 퀸을 서로 공격하지 않게 배치하는 효율적인 백트래킹 알고리즘을 파이썬으로 구현해줘."}]
)

# 사고 과정 태그(<think>...</think>) 포함 출력
print(response.choices[0].message.content)
```',
'{"local_runners":["Ollama","vLLM","LMStudio"]}'),

(8, 'PROS_CONS', 'DeepSeek-R1 장단점 분석',
'### 장점 및 단점

#### 장점 (Pros)
1. **OpenAI o1 급 추론 성능의 오픈소스화**: 수학 올림피아드 및 복잡한 코딩 알고리즘에서 o1과 대등한 점수를 기록합니다.
2. **극단적인 저비용 API**: 1백만 토큰당 $0.55 / $2.19로 o1($15/$60) 대비 1/25 이하의 가격입니다.
3. **자유로운 온프레미스 배포**: 보안이 중요한 사내 폐쇄망에서도 온프레미스 GPU 클러스터에 완전 격리 배포할 수 있습니다.

#### 단점 및 고려사항 (Cons)
1. **일반 언어 생성 스타일**: 사고 과정이 길어 단순 이메일 작성이나 가벼운 질의에는 과도하게 연산이 낭비될 수 있습니다.
2. **다국어 혼합 현상(Language Mixing)**: 한국어 질의에 대해 사고 과정 중 영어와 중국어가 섞여 나오는 경향이 있습니다.',
'{"rating":4.9,"license":"MIT"}'),

(8, 'BENCHMARKS', 'DeepSeek-R1 벤치마크 지표',
'### 공식 벤치마크 결과

- **AIME 2024 (미국 수학 올림피아드)**: **79.8%** (OpenAI o1-0912의 79.2% 능가)
- **MATH 500**: **97.3%**
- **Codeforces Percentile**: **96.3%** (상위 3.7% 엘리트 프로그래머 수준)
- **MMLU**: **90.8%**
- **SWE-bench Verified**: **49.2%**',
'{"aime_2024":79.8,"math_500":97.3,"codeforces":96.3,"mmlu":90.8}'),

(8, 'LINKS', 'DeepSeek-R1 공식 링크',
'### 공식 연결 링크

- 🌐 [DeepSeek 공식 홈페이지](https://www.deepseek.com/)
- 🐙 [GitHub: deepseek-ai/DeepSeek-R1](https://github.com/deepseek-ai/DeepSeek-R1)
- 🤗 [Hugging Face Model Card (deepseek-ai/DeepSeek-R1)](https://huggingface.co/deepseek-ai/DeepSeek-R1)
- 📄 [DeepSeek-R1 Technical Report (PDF)](https://arxiv.org/abs/2501.12948)',
'{"github":"https://github.com/deepseek-ai/DeepSeek-R1"}');

-- Model Metrics (for Radar / Comparison Charts in Plane UI)
INSERT INTO model_metrics (model_id, benchmark_name, score, percent_val, category) VALUES
-- GPT-4o
(1, 'MMLU (General)', '88.7%', 89, 'Knowledge'),
(1, 'HumanEval (Coding)', '90.2%', 90, 'Coding'),
(1, 'MATH (Logic)', '76.6%', 77, 'Math'),
(1, 'GPQA (Science)', '53.6%', 54, 'Science'),
(1, 'Speed & Latency', 'Fast (65 t/s)', 85, 'Speed'),

-- Claude 3.7 Sonnet
(3, 'MMLU (General)', '89.5%', 90, 'Knowledge'),
(3, 'SWE-bench (Software)', '70.3%', 98, 'Coding'),
(3, 'MATH 500 (Logic)', '96.2%', 96, 'Math'),
(3, 'GPQA Diamond', '65.3%', 75, 'Science'),
(3, 'Agentic Precision', '97.0%', 97, 'Agent'),

-- Gemini 2.0 Flash
(5, 'MMLU Pro', '77.8%', 78, 'Knowledge'),
(5, 'HumanEval (Coding)', '88.6%', 89, 'Coding'),
(5, 'MATH', '89.9%', 90, 'Math'),
(5, 'Output Speed', '135 t/s', 99, 'Speed'),
(5, 'Context Window', '1M tokens', 95, 'Context'),

-- DeepSeek-R1
(8, 'AIME 2024 (Olympiad)', '79.8%', 95, 'Math'),
(8, 'MATH 500', '97.3%', 97, 'Math'),
(8, 'Codeforces', 'Top 3.7%', 96, 'Coding'),
(8, 'MMLU (General)', '90.8%', 91, 'Knowledge'),
(8, 'Cost Efficiency', 'Ultra High', 98, 'Value');
