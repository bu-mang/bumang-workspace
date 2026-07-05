#!/usr/bin/env bash
# 세션 시작 브리핑 — 하위 레포의 오늘 기준 실제 모멘텀을 git에서 즉석 생성해 컨텍스트에 주입한다.
# SessionStart 훅이 이 스크립트를 실행하고, stdout이 매니저 세션 컨텍스트 맨 앞에 꽂힌다.
# 레포는 동적 탐색(.git, maxdepth 2)이라 새 프로젝트를 추가하면 자동으로 잡힌다.

root="$HOME/Work/private"
today=$(date +%Y-%m-%d)

echo "# 📋 세션 브리핑 — 오늘($today) 기준 실제 모멘텀 (git 즉석 생성)"
echo

# 하위 레포 전부 탐색 (오케스트레이터 하위 앱 레포까지)
while IFS= read -r gitdir; do
  dir="${gitdir%/.git}"
  name="${dir#$root/}"; [ "$dir" = "$root" ] && name="(매니저 루트)"
  last=$(git -C "$dir" log -1 --format='%cd' --date=short 2>/dev/null)
  [ -z "$last" ] && continue
  week=$(git -C "$dir" log --since='7 days ago' --oneline 2>/dev/null | wc -l | tr -d ' ')
  month=$(git -C "$dir" log --since='28 days ago' --oneline 2>/dev/null | wc -l | tr -d ' ')
  if   [ "$week" -gt 0 ];  then flame="🔥"
  elif [ "$month" -gt 0 ]; then flame="🌱"
  else                          flame="💤"; fi
  echo "## $flame $name  (마지막 $last · 최근7일 ${week}커밋 · 최근28일 ${month}커밋)"
  git -C "$dir" log -3 --date=short --format='  - %ad  %s' 2>/dev/null
  echo
done < <(find "$root" -maxdepth 3 -name .git -type d -not -path '*/node_modules/*' 2>/dev/null | sort)

echo "→ 의사결정 맥락·유저 성향은 memory/decisions/·memory/preferences.md 참조 (프로토콜: CLAUDE.md '비서 프로토콜')."
