'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { useUser } from '@/hooks/use-user';
import { canAccessReports } from '@/lib/roles';
import {
  endOfDay,
  endOfMonth,
  endOfWeek,
  format,
  parseISO,
  startOfDay,
  startOfMonth,
  startOfWeek,
} from 'date-fns';
import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';
import { createClient } from '@/lib/supabase/client';
import { cn } from '@/lib/utils';
import type {
  Category,
  DailyConsumption,
  DailyStockSummary,
  MenuItem,
  PurchaseOrder,
  Recipe,
  RecipeCostSummary,
  StockTransaction,
  WasteLog,
  WasteReason,
} from '@/types/database';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Skeleton } from '@/components/ui/skeleton';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';

type DatePreset = 'today' | 'week' | 'month' | 'custom';

const WASTE_REASONS: WasteReason[] = ['expired', 'spoiled', 'preparation', 'other'];

const CHART_COLORS = {
  primary: 'var(--primary)',
  bar: 'var(--chart-1)',
  bar2: 'var(--chart-2)',
  bar3: 'var(--chart-3)',
  pie1: '#22c55e',
  pie2: '#eab308',
  pie3: '#ef4444',
};

function marginPercent(selling: number, cost: number): number | null {
  if (selling <= 0) return null;
  return ((selling - cost) / selling) * 100;
}

function safeParseDate(ymd: string, fallback: Date): Date {
  try {
    const d = parseISO(ymd);
    return Number.isNaN(d.getTime()) ? fallback : d;
  } catch {
    return fallback;
  }
}

function getRange(
  preset: DatePreset,
  customFrom: string,
  customTo: string
): { start: Date; end: Date; startStr: string; endStr: string } {
  const now = new Date();
  let start: Date;
  let end: Date;

  switch (preset) {
    case 'today':
      start = startOfDay(now);
      end = endOfDay(now);
      break;
    case 'week':
      start = startOfWeek(now, { weekStartsOn: 1 });
      end = endOfWeek(now, { weekStartsOn: 1 });
      break;
    case 'month':
      start = startOfMonth(now);
      end = endOfMonth(now);
      break;
    case 'custom': {
      const fbStart = startOfMonth(now);
      const fbEnd = endOfMonth(now);
      const fromD = safeParseDate(customFrom, fbStart);
      const toD = safeParseDate(customTo, fbEnd);
      start = startOfDay(fromD > toD ? toD : fromD);
      end = endOfDay(fromD > toD ? fromD : toD);
      break;
    }
    default:
      start = startOfMonth(now);
      end = endOfMonth(now);
  }

  return {
    start,
    end,
    startStr: format(start, 'yyyy-MM-dd'),
    endStr: format(end, 'yyyy-MM-dd'),
  };
}

type StockAgg = { received: number; consumed: number; wasted: number };

function aggregateStockTx(rows: StockTransaction[] | null): Map<string, StockAgg> {
  const map = new Map<string, StockAgg>();
  for (const row of rows || []) {
    const id = row.item_id;
    if (!map.has(id)) {
      map.set(id, { received: 0, consumed: 0, wasted: 0 });
    }
    const a = map.get(id)!;
    const q = Number(row.quantity) || 0;
    switch (row.transaction_type) {
      case 'received':
        a.received += q;
        break;
      case 'consumed':
        a.consumed += q;
        break;
      case 'wasted':
        a.wasted += q;
        break;
      default:
        break;
    }
  }
  return map;
}

type MenuRow = MenuItem & { recipe?: Recipe | null };

