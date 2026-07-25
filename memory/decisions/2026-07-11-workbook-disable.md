---
name: 2026-07-11-workbook-disable
description: 회사 workbook 플러그인을 개인 레포 4곳 전부에서 비활성화 — 설정은 상위로 캐스케이드 안 되므로 각각 필요
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-11
  status: 확정
---

# workbook 플러그인을 개인 작업공간 전체에서 비활성화

**결정**: 회사 워크북 플러그인(`workbook@workbook`)을 개인 레포 **네 곳 전부**의 `.claude/settings.json` `enabledPlugins`에 `false`로 박음 — bumang-workspace 루트 + bumang-blog + ant-index + zentarot. cpf/camfit 차단 선례와 동일한 위치·방식.

**왜 네 곳 다**: 프로젝트 설정은 세션의 프로젝트 루트에서 읽히고 **상위로 캐스케이드 안 됨**(cpf/camfit이 네 곳에 전부 복제돼 있던 게 그 증거). 루트에만 넣으면 하위 레포에서 직접 연 세션엔 안 먹는다.

**이유**:
- (a) "workbook을 개인 레포에 겹쳐 쓰지 않음"([[2026-07-06-thin-lens-boundary]] 6번)의 강화 — 겹쳐 안 쓰는 수준을 넘어 로드 자체를 차단.
- (b) 워크북이 개인 세션에서까지 자동으로 스킬 번들 설치(`vercel-react-best-practices`)를 하는 걸 확인 → 개인 영역 오염.
- (c) 추적 위험은 낮음(워크북 로깅 훅은 전부 `workbook/` 디렉토리 게이트, 개인 경로엔 없어 즉시 exit 0, 네트워크 호출도 없음) — 그래도 자동설치·자동로드 자체가 불필요.

**예외**: `vercel-react-best-practices`는 **유지**. `~/.agents/skills/`에 실체 + `~/.claude/skills/`에 심링크로 이미 독립 설치돼 워크북과 무관하게 전역 상시 로드됨.

**상태**: 확정 · 발효 완료(플러그인 enablement는 세션 재시작 필요).

연결: [[../preferences]] · [[2026-07-12-plugin-optout-per-repo]]
