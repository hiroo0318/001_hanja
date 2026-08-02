-- Confirmed multiple-answer entries for 준5급 2.
update hanja.characters c
set meaning = '악하다 / 미워하다',
    reading = '악 / 오',
    source_text = '惡 악하다 악 / 미워하다 오'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-2'
  and c.glyph = '惡'
  and c.meaning = '미워하다'
  and c.reading = '악';

update hanja.characters c
set meaning = '편하다 / 똥오줌',
    reading = '편 / 변',
    source_text = '便 편하다 편 / 똥오줌 변'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-2'
  and c.glyph = '便'
  and c.meaning = '편하다'
  and c.reading = '편';

update hanja.characters c
set meaning = '그림 / 긋다',
    reading = '화 / 획',
    source_text = '畫 그림 화 / 긋다 획'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun5-2'
  and c.glyph = '畫'
  and c.meaning = '그림'
  and c.reading = '화';
