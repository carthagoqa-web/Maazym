-- Menu sections aligned with MAAZYM MENU V02 (restaurant & coffee).
-- Replaces default seed sections for the main branch: clears menu item section links
-- so staff can re-assign items to the new PDF structure.

BEGIN;

UPDATE menu_items SET section_id = NULL
WHERE branch_id = '00000000-0000-0000-0000-000000000001'
  AND section_id IN (
    SELECT id FROM menu_sections WHERE branch_id = '00000000-0000-0000-0000-000000000001'
  );

UPDATE menu_sections
SET is_active = false
WHERE branch_id = '00000000-0000-0000-0000-000000000001';

INSERT INTO menu_sections (name_ar, name_en, sort_order, branch_id) VALUES
  ('المقبلات', 'Starters', 1, '00000000-0000-0000-0000-000000000001'),
  ('السلطات', 'Salads', 2, '00000000-0000-0000-0000-000000000001'),
  ('الشوربات', 'Soups', 3, '00000000-0000-0000-0000-000000000001'),
  ('البيتزا', 'Pizza', 4, '00000000-0000-0000-0000-000000000001'),
  ('المعكرونة', 'Pasta', 5, '00000000-0000-0000-0000-000000000001'),
  ('سندويشات متوسطية', 'Mediterranean Sandwiches', 6, '00000000-0000-0000-0000-000000000001'),
  ('الفطائر', 'Fatayer', 7, '00000000-0000-0000-0000-000000000001'),
  ('ركن المخبوزات', 'Bakery Corner', 8, '00000000-0000-0000-0000-000000000001'),
  ('الإفطار', 'Breakfast', 9, '00000000-0000-0000-0000-000000000001'),
  ('القهوة والمشروبات الساخنة', 'Coffee & Hot Drinks', 10, '00000000-0000-0000-0000-000000000001'),
  ('الشاي والمشروبات المميزة', 'Tea & Specialty', 11, '00000000-0000-0000-0000-000000000001'),
  ('المثلجات الكلاسيكية', 'The Iced Classics', 12, '00000000-0000-0000-0000-000000000001'),
  ('مشروبات باردة ومياه', 'Cold Drinks & Water', 13, '00000000-0000-0000-0000-000000000001'),
  ('الشيشة', 'Shisha', 14, '00000000-0000-0000-0000-000000000001'),
  ('مشروبات غازية ومياه', 'Soft Drinks & Water', 15, '00000000-0000-0000-0000-000000000001');

COMMIT;
