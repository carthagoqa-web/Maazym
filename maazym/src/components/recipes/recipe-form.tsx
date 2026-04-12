'use client';

import { useState, useEffect, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { useTranslations, useLocale } from 'next-intl';
import { createClient } from '@/lib/supabase/client';
import { DEFAULT_BRANCH_ID } from '@/lib/default-branch';
import { normalizePublicStorageUrl } from '@/lib/supabase-storage';
import type { Recipe, Category, InventoryItem, RecipeIngredient } from '@/types/database';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Separator } from '@/components/ui/separator';
import { Plus, Trash2, Upload, Calculator } from 'lucide-react';
import { toast } from 'sonner';

interface RecipeFormProps {
  recipe?: Recipe & { ingredients?: (RecipeIngredient & { inventory_item?: InventoryItem })[] };
}

interface IngredientRow {
  id?: string;
  inventory_item_id: string;
  quantity: number;
  unit: string;
  item_name?: string;
  item_cost?: number;
}

const UNITS = ['kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can'];

export function RecipeForm({ recipe }: RecipeFormProps) {
  const t = useTranslations('recipes');
  const tCommon = useTranslations('common');
  const tInv = useTranslations('inventory');
  const locale = useLocale();
  const router = useRouter();

  const [categories, setCategories] = useState<Category[]>([]);
  const [inventoryItems, setInventoryItems] = useState<InventoryItem[]>([]);
  const [saving, setSaving] = useState(false);
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(
    normalizePublicStorageUrl(recipe?.image_url) || null
  );

  const [form, setForm] = useState({
    name_ar: recipe?.name_ar || '',
    name_en: recipe?.name_en || '',
    description_ar: recipe?.description_ar || '',
    description_en: recipe?.description_en || '',
    category_id: recipe?.category_id || '',
    prep_time_minutes: recipe?.prep_time_minutes?.toString() || '',
    serving_size: recipe?.serving_size?.toString() || '1',
    calories: recipe?.calories?.toString() || '',
  });

  const [ingredients, setIngredients] = useState<IngredientRow[]>(
    recipe?.ingredients?.map((ing) => ({
      id: ing.id,
      inventory_item_id: ing.inventory_item_id,
      quantity: ing.quantity,
      unit: ing.unit,
      item_name: locale === 'ar' ? ing.inventory_item?.name_ar : ing.inventory_item?.name_en,
      item_cost: ing.inventory_item?.unit_cost,
    })) || []
  );

  useEffect(() => {
    loadOptions();
  }, []);

  async function loadOptions() {
    const supabase = createClient();
    const [catRes, itemsRes] = await Promise.all([
      supabase.from('categories').select('*').eq('is_active', true).order('sort_order'),
      supabase.from('inventory_items').select('*').eq('is_active', true).order('name_en'),
    ]);
    setCategories(catRes.data || []);
    setInventoryItems(itemsRes.data || []);
  }

  function addIngredient() {
    setIngredients([...ingredients, { inventory_item_id: '', quantity: 0, unit: 'g' }]);
  }

  function removeIngredient(index: number) {
    setIngredients(ingredients.filter((_, i) => i !== index));
  }

  function updateIngredient(index: number, field: keyof IngredientRow, value: string | number) {
    const updated = [...ingredients];
    (updated[index] as any)[field] = value;
    if (field === 'inventory_item_id') {
      const item = inventoryItems.find((i) => i.id === value);
      if (item) {
        updated[index].unit = item.unit;
        updated[index].item_cost = item.unit_cost;
        updated[index].item_name = locale === 'ar' ? item.name_ar : item.name_en;
      }
    }
    setIngredients(updated);
  }

  const totalCost = ingredients.reduce((sum, ing) => {
    const item = inventoryItems.find((i) => i.id === ing.inventory_item_id);
    if (!item) return sum;
    return sum + ing.quantity * item.unit_cost;
  }, 0);

  const { totalCaloriesFromIngredients, caloriesMissingCount, rowCalorieContributions } = useMemo(() => {
    let total = 0;
    let missing = 0;
    const perRow: (number | null)[] = ingredients.map((ing) => {
      if (!ing.inventory_item_id) return null;
      const item = inventoryItems.find((i) => i.id === ing.inventory_item_id);
      if (!item) return null;
      if (item.calories_per_unit == null) {
        missing += 1;
        return null;
      }
      const contribution = ing.quantity * item.calories_per_unit;
      total += contribution;
      return contribution;
    });
    return {
      totalCaloriesFromIngredients: total,
      caloriesMissingCount: missing,
      rowCalorieContributions: perRow,
    };
  }, [ingredients, inventoryItems]);

  const hasIngredientRows = ingredients.length > 0;
  const caloriesToSave = hasIngredientRows
    ? Math.round(totalCaloriesFromIngredients)
    : form.calories
      ? parseInt(form.calories, 10)
      : null;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    try {
      const supabase = createClient();
      const {
        data: { user },
        error: userError,
      } = await supabase.auth.getUser();
      if (userError || !user) {
        throw new Error(userError?.message || tCommon('error'));
      }

      const { data: profile } = await supabase
        .from('profiles')
        .select('branch_id')
        .eq('id', user.id)
        .maybeSingle();

      const branch_id = profile?.branch_id ?? DEFAULT_BRANCH_ID;

      let image_url = recipe?.image_url || null;

      if (imageFile) {
        const ext = imageFile.name.split('.').pop();
        const fileName = `${Date.now()}.${ext}`;
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('recipe-images')
          .upload(fileName, imageFile, { upsert: false, cacheControl: '3600' });

        if (uploadError) throw uploadError;

        const { data: urlData } = supabase.storage
          .from('recipe-images')
          .getPublicUrl(uploadData.path);
        image_url = normalizePublicStorageUrl(urlData.publicUrl);
      }

      const recipeData = {
        name_ar: form.name_ar,
        name_en: form.name_en,
        description_ar: form.description_ar || null,
        description_en: form.description_en || null,
        category_id: form.category_id,
        prep_time_minutes: form.prep_time_minutes ? parseInt(form.prep_time_minutes) : null,
        serving_size: parseInt(form.serving_size) || 1,
        calories: Number.isFinite(caloriesToSave as number) ? caloriesToSave : null,
        image_url,
        ...(recipe ? {} : { branch_id, created_by: user.id }),
      };

      let recipeId = recipe?.id;

      if (recipe) {
        const { error } = await supabase.from('recipes').update(recipeData).eq('id', recipe.id);
        if (error) throw error;
      } else {
        const { data, error } = await supabase.from('recipes').insert(recipeData).select().single();
        if (error) throw error;
        recipeId = data.id;
      }

      if (recipe) {
        await supabase.from('recipe_ingredients').delete().eq('recipe_id', recipe.id);
      }

      if (ingredients.length > 0 && recipeId) {
        const ingredientData = ingredients
          .filter((ing) => ing.inventory_item_id)
          .map((ing) => ({
            recipe_id: recipeId!,
            inventory_item_id: ing.inventory_item_id,
            quantity: ing.quantity,
            unit: ing.unit,
          }));

        if (ingredientData.length > 0) {
          const { error } = await supabase.from('recipe_ingredients').insert(ingredientData);
          if (error) throw error;
        }
      }

      toast.success(recipe ? tCommon('updated') : tCommon('created'));
      router.push(`/${locale}/recipes`);
      router.refresh();
    } catch (error: any) {
      toast.error(error.message || tCommon('error'));
    } finally {
      setSaving(false);
    }
  }

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const categorySelectItems = useMemo(
    () => categories.map((c) => ({ value: c.id, label: getName(c) })),
    [categories, locale]
  );

  const inventorySelectItems = useMemo(
    () =>
      inventoryItems.map((inv) => ({
        value: inv.id,
        label: `${getName(inv)} (${tInv(`units.${inv.unit}`)})`,
      })),
    [inventoryItems, locale, tInv]
  );

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>{t('recipeName')}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>{t('recipeNameAr')}</Label>
              <Input
                value={form.name_ar}
                onChange={(e) => setForm({ ...form, name_ar: e.target.value })}
                dir="rtl"
                required
              />
            </div>
            <div className="space-y-2">
              <Label>{t('recipeNameEn')}</Label>
              <Input
                value={form.name_en}
                onChange={(e) => setForm({ ...form, name_en: e.target.value })}
                dir="ltr"
                required
              />
            </div>
            <div className="space-y-2">
              <Label>{t('category')}</Label>
              <Select
                value={form.category_id}
                onValueChange={(v) => setForm({ ...form, category_id: v ?? '' })}
                items={categorySelectItems}
              >
                <SelectTrigger className="w-full min-w-0">
                  <SelectValue placeholder={t('category')} />
                </SelectTrigger>
                <SelectContent>
                  {categories.map((cat) => (
                    <SelectItem key={cat.id} value={cat.id} label={getName(cat)}>{getName(cat)}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>{tCommon('description')}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>{t('descriptionAr')}</Label>
              <Textarea
                value={form.description_ar}
                onChange={(e) => setForm({ ...form, description_ar: e.target.value })}
                dir="rtl"
                rows={3}
              />
            </div>
            <div className="space-y-2">
              <Label>{t('descriptionEn')}</Label>
              <Textarea
                value={form.description_en}
                onChange={(e) => setForm({ ...form, description_en: e.target.value })}
                dir="ltr"
                rows={3}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>{t('image')}</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            {imagePreview && (
              <div className="w-32 h-32 rounded-lg overflow-hidden bg-muted relative">
                <img src={imagePreview} alt="" className="object-cover w-full h-full" />
              </div>
            )}
            <div>
              <Label htmlFor="image" className="cursor-pointer">
                <div className="flex items-center gap-2 px-4 py-2 border rounded-lg hover:bg-muted transition-colors">
                  <Upload className="h-4 w-4" />
                  {t('uploadImage')}
                </div>
              </Label>
              <input
                id="image"
                type="file"
                accept="image/*"
                className="hidden"
                onChange={(e) => {
                  const file = e.target.files?.[0];
                  if (file) {
                    setImageFile(file);
                    setImagePreview(URL.createObjectURL(file));
                  }
                }}
              />
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-6 md:grid-cols-3">
        <Card>
          <CardContent className="pt-6">
            <div className="space-y-2">
              <Label>{t('prepTime')}</Label>
              <Input
                type="number"
                value={form.prep_time_minutes}
                onChange={(e) => setForm({ ...form, prep_time_minutes: e.target.value })}
                min="0"
              />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="space-y-2">
              <Label>{t('servingSize')}</Label>
              <Input
                type="number"
                value={form.serving_size}
                onChange={(e) => setForm({ ...form, serving_size: e.target.value })}
                min="1"
              />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="space-y-2">
              <Label>{t('calories')}</Label>
              {hasIngredientRows ? (
                <Input
                  type="number"
                  readOnly
                  value={Math.round(totalCaloriesFromIngredients)}
                  min="0"
                  className="bg-muted/50"
                />
              ) : (
                <Input
                  type="number"
                  value={form.calories}
                  onChange={(e) => setForm({ ...form, calories: e.target.value })}
                  min="0"
                  placeholder={tCommon('optional')}
                />
              )}
              <p className="text-xs text-muted-foreground">
                {hasIngredientRows ? t('caloriesAutoCalculated') : t('noIngredientsForCalories')}
              </p>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>{t('ingredients')}</CardTitle>
            <Button type="button" variant="outline" size="sm" onClick={addIngredient}>
              <Plus className="h-4 w-4 me-2" />
              {t('addIngredient')}
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {ingredients.length === 0 ? (
            <p className="text-muted-foreground text-sm text-center py-8">{t('addIngredient')}</p>
          ) : (
            <div className="space-y-3">
              {ingredients.map((ing, index) => {
                const rowCal = rowCalorieContributions[index];
                const item = ing.inventory_item_id
                  ? inventoryItems.find((i) => i.id === ing.inventory_item_id)
                  : undefined;
                const rowMissingCals =
                  Boolean(ing.inventory_item_id && item && item.calories_per_unit == null);

                return (
                  <div key={index} className="flex items-end gap-3 flex-wrap sm:flex-nowrap">
                    <div className="flex-1 min-w-[140px]">
                      {index === 0 && <Label className="text-xs mb-1 block">{tCommon('name')}</Label>}
                      <Select
                        value={ing.inventory_item_id}
                        onValueChange={(v) => v != null && updateIngredient(index, 'inventory_item_id', v)}
                        items={inventorySelectItems}
                      >
                        <SelectTrigger className="w-full min-w-0">
                          <SelectValue placeholder={tCommon('search')} />
                        </SelectTrigger>
                        <SelectContent>
                          {inventoryItems.map((inv) => (
                            <SelectItem
                              key={inv.id}
                              value={inv.id}
                              label={`${getName(inv)} (${tInv(`units.${inv.unit}`)})`}
                            >
                              {getName(inv)} ({tInv(`units.${inv.unit}`)})
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="w-28">
                      {index === 0 && <Label className="text-xs mb-1 block">{tCommon('quantity')}</Label>}
                      <Input
                        type="number"
                        step="0.001"
                        value={ing.quantity || ''}
                        onChange={(e) => updateIngredient(index, 'quantity', parseFloat(e.target.value) || 0)}
                      />
                    </div>
                    <div className="w-28">
                      {index === 0 && <Label className="text-xs mb-1 block">{tCommon('unit')}</Label>}
                      <Select value={ing.unit} onValueChange={(v) => v != null && updateIngredient(index, 'unit', v)}>
                        <SelectTrigger className="w-full">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {UNITS.map((u) => (
                            <SelectItem key={u} value={u}>{tInv(`units.${u}`)}</SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="w-24">
                      {index === 0 && (
                        <Label className="text-xs mb-1 block">{t('calories')}</Label>
                      )}
                      <div
                        className={`flex h-8 items-center rounded-md border border-input bg-transparent px-2 text-sm tabular-nums ${
                          rowMissingCals ? 'text-amber-600 dark:text-amber-500' : 'text-muted-foreground'
                        }`}
                      >
                        {rowCal != null ? Math.round(rowCal) : '—'}
                      </div>
                    </div>
                    <Button type="button" variant="ghost" size="icon" onClick={() => removeIngredient(index)} className="text-destructive shrink-0">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                );
              })}
            </div>
          )}

          <Separator className="my-4" />

          <div className="space-y-3">
            <div className="flex items-center justify-between bg-muted/50 rounded-lg p-4">
              <div className="flex items-center gap-2">
                <Calculator className="h-5 w-5 text-muted-foreground" />
                <span className="font-medium">{t('costPerDish')}</span>
              </div>
              <span className="text-2xl font-bold">
                {tCommon('currencyAmount', { amount: totalCost.toFixed(2) })}
              </span>
            </div>
            {ingredients.length > 0 && (
              <div className="rounded-lg border border-border bg-card p-4 space-y-2">
                <p className="text-lg font-semibold tabular-nums">
                  {t('totalCalories')}: {Math.round(totalCaloriesFromIngredients)}
                </p>
                {caloriesMissingCount > 0 && (
                  <p className="text-sm text-amber-600 dark:text-amber-500" role="status">
                    {t('caloriesMissingWarning', { count: caloriesMissingCount })}
                  </p>
                )}
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      <div className="flex justify-end gap-3">
        <Button type="button" variant="outline" onClick={() => router.back()}>
          {tCommon('cancel')}
        </Button>
        <Button type="submit" disabled={saving}>
          {saving ? tCommon('loading') : tCommon('save')}
        </Button>
      </div>
    </form>
  );
}
