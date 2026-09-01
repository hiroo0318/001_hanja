-- 준5급 1 원본 21번: 間 사이 간.
-- 기존 시험 차수는 고정된 출제 기록이므로 유지하고, 공부하기 및 새 차수의 원본 연결만 바로잡는다.
update hanja.grade_question_items question_item
set character_id = correct_character.id
from hanja.grades grade
join hanja.characters correct_character
  on correct_character.grade_id = grade.id
  and correct_character.glyph = '間'
  and correct_character.meaning = '사이'
  and correct_character.reading = '간'
where question_item.grade_id = grade.id
  and grade.code = 'jun5-1'
  and question_item.source_position = 21;
