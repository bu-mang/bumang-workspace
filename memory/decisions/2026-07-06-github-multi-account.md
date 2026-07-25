---
name: 2026-07-06-github-multi-account
description: 개인 레포 push는 계정 전환 필수 — 회사 GITHUB_TOKEN이 gh 키링보다 우선해 403. push-personal.sh가 unset·switch·복원을 처리
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-06
  status: 확정
---

# GitHub 멀티계정 — 개인 레포 push는 계정 전환 필수

**사실**: 이 루트의 모든 레포는 **`bu-mang`(개인, calmness0729@gmail.com) 소유**. 그런데 머신 기본 gh 활성계정은 **회사 `bhjeong-camfit`**이고, 셸(`~/.zshrc`)에 회사 토큰이 `GITHUB_TOKEN`으로 깔려 있음(Camfit 셋업 산물, **지우면 안 됨**).

HTTPS 자격증명 우선순위 = ① `GITHUB_TOKEN` env → ② gh 키링 활성계정. 그래서 그냥 push하면 **403 (Permission denied to bhjeong-camfit)**.

**해법**: `.claude/scripts/push-personal.sh` — `GITHUB_TOKEN`을 프로세스에서만 unset → `gh auth switch --user bu-mang` → `gh api user`로 재확인 → push → **원래 계정 복원(trap EXIT)**. `/commit-push`·`/push-repo`가 전부 이걸 경유한다. `repos-push.sh`를 직접 부르지 말 것.

## 함정 (모르면 오래 헤맴)

- **env에 토큰이 있으면 `gh auth switch`가 no-op처럼 동작한다.** gh가 토큰 모드로 빠져서 키링 전환이 반영 안 됨.
- **Claude 툴 셸은 매 Bash 호출마다 프로필에서 재초기화**돼 토큰이 다시 붙는다 → 한 번 unset으로 안 끝나고 **switch·push·복귀 매 명령마다 인라인 unset**이 필요(커밋 `c65fb13`).
- **SSH 키(`id_ed25519`)도 회사 계정 거**라 SSH 전환은 답이 아님.

**커밋 identity**: 이 루트 하위 레포는 **전부 `Bumang-Cyber <calmness0729@gmail.com>`**로 통일. 각 레포에 `user.name/email`을 레포별 config로 박아둠 → 그냥 커밋해도 자동으로 맞음. 새 레포 추가 시 동일 config 설정. (ant-index의 회사 identity 커밋 2개는 재작성+force-push로 교정 완료.)

**상태**: 확정 (검증 완료 — 5커밋 push 성공).

연결: [[../preferences]] · [[2026-07-06-workspace-git-repo]]
