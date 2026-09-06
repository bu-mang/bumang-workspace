---
name: 2026-09-06-cloudflare-ssr-internal-route
description: Cloudflare 뒤 SSR은 백엔드를 공개 도메인으로 부르지 말고 내부 주소로 직행 — cf-connecting-ip를 달고 Cloudflare를 재통과하면 403(error 1000)
metadata:
  type: decision
  scope: portfolio
  date: 2026-09-06
  status: 확정
---

# Cloudflare 뒤에서 SSR → 백엔드는 내부 주소로 직행한다

**인시던트(bumang-blog)**: 감사 로그에 방문자 IP를 정확히 남기려고 SSR `serverFetch`가 `cf-connecting-ip` 등 방문자 헤더를 백엔드로 전달하게 했는데, SSR이 백엔드를 **공개 도메인(`api.bumang.xyz`)** 으로 부르고 있어 그 요청이 Cloudflare 엣지를 다시 통과했다. **Cloudflare는 외부에서 들어온 요청에 `cf-connecting-ip`가 이미 붙어 있으면 값과 무관하게 403(error code 1000)** 으로 거절한다 → 프로덕션 글 상세 SSR 전면 실패(로그인 여부 무관). 로컬엔 그 헤더가 없어 재현이 안 됐다.

**결정 (포트폴리오 공통 규칙)**: 프론트와 백엔드가 같은 호스트/compose 네트워크에 있으면 **서버 사이드 호출은 서비스명 내부 주소(`http://app:4001` 류)** 로 간다. 인터넷→Cloudflare→nginx를 한 바퀴 돌아 옆 컨테이너로 들어오는 건 지연 낭비이자, Cloudflare가 중간에 끼어 헤더 제약이 생기는 원인이다. 브라우저용 공개 주소(`NEXT_PUBLIC_*`)와 서버용 내부 주소(런타임 env, 서버 전용)를 **분리**한다. bumang-blog 구현: 프론트 `serverFetch`가 `API_INTERNAL_URL`로 프리픽스 스왑, compose `frontend.environment`에서 주입.

> ⚠️ **함정 3개**
> 1. `cf-connecting-ip`는 **Cloudflare를 거치지 않는 경로에서만** 전달한다. 공개 경로로 나갈 땐 지워라 — 방어적으로 코드에 박아두면 env 누락·배포 순서 꼬임에도 장애로 안 돌아간다.
> 2. `fetch` 실패 body를 `json()` 실패 후 `text()`로 다시 읽으면 "Body is unusable" TypeError가 원래 status를 덮는다 → 401/403 분기가 죽고 증상이 "영원한 로딩"으로 위장된다. 텍스트로 한 번 읽고 JSON 파싱.
> 3. 내부 직행 전엔 백엔드 레이트리밋이 SSR 트래픽을 서버 공인 IP 하나로 묶어 봤다(전역 공용 버킷). 내부 직행 + 헤더 전달이 이걸 방문자별로 푼다.

**상태**: bumang-blog 코드 수정·로컬 검증 완료, 배포 대기. 상세는 `bumang-blog/PLANNING.md` 2026-09-06 항목.

연결: [[bumang-blog]] · [[2026-07-26-docker-log-rotation]](배포는 app만 재생성 → compose env 변경은 순서 주의)
