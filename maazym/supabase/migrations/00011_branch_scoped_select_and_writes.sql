-- Branch-scoped RLS: replace blanket authenticated SELECT (USING true) and scope
-- manager / purchasing_manager writes to their branch. Admin retains full access.
-- Aligns with kitchen-staff recipe policies (00006): default branch when profile.branch_id IS NULL.

CREATE OR REPLACE FUNCTION public.branch_row_visible(p_branch_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    get_user_role() = 'admin'
    OR (
      p_branch_id IS NOT NULL
      AND (
        p_branch_id = get_user_branch_id()
        OR (
          get_user_branch_id() IS NULL
          AND p_branch_id = '00000000-0000-0000-0000-000000000001'::uuid
        )
      )
    );
$$;

COMMENT ON FUNCTION public.branch_row_visible(uuid) IS
  'True if current user may access a row keyed by branch_id: admin all branches; others own branch or default branch when profile.branch_id is null. Rows with NULL branch_id are admin-only.';

-- ---------------------------------------------------------------------------
-- branches: list only own branch unless admin
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Authenticated users can view branches" ON branches;
CREATE POLICY "Users can view relevant branches" ON branches
  FOR SELECT TO authenticated
  USING (
    get_user_role() = 'admin'
    OR id = get_user_branch_id()
    OR (
      get_user_branch_id() IS NULL
      AND id = '00000000-0000-0000-0000-000000000001'::uuid
    )
  );

-- ---------------------------------------------------------------------------
-- Drop blanket SELECT policies
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Authenticated read categories" ON categories;
DROP POLICY IF EXISTS "Authenticated read recipes" ON recipes;
DROP POLICY IF EXISTS "Authenticated read recipe_ingredients" ON recipe_ingredients;
DROP POLICY IF EXISTS "Authenticated read inventory_categories" ON inventory_categories;
DROP POLICY IF EXISTS "Authenticated read inventory_items" ON inventory_items;
DROP POLICY IF EXISTS "Authenticated read stock_levels" ON stock_levels;
DROP POLICY IF EXISTS "Authenticated read stock_transactions" ON stock_transactions;
DROP POLICY IF EXISTS "Authenticated read daily_consumption" ON daily_consumption;
DROP POLICY IF EXISTS "Authenticated read menu_sections" ON menu_sections;
DROP POLICY IF EXISTS "Authenticated read menu_items" ON menu_items;
DROP POLICY IF EXISTS "Authenticated read suppliers" ON suppliers;
DROP POLICY IF EXISTS "Authenticated read supplier_items" ON supplier_items;
DROP POLICY IF EXISTS "Authenticated read purchase_orders" ON purchase_orders;
DROP POLICY IF EXISTS "Authenticated read purchase_order_items" ON purchase_order_items;
DROP POLICY IF EXISTS "Authenticated read waste_logs" ON waste_logs;
DROP POLICY IF EXISTS "Authenticated read pricing_config" ON pricing_config;
DROP POLICY IF EXISTS "Authenticated read promotions" ON promotions;
DROP POLICY IF EXISTS "Authenticated read promotion_items" ON promotion_items;
DROP POLICY IF EXISTS "Authenticated read price_simulations" ON price_simulations;
DROP POLICY IF EXISTS "Authenticated read simulation_overrides" ON simulation_overrides;

-- ---------------------------------------------------------------------------
-- Branch-scoped SELECT
-- ---------------------------------------------------------------------------
CREATE POLICY "Branch scoped read categories" ON categories
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read recipes" ON recipes
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read recipe_ingredients" ON recipe_ingredients
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM recipes r
      WHERE r.id = recipe_ingredients.recipe_id
        AND public.branch_row_visible(r.branch_id)
    )
  );

CREATE POLICY "Branch scoped read inventory_categories" ON inventory_categories
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read inventory_items" ON inventory_items
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read stock_levels" ON stock_levels
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read stock_transactions" ON stock_transactions
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read daily_consumption" ON daily_consumption
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read menu_sections" ON menu_sections
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read menu_items" ON menu_items
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read suppliers" ON suppliers
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read supplier_items" ON supplier_items
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM suppliers s
      WHERE s.id = supplier_items.supplier_id
        AND public.branch_row_visible(s.branch_id)
    )
  );

CREATE POLICY "Branch scoped read purchase_orders" ON purchase_orders
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read purchase_order_items" ON purchase_order_items
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = purchase_order_items.po_id
        AND public.branch_row_visible(po.branch_id)
    )
  );

