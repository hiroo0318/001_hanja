-- 원본 8급 1페이지의 50개 출제 자리를 보존한다.
-- 口은 원본에 두 번 등장하므로 characters는 49개, 출제 항목은 50개이다.

create table if not exists hanja.grade_question_items (
  id uuid primary key default gen_random_uuid(),
  grade_id uuid not null references hanja.grades(id) on delete cascade,
  character_id uuid not null references hanja.characters(id) on delete restrict,
  source_position integer not null check (source_position > 0),
  source_document text not null,
  source_page integer not null check (source_page > 0),
  unique (grade_id, source_position)
);

alter table hanja.grade_question_items enable row level security;
revoke all on hanja.grade_question_items from anon, authenticated;
grant all on hanja.grade_question_items to service_role;

alter table hanja.exam_round_items
  drop constraint if exists exam_round_items_round_id_character_id_key;

-- 사용자 승인에 따라 기존의 잘못된 8급 차수와 연결 문제를 삭제한다.
delete from hanja.exam_rounds
where grade_id = (select id from hanja.grades where code = '8');

delete from hanja.characters
where grade_id = (select id from hanja.grades where code = '8');

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 1
from hanja.grades g
cross join (values
  ('土', '흙', '토'), ('八', '여덟', '팔'), ('下', '아래', '하'), ('禾', '벼', '화'), ('火', '불', '화'),
  ('口', '입', '구'), ('子', '아들', '자'), ('目', '눈', '목'), ('田', '밭', '전'), ('足', '발', '족'),
  ('耳', '귀', '이'), ('二', '두', '이'), ('人', '사람', '인'), ('日', '해', '일'), ('一', '한', '일'),
  ('鼻', '코', '비'), ('五', '다섯', '오'), ('雨', '비', '우'), ('月', '달', '월'), ('衣', '옷', '의'),
  ('小', '작다', '소'), ('手', '손', '수'), ('身', '몸', '신'), ('水', '물', '수'), ('心', '마음', '심'),
  ('右', '오른쪽', '우'), ('上', '위', '상'), ('三', '석', '삼'), ('山', '뫼', '산'), ('四', '넉', '사'),
  ('木', '나무', '목'), ('入', '들', '입'), ('門', '문', '문'), ('父', '아비', '부'), ('自', '스스로', '자'),
  ('大', '큰', '대'), ('母', '어미', '모'), ('六', '여섯', '육'), ('力', '힘', '력'), ('刀', '칼', '도'),
  ('車', '수레', '거'), ('女', '여자', '녀'), ('金', '쇠', '금'), ('九', '아홉', '구'), ('走', '달리다', '주'),
  ('川', '내', '천'), ('中', '가운데', '중'), ('主', '주인', '주'), ('七', '일곱', '칠')
) as v(glyph, meaning, reading)
where g.code = '8';

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, v.position, '스캔 문서.pdf', 1
from hanja.grades g
join (values
  (1, '土'), (2, '八'), (3, '下'), (4, '禾'), (5, '火'),
  (6, '口'), (7, '子'), (8, '目'), (9, '田'), (10, '足'),
  (11, '耳'), (12, '二'), (13, '人'), (14, '日'), (15, '一'),
  (16, '鼻'), (17, '五'), (18, '雨'), (19, '月'), (20, '衣'),
  (21, '小'), (22, '手'), (23, '身'), (24, '水'), (25, '心'),
  (26, '右'), (27, '上'), (28, '三'), (29, '山'), (30, '四'),
  (31, '木'), (32, '入'), (33, '門'), (34, '父'), (35, '自'),
  (36, '大'), (37, '母'), (38, '六'), (39, '力'), (40, '刀'),
  (41, '車'), (42, '口'), (43, '女'), (44, '金'), (45, '九'),
  (46, '走'), (47, '川'), (48, '中'), (49, '主'), (50, '七')
) as v(position, glyph) on true
join hanja.characters c on c.grade_id = g.id and c.glyph = v.glyph
where g.code = '8';

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
  question_total integer;
begin
  select name into grade_label from grades where id = requested_grade_id;
  if grade_label is null then raise exception 'Grade not found'; end if;
  select count(*) into question_total from grade_question_items where grade_id = requested_grade_id;
  if question_total = 0 then raise exception 'This grade has no source questions'; end if;

  perform pg_advisory_xact_lock(hashtext(requested_grade_id::text));
  select coalesce(max(round_number), 0) + 1 into next_number from exam_rounds where grade_id = requested_grade_id;
  insert into exam_rounds (grade_id, round_number, title, timer_seconds)
  values (requested_grade_id, next_number, grade_label || ' - ' || next_number || '차', requested_timer_seconds)
  returning id into new_round_id;

  insert into exam_round_items (round_id, character_id, position)
  select new_round_id, character_id, row_number() over (order by random())::integer
  from grade_question_items where grade_id = requested_grade_id;
  return new_round_id;
end;
$$;
