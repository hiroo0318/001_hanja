import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { isMom } from "@/lib/auth";
import { getMomRound } from "@/lib/db";
import { PrintButton } from "@/components/PrintButton";
export const dynamic = "force-dynamic";

export default async function PrintPage({ params }: { params: Promise<{ id: string }> }) {
  if (!(await isMom())) redirect("/mom/login"); const { id } = await params; const round = await getMomRound(id); if (!round) notFound();
  const pages = Array.from({length:Math.ceil(round.items.length/52)},(_,index)=>round.items.slice(index*52,index*52+52));
  return <main className="print-page"><div className="print-toolbar"><Link className="secondary" href={`/mom/round/${round.id}`}>← 답지로</Link><PrintButton /></div>{pages.map((items,pageIndex)=><section className={`worksheet ${pageIndex ? "page-break" : ""}`} key={pageIndex}>{pageIndex === 0 && <header className="worksheet-header"><h1>한자의 뜻과 음을 쓰세요. ({round.grade.name})</h1><div className="worksheet-meta"><span>차수: {round.title}</span><span>날짜: __________</span></div></header>}<div className="worksheet-grid">{items.map((item)=><div className="worksheet-item" key={item.id}><span className="worksheet-number">{item.position}.</span><span className="worksheet-glyph">{item.character.glyph}</span><span className="worksheet-answer">（　　　　　）</span></div>)}</div></section>)}</main>;
}
