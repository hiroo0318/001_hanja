import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { isMom } from "@/lib/auth";
import { getMomRound } from "@/lib/db";
import { PrintButton } from "@/components/PrintButton";
export const dynamic = "force-dynamic";

export default async function PrintPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ from?: string }> }) {
  if (!(await isMom())) redirect("/mom/login"); const { id } = await params; const { from } = await searchParams; const round = await getMomRound(id); if (!round) notFound();
  const pages = Array.from({length:Math.ceil(round.items.length/52)},(_,index)=>round.items.slice(index*52,index*52+52));
  const returnToList = from === "list";
  return <main className="print-page"><div className="print-toolbar"><PrintButton /><Link className="secondary" href={returnToList ? "/mom" : `/mom/round/${round.id}`}>{returnToList ? "← 차수 목록" : "← 답지로"}</Link></div>{pages.map((items,pageIndex)=><section className={`worksheet ${pageIndex ? "page-break" : ""}`} key={pageIndex}>{pageIndex === 0 && <header className="worksheet-header"><h1>한자의 뜻과 음을 쓰세요. ({round.grade.name})</h1><div className="worksheet-meta"><span>차수: {round.title}</span><span>날짜: __________</span></div></header>}<div className="worksheet-grid">{items.map((item)=><div className="worksheet-item" key={item.id}><span className="worksheet-number">{item.position}.</span><span className="worksheet-glyph">{item.character.glyph}</span><span className="worksheet-answer">（　　　　　）</span></div>)}</div></section>)}</main>;
}
