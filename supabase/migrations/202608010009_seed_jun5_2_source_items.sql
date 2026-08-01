-- 원본 6페이지의 '뜻과 음을 쓰세요. (준5-2)'만 반영한다. 독음 쓰기 문항은 제외한다.

insert into hanja.grades (code, name, sort_order) values ('jun5-2', '준5급 2', 60)
on conflict (code) do update set name = excluded.name, sort_order = excluded.sort_order;
delete from hanja.exam_rounds where grade_id = (select id from hanja.grades where code = 'jun5-2');
delete from hanja.grade_question_items where grade_id = (select id from hanja.grades where code = 'jun5-2');
delete from hanja.characters where grade_id = (select id from hanja.grades where code = 'jun5-2');

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page)
select g.id, v.glyph, v.meaning, v.reading, '스캔 문서.pdf', 6
from hanja.grades g cross join (values
('習','익히다','습'),('始','처음','시'),('勝','이기다','승'),('示','보이다','시'),('詩','시','시'),
('植','심다','식'),('式','법','식'),('臣','신하','신'),('氏','성씨','씨'),('信','믿다','신'),
('新','새롭다','신'),('惡','미워하다','악'),('愛','사랑','애'),('野','들','야'),('夜','밤','야'),
('藥','약','약'),('魚','물고기','어'),('弱','약하다','약'),('英','꽃부리','영'),('勇','날래다','용'),
('運','움직이다','운'),('雲','구름','운'),('園','동산','원'),('原','근원','원'),('元','으뜸','원'),
('位','자리','위'),('銀','은','은'),('音','소리','음'),('因','인하다','인'),('者','사람','자'),
('章','글','장'),('電','번개','전'),('戰','싸움','전'),('助','돕다','조'),('竹','대','죽'),
('紙','종이','지'),('集','모이다','집'),('支','지탱하다','지'),('次','버금','차'),('唱','부르다','창'),
('窓','창','창'),('鐵','쇠','철'),('清','맑다','청'),('祝','빌다','축'),('致','이르다','치'),
('親','친하다','친'),('宅','집','택'),('通','통하다','통'),('特','특별하다','특'),('貝','조개','패'),
('便','편하다','편'),('表','겉','표'),('幸','다행','행'),('香','향기','향'),('血','피','혈'),
('形','모양','형'),('號','이름','호'),('話','말씀','화'),('畫','그림','화'),('訓','가르치다','훈')
) as v(glyph, meaning, reading) where g.code = 'jun5-2';

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, row_number() over (order by v.position), '스캔 문서.pdf', 6
from hanja.grades g cross join (values
(1,'習'),(2,'始'),(3,'勝'),(4,'示'),(5,'詩'),(6,'植'),(7,'式'),(8,'臣'),(9,'氏'),(10,'信'),
(11,'新'),(12,'惡'),(13,'愛'),(14,'野'),(15,'夜'),(16,'藥'),(17,'魚'),(18,'弱'),(19,'英'),(20,'勇'),
(21,'運'),(22,'雲'),(23,'園'),(24,'原'),(25,'元'),(26,'位'),(27,'銀'),(28,'音'),(29,'因'),(30,'者'),
(31,'章'),(32,'電'),(33,'戰'),(34,'助'),(35,'竹'),(36,'紙'),(37,'集'),(38,'支'),(39,'次'),(40,'唱'),
(41,'窓'),(42,'鐵'),(43,'清'),(44,'祝'),(45,'致'),(46,'親'),(47,'宅'),(48,'通'),(49,'特'),(50,'貝'),
(51,'便'),(52,'表'),(53,'幸'),(54,'香'),(55,'血'),(56,'形'),(57,'號'),(58,'話'),(59,'畫'),(60,'訓')
) as v(position,glyph) join hanja.characters c on c.grade_id=g.id and c.glyph=v.glyph where g.code='jun5-2';
