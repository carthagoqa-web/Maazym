'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { InventoryCategory, InventoryItem, WasteLog, WasteReason } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Textarea } from '@/components/ui/textarea';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from '@/components/ui/command';
import { Plus, ChevronsUpDown, TrendingDown } from 'lucide-react';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';
import { BulkUploadButton } from '@/components/bulk-upload-button';

const WASTE_REASONS: WasteReason[] = ['expired', 'spoiled', 'preparation', 'other'];

type WasteRow = WasteLog & {
  inventory_item?: (InventoryItem & { category?: InventoryCategory | null }) | null;
  logger?: { full_name: string } | null;
};

function wasteCost(row: WasteRow) {
  const unit = row.inventory_item?.unit_cost ?? 0;
  return Number(row.quantity) * Number(unit);
}

function reasonBadgeClass(reason: WasteReason) {
  switch (reason) {
    case 'expired':
      return 'border-amber-500/40 bg-amber-500/10 text-amber-800 dark:text-amber-200';
    case 'spoiled':
      return 'border-orange-500/40 bg-orange-500/10 text-orange-800 dark:text-orange-200';
    case 'preparation':
      return 'border-violet-500/40 bg-violet-500/10 text-violet-800 dark:text-violet-200';
    case 'other':
    default:
      return 'bg-secondary text-secondary-foreground border-transparent';
  }
}

