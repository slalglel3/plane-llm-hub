-- ========================================================
-- 1. CATEGORIES (c, i, f, o)
-- ========================================================
-- [c] LLM Foundation Models
INSERT INTO categories (id, module_type, slug, name, icon, tagline, display_order) VALUES
(1, 'c', 'openai', 'OpenAI', '⚡', 'Pioneering frontier intelligence & reasoning models', 1),
(2, 'c', 'anthropic', 'Anthropic Claude', '🧠', 'Constitutional AI, state-of-the-art coding & agentic reasoning', 2),
(3, 'c', 'google', 'Google DeepMind Gemini', '✨', 'Massive context windows & native omni-modal processing', 3),
(4, 'c', 'meta', 'Meta Llama (Open Source)', '🦙', 'Leading open-weights foundational models for enterprise self-hosting', 4),
(5, 'c', 'deepseek', 'DeepSeek', '🐋', 'Disruptive high-efficiency MoE & pure RL reasoning models', 5),
(6, 'c', 'specialized', 'Specialized & Open Weights', '🚀', 'Fine-tuned code generation & multilingual powerhouses', 6);

-- [i] Famous Internet Web Sites
INSERT INTO categories (id, module_type, slug, name, icon, tagline, display_order) VALUES
(101, 'i', 'i-search', '포털 & 검색 엔진', '🔍', '전 세계 및 국내 사용자를 위한 핵심 관문 검색 포털', 1),
(102, 'i', 'i-ecommerce', '글로벌 전자상거래', '🛒', '초고속 물류와 온라인 쇼핑 생태계를 선도하는 커머스', 2),
(103, 'i', 'i-cloud', '클라우드 & 개발 플랫폼', '☁️', '소프트웨어 개발과 인프라 호스팅을 책임지는 엔지니어링 허브', 3),
(104, 'i', 'i-media', '동영상 & 스트리밍 미디어', '🎬', '엔터테인먼트, 음악, 라이브 스트리밍을 제공하는 글로벌 미디어', 4),
(105, 'i', 'i-knowledge', '지식 백과 & 테크 포럼', '📚', '집단 지성과 최신 기술 뉴스를 공유하는 글로벌 지식 저장소', 5);

-- [f] Famous AI Tools & Platforms
INSERT INTO categories (id, module_type, slug, name, icon, tagline, display_order) VALUES
(201, 'f', 'f-coding', 'AI 코딩 & 개발 IDE', '💻', '소프트웨어 엔지니어링 생산성을 극대화하는 자율 코딩 툴', 1),
(202, 'f', 'f-image', 'AI 이미지 & 그래픽 생성', '🎨', '텍스트 프롬프트를 시각 예술과 디자인 자산으로 바꾸는 생성 툴', 2),
(203, 'f', 'f-video', 'AI 비디오 & 오디오 제작', '🎥', '상상 속 시나리오를 고화질 영상과 음악으로 구현하는 멀티미디어 AI', 3),
(204, 'f', 'f-search', 'AI 리서치 & 지능형 검색', '🔎', '신뢰할 수 있는 출처와 문서 기반 심층 분석을 제공하는 리서치 AI', 4),
(205, 'f', 'f-productivity', 'AI 워크스페이스 & 생산성', '⚡', '슬라이드, 문서, 업무 자동화를 지원하는 차세대 오피스 AI', 5);

-- [o] Famous SNS & Social Networks
INSERT INTO categories (id, module_type, slug, name, icon, tagline, display_order) VALUES
(301, 'o', 'o-micro', '텍스트 & 마이크로블로그', '💬', '글로벌 실시간 이슈와 생각을 빠르게 공유하는 단문형 SNS', 1),
(302, 'o', 'o-visual', '비주얼 & 숏폼 미디어', '📸', '사진, 릴스, 숏폼 비디오 중심의 시각 트렌드 리딩 플랫폼', 2),
(303, 'o', 'o-chat', '메신저 & 실시간 커뮤니티', '📱', '개인 메시징부터 대규모 서버 커뮤니티까지 포괄하는 소통 허브', 3),
(304, 'o', 'o-biz', '비즈니스 & 프로페셔널', '💼', '커리어 성장과 직장인 네트워킹을 지원하는 전문 플랫폼', 4),
(305, 'o', 'o-community', '취향 커뮤니티 & 토론 포럼', '🌐', '다양한 주제별 서브레딧과 게시판을 통한 정보 교류의 장', 5);