CREATE POLICY "Branch scoped read waste_logs" ON waste_logs
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read pricing_config" ON pricing_config
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read promotions" ON promotions
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read promotion_items" ON promotion_items
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM promotions p
      WHERE p.id = promotion_items.promotion_id
        AND public.branch_row_visible(p.branch_id)
    )
  );

CREATE POLICY "Branch scoped read price_simulations" ON price_simulations
  FOR SELECT TO authenticated USING (public.branch_row_visible(branch_id));

CREATE POLICY "Branch scoped read simulation_overrides" ON simulation_overrides
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM price_simulations ps
      WHERE ps.id = simulation_overrides.simulation_id
        AND public.branch_row_visible(ps.branch_id)
    )
  );

-- ---------------------------------------------------------------------------
-- Replace Admin/Manager FOR ALL (still on tables not split in 00009)
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admin/Manager write categories" ON categories;
CREATE POLICY "Admin Manager branch write categories" ON categories
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write recipes" ON recipes;
CREATE POLICY "Admin Manager branch write recipes" ON recipes
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write recipe_ingredients" ON recipe_ingredients;
CREATE POLICY "Admin Manager branch write recipe_ingredients" ON recipe_ingredients
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() = 'manager'
      AND EXISTS (
        SELECT 1 FROM recipes r
        WHERE r.id = recipe_ingredients.recipe_id
          AND public.branch_row_visible(r.branch_id)
      )
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() = 'manager'
      AND EXISTS (
        SELECT 1 FROM recipes r
        WHERE r.id = recipe_ingredients.recipe_id
          AND public.branch_row_visible(r.branch_id)
      )
    )
  );

DROP POLICY IF EXISTS "Admin/Manager write daily_consumption" ON daily_consumption;
CREATE POLICY "Admin Manager branch write daily_consumption" ON daily_consumption
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write menu_sections" ON menu_sections;
CREATE POLICY "Admin Manager branch write menu_sections" ON menu_sections
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write menu_items" ON menu_items;
CREATE POLICY "Admin Manager branch write menu_items" ON menu_items
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write waste_logs" ON waste_logs;
CREATE POLICY "Admin Manager branch write waste_logs" ON waste_logs
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write promotions" ON promotions;
CREATE POLICY "Admin Manager branch write promotions" ON promotions
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin/Manager write promotion_items" ON promotion_items;
CREATE POLICY "Admin Manager branch write promotion_items" ON promotion_items
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() = 'manager'
      AND EXISTS (
        SELECT 1 FROM promotions p
        WHERE p.id = promotion_items.promotion_id
          AND public.branch_row_visible(p.branch_id)
      )
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() = 'manager'
      AND EXISTS (
        SELECT 1 FROM promotions p
        WHERE p.id = promotion_items.promotion_id
          AND public.branch_row_visible(p.branch_id)
      )
    )
  );

-- ---------------------------------------------------------------------------
-- 00009: scope manager + purchasing_manager on procurement / stock / pricing
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admin Manager PM write purchase_orders" ON purchase_orders;
CREATE POLICY "Admin Manager PM branch write purchase_orders" ON purchase_orders
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write purchase_order_items" ON purchase_order_items;
CREATE POLICY "Admin Manager PM branch write purchase_order_items" ON purchase_order_items
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM purchase_orders po
        WHERE po.id = purchase_order_items.po_id
          AND public.branch_row_visible(po.branch_id)
      )
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM purchase_orders po
        WHERE po.id = purchase_order_items.po_id
          AND public.branch_row_visible(po.branch_id)
      )
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write suppliers" ON suppliers;
CREATE POLICY "Admin Manager PM branch write suppliers" ON suppliers
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write supplier_items" ON supplier_items;
CREATE POLICY "Admin Manager PM branch write supplier_items" ON supplier_items
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM suppliers s
        WHERE s.id = supplier_items.supplier_id
          AND public.branch_row_visible(s.branch_id)
      )
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM suppliers s
        WHERE s.id = supplier_items.supplier_id
          AND public.branch_row_visible(s.branch_id)
      )
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write stock_levels" ON stock_levels;
CREATE POLICY "Admin Manager PM branch write stock_levels" ON stock_levels
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write stock_transactions" ON stock_transactions;
CREATE POLICY "Admin Manager PM branch write stock_transactions" ON stock_transactions
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write pricing_config" ON pricing_config;
CREATE POLICY "Admin Manager PM branch write pricing_config" ON pricing_config
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write price_simulations" ON price_simulations;
CREATE POLICY "Admin Manager PM branch write price_simulations" ON price_simulations
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND public.branch_row_visible(branch_id)
    )
  );

