import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = { title: "한자 차수 시험", description: "한자 급수 시험 연습" };

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="ko"><body>{children}</body></html>;
}