-- ========================================================
-- 2. MODELS & ITEMS (각 대메뉴별 4~5개씩 구성)
-- ========================================================
-- [c] LLM Models (OpenAI 5개, Anthropic 4개, Google 4개, Meta 4개, DeepSeek 4개, Specialized 4개)
INSERT INTO llm_models (id, category_id, model_key, name, provider, release_date, context_window, max_output, pricing_input, pricing_output, badge, tagline, display_order) VALUES
-- OpenAI (5 models)
(1, 1, 'gpt-4o', 'GPT-4o (Omni)', 'OpenAI', '2024-05', '128K', '16K', '$2.50 / 1M', '$10.00 / 1M', 'Omni', '플래그십 옴니모달 모델', 1),
(2, 1, 'gpt-4o-mini', 'GPT-4o mini', 'OpenAI', '2024-07', '128K', '16K', '$0.15 / 1M', '$0.60 / 1M', 'Light', '초경량 고속 지능 모델', 2),
(3, 1, 'o1', 'OpenAI o1', 'OpenAI', '2024-12', '200K', '100K', '$15.00 / 1M', '$60.00 / 1M', 'Reasoning', '단계별 심층 추론 모델', 3),
(4, 1, 'o3-mini', 'OpenAI o3-mini', 'OpenAI', '2025-01', '200K', '100K', '$1.10 / 1M', '$4.40 / 1M', 'Fast CoT', '고효율 수학/코딩 추론', 4),
(5, 1, 'gpt-4-turbo', 'GPT-4 Turbo', 'OpenAI', '2024-04', '128K', '4K', '$10.00 / 1M', '$30.00 / 1M', 'Enterprise', '안정화된 엔터프라이즈 기준', 5),

-- Anthropic (4 models)
(6, 2, 'claude-3-7-sonnet', 'Claude 3.7 Sonnet', 'Anthropic', '2025-02', '200K', '64K', '$3.00 / 1M', '$15.00 / 1M', 'Hybrid', '세계 최초 하이브리드 추론', 1),
(7, 2, 'claude-3-5-sonnet', 'Claude 3.5 Sonnet', 'Anthropic', '2024-10', '200K', '8K', '$3.00 / 1M', '$15.00 / 1M', 'Coding Gold', '에이전틱 코딩 표준 모델', 2),
(8, 2, 'claude-3-5-haiku', 'Claude 3.5 Haiku', 'Anthropic', '2024-11', '200K', '8K', '$0.80 / 1M', '$4.00 / 1M', 'Fastest', '초저지연 경량 프론티어', 3),
(9, 2, 'claude-3-opus', 'Claude 3 Opus', 'Anthropic', '2024-03', '200K', '4K', '$15.00 / 1M', '$75.00 / 1M', 'Deep Research', '심층 인문학/학술 분석', 4),

-- Google (4 models)
(10, 3, 'gemini-2-0-flash', 'Gemini 2.0 Flash', 'Google DeepMind', '2024-12', '1M', '8K', '$0.10 / 1M', '$0.40 / 1M', 'Realtime', '차세대 실시간 멀티모달', 1),
(11, 3, 'gemini-1-5-pro', 'Gemini 1.5 Pro', 'Google DeepMind', '2024-04', '2M', '8K', '$1.25 / 1M', '$5.00 / 1M', '2M Context', '200만 토큰 대용량 분석', 2),
(12, 3, 'gemini-1-5-flash', 'Gemini 1.5 Flash', 'Google DeepMind', '2024-05', '1M', '8K', '$0.075 / 1M', '$0.30 / 1M', 'Ultra Speed', '대규모 배치 고속 처리', 3),
(13, 3, 'gemini-2-0-thinking', 'Gemini 2.0 Thinking', 'Google DeepMind', '2024-12', '1M', '8K', 'Experimental', 'Free Tier', 'Experimental', '자율 생각 시각화 모델', 4),

-- Meta (4 models)
(14, 4, 'llama-3-3-70b', 'Llama 3.3 70B', 'Meta AI', '2024-12', '128K', '4K', 'Open Weights', 'Self-host', 'Open Weights', '최고 성능 70B 오픈 가중치', 1),
(15, 4, 'llama-3-1-405b', 'Llama 3.1 405B', 'Meta AI', '2024-07', '128K', '4K', 'Open Weights', 'Cluster Host', '405B Giant', '세계 최대 4050억 오픈 모델', 2),
(16, 4, 'llama-3-1-8b', 'Llama 3.1 8B', 'Meta AI', '2024-07', '128K', '4K', 'Open Weights', 'Edge / Local', 'Edge AI', '단일 GPU/엣지 구동 모델', 3),
(17, 4, 'llama-3-2-11b', 'Llama 3.2 11B Vision', 'Meta AI', '2024-09', '128K', '4K', 'Open Weights', 'Vision AI', 'Multimodal', '오픈소스 멀티모달 비전', 4),

-- DeepSeek (4 models)
(18, 5, 'deepseek-r1', 'DeepSeek-R1', 'DeepSeek', '2025-01', '128K', '32K', '$0.55 / 1M', '$2.19 / 1M', 'Pure RL', 'MIT 라이선스 오픈 추론', 1),
(19, 5, 'deepseek-v3', 'DeepSeek-V3', 'DeepSeek', '2024-12', '128K', '8K', '$0.14 / 1M', '$0.28 / 1M', '671B MoE', '초저비용 고효율 MoE', 2),
(20, 5, 'deepseek-coder-v2', 'DeepSeek Coder V2', 'DeepSeek', '2024-06', '128K', '8K', '$0.14 / 1M', '$0.28 / 1M', 'Code MoE', '338개 언어 지원 코딩', 3),
(21, 5, 'deepseek-r1-distill', 'DeepSeek-R1 Distill 32B', 'DeepSeek', '2025-01', '128K', '8K', 'Open Weights', 'Apache 2.0', 'Distilled', 'Qwen 기반 경량 추론', 4),

