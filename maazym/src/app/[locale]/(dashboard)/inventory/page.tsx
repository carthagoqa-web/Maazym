'use client';

import { useEffect, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import Link from 'next/link';
import { createClient } from '@/lib/supabase/client';
import type { DailyStockSummary } from '@/types/database';
import { cn } from '@/lib/utils';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Package, AlertTriangle, XCircle, CheckCircle, Search, Settings2, ClipboardList } from 'lucide-react';
import { BulkUploadButton } from '@/components/bulk-upload-button';

export default function InventoryPage() {
  const t = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [stockData, setStockData] = useState<DailyStockSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [tab, setTab] = useState('all');

  useEffect(() => {
    loadStock();
  }, []);

  async function loadStock() {
    const supabase = createClient();
    const { data } = await supabase.from('daily_stock_summary').select('*');
    setStockData(data || []);
    setLoading(false);
  }

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const filtered = stockData.filter((item) => {
    const matchesSearch = search === '' ||
      item.name_ar.toLowerCase().includes(search.toLowerCase()) ||
      item.name_en.toLowerCase().includes(search.toLowerCase());
    const matchesTab = tab === 'all' ||
      (tab === 'low' && item.stock_status === 'low_stock') ||
      (tab === 'out' && item.stock_status === 'out_of_stock');
    return matchesSearch && matchesTab;
  });

  const totalItems = stockData.length;
  const lowStockCount = stockData.filter((i) => i.stock_status === 'low_stock').length;
  const outOfStockCount = stockData.filter((i) => i.stock_status === 'out_of_stock').length;
  const inStockCount = stockData.filter((i) => i.stock_status === 'in_stock').length;

  const statusBadge = (status: string) => {
    switch (status) {
      case 'in_stock':
        return <Badge variant="default" className="bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">{t('inStock')}</Badge>;
      case 'low_stock':
        return <Badge variant="default" className="bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200">{t('lowStock')}</Badge>;
      case 'out_of_stock':
        return <Badge variant="destructive">{t('outOfStock')}</Badge>;
      default:
        return null;
    }
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
        <div className="grid gap-4 md:grid-cols-4">
          {[...Array(4)].map((_, i) => <Skeleton key={i} className="h-24" />)}
        </div>
        <Skeleton className="h-96" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">{t('title')}</h1>
        <div className="flex flex-wrap items-center gap-2">
          <BulkUploadButton templateType="current_stock" onUploadComplete={loadStock} />
          <Link href={`/${locale}/inventory/items`}>
            <Button variant="outline" size="sm">
              <Settings2 className="h-4 w-4 me-2" />
              {t('items')}
            </Button>
          </Link>
          <Link href={`/${locale}/inventory/consumption`}>
            <Button size="sm">
              <ClipboardList className="h-4 w-4 me-2" />
              {t('addConsumption')}
            </Button>
          </Link>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">{tCommon('total')}</p>
                <p className="text-3xl font-bold">{totalItems}</p>
              </div>
              <Package className="h-8 w-8 text-blue-500" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">{t('inStock')}</p>
                <p className="text-3xl font-bold text-green-600">{inStockCount}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-green-500" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">{t('lowStock')}</p>
                <p className="text-3xl font-bold text-orange-600">{lowStockCount}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-orange-500" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">{t('outOfStock')}</p>
                <p className="text-3xl font-bold text-red-600">{outOfStockCount}</p>
              </div>
              <XCircle className="h-8 w-8 text-red-500" />
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="relative flex-1">
              <Search className="absolute start-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input placeholder={tCommon('search')} value={search} onChange={(e) => setSearch(e.target.value)} className="ps-9" />
            </div>
            <Tabs value={tab} onValueChange={setTab}>
              <TabsList>
                <TabsTrigger value="all">{tCommon('all')}</TabsTrigger>
                <TabsTrigger value="low">{t('lowStock')}</TabsTrigger>
                <TabsTrigger value="out">{t('outOfStock')}</TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{t('currentStock')}</TableHead>
                <TableHead>{t('zeroStockLevel')}</TableHead>
                <TableHead>{t('received')}</TableHead>
                <TableHead>{t('consumed')}</TableHead>
                <TableHead>{t('wasted')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                    {t('noItems')}
                  </TableCell>
                </TableRow>
              ) : (
                filtered.map((item) => (
                  <TableRow key={item.item_id} className={cn(
                    item.stock_status === 'out_of_stock' && 'bg-red-50 dark:bg-red-950/20',
                    item.stock_status === 'low_stock' && 'bg-orange-50 dark:bg-orange-950/20'
                  )}>
                    <TableCell className="font-medium">{getName(item)}</TableCell>
                    <TableCell>{Number(item.current_quantity).toFixed(2)} {t(`units.${item.unit}`)}</TableCell>
                    <TableCell>{Number(item.zero_stock_level).toFixed(2)}</TableCell>
                    <TableCell className="text-green-600">+{Number(item.today_received).toFixed(2)}</TableCell>
                    <TableCell className="text-orange-600">-{Number(item.today_consumed).toFixed(2)}</TableCell>
                    <TableCell className="text-red-600">-{Number(item.today_wasted).toFixed(2)}</TableCell>
                    <TableCell>{statusBadge(item.stock_status)}</TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
