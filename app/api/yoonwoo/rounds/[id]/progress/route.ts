import { NextResponse } from "next/server";
import { saveProgress } from "@/lib/db";
export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) { try { const { id } = await params; const { position, completed } = await request.json(); if (!Number.isInteger(position) || position < 1 || typeof completed !== "boolean") throw new Error("잘못된 진행 상태입니다."); await saveProgress(id,position,completed); return NextResponse.json({ok:true}); } catch (error) { return NextResponse.json({error:error instanceof Error ? error.message : "진행 상태를 저장하지 못했습니다."},{status:400}); } }
