'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { AlertCircle } from 'lucide-react';
import { SiteLogo } from '@/components/site-logo';
import { useSiteBranding } from '@/contexts/site-branding';

export default function LoginPage() {
  const t = useTranslations('auth');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const router = useRouter();
  const { outletDisplayName } = useSiteBranding();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (authError) {
      setError(t('invalidCredentials'));
      setLoading(false);
      return;
    }

    await supabase.auth.getSession();
    router.push(`/${locale}`);
    router.refresh();
  };

  return (
    <div className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden p-4">
      <div
        className="pointer-events-none absolute inset-0 bg-gradient-to-br from-primary/[0.09] via-background to-accent/50"
        aria-hidden
      />
      <div
        className="pointer-events-none absolute -top-28 end-[-4rem] h-[22rem] w-[22rem] rounded-full bg-primary/[0.12] blur-3xl"
        aria-hidden
      />
      <div
        className="pointer-events-none absolute -bottom-36 start-[-5rem] h-[18rem] w-[18rem] rounded-full bg-primary/[0.08] blur-3xl"
        aria-hidden
      />
      <Card className="relative w-full max-w-md border-border/70 shadow-lg shadow-black/[0.04] dark:shadow-black/30">
        <CardHeader className="space-y-4 text-center">
          <div className="mx-auto flex h-[7.5rem] w-[7.5rem] items-center justify-center overflow-hidden rounded-2xl border bg-card shadow-md shadow-primary/10 sm:h-32 sm:w-32">
            <SiteLogo size={120} className="h-full w-full max-h-[7rem] max-w-[7rem] rounded-2xl object-contain p-2 sm:max-h-[7.5rem] sm:max-w-[7.5rem]" />
          </div>
          <p className="text-xl font-bold tracking-tight text-foreground">{outletDisplayName}</p>
          <div>
            <CardTitle className="text-2xl font-bold tracking-tight">{t('welcomeBack')}</CardTitle>
            <CardDescription className="mt-2 text-pretty">{t('loginSubtitle')}</CardDescription>
            <p className="mt-3 text-xs text-muted-foreground text-pretty">{t('loginTagline')}</p>
          </div>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin} className="space-y-4">
            {error && (
              <Alert variant="destructive">
                <AlertCircle className="h-4 w-4" />
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}
            <div className="space-y-2">
              <Label htmlFor="email">{t('email')}</Label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@maazym.com"
                required
                dir="ltr"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">{t('password')}</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                dir="ltr"
              />
            </div>
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? tCommon('loading') : t('login')}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
