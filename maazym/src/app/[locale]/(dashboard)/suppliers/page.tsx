'use client';

import { useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { useUser } from '@/hooks/use-user';
import { canAccessSuppliers } from '@/lib/roles';
import type { InventoryItem, Supplier, SupplierItem } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Checkbox } from '@/components/ui/checkbox';
import { Skeleton } from '@/components/ui/skeleton';
import { Plus, Search, Edit, Trash2, Link2 } from 'lucide-react';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';
import { BulkUploadButton } from '@/components/bulk-upload-button';

const NO_ITEM = '__none__';

type SupplierItemRow = SupplierItem & { inventory_item?: InventoryItem | null };

export default function SuppliersPage() {
  const t = useTranslations('suppliers');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const router = useRouter();
  const { profile, loading: userLoading } = useUser();
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [itemCountBySupplier, setItemCountBySupplier] = useState<Map<string, number>>(new Map());
  const [inventoryItems, setInventoryItems] = useState<InventoryItem[]>([]);
  const [supplierItems, setSupplierItems] = useState<SupplierItemRow[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [itemsLoading, setItemsLoading] = useState(false);
  const [search, setSearch] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editSupplier, setEditSupplier] = useState<Supplier | null>(null);
  const [saving, setSaving] = useState(false);
  const [linkSaving, setLinkSaving] = useState(false);

  useEffect(() => {
    if (userLoading) return;
    if (!canAccessSuppliers(profile?.role)) {
      router.replace(`/${locale}`);
    }
  }, [userLoading, profile?.role, locale, router]);

  const [form, setForm] = useState({
    name: '',
    contact_person: '',
    phone: '',
    email: '',
    address: '',
    is_halal_certified: false,
    is_active: true,
  });

  const [linkForm, setLinkForm] = useState({
    inventory_item_id: '',
    supplier_price: '',
    lead_time_days: '',
  });

  useEffect(() => {
    loadSuppliers();
  }, []);

  useEffect(() => {
    if (!selectedId) {
      setSupplierItems([]);
      return;
    }
    loadSupplierItems(selectedId);
  }, [selectedId]);

  async function loadSuppliers() {
    const supabase = createClient();
    const [supRes, siRes, invRes] = await Promise.all([
      supabase.from('suppliers').select('*').order('name'),
      supabase.from('supplier_items').select('supplier_id'),
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
    ]);

    const counts = new Map<string, number>();
    (siRes.data as { supplier_id: string }[] | null)?.forEach((row) => {
      counts.set(row.supplier_id, (counts.get(row.supplier_id) ?? 0) + 1);
    });
    setItemCountBySupplier(counts);
    setSuppliers((supRes.data as Supplier[]) || []);
    setInventoryItems((invRes.data as InventoryItem[]) || []);
    setLoading(false);

    setSelectedId((prev) => {
      const list = (supRes.data as Supplier[]) || [];
      if (prev && list.some((s) => s.id === prev)) return prev;
      return list[0]?.id ?? null;
    });
  }

  async function loadSupplierItems(supplierId: string) {
    setItemsLoading(true);
    const supabase = createClient();
    const { data, error } = await supabase
      .from('supplier_items')
      .select('*, inventory_item:inventory_items(*)')
      .eq('supplier_id', supplierId)
      .order('created_at', { ascending: true });
    setItemsLoading(false);
    if (error) {
      toast.error(error.message || tCommon('error'));
      setSupplierItems([]);
      return;
    }
    setSupplierItems((data as SupplierItemRow[]) || []);
  }

  const getInvName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const filteredSuppliers = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return suppliers;
    return suppliers.filter(
      (s) =>
        s.name.toLowerCase().includes(q) ||
        (s.contact_person?.toLowerCase().includes(q) ?? false) ||
        (s.phone?.toLowerCase().includes(q) ?? false) ||
        (s.email?.toLowerCase().includes(q) ?? false)
    );
  }, [suppliers, search]);

  const stats = useMemo(() => {
    const total = suppliers.length;
    const halal = suppliers.filter((s) => s.is_halal_certified).length;
    const active = suppliers.filter((s) => s.is_active).length;
    return { total, halal, active };
  }, [suppliers]);

  const selectedSupplier = suppliers.find((s) => s.id === selectedId) ?? null;

  const linkedInventoryIds = new Set(supplierItems.map((si) => si.inventory_item_id));
  const linkableInventory = inventoryItems.filter((i) => !linkedInventoryIds.has(i.id));

  const supplierLinkSelectItems = useMemo(() => {
    const linkedIds = new Set(supplierItems.map((si) => si.inventory_item_id));
    const linkable = inventoryItems.filter((i) => !linkedIds.has(i.id));
    return [
      { value: NO_ITEM, label: tCommon('optional') },
      ...linkable.map((inv) => ({ value: inv.id, label: getInvName(inv) })),
    ];
  }, [inventoryItems, supplierItems, locale, tCommon]);

  function openNew() {
    setEditSupplier(null);
    setForm({
      name: '',
      contact_person: '',
      phone: '',
      email: '',
      address: '',
      is_halal_certified: false,
      is_active: true,
    });
    setDialogOpen(true);
  }

  function openEdit(s: Supplier) {
    setEditSupplier(s);
    setForm({
      name: s.name,
      contact_person: s.contact_person ?? '',
      phone: s.phone ?? '',
      email: s.email ?? '',
      address: s.address ?? '',
      is_halal_certified: s.is_halal_certified,
      is_active: s.is_active,
    });
    setDialogOpen(true);
  }

  async function handleSaveSupplier() {
    setSaving(true);
    try {
      const supabase = createClient();
      const payload = {
        name: form.name.trim(),
        contact_person: form.contact_person.trim() || null,
        phone: form.phone.trim() || null,
        email: form.email.trim() || null,
        address: form.address.trim() || null,
        is_halal_certified: form.is_halal_certified,
        is_active: form.is_active,
      };
      if (!payload.name) {
        toast.error(tCommon('required'));
        setSaving(false);
        return;
      }

      if (editSupplier) {
        const { error } = await supabase.from('suppliers').update(payload).eq('id', editSupplier.id);
        if (error) throw error;
        toast.success(tCommon('updated'));
      } else {
        const { error } = await supabase.from('suppliers').insert(payload);
        if (error) throw error;
        toast.success(tCommon('created'));
      }

      setDialogOpen(false);
      await loadSuppliers();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  async function handleLinkItem() {
    if (!selectedId) {
      toast.error(t('noSupplierSelected'));
      return;
    }
    if (!linkForm.inventory_item_id) {
      toast.error(tCommon('required'));
      return;
    }
    setLinkSaving(true);
    try {
      const supabase = createClient();
      const price =
        linkForm.supplier_price.trim() === '' ? null : parseFloat(linkForm.supplier_price);
      const lead =
        linkForm.lead_time_days.trim() === '' ? null : parseInt(linkForm.lead_time_days, 10);
      if (price !== null && (Number.isNaN(price) || price < 0)) {
        toast.error(tCommon('error'));
        setLinkSaving(false);
        return;
      }
      if (lead !== null && (Number.isNaN(lead) || lead < 0)) {
        toast.error(tCommon('error'));
        setLinkSaving(false);
        return;
      }

      const { error } = await supabase.from('supplier_items').insert({
        supplier_id: selectedId,
        inventory_item_id: linkForm.inventory_item_id,
        supplier_price: price,
        lead_time_days: lead,
      });
      if (error) throw error;
      toast.success(tCommon('created'));
      setLinkForm({ inventory_item_id: '', supplier_price: '', lead_time_days: '' });
      await loadSuppliers();
      await loadSupplierItems(selectedId);
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setLinkSaving(false);
    }
  }

  async function handleUnlink(row: SupplierItemRow) {
    const supabase = createClient();
    const { error } = await supabase.from('supplier_items').delete().eq('id', row.id);
    if (error) {
      toast.error(error.message || tCommon('error'));
      return;
    }
    toast.success(tCommon('deleted'));
    await loadSuppliers();
    if (selectedId) await loadSupplierItems(selectedId);
  }

  const linkSelectValue = linkForm.inventory_item_id || NO_ITEM;

  if (userLoading || !canAccessSuppliers(profile?.role)) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="h-96" />
      </div>
    );
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
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
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl font-bold">{t('title')}</h1>
        <div className="flex flex-wrap items-center gap-2">
          <BulkUploadButton templateType="suppliers" onUploadComplete={loadSuppliers} />
          <Button onClick={openNew}>
            <Plus className="h-4 w-4 me-2" />
            {t('addSupplier')}
          </Button>
        </div>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsTotal')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold">{stats.total}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsHalal')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold text-green-600">{stats.halal}</CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('statsActive')}</CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-bold">{stats.active}</CardContent>
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
                <TableHead>{t('contactPerson')}</TableHead>
                <TableHead>{t('phone')}</TableHead>
                <TableHead>{t('email')}</TableHead>
                <TableHead>{t('halalCertified')}</TableHead>
                <TableHead>{t('itemsCount')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
                <TableHead>{tCommon('actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredSuppliers.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={8} className="py-8 text-center text-muted-foreground">
                    {t('noSuppliers')}
                  </TableCell>
                </TableRow>
              ) : (
                filteredSuppliers.map((s) => (
                  <TableRow
                    key={s.id}
                    className={cn(
                      'cursor-pointer',
                      selectedId === s.id && 'bg-muted/60'
                    )}
                    onClick={() => setSelectedId(s.id)}
                  >
                    <TableCell className="font-medium">{s.name}</TableCell>
                    <TableCell>{s.contact_person ?? '—'}</TableCell>
                    <TableCell>{s.phone ?? '—'}</TableCell>
                    <TableCell>{s.email ?? '—'}</TableCell>
                    <TableCell>
                      {s.is_halal_certified ? (
                        <Badge className="bg-green-600 hover:bg-green-600">{t('halalCertified')}</Badge>
                      ) : (
                        <span className="text-muted-foreground text-sm">—</span>
                      )}
                    </TableCell>
                    <TableCell>{itemCountBySupplier.get(s.id) ?? 0}</TableCell>
                    <TableCell>
                      <Badge variant={s.is_active ? 'default' : 'secondary'}>
                        {s.is_active ? tCommon('active') : tCommon('inactive')}
                      </Badge>
                    </TableCell>
                    <TableCell onClick={(e) => e.stopPropagation()}>
                      <Button variant="ghost" size="icon" onClick={() => openEdit(s)}>
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

      <Card>
        <CardHeader>
          <CardTitle className="text-lg">
            {t('suppliedItems')}
            {selectedSupplier ? (
              <span className="text-muted-foreground font-normal"> — {selectedSupplier.name}</span>
            ) : null}
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          {!selectedId ? (
            <p className="text-sm text-muted-foreground">{t('noSupplierSelected')}</p>
          ) : (
            <>
              <div className="flex flex-col gap-4 rounded-lg border p-4 md:flex-row md:items-end">
                <div className="flex-1 space-y-2">
                  <Label>{t('selectInventoryItem')}</Label>
                  <Select
                    value={linkSelectValue}
                    onValueChange={(v) => {
                      const raw = v ?? NO_ITEM;
                      setLinkForm((f) => ({
                        ...f,
                        inventory_item_id: raw === NO_ITEM ? '' : raw,
                      }));
                    }}
                    items={supplierLinkSelectItems}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder={tCommon('optional')} />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value={NO_ITEM}>{tCommon('optional')}</SelectItem>
                      {linkableInventory.map((inv) => (
                        <SelectItem key={inv.id} value={inv.id} label={getInvName(inv)}>
                          {getInvName(inv)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="w-full space-y-2 md:w-40">
                  <Label>{t('supplierPrice')} (QAR)</Label>
                  <Input
                    type="number"
                    step="0.01"
                    min={0}
                    value={linkForm.supplier_price}
                    onChange={(e) => setLinkForm((f) => ({ ...f, supplier_price: e.target.value }))}
                  />
                </div>
                <div className="w-full space-y-2 md:w-40">
                  <Label>{t('leadTimeDays')}</Label>
                  <Input
                    type="number"
                    min={0}
                    value={linkForm.lead_time_days}
                    onChange={(e) => setLinkForm((f) => ({ ...f, lead_time_days: e.target.value }))}
                  />
                </div>
                <Button onClick={handleLinkItem} disabled={linkSaving || !linkForm.inventory_item_id}>
                  <Link2 className="h-4 w-4 me-2" />
                  {t('linkItem')}
                </Button>
              </div>

              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>{tCommon('name')}</TableHead>
                      <TableHead>{t('supplierPrice')}</TableHead>
                      <TableHead>{t('leadTimeDays')}</TableHead>
                      <TableHead>{tCommon('actions')}</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {itemsLoading ? (
                      <TableRow>
                        <TableCell colSpan={4} className="py-8 text-center text-muted-foreground">
                          {tCommon('loading')}
                        </TableCell>
                      </TableRow>
                    ) : supplierItems.length === 0 ? (
                      <TableRow>
                        <TableCell colSpan={4} className="py-8 text-center text-muted-foreground">
                          {t('noLinkedItems')}
                        </TableCell>
                      </TableRow>
                    ) : (
                      supplierItems.map((si) => (
                        <TableRow key={si.id}>
                          <TableCell className="font-medium">
                            {si.inventory_item ? getInvName(si.inventory_item) : '—'}
                          </TableCell>
                          <TableCell>
                            {si.supplier_price !== null && si.supplier_price !== undefined
                              ? `${Number(si.supplier_price).toFixed(2)} QAR`
                              : '—'}
                          </TableCell>
                          <TableCell>
                            {si.lead_time_days !== null && si.lead_time_days !== undefined
                              ? si.lead_time_days
                              : '—'}
                          </TableCell>
                          <TableCell>
                            <Button
                              variant="ghost"
                              size="icon"
                              className="text-destructive"
                              onClick={() => handleUnlink(si)}
                            >
                              <Trash2 className="h-4 w-4" />
                              <span className="sr-only">{t('unlink')}</span>
                            </Button>
                          </TableCell>
                        </TableRow>
                      ))
                    )}
                  </TableBody>
                </Table>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-lg" showCloseButton>
          <DialogHeader>
            <DialogTitle>{editSupplier ? t('editSupplier') : t('addSupplier')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('supplierName')}</Label>
              <Input
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('contactPerson')}</Label>
              <Input
                value={form.contact_person}
                onChange={(e) => setForm({ ...form, contact_person: e.target.value })}
              />
            </div>
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <Label>{t('phone')}</Label>
                <Input
                  value={form.phone}
                  onChange={(e) => setForm({ ...form, phone: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label>{t('email')}</Label>
                <Input
                  type="email"
                  value={form.email}
                  onChange={(e) => setForm({ ...form, email: e.target.value })}
                />
              </div>
            </div>
            <div className="space-y-2">
              <Label>{t('address')}</Label>
              <Input
                value={form.address}
                onChange={(e) => setForm({ ...form, address: e.target.value })}
              />
            </div>
            <div className="flex items-center gap-2">
              <Checkbox
                checked={form.is_halal_certified}
                onCheckedChange={(v) =>
                  setForm((f) => ({ ...f, is_halal_certified: Boolean(v) }))
                }
              />
              <Label className="font-normal">{t('halalCertified')}</Label>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox
                checked={form.is_active}
                onCheckedChange={(v) => setForm((f) => ({ ...f, is_active: Boolean(v) }))}
              />
              <Label className="font-normal">{t('isActive')}</Label>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={handleSaveSupplier} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
