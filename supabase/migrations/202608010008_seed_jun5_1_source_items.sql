-- 원본 5페이지의 '뜻과 음을 쓰세요. (준5-1)'만 반영한다. 독음 쓰기 문항은 제외한다.

insert into hanja.grades (code, name, sort_order)
values ('jun5-1', '준5급 1', 50)
on conflict (code) do update set name = excluded.name, sort_order = excluded.sort_order;

delete from hanja.exam_rounds where grade_id = (select id from hanja.grades where code = 'jun5-1');
delete from hanja.grade_question_items where grade_id = (select id from hanja.grades where code = 'jun5-1');
delete from hanja.characters where grade_id = (select id from hanja.grades where code = 'jun5-1');

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 5
from hanja.grades g
cross join (values
  ('樹','나무','수'),('消','사라지다','소'),('性','성품','성'),('雪','눈','설'),('席','자리','석'),
  ('算','셈하다','산'),('使','부리다','사'),('死','죽다','사'),('比','견주다','비'),('社','모이다','사'),
  ('部','떼','부'),('服','옷','복'),('富','부유하다','부'),('步','걷다','보'),('病','병','병'),
  ('放','놓다','방'),('發','피다','발'),('朴','순박하다','박'),('美','아름답다','미'),('物','물건','물'),
  ('問','묻다','문'),('每','매양','매'),('聞','묻다','문'),('亡','망하다','망'),('利','이롭다','리'),
  ('理','다스리다','리'),('賴','의뢰하다','뢰'),('粒','낱알','립'),('禮','예도','례'),('旅','나그네','려'),
  ('冷','차다','랭'),('得','얻다','득'),('童','아이','동'),('獨','홀로','독'),('讀','읽다','독'),
  ('都','도읍','도'),('德','덕','덕'),('待','기다리다','대'),('端','바르다','단'),('短','짧다','단'),
  ('期','기약하다','기'),('根','뿌리','근'),('郡','고을','군'),('救','구원하다','구'),('關','관계하다','관'),
  ('科','과목','과'),('功','공','공'),('考','생각하다','고'),('曲','굽다','곡'),('苦','괴롭다','고'),
  ('固','굳다','고'),('計','세다','계'),('競','다투다','경'),('開','열다','개'),
  ('京','서울','경'),('強','강하다','강'),('甘','달다','감'),('間','사이','간'),('歌','노래','가')
) as v(glyph, meaning, reading)
where g.code = 'jun5-1';

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, v.position, '스캔 문서.pdf', 5
from hanja.grades g
cross join (values
  (1,'樹'),(2,'消'),(3,'性'),(4,'雪'),(5,'席'),(6,'算'),(7,'使'),(8,'死'),(9,'比'),(10,'社'),
  (11,'部'),(12,'服'),(13,'富'),(14,'步'),(15,'病'),(16,'放'),(17,'發'),(18,'朴'),(19,'美'),(20,'物'),
  (21,'問'),(22,'每'),(23,'聞'),(24,'亡'),(25,'利'),(26,'理'),(27,'賴'),(28,'粒'),(29,'禮'),(30,'旅'),
  (31,'冷'),(32,'得'),(33,'童'),(34,'獨'),(35,'讀'),(36,'都'),(37,'德'),(38,'待'),(39,'端'),(40,'短'),
  (41,'期'),(42,'根'),(43,'郡'),(44,'救'),(45,'關'),(46,'科'),(47,'功'),(48,'考'),(49,'曲'),(50,'苦'),
  (51,'固'),(52,'計'),(53,'競'),(54,'開'),(55,'競'),(56,'京'),(57,'強'),(58,'甘'),(59,'間'),(60,'歌')
) as v(position, glyph)
join hanja.characters c on c.grade_id = g.id and c.glyph = v.glyph
where g.code = 'jun5-1';
