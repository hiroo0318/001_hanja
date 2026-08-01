import { notFound } from "next/navigation";
import { getChildRound } from "@/lib/db";
import { ExamPlayer } from "@/components/ExamPlayer";
export const dynamic = "force-dynamic";
export default async function YoonwooRoundPage({ params }: { params: Promise<{ id: string }> }) { const { id } = await params; const round = await getChildRound(id); if (!round) notFound(); return <ExamPlayer round={round} />; }
