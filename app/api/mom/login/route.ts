import { NextResponse } from "next/server";
import { momCookieName, sessionValue, verifyPin } from "@/lib/auth";
export async function POST(request: Request) { const { pin } = await request.json(); if (typeof pin !== "string" || !verifyPin(pin)) return NextResponse.json({error:"invalid"},{status:401}); const session = sessionValue(); const response = NextResponse.json({ok:true}); response.cookies.set(momCookieName,session.value,{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV === "production",path:"/",maxAge:session.maxAge}); return response; }
