# 의사결정 — 포트폴리오 (루트/크로스프로젝트)

개별 프로젝트를 넘어서는 결정들. 최신이 맨 위.

### 2026-07-06 · 매니저 루트를 git repo로 (bu-mang/bumang-workspace)
- **결정**: 이 루트를 독립 git repo로 만들어 **`bu-mang/bumang-workspace`(private)**에 올림. 매니저 레이어(CLAUDE.md·PROJECTS.md·memory/·.claude/)만 추적하고, 하위 레포는 **`.gitignore` 화이트리스트**(`/*` 후 매니저 파일만 `!`로 되살림)로 제외 — 새 하위 레포도 자동 제외.
- **이름 사연**: `bumang-workspace`는 원래 다른 어드민 앱이 점유 → 그 앱을 **`user-admin`으로 rename**하고 이 이름을 확보.
- **부작용(의도됨)**: 루트에 `.git`이 생겨 스킬 스크립트 동적 탐색이 루트도 잡음 → `(매니저 루트)`로 라벨. commit-push가 매니저 레이어 변경도 함께 커밋/push함.
- **상태**: 확정 (push 완료, 회사계정 복원 확인). identity·인증은 이 파일의 다른 블록 참조.

### 2026-07-05 · 루트를 지휘소로, 비서의 뇌를 `memory/`에 구축
- **결정**: 하위 레포로 들어가지 않고 이 루트에서 모든 작업을 하며, 총체적 의사결정을 보이는 `memory/` 폴더에 누적한다. 숨은 네이티브 메모리(`~/.claude/...`)는 정본을 가리키는 포인터로 격하.
- **이유**: 유저가 결정 기록을 **눈으로 보고 관리**하길 원함. 네이티브 메모리는 자동 로드되지만 작업 폴더 밖에 숨어 있어 부적합.
- **상태**: 확정 · 진행 중
- 연결: [[../preferences]]

### 2026-07-06 · GitHub 멀티계정 — 개인 레포 push는 계정 전환 필수
- **사실**: 이 루트의 모든 레포는 **`bu-mang`(개인, calmness0729@gmail.com) 소유**. 그런데 머신 기본 gh 활성계정은 **회사 `bhjeong-camfit`**이고, 셸(`~/.zshrc`)에 회사 토큰이 `GITHUB_TOKEN`으로 깔려 있음(Camfit 셋업 산물, **지우면 안 됨**). HTTPS 자격증명 우선순위 = ① `GITHUB_TOKEN` env → ② gh 키링 활성계정. 그래서 그냥 push하면 **403 (Permission denied to bhjeong-camfit)**.
- **해법**: `.claude/scripts/push-personal.sh` — `GITHUB_TOKEN`을 프로세스에서만 unset → `gh auth switch --user bu-mang` → push → 원래 계정 복원(trap). `/commit-push`·`/push-repo`가 전부 이걸 경유한다.
- **주의**: SSH 키(`id_ed25519`)도 **회사 계정** 거라 SSH 전환은 답이 아님.
- **커밋 identity**: 이 루트 하위 레포는 **전부 `Bumang-Cyber <calmness0729@gmail.com>`**로 통일(2026-07-06 사용자 지정). 각 레포에 `user.name/email`을 레포별 config로 박아둠 → 그냥 커밋해도 자동으로 맞음. 새 레포 추가 시 동일 config 설정. (ant-index의 회사 identity 커밋 2개는 재작성+force-push로 교정 완료.)
- **상태**: 확정 (검증 완료 — 5커밋 push 성공). 연결: [[../preferences]]

### (기존) 스택 시그니처 — 나의 기본값
- **결정**: 새 프로젝트의 사실상 디폴트 = 백엔드 NestJS · DB PostgreSQL + **Drizzle ORM** · 프론트 Next.js(앱은 Expo RN) · 공유 타입 zod 스키마 · TS strict · 한국어 우선 · Conventional Commits.
- **이유**: 여러 프로젝트에 반복 수렴한 조합. 새로 시작할 때 결정 비용을 줄임.
- **상태**: 확정 (관찰된 수렴)
- **이탈 주시**: `bumang-blog`만 TypeORM (→ [[bumang-blog]]). 벗어난 선택 발견 시 매니저가 짚는다.

### (기존) 포트 레지스트리 — 로컬 충돌 방지
- **결정**: ant-index 5433/3333 · bumang-blog 4000/4001 · zentarot 30000/35432. 새 프로젝트는 이와 안 겹치게 배정.
- **이유**: 여러 프로젝트를 동시에 로컬 구동할 때 포트 충돌 방지.
- **상태**: 확정
