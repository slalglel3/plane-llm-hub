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
(2, 1, 'o1', 'OpenAI o1 (Reasoning)', 'OpenAI', '2024-12', '200K tokens', '100K tokens', '$15.00 / 1M', '$60.00 / 1M', 'Reasoning', 'Deliberate chain-of-thought model for complex mathematics, coding, and science.', 2),

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
    response_format={"type": "json_object"}
)
print(response.choices[0].message.content)
```',
'{"sdk":"Python, Node.js, cURL","json_mode":true}'),

(1, 'PROS_CONS', 'GPT-4o 장단점 및 고려사항',
'### 실무 관점의 핵심 장단점 분석

#### 장점 (Pros)
1. **압도적인 범용 완성도**: 대화, 번역, 텍스트 요약, 코드 보조 등 다방면에서 가장 안정적인 답변 일관성을 유지합니다.
2. **풍부한 서드파티 에코시스템**: LangChain, LlamaIndex, Cursor 등 현존하는 거의 모든 AI 도구가 GPT-4o를 기본 모델로 지원합니다.
3. **고속 Tool Calling**: 구조화된 JSON Schema 출력 보장(`Strict Structured Outputs`) 기능이 매우 견고합니다.

#### 단점 및 한계점 (Cons)
1. **심층 추론의 한계**: o1과 같은 전용 추론 모델에 비해 다단계 논리 문제나 경시대회 수학에서 환각이 발생할 수 있습니다.
2. **200K 이상의 초장문 제약**: Gemini 1.5 Pro(200만 토큰)에 비해 128K 컨텍스트는 대용량 동영상/장편 서적 전체 분석 시 제약이 있습니다.',
'{"rating":4.8}'),

(1, 'BENCHMARKS', 'GPT-4o 벤치마크 지표',
'### 공인 벤치마크 및 성능 지표

- **MMLU (대규모 다중작업 언어 이해)**: **88.7%**
- **HumanEval (파이썬 코딩 능력)**: **90.2%**
- **MATH (경시대회급 수학)**: **76.6%**
- **GPQA (박사급 과학 지식)**: **53.6%**
- **Vision MMMU (멀티모달 고난도 추론)**: **69.1%**',
'{"mmlu":88.7,"humaneval":90.2}'),

(1, 'LINKS', 'GPT-4o 공식 링크 및 리소스',
'### 공식 연결 링크 모음

- 🌐 [OpenAI 공식 모델 소개 페이지](https://openai.com/index/hello-gpt-4o/)
- 📖 [OpenAI API Reference & Docs](https://platform.openai.com/docs/models/gpt-4o)
- 🎮 [OpenAI Playground 체험하기](https://platform.openai.com/playground)
- 📊 [OpenAI Status & Latency 대시보드](https://status.openai.com/)',
'{"docs":"https://platform.openai.com/docs"}');

-- Model 2: OpenAI o1
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(2, 'OVERVIEW', 'OpenAI o1 개요 및 추론 아키텍처',
'### OpenAI o1: 대규모 강화학습 기반의 심층 추론(Deep Reasoning) 모델

OpenAI o1은 응답을 생성하기 전에 내부적으로 생각(Chain of Thought)을 수행하도록 훈련된 차세대 추론 특화 파운데이션 모델입니다. 복잡한 과학, 코딩, 수학 문제에서 인간 박사급 이상의 문제 해결력을 제공합니다.',
'{"category":"Pure Reasoning"}'),

(2, 'USAGE', 'OpenAI o1 사용법 및 파라미터 가이드',
'### o1 API 호출 예제 및 주의사항

```python
from openai import OpenAI

client = OpenAI()

