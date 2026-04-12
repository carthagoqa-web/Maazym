'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { InventoryCategory, InventoryItem, PresetInventoryItem, UnitType } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from '@/components/ui/command';
import { Plus, Search, Edit, Trash2, ShieldCheck, ChevronsUpDown, Download } from 'lucide-react';
import { toast } from 'sonner';
import { BulkUploadButton } from '@/components/bulk-upload-button';
import { downloadInventoryItemsExport } from '@/lib/excel/templates';
import { useUser } from '@/hooks/use-user';
import { canViewFinancials, canDeleteInventoryCatalog } from '@/lib/roles';

const UNITS = ['kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can'] as const;

/** Row from Supabase join: related row may be object or single-element array */
type InventoryItemRow = Omit<InventoryItem, 'category'> & {
  category?: InventoryCategory | InventoryCategory[] | null;
};

function escapeIlikePattern(value: string): string {
  return value.replace(/\\/g, '\\\\').replace(/%/g, '\\%').replace(/_/g, '\\_');
}

export default function ItemsPage() {
  const t = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const { profile } = useUser();
  const showFinancials = canViewFinancials(profile?.role);
  const showDeleteItem = canDeleteInventoryCatalog(profile?.role);
  const [items, setItems] = useState<InventoryItemRow[]>([]);
  const [categories, setCategories] = useState<InventoryCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editItem, setEditItem] = useState<InventoryItemRow | null>(null);
  const [saving, setSaving] = useState(false);

  const [presets, setPresets] = useState<PresetInventoryItem[]>([]);
  const [presetsLoading, setPresetsLoading] = useState(false);
  const [presetPopoverOpen, setPresetPopoverOpen] = useState(false);

  const [form, setForm] = useState({
    name_ar: '',
    name_en: '',
    category_id: '',
    unit: 'kg' as string,
    unit_cost: '',
    calories_per_unit: '',
  });

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const getCategory = (item: InventoryItemRow) => {
    const cat = Array.isArray(item.category) ? item.category[0] : item.category;
    return cat ? getName(cat) : '';
  };

  function getCategoryNameEn(item: InventoryItemRow): string {
    const cat = Array.isArray(item.category) ? item.category[0] : item.category;
    return cat?.name_en?.trim() ?? '';
  }

  function handleExportItemsExcel() {
    const exportRows = items.map((item) => ({
      id: item.id,
      name_ar: item.name_ar,
      name_en: item.name_en,
      category_name_en: getCategoryNameEn(item),
      unit: item.unit,
      unit_cost: Number(item.unit_cost),
      calories_per_unit:
        item.calories_per_unit !== null && item.calories_per_unit !== undefined
          ? Number(item.calories_per_unit)
          : null,
    }));
    downloadInventoryItemsExport(exportRows);
  }

  const categorySelectItems = useMemo(
    () => categories.map((c) => ({ value: c.id, label: getName(c) })),
    [categories, locale]
  );

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    const supabase = createClient();
    const [itemsRes, catRes] = await Promise.all([
      supabase.from('inventory_items').select('*, category:inventory_categories(*)').eq('is_active', true).order('name_en'),
      supabase.from('inventory_categories').select('*').eq('is_active', true).order('sort_order'),
    ]);
    setItems((itemsRes.data as InventoryItemRow[]) || []);
    setCategories(catRes.data || []);
    setLoading(false);
  }

  async function loadPresets() {
    if (presets.length > 0 || presetsLoading) return;
    setPresetsLoading(true);
    try {
      const supabase = createClient();
      const { data, error } = await supabase.from('preset_inventory_items').select('*').order('name_en');
      if (error) throw error;
      setPresets(data || []);
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : tCommon('error');
      toast.error(message);
    } finally {
      setPresetsLoading(false);
    }
  }

  function openNew() {
    setEditItem(null);
    setForm({
      name_ar: '',
      name_en: '',
      category_id: '',
      unit: 'kg',
      unit_cost: '',
      calories_per_unit: '',
    });
    setDialogOpen(true);
  }

  function openEdit(item: InventoryItemRow) {
    setEditItem(item);
    setForm({
      name_ar: item.name_ar,
      name_en: item.name_en,
      category_id: item.category_id,
      unit: item.unit,
      unit_cost: item.unit_cost.toString(),
      calories_per_unit:
        item.calories_per_unit !== null && item.calories_per_unit !== undefined
          ? String(item.calories_per_unit)
          : '',
    });
    setDialogOpen(true);
  }

  function applyPreset(preset: PresetInventoryItem) {
    const matched = categories.find(
      (c) => c.name_en === preset.category || c.name_en.toLowerCase() === preset.category.toLowerCase()
    );
    setForm((prev) => ({
      ...prev,
      name_ar: preset.name_ar,
      name_en: preset.name_en,
      unit: preset.default_unit,
      category_id: matched?.id ?? prev.category_id,
      calories_per_unit:
        preset.calories_per_unit !== null && preset.calories_per_unit !== undefined
          ? String(preset.calories_per_unit)
          : '',
    }));
    setPresetPopoverOpen(false);
  }

  const lookupCaloriesFromReference = useCallback(
    async (nameEn: string) => {
      const trimmed = nameEn.trim();
      if (!trimmed) return;

      const supabase = createClient();
      const safe = escapeIlikePattern(trimmed);

      let { data: row } = await supabase
        .from('calorie_reference')
        .select('calories_per_unit')
        .ilike('name_en', safe)
        .maybeSingle();

      if (!row) {
        const res = await supabase
          .from('calorie_reference')
          .select('calories_per_unit')
          .ilike('name_en', `%${safe}%`)
          .limit(1)
          .maybeSingle();
        row = res.data;
      }

      if (row?.calories_per_unit !== null && row?.calories_per_unit !== undefined) {
        setForm((prev) => ({
          ...prev,
          calories_per_unit:
            prev.calories_per_unit === '' ? String(row!.calories_per_unit) : prev.calories_per_unit,
        }));
      }
    },
    []
  );

  async function handleNameEnBlur() {
    await lookupCaloriesFromReference(form.name_en);
  }

  async function handleSave() {
    setSaving(true);
    try {
      const supabase = createClient();
      const caloriesRaw = form.calories_per_unit.trim();
      let calories_per_unit: number | null = null;
      if (caloriesRaw !== '') {
        const n = Number.parseFloat(caloriesRaw);
        calories_per_unit = Number.isFinite(n) ? n : null;
      }

      const data = {
        name_ar: form.name_ar,
        name_en: form.name_en,
        category_id: form.category_id,
        unit: form.unit as UnitType,
        unit_cost: showFinancials
          ? Number.parseFloat(form.unit_cost) || 0
          : editItem
            ? Number(editItem.unit_cost) || 0
            : Number.parseFloat(form.unit_cost) || 0,
        calories_per_unit,
      };

      if (editItem) {
        const { error } = await supabase.from('inventory_items').update(data).eq('id', editItem.id);
        if (error) throw error;
        toast.success(tCommon('updated'));
      } else {
        const { error } = await supabase.from('inventory_items').insert(data);
        if (error) throw error;
        toast.success(tCommon('created'));
      }

      setDialogOpen(false);
      loadData();
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : tCommon('error');
      toast.error(message);
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(id: string) {
    const supabase = createClient();
    await supabase.from('inventory_items').update({ is_active: false }).eq('id', id);
    toast.success(tCommon('deleted'));
    loadData();
  }

  const filtered = items.filter(
    (item) =>
      search === '' ||
      item.name_ar.includes(search) ||
      item.name_en.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">{t('items')}</h1>
          <div className="flex items-center gap-2 mt-1">
            <ShieldCheck className="h-4 w-4 text-green-600" />
            <span className="text-sm text-green-600 font-medium">{t('halalOnly')}</span>
          </div>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          {showFinancials ? (
            <Button variant="outline" size="sm" onClick={handleExportItemsExcel} disabled={loading || items.length === 0}>
              <Download className="h-4 w-4 me-2" />
              {t('exportItemsExcel')}
            </Button>
          ) : null}
          {showFinancials ? <BulkUploadButton templateType="inventory_items" onUploadComplete={loadData} /> : null}
          <Button onClick={openNew}>
            <Plus className="h-4 w-4 me-2" />
            {t('addItem')}
          </Button>
        </div>
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
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{tCommon('category')}</TableHead>
                <TableHead>{tCommon('unit')}</TableHead>
                {showFinancials ? <TableHead>{t('unitCost')}</TableHead> : null}
                <TableHead>{tCommon('actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={showFinancials ? 5 : 4} className="text-center py-8 text-muted-foreground">
                    {tCommon('loading')}
                  </TableCell>
                </TableRow>
              ) : filtered.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={showFinancials ? 5 : 4} className="text-center py-8 text-muted-foreground">
                    {t('noItems')}
                  </TableCell>
                </TableRow>
              ) : (
                filtered.map((item) => {
                  const categoryLabel = getCategory(item);
                  return (
                  <TableRow key={item.id}>
                    <TableCell className="font-medium">{getName(item)}</TableCell>
                    <TableCell>
                      {categoryLabel ? (
                        <Badge variant="secondary">{categoryLabel}</Badge>
                      ) : null}
                    </TableCell>
                    <TableCell>{t(`units.${item.unit}`)}</TableCell>
                    {showFinancials ? (
                      <TableCell>
                        {Number(item.unit_cost).toFixed(2)} QAR
                      </TableCell>
                    ) : null}
                    <TableCell>
                      <div className="flex gap-1">
                        <Button variant="ghost" size="icon" onClick={() => openEdit(item)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                        {showDeleteItem ? (
                          <Button
                            variant="ghost"
                            size="icon"
                            className="text-destructive"
                            onClick={() => handleDelete(item.id)}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        ) : null}
                      </div>
                    </TableCell>
                  </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog
        open={dialogOpen}
        onOpenChange={(open) => {
          setDialogOpen(open);
          if (!open) setPresetPopoverOpen(false);
        }}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{editItem ? t('editItem') : t('addItem')}</DialogTitle>
          </DialogHeader>

          {!editItem && (
            <div className="space-y-2">
              <Popover
                open={presetPopoverOpen}
                onOpenChange={(o) => {
                  setPresetPopoverOpen(o);
                  if (o) void loadPresets();
                }}
              >
                <PopoverTrigger
                  render={
                    <Button
                      type="button"
                      variant="outline"
                      role="combobox"
                      aria-expanded={presetPopoverOpen}
                      className="w-full justify-between font-normal"
                    >
                      {t('pickFromPresets')}
                      <ChevronsUpDown className="ms-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  }
                />
                <PopoverContent className="w-[min(100vw-2rem,var(--anchor-width))] min-w-[280px] p-0" align="start">
                  <Command>
                    <CommandInput placeholder={tCommon('search')} />
                    <CommandList>
                      <CommandEmpty>
                        {presetsLoading ? tCommon('loading') : tCommon('noResults')}
                      </CommandEmpty>
                      <CommandGroup heading={t('presetItems')}>
                        {presets.map((p) => (
                          <CommandItem
                            key={p.id}
                            value={`${p.name_en} ${p.name_ar} ${p.category}`}
                            onSelect={() => applyPreset(p)}
                          >
                            <span className="truncate">{getName(p)}</span>
                            <span className="text-muted-foreground text-xs truncate"> · {p.default_unit}</span>
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </CommandList>
                  </Command>
                </PopoverContent>
              </Popover>
              <p className="text-xs text-muted-foreground text-center">{t('orAddManually')}</p>
            </div>
          )}

          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('itemNameAr')}</Label>
              <Input
                value={form.name_ar}
                onChange={(e) => setForm({ ...form, name_ar: e.target.value })}
                dir="rtl"
                required
              />
            </div>
            <div className="space-y-2">
              <Label>{t('itemNameEn')}</Label>
              <Input
                value={form.name_en}
                onChange={(e) => setForm({ ...form, name_en: e.target.value })}
                onBlur={() => void handleNameEnBlur()}
                dir="ltr"
                required
              />
            </div>
            <div className="space-y-2">
              <Label>{tCommon('category')}</Label>
              <Select
                value={form.category_id}
                onValueChange={(v) => setForm({ ...form, category_id: v ?? '' })}
                items={categorySelectItems}
              >
                <SelectTrigger>
                  <SelectValue placeholder={tCommon('category')} />
                </SelectTrigger>
                <SelectContent>
                  {categories.map((cat) => (
                    <SelectItem key={cat.id} value={cat.id} label={getName(cat)}>
                      {getName(cat)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className={showFinancials ? 'grid grid-cols-2 gap-4' : 'space-y-2'}>
              <div className="space-y-2">
                <Label>{tCommon('unit')}</Label>
                <Select value={form.unit} onValueChange={(v) => setForm({ ...form, unit: v ?? 'kg' })}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {UNITS.map((u) => (
                      <SelectItem key={u} value={u}>
                        {t(`units.${u}`)}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              {showFinancials ? (
                <div className="space-y-2">
                  <Label>
                    {t('unitCost')} (QAR)
                  </Label>
                  <Input
                    type="number"
                    step="0.01"
                    value={form.unit_cost}
                    onChange={(e) => setForm({ ...form, unit_cost: e.target.value })}
                  />
                </div>
              ) : null}
            </div>
            <div className="space-y-2">
              <Label>{t('caloriesPerUnit')}</Label>
              <Input
                type="number"
                step="0.01"
                min="0"
                value={form.calories_per_unit}
                onChange={(e) => setForm({ ...form, calories_per_unit: e.target.value })}
                dir="ltr"
                placeholder={tCommon('optional')}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={() => void handleSave()} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