-- Specialized (4 models)
(22, 6, 'qwen-2-5-coder-32b', 'Qwen 2.5 Coder 32B', 'Alibaba Cloud', '2024-11', '128K', '8K', 'Open Weights', 'Apache 2.0', 'Code Leader', '오픈소스 1위 코딩 특화', 1),
(23, 6, 'mistral-large-2', 'Mistral Large 2', 'Mistral AI', '2024-07', '128K', '8K', '$2.00 / 1M', '$6.00 / 1M', 'European', '유럽 엔터프라이즈 대표', 2),
(24, 6, 'codestral-22b', 'Codestral 22B', 'Mistral AI', '2024-05', '32K', '4K', '$0.20 / 1M', '$0.60 / 1M', 'Fast Code', '80개 프로그래밍 언어', 3),
(25, 6, 'command-r-plus', 'Command R+', 'Cohere', '2024-04', '128K', '4K', '$2.50 / 1M', '$10.00 / 1M', 'Enterprise RAG', '사내 검색/RAG 특화 모델', 4);

-- [i] Famous Internet Web Sites (각 대메뉴별 4개씩)
INSERT INTO llm_models (id, category_id, model_key, name, provider, release_date, context_window, max_output, pricing_input, pricing_output, badge, tagline, display_order) VALUES
-- i-search (4 sites)
(101, 101, 'site-google', 'Google (구글)', 'Alphabet', '1998-09', 'Global #1', 'Search & Web', 'Free / Ads', 'Search API', 'Global #1', '글로벌 점유율 90% 이상의 검색 엔진', 1),
(102, 101, 'site-naver', 'Naver (네이버)', 'NAVER Corp', '1999-06', 'Korea #1', 'Portal & Pay', 'Free / Ads', 'Clova Cloud', 'Korea #1', '대한민국 1위 통합 포털 및 쇼핑 허브', 2),
(103, 101, 'site-daum', 'Daum (다음)', 'Kakao', '1995-02', 'Portal', 'News & Cafe', 'Free / Ads', 'Kakao Cloud', 'Portal', '카페, 뉴스, 미디어 콘텐츠 중심의 포털', 3),
(104, 101, 'site-bing', 'Microsoft Bing', 'Microsoft', '2009-06', 'AI Search', 'Copilot Web', 'Free / Ads', 'Azure Search', 'Copilot', 'OpenAI 기술이 결합된 검색 및 요약', 4),

-- i-ecommerce (4 sites)
(105, 102, 'site-amazon', 'Amazon (아마존)', 'Amazon.com', '1994-07', 'Worldwide', 'E-Commerce', 'Prime Sub', 'Marketplace', 'Global Mega', '세계 최대 전자상거래 및 물류 인프라', 1),
(106, 102, 'site-coupang', 'Coupang (쿠팡)', 'Coupang Inc', '2010-08', 'Rocket Delivery', 'E-Commerce', 'Wow Sub', 'Fast Pay', 'Rocket Delivery', '새벽 배송과 로켓와우 생태계 혁신', 2),
(107, 102, 'site-aliexpress', 'AliExpress (알리)', 'Alibaba', '2010-04', 'Cross-border', 'Direct Buy', 'Low-Price', 'Choice Service', 'Direct Buy', '글로벌 초저가 직구 플랫폼', 3),
(108, 102, 'site-smartstore', 'Naver Shopping', 'NAVER Corp', '2014-06', 'Commerce', 'Pay Integration', 'Low Fee', 'Smart Store', 'Naver Pay', '소상공인 연계 네이버 쇼핑 생태계', 4),

-- i-cloud (4 sites)
(109, 103, 'site-github', 'GitHub (깃허브)', 'Microsoft', '2008-02', 'Git Host', 'Dev Platform', 'Free / Enterprise', 'Copilot Cloud', 'Dev Essential', '1억 명 이상의 개발자가 협업하는 코드 허브', 1),
(110, 103, 'site-aws', 'AWS Console', 'Amazon', '2006-03', 'Public Cloud', 'Infra Services', 'Pay-as-you-go', 'Enterprise SLA', 'Cloud #1', '세계 1위 클라우드 컴퓨팅 플랫폼', 2),
(111, 103, 'site-stackoverflow', 'Stack Overflow', 'Prosus', '2008-09', 'Q&A Hub', 'Developer KB', 'Free / Team', 'Overflow API', 'Community', '전 세계 개발자들의 집단지성 질의응답', 3),
(112, 103, 'site-cloudflare', 'Cloudflare (클라우드플레어)', 'Cloudflare Inc', '2010-09', 'Global CDN', 'DDoS Protection', 'Free / Enterprise', 'Workers Edge', 'Security', '인터넷의 20%를 보호하는 CDN/보안망', 4),

-- i-media (4 sites)
(113, 104, 'site-youtube', 'YouTube (유튜브)', 'Google', '2005-02', 'Video Hub', 'Shorts & Live', 'Free / Premium', 'YouTube API', 'Video #1', '월간 25억 명이 시청하는 동영상 플랫폼', 1),
(114, 104, 'site-netflix', 'Netflix (넷플릭스)', 'Netflix Inc', '1997-08', 'OTT Leader', 'Original Content', 'Subscription', '4K HDR', 'OTT #1', '글로벌 오리지널 콘텐츠 스트리밍', 2),
(115, 104, 'site-chzzk', 'Chzzk (치지직)', 'NAVER Corp', '2023-12', 'Streaming', 'FHD 60FPS', 'Free / Bits', 'Naver Pay', 'Live Korea', '네이버의 고화질 인터랙티브 방송 플랫폼', 3),
(116, 104, 'site-spotify', 'Spotify (스포티파이)', 'Spotify AB', '2008-10', 'Music Stream', 'Personal AI', 'Free / Premium', 'Web API', 'Music #1', '개인화 알고리즘 기반 글로벌 음악 스트리밍', 4),

