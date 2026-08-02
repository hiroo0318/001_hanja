-- Source correction for 6급 2: 黃 누렇다 황.
update hanja.characters c
set meaning = '누렇다',
    source_text = '黃 누렇다 황'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '6-2'
  and c.glyph = '黃'
  and c.meaning = '누르다'
  and c.reading = '황';
