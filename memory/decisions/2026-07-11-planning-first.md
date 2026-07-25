---
name: 2026-07-11-planning-first
description: 방법론 전환 — "코드 제로투원"을 버리고 기획 구체화 우선으로. 기획 정본은 각 repo의 PLANNING.md
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-11
  status: 확정
---

# 방법론 전환 — "코드 제로투원"에서 "기획 구체화 우선"으로

**결정**: 새 사이드 프로젝트를 곧장 코드로 제로투원 하려던 성향을 버린다. **기획을 먼저 구체화**하고, 각 프로젝트별로 **기획 히스토리를 축적**한다. 코드 착수는 기획이 여문 뒤.

**이유**: (유저 소견) 지금까지 바로 코드부터 짜는 데 집착했지만, 기획 구체화가 더 중요하다는 판단. **관찰 신호가 이를 뒷받침**: ant-index(6주 휴면)·zentarot(3주+ 멈춤) 둘 다 코드 PoC까진 갔으나 기획·에셋·방향이 안 여물어 정체. "코드 먼저"의 대가가 포트폴리오에 찍혀 있다.

**축적 위치 (확정)**: **각 프로젝트 repo의 `<project>/PLANNING.md`** — 최신이 위로 오는 날짜순 append(`## YYYY-MM-DD · 제목` / 문제 → 선택지 → 결정·이유). 코드와 함께 버전관리되고 "정본은 현장"과 일관. 매니저는 on-demand로 참조.
**하이브리드**: repo가 아직 없는 초기 아이디어는 매니저 memory에 임시로 두다가, repo가 생기면 그 repo의 PLANNING.md로 이관.

**기획 결정 vs 실행 결정**:
- 기획(무엇을·왜 만들지, 방향·범위) → `<project>/PLANNING.md`
- 실행·아키텍처 결정 → 각 repo의 `CLAUDE.md`(커밋 해시 첨부)
- 크로스프로젝트 결정 → 매니저 `memory/decisions/`

**정본 이관 완료(2026-07-11)**: 3개 repo에 `PLANNING.md`를 스캐폴딩하고, 기존에 매니저 memory에 고여 있던 프로젝트별 핵심 결정을 각 repo의 PLANNING.md로 옮겼다. 매니저 `memory/decisions/{ant-index,zentarot,bumang-blog}.md`는 **포인터+종합**으로 축소(정본 이중화 제거).

**상태**: 확정 (방향 + 메커니즘 + 이관 완료).

연결: [[../preferences]] · [[2026-07-06-thin-lens-boundary]]