-- i-knowledge (4 sites)
(117, 105, 'site-wikipedia', 'Wikipedia (위키백과)', 'Wikimedia', '2001-01', 'Open Wiki', 'Multilingual', 'Free / Donation', 'MediaWiki API', 'Non-profit', '인류 지식을 집대성한 다국어 오픈 백과', 1),
(118, 105, 'site-namuwiki', 'Namu Wiki (나무위키)', 'Umanle S.R.L.', '2015-04', 'Wiki Korea', 'Pop Culture', 'Free / Ads', 'Open Engine', 'Pop Culture', '한국어 최대 규모의 대중문화 위키', 2),
(119, 105, 'site-reddit', 'Reddit (레딧)', 'Reddit Inc', '2005-06', 'Subreddit', 'Discussion Forum', 'Free / Gold', 'Data API', 'Discussion', '인터넷의 모든 주제가 모이는 포럼', 3),
(120, 105, 'site-hackernews', 'Hacker News (해커뉴스)', 'Y Combinator', '2007-02', 'Tech News', 'Minimal Text', 'Free / Open', 'Firebase API', 'Tech Elite', '실리콘밸리 스타트업/테크 엘리트 토론장', 4);

-- [f] Famous AI Tools & Platforms (각 대메뉴별 4개씩)
INSERT INTO llm_models (id, category_id, model_key, name, provider, release_date, context_window, max_output, pricing_input, pricing_output, badge, tagline, display_order) VALUES
-- f-coding (4 tools)
(201, 201, 'tool-cursor', 'Cursor (커서)', 'Anysphere', '2023-03', 'VS Code Fork', 'Agent Mode', '$20 / mo (Pro)', 'Multi-Model', 'AI IDE #1', '코드베이스 전체를 파악하는 차세대 AI IDE', 1),
(202, 201, 'tool-copilot', 'GitHub Copilot', 'GitHub / OpenAI', '2021-10', 'Extension', 'Autocomplete', '$10 / mo', 'Enterprise', 'Standard', '전 세계 가장 널리 쓰이는 AI 페어 프로그래머', 2),
(203, 201, 'tool-v0', 'v0.dev', 'Vercel', '2023-10', 'React/Next.js', 'UI Generator', 'Free / $20 mo', 'Tailwind CSS', 'UI Fast', '프롬프트 한 줄로 즉시 생성되는 완성형 UI', 3),
(204, 201, 'tool-lovable', 'Lovable.dev', 'Lovable AI', '2024-10', 'Full Stack', 'Web Builder', 'Free / Pro', 'Supabase Sync', 'Fullstack AI', '자연어로 풀스택 웹앱을 완성하는 소프트웨어 빌더', 4),

-- f-image (4 tools)
(205, 202, 'tool-midjourney', 'Midjourney v6', 'Midjourney Inc', '2022-07', 'Discord / Web', 'Image Gen', '$10~$60 / mo', 'GPU Fast', 'Art Master', '극사실적 질감과 예술적 완성도의 시각 아트', 1),
(206, 202, 'tool-flux', 'Flux.1 (플럭스)', 'Black Forest Labs', '2024-08', 'Open Weights', 'Text-to-Image', 'Open / API', 'ComfyUI Local', 'Open Image', '안정적인 텍스트 렌더링을 지원하는 오픈 모델', 2),
(207, 202, 'tool-dalle3', 'DALL-E 3', 'OpenAI', '2023-10', 'ChatGPT Sync', 'Nuanced Prompt', 'ChatGPT Plus', 'API Per Image', 'ChatGPT AI', '프롬프트 문맥을 가장 정밀하게 따르는 이미지 생성', 3),
(208, 202, 'tool-recraft', 'Recraft AI', 'Recraft Inc', '2023-11', 'Vector & SVG', 'Design Assets', 'Free / Sub', 'Commercial SVG', 'Vector Expert', '로고, 아이콘, 벡터 SVG 생성 특화 디자인 툴', 4),

-- f-video (4 tools)
(209, 203, 'tool-runway', 'Runway Gen-3 Alpha', 'Runway AI', '2024-06', 'Video Gen', 'Cinematic FX', '$12~$76 / mo', 'Motion Brush', 'Cinema AI', '헐리우드급 영상 효과 및 물리 엔진 시뮬레이션', 1),
(210, 203, 'tool-kling', 'Kling AI (클링)', 'Kuaishou', '2024-06', 'High Def', '1080p Video', 'Credit Based', 'Realistic Mo', 'HD Video', '2분 길이의 초현실적 비디오 생성 엔진', 2),
(211, 203, 'tool-suno', 'Suno AI v4', 'Suno Inc', '2023-12', 'Music Audio', 'Full Songs', 'Free / Pro', 'Vocal & Beats', 'Music Master', '가사와 보컬, 악기 편곡까지 한 번에 작곡', 3),
(212, 203, 'tool-elevenlabs', 'ElevenLabs', 'ElevenLabs Inc', '2023-01', 'Voice Cloning', 'Text-to-Speech', 'Free / $5 mo', 'Multilingual', 'Voice AI #1', '숨소리와 감정까지 재현하는 실시간 음성 복제', 4),

