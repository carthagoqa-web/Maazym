import type { UnitType } from '@/types/database';

/** Converts inventory `unit_cost` to cost per one unit of `recipeUnit` (matches `recipe_cost_summary` view). */
export function costPerRecipeUnit(
  recipeUnit: UnitType,
  inventoryUnit: UnitType,
  unitCost: number
): number {
  if (recipeUnit === inventoryUnit) return unitCost;
  if (recipeUnit === 'g' && inventoryUnit === 'kg') return unitCost / 1000;
  if (recipeUnit === 'kg' && inventoryUnit === 'g') return unitCost * 1000;
  if (recipeUnit === 'ml' && inventoryUnit === 'l') return unitCost / 1000;
  if (recipeUnit === 'l' && inventoryUnit === 'ml') return unitCost * 1000;
  return unitCost;
}

export function ingredientLineCost(
  quantity: number,
  recipeUnit: UnitType,
  inventoryUnit: UnitType,
  unitCost: number
): number {
  return quantity * costPerRecipeUnit(recipeUnit, inventoryUnit, unitCost);
}
