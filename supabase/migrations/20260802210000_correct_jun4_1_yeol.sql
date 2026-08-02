-- Source: 준4-1, first row third item (烈 벌이다 렬).
update hanja.characters c
set meaning = '벌이다',
    reading = '렬',
    source_text = '烈 벌이다 렬'
from hanja.grades g
where c.grade_id = g.id
  and g.code = 'jun4-1'
  and c.glyph = '烈'
  and c.meaning = '세차다'
  and c.reading = '렬';
