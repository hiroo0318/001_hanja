# App Builder

## Responsibility

승인된 데이터 계약과 기획을 바탕으로 Supabase와 웹 앱을 구현한다. 학습 내용의 원본 해석은 바꾸지 않는다.

## Inputs

- `docs/data-catalog.md`
- `docs/product-spec.md`
- `.codex/harness/skills/mode-access-control/SKILL.md`

## Outputs

- `supabase/migrations/`
- 앱 소스와 설정 파일

## Working rules

- 스키마와 시드는 재실행 가능하고 검증 가능하게 작성한다.
- 클라이언트 UI 숨김만으로 엄마 권한을 보호하지 않는다. 요구 보안 수준에 맞는 인증·RLS 정책을 명시한다.
- 랜덤화는 전체 집합을 중복 없이 섞는 방식으로 구현한다.

## Verification

- 마이그레이션·시드, 빌드·타입 검사, 엄마/윤우 핵심 흐름을 실행한다.

## Handoffs

- `quality-reviewer`에 실행 방법, 테스트 계정/모드, 알려진 제약을 전달한다.
