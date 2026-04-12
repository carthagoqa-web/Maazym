'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { useUser } from '@/hooks/use-user';
import { canAccessPriceSimulator } from '@/lib/roles';
import type { InventoryItem, MenuItem, PricingConfig, Recipe, RecipeIngredient } from '@/types/database';
import { ingredientLineCost } from '@/lib/pricing/recipe-cost';
import { PromotionsSubnav } from '@/components/promotions/promotions-subnav';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';

const NONE = '__none__';

type RiRow = RecipeIngredient & { inventory_item?: InventoryItem | null };

function marginFromFinal(
  finalWithTax: number,
  cost: number,
  taxPercent: number
): { net: number; marginPct: number | null } {
  if (finalWithTax <= 0 || taxPercent < 0) return { net: 0, marginPct: null };
  const net = finalWithTax / (1 + taxPercent / 100);
  if (net <= 0) return { net, marginPct: null };
  return { net, marginPct: ((net - cost) / net) * 100 };
}

export default function PricingCalculatorPage() {
  const t = useTranslations('promotions');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const router = useRouter();
  const { profile, loading: userLoading } = useUser();
  const [loading, setLoading] = useState(true);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [pricing, setPricing] = useState<PricingConfig | null>(null);
  const [selection, setSelection] = useState('');
  const [ingredients, setIngredients] = useState<RiRow[]>([]);
  const [ingLoading, setIngLoading] = useState(false);
  const [overrideFinal, setOverrideFinal] = useState('');
  const [overrideTouched, setOverrideTouched] = useState(false);

  useEffect(() => {
    if (userLoading) return;
    if (!canAccessPriceSimulator(profile?.role)) {
      router.replace(`/${locale}/promotions`);
    }
  }, [userLoading, profile?.role, locale, router]);

  const loadBase = useCallback(async () => {
    const supabase = createClient();
    const [recRes, menuRes, priceRes] = await Promise.all([
      supabase.from('recipes').select('*').eq('is_active', true).order('name_en'),
      supabase.from('menu_items').select('*').order('name_en'),
      supabase.from('pricing_config').select('*').limit(1).maybeSingle(),
    ]);
    setRecipes((recRes.data as Recipe[]) || []);
    setMenuItems((menuRes.data as MenuItem[]) || []);
    setPricing((priceRes.data as PricingConfig) || null);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadBase();
  }, [loadBase]);

  const marginPct = Number(pricing?.default_margin_percent ?? 65);
  const taxPct = Number(pricing?.tax_percent ?? 15);

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const recipeIdFromSelection = useMemo(() => {
    if (!selection || selection === NONE) return null;
    if (selection.startsWith('r:')) return selection.slice(2);
    if (selection.startsWith('m:')) {
      const m = menuItems.find((x) => x.id === selection.slice(2));
      return m?.recipe_id || null;
    }
    return null;
  }, [selection, menuItems]);

  useEffect(() => {
    if (!recipeIdFromSelection) {
      setIngredients([]);
      setOverrideFinal('');
      return;
    }
    let cancelled = false;
    (async () => {
      setIngLoading(true);
      const supabase = createClient();
      const { data, error } = await supabase
        .from('recipe_ingredients')
        .select('*, inventory_item:inventory_items(*)')
        .eq('recipe_id', recipeIdFromSelection);
      if (!cancelled) {
        if (error) setIngredients([]);
        else setIngredients((data as RiRow[]) || []);
        setIngLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [recipeIdFromSelection]);

  const totalCost = useMemo(() => {
    let sum = 0;
    for (const row of ingredients) {
      const ii = row.inventory_item;
      if (!ii) continue;
      sum += ingredientLineCost(row.quantity, row.unit, ii.unit, Number(ii.unit_cost));
    }
    return sum;
  }, [ingredients]);

  const suggestedNet =
    marginPct >= 100 ? 0 : totalCost / (1 - marginPct / 100);
  const suggestedTax = suggestedNet * (taxPct / 100);
  const suggestedFinal = suggestedNet + suggestedTax;

  const parsedOverride = parseFloat(overrideFinal);
  const hasOverride = overrideFinal.trim() !== '' && !Number.isNaN(parsedOverride);
  const displayFinal = hasOverride ? parsedOverride : suggestedFinal;

  const { net: actualNet, marginPct: actualMarginPct } = marginFromFinal(
    displayFinal,
    totalCost,
    taxPct
  );
  const actualMarginAmount = actualNet - totalCost;

  useEffect(() => {
    if (!recipeIdFromSelection) setOverrideFinal('');
    setOverrideTouched(false);
  }, [recipeIdFromSelection]);

  useEffect(() => {
    if (!recipeIdFromSelection || ingLoading || overrideTouched) return;
    setOverrideFinal(suggestedFinal > 0 ? suggestedFinal.toFixed(2) : '');
  }, [recipeIdFromSelection, ingLoading, suggestedFinal, overrideTouched]);

  const gaugeTone = useMemo(() => {
    if (actualMarginPct === null) return 'bg-muted';
    if (actualMarginPct >= marginPct) return 'bg-green-500';
    if (actualMarginPct >= marginPct * 0.85) return 'bg-amber-500';
    return 'bg-red-500';
  }, [actualMarginPct, marginPct]);

  const gaugeWidth = useMemo(() => {
    if (actualMarginPct === null) return 0;
    const cap = Math.max(marginPct * 1.2, 1);
    return Math.min(100, (actualMarginPct / cap) * 100);
  }, [actualMarginPct, marginPct]);

  if (userLoading || !canAccessPriceSimulator(profile?.role)) {
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
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-48" />
      </div>
    );
  }

  const selectValue = selection || NONE;

  return (
    <div className="space-y-6">
      <PromotionsSubnav />
      <h1 className="text-2xl font-bold">{t('calculator')}</h1>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('selectRecipeOrMenu')}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2 max-w-md">
            <Label>{t('targetSelection')}</Label>
            <Select
              value={selectValue}
              onValueChange={(v) => setSelection((v ?? NONE) === NONE ? '' : (v ?? ''))}
            >
              <SelectTrigger>
                <SelectValue placeholder={t('selectRecipeOrMenu')} />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NONE}>{tCommon('optional')}</SelectItem>
                {recipes.map((r) => (
                  <SelectItem
                    key={r.id}
                    value={`r:${r.id}`}
                    label={`${t('recipePrefix')} ${getName(r)}`}
                  >
                    {t('recipePrefix')} {getName(r)}
                  </SelectItem>
                ))}
                {menuItems.map((m) => (
                  <SelectItem
                    key={m.id}
                    value={`m:${m.id}`}
                    label={`${t('menuItemPrefix')} ${getName(m)}`}
                  >
                    {t('menuItemPrefix')} {getName(m)}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {!recipeIdFromSelection ? (
            <p className="text-sm text-muted-foreground">{t('pickRecipeHint')}</p>
          ) : ingLoading ? (
            <Skeleton className="h-40" />
          ) : (
            <>
              <div>
                <h3 className="text-sm font-medium mb-2">{t('ingredientBreakdown')}</h3>
                <div className="overflow-x-auto rounded-md border">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>{tCommon('name')}</TableHead>
                        <TableHead>{tCommon('quantity')}</TableHead>
                        <TableHead>{tCommon('unit')}</TableHead>
                        <TableHead>{t('lineCost')}</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {ingredients.length === 0 ? (
                        <TableRow>
                          <TableCell colSpan={4} className="text-center text-muted-foreground py-6">
                            {t('noIngredients')}
                          </TableCell>
                        </TableRow>
                      ) : (
                        ingredients.map((row) => {
                          const ii = row.inventory_item;
                          const line =
                            ii != null
                              ? ingredientLineCost(
                                  row.quantity,
                                  row.unit,
                                  ii.unit,
                                  Number(ii.unit_cost)
                                )
                              : 0;
                          return (
                            <TableRow key={row.id}>
                              <TableCell>{ii ? getName(ii) : '—'}</TableCell>
                              <TableCell>{Number(row.quantity).toFixed(3)}</TableCell>
                              <TableCell>{row.unit}</TableCell>
                              <TableCell>{line.toFixed(2)} QAR</TableCell>
                            </TableRow>
                          );
                        })
                      )}
                    </TableBody>
                  </Table>
                </div>
                <p className="mt-2 text-sm font-medium">
                  {t('totalRecipeCost')}: {totalCost.toFixed(2)} QAR
                </p>
              </div>

              <div className="grid gap-4 sm:grid-cols-2 text-sm">
                <div className="rounded-lg border p-3">
                  <div className="text-muted-foreground">{t('targetMargin')}</div>
                  <div className="text-lg font-semibold">{marginPct.toFixed(1)}%</div>
                </div>
                <div className="rounded-lg border p-3">
                  <div className="text-muted-foreground">{t('taxPercentLabel')}</div>
                  <div className="text-lg font-semibold">{taxPct.toFixed(1)}%</div>
                </div>
              </div>
              <p className="text-xs text-muted-foreground">
                {t('pricingCurrency', { code: pricing?.currency ?? 'QAR' })}
              </p>

              <div className="space-y-2 max-w-xs">
                <Label>{t('overrideFinalPrice')}</Label>
                <Input
                  type="number"
                  step="0.01"
                  min={0}
                  value={overrideFinal}
                  onChange={(e) => {
                    setOverrideTouched(true);
                    setOverrideFinal(e.target.value);
                  }}
                />
              </div>

              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">{t('marginHealth')}</span>
                  <span
                    className={cn(
                      'font-medium',
                      actualMarginPct !== null && actualMarginPct >= marginPct
                        ? 'text-green-600 dark:text-green-500'
                        : actualMarginPct !== null && actualMarginPct >= marginPct * 0.85
                          ? 'text-amber-600 dark:text-amber-500'
                          : 'text-red-600 dark:text-red-500'
                    )}
                  >
                    {actualMarginPct !== null ? `${actualMarginPct.toFixed(1)}%` : '—'} ({t('targetMargin')}{' '}
                    {marginPct.toFixed(1)}%)
                  </span>
                </div>
                <div className="h-3 w-full overflow-hidden rounded-full bg-muted">
                  <div
                    className={cn('h-full transition-all', gaugeTone)}
                    style={{ width: `${gaugeWidth}%` }}
                  />
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-5">
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs font-medium text-muted-foreground">
                      {t('ingredientCost')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="text-lg font-bold">{totalCost.toFixed(2)} QAR</CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs font-medium text-muted-foreground">
                      {t('marginAmount')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="text-lg font-bold">{actualMarginAmount.toFixed(2)} QAR</CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs font-medium text-muted-foreground">
                      {t('suggestedPrice')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="text-lg font-bold">{suggestedNet.toFixed(2)} QAR</CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs font-medium text-muted-foreground">
                      {t('taxAmount')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="text-lg font-bold">
                    {(hasOverride ? displayFinal - actualNet : suggestedTax).toFixed(2)} QAR
                  </CardContent>
                </Card>
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs font-medium text-muted-foreground">
                      {t('finalPrice')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="text-lg font-bold">{displayFinal.toFixed(2)} QAR</CardContent>
                </Card>
              </div>

              <p className="text-xs text-muted-foreground">{t('calculatorFootnote')}</p>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
