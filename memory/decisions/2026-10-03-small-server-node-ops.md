---
name: 2026-10-03-small-server-node-ops
description: 작은 EC2(1~2GB)에서 Node 컨테이너를 돌릴 때의 공통 규칙 — 힙 상한·진단 리포트·코어 덤프 기록만·빌드된 JS로 마이그레이션·Next standalone엔 sharp 필수·한도 붙은 컨테이너 안에서 진단 금지
metadata:
  type: decision
  scope: portfolio
  date: 2026-10-03
  status: 확정
---

# 작은 서버에서 Node 컨테이너를 운영하는 규칙

**계기(bumang-blog, 2026-10-02~03)**: "블로그가 느리다"에서 시작해 하루 동안 이미지·인증·메모리·인프라를 정리하고 EC2를 t4g.small → t4g.micro로 내렸다. 그 과정에서 프로젝트를 가리지 않고 재사용할 규칙이 나왔다. 프로젝트 고유 결정의 정본은 `bumang-blog/PLANNING.md` 2026-10-02~03 항목.

**결정 (Node 백엔드·Next 프론트를 Docker로 작은 서버에 올리는 모든 프로젝트)**

1. **실행 옵션은 `command`에, `NODE_OPTIONS`에 넣지 않는다.** 배포 때 같은 서비스로 도는 마이그레이션 등이 물려받지 않게.
   - `--max-old-space-size`를 컨테이너 한도보다 낮게(예: 한도 256MB → 백엔드 192, 프론트 160). 없으면 V8이 한도를 모른 채 쓰다가 스왑에 빠져 죽지도 못하고 멈춘다. 상한이 있으면 "heap out of memory"로 깔끔히 죽고 재시작된다.
   - `--report-on-fatalerror --report-uncaught-exception --report-dir=…` + **`--report-exclude-env` 필수**. 없으면 리포트에 환경변수(DB 비밀번호·JWT 키)가 통째로 담긴다.
2. **로그·리포트는 호스트 디렉토리에 마운트.** 컨테이너 안에 두면 재배포 때 사라져 "왜 죽었는지"를 뒤늦게 못 본다(bumang-blog 9월 비정상 종료 3건의 원인을 이래서 못 찾음). 크기는 winston `maxsize·maxFiles`로 묶는다.
3. **systemd-coredump는 기록만**(`Storage=none`, `ProcessSizeMax=0`). 덤프를 쓰는 동안 죽은 프로세스가 정리되지 않아 재시작이 몇 분씩 늦어진다(bumang-blog: 4분 16초 API 중단). 죽은 시각·시그널은 `coredumpctl list`에 남는다.
4. **프로덕션 마이그레이션은 빌드된 JS로.** ts-node는 TypeScript 컴파일러와 앱 전체 타입 정보까지 올려 256MB를 꽉 채웠다(빌드된 JS는 26MB·1초). 로컬 개발용 ts-node 스크립트는 따로 둔다.
5. **Next `output: "standalone"`이면 `sharp`를 의존성에 넣는다.** 없으면 `/_next/image`가 에러 없이 원본을 그대로 내보낸다(판별: 폭을 바꿔도 `content-length`가 같다). 넣은 뒤엔 `deviceSizes` 최댓값을 화면에 필요한 만큼(2048)으로 줄이고, libvips 메모리 캐시는 끄는 걸 검토(서버 시작 훅에서 `sharp.cache(false)`).
6. **수집 서버 없는 지표 라이브러리는 끈다.** prom-client 같은 pull 방식은 아무도 안 읽어도 메모리에 쌓는다. 켤 거면 라벨에 실제 URL이 아니라 라우트 패턴을 쓴다.
7. **한도에 붙어 있는 프로덕션 컨테이너 안에서 진단용 프로세스(`docker exec … node -e`)를 띄우지 않는다.** 그 한 번이 본체를 죽인다. 관찰은 호스트의 cgroup 파일(`/sys/fs/cgroup/…/memory.*`)이나 다른 컨테이너에서 한다.
8. **서버를 1년씩 재부팅하지 않으면 커널 회수 불가 메모리가 쌓인다**(bumang-blog: 224MB → 재부팅 후 51MB). 인스턴스를 줄이기 전에 한 번 재부팅하고 잰다. 재부팅 전 모든 컨테이너에 `restart:` 정책이 있는지 확인(certbot이 빠져 있었다).
9. **Amazon Linux 2023은 릴리스에 고정돼 `dnf upgrade`만으로는 보안 패치가 안 들어온다.** `dnf upgrade --releasever=latest` + 커널이 바뀌면 재부팅을 **systemd 타이머로 월 1회** 돌린다(bumang-blog: 매월 첫째 일요일 04:00 KST, 업데이트 전 DB 덤프, 재부팅 후 응답 확인). 컨테이너를 새로 띄우는 것으로는 커널·OS 층이 갱신되지 않는다.

**엣지(Cloudflare 뒤에 오리진이 있는 경우)**: 봇 차단은 앱 미들웨어가 아니라 Cloudflare WAF 커스텀 규칙에서, 오리진 보안 그룹 80·443은 Cloudflare IP 대역만 허용. 그래야 WAF를 우회하는 직접 접속이 막힌다. 이로써 [[2026-07-26-aws-account-hygiene]]의 "오리진 IP 노출" 위험은 실질적으로 닫혔다(IP를 알아도 80·443에 직접 닿지 않음).

**상태**: bumang-blog 전부 적용·배포 완료. ant-index·zentarot는 배포할 때 이 목록으로 점검.

연결: [[bumang-blog]] · [[2026-07-26-docker-log-rotation]] · [[2026-09-06-cloudflare-ssr-internal-route]]
