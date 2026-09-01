import Link from "next/link";
import { getChildRounds } from "@/lib/db";
import { ChildRoundsRefresh } from "@/components/ChildRoundsRefresh";
export const dynamic = "force-dynamic";

export default async function YoonwooExamPage() {
  const rounds = await getChildRounds();
  return <main className="shell">
    <nav className="nav"><Link className="brand" href="/">漢 한자 차수 시험</Link><Link className="back" href="/yoonwoo">← 윤우 메뉴</Link></nav>
    <p className="eyebrow">윤우 시험</p>
    <h1 className="page-title">어떤 차수를<br />풀어 볼까?</h1>
    <div className="exam-list-description"><p className="sub">한자를 보고 뜻과 음을 큰 소리로 말해 보세요.</p><ChildRoundsRefresh /></div>
    {rounds.length === 0 ? <p className="empty">엄마가 먼저 시험 차수를 만들어 줄 거예요.</p> : rounds.map((round)=><article className="round-card" key={round.id}><div className="round-main"><div className="round-top"><span className="round-title">{round.title}</span></div><div className="round-meta"><span>{round.questionCount}문항</span><span>{round.timer_seconds ? `${round.timer_seconds/60}분` : "시간 제한 없음"}</span>{round.score.checked > 0 && <strong className="round-score">맞음 {round.score.correct} / {round.questionCount}</strong>}</div><div className="round-start-actions"><Link className="secondary" href={`/yoonwoo/${round.id}?mode=restart`}>처음부터</Link>{round.score.hasAttempt ? <Link className="primary" href={`/yoonwoo/${round.id}`}>이어서 하기</Link> : <span className="round-action-disabled">이어서 하기</span>}{round.score.incorrect > 0 ? <Link className="wrong-review" href={`/yoonwoo/${round.id}?review=incorrect`}>틀린문제</Link> : <span className="round-action-disabled">틀린문제</span>}</div></div></article>)}
  </main>;
}
