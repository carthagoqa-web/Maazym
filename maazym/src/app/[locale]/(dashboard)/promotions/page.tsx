'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { MenuItem, Promotion, PromotionItem, PromotionType } from '@/types/database';
import { PromotionsSubnav } from '@/components/promotions/promotions-subnav';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import { Checkbox } from '@/components/ui/checkbox';
import { Skeleton } from '@/components/ui/skeleton';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Plus, Edit, Search } from 'lucide-react';
import { toast } from 'sonner';
import {
  isPromotionActiveBySchedule as isActiveBySchedule,
  isPromotionExpiringThisWeek as isExpiringThisWeek,
  startOfTodayLocal,
} from '@/lib/promotion-schedule';

const PROMO_TYPES: PromotionType[] = [
  'percentage_discount',
  'fixed_discount',
  'combo_deal',
  'buy_x_get_y',
  'happy_hour',
];

const DAY_INDICES = [0, 1, 2, 3, 4, 5, 6] as const;

type PromotionRow = Promotion & {
  items?: (PromotionItem & { menu_item?: MenuItem | null })[];
};

function formatTimeForInput(t: string | null): string {
  if (!t) return '';
  return t.slice(0, 5);
}

const NO_TYPE = '__none__';

const TYPE_MSG_KEYS: Record<PromotionType, string> = {
  percentage_discount: 'percentageDiscount',
  fixed_discount: 'fixedDiscount',
  combo_deal: 'comboDeal',
  buy_x_get_y: 'buyXGetY',
  happy_hour: 'happyHour',
};