DROP POLICY IF EXISTS "Admin Manager PM write simulation_overrides" ON simulation_overrides;
CREATE POLICY "Admin Manager PM branch write simulation_overrides" ON simulation_overrides
  FOR ALL TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM price_simulations ps
        WHERE ps.id = simulation_overrides.simulation_id
          AND public.branch_row_visible(ps.branch_id)
      )
    )
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (
      get_user_role() IN ('manager', 'purchasing_manager')
      AND EXISTS (
        SELECT 1 FROM price_simulations ps
        WHERE ps.id = simulation_overrides.simulation_id
          AND public.branch_row_visible(ps.branch_id)
      )
    )
  );

-- ---------------------------------------------------------------------------
-- 00009: inventory split policies — add branch to USING/WITH CHECK (admin unchanged)
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Admin Manager insert inventory_items" ON inventory_items;
CREATE POLICY "Admin Manager insert inventory_items" ON inventory_items
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin Manager update inventory_items" ON inventory_items;
CREATE POLICY "Admin Manager update inventory_items" ON inventory_items
  FOR UPDATE TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin Manager insert inventory_categories" ON inventory_categories;
CREATE POLICY "Admin Manager insert inventory_categories" ON inventory_categories
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

DROP POLICY IF EXISTS "Admin Manager update inventory_categories" ON inventory_categories;
CREATE POLICY "Admin Manager update inventory_categories" ON inventory_categories
  FOR UPDATE TO authenticated
  USING (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  )
  WITH CHECK (
    get_user_role() = 'admin'
    OR (get_user_role() = 'manager' AND public.branch_row_visible(branch_id))
  );

-- ---------------------------------------------------------------------------
-- Staff logging: item must be in an accessible branch; row.branch_id must match item.branch_id
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Staff can log consumption" ON daily_consumption;
CREATE POLICY "Staff can log consumption" ON daily_consumption
  FOR INSERT TO authenticated
  WITH CHECK (
    consumed_by = auth.uid()
    AND EXISTS (
      SELECT 1 FROM inventory_items ii
      WHERE ii.id = item_id
        AND public.branch_row_visible(ii.branch_id)
        AND branch_id IS NOT DISTINCT FROM ii.branch_id
    )
  );

DROP POLICY IF EXISTS "Staff can log waste" ON waste_logs;
CREATE POLICY "Staff can log waste" ON waste_logs
  FOR INSERT TO authenticated
  WITH CHECK (
    logged_by = auth.uid()
    AND EXISTS (
      SELECT 1 FROM inventory_items ii
      WHERE ii.id = item_id
        AND public.branch_row_visible(ii.branch_id)
        AND branch_id IS NOT DISTINCT FROM ii.branch_id
    )
  );

-- ---------------------------------------------------------------------------
-- Chef/bartender draft POs: branch must match user's access (default-branch rule included)
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "Staff insert purchase_orders" ON purchase_orders;
CREATE POLICY "Staff insert purchase_orders" ON purchase_orders
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND created_by = auth.uid()
    AND status = 'draft'
    AND public.branch_row_visible(branch_id)
  );

DROP POLICY IF EXISTS "Staff update own draft purchase_orders" ON purchase_orders;
CREATE POLICY "Staff update own draft purchase_orders" ON purchase_orders
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND created_by = auth.uid()
    AND status = 'draft'
    AND public.branch_row_visible(branch_id)
  )
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND created_by = auth.uid()
    AND public.branch_row_visible(branch_id)
  );

DROP POLICY IF EXISTS "Staff insert purchase_order_items" ON purchase_order_items;
CREATE POLICY "Staff insert purchase_order_items" ON purchase_order_items
  FOR INSERT TO authenticated
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
        AND public.branch_row_visible(po.branch_id)
    )
  );

DROP POLICY IF EXISTS "Staff update purchase_order_items draft PO" ON purchase_order_items;
CREATE POLICY "Staff update purchase_order_items draft PO" ON purchase_order_items
  FOR UPDATE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
        AND public.branch_row_visible(po.branch_id)
    )
  )
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
        AND public.branch_row_visible(po.branch_id)
    )
  );

DROP POLICY IF EXISTS "Staff delete purchase_order_items draft PO" ON purchase_order_items;
CREATE POLICY "Staff delete purchase_order_items draft PO" ON purchase_order_items
  FOR DELETE TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM purchase_orders po
      WHERE po.id = po_id
        AND po.created_by = auth.uid()
        AND po.status = 'draft'
        AND public.branch_row_visible(po.branch_id)
    )
  );
