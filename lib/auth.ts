import crypto from "node:crypto";
import { cookies } from "next/headers";

const COOKIE_NAME = "hanja_mom";
const MAX_AGE_SECONDS = 60 * 60 * 8;

function required(name: string) {
  const value = process.env[name];
  if (!value) throw new Error(`${name} 환경 변수가 필요합니다.`);
  return value;
}

function sign(payload: string) {
  return crypto.createHmac("sha256", required("MOM_SESSION_SECRET")).update(payload).digest("hex");
}

export function verifyPin(pin: string) {
  const expected = Buffer.from(required("MOM_PIN"));
  const actual = Buffer.from(pin);
  return actual.length === expected.length && crypto.timingSafeEqual(actual, expected);
}

export function sessionValue() {
  const expiresAt = Math.floor(Date.now() / 1000) + MAX_AGE_SECONDS;
  const payload = `mom.${expiresAt}`;
  return { value: `${payload}.${sign(payload)}`, maxAge: MAX_AGE_SECONDS };
}

export async function isMom() {
  const value = (await cookies()).get(COOKIE_NAME)?.value;
  if (!value) return false;
  const [role, expiresAt, signature] = value.split(".");
  if (role !== "mom" || !expiresAt || !signature || Number(expiresAt) < Date.now() / 1000) return false;
  const payload = `${role}.${expiresAt}`;
  const expected = sign(payload);
  return signature.length === expected.length && crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expected));
}

export const momCookieName = COOKIE_NAME;
