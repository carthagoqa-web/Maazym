'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { useUser } from '@/hooks/use-user';
import { canAccessPriceSimulator } from '@/lib/roles';
import type { MenuItem, Recipe, RecipeCostSummary } from '@/types/database';
import { PromotionsSubnav } from '@/components/promotions/promotions-subnav';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Checkbox } from '@/components/ui/checkbox';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';

const MAX_ITEMS = 4;

type MenuRow = MenuItem & { recipe?: Recipe | null };

function marginAmount(sell: number, cost: number) {
  return sell - cost;
}

function marginPercent(sell: number, cost: number): number | null {
  if (sell <= 0) return null;
  return ((sell - cost) / sell) * 100;
}

function cellTone(
  value: number,
  values: number[],
  lowerIsBetter: boolean
): 'best' | 'worst' | 'neutral' {
  if (values.length < 2) return 'neutral';
  const min = Math.min(...values);
  const max = Math.max(...values);
  if (min === max) return 'neutral';
  if (lowerIsBetter) {
    if (value === min) return 'best';
    if (value === max) return 'worst';
  } else {
    if (value === max) return 'best';
    if (value === min) return 'worst';
  }
  return 'neutral';
}

function toneClass(tone: 'best' | 'worst' | 'neutral') {
  if (tone === 'best') return 'bg-green-500/15 font-semibold text-green-800 dark:text-green-400';
  if (tone === 'worst') return 'bg-red-500/15 font-semibold text-red-800 dark:text-red-400';
  return '';
}

