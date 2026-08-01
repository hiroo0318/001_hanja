-- 원본 8페이지의 '뜻과 음을 쓰세요. (5-2)'만 반영한다.
insert into hanja.grades (code,name,sort_order) values ('5-2','5급 2',80) on conflict (code) do update set name=excluded.name,sort_order=excluded.sort_order;
delete from hanja.exam_rounds where grade_id=(select id from hanja.grades where code='5-2');
delete from hanja.grade_question_items where grade_id=(select id from hanja.grades where code='5-2');
delete from hanja.characters where grade_id=(select id from hanja.grades where code='5-2');
with source(glyph,meaning,reading) as (values
('飯','밥','반'),('番','차례','번'),('變','변하다','변'),('報','알리다','보'),('福','복','복'),('奉','받들다','봉'),('備','갖추다','비'),('費','쓰다','비'),
('速','빠르다','속'),('守','지키다','수'),('宿','자다','숙'),('順','순하다','순'),('識','알다','식'),('神','귀신','신'),('實','열매','실'),('兒','아이','아'),
('貧','가난하다','빈'),('仕','벼슬하다','사'),('師','스승','사'),('思','생각하다','사'),('相','서로','상'),('賞','상주다','상'),('書','글','서'),('序','차례','서'),
('暗','어둡다','암'),('約','맺다','약'),('洋','큰바다','양'),('養','기르다','양'),('業','일','업'),('餘','남다','여'),('葉','잎','엽'),('榮','영화롭다','영'),
('永','길다','영'),('完','완전하다','완'),('要','요긴하다','요'),('雄','수컷','웅'),('願','원하다','원'),('遠','멀다','원'),('油','기름','유'),('由','말미암다','유'),
('恩','은혜','은'),('飮','마시다','음'),('意','뜻','의'),('選','뽑다','선'),('線','줄','선'),('仙','신선','선'),('誠','정성','성'),('星','별','성'),
('城','성','성'),('省','살피다','성'),('洗','씻다','세'),('笑','웃다','소'),('鮮','곱다','선'),('善','착하다','선')
), inserted as (
insert into hanja.characters (grade_id,glyph,meaning,reading,source_document,source_page)
select g.id,s.glyph,s.meaning,s.reading,'스캔 문서.pdf',8 from hanja.grades g cross join source s where g.code='5-2' returning id,glyph)
insert into hanja.grade_question_items (grade_id,character_id,source_position,source_document,source_page)
select g.id,c.id,row_number() over (), '스캔 문서.pdf',8 from hanja.grades g join inserted c on true where g.code='5-2';