response = client.chat.completions.create(
    model="o1",
    messages=[{"role": "user", "content": "양자 컴퓨팅에서 쇼어 알고리즘의 오류 정정 원리를 증명해줘."}],
    reasoning_effort="high" # low, medium, high 중 선택
)
print(response.choices[0].message.content)
```

> **주의**: o1 모델은 `temperature`, `top_p` 등의 샘플링 파라미터를 지원하지 않으며, 시스템 프롬프트는 `developer` 롤을 사용합니다.',
'{"effort_levels":["low","medium","high"]}'),

(2, 'PROS_CONS', 'OpenAI o1 장단점 분석',
'### 장점 및 단점

#### 장점 (Pros)
1. **극고난도 수학 및 과학 최고 성능**: AIME 2024 83.3%, GPQA Diamond 78.0%로 업계 최고 수준.
2. **다단계 알고리즘 논리 검증**: 반례를 스스로 탐색하고 수정하는 강력한 자기 수정(Self-Correction) 능력.

#### 단점 (Cons)
1. **높은 토큰 단가**: 입력 $15/1M, 출력 $60/1M로 일반 LLM 대비 5~15배 비쌈.
2. **추론 대기 시간**: 응답 전 생각 시간이 수초~수십초 소요되어 실시간 챗봇에는 부적합.',
'{"rating":4.9}'),

(2, 'BENCHMARKS', 'OpenAI o1 벤치마크 지표',
'### 공식 벤치마크 결과

- **GPQA Diamond (박사급 과학)**: **78.0%**
- **AIME 2024 (미국 수학 올림피아드)**: **83.3%**
- **MATH 500**: **96.4%**
- **Codeforces Percentile**: **89th Percentile**',
'{"gpqa":78.0,"math":96.4}'),

(2, 'LINKS', 'OpenAI o1 공식 링크',
'### 공식 연결 링크

- 🌐 [OpenAI o1 System Card & Research](https://openai.com/index/learning-to-reason-with-llms/)
- 📖 [OpenAI Reasoning Guide](https://platform.openai.com/docs/guides/reasoning)
- 🎮 [OpenAI Playground o1 Console](https://platform.openai.com/playground)',
'{"docs":"https://platform.openai.com/docs"}');

-- Model 3: Claude 3.7 Sonnet
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(3, 'OVERVIEW', 'Claude 3.7 Sonnet 개요 및 하이브리드 아키텍처',
'### Claude 3.7 Sonnet: 최초의 하이브리드 사고(Hybrid Reasoning) 파운데이션 모델

Claude 3.7 Sonnet은 표준 모드의 빠른 응답성과 깊은 사고(Extended Thinking) 모드를 단일 모델 내에서 유연하게 전환할 수 있는 세계 최초의 하이브리드 추론 아키텍처입니다.',
'{"category":"Hybrid Reasoning"}'),

(3, 'USAGE', 'Claude 3.7 Sonnet 사용법 및 Thinking API',
'### 확장 사고(Extended Thinking) 모드 API 호출 예제

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-3-7-sonnet-20250219",
    max_tokens=8192,
    thinking={
        "type": "enabled",
        "budget_tokens": 4096
    },
    messages=[{"role": "user", "content": "Vue2 프로젝트의 트리 내비게이션 아키텍처 리팩토링 방안을 작성해줘."}]
)
for block in response.content:
    if block.type == "text":
        print(block.text)
```',
'{"thinking":true}'),

(3, 'PROS_CONS', 'Claude 3.7 Sonnet 장단점 분석',
'### 장점 및 단점

#### 장점 (Pros)
1. **SWE-bench Verified 1위 (70.3%)**: 실전 코딩 및 소프트웨어 엔지니어링 문제 해결력 최강.
2. **사고 예산(Thinking Budget) 자유 조절**: 1K~64K 토큰까지 생각하는 양을 직접 통제 가능.
3. **컴퓨터 사용(Computer Use) 자동화**: 화면을 보고 직접 클릭/입력하는 자율 에이전트 능력.

#### 단점 (Cons)
1. **Thinking 토큰 비용**: 내부 생각 토큰도 출력 요율($15/1M)로 부과됨.',
'{"rating":4.95}'),