export default function WastePage() {
  const t = useTranslations('waste');
  const tInv = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();

  const [rows, setRows] = useState<WasteRow[]>([]);
  const [items, setItems] = useState<InventoryItem[]>([]);
  const [categories, setCategories] = useState<InventoryCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [reasonFilter, setReasonFilter] = useState<string>('all');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');

  const [todayCount, setTodayCount] = useState(0);
  const [todayCost, setTodayCost] = useState(0);
  const [monthCost, setMonthCost] = useState(0);

  const [dialogOpen, setDialogOpen] = useState(false);
  const [itemPopoverOpen, setItemPopoverOpen] = useState(false);
  const [itemSearchCategory, setItemSearchCategory] = useState<string>('all');

  const [form, setForm] = useState({
    item_id: '',
    quantity: '',
    reason: 'expired' as WasteReason,
    waste_date: new Date().toISOString().split('T')[0],
    notes: '',
  });

  const getName = (x: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? x.name_ar : x.name_en;

  const wasteCategoryFilterItems = useMemo(
    () => [
      { value: 'all', label: tCommon('all') },
      ...categories.map((c) => ({ value: c.id, label: getName(c) })),
    ],
    [categories, locale, tCommon]
  );

  const todayStr = useMemo(() => new Date().toISOString().split('T')[0], []);

  const monthRange = useMemo(() => {
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), 1);
    const end = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    return {
      start: start.toISOString().split('T')[0],
      end: end.toISOString().split('T')[0],
    };
  }, []);

  const loadStats = useCallback(async () => {
    const supabase = createClient();
    const [todayRes, monthRes] = await Promise.all([
      supabase
        .from('waste_logs')
        .select('quantity, inventory_item:inventory_items(unit_cost)')
        .eq('waste_date', todayStr),
      supabase
        .from('waste_logs')
        .select('quantity, inventory_item:inventory_items(unit_cost)')
        .gte('waste_date', monthRange.start)
        .lte('waste_date', monthRange.end),
    ]);

    const pickUnitCost = (row: { quantity: unknown; inventory_item: unknown }) => {
      const raw = row.inventory_item;
      const item = Array.isArray(raw) ? raw[0] : raw;
      const cost =
        item && typeof item === 'object' && 'unit_cost' in item
          ? Number((item as { unit_cost: number }).unit_cost)
          : 0;
      return Number(row.quantity) * cost;
    };

    const todayRows = todayRes.data ?? [];
    const monthRows = monthRes.data ?? [];

    setTodayCount(todayRows.length);
    setTodayCost(todayRows.reduce((s, r) => s + pickUnitCost(r), 0));
    setMonthCost(monthRows.reduce((s, r) => s + pickUnitCost(r), 0));
  }, [todayStr, monthRange.start, monthRange.end]);

  const loadList = useCallback(async () => {
    const supabase = createClient();
    let q = supabase
      .from('waste_logs')
      .select(
        '*, inventory_item:inventory_items(*, category:inventory_categories(*)), logger:profiles(full_name)'
      )
      .order('waste_date', { ascending: false })
      .order('created_at', { ascending: false });

    if (reasonFilter !== 'all') {
      q = q.eq('reason', reasonFilter);
    }
    if (fromDate) q = q.gte('waste_date', fromDate);
    if (toDate) q = q.lte('waste_date', toDate);

    const { data, error } = await q;
    if (error) {
      console.error(error);
      toast.error(error.message || tCommon('error'));
      setRows([]);
    } else {
      setRows((data as WasteRow[]) || []);
    }
  }, [reasonFilter, fromDate, toDate, tCommon]);

  const loadSupporting = useCallback(async () => {
    const supabase = createClient();
    const [itemsRes, catRes] = await Promise.all([
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
      supabase.from('inventory_categories').select('*').eq('is_active', true).order('sort_order'),
    ]);
    setItems(itemsRes.data || []);
    setCategories(catRes.data || []);
  }, []);

  useEffect(() => {
    loadSupporting();
    loadStats();
  }, [loadSupporting, loadStats]);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      await loadList();
      if (!cancelled) setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [loadList]);

  const selectedItem = items.find((i) => i.id === form.item_id);

  const filteredPickerItems = useMemo(() => {
    let list = items;
    if (itemSearchCategory !== 'all') {
      list = list.filter((i) => i.category_id === itemSearchCategory);
    }
    return list;
  }, [items, itemSearchCategory]);

  function openDialog() {
    setForm({
      item_id: '',
      quantity: '',
      reason: 'expired',
      waste_date: new Date().toISOString().split('T')[0],
      notes: '',
    });
    setItemSearchCategory('all');
    setDialogOpen(true);
  }

  async function handleLogWaste() {
    if (!form.item_id || !parseFloat(form.quantity) || parseFloat(form.quantity) <= 0) {
      toast.error(tCommon('required'));
      return;
    }

    setSaving(true);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user?.id) {
        toast.error(tCommon('error'));
        return;
      }

      const { data: profile } = await supabase
        .from('profiles')
        .select('branch_id')
        .eq('id', user.id)
        .maybeSingle();

      const { error } = await supabase.from('waste_logs').insert({
        item_id: form.item_id,
        quantity: parseFloat(form.quantity),
        reason: form.reason,
        waste_date: form.waste_date,
        notes: form.notes.trim() || null,
        logged_by: user.id,
        branch_id: profile?.branch_id ?? null,
      });

      if (error) throw error;

      toast.success(t('logSuccess'));
      setDialogOpen(false);
      await loadStats();
      await loadList();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  function reasonLabel(reason: WasteReason) {
    switch (reason) {
      case 'expired':
        return t('expired');
      case 'spoiled':
        return t('spoiled');
      case 'preparation':
        return t('preparation');
      case 'other':
        return t('other');
      default:
        return reason;
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[40vh] text-muted-foreground">
        {tCommon('loading')}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold">{t('title')}</h1>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <BulkUploadButton
            templateType="waste_logs"
            onUploadComplete={() => {
              void loadStats();
              void loadList();
            }}
          />
          <Button onClick={openDialog}>
            <Plus className="h-4 w-4 me-2" />
            {t('addWaste')}
          </Button>
        </div>
      </div>

      <div className="rounded-xl border border-destructive/25 bg-destructive/5 px-4 py-3 flex flex-wrap items-center gap-3 justify-between">
        <div className="flex items-center gap-2 text-destructive">
          <TrendingDown className="h-5 w-5 shrink-0" />
          <div>
            <p className="font-semibold">{t('costImpact')}</p>
            <p className="text-sm text-muted-foreground">{t('costImpactHint')}</p>
          </div>
        </div>
        <div className="text-end">
          <p className="text-xs text-muted-foreground uppercase tracking-wide">{t('monthCost')}</p>
          <p className="text-2xl font-bold tabular-nums text-destructive">{monthCost.toFixed(2)} QAR</p>
        </div>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('todayCount')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold">{todayCount}</p>
          </CardContent>
        </Card>
        <Card className="border-destructive/20 shadow-sm ring-1 ring-destructive/10">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-destructive">{t('todayCost')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold tabular-nums text-destructive">{todayCost.toFixed(2)} QAR</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('monthCost')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold tabular-nums">{monthCost.toFixed(2)} QAR</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{tCommon('filter')}</CardTitle>
          <div className="flex flex-col gap-3 lg:flex-row lg:flex-wrap lg:items-end">
            <div className="space-y-2 min-w-[160px]">
              <Label>{t('filterReason')}</Label>
              <Select
                value={reasonFilter}
                onValueChange={(v) => setReasonFilter(v ?? 'all')}
              >
                <SelectTrigger className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">{t('allReasons')}</SelectItem>
                  {WASTE_REASONS.map((r) => (
                    <SelectItem key={r} value={r}>
                      {reasonLabel(r)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('fromDate')}</Label>
              <Input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>{t('toDate')}</Label>
              <Input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
            </div>
            <Button
              type="button"
              variant="outline"
              onClick={() => {
                setReasonFilter('all');
                setFromDate('');
                setToDate('');
              }}
            >
              {tCommon('all')}
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{t('item')}</TableHead>
                <TableHead>{tCommon('quantity')}</TableHead>
                <TableHead>{tCommon('unit')}</TableHead>
                <TableHead>{t('reason')}</TableHead>
                <TableHead>{t('wasteDate')}</TableHead>
                <TableHead>{t('loggedBy')}</TableHead>
                <TableHead>{t('wasteCost')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {rows.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                    {t('noWaste')}
                  </TableCell>
                </TableRow>
              ) : (
                rows.map((row) => (
                  <TableRow key={row.id}>
                    <TableCell className="font-medium">
                      {row.inventory_item ? getName(row.inventory_item) : '—'}
                    </TableCell>
                    <TableCell>{Number(row.quantity)}</TableCell>
                    <TableCell>
                      {row.inventory_item
                        ? tInv(`units.${row.inventory_item.unit}`)
                        : '—'}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline" className={cn(reasonBadgeClass(row.reason))}>
                        {reasonLabel(row.reason)}
                      </Badge>
                    </TableCell>
                    <TableCell>{row.waste_date}</TableCell>
                    <TableCell>{row.logger?.full_name ?? '—'}</TableCell>
                    <TableCell className="font-medium tabular-nums">
                      {wasteCost(row).toFixed(2)} QAR
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{t('addWaste')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{tCommon('category')}</Label>
              <Select
                value={itemSearchCategory}
                onValueChange={(v) => setItemSearchCategory(v ?? 'all')}
                items={wasteCategoryFilterItems}
              >
                <SelectTrigger>
                  <SelectValue placeholder={tCommon('category')} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">{tCommon('all')}</SelectItem>
                  {categories.map((c) => (
                    <SelectItem key={c.id} value={c.id} label={getName(c)}>
                      {getName(c)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('item')}</Label>
              <Popover open={itemPopoverOpen} onOpenChange={setItemPopoverOpen}>
                <PopoverTrigger
                  render={
                    <Button
                      type="button"
                      variant="outline"
                      role="combobox"
                      aria-expanded={itemPopoverOpen}
                      className="w-full justify-between font-normal"
                    >
                      <span className="truncate">
                        {selectedItem ? getName(selectedItem) : t('pickItem')}
                      </span>
                      <ChevronsUpDown className="ms-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  }
                />
                <PopoverContent className="w-[min(100vw-2rem,var(--anchor-width))] min-w-[280px] p-0">
                  <Command>
                    <CommandInput placeholder={t('searchItems')} />
                    <CommandList>
                      <CommandEmpty>{tCommon('noResults')}</CommandEmpty>
                      <CommandGroup>
                        {filteredPickerItems.map((it) => (
                          <CommandItem
                            key={it.id}
                            value={`${getName(it)} ${it.name_en}`}
                            onSelect={() => {
                              setForm((f) => ({ ...f, item_id: it.id }));
                              setItemPopoverOpen(false);
                            }}
                          >
                            {getName(it)}
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </CommandList>
                  </Command>
                </PopoverContent>
              </Popover>
            </div>
            <div className="space-y-2">
              <Label>{tCommon('quantity')}</Label>
              <Input
                type="number"
                step="0.001"
                min="0"
                value={form.quantity}
                onChange={(e) => setForm((f) => ({ ...f, quantity: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('reason')}</Label>
              <Select
                value={form.reason}
                onValueChange={(v) => setForm((f) => ({ ...f, reason: (v ?? 'expired') as WasteReason }))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {WASTE_REASONS.map((r) => (
                    <SelectItem key={r} value={r}>
                      {reasonLabel(r)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('wasteDate')}</Label>
              <Input
                type="date"
                value={form.waste_date}
                onChange={(e) => setForm((f) => ({ ...f, waste_date: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>{tCommon('notes')}</Label>
              <Textarea
                value={form.notes}
                onChange={(e) => setForm((f) => ({ ...f, notes: e.target.value }))}
                rows={3}
              />
            </div>
            {selectedItem && form.quantity && parseFloat(form.quantity) > 0 && (
              <div className="rounded-lg border bg-muted/40 p-3 text-sm">
                <span className="text-muted-foreground">{t('wasteCost')}: </span>
                <span className="font-semibold text-destructive tabular-nums">
                  {(parseFloat(form.quantity) * Number(selectedItem.unit_cost)).toFixed(2)} QAR
                </span>
              </div>
            )}
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={handleLogWaste} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
