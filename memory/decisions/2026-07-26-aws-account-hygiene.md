---
name: 2026-07-26-aws-account-hygiene
description: 2024년 Elastic Beanstalk 잔재(Bumang-ket-env) 정리 — 관리형 서비스는 인스턴스가 아니라 부모를 지운다. 블로그 오리진은 별개 계정이며 식별 절차를 기록
metadata:
  type: decision
  scope: portfolio
  date: 2026-07-26
  status: 열림
---

# AWS 계정 위생 — EB 잔재 정리와 블로그 오리진 식별

## 발단

EC2 콘솔에 `Bumang-ket-env`(t2.micro, ap-northeast-2a)가 떠 있는 걸 발견. **"블로그 서버인가?"** 판단이 안 서서 조사했고, 지우려 했더니 **종료해도 계속 새로 생겼다**(종료된 인스턴스가 4개까지 쌓임).

## 결론 1 — 블로그와 무관했다

`Bumang-ket-env`는 **2024년 8월에 만든 Elastic Beanstalk 환경**이었다. 애플리케이션 `bumang-ket`, 플랫폼 **Node.js 1x**(이미 지원 중단), 티어 WebServer. 약 2년간 t2.micro 하나가 계속 돌고 있었다.

**경위(유저 확인)**: Elastic Beanstalk이라는 게 있다는 걸 알고 **학습 삼아 배포 실험을 해본 뒤 그대로 방치**한 것. 의도적으로 운영하던 리소스가 아니다. → 같은 시기에 **다른 서비스도 실험했을 수 있다**는 뜻이라, 아래 "타 리전 잔재 점검"이 형식적 항목이 아니다.

## 결론 2 — 관리형 서비스는 인스턴스가 아니라 **부모**를 지운다

**EC2 인스턴스를 종료하는 건 소용없다.** Elastic Beanstalk은 내부에 Auto Scaling Group을 두고 인스턴스가 사라지면 즉시 재생성한다. 종료된 껍데기만 쌓인다.

- **판별법**: 인스턴스 → 태그 탭. `elasticbeanstalk:environment-name`이 있으면 EB, `aws:autoscaling:groupName`만 있으면 순수 ASG.
- **이름 힌트**: 끝의 **`-env` 접미사가 EB 환경의 네이밍 관례**다. 이것만 봐도 거의 확정.
- **해법**: EB면 **환경 종료(Terminate environment)**, ASG면 **그룹 삭제**(급하면 희망 용량 0). 부모를 지우면 EC2는 알아서 종료된다.
- **결과 검증(완료)**: 환경 종료 후 EC2 4개 전부 `종료됨`, **탄력적 IP 0개**(EB가 회수) 확인.

## 블로그 오리진을 식별하는 절차 (다음에 또 헷갈릴 지점)

`bumang.xyz`·`api.bumang.xyz`는 **Cloudflare 프록시**라 `dig`하면 CF IP(`172.67.*`, `104.21.*`)만 나온다. **DNS로는 오리진을 못 찾는다.** 대신 이렇게 확정했다.

1. **오리진 주소의 출처**: `bumang-blog-backend/README.md`의 SSH 접속 예시. (배포 워크플로우의 호스트는 GitHub Actions 시크릿 `EC2_HOST`라 레포엔 없다.)
2. **확증 방법**: 그 IP에 `curl -k -H 'Host: api.bumang.xyz'` → 200, `openssl s_client`로 인증서 subject가 `CN=bumang.xyz`인지 확인. 서버 헤더는 `nginx/1.31.2`.
3. **스펙 대조**: 블로그는 **t4g.small(ARM64, 2GB)**이다. 컨테이너 메모리 할당만 900MB가 넘어 **t2.micro(1GB)에선 애초에 못 돈다.** 인스턴스 타입만 봐도 구분된다.

## ⚠️ 계정이 다르다

정리 작업을 한 계정은 **`bumang` 개인 계정 / 서울 리전**인데, 그 계정·리전의 인스턴스 목록에 **실행 중인 블로그 서버가 없었다.** 블로그 오리진은 같은 `ap-northeast-2`인데도 안 보였다.

→ **블로그는 다른 AWS 계정에서 돌고 있다**(또는 목록에 필터가 걸려 있었다). 미확정이지만, **장애 대응으로 급하게 콘솔을 열 때 엉뚱한 계정에서 찾아 헤맬 수 있는 지점**이다. 2026-07-26 502 같은 상황에서 특히 위험. (계정 ID는 이 레포가 public이라 기록하지 않는다.)

## 비용 (추정 — 실측 아님)

| 항목 | 월 |
|---|---:|
| t2.micro 온디맨드(서울) | 약 $10.5 |
| EBS 8GB | 약 $0.9 |
| **퍼블릭 IPv4 주소** | 약 $3.6 |
| **합계** | **약 $15** |

**함정**: AWS는 **2024년 2월부터 모든 공인 IPv4 주소에 시간당 과금**을 시작했다. 예전엔 인스턴스에 붙어 있으면 무료였다. 이 환경은 그 직후인 2024년 8월 생성이라 전 기간 해당된다.

총액은 프리티어 적용 여부에 따라 **$170~370** 범위로 추정된다. 실측은 `Billing → 청구서(Bills)`에서 월별로 확인해야 한다(Cost Explorer는 기본 12~13개월치만 보임).

## 🔴 열린 항목

- **[보안] 블로그 오리진 IP가 public 레포에 노출돼 있다.** `bu-mang/bumang-blog-backend`(PUBLIC)의 `README.md` SSH 접속 예시 2줄에 오리진 IP가 그대로 있다. Cloudflare로 오리진을 숨긴 목적(크롤러·DDoS 차단)이 무력화된다. 플레이스홀더로 교체 필요. — 참고: `key-of-bumang-blog.pem`은 `.gitignore`의 `*.pem`으로 차단돼 있고 원격에도 없음(404) **✅ 안전**.
- **실제 청구액 확인** — 청구서에서 2024-08부터 월별 EC2 금액 합산.
- **예산 알림 설정** — `Billing → Budgets`에 월 $20 정도. 이번 건의 본질은 t2.micro가 비싼 게 아니라 **돈이 나가는 걸 아무도 안 본 것**이다.
- **타 리전 잔재 점검** — 콘솔은 리전별로만 보여준다. `AWS Global View`로 전 리전 확인.
- **EB 잔여 정리** — 애플리케이션 `bumang-ket` 삭제, 고아 EBS 볼륨(`사용 가능` 상태) 확인, `elasticbeanstalk-ap-northeast-2-*` S3 버킷.

**상태**: EB 환경 종료·EIP 회수는 **완료**. 위 5건은 **열림**.

연결: [[2026-07-26-docker-log-rotation]] · [[bumang-blog]]
