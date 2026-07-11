---
name: commit-all
description: 하위 레포들의 커밋 안 된 변경을 커밋만 한다 (push는 안 함). "변경사항 전부 커밋해줘", "커밋만 해줘", "푸시 말고 커밋", "다 커밋해줘", "일단 커밋만", "commit all", "커밋만" 같은 요청에 사용. push까지 원하면 commit-push, 특정 레포 push는 push-repo.
---

# 커밋 (일괄, push 없음)

이 루트 하위 레포의 커밋 안 된 변경을 레포별로 커밋한다. **push는 하지 않는다** — 커밋까지만. 이 절차는 commit-push 스킬이 그대로 재사용하는 **커밋 규칙의 정본**이다.

## 절차

### 1. 변경 스캔
전체(또는 사용자가 지목한) 레포의 상태를 본다:
```bash
root="$HOME/Work/private"
for gitdir in $(find "$root" -maxdepth 3 -name .git -type d -not -path '*/node_modules/*' | sort); do
  d="${gitdir%/.git}"; echo "===== ${d#$root/} ====="; git -C "$d" status --short
done
```
변경이 하나도 없으면 여기서 끝("커밋할 게 없다"고 보고).

### 2. 커밋 (레포별)
변경이 있는 레포마다:
- **비밀/키 점검**: `.env`, `*.pem`, 토큰 등이 스테이징되지 않는지 diff로 확인. 의심되면 커밋 말고 사용자에게 알린다.
- **`git add -A` 금지**: 변경을 보고 판단해 관련 경로만 스테이징한다.
- **성격이 다르면 커밋을 나눈다**: 기능 코드(`feat`)와 툴링/설정(`chore`)이 섞였으면 별도 커밋으로.
- **identity = `Bumang-Cyber <calmness0729@gmail.com>`** (전 레포 공통). 각 레포에 `user.name/email`이 이미 레포별 config로 박혀 있어 그냥 커밋하면 자동으로 맞는다(`--author` 불필요). 새 레포면 한 번 설정:
  ```bash
  git -C "$d" config user.name "Bumang-Cyber" && git -C "$d" config user.email "calmness0729@gmail.com"
  ```
- **메시지**: Conventional Commits + 한국어. 끝에 `Co-Authored-By: Claude <현재 세션 모델명> <noreply@anthropic.com>` — 모델명은 하드코딩하지 말고 그때 실제 작업한 모델을 쓴다 (예: `Claude Fable 5`).
- 커밋 계획(레포별 무엇을/어떤 메시지로)을 사용자에게 간단히 보여주고 진행한다.

### 3. 보고
레포별 커밋(해시·메시지)을 요약한다. **push는 하지 않았음을 명확히** 하고, 이어서 올리려면 `/commit-push`(전부) 또는 `/push-repo <레포명>`(하나)를 안내한다.
