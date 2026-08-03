import { NextResponse } from "next/server";
import { isMom } from "@/lib/auth";
import { setRoundVisibility } from "@/lib/db";

export async function PATCH(request: Request) {
  if (!(await isMom())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  try {
    const { roundIds, hidden } = await request.json();
    if (!Array.isArray(roundIds) || roundIds.length === 0 || !roundIds.every((id) => typeof id === "string") || typeof hidden !== "boolean") {
      throw new Error("잘못된 차수 선택입니다.");
    }
    await setRoundVisibility(roundIds, hidden);
    return NextResponse.json({ ok: true });
  } catch (error) {
    return NextResponse.json({ error: error instanceof Error ? error.message : "차수 상태를 변경하지 못했습니다." }, { status: 400 });
  }
}