-- f-search (4 tools)
(213, 204, 'tool-perplexity', 'Perplexity AI', 'Perplexity Inc', '2022-12', 'Search Engine', 'Pro Search', 'Free / $20 mo', 'Multi-Source', 'AI Search #1', '신뢰도 높은 출처 링크와 요약을 실시간 제공', 1),
(214, 204, 'tool-genspark', 'Genspark', 'MainFunc', '2024-05', 'Sparkpages', 'Multi-Agent', 'Free Tier', 'Cross-Check', 'Agent Search', '전문 에이전트들이 교차 검증하는 리서치 페이지', 2),
(215, 204, 'tool-notebooklm', 'NotebookLM', 'Google', '2023-07', 'Document QA', 'Audio Overview', 'Free (Google)', 'Gemini 1.5 Pro', 'Deep Study', '내 문서를 분석해 2명의 AI 진행자가 팟캐스트 진행', 3),
(216, 204, 'tool-consensus', 'Consensus AI', 'Consensus', '2022-09', 'Science Papers', 'Evidence Meta', 'Free / Pro', '200M Papers', 'Research AI', '2억 건의 학술 논문을 검토하여 근거 중심 답변', 4),

-- f-productivity (4 tools)
(217, 205, 'tool-notion-ai', 'Notion AI', 'Notion Labs', '2023-02', 'Workspace', 'Doc Summarizer', '$10 / mo add-on', 'Q&A Database', 'Knowledge', '사내 위키 및 프로젝트 문서를 즉각 브레인스토밍', 1),
(218, 205, 'tool-gamma', 'Gamma App', 'Gamma Tech', '2023-03', 'Presentation', 'Web Doc', 'Free / Plus', 'One-Click Deck', 'Deck Master', '간단한 개요만으로 감각적인 프레젠테이션 완성', 2),
(219, 205, 'tool-canva-ai', 'Canva Magic Studio', 'Canva Pty', '2023-10', 'Graphic Design', 'Magic Erase', 'Free / Pro', 'Multi-Format', 'Design Suite', '원클릭 배경 제거 및 디자인 템플릿 마법봉', 3),
(220, 205, 'tool-artifacts', 'Claude Artifacts', 'Anthropic', '2024-06', 'Live Code Preview', 'Interactive App', 'Included in Claude', 'SVG / React / HTML', 'Live App', '대화창 옆에서 즉시 렌더링되는 실시간 인터랙티브 앱', 4);

-- [o] Famous SNS & Social Networks (각 대메뉴별 4개씩)
INSERT INTO llm_models (id, category_id, model_key, name, provider, release_date, context_window, max_output, pricing_input, pricing_output, badge, tagline, display_order) VALUES
-- o-micro (4 platforms)
(301, 301, 'sns-x', 'X (구 트위터)', 'X Corp', '2006-03', 'Microblog', '280 Chars (Long)', 'Free / Premium', 'Realtime Stream', 'News & Trend', '전 세계 실시간 브레이킹 뉴스와 담론의 중심', 1),
(302, 301, 'sns-threads', 'Threads (스레드)', 'Meta Platforms', '2023-07', 'Text & Photos', '500 Chars', 'Free', 'Fediverse Sync', 'Meta Text', '인스타그램 계정 연계 텍스트 기반 소통 커뮤니티', 2),
(303, 301, 'sns-bluesky', 'Bluesky (블루스카이)', 'Bluesky PBC', '2023-03', 'Decentralized', 'AT Protocol', 'Free / Open', 'Custom Feeds', 'Open Social', '알고리즘 독점 없는 탈중앙화 오픈 마이크로블로그', 3),
(304, 301, 'sns-mastodon', 'Mastodon (마스토돈)', 'Mastodon gGmbH', '2016-10', 'Fediverse', '500 Chars', 'Free / Open Source', 'ActivityPub', 'Fediverse', '서버별 독립 운영이 가능한 분산형 소셜 네트워크', 4),

-- o-visual (4 platforms)
(305, 302, 'sns-instagram', 'Instagram (인스타그램)', 'Meta Platforms', '2010-10', 'Visual Media', 'Photos / Reels', 'Free / Meta Verified', 'Graph API', 'Visual #1', '피드, 스토리, 릴스를 아우르는 비주얼 트렌드 대표', 1),
(306, 302, 'sns-tiktok', 'TikTok (틱톡)', 'ByteDance', '2016-09', 'Shorts Video', 'Algorithm Feed', 'Free / Ads', 'Creator Fund', 'Shorts #1', '강력한 추천 알고리즘으로 전 세계를 사로잡은 숏폼', 2),
(307, 302, 'sns-pinterest', 'Pinterest (핀터레스트)', 'Pinterest Inc', '2010-03', 'Mood Board', 'Visual Search', 'Free / Ads', 'Shopping Ads', 'Idea Board', '인테리어, 디자인, 레시피 등 시각적 아이디어 저장소', 3),
(308, 302, 'sns-snapchat', 'Snapchat (스냅챗)', 'Snap Inc', '2011-09', 'Ephemeral Photo', 'AR Lenses', 'Free / Snapchat+', 'Lenses API', 'AR Social', '사라지는 사진 메시지와 혁신적인 AR 필터의 선구자', 4),

