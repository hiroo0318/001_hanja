-- Confirmed corrections for 5급 3.
update hanja.characters c
set meaning = '참여하다 / 셋',
    reading = '참 / 삼',
    source_text = '參 참여하다 참 / 셋 삼'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-3'
  and c.glyph = '參'
  and c.meaning = '참여하다'
  and c.reading = '참';

update hanja.characters c
set meaning = '곧',
    reading = '즉',
    source_text = '則 곧 즉'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-3'
  and c.glyph = '則'
  and c.meaning = '법칙'
  and c.reading = '칙';

update hanja.characters c
set meaning = '군사 / 미치다',
    reading = '졸',
    source_text = '卒 군사 졸 / 미치다 졸'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-3'
  and c.glyph = '卒'
  and c.meaning = '군사'
  and c.reading = '졸';
