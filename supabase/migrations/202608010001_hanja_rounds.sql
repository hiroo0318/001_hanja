create schema if not exists hanja;

create table if not exists hanja.grades (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  sort_order integer not null unique,
  created_at timestamptz not null default now()
);

create table if not exists hanja.characters (
  id uuid primary key default gen_random_uuid(),
  grade_id uuid not null references hanja.grades(id) on delete cascade,
  glyph text not null check (char_length(glyph) = 1),
  meaning text not null,
  reading text not null,
  source_document text not null,
  source_page integer not null check (source_page > 0),
  source_text text,
  created_at timestamptz not null default now(),
  unique (grade_id, glyph)
);

create type hanja.round_status as enum ('ready', 'in_progress', 'completed');
create type hanja.attempt_status as enum ('in_progress', 'completed');
create type hanja.answer_result as enum ('correct', 'incorrect');

create table if not exists hanja.exam_rounds (
  id uuid primary key default gen_random_uuid(),
  grade_id uuid not null references hanja.grades(id) on delete restrict,
  round_number integer not null,
  title text not null,
  timer_seconds integer check (timer_seconds is null or timer_seconds > 0),
  status hanja.round_status not null default 'ready',
  created_at timestamptz not null default now(),
  unique (grade_id, round_number)
);

create table if not exists hanja.exam_round_items (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references hanja.exam_rounds(id) on delete cascade,
  character_id uuid not null references hanja.characters(id) on delete restrict,
  position integer not null check (position > 0),
  unique (round_id, position),
  unique (round_id, character_id)
);

create table if not exists hanja.exam_attempts (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null unique references hanja.exam_rounds(id) on delete cascade,
  learner text not null default '윤우',
  current_position integer not null default 1 check (current_position > 0),
  started_at timestamptz,
  completed_at timestamptz,
  status hanja.attempt_status not null default 'in_progress',
  created_at timestamptz not null default now()
);

create table if not exists hanja.exam_answers (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references hanja.exam_attempts(id) on delete cascade,
  round_item_id uuid not null references hanja.exam_round_items(id) on delete cascade,
  result hanja.answer_result,
  checked_at timestamptz,
  unique (attempt_id, round_item_id)
);

create index if not exists characters_grade_idx on hanja.characters(grade_id);
create index if not exists round_items_round_idx on hanja.exam_round_items(round_id, position);
create index if not exists answers_attempt_idx on hanja.exam_answers(attempt_id);

create or replace function hanja.create_exam_round(
  requested_grade_id uuid,
  requested_timer_seconds integer default null
) returns uuid
language plpgsql
security invoker
set search_path = hanja, public
as $$
declare
  new_round_id uuid;
  next_number integer;
  grade_label text;
  character_total integer;
begin
  select name into grade_label from grades where id = requested_grade_id;
  if grade_label is null then
    raise exception 'Grade not found';
  end if;

  select count(*) into character_total from characters where grade_id = requested_grade_id;
  if character_total = 0 then
    raise exception 'This grade has no characters';
  end if;

  perform pg_advisory_xact_lock(hashtext(requested_grade_id::text));
  select coalesce(max(round_number), 0) + 1 into next_number
  from exam_rounds where grade_id = requested_grade_id;

  insert into exam_rounds (grade_id, round_number, title, timer_seconds)
  values (
    requested_grade_id,
    next_number,
    grade_label || ' - ' || next_number || '차',
    requested_timer_seconds
  ) returning id into new_round_id;

  insert into exam_round_items (round_id, character_id, position)
  select new_round_id, id, row_number() over (order by random())::integer
  from characters where grade_id = requested_grade_id;

  return new_round_id;
end;
$$;

alter table hanja.grades enable row level security;
alter table hanja.characters enable row level security;
alter table hanja.exam_rounds enable row level security;
alter table hanja.exam_round_items enable row level security;
alter table hanja.exam_attempts enable row level security;
alter table hanja.exam_answers enable row level security;

revoke all on schema hanja from public, anon, authenticated;
revoke all on all tables in schema hanja from anon, authenticated;
revoke all on all sequences in schema hanja from anon, authenticated;
revoke execute on all functions in schema hanja from public, anon, authenticated;
grant usage on schema hanja to service_role;
grant all on all tables in schema hanja to service_role;
grant all on all sequences in schema hanja to service_role;
grant execute on all functions in schema hanja to service_role;

insert into hanja.grades (code, name, sort_order)
values ('8', '8급', 8)
on conflict (code) do update set name = excluded.name;

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 1
from hanja.grades g
cross join (values
  ('土', '흙', '토'), ('八', '여덟', '팔'), ('下', '아래', '하'), ('木', '나무', '목'),
  ('火', '불', '화'), ('口', '입', '구'), ('子', '아들', '자'), ('目', '눈', '목'),
  ('田', '밭', '전'), ('足', '발', '족'), ('耳', '귀', '이'), ('二', '두', '이'),
  ('人', '사람', '인'), ('日', '해', '일'), ('一', '한', '일'), ('鼻', '코', '비'),
  ('五', '다섯', '오'), ('雨', '비', '우'), ('月', '달', '월'), ('女', '여자', '녀'),
  ('小', '작다', '소'), ('手', '손', '수'), ('身', '몸', '신'), ('水', '물', '수'),
  ('心', '마음', '심'), ('右', '오른쪽', '우'), ('上', '위', '상'), ('三', '석', '삼'),
  ('山', '뫼', '산'), ('四', '넉', '사'), ('入', '들', '입'), ('門', '문', '문'),
  ('父', '아비', '부'), ('白', '흰', '백'), ('大', '큰', '대'), ('母', '어미', '모'),
  ('六', '여섯', '육'), ('力', '힘', '력'), ('刀', '칼', '도'), ('車', '수레', '거'),
  ('金', '쇠', '금'), ('九', '아홉', '구'), ('走', '달리다', '주'), ('川', '내', '천'),
  ('中', '가운데', '중'), ('主', '주인', '주'), ('七', '일곱', '칠')
) as v(glyph, meaning, reading)
where g.code = '8'
on conflict (grade_id, glyph) do update
set meaning = excluded.meaning, reading = excluded.reading;
