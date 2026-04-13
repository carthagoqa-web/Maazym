'use client';

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react';
import { useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';

const BUCKET = 'site-assets';

export const SITE_BRANDING_CHANGED = 'maazym:site-branding-changed';

type SiteBrandingState = {
  logoUrl: string | null;
  outletNameEn: string;
  outletNameAr: string;
  /** Resolved for current locale */
  outletDisplayName: string;
  loading: boolean;
  refetch: () => Promise<void>;
};

const DEFAULT_OUTLET_EN = 'Maazym';
const DEFAULT_OUTLET_AR = 'معزم';

const SiteBrandingContext = createContext<SiteBrandingState | null>(null);

export function SiteBrandingProvider({ children }: { children: ReactNode }) {
  const locale = useLocale();
  const [logoUrl, setLogoUrl] = useState<string | null>(null);
  const [outletNameEn, setOutletNameEn] = useState(DEFAULT_OUTLET_EN);
  const [outletNameAr, setOutletNameAr] = useState(DEFAULT_OUTLET_AR);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    const supabase = createClient();
    // select('*') so production DBs that only ran 00012 (no outlet columns yet) still return logo_path.
    // Explicit column lists error when outlet_name_* columns are missing, and the whole row is dropped.
    const { data, error } = await supabase.from('site_branding').select('*').eq('id', 1).maybeSingle();

    if (error || !data) {
      setLogoUrl(null);
      setOutletNameEn(DEFAULT_OUTLET_EN);
      setOutletNameAr(DEFAULT_OUTLET_AR);
      return;
    }

    const row = data as {
      logo_path?: string | null;
      updated_at?: string | null;
      outlet_name_en?: string | null;
      outlet_name_ar?: string | null;
    };

    const en =
      typeof row.outlet_name_en === 'string' && row.outlet_name_en.trim()
        ? row.outlet_name_en.trim()
        : DEFAULT_OUTLET_EN;
    const ar =
      typeof row.outlet_name_ar === 'string' && row.outlet_name_ar.trim()
        ? row.outlet_name_ar.trim()
        : DEFAULT_OUTLET_AR;
    setOutletNameEn(en);
    setOutletNameAr(ar);

    if (row.logo_path) {
      const { data: pub } = supabase.storage.from(BUCKET).getPublicUrl(row.logo_path);
      const v = row.updated_at ? new Date(row.updated_at).getTime() : Date.now();
      setLogoUrl(`${pub.publicUrl}?v=${v}`);
    } else {
      setLogoUrl(null);
    }
  }, []);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      await load();
      if (!cancelled) setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [load]);

  useEffect(() => {
    const onChange = () => {
      void (async () => {
        await load();
      })();
    };
    window.addEventListener(SITE_BRANDING_CHANGED, onChange);
    return () => window.removeEventListener(SITE_BRANDING_CHANGED, onChange);
  }, [load]);

  const value = useMemo<SiteBrandingState>(
    () => ({
      logoUrl,
      outletNameEn,
      outletNameAr,
      outletDisplayName: locale === 'ar' ? outletNameAr : outletNameEn,
      loading,
      refetch: load,
    }),
    [logoUrl, outletNameEn, outletNameAr, locale, loading, load]
  );

  return <SiteBrandingContext.Provider value={value}>{children}</SiteBrandingContext.Provider>;
}

export function useSiteBranding() {
  const ctx = useContext(SiteBrandingContext);
  if (!ctx) {
    throw new Error('useSiteBranding must be used within SiteBrandingProvider');
  }
  return ctx;
}
