"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { RoundSummary } from "@/lib/types";

function dateText(value: string | null) {
  if (!value) return "채점 전";
  return new Intl.DateTimeFormat("ko-KR", { year: "numeric", month: "numeric", day: "numeric" }).format(new Date(value));
}

export function ArchivedRounds({ rounds }: { rounds: RoundSummary[] }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [selected, setSelected] = useState<string[]>([]);
  const [pending, setPending] = useState(false);

  function toggle(roundId: string) {
    setSelected((current) => current.includes(roundId) ? current.filter((id) => id !== roundId) : [...current, roundId]);
  }

  async function restore() {
    if (!selected.length) return;
    setPending(true);
    try {
      const response = await fetch("/api/mom/rounds/visibility", {
        method: "PATCH",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ roundIds: selected, hidden: false }),
      });
      if (!response.ok) throw new Error((await response.json()).error ?? "재노출하지 못했습니다.");
      setOpen(false);
      setSelected([]);
      router.refresh();
    } catch (error) {
      window.alert(error instanceof Error ? error.message : "재노출하지 못했습니다.");
    } finally {
      setPending(false);
    }
  }

  return <><button className="secondary archive-trigger" type="button" onClick={() => setOpen(true)}>지난 차수 보기{rounds.length ? ` (${rounds.length})` : ""}</button>{open && <div className="modal-backdrop" role="presentation"><section className="archive-modal" role="dialog" aria-modal="true" aria-labelledby="archive-title"><div className="modal-header"><div><p className="eyebrow">엄마 전용</p><h2 id="archive-title">지난 차수</h2></div><button className="modal-close" type="button" onClick={() => setOpen(false)} aria-label="닫기">×</button></div>{rounds.length === 0 ? <p className="empty">비노출 처리한 차수가 없어요.</p> : <div className="archive-list">{rounds.map((round) => { const isSelected = selected.includes(round.id); return <div className={`archive-row${isSelected ? " is-selected" : ""}`} key={round.id} role="button" tabIndex={0} aria-pressed={isSelected} onClick={() => toggle(round.id)} onKeyDown={(event) => { if (event.key === "Enter" || event.key === " ") { event.preventDefault(); toggle(round.id); } }}><span className="archive-info"><strong>{round.title}</strong><small>생성일 {dateText(round.created_at)} · 채점일 {dateText(round.score.gradedAt)} · 최종 점수 {round.score.correct}/{round.questionCount}</small></span><span className="archive-choice">{isSelected ? "선택됨" : "선택"}</span></div>; })}</div>}<div className="modal-actions"><button className="secondary" type="button" onClick={() => setOpen(false)}>닫기</button><button className="primary" type="button" onClick={restore} disabled={pending || !selected.length}>{pending ? "처리 중…" : `선택 차수 재시험${selected.length ? ` (${selected.length})` : ""}`}</button></div></section></div>}</>;
}
