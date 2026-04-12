export type UserRole = 'admin' | 'manager' | 'purchasing_manager' | 'chef' | 'bartender';
export type RecipeType = 'food' | 'beverage';
export type UnitType = 'kg' | 'g' | 'l' | 'ml' | 'piece' | 'pack' | 'box' | 'bag' | 'bottle' | 'can';
export type TransactionType = 'received' | 'consumed' | 'adjusted' | 'wasted';
export type ShiftType = 'morning' | 'evening';
export type POStatus = 'draft' | 'submitted' | 'received' | 'cancelled';
export type WasteReason = 'expired' | 'spoiled' | 'preparation' | 'other';
export type PromotionType = 'percentage_discount' | 'fixed_discount' | 'combo_deal' | 'buy_x_get_y' | 'happy_hour';
export type StockStatus = 'in_stock' | 'low_stock' | 'out_of_stock';
export type Language = 'ar' | 'en';

export interface Branch {
  id: string;
  name_ar: string;
  name_en: string;
  address: string | null;
  phone: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Profile {
  id: string;
  full_name: string;
  role: UserRole;
  branch_id: string | null;
  preferred_language: Language;
  avatar_url: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Category {
  id: string;
  name_ar: string;
  name_en: string;
  type: RecipeType;
  sort_order: number;
  branch_id: string | null;
  is_active: boolean;
  created_at: string;
}

export interface Recipe {
  id: string;
  category_id: string;
  name_ar: string;
  name_en: string;
  description_ar: string | null;
  description_en: string | null;
  image_url: string | null;
  prep_time_minutes: number | null;
  serving_size: number;
  calories: number | null;
  is_active: boolean;
  created_by: string | null;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
  category?: Category;
  ingredients?: RecipeIngredient[];
}

export interface RecipeIngredient {
  id: string;
  recipe_id: string;
  inventory_item_id: string;
  quantity: number;
  unit: UnitType;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface InventoryCategory {
  id: string;
  name_ar: string;
  name_en: string;
  sort_order: number;
  branch_id: string | null;
  is_active: boolean;
  created_at: string;
}

export interface InventoryItem {
  id: string;
  category_id: string;
  name_ar: string;
  name_en: string;
  unit: UnitType;
  unit_cost: number;
  calories_per_unit: number | null;
  is_halal: boolean;
  is_active: boolean;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
  category?: InventoryCategory;
  stock_level?: StockLevel;
}

export interface StockLevel {
  id: string;
  item_id: string;
  current_quantity: number;
  zero_stock_level: number;
  branch_id: string | null;
  last_updated: string;
}

export interface StockTransaction {
  id: string;
  item_id: string;
  transaction_type: TransactionType;
  quantity: number;
  notes: string | null;
  created_by: string | null;
  branch_id: string | null;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface DailyConsumption {
  id: string;
  item_id: string;
  quantity_used: number;
  consumed_by: string | null;
  consumption_date: string;
  shift: ShiftType | null;
  branch_id: string | null;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface MenuSection {
  id: string;
  name_ar: string;
  name_en: string;
  sort_order: number;
  branch_id: string | null;
  is_active: boolean;
  created_at: string;
}

export interface MenuItem {
  id: string;
  recipe_id: string | null;
  section_id: string | null;
  name_ar: string;
  name_en: string;
  selling_price: number;
  is_available: boolean;
  display_order: number;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
  recipe?: Recipe;
  section?: MenuSection;
}

export interface Supplier {
  id: string;
  name: string;
  contact_person: string | null;
  phone: string | null;
  email: string | null;
  address: string | null;
  is_halal_certified: boolean;
  is_active: boolean;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
}

export interface SupplierItem {
  id: string;
  supplier_id: string;
  inventory_item_id: string;
  supplier_price: number | null;
  lead_time_days: number | null;
  created_at: string;
  supplier?: Supplier;
  inventory_item?: InventoryItem;
}

export interface PurchaseOrder {
  id: string;
  supplier_id: string;
  status: POStatus;
  total_amount: number;
  order_date: string;
  expected_delivery: string | null;
  created_by: string | null;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
  supplier?: Supplier;
  items?: PurchaseOrderItem[];
}

export interface PurchaseOrderItem {
  id: string;
  po_id: string;
  inventory_item_id: string;
  quantity: number;
  unit_price: number;
  received_quantity: number;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface WasteLog {
  id: string;
  item_id: string;
  quantity: number;
  reason: WasteReason;
  waste_date: string;
  logged_by: string | null;
  notes: string | null;
  branch_id: string | null;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface PricingConfig {
  id: string;
  default_margin_percent: number;
  currency: string;
  tax_percent: number;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
}

export interface Promotion {
  id: string;
  name_ar: string;
  name_en: string;
  type: PromotionType;
  discount_value: number | null;
  start_date: string | null;
  end_date: string | null;
  is_active: boolean;
  days_of_week: number[];
  time_start: string | null;
  time_end: string | null;
  created_by: string | null;
  branch_id: string | null;
  created_at: string;
  updated_at: string;
  items?: PromotionItem[];
}

export interface PromotionItem {
  id: string;
  promotion_id: string;
  menu_item_id: string;
  custom_price: number | null;
  created_at: string;
  menu_item?: MenuItem;
}

export interface PriceSimulation {
  id: string;
  name: string;
  description: string | null;
  created_by: string | null;
  branch_id: string | null;
  created_at: string;
  overrides?: SimulationOverride[];
}

export interface SimulationOverride {
  id: string;
  simulation_id: string;
  inventory_item_id: string;
  original_cost: number;
  simulated_cost: number;
  created_at: string;
  inventory_item?: InventoryItem;
}

export interface RecipeCostSummary {
  recipe_id: string;
  name_ar: string;
  name_en: string;
  category_id: string;
  branch_id: string | null;
  total_cost: number;
  ingredient_count: number;
}

export interface CalorieReference {
  id: string;
  name_en: string;
  name_ar: string;
  calories_per_unit: number;
  unit: UnitType;
  category: string;
  created_at: string;
}

export interface PresetInventoryItem {
  id: string;
  name_en: string;
  name_ar: string;
  default_unit: UnitType;
  category: string;
  calories_per_unit: number | null;
  created_at: string;
}

export interface DailyStockSummary {
  item_id: string;
  name_ar: string;
  name_en: string;
  unit: UnitType;
  current_quantity: number;
  zero_stock_level: number;
  stock_status: StockStatus;
  today_consumed: number;
  today_wasted: number;
  today_received: number;
  branch_id: string | null;
}
