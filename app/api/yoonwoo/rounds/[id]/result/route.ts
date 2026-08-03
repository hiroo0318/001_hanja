import { NextResponse } from "next/server";
import { getChildItemResult } from "@/lib/db";

export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const roundItemId = new URL(request.url).searchParams.get("roundItemId");
    if (!roundItemId) throw new Error("문항 정보가 필요합니다.");
    const result = await getChildItemResult(id, roundItemId);
    if (!result) return NextResponse.json({ error: "not_found" }, { status: 404 });
    return NextResponse.json(result);
  } catch (error) {
    return NextResponse.json({ error: error instanceof Error ? error.message : "채점 결과를 불러오지 못했습니다." }, { status: 400 });
  }
}