function BarRow({ label, values }: { label: string; values: number[] }) {
  const max = Math.max(...values, 0.0001);
  return (
    <div className="space-y-1">
      <div className="text-xs text-muted-foreground">{label}</div>
      <div className="flex gap-2 items-end">
        {values.map((v, i) => (
          <div key={i} className="flex-1 flex flex-col items-center gap-1">
            <div
              className="w-full rounded bg-primary/80 min-h-[4px] transition-all"
              style={{ height: `${Math.max(8, (v / max) * 72)}px` }}
            />
            <span className="text-[10px] text-muted-foreground tabular-nums">{v.toFixed(0)}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

export default function MenuComparePage() {
  const t = useTranslations('promotions');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const router = useRouter();
  const { profile, loading: userLoading } = useUser();
  const [loading, setLoading] = useState(true);
  const [menuRows, setMenuRows] = useState<MenuRow[]>([]);
  const [costByRecipe, setCostByRecipe] = useState<Map<string, RecipeCostSummary>>(new Map());
  const [ingredientIdsByRecipe, setIngredientIdsByRecipe] = useState<Map<string, Set<string>>>(
    new Map()
  );
  const [selected, setSelected] = useState<string[]>([]);

  const load = useCallback(async () => {
    const supabase = createClient();
    const [menuRes, costRes, riRes] = await Promise.all([
      supabase.from('menu_items').select('*, recipe:recipes(*)').order('name_en'),
      supabase.from('recipe_cost_summary').select('*'),
      supabase.from('recipe_ingredients').select('recipe_id, inventory_item_id'),
    ]);
    const cmap = new Map<string, RecipeCostSummary>();
    (costRes.data as RecipeCostSummary[] | null)?.forEach((c) => cmap.set(c.recipe_id, c));
    const imap = new Map<string, Set<string>>();
    (riRes.data as { recipe_id: string; inventory_item_id: string }[] | null)?.forEach((r) => {
      if (!imap.has(r.recipe_id)) imap.set(r.recipe_id, new Set());
      imap.get(r.recipe_id)!.add(r.inventory_item_id);
    });
    setMenuRows((menuRes.data as MenuRow[]) || []);
    setCostByRecipe(cmap);
    setIngredientIdsByRecipe(imap);
    setLoading(false);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(() => {
    if (userLoading) return;
    if (!canAccessPriceSimulator(profile?.role)) {
      router.replace(`/${locale}/promotions`);
    }
  }, [userLoading, profile?.role, locale, router]);

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  function toggleId(id: string) {
    setSelected((s) => {
      if (s.includes(id)) return s.filter((x) => x !== id);
      if (s.length >= MAX_ITEMS) return s;
      return [...s, id];
    });
  }

  const selectedRows = useMemo(
    () => selected.map((id) => menuRows.find((m) => m.id === id)).filter(Boolean) as MenuRow[],
    [selected, menuRows]
  );

  const sharedIngredientIds = useMemo(() => {
    if (selectedRows.length < 2) return [] as string[];
    const recipeIds = selectedRows.map((r) => r.recipe_id).filter(Boolean) as string[];
    if (recipeIds.length < 2) return [];
    const freq = new Map<string, number>();
    for (const rid of recipeIds) {
      const set = ingredientIdsByRecipe.get(rid);
      if (!set) continue;
      for (const iid of set) {
        freq.set(iid, (freq.get(iid) ?? 0) + 1);
      }
    }
    return [...freq.entries()].filter(([, n]) => n >= 2).map(([id]) => id);
  }, [selectedRows, ingredientIdsByRecipe]);

  // Resolve shared ingredient display names
  const [invNames, setInvNames] = useState<Map<string, string>>(new Map());

  useEffect(() => {
    if (sharedIngredientIds.length === 0) {
      setInvNames(new Map());
      return;
    }
    const supabase = createClient();
    supabase
      .from('inventory_items')
      .select('id, name_ar, name_en')
      .in('id', sharedIngredientIds)
      .then(({ data }) => {
        const m = new Map<string, string>();
        (data as { id: string; name_ar: string; name_en: string }[] | null)?.forEach((r) => {
          m.set(r.id, locale === 'ar' ? r.name_ar : r.name_en);
        });
        setInvNames(m);
      });
  }, [sharedIngredientIds, locale]);

  const metrics = useMemo(() => {
    return selectedRows.map((row) => {
      const rid = row.recipe_id;
      const cost = rid ? Number(costByRecipe.get(rid)?.total_cost ?? 0) : 0;
      const ingCount = rid ? Number(costByRecipe.get(rid)?.ingredient_count ?? 0) : 0;
      const sell = Number(row.selling_price);
      const mAmt = marginAmount(sell, cost);
      const mPct = marginPercent(sell, cost);
      const cal = row.recipe?.calories;
      return { row, cost, ingCount, sell, mAmt, mPct, cal: cal ?? null };
    });
  }, [selectedRows, costByRecipe]);

  const costs = metrics.map((m) => m.cost);
  const ingCounts = metrics.map((m) => m.ingCount);
  const sells = metrics.map((m) => m.sell);
  const mAmts = metrics.map((m) => m.mAmt);
  const mPctVals = metrics.map((m) => m.mPct).filter((c): c is number => c !== null);

  if (userLoading || !canAccessPriceSimulator(profile?.role)) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-64" />
      </div>
    );
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-64" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PromotionsSubnav />
      <h1 className="text-2xl font-bold">{t('compare')}</h1>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('selectMenuItemsCompare')}</CardTitle>
          <p className="text-sm text-muted-foreground">{t('compareMax', { max: MAX_ITEMS })}</p>
        </CardHeader>
        <CardContent>
          <ScrollArea className="h-64 rounded-md border p-3">
            <div className="space-y-2">
              {menuRows.map((m) => (
                <label key={m.id} className="flex items-center gap-2 text-sm">
                  <Checkbox
                    checked={selected.includes(m.id)}
                    disabled={!selected.includes(m.id) && selected.length >= MAX_ITEMS}
                    onCheckedChange={() => toggleId(m.id)}
                  />
                  {getName(m)}
                </label>
              ))}
            </div>
          </ScrollArea>
        </CardContent>
      </Card>

      {selectedRows.length < 2 ? (
        <p className="text-sm text-muted-foreground">{t('pickAtLeastTwo')}</p>
      ) : (
        <>
          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('comparisonTable')}</CardTitle>
            </CardHeader>
            <CardContent className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-40">{t('metric')}</TableHead>
                    {metrics.map(({ row }) => (
                      <TableHead key={row.id} className="min-w-[140px]">
                        {getName(row)}
                      </TableHead>
                    ))}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  <TableRow>
                    <TableCell className="font-medium">{t('linkedRecipe')}</TableCell>
                    {metrics.map(({ row }) => (
                      <TableCell key={row.id}>
                        {row.recipe ? getName(row.recipe) : '—'}
                      </TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{t('ingredientCount')}</TableCell>
                    {metrics.map(({ row, ingCount }) => (
                      <TableCell
                        key={row.id}
                        className={toneClass(cellTone(ingCount, ingCounts, true))}
                      >
                        {ingCount}
                      </TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{tCommon('cost')}</TableCell>
                    {metrics.map(({ row, cost }) => (
                      <TableCell
                        key={row.id}
                        className={toneClass(cellTone(cost, costs, true))}
                      >
                        {cost.toFixed(2)} QAR
                      </TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{t('sellingPrice')}</TableCell>
                    {metrics.map(({ row, sell }) => (
                      <TableCell key={row.id}>{sell.toFixed(2)} QAR</TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{t('marginAmount')}</TableCell>
                    {metrics.map(({ row, mAmt }) => (
                      <TableCell
                        key={row.id}
                        className={toneClass(cellTone(mAmt, mAmts, false))}
                      >
                        {mAmt.toFixed(2)} QAR
                      </TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{t('marginPercentLabel')}</TableCell>
                    {metrics.map(({ row, mPct }) => (
                      <TableCell
                        key={row.id}
                        className={toneClass(
                          mPct === null || mPctVals.length < 2
                            ? 'neutral'
                            : cellTone(mPct, mPctVals, false)
                        )}
                      >
                        {mPct !== null ? `${mPct.toFixed(1)}%` : '—'}
                      </TableCell>
                    ))}
                  </TableRow>
                  <TableRow>
                    <TableCell className="font-medium">{t('calories')}</TableCell>
                    {metrics.map(({ row, cal }) => {
                      const calVals = metrics
                        .map((x) => x.cal)
                        .filter((c): c is number => c !== null);
                      const tone =
                        cal === null || calVals.length < 2
                          ? 'neutral'
                          : cellTone(cal, calVals, true);
                      return (
                        <TableCell key={row.id} className={toneClass(tone)}>
                          {cal !== null ? cal : '—'}
                        </TableCell>
                      );
                    })}
                  </TableRow>
                </TableBody>
              </Table>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('sharedIngredients')}</CardTitle>
            </CardHeader>
            <CardContent>
              {sharedIngredientIds.length === 0 ? (
                <p className="text-sm text-muted-foreground">{t('noSharedIngredients')}</p>
              ) : (
                <ul className="list-disc ps-5 text-sm space-y-1">
                  {sharedIngredientIds.map((id) => (
                    <li key={id}>{invNames.get(id) ?? id}</li>
                  ))}
                </ul>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-base">{t('visualComparison')}</CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <BarRow label={tCommon('cost')} values={costs} />
              <BarRow label={t('marginAmount')} values={mAmts} />
              <BarRow label={t('marginPercentLabel')} values={metrics.map((m) => m.mPct ?? 0)} />
            </CardContent>
          </Card>
        </>
      )}
    </div>
  );
}
