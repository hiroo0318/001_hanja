-- Confirmed source corrections for 6급 1.
update hanja.characters c
set glyph = '共',
    meaning = '함께',
    reading = '공',
    source_text = '共 함께 공'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '6-1'
  and c.glyph = '公'
  and c.meaning = '공평하다'
  and c.reading = '공';

update hanja.characters c
set meaning = '골 / 밝다',
    reading = '동 / 통',
    source_text = '洞 골 동 / 밝다 통'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '6-1'
  and c.glyph = '洞'
  and c.meaning = '골'
  and c.reading = '동';

update hanja.characters c
set meaning = '셈 / 자주',
    reading = '수 / 삭',
    source_text = '數 셈 수 / 자주 삭'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '6-1'
  and c.glyph = '數'
  and c.meaning = '셈'
  and c.reading = '수';
