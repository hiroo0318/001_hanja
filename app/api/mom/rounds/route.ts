import { NextResponse } from "next/server";
import { isMom } from "@/lib/auth";
import { createRound } from "@/lib/db";
export async function POST(request: Request) { if (!(await isMom())) return NextResponse.json({error:"unauthorized"},{status:401}); try { const { gradeId, timerMinutes } = await request.json(); if (typeof gradeId !== "string") throw new Error("급수를 선택하세요."); const minutes = timerMinutes === null ? null : Number(timerMinutes); if (minutes !== null && (!Number.isFinite(minutes) || minutes < 1 || minutes > 180)) throw new Error("시험 시간은 1~180분으로 입력하세요."); return NextResponse.json({id:await createRound(gradeId,minutes)}); } catch (error) { return NextResponse.json({error:error instanceof Error ? error.message : "차수를 만들지 못했습니다."},{status:400}); } }
