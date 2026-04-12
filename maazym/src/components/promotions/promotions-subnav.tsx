'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useLocale, useTranslations } from 'next-intl';
import { cn } from '@/lib/utils';
import { useMemo } from 'react';
import { useUser } from '@/hooks/use-user';
import { canAccessPriceSimulator } from '@/lib/roles';

const LINKS = [
  { suffix: '', key: 'subnavList' as const },
  { suffix: '/calculator', key: 'calculator' as const },
  { suffix: '/simulator', key: 'simulator' as const },
  { suffix: '/compare', key: 'compare' as const },
];

export function PromotionsSubnav() {
  const locale = useLocale();
  const pathname = usePathname();
  const t = useTranslations('promotions');
  const { profile } = useUser();
  const links = useMemo(() => {
    if (canAccessPriceSimulator(profile?.role)) return LINKS;
    return LINKS.filter((l) => l.suffix === '');
  }, [profile?.role]);

  return (
    <nav className="flex flex-wrap gap-2 border-b pb-3">
      {links.map(({ suffix, key }) => {
        const href = `/${locale}/promotions${suffix}`;
        const base = `/${locale}/promotions`;
        const isActive =
          suffix === ''
            ? pathname === base || pathname === `${base}/`
            : pathname.startsWith(`/${locale}/promotions${suffix}`);

        return (
          <Link
            key={suffix || 'root'}
            href={href}
            className={cn(
              'rounded-md px-3 py-1.5 text-sm font-medium transition-colors',
              isActive
                ? 'bg-primary text-primary-foreground'
                : 'bg-muted/60 text-muted-foreground hover:bg-muted hover:text-foreground'
            )}
          >
            {t(key)}
          </Link>
        );
      })}
    </nav>
  );
}
