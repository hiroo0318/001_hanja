"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";

export function ChildRoundsRefresh() {
  const router = useRouter();
  const [refreshing, setRefreshing] = useState(false);
  const [, startTransition] = useTransition();

  function refreshRounds() {
    if (refreshing) return;
    setRefreshing(true);
    startTransition(() => router.refresh());
    window.setTimeout(() => setRefreshing(false), 800);
  }

  return <button className={`secondary rounds-refresh ${refreshing ? "is-refreshing" : ""}`} type="button" onClick={refreshRounds} disabled={refreshing} aria-live="polite">{refreshing ? "새 차수 확인 중…" : "새 차수 확인"}</button>;
}
