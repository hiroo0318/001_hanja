-- 급수 선택 목록은 원본 문서의 페이지 순서(8급 → 7급 → 6-1 → 6-2)로 보인다.

update hanja.grades
set sort_order = case code
  when '8' then 10
  when '7' then 20
  when '6-1' then 30
  when '6-2' then 40
  else sort_order
end
where code in ('8', '7', '6-1', '6-2');
