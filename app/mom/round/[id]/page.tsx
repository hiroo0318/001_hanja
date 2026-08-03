import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { isMom } from "@/lib/auth";
import { getMomRound } from "@/lib/db";
import { RoundReview } from "@/components/RoundReview";
export const dynamic = "force-dynamic";

export default async function MomRoundPage({ params }: { params: Promise<{ id: string }> }) {
  if (!(await isMom())) redirect("/mom/login"); const { id } = await params; const round = await getMomRound(id); if (!round) notFound();
  return <main className="shell"><nav className="nav"><Link className="secondary" href={`/print/${round.id}?from=round`}>문제지 인쇄</Link><a className="back" href="/mom">← 차수 목록</a></nav><p className="eyebrow">{round.grade.name} · {round.questionCount}문항</p><h1 className="page-title">{round.title}</h1><RoundReview round={round} /></main>;
}
