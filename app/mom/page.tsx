import Link from "next/link";
import { redirect } from "next/navigation";
import { isMom } from "@/lib/auth";
import { getGrades, getRoundSummaries } from "@/lib/db";
import { RoundCreator } from "@/components/RoundCreator";
export const dynamic = "force-dynamic";

export default async function MomPage() {
  if (!(await isMom())) redirect("/mom/login");
  const [grades, rounds] = await Promise.all([getGrades(), getRoundSummaries()]);
  return <main className="shell"><nav className="nav"><Link className="brand" href="/">漢 한자 차수 시험</Link><Link className="home-button" href="/">홈으로</Link></nav><p className="eyebrow">엄마 관리실</p><h1 className="page-title">문제를 만들고,<br />차수별로 확인해요.</h1><p className="sub">차수를 만들면 랜덤 문제 순서와 답지가 함께 저장됩니다.</p><RoundCreator grades={grades} /><section style={{marginTop:28}}><h2>생성한 차수</h2>{rounds.length === 0 ? <p className="empty">아직 만든 차수가 없어요.</p> : rounds.map((round)=><article className="round-card" key={round.id}><div className="round-top"><span className="round-title">{round.title}</span></div><div className="round-meta"><span>{new Date(round.created_at).toLocaleDateString("ko-KR")}</span><span>{round.questionCount}문항</span><span>{round.timer_seconds ? `${round.timer_seconds/60}분` : "시간 제한 없음"}</span><span>채점 {round.score.checked}/{round.questionCount} · {round.score.correct}점</span></div><div className="round-actions"><Link className="secondary" href={`/mom/round/${round.id}`}>답지 · 채점</Link><Link className="secondary" href={`/print/${round.id}`}>문제지 인쇄</Link></div></article>)}</section></main>;
}
