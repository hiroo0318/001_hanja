create or replace function hanja.get_child_item_result(
  requested_round_id uuid,
  requested_round_item_id uuid
)
returns table(result text, meaning text, reading text)
language sql
stable
set search_path = hanja, public
as $$
  select
    answer.result::text,
    case when answer.result = 'incorrect' then character.meaning end,
    case when answer.result = 'incorrect' then character.reading end
  from hanja.exam_round_items item
  join hanja.exam_rounds round on round.id = item.round_id
  join hanja.characters character on character.id = item.character_id
  left join hanja.exam_attempts attempt on attempt.round_id = round.id
  left join hanja.exam_answers answer
    on answer.attempt_id = attempt.id
   and answer.round_item_id = item.id
  where item.id = requested_round_item_id
    and item.round_id = requested_round_id
    and round.is_hidden = false;
$$;
