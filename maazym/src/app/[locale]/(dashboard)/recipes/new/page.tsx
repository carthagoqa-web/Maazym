'use client';

import { RecipeForm } from '@/components/recipes/recipe-form';
import { useTranslations } from 'next-intl';

export default function NewRecipePage() {
  const t = useTranslations('recipes');

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">{t('addRecipe')}</h1>
      <RecipeForm />
    </div>
  );
}
