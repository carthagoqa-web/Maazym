'use client';

import { useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import type { Profile } from '@/types/database';
import type { User } from '@supabase/supabase-js';

/** Max wait for getSession; avoids UI stuck forever if the auth client deadlocks. */
const SESSION_INIT_MS = 12_000;

export function useUser() {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const supabase = createClient();
    let cancelled = false;

    function loadProfileForUser(userId: string) {
      return Promise.resolve(
        supabase.from('profiles').select('*').eq('id', userId).maybeSingle()
      )
        .then(({ data, error }) => {
          if (error) console.error('profiles select:', error.message);
          if (!cancelled) setProfile((data as Profile | null) ?? null);
        })
        .catch((e) => {
          console.error('loadProfileForUser:', e);
          if (!cancelled) setProfile(null);
        });
    }

    const sessionTimeout = new Promise<never>((_, reject) => {
      setTimeout(() => reject(new Error('getSession timeout')), SESSION_INIT_MS);
    });

    Promise.race([supabase.auth.getSession(), sessionTimeout])
      .then(({ data: { session } }) => {
        if (cancelled) return;
        const currentUser = session?.user ?? null;
        setUser(currentUser);
        if (currentUser) {
          return loadProfileForUser(currentUser.id);
        }
        setProfile(null);
      })
      .catch((e) => {
        console.error('useUser session init:', e);
        if (!cancelled) {
          setUser(null);
          setProfile(null);
        }
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      const u = session?.user ?? null;
      setUser(u);
      if (u) {
        // Never use async/await here — it can deadlock the GoTrue client (Supabase docs / GH #35754).
        queueMicrotask(() => {
          void loadProfileForUser(u.id);
        });
      } else {
        setProfile(null);
      }
    });

    return () => {
      cancelled = true;
      subscription.unsubscribe();
    };
  }, []);

  return { user, profile, loading };
}
