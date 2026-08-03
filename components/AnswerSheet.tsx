"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import type { MomRound } from "@/lib/types";
import { formatMeaningReading } from "@/lib/hanja";

export function AnswerSheet({ round, onResultChange }: { round: MomRound; onResultChange?: (itemId: string, result: "correct" | "incorrect" | null) => void }) {
  const [results, setResults] = useState<Record<string, string | null>>(Object.fromEntries(round.items.map((item)=>[item.id,item.result])));
  const router = useRouter();
  async function mark(itemId: string, result: "correct" | "incorrect") {
    const previous = results[itemId];
    const nextResult = previous === result ? null : result;
    setResults((value)=>({ ...value, [itemId]: nextResult }));
    onResultChange?.(itemId, nextResult);
    const response = await fetch(`/api/mom/rounds/${round.id}/answers`, { method:"PATCH", headers:{"Content-Type":"application/json"}, body:JSON.stringify({roundItemId:itemId,result:nextResult}) });
    if (!response.ok) { setResults((value)=>({ ...value, [itemId]: previous })); onResultChange?.(itemId, previous as "correct" | "incorrect" | null); return; }
    router.refresh();
  }
  return <section className="panel"><h2>답지 · 채점</h2>{round.items.map((item)=><div className="answer-row" key={item.id}><b>{item.position}</b><span className="answer-glyph">{item.character.glyph}</span><span className="answer-text"><strong>{formatMeaningReading(item.character.meaning, item.character.reading)}</strong></span><span className="mark"><button className={results[item.id] === "correct" ? "selected-correct" : ""} onClick={()=>mark(item.id,"correct")}>맞음</button><button className={results[item.id] === "incorrect" ? "selected-incorrect" : ""} onClick={()=>mark(item.id,"incorrect")}>틀림</button></span></div>)}</section>;
}
