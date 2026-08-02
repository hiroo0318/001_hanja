-- 6급 1 positions 4 and 5 are distinct: 公 공평하다 공 / 共 함께 공.
update hanja.characters c
set glyph = '公',
    meaning = '공평하다',
    reading = '공',
    source_text = '公 공평하다 공'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '6-1'
  and c.glyph = '共'
  and c.meaning = '함께'
  and c.reading = '공'
  and c.id = (
    select q.character_id
    from hanja.grade_question_items q
    where q.grade_id = g.id and q.source_position = 4
  );
