'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { useUser } from '@/hooks/use-user';
import { canAccessPriceSimulator } from '@/lib/roles';
import type { InventoryItem, MenuItem, PriceSimulation, Recipe, SimulationOverride, UnitType } from '@/types/database';
import { ingredientLineCost } from '@/lib/pricing/recipe-cost';
import { PromotionsSubnav } from '@/components/promotions/promotions-subnav';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/lib/utils';
import { toast } from 'sonner';
import { Search } from 'lucide-react';

const NO_SIM = '__none__';

type RiRow = {
  id: string;
  recipe_id: string;
  inventory_item_id: string;
  quantity: number;
  unit: string;
  inventory_item?: InventoryItem | null;
};

function marginPct(sell: number, cost: number): number | null {
  if (sell <= 0) return null;
  return ((sell - cost) / sell) * 100;
}

export default function PriceSimulatorPage() {
  const t = useTranslations('promotions');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const router = useRouter();
  const { profile, loading: userLoading } = useUser();
  const [loading, setLoading] = useState(true);
  const [inventory, setInventory] = useState<InventoryItem[]>([]);
  const [recipeIngredients, setRecipeIngredients] = useState<RiRow[]>([]);
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [simulations, setSimulations] = useState<PriceSimulation[]>([]);
  const [overrideInputs, setOverrideInputs] = useState<Record<string, string>>({});
  const [search, setSearch] = useState('');
  const [saveOpen, setSaveOpen] = useState(false);
  const [saveName, setSaveName] = useState('');
  const [saveDesc, setSaveDesc] = useState('');
  const [saving, setSaving] = useState(false);
  const [selectedSimId, setSelectedSimId] = useState<string>(NO_SIM);

  useEffect(() => {
    if (userLoading) return;
    if (!canAccessPriceSimulator(profile?.role)) {
      router.replace(`/${locale}/promotions`);
    }
  }, [userLoading, profile?.role, locale, router]);

  const loadData = useCallback(async () => {
    const supabase = createClient();
    const [invRes, riRes, menuRes, recRes, simRes] = await Promise.all([
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
      supabase.from('recipe_ingredients').select('*, inventory_item:inventory_items(*)'),
      supabase.from('menu_items').select('*'),
      supabase.from('recipes').select('*').eq('is_active', true),
      supabase.from('price_simulations').select('*').order('created_at', { ascending: false }),
    ]);
    setInventory((invRes.data as InventoryItem[]) || []);
    setRecipeIngredients((riRes.data as RiRow[]) || []);
    setMenuItems((menuRes.data as MenuItem[]) || []);
    setRecipes((recRes.data as Recipe[]) || []);
    setSimulations((simRes.data as PriceSimulation[]) || []);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const effectiveUnitCost = useCallback(
    (item: InventoryItem) => {
      const raw = overrideInputs[item.id];
      if (raw === undefined || raw.trim() === '') return Number(item.unit_cost);
      const v = parseFloat(raw);
      return Number.isNaN(v) ? Number(item.unit_cost) : v;
    },
    [overrideInputs]
  );

  const recipeTotal = useCallback(
    (recipeId: string, resolver: (item: InventoryItem) => number) => {
      let sum = 0;
      for (const ri of recipeIngredients) {
        if (ri.recipe_id !== recipeId) continue;
        const ii = ri.inventory_item;
        if (!ii) continue;
        const uc = resolver(ii);
        sum += ingredientLineCost(ri.quantity, ri.unit as UnitType, ii.unit, uc);
      }
      return sum;
    },
    [recipeIngredients]
  );

  const recipeIds = useMemo(() => {
    const s = new Set<string>();
    recipeIngredients.forEach((ri) => s.add(ri.recipe_id));
    return [...s];
  }, [recipeIngredients]);

  const currentRecipeCost = useCallback(
    (rid: string) => recipeTotal(rid, (ii) => Number(ii.unit_cost)),
    [recipeTotal]
  );

  const simulatedRecipeCost = useCallback(
    (rid: string) => recipeTotal(rid, (ii) => effectiveUnitCost(ii)),
    [recipeTotal, effectiveUnitCost]
  );

  const recipeRows = useMemo(() => {
    return recipeIds
      .map((id) => {
        const cur = currentRecipeCost(id);
        const sim = simulatedRecipeCost(id);
        const delta = sim - cur;
        return { id, cur, sim, delta };
      })
      .filter((r) => Math.abs(r.delta) > 0.0001);
  }, [recipeIds, currentRecipeCost, simulatedRecipeCost]);

  const menuRows = useMemo(() => {
    return menuItems
      .filter((m) => m.recipe_id)
      .map((m) => {
        const rid = m.recipe_id as string;
        const sell = Number(m.selling_price);
        const cur = currentRecipeCost(rid);
        const sim = simulatedRecipeCost(rid);
        const p0 = marginPct(sell, cur);
        const p1 = marginPct(sell, sim);
        const d = p0 !== null && p1 !== null ? p1 - p0 : null;
        return { m, rid, sell, cur, sim, p0, p1, d };
      })
      .filter((row) => Math.abs(row.sim - row.cur) > 0.0001);
  }, [menuItems, currentRecipeCost, simulatedRecipeCost]);

  const summary = useMemo(() => {
    const n = recipeRows.length;
    const deltas = menuRows.map((r) => r.d).filter((x): x is number => x !== null);
    const avg = deltas.length ? deltas.reduce((a, b) => a + b, 0) / deltas.length : null;
    return { n, avg };
  }, [recipeRows, menuRows]);

  const filteredInventory = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return inventory;
    return inventory.filter(
      (i) =>
        i.name_ar.toLowerCase().includes(q) ||
        i.name_en.toLowerCase().includes(q)
    );
  }, [inventory, search]);

  async function handleSaveSimulation() {
    if (!saveName.trim()) {
      toast.error(tCommon('required'));
      return;
    }
    const entries = inventory
      .map((i) => {
        const raw = overrideInputs[i.id];
        if (raw === undefined || raw.trim() === '') return null;
        const sim = parseFloat(raw);
        if (Number.isNaN(sim)) return null;
        const orig = Number(i.unit_cost);
        if (Math.abs(sim - orig) < 0.0001) return null;
        return {
          inventory_item_id: i.id,
          original_cost: orig,
          simulated_cost: sim,
        };
      })
      .filter(Boolean) as {
      inventory_item_id: string;
      original_cost: number;
      simulated_cost: number;
    }[];

    if (entries.length === 0) {
      toast.error(t('noOverridesToSave'));
      return;
    }

    setSaving(true);
    try {
      const supabase = createClient();
      const { data: simRow, error: simErr } = await supabase
        .from('price_simulations')
        .insert({
          name: saveName.trim(),
          description: saveDesc.trim() || null,
        })
        .select('id')
        .single();
      if (simErr) throw simErr;
      const sid = simRow?.id;
      if (!sid) throw new Error('sim id');

      const { error: ovErr } = await supabase.from('simulation_overrides').insert(
        entries.map((e) => ({
          simulation_id: sid,
          inventory_item_id: e.inventory_item_id,
          original_cost: e.original_cost,
          simulated_cost: e.simulated_cost,
        }))
      );
      if (ovErr) throw ovErr;

      toast.success(tCommon('created'));
      setSaveOpen(false);
      setSaveName('');
      setSaveDesc('');
      loadData();
    } catch (e: unknown) {
      toast.error(e instanceof Error ? e.message : tCommon('error'));
    } finally {
      setSaving(false);
    }
  }

  async function loadSimulationOverrides(simId: string) {
    const supabase = createClient();
    const { data, error } = await supabase
      .from('simulation_overrides')
      .select('*')
      .eq('simulation_id', simId);
    if (error) {
      toast.error(error.message);
      return;
    }
    const next: Record<string, string> = {};
    (data as SimulationOverride[]).forEach((o) => {
      next[o.inventory_item_id] = String(o.simulated_cost);
    });
    setOverrideInputs(next);
  }

  const simSelectValue = selectedSimId || NO_SIM;

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
        <Skeleton className="h-96" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PromotionsSubnav />
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">{t('simulator')}</h1>
        <Button onClick={() => setSaveOpen(true)}>{t('saveSimulation')}</Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('loadSimulation')}</CardTitle>
        </CardHeader>
        <CardContent className="flex flex-col gap-4 sm:flex-row sm:items-end">
          <div className="space-y-2 flex-1 max-w-md">
            <Label>{t('existingSimulation')}</Label>
            <Select
              value={simSelectValue}
              onValueChange={(v) => {
                const raw = v ?? NO_SIM;
                setSelectedSimId(raw === NO_SIM ? NO_SIM : raw);
                if (raw !== NO_SIM) loadSimulationOverrides(raw);
                else setOverrideInputs({});
              }}
            >
              <SelectTrigger>
                <SelectValue placeholder={t('pickSimulation')} />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NO_SIM}>{t('clearSimulation')}</SelectItem>
                {simulations.map((s) => (
                  <SelectItem key={s.id} value={s.id} label={s.name}>
                    {s.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <Button
            type="button"
            variant="outline"
            onClick={() => {
              setOverrideInputs({});
              setSelectedSimId(NO_SIM);
            }}
          >
            {t('resetOverrides')}
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <div className="relative max-w-md">
            <Search className="absolute start-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder={tCommon('search')}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="ps-9"
            />
          </div>
          <CardTitle className="text-base pt-2">{t('inventoryOverrides')}</CardTitle>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{t('currentCost')}</TableHead>
                <TableHead>{t('simulatedCost')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredInventory.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={3} className="text-center text-muted-foreground py-8">
                    {tCommon('noResults')}
                  </TableCell>
                </TableRow>
              ) : (
                filteredInventory.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell className="font-medium">{getName(item)}</TableCell>
                    <TableCell>{Number(item.unit_cost).toFixed(2)} QAR</TableCell>
                    <TableCell>
                      <Input
                        className="w-32"
                        type="number"
                        step="0.01"
                        min={0}
                        placeholder={Number(item.unit_cost).toFixed(2)}
                        value={overrideInputs[item.id] ?? ''}
                        onChange={(e) => {
                          const v = e.target.value;
                          setOverrideInputs((prev) => {
                            const next = { ...prev };
                            if (v === '') delete next[item.id];
                            else next[item.id] = v;
                            return next;
                          });
                        }}
                      />
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('simulationSummary')}</CardTitle>
        </CardHeader>
        <CardContent className="text-sm space-y-1">
          <p>
            {t('recipesAffectedCount', { count: summary.n })}
          </p>
          <p>
            {t('avgMarginChange')}:{' '}
            {summary.avg !== null ? (
              <span
                className={cn(
                  'font-semibold',
                  summary.avg > 0
                    ? 'text-green-600 dark:text-green-500'
                    : summary.avg < 0
                      ? 'text-red-600 dark:text-red-500'
                      : ''
                )}
              >
                {summary.avg > 0 ? '+' : ''}
                {summary.avg.toFixed(2)}%
              </span>
            ) : (
              '—'
            )}
          </p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('recipeImpact')}</CardTitle>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{t('currentCost')}</TableHead>
                <TableHead>{t('simulatedCost')}</TableHead>
                <TableHead>{t('delta')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {recipeRows.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center text-muted-foreground py-8">
                    {t('noCostChanges')}
                  </TableCell>
                </TableRow>
              ) : (
                recipeRows.map((row) => {
                  const r = recipes.find((x) => x.id === row.id);
                  return (
                    <TableRow key={row.id}>
                      <TableCell>{r ? getName(r) : row.id}</TableCell>
                      <TableCell>{row.cur.toFixed(2)} QAR</TableCell>
                      <TableCell>{row.sim.toFixed(2)} QAR</TableCell>
                      <TableCell
                        className={cn(
                          'font-medium',
                          row.delta > 0
                            ? 'text-red-600 dark:text-red-500'
                            : row.delta < 0
                              ? 'text-green-600 dark:text-green-500'
                              : ''
                        )}
                      >
                        {row.delta > 0 ? '+' : ''}
                        {row.delta.toFixed(2)} QAR
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('menuMarginImpact')}</CardTitle>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{t('marginPercentCurrent')}</TableHead>
                <TableHead>{t('marginPercentSimulated')}</TableHead>
                <TableHead>{t('marginDelta')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {menuRows.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center text-muted-foreground py-8">
                    {t('noCostChanges')}
                  </TableCell>
                </TableRow>
              ) : (
                menuRows.map((row) => (
                  <TableRow key={row.m.id}>
                    <TableCell className="font-medium">{getName(row.m)}</TableCell>
                    <TableCell>{row.p0 !== null ? `${row.p0.toFixed(1)}%` : '—'}</TableCell>
                    <TableCell>{row.p1 !== null ? `${row.p1.toFixed(1)}%` : '—'}</TableCell>
                    <TableCell
                      className={cn(
                        'font-medium',
                        row.d !== null && row.d > 0
                          ? 'text-green-600 dark:text-green-500'
                          : row.d !== null && row.d < 0
                            ? 'text-red-600 dark:text-red-500'
                            : ''
                      )}
                    >
                      {row.d === null
                        ? '—'
                        : `${row.d > 0 ? '+' : ''}${row.d.toFixed(2)}%`}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={saveOpen} onOpenChange={setSaveOpen}>
        <DialogContent showCloseButton>
          <DialogHeader>
            <DialogTitle>{t('saveSimulation')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('simulationName')}</Label>
              <Input value={saveName} onChange={(e) => setSaveName(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>{tCommon('description')}</Label>
              <Input value={saveDesc} onChange={(e) => setSaveDesc(e.target.value)} />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setSaveOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={handleSaveSimulation} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
