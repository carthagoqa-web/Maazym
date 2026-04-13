'use client';

import { usePathname } from 'next/navigation';
import { useTranslations, useLocale } from 'next-intl';
import Link from 'next/link';
import { cn } from '@/lib/utils';
import {
  LayoutDashboard,
  BookOpen,
  Package,
  UtensilsCrossed,
  Truck,
  ShoppingCart,
  Trash2,
  Tag,
  BarChart3,
  Settings,
  ChevronRight,
  ChevronLeft,
} from 'lucide-react';
import { SiteLogo } from '@/components/site-logo';
import { useSiteBranding } from '@/contexts/site-branding';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Button } from '@/components/ui/button';
import { useMemo, useState } from 'react';
import { useUser } from '@/hooks/use-user';
import type { UserRole } from '@/types/database';
import { canAccessReports, canAccessSuppliers } from '@/lib/roles';

type NavKey =
  | 'dashboard'
  | 'recipes'
  | 'inventory'
  | 'menu'
  | 'suppliers'
  | 'purchaseOrders'
  | 'waste'
  | 'promotions'
  | 'reports'
  | 'settings';

const ALL_NAV: { key: NavKey; href: string; icon: typeof LayoutDashboard }[] = [
  { key: 'dashboard', href: '', icon: LayoutDashboard },
  { key: 'recipes', href: '/recipes', icon: BookOpen },
  { key: 'inventory', href: '/inventory', icon: Package },
  { key: 'menu', href: '/menu', icon: UtensilsCrossed },
  { key: 'suppliers', href: '/suppliers', icon: Truck },
  { key: 'purchaseOrders', href: '/purchase-orders', icon: ShoppingCart },
  { key: 'waste', href: '/waste', icon: Trash2 },
  { key: 'promotions', href: '/promotions', icon: Tag },
  { key: 'reports', href: '/reports', icon: BarChart3 },
  { key: 'settings', href: '/settings', icon: Settings },
];

function navItemsForRole(role: UserRole | null | undefined) {
  return ALL_NAV.filter((item) => {
    if (item.key === 'suppliers') return canAccessSuppliers(role);
    if (item.key === 'reports') return canAccessReports(role);
    return true;
  });
}

export function Sidebar() {
  const t = useTranslations('nav');
  const locale = useLocale();
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);
  const isRtl = locale === 'ar';
  const { profile } = useUser();
  const { outletDisplayName } = useSiteBranding();
  const navItems = useMemo(() => navItemsForRole(profile?.role), [profile?.role]);

  const CollapseIcon = isRtl
    ? (collapsed ? ChevronLeft : ChevronRight)
    : (collapsed ? ChevronRight : ChevronLeft);

  return (
    <aside
      className={cn(
        'fixed top-0 bottom-0 z-30 flex flex-col border-e bg-sidebar transition-all duration-300',
        isRtl ? 'right-0' : 'left-0',
        collapsed ? 'w-16' : 'w-64'
      )}
    >
      <div className="flex min-h-16 items-center justify-between border-b px-3 py-2.5">
        {!collapsed && (
          <Link href={`/${locale}`} className="flex items-center gap-2.5 min-w-0">
            <SiteLogo size={48} className="rounded-xl shrink-0" />
            <span className="font-bold text-lg leading-tight truncate">{outletDisplayName}</span>
          </Link>
        )}
        {collapsed && (
          <div className="mx-auto py-0.5">
            <SiteLogo size={44} className="rounded-xl" />
          </div>
        )}
      </div>

      <ScrollArea className="flex-1 py-4">
        <nav className="space-y-1 px-2">
          {navItems.map((item) => {
            const fullHref = `/${locale}${item.href}`;
            const isActive = item.href === ''
              ? pathname === `/${locale}` || pathname === `/${locale}/`
              : pathname.startsWith(fullHref);

            return (
              <Link
                key={item.key}
                href={fullHref}
                className={cn(
                  'flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors duration-200',
                  isActive
                    ? 'bg-primary/12 text-primary shadow-sm ring-1 ring-primary/15'
                    : 'text-sidebar-foreground/75 hover:bg-sidebar-accent/70 hover:text-sidebar-foreground',
                  collapsed && 'justify-center px-2'
                )}
                title={collapsed ? t(item.key) : undefined}
              >
                <item.icon className="h-5 w-5 shrink-0" />
                {!collapsed && <span>{t(item.key)}</span>}
              </Link>
            );
          })}
        </nav>
      </ScrollArea>

      <div className="border-t p-2">
        <Button
          variant="ghost"
          size="sm"
          className="w-full"
          onClick={() => setCollapsed(!collapsed)}
        >
          <CollapseIcon className="h-4 w-4" />
        </Button>
      </div>
    </aside>
  );
}
