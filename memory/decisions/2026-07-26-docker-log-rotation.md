---
name: 2026-07-26-docker-log-rotation
description: Docker Compose 개인 프로젝트는 전 서비스에 로그 로테이션 필수 — bumang-blog 502 장애(디스크 100% 포화)에서 도출
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-26
  status: 열림
---

# Docker Compose 프로젝트엔 로그 로테이션 필수

**인시던트**: bumang-blog가 **배포를 안 했는데 api 502**. 원인은 루트 디스크 20G **100% 포화** → 백엔드 앱 크래시 → nginx가 upstream(4001) 못 잡아 502. 진짜 범인은 **로테이션 없는 Docker `json-file` 로그의 무한 증식**: frontend 단일 로그 **7.6G** + nginx **1.6G**(backend는 매 요청 `console.log`로 412M). 컨테이너는 전부 `Up`이라 겉으론 멀쩡해 보였음. 메모리·OOM은 무관(1.1G 여유).

**긴급 복구**: 컨테이너 로그 truncate + `docker builder/image prune`(볼륨은 제외 — DB 안전)로 20G→7.5G 회수, 백엔드 재시작.

> ⚠️ **함정**: 백엔드 포트가 compose에서 `expose`만 돼(호스트 `4001` 미publish) `curl localhost:4001`은 **정상적으로** 실패한다 → 앱 죽음의 신호로 오독 금지. 실측은 nginx 경유 외부 curl로.

**근본 결정**: **Docker Compose를 쓰는 개인 프로젝트는 모든 서비스에 로그 로테이션을 건다.** bumang-blog엔 `docker-compose.prod.yaml`(백엔드 repo가 5개 컨테이너 전부 정의)에 `x-logging` YAML 앵커로 `max-size:10m·max-file:3` 정책을 정의하고 5개 서비스에 적용 → 로그 총량 상한 150MB. 커밋 `6cb6679`(로테이션)+`5ab9c24`(main.ts의 매요청 디버그 `console.log` 미들웨어 제거, Winston 인터셉터가 이미 있어 잔재였음). 배포+서버 전체 `up -d` 재생성으로 5개 컨테이너 LogConfig 적용 검증 완료.

**배포 함정(기록)**: 백엔드 Actions 워크플로우는 `docker-compose up -d app`(**app만**) 재생성이라, compose의 로깅 블록이 nginx·frontend·db·certbot엔 자동 적용 안 됨 → 배포 후 서버에서 **한 번 전체 `up -d`** 필요(SSH로 처리함). 신규 로깅/리소스 설정을 compose에 넣을 때 항상 유의.

## 🔴 열린 항목

- 같은 지뢰가 **ant-index**(Docker Compose)에도 있을 수 있음 — 로그 로테이션 걸렸는지 **점검 필요**.
- 서버 전역 `/etc/docker/daemon.json`에 기본 로테이션이 없으면 신규 컨테이너가 다 무방비 → 확인 필요.
- zentarot는 아직 배포 전이라 후순위.

**상태**: bumang-blog 확정·배포완료 / ant-index 점검은 **열린 항목**.

연결: [[bumang-blog]] · [[ant-index]]
