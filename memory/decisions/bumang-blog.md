# 의사결정 — bumang-blog

개인 블로그 + 포트폴리오 (bumang.xyz). 최신이 맨 위.
정본 매니저: `bumang-blog/CLAUDE.md`(오케스트레이터) + 하위 `bumang-blog-{front,backend}/CLAUDE.md` · 포트 4000/4001

### 2026-07-11 · 블로그 삽화용 다이어그램 생성 — 레시피 확립, 스킬화는 보류
- **결정**: 블로그 글 중간에 넣을 다이어그램 이미지를 Claude가 뽑는 워크플로를 확립. **스킬화(`/diagram` 류)는 아직 안 만들고**, 여러 번 손으로 써보며 패턴을 관찰한 뒤 제작. (portfolio 결정 #5 "자동화는 필요 증명 후, 3번+ 쌓이면 제작"과 같은 태도.)
- **성공한 레시피** (재현용):
  1. **SVG를 손으로 작성** — 박스+커넥터 트리. 자체 배경 패널(off-white `#fbfaf8`)을 깔아 라이트/다크 블로그 배경 어디든 얹힘. 한글은 `font-family`에 `'Apple SD Gothic Neo'` 포함.
  2. **래스터화는 Chrome headless로**: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --force-device-scale-factor=2 --window-size=W,H --screenshot=out.png "file://…​.svg"` → 2x 선명본.
  3. ⚠️ **`qlmanage -t`는 쓰지 말 것** — SVG를 정사각형으로 크롭해 오른쪽이 잘림(이번에 잘려 보인 원인. "2x가 이상"이 아니라 qlmanage 문제였음).
  4. 렌더 결과는 **Read 툴로 이미지 확인**해 검증.
- **산출물 보관**: 원본 SVG는 **`bumang-blog/drafts/assets/`**에 둔다(git 추적됨, 초안 옆). scratchpad(`/private/tmp/...`)는 세션 청소로 날아가므로 임시로만. 발행은 SVG/PNG를 **BlockNote 에디터에 드래그 업로드**(→ 백엔드/S3), public/ 에 두지 않음.
- **첫 사례**: AI-Workspace 매니저 → 3개 독립 프로젝트(bumang-blog·zentarot·ant-index) 트리 다이어그램. `drafts/assets/workspace-diagram.{svg,png}`.
- **상태**: 레시피 확정 · 스킬화 보류(usage 축적 중) · 미커밋
- 연결: [[portfolio]]

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
