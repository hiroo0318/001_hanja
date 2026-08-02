import { notFound } from "next/navigation";
import { getStudyGrade } from "@/lib/db";
import { StudyPlayer } from "@/components/StudyPlayer";
export const dynamic = "force-dynamic";

export default async function StudyPlayerPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const grade = await getStudyGrade(id);
  if (!grade || grade.items.length === 0) notFound();
  return <StudyPlayer grade={grade} />;
}