-- o-chat (4 platforms)
(309, 303, 'sns-discord', 'Discord (디스코드)', 'Discord Inc', '2015-05', 'Voice & Text', 'Server Channels', 'Free / Nitro', 'Bot & Webhook', 'Community #1', '게이머, 개발자, AI 커뮤니티를 위한 최적의 음성/채팅', 1),
(310, 303, 'sns-telegram', 'Telegram (텔레그램)', 'Telegram FZ-LLC', '2013-08', 'Cloud Messaging', 'Channels & Bots', 'Free / Premium', 'MTProto API', 'Speed & Security', '초고속 전송과 무제한 대용량 파일 공유 클라우드 메신저', 2),
(311, 303, 'sns-slack', 'Slack (슬랙)', 'Salesforce', '2013-08', 'Workplace Chat', 'App Directory', 'Free / Pro / Ent', 'Slack API', 'Enterprise #1', '글로벌 기업과 테크 스타트업의 표준 협업 메신저', 3),
(312, 303, 'sns-kakaotalk', 'KakaoTalk (카카오톡)', 'Kakao Corp', '2010-03', 'Mobile Chat', 'Pay & Bank & Gift', 'Free', 'Kakao Open API', 'Korea #1', '대한민국 전 국민이 사용하는 종합 라이프스타일 메신저', 4),

-- o-biz (4 platforms)
(313, 304, 'sns-linkedin', 'LinkedIn (링크드인)', 'Microsoft', '2003-05', 'Professional', 'Resume & Jobs', 'Free / Premium', 'Talent Solutions', 'Business #1', '10억 글로벌 직장인과 채용 담당자가 모이는 네트워크', 1),
(314, 304, 'sns-blind', 'Blind (블라인드)', 'TeamBlind', '2013-12', 'Anonymous Chat', 'Company Verified', 'Free / Ads', 'Talent Search', 'Workplace Truth', '회사 이메일 인증 기반 직장인 익명 소통 커뮤니티', 2),
(315, 304, 'sns-behance', 'Behance (비핸스)', 'Adobe', '2005-09', 'Design Portfolio', 'Creative Fields', 'Free / Creative Cloud', 'Adobe API', 'Portfolio #1', '전 세계 크리에이터들이 작품을 선보이는 포트폴리오 쇼케이스', 3),
(316, 304, 'sns-dribbble', 'Dribbble (드리블)', 'Dribbble LLC', '2009-07', 'UI/UX Shots', 'Design Inspiration', 'Free / Pro', 'Hire Designers', 'Designer Hub', '디자이너들의 작업 과정(Shots)을 공유하는 커뮤니티', 4),

-- o-community (4 platforms)
(317, 305, 'sns-reddit', 'Reddit (레딧)', 'Reddit Inc', '2005-06', 'Subreddit Hub', 'Upvote/Downvote', 'Free / Premium', 'Reddit API', 'Frontpage', '인터넷의 최전선(Front page of the Internet) 뉴스 포럼', 1),
(318, 305, 'sns-quora', 'Quora (쿼라)', 'Quora Inc', '2009-06', 'Expert Q&A', 'Poe AI Integration', 'Free / Plus', 'Creator Space', 'Q&A Hub', '각 분야 전문가들이 직접 답변을 공유하는 지식 플랫폼', 2),
(319, 305, 'sns-dcinside', 'DC Inside (디시인사이드)', 'DC Inside Inc', '1999-10', 'Gallery Board', 'Meme & Trend', 'Free / Ads', 'Community Engine', 'Korea Trend', '한국 인터넷 밈과 트렌드의 발원지이자 최대 익명 갤러리', 3),
(320, 305, 'sns-fmkorea', 'FM Korea (에펨코리아)', 'FM Korea', '2008-04', 'Sports & Life', 'Hot Posts', 'Free / Ads', 'Community Board', 'Sports & Tech', '스포츠, 테크, 대중문화를 아우르는 한국 대형 종합 포럼', 4);

