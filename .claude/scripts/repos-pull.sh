#!/usr/bin/env bash
# 하위 레포 일괄 pull (--ff-only, 안전). dirty 트리·diverged·업스트림 없음은 건너뛰고 경고.
# 사용: repos-pull.sh [레포명부분일치] [--dry-run]
#   레포명 주면 그 레포만. --dry-run 이면 fetch만 하고 실제 pull 안 함(무엇이 풀될지 미리보기).
root="$HOME/Work/private"
dry=""; filter=""
for a in "$@"; do
  case "$a" in
    --dry-run) dry=1 ;;
    *) filter="$a" ;;
  esac
done

while IFS= read -r gitdir; do
  dir="${gitdir%/.git}"
  name="${dir#$root/}"; [ "$dir" = "$root" ] && name="(매니저 루트)"
  [ -n "$filter" ] && [[ "$name" != *"$filter"* ]] && continue
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null) || { echo "•  $name — detached HEAD, 건너뜀"; continue; }

  if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
    echo "⚠️  $name [$branch] — 작업 트리에 변경 있음, pull 건너뜀 (먼저 커밋/스태시)"
    continue
  fi

  git -C "$dir" fetch --quiet 2>/dev/null
  remote_rev=$(git -C "$dir" rev-parse @{u} 2>/dev/null)
  if [ -z "$remote_rev" ]; then
    echo "•  $name [$branch] — 업스트림 없음, 건너뜀"
    continue
  fi
  local_rev=$(git -C "$dir" rev-parse @ 2>/dev/null)
  if [ "$local_rev" = "$remote_rev" ]; then
    echo "✓  $name [$branch] — 이미 최신"
    continue
  fi
  ahead=$(git -C "$dir" rev-list --count @{u}..@ 2>/dev/null)
  behind=$(git -C "$dir" rev-list --count @..@{u} 2>/dev/null)
  if [ "${ahead:-0}" -gt 0 ]; then
    echo "⚠️  $name [$branch] — 로컬이 ${ahead}커밋 앞섬(diverged), --ff-only 불가 → 수동 처리 필요"
    continue
  fi
  if [ -n "$dry" ]; then
    echo "⬇️  $name [$branch] — ${behind}커밋 풀 받을 예정 (dry-run)"
    continue
  fi
  if git -C "$dir" pull --ff-only --quiet 2>/dev/null; then
    echo "⬇️  $name [$branch] — ${behind}커밋 pull 완료"
  else
    echo "✗  $name [$branch] — pull 실패"
  fi
done < <(find "$root" -maxdepth 3 -name .git -type d -not -path '*/node_modules/*' 2>/dev/null | sort)
exit 0
