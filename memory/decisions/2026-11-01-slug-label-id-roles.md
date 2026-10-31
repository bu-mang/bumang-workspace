---
name: 2026-11-01-slug-label-id-roles
description: 분류(그룹·카테고리·태그 등)는 id·slug·label의 역할을 나눈다 — 관계는 정수 id, 주소·코드 판정은 slug, 화면 이름은 label. bumang-blog 분류 개편에서 나온 규칙
metadata:
  type: decision
  scope: portfolio
  date: 2026-11-01
  status: 확정(bumang-blog 구현 완료·배포 전)
---

# 분류 키는 slug — id는 관계, label은 화면

**결정**

- 분류 데이터(그룹·카테고리·태그처럼 이름이 바뀔 수 있는 목록)에는 **`slug` 칸을 둔다**(소문자·숫자·하이픈, UNIQUE, 한 번 정하면 고정).
- 역할: **정수 id = DB 안의 관계(FK)에만** / **slug = URL 쿼리와 코드 판정**(`slug === 'life'`) / **label = 화면 이름**(언제든 바꿔도 됨).
- 글 같은 **콘텐츠 본체의 주소는 정수 id를 유지**한다(`/blog/116`) — 제목이 바뀌어도 링크가 안 깨지고, 한글 제목은 주소에 넣기 나쁘다.
- 첫 적용: bumang-blog 분류 개편(카테고리 29개 → 16개). 정본은 `bumang-blog/PLANNING.md`의 2026-11-01 항목.
- 블로그 안의 slug는 **규칙 한 벌**이다(분류 + 원래 있던 사용자 그룹): 소문자·숫자를 하이픈 하나로 잇기, 최대 50자, 비우면 이름에서 생성. 사용자 그룹의 느슨한 옛 규칙(`^[a-z0-9-]+$`, 직접 입력만)은 같은 날 이 규칙으로 맞췄다. 새 프로젝트도 이 한 벌로 시작한다.

**이유**

- **id를 주소에 쓰면**: 이름만 바꿔 id를 재활용할 때 예전 링크가 다른 뜻의 칸을 가리킨다. 또 로컬과 운영 DB에서 값이 달라 코드에 박을 수 없다.
- **label로 판정하면**: 화면 이름을 바꾸는 순간 기능이 깨진다. bumang-blog는 `label === 'Life'`로 dev/life 탭과 글 type을 정하고, 그룹 이름으로 기본 썸네일을 골랐다.
- 유저가 처음엔 "id 재활용으로 기존 링크를 살리는" 안을 생각했다가, 위 두 문제를 듣고 slug로 정했다.

**적용할 때의 함정**

- 기존 행 backfill: 이름에서 slug를 만들 때 **영문이 없는 이름(한글 태그)은 빈 값**이 된다 → `<접두어>-<id>`로, 겹치면 두 번째부터 `-<id>`.
- 생성 API: 한글 이름만 오고 slug가 없으면 **400으로 slug를 직접 받는다**(자동 음역 안 함).
- 수정 API: slug는 **명시했을 때만** 바꾼다(label만 고치면 slug 유지 = 링크 유지).
- TypeORM은 unique 제약 이름을 해시로 만든다 → 마이그레이션의 제약 이름을 `DefaultNamingStrategy`와 같게 맞춰야 dev synchronize가 제약을 지웠다 다시 만들지 않는다.
- **운영 DB 일회성 SQL은 로컬 리허설이 먼저**: 공개 API로 운영 모양 fixture를 만들어 docker postgres에서 마이그레이션 + SQL을 돌려 보고, 운영에서는 트랜잭션 + 검사 블록을 넣고 COMMIT은 사람이 한다.

**다른 프로젝트**: zentarot(카드·스프레드)·ant-index에 분류 목록이 생기면 같은 규칙으로 시작한다. Drizzle이면 `text('slug').notNull().unique()`.
