# 의사결정 — ant-index

주식 커뮤니티 심리 지표(개미지표). 최신이 맨 위.
정본 매니저: `ant-index/CLAUDE.md` · 포트 5433/3333

### 2026-07-05 · 시총 트리맵 "민심 히트맵" 원페이지 앱으로 피벗
- **결정**: 3-tier 풀스택(crawler Python / server NestJS+Drizzle / web Next16)을 **원페이지 트리맵 히트맵**으로 피벗. 셀 크기=시가총액(시총 티어→CSS Grid grid-span 반응형), 셀 색상=개미지표 민심 연속 그라데이션(`color-mix(--sb↔--gazua)`), 셀 클릭→상세 패널, 국장⇄미장 토글, 섹터 그룹핑. 감성분석 유지가 핵심(색상=민심).
- **상태**: 확정 · 진행 중 (2026-07-05 착수)
- 계획서: `~/.claude/plans/generic-popping-acorn.md`

### 2026-07-05 · 미장 데이터를 네이버페이증권 JSON API로 확보
- **결정**: 낡은 finance.naver.com HTML 스크래핑을 JSON API로 전면 재작성해 국장+미장 통합. `api.stock.naver.com/stock/{reutersCode}/basic`+`/integration`(시세·시총 marketValueRaw·섹터), `m.stock.naver.com/front-api/discussion/list?discussionType=domesticStock|foreignStock&itemCode=`(민심).
- **이유**: 미장 글도 한글이라 기존 한국어 감성분석 재사용 가능. 검증 완료.
- **상태**: 확정

### 2026-07-05 · LLM 감성분석 Gemini → 로컬 Ollama 전환
- **결정**: Gemini API(2만원+/월) → 로컬 Ollama(비용 0). `llm.py`에 `SENTIMENT_PROVIDER` 스위치 완비. 유저는 Qwen 로컬 모델 원함.
- **이유**: 비용 절감. provider 추상화(Gemini↔Ollama)는 포트폴리오에서 재사용 가능한 자산.
- **상태**: 확정

### 2026-07-05 · Web-first(contract-first) 구현 순서
- **결정**: 웹을 더미로 먼저 완성 → 백엔드 → 크롤러 순.
- **상태**: 확정

### 주의 / 부채
- README·CLAUDE.md의 감성분석 provider·web 진행상태 기술이 **코드와 불일치**(오래됨). 코드 우선.
- web은 **Next.js 16**(학습데이터와 다름) — Next 코드 작성 전 `web/AGENTS.md`대로 `node_modules/next/dist/docs/` 먼저 읽을 것.
- 6주 휴면(마지막 05-26) 이력 → 재개 시 크롤러 cron 살아있는지부터 확인.
