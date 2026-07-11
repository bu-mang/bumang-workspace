# 프로젝트 인덱스

매니저가 참조하는 포트폴리오 스냅샷. 새 프로젝트 추가·상태 변경 시 이 파일을 갱신한다.
_마지막 갱신: 2026-07-11_

| 프로젝트 | 한 줄 | 모멘텀 | 단계 |
|---|---|---|---|
| [ant-index](#ant-index) | 주식 커뮤니티 심리 지표 | 🌱 재개 (07-06 트리맵 착수) | MVP 완료 · 시각화 피벗 |
| [bumang-blog](#bumang-blog) | 개인 블로그 + 포트폴리오 (bumang.xyz) | 🌱 냉각 (제품은 07-05가 마지막) | 운영 중 · 콘텐츠/UI 개선 |
| [zentarot](#zentarot) | 모바일 타로 앱 (애니메이션 중심) | 💤 멈춤 (3주+, 06-22) | 렌더링 PoC |

> 최근 일주일(~07-11) 커밋 대부분은 **인프라 정리**(Camfit·workbook 플러그인 차단)라 제품 모멘텀 아님. 위 모멘텀은 _제품 작업_ 기준으로 재판정한 값.

모멘텀 범례: 🔥 이번 주 활발 · 🌱 최근 멈춤(1–4주) · 💤 휴면(4주+)

---

## bumang-blog

- **정본 매니저**: `bumang-blog/CLAUDE.md` (오케스트레이터), 하위 `bumang-blog-{front,backend}/CLAUDE.md`
- **성격**: 오케스트레이터 레포 1개 + 독립 앱 레포 2개(front/backend). 각각 별도 git.
- **스택**: NestJS 10 · PostgreSQL · **TypeORM** · Next.js 14 · React 18
- **포트**: front 4000 / backend 4001
- **배포**: EC2(ap-northeast-2) + Docker + GitHub Actions, `bumang.xyz` / `api.bumang.xyz`
- **모멘텀**: 제품 작업은 **07-05가 마지막**(6일 냉각). 07-06 이후 커밋은 플러그인 차단 chore뿐. 07-05 하루에 몰아친 뒤 정지.
- **최근 흐름**: 블로그 글 초안(Redis/stateless), 시맨틱 컬러 토큰 통일, 다크모드 모달 대응, 인프라 그룹 썸네일/OG 교체, 백엔드 `thumbnailUrl` 컬럼 타입 프로덕션 정합, 애셋 정리.
- **매니저 노트**: 스택 시그니처에서 유일하게 **TypeORM**을 쓴다(나머지는 Drizzle). 가장 오래되고 성숙한 프로젝트. Drizzle 이관은 언젠가의 부채 정리 후보지만 운영 중이라 리스크 있음 — 급하지 않음.

## zentarot

- **정본 매니저**: `zentarot/CLAUDE.md`
- **성격**: pnpm + turbo 모노레포. `apps/mobile`(Expo RN) · `apps/api`(NestJS) · `packages/shared`(zod).
- **스택**: Expo React Native · Reanimated 3 · Skia · TanStack Query · Zustand / NestJS · Drizzle · PostgreSQL
- **포트**: API 30000 / PostgreSQL 35432
- **모멘텀**: 제품 마지막 06-22 (**~3주+ 멈춤**). 2.5D 렌더링 방식 확정(베이크 2.5D)하고 greybox PoC까지 진행 후 정지. 이후 커밋은 전부 플러그인 chore.
- **다음 할 일** (README 기준): 카드 이미지 에셋 + 정/역방향 의미 텍스트 채우기 · 리딩 결과/스프레드 선택 UI · 진짜 3D(r3f)·Rive는 PoC 게이트 후 결정.
- **매니저 노트**: `packages/shared`의 zod 공유 스키마 패턴이 포트폴리오에서 가장 깔끔한 프론트/백 계약 구조. 다른 프로젝트(특히 ant-index)에 이식할 가치가 있다.

## ant-index

- **정본 매니저**: `ant-index/CLAUDE.md`
- **성격**: 단일 repo, Makefile로 3서비스(crawler/server/web) 묶음.
- **스택**: NestJS · **Drizzle** · PostgreSQL 16 · Python 크롤러(requests/BS4/Playwright) · Next.js + shadcn · Docker Compose · LLM 감성분석(Gemini 2.5 Flash-Lite / Ollama Exaone 폴백)
- **포트**: PostgreSQL 5433 / server 3333
- **모멘텀**: **07-06 휴면 깸** — `feat(web): 시총 트리맵 히트맵 컴포넌트·유틸` 커밋으로 트리맵 시각화 착수. 6주 휴면 후 재개한 유일한 제품 라인. (그 뒤 07-11은 플러그인 chore.)
- **다음 할 일** (README 기준): 30일 min/max 정규화 · 토스증권 크롤러 · 미국주식(나스닥) 확장 · UI 고도화/온프레미스 배포. ※ 07-06 실제 방향은 **시총 트리맵**으로, README 로드맵과 다른 축 — 의도된 피벗인지 확인 필요.
- **매니저 노트**: 포트폴리오에서 유일하게 **LLM을 제품에 내장**한 프로젝트. 감성분석 provider 추상화(Gemini↔Ollama)가 재사용 가능한 자산. 재개했지만 그 전 6주 휴면이라 데이터 파이프라인(크롤러 cron)이 살아있는지 확인 필요.
