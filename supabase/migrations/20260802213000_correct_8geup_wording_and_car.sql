-- Confirmed source wording and alternate-reading corrections for 8급.
update hanja.characters c
set meaning = '들어가다',
    source_text = '入 들어가다 입'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '入'
  and c.meaning = '들'
  and c.reading = '입';

update hanja.characters c
set meaning = '크다',
    source_text = '大 크다 대'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '大'
  and c.meaning = '큰'
  and c.reading = '대';

update hanja.characters c
set reading = '거 / 차',
    source_text = '車 수레 거 / 차'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '8'
  and c.glyph = '車'
  and c.meaning = '수레'
  and c.reading = '거';
