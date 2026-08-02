-- Confirmed source corrections for 8급.
update hanja.characters c
set glyph = '石',
    meaning = '돌',
    reading = '석',
    source_text = '石 돌 석'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '右'
  and c.meaning = '오른쪽'
  and c.reading = '우';

update hanja.characters c
set meaning = '산',
    source_text = '山 산 산'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '山'
  and c.meaning = '뫼'
  and c.reading = '산';

update hanja.characters c
set meaning = '넷',
    source_text = '四 넷 사'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '四'
  and c.meaning = '넉'
  and c.reading = '사';
