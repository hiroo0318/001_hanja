import Link from "next/link";
import { getGrades } from "@/lib/db";
export const dynamic = "force-dynamic";

export default async function StudyGradePage() {
  const grades = await getGrades();
  return <main className="shell"><nav className="nav"><Link className="brand" href="/">漢 한자 차수 시험</Link><Link className="back" href="/yoonwoo">← 윤우 메뉴</Link></nav><p className="eyebrow">윤우 공부</p><h1 className="page-title">어떤 급수를<br />공부할까?</h1><p className="sub">한자를 먼저 읽어 보고, 정답을 확인해 보세요.</p><div className="grade-study-list">{grades.map((grade)=><Link className="round-card" key={grade.id} href={`/yoonwoo/study/${grade.id}`}><div className="round-top"><span className="round-title">{grade.name}</span><span className="badge">공부하기</span></div></Link>)}</div></main>;
}
