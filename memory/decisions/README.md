# 의사결정 인덱스

**세션에서 항상 읽는 건 이 파일뿐이다.** 각 결정의 본문은 필요할 때만 연다 — 한 줄 요약으로 "그런 결정이 있었다"까지는 여기서 알 수 있고, 그 이상이 필요하면 그때 해당 파일을 읽거나 `grep -r <키워드> memory/decisions/`로 찾는다.

포맷: **1결정 = 1파일** (`YYYY-MM-DD-<slug>.md`). 구조 결정의 근거는 [[2026-07-26-memory-sharding]].

---

## 🔴 열린 항목

- [2026-07-26-docker-log-rotation](2026-07-26-docker-log-rotation.md) — **ant-index에 Docker 로그 로테이션 걸렸는지 점검 필요.** 서버 전역 `/etc/docker/daemon.json` 기본 로테이션도 확인. (zentarot는 미배포라 후순위)

## 크로스프로젝트 결정 (최신순)

- [2026-07-26-memory-sharding](2026-07-26-memory-sharding.md) — 결정 로그를 monolith에서 인덱스+1결정1파일로 분해. 압축(요약)이 아니라 계층화 — 총량과 상시 로드량을 분리해 로드량을 상수로 고정. 아카이브 트리거 = 인덱스 300줄
- [2026-07-26-docker-log-rotation](2026-07-26-docker-log-rotation.md) — Docker Compose 개인 프로젝트는 전 서비스 로그 로테이션 필수. bumang-blog 502의 진범은 로테이션 없는 json-file 로그 7.6G. 함정 2개: `expose`만 된 포트는 `curl localhost:4001`이 정상적으로 실패 / Actions는 `app`만 재생성이라 배포 후 전체 `up -d` 필요
- [2026-07-12-plugin-optout-per-repo](2026-07-12-plugin-optout-per-repo.md) — 회사 플러그인 차단은 레포별 `false` 유지, 전역 반전안 기각(회사 repo에서 켜는 걸 잊는 쪽이 더 위험). cpf엔 대화록 업로드 Stop 훅이 있어 실질 방어선
- [2026-07-11-planning-first](2026-07-11-planning-first.md) — "코드 제로투원" 버리고 기획 구체화 우선. 기획 정본은 각 repo `PLANNING.md`, 실행은 repo `CLAUDE.md`, 크로스프로젝트만 여기
- [2026-07-11-workbook-disable](2026-07-11-workbook-disable.md) — workbook 플러그인을 개인 레포 4곳 전부에서 `false`. 설정은 상위로 캐스케이드 안 되므로 중첩 repo도 각각 필요
- [2026-07-06-thin-lens-boundary](2026-07-06-thin-lens-boundary.md) — **이 워크스페이스의 헌법.** 매니저는 얇은 고고도 렌즈, 정본은 현장, 미러링 안 함. 스킬·훅은 cwd-scoped라 작업축/맥락축 분리. 자동화는 "3번 쌓이면" 규칙
- [2026-07-06-workspace-git-repo](2026-07-06-workspace-git-repo.md) — 루트를 독립 repo `bu-mang/bumang-workspace`(**PUBLIC**)로. `.gitignore` 화이트리스트로 하위 레포 자동 제외. 로컬 경로는 여전히 `~/Work/private`(하드코딩 14곳)
- [2026-07-06-github-multi-account](2026-07-06-github-multi-account.md) — 개인 레포 push는 계정 전환 필수(회사 `GITHUB_TOKEN`이 gh 키링보다 우선 → 403). `push-personal.sh` 경유. 함정: 토큰 있으면 `gh auth switch`가 no-op
- [2026-07-05-visible-memory](2026-07-05-visible-memory.md) — 루트를 지휘소로, 장기기억은 보이는 `memory/`가 정본. 네이티브 메모리는 포인터로 격하

## 프로젝트별 (포인터 — 정본은 각 repo의 `PLANNING.md`)

- [bumang-blog](bumang-blog.md) — 정본 `bumang-blog/PLANNING.md`. 스택 시그니처에서 유일하게 이탈(TypeORM)
- [ant-index](ant-index.md) — 정본 `ant-index/PLANNING.md`. 유일하게 LLM을 제품에 내장
- [zentarot](zentarot.md) — 정본 `zentarot/PLANNING.md`. `packages/shared` zod 패턴이 이식 가치 최고

## 규칙으로 승격됨 (본문 없음 — `CLAUDE.md`가 정본)

- **스택 시그니처** (NestJS · PostgreSQL+Drizzle · Next/Expo · zod · TS strict · 한국어 · Conventional Commits) → `CLAUDE.md` "스택 시그니처". 이탈 주시: bumang-blog만 TypeORM
- **포트 레지스트리** (ant-index 5433/3333 · bumang-blog 4000/4001 · zentarot 30000/35432) → `CLAUDE.md` "포트 레지스트리"

## 아카이브

없음. (트리거: 이 인덱스가 **300줄**을 넘으면 오래된 확정 결정을 `archive/YYYY-H{1,2}/`로 강등하고 여기엔 `"N건 — grep으로 조회"` 한 줄로 접는다.)

---

## 운영 규칙

- **새 결정 = 새 파일 + 인덱스 한 줄.** 기존 파일에 append하지 않는다(그게 monolith로 돌아가는 길).
- 파일명은 `YYYY-MM-DD-<slug>.md`, slug은 영문 kebab-case.
- 본문은 **결정 / 이유 / 상태**를 반드시 포함. 이유 없는 결정은 나중에 못 쓴다.
- 결정이 바뀌면 **파일을 지우지 말고** frontmatter `status`를 갱신(`확정`→`폐기`)하고 새 파일에서 `[[이전결정]]`으로 연결.
- 반복되는 결정이 규칙으로 굳으면 `CLAUDE.md`로 **승격**하고 여기엔 포인터만 남긴다.
- 인덱스 한 줄에는 **결론과 핵심 함정**까지 담는다 — 본문을 안 열고도 판단할 수 있어야 인덱스가 제 역할을 한다.
