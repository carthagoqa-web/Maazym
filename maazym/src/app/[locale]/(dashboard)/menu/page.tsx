'use client';

import { useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { MenuItem, MenuSection, Recipe, RecipeCostSummary } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import { Skeleton } from '@/components/ui/skeleton';
import { Plus, Search, Edit } from 'lucide-react';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';
import { BulkUploadButton } from '@/components/bulk-upload-button';
import { withTimeout } from '@/lib/with-timeout';

const NO_RECIPE = '__none__';
const NO_SECTION = '__none__';

type MenuItemRow = MenuItem & {
  recipe?: Recipe | null;
  section?: MenuSection | null;
};

function marginPercent(selling: number, cost: number): number | null {
  if (selling <= 0) return null;
  return ((selling - cost) / selling) * 100;
}

function marginTone(pct: number | null): string {
  if (pct === null) return 'text-muted-foreground';
  if (pct >= 50) return 'text-green-600 dark:text-green-500';
  if (pct >= 30) return 'text-yellow-600 dark:text-yellow-500';
  return 'text-red-600 dark:text-red-500';
}

export default function MenuPage() {
  const t = useTranslations('menu');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [rows, setRows] = useState<MenuItemRow[]>([]);
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [sections, setSections] = useState<MenuSection[]>([]);
  const [costByRecipeId, setCostByRecipeId] = useState<Map<string, number>>(new Map());
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editItem, setEditItem] = useState<MenuItemRow | null>(null);
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    recipe_id: '',
    section_id: '',
    name_ar: '',
    name_en: '',
    selling_price: '',
    is_available: true,
  });

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      const supabase = createClient();
      const [menuRes, recipesRes, sectionsRes, costsRes] = await withTimeout(
        Promise.all([
          supabase
            .from('menu_items')
            .select('*, recipe:recipes(*), section:menu_sections(*)')
            .order('display_order', { ascending: true }),
          supabase.from('recipes').select('*').eq('is_active', true).order('name_en'),
          supabase.from('menu_sections').select('*').eq('is_active', true).order('sort_order'),
          supabase.from('recipe_cost_summary').select('*'),
        ]),
        30_000,
        'Menu load'
      );

      if (menuRes.error) console.error('menu_items load error:', menuRes.error);

      const costMap = new Map<string, number>();
      (costsRes.data as RecipeCostSummary[] | null)?.forEach((c) => {
        costMap.set(c.recipe_id, Number(c.total_cost) || 0);
      });
      setCostByRecipeId(costMap);
      setRows((menuRes.data as MenuItemRow[]) || []);
      setRecipes((recipesRes.data as Recipe[]) || []);
      setSections((sectionsRes.data as MenuSection[]) || []);
    } catch (e) {
      console.error('Menu load error:', e);
    } finally {
      setLoading(false);
    }
  }

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  function costForRow(item: MenuItemRow): number {
    if (!item.recipe_id) return 0;
    return costByRecipeId.get(item.recipe_id) ?? 0;
  }

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return rows;
    return rows.filter(
      (r) =>
        r.name_ar.toLowerCase().includes(q) ||
        r.name_en.toLowerCase().includes(q) ||
        (r.recipe && (r.recipe.name_ar.toLowerCase().includes(q) || r.recipe.name_en.toLowerCase().includes(q))) ||
        (r.section && (r.section.name_ar.toLowerCase().includes(q) || r.section.name_en.toLowerCase().includes(q)))
    );
  }, [rows, search]);

  const stats = useMemo(() => {
    const total = filtered.length;
    const available = filtered.filter((r) => r.is_available).length;
    const unavailable = total - available;
    const pcts = filtered
      .map((r) => marginPercent(Number(r.selling_price), costForRow(r)))
      .filter((p): p is number => p !== null);
    const avgMargin =
      pcts.length > 0 ? pcts.reduce((a, b) => a + b, 0) / pcts.length : null;
    return { total, available, unavailable, avgMargin };
  }, [filtered, costByRecipeId]);

  function openNew() {
    setEditItem(null);
    setForm({
      recipe_id: '',
      section_id: '',
      name_ar: '',
      name_en: '',
      selling_price: '',
      is_available: true,
    });
    setDialogOpen(true);
  }

  function openEdit(item: MenuItemRow) {
    setEditItem(item);
    setForm({
      recipe_id: item.recipe_id || '',
      section_id: item.section_id || '',
      name_ar: item.name_ar,
      name_en: item.name_en,
      selling_price: String(item.selling_price),
      is_available: item.is_available,
    });
    setDialogOpen(true);
  }

  function applyRecipeNames(recipeId: string) {
    if (!recipeId) return;
    const r = recipes.find((x) => x.id === recipeId);
    if (r) {
      setForm((f) => ({ ...f, name_ar: r.name_ar, name_en: r.name_en }));
    }
  }

  async function handleSave() {
    setSaving(true);
    try {
      const supabase = createClient();
      const selling = parseFloat(form.selling_price);
      if (Number.isNaN(selling) || selling < 0) {
        toast.error(tCommon('error'));
        setSaving(false);
        return;
      }

      const payload = {
        recipe_id: form.recipe_id ? form.recipe_id : null,
        section_id: form.section_id ? form.section_id : null,
        name_ar: form.name_ar.trim(),
        name_en: form.name_en.trim(),
        selling_price: selling,
        is_available: form.is_available,
      };

      if (!payload.name_ar || !payload.name_en) {
        toast.error(tCommon('required'));
        setSaving(false);
        return;
      }

      if (editItem) {
        const { error } = await supabase.from('menu_items').update(payload).eq('id', editItem.id);
        if (error) throw error;
        toast.success(tCommon('updated'));
      } else {
        const maxOrder = rows.reduce((m, r) => Math.max(m, r.display_order), -1);
        const { error } = await supabase
          .from('menu_items')
          .insert({ ...payload, display_order: maxOrder + 1 });
        if (error) throw error;
        toast.success(tCommon('created'));
      }

      setDialogOpen(false);
      loadData();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  async function toggleAvailable(item: MenuItemRow, next: boolean) {
    const prev = item.is_available;
    setRows((list) =>
      list.map((r) => (r.id === item.id ? { ...r, is_available: next } : r))
    );
    const supabase = createClient();
    const { error } = await supabase.from('menu_items').update({ is_available: next }).eq('id', item.id);
    if (error) {
      setRows((list) =>
        list.map((r) => (r.id === item.id ? { ...r, is_available: prev } : r))
      );
      toast.error(error.message || tCommon('error'));
      return;
    }
    toast.success(tCommon('updated'));
  }

  const dialogRecipeValue = form.recipe_id || NO_RECIPE;
  const dialogSectionValue = form.section_id || NO_SECTION;
  const dialogCost = form.recipe_id ? (costByRecipeId.get(form.recipe_id) ?? 0) : 0;

  const recipeSelectItems = useMemo(
    () => [
      { value: NO_RECIPE, label: t('noRecipeLinked') },
      ...recipes.map((r) => ({ value: r.id, label: getName(r) })),
    ],
    [recipes, locale, t]
  );

  const sectionSelectItems = useMemo(
    () => [
      { value: NO_SECTION, label: tCommon('optional') },
      ...sections.map((s) => ({ value: s.id, label: getName(s) })),
    ],
    [sections, locale, tCommon]
  );

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <Skeleton key={i} className="h-24" />
          ))}
        </div>
        <Skeleton className="h-96" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">{t('title')}</h1>
        <div className="flex flex-wrap items-center gap-2">
          <BulkUploadButton templateType="menu_items" onUploadComplete={loadData} />
          <Button onClick={openNew}>
            <Plus className="h-4 w-4 me-2" />
            {t('addItem')}
          </Button>
        </div>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsTotalItems')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold">{stats.total}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsAvailable')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold text-green-600">{stats.available}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsUnavailable')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold text-muted-foreground">{stats.unavailable}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('averageMarginPercent')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold">
            {stats.avgMargin !== null ? `${stats.avgMargin.toFixed(1)}%` : '—'}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div className="relative">
            <Search className="absolute start-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder={tCommon('search')}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="ps-9"
            />
          </div>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{t('section')}</TableHead>
                <TableHead>{t('linkedRecipe')}</TableHead>
                <TableHead>{t('sellingPrice')}</TableHead>
                <TableHead>{tCommon('cost')}</TableHead>
                <TableHead>{t('margin')}</TableHead>
                <TableHead>{t('marginPercent')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
                <TableHead>{tCommon('actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={9} className="py-8 text-center text-muted-foreground">
                    {t('noItems')}
                  </TableCell>
                </TableRow>
              ) : (
                filtered.map((item) => {
                  const cost = costForRow(item);
                  const sell = Number(item.selling_price);
                  const margin = sell - cost;
                  const pct = marginPercent(sell, cost);
                  return (
                    <TableRow key={item.id}>
                      <TableCell className="font-medium">{getName(item)}</TableCell>
                      <TableCell>
                        {item.section ? (
                          <Badge variant="secondary">{getName(item.section)}</Badge>
                        ) : (
                          <span className="text-muted-foreground">—</span>
                        )}
                      </TableCell>
                      <TableCell>
                        {item.recipe ? (
                          <span>{getName(item.recipe)}</span>
                        ) : (
                          <span className="text-muted-foreground">{t('noRecipeLinked')}</span>
                        )}
                      </TableCell>
                      <TableCell>{tCommon('currencyAmount', { amount: sell.toFixed(2) })}</TableCell>
                      <TableCell>{tCommon('currencyAmount', { amount: cost.toFixed(2) })}</TableCell>
                      <TableCell className={cn('font-medium', marginTone(pct))}>
                        {tCommon('currencyAmount', { amount: margin.toFixed(2) })}
                      </TableCell>
                      <TableCell className={cn('font-medium', marginTone(pct))}>
                        {pct !== null ? `${pct.toFixed(1)}%` : '—'}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center gap-2">
                          <Switch
                            checked={item.is_available}
                            onCheckedChange={(v) => toggleAvailable(item, Boolean(v))}
                          />
                          <span className="text-sm text-muted-foreground">
                            {item.is_available ? t('available') : t('unavailable')}
                          </span>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Button variant="ghost" size="icon" onClick={() => openEdit(item)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-lg" showCloseButton>
          <DialogHeader>
            <DialogTitle>{editItem ? t('editItem') : t('addItem')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('selectRecipe')}</Label>
              <Select
                value={dialogRecipeValue}
                onValueChange={(v) => {
                  const raw = v ?? NO_RECIPE;
                  const id = raw === NO_RECIPE ? '' : raw;
                  setForm((f) => ({ ...f, recipe_id: id }));
                  if (id) applyRecipeNames(id);
                }}
                items={recipeSelectItems}
              >
                <SelectTrigger>
                  <SelectValue placeholder={t('selectRecipe')} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={NO_RECIPE}>{t('noRecipeLinked')}</SelectItem>
                  {recipes.map((r) => (
                    <SelectItem key={r.id} value={r.id} label={getName(r)}>
                      {getName(r)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('selectSection')}</Label>
              <Select
                value={dialogSectionValue}
                onValueChange={(v) => {
                  const raw = v ?? NO_SECTION;
                  setForm((f) => ({ ...f, section_id: raw === NO_SECTION ? '' : raw }));
                }}
                items={sectionSelectItems}
              >
                <SelectTrigger>
                  <SelectValue placeholder={t('selectSection')} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={NO_SECTION}>{tCommon('optional')}</SelectItem>
                  {sections.map((s) => (
                    <SelectItem key={s.id} value={s.id} label={getName(s)}>
                      {getName(s)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('itemNameAr')}</Label>
              <Input
                dir="rtl"
                value={form.name_ar}
                onChange={(e) => setForm({ ...form, name_ar: e.target.value })}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('itemNameEn')}</Label>
              <Input
                dir="ltr"
                value={form.name_en}
                onChange={(e) => setForm({ ...form, name_en: e.target.value })}
              />
            </div>
            <div className="space-y-2">
              <Label>
                {t('sellingPrice')} ({tCommon('currencyCode')})
              </Label>
              <Input
                type="number"
                step="0.01"
                min={0}
                value={form.selling_price}
                onChange={(e) => setForm({ ...form, selling_price: e.target.value })}
              />
            </div>
            {form.recipe_id ? (
              <p className="text-sm text-muted-foreground">
                {t('recipeCost')}: {tCommon('currencyAmount', { amount: dialogCost.toFixed(2) })}
              </p>
            ) : null}
            <div className="flex items-center gap-2">
              <Switch
                checked={form.is_available}
                onCheckedChange={(v) => setForm((f) => ({ ...f, is_available: Boolean(v) }))}
              />
              <Label className="font-normal">{t('available')}</Label>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={handleSave} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
