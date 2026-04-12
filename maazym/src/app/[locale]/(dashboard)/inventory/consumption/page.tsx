'use client';

import { useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import type { InventoryItem, InventoryCategory } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { Separator } from '@/components/ui/separator';
import { Plus, Trash2, Send, ClipboardList } from 'lucide-react';
import { toast } from 'sonner';

interface ConsumptionEntry {
  item_id: string;
  quantity: string;
  item_name?: string;
}

export default function ConsumptionPage() {
  const t = useTranslations('inventory');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [items, setItems] = useState<InventoryItem[]>([]);
  const [categories, setCategories] = useState<InventoryCategory[]>([]);
  const [shift, setShift] = useState<'morning' | 'evening'>('morning');
  const [entries, setEntries] = useState<ConsumptionEntry[]>([{ item_id: '', quantity: '' }]);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [saving, setSaving] = useState(false);

  useEffect(() => { loadItems(); }, []);

  async function loadItems() {
    const supabase = createClient();
    const [itemsRes, catRes] = await Promise.all([
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
      supabase.from('inventory_categories').select('*').eq('is_active', true).order('sort_order'),
    ]);
    setItems(itemsRes.data || []);
    setCategories(catRes.data || []);
  }

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const filteredItems = selectedCategory === 'all'
    ? items
    : items.filter((i) => i.category_id === selectedCategory);

  const categoryFilterItems = useMemo(
    () => [
      { value: 'all', label: tCommon('all') },
      ...categories.map((c) => ({ value: c.id, label: getName(c) })),
    ],
    [categories, locale, tCommon]
  );

  const itemPickerItems = useMemo(
    () =>
      filteredItems.map((i) => ({
        value: i.id,
        label: `${getName(i)} (${t(`units.${i.unit}`)})`,
      })),
    [filteredItems, locale, t]
  );

  function addEntry() {
    setEntries([...entries, { item_id: '', quantity: '' }]);
  }

  function removeEntry(index: number) {
    setEntries(entries.filter((_, i) => i !== index));
  }

  function updateEntry(index: number, field: keyof ConsumptionEntry, value: string) {
    const updated = [...entries];
    (updated[index] as any)[field] = value;
    if (field === 'item_id') {
      const item = items.find((i) => i.id === value);
      updated[index].item_name = item ? getName(item) : '';
    }
    setEntries(updated);
  }

  async function handleSubmit() {
    const validEntries = entries.filter((e) => e.item_id && parseFloat(e.quantity) > 0);
    if (validEntries.length === 0) {
      toast.error(tCommon('required'));
      return;
    }

    setSaving(true);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();

      const data = validEntries.map((e) => ({
        item_id: e.item_id,
        quantity_used: parseFloat(e.quantity),
        consumed_by: user?.id,
        shift,
        consumption_date: new Date().toISOString().split('T')[0],
      }));

      const { error } = await supabase.from('daily_consumption').insert(data);
      if (error) throw error;

      toast.success(tCommon('success'));
      setEntries([{ item_id: '', quantity: '' }]);
    } catch (error: any) {
      toast.error(error.message || tCommon('error'));
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">{t('dailyConsumption')}</h1>
        <p className="text-muted-foreground mt-1">{new Date().toLocaleDateString(locale)}</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>{t('shift')}</CardTitle>
        </CardHeader>
        <CardContent>
          <RadioGroup value={shift} onValueChange={(v) => setShift(v as 'morning' | 'evening')} className="flex gap-6">
            <div className="flex items-center gap-2">
              <RadioGroupItem value="morning" id="morning" />
              <Label htmlFor="morning">{t('morning')}</Label>
            </div>
            <div className="flex items-center gap-2">
              <RadioGroupItem value="evening" id="evening" />
              <Label htmlFor="evening">{t('evening')}</Label>
            </div>
          </RadioGroup>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <ClipboardList className="h-5 w-5" />
              {t('addConsumption')}
            </CardTitle>
            <div className="flex gap-2">
              <Select
                value={selectedCategory}
                onValueChange={(v) => setSelectedCategory(v ?? 'all')}
                items={categoryFilterItems}
              >
                <SelectTrigger className="w-40">
                  <SelectValue placeholder={tCommon('category')} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">{tCommon('all')}</SelectItem>
                  {categories.map((cat) => (
                    <SelectItem key={cat.id} value={cat.id} label={getName(cat)}>{getName(cat)}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Button variant="outline" size="sm" onClick={addEntry}>
                <Plus className="h-4 w-4 me-2" />
                {tCommon('add')}
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {entries.map((entry, index) => (
              <div key={index} className="flex items-end gap-3">
                <div className="flex-1">
                  {index === 0 && <Label className="text-xs mb-1 block">{tCommon('name')}</Label>}
                  <Select
                    value={entry.item_id}
                    onValueChange={(v) => updateEntry(index, 'item_id', v ?? '')}
                    items={itemPickerItems}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder={tCommon('search')} />
                    </SelectTrigger>
                    <SelectContent>
                      {filteredItems.map((item) => (
                        <SelectItem
                          key={item.id}
                          value={item.id}
                          label={`${getName(item)} (${t(`units.${item.unit}`)})`}
                        >
                          {getName(item)} ({t(`units.${item.unit}`)})
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="w-32">
                  {index === 0 && <Label className="text-xs mb-1 block">{tCommon('quantity')}</Label>}
                  <Input
                    type="number"
                    step="0.01"
                    value={entry.quantity}
                    onChange={(e) => updateEntry(index, 'quantity', e.target.value)}
                    placeholder="0.00"
                  />
                </div>
                <Button variant="ghost" size="icon" onClick={() => removeEntry(index)} className="text-destructive" disabled={entries.length === 1}>
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
            ))}
          </div>

          <Separator className="my-6" />

          <div className="flex justify-end">
            <Button onClick={handleSubmit} disabled={saving}>
              <Send className="h-4 w-4 me-2" />
              {saving ? tCommon('loading') : tCommon('save')}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
