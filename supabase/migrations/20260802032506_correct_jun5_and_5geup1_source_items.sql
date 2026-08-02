-- Correct confirmed OCR mistakes using the original source positions.
-- A grade may contain the same glyph with different answers (for example 間: 문 / 간),
-- so the answer tuple, rather than only the glyph, must remain distinguishable.
alter table hanja.characters
  drop constraint if exists characters_grade_id_glyph_key;

-- Rounds are immutable snapshots. Remove affected existing snapshots so no old OCR data remains.
delete from hanja.exam_rounds
where grade_id in (
  select id from hanja.grades where code in ('jun5-1', '5-1')
);

-- 준5급 1: rebuild the source-item map so the position-specific answers stay accurate.
delete from hanja.grade_question_items
where grade_id = (select id from hanja.grades where code = 'jun5-1');

delete from hanja.characters
where grade_id = (select id from hanja.grades where code = 'jun5-1');

with source_items(source_position, glyph, meaning, reading) as (
  values
    (1, '樹', '나무', '수'), (2, '消', '사라지다', '소'), (3, '性', '성품', '성'), (4, '雪', '눈', '설'), (5, '席', '자리', '석'),
    (6, '算', '셈하다', '산'), (7, '使', '부리다', '사'), (8, '死', '죽다', '사'), (9, '比', '견주다', '비'), (10, '社', '모이다', '사'),
    (11, '部', '떼', '부'), (12, '服', '옷', '복'), (13, '富', '부유하다', '부'), (14, '步', '걷다', '보'), (15, '病', '병', '병'),
    (16, '放', '놓다', '방'), (17, '發', '피다', '발'), (18, '朴', '순박하다', '박'), (19, '美', '아름답다', '미'), (20, '物', '물건', '물'),
    (21, '間', '묻다', '문'), (22, '每', '매양', '매'), (23, '問', '묻다', '문'), (24, '亡', '망하다', '망'), (25, '利', '이롭다', '리'),
    (26, '理', '다스리다', '리'), (27, '類', '무리', '류'), (28, '料', '헤아릴', '료'), (29, '禮', '예도', '례'), (30, '旅', '나그네', '려'),
    (31, '冷', '차다', '랭'), (32, '得', '얻다', '득'), (33, '童', '아이', '동'), (34, '獨', '홀로', '독'), (35, '讀', '읽다', '독'),
    (36, '都', '도읍', '도'), (37, '德', '덕', '덕'), (38, '待', '기다리다', '대'), (39, '端', '바르다', '단'), (40, '短', '짧다', '단'),
    (41, '期', '기약하다', '기'), (42, '根', '뿌리', '근'), (43, '郡', '고을', '군'), (44, '救', '구원하다', '구'), (45, '關', '관계하다', '관'),
    (46, '科', '과목', '과'), (47, '功', '공', '공'), (48, '考', '생각하다', '고'), (49, '曲', '굽다', '곡'), (50, '苦', '괴롭다', '고'),
    (51, '固', '굳다', '고'), (52, '計', '세다', '계'), (53, '競', '다투다', '경'), (54, '開', '열다', '개'), (55, '競', '다투다', '경'),
    (56, '京', '서울', '경'), (57, '強', '강하다', '강'), (58, '甘', '달다', '감'), (59, '間', '사이', '간'), (60, '歌', '노래', '가')
), distinct_items as (
  select distinct glyph, meaning, reading from source_items
)
insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page, source_text)
select g.id, d.glyph, d.meaning, d.reading, '스캔 문서.pdf', 5, d.glyph || ' ' || d.meaning || ' ' || d.reading
from distinct_items d
cross join hanja.grades g
where g.code = 'jun5-1';

with source_items(source_position, glyph, meaning, reading) as (
  values
    (1, '樹', '나무', '수'), (2, '消', '사라지다', '소'), (3, '性', '성품', '성'), (4, '雪', '눈', '설'), (5, '席', '자리', '석'),
    (6, '算', '셈하다', '산'), (7, '使', '부리다', '사'), (8, '死', '죽다', '사'), (9, '比', '견주다', '비'), (10, '社', '모이다', '사'),
    (11, '部', '떼', '부'), (12, '服', '옷', '복'), (13, '富', '부유하다', '부'), (14, '步', '걷다', '보'), (15, '病', '병', '병'),
    (16, '放', '놓다', '방'), (17, '發', '피다', '발'), (18, '朴', '순박하다', '박'), (19, '美', '아름답다', '미'), (20, '物', '물건', '물'),
    (21, '間', '묻다', '문'), (22, '每', '매양', '매'), (23, '問', '묻다', '문'), (24, '亡', '망하다', '망'), (25, '利', '이롭다', '리'),
    (26, '理', '다스리다', '리'), (27, '類', '무리', '류'), (28, '料', '헤아릴', '료'), (29, '禮', '예도', '례'), (30, '旅', '나그네', '려'),
    (31, '冷', '차다', '랭'), (32, '得', '얻다', '득'), (33, '童', '아이', '동'), (34, '獨', '홀로', '독'), (35, '讀', '읽다', '독'),
    (36, '都', '도읍', '도'), (37, '德', '덕', '덕'), (38, '待', '기다리다', '대'), (39, '端', '바르다', '단'), (40, '短', '짧다', '단'),
    (41, '期', '기약하다', '기'), (42, '根', '뿌리', '근'), (43, '郡', '고을', '군'), (44, '救', '구원하다', '구'), (45, '關', '관계하다', '관'),
    (46, '科', '과목', '과'), (47, '功', '공', '공'), (48, '考', '생각하다', '고'), (49, '曲', '굽다', '곡'), (50, '苦', '괴롭다', '고'),
    (51, '固', '굳다', '고'), (52, '計', '세다', '계'), (53, '競', '다투다', '경'), (54, '開', '열다', '개'), (55, '競', '다투다', '경'),
    (56, '京', '서울', '경'), (57, '強', '강하다', '강'), (58, '甘', '달다', '감'), (59, '間', '사이', '간'), (60, '歌', '노래', '가')
)
insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, s.source_position, '스캔 문서.pdf', 5
from source_items s
join hanja.grades g on g.code = 'jun5-1'
join hanja.characters c on c.grade_id = g.id
  and c.glyph = s.glyph and c.meaning = s.meaning and c.reading = s.reading;

-- 5급 1: source position 23 was OCR'd as 急; the source is 念 생각하다 념.
delete from hanja.grade_question_items
where grade_id = (select id from hanja.grades where code = '5-1')
  and source_position = 23;

insert into hanja.characters (grade_id, glyph, meaning, reading, source_document, source_page, source_text)
select g.id, '念', '생각하다', '념', '스캔 문서.pdf', 7, '念 생각하다 념'
from hanja.grades g
where g.code = '5-1'
  and not exists (
    select 1 from hanja.characters c
    where c.grade_id = g.id and c.glyph = '念' and c.meaning = '생각하다' and c.reading = '념'
  );

insert into hanja.grade_question_items (grade_id, character_id, source_position, source_document, source_page)
select g.id, c.id, 23, '스캔 문서.pdf', 7
from hanja.grades g
join hanja.characters c on c.grade_id = g.id
  and c.glyph = '念' and c.meaning = '생각하다' and c.reading = '념'
where g.code = '5-1';