-- ========================================================
-- 3. SUB-MENU CONTENTS (5대 서브메뉴 샘플 데이터 완비)
-- ========================================================
-- Sample full contents for representative items in each module
INSERT INTO model_contents (model_id, sub_menu_type, title, content_body, meta_json) VALUES
-- c: GPT-4o
(1, 'OVERVIEW', 'GPT-4o (Omni) 플래그십 개요', '### GPT-4o: 텍스트·음성·비전 네이티브 옴니 플래그십\nOpenAI의 최상위 멀티모달 플래그십 모델로, 텍스트뿐만 아니라 비전과 오디오를 엔드투엔드로 통합 처리합니다.', '{"category":"Omni"}'),
(1, 'USAGE', 'GPT-4o OpenAI API 호출 예제', '```python\nfrom openai import OpenAI\nclient = OpenAI()\nresponse = client.chat.completions.create(\n    model="gpt-4o",\n    messages=[{"role": "user", "content": "Vue 2 + Spring Boot 아키텍처 가이드 작성"}]\n)\nprint(response.choices[0].message.content)\n```', '{"multimodal":true}'),
(1, 'PROS_CONS', 'GPT-4o 장단점 및 도입 분석', '#### 장점: 범용 지능 1위, 빠른 응답 속도, 방대한 서드파티 에코시스템 및 Function Calling.\n#### 단점: 높은 동시성 요청 시 간헐적 지연 발생 가능성.', '{"rating":4.9}'),
(1, 'BENCHMARKS', 'GPT-4o 공인 벤치마크 지표', '- MMLU: 88.7%\n- HumanEval: 90.2%\n- MathVista: 63.8%', '{"mmlu":88.7}'),
(1, 'LINKS', 'GPT-4o 공식 문서 및 플레이그라운드', '- 🌐 [OpenAI 공식 웹사이트](https://openai.com/)\n- 📖 [OpenAI API Reference](https://platform.openai.com/docs)', '{"url":"https://openai.com"}'),

-- c: Claude 3.7
(6, 'OVERVIEW', 'Claude 3.7 Sonnet 하이브리드 개요', '### Claude 3.7 Sonnet: 최초의 하이브리드 추론 모델\n표준 응답과 생각(Thinking) 모드를 단일 모델에서 전환할 수 있는 업계 최신 프론티어입니다.', '{"category":"Hybrid"}'),
(6, 'USAGE', 'Claude 3.7 Sonnet 사용법', '```python\nimport anthropic\nclient = anthropic.Anthropic()\nres = client.messages.create(model="claude-3-7-sonnet-20250219", max_tokens=4096, thinking={"type":"enabled","budget_tokens":2048}, messages=[{"role":"user","content":"코드 리팩토링"}])\n```', '{"thinking":true}'),
(6, 'PROS_CONS', 'Claude 3.7 Sonnet 장단점', '#### 장점: SWE-bench 1위(70.3%), 사고 예산 조절, 지시 순응성 최강.\n#### 단점: Thinking 모드 시 추가 토큰 과금.', '{"rating":4.95}'),
(6, 'BENCHMARKS', 'Claude 3.7 Sonnet 벤치마크', '- SWE-bench Verified: 70.3%\n- MATH 500: 96.2%\n- GPQA Diamond: 65.3%', '{"swe":70.3}'),
(6, 'LINKS', 'Claude 3.7 Sonnet 공식 링크', '- 🌐 [공식 발표](https://anthropic.com)\n- 📖 [API 문서](https://docs.anthropic.com)', '{"url":"https://anthropic.com"}'),

-- c: DeepSeek-R1
(18, 'OVERVIEW', 'DeepSeek-R1 순수 강화학습 추론 모델 개요', '### DeepSeek-R1: 오픈 가중치 순수 강화학습 추론 혁신\n지도학습 미세조정(SFT) 없이 대규모 강화학습(RL)만으로 복잡한 수학 및 코딩 추론 능력을 스스로 획득한 차세대 오픈 모델입니다.', '{"category":"Pure RL"}'),
(18, 'USAGE', 'DeepSeek-R1 추론 토큰 활용법', '```python\nfrom openai import OpenAI\nclient = OpenAI(api_key="YOUR_KEY", base_url="https://api.deepseek.com")\nresponse = client.chat.completions.create(\n    model="deepseek-reasoner",\n    messages=[{"role": "user", "content": "복잡한 알고리즘 증명"}]\n)\nprint("Thinking:", response.choices[0].message.reasoning_content)\nprint("Answer:", response.choices[0].message.content)\n```', '{"reasoning":true}'),
(18, 'PROS_CONS', 'DeepSeek-R1 장단점 비교', '#### 장점: o1 급 추론 성능, 파격적인 API 비용($0.55 / $2.19), MIT 라이선스 오픈 가중치 제공.\n#### 단점: 일반적인 일상 대화에서는 응답 생성 시간이 다소 소요됨.', '{"rating":4.88}'),
(18, 'BENCHMARKS', 'DeepSeek-R1 핵심 벤치마크 점수', '- AIME 2024: 79.8%\n- MATH 500: 97.3%\n- SWE-bench Verified: 49.2%', '{"aime":79.8}'),
(18, 'LINKS', 'DeepSeek 공식 저장소 및 문서', '- 🌐 [DeepSeek 웹사이트](https://www.deepseek.com/)\n- 🐙 [GitHub 오픈소스 저장소](https://github.com/deepseek-ai/DeepSeek-R1)', '{"url":"https://deepseek.com"}'),