(3, 'BENCHMARKS', 'Claude 3.7 Sonnet 벤치마크',
'### 벤치마크 결과 비교

- **SWE-bench Verified (소프트웨어 버그 해결)**: **70.3%**
- **GPQA Diamond**: **65.3%**
- **MATH 500**: **96.2%**
- **AIME 2024**: **84.0%**',
'{"swe_bench":70.3}'),

(3, 'LINKS', 'Claude 3.7 Sonnet 공식 링크',
'### 공식 연결 링크

- 🌐 [Anthropic Claude 3.7 Announcement](https://www.anthropic.com/news/claude-3-7-sonnet)
- 📖 [Anthropic API Documentation](https://docs.anthropic.com/en/docs/about-claude/models)
- 💻 [Claude Console Playground](https://console.anthropic.com/)',
'{"website":"https://www.anthropic.com"}');

-- Model 4: Claude 3.5 Sonnet
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(4, 'OVERVIEW', 'Claude 3.5 Sonnet 개요 및 특징',
'### Claude 3.5 Sonnet: 업계 에이전틱 코딩의 기준점 모델

2024년 여름 출시 이후 전 세계 개발자들에게 가장 사랑받은 코딩 및 자연어 추론 모델입니다. 매우 정교한 인스트럭션 추종력과 자연스러운 한국어 문맥 이해도를 갖추고 있습니다.',
'{"category":"Coding & Nuance"}'),
(4, 'USAGE', 'Claude 3.5 Sonnet 사용법',
'```python
import anthropic
client = anthropic.Anthropic()
res = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    messages=[{"role": "user", "content": "RESTful API 설계를 점검해줘."}]
)
print(res.content[0].text)
```', '{"sdk":"Python"}'),
(4, 'PROS_CONS', 'Claude 3.5 Sonnet 장단점',
'#### 장점: 완벽한 지시 순응성, 뛰어난 코드 완성도, 200K 대용량 컨텍스트.\n#### 단점: 복잡한 올림피아드 수학에서는 o1/3.7 대비 다소 낮은 점수.', '{"rating":4.85}'),
(4, 'BENCHMARKS', 'Claude 3.5 Sonnet 벤치마크',
'- SWE-bench Verified: 57.2%\n- MMLU: 88.3%\n- HumanEval: 93.7%', '{"swe_bench":57.2}'),
(4, 'LINKS', 'Claude 3.5 Sonnet 링크',
'- 🌐 [Anthropic Models](https://docs.anthropic.com/en/docs/about-claude/models)\n- 💻 [Claude Console](https://console.anthropic.com/)', '{"docs":"anthropic"}');

-- Model 5: Gemini 2.0 Flash
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(5, 'OVERVIEW', 'Gemini 2.0 Flash 개요 및 차세대 스펙',
'### Google Gemini 2.0 Flash: 차세대 초저지연 실시간 에이전틱 멀티모달

Gemini 2.0 Flash는 "초고속 속도(Sub-second Latency)"와 "1백만 토큰 컨텍스트"를 극단적으로 저렴한 단가로 제공하는 Google DeepMind의 핵심 모델입니다.',
'{"category":"High-speed Multimodal"}'),
(5, 'USAGE', 'Gemini 2.0 Flash API 연동 가이드',
'```python
from google import genai
client = genai.Client()
res = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="데이터베이스 인덱스 최적화 방안을 요약해줘."
)
print(res.text)
```', '{"sdk":"google-genai"}'),
(5, 'PROS_CONS', 'Gemini 2.0 Flash 장단점',
'#### 장점: 1M 토큰 지원, 입력 $0.10/1M 초저비용, 초당 135+ 토큰 초고속 생성.\n#### 단점: 심층 수학 증명에서는 전용 추론 모델 대비 정밀도 차이 존재.', '{"rating":4.7}'),
(5, 'BENCHMARKS', 'Gemini 2.0 Flash 벤치마크',
'- MMLU Pro: 77.8%\n- MATH: 89.9%\n- HumanEval: 88.6%\n- Output Speed: 135 tokens/sec', '{"speed":135}'),
(5, 'LINKS', 'Gemini 2.0 Flash 링크',
'- 🌐 [Google AI Studio](https://aistudio.google.com/)\n- 📖 [Gemini API Docs](https://ai.google.dev/)', '{"studio":"aistudio"}');

-- Model 6: Gemini 1.5 Pro
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(6, 'OVERVIEW', 'Gemini 1.5 Pro 개요 및 2M 토큰 컨텍스트',
'### Gemini 1.5 Pro: 세계 최대 2,000,000(200만) 토큰 컨텍스트 윈도우

책 10권 분량, 1시간짜리 비디오 전체 또는 5만 줄 이상의 소스코드 리포지토리를 한 번의 프롬프트에 담아 분석할 수 있는 독보적인 롱 컨텍스트 모델입니다.', '{"context":"2M"}'),
(6, 'USAGE', 'Gemini 1.5 Pro 대용량 파일 분석 사용법',
'```python
import google.generativeai as genai
model = genai.GenerativeModel("gemini-1.5-pro")
res = model.generate_content(["전체 시스템 아키텍처 문서에서 인증 흐름도를 분석해줘.", doc_file])
print(res.text)
```', '{"file_api":true}'),
(6, 'PROS_CONS', 'Gemini 1.5 Pro 장단점',
'#### 장점: 2M 초거대 컨텍스트, 뛰어난 비디오/오디오 멀티모달 이해도.\n#### 단점: 2.0 Flash 대비 느린 속도 및 높은 토큰 단가.', '{"rating":4.75}'),
(6, 'BENCHMARKS', 'Gemini 1.5 Pro 벤치마크',
'- Needle In A Haystack (2M): 99.7% 검색 성공률\n- MMLU: 85.9%\n- MATH: 67.7%', '{"needle":99.7}'),
(6, 'LINKS', 'Gemini 1.5 Pro 링크',
'- 🌐 [Gemini 1.5 Pro Overview](https://deepmind.google/technologies/gemini/pro/)\n- 🎮 [AI Studio Playground](https://aistudio.google.com/)', '{"docs":"gemini"}');

-- Model 7: Llama 3.3 70B
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(7, 'OVERVIEW', 'Llama 3.3 70B Instruct 개요',
'### Meta Llama 3.3 70B: 오픈소스 파운데이션 모델의 새로운 기준

Meta가 공개한 플래그십 오픈 가중치 모델로, 이전 세대인 Llama 3.1 405B에 필적하는 추론 능력을 단 70B 파라미터 크기에 압축하여 단일 노드 H100/A100 서버에서 실시간 호스팅이 가능합니다.', '{"open_source":true}'),
(7, 'USAGE', 'Llama 3.3 70B vLLM / Ollama 로컬 실행',
'```bash
vllm serve meta-llama/Llama-3.3-70B-Instruct --tensor-parallel-size 4 --port 8000
ollama run llama3.3:70b
```', '{"self_hosted":true}'),
(7, 'PROS_CONS', 'Llama 3.3 70B 장단점',
'#### 장점: 완전 무료 오픈 가중치, 사내 폐쇄망 배포 가능, 상업적 이용 허용.\n#### 단점: 호스팅을 위한 최소 2~4장의 고성능 GPU 인프라 필요.', '{"rating":4.7}'),
(7, 'BENCHMARKS', 'Llama 3.3 70B 벤치마크',
'- MMLU: 86.0%\n- MATH 500: 70.1%\n- HumanEval: 81.7%', '{"mmlu":86.0}'),
(7, 'LINKS', 'Llama 3.3 70B 링크',
'- 🌐 [Meta Llama 공식 사이트](https://www.llama.com/)\n- 🤗 [Hugging Face Llama-3.3-70B-Instruct](https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct)', '{"huggingface":true}');

-- Model 8: DeepSeek-R1
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(8, 'OVERVIEW', 'DeepSeek-R1 개요 및 강화학습 혁신',
'### DeepSeek-R1: 오픈 가중치 순수 강화학습(Pure RL) 추론 모델

DeepSeek-R1은 지도학습 미세조정(SFT) 없이 대규모 강화학습(Large-Scale RL)만을 적용한 최초의 오픈소스 고난도 추론 모델입니다. 671B MoE 구조로 토큰당 37B만 활성화됩니다.', '{"license":"MIT"}'),
(8, 'USAGE', 'DeepSeek-R1 로컬 실행 및 API',
'```bash
ollama run deepseek-r1:14b
```
```python
from openai import OpenAI
client = OpenAI(api_key="your-key", base_url="https://api.deepseek.com")
res = client.chat.completions.create(model="deepseek-reasoner", messages=[{"role": "user", "content": "알고리즘 문제 풀이"}])
print(res.choices[0].message.content)
```', '{"api_base":"api.deepseek.com"}'),
(8, 'PROS_CONS', 'DeepSeek-R1 장단점',
'#### 장점: MIT 완전 무료 오픈 라이선스, o1과 대등한 AIME 79.8% 수학 성능, 초저비용 API.\n#### 단점: 긴 생각 시간으로 단순 대화 질의 시 비효율적, 언어 혼합 현상 가끔 발생.', '{"rating":4.9}'),
(8, 'BENCHMARKS', 'DeepSeek-R1 벤치마크',
'- AIME 2024: 79.8%\n- MATH 500: 97.3%\n- Codeforces: 상위 3.7%\n- MMLU: 90.8%', '{"aime":79.8}'),
(8, 'LINKS', 'DeepSeek-R1 링크',
'- 🌐 [DeepSeek 공식 사이트](https://www.deepseek.com/)\n- 🐙 [GitHub deepseek-ai/DeepSeek-R1](https://github.com/deepseek-ai/DeepSeek-R1)', '{"github":true}');

-- Model 9: DeepSeek-V3
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(9, 'OVERVIEW', 'DeepSeek-V3 개요 및 671B MoE 아키텍처',
'### DeepSeek-V3: 현존 최강의 6710억 파라미터 MoE 오픈 가중치 모델

토큰당 370억 파라미터만 활성화하는 고효율 Multi-Head Latent Attention(MLA) 구조를 통해 세계 최고 수준의 추론 성능을 상용 폐쇄형 모델의 1/10 이하 비용으로 제공합니다.', '{"moe":true}'),
(9, 'USAGE', 'DeepSeek-V3 API 사용법',
'```python
from openai import OpenAI
client = OpenAI(api_key="your-key", base_url="https://api.deepseek.com")
res = client.chat.completions.create(model="deepseek-chat", messages=[{"role": "user", "content": "Vue2 컴포넌트 라이프사이클을 설명해줘."}])
print(res.choices[0].message.content)
```', '{"openai_compatible":true}'),
(9, 'PROS_CONS', 'DeepSeek-V3 장단점',
'#### 장점: 입력 1M당 $0.14의 혁신적 단가, Llama 3.1 405B 능가하는 성능.\n#### 단점: 완전 호스팅 시 최소 8xH100 노드 필요.', '{"rating":4.8}'),
(9, 'BENCHMARKS', 'DeepSeek-V3 벤치마크',
'- MMLU: 88.5%\n- HumanEval: 82.6%\n- MATH: 89.3%', '{"mmlu":88.5}'),
(9, 'LINKS', 'DeepSeek-V3 링크',
'- 🐙 [GitHub: deepseek-ai/DeepSeek-V3](https://github.com/deepseek-ai/DeepSeek-V3)\n- 🤗 [Hugging Face Model Card](https://huggingface.co/deepseek-ai/DeepSeek-V3)', '{"github":true}');

-- Model 10: Qwen 2.5 Coder 32B
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
(10, 'OVERVIEW', 'Qwen 2.5 Coder 32B Instruct 개요',
'### Qwen 2.5 Coder 32B: 오픈소스 코딩 특화 모델의 최정상

Alibaba Cloud가 5조 5천억 개 이상의 방대한 소스코드 토큰으로 훈련한 코딩 전문 모델로, 단 32B의 크기로 GPT-4o 및 Claude 3.5 Sonnet과 대등한 코드 작성 및 디버깅 성능을 보여줍니다.', '{"coding_specialist":true}'),
(10, 'USAGE', 'Qwen 2.5 Coder 로컬 실행 (Ollama)',
'```bash
ollama run qwen2.5-coder:32b
```', '{"ollama":true}'),
(10, 'PROS_CONS', 'Qwen 2.5 Coder 장단점',
'#### 장점: Apache 2.0 라이선스, 개인 PC/서버(RTX 3090/4090 1장)에서 단독 실행 가능, 128K 컨텍스트.\n#### 단점: 일반 상식이나 철학/문학 대화는 범용 모델 대비 다소 전문성 치우침.', '{"rating":4.85}'),
(10, 'BENCHMARKS', 'Qwen 2.5 Coder 벤치마크',
'- EvalPlus HumanEval: 92.7%\n- MultiPL-E (다국어 코딩): 80.5%\n- LiveCodeBench: 39.5%', '{"humaneval":92.7}'),
(10, 'LINKS', 'Qwen 2.5 Coder 링크',
'- 🐙 [GitHub: QwenLM/Qwen2.5-Coder](https://github.com/QwenLM/Qwen2.5-Coder)\n- 🤗 [Hugging Face Qwen 2.5 Coder](https://huggingface.co/Qwen/Qwen2.5-Coder-32B-Instruct)', '{"apache2":true}');

-- Metrics
INSERT INTO model_metrics (model_id, benchmark_name, score, percent_val, category) VALUES
(1, 'MMLU (General)', '88.7%', 89, 'Knowledge'),
(1, 'HumanEval (Coding)', '90.2%', 90, 'Coding'),
(1, 'MATH (Logic)', '76.6%', 77, 'Math'),
(1, 'GPQA (Science)', '53.6%', 54, 'Science'),
(1, 'Speed & Latency', 'Fast (65 t/s)', 85, 'Speed'),
(2, 'GPQA Diamond', '78.0%', 88, 'Science'),
(2, 'AIME 2024', '83.3%', 96, 'Math'),
(2, 'MATH 500', '96.4%', 96, 'Math'),
(3, 'MMLU (General)', '89.5%', 90, 'Knowledge'),
(3, 'SWE-bench (Software)', '70.3%', 98, 'Coding'),
(3, 'MATH 500 (Logic)', '96.2%', 96, 'Math'),
(3, 'GPQA Diamond', '65.3%', 75, 'Science'),
(3, 'Agentic Precision', '97.0%', 97, 'Agent'),
(5, 'MMLU Pro', '77.8%', 78, 'Knowledge'),
(5, 'HumanEval (Coding)', '88.6%', 89, 'Coding'),
(5, 'MATH', '89.9%', 90, 'Math'),
(5, 'Output Speed', '135 t/s', 99, 'Speed'),
(5, 'Context Window', '1M tokens', 95, 'Context'),
(8, 'AIME 2024 (Olympiad)', '79.8%', 95, 'Math'),
(8, 'MATH 500', '97.3%', 97, 'Math'),
(8, 'Codeforces', 'Top 3.7%', 96, 'Coding'),
(8, 'MMLU (General)', '90.8%', 91, 'Knowledge'),
(8, 'Cost Efficiency', 'Ultra High', 98, 'Value');
