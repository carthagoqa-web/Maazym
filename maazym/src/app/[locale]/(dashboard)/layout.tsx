'use client';

import { Sidebar } from '@/components/layout/sidebar';
import { Header } from '@/components/layout/header';
import { useLocale } from 'next-intl';
import { useState } from 'react';
import { cn } from '@/lib/utils';
import { Sheet, SheetContent } from '@/components/ui/sheet';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const locale = useLocale();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const isRtl = locale === 'ar';

  return (
    <div className="min-h-screen bg-muted/40">
      <div className="hidden md:block">
        <Sidebar />
      </div>

      <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
        <SheetContent side={isRtl ? 'right' : 'left'} className="p-0 w-64">
          <Sidebar />
        </SheetContent>
      </Sheet>

      <div className={cn('flex flex-col transition-all duration-300', isRtl ? 'md:mr-64' : 'md:ml-64')}>
        <Header onMenuToggle={() => setMobileMenuOpen(true)} />
        <main className="flex-1 p-4 md:p-6">
          <div className="mx-auto w-full max-w-[1600px]">{children}</div>
        </main>
      </div>
    </div>
  );
}
