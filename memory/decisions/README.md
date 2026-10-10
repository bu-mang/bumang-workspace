# 의사결정 인덱스

**세션에서 항상 읽는 건 이 파일뿐이다.** 각 결정의 본문은 필요할 때만 연다 — 한 줄 요약으로 "그런 결정이 있었다"까지는 여기서 알 수 있고, 그 이상이 필요하면 그때 해당 파일을 읽거나 `grep -r <키워드> memory/decisions/`로 찾는다.

포맷: **1결정 = 1파일** (`YYYY-MM-DD-<slug>.md`). 구조 결정의 근거는 [[2026-07-26-memory-sharding]].

---

## 🔴 열린 항목

- [2026-07-26-aws-account-hygiene](2026-07-26-aws-account-hygiene.md) — ~~[보안] 블로그 오리진 IP가 public 레포 README에 노출~~ → **2026-10-03 오리진 80·443을 Cloudflare 대역만 허용해 실질 위험은 닫힘**(IP를 알아도 직접 접속 불가, SSH는 키 전용). README 플레이스홀더 교체는 선택. 그 외 실제 청구액 확인 · 예산 알림 · 타 리전 점검 · EB 잔여 정리
- [2026-07-26-docker-log-rotation](2026-07-26-docker-log-rotation.md) — **ant-index에 Docker 로그 로테이션 걸렸는지 점검 필요.** 서버 전역 `/etc/docker/daemon.json` 기본 로테이션도 확인. (zentarot는 미배포라 후순위)

## 크로스프로젝트 결정 (최신순)

- [2026-10-04-sql-game-unity](2026-10-04-sql-game-unity.md) — SQL 학습 게임(6인 스타트업의 첫 데이터 분석가가 팀 요청을 SQL로 쳐냄 — 처음엔 8인, 2026-10-11에 줄임)을 **Unity 6 + C# + UI Toolkit + 내장 SQLite**로 가볍게. 모바일 세로 정본, 서버 없음, Steam은 보류. **스택 시그니처 이탈은 의도된 것** — Unity는 이 게임이 아니라 "나중에 큰 게임" 때문. 함정: **범위 팽창이 기본 성향**(대화 중 Steam 정본까지 부풀었다 되돌림) · SQLite엔 ROLLUP 없음(sql-dojo 문제 일부는 못 옮김) · 모바일 SQL 입력 UX가 최대 미지수. 레포 **`aloha-sql`**(게임 제목 "알로하 SQL: 눌라 섬 워케이션", 처음 이름 sql-office), 기획 정본은 `aloha-sql/PLANNING.md`(수익화·배경·섬 이름 등 이후 결정은 전부 그쪽)
- [2026-10-03-small-server-node-ops](2026-10-03-small-server-node-ops.md) — 작은 EC2에서 Node 컨테이너 운영 규칙: 힙 상한은 `command`에(마이그레이션이 물려받지 않게), 진단 리포트는 **`--report-exclude-env` 필수**, 코어 덤프는 기록만, 로그는 호스트 마운트, 마이그레이션은 빌드된 JS(ts-node는 256MB 꽉 참), Next standalone엔 **sharp 필수**(없으면 원본을 조용히 내보냄). 함정: **한도 붙은 컨테이너 안에서 진단 node 금지**(본체를 죽임). **Amazon Linux 2023은 `--releasever=latest` 없이는 보안 패치가 안 들어옴** → 월 1회 systemd 타이머로 업데이트·재부팅. bumang-blog t4g.micro 전환의 근거
- [2026-09-08-sql-dojo-routine](2026-09-08-sql-dojo-routine.md) — 학습 루틴(SQLD)도 **하위 레포 + 루트 스킬(`/sql-daily`)** 패턴. 실행 엔진 PostgreSQL 5434(SQLite 는 ROLLUP 없음). 함정: 이 레포 모멘텀은 커밋이 아니라 `progress/log.md` 날짜로 판정
- [2026-09-06-cloudflare-ssr-internal-route](2026-09-06-cloudflare-ssr-internal-route.md) — Cloudflare 뒤 SSR은 백엔드를 **내부 주소로 직행**(공개 도메인 재통과 금지). **`cf-connecting-ip`를 달고 Cloudflare를 다시 지나면 값 무관 403(error 1000)** → bumang-blog 글 상세 SSR 전면 장애. 서버용 내부 URL과 브라우저용 공개 URL 분리. 함정: fetch 실패 body 이중 읽기가 status를 덮어 "영원한 로딩"으로 위장
- [2026-07-26-aws-account-hygiene](2026-07-26-aws-account-hygiene.md) — 2024년 EB 잔재(`Bumang-ket-env`) 정리. **관리형 서비스는 인스턴스가 아니라 부모(EB 환경·ASG)를 지운다** — 인스턴스만 종료하면 계속 부활. `-env` 접미사가 EB 힌트. 블로그 오리진은 Cloudflare 뒤라 DNS로 못 찾고 인증서·Host 헤더·인스턴스 타입(t4g.small vs t2.micro)으로 식별. **블로그는 이 계정에 없다** — 장애 대응 시 엉뚱한 계정에서 헤맬 위험. 공인 IPv4는 2024-02부터 유료
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
- [sql-dojo](sql-dojo.md) — 정본 `sql-dojo/PLANNING.md`. 유일한 학습 루틴형 프로젝트, 진입점 `/sql-daily`

## 규칙으로 승격됨 (본문 없음 — `CLAUDE.md`가 정본)

- **스택 시그니처** (NestJS · PostgreSQL+Drizzle · Next/Expo · zod · TS strict · 한국어 · Conventional Commits) → `CLAUDE.md` "스택 시그니처". 이탈 주시: bumang-blog만 TypeORM
- **포트 레지스트리** (ant-index 5433/3333 · bumang-blog 4000/4001 · zentarot 30000/35432 · sql-dojo 5434) → `CLAUDE.md` "포트 레지스트리"

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
