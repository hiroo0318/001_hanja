import Link from "next/link";

export default function Home() {
  return <main className="home-shell">
    <div className="sun">漢</div>
    <p className="eyebrow">한자 급수 시험 대비</p>
    <h1>오늘의 한자,<br />차근차근 익혀요.</h1>
    <p className="lead">엄마가 문제 차수를 만들고, 윤우가 한 글자씩 도전해요.</p>
    <div className="role-grid">
      <Link className="role-card mom" href="/mom/login"><span>👩</span><strong>엄마</strong><small>차수 만들기 · 답지 · 채점</small></Link>
      <Link className="role-card child" href="/yoonwoo"><span>🧒</span><strong>윤우</strong><small>차수 선택 · 시험 시작</small></Link>
    </div>
  </main>;
}
