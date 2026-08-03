export type Grade = { id: string; code: string; name: string; sort_order: number };

export type RoundSummary = {
  id: string;
  title: string;
  round_number: number;
  status: "ready" | "in_progress" | "completed";
  timer_seconds: number | null;
  created_at: string;
  grade: { name: string; code: string };
  questionCount: number;
  score: { correct: number; incorrect: number; checked: number; gradedAt: string | null };
};

export type MomRound = RoundSummary & {
  items: Array<{
    id: string;
    position: number;
    character: { glyph: string; meaning: string; reading: string };
    result: "correct" | "incorrect" | null;
  }>;
  attemptId: string | null;
};

export type ChildRound = {
  id: string;
  title: string;
  timer_seconds: number | null;
  status: "ready" | "in_progress" | "completed";
  gradeName: string;
  currentPosition: number;
  questionCount: number;
  reviewIncorrect: boolean;
  items: Array<{ id: string; position: number; glyph: string }>;
};

export type StudyGrade = {
  id: string;
  name: string;
  items: Array<{ id: string; position: number; glyph: string; meaning: string; reading: string }>;
};
