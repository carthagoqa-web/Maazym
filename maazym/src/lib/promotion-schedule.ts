import type { Promotion } from '@/types/database';

export function parseLocalDate(s: string | null): Date | null {
  if (!s) return null;
  const [y, m, d] = s.split('-').map(Number);
  if (!y || !m || !d) return null;
  return new Date(y, m - 1, d);
}

export function startOfTodayLocal(): Date {
  const t = new Date();
  return new Date(t.getFullYear(), t.getMonth(), t.getDate());
}

/** Matches Promotions page: enabled flag + optional start/end window. */
export function isPromotionActiveBySchedule(p: Promotion, today: Date): boolean {
  if (!p.is_active) return false;
  const start = parseLocalDate(p.start_date);
  const end = parseLocalDate(p.end_date);
  if (start && today < start) return false;
  if (end && today > end) return false;
  return true;
}

export function isPromotionExpiringThisWeek(p: Promotion, today: Date): boolean {
  if (!p.is_active || !p.end_date) return false;
  const end = parseLocalDate(p.end_date);
  if (!end) return false;
  const weekEnd = new Date(today);
  weekEnd.setDate(weekEnd.getDate() + 7);
  return end >= today && end <= weekEnd;
}
