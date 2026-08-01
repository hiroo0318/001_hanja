import { NextResponse } from "next/server";
import { momCookieName } from "@/lib/auth";
export async function GET(request: Request) { const response = NextResponse.redirect(new URL("/",request.url)); response.cookies.set(momCookieName,"",{path:"/",maxAge:0}); return response; }
