-- Seed data for local / initial setup (run after migrations).
-- Default branch UUID matches app fallback in settings.
-- Menu sections for the main branch come from migration 00004 (MAAZYM menu PDF).

INSERT INTO branches (id, name_ar, name_en, address) VALUES
  ('00000000-0000-0000-0000-000000000001', 'الفرع الرئيسي', 'Main Branch', 'Riyadh, Saudi Arabia')
ON CONFLICT (id) DO NOTHING;

INSERT INTO categories (name_ar, name_en, type, sort_order, branch_id)
SELECT v.name_ar, v.name_en, v.type::text, v.sort_order, v.branch_id::uuid
FROM (VALUES
  ('المقبلات', 'Appetizers', 'food', 1, '00000000-0000-0000-0000-000000000001'),
  ('السلطات', 'Salads', 'food', 2, '00000000-0000-0000-0000-000000000001'),
  ('الشوربات', 'Soups', 'food', 3, '00000000-0000-0000-0000-000000000001'),
  ('الأطباق الرئيسية', 'Main Courses', 'food', 4, '00000000-0000-0000-0000-000000000001'),
  ('الأطباق الجانبية', 'Side Dishes', 'food', 5, '00000000-0000-0000-0000-000000000001'),
  ('الحلويات', 'Desserts', 'food', 6, '00000000-0000-0000-0000-000000000001'),
  ('المشروبات الساخنة', 'Hot Drinks', 'beverage', 7, '00000000-0000-0000-0000-000000000001'),
  ('المشروبات الباردة', 'Cold Drinks', 'beverage', 8, '00000000-0000-0000-0000-000000000001'),
  ('الموكتيلات', 'Mocktails', 'beverage', 9, '00000000-0000-0000-0000-000000000001'),
  ('العصائر الطازجة', 'Fresh Juices', 'beverage', 10, '00000000-0000-0000-0000-000000000001')
) AS v(name_ar, name_en, type, sort_order, branch_id)
WHERE NOT EXISTS (
  SELECT 1 FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001' LIMIT 1
);

INSERT INTO inventory_categories (name_ar, name_en, sort_order, branch_id)
SELECT v.name_ar, v.name_en, v.sort_order, v.branch_id::uuid
FROM (VALUES
  ('البروتينات', 'Proteins', 1, '00000000-0000-0000-0000-000000000001'),
  ('الخضروات', 'Vegetables', 2, '00000000-0000-0000-0000-000000000001'),
  ('الفواكه', 'Fruits', 3, '00000000-0000-0000-0000-000000000001'),
  ('الألبان', 'Dairy', 4, '00000000-0000-0000-0000-000000000001'),
  ('الحبوب', 'Grains', 5, '00000000-0000-0000-0000-000000000001'),
  ('التوابل', 'Spices', 6, '00000000-0000-0000-0000-000000000001'),
  ('الزيوت', 'Oils & Fats', 7, '00000000-0000-0000-0000-000000000001'),
  ('المشروبات', 'Beverages', 8, '00000000-0000-0000-0000-000000000001'),
  ('المواد الجافة', 'Dry Goods', 9, '00000000-0000-0000-0000-000000000001'),
  ('المجمدات', 'Frozen', 10, '00000000-0000-0000-0000-000000000001'),
  ('المخبوزات', 'Bakery', 11, '00000000-0000-0000-0000-000000000001'),
  ('الصلصات', 'Sauces & Condiments', 12, '00000000-0000-0000-0000-000000000001'),
  ('مواد التعبئة', 'Packaging', 13, '00000000-0000-0000-0000-000000000001'),
  ('مواد التنظيف', 'Cleaning Supplies', 14, '00000000-0000-0000-0000-000000000001')
) AS v(name_ar, name_en, sort_order, branch_id)
WHERE NOT EXISTS (
  SELECT 1 FROM inventory_categories ic WHERE ic.branch_id = '00000000-0000-0000-0000-000000000001' LIMIT 1
);

INSERT INTO pricing_config (default_margin_percent, currency, tax_percent, branch_id) VALUES
  (65.00, 'QAR', 15.00, '00000000-0000-0000-0000-000000000001')
ON CONFLICT (branch_id) DO UPDATE SET
  default_margin_percent = EXCLUDED.default_margin_percent,
  currency = EXCLUDED.currency,
  tax_percent = EXCLUDED.tax_percent,
  updated_at = now();
