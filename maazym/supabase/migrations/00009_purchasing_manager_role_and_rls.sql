-- Purchasing Manager role + tighter inventory delete + procurement/stock/pricing access
-- ---------------------------------------------------------------------------
-- profiles.role: add purchasing_manager
-- ---------------------------------------------------------------------------
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_role_check;
ALTER TABLE profiles ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('admin', 'manager', 'purchasing_manager', 'chef', 'bartender'));

-- ---------------------------------------------------------------------------
-- inventory_items / inventory_categories: manager+admin insert/update; admin-only delete
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admin/Manager write inventory_items" ON inventory_items;
CREATE POLICY "Admin Manager insert inventory_items" ON inventory_items
  FOR INSERT TO authenticated
  WITH CHECK (get_user_role() IN ('admin', 'manager'));
CREATE POLICY "Admin Manager update inventory_items" ON inventory_items
  FOR UPDATE TO authenticated
  USING (get_user_role() IN ('admin', 'manager'));
CREATE POLICY "Admin delete inventory_items" ON inventory_items
  FOR DELETE TO authenticated
  USING (get_user_role() = 'admin');

DROP POLICY IF EXISTS "Admin/Manager write inventory_categories" ON inventory_categories;
CREATE POLICY "Admin Manager insert inventory_categories" ON inventory_categories
  FOR INSERT TO authenticated
  WITH CHECK (get_user_role() IN ('admin', 'manager'));
CREATE POLICY "Admin Manager update inventory_categories" ON inventory_categories
  FOR UPDATE TO authenticated
  USING (get_user_role() IN ('admin', 'manager'));
CREATE POLICY "Admin delete inventory_categories" ON inventory_categories
  FOR DELETE TO authenticated
  USING (get_user_role() = 'admin');

-- ---------------------------------------------------------------------------
-- Procurement, stock movement, pricing: admin + manager + purchasing_manager
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admin/Manager write purchase_orders" ON purchase_orders;
CREATE POLICY "Admin Manager PM write purchase_orders" ON purchase_orders
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write purchase_order_items" ON purchase_order_items;
CREATE POLICY "Admin Manager PM write purchase_order_items" ON purchase_order_items
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write suppliers" ON suppliers;
CREATE POLICY "Admin Manager PM write suppliers" ON suppliers
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write supplier_items" ON supplier_items;
CREATE POLICY "Admin Manager PM write supplier_items" ON supplier_items
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write stock_levels" ON stock_levels;
CREATE POLICY "Admin Manager PM write stock_levels" ON stock_levels
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write stock_transactions" ON stock_transactions;
CREATE POLICY "Admin Manager PM write stock_transactions" ON stock_transactions
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write pricing_config" ON pricing_config;
CREATE POLICY "Admin Manager PM write pricing_config" ON pricing_config
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write price_simulations" ON price_simulations;
CREATE POLICY "Admin Manager PM write price_simulations" ON price_simulations
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

DROP POLICY IF EXISTS "Admin/Manager write simulation_overrides" ON simulation_overrides;
CREATE POLICY "Admin Manager PM write simulation_overrides" ON simulation_overrides
  FOR ALL TO authenticated
  USING (get_user_role() IN ('admin', 'manager', 'purchasing_manager'));

-- ---------------------------------------------------------------------------
-- Chef / bartender: create and edit their own draft purchase orders (request flow)
-- ---------------------------------------------------------------------------
CREATE POLICY "Staff insert purchase_orders" ON purchase_orders
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND created_by = auth.uid()
    AND status = 'draft'
  );

CREATE POLICY "Staff update own draft purchase_orders" ON purchase_orders
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND created_by = auth.uid()
    AND status = 'draft'
  );

CREATE POLICY "Staff insert purchase_order_items" ON purchase_order_items
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = purchase_order_items.po_id AND po.created_by = auth.uid()
        AND po.status = 'draft'
    )
  );

CREATE POLICY "Staff update purchase_order_items draft PO" ON purchase_order_items
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = purchase_order_items.po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
    )
  );

CREATE POLICY "Staff delete purchase_order_items draft PO" ON purchase_order_items
  FOR DELETE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = purchase_order_items.po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
    )
  );
