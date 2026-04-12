'use client';

import { useEffect, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { InventoryItem, StockLevel } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Save, AlertTriangle } from 'lucide-react';
import { toast } from 'sonner';

interface StockSetup {
  item_id: string;
  name_ar: string;
  name_en: string;
  unit: string;
  current_quantity: number;
  zero_stock_level: number;
}

export default function ZeroStockPage() {
  const t = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [stockSetup, setStockSetup] = useState<StockSetup[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => { loadData(); }, []);

  async function loadData() {
    const supabase = createClient();
    const { data } = await supabase
      .from('inventory_items')
      .select('id, name_ar, name_en, unit, stock_levels:stock_levels(current_quantity, zero_stock_level)')
      .eq('is_active', true)
      .order('name_en');

    const setup: StockSetup[] = (data || []).map((item: any) => ({
      item_id: item.id,
      name_ar: item.name_ar,
      name_en: item.name_en,
      unit: item.unit,
      current_quantity: item.stock_levels?.[0]?.current_quantity || 0,
      zero_stock_level: item.stock_levels?.[0]?.zero_stock_level || 0,
    }));

    setStockSetup(setup);
    setLoading(false);
  }

  function updateLevel(index: number, value: string) {
    const updated = [...stockSetup];
    updated[index].zero_stock_level = parseFloat(value) || 0;
    setStockSetup(updated);
  }

  async function handleSave() {
    setSaving(true);
    try {
      const supabase = createClient();
      for (const item of stockSetup) {
        await supabase
          .from('stock_levels')
          .update({ zero_stock_level: item.zero_stock_level })
          .eq('item_id', item.item_id);
      }
      toast.success(tCommon('updated'));
    } catch (error: any) {
      toast.error(error.message || tCommon('error'));
    } finally {
      setSaving(false);
    }
  }

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">{t('zeroStockSetup')}</h1>
          <p className="text-muted-foreground mt-1 flex items-center gap-2">
            <AlertTriangle className="h-4 w-4" />
            {t('zeroStockSetup')}
          </p>
        </div>
        <Button onClick={handleSave} disabled={saving}>
          <Save className="h-4 w-4 me-2" />
          {saving ? tCommon('loading') : tCommon('save')}
        </Button>
      </div>

      <Card>
        <CardContent className="pt-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{tCommon('name')}</TableHead>
                <TableHead>{tCommon('unit')}</TableHead>
                <TableHead>{t('currentStock')}</TableHead>
                <TableHead>{t('zeroStockLevel')}</TableHead>
                <TableHead>{tCommon('status')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {stockSetup.map((item, index) => (
                <TableRow key={item.item_id}>
                  <TableCell className="font-medium">{getName(item)}</TableCell>
                  <TableCell>{t(`units.${item.unit}`)}</TableCell>
                  <TableCell>{Number(item.current_quantity).toFixed(2)}</TableCell>
                  <TableCell>
                    <Input
                      type="number"
                      step="0.01"
                      value={item.zero_stock_level}
                      onChange={(e) => updateLevel(index, e.target.value)}
                      className="w-28"
                    />
                  </TableCell>
                  <TableCell>
                    {item.current_quantity <= item.zero_stock_level ? (
                      <Badge variant="destructive">{t('lowStock')}</Badge>
                    ) : (
                      <Badge variant="default" className="bg-green-100 text-green-800">{t('inStock')}</Badge>
                    )}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
