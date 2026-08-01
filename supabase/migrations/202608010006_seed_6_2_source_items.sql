-- 원본 4페이지의 '뜻과 음을 쓰세요. (6-2)'만 반영한다.

insert into hanja.grades (code, name, sort_order)
values ('6-2', '6급 2', 62)
on conflict (code) do update set name = excluded.name, sort_order = excluded.sort_order;

delete from hanja.exam_rounds where grade_id = (select id from hanja.grades where code = '6-2');
delete from hanja.grade_question_items where grade_id = (select id from hanja.grades where code = '6-2');
delete from hanja.characters where grade_id = (select id from hanja.grades where code = '6-2');

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 4
from hanja.grades g
cross join (values
  ('然', '그러하다', '연'), ('玉', '구슬', '옥'), ('温', '따뜻하다', '온'), ('用', '쓰다', '용'),
  ('友', '벗', '우'), ('右', '오른쪽', '우'), ('又', '또', '우'), ('有', '있다', '유'),
  ('育', '기르다', '육'), ('肉', '고기', '육'), ('邑', '고을', '읍'), ('醫', '의원', '의'),
  ('字', '글자', '자'), ('作', '짓다', '작'), ('場', '마당', '장'), ('在', '있다', '재'),
  ('才', '재주', '재'), ('前', '앞', '전'), ('全', '온전하다', '전'), ('朝', '아침', '조'),
  ('祖', '할아버지', '조'), ('族', '겨레', '족'), ('存', '있다', '존'), ('左', '왼쪽', '좌'),
  ('重', '무겁다', '중'), ('止', '그치다', '지'), ('地', '땅', '지'), ('至', '이르다', '지'),
  ('直', '곧다', '직'), ('體', '몸', '체'), ('草', '풀', '초'), ('村', '마을', '촌'),
  ('秋', '가을', '추'), ('春', '봄', '춘'), ('太', '크다', '태'), ('平', '평평하다', '평'),
  ('品', '물건', '품'), ('風', '바람', '풍'), ('夏', '여름', '하'), ('漢', '한나라', '한'),
  ('合', '합하다', '합'), ('海', '바다', '해'), ('現', '나타나다', '현'), ('化', '되다', '화'),
  ('花', '꽃', '화'), ('活', '살다', '활'), ('黃', '누르다', '황'), ('孝', '효도', '효'),
  ('後', '뒤', '후'), ('休', '쉬다', '휴')
) as v(glyph, meaning, reading)
where g.code = '6-2';

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, v.position, '스캔 문서.pdf', 4
from hanja.grades g
cross join (values
  (1,'然'),(2,'玉'),(3,'温'),(4,'用'),(5,'友'),(6,'右'),(7,'又'),(8,'有'),(9,'育'),(10,'肉'),
  (11,'邑'),(12,'醫'),(13,'字'),(14,'作'),(15,'場'),(16,'在'),(17,'才'),(18,'前'),(19,'全'),(20,'朝'),
  (21,'祖'),(22,'族'),(23,'存'),(24,'左'),(25,'重'),(26,'止'),(27,'地'),(28,'至'),(29,'直'),(30,'體'),
  (31,'草'),(32,'村'),(33,'秋'),(34,'春'),(35,'太'),(36,'平'),(37,'品'),(38,'風'),(39,'夏'),(40,'漢'),
  (41,'合'),(42,'海'),(43,'現'),(44,'化'),(45,'花'),(46,'活'),(47,'黃'),(48,'孝'),(49,'後'),(50,'休')
) as v(position, glyph)
join hanja.characters c on c.grade_id = g.id and c.glyph = v.glyph
where g.code = '6-2';
