import { createBrowserClient } from '@supabase/ssr';

/**
 * isSingleton: false avoids a long-lived client getting stuck after a bad refresh
 * (common when async work runs inside onAuthStateChange elsewhere).
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { isSingleton: false }
  );
}
