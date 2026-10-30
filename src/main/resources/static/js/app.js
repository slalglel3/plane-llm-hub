/* Plane LLM Hub - Vue 2 Client Application */
new Vue({
  el: '#app',
  data: {
    categories: [],
    allModels: [],
    selectedModel: null,
    activeSubTab: 'OVERVIEW',
    viewMode: 'model', // 'model' | 'dashboard' | 'leaderboard'
    currentRailView: 'models',
    searchKeyword: '',
    stats: {},
    showNavModal: false,

    // Ask Pi / AI Advisor State
    aiQuery: '',
    aiFocus: 'All Frontier Models',
    aiFocusOptions: ['All Frontier Models', 'Coding & Agents', 'Math & Reasoning', 'High-Speed / Low-Cost', 'Open Weights / On-Premise'],
    aiFocusIndex: 0,
    aiAnswer: ''
  },
  computed: {
    currentSubContent() {
      if (!this.selectedModel || !this.selectedModel.contents) return null;
      return this.selectedModel.contents.find(c => c.subMenuType === this.activeSubTab);
    },
    renderedMarkdown() {
      if (!this.currentSubContent || !this.currentSubContent.contentBody) return '';
      try {
        return marked.parse(this.currentSubContent.contentBody);
      } catch (e) {
        return this.currentSubContent.contentBody;
      }
    },
    renderedAiAnswer() {
      if (!this.aiAnswer) return '';
      try {
        return marked.parse(this.aiAnswer);
      } catch (e) {
        return this.aiAnswer;
      }
    }
  },
  watch: {
    renderedMarkdown() {
      this.$nextTick(() => {
        this.highlightCodeBlocks();
      });
    }
  },
  created() {
    this.initData();
  },
  methods: {
    async initData() {
      try {
        // 1. Fetch categories with models
        const catRes = await fetch('/api/categories');
        this.categories = await catRes.json();

        // 2. Fetch all models
        const modelRes = await fetch('/api/models');
        this.allModels = await modelRes.json();

        // 3. Fetch stats
        const statsRes = await fetch('/api/stats');
        this.stats = await statsRes.json();

        // 4. Default selection: First model (GPT-4o or Claude 3.7 Sonnet)
        if (this.allModels.length > 0) {
          const defaultKey = 'claude-3-7-sonnet';
          const exists = this.allModels.find(m => m.modelKey === defaultKey);
          await this.selectModel(exists ? defaultKey : this.allModels[0].modelKey);
        }
      } catch (err) {
        console.error('Error fetching data from Spring Boot API:', err);
      }
    },

    async selectModel(modelKey) {
      this.viewMode = 'model';
      try {
        const res = await fetch(`/api/models/${modelKey}`);
        if (res.ok) {
          this.selectedModel = await res.json();
          // Keep active subtab or default to OVERVIEW
          if (!this.activeSubTab) {
            this.activeSubTab = 'OVERVIEW';
          }
          this.$nextTick(() => {
            this.highlightCodeBlocks();
          });
        }
      } catch (err) {
        console.error('Error loading model detail:', err);
      }
    },

    selectDashboardView() {
      this.viewMode = 'dashboard';
    },

    selectLeaderboardView() {
      this.viewMode = 'leaderboard';
    },

    focusPiAdvisor() {
      const textarea = document.querySelector('.plane-ai-textarea');
      if (textarea) {
        textarea.focus();
      }
    },

    cycleAiFocus() {
      this.aiFocusIndex = (this.aiFocusIndex + 1) % this.aiFocusOptions.length;
      this.aiFocus = this.aiFocusOptions[this.aiFocusIndex];
    },

    setAiPrompt(prompt) {
      this.aiQuery = prompt;
      this.askAiAdvisor();
    },

    askAiAdvisor() {
      if (!this.aiQuery.trim()) return;

      const q = this.aiQuery.toLowerCase();
      let answer = '';

      if (q.includes('코딩') || q.includes('에이전트') || q.includes('개발') || q.includes('swe')) {
        answer = `**🎯 코딩 및 에이전트 최적 추천: Claude 3.7 Sonnet**\n\n- **선정 이유**: SWE-bench Verified 70.3%로 현존 모든 모델 중 1위를 기록하고 있습니다.\n- **핵심 장점**: 자율 추론(Thinking Budget) 조절을 통해 대규모 리팩토링 및 파일 단위 수정에서 환각율이 가장 낮습니다.\n- **오픈소스 대안**: 사내 온프레미스 환경이라면 **Qwen 2.5 Coder 32B** 또는 **DeepSeek-R1**을 강력 추천합니다.`;
      } else if (q.includes('가성비') || q.includes('빠른') || q.includes('속도') || q.includes('비용')) {
        answer = `**⚡ 초고속 & 가성비 최적 추천: Gemini 2.0 Flash / DeepSeek-V3**\n\n- **Gemini 2.0 Flash**: 100만 토큰 컨텍스트 지원 및 초당 135+ 토큰 출력, 가격은 입력 1M당 $0.10으로 극단적으로 저렴합니다.\n- **DeepSeek-V3**: 671B 대형 MoE 모델임에도 1M당 $0.14의 혁신적인 단가로 상용 서비스 대규모 트래픽 처리에 적합합니다.`;
      } else if (q.includes('추론') || q.includes('수학') || q.includes('r1') || q.includes('o1')) {
        answer = `**🧠 고난도 수학 & 과학 추론 비교: OpenAI o1 vs DeepSeek-R1**\n\n- **DeepSeek-R1**: 미국 수학 올림피아드 AIME 2024에서 79.8%를 기록하며 o1을 대등/추월했습니다. 특히 **MIT 라이선스 오픈 가중치**로 온프레미스 배포가 가능합니다.\n- **OpenAI o1**: 엄격한 폐쇄형 API이지만 영어권 학술 과학(GPQA) 및 일관된 시스템 안정성에서 최고 수준입니다.`;
      } else if (q.includes('사내') || q.includes('폐쇄망') || q.includes('오픈소스') || q.includes('로컬')) {
        answer = `**🔒 사내 폐쇄망 & 온프레미스 최적 추천: Llama 3.3 70B & DeepSeek-R1**\n\n- **범용 엔터프라이즈**: Meta의 **Llama 3.3 70B Instruct** (405B급 지능을 70B 단일 노드 GPU에 경량화)\n- **심층 추론/분석**: **DeepSeek-R1 (671B / 경량 증류 모델 14B~32B)** (vLLM, Ollama 즉시 연동 가능)\n- **보안 이점**: 외부 네트워크 트래픽 0%, 완전 자체 호스팅 가능.`;
      } else {
        answer = `**💡 LLM Hub 어드바이저 분석 결과**\n\n- 현재 질의하신 내용과 관련하여 **${this.selectedModel ? this.selectedModel.name : 'Claude 3.7 Sonnet'}** 및 **Gemini 2.0 Flash**를 비교 검토하시는 것을 추천합니다.\n- 상단의 **[⚖️ 장단점 비교]** 및 **[📊 벤치마크 및 스펙]** 탭을 클릭하시면 더 구체적인 정량 지표를 확인하실 수 있습니다.`;
      }

      this.aiAnswer = answer;
    },

    async onSearch() {
      if (!this.searchKeyword.trim()) {
        const res = await fetch('/api/models');
        this.allModels = await res.json();
        return;
      }
      const res = await fetch(`/api/search?q=${encodeURIComponent(this.searchKeyword)}`);
      this.allModels = await res.json();
    },

    async refreshData() {
      await this.initData();
      alert('API 동기화가 완료되었습니다.');
    },

    highlightCodeBlocks() {
      document.querySelectorAll('pre code').forEach((el) => {
        hljs.highlightElement(el);
      });

      // Add copy button to pre blocks
      document.querySelectorAll('.plane-card pre').forEach((pre) => {
        if (!pre.parentElement.classList.contains('plane-code-block')) {
          const wrapper = document.createElement('div');
          wrapper.className = 'plane-code-block';
          
          const header = document.createElement('div');
          header.className = 'plane-code-header';
          header.innerHTML = `<span>Code Snippet</span>`;
          
          const copyBtn = document.createElement('button');
          copyBtn.className = 'plane-copy-btn';
          copyBtn.innerText = '복사하기';
          copyBtn.onclick = () => {
            navigator.clipboard.writeText(pre.innerText);
            copyBtn.innerText = '복사 완료!';
            setTimeout(() => { copyBtn.innerText = '복사하기'; }, 1500);
          };
          header.appendChild(copyBtn);

          pre.parentNode.insertBefore(wrapper, pre);
          wrapper.appendChild(header);
          wrapper.appendChild(pre);
        }
      });
    }
  }
});
