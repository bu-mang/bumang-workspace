---
name: 2026-07-12-plugin-optout-per-repo
description: 회사 플러그인 차단은 레포별 opt-out(각 repo에 false) 유지 — 전역 false + 회사 repo만 true로 뒤집는 안은 기각
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-12
  status: 확정
---

# 회사 플러그인 차단 구조: 레포별 opt-out 유지 (전역 반전안 기각)

**결정**: 회사 플러그인 차단은 지금처럼 **각 개인 레포의 `.claude/settings.json`에 `false`**로 유지한다. Claude가 제안한 반전 구조(전역 `false` + 회사 레포에서만 `true`)는 **기각**.

**이유**: (유저) 회사 레포를 만들 때마다 `true`를 켜야 하는 걸 잊는 쪽이 더 위험하다. 개인 레포는 어차피 생성 절차(`CLAUDE.md` "새 프로젝트 추가")에 차단 추가를 포함시키면 된다. — 즉 **실수했을 때 피해가 작은 방향으로 기본값을 잡는다.**

**점검 결과(같은 날)**: cpf에는 세션 대화록을 회사 서버로 업로드하는 Stop 훅이 있어 이 차단이 실질 방어선임을 확인. 개인 레포 전수 점검 결과 7-11 차단이 이미 전부 깔려 있었고, 유일한 사각지대였던 **bumang-blog 하위 레포 2곳(front/backend)의 `workbook` 차단 누락을 보완**.

**운영 규칙**: 새 개인 레포 추가 시 `.claude/settings.json`에 3종 차단(`cpf@camfit-plugins`, `camfit-admin-plugin@camfit-plugins`, `workbook@workbook` 전부 `false`)을 함께 스캐폴딩한다. **하위에 중첩된 독립 repo도 각각 필요**(설정은 상위로 캐스케이드 안 됨).

**상태**: 확정.

연결: [[../preferences]] · [[2026-07-11-workbook-disable]]
