import Link from "next/link";
import { MomLogin } from "@/components/MomLogin";
export default function MomLoginPage() { return <main className="shell"><div className="login-nav"><Link className="back" href="/">← 처음으로</Link></div><MomLogin /></main>; }
