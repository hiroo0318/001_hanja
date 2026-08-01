"use client";
import { useState } from "react";
import type { Grade } from "@/lib/types";

export function RoundCreator({ grades }: { grades: Grade[] }) {
  const [gradeId, setGradeId] = useState(grades[0]?.id ?? ""); const [timerOn, setTimerOn] = useState(false); const [minutes, setMinutes] = useState("10"); const [error, setError] = useState(""); const [pending, setPending] = useState(false);
  async function create(event: React.FormEvent) {
    event.preventDefault(); setPending(true); setError("");
    const timerMinutes = timerOn ? Number(minutes) : null;
    const response = await fetch("/api/mom/rounds", { method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify({gradeId, timerMinutes}) });
    const body = await response.json();
    if (!response.ok) { setError(body.error ?? "차수를 만들지 못했습니다."); setPending(false); return; }
    window.location.href = `/mom/round/${body.id}`;
  }
  return <form className="panel" onSubmit={create}><h2>새 차수 만들기</h2><label className="field">급수 선택<select className="grade-select" value={gradeId} onChange={(e)=>setGradeId(e.target.value)}>{grades.map((grade)=><option key={grade.id} value={grade.id}>{grade.name}</option>)}</select></label><label className="timer-toggle"><span><strong>타이머 사용</strong><small>시험 시간 제한을 설정해요</small></span><input type="checkbox" checked={timerOn} onChange={(e)=>setTimerOn(e.target.checked)} /></label>{timerOn && <label className="field">시험 시간 (분)<input type="number" min="1" max="180" value={minutes} onChange={(e)=>setMinutes(e.target.value)} /></label>}{error && <p className="error">{error}</p>}<button className="primary creator-submit" disabled={!gradeId || pending}>{pending ? "무작위 문제를 만드는 중…" : "랜덤 차수 생성"}</button></form>;
}
