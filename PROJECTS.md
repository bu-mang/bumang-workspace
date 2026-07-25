# 프로젝트 인덱스

매니저가 참조하는 포트폴리오 스냅샷. 새 프로젝트 추가·상태 변경 시 이 파일을 갱신한다.
_마지막 갱신: 2026-07-26_

| 프로젝트 | 한 줄 | 모멘텀 | 단계 |
|---|---|---|---|
| [bumang-blog](#bumang-blog) | 개인 블로그 + 포트폴리오 (bumang.xyz) | 🔥 운영 대응 (07-26 backend 502 수습) | 운영 중 · 콘텐츠/UI 개선 |
| [ant-index](#ant-index) | 주식 커뮤니티 심리 지표 | 🌱 멈춤 (제품은 07-06 트리맵이 마지막) | MVP 완료 · 시각화 피벗 |
| [zentarot](#zentarot) | 모바일 타로 앱 (애니메이션 중심) | 💤 휴면 (5주, 06-22) | 렌더링 PoC |
| [bumang-consulting](#bumang-consulting) | 인생·커리어 상담 기록 (코드 아님) | 🌱 (07-12 개설) | 기록 축적 |

> **07-06~07-12 커밋 대부분은 인프라 정리**(Camfit·workbook 플러그인 차단, PLANNING.md 스캐폴딩)라 제품 모멘텀이 아니다. 위 모멘텀은 _제품 작업_ 기준으로 재판정한 값.
> 그 후 **07-13~07-25는 포트폴리오 전체가 정지**했고, 07-26 blog backend 장애 대응으로만 재개됐다.

모멘텀 범례: 🔥 이번 주 활발 · 🌱 최근 멈춤(1–4주) · 💤 휴면(4주+)

---

## bumang-blog

- **정본 매니저**: `bumang-blog/CLAUDE.md` (오케스트레이터), 하위 `bumang-blog-{front,backend}/CLAUDE.md`
- **성격**: 오케스트레이터 레포 1개 + 독립 앱 레포 2개(front/backend). 각각 별도 git.
- **스택**: NestJS 10 · PostgreSQL · **TypeORM** · Next.js 14 · React 18
- **포트**: front 4000 / backend 4001
- **배포**: EC2(ap-northeast-2) + Docker + GitHub Actions, `bumang.xyz` / `api.bumang.xyz`
- **모멘텀**: 포트폴리오에서 유일하게 살아있는 라인 — **07-26 backend 장애 대응**(디스크 포화로 502 → 컨테이너 로그 로테이션 추가, 매 요청 찍던 디버그 console.log 미들웨어 제거). 단 이건 _운영 수습_이지 기능 개발이 아니다. front 제품 작업은 **07-05가 마지막**(3주), 오케스트레이터는 07-11(글 초안·다이어그램 애셋).
- **최근 흐름**: (07-26) 로그 로테이션·디버그 로그 제거 · (07-11) git worktree 글 초안, AI-workspace 구조 다이어그램 애셋 · (07-05) 시맨틱 컬러 토큰 통일, 다크모드 모달 대응, 인프라 그룹 썸네일/OG 교체, 백엔드 `thumbnailUrl` 컬럼 타입 프로덕션 정합, 애셋 정리.
- **운영 주시**: 07-26 502는 **디스크 포화**가 원인이었다. 로테이션으로 재발은 막았지만 EC2 디스크 여유·다른 로그 소스(도커 이미지 잔여, DB 로그)는 아직 미점검.
- **매니저 노트**: 스택 시그니처에서 유일하게 **TypeORM**을 쓴다(나머지는 Drizzle). 가장 오래되고 성숙한 프로젝트. Drizzle 이관은 언젠가의 부채 정리 후보지만 운영 중이라 리스크 있음 — 급하지 않음.

## zentarot

- **정본 매니저**: `zentarot/CLAUDE.md`
- **성격**: pnpm + turbo 모노레포. `apps/mobile`(Expo RN) · `apps/api`(NestJS) · `packages/shared`(zod).
- **스택**: Expo React Native · Reanimated 3 · Skia · TanStack Query · Zustand / NestJS · Drizzle · PostgreSQL
- **포트**: API 30000 / PostgreSQL 35432
- **모멘텀**: 제품 마지막 06-22 (**5주 휴면**, 포트폴리오 최장). 2.5D 렌더링 방식 확정(베이크 2.5D)하고 greybox PoC까지 진행 후 정지. 이후 커밋은 전부 chore/docs(플러그인 차단·PLANNING 스캐폴딩).
- **다음 할 일** (README 기준): 카드 이미지 에셋 + 정/역방향 의미 텍스트 채우기 · 리딩 결과/스프레드 선택 UI · 진짜 3D(r3f)·Rive는 PoC 게이트 후 결정.
- **매니저 노트**: `packages/shared`의 zod 공유 스키마 패턴이 포트폴리오에서 가장 깔끔한 프론트/백 계약 구조. 다른 프로젝트(특히 ant-index)에 이식할 가치가 있다.

## ant-index

- **정본 매니저**: `ant-index/CLAUDE.md`
- **성격**: 단일 repo, Makefile로 3서비스(crawler/server/web) 묶음.
- **스택**: NestJS · **Drizzle** · PostgreSQL 16 · Python 크롤러(requests/BS4/Playwright) · Next.js + shadcn · Docker Compose · LLM 감성분석(Gemini 2.5 Flash-Lite / Ollama Exaone 폴백)
- **포트**: PostgreSQL 5433 / server 3333
- **모멘텀**: **07-06에 6주 휴면을 깼다가 다시 멈춤** — `feat(web): 시총 트리맵 히트맵 컴포넌트·유틸` 커밋으로 트리맵 시각화에 착수한 게 마지막 제품 작업(20일 경과). 그 뒤 07-11 커밋은 chore/docs. 재개했다가 한 커밋 만에 식은 패턴.
- **다음 할 일** (README 기준): 30일 min/max 정규화 · 토스증권 크롤러 · 미국주식(나스닥) 확장 · UI 고도화/온프레미스 배포. ※ 07-06 실제 방향은 **시총 트리맵**으로, README 로드맵과 다른 축 — 의도된 피벗인지 확인 필요.
- **매니저 노트**: 포트폴리오에서 유일하게 **LLM을 제품에 내장**한 프로젝트. 감성분석 provider 추상화(Gemini↔Ollama)가 재사용 가능한 자산. 07-06 재개 이후 또 3주가 지나 데이터 파이프라인(크롤러 cron)이 아직 살아있는지 확인 필요.

## bumang-consulting

- **정본 매니저**: `bumang-consulting/CLAUDE.md`
- **성격**: 코드 프로젝트가 **아니다.** 인생·커리어 상담 기록 레포. `sessions/YYYY-MM-DD-<슬러그>.md`로 세션별 append.
- **공개 범위**: GitHub **private**. 사적 맥락(연애·몸·돈·심리)의 **정본은 오직 여기** — public인 이 워크스페이스 레포(`memory/` 포함)엔 존재 포인터만 두고 내용은 절대 복제하지 않는다. 매니저 `.gitignore` 화이트리스트로 자동 제외됨.
- **스택/포트**: 해당 없음.
- **모멘텀**: 07-12 개설 + 첫 세션(인생 포트폴리오 정리) 기록. 이후 추가 세션 없음.
- **매니저 노트**: 상담 요청이 오면 이 레포의 **최근 세션 2–3개를 먼저 읽고 이어받는다**. 매번 처음부터 캐묻지 않기 위해 만든 구조.
