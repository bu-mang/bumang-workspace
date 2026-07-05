---
name: pull-all
description: 모든 하위 레포(ant-index·bumang-blog 3개·zentarot 등)를 git pull(--ff-only)로 한 번에 최신화한다. "전부 풀해줘", "전부 pull해줘", "하위 레포 풀 받아줘", "다 최신화", "pull all" 같은 요청에 사용. 개별 레포만 풀 받을 땐 레포명을 함께 준다.
---

# 하위 레포 일괄 Pull

이 루트의 모든 하위 git 레포를 안전하게(`--ff-only`) 최신화한다. dirty 작업 트리·diverged·업스트림 없음은 건드리지 않고 건너뛴다.

## 실행

1. 특정 레포만 요청했으면 레포명(부분일치)을 인자로 넘긴다. 전부면 인자 없이:
   ```bash
   bash ~/Work/private/.claude/scripts/repos-pull.sh [레포명]
   ```
2. 결과를 아이콘별로 묶어 간결히 보고한다:
   - ⬇️ 풀 받은 레포(+ 커밋 수) · ✓ 이미 최신 · ⚠️ 건너뜀(dirty / diverged / 업스트림 없음)
3. ⚠️/✗ 가 있으면 그 레포만 짚어 다음 조치를 제안한다(예: dirty면 "커밋하거나 스태시 후 다시", diverged면 "수동 rebase/merge 필요").

## 주의
- 매니저는 임의로 커밋하지 않는다. dirty 트리를 만나면 pull을 건너뛰고 사용자에게 알리기만 한다.
- 무엇이 풀될지 미리 보고 싶으면 `--dry-run` 을 붙여 fetch만 하고 결과를 보여준 뒤 실제 실행한다.
