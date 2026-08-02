-- Confirmed multiple-answer entries for 5급 2.
update hanja.characters c
set meaning = '갚다 / 알리다',
    reading = '보',
    source_text = '報 갚다 보 / 알리다 보'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-2'
  and c.glyph = '報'
  and c.meaning = '알리다'
  and c.reading = '보';

update hanja.characters c
set meaning = '자다 / 별자리',
    reading = '숙 / 수',
    source_text = '宿 자다 숙 / 별자리 수'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-2'
  and c.glyph = '宿'
  and c.meaning = '자다'
  and c.reading = '숙';

update hanja.characters c
set meaning = '알다 / 기록하다',
    reading = '식 / 지',
    source_text = '識 알다 식 / 기록하다 지'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-2'
  and c.glyph = '識'
  and c.meaning = '알다'
  and c.reading = '식';

update hanja.characters c
set meaning = '살피다 / 덜다',
    reading = '성 / 생',
    source_text = '省 살피다 성 / 덜다 생'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-2'
  and c.glyph = '省'
  and c.meaning = '살피다'
  and c.reading = '성';
