#!/usr/bin/env bash
# 개인계정(bu-mang) push 래퍼.
# 이 루트의 레포는 전부 bu-mang(개인) 소유인데, 이 머신 기본 gh 활성계정은 bhjeong-camfit(회사)이고
# 셸에 GITHUB_TOKEN(회사 토큰)이 깔려 있어 그냥 push하면 403이 난다.
# 해법: (1) GITHUB_TOKEN을 이 프로세스에서만 unset  (2) gh 활성계정을 bu-mang으로 switch
#       (3) repos-push.sh 로 push  (4) 무슨 일이 있어도 원래 계정으로 복원(trap).
# 인자는 repos-push.sh 로 그대로 전달 (레포명 필터 / --dry-run).
#
# 주의: ~/.zshrc 의 GITHUB_TOKEN(회사 토큰, Camfit setup.sh 산물)은 절대 지우지 않는다 —
#       여기선 이 스크립트 실행 동안만 unset 한다.
set -o pipefail
root="$HOME/Work/private"
scripts="$root/.claude/scripts"

# 원래 활성계정 기억 (복원용). 못 읽으면 회사 계정으로 폴백.
orig=$(gh auth status 2>&1 | grep -B3 'Active account: true' | grep -oE 'account [A-Za-z0-9-]+' | awk '{print $2}' | head -1)
[ -z "$orig" ] && orig="bhjeong-camfit"

restore() {
  gh auth switch --user "$orig" >/dev/null 2>&1 && echo "🔁 활성계정 복원: $orig"
}
trap restore EXIT

unset GITHUB_TOKEN GH_TOKEN

if ! gh auth switch --user bu-mang >/dev/null 2>&1; then
  echo "❌ bu-mang 계정으로 전환 실패 — gh 키링에 bu-mang 로그인이 없을 수 있음."
  echo "   본인 터미널에서: unset GITHUB_TOKEN && gh auth login (bu-mang 으로 승인) 후 재시도."
  exit 1
fi

who=$(gh api user -q .login 2>/dev/null)
if [ "$who" != "bu-mang" ]; then
  echo "❌ 인증 계정이 bu-mang이 아님(현재: ${who:-불명}) — 안전상 중단."
  exit 1
fi
echo "🔑 인증 계정: bu-mang"
echo ""

bash "$scripts/repos-push.sh" "$@"
