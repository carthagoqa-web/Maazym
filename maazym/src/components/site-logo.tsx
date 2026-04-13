'use client';

import { UtensilsCrossed } from 'lucide-react';
import { cn } from '@/lib/utils';
import { useSiteBranding } from '@/contexts/site-branding';

type SiteLogoProps = {
  className?: string;
  iconClassName?: string;
  /** Pixel size for logo image (square); fallback icon uses same box */
  size?: number;
};

export function SiteLogo({ className, iconClassName, size = 40 }: SiteLogoProps) {
  const { logoUrl } = useSiteBranding();

  if (logoUrl) {
    return (
      // eslint-disable-next-line @next/next/no-img-element -- dynamic Supabase public URL
      <img
        src={logoUrl}
        alt=""
        width={size}
        height={size}
        className={cn('object-contain', className)}
      />
    );
  }

  return (
    <div
      className={cn('flex items-center justify-center rounded-xl bg-primary text-primary-foreground', className)}
      style={{ width: size, height: size }}
    >
      <UtensilsCrossed
        className={cn('text-primary-foreground', iconClassName)}
        style={{ width: size * 0.45, height: size * 0.45 }}
      />
    </div>
  );
}
