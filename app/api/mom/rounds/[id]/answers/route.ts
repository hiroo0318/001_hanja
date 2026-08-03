import { NextResponse } from "next/server";
import { isMom } from "@/lib/auth";
import { markAnswer, resetRoundAnswers } from "@/lib/db";
export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) { if (!(await isMom())) return NextResponse.json({error:"unauthorized"},{status:401}); try { const { id } = await params; const { roundItemId, result } = await request.json(); if (typeof roundItemId !== "string" || (result !== null && !["correct","incorrect"].includes(result))) throw new Error("잘못된 채점 값입니다."); await markAnswer(id,roundItemId,result); return NextResponse.json({ok:true}); } catch (error) { return NextResponse.json({error:error instanceof Error ? error.message : "채점하지 못했습니다."},{status:400}); } }

export async function DELETE(_: Request, { params }: { params: Promise<{ id: string }> }) { if (!(await isMom())) return NextResponse.json({error:"unauthorized"},{status:401}); try { const { id } = await params; await resetRoundAnswers(id); return NextResponse.json({ok:true}); } catch (error) { return NextResponse.json({error:error instanceof Error ? error.message : "채점 초기화에 실패했습니다."},{status:400}); } }
