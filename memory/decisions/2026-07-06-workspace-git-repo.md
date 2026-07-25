---
name: 2026-07-06-workspace-git-repo
description: 매니저 루트를 독립 git repo(bu-mang/bumang-workspace, PUBLIC)로. .gitignore 화이트리스트로 하위 레포 자동 제외
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-06
  status: 확정
---

# 매니저 루트를 git repo로 (bu-mang/bumang-workspace)

**결정**: 이 루트를 독립 git repo로 만들어 **`bu-mang/bumang-workspace`**에 올림. 매니저 레이어(`CLAUDE.md`·`PROJECTS.md`·`memory/`·`.claude/`)만 추적하고, 하위 레포는 **`.gitignore` 화이트리스트**(`/*`로 전부 무시 후 매니저 파일만 `!`로 되살림)로 제외 — 새 하위 레포도 자동 제외된다.

> **공개범위 정정(2026-07-26 실측)**: 이 블록은 원래 "(private)"라고 적혀 있었으나 **틀렸다**. `gh repo view`로 확인한 실제 값은 **PUBLIC**. (같이 확인한 `bumang-consulting`은 PRIVATE로 기록과 일치.) 개설 시점에 private였다가 나중에 public으로 바꿨는지, 처음부터 오기였는지는 불명 — 어느 쪽이든 **정본은 실측값 PUBLIC**이며 [[../preferences]]의 "public이라 회사·토큰 셋업 서술 공개는 의도된 것" 서술과 일치한다. 사적 내용은 여기 절대 쓰지 않는다.
>
> ⚠️ 이 오기는 **20일간 아무도 못 잡았다.** 검증되지 않은 기록은 반감기가 있다는 실사례.

**이름 사연**: `bumang-workspace`는 원래 다른 어드민 앱이 점유 → 그 앱을 **`user-admin`으로 rename**하고 이 이름을 확보.

**로컬 경로**: 레포 이름은 `bumang-workspace`지만 로컬 디렉토리는 여전히 `~/Work/private`다(레거시). 스크립트·설정·스킬 문서 **14곳**에 `$HOME/Work/private`가 하드코딩돼 있고 Claude Code 네이티브 메모리 디렉토리 키(`-Users-beomhwan-Work-private`)까지 걸려 있어, rename은 별건의 작업.

**부작용(의도됨)**: 루트에 `.git`이 생겨 스킬 스크립트 동적 탐색이 루트도 잡음 → `(매니저 루트)`로 라벨. `/commit-push`가 매니저 레이어 변경도 함께 커밋/push함.

**상태**: 확정 (push 완료, 회사계정 복원 확인).

연결: [[2026-07-06-github-multi-account]] · [[../preferences]]
