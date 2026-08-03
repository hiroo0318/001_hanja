import { notFound } from "next/navigation";
import { getChildRound } from "@/lib/db";
import { ExamPlayer } from "@/components/ExamPlayer";
export const dynamic = "force-dynamic";
export default async function YoonwooRoundPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ review?: string; mode?: string }> }) { const { id } = await params; const { review, mode } = await searchParams; const round = await getChildRound(id, review === "incorrect", mode === "restart"); if (!round) notFound(); return <ExamPlayer round={round} />; }
