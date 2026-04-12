'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type {
  InventoryItem,
  POStatus,
  PurchaseOrder,
  PurchaseOrderItem,
  Supplier,
} from '@/types/database';
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
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Plus, Trash2, Eye, Package, Send, ClipboardList } from 'lucide-react';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';
import { BulkUploadButton } from '@/components/bulk-upload-button';
import { useUser } from '@/hooks/use-user';
import { canViewFinancials, canReceivePurchaseOrder } from '@/lib/roles';

type LineForm = {
  inventory_item_id: string;
  quantity: string;
  unit_price: string;
};

type POWithRelations = PurchaseOrder & {
  supplier?: Supplier | null;
  items?: (PurchaseOrderItem & { inventory_item?: InventoryItem | null })[];
};

function shortId(id: string) {
  return id.replace(/-/g, '').slice(0, 8).toUpperCase();
}

function statusBadgeClass(status: POStatus) {
  switch (status) {
    case 'draft':
      return 'bg-secondary text-secondary-foreground border-transparent';
    case 'submitted':
      return 'border-blue-500/40 bg-blue-500/10 text-blue-700 dark:text-blue-300';
    case 'received':
      return 'border-emerald-500/40 bg-emerald-500/10 text-emerald-700 dark:text-emerald-300';
    case 'cancelled':
      return '';
    default:
      return '';
  }
}

