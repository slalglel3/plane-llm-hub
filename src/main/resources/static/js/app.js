/* Plane LLM Hub - Vue 2 Client Application */
new Vue({
  el: '#app',
  data: {
    categories: [],
    allModels: [],
    selectedModel: null,
    activeSubTab: 'OVERVIEW',
    viewMode: 'model', // 'model' | 'dashboard' | 'leaderboard'
    
    // Rail Navigation state: 'c' by default as requested
    currentRailView: 'c', // 'favorites' | 'c' | 'i' | 'f' | 'o' | 'C' | 'I' | 'F' | 'O'
    
    // Tree Flyout state
    hoveredCategory: null,
    flyoutTop: 120,
    flyoutTimer: null,

    // Favorites state
    favoriteKeys: ['claude-3-7-sonnet', 'gpt-4o', 'deepseek-r1'],

    searchKeyword: '',
    stats: {},
    showNavModal: false,

    // Ask Pi / AI Advisor State
    aiQuery: '',
    aiFocus: 'c-TTTM All Models',
    aiFocusOptions: ['c-TTTM All Models', 'Coding & Agents', 'Math & Reasoning', 'High-Speed / Low-Cost', 'Open Weights / On-Premise'],
    aiFocusIndex: 0,
    aiAnswer: ''
  },
  computed: {
    currentRailTitle() {
      const titles = {
        'favorites': '즐겨찾기',
        'c': 'c-TTTM',
        'i': 'i-TTTM',
        'f': 'fdc-TTTM',
        'o': 'output-TTTM',
        'C': 'C-TTTM',
        'I': 'I-TTTM',
        'F': 'F-TTTM',
        'O': 'O-TTTM'
      };
      return titles[this.currentRailView] || 'c-TTTM';
    },

    filteredCategories() {
      if (!this.searchKeyword.trim()) {
        return this.categories;
      }
      const kw = this.searchKeyword.toLowerCase();
      return this.categories.filter(c => {
        const matchCat = c.name.toLowerCase().includes(kw) || (c.tagline && c.tagline.toLowerCase().includes(kw));
        const matchModel = c.models && c.models.some(m => m.name.toLowerCase().includes(kw) || m.tagline.toLowerCase().includes(kw));
        return matchCat || matchModel;
      });
    },

    favoriteModels() {
      return this.allModels.filter(m => this.favoriteKeys.includes(m.modelKey));
    },

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

        // 4. Default selection: First model (Claude 3.7 Sonnet or GPT-4o)
        if (this.allModels.length > 0) {
          const defaultKey = 'claude-3-7-sonnet';
          const exists = this.allModels.find(m => m.modelKey === defaultKey);
          await this.selectModel(exists ? defaultKey : this.allModels[0].modelKey);
        }
      } catch (err) {
        console.error('Error fetching data from Spring Boot API:', err);
      }
    },

    selectRailItem(railKey) {
      this.currentRailView = railKey;
      if (railKey === 'favorites') {
        this.viewMode = 'dashboard';
      } else if (railKey === 'c') {
        if (!this.selectedModel && this.allModels.length > 0) {
          this.selectModel(this.allModels[0].modelKey);
        }
      }
    },

    showCategoryFlyout(cat, event) {
      if (this.flyoutTimer) {
        clearTimeout(this.flyoutTimer);
        this.flyoutTimer = null;
      }
      if (event && event.currentTarget) {
        const rect = event.currentTarget.getBoundingClientRect();
        // Keep within viewport height
        this.flyoutTop = Math.max(12, Math.min(rect.top - 12, window.innerHeight - 380));
      }
      this.hoveredCategory = cat;
    },

    hideCategoryFlyout() {
      if (this.flyoutTimer) clearTimeout(this.flyoutTimer);
      this.flyoutTimer = setTimeout(() => {
        this.hoveredCategory = null;
      }, 180);
    },

    keepCategoryFlyout() {
      if (this.flyoutTimer) {
        clearTimeout(this.flyoutTimer);
        this.flyoutTimer = null;
      }
    },

    async selectModel(modelKey) {
      this.viewMode = 'model';
      try {
        const res = await fetch(`/api/models/${modelKey}`);
        if (res.ok) {
          this.selectedModel = await res.json();
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

    async selectModelAndTab(modelKey, tabKey) {
      this.hoveredCategory = null;
      this.activeSubTab = tabKey;
      await this.selectModel(modelKey);
    },

    isCurrentModelAndTab(modelKey, tabKey) {
      return this.selectedModel && this.selectedModel.modelKey === modelKey && this.activeSubTab === tabKey;
    },

    getSubTabTitle(tabKey) {
      const titles = {
        'OVERVIEW': '소개 및 개요',
        'USAGE': '주요 특징 & 사용법',
        'PROS_CONS': '장단점 비교',
        'BENCHMARKS': '벤치마크 및 스펙',
        'LINKS': '공식 연결 링크'
      };
      return titles[tabKey] || tabKey;
    },

    isFavorite(modelKey) {
      return this.favoriteKeys.includes(modelKey);
    },

    toggleFavorite(model) {
      if (!model) return;
      const idx = this.favoriteKeys.indexOf(model.modelKey);
      if (idx >= 0) {
        this.favoriteKeys.splice(idx, 1);
      } else {
        this.favoriteKeys.push(model.modelKey);
      }
    },

    selectDashboardView() {
      this.viewMode = 'dashboard';
      this.hoveredCategory = null;
    },

    selectLeaderboardView() {
      this.viewMode = 'leaderboard';
      this.hoveredCategory = null;
    },

    cycleAiFocus() {
      this.aiFocusIndex = (this.aiFocusIndex + 1) % this.aiFocusOptions.length;
      this.aiFocus = this.aiFocusOptions[this.aiFocusIndex];
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
        answer = `**💡 c-TTTM 어드바이저 안내**\n\n- 현재 질의하신 내용과 관련하여 **${this.selectedModel ? this.selectedModel.name : 'Claude 3.7 Sonnet'}** 및 **Gemini 2.0 Flash**를 비교 검토하시는 것을 추천합니다.\n- 좌측 2번째 메뉴의 대메뉴(OpenAI, Anthropic 등) 위에 마우스를 올리시면 횡방향 모델 목록 및 종방향 서브메뉴(개요, 사용법, 장단점, 벤치마크, 링크)를 바로 탐색하실 수 있습니다.`;
      }

      this.aiAnswer = answer;
    },

    async onSearch() {
      // In tree mode, filteredCategories computed property handles real-time filtering
    },

    async refreshData() {
      await this.initData();
      alert('API 및 최신 모델 동기화가 완료되었습니다.');
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
