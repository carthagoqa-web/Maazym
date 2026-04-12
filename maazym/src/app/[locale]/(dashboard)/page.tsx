'use client';

import { useEffect, useState } from 'react';
import { useTranslations } from 'next-intl';
import { useUser } from '@/hooks/use-user';
import { createClient } from '@/lib/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { BookOpen, Package, AlertTriangle, Tag, TrendingDown, Activity } from 'lucide-react';
import { cn } from '@/lib/utils';
import { withTimeout } from '@/lib/with-timeout';

export default function DashboardPage() {
  const t = useTranslations('dashboard');
  const { profile } = useUser();
  const [counts, setCounts] = useState({ recipes: 0, items: 0, lowStock: 0, promos: 0 });
  const [dataLoaded, setDataLoaded] = useState(false);

  useEffect(() => {
    async function loadCounts() {
      try {
        const supabase = createClient();
        const [recipesRes, itemsRes, lowStockRes, promosRes] = await withTimeout(
          Promise.all([
            supabase.from('recipes').select('id', { count: 'exact', head: true }).eq('is_active', true),
            supabase.from('inventory_items').select('id', { count: 'exact', head: true }).eq('is_active', true),
            supabase.from('daily_stock_summary').select('item_id', { count: 'exact', head: true }).eq('stock_status', 'low_stock'),
            supabase.from('promotions').select('id', { count: 'exact', head: true }).eq('is_active', true),
          ]),
          30_000,
          'Dashboard counts'
        );
        setCounts({
          recipes: recipesRes.count ?? 0,
          items: itemsRes.count ?? 0,
          lowStock: lowStockRes.count ?? 0,
          promos: promosRes.count ?? 0,
        });
      } catch (e) {
        console.error('Dashboard counts error:', e);
      } finally {
        setDataLoaded(true);
      }
    }
    loadCounts();
  }, []);

  if (!dataLoaded) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <Skeleton key={i} className="h-32" />
          ))}
        </div>
      </div>
    );
  }

  const stats = [
    { title: t('totalRecipes'), value: String(counts.recipes), icon: BookOpen, color: 'text-blue-600' },
    { title: t('totalItems'), value: String(counts.items), icon: Package, color: 'text-green-600' },
    { title: t('lowStockItems'), value: String(counts.lowStock), icon: AlertTriangle, color: 'text-orange-600' },
    { title: t('activePromotions'), value: String(counts.promos), icon: Tag, color: 'text-purple-600' },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">
          {t('welcomeMessage', { name: profile?.full_name || '' })}
        </h1>
        <p className="text-muted-foreground">{t('title')}</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <Card key={stat.title}>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {stat.title}
              </CardTitle>
              <stat.icon className={cn('h-5 w-5', stat.color)} />
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold">{stat.value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Activity className="h-5 w-5" />
              {t('recentActivity')}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground text-sm">{t('title')}</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingDown className="h-5 w-5" />
              {t('todayConsumption')}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground text-sm">{t('title')}</p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
