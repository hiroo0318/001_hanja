-- 원본 7페이지의 '뜻과 음을 쓰세요. (5-1)'만 반영한다.
insert into hanja.grades (code,name,sort_order) values ('5-1','5급 1',70) on conflict (code) do update set name=excluded.name,sort_order=excluded.sort_order;
delete from hanja.exam_rounds where grade_id=(select id from hanja.grades where code='5-1');
delete from hanja.grade_question_items where grade_id=(select id from hanja.grades where code='5-1');
delete from hanja.characters where grade_id=(select id from hanja.grades where code='5-1');
with source(glyph,meaning,reading) as (values
('加','더하다','가'),('價','값','가'),('感','느끼다','감'),('各','각각','각'),('看','보다','간'),('改','고치다','개'),('擧','들다','거'),('格','격식','격'),
('客','손님','객'),('景','볕','경'),('更','고치다','경'),('界','지경','계'),('告','알리다','고'),('課','매기다','과'),('過','지나다','과'),('廣','넓다','광'),
('君','임금','군'),('權','권세','권'),('歸','돌아가다','귀'),('貴','귀하다','귀'),('規','법','규'),('近','가깝다','근'),('急','급하다','급'),('當','마땅하다','당'),
('堂','집','당'),('圖','그림','도'),('度','법도','도'),('頭','머리','두'),('等','무리','등'),('落','떨어지다','락'),('樂','즐기다','락'),('兩','두','량'),
('練','익히다','련'),('令','명령하다','령'),('領','거느리다','령'),('例','법식','례'),('勞','일하다','로'),('綠','푸르다','록'),('論','논하다','론'),('陸','뭍','륙'),
('李','오얏','리'),('望','바라다','망'),('妹','아랫누이','매'),('賣','팔다','매'),('急','급하다','급'),('技','재주','기'),('基','터','기'),('吉','길하다','길'),
('暖','따뜻하다','난'),('買','사다','매'),('明','밝다','명'),('味','맛','미'),('半','절반','반'),('量','헤아리다','량')
), inserted as (
insert into hanja.characters (grade_id,glyph,meaning,reading,source_document,source_page)
select g.id,s.glyph,s.meaning,s.reading,'스캔 문서.pdf',7 from hanja.grades g cross join (select distinct on (glyph) * from source) s where g.code='5-1'
on conflict (grade_id,glyph) do update set meaning=excluded.meaning,reading=excluded.reading returning id,glyph
)
insert into hanja.grade_question_items (grade_id,character_id,source_position,source_document,source_page)
select g.id,c.id,row_number() over (), '스캔 문서.pdf',7 from hanja.grades g join source s on true join inserted c on c.glyph=s.glyph where g.code='5-1';