export default function PurchaseOrdersPage() {
  const t = useTranslations('purchaseOrders');
  const tInv = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const { profile, loading: userLoading } = useUser();
  const showFinancials = canViewFinancials(profile?.role);
  const showReceive = canReceivePurchaseOrder(profile?.role);

  const [orders, setOrders] = useState<POWithRelations[]>([]);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [inventoryItems, setInventoryItems] = useState<InventoryItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusTab, setStatusTab] = useState<string>('all');

  const [addOpen, setAddOpen] = useState(false);
  const [detailOpen, setDetailOpen] = useState(false);
  const [detailPo, setDetailPo] = useState<POWithRelations | null>(null);
  const [saving, setSaving] = useState(false);
  const [receiving, setReceiving] = useState(false);

  const [addForm, setAddForm] = useState({
    supplier_id: '',
    order_date: new Date().toISOString().split('T')[0],
    expected_delivery: '',
    lines: [{ inventory_item_id: '', quantity: '1', unit_price: '' }] as LineForm[],
  });

  const [editForm, setEditForm] = useState({
    supplier_id: '',
    order_date: '',
    expected_delivery: '',
    lines: [] as LineForm[],
  });

  const getItemName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const poInventorySelectItems = useMemo(
    () => inventoryItems.map((it) => ({ value: it.id, label: getItemName(it) })),
    [inventoryItems, locale]
  );

  const supplierSelectItems = useMemo(
    () => suppliers.map((s) => ({ value: s.id, label: s.name })),
    [suppliers]
  );

  const loadData = useCallback(async () => {
    const supabase = createClient();
    const [poRes, supRes, invRes] = await Promise.all([
      supabase
        .from('purchase_orders')
        .select(
          '*, supplier:suppliers(*), items:purchase_order_items(*, inventory_item:inventory_items(*))'
        )
        .order('order_date', { ascending: false }),
      supabase.from('suppliers').select('*').eq('is_active', true).order('name'),
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
    ]);
    setOrders((poRes.data as POWithRelations[]) || []);
    setSuppliers(supRes.data || []);
    setInventoryItems(invRes.data || []);
    setLoading(false);
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const monthBounds = useMemo(() => {
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), 1);
    const end = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    return {
      startStr: start.toISOString().split('T')[0],
      endStr: end.toISOString().split('T')[0],
    };
  }, []);

  const stats = useMemo(() => {
    const total = orders.length;
    const pending = orders.filter((o) => o.status === 'draft' || o.status === 'submitted').length;
    const monthSpending = orders
      .filter(
        (o) =>
          o.order_date >= monthBounds.startStr &&
          o.order_date <= monthBounds.endStr &&
          (o.status === 'received' || o.status === 'submitted')
      )
      .reduce((s, o) => s + Number(o.total_amount), 0);
    return { total, pending, monthSpending };
  }, [orders, monthBounds]);

  const filteredOrders = useMemo(() => {
    if (statusTab === 'all') return orders;
    return orders.filter((o) => o.status === statusTab);
  }, [orders, statusTab]);

  function lineTotal(l: LineForm) {
    const q = parseFloat(l.quantity) || 0;
    const p = parseFloat(l.unit_price) || 0;
    return q * p;
  }

  function sumLines(lines: LineForm[]) {
    return lines.reduce((s, l) => s + lineTotal(l), 0);
  }

  function defaultUnitPriceForItem(itemId: string): number {
    const it = inventoryItems.find((i) => i.id === itemId);
    return it ? Number(it.unit_cost) || 0 : 0;
  }

  /** When staff cannot see prices, persist uses current inventory unit cost per line. */
  function resolveLinesForSave(lines: LineForm[]): LineForm[] {
    if (showFinancials) return lines;
    return lines.map((l) => ({
      ...l,
      unit_price: String(defaultUnitPriceForItem(l.inventory_item_id)),
    }));
  }

  async function getUserContext() {
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user?.id) return { userId: null as string | null, branchId: null as string | null };
    const { data: profile } = await supabase
      .from('profiles')
      .select('branch_id')
      .eq('id', user.id)
      .maybeSingle();
    return { userId: user.id, branchId: profile?.branch_id ?? null };
  }

  function resetAddForm() {
    setAddForm({
      supplier_id: '',
      order_date: new Date().toISOString().split('T')[0],
      expected_delivery: '',
      lines: [{ inventory_item_id: '', quantity: '1', unit_price: '' }],
    });
  }

  function openAdd() {
    resetAddForm();
    setAddOpen(true);
  }

  function openDetail(po: POWithRelations) {
    setDetailPo(po);
    setEditForm({
      supplier_id: po.supplier_id,
      order_date: po.order_date,
      expected_delivery: po.expected_delivery || '',
      lines:
        po.items?.map((it) => ({
          inventory_item_id: it.inventory_item_id,
          quantity: String(it.quantity),
          unit_price: String(it.unit_price),
        })) || [],
    });
    setDetailOpen(true);
  }

  async function refreshPo(id: string) {
    const supabase = createClient();
    const { data } = await supabase
      .from('purchase_orders')
      .select(
        '*, supplier:suppliers(*), items:purchase_order_items(*, inventory_item:inventory_items(*))'
      )
      .eq('id', id)
      .single();
    if (data) {
      const po = data as POWithRelations;
      setDetailPo(po);
      setOrders((prev) => prev.map((o) => (o.id === po.id ? po : o)));
    }
  }

  async function persistPoLines(
    poId: string,
    lines: LineForm[],
    total: number,
    extra: Partial<PurchaseOrder> = {}
  ) {
    const supabase = createClient();
    const { error: delErr } = await supabase.from('purchase_order_items').delete().eq('po_id', poId);
    if (delErr) throw delErr;

    const resolved = resolveLinesForSave(lines);
    const valid = resolved.filter(
      (l) => l.inventory_item_id && parseFloat(l.quantity) > 0 && parseFloat(l.unit_price) >= 0
    );
    if (valid.length === 0) throw new Error(t('atLeastOneLine'));

    const { error: insErr } = await supabase.from('purchase_order_items').insert(
      valid.map((l) => ({
        po_id: poId,
        inventory_item_id: l.inventory_item_id,
        quantity: parseFloat(l.quantity),
        unit_price: parseFloat(l.unit_price),
      }))
    );
    if (insErr) throw insErr;

    const { error: upErr } = await supabase
      .from('purchase_orders')
      .update({ total_amount: total, ...extra })
      .eq('id', poId);
    if (upErr) throw upErr;
  }

  async function handleCreatePo() {
    if (!addForm.supplier_id) {
      toast.error(t('selectSupplier'));
      return;
    }
    const lines = addForm.lines;
    const valid = lines.filter((l) => {
      if (!l.inventory_item_id || parseFloat(l.quantity) <= 0) return false;
      if (showFinancials) return parseFloat(l.unit_price) >= 0;
      return true;
    });
    if (valid.length === 0) {
      toast.error(t('atLeastOneLine'));
      return;
    }

    setSaving(true);
    try {
      const supabase = createClient();
      const { userId, branchId } = await getUserContext();
      const toSave = resolveLinesForSave(valid);
      const total = sumLines(toSave);

      const { data: inserted, error: poErr } = await supabase
        .from('purchase_orders')
        .insert({
          supplier_id: addForm.supplier_id,
          order_date: addForm.order_date,
          expected_delivery: addForm.expected_delivery || null,
          total_amount: total,
          status: 'draft',
          created_by: userId,
          branch_id: branchId,
        })
        .select('id')
        .single();
      if (poErr) throw poErr;
      if (!inserted?.id) throw new Error('No PO id');

      const { error: lineErr } = await supabase.from('purchase_order_items').insert(
        toSave.map((l) => ({
          po_id: inserted.id,
          inventory_item_id: l.inventory_item_id,
          quantity: parseFloat(l.quantity),
          unit_price: parseFloat(l.unit_price),
        }))
      );
      if (lineErr) throw lineErr;

      toast.success(tCommon('created'));
      setAddOpen(false);
      resetAddForm();
      loadData();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  async function handleSaveDraft() {
    if (!detailPo || detailPo.status !== 'draft') return;
    setSaving(true);
    try {
      const supabase = createClient();
      const total = sumLines(resolveLinesForSave(editForm.lines));
      await supabase
        .from('purchase_orders')
        .update({
          supplier_id: editForm.supplier_id,
          order_date: editForm.order_date,
          expected_delivery: editForm.expected_delivery || null,
        })
        .eq('id', detailPo.id);

      await persistPoLines(detailPo.id, editForm.lines, total);
      toast.success(tCommon('updated'));
      await refreshPo(detailPo.id);
      loadData();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  async function handleSubmitOrder() {
    if (!detailPo || detailPo.status !== 'draft') return;
    setSaving(true);
    try {
      const supabase = createClient();
      const total = sumLines(resolveLinesForSave(editForm.lines));
      await supabase
        .from('purchase_orders')
        .update({
          supplier_id: editForm.supplier_id,
          order_date: editForm.order_date,
          expected_delivery: editForm.expected_delivery || null,
        })
        .eq('id', detailPo.id);
      await persistPoLines(detailPo.id, editForm.lines, total, { status: 'submitted' });
      toast.success(t('submitSuccess'));
      await refreshPo(detailPo.id);
      loadData();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setSaving(false);
    }
  }

  async function handleReceiveOrder() {
    if (!detailPo || detailPo.status !== 'submitted') return;
    const items = detailPo.items || [];
    if (items.length === 0) {
      toast.error(t('atLeastOneLine'));
      return;
    }

    setReceiving(true);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      const { data: profile } = await supabase
        .from('profiles')
        .select('branch_id')
        .eq('id', user?.id || '')
        .maybeSingle();
      const branchId = profile?.branch_id ?? null;

      for (const line of items) {
        const qty = Number(line.quantity);
        const { error: txErr } = await supabase.from('stock_transactions').insert({
          item_id: line.inventory_item_id,
          transaction_type: 'received',
          quantity: qty,
          notes: `PO #${shortId(detailPo.id)} receipt`,
          created_by: user?.id ?? null,
          branch_id: branchId,
        });
        if (txErr) throw txErr;

        const { data: sl, error: slErr } = await supabase
          .from('stock_levels')
          .select('id, current_quantity')
          .eq('item_id', line.inventory_item_id)
          .maybeSingle();
        if (slErr) throw slErr;
        if (sl) {
          const next = Number(sl.current_quantity) + qty;
          const { error: upSl } = await supabase
            .from('stock_levels')
            .update({ current_quantity: next, last_updated: new Date().toISOString() })
            .eq('id', sl.id);
          if (upSl) throw upSl;
        }

        const { error: upLine } = await supabase
          .from('purchase_order_items')
          .update({ received_quantity: qty })
          .eq('id', line.id);
        if (upLine) throw upLine;
      }

      const { error: upPo } = await supabase
        .from('purchase_orders')
        .update({ status: 'received' })
        .eq('id', detailPo.id);
      if (upPo) throw upPo;

      toast.success(t('receiveSuccess'));
      await refreshPo(detailPo.id);
      loadData();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : tCommon('error');
      toast.error(msg);
    } finally {
      setReceiving(false);
    }
  }

  function statusLabel(status: POStatus) {
    switch (status) {
      case 'draft':
        return t('statusDraft');
      case 'submitted':
        return t('statusSubmitted');
      case 'received':
        return t('statusReceived');
      case 'cancelled':
        return t('statusCancelled');
      default:
        return status;
    }
  }

  function renderStatusBadge(status: POStatus) {
    return (
      <Badge
        variant={status === 'cancelled' ? 'destructive' : 'outline'}
        className={cn(status !== 'cancelled' && statusBadgeClass(status))}
      >
        {statusLabel(status)}
      </Badge>
    );
  }

  function addLineRow(target: 'add' | 'edit') {
    if (target === 'add') {
      setAddForm((f) => ({
        ...f,
        lines: [...f.lines, { inventory_item_id: '', quantity: '1', unit_price: '' }],
      }));
    } else {
      setEditForm((f) => ({
        ...f,
        lines: [...f.lines, { inventory_item_id: '', quantity: '1', unit_price: '' }],
      }));
    }
  }

  function removeLineRow(target: 'add' | 'edit', index: number) {
    if (target === 'add') {
      setAddForm((f) => ({
        ...f,
        lines: f.lines.length > 1 ? f.lines.filter((_, i) => i !== index) : f.lines,
      }));
    } else {
      setEditForm((f) => ({
        ...f,
        lines: f.lines.length > 1 ? f.lines.filter((_, i) => i !== index) : f.lines,
      }));
    }
  }

  function updateLine(target: 'add' | 'edit', index: number, patch: Partial<LineForm>) {
    if (target === 'add') {
      setAddForm((f) => {
        const lines = [...f.lines];
        lines[index] = { ...lines[index], ...patch };
        return { ...f, lines };
      });
    } else {
      setEditForm((f) => {
        const lines = [...f.lines];
        lines[index] = { ...lines[index], ...patch };
        return { ...f, lines };
      });
    }
  }

  function renderLineEditor(target: 'add' | 'edit', lines: LineForm[], readOnly: boolean) {
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <Label>{t('items')}</Label>
          {!readOnly && (
            <Button type="button" variant="outline" size="sm" onClick={() => addLineRow(target)}>
              <Plus className="h-4 w-4 me-1" />
              {t('addLine')}
            </Button>
          )}
        </div>
        <div className="rounded-lg border divide-y">
          {lines.map((line, index) => (
            <div key={index} className="p-3 space-y-2">
              <div className="grid gap-2 sm:grid-cols-12 sm:items-end">
                <div className="sm:col-span-5 space-y-1">
                  <Label className="text-xs text-muted-foreground">{tInv('items')}</Label>
                  {readOnly ? (
                    <p className="text-sm font-medium py-2">
                      {(() => {
                        const poLine = detailPo?.items?.[index]?.inventory_item;
                        if (poLine) return getItemName(poLine);
                        const it = inventoryItems.find((i) => i.id === line.inventory_item_id);
                        return it ? getItemName(it) : '—';
                      })()}
                    </p>
                  ) : (
                    <Select
                      value={line.inventory_item_id}
                      onValueChange={(v) => updateLine(target, index, { inventory_item_id: v ?? '' })}
                      items={poInventorySelectItems}
                    >
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder={tInv('items')} />
                      </SelectTrigger>
                      <SelectContent>
                        {inventoryItems.map((it) => (
                          <SelectItem key={it.id} value={it.id} label={getItemName(it)}>
                            {getItemName(it)}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                </div>
                <div className={showFinancials ? 'sm:col-span-2 space-y-1' : 'sm:col-span-5 space-y-1'}>
                  <Label className="text-xs text-muted-foreground">{tCommon('quantity')}</Label>
                  {readOnly ? (
                    <p className="text-sm py-2">{line.quantity}</p>
                  ) : (
                    <Input
                      type="number"
                      step="0.001"
                      min="0"
                      value={line.quantity}
                      onChange={(e) => updateLine(target, index, { quantity: e.target.value })}
                    />
                  )}
                </div>
                {showFinancials && (
                  <>
                    <div className="sm:col-span-2 space-y-1">
                      <Label className="text-xs text-muted-foreground">{t('unitPrice')}</Label>
                      {readOnly ? (
                        <p className="text-sm py-2">{Number(line.unit_price).toFixed(2)}</p>
                      ) : (
                        <Input
                          type="number"
                          step="0.01"
                          min="0"
                          value={line.unit_price}
                          onChange={(e) => updateLine(target, index, { unit_price: e.target.value })}
                        />
                      )}
                    </div>
                    <div className="sm:col-span-2 space-y-1">
                      <Label className="text-xs text-muted-foreground">{t('lineTotal')}</Label>
                      <p className="text-sm font-medium py-2">{lineTotal(line).toFixed(2)} QAR</p>
                    </div>
                  </>
                )}
                {!readOnly && (
                  <div className="sm:col-span-1 flex justify-end">
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      className="text-destructive"
                      disabled={lines.length <= 1}
                      onClick={() => removeLineRow(target, index)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  if (loading || userLoading) {
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
          <p className="text-muted-foreground mt-1 flex items-center gap-2">
            <ClipboardList className="h-4 w-4" />
            {tCommon('total')}: {stats.total}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          {showFinancials ? (
            <BulkUploadButton templateType="purchase_orders" onUploadComplete={loadData} />
          ) : null}
          <Button onClick={openAdd}>
            <Plus className="h-4 w-4 me-2" />
            {t('addOrder')}
          </Button>
        </div>
      </div>

      <div className={cn('grid gap-4', showFinancials ? 'sm:grid-cols-3' : 'sm:grid-cols-2')}>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('totalPOs')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold">{stats.total}</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">{t('pending')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold text-amber-600">{stats.pending}</p>
          </CardContent>
        </Card>
        {showFinancials ? (
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">{t('monthSpending')}</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold text-primary">{stats.monthSpending.toFixed(2)} QAR</p>
            </CardContent>
          </Card>
        ) : null}
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <Tabs value={statusTab} onValueChange={(v) => setStatusTab(v ?? 'all')}>
              <TabsList>
                <TabsTrigger value="all">{tCommon('all')}</TabsTrigger>
                <TabsTrigger value="draft">{t('statusDraft')}</TabsTrigger>
                <TabsTrigger value="submitted">{t('statusSubmitted')}</TabsTrigger>
                <TabsTrigger value="received">{t('statusReceived')}</TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{t('orderNumber')}</TableHead>
                <TableHead>{t('supplier')}</TableHead>
                <TableHead>{t('orderDate')}</TableHead>
                <TableHead>{t('expectedDelivery')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
                {showFinancials ? <TableHead>{t('totalAmount')}</TableHead> : null}
                <TableHead>{tCommon('actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredOrders.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={showFinancials ? 7 : 6} className="text-center py-8 text-muted-foreground">
                    {t('noOrders')}
                  </TableCell>
                </TableRow>
              ) : (
                filteredOrders.map((po) => (
                  <TableRow key={po.id}>
                    <TableCell className="font-mono text-sm">#{shortId(po.id)}</TableCell>
                    <TableCell className="font-medium">{po.supplier?.name ?? '—'}</TableCell>
                    <TableCell>{po.order_date}</TableCell>
                    <TableCell>{po.expected_delivery || '—'}</TableCell>
                    <TableCell>{renderStatusBadge(po.status)}</TableCell>
                    {showFinancials ? (
                      <TableCell>{Number(po.total_amount).toFixed(2)} QAR</TableCell>
                    ) : null}
                    <TableCell>
                      <Button variant="outline" size="sm" onClick={() => openDetail(po)}>
                        <Eye className="h-4 w-4 me-1" />
                        {t('viewOrder')}
                      </Button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={addOpen} onOpenChange={setAddOpen}>
        <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>{t('addOrder')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>{t('supplier')}</Label>
              <Select
                value={addForm.supplier_id}
                onValueChange={(v) => setAddForm((f) => ({ ...f, supplier_id: v ?? '' }))}
                items={supplierSelectItems}
              >
                <SelectTrigger>
                  <SelectValue placeholder={t('selectSupplier')} />
                </SelectTrigger>
                <SelectContent>
                  {suppliers.map((s) => (
                    <SelectItem key={s.id} value={s.id} label={s.name}>
                      {s.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>{t('orderDate')}</Label>
                <Input
                  type="date"
                  value={addForm.order_date}
                  onChange={(e) => setAddForm((f) => ({ ...f, order_date: e.target.value }))}
                />
              </div>
              <div className="space-y-2">
                <Label>{t('expectedDelivery')}</Label>
                <Input
                  type="date"
                  value={addForm.expected_delivery}
                  onChange={(e) => setAddForm((f) => ({ ...f, expected_delivery: e.target.value }))}
                />
              </div>
            </div>
            {renderLineEditor('add', addForm.lines, false)}
            {showFinancials ? (
              <div className="flex justify-end text-lg font-semibold">
                {t('totalAmount')}: {sumLines(resolveLinesForSave(addForm.lines)).toFixed(2)} QAR
              </div>
            ) : null}
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setAddOpen(false)}>
              {tCommon('cancel')}
            </Button>
            <Button onClick={handleCreatePo} disabled={saving}>
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog
        open={detailOpen}
        onOpenChange={(o) => {
          setDetailOpen(o);
          if (!o) setDetailPo(null);
        }}
      >
        <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {detailPo ? `${t('editOrder')} #${shortId(detailPo.id)}` : t('editOrder')}
            </DialogTitle>
          </DialogHeader>
          {detailPo && (
            <>
              <div className="space-y-4">
                <div className="flex flex-wrap items-center gap-2">
                  {renderStatusBadge(detailPo.status)}
                </div>
                <div className="space-y-2">
                  <Label>{t('supplier')}</Label>
                  {detailPo.status === 'draft' ? (
                    <Select
                      value={editForm.supplier_id}
                      onValueChange={(v) => setEditForm((f) => ({ ...f, supplier_id: v ?? '' }))}
                      items={supplierSelectItems}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder={t('selectSupplier')} />
                      </SelectTrigger>
                      <SelectContent>
                        {suppliers.map((s) => (
                          <SelectItem key={s.id} value={s.id} label={s.name}>
                            {s.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  ) : (
                    <p className="text-sm font-medium py-2">{detailPo.supplier?.name ?? '—'}</p>
                  )}
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label>{t('orderDate')}</Label>
                    {detailPo.status === 'draft' ? (
                      <Input
                        type="date"
                        value={editForm.order_date}
                        onChange={(e) => setEditForm((f) => ({ ...f, order_date: e.target.value }))}
                      />
                    ) : (
                      <p className="text-sm py-2">{detailPo.order_date}</p>
                    )}
                  </div>
                  <div className="space-y-2">
                    <Label>{t('expectedDelivery')}</Label>
                    {detailPo.status === 'draft' ? (
                      <Input
                        type="date"
                        value={editForm.expected_delivery}
                        onChange={(e) =>
                          setEditForm((f) => ({ ...f, expected_delivery: e.target.value }))
                        }
                      />
                    ) : (
                      <p className="text-sm py-2">{detailPo.expected_delivery || '—'}</p>
                    )}
                  </div>
                </div>
                {renderLineEditor('edit', editForm.lines, detailPo.status !== 'draft')}
                {showFinancials ? (
                  <div className="flex justify-end text-lg font-semibold">
                    {t('totalAmount')}:{' '}
                    {detailPo.status === 'draft'
                      ? `${sumLines(resolveLinesForSave(editForm.lines)).toFixed(2)} QAR`
                      : `${Number(detailPo.total_amount).toFixed(2)} QAR`}
                  </div>
                ) : null}
              </div>
              <DialogFooter className="flex-col gap-2 sm:flex-row sm:justify-end">
                {detailPo.status === 'draft' && (
                  <>
                    <Button variant="outline" onClick={handleSaveDraft} disabled={saving}>
                      {saving ? tCommon('loading') : t('saveDraft')}
                    </Button>
                    <Button onClick={handleSubmitOrder} disabled={saving}>
                      <Send className="h-4 w-4 me-2" />
                      {saving ? tCommon('loading') : t('submitOrder')}
                    </Button>
                  </>
                )}
                {detailPo.status === 'submitted' && showReceive && (
                  <Button onClick={handleReceiveOrder} disabled={receiving}>
                    <Package className="h-4 w-4 me-2" />
                    {receiving ? tCommon('loading') : t('receiveOrder')}
                  </Button>
                )}
              </DialogFooter>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
