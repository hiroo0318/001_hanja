update hanja.exam_rounds r
set title = g.name || '_' || r.round_number || '차수 시험'
from hanja.grades g
where g.id = r.grade_id;

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
  values (requested_grade_id, next_number, grade_label || '_' || next_number || '차수 시험', requested_timer_seconds)
  returning id into new_round_id;

  insert into exam_round_items (round_id, character_id, position)
  select new_round_id, character_id, row_number() over (order by random())::integer
  from grade_question_items where grade_id = requested_grade_id;
  return new_round_id;
end;
$$;
