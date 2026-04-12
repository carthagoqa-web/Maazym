import { NextIntlClientProvider, hasLocale } from 'next-intl';
import { notFound } from 'next/navigation';
import { routing } from '@/i18n/routing';
import { Toaster } from '@/components/ui/sonner';
import { TooltipProvider } from '@/components/ui/tooltip';

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  return {
    other: {
      dir: locale === 'ar' ? 'rtl' : 'ltr',
    },
  };
}

export default async function LocaleLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  const messages = (await import(`@/messages/${locale}.json`)).default;
  const dir = locale === 'ar' ? 'rtl' : 'ltr';

  return (
    <div lang={locale} dir={dir} className="min-h-screen">
      <NextIntlClientProvider locale={locale} messages={messages}>
        <TooltipProvider>
          {children}
          <Toaster position={locale === 'ar' ? 'bottom-left' : 'bottom-right'} />
        </TooltipProvider>
      </NextIntlClientProvider>
    </div>
  );
}
