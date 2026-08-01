"use client";
import { useState } from "react";

export function MomLogin() {
  const [pin, setPin] = useState(""); const [error, setError] = useState(""); const [pending, setPending] = useState(false);
  async function submit(event: React.FormEvent) {
    event.preventDefault(); setPending(true); setError("");
    const response = await fetch("/api/mom/login", { method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify({pin}) });
    if (response.ok) window.location.href = "/mom"; else setError("PIN이 맞지 않습니다. 다시 확인해 주세요.");
    setPending(false);
  }
  return <form className="panel login-card" onSubmit={submit}><p className="eyebrow">엄마 전용</p><h1 className="page-title">PIN을 입력해 주세요</h1><p className="sub">문제 생성, 답지 확인, 인쇄는 엄마만 할 수 있어요.</p><label className="field">PIN<input inputMode="numeric" type="password" autoFocus value={pin} onChange={(e)=>setPin(e.target.value)} /></label>{error && <p className="error">{error}</p>}<button className="primary" disabled={pending}>{pending ? "확인 중…" : "들어가기"}</button></form>;
}
