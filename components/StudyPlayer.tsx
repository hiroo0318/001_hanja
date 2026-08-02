"use client";

import { useState } from "react";
import type { StudyGrade } from "@/lib/types";

export function StudyPlayer({ grade }: { grade: StudyGrade }) {
  const [index, setIndex] = useState(0);
  const [showAnswer, setShowAnswer] = useState(false);
  const item = grade.items[index];
  function move(nextIndex: number) { setIndex(nextIndex); setShowAnswer(false); }
  return <main className="exam study-player"><div className="exam-head"><a className="back" href="/yoonwoo/study">← 급수 선택</a><span>{grade.name} 공부</span></div><div className="progress"><i style={{width:`${((index + 1) / grade.items.length) * 100}%`}} /></div><div className="exam-head"><span>{index + 1} / {grade.items.length}</span><span>한자를 먼저 읽어 보세요</span></div><div className="hanja-card"><span className="glyph">{item.glyph}</span>{showAnswer && <div className="study-answer"><strong>{item.meaning} {item.reading}</strong></div>}</div><div className="study-actions"><button className="secondary" onClick={() => move(index - 1)} disabled={index === 0}>이전</button><button className="answer-button" onClick={() => setShowAnswer((value) => !value)}>{showAnswer ? "정답 가리기" : "정답 보기"}</button><button className="primary" onClick={() => move(index + 1)} disabled={index === grade.items.length - 1}>다음</button></div></main>;
}
