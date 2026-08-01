"use client";
import { useEffect, useMemo, useState } from "react";
import type { ChildRound } from "@/lib/types";

function timeText(seconds: number) { return `${String(Math.floor(seconds/60)).padStart(2,"0")}:${String(seconds%60).padStart(2,"0")}`; }
export function ExamPlayer({ round }: { round: ChildRound }) {
  const [index, setIndex] = useState(Math.max(0, round.currentPosition - 1)); const [remaining, setRemaining] = useState(round.timer_seconds); const [done, setDone] = useState(false);
  const item = round.items[index]; const progress = useMemo(()=>((index+1)/round.items.length)*100,[index,round.items.length]);
  useEffect(()=>{ if (remaining === null || done) return; if (remaining <= 0) { finish(); return; } const id=window.setTimeout(()=>setRemaining(remaining-1),1000); return ()=>window.clearTimeout(id); },[remaining,done]);
  async function save(position: number, complete = false) { await fetch(`/api/yoonwoo/rounds/${round.id}/progress`, { method:"PATCH", headers:{"Content-Type":"application/json"}, body:JSON.stringify({position, completed:complete}) }); }
  async function next() { if (index === round.items.length-1) return finish(); const nextIndex=index+1; setIndex(nextIndex); await save(nextIndex+1); }
  async function previous() { if (index === 0) return; const previousIndex=index-1; setIndex(previousIndex); await save(previousIndex+1); }
  async function finish() { if (done) return; setDone(true); await save(round.items.length,true); }
  if (done) return <main className="exam"><div className="hanja-card"><div style={{textAlign:"center"}}><p className="eyebrow">수고했어요!</p><h1 className="page-title">시험을 마쳤어요</h1><p className="sub">엄마와 함께 답지를 확인해 보세요.</p><a className="primary" href="/yoonwoo">차수 목록으로</a></div></div></main>;
  return <main className="exam"><div className="exam-head"><a className="back" href="/yoonwoo">← 목록으로</a><span>{round.title}</span>{remaining !== null && <span className="timer">⏱ {timeText(remaining)}</span>}</div><div className="progress"><i style={{width:`${progress}%`}} /></div><div className="exam-head"><span>{index+1} / {round.items.length}</span><span>뜻과 음을 말해 보세요</span></div><div className="hanja-card"><span className="glyph">{item.glyph}</span></div><div className="exam-actions"><button className="secondary" onClick={previous} disabled={index===0}>이전</button><button className="primary" onClick={next}>{index===round.items.length-1 ? "시험 끝내기" : "다음 한자"}</button></div></main>;
}
