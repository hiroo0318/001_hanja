-- Confirmed source corrections for 7급.
update hanja.characters c
set meaning = '가다 / 항렬',
    reading = '행 / 항',
    source_text = '行 가다 행 / 항렬 항'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '行'
  and c.meaning = '가다'
  and c.reading = '행';

update hanja.characters c
set glyph = '革',
    meaning = '가죽 / 고치다',
    reading = '혁',
    source_text = '革 가죽 혁 / 고치다 혁'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '車'
  and c.meaning = '수레'
  and c.reading = '거';

update hanja.characters c
set meaning = '길다 / 어른',
    source_text = '長 길다 장 / 어른 장'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '長'
  and c.meaning = '길다'
  and c.reading = '장';

update hanja.characters c
set glyph = '兵',
    meaning = '병사',
    reading = '병',
    source_text = '兵 병사 병'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '豆'
  and c.meaning = '콩'
  and c.reading = '두';

update hanja.characters c
set meaning = '북녘 / 달아나다',
    reading = '북 / 배',
    source_text = '北 북녘 북 / 달아나다 배'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '北'
  and c.meaning = '북녘'
  and c.reading = '북';

update hanja.characters c
set glyph = '軍',
    meaning = '군사',
    reading = '군',
    source_text = '軍 군사 군'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '7'
  and c.glyph = '里'
  and c.meaning = '마을'
  and c.reading = '리';