export default function PromotionsPage() {
  const t = useTranslations('promotions');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [rows, setRows] = useState<PromotionRow[]>([]);
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [filterMode, setFilterMode] = useState<'all' | 'active'>('all');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editRow, setEditRow] = useState<PromotionRow | null>(null);
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    name_ar: '',
    name_en: '',
    type: '' as PromotionType | '',
    discount_value: '',
    start_date: '',
    end_date: '',
    days_of_week: [...DAY_INDICES] as number[],
    time_start: '',
    time_end: '',
    is_active: true,
    menu_item_ids: [] as string[],
  });

  const loadData = useCallback(async () => {
    const supabase = createClient();
    const [promoRes, menuRes] = await Promise.all([
      supabase
        .from('promotions')
        .select('*, items:promotion_items(id, menu_item_id, menu_item:menu_items(id, name_ar, name_en))')
        .order('created_at', { ascending: false }),
      supabase.from('menu_items').select('*').order('name_en'),
    ]);
    if (promoRes.error) {
      toast.error(promoRes.error.message);
    }
    setRows((promoRes.data as PromotionRow[]) || []);
    setMenuItems((menuRes.data as MenuItem[]) || []);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const today = useMemo(() => startOfTodayLocal(), []);

  const stats = useMemo(() => {
    const total = rows.length;
    const activeNow = rows.filter((r) => isActiveBySchedule(r, today)).length;
    const expiring = rows.filter((r) => isExpiringThisWeek(r, today)).length;
    return { total, activeNow, expiring };
  }, [rows, today]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    let list = rows;
    if (filterMode === 'active') {
      list = list.filter((r) => r.is_active && isActiveBySchedule(r, today));
    }
    if (!q) return list;
    return list.filter(
      (r) =>
        r.name_ar.toLowerCase().includes(q) ||
        r.name_en.toLowerCase().includes(q) ||
        t(TYPE_MSG_KEYS[r.type]).toLowerCase().includes(q)
    );
  }, [rows, search, filterMode, today, t]);

  function typeLabel(type: PromotionType): string {
    return t(TYPE_MSG_KEYS[type]);
  }

  function openNew() {
    setEditRow(null);
    setForm({
      name_ar: '',
      name_en: '',
      type: '',
      discount_value: '',
      start_date: '',
      end_date: '',
      days_of_week: [...DAY_INDICES],
      time_start: '',
      time_end: '',
      is_active: true,
      menu_item_ids: [],
    });
    setDialogOpen(true);
  }

  function openEdit(row: PromotionRow) {
    setEditRow(row);
    const days = row.days_of_week?.length ? [...row.days_of_week] : [...DAY_INDICES];
    const linked = (row.items || []).map((i) => i.menu_item_id).filter(Boolean);
    setForm({
      name_ar: row.name_ar,
      name_en: row.name_en,
      type: row.type,
      discount_value: row.discount_value != null ? String(row.discount_value) : '',
      start_date: row.start_date || '',
      end_date: row.end_date || '',
      days_of_week: days.sort((a, b) => a - b),
      time_start: formatTimeForInput(row.time_start),
      time_end: formatTimeForInput(row.time_end),
      is_active: row.is_active,
      menu_item_ids: linked,
    });
    setDialogOpen(true);
  }

  function toggleDay(day: number) {
    setForm((f) => {
      const has = f.days_of_week.includes(day);
      const next = has ? f.days_of_week.filter((d) => d !== day) : [...f.days_of_week, day].sort((a, b) => a - b);
      return { ...f, days_of_week: next };
    });
  }

  function toggleMenuItem(id: string) {
    setForm((f) => {
      const has = f.menu_item_ids.includes(id);
      const menu_item_ids = has ? f.menu_item_ids.filter((x) => x !== id) : [...f.menu_item_ids, id];
      return { ...f, menu_item_ids };
    });
  }

  async function handleSave() {
    if (!form.type) {
      toast.error(tCommon('required'));
      return;
    }
    if (!form.name_ar.trim() || !form.name_en.trim()) {
      toast.error(tCommon('required'));
      return;
    }
    if (form.days_of_week.length === 0) {
      toast.error(t('daysRequired'));
      return;
    }

    const discount =
      form.discount_value.trim() === '' ? null : parseFloat(form.discount_value);
    if (form.discount_value.trim() !== '' && (discount === null || Number.isNaN(discount))) {
      toast.error(tCommon('error'));
      return;
    }

    setSaving(true);
    try {
      const supabase = createClient();
      const payload = {
        name_ar: form.name_ar.trim(),
        name_en: form.name_en.trim(),
        type: form.type as PromotionType,
        discount_value: discount,
        start_date: form.start_date || null,
        end_date: form.end_date || null,
        days_of_week: form.days_of_week,
        time_start: form.time_start ? `${form.time_start}:00` : null,
        time_end: form.time_end ? `${form.time_end}:00` : null,
        is_active: form.is_active,
      };

      let promoId = editRow?.id;
      if (editRow) {
        const { error } = await supabase.from('promotions').update(payload).eq('id', editRow.id);
        if (error) throw error;
      } else {
        const { data, error } = await supabase.from('promotions').insert(payload).select('id').single();
        if (error) throw error;
        promoId = data?.id;
      }

      if (!promoId) throw new Error('No promotion id');

      await supabase.from('promotion_items').delete().eq('promotion_id', promoId);
      if (form.menu_item_ids.length > 0) {
        const { error: piErr } = await supabase.from('promotion_items').insert(
          form.menu_item_ids.map((menu_item_id) => ({ promotion_id: promoId, menu_item_id }))
        );
        if (piErr) throw piErr;
      }

      toast.success(editRow ? tCommon('updated') : tCommon('created'));
      setDialogOpen(false);
      loadData();
    } catch (e: unknown) {
      toast.error(e instanceof Error ? e.message : tCommon('error'));
    } finally {
      setSaving(false);
    }
  }

  async function togglePromotionActive(row: PromotionRow, next: boolean) {
    const prev = row.is_active;
    setRows((list) => list.map((r) => (r.id === row.id ? { ...r, is_active: next } : r)));
    const supabase = createClient();
    const { error } = await supabase.from('promotions').update({ is_active: next }).eq('id', row.id);
    if (error) {
      setRows((list) => list.map((r) => (r.id === row.id ? { ...r, is_active: prev } : r)));
      toast.error(error.message);
      return;
    }
    toast.success(tCommon('updated'));
  }

  const dialogTypeValue = form.type || NO_TYPE;

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-10 w-full max-w-xl" />
        <div className="grid gap-4 sm:grid-cols-3">
          {[...Array(3)].map((_, i) => (
            <Skeleton key={i} className="h-24" />
          ))}
        </div>
        <Skeleton className="h-96" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PromotionsSubnav />

      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">{t('title')}</h1>
        <Button onClick={openNew}>
          <Plus className="h-4 w-4 me-2" />
          {t('addPromotion')}
        </Button>
      </div>

      <div className="flex flex-wrap gap-2">
        <Button
          type="button"
          variant={filterMode === 'all' ? 'default' : 'outline'}
          size="sm"
          onClick={() => setFilterMode('all')}
        >
          {t('showAll')}
        </Button>
        <Button
          type="button"
          variant={filterMode === 'active' ? 'default' : 'outline'}
          size="sm"
          onClick={() => setFilterMode('active')}
        >
          {t('showActiveOnly')}
        </Button>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              {t('statsTotalPromotions')}
            </CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold">{stats.total}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsActiveNow')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold text-green-600 dark:text-green-500">
            {stats.activeNow}
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              {t('statsExpiringThisWeek')}
            </CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold text-amber-600 dark:text-amber-500">
            {stats.expiring}
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
                <TableHead>{t('nameBilingual')}</TableHead>
                <TableHead>{t('promotionType')}</TableHead>
                <TableHead>{t('discountValue')}</TableHead>
                <TableHead>{t('startDate')}</TableHead>
                <TableHead>{t('endDate')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
                <TableHead>{tCommon('actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="py-8 text-center text-muted-foreground">
                    {t('noPromotions')}
                  </TableCell>
                </TableRow>
              ) : (
                filtered.map((row) => (
                  <TableRow key={row.id}>
                    <TableCell>
                      <div className="font-medium">{getName(row)}</div>
                      <div className="text-xs text-muted-foreground">
                        {locale === 'ar' ? row.name_en : row.name_ar}
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary">{typeLabel(row.type)}</Badge>
                    </TableCell>
                    <TableCell>
                      {row.discount_value != null ? Number(row.discount_value).toFixed(2) : '—'}
                    </TableCell>
                    <TableCell>{row.start_date || '—'}</TableCell>
                    <TableCell>{row.end_date || '—'}</TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <Switch
                          checked={row.is_active}
                          onCheckedChange={(v) => togglePromotionActive(row, Boolean(v))}
                        />
                        <span className="text-sm text-muted-foreground">
                          {row.is_active ? tCommon('active') : tCommon('inactive')}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon" onClick={() => openEdit(row)}>
                        <Edit className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-lg max-h-[90vh] flex flex-col" showCloseButton>
          <DialogHeader>
            <DialogTitle>{editRow ? t('editPromotion') : t('addPromotion')}</DialogTitle>
          </DialogHeader>
          <ScrollArea className="flex-1 max-h-[60vh] pe-2">
            <div className="space-y-4 pe-2">
              <div className="space-y-2">
                <Label>{t('nameAr')}</Label>
                <Input
                  dir="rtl"
                  value={form.name_ar}
                  onChange={(e) => setForm({ ...form, name_ar: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label>{t('nameEn')}</Label>
                <Input
                  dir="ltr"
                  value={form.name_en}
                  onChange={(e) => setForm({ ...form, name_en: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label>{t('promotionType')}</Label>
                <Select
                  value={dialogTypeValue}
                  onValueChange={(v) => {
                    const raw = v ?? NO_TYPE;
                    setForm((f) => ({
                      ...f,
                      type: raw === NO_TYPE ? '' : (raw as PromotionType),
                    }));
                  }}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={tCommon('required')} />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value={NO_TYPE}>{t('selectType')}</SelectItem>
                    {PROMO_TYPES.map((pt) => (
                      <SelectItem key={pt} value={pt}>
                        {typeLabel(pt)}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>{t('discountValue')}</Label>
                <Input
                  type="number"
                  step="0.01"
                  value={form.discount_value}
                  onChange={(e) => setForm({ ...form, discount_value: e.target.value })}
                  placeholder={t('optionalDiscount')}
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-2">
                  <Label>{t('startDate')}</Label>
                  <Input
                    type="date"
                    value={form.start_date}
                    onChange={(e) => setForm({ ...form, start_date: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label>{t('endDate')}</Label>
                  <Input
                    type="date"
                    value={form.end_date}
                    onChange={(e) => setForm({ ...form, end_date: e.target.value })}
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label>{t('daysOfWeek')}</Label>
                <div className="flex flex-wrap gap-3">
                  {DAY_INDICES.map((d) => (
                    <label key={d} className="flex items-center gap-2 text-sm">
                      <Checkbox
                        checked={form.days_of_week.includes(d)}
                        onCheckedChange={() => toggleDay(d)}
                      />
                      {t(`day_${d}`)}
                    </label>
                  ))}
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-2">
                  <Label>{t('timeStart')}</Label>
                  <Input
                    type="time"
                    value={form.time_start}
                    onChange={(e) => setForm({ ...form, time_start: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label>{t('timeEnd')}</Label>
                  <Input
                    type="time"
                    value={form.time_end}
                    onChange={(e) => setForm({ ...form, time_end: e.target.value })}
                  />
                </div>
              </div>
              <div className="flex items-center gap-2">
                <Switch
                  checked={form.is_active}
                  onCheckedChange={(v) => setForm((f) => ({ ...f, is_active: Boolean(v) }))}
                />
                <Label className="font-normal">{tCommon('active')}</Label>
              </div>
              <div className="space-y-2 border-t pt-4">
                <Label>{t('linkMenuItems')}</Label>
                <p className="text-xs text-muted-foreground">{t('linkMenuItemsHint')}</p>
                <div className="max-h-40 space-y-2 overflow-y-auto rounded-md border p-2">
                  {menuItems.length === 0 ? (
                    <p className="text-sm text-muted-foreground">{t('noMenuItems')}</p>
                  ) : (
                    menuItems.map((m) => (
                      <label key={m.id} className="flex items-center gap-2 text-sm">
                        <Checkbox
                          checked={form.menu_item_ids.includes(m.id)}
                          onCheckedChange={() => toggleMenuItem(m.id)}
                        />
                        {getName(m)}
                      </label>
                    ))
                  )}
                </div>
              </div>
            </div>
          </ScrollArea>
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
