"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export function RoundCompletionButton({ roundId }: { roundId: string }) {
  const router = useRouter();
  const [pending, setPending] = useState(false);

  async function completeRound() {
    setPending(true);
    try {
      const response = await fetch("/api/mom/rounds/visibility", {
        method: "PATCH",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ roundIds: [roundId], hidden: true }),
      });
      if (!response.ok) throw new Error((await response.json()).error ?? "처리하지 못했습니다.");
      router.refresh();
    } catch (error) {
      window.alert(error instanceof Error ? error.message : "처리하지 못했습니다.");
      setPending(false);
    }
  }

  return <button className="secondary round-complete" type="button" onClick={completeRound} disabled={pending}>{pending ? "처리 중…" : "시험 완료"}</button>;
}
