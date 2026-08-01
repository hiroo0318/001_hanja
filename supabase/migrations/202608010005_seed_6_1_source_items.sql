-- 원본 3페이지의 '뜻과 음을 쓰세요. (6-1)'만 반영한다.

insert into hanja.grades (code, name, sort_order)
values ('6-1', '6급 1', 61)
on conflict (code) do update set name = excluded.name, sort_order = excluded.sort_order;

delete from hanja.exam_rounds where grade_id = (select id from hanja.grades where code = '6-1');
delete from hanja.grade_question_items where grade_id = (select id from hanja.grades where code = '6-1');
delete from hanja.characters where grade_id = (select id from hanja.grades where code = '6-1');

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 3
from hanja.grades g
cross join (values
  ('家', '집', '가'), ('角', '뿔', '각'), ('高', '높다', '고'), ('公', '공평하다', '공'),
  ('共', '함께', '공'), ('果', '열매', '과'), ('光', '빛', '광'), ('交', '사귀다', '교'),
  ('今', '이제', '금'), ('氣', '기운', '기'), ('記', '기록하다', '기'), ('己', '몸', '기'),
  ('農', '농사', '농'), ('答', '대답하다', '답'), ('代', '대신하다', '대'), ('對', '대하다', '대'),
  ('道', '길', '도'), ('冬', '겨울', '동'), ('動', '움직이다', '동'), ('同', '같다', '동'),
  ('洞', '골', '동'), ('登', '오르다', '등'), ('路', '길', '로'), ('里', '마을', '리'),
  ('林', '수풀', '림'), ('命', '목숨', '명'), ('毛', '털', '모'), ('無', '없다', '무'),
  ('文', '글월', '문'), ('米', '쌀', '미'), ('反', '돌이키다', '반'), ('別', '다르다', '별'),
  ('分', '나누다', '분'), ('不', '아니다', '불'), ('士', '선비', '사'), ('事', '일', '사'),
  ('産', '낳다', '산'), ('色', '빛', '색'), ('成', '이루다', '성'), ('姓', '성', '성'),
  ('所', '바', '소'), ('孫', '손자', '손'), ('數', '셈', '수'), ('時', '때', '시'),
  ('市', '저자', '시'), ('失', '잃다', '실'), ('安', '편안하다', '안'), ('陽', '볕', '양'),
  ('語', '말씀', '어'), ('言', '말씀', '언')
) as v(glyph, meaning, reading)
where g.code = '6-1';

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, v.position, '스캔 문서.pdf', 3
from hanja.grades g
cross join (values
  (1,'家'),(2,'角'),(3,'高'),(4,'公'),(5,'共'),(6,'果'),(7,'光'),(8,'交'),(9,'今'),(10,'氣'),
  (11,'記'),(12,'己'),(13,'農'),(14,'答'),(15,'代'),(16,'對'),(17,'道'),(18,'冬'),(19,'動'),(20,'同'),
  (21,'洞'),(22,'登'),(23,'路'),(24,'里'),(25,'林'),(26,'命'),(27,'毛'),(28,'無'),(29,'文'),(30,'米'),
  (31,'反'),(32,'別'),(33,'分'),(34,'不'),(35,'士'),(36,'事'),(37,'産'),(38,'色'),(39,'成'),(40,'姓'),
  (41,'所'),(42,'孫'),(43,'數'),(44,'時'),(45,'市'),(46,'失'),(47,'安'),(48,'陽'),(49,'語'),(50,'言')
) as v(position, glyph)
join hanja.characters c on c.grade_id = g.id and c.glyph = v.glyph
where g.code = '6-1';
