'use client';

import { useEffect, useMemo, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import Link from 'next/link';
import Image from 'next/image';
import { createClient } from '@/lib/supabase/client';
import type { Recipe, Category } from '@/types/database';
import { normalizePublicStorageUrl } from '@/lib/supabase-storage';
import { withTimeout } from '@/lib/with-timeout';

function normalizeCategory(cat: Category | Category[] | null | undefined): Category | null {
  if (!cat) return null;
  return Array.isArray(cat) ? (cat[0] ?? null) : cat;
}
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardFooter, CardHeader } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Skeleton } from '@/components/ui/skeleton';
import { Plus, Search, UtensilsCrossed, Clock, Flame, DollarSign } from 'lucide-react';

export default function RecipesPage() {
  const t = useTranslations('recipes');
  const tCommon = useTranslations('common');
  const locale = useLocale();
  const [recipes, setRecipes] = useState<(Recipe & { category: Category | null; total_cost?: number })[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const getName = (item: { name_ar: string; name_en: string }) =>
    locale === 'ar' ? item.name_ar : item.name_en;

  const categoryFilterItems = useMemo(
    () => [
      { value: 'all', label: tCommon('all') },
      ...categories.map((c) => ({ value: c.id, label: getName(c) })),
    ],
    [categories, locale, tCommon]
  );

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      const supabase = createClient();

      const [recipesRes, categoriesRes, costsRes] = await withTimeout(
        Promise.all([
          supabase.from('recipes').select('*, category:categories(*)').eq('is_active', true).order('created_at', { ascending: false }),
          supabase.from('categories').select('*').eq('is_active', true).order('sort_order'),
          supabase.from('recipe_cost_summary').select('*'),
        ]),
        30_000,
        'Recipe book load'
      );

      if (recipesRes.error) console.error('recipes load error:', recipesRes.error);
      if (categoriesRes.error) console.error('categories load error:', categoriesRes.error);
      if (costsRes.error) console.error('recipe_cost_summary load error:', costsRes.error);

      const costsMap = new Map(costsRes.data?.map((c: any) => [c.recipe_id, c.total_cost]) || []);
      const recipesWithCost = (recipesRes.data || []).map((r: any) => ({
        ...r,
        category: normalizeCategory(r.category),
        total_cost: costsMap.get(r.id) || 0,
      }));

      setRecipes(recipesWithCost);
      setCategories(categoriesRes.data || []);
    } catch (e) {
      console.error('Recipe book load error:', e);
    } finally {
      setLoading(false);
    }
  }

  const filtered = recipes.filter((r) => {
    const matchesSearch = search === '' ||
      r.name_ar.toLowerCase().includes(search.toLowerCase()) ||
      r.name_en.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || r.category_id === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-48" />
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {[...Array(6)].map((_, i) => <Skeleton key={i} className="h-64" />)}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">{t('title')}</h1>
        </div>
        <Link href={`/${locale}/recipes/new`}>
          <Button>
            <Plus className="h-4 w-4 me-2" />
            {t('addRecipe')}
          </Button>
        </Link>
      </div>

      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="absolute start-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder={tCommon('search')}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="ps-9"
          />
        </div>
        <Select
          value={selectedCategory}
          onValueChange={(v) => setSelectedCategory(v ?? 'all')}
          items={categoryFilterItems}
        >
          <SelectTrigger className="w-full sm:w-48">
            <SelectValue placeholder={t('category')} />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">{tCommon('all')}</SelectItem>
            {categories.map((cat) => (
              <SelectItem key={cat.id} value={cat.id} label={getName(cat)}>{getName(cat)}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {filtered.length === 0 ? (
        <Card className="p-12 text-center">
          <UtensilsCrossed className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
          <p className="text-muted-foreground">{t('noRecipes')}</p>
          <Link href={`/${locale}/recipes/new`} className="mt-4 inline-block">
            <Button variant="outline">
              <Plus className="h-4 w-4 me-2" />
              {t('addRecipe')}
            </Button>
          </Link>
        </Card>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {filtered.map((recipe) => {
            const imageSrc = normalizePublicStorageUrl(recipe.image_url);
            return (
            <Link key={recipe.id} href={`/${locale}/recipes/${recipe.id}`}>
              <Card className="overflow-hidden hover:shadow-lg transition-shadow cursor-pointer h-full">
                <div className="aspect-video bg-muted relative">
                  {imageSrc ? (
                    <Image
                      src={imageSrc}
                      alt={getName(recipe)}
                      fill
                      className="object-cover"
                    />
                  ) : (
                    <div className="flex items-center justify-center h-full">
                      <UtensilsCrossed className="h-12 w-12 text-muted-foreground/30" />
                    </div>
                  )}
                </div>
                <CardHeader className="pb-2">
                  <div className="flex items-center justify-between">
                    <h3 className="font-semibold text-lg">{getName(recipe)}</h3>
                    {recipe.category && (
                      <Badge variant="secondary">{getName(recipe.category)}</Badge>
                    )}
                  </div>
                </CardHeader>
                <CardContent className="pb-2">
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {locale === 'ar'
                      ? recipe.description_ar || recipe.description_en
                      : recipe.description_en || recipe.description_ar}
                  </p>
                </CardContent>
                <CardFooter className="gap-4 text-sm text-muted-foreground">
                  {recipe.prep_time_minutes && (
                    <span className="flex items-center gap-1">
                      <Clock className="h-3.5 w-3.5" />
                      {t('minutesShort', { minutes: recipe.prep_time_minutes })}
                    </span>
                  )}
                  {recipe.calories && (
                    <span className="flex items-center gap-1">
                      <Flame className="h-3.5 w-3.5" />
                      {t('caloriesShort', { calories: recipe.calories })}
                    </span>
                  )}
                  <span className="flex items-center gap-1 ms-auto font-medium text-foreground">
                    <DollarSign className="h-3.5 w-3.5" />
                    {tCommon('currencyAmount', { amount: Number(recipe.total_cost).toFixed(2) })}
                  </span>
                </CardFooter>
              </Card>
            </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
