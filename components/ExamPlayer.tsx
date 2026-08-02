"use client";
import { useEffect, useMemo, useState } from "react";
import type { ChildRound } from "@/lib/types";

function timeText(seconds: number) { return `${String(Math.floor(seconds/60)).padStart(2,"0")}:${String(seconds%60).padStart(2,"0")}`; }
export function ExamPlayer({ round }: { round: ChildRound }) {
  const [index, setIndex] = useState(Math.max(0, round.items.findIndex((candidate) => candidate.position === round.currentPosition))); const [remaining, setRemaining] = useState(round.reviewIncorrect ? null : round.timer_seconds); const [done, setDone] = useState(false);
  const item = round.items[index]; const progress = useMemo(()=>((index+1)/round.items.length)*100,[index,round.items.length]);
  useEffect(()=>{ if (remaining === null || done) return; if (remaining <= 0) { finish(); return; } const id=window.setTimeout(()=>setRemaining(remaining-1),1000); return ()=>window.clearTimeout(id); },[remaining,done]);
  async function save(position: number, complete = false) { await fetch(`/api/yoonwoo/rounds/${round.id}/progress`, { method:"PATCH", headers:{"Content-Type":"application/json"}, body:JSON.stringify({position, completed:complete}) }); }
  async function next() { if (index === round.items.length-1) return finish(); const nextIndex=index+1; setIndex(nextIndex); if (!round.reviewIncorrect) await save(round.items[nextIndex].position); }
  async function previous() { if (index === 0) return; const previousIndex=index-1; setIndex(previousIndex); if (!round.reviewIncorrect) await save(round.items[previousIndex].position); }
  async function finish() { if (done) return; setDone(true); if (!round.reviewIncorrect) await save(round.items[round.items.length-1].position,true); }
  if (done) return <main className="exam"><div className="hanja-card"><div style={{textAlign:"center"}}><p className="eyebrow">수고했어요!</p><h1 className="page-title">{round.reviewIncorrect ? "틀린 문제를 다 풀었어요" : "시험을 마쳤어요"}</h1><p className="sub">{round.reviewIncorrect ? "답지를 다시 확인해 보세요." : "엄마와 함께 답지를 확인해 보세요."}</p><a className="primary" href="/yoonwoo/exam">차수 목록으로</a></div></div></main>;
  return <main className="exam"><div className="exam-head"><a className="back" href="/yoonwoo/exam">← 목록으로</a><span>{round.reviewIncorrect ? "틀린 문제 다시 풀기" : round.title}</span>{remaining !== null && <span className="timer">⏱ {timeText(remaining)}</span>}</div><div className="progress"><i style={{width:`${progress}%`}} /></div><div className="exam-head"><span>문제 {item.position} / {round.questionCount}</span><span>{round.reviewIncorrect ? `${index+1}번째 틀린 문제` : "뜻과 음을 말해 보세요"}</span></div><div className="hanja-card"><span className="glyph">{item.glyph}</span></div><div className="exam-actions"><button className="secondary" onClick={previous} disabled={index===0}>이전</button><button className="primary" onClick={next}>{index===round.items.length-1 ? "끝내기" : "다음 한자"}</button></div></main>;
}
