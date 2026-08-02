-- Source: 준4-1, 11th row / 2nd column (敢 감히 감).
update hanja.characters c
set glyph = '敢',
    source_text = '敢 감히 감'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun4-1'
  and c.glyph = '敵'
  and c.meaning = '감히'
  and c.reading = '감';
