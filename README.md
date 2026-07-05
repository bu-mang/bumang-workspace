# bumang-workspace

여러 개인 사이드 프로젝트를 **한 층 위에서 관장하는 매니저 레이어**다. 개별 프로젝트의 코드가 아니라, 그 프로젝트들을 총괄하는 **AI 비서(포트폴리오 매니저)의 뇌**가 여기에 산다.

이 레포에는 하위 프로젝트의 소스가 들어있지 않다. 하위 프로젝트(ant-index·bumang-blog·zentarot…)는 각자 독립 git repo이고, 여기서는 `.gitignore` 화이트리스트로 제외된다. 이 레포가 담는 건 **매니저 레이어뿐** — 규칙(`CLAUDE.md`), 스냅샷(`PROJECTS.md`), 장기기억(`memory/`), 자동화(`.claude/`).

## 구조

```
bumang-workspace/
├── CLAUDE.md          # 매니저의 뇌 — 역할·경향·프로토콜
├── PROJECTS.md        # 포트폴리오 스냅샷 — 스택·상태·다음 할 일
├── memory/            # 비서의 장기기억 (보이고, 안 휘발됨)
│   ├── preferences.md #   유저 성향 · 매니저 행동 규칙
│   └── decisions/     #   프로젝트별·포트폴리오 의사결정 로그
└── .claude/
    ├── settings.json  # SessionStart 훅 등록
    ├── session-brief.sh   # 세션 시작 시 오늘자 활동 브리핑 생성
    ├── scripts/       # pull/push 유틸
    └── skills/        # /pull-all · /commit-all · /commit-push · /push-repo
```

## "비서"가 하는 일

Claude Code로 이 루트에서 세션을 열면, 개별 구현자가 아니라 **포트폴리오 매니저**로 동작한다.

- **회상** — 세션 시작 시 `SessionStart` 훅이 하위 레포의 오늘자 활동(🔥 활발 / 🌱 최근 멈춤 / 💤 휴면)을 git에서 즉석 생성해 브리핑으로 주입한다. 정적 문서가 아니라 매번 새로 계산되므로 절대 낡지 않는다.
- **포착** — 의사결정이 나오면 즉시 `memory/decisions/`에 append한다. 재생성 가능한 것(파일 트리·커밋 로그)은 저장하지 않고, **재생성 불가한 것(결정·이유·성향)**만 남긴다.
- **컨설팅** — 단일 프로젝트 질문이라도 다른 프로젝트와의 관계(중복 노력·이식 가능한 해법·스택 일관성)를 함께 본다.

## 스킬

이 루트에서 쓰는 자체 워크플로우. 하위 레포를 **동적 탐색**하므로 새 프로젝트를 추가해도 자동 포함된다.

| 스킬 | 하는 일 |
|---|---|
| `/pull-all` | 하위 레포 전부 안전 최신화 (`--ff-only`, dirty·diverged는 건너뜀) |
| `/commit-all` | 커밋 안 된 변경을 레포별로 커밋만 (비밀 점검·Conventional Commits) |
| `/commit-push` | 커밋 + 전부 push (커밋+푸시 통합 정본) |
| `/push-repo` | 지목한 레포 하나만 push |

## 관장 중인 프로젝트

스냅샷은 [`PROJECTS.md`](./PROJECTS.md) 참조.

| 프로젝트 | 한 줄 | 레포 |
|---|---|---|
| bumang-blog | 개인 블로그 + 포트폴리오 ([bumang.xyz](https://bumang.xyz)) | [orchestrator](https://github.com/bu-mang/bumang-blog-ochestrator) · [front](https://github.com/bu-mang/bumang-blog-front) · [backend](https://github.com/bu-mang/bumang-blog-backend) |
| ant-index | 주식 커뮤니티 심리 지표 (시총 트리맵 히트맵으로 피벗 중) | [ant-index](https://github.com/bu-mang/ant-index) |
| zentarot | 모바일 타로 앱 (애니메이션 중심) | [zentarot](https://github.com/bu-mang/zentarot) 🔒 |

> 🔒 = private repo (외부에서는 비공개).

---

_이 레포는 Claude Code와 함께 운영되는 실험적 "AI 매니저 레이어"다. 자세한 운영 규칙은 [`CLAUDE.md`](./CLAUDE.md)에 있다._
