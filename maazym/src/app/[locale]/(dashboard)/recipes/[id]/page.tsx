'use client';

import { useEffect, useState, use } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import type { Recipe, RecipeIngredient, InventoryItem } from '@/types/database';
import { RecipeForm } from '@/components/recipes/recipe-form';
import { Skeleton } from '@/components/ui/skeleton';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { ArrowRight, ArrowLeft, Trash2 } from 'lucide-react';
import { toast } from 'sonner';
import type { PostgrestError } from '@supabase/supabase-js';
import { withTimeout } from '@/lib/with-timeout';

export default function RecipeDetailPage({ params }: { params: Promise<{ id: string; locale: string }> }) {
  const { id, locale } = use(params);
  const t = useTranslations('recipes');
  const tCommon = useTranslations('common');
  const router = useRouter();
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [loading, setLoading] = useState(true);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const BackIcon = locale === 'ar' ? ArrowRight : ArrowLeft;

  useEffect(() => {
    loadRecipe();
  }, [id]);

  async function loadRecipe() {
    try {
      const supabase = createClient();
      const { data, error } = (await withTimeout(
        supabase
          .from('recipes')
          .select('*, category:categories(*), ingredients:recipe_ingredients(*, inventory_item:inventory_items(*))')
          .eq('id', id)
          .single(),
        30_000,
        'loadRecipe'
      )) as { data: Recipe | null; error: PostgrestError | null };

      if (error) console.error('loadRecipe error:', error);
      setRecipe(data ?? null);
    } catch (e) {
      console.error('loadRecipe error:', e);
      setRecipe(null);
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete() {
    const supabase = createClient();
    await supabase.from('recipes').update({ is_active: false }).eq('id', id);
    toast.success(tCommon('deleted'));
    router.push(`/${locale}/recipes`);
  }

  if (loading) {
    return <Skeleton className="h-96" />;
  }

  if (!recipe) {
    return <p>{tCommon('noResults')}</p>;
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="icon" onClick={() => router.push(`/${locale}/recipes`)}>
            <BackIcon className="h-5 w-5" />
          </Button>
          <h1 className="text-2xl font-bold">{t('editRecipe')}</h1>
        </div>

        <Dialog open={deleteOpen} onOpenChange={setDeleteOpen}>
          <DialogTrigger
            render={<Button variant="destructive" size="sm" />}
          >
            <Trash2 className="h-4 w-4 me-2" />
            {tCommon('delete')}
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>{tCommon('confirm')}</DialogTitle>
              <DialogDescription>{t('deleteConfirm')}</DialogDescription>
            </DialogHeader>
            <DialogFooter>
              <Button variant="outline" onClick={() => setDeleteOpen(false)}>{tCommon('cancel')}</Button>
              <Button variant="destructive" onClick={handleDelete}>{tCommon('delete')}</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      <RecipeForm recipe={recipe} />
    </div>
  );
}
