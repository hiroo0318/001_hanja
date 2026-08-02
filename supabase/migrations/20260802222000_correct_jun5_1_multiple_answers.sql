-- Confirmed multiple-answer entries for 준5급 1.
update hanja.characters c
set meaning = '순박하다 / 성',
    reading = '박',
    source_text = '朴 순박하다 박 / 성 박'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-1'
  and c.glyph = '朴'
  and c.meaning = '순박하다'
  and c.reading = '박';

update hanja.characters c
set meaning = '다스리다 / 이치',
    reading = '리',
    source_text = '理 다스리다 리 / 이치 리'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-1'
  and c.glyph = '理'
  and c.meaning = '다스리다'
  and c.reading = '리';

update hanja.characters c
set meaning = '읽다 / 구절',
    reading = '독 / 두',
    source_text = '讀 읽다 독 / 구절 두'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-1'
  and c.glyph = '讀'
  and c.meaning = '읽다'
  and c.reading = '독';

update hanja.characters c
set meaning = '바르다 / 끝',
    reading = '단',
    source_text = '端 바르다 단 / 끝 단'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-1'
  and c.glyph = '端'
  and c.meaning = '바르다'
  and c.reading = '단';

update hanja.characters c
set meaning = '굽다 / 가락',
    reading = '곡',
    source_text = '曲 굽다 곡 / 가락 곡'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-1'
  and c.glyph = '曲'
  and c.meaning = '굽다'
  and c.reading = '곡';
