---
name: commit-push
description: 하위 레포들의 커밋 안 된 변경을 커밋하고 전부 원격(bu-mang 개인계정)에 push한다 — 커밋+푸시 통합 정본. "커밋푸시해줘", "커밋하고 푸시해줘", "전부 커밋푸시", "변경사항 다 올려줘", "전부 push", "다 푸시해줘", "다 밀어줘", "다 올려줘", "push all", "commit push" 같은 요청에 사용. 커밋할 게 없으면 origin보다 앞선 커밋만 push한다. 특정 레포 하나만 올릴 땐 push-repo, 최신화(pull)는 pull-all.
---

# 커밋 + 푸시 (일괄)

이 루트의 하위 레포에서 커밋 안 된 변경을 **커밋**하고 개인계정으로 **push**한다. 사용자가 자주 쓰는 흐름이다("커밋푸시해줘").

## 절차

### 1. 커밋
**`commit-all` 스킬의 절차를 그대로 수행**한다 — 변경 스캔 → 비밀/키 점검 → 관련 경로만 스테이징 → `Bumang-Cyber` identity로 Conventional Commit(성격 다르면 분리). 커밋 규칙의 정본은 commit-all에 있으니 그걸 따른다.
- 커밋할 게 없는 레포는 건너뛴다 — 이미 커밋됐지만 origin보다 앞선 커밋이 있으면 그건 그대로 push 대상이다.

### 2. 푸시
인증을 처리하는 래퍼로 push한다(회사 토큰 403 회피). 먼저 dry-run으로 확인 후 실제 push:
```bash
bash ~/Work/private/.claude/scripts/push-personal.sh --dry-run   # 무엇이 나갈지
bash ~/Work/private/.claude/scripts/push-personal.sh             # 실제 push
```
특정 레포만이면 끝에 레포명을 붙인다.

### 3. 보고
레포별 커밋(해시·메시지)과 push 결과(⬆️/✗)를 요약한다.

## 인증 배경 (왜 push-personal.sh인가)
- 이 루트 레포는 전부 **`bu-mang`(개인) 소유**. 머신 기본 gh 계정은 **회사(`bhjeong-camfit`)**, 셸엔 `GITHUB_TOKEN`(회사 토큰)이 있어 그냥 push하면 **403**.
- `push-personal.sh`가 `GITHUB_TOKEN`을 이 프로세스에서만 unset → gh 활성계정을 `bu-mang`으로 전환 → push → **원래 계정 자동 복원**까지 처리한다.
- `~/.zshrc`의 `GITHUB_TOKEN`은 **절대 지우지 않는다**(Camfit 셋업 산물).

## 안 하는 것
- force push 안 함.
- 커밋 단계의 안전장치(비밀 점검, `git add -A` 금지, 커밋 계획 확인)는 commit-all 스킬을 따른다.
