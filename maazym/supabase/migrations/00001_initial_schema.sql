-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- BRANCHES (multi-branch readiness)
-- =============================================
CREATE TABLE branches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  address TEXT,
  phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PROFILES (extends Supabase auth.users)
-- =============================================
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'manager', 'chef', 'bartender')),
  branch_id UUID REFERENCES branches(id),
  preferred_language TEXT DEFAULT 'ar' CHECK (preferred_language IN ('ar', 'en')),
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- RECIPE CATEGORIES
-- =============================================
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('food', 'beverage')),
  sort_order INTEGER DEFAULT 0,
  branch_id UUID REFERENCES branches(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- RECIPES
-- =============================================
CREATE TABLE recipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL REFERENCES categories(id),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  description_ar TEXT,
  description_en TEXT,
  image_url TEXT,
  prep_time_minutes INTEGER,
  serving_size INTEGER DEFAULT 1,
  calories INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_by UUID REFERENCES profiles(id),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- INVENTORY CATEGORIES
-- =============================================
CREATE TABLE inventory_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  branch_id UUID REFERENCES branches(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- INVENTORY ITEMS
-- =============================================
CREATE TABLE inventory_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL REFERENCES inventory_categories(id),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  unit TEXT NOT NULL CHECK (unit IN ('kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can')),
  unit_cost DECIMAL(10, 2) DEFAULT 0,
  is_halal BOOLEAN NOT NULL DEFAULT true CHECK (is_halal = true),
  is_active BOOLEAN DEFAULT true,
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- RECIPE INGREDIENTS (join recipes to inventory)
-- =============================================
CREATE TABLE recipe_ingredients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  inventory_item_id UUID NOT NULL REFERENCES inventory_items(id),
  quantity DECIMAL(10, 3) NOT NULL,
  unit TEXT NOT NULL CHECK (unit IN ('kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- STOCK LEVELS
-- =============================================
CREATE TABLE stock_levels (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_id UUID NOT NULL UNIQUE REFERENCES inventory_items(id) ON DELETE CASCADE,
  current_quantity DECIMAL(10, 3) DEFAULT 0,
  zero_stock_level DECIMAL(10, 3) DEFAULT 0,
  branch_id UUID REFERENCES branches(id),
  last_updated TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- STOCK TRANSACTIONS (audit log)
-- =============================================
CREATE TABLE stock_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_id UUID NOT NULL REFERENCES inventory_items(id),
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('received', 'consumed', 'adjusted', 'wasted')),
  quantity DECIMAL(10, 3) NOT NULL,
  notes TEXT,
  created_by UUID REFERENCES profiles(id),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- DAILY CONSUMPTION
-- =============================================
CREATE TABLE daily_consumption (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_id UUID NOT NULL REFERENCES inventory_items(id),
  quantity_used DECIMAL(10, 3) NOT NULL,
  consumed_by UUID REFERENCES profiles(id),
  consumption_date DATE NOT NULL DEFAULT CURRENT_DATE,
  shift TEXT CHECK (shift IN ('morning', 'evening')),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- MENU SECTIONS
-- =============================================
CREATE TABLE menu_sections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  branch_id UUID REFERENCES branches(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- MENU ITEMS
-- =============================================
CREATE TABLE menu_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipe_id UUID REFERENCES recipes(id),
  section_id UUID REFERENCES menu_sections(id),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  selling_price DECIMAL(10, 2) NOT NULL,
  is_available BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- SUPPLIERS
-- =============================================
CREATE TABLE suppliers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  contact_person TEXT,
  phone TEXT,
  email TEXT,
  address TEXT,
  is_halal_certified BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- SUPPLIER ITEMS
-- =============================================
CREATE TABLE supplier_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
  inventory_item_id UUID NOT NULL REFERENCES inventory_items(id),
  supplier_price DECIMAL(10, 2),
  lead_time_days INTEGER,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PURCHASE ORDERS
-- =============================================
CREATE TABLE purchase_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id UUID NOT NULL REFERENCES suppliers(id),
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'received', 'cancelled')),
  total_amount DECIMAL(12, 2) DEFAULT 0,
  order_date DATE NOT NULL DEFAULT CURRENT_DATE,
  expected_delivery DATE,
  created_by UUID REFERENCES profiles(id),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PURCHASE ORDER ITEMS
-- =============================================
CREATE TABLE purchase_order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  po_id UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
  inventory_item_id UUID NOT NULL REFERENCES inventory_items(id),
  quantity DECIMAL(10, 3) NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  received_quantity DECIMAL(10, 3) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- WASTE LOGS
-- =============================================
CREATE TABLE waste_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_id UUID NOT NULL REFERENCES inventory_items(id),
  quantity DECIMAL(10, 3) NOT NULL,
  reason TEXT NOT NULL CHECK (reason IN ('expired', 'spoiled', 'preparation', 'other')),
  waste_date DATE NOT NULL DEFAULT CURRENT_DATE,
  logged_by UUID REFERENCES profiles(id),
  notes TEXT,
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PRICING CONFIG
-- =============================================
CREATE TABLE pricing_config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  default_margin_percent DECIMAL(5, 2) NOT NULL DEFAULT 65.00,
  currency TEXT NOT NULL DEFAULT 'SAR',
  tax_percent DECIMAL(5, 2) DEFAULT 15.00,
  branch_id UUID UNIQUE REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PROMOTIONS
-- =============================================
CREATE TABLE promotions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('percentage_discount', 'fixed_discount', 'combo_deal', 'buy_x_get_y', 'happy_hour')),
  discount_value DECIMAL(10, 2),
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT true,
  days_of_week INTEGER[] DEFAULT '{0,1,2,3,4,5,6}',
  time_start TIME,
  time_end TIME,
  created_by UUID REFERENCES profiles(id),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PROMOTION ITEMS
-- =============================================
CREATE TABLE promotion_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  promotion_id UUID NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
  menu_item_id UUID NOT NULL REFERENCES menu_items(id),
  custom_price DECIMAL(10, 2),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- PRICE SIMULATIONS
-- =============================================
CREATE TABLE price_simulations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  created_by UUID REFERENCES profiles(id),
  branch_id UUID REFERENCES branches(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- SIMULATION OVERRIDES
-- =============================================
CREATE TABLE simulation_overrides (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  simulation_id UUID NOT NULL REFERENCES price_simulations(id) ON DELETE CASCADE,
  inventory_item_id UUID NOT NULL REFERENCES inventory_items(id),
  original_cost DECIMAL(10, 2) NOT NULL,
  simulated_cost DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- VIEWS
-- =============================================

-- Recipe cost summary view
CREATE OR REPLACE VIEW recipe_cost_summary AS
SELECT
  r.id AS recipe_id,
  r.name_ar,
  r.name_en,
  r.category_id,
  r.branch_id,
  COALESCE(SUM(
    ri.quantity * CASE
      WHEN ri.unit = ii.unit THEN ii.unit_cost
      WHEN ri.unit = 'g' AND ii.unit = 'kg' THEN ii.unit_cost / 1000
      WHEN ri.unit = 'kg' AND ii.unit = 'g' THEN ii.unit_cost * 1000
      WHEN ri.unit = 'ml' AND ii.unit = 'l' THEN ii.unit_cost / 1000
      WHEN ri.unit = 'l' AND ii.unit = 'ml' THEN ii.unit_cost * 1000
      ELSE ii.unit_cost
    END
  ), 0) AS total_cost,
  COUNT(ri.id) AS ingredient_count
FROM recipes r
LEFT JOIN recipe_ingredients ri ON ri.recipe_id = r.id
LEFT JOIN inventory_items ii ON ii.id = ri.inventory_item_id
WHERE r.is_active = true
GROUP BY r.id, r.name_ar, r.name_en, r.category_id, r.branch_id;

-- Daily stock summary view
CREATE OR REPLACE VIEW daily_stock_summary AS
SELECT
  ii.id AS item_id,
  ii.name_ar,
  ii.name_en,
  ii.unit,
  sl.current_quantity,
  sl.zero_stock_level,
  CASE
    WHEN sl.current_quantity <= 0 THEN 'out_of_stock'
    WHEN sl.current_quantity <= sl.zero_stock_level THEN 'low_stock'
    ELSE 'in_stock'
  END AS stock_status,
  COALESCE((
    SELECT SUM(dc.quantity_used)
    FROM daily_consumption dc
    WHERE dc.item_id = ii.id AND dc.consumption_date = CURRENT_DATE
  ), 0) AS today_consumed,
  COALESCE((
    SELECT SUM(wl.quantity)
    FROM waste_logs wl
    WHERE wl.item_id = ii.id AND wl.waste_date = CURRENT_DATE
  ), 0) AS today_wasted,
  COALESCE((
    SELECT SUM(st.quantity)
    FROM stock_transactions st
    WHERE st.item_id = ii.id
      AND st.transaction_type = 'received'
      AND st.created_at::date = CURRENT_DATE
  ), 0) AS today_received,
  ii.branch_id
FROM inventory_items ii
LEFT JOIN stock_levels sl ON sl.item_id = ii.id
WHERE ii.is_active = true;

-- =============================================
-- HALAL ENFORCEMENT TRIGGER
-- =============================================
CREATE OR REPLACE FUNCTION check_halal_compliance()
RETURNS TRIGGER AS $$
DECLARE
  haram_keywords_en TEXT[] := ARRAY['pork', 'bacon', 'ham', 'lard', 'alcohol', 'wine', 'beer', 'vodka', 'whiskey', 'rum', 'gin', 'tequila', 'brandy', 'liquor', 'liqueur', 'champagne', 'sake', 'mirin'];
  haram_keywords_ar TEXT[] := ARRAY['لحم خنزير', 'خنزير', 'كحول', 'خمر', 'بيرة', 'نبيذ', 'فودكا', 'ويسكي', 'شحم خنزير'];
  keyword TEXT;
BEGIN
  FOREACH keyword IN ARRAY haram_keywords_en LOOP
    IF LOWER(NEW.name_en) LIKE '%' || keyword || '%' THEN
      RAISE EXCEPTION 'Haram item detected: %. All items must be Halal.', keyword;
    END IF;
  END LOOP;

  FOREACH keyword IN ARRAY haram_keywords_ar LOOP
    IF NEW.name_ar LIKE '%' || keyword || '%' THEN
      RAISE EXCEPTION 'تم اكتشاف صنف حرام: %. جميع الأصناف يجب أن تكون حلال.', keyword;
    END IF;
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_halal_compliance
  BEFORE INSERT OR UPDATE ON inventory_items
  FOR EACH ROW
  EXECUTE FUNCTION check_halal_compliance();

-- =============================================
-- STOCK UPDATE TRIGGERS
-- =============================================

-- Auto-create stock_levels row when inventory_item is created
CREATE OR REPLACE FUNCTION create_stock_level()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO stock_levels (item_id, branch_id, current_quantity, zero_stock_level)
  VALUES (NEW.id, NEW.branch_id, 0, 0);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_create_stock_level
  AFTER INSERT ON inventory_items
  FOR EACH ROW
  EXECUTE FUNCTION create_stock_level();

-- Update stock on daily consumption
CREATE OR REPLACE FUNCTION update_stock_on_consumption()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE stock_levels
  SET current_quantity = current_quantity - NEW.quantity_used,
      last_updated = now()
  WHERE item_id = NEW.item_id;

  INSERT INTO stock_transactions (item_id, transaction_type, quantity, notes, created_by, branch_id)
  VALUES (NEW.item_id, 'consumed', NEW.quantity_used, 'Daily consumption', NEW.consumed_by, NEW.branch_id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_update_stock_consumption
  AFTER INSERT ON daily_consumption
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_on_consumption();

-- Update stock on waste
CREATE OR REPLACE FUNCTION update_stock_on_waste()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE stock_levels
  SET current_quantity = current_quantity - NEW.quantity,
      last_updated = now()
  WHERE item_id = NEW.item_id;

  INSERT INTO stock_transactions (item_id, transaction_type, quantity, notes, created_by, branch_id)
  VALUES (NEW.item_id, 'wasted', NEW.quantity, NEW.reason || ': ' || COALESCE(NEW.notes, ''), NEW.logged_by, NEW.branch_id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_update_stock_waste
  AFTER INSERT ON waste_logs
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_on_waste();

-- Auto-create profile on auth signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, role)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), 'chef');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at BEFORE UPDATE ON branches FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON recipes FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON inventory_items FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON menu_items FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON suppliers FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON purchase_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON pricing_config FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON promotions FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_consumption ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE waste_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE pricing_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE promotion_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE price_simulations ENABLE ROW LEVEL SECURITY;
ALTER TABLE simulation_overrides ENABLE ROW LEVEL SECURITY;

-- Helper function for getting user role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function for getting user branch
CREATE OR REPLACE FUNCTION get_user_branch_id()
RETURNS UUID AS $$
  SELECT branch_id FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Profiles: users can read all profiles in their branch, update own
CREATE POLICY "Users can view profiles in their branch" ON profiles
  FOR SELECT USING (
    branch_id = get_user_branch_id() OR get_user_role() = 'admin'
  );

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Admins can manage profiles" ON profiles
  FOR ALL USING (get_user_role() = 'admin');

-- Branches: all authenticated users can read
CREATE POLICY "Authenticated users can view branches" ON branches
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins can manage branches" ON branches
  FOR ALL USING (get_user_role() = 'admin');

-- Generic read policy for most tables (authenticated users in same branch)
DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'categories', 'recipes', 'recipe_ingredients', 'inventory_categories',
    'inventory_items', 'stock_levels', 'stock_transactions', 'daily_consumption',
    'menu_sections', 'menu_items', 'suppliers', 'supplier_items',
    'purchase_orders', 'purchase_order_items', 'waste_logs',
    'pricing_config', 'promotions', 'promotion_items',
    'price_simulations', 'simulation_overrides'
  ]) LOOP
    EXECUTE format(
      'CREATE POLICY "Authenticated read %1$s" ON %1$s FOR SELECT TO authenticated USING (true)',
      tbl
    );
    EXECUTE format(
      'CREATE POLICY "Admin/Manager write %1$s" ON %1$s FOR ALL USING (get_user_role() IN (''admin'', ''manager''))',
      tbl
    );
  END LOOP;
END $$;

-- Chefs and bartenders can write to daily_consumption
CREATE POLICY "Staff can log consumption" ON daily_consumption
  FOR INSERT TO authenticated WITH CHECK (consumed_by = auth.uid());

-- Chefs and bartenders can write to waste_logs
CREATE POLICY "Staff can log waste" ON waste_logs
  FOR INSERT TO authenticated WITH CHECK (logged_by = auth.uid());

-- Chefs can manage recipes they created
CREATE POLICY "Chefs can manage own recipes" ON recipes
  FOR ALL USING (created_by = auth.uid());

CREATE POLICY "Chefs can manage recipe ingredients" ON recipe_ingredients
  FOR ALL USING (
    EXISTS (SELECT 1 FROM recipes WHERE recipes.id = recipe_ingredients.recipe_id AND recipes.created_by = auth.uid())
  );

-- =============================================
-- INDEXES
-- =============================================
CREATE INDEX idx_recipes_category ON recipes(category_id);
CREATE INDEX idx_recipes_branch ON recipes(branch_id);
CREATE INDEX idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_item ON recipe_ingredients(inventory_item_id);
CREATE INDEX idx_inventory_items_category ON inventory_items(category_id);
CREATE INDEX idx_inventory_items_branch ON inventory_items(branch_id);
CREATE INDEX idx_stock_levels_item ON stock_levels(item_id);
CREATE INDEX idx_stock_transactions_item ON stock_transactions(item_id);
CREATE INDEX idx_stock_transactions_date ON stock_transactions(created_at);
CREATE INDEX idx_daily_consumption_item ON daily_consumption(item_id);
CREATE INDEX idx_daily_consumption_date ON daily_consumption(consumption_date);
CREATE INDEX idx_menu_items_recipe ON menu_items(recipe_id);
CREATE INDEX idx_menu_items_section ON menu_items(section_id);
CREATE INDEX idx_purchase_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_purchase_order_items_po ON purchase_order_items(po_id);
CREATE INDEX idx_waste_logs_item ON waste_logs(item_id);
CREATE INDEX idx_waste_logs_date ON waste_logs(waste_date);
CREATE INDEX idx_promotions_active ON promotions(is_active, start_date, end_date);
CREATE INDEX idx_promotion_items_promo ON promotion_items(promotion_id);
CREATE INDEX idx_simulation_overrides_sim ON simulation_overrides(simulation_id);
