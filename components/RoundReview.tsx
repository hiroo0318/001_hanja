"use client";

import { useMemo, useState } from "react";
import { AnswerSheet } from "@/components/AnswerSheet";
import type { MomRound } from "@/lib/types";

export function RoundReview({ round }: { round: MomRound }) {
  const [results, setResults] = useState<Record<string, "correct" | "incorrect" | null>>(Object.fromEntries(round.items.map((item) => [item.id, item.result])));
  const score = useMemo(() => {
    const values = Object.values(results);
    return { checked: values.filter((value) => value !== null).length, correct: values.filter((value) => value === "correct").length };
  }, [results]);
  return <><p className="sub">채점 {score.checked}/{round.questionCount} · 맞음 {score.correct}개</p><AnswerSheet round={round} onResultChange={(itemId, result) => setResults((value) => ({ ...value, [itemId]: result }))} onReset={() => setResults(Object.fromEntries(round.items.map((item) => [item.id, null])))} /></>;
}
