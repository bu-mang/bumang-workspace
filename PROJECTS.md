# 프로젝트 인덱스

매니저가 참조하는 포트폴리오 스냅샷. 새 프로젝트 추가·상태 변경 시 이 파일을 갱신한다.
_마지막 갱신: 2026-10-04_

| 프로젝트 | 한 줄 | 모멘텀 | 단계 |
|---|---|---|---|
| [bumang-blog](#bumang-blog) | 개인 블로그 + 포트폴리오 (bumang.xyz) | 🔥 성능·인증·인프라 정리 (10-02~03, t4g.micro 전환) | 운영 중 · 콘텐츠/UI 개선 |
| [ant-index](#ant-index) | 주식 커뮤니티 심리 지표 | 🌱 멈춤 (제품은 07-06 트리맵이 마지막) | MVP 완료 · 시각화 피벗 |
| [zentarot](#zentarot) | 모바일 타로 앱 (애니메이션 중심) | 💤 휴면 (5주, 06-22) | 렌더링 PoC |
| [bumang-consulting](#bumang-consulting) | 인생·커리어 상담 기록 (코드 아님) | 🌱 (07-12 개설) | 기록 축적 |
| [sql-dojo](#sql-dojo) | 매일 아침 SQL 루틴 (SQLD 대비 + 활용, 학습 레포) | 🔥 (09-08 개설) | 루틴 가동 |
| [aloha-sql](#aloha-sql) | SQL로 팀 요청을 쳐내는 데이터 분석가 모바일 게임 (Unity) | 🌱 (10-04 개설) | 기획 · 코드 없음 |

> **07-06~07-12 커밋 대부분은 인프라 정리**(Camfit·workbook 플러그인 차단, PLANNING.md 스캐폴딩)라 제품 모멘텀이 아니다. 위 모멘텀은 _제품 작업_ 기준으로 재판정한 값.
> 그 후 **07-13~07-25는 포트폴리오 전체가 정지**했고, 07-26 blog backend 장애 대응으로만 재개됐다.

모멘텀 범례: 🔥 이번 주 활발 · 🌱 최근 멈춤(1–4주) · 💤 휴면(4주+)

---

## bumang-blog

- **정본 매니저**: `bumang-blog/CLAUDE.md` (오케스트레이터), 하위 `bumang-blog-{front,backend}/CLAUDE.md`
- **성격**: 오케스트레이터 레포 1개 + 독립 앱 레포 2개(front/backend). 각각 별도 git.
- **스택**: NestJS 10 · PostgreSQL · **TypeORM** · Next.js 14 · React 18
- **포트**: front 4000 / backend 4001
- **배포**: EC2 **t4g.micro**(ap-northeast-2, 2026-10-03 small에서 하향, 탄력적 IP) + Docker + GitHub Actions, `bumang.xyz` / `api.bumang.xyz`. 앞단 Cloudflare 프록시(WAF 봇 차단, 오리진 80·443은 CF 대역만)
- **모멘텀**: 🔥 **10-02~03 하루 집중 작업** — "블로그가 느리다"에서 출발해 이미지 최적화 복구(sharp 누락이 진범), 이미지·3D 모델 다이어트(레포 정적 파일 198→62MB, S3 37.5→10.7MB), 인증 재구성(access JWT 15분 + 기기별 refresh 세션, 사용자 서버 확정), 백엔드 메모리 373→75MB(geoip-lite·Prometheus 제거), EC2 t4g.micro 전환(월 $15→$7.6). 기능이 아니라 성능·운영·보안 정리다.
- **최근 흐름**: (10-03) 인증 재구성·전역 레이트리밋·WAF·보안 그룹·메모리 한도 256MB·마이그레이션 빌드 JS화·micro 전환 · (10-02) sharp·이미지 캐시·S3 워싱·업로드 압축 · (09-06) SSR 내부 직행, 401일 때만 쿠키 삭제
- **운영 주시**: ① micro 전환 직후라 며칠 뒤 스왑·컨테이너 메모리 재측정(스왑 수백 MB, 컨테이너 200MB 이상이면 부족 신호). ② KT 회선이 무료 플랜 Cloudflare를 LAX 엣지로 받음 — 감사 로그 `colo`로 LAX 비율 확인 후 유료 플랜 판단. ③ `/ko/work/anttime-swap` 500(콘텐츠 없음), 마이그레이션 누락 컬럼 2개 — PLANNING "발견했지만 손대지 않은 것".
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

## sql-dojo

- **정본 매니저**: `sql-dojo/CLAUDE.md` (루틴 프로토콜), 기획 `sql-dojo/PLANNING.md`
- **성격**: 코드 제품이 **아니다.** Claude 가 출제·채점·기록하는 **학습 레포**. 진입점은 루트 스킬 `/sql-daily`.
- **목표**: ① SQLD 합격(응시 회차 미정, 11월 가정) ② 시험과 별개로 SQL 활용능력.
- **스택**: PostgreSQL 16 (Docker) · bash 채점기(결과셋 diff) · python3 숙련도(Leitner). 시험은 Oracle 문법이라 차이표를 이론 카드로 병행.
- **포트**: PostgreSQL 5434
- **루틴**: 아침 3문제(복습 1 · 신규 쿼리 1 · 이론 카드 1) 10~20분. 문제 은행은 세션 중 자라고, 오답·로그·숙련도가 파일로 쌓인다.
- **모멘텀**: 09-08 개설. 스타터 은행 21문제(전부 실행 검증). **첫 루틴 미실행.**
- **매니저 노트**: 워크스페이스에서 유일한 "루틴형" 프로젝트 — 모멘텀 판정 기준이 커밋이 아니라 **`progress/log.md` 의 최근 날짜**다. 3일 이상 비면 리마인더 자동화 검토(PLANNING "미정" 참조).

## aloha-sql

- **정본 매니저**: `aloha-sql/CLAUDE.md`, 기획 `aloha-sql/PLANNING.md`
- **게임 제목**: **알로하 SQL: 눌라 섬 워케이션** (레포 이름 `aloha-sql`, 2026-10-04에 `sql-office`에서 변경)
- **성격**: 포트폴리오 첫 **게임**. 8인 스타트업의 첫 데이터 분석가가 되어 팀원들의 데이터 요청을 SQL로 해결하는 모바일 게임. 가볍게 만드는 프로젝트.
- **스택**: Unity 6 · C# · 3D + 2D(데이브 더 다이버식 — 고정 카메라의 3D 사무실에 손그림 2D 캐릭터) · UI Toolkit · 내장 SQLite. 서버·계정 없음(전부 로컬). 정본 플랫폼은 모바일 세로.
- **포트**: 해당 없음.
- **스택 이탈**: 시그니처(NestJS·Next·TS·Drizzle·PostgreSQL)를 **하나도 안 쓴다 — 의도된 이탈.** Unity를 고른 이유는 이 게임이 아니라 "언젠가 큰 게임도 만들 것"이라는 장기 학습 투자(이 게임만이면 Godot으로 충분했다). SQLite는 앱 내장용.
- **모멘텀**: 10-04 개설. ChatGPT 기획 대화를 `PLANNING.md`로 옮긴 상태. Unity 6000.6.4f1 설치됨(모바일 빌드 모듈 없음). **코드 없음, 원격 레포 없음.** 수익화는 무료 체험 + 1회 해금(약 3,400원)으로 확정.
- **다음 할 일**: ① Unity 프로젝트 생성 ② vertical slice — NPC 한 명의 요청 → SQL 작성 → SQLite 실행 → 판정 → 반응 → 자동 저장 ③ 그 전에 정할 것: SQLite 바인딩. 시드 데이터(`db/`, 가게 8·상품 20·회원 40·예약 150)는 작성·검증 완료. (직원 7명 설정 확정 — 웬델·이드리스·티아고·소렌·나루·솔레이·모미. 첫 NPC는 마케터 **솔레이**, 요청 3개 확정) (테이블 4개 `shops·activities·members·bookings` 스키마는 확정) (배경·서비스는 **휴양지 눌라 섬(괌·하와이 모티브)의 액티비티 예약 중개 플랫폼 "부이"**로 확정)
- **매니저 노트**: ① **범위 팽창이 이 기획의 기본 성향** — 기획 대화가 Steam 정본·회사 성장 시뮬까지 부풀었다가 유저가 되돌렸다. `PLANNING.md`의 "만들지 않는 것 목록"이 방어선. ② **sql-dojo가 콘텐츠 창고**가 될 수 있다(검증된 문제·오답 → 업무 요청). 단 SQLite엔 ROLLUP류가 없다. ③ 최대 미지수는 **모바일 SQL 입력 UX** — 첫 목표에서 바로 검증해야 한다.
