'use client';

import { useEffect, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { format } from 'date-fns';
import { useUser } from '@/hooks/use-user';
import { createClient } from '@/lib/supabase/client';
import { isPromotionActiveBySchedule, startOfTodayLocal } from '@/lib/promotion-schedule';
import type { Promotion } from '@/types/database';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { BookOpen, Package, AlertTriangle, Tag, TrendingDown, Activity } from 'lucide-react';
import { cn } from '@/lib/utils';
import { withTimeout } from '@/lib/with-timeout';

type RecentTx = {
  id: string;
  transaction_type: string;
  quantity: number;
  created_at: string;
  item_id: string;
  name_ar: string;
  name_en: string;
};

export default function DashboardPage() {
  const t = useTranslations('dashboard');
  const tInv = useTranslations('inventory');
  const locale = useLocale();
  const { profile } = useUser();
  const [counts, setCounts] = useState({ recipes: 0, items: 0, lowStock: 0, promos: 0 });
  const [recentActivity, setRecentActivity] = useState<RecentTx[]>([]);
  const [todayConsumptionTotal, setTodayConsumptionTotal] = useState<number | null>(null);
  const [dataLoaded, setDataLoaded] = useState(false);

  useEffect(() => {
    async function loadDashboard() {
      try {
        const supabase = createClient();
        const todayDay = startOfTodayLocal();
        const todayStr = format(todayDay, 'yyyy-MM-dd');

        const [
          recipesRes,
          itemsRes,
          stockStatusRes,
          promoRes,
          txRes,
          consumptionRes,
        ] = await withTimeout(
          Promise.all([
            supabase.from('recipes').select('id', { count: 'exact', head: true }).eq('is_active', true),
            supabase.from('inventory_items').select('id', { count: 'exact', head: true }).eq('is_active', true),
            supabase.from('daily_stock_summary').select('stock_status'),
            supabase.from('promotions').select('id, is_active, start_date, end_date').eq('is_active', true),
            supabase
              .from('stock_transactions')
              .select('id, transaction_type, quantity, created_at, item_id')
              .order('created_at', { ascending: false })
              .limit(8),
            supabase.from('daily_consumption').select('quantity_used').eq('consumption_date', todayStr),
          ]),
          30_000,
          'Dashboard load'
        );

        const stockAlertCount =
          stockStatusRes.data?.filter(
            (r) => r.stock_status === 'low_stock' || r.stock_status === 'out_of_stock'
          ).length ?? 0;

        const promoRows = (promoRes.data ?? []) as Pick<Promotion, 'id' | 'is_active' | 'start_date' | 'end_date'>[];
        const activePromoCount = promoRows.filter((p) =>
          isPromotionActiveBySchedule(p as Promotion, todayDay)
        ).length;

        const consumptionSum =
          consumptionRes.data?.reduce((s, r) => s + (Number(r.quantity_used) || 0), 0) ?? 0;

        const txs = txRes.data ?? [];
        const itemIds = [...new Set(txs.map((t) => t.item_id))];
        let activity: RecentTx[] = [];
        if (itemIds.length) {
          const { data: inv } = await supabase
            .from('inventory_items')
            .select('id, name_ar, name_en')
            .in('id', itemIds);
          const map = new Map((inv ?? []).map((i) => [i.id, i]));
          activity = txs.map((t) => {
            const item = map.get(t.item_id);
            return {
              id: t.id,
              transaction_type: t.transaction_type,
              quantity: Number(t.quantity) || 0,
              created_at: t.created_at,
              item_id: t.item_id,
              name_ar: item?.name_ar ?? '—',
              name_en: item?.name_en ?? '—',
            };
          });
        }

        setCounts({
          recipes: recipesRes.count ?? 0,
          items: itemsRes.count ?? 0,
          lowStock: stockAlertCount,
          promos: activePromoCount,
        });
        setRecentActivity(activity);
        setTodayConsumptionTotal(consumptionSum);

        if (promoRes.error) console.error('Dashboard promotions:', promoRes.error);
        if (txRes.error) console.error('Dashboard stock_transactions:', txRes.error);
        if (consumptionRes.error) console.error('Dashboard daily_consumption:', consumptionRes.error);
      } catch (e) {
        console.error('Dashboard load error:', e);
      } finally {
        setDataLoaded(true);
      }
    }
    loadDashboard();
  }, []);

  const txLabel = (type: string) => {
    switch (type) {
      case 'received':
        return tInv('received');
      case 'consumed':
        return tInv('consumed');
      case 'wasted':
        return tInv('wasted');
      case 'adjusted':
        return t('adjusted');
      default:
        return type;
    }
  };

  const itemName = (row: RecentTx) => (locale === 'ar' ? row.name_ar : row.name_en);

  if (!dataLoaded) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <Skeleton key={i} className="h-32" />
          ))}
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          <Skeleton className="h-48" />
          <Skeleton className="h-48" />
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
            {recentActivity.length === 0 ? (
              <p className="text-muted-foreground text-sm">{t('noRecentActivity')}</p>
            ) : (
              <ul className="space-y-2 text-sm">
                {recentActivity.map((row) => (
                  <li key={row.id} className="flex flex-wrap items-baseline justify-between gap-2 border-b border-border/60 pb-2 last:border-0 last:pb-0">
                    <span className="text-foreground">
                      <span className="font-medium">{txLabel(row.transaction_type)}</span>
                      <span className="text-muted-foreground"> · </span>
                      {itemName(row)}
                      <span className="text-muted-foreground"> · </span>
                      {row.quantity.toFixed(2)}
                    </span>
                    <span className="text-muted-foreground shrink-0 text-xs tabular-nums">
                      {format(new Date(row.created_at), 'yyyy-MM-dd HH:mm')}
                    </span>
                  </li>
                ))}
              </ul>
            )}
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
            {todayConsumptionTotal !== null && todayConsumptionTotal > 0 ? (
              <p className="text-2xl font-semibold tabular-nums">
                {t('todayConsumptionTotal', { quantity: todayConsumptionTotal.toFixed(2) })}
              </p>
            ) : (
              <p className="text-muted-foreground text-sm">{t('noConsumptionToday')}</p>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
