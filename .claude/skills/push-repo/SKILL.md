---
name: push-repo
description: 지정한 하위 레포 하나만 원격에 push한다. "zentarot push", "ant-index만 올려", "이 레포 push해", "bumang 백엔드 push" 같은 특정 레포 지목 요청에 사용. 전부 커밋·push할 땐 commit-push 스킬.
---

# 개별 레포 Push

사용자가 지목한 레포 하나만 올린다. push는 밖으로 나가는 작업이므로 dry-run으로 확인 후 실행한다.

## 실행

1. 사용자가 말한 레포명을 인자(부분일치)로 dry-run:
   ```bash
   bash ~/Work/private/.claude/scripts/push-personal.sh --dry-run <레포명>
   ```
2. 매칭된 레포와 push 예정 커밋을 확인한다.
   - **매칭이 여러 개면**(예: "bumang" → 오케·front·backend 3개) 어느 것인지 사용자에게 되묻는다. 정말 전부면 commit-push를 안내.
   - 올릴 게 없으면 여기서 끝.
3. 확인되면 실제 push:
   ```bash
   bash ~/Work/private/.claude/scripts/push-personal.sh <레포명>
   ```
4. ⬆️ 완료 / ✗ 실패를 보고한다.

## 인증 (중요)
- 반드시 **`push-personal.sh`**를 쓴다 — 개인계정(`bu-mang`) 전환→push→회사계정 복원을 자동 처리한다. `repos-push.sh` 직접 호출 시 회사 토큰으로 **403**. 배경은 commit-push 스킬의 "인증 배경" 절 참조.

## 주의
- 레포명은 부분일치다. 정확히 하나만 올리려면 유일하게 식별되는 이름을 쓴다(예: `bumang-blog-front`).
- force push 안 함. 커밋 안 된 변경은 포함 안 됨.
