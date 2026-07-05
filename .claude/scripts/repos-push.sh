#!/usr/bin/env bash
# 하위 레포 push. 현재 브랜치의 커밋을 업스트림에 올린다 (force 없음, 안전).
# 사용: repos-push.sh [레포명부분일치] [--dry-run]
#   레포명 주면 그 레포만; 없으면 전부. --dry-run 이면 push할 커밋만 보여주고 실제로는 안 올림.
root="$HOME/Work/private"
dry=""; filter=""
for a in "$@"; do
  case "$a" in
    --dry-run) dry=1 ;;
    *) filter="$a" ;;
  esac
done

pushed_any=""
while IFS= read -r gitdir; do
  dir="${gitdir%/.git}"
  name="${dir#$root/}"; [ "$dir" = "$root" ] && name="(매니저 루트)"
  [ -n "$filter" ] && [[ "$name" != *"$filter"* ]] && continue
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null) || { echo "•  $name — detached HEAD, 건너뜀"; continue; }
  upstream=$(git -C "$dir" rev-parse --abbrev-ref @{u} 2>/dev/null)
  if [ -z "$upstream" ]; then
    echo "⚠️  $name [$branch] — 업스트림 없음 (git push -u origin $branch 필요), 건너뜀"
    continue
  fi
  ahead=$(git -C "$dir" rev-list --count @{u}..@ 2>/dev/null)
  if [ "${ahead:-0}" -eq 0 ]; then
    echo "✓  $name [$branch] — push할 커밋 없음"
    continue
  fi
  pushed_any=1
  echo "── $name [$branch] → $upstream : ${ahead}커밋"
  git -C "$dir" log --oneline @{u}..@ 2>/dev/null | sed 's/^/     /'
  if [ -z "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then :; else
    echo "     (참고: 커밋 안 된 변경도 있음 — push엔 포함 안 됨)"
  fi
  if [ -z "$dry" ]; then
    if git -C "$dir" push --quiet 2>/dev/null; then
      echo "     ⬆️  push 완료"
    else
      echo "     ✗  push 실패"
    fi
  fi
done < <(find "$root" -maxdepth 3 -name .git -type d -not -path '*/node_modules/*' 2>/dev/null | sort)

[ -z "$pushed_any" ] && echo "→ push할 게 있는 레포 없음."
[ -n "$dry" ] && [ -n "$pushed_any" ] && echo "" && echo "(dry-run — 실제 push 안 함. 확인되면 --dry-run 빼고 다시 실행)"
exit 0