export default function ReportsPage() {
  const t = useTranslations('reports');
  const tCommon = useTranslations('common');
  const tInv = useTranslations('inventory');
  const tWaste = useTranslations('waste');
  const locale = useLocale();
  const router = useRouter();
  const { profile, loading: userLoading } = useUser();

  const [preset, setPreset] = useState<DatePreset>('month');
  const [customFrom, setCustomFrom] = useState(() => format(startOfMonth(new Date()), 'yyyy-MM-dd'));
  const [customTo, setCustomTo] = useState(() => format(endOfMonth(new Date()), 'yyyy-MM-dd'));

  const [tab, setTab] = useState('stock');
  const [loading, setLoading] = useState(true);

  const [stockSummary, setStockSummary] = useState<DailyStockSummary[]>([]);
  const [stockAgg, setStockAgg] = useState<Map<string, StockAgg>>(new Map());

  const [recipeCosts, setRecipeCosts] = useState<RecipeCostSummary[]>([]);
  const [categoryById, setCategoryById] = useState<Map<string, Category>>(new Map());

  const [menuRows, setMenuRows] = useState<MenuRow[]>([]);
  const [costByRecipeId, setCostByRecipeId] = useState<Map<string, number>>(new Map());

  const [consumptionRows, setConsumptionRows] = useState<DailyConsumption[]>([]);

  const [wasteRows, setWasteRows] = useState<
    (WasteLog & { inventory_item?: { unit_cost: number } | null })[]
  >([]);

  const [purchaseRows, setPurchaseRows] = useState<(PurchaseOrder & { supplier?: { name: string } | null })[]>([]);

  const range = useMemo(() => getRange(preset, customFrom, customTo), [preset, customFrom, customTo]);

  const getName = useCallback(
    (item: { name_ar: string; name_en: string }) => (locale === 'ar' ? item.name_ar : item.name_en),
    [locale]
  );

  const load = useCallback(async () => {
    setLoading(true);
    const supabase = createClient();
    const { start, end } = range;
    const startIso = start.toISOString();
    const endIso = end.toISOString();

    const [
      stockRes,
      txRes,
      recipeRes,
      catRes,
      menuRes,
      consRes,
      wasteRes,
      poRes,
    ] = await Promise.all([
      supabase.from('daily_stock_summary').select('*'),
      supabase
        .from('stock_transactions')
        .select('*')
        .gte('created_at', startIso)
        .lte('created_at', endIso),
      supabase.from('recipe_cost_summary').select('*'),
      supabase.from('categories').select('*'),
      supabase.from('menu_items').select('*, recipe:recipes(*)').order('display_order'),
      supabase
        .from('daily_consumption')
        .select('*')
        .gte('consumption_date', format(start, 'yyyy-MM-dd'))
        .lte('consumption_date', format(end, 'yyyy-MM-dd')),
      supabase
        .from('waste_logs')
        .select('*, inventory_item:inventory_items(unit_cost)')
        .gte('waste_date', format(start, 'yyyy-MM-dd'))
        .lte('waste_date', format(end, 'yyyy-MM-dd')),
      supabase
        .from('purchase_orders')
        .select('*, supplier:suppliers(name)')
        .gte('order_date', format(start, 'yyyy-MM-dd'))
        .lte('order_date', format(end, 'yyyy-MM-dd')),
    ]);

    setStockSummary((stockRes.data as DailyStockSummary[]) || []);
    setStockAgg(aggregateStockTx(txRes.data as StockTransaction[] | null));

    const cats = (catRes.data as Category[]) || [];
    setCategoryById(new Map(cats.map((c) => [c.id, c])));

    const rc = (recipeRes.data as RecipeCostSummary[]) || [];
    setRecipeCosts(rc);
    const costMap = new Map<string, number>();
    rc.forEach((c) => costMap.set(c.recipe_id, Number(c.total_cost) || 0));
    setCostByRecipeId(costMap);

    setMenuRows((menuRes.data as MenuRow[]) || []);
    setConsumptionRows((consRes.data as DailyConsumption[]) || []);
    setWasteRows((wasteRes.data as typeof wasteRows) || []);
    setPurchaseRows((poRes.data as typeof purchaseRows) || []);

    setLoading(false);
  }, [range]);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(() => {
    if (userLoading) return;
    if (!canAccessReports(profile?.role)) {
      router.replace(`/${locale}`);
    }
  }, [userLoading, profile?.role, locale, router]);

  const stockTableRows = useMemo(() => {
    return stockSummary.map((row) => {
      const agg = stockAgg.get(row.item_id) ?? { received: 0, consumed: 0, wasted: 0 };
      const closing = Number(row.current_quantity) || 0;
      const opening = closing - agg.received + agg.consumed + agg.wasted;
      const belowMin = closing < Number(row.zero_stock_level);
      return {
        ...row,
        opening,
        received: agg.received,
        consumed: agg.consumed,
        wasted: agg.wasted,
        closing,
        belowMin,
      };
    });
  }, [stockSummary, stockAgg]);

  const recipesSorted = useMemo(() => {
    return [...recipeCosts].sort((a, b) => Number(b.total_cost) - Number(a.total_cost));
  }, [recipeCosts]);

  const top10Recipes = useMemo(() => {
    return recipesSorted.slice(0, 10).map((r) => ({
      name: (locale === 'ar' ? r.name_ar : r.name_en).slice(0, 24),
      cost: Number(r.total_cost) || 0,
    }));
  }, [recipesSorted, locale]);

  const menuProfitRows = useMemo(() => {
    const rows = menuRows.map((m) => {
      const cost = m.recipe_id ? costByRecipeId.get(m.recipe_id) ?? 0 : 0;
      const sell = Number(m.selling_price) || 0;
      const pct = marginPercent(sell, cost);
      const margin = sell - cost;
      return {
        id: m.id,
        name: getName(m),
        sellingPrice: sell,
        cost,
        margin,
        marginPct: pct,
      };
    });
    return rows.sort((a, b) => {
      if (a.marginPct === null && b.marginPct === null) return 0;
      if (a.marginPct === null) return 1;
      if (b.marginPct === null) return -1;
      return a.marginPct - b.marginPct;
    });
  }, [menuRows, costByRecipeId, getName]);

  const marginPieData = useMemo(() => {
    let high = 0;
    let mid = 0;
    let low = 0;
    for (const r of menuProfitRows) {
      if (r.marginPct === null) continue;
      if (r.marginPct > 50) high += 1;
      else if (r.marginPct >= 30) mid += 1;
      else low += 1;
    }
    return [
      { name: t('marginHigh'), value: high, fill: CHART_COLORS.pie1 },
      { name: t('marginMid'), value: mid, fill: CHART_COLORS.pie2 },
      { name: t('marginLow'), value: low, fill: CHART_COLORS.pie3 },
    ].filter((d) => d.value > 0);
  }, [menuProfitRows, t]);

  const consumptionByDate = useMemo(() => {
    const map = new Map<string, number>();
    for (const row of consumptionRows) {
      const d = row.consumption_date;
      map.set(d, (map.get(d) ?? 0) + (Number(row.quantity_used) || 0));
    }
    const points: { date: string; qty: number }[] = [];
    const cur = new Date(range.start);
    const end = range.end;
    while (cur <= end) {
      const key = format(cur, 'yyyy-MM-dd');
      points.push({ date: key, qty: map.get(key) ?? 0 });
      cur.setDate(cur.getDate() + 1);
    }
    return points;
  }, [consumptionRows, range.start, range.end]);

  const wasteByReason = useMemo(() => {
    const map = new Map<
      WasteReason,
      { reason: WasteReason; count: number; qty: number; cost: number }
    >();
    for (const r of WASTE_REASONS) {
      map.set(r, { reason: r, count: 0, qty: 0, cost: 0 });
    }
    for (const row of wasteRows) {
      const entry = map.get(row.reason);
      if (!entry) continue;
      const q = Number(row.quantity) || 0;
      const rawItem = row.inventory_item;
      const item = Array.isArray(rawItem) ? rawItem[0] : rawItem;
      const unit =
        item && typeof item === 'object' && 'unit_cost' in item
          ? Number((item as { unit_cost: number }).unit_cost)
          : 0;
      entry.count += 1;
      entry.qty += q;
      entry.cost += q * unit;
    }
    return Array.from(map.values()).filter((x) => x.count > 0);
  }, [wasteRows]);

  const wasteChartData = useMemo(() => {
    return wasteByReason.map((w) => ({
      reason: tWaste(w.reason),
      cost: Math.round(w.cost * 100) / 100,
    }));
  }, [wasteByReason, tWaste]);

  const purchaseBySupplier = useMemo(() => {
    const map = new Map<string, { supplier: string; orders: number; amount: number }>();
    for (const po of purchaseRows) {
      const name = po.supplier?.name?.trim() || tCommon('name');
      if (!map.has(name)) {
        map.set(name, { supplier: name, orders: 0, amount: 0 });
      }
      const e = map.get(name)!;
      e.orders += 1;
      e.amount += Number(po.total_amount) || 0;
    }
    return Array.from(map.values()).sort((a, b) => b.amount - a.amount);
  }, [purchaseRows, tCommon]);

  const purchaseChartData = useMemo(() => {
    return purchaseBySupplier.map((p) => ({
      supplier: p.supplier.length > 20 ? `${p.supplier.slice(0, 18)}…` : p.supplier,
      amount: Math.round(p.amount * 100) / 100,
    }));
  }, [purchaseBySupplier]);

  const periodLabel = `${range.startStr} — ${range.endStr}`;

  if (userLoading || !canAccessReports(profile?.role)) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-96" />
      </div>
    );
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-9 w-64" />
        <Skeleton className="h-10 w-full max-w-xl" />
        <Skeleton className="h-[480px] w-full" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">{t('title')}</h1>
        <p className="text-muted-foreground text-sm mt-1">{t('subtitle')}</p>
      </div>

      <Card>
        <CardHeader className="pb-3">
          <CardTitle className="text-base font-medium">{t('selectDateRange')}</CardTitle>
          <p className="text-sm text-muted-foreground">
            {t('dateRangeLabel')}: {periodLabel}
          </p>
        </CardHeader>
        <CardContent className="flex flex-col gap-4">
          <div className="flex flex-wrap gap-2">
            {(
              [
                ['today', t('today')],
                ['week', t('thisWeek')],
                ['month', t('thisMonth')],
                ['custom', t('custom')],
              ] as const
            ).map(([key, label]) => (
              <Button
                key={key}
                type="button"
                size="sm"
                variant={preset === key ? 'default' : 'outline'}
                onClick={() => setPreset(key)}
              >
                {label}
              </Button>
            ))}
          </div>
          {preset === 'custom' && (
            <div className="flex flex-wrap items-end gap-4">
              <div className="space-y-1.5">
                <Label htmlFor="rep-from">{t('dateFrom')}</Label>
                <Input
                  id="rep-from"
                  type="date"
                  value={customFrom}
                  onChange={(e) => setCustomFrom(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="rep-to">{t('dateTo')}</Label>
                <Input
                  id="rep-to"
                  type="date"
                  value={customTo}
                  onChange={(e) => setCustomTo(e.target.value)}
                />
              </div>
              <Button type="button" size="sm" onClick={() => load()}>
                {t('applyRange')}
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      <Tabs
        value={tab}
        onValueChange={(v) => {
          if (v) setTab(v);
        }}
      >
        <TabsList variant="line" className="flex h-auto min-h-9 w-full flex-wrap justify-start gap-1">
          <TabsTrigger value="stock">{t('dailyStockSummary')}</TabsTrigger>
          <TabsTrigger value="recipe">{t('recipeCostAnalysis')}</TabsTrigger>
          <TabsTrigger value="menu">{t('menuProfitability')}</TabsTrigger>
          <TabsTrigger value="consumption">{t('consumptionTrends')}</TabsTrigger>
          <TabsTrigger value="waste">{t('wasteAnalysis')}</TabsTrigger>
          <TabsTrigger value="purchase">{t('purchaseSpending')}</TabsTrigger>
        </TabsList>

        <TabsContent value="stock" className="mt-4 space-y-4">
          <Card>
            <CardContent className="pt-6">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('itemName')}</TableHead>
                    <TableHead>{tInv('unit')}</TableHead>
                    <TableHead>{tInv('openingStock')}</TableHead>
                    <TableHead>{tInv('received')}</TableHead>
                    <TableHead>{tInv('consumed')}</TableHead>
                    <TableHead>{tInv('wasted')}</TableHead>
                    <TableHead>{tInv('closingStock')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {stockTableRows.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={7} className="text-center text-muted-foreground py-10">
                        {t('noData')}
                      </TableCell>
                    </TableRow>
                  ) : (
                    stockTableRows.map((item) => (
                      <TableRow
                        key={item.item_id}
                        className={cn(
                          item.belowMin && 'bg-destructive/10 dark:bg-destructive/20'
                        )}
                      >
                        <TableCell className="font-medium">
                          <div className="flex flex-col gap-0.5">
                            <span>{getName(item)}</span>
                            {item.belowMin && (
                              <span className="text-xs text-destructive">{t('belowMinStock')}</span>
                            )}
                          </div>
                        </TableCell>
                        <TableCell>{tInv(`units.${item.unit}`)}</TableCell>
                        <TableCell>{item.opening.toFixed(2)}</TableCell>
                        <TableCell className="text-green-600 dark:text-green-400">
                          +{item.received.toFixed(2)}
                        </TableCell>
                        <TableCell className="text-orange-600 dark:text-orange-400">
                          -{item.consumed.toFixed(2)}
                        </TableCell>
                        <TableCell className="text-red-600 dark:text-red-400">
                          -{item.wasted.toFixed(2)}
                        </TableCell>
                        <TableCell className="font-medium">{item.closing.toFixed(2)}</TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="recipe" className="mt-4 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('topRecipesCost')}</CardTitle>
            </CardHeader>
            <CardContent className="h-[300px] w-full min-h-[280px]">
              {top10Recipes.length === 0 ? (
                <p className="text-muted-foreground text-sm">{t('noData')}</p>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={top10Recipes} margin={{ top: 8, right: 8, left: 8, bottom: 48 }}>
                    <XAxis dataKey="name" interval={0} angle={-28} textAnchor="end" height={60} tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip />
                    <Bar dataKey="cost" fill={CHART_COLORS.bar} radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('recipeName')}</TableHead>
                    <TableHead>{tCommon('category')}</TableHead>
                    <TableHead>{t('ingredientCount')}</TableHead>
                    <TableHead className="text-end">{t('totalCost')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {recipesSorted.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={4} className="text-center text-muted-foreground py-10">
                        {t('noData')}
                      </TableCell>
                    </TableRow>
                  ) : (
                    recipesSorted.map((r) => {
                      const cat = categoryById.get(r.category_id);
                      const catName = cat ? getName(cat) : '—';
                      return (
                        <TableRow key={r.recipe_id}>
                          <TableCell className="font-medium">{getName(r)}</TableCell>
                          <TableCell>{catName}</TableCell>
                          <TableCell>{r.ingredient_count}</TableCell>
                          <TableCell className="text-end font-medium">
                            {(Number(r.total_cost) || 0).toFixed(2)}
                          </TableCell>
                        </TableRow>
                      );
                    })
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="menu" className="mt-4 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('marginDistribution')}</CardTitle>
            </CardHeader>
            <CardContent className="h-[300px] w-full min-h-[280px]">
              {marginPieData.length === 0 ? (
                <p className="text-muted-foreground text-sm">{t('noData')}</p>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={marginPieData}
                      dataKey="value"
                      nameKey="name"
                      cx="50%"
                      cy="50%"
                      outerRadius={100}
                      label
                    >
                      {marginPieData.map((entry, i) => (
                        <Cell key={i} fill={entry.fill} />
                      ))}
                    </Pie>
                    <Tooltip />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('menuItem')}</TableHead>
                    <TableHead className="text-end">{t('sellingPrice')}</TableHead>
                    <TableHead className="text-end">{t('cost')}</TableHead>
                    <TableHead className="text-end">{t('margin')}</TableHead>
                    <TableHead className="text-end">{t('marginPercent')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {menuProfitRows.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={5} className="text-center text-muted-foreground py-10">
                        {t('noData')}
                      </TableCell>
                    </TableRow>
                  ) : (
                    menuProfitRows.map((r) => (
                      <TableRow key={r.id}>
                        <TableCell className="font-medium">{r.name}</TableCell>
                        <TableCell className="text-end">{r.sellingPrice.toFixed(2)}</TableCell>
                        <TableCell className="text-end">{r.cost.toFixed(2)}</TableCell>
                        <TableCell className="text-end">{r.margin.toFixed(2)}</TableCell>
                        <TableCell className="text-end">
                          {r.marginPct === null ? '—' : `${r.marginPct.toFixed(1)}%`}
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="consumption" className="mt-4 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('dailyTotalConsumption')}</CardTitle>
            </CardHeader>
            <CardContent className="h-[320px] w-full min-h-[280px]">
              {consumptionByDate.every((d) => d.qty === 0) ? (
                <p className="text-muted-foreground text-sm">{t('noData')}</p>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={consumptionByDate} margin={{ top: 8, right: 8, left: 8, bottom: 8 }}>
                    <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                    <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip />
                    <Line
                      type="monotone"
                      dataKey="qty"
                      name={t('consumptionQuantity')}
                      stroke={CHART_COLORS.primary}
                      strokeWidth={2}
                      dot={false}
                    />
                  </LineChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="waste" className="mt-4 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('costByReason')}</CardTitle>
            </CardHeader>
            <CardContent className="h-[300px] w-full min-h-[280px]">
              {wasteChartData.length === 0 ? (
                <p className="text-muted-foreground text-sm">{t('noData')}</p>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={wasteChartData} margin={{ top: 8, right: 8, left: 8, bottom: 8 }}>
                    <XAxis dataKey="reason" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip />
                    <Bar dataKey="cost" fill={CHART_COLORS.bar2} radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('reason')}</TableHead>
                    <TableHead className="text-end">{t('count')}</TableHead>
                    <TableHead className="text-end">{t('totalQuantity')}</TableHead>
                    <TableHead className="text-end">{t('totalCost')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {wasteByReason.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={4} className="text-center text-muted-foreground py-10">
                        {t('noData')}
                      </TableCell>
                    </TableRow>
                  ) : (
                    wasteByReason.map((w) => (
                      <TableRow key={w.reason}>
                        <TableCell className="font-medium">{tWaste(w.reason)}</TableCell>
                        <TableCell className="text-end">{w.count}</TableCell>
                        <TableCell className="text-end">{w.qty.toFixed(2)}</TableCell>
                        <TableCell className="text-end">{w.cost.toFixed(2)}</TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="purchase" className="mt-4 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('spendingBySupplier')}</CardTitle>
            </CardHeader>
            <CardContent className="h-[300px] w-full min-h-[280px]">
              {purchaseChartData.length === 0 ? (
                <p className="text-muted-foreground text-sm">{t('noData')}</p>
              ) : (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={purchaseChartData} margin={{ top: 8, right: 8, left: 8, bottom: 48 }}>
                    <XAxis dataKey="supplier" interval={0} angle={-24} textAnchor="end" height={56} tick={{ fontSize: 10 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip />
                    <Bar dataKey="amount" fill={CHART_COLORS.bar3} radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('supplier')}</TableHead>
                    <TableHead className="text-end">{t('totalOrders')}</TableHead>
                    <TableHead className="text-end">{t('totalAmount')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {purchaseBySupplier.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={3} className="text-center text-muted-foreground py-10">
                        {t('noData')}
                      </TableCell>
                    </TableRow>
                  ) : (
                    purchaseBySupplier.map((p) => (
                      <TableRow key={p.supplier}>
                        <TableCell className="font-medium">{p.supplier}</TableCell>
                        <TableCell className="text-end">{p.orders}</TableCell>
                        <TableCell className="text-end">{p.amount.toFixed(2)}</TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
