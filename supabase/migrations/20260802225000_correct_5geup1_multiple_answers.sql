-- Confirmed multiple-answer entries for 5급 1.
update hanja.characters c
set meaning = '고치다 / 다시',
    reading = '경 / 갱',
    source_text = '更 고치다 경 / 다시 갱'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-1'
  and c.glyph = '更'
  and c.meaning = '고치다'
  and c.reading = '경';

update hanja.characters c
set meaning = '법도 / 재다',
    reading = '도 / 탁',
    source_text = '度 법도 도 / 재다 탁'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-1'
  and c.glyph = '度'
  and c.meaning = '법도'
  and c.reading = '도';

update hanja.characters c
set meaning = '즐기다 / 음악 / 좋아하다',
    reading = '락 / 악 / 요',
    source_text = '樂 즐기다 락 / 음악 악 / 좋아하다 요'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-1'
  and c.glyph = '樂'
  and c.meaning = '즐기다'
  and c.reading = '락';

update hanja.characters c
set meaning = '오얏 / 성',
    reading = '리',
    source_text = '李 오얏 리 / 성 리'
from hanja.grades g
where c.grade_id = g.id
  and g.code = '5-1'
  and c.glyph = '李'
  and c.meaning = '오얏'
  and c.reading = '리';
