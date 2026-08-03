import "server-only";
import { createClient } from "@supabase/supabase-js";
import type { ChildRound, Grade, MomRound, RoundSummary, StudyGrade } from "@/lib/types";

function client() {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) throw new Error("SUPABASE_URL과 SUPABASE_SERVICE_ROLE_KEY를 설정하세요.");
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } }).schema("hanja");
}

function fail(error: { message: string } | null) {
  if (error) throw new Error(error.message);
}

export async function getGrades(): Promise<Grade[]> {
  const { data, error } = await client().from("grades").select("id, code, name, sort_order").order("sort_order");
  fail(error);
  return (data ?? []) as Grade[];
}

async function scoreForRound(roundId: string) {
  const { data: attempt, error: attemptError } = await client().from("exam_attempts").select("id").eq("round_id", roundId).maybeSingle();
  fail(attemptError);
  if (!attempt) return { correct: 0, incorrect: 0, checked: 0, gradedAt: null };
  const { data, error } = await client().from("exam_answers").select("result,checked_at").eq("attempt_id", attempt.id).not("result", "is", null);
  fail(error);
  return {
    correct: (data ?? []).filter((answer) => answer.result === "correct").length,
    incorrect: (data ?? []).filter((answer) => answer.result === "incorrect").length,
    checked: (data ?? []).length,
    gradedAt: (data ?? []).reduce<string | null>((latest, answer: any) => !answer.checked_at || (latest && latest > answer.checked_at) ? latest : answer.checked_at, null),
  };
}

export async function getRoundSummaries(hidden = false): Promise<RoundSummary[]> {
  const { data: rounds, error } = await client()
    .from("exam_rounds")
    .select("id,title,round_number,status,timer_seconds,created_at,grade:grades(name,code),items:exam_round_items(id)")
    .eq("is_hidden", hidden)
    .order("created_at", { ascending: false });
  fail(error);
  return Promise.all((rounds ?? []).map(async (round: any) => ({
    id: round.id,
    title: round.title,
    round_number: round.round_number,
    status: round.status,
    timer_seconds: round.timer_seconds,
    created_at: round.created_at,
    grade: round.grade,
    questionCount: round.items?.length ?? 0,
    score: await scoreForRound(round.id),
  })));
}

export async function createRound(gradeId: string, timerMinutes: number | null) {
  const timerSeconds = timerMinutes ? Math.round(timerMinutes * 60) : null;
  const { data, error } = await client().rpc("create_exam_round", {
    requested_grade_id: gradeId,
    requested_timer_seconds: timerSeconds,
  });
  fail(error);
  return data as string;
}

export async function getMomRound(roundId: string): Promise<MomRound | null> {
  const { data: round, error } = await client()
    .from("exam_rounds")
    .select("id,title,round_number,status,timer_seconds,created_at,grade:grades(name,code),items:exam_round_items(id,position,character:characters(glyph,meaning,reading))")
    .eq("id", roundId).maybeSingle();
  fail(error);
  if (!round) return null;
  const { data: attempt, error: attemptError } = await client().from("exam_attempts").select("id").eq("round_id", roundId).maybeSingle();
  fail(attemptError);
  const { data: answers, error: answersError } = attempt
    ? await client().from("exam_answers").select("round_item_id,result").eq("attempt_id", attempt.id)
    : { data: [], error: null };
  fail(answersError);
  const answerMap = new Map((answers ?? []).map((answer: any) => [answer.round_item_id, answer.result]));
  const items = [...(round.items ?? [])].sort((a: any, b: any) => a.position - b.position).map((item: any) => ({
    id: item.id, position: item.position, character: item.character, result: answerMap.get(item.id) ?? null,
  }));
  return {
    id: round.id, title: round.title, round_number: round.round_number, status: round.status,
    timer_seconds: round.timer_seconds, created_at: round.created_at, grade: Array.isArray(round.grade) ? round.grade[0] : round.grade,
    questionCount: items.length, score: await scoreForRound(round.id), items, attemptId: attempt?.id ?? null,
  };
}

export async function getChildRounds() {
  return getRoundSummaries();
}

export async function setRoundVisibility(roundIds: string[], hidden: boolean) {
  if (roundIds.length === 0) return;
  const { error } = await client()
    .from("exam_rounds")
    .update({ is_hidden: hidden, hidden_at: hidden ? new Date().toISOString() : null })
    .in("id", roundIds);
  fail(error);
}

