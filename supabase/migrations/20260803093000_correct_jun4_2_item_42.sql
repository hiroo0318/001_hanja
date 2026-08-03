update hanja.characters
set glyph = '誤',
    meaning = '그릇되다',
    reading = '오',
    source_text = '誤 그릇되다 오'
where id = (
  select gqi.character_id
  from hanja.grade_question_items gqi
  join hanja.grades g on g.id = gqi.grade_id
  where g.name = '준4급 2'
    and gqi.source_position = 42
);
