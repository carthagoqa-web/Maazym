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
import { publicStorageObjectUrl } from '@/lib/public-storage-url';

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
    const { data } = await supabase
      .from('site_branding')
      .select('logo_path, updated_at, outlet_name_en, outlet_name_ar')
      .eq('id', 1)
      .maybeSingle();

    if (data) {
      const en =
        typeof data.outlet_name_en === 'string' && data.outlet_name_en.trim()
          ? data.outlet_name_en.trim()
          : DEFAULT_OUTLET_EN;
      const ar =
        typeof data.outlet_name_ar === 'string' && data.outlet_name_ar.trim()
          ? data.outlet_name_ar.trim()
          : DEFAULT_OUTLET_AR;
      setOutletNameEn(en);
      setOutletNameAr(ar);

      if (data.logo_path) {
        const base = publicStorageObjectUrl(BUCKET, data.logo_path);
        if (base) {
          const v = data.updated_at ? new Date(data.updated_at).getTime() : Date.now();
          setLogoUrl(`${base}?v=${v}`);
        } else {
          setLogoUrl(null);
        }
      } else {
        setLogoUrl(null);
      }
    } else {
      setLogoUrl(null);
      setOutletNameEn(DEFAULT_OUTLET_EN);
      setOutletNameAr(DEFAULT_OUTLET_AR);
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
