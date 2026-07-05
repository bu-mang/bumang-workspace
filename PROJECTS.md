# 프로젝트 인덱스

매니저가 참조하는 포트폴리오 스냅샷. 새 프로젝트 추가·상태 변경 시 이 파일을 갱신한다.
_마지막 갱신: 2026-07-05_

| 프로젝트 | 한 줄 | 모멘텀 | 단계 |
|---|---|---|---|
| [bumang-blog](#bumang-blog) | 개인 블로그 + 포트폴리오 (bumang.xyz) | 🔥 활발 (오늘) | 운영 중 · 콘텐츠/UI 개선 |
| [zentarot](#zentarot) | 모바일 타로 앱 (애니메이션 중심) | 🌱 최근 멈춤 (2주) | 렌더링 PoC |
| [ant-index](#ant-index) | 주식 커뮤니티 심리 지표 | 💤 휴면 (6주) | MVP 완료 · 데이터 축적 |

모멘텀 범례: 🔥 이번 주 활발 · 🌱 최근 멈춤(1–4주) · 💤 휴면(4주+)

---

## bumang-blog

- **정본 매니저**: `bumang-blog/CLAUDE.md` (오케스트레이터), 하위 `bumang-blog-{front,backend}/CLAUDE.md`
- **성격**: 오케스트레이터 레포 1개 + 독립 앱 레포 2개(front/backend). 각각 별도 git.
- **스택**: NestJS 10 · PostgreSQL · **TypeORM** · Next.js 14 · React 18
- **포트**: front 4000 / backend 4001
- **배포**: EC2(ap-northeast-2) + Docker + GitHub Actions, `bumang.xyz` / `api.bumang.xyz`
- **모멘텀**: front 603 커밋, backend 222 커밋, 오케스트레이터 11 커밋 — 셋 다 오늘(07-05) 작업. 포트폴리오 중 가장 뜨겁다.
- **최근 흐름**: 블로그 글 초안(Redis/stateless), 시맨틱 컬러 토큰 통일, 다크모드 대응, 애셋 정리.
- **매니저 노트**: 스택 시그니처에서 유일하게 **TypeORM**을 쓴다(나머지는 Drizzle). 가장 오래되고 성숙한 프로젝트. Drizzle 이관은 언젠가의 부채 정리 후보지만 운영 중이라 리스크 있음 — 급하지 않음.

## zentarot

- **정본 매니저**: `zentarot/CLAUDE.md`
- **성격**: pnpm + turbo 모노레포. `apps/mobile`(Expo RN) · `apps/api`(NestJS) · `packages/shared`(zod).
- **스택**: Expo React Native · Reanimated 3 · Skia · TanStack Query · Zustand / NestJS · Drizzle · PostgreSQL
- **포트**: API 30000 / PostgreSQL 35432
- **모멘텀**: 43 커밋, 마지막 06-22 (~2주 멈춤). 2.5D 렌더링 방식 확정(베이크 2.5D)하고 greybox PoC까지 진행 후 정지.
- **다음 할 일** (README 기준): 카드 이미지 에셋 + 정/역방향 의미 텍스트 채우기 · 리딩 결과/스프레드 선택 UI · 진짜 3D(r3f)·Rive는 PoC 게이트 후 결정.
- **매니저 노트**: `packages/shared`의 zod 공유 스키마 패턴이 포트폴리오에서 가장 깔끔한 프론트/백 계약 구조. 다른 프로젝트(특히 ant-index)에 이식할 가치가 있다.

## ant-index

- **정본 매니저**: `ant-index/CLAUDE.md`
- **성격**: 단일 repo, Makefile로 3서비스(crawler/server/web) 묶음.
- **스택**: NestJS · **Drizzle** · PostgreSQL 16 · Python 크롤러(requests/BS4/Playwright) · Next.js + shadcn · Docker Compose · LLM 감성분석(Gemini 2.5 Flash-Lite / Ollama Exaone 폴백)
- **포트**: PostgreSQL 5433 / server 3333
- **모멘텀**: 108 커밋, 마지막 05-26 (~6주 휴면). MVP 완료 후 데이터 축적하며 정지.
- **다음 할 일** (README 기준): 30일 min/max 정규화 · 토스증권 크롤러 · 미국주식(나스닥) 확장 · UI 고도화/온프레미스 배포.
- **매니저 노트**: 포트폴리오에서 유일하게 **LLM을 제품에 내장**한 프로젝트. 감성분석 provider 추상화(Gemini↔Ollama)가 재사용 가능한 자산. 6주 휴면이라 재개 시 데이터 파이프라인(크롤러 cron)이 살아있는지부터 확인 필요.
