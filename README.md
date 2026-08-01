# 한자 차수 시험

엄마가 급수별 무작위 차수를 만들고, 윤우가 온라인 또는 인쇄 문제지로 연습하는 Next.js 앱입니다.

## 시작하기

1. Supabase Dashboard의 Data API 설정에서 `hanja` 스키마를 노출 스키마에 추가합니다. 테이블은 RLS와 권한 회수로 브라우저에 직접 공개되지 않습니다.
2. `.env.example`을 `.env.local`로 복사하고 값을 채웁니다.

```bash
cp .env.example .env.local
npm run dev
```

- `SUPABASE_SERVICE_ROLE_KEY`는 서버에서만 사용하며 절대 `NEXT_PUBLIC_` 변수로 만들지 않습니다.
- `MOM_PIN`에는 엄마가 기억하기 쉬운 숫자 PIN을 직접 넣습니다. `.env.local`은 Git에 포함되지 않습니다.
- `MOM_SESSION_SECRET`에는 충분히 긴 임의 문자열을 넣습니다.

## 데이터

`supabase/migrations/202608010002_correct_8geup_source_items.sql`은 원본 스캔 1페이지의 8급 뜻·음 50개 출제 자리를 다시 검수해 적재합니다. `口`이 원본에 두 번 있어 한자는 49개지만, 차수에는 50문항이 생성됩니다. 나머지 급수는 OCR 결과를 사람 검수한 뒤 같은 형식으로 추가하세요.

## 인쇄

엄마의 차수 상세 화면에서 `문제지 인쇄`를 선택하면 A4 인쇄 레이아웃이 열립니다. `PDF로 저장 · 인쇄` 버튼을 누른 뒤 브라우저 인쇄 대화상자에서 PDF로 저장하거나 프린터를 선택할 수 있습니다.