export async function getStudyGrade(gradeId: string): Promise<StudyGrade | null> {
  const { data: grade, error } = await client()
    .from("grades")
    .select("id,name,items:grade_question_items(id,source_position,character:characters(glyph,meaning,reading))")
    .eq("id", gradeId)
    .maybeSingle();
  fail(error);
  if (!grade) return null;
  return {
    id: grade.id,
    name: grade.name,
    items: [...(grade.items ?? [])]
      .sort((a: any, b: any) => a.source_position - b.source_position)
      .map((item: any) => ({ id: item.id, position: item.source_position, ...item.character })),
  };
}

export async function getChildRound(roundId: string, reviewIncorrect = false): Promise<ChildRound | null> {
  const { data: round, error } = await client()
    .from("exam_rounds")
    .select("id,title,timer_seconds,status,is_hidden,grade:grades(name),items:exam_round_items(id,position,character:characters(glyph))")
    .eq("id", roundId).maybeSingle();
  fail(error);
  if (!round || round.is_hidden) return null;
  const { data: attempt, error: attemptError } = await client().from("exam_attempts").select("id,current_position").eq("round_id", roundId).maybeSingle();
  fail(attemptError);
  const { data: answers, error: answersError } = attempt
    ? await client().from("exam_answers").select("round_item_id,result").eq("attempt_id", attempt.id)
    : { data: [], error: null };
  fail(answersError);
  const resultByItemId = new Map((answers ?? []).map((answer: any) => [answer.round_item_id, answer.result]));
  const allItems = [...(round.items as any[])]
    .sort((a, b) => a.position - b.position)
    .map((item) => ({ id: item.id, position: item.position, glyph: item.character.glyph, result: resultByItemId.get(item.id) }));
  const items = reviewIncorrect ? allItems.filter((item) => item.result === "incorrect") : allItems;
  if (items.length === 0) return null;
  return {
    id: round.id, title: round.title, timer_seconds: round.timer_seconds, status: round.status,
    gradeName: (Array.isArray(round.grade) ? round.grade[0] : round.grade as any).name,
    currentPosition: reviewIncorrect || round.status === "completed" ? items[0].position : attempt?.current_position ?? items[0].position,
    questionCount: allItems.length,
    reviewIncorrect,
    items: items.map(({ id, position, glyph }) => ({ id, position, glyph })),
  };
}

export async function saveProgress(roundId: string, position: number, completed: boolean) {
  const db = client();
  const { data: existing, error: existingError } = await db.from("exam_attempts").select("id").eq("round_id", roundId).maybeSingle();
  fail(existingError);
  const now = new Date().toISOString();
  if (existing) {
    const { error } = await db.from("exam_attempts").update({ current_position: position, status: completed ? "completed" : "in_progress", completed_at: completed ? now : null }).eq("id", existing.id);
    fail(error);
  } else {
    const { error } = await db.from("exam_attempts").insert({ round_id: roundId, current_position: position, started_at: now, status: completed ? "completed" : "in_progress", completed_at: completed ? now : null });
    fail(error);
  }
  const { error } = await db.from("exam_rounds").update({ status: completed ? "completed" : "in_progress" }).eq("id", roundId);
  fail(error);
}

export async function markAnswer(roundId: string, roundItemId: string, result: "correct" | "incorrect" | null) {
  const db = client();
  let { data: attempt, error: attemptError } = await db.from("exam_attempts").select("id").eq("round_id", roundId).maybeSingle();
  fail(attemptError);
  if (!attempt && result === null) return;
  if (!attempt) {
    const { data, error } = await db.from("exam_attempts").insert({ round_id: roundId, started_at: new Date().toISOString() }).select("id").single();
    fail(error);
    attempt = data;
  }
  if (!attempt) throw new Error("시험 진행 정보를 만들 수 없습니다.");
  if (result === null) {
    const { error } = await db.from("exam_answers").delete().eq("attempt_id", attempt.id).eq("round_item_id", roundItemId);
    fail(error);
    return;
  }
  const { error } = await db.from("exam_answers").upsert({ attempt_id: attempt.id, round_item_id: roundItemId, result, checked_at: new Date().toISOString() }, { onConflict: "attempt_id,round_item_id" });
  fail(error);
}
