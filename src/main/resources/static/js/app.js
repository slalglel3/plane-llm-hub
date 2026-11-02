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
// Global Reactive Favorites Store (Vue.observable)
// ========================================================
const DEFAULT_INITIAL_FAVORITES = [
  {
    id: 1,
    modelKey: 'gpt-4o',
    name: 'GPT-4o (Omni)',
    badge: 'Omni SOTA',
    tagline: '멀티모달 옴니 플래그십',
    provider: 'OpenAI',
    contextWindow: '128K',
    pricingInput: '$2.50 / 1M',
    categoryId: 1,
    categorySlug: 'openai',
    categoryName: 'OpenAI',
    categoryIcon: '⚡',
    categoryTagline: 'Pioneering frontier intelligence & reasoning models',
    moduleKey: 'c',
    subTab: 'BENCHMARKS',
    subTabTitle: '성능 분석 시트 (AUIGrid)'
  },
  {
    id: 6,
    modelKey: 'claude-3-7-sonnet',
    name: 'Claude 3.7 Sonnet',
    badge: 'Hybrid SOTA',
    tagline: '업계 최초 하이브리드 추론 플래그십',
    provider: 'Anthropic',
    contextWindow: '200K',
    pricingInput: '$3.00 / 1M',
    categoryId: 2,
    categorySlug: 'anthropic',
    categoryName: 'Anthropic Claude',
    categoryIcon: '🧠',
    categoryTagline: 'Safety-first steerable AI & hybrid reasoning models',
    moduleKey: 'c',
    subTab: 'CROSS_EDITOR',
    subTabTitle: '운영 가이드 (CrossEditor)'
  },
  {
    id: 101,
    modelKey: 'site-google',
    name: 'Google (구글)',
    badge: 'Portal #1',
    tagline: '글로벌 표준 검색 엔진 및 통합 플랫폼',
    provider: 'Google LLC',
    contextWindow: 'Search & Cloud',
    pricingInput: 'Free / Ads',
    categoryId: 101,
    categorySlug: 'i-search',
    categoryName: '포털 & 검색 엔진',
    categoryIcon: '🔍',
    categoryTagline: '글로벌 정보 인덱싱과 스마트 웹 서칭 포털',
    moduleKey: 'i',
    subTab: 'OVERVIEW',
    subTabTitle: '소개 및 개요'
  }
];

