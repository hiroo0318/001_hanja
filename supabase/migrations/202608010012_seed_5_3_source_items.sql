-- 원본 9페이지의 '뜻과 음을 쓰세요. (5-3)'만 반영한다.
insert into hanja.grades (code,name,sort_order) values ('5-3','5급 3',90) on conflict (code) do update set name=excluded.name,sort_order=excluded.sort_order;
delete from hanja.exam_rounds where grade_id=(select id from hanja.grades where code='5-3');
delete from hanja.grade_question_items where grade_id=(select id from hanja.grades where code='5-3');
delete from hanja.characters where grade_id=(select id from hanja.grades where code='5-3');
with source(glyph,meaning,reading) as (values
('義','옳다','의'),('姉','손위누이','자'),('昨','어제','작'),('貯','쌓다','저'),('典','법','전'),('展','펴다','전'),('傳','전하다','전'),('節','마디','절'),
('店','가게','점'),('情','뜻','정'),('定','정하다','정'),('庭','뜰','정'),('第','차례','제'),('題','제목','제'),('調','고르다','조'),('早','이르다','조'),
('著','붙다','착'),('參','참여하다','참'),('責','꾸짖다','책'),('初','처음','초'),('最','가장','최'),('忠','충성','충'),('充','채우다','충'),('則','법칙','칙'),
('打','치다','타'),('他','다르다','타'),('暴','사납다','폭'),('必','반드시','필'),('筆','붓','필'),('河','강','하'),('寒','차다','한'),('害','해하다','해'),
('協','화합하다','협'),('湖','호수','호'),('好','좋다','호'),('紅','붉다','홍'),('和','화하다','화'),('患','근심','환'),('回','돌다','회'),('會','모이다','회'),
('效','본받다','효'),('凶','흉하다','흉'),('卒','군사','졸'),('種','씨','종'),('終','마치다','종'),('晝','낮','주'),('注','붓다','주'),('志','뜻','지'),
('知','알다','지'),('眞','참','진'),('進','나아가다','진'),('質','바탕','질'),('鮮','곱다','선'),('善','착하다','선')
), inserted as (
insert into hanja.characters (grade_id,glyph,meaning,reading,source_document,source_page)
select g.id,s.glyph,s.meaning,s.reading,'스캔 문서.pdf',9 from hanja.grades g cross join source s where g.code='5-3' returning id,glyph)
insert into hanja.grade_question_items (grade_id,character_id,source_position,source_document,source_page)
select g.id,c.id,row_number() over (), '스캔 문서.pdf',9 from hanja.grades g join inserted c on true where g.code='5-3';
