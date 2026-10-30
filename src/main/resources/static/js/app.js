/* Plane Web + AUIGrid + CrossEditor Enterprise Application (Vue 2) */

// ========================================================
// 1. Reusable Component: AUIGrid Enterprise Data Grid
// ========================================================
Vue.component('aui-grid', {
  props: {
    title: { type: String, default: 'AUIGrid Enterprise Data Sheet' },
    columns: { type: Array, required: true },
    rows: { type: Array, required: true }
  },
  data() {
    return {
      selectedRowIds: [],
      selectAllChecked: false,
      sortColumn: '',
      sortDirection: 1, // 1: asc, -1: desc
      filterText: '',
      currentPage: 1,
      pageSize: 10
    };
  },
  computed: {
    filteredRows() {
      let list = this.rows.slice();
      if (this.filterText.trim()) {
        const kw = this.filterText.toLowerCase();
        list = list.filter(r => Object.values(r).some(val => String(val).toLowerCase().includes(kw)));
      }
      if (this.sortColumn) {
        list.sort((a, b) => {
          let valA = a[this.sortColumn];
          let valB = b[this.sortColumn];
          if (valA === valB) return 0;
          return (valA > valB ? 1 : -1) * this.sortDirection;
        });
      }
      return list;
    },
    pagedRows() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredRows.slice(start, start + this.pageSize);
    },
    totalPages() {
      return Math.max(1, Math.ceil(this.filteredRows.length / this.pageSize));
    }
  },
  methods: {
    toggleSort(colKey) {
      if (this.sortColumn === colKey) {
        this.sortDirection = -this.sortDirection;
      } else {
        this.sortColumn = colKey;
        this.sortDirection = 1;
      }
    },
    toggleSelectAll() {
      this.selectAllChecked = !this.selectAllChecked;
      if (this.selectAllChecked) {
        this.selectedRowIds = this.pagedRows.map((r, i) => r.id || i);
      } else {
        this.selectedRowIds = [];
      }
    },
    toggleRowSelect(row, idx) {
      const id = row.id || idx;
      const pos = this.selectedRowIds.indexOf(id);
      if (pos >= 0) {
        this.selectedRowIds.splice(pos, 1);
      } else {
        this.selectedRowIds.push(id);
      }
    },
    isRowSelected(row, idx) {
      return this.selectedRowIds.includes(row.id || idx);
    },
    exportExcel() {
      let csv = this.columns.map(c => `"${c.header}"`).join(',') + '\n';
      this.filteredRows.forEach(r => {
        csv += this.columns.map(c => `"${r[c.key] || ''}"`).join(',') + '\n';
      });
      const blob = new Blob(["\uFEFF" + csv], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.setAttribute("href", url);
      link.setAttribute("download", `데이터_분석_시트_${new Date().toISOString().slice(0,10)}.csv`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  },
  template: `
    <div class="aui-grid-wrapper">
      <div class="aui-grid-toolbar">
        <div class="aui-grid-title">
          <span style="color:#2563eb;">▦</span>
          <span>{{ title }}</span>
        </div>
        <div style="display:flex; align-items:center; gap:8px;">
          <input type="text" v-model="filterText" placeholder="검색 필터..." class="plane-search-input" style="width:180px; padding:4px 8px; font-size:11.5px;">
          <div class="aui-btn-group">
            <button class="aui-btn aui-btn-excel" @click="exportExcel">
              <span>📗</span> 엑셀 다운로드
            </button>
            <button class="aui-btn" @click="filterText = ''; sortColumn = '';">
              <span>↺</span> 초기화
            </button>
          </div>
        </div>
      </div>
      <div class="aui-table-container">
        <table class="aui-table">
          <thead>
            <tr>
              <th style="width:40px; text-align:center;">
                <input type="checkbox" :checked="selectAllChecked" @change="toggleSelectAll">
              </th>
              <th v-for="col in columns" :key="col.key" @click="toggleSort(col.key)" :style="{ width: col.width || 'auto' }">
                <div style="display:flex; align-items:center; justify-content:space-between;">
                  <span>{{ col.header }}</span>
                  <span style="font-size:9px; color:#94a3b8;">
                    {{ sortColumn === col.key ? (sortDirection === 1 ? '▲' : '▼') : '↕' }}
                  </span>
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, idx) in pagedRows" :key="row.id || idx" :class="{ selected: isRowSelected(row, idx) }">
              <td style="text-align:center;">
                <input type="checkbox" :checked="isRowSelected(row, idx)" @change="toggleRowSelect(row, idx)">
              </td>
              <td v-for="col in columns" :key="col.key">
                <template v-if="col.badge">
                  <span class="plane-model-badge" style="font-size:10px;">{{ row[col.key] }}</span>
                </template>
                <template v-else-if="col.score">
                  <strong style="color:#2563eb;">{{ row[col.key] }}</strong>
                </template>
                <template v-else>
                  {{ row[col.key] }}
                </template>
              </td>
            </tr>
            <tr v-if="pagedRows.length === 0">
              <td :colspan="columns.length + 1" style="text-align:center; padding:30px; color:#94a3b8;">
                조회된 그리드 데이터가 없습니다.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="aui-grid-footer">
        <div>
          <span>전체 <strong>{{ filteredRows.length }}</strong>건 (선택 {{ selectedRowIds.length }}건)</span>
        </div>
        <div class="aui-pagination">
          <button class="aui-page-btn" :disabled="currentPage === 1" @click="currentPage = 1">|&lt;</button>
          <button class="aui-page-btn" :disabled="currentPage === 1" @click="currentPage--">&lt;</button>
          <button v-for="p in totalPages" :key="p" class="aui-page-btn" :class="{ active: currentPage === p }" @click="currentPage = p">{{ p }}</button>
          <button class="aui-page-btn" :disabled="currentPage === totalPages" @click="currentPage++">&gt;</button>
          <button class="aui-page-btn" :disabled="currentPage === totalPages" @click="currentPage = totalPages">&gt;|</button>
        </div>
      </div>
    </div>
  `
});

// ========================================================
// 2. Reusable Component: Namo CrossEditor Enterprise WYSIWYG
// ========================================================
Vue.component('cross-editor', {
  props: {
    value: { type: String, default: '' },
    title: { type: String, default: '사내 기술 표준 문서 편집기 (Namo CrossEditor)' }
  },
  data() {
    return {
      mode: 'design', // 'design' | 'source' | 'preview'
      contentHtml: this.value,
      sourceHtml: this.value,
      tagPath: 'BODY > P > SPAN'
    };
  },
  watch: {
    value(newVal) {
      this.contentHtml = newVal;
      this.sourceHtml = newVal;
    }
  },
  methods: {
    exec(command, value = null) {
      document.execCommand(command, false, value);
      this.onCanvasInput();
    },
    onCanvasInput() {
      const el = this.$refs.canvas;
      if (el) {
        this.contentHtml = el.innerHTML;
        this.sourceHtml = el.innerHTML;
        this.$emit('input', this.contentHtml);
      }
    },
    switchMode(m) {
      if (this.mode === 'design' && m === 'source') {
        this.sourceHtml = this.$refs.canvas ? this.$refs.canvas.innerHTML : this.contentHtml;
      } else if (this.mode === 'source' && m === 'design') {
        this.contentHtml = this.sourceHtml;
      }
      this.mode = m;
      this.$nextTick(() => {
        if (m === 'design' && this.$refs.canvas) {
          this.$refs.canvas.innerHTML = this.contentHtml;
        }
      });
    },
    insertTable() {
      const tableHtml = `
        <table border="1" cellpadding="6" style="border-collapse:collapse; width:100%; border:1px solid #cbd5e1; margin:10px 0;">
          <tr style="background:#f8fafc;"><th>분류</th><th>항목</th><th>내용</th></tr>
          <tr><td>표준 규격</td><td>시스템 아키텍처</td><td>사내 표준 가이드라인 준수</td></tr>
          <tr><td>보안 등급</td><td>데이터 보호</td><td>기밀 정보 암호화 적용</td></tr>
        </table>
      `;
      this.exec('insertHTML', tableHtml);
    },
    saveDocument() {
      alert('문서 내용이 성공적으로 저장되었습니다.');
      this.$emit('save', this.contentHtml);
    }
  },
  template: `
    <div class="cross-editor-wrapper">
      <div class="cross-editor-topbar">
        <div class="cross-editor-brand">
          <span style="color:#2563eb;">✎</span>
          <span>{{ title }}</span>
        </div>
        <div style="display:flex; gap:6px;">
          <button class="aui-btn" style="background:#2563eb; color:#fff; border-color:#2563eb;" @click="saveDocument">
            <span>💾</span> 저장
          </button>
        </div>
      </div>
      
      <!-- Toolbar -->
      <div class="cross-editor-toolbar" v-if="mode === 'design'">
        <div class="cross-editor-tool-row">
          <select class="cross-tool-select" @change="exec('fontName', $event.target.value)">
            <option value="Malgun Gothic">맑은 고딕</option>
            <option value="Dotum">돋움</option>
            <option value="Gulim">굴림</option>
            <option value="Arial">Arial</option>
          </select>
          <select class="cross-tool-select" @change="exec('fontSize', $event.target.value)">
            <option value="2">9pt</option>
            <option value="3" selected>11pt</option>
            <option value="4">13pt</option>
            <option value="5">16pt</option>
            <option value="6">20pt</option>
          </select>
          <button class="cross-tool-btn" @click="exec('bold')" title="굵게"><strong>B</strong></button>
          <button class="cross-tool-btn" @click="exec('italic')" title="기울임"><em>I</em></button>
          <button class="cross-tool-btn" @click="exec('underline')" title="밑줄"><u>U</u></button>
          <button class="cross-tool-btn" @click="exec('strikeThrough')" title="취소선"><s>S</s></button>
          <button class="cross-tool-btn" @click="exec('foreColor', '#2563eb')" style="color:#2563eb;" title="글자색">A</button>
          <button class="cross-tool-btn" @click="exec('hiliteColor', '#fef08a')" style="background:#fef08a;" title="형광펜">T</button>
          <span style="color:#cbd5e1;">|</span>
          <button class="cross-tool-btn" @click="exec('justifyLeft')" title="좌측정렬">≡</button>
          <button class="cross-tool-btn" @click="exec('justifyCenter')" title="가운데정렬">⫸</button>
          <button class="cross-tool-btn" @click="exec('justifyRight')" title="우측정렬">⫷</button>
          <span style="color:#cbd5e1;">|</span>
          <button class="cross-tool-btn" @click="insertTable" title="표 삽입">▦ 표 삽입</button>
          <button class="cross-tool-btn" @click="exec('insertUnorderedList')" title="글머리 기호">• 목록</button>
          <button class="cross-tool-btn" @click="exec('removeFormat')" title="서식 지우기">⌫ 서식제거</button>
        </div>
      </div>

      <!-- Editor Canvas -->
      <div v-show="mode === 'design'" 
           ref="canvas" 
           class="cross-editor-canvas" 
           contenteditable="true" 
           @input="onCanvasInput" 
           v-html="contentHtml">
      </div>
      <textarea v-show="mode === 'source'" 
                class="cross-editor-source-textarea" 
                v-model="sourceHtml" 
                @input="$emit('input', sourceHtml)">
      </textarea>
      <div v-show="mode === 'preview'" class="cross-editor-canvas" v-html="sourceHtml"></div>

      <!-- Status Bar & Mode Switch -->
      <div class="cross-editor-statusbar">
        <div class="cross-editor-modes">
          <button class="cross-mode-tab" :class="{ active: mode === 'design' }" @click="switchMode('design')">디자인 (Design)</button>
          <button class="cross-mode-tab" :class="{ active: mode === 'source' }" @click="switchMode('source')">HTML 소스</button>
          <button class="cross-mode-tab" :class="{ active: mode === 'preview' }" @click="switchMode('preview')">미리보기</button>
        </div>
        <div style="display:flex; gap:12px;">
          <span>태그경로: <strong>{{ tagPath }}</strong></span>
          <span>확대: <strong>100%</strong></span>
        </div>
      </div>
    </div>
  `
});

// ========================================================
// 3. Factory function for Modular Rail Views (c, i, f, o / C, I, F, O)
// ========================================================
function createModuleComponent(moduleKey, moduleTitle, moduleTagline) {
  return {
    data() {
      return {
        moduleKey: moduleKey,
        moduleTitle: moduleTitle,
        moduleTagline: moduleTagline,
        categories: [],
        allModels: [],
        selectedModel: null,
        activeSubTab: 'OVERVIEW',
        hoveredCategory: null,
        flyoutTop: 120,
        flyoutTimer: null,
        searchKeyword: '',
        
        // AUIGrid Columns
        gridColumns: [
          { header: 'ID', key: 'id', width: '60px' },
          { header: '항목명 (Name)', key: 'name', width: '180px' },
          { header: '제공사 / 분류', key: 'provider', width: '140px' },
          { header: '릴리즈 일자', key: 'releaseDate', width: '100px' },
          { header: '규격 / 스펙', key: 'contextWindow', width: '120px' },
          { header: '단가 / 요금제', key: 'pricingInput', width: '130px' },
          { header: '상태 배지', key: 'badge', width: '100px', badge: true }
        ],

        // CrossEditor Content Model
        crossEditorHtml: `
          <h2 style="color:#1e293b; border-bottom:2px solid #2563eb; padding-bottom:8px;">${moduleTitle} 표준 운영 가이드</h2>
          <p>본 문서는 <strong>${moduleTitle}</strong> 서비스 활용 및 표준 운영 지침을 정의합니다.</p>
          <table border="1" cellpadding="8" style="border-collapse:collapse; width:100%; border:1px solid #cbd5e1; margin-top:12px;">
            <tr style="background:#f1f5f9;">
              <th>검토 항목</th>
              <th>표준 기준</th>
              <th>비고</th>
            </tr>
            <tr>
              <td>보안 및 권한</td>
              <td>SSO 연동 및 역할 기반 접근 제어</td>
              <td>기밀 데이터 마스킹 적용</td>
            </tr>
            <tr>
              <td>가용성 및 성능</td>
              <td>99.9% 가용성 및 지연시간 200ms 이내</td>
              <td>실시간 모니터링 연계</td>
            </tr>
          </table>
          <p style="margin-top:12px;">※ 변경 사항 발생 시 상단 서식 도구를 활용하여 수정 후 저장하십시오.</p>
        `
      };
    },
    computed: {
      filteredCategories() {
        if (!this.searchKeyword.trim()) return this.categories;
        const kw = this.searchKeyword.toLowerCase();
        return this.categories.filter(c => {
          const matchCat = c.name.toLowerCase().includes(kw);
          const matchM = c.models && c.models.some(m => m.name.toLowerCase().includes(kw));
          return matchCat || matchM;
        });
      },
      currentSubContent() {
        if (!this.selectedModel) return null;
        if (this.selectedModel.contents && this.selectedModel.contents.length > 0) {
          const found = this.selectedModel.contents.find(c => c.subMenuType === this.activeSubTab);
          if (found) return found;
        }
        // Dynamic fallback generation for all items across all modules
        const m = this.selectedModel;
        const type = this.activeSubTab;
        if (type === 'OVERVIEW') {
          return {
            title: `${m.name} 소개 및 개요`,
            contentBody: `### ${m.name}: ${m.tagline || '핵심 서비스 및 기술 사양'}\n\n- **제공자 / 분류**: ${m.provider}\n- **출시 / 등록일**: ${m.releaseDate}\n- **주요 규격 / 스펙**: ${m.contextWindow}\n- **단가 및 요금 정책**: ${m.pricingInput}\n\n${m.name}은(는) 해당 분야에서 널리 활용되는 대표적인 서비스로, 고성능 처리 엔진과 안정적인 인프라를 바탕으로 최적의 작업 효율을 제공합니다.`
          };
        } else if (type === 'USAGE') {
          return {
            title: `${m.name} 주요 특징 & 사용법`,
            contentBody: `### ${m.name} 핵심 활용 가이드\n\n1. **환경 설정**: 공식 API 키 발급 또는 서비스 엔드포인트 등록\n2. **연동 규격**: REST API / SDK / 웹 콘솔을 통한 표준 호출\n3. **모니터링**: 실시간 모니터링 시스템과 지표 동기화\n\n\`\`\`bash\n# ${m.name} 표준 연동 프로토콜\ncurl -X GET "https://api.example.com/${m.modelKey}/status" \\\n     -H "Authorization: Bearer YOUR_TOKEN"\n\`\`\``
          };
        } else if (type === 'PROS_CONS') {
          return {
            title: `${m.name} 장단점 비교 분석`,
            contentBody: `### ${m.name} 장점 및 트레이드오프\n\n#### ✅ 핵심 강점\n- **뛰어난 안정성**: 높은 SLA 가용성 및 글로벌 CDN/클러스터 분산 지원\n- **풍부한 기능**: 엔터프라이즈 업무 워크플로우에 최적화된 편의성\n- **비용 최적화**: 경쟁력 있는 단가 및 사용량 기반 탄력적 요금제 (${m.pricingInput})\n\n#### ⚠️ 유의사항 및 한계\n- 대규모 동시 요청 시 트래픽 스로틀링(Rate Limiting) 정책 준수 필요\n- 사내 망 연동 시 프록시 및 방화벽 인바운드/아웃바운드 포트 확인 필요`
          };
        } else if (type === 'BENCHMARKS') {
          return {
            title: `${m.name} 벤치마크 및 성능 지표`,
            contentBody: `### ${m.name} 성능 데이터\n\n- 스펙 사양: **${m.contextWindow}**\n- 출력 및 응답 용량: **${m.maxOutput}**\n- 상태 배지: **${m.badge}**\n\n*상세 비교 데이터는 '성능 분석 시트' 탭에서 확인하실 수 있습니다.*`
          };
        } else if (type === 'LINKS') {
          return {
            title: `${m.name} 공식 연결 링크`,
            contentBody: `### ${m.name} 공식 리소스\n\n- 🌐 [공식 홈페이지 및 포털](https://www.google.com/search?q=${encodeURIComponent(m.name)})\n- 📖 [개발자 및 사용자 기술 문서](https://www.google.com/search?q=${encodeURIComponent(m.name + ' docs')})\n- 💬 [커뮤니티 및 지원 센터](https://www.google.com/search?q=${encodeURIComponent(m.name + ' community')})`
          };
        }
        return null;
      },
      renderedMarkdown() {
        if (!this.currentSubContent || !this.currentSubContent.contentBody) return '';
        try { return marked.parse(this.currentSubContent.contentBody); } catch (e) { return this.currentSubContent.contentBody; }
      }
    },
    created() {
      this.initData();
    },
    methods: {
      async initData() {
        try {
          const baseModule = this.moduleKey.toLowerCase();
          const catRes = await fetch(`/api/categories?module=${baseModule}`);
          this.categories = await catRes.json();

          let items = [];
          this.categories.forEach(c => {
            if (c.models) items.push(...c.models);
          });
          this.allModels = items;

          if (this.allModels.length > 0) {
            await this.selectModel(this.allModels[0].modelKey);
          }
        } catch (err) {
          console.error(`Error loading data for ${this.moduleKey}:`, err);
        }
      },
      showCategoryFlyout(cat, event) {
        if (this.flyoutTimer) clearTimeout(this.flyoutTimer);
        if (event && event.currentTarget) {
          const rect = event.currentTarget.getBoundingClientRect();
          this.flyoutTop = Math.max(12, Math.min(rect.top - 12, window.innerHeight - 340));
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
        if (this.flyoutTimer) clearTimeout(this.flyoutTimer);
      },
      async selectModel(modelKey) {
        try {
          const res = await fetch(`/api/models/${modelKey}`);
          if (res.ok) {
            this.selectedModel = await res.json();
            if (!this.activeSubTab) this.activeSubTab = 'OVERVIEW';
          }
        } catch (e) {
          console.error(e);
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
          'BENCHMARKS': '성능 분석 시트 (AUIGrid)',
          'CROSS_EDITOR': '운영 가이드 (CrossEditor)',
          'PROS_CONS': '장단점 비교',
          'LINKS': '공식 링크'
        };
        return titles[tabKey] || tabKey;
      }
    },
    template: `
      <div style="display:flex; width:100%; height:100%;">
        <!-- Secondary Navigation Sidebar -->
        <aside class="plane-sidebar">
          <div class="plane-sidebar-header">
            <div class="plane-workspace-selector">
              <span>⚡</span>
              <span>{{ moduleTitle }}</span>
              <svg style="width:14px;height:14px;color:#64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
            </div>
          </div>

          <!-- Quick Search -->
          <div class="plane-search-box">
            <div class="plane-search-input-wrapper">
              <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
              <input type="text" class="plane-search-input" v-model="searchKeyword" placeholder="검색...">
            </div>
          </div>

          <!-- Categories List -->
          <div class="plane-nav-section">
            <div class="plane-nav-section-title">
              <span>카테고리</span>
            </div>
            <ul class="plane-nav-list">
              <li class="plane-nav-item" 
                  v-for="cat in filteredCategories" 
                  :key="cat.id"
                  :class="{ 'flyout-active': hoveredCategory && hoveredCategory.id === cat.id, 'active': selectedModel && selectedModel.categoryId === cat.id }"
                  @mouseenter="showCategoryFlyout(cat, $event)"
                  @mouseleave="hideCategoryFlyout">
                <span class="icon">{{ cat.icon }}</span>
                <span style="font-weight:600; font-size:13px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">{{ cat.name }}</span>
                <svg class="chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
              </li>
            </ul>
          </div>

          <div class="plane-sidebar-footer">
            <div class="plane-user-guide-link">
              <svg style="width:14px;height:14px;color:#64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
              <span>시스템 도움말</span>
            </div>
          </div>
        </aside>

        <!-- Compact Tree Flyout Portal -->
        <div class="plane-tree-flyout-portal" 
             v-if="hoveredCategory" 
             :style="{ top: flyoutTop + 'px', left: '326px' }"
             @mouseenter="keepCategoryFlyout" 
             @mouseleave="hideCategoryFlyout">
          
          <div class="plane-flyout-header">
            <div class="plane-flyout-title">
              <span>{{ hoveredCategory.icon }}</span>
              <span>{{ hoveredCategory.name }}</span>
              <span class="plane-flyout-tagline" v-if="hoveredCategory.tagline">· {{ hoveredCategory.tagline }}</span>
            </div>
          </div>

          <!-- 4 ~ 5 Columns Horizontal Row -->
          <div class="plane-flyout-models-row">
            <div class="plane-flyout-model-col" v-for="m in hoveredCategory.models" :key="m.id">
              <div class="plane-flyout-model-top" @click="selectModelAndTab(m.modelKey, 'OVERVIEW')">
                <span class="plane-flyout-model-name">{{ m.name }}</span>
                <span class="plane-flyout-model-badge">{{ m.badge || 'Verified' }}</span>
              </div>

              <!-- Sub-menu List under each item (Includes AUIGrid & CrossEditor) -->
              <ul class="plane-flyout-submenu-list">
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'OVERVIEW') }"
                    @click="selectModelAndTab(m.modelKey, 'OVERVIEW')">
                  <span>📌</span><span>소개 및 개요</span>
                </li>
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'USAGE') }"
                    @click="selectModelAndTab(m.modelKey, 'USAGE')">
                  <span>💡</span><span>주요 특징 &amp; 사용법</span>
                </li>
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'BENCHMARKS') }"
                    @click="selectModelAndTab(m.modelKey, 'BENCHMARKS')">
                  <span>📊</span><span>성능 분석 시트 (AUIGrid)</span>
                </li>
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'CROSS_EDITOR') }"
                    @click="selectModelAndTab(m.modelKey, 'CROSS_EDITOR')">
                  <span>📝</span><span>운영 가이드 (CrossEditor)</span>
                </li>
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'PROS_CONS') }"
                    @click="selectModelAndTab(m.modelKey, 'PROS_CONS')">
                  <span>⚖️</span><span>장단점 비교</span>
                </li>
                <li class="plane-flyout-submenu-item" 
                    :class="{ current: isCurrentModelAndTab(m.modelKey, 'LINKS') }"
                    @click="selectModelAndTab(m.modelKey, 'LINKS')">
                  <span>🔗</span><span>공식 링크</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Main Workspace Area -->
        <main class="plane-main">
          <header class="plane-header">
            <div class="plane-breadcrumbs">
              <span>{{ moduleTitle }}</span>
              <span>&gt;</span>
              <span v-if="selectedModel">{{ selectedModel.categoryName || selectedModel.provider }}</span>
              <span>&gt;</span>
              <span class="crumb-active" v-if="selectedModel">{{ selectedModel.name }} · {{ getSubTabTitle(activeSubTab) }}</span>
            </div>
          </header>

          <div class="plane-content-body">
            <section v-if="selectedModel">
              <div class="plane-model-header">
                <div>
                  <h1 class="plane-model-name">
                    {{ selectedModel.name }}
                    <span class="plane-model-badge">{{ selectedModel.badge }}</span>
                  </h1>
                  <p class="plane-model-tagline">{{ selectedModel.tagline }}</p>
                </div>
                <div class="plane-specs-strip">
                  <div class="plane-spec-chip">
                    <span class="plane-spec-label">제공사 / 분류</span>
                    <span class="plane-spec-value">{{ selectedModel.provider }}</span>
                  </div>
                  <div class="plane-spec-chip">
                    <span class="plane-spec-label">주요 규격 / 스펙</span>
                    <span class="plane-spec-value">{{ selectedModel.contextWindow }}</span>
                  </div>
                  <div class="plane-spec-chip">
                    <span class="plane-spec-label">요금 / 라이선스</span>
                    <span class="plane-spec-value">{{ selectedModel.pricingInput }}</span>
                  </div>
                </div>
              </div>

              <!-- Horizontal Sub-menu Tabs -->
              <nav class="plane-tabs">
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'OVERVIEW' }" @click="activeSubTab = 'OVERVIEW'">
                  <span>📌</span><span>소개 및 개요</span>
                </div>
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'USAGE' }" @click="activeSubTab = 'USAGE'">
                  <span>💡</span><span>주요 특징 &amp; 사용법</span>
                </div>
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'BENCHMARKS' }" @click="activeSubTab = 'BENCHMARKS'">
                  <span>📊</span><span>성능 분석 시트 (AUIGrid)</span>
                </div>
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'CROSS_EDITOR' }" @click="activeSubTab = 'CROSS_EDITOR'">
                  <span>📝</span><span>운영 가이드 (CrossEditor)</span>
                </div>
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'PROS_CONS' }" @click="activeSubTab = 'PROS_CONS'">
                  <span>⚖️</span><span>장단점 비교</span>
                </div>
                <div class="plane-tab-item" :class="{ active: activeSubTab === 'LINKS' }" @click="activeSubTab = 'LINKS'">
                  <span>🔗</span><span>공식 링크</span>
                </div>
              </nav>

              <!-- Detailed Sub-menu 1: AUIGrid Component -->
              <div v-if="activeSubTab === 'BENCHMARKS'" class="plane-card">
                <div style="margin-bottom:14px;">
                  <h3 style="font-size:15px; font-weight:700;">📊 {{ selectedModel.name }} 성능 지표 및 비교 분석</h3>
                  <p style="color:#64748b; font-size:12.5px; margin-top:3px;">
                    동일 카테고리 및 전체 서비스의 스펙, 릴리즈 시점, 요금제 지표를 실시간으로 비교 분석합니다.
                  </p>
                </div>
                <aui-grid :title="selectedModel.name + ' 성능 분석 시트'" :columns="gridColumns" :rows="allModels" />
              </div>

              <!-- Detailed Sub-menu 2: CrossEditor Component -->
              <div v-else-if="activeSubTab === 'CROSS_EDITOR'" class="plane-card">
                <div style="margin-bottom:14px;">
                  <h3 style="font-size:15px; font-weight:700;">📝 {{ selectedModel.name }} 표준 가이드 문서</h3>
                  <p style="color:#64748b; font-size:12.5px; margin-top:3px;">
                    표준 서식과 표 편집기를 활용하여 운영 및 기술 표준 문서를 편집하고 보관할 수 있습니다.
                  </p>
                </div>
                <cross-editor v-model="crossEditorHtml" :title="selectedModel.name + ' 표준 운영 가이드'" />
              </div>

              <!-- Detailed Sub-menus 3: Markdown Sub-menus -->
              <div v-else-if="currentSubContent" class="plane-card">
                <h3 style="font-size:16px; margin-bottom:12px;">{{ currentSubContent.title }}</h3>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
                
                <div v-if="activeSubTab === 'PROS_CONS'" class="plane-pros-cons-grid">
                  <div class="plane-pros-card">
                    <h4>✅ 핵심 강점 (Key Advantages)</h4>
                    <p style="font-size:13px; margin-top:8px;">업계 최상위 성능 지표 및 신뢰할 수 있는 엔터프라이즈 SLA 보장.</p>
                  </div>
                  <div class="plane-cons-card">
                    <h4>⚠️ 도입 시 고려사항 (Trade-offs)</h4>
                    <p style="font-size:13px; margin-top:8px;">사내 인프라 연동 시 라이선스 및 방화벽 포트 점검 필요.</p>
                  </div>
                </div>
              </div>
              <div v-else class="plane-card">
                <h3>{{ getSubTabTitle(activeSubTab) }}</h3>
                <p style="color:#64748b;">선택된 항목의 상세 가이드가 준비되어 있습니다.</p>
              </div>

            </section>
          </div>
        </main>
      </div>
    `
  };
}

// ========================================================
// 4. Register Distinct Components for c, i, f, o and C, I, F, O
// ========================================================
// [c & C]: LLM Foundation Models
Vue.component('component-c', createModuleComponent('c', 'c-TTTM (Frontier LLM Hub)', '차세대 프론티어 대형 언어 모델 및 추론 아키텍처'));
Vue.component('component-C', createModuleComponent('C', 'C-TTTM (Enterprise LLM Cluster)', '사내 전용 프라이빗 엔터프라이즈 대형 언어 모델 클러스터'));

// [i & I]: Famous Internet Web Sites
Vue.component('component-i', createModuleComponent('i', 'i-TTTM (Global Web Sites Hub)', '전 세계 주요 인터넷 포털, 이커머스, 클라우드 및 미디어'));
Vue.component('component-I', createModuleComponent('I', 'I-TTTM (Enterprise Portal Gateway)', '사내망 프록시 및 업무용 글로벌 웹 서비스 통합 게이트웨이'));

// [f & F]: Famous AI Tools
Vue.component('component-f', createModuleComponent('f', 'fdc-TTTM (AI Tools Suite)', '코딩, 이미지, 영상, 리서치 및 생산성 AI 도구 생태계'));
Vue.component('component-F', createModuleComponent('F', 'F-TTTM (Enterprise AI Pipeline)', '사내 승인 및 연동 엔터프라이즈 AI 자동화 파이프라인'));

// [o & O]: Famous SNS & Social Networks
Vue.component('component-o', createModuleComponent('o', 'output-TTTM (Global SNS Platforms)', '마이크로블로그, 숏폼 미디어, 메신저 및 전문 비즈니스 네트워크'));
Vue.component('component-O', createModuleComponent('O', 'O-TTTM (Enterprise Social Mesh)', '사내 소셜 협업망 및 외부 공식 SNS 채널 통합 대시보드'));

// ========================================================
// 5. Root Vue Instance
// ========================================================
new Vue({
  el: '#app',
  data: {
    currentRailView: 'c', // 'c', 'i', 'f', 'o', 'C', 'I', 'F', 'O', 'favorites'
    showNavModal: false
  },
  computed: {
    activeComponentName() {
      if (this.currentRailView === 'favorites') {
        return 'component-c';
      }
      return 'component-' + this.currentRailView;
    }
  },
  methods: {
    selectRailItem(railKey) {
      this.currentRailView = railKey;
    }
  }
});
