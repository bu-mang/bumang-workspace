# 의사결정 — bumang-blog

개인 블로그 + 포트폴리오 (bumang.xyz). 최신이 맨 위.
정본 매니저: `bumang-blog/CLAUDE.md`(오케스트레이터) + 하위 `bumang-blog-{front,backend}/CLAUDE.md` · 포트 4000/4001

### 스택 이탈 · TypeORM 유지 (Drizzle 아님)
- **결정**: 포트폴리오에서 유일하게 **TypeORM** 사용. 스택 시그니처(Drizzle)에서 벗어남.
- **이유**: 가장 오래되고 성숙한 프로젝트라 그 시절 선택이 굳어짐. 연결: [[portfolio]]
- **상태**: 확정 (의도된 역사적 이탈)

### Drizzle 이관은 보류
- **결정**: TypeORM → Drizzle 이관은 **지금 하지 않음**.
- **이유**: 운영 중(bumang.xyz 라이브)이라 이관 리스크가 큼. "언젠가의 부채 정리 후보"이나 급하지 않음.
- **상태**: 보류 (부채로 인지, 우선순위 낮음)

### 성격 / 배포
- 오케스트레이터 레포 1개 + 독립 앱 레포 2개(front/backend), 각각 별도 git.
- 배포: EC2(ap-northeast-2) + Docker + GitHub Actions → `bumang.xyz` / `api.bumang.xyz`.
- 모멘텀: 포트폴리오 중 가장 뜨거움(front 603 / backend 222 / 오케 11 커밋, 07-05 작업).