const FavoritesStore = Vue.observable({
  list: (function() {
    try {
      const saved = localStorage.getItem('plane_favorites_v3');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch (e) {}
    return DEFAULT_INITIAL_FAVORITES;
  })(),
  save() {
    try {
      localStorage.setItem('plane_favorites_v3', JSON.stringify(this.list));
    } catch (e) {}
  },
  isFavorite(modelKey, subTab) {
    if (!modelKey) return false;
    return this.list.some(f => f.modelKey === modelKey && (!subTab || f.subTab === subTab));
  },
  toggleFavorite(model, category, moduleKey, subTab) {
    if (!model) return;
    const effectiveSubTab = subTab || 'OVERVIEW';
    const idx = this.list.findIndex(f => f.modelKey === model.modelKey && f.subTab === effectiveSubTab);
    if (idx >= 0) {
      this.list.splice(idx, 1);
    } else {
      const titles = {
        'OVERVIEW': '소개 및 개요',
        'USAGE': '주요 특징 & 사용법',
        'BENCHMARKS': '성능 분석 시트 (AUIGrid)',
        'CROSS_EDITOR': '운영 가이드 (CrossEditor)',
        'PROS_CONS': '장단점 비교',
        'LINKS': '공식 링크'
      };
      this.list.push({
        id: model.id,
        modelKey: model.modelKey,
        name: model.name,
        badge: model.badge || 'Verified',
        tagline: model.tagline || '',
        provider: model.provider || '',
        contextWindow: model.contextWindow || '',
        pricingInput: model.pricingInput || '',
        categoryId: category ? category.id : (model.categoryId || 1),
        categorySlug: category ? category.slug : 'fav',
        categoryName: category ? category.name : (model.categoryName || model.provider || '즐겨찾기'),
        categoryIcon: category ? category.icon : '★',
        categoryTagline: category ? category.tagline : '즐겨찾는 주요 메뉴',
        moduleKey: moduleKey || 'c',
        subTab: effectiveSubTab,
        subTabTitle: titles[effectiveSubTab] || effectiveSubTab
      });
    }
    this.save();
  }
});

// ========================================================
// 3. Top Cascading Locations & Calendar Preset Constants
// ========================================================
const CASCADING_LOCATIONS = {
  KR: {
    name: "대한민국 (Korea)",
    cities: [
      { code: "ALL", name: "전체 (Select All)" },
      { code: "SEOUL", name: "서울특별시" },
      { code: "GYEONGGI", name: "경기도" },
      { code: "BUSAN", name: "부산광역시" },
      { code: "INCHEON", name: "인천광역시" },
      { code: "DAEGU", name: "대구광역시" },
      { code: "DAEJEON", name: "대전광역시" },
      { code: "GWANGJU", name: "광주광역시" },
      { code: "SEJONG", name: "세종특별자치시" }
    ]
  },
  US: {
    name: "미국 (USA)",
    cities: [
      { code: "ALL", name: "전체 (Select All)" },
      { code: "CA", name: "캘리포니아 (CA)" },
      { code: "NY", name: "뉴욕 (NY)" },
      { code: "TX", name: "텍사스 (TX)" },
      { code: "WA", name: "워싱턴 (WA)" },
      { code: "IL", name: "일리노이 (IL)" },
      { code: "MA", name: "매사추세츠 (MA)" }
    ]
  },
  JP: {
    name: "일본 (Japan)",
    cities: [
      { code: "ALL", name: "전체 (Select All)" },
      { code: "TOKYO", name: "도쿄도 (Tokyo)" },
      { code: "OSAKA", name: "오사카부 (Osaka)" },
      { code: "KANAGAWA", name: "가나가와현 (Kanagawa)" },
      { code: "KYOTO", name: "교토부 (Kyoto)" },
      { code: "AICHI", name: "아이치현 (Aichi)" }
    ]
  },
  DE: {
    name: "독일 (Germany)",
    cities: [
      { code: "ALL", name: "전체 (Select All)" },
      { code: "BERLIN", name: "베를린 (Berlin)" },
      { code: "BAVARIA", name: "바이에른 (Bavaria)" },
      { code: "HESSEN", name: "헤센 (Hessen)" },
      { code: "HAMBURG", name: "함부르크 (Hamburg)" }
    ]
  },
  UK: {
    name: "영국 (UK)",
    cities: [
      { code: "ALL", name: "전체 (Select All)" },
      { code: "LONDON", name: "런던 (Greater London)" },
      { code: "SCOTLAND", name: "스코틀랜드 (Scotland)" },
      { code: "WALES", name: "웨일스 (Wales)" },
      { code: "MANCHESTER", name: "맨체스터 (Manchester)" }
    ]
  }
};

function formatLocalDateIso(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

// ========================================================
// 4. Factory function for Modular Rail Views (c, i, f, o / C, I, F, O / favorites)
// ========================================================
function createModuleComponent(moduleKey, moduleTitle, moduleTagline) {
  return {
    data() {
      return {
        moduleKey: moduleKey,
        moduleTitle: moduleTitle,
        moduleTagline: moduleTagline,
        rawCategories: [],
        selectedModel: null,
        activeSubTab: "OVERVIEW",
        hoveredCategory: null,
        flyoutTop: 120,
        flyoutTimer: null,
        searchKeyword: "",
        isCategoryCollapsed: false,

        // Dedicated Favorites Direct Selection State
        selectedFavItem: null,

        // Top Filter Bar State (Cascading Combos & Calendar Pickers)
        filterCountry: "KR",
        filterCity: "ALL",
        filterEnv: "ALL",
        filterPeriod: "7DAYS",
        filterStartDate: "",
        filterEndDate: "",
        filterValidationWarning: false,
        filterSummaryText: "",

        // AUIGrid Columns
        gridColumns: [
          { header: "ID", key: "id", width: "60px" },
          { header: "항목명 (Name)", key: "name", width: "180px" },
          { header: "제공사 / 분류", key: "provider", width: "140px" },
          { header: "릴리즈 일자", key: "releaseDate", width: "100px" },
          { header: "규격 / 스펙", key: "contextWindow", width: "120px" },
          { header: "단가 / 요금제", key: "pricingInput", width: "130px" },
          { header: "상태 배지", key: "badge", width: "100px", badge: true }
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
      categories() {
        return this.rawCategories;
      },
      filteredCategories() {
        if (!this.searchKeyword.trim()) return this.categories;
        const kw = this.searchKeyword.toLowerCase();
        return this.categories.filter(c => {
          const matchCat = c.name.toLowerCase().includes(kw);
          const matchM = c.models && c.models.some(m => m.name.toLowerCase().includes(kw));
          return matchCat || matchM;
        });
      },
      allModels() {
        let items = [];
        this.categories.forEach(c => {
          if (c.models) items.push(...c.models);
        });
        return items;
      },
      favoriteList() {
        return FavoritesStore.list;
      },
      filteredFavoriteItemsList() {
        const list = FavoritesStore.list;
        if (!this.searchKeyword.trim()) return list;
        const kw = this.searchKeyword.toLowerCase();
        return list.filter(f => 
          (f.name && f.name.toLowerCase().includes(kw)) ||
          (f.subTabTitle && f.subTabTitle.toLowerCase().includes(kw)) ||
          (f.provider && f.provider.toLowerCase().includes(kw)) ||
          (f.moduleKey && f.moduleKey.toLowerCase().includes(kw))
        );
      },
      cityOptions() {
        if (!this.filterCountry || !CASCADING_LOCATIONS[this.filterCountry]) {
          return [{ code: "ALL", name: "전체 (Select All)" }];
        }
        return CASCADING_LOCATIONS[this.filterCountry].cities;
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
        if (type === "OVERVIEW") {
          return {
            title: `${m.name} 소개 및 개요`,
            contentBody: `### ${m.name}: ${m.tagline || "핵심 서비스 및 기술 사양"}

- **제공자 / 분류**: ${m.provider}
- **출시 / 등록일**: ${m.releaseDate}
- **주요 규격 / 스펙**: ${m.contextWindow}
- **단가 및 요금 정책**: ${m.pricingInput}

${m.name}은(는) 해당 분야에서 널리 활용되는 대표적인 서비스로, 고성능 처리 엔진과 안정적인 인프라를 바탕으로 최적의 작업 효율을 제공합니다.`
          };
        } else if (type === "USAGE") {
          return {
            title: `${m.name} 주요 특징 & 사용법`,
            contentBody: `### ${m.name} 핵심 활용 가이드

1. **환경 설정**: 공식 API 키 발급 또는 서비스 엔드포인트 등록
2. **연동 규격**: REST API / SDK / 웹 콘솔을 통한 표준 호출
3. **모니터링**: 실시간 모니터링 시스템과 지표 동기화

\`\`\`bash
# ${m.name} 표준 연동 프로토콜
curl -X GET "https://api.example.com/${m.modelKey}/status" \
     -H "Authorization: Bearer YOUR_TOKEN"
\`\`\``
          };
        } else if (type === "PROS_CONS") {
          return {
            title: `${m.name} 장단점 비교 분석`,
            contentBody: `### ${m.name} 장점 및 트레이드오프

#### ✅ 핵심 강점
- **뛰어난 안정성**: 높은 SLA 가용성 및 글로벌 CDN/클러스터 분산 지원
- **풍부한 기능**: 엔터프라이즈 업무 워크플로우에 최적화된 편의성
- **비용 최적화**: 경쟁력 있는 단가 및 사용량 기반 탄력적 요금제 (${m.pricingInput})

#### ⚠️ 유의사항 및 한계
- 대규모 동시 요청 시 트래픽 스로틀링(Rate Limiting) 정책 준수 필요
- 사내 망 연동 시 프록시 및 방화벽 인바운드/아웃바운드 포트 확인 필요`
          };
        } else if (type === "BENCHMARKS") {
          return {
            title: `${m.name} 벤치마크 및 성능 지표`,
            contentBody: `### ${m.name} 성능 데이터

- 스펙 사양: **${m.contextWindow}**
- 출력 및 응답 용량: **${m.maxOutput}**
- 상태 배지: **${m.badge}**

*상세 비교 데이터는 '성능 분석 시트' 탭에서 확인하실 수 있습니다.*`
          };
        } else if (type === "LINKS") {
          return {
            title: `${m.name} 공식 연결 링크`,
            contentBody: `### ${m.name} 공식 리소스

- 🌐 [공식 홈페이지 및 포털](https://www.google.com/search?q=${encodeURIComponent(m.name)})
- 📖 [개발자 및 사용자 기술 문서](https://www.google.com/search?q=${encodeURIComponent(m.name + " docs")})
- 💬 [커뮤니티 및 지원 센터](https://www.google.com/search?q=${encodeURIComponent(m.name + " community")})`
          };
        }
        return null;
      },
      renderedMarkdown() {
        if (!this.currentSubContent || !this.currentSubContent.contentBody) return "";
        try { return marked.parse(this.currentSubContent.contentBody); } catch (e) { return this.currentSubContent.contentBody; }
      }
    },
    created() {
      this.initData();
    },
    methods: {
      initFilterDates() {
        const today = new Date();
        const past = new Date();
        past.setDate(today.getDate() - 7);
        this.filterStartDate = formatLocalDateIso(past);
        this.filterEndDate = formatLocalDateIso(today);
      },
      onCountryChange() {
        this.filterValidationWarning = false;
        this.filterCity = "ALL";
        this.applyFilter();
      },
      onPeriodPresetChange() {
        const today = new Date();
        if (this.filterPeriod === "TODAY") {
          this.filterStartDate = formatLocalDateIso(today);
          this.filterEndDate = formatLocalDateIso(today);
        } else if (this.filterPeriod === "7DAYS") {
          const past = new Date();
          past.setDate(today.getDate() - 7);
          this.filterStartDate = formatLocalDateIso(past);
          this.filterEndDate = formatLocalDateIso(today);
        } else if (this.filterPeriod === "30DAYS") {
          const past = new Date();
          past.setDate(today.getDate() - 30);
          this.filterStartDate = formatLocalDateIso(past);
          this.filterEndDate = formatLocalDateIso(today);
        } else if (this.filterPeriod === "THIS_MONTH") {
          const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
          this.filterStartDate = formatLocalDateIso(firstDay);
          this.filterEndDate = formatLocalDateIso(today);
        } else if (this.filterPeriod === "THIS_YEAR") {
          const firstDay = new Date(today.getFullYear(), 0, 1);
          this.filterStartDate = formatLocalDateIso(firstDay);
          this.filterEndDate = formatLocalDateIso(today);
        }
        this.applyFilter();
      },
      onCustomDateChange() {
        this.filterPeriod = "CUSTOM";
        this.applyFilter();
      },
      applyFilter() {
        if (!this.filterCountry) {
          this.filterValidationWarning = true;
          return;
        }
        this.filterValidationWarning = false;

        const countryObj = CASCADING_LOCATIONS[this.filterCountry];
        const countryName = countryObj ? countryObj.name : this.filterCountry;
        let cityName = "전체 (Select All)";
        if (countryObj && this.filterCity !== "ALL") {
          const c = countryObj.cities.find(ci => ci.code === this.filterCity);
          if (c) cityName = c.name;
        }
        const envMap = {
          ALL: "전체 (Select All)",
          PROD: "운영 (Production)",
          STAGE: "검증 (Staging)",
          DEV: "개발 (Development)",
          MAINT: "점검 중 (Maintenance)"
        };
        const envName = envMap[this.filterEnv] || this.filterEnv;

        this.filterSummaryText = `[국가: ${countryName}] · [시/도: ${cityName}] · [환경: ${envName}] · [기간: ${this.filterStartDate} ~ ${this.filterEndDate}]`;
      },
      resetFilter() {
        this.filterCountry = "KR";
        this.filterCity = "ALL";
        this.filterEnv = "ALL";
        this.filterPeriod = "7DAYS";
        this.initFilterDates();
        this.applyFilter();
      },
      async selectDirectFavorite(fav) {
        if (!fav) return;
        this.selectedFavItem = fav;
        this.activeSubTab = fav.subTab || "OVERVIEW";
        await this.selectModel(fav.modelKey);
      },
      removeDirectFavorite(fav) {
        const isCurrent = this.selectedFavItem && 
          this.selectedFavItem.modelKey === fav.modelKey && 
          this.selectedFavItem.subTab === fav.subTab;

        FavoritesStore.toggleFavorite(fav, null, fav.moduleKey, fav.subTab);

        if (isCurrent) {
          this.$nextTick(() => {
            if (this.favoriteList.length > 0) {
              this.selectDirectFavorite(this.favoriteList[0]);
            } else {
              this.selectedFavItem = null;
              this.selectedModel = null;
            }
          });
        }
      },
      async initData() {
        this.initFilterDates();
        this.applyFilter();
        try {
          if (this.moduleKey === "favorites") {
            if (this.favoriteList.length > 0) {
              await this.selectDirectFavorite(this.favoriteList[0]);
            }
            return;
          }
          const baseModule = this.moduleKey.toLowerCase();
          const catRes = await fetch(`/api/categories?module=${baseModule}`);
          this.rawCategories = await catRes.json();

          if (this.allModels.length > 0) {
            await this.selectModel(this.allModels[0].modelKey);
          }
        } catch (err) {
          console.error(`Error loading data for ${this.moduleKey}:`, err);
        }
      },
      showCategoryFlyout(cat, event) {
        if (this.moduleKey === "favorites") return;
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
            if (!this.activeSubTab) this.activeSubTab = "OVERVIEW";
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
          OVERVIEW: "소개 및 개요",
          USAGE: "주요 특징 & 사용법",
          BENCHMARKS: "성능 분석 시트 (AUIGrid)",
          CROSS_EDITOR: "운영 가이드 (CrossEditor)",
          PROS_CONS: "장단점 비교",
          LINKS: "공식 링크"
        };
        return titles[tabKey] || tabKey;
      },
      isFavorite(model, subTab) {
        if (!model) return false;
        return FavoritesStore.isFavorite(model.modelKey, subTab);
      },
      toggleFavorite(model, subTab) {
        if (!model) return;
        const cat = this.categories.find(c => c.id === model.categoryId) || {
          id: model.categoryId,
          name: model.categoryName || model.provider,
          icon: "★"
        };
        FavoritesStore.toggleFavorite(model, cat, this.moduleKey, subTab);
        if (this.moduleKey === "favorites") {
          this.$nextTick(() => {
            if (this.favoriteList.length > 0) {
              if (!this.selectedFavItem || !this.favoriteList.some(f => f.modelKey === this.selectedFavItem.modelKey && f.subTab === this.selectedFavItem.subTab)) {
                this.selectDirectFavorite(this.favoriteList[0]);
              }
            } else {
              this.selectedFavItem = null;
              this.selectedModel = null;
            }
          });
        }
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
              <input type="text" class="plane-search-input" v-model="searchKeyword" :placeholder="moduleKey === 'favorites' ? '즐겨찾기 메뉴 검색...' : '카테고리 검색...'">
            </div>
          </div>

          <!-- CASE 1: Favorites Mode -> Flat Direct List (NO Category Tree, NO Hover Flyout) -->
          <div class="plane-nav-section" v-if="moduleKey === 'favorites'">
            <div class="plane-nav-section-title">
              <div style="display:flex; align-items:center; gap:6px;">
                <span style="color:#eab308; font-size:14px;">⭐</span>
                <span>즐겨찾기 메뉴 목록</span>
              </div>
              <span class="plane-collapse-badge" style="background:#fef08a; color:#854d0e;">
                {{ filteredFavoriteItemsList.length }}개
              </span>
            </div>

            <ul class="plane-fav-direct-list">
              <li v-for="item in filteredFavoriteItemsList" 
                  :key="item.modelKey + '-' + item.subTab"
                  class="plane-fav-direct-item"
                  :class="{ active: selectedFavItem && selectedFavItem.modelKey === item.modelKey && selectedFavItem.subTab === item.subTab }"
                  @click="selectDirectFavorite(item)">
                <div class="plane-fav-star-icon">★</div>
                <div class="plane-fav-item-body">
                  <div class="plane-fav-item-title">{{ item.name }}</div>
                  <div class="plane-fav-item-subtab-row">
                    <span class="plane-fav-subtab-badge">{{ item.subTabTitle }}</span>
                    <span class="plane-fav-module-badge">{{ (item.moduleKey || 'c').toUpperCase() }}-TTTM</span>
                  </div>
                </div>
                <button class="plane-fav-remove-btn" 
                        @click.stop="removeDirectFavorite(item)" 
                        title="즐겨찾기 삭제">
                  &times;
                </button>
              </li>
              <li v-if="filteredFavoriteItemsList.length === 0" class="plane-fav-empty">
                <div style="font-size:22px; margin-bottom:8px;">⭐</div>
                <div style="font-weight:600; font-size:13px; color:#475569;">등록된 즐겨찾기가 없습니다.</div>
                <div style="font-size:11.5px; color:#94a3b8; margin-top:4px; line-height:1.4;">
                  각 화면의 별표(★)를 눌러 자주 찾는 메뉴를 등록하세요.
                </div>
              </li>
            </ul>
          </div>

          <!-- CASE 2: Normal Module Mode -> Multi-Level Category Nav with Hover Flyout -->
          <div class="plane-nav-section" v-else>
            <div class="plane-nav-section-title" @click="isCategoryCollapsed = !isCategoryCollapsed" style="cursor:pointer; user-select:none;">
              <div style="display:flex; align-items:center; gap:6px;">
                <svg :style="{ transform: isCategoryCollapsed ? 'rotate(-90deg)' : 'rotate(0deg)', transition: 'transform 0.18s ease' }" 
                     style="width:12px;height:12px;color:#94a3b8;" 
                     fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                </svg>
                <span>카테고리</span>
              </div>
              <span class="plane-collapse-badge">
                {{ isCategoryCollapsed ? '펼치기' : '접기' }}
              </span>
            </div>

            <ul class="plane-nav-list" v-show="!isCategoryCollapsed">
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
              <li v-if="filteredCategories.length === 0" style="padding:18px 12px; text-align:center; color:#94a3b8; font-size:12px;">
                등록된 항목이 없습니다.
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

        <!-- Compact Tree Flyout Portal: ONLY for normal modules, NOT for favorites! -->
        <div class="plane-tree-flyout-portal" 
             v-if="moduleKey !== 'favorites' && hoveredCategory" 
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
              <span v-if="moduleKey === 'favorites' && selectedFavItem">{{ selectedFavItem.name }}</span>
              <span v-else-if="selectedModel">{{ selectedModel.name }}</span>
              <span>&gt;</span>
              <span class="crumb-active" v-if="moduleKey === 'favorites' && selectedFavItem">{{ selectedFavItem.subTabTitle }}</span>
              <span class="crumb-active" v-else-if="selectedModel">{{ getSubTabTitle(activeSubTab) }}</span>
            </div>
          </header>

          <div class="plane-content-body">
            <!-- 1. Top Filter & Cascading Combo Control Bar (화면마다 상단 콤보 & 캘린더) -->
            <div class="plane-filter-bar">
              <div class="plane-filter-row">
                <!-- Cascading Combo 1: 국가 (Country) - Required Selection with * and Badge -->
                <div class="plane-filter-group" :class="{ 'has-error': filterValidationWarning }">
                  <label class="plane-filter-label">
                    <span>국가 (Country)</span>
                    <span class="plane-req-star">*</span>
                    <span class="plane-req-badge">필수</span>
                  </label>
                  <select class="plane-filter-select" v-model="filterCountry" @change="onCountryChange">
                    <option value="" disabled>-- 국가 선택 (필수) --</option>
                    <option value="KR">대한민국 (Korea)</option>
                    <option value="US">미국 (USA)</option>
                    <option value="JP">일본 (Japan)</option>
                    <option value="DE">독일 (Germany)</option>
                    <option value="UK">영국 (UK)</option>
                  </select>
                </div>

                <!-- Cascading Combo 2: 시/도 (City/State) - Linked with Country + Select All Option -->
                <div class="plane-filter-group">
                  <label class="plane-filter-label">
                    <span>시/도 (City/State)</span>
                    <span class="plane-all-badge">Select All 지원</span>
                  </label>
                  <select class="plane-filter-select" v-model="filterCity" @change="applyFilter">
                    <option v-for="c in cityOptions" :key="c.code" :value="c.code">
                      {{ c.name }}
                    </option>
                  </select>
                </div>

                <!-- Combo 3: 운영 환경 / 상태 (Environment) - with Select All Option -->
                <div class="plane-filter-group">
                  <label class="plane-filter-label">
                    <span>운영 환경 / 상태</span>
                    <span class="plane-all-badge">Select All 지원</span>
                  </label>
                  <select class="plane-filter-select" v-model="filterEnv" @change="applyFilter">
                    <option value="ALL">전체 (Select All)</option>
                    <option value="PROD">운영 (Production)</option>
                    <option value="STAGE">검증 (Staging)</option>
                    <option value="DEV">개발 (Development)</option>
                    <option value="MAINT">점검 중 (Maintenance)</option>
                  </select>
                </div>

                <!-- Combo 4: 조회 기간 콤보 & 캘린더 날짜 선택 (Calendar Date Pickers) -->
                <div class="plane-filter-group plane-filter-group-date">
                  <label class="plane-filter-label">
                    <span>조회 기간 (Calendar)</span>
                    <span style="font-size:11px; color:#2563eb; font-weight:normal;">📅 캘린더 연동</span>
                  </label>
                  <div class="plane-date-control-wrap">
                    <!-- Preset Combo -->
                    <select class="plane-filter-select plane-period-select" v-model="filterPeriod" @change="onPeriodPresetChange">
                      <option value="TODAY">오늘 (Today)</option>
                      <option value="7DAYS">최근 7일 (Last 7 Days)</option>
                      <option value="30DAYS">최근 30일 (Last 30 Days)</option>
                      <option value="THIS_MONTH">이번 달 (This Month)</option>
                      <option value="THIS_YEAR">올해 (This Year)</option>
                      <option value="CUSTOM">직접 선택 (Calendar Custom)</option>
                    </select>
                    
                    <!-- Calendar Date Pickers -->
                    <div class="plane-date-inputs">
                      <input type="date" 
                             class="plane-date-input" 
                             v-model="filterStartDate" 
                             @change="onCustomDateChange"
                             title="시작일 선택">
                      <span class="plane-date-separator">~</span>
                      <input type="date" 
                             class="plane-date-input" 
                             v-model="filterEndDate" 
                             @change="onCustomDateChange"
                             title="종료일 선택">
                    </div>
                  </div>
                </div>

                <!-- Filter Actions: Search & Reset Buttons -->
                <div class="plane-filter-actions">
                  <button class="plane-filter-search-btn" @click="applyFilter" title="조건으로 조회">
                    <svg style="width:14px; height:14px;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    <span>조회</span>
                  </button>
                  <button class="plane-filter-reset-btn" @click="resetFilter" title="조건 초기화">
                    <svg style="width:14px; height:14px;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                    </svg>
                    <span>초기화</span>
                  </button>
                </div>
              </div>

              <!-- Validation Warning Alert -->
              <div v-if="filterValidationWarning" class="plane-filter-warning-msg">
                ⚠️ <strong>필수 선택 오류:</strong> [국가]는 필수 선택 항목입니다. 국가를 선택한 후 조회해 주십시오.
              </div>

              <!-- Applied Filter Summary Status Bar -->
              <div v-if="filterSummaryText && !filterValidationWarning" class="plane-filter-summary-row">
                <span class="plane-filter-applied-badge">적용된 조회 조건</span>
                <span class="plane-filter-summary-text">{{ filterSummaryText }}</span>
              </div>
            </div>

            <!-- 2. Sub-menu Tabs / Favorites Single-View Bar -->
            <!-- In Favorites Mode: Single-Menu Indicator (NO Tree sibling tabs!) -->
            <div class="plane-fav-single-tab-bar" v-if="moduleKey === 'favorites' && selectedFavItem">
              <span class="plane-fav-active-badge">⭐ 즐겨찾기 단독 화면</span>
              <span class="plane-fav-active-label">{{ selectedFavItem.name }} &gt; {{ selectedFavItem.subTabTitle }}</span>
            </div>

            <!-- In Normal Mode: Multi-tab navigation (소개 및 개요, 주요 특징, 성능 분석 시트, 운영 가이드, 장단점, 공식 링크) -->
            <div class="plane-model-nav" v-else-if="selectedModel">
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'OVERVIEW' }" 
                      @click="activeSubTab = 'OVERVIEW'">
                📌 소개 및 개요
              </button>
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'USAGE' }" 
                      @click="activeSubTab = 'USAGE'">
                💡 주요 특징 &amp; 사용법
              </button>
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'BENCHMARKS' }" 
                      @click="activeSubTab = 'BENCHMARKS'">
                📊 성능 분석 시트 (AUIGrid)
              </button>
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'CROSS_EDITOR' }" 
                      @click="activeSubTab = 'CROSS_EDITOR'">
                📝 운영 가이드 (CrossEditor)
              </button>
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'PROS_CONS' }" 
                      @click="activeSubTab = 'PROS_CONS'">
                ⚖️ 장단점 비교
              </button>
              <button class="plane-model-nav-btn" 
                      :class="{ active: activeSubTab === 'LINKS' }" 
                      @click="activeSubTab = 'LINKS'">
                🔗 공식 링크
              </button>
            </div>

            <!-- 3. Screen Content Section -->
            <section v-if="selectedModel">
              <!-- Sub-menu 1: AUIGrid Component View -->
              <div v-if="activeSubTab === 'BENCHMARKS'" class="plane-card">
                <div style="margin-bottom:14px; display:flex; align-items:flex-start; gap:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <div>
                    <h2 style="font-size:17px; font-weight:700; color:#0f172a;">📊 {{ selectedModel.name }} - 성능 분석 시트</h2>
                    <p style="color:#64748b; font-size:12.5px; margin-top:3px;">
                      동일 카테고리 및 전체 서비스의 스펙, 릴리즈 시점, 요금제 지표를 실시간으로 비교 분석합니다.
                    </p>
                  </div>
                </div>
                <aui-grid :title="selectedModel.name + ' 성능 분석 시트'" :columns="gridColumns" :rows="allModels.length ? allModels : [selectedModel]" />
              </div>

              <!-- Sub-menu 2: CrossEditor Component View -->
              <div v-else-if="activeSubTab === 'CROSS_EDITOR'" class="plane-card">
                <div style="margin-bottom:14px; display:flex; align-items:flex-start; gap:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <div>
                    <h2 style="font-size:17px; font-weight:700; color:#0f172a;">📝 {{ selectedModel.name }} - 운영 가이드 문서</h2>
                    <p style="color:#64748b; font-size:12.5px; margin-top:3px;">
                      표준 서식과 표 편집기를 활용하여 운영 및 기술 표준 문서를 편집하고 보관할 수 있습니다.
                    </p>
                  </div>
                </div>
                <cross-editor v-model="crossEditorHtml" :title="selectedModel.name + ' 표준 운영 가이드'" />
              </div>

              <!-- Sub-menu 3: Overview Sub-menu View -->
              <div v-else-if="activeSubTab === 'OVERVIEW'" class="plane-card">
                <div style="display:flex; align-items:center; gap:10px; margin-bottom:14px; border-bottom:1px solid #e2e8f0; padding-bottom:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <h2 style="font-size:18px; font-weight:700; color:#0f172a; margin:0;">
                    📌 {{ currentSubContent ? currentSubContent.title : (selectedModel.name + ' 소개 및 개요') }}
                  </h2>
                </div>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
              </div>

              <!-- Sub-menu 4: Usage Sub-menu View -->
              <div v-else-if="activeSubTab === 'USAGE'" class="plane-card">
                <div style="display:flex; align-items:center; gap:10px; margin-bottom:14px; border-bottom:1px solid #e2e8f0; padding-bottom:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <h2 style="font-size:18px; font-weight:700; color:#0f172a; margin:0;">
                    💡 {{ currentSubContent ? currentSubContent.title : (selectedModel.name + ' 주요 특징 & 사용법') }}
                  </h2>
                </div>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
              </div>

              <!-- Sub-menu 5: Pros & Cons Sub-menu View -->
              <div v-else-if="activeSubTab === 'PROS_CONS'" class="plane-card">
                <div style="display:flex; align-items:center; gap:10px; margin-bottom:14px; border-bottom:1px solid #e2e8f0; padding-bottom:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <h2 style="font-size:18px; font-weight:700; color:#0f172a; margin:0;">
                    ⚖️ {{ currentSubContent ? currentSubContent.title : (selectedModel.name + ' 장단점 비교') }}
                  </h2>
                </div>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
                <div class="plane-pros-cons-grid" style="margin-top:18px;">
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

              <!-- Sub-menu 6: Links Sub-menu View -->
              <div v-else-if="activeSubTab === 'LINKS'" class="plane-card">
                <div style="display:flex; align-items:center; gap:10px; margin-bottom:14px; border-bottom:1px solid #e2e8f0; padding-bottom:10px;">
                  <button class="plane-star-btn" 
                          :class="{ active: isFavorite(selectedModel, activeSubTab) }" 
                          @click="toggleFavorite(selectedModel, activeSubTab)" 
                          :title="isFavorite(selectedModel, activeSubTab) ? '즐겨찾기 해제' : '즐겨찾기 추가'">
                    <svg style="width:22px; height:22px;" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                    </svg>
                  </button>
                  <h2 style="font-size:18px; font-weight:700; color:#0f172a; margin:0;">
                    🔗 {{ currentSubContent ? currentSubContent.title : (selectedModel.name + ' 공식 링크') }}
                  </h2>
                </div>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
              </div>

              <div v-else-if="currentSubContent" class="plane-card">
                <h2 style="font-size:18px; font-weight:700; color:#0f172a; margin-bottom:14px; border-bottom:1px solid #e2e8f0; padding-bottom:10px;">
                  {{ currentSubContent.title }}
                </h2>
                <div class="markdown-body" v-html="renderedMarkdown"></div>
              </div>
            </section>

            <!-- Empty state when no items exist -->
            <section v-else class="plane-card" style="text-align:center; padding:60px 20px;">
              <div style="font-size:48px; margin-bottom:14px; color:#f59e0b;">★</div>
              <h3 style="font-size:18px; font-weight:700; color:#1e293b; margin-bottom:8px;">
                {{ moduleKey === 'favorites' ? '등록된 즐겨찾기 메뉴가 없습니다' : '표시할 데이터가 없습니다' }}
              </h3>
              <p style="color:#64748b; font-size:13.5px; max-width:440px; margin:0 auto 20px auto; line-height:1.6;">
                {{ moduleKey === 'favorites' 
                   ? '각 화면에서 제목 왼쪽의 별표(★)를 누르면 언제든지 이 곳에서 정확히 해당 메뉴만 모아볼 수 있습니다.' 
                   : '좌측 메뉴에서 항목을 선택해 주십시오.' }}
              </p>
              <button v-if="moduleKey === 'favorites'" class="plane-btn plane-btn-primary" @click="$root.selectRailItem('c')">
                <span>⚡ Frontier LLM Hub 둘러보기</span>
              </button>
            </section>
          </div>
        </main>
      </div>
    `
  };
}

// ========================================================
// 4. Register Distinct Components for c, i, f, o / C, I, F, O / Favorites
// ========================================================
// [Favorites]: Registered Favorites Menu Module
Vue.component('component-favorites', createModuleComponent('favorites', '즐겨찾기 (Favorites)', '사용자가 별표로 등록한 맞춤형 대메뉴 및 세부 화면'));

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
        return 'component-favorites';
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