-- i: Google
(101, 'OVERVIEW', 'Google 검색 포털 개요', '### Google: 전 세계 정보를 체계화하는 글로벌 검색의 표준\n매일 85억 건 이상의 검색 요청을 처리하며 웹 인덱싱, PageRank, 머신러닝 검색 랭킹을 선도합니다.', '{"type":"Search"}'),
(101, 'USAGE', 'Google 고급 검색 연산자', '```bash\n# 사이트 한정 검색: site:github.com vue2\n# 특정 확장자 검색: filetype:pdf spring boot\n# 정확한 문구 일치: "AUIGrid" "CrossEditor"\n```', '{"operators":true}'),
(101, 'PROS_CONS', 'Google 검색 장단점', '#### 장점: 압도적인 웹 인덱스 커버리지, 지도/유튜브/지메일 통합 계정.\n#### 단점: 최근 스폰서 광고 상단 도배 및 SEO 어뷰징 사이트 증가.', '{"rating":4.8}'),
(101, 'BENCHMARKS', 'Google 트래픽 및 점유율', '- 글로벌 검색 점유율: 90.8%\n- 일일 처리 쿼리: 85억 건+\n- 평균 검색 결과 응답속도: 0.25초', '{"share":"90.8%"}'),
(101, 'LINKS', 'Google 공식 링크', '- 🌐 [Google 메인 홈](https://www.google.com)\n- 📊 [Google Search Central](https://developers.google.com/search)', '{"url":"google.com"}'),

-- f: Cursor
(201, 'OVERVIEW', 'Cursor AI IDE 개요', '### Cursor: VS Code를 기반으로 재설계된 최초의 AI 네이티브 에디터\n단순 코드 완성을 넘어 프로젝트 전체 코드베이스(Codebase Indexing)를 임베딩하여 다중 파일 수정과 자율 에이전트 기능을 제공합니다.', '{"type":"IDE"}'),
(201, 'USAGE', 'Cursor 핵심 단축키 및 Composer 모드', '```bash\n# 인라인 코드 수정: Ctrl + K (Cmd + K)\n# 프로젝트 전체 질의: Ctrl + L (Chat)\n# 자율 에이전트 다중 파일 빌드: Ctrl + I (Composer)\n```', '{"shortcuts":true}'),
(201, 'PROS_CONS', 'Cursor 장단점', '#### 장점: 기존 VS Code 확장 프로그램 100% 호환, 파일 단위 지능형 리팩토링, Claude 3.7/GPT-4o 선택 가능.\n#### 단점: 월 $20 구독료, 고난도 프로젝트 시 토큰 소비량 큼.', '{"rating":4.9}'),
(201, 'BENCHMARKS', 'Cursor 개발 생산성 지표', '- 개발자 코딩 시간 절감률: 평균 42%\n- 월간 활성 개발자 수: 100만 명+\n- 지원 AI 모델: Claude 3.7, GPT-4o, o3-mini, DeepSeek-V3', '{"productivity":"42%"}'),
(201, 'LINKS', 'Cursor 공식 링크', '- 🌐 [Cursor 공식 웹사이트](https://cursor.com/)\n- 📖 [Cursor 포럼 및 문서](https://docs.cursor.com/)', '{"url":"cursor.com"}'),

-- o: Discord
(309, 'OVERVIEW', 'Discord 실시간 소통 플랫폼 개요', '### Discord: 전 세계 게이머와 개발자, AI 커뮤니티의 중심 허브\n음성 채널, 텍스트 채팅, 화면 공유, 봇 API를 단일 서버 아키텍처로 묶어 커뮤니티 운영을 혁신했습니다.', '{"type":"Community"}'),
(309, 'USAGE', 'Discord 웹훅 및 봇 연동 예제', '```python\nimport requests\nurl = "https://discord.com/api/webhooks/your/webhook"\nrequests.post(url, json={"content": "🚀 Plane 배포 성공 알림!"})\n```', '{"webhook":true}'),
(309, 'PROS_CONS', 'Discord 장단점', '#### 장점: 초저지연 WebRTC 음성 채널, 무제한 채팅 히스토리, 풍부한 개발자 Webhook 에코시스템.\n#### 단점: 비즈니스 격식보다는 캐주얼 커뮤니티 지향, 스팸 DM 주의 필요.', '{"rating":4.85}'),
(309, 'BENCHMARKS', 'Discord 커뮤니티 지표', '- 글로벌 월간 활성 사용자(MAU): 2억 명+\n- 일일 전송 메시지 수: 40억 건+\n- 서버 동시 접속 음성 대역폭 최적화 지원', '{"mau":"200M"}'),
(309, 'LINKS', 'Discord 공식 링크', '- 🌐 [Discord 공식 홈페이지](https://discord.com/)\n- 🤖 [Discord Developer Portal](https://discord.com/developers)', '{"url":"discord.com"}');

-- Model Metrics
INSERT INTO model_metrics (model_id, benchmark_name, score, percent_val, category) VALUES
(1, 'MMLU (General)', '88.7%', 89, 'Knowledge'),
(1, 'HumanEval (Coding)', '90.2%', 90, 'Coding'),
(6, 'SWE-bench (Software)', '70.3%', 98, 'Coding'),
(6, 'MATH 500 (Logic)', '96.2%', 96, 'Math'),
(18, 'AIME 2024 (Olympiad)', '79.8%', 95, 'Math'),
(18, 'MATH 500', '97.3%', 97, 'Math'),
(18, 'SWE-bench Verified', '49.2%', 85, 'Coding'),
(101, 'Global Search Share', '90.8%', 91, 'Traffic'),
(101, 'Query Response Time', '0.25s', 95, 'Speed'),
(201, 'Productivity Boost', '42%', 92, 'Efficiency'),
(201, 'Code Accuracy', '89.5%', 90, 'Coding'),
(309, 'Global MAU', '200M+', 88, 'Users'),
(309, 'Voice Latency', 'Under 30ms', 96, 'Realtime');
