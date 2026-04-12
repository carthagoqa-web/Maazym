-- MAAZYM MENU V02: recipes + menu_items (kitchen & café). Excludes: Ice Cream, Shisha, Soft Drinks & Water retail.
-- Run after migrations 00001–00004. Requires inventory_items + categories + menu_sections for branch 00000000-0000-0000-0000-000000000001.
-- Ingredient rows only inserted when inventory_items.name_en matches.

BEGIN;

DELETE FROM recipe_ingredients WHERE recipe_id IN ('aaaaaaaa-0000-4000-8000-a00000000001'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000040'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000048'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000050'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000055'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid);
DELETE FROM menu_items WHERE id IN ('bbbbbbbb-0000-4000-8000-b00000000001'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000002'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000003'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000004'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000005'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000006'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000007'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000008'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000009'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000000f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000010'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000011'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000012'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000013'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000014'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000015'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000016'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000017'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000018'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000019'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000001f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000020'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000021'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000022'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000023'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000024'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000025'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000026'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000027'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000028'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000029'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000002f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000030'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000031'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000032'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000033'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000034'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000035'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000036'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000037'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000038'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000039'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000003f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000040'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000041'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000042'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000043'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000044'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000045'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000046'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000047'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000048'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000049'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000004f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000050'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000051'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000052'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000053'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000054'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000055'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000056'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000057'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000058'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000059'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005a'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005b'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005c'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005d'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005e'::uuid, 'bbbbbbbb-0000-4000-8000-b0000000005f'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000060'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000061'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000062'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000063'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000064'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000065'::uuid, 'bbbbbbbb-0000-4000-8000-b00000000066'::uuid);
DELETE FROM recipes WHERE id IN ('aaaaaaaa-0000-4000-8000-a00000000001'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000040'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000048'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000050'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000055'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid);

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, c.id, 'أصابع موزاريلا', 'Mozzarella Sticks', 'موزاريلا قليلة الرطوبة مغطاة بالطحين والبيض والبقسماط ومقلية؛ تقدم مع صلصة طماطم من المعجون والأعشاب.', 'Breaded low-moisture mozzarella, fried; tomato dip from paste and herbs (restaurant-style breading station).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Appetizers' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, c.id, 'أجنحة دجاج', 'Chicken Wings', 'أجنحة دجاج مقلية مع طلاء بنكهة باربيكيو أو بافلو (عسل وبابريكا ولمحة خل).', 'Fried wings with BBQ or buffalo-style glaze (honey, paprika, vinegar notes).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Appetizers' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, c.id, 'سبرينغ رول / بريك', 'Spring Rolls / Brik', 'عجينة مقرمشة بحشوة خضار أو لحم مفروم متبل (أسلوب بريك تونسي).', 'Crispy pastry with vegetables or seasoned minced meat (Tunisian brik-style).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Appetizers' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, c.id, 'بطاطس مقلية', 'French Fries', 'تُقطع البطاطس وتُقلى حتى يصبح لونها ذهبياً؛ يُرشّ عليها الملح.', 'Cut potatoes, fried golden; salt.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Appetizers' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, c.id, 'شرائح بطاطس', 'Potato Wedges', 'شرائح بطاطس سميكة متبلة، تُخبز في الفرن أو تُقلى في الزيت.', 'Thick-cut seasoned potato wedges, oven or fryer.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Appetizers' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, c.id, 'سلطة قيصر', 'Caesar Salad', 'خس على أسلوب الرومين مع بارميزان وقطع خبز محمص وصلصة قيصر (مايونيز وليمون وثوم).', 'Romaine-style on lettuce, parmesan, croutons, Caesar dressing (mayo-lemon-garlic).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Salads' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, c.id, 'سلطة بوراتا', 'Burrata Salad', 'بوراتا كريمية مع طماطم وزيت زيتون وقطرات خل بلسمي وريحان.', 'Creamy burrata with tomatoes, olive oil, balsamic drizzle, basil.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Salads' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, c.id, 'سلطة كابريزي', 'Caprese Salad', 'موزاريلا وطماطم وزيت زيتون ونكهة ريحان (ريحان مجفف).', 'Mozzarella, tomato, olive oil, fresh basil note (dried basil).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Salads' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, c.id, 'سلطة نيسواز', 'Niçoise Salad', 'تونة وبيض وزيتون وبطاطس وفاصوليا خضراء وخلّ بنكهة الفجت.', 'Tuna, eggs, olives, potato, green beans, vinaigrette.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Salads' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, c.id, 'شوربة تونسية', 'Tunisian Soup', 'شوربة طماطم وحمص مع معكرونة أورزو أو لؤلؤ والتوابل (هريسة اختياري).', 'Tomato-chickpea soup with orzo/pearl pasta and spices (harissa optional).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Soups' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, c.id, 'شوربة عدس', 'Lentil Soup', 'عدس أحمر مع بصل وجزر وكمون وزيت زيتون.', 'Red lentils with onion, carrot, cumin, olive oil.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Soups' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, c.id, 'شوربة دجاج وخضار', 'Chicken Veggie Soup', 'مرق دجاج من صدر الدجاج والخضار.', 'Chicken broth from breast and vegetables.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Soups' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, c.id, 'مارغريتا', 'Margherita', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, c.id, 'بيبروني', 'Pepperoni', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, c.id, 'خضار كثيرة', 'Very Veggie', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, c.id, 'دجاج رانش', 'Chicken Ranch', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, c.id, 'دجاج بيستو', 'Chicken Pesto', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, c.id, 'بيتزا بوراتا', 'Burrata Pizza', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, c.id, 'تونة وبصل', 'Tonno e Cipolla', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, c.id, 'أربع أجبان', 'Quattro Formaggi', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, c.id, 'ريجينا', 'Regina', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, c.id, 'فصول أربعة', 'Four Seasons', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, c.id, 'أمواج حارة', 'Hot Waves', 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, c.id, 'لازانيا بولونيز', 'Lasagna Bolognese', 'طبقات رقائق لازانيا مع راغو لحم بقري وبشاميل وموزاريلا.', 'Layers of pasta sheets, beef ragu, béchamel, mozzarella.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, c.id, 'لازانيا دجاج وخضار', 'Lasagna Chicken & Vegetable', 'دجاج وخضار موسمية مع صوص بشاميل وموزاريلا بين طبقات اللازانيا.', 'Chicken, seasonal vegetables, béchamel, mozzarella.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, c.id, 'لازانيا لحم مدخن', 'Smoked Ham Lasagna', 'طبقات لازانيا مع بديل حلال للحم الديك الرومي المدخّن وصوص أبيض وموزاريلا.', 'Layers with halal smoked turkey ham substitute, white sauce, mozzarella.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, c.id, 'بوتانيسكا', 'Puttanesca', 'سباغيتي مع طماطم وأنشوجة وزيتون وكبر وثوم.', 'Spaghetti with tomato, anchovies, olives, capers.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, c.id, 'بيني أرابياتا', 'Penne Arrabbiata', 'صلصة طماطم حارة بالثوم مع معكرونة بيني.', 'Spicy tomato-garlic sauce with penne.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, c.id, 'دجاج ألفريدو', 'Chicken Alfredo', 'صوص ألفريدو كريمي مع صدور دجاج مشوية (كريمة وزبدة وبارميزان).', 'Creamy Alfredo with grilled chicken (cream, butter, parmesan).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, c.id, 'بولونيز', 'Bolognese', 'راغو لحم بقري وطماطم يُطبخ على نار هادئة مع سباغيتي أو بيني.', 'Slow beef-tomato ragu with spaghetti or penne.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, c.id, 'مقلوب معاظم', 'Makloub Maazym', 'عجينة مطوية، دجاج أو لحم مشوي، سلطة، جبن، مايونيز.', 'Folded dough, grilled chicken or meat, salad, cheese, mayo.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, c.id, 'باجيت فارسي معاظم', 'Baguette Farcie Maazym', 'باجيت محشو بالبروتين والجبن والبطاطس المقلية داخل الخبز.', 'Stuffed baguette with protein, cheese, fries inside.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, c.id, 'تاكو فرنسي دجاج', 'French Tacos Chicken', 'تورتيلا ملفوفة بدجاج وبطاطس مقلية وصلصة جبن.', 'Tortilla wrap, chicken, fries, cheese sauce.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, c.id, 'تاكو فرنسي لحم', 'French Tacos Beef', 'تورتيلا ملفوفة بلحم مفروم وبطاطس مقلية وصلصة جبن.', 'Tortilla, minced beef, fries, cheese sauce.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, c.id, 'كورني معاظم', 'Cornet Maazym', 'خبز على شكل مخروط بحشوة دجاج حار وجبن.', 'Cone bread, spicy chicken filling, cheese.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, c.id, 'بانوتزو معاظم', 'Panuzzo Maazym', 'سندويش بخبز البيتزا مع موزاريلا ولحم وخضار.', 'Pizza-bread sandwich with mozzarella, meat, greens.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, c.id, 'سندويش كليا', 'Kleya Sandwich', 'مكعبات لحم مشوية مع فلفل وبصل وتوابل تونسية.', 'Sautéed meat cubes, peppers, onions, Tunisian spices.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, c.id, 'سندويش مدخن', 'Smoked Sandwich', 'جبن مدخن وديك رومي حلال وخس وصلصة.', 'Smoked cheese, halal turkey, lettuce, sauce.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, c.id, 'منقوشة جبن', 'Mankouch Cheese', 'خبز مسطح مع ذوبان أجبان عكاوي/موزاريلا.', 'Flatbread with akkawi/mozzarella melt.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, c.id, 'منقوشة زعتر', 'Mankouch Zaatar', 'خبز مسطح بخلطة زعتر وزيت زيتون.', 'Flatbread with zaatar mix and olive oil.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, c.id, 'منقوشة سبانخ', 'Mankouch Spinach', 'سبانخ وبصل وسماق وليمون.', 'Spinach, onion, sumac, lemon.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, c.id, 'منقوشة جبن وسبانخ', 'Mankouch Cheese & Spinach', 'سبانخ مع جبن ذائب على الخبز المسطح.', 'Spinach with melted cheese on flatbread.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, c.id, 'منقوشة لحم', 'Mankouch Meat', 'لحم مفروم وطماطم وبصل وتوابل.', 'Minced beef/lamb, tomato, onion, spices.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, c.id, 'كرواسون', 'Croissant', 'عجينة معجنات مدهونة بالزبدة على طبقات (كرواسان).', 'Laminated butter pastry.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, c.id, 'مافن', 'Muffin', 'مافن حلو (رقائق شوكولاتة / توت / فانيليا).', 'Sweet muffin (chocolate chips / berry / vanilla).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, c.id, 'كوكي', 'Cookie', 'كوكي برقائق الشوكولاتة.', 'Chocolate chip cookie.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, c.id, 'ميل في', 'Millefeuille', 'طبقات عجينة مقرمشة مع كريمة باتسيير.', 'Puff pastry layers with pastry cream.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, c.id, 'تشيز كيك', 'Cheesecake', 'حشوة جبن كريمي وقاعدة بسكويت وفاكهة فوقها.', 'Cream cheese filling, crust, fruit topping.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, c.id, 'بان كيك', 'Pancakes', 'بان كيك هشّ مع شراب القيقب وتوت.', 'Fluffy pancakes, maple, berries.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, c.id, 'بانا كوتا', 'Panna Cotta', 'كريمة محلاة تُثبت بالجيلاتين مع صلصة فواكه.', 'Sweetened cream set with gelatin, fruit coulis.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, c.id, 'سان سيباستيان', 'San Sebastian', 'تشيز كيك باسكي محروق السطح (جبن كريم وكريمة وبيض).', 'Burnt Basque-style cheesecake (cream cheese, cream, eggs).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, c.id, 'كريب', 'Crêpes', 'كريب رقيق مع شوكولاتة أو فاكهة.', 'Thin pancakes with chocolate or fruit.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, c.id, 'سلطة فواكه', 'Fruit Salad', 'مزيج فواكه طازجة موسمية.', 'Seasonal fresh fruit mix.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, c.id, 'جرانولا', 'Granola', 'شوفان ومكسرات وعسل؛ يُقدّم مع زبادي أو حليب.', 'Oats, nuts, honey; served with yogurt/milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, c.id, 'تيراميسو', 'Tiramisu', 'كريمة مسكربون وإسبريسو منقوع في إسفنجة (أو بديل خبز) وكاكاو.', 'Mascarpone cream, coffee-soaked sponge, cocoa.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Desserts' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, c.id, 'إفطار متوسطي', 'Mediterranean Breakfast', 'بيض وأجبان وزيتون وخبز ولبنة وسلطة.', 'Eggs, cheese, olives, bread, labneh, salad.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, c.id, 'إفطار كونتيننتال', 'Continental Breakfast', 'بيض وبديل نقانق لحم بقري حلال وبطاطس مهروسة وتوست وزبدة.', 'Eggs, halal beef sausage-style mince patty, potato hash, toast, butter.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, c.id, 'إفطار عربي', 'Arabic Breakfast', 'فول وأقراص حمص مقلية (فلافل) وحمص وبيض ومخللات وخبز بيتا.', 'Foul, falafel-style chickpea fritters, hummus, eggs, pickles, pita.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, c.id, 'إفطار أطفال', 'Kids Breakfast', 'بان كيك صغير وبيض مخفوق ومكوّنات عصير طازج.', 'Mini pancakes, scrambled eggs, fresh juice components.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Main Courses' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003c'::uuid, c.id, 'إسبريسو (١ أونصة)', 'Espresso (1 oz)', 'جرعة إسبريسو فردية؛ حوالي ٩–١٠ غ قهوة مطحونة مستخلصة.', 'Single espresso shot (~18–20 g liquid); ~9–10 g ground coffee in (typical double basket yield split).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003d'::uuid, c.id, 'إسبريسو مزدوج', 'Double Espresso (2 oz)', 'جرعتان إسبريسو؛ حوالي 18–20 غ قهوة مطحونة في الاستخلاص.', 'Two espresso shots; ~18–20 g coffee in.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, c.id, 'إسبريسو خاص', 'Special Espresso (1.5 oz)', 'إسبريسو مع حلاوة من الحليب المكثّف.', 'Espresso shot with condensed milk sweetness.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, c.id, 'ماكياتو', 'Macchiato (2 oz)', 'إسبريسو يُزيّن بحليب مزبد.', 'Espresso marked with foamed milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000040'::uuid, c.id, 'أمريكانو', 'Americano (8 oz)', 'إسبريسو ممدّد بماء ساخن.', 'Espresso diluted with hot water.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, c.id, 'فلات وايت', 'Flat White (7 oz)', 'إسبريسو مزدوج النكهة مع حليب مخملي.', 'Doubleristretto-style with velvety milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, c.id, 'كابتشينو', 'Cappuccino (8 oz)', 'إسبريسو وحليب مبخر ورغوة.', 'Espresso, steamed milk, foam cap.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, c.id, 'لاتيه', 'Latte (10 oz)', 'إسبريسو مع كمية أكبر من الحليب المبخر.', 'Espresso with more steamed milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, c.id, 'لاتيه ماتشا', 'Matcha Latte (10 oz)', 'مسحوق ماتشا مع حليب مبخر.', 'Matcha powder with steamed milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, c.id, 'لاتيه إسباني', 'Spanish Latte (10 oz)', 'إسبريسو وحليب وحليب مكثّف.', 'Espresso, milk, condensed milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, c.id, 'موكا لاتيه', 'Mocha Latte (10 oz)', 'إسبريسو وصلصة شوكولاتة وحليب مبخر.', 'Espresso, chocolate sauce, steamed milk.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, c.id, 'شوكولاتة ساخنة', 'Hot Chocolate (10 oz)', 'كاكاو وحليب وسكر.', 'Cocoa powder, milk, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000048'::uuid, c.id, 'قهوة V60', 'V60 Coffee (8.5 oz)', 'قهوة ترشيح يدوي V60.', 'Pour-over filter coffee (manual brew).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, c.id, 'قهوة تركية', 'Turkish Coffee (3 oz)', 'قهوة مطحونة ناعمة مع ماء وسكر اختياري.', 'Fine-ground coffee, water, optional sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, c.id, 'شاي تونسي بالنعناع', 'Tunisian Mint Tea (7 oz)', 'شاي أخضر ونعناع طازج وسكر.', 'Green tea, fresh mint, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, c.id, 'شاي باللوز/البندق', 'Tea w/ Almonds/Hazelnut (7.5 oz)', 'شاي بالنعناع مع مكسرات محمصة.', 'Mint tea with toasted nuts.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, c.id, 'شاي مغربي', 'Moroccan Mint Tea (7 oz)', 'شاي أخضر قوي مع نعناع.', 'Strong green tea with mint.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, c.id, 'شاي نكهات', 'Flavors Tea (8 oz)', 'شاي فواكه أو أعشاب (تشكيلة).', 'Fruit or herbal tea selection.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, c.id, 'شاي بقلاوة معاظم', 'Maazym Baklawa Tea (8 oz)', 'شاي مميز بنكهات العسل والمكسرات والقرفة.', 'Signature spiced tea with honey-nut notes.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Hot Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004f'::uuid, c.id, 'V60 مثلج', 'Iced V60 (10 oz)', 'قهوة ترشيح باردة على الثلج.', 'Cold filtered coffee over ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000050'::uuid, c.id, 'أمريكانو مثلج', 'Iced Americano (11 oz)', 'إسبريسو وماء بارد وثلج.', 'Espresso + cold water + ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, c.id, 'لاتيه مثلج', 'Iced Latte (12 oz)', 'إسبريسو وحليب بارد وثلج.', 'Espresso, chilled milk, ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, c.id, 'لاتيه إسباني مثلج', 'Iced Spanish Latte (12 oz)', 'إسبريسو وحليب مكثّف وحليب بارد وثلج.', 'Espresso, condensed milk, cold milk, ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, c.id, 'موكا مثلج', 'Iced Mocha Latte (12 oz)', 'إسبريسو وشوكولاتة وحليب وثلج.', 'Espresso, chocolate, milk, ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, c.id, 'ماتشا مثلج', 'Iced Matcha Latte (12 oz)', 'ماتشا وحليب وثلج.', 'Matcha, milk, ice.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000055'::uuid, c.id, 'شراب إضافي', 'Extra Syrup (1 oz)', 'مضخة شراب فانيليا أو كراميل أو بندق.', 'Vanilla, caramel, or hazelnut pump.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, c.id, 'مشروب معاظم مخصص', 'Maazym Customized Drink (12 oz)', 'مشروب مخصّص حسب ذوق الضيف (قاعدة + شراب + حليب).', 'House blend to guest preference (base + syrup + milk).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, c.id, 'موهيتو كلاسيكي', 'Classic Mojito (14 oz)', 'ليمون ونعناع وخليط صودا وسكر.', 'Lime, mint, soda-style mixer, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, c.id, 'موهيتو فراولة', 'Strawberry Mojito (14 oz)', 'فراولة وليمون ونعناع وسكر.', 'Strawberry, lime, mint, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, c.id, 'موهيتو مانجو', 'Mango Mojito (14 oz)', 'مانجو وليمون ونعناع وسكر.', 'Mango, lime, mint, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, c.id, 'موهيتو فاكهة العاطفة', 'Passion Fruit Mojito (14 oz)', 'فاكهة الباشن وليمون ونعناع وسكر.', 'Passion fruit, lime, mint, sugar.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, c.id, 'ليمونادة تونسية', 'Tunisian Lemonade (12 oz)', 'ليمون ونعناع وماء زهر.', 'Lemon, mint, orange blossom water.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Fresh Juices' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, c.id, 'عصير طازج معاظم', 'Fresh Juice Maazym (12 oz)', 'مزيج فواكه طازجة موسمية.', 'Seasonal fresh fruit blend.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Fresh Juices' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, c.id, 'ميلك شيك فانيليا', 'Vanilla Milkshake (14 oz)', 'حليب وشراب فانيليا وقاعدة زبادي مجمّد.', 'Milk, vanilla syrup, frozen yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, c.id, 'ميلك شيك شوكولاتة', 'Chocolate Milkshake (14 oz)', 'حليب وصلصة شوكولاتة وقاعدة زبادي مجمّد.', 'Milk, chocolate sauce, frozen yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, c.id, 'ميلك شيك فراولة', 'Strawberry Milkshake (14 oz)', 'حليب وفراولة طازجة وقاعدة زبادي مجمّد.', 'Milk, fresh strawberry, frozen yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, c.id, 'ميلك شيك مانجو', 'Mango Milkshake (14 oz)', 'حليب ومانجو وقاعدة زبادي مجمّد.', 'Milk, mango, frozen yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, c.id, 'ميلك شيك أناناس', 'Pineapple Milkshake (14 oz)', 'حليب وأناناس وقاعدة زبادي مجمّد.', 'Milk, pineapple, frozen yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, c.id, 'بينيا كولادا', 'Piña Colada (14 oz)', 'أناناس وحليب جوز الهند وثلج مجروش (مزيج).', 'Pineapple, coconut milk, crushed ice blend.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, c.id, 'غروب استوائي', 'Tropical Sunset (14 oz)', 'برتقال وأناناس ومانجو وشراب بنكهة غرينادين.', 'Orange, pineapple, grenadine-style syrup, mango.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Mocktails' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, c.id, 'مشروب بوبا', 'Boba Drink (16 oz)', 'قاعدة شاي وحليب وشراب كراميل (حبات التابيوكا اختيارية تجارياً).', 'Tea base, milk, caramel syrup (tapioca pearls optional retail).', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, c.id, 'جواجم معاظم', 'Jwajem Maazym (15 oz)', 'فواكه مشكّلة وكريمة ومكسرات وعسل.', 'Mixed fruit, cream, nuts, honey.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid, c.id, 'سموذي معاظم', 'Smoothie Maazym (14 oz)', 'فواكه مجمّدة مخلوطة مع قاعدة زبادي.', 'Blended frozen fruit with yogurt base.', '00000000-0000-0000-0000-000000000001'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND c.name_en = 'Cold Drinks' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.09, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 1.5, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Breadcrumbs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried basil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.12, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.35, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken wings' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.15, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.005, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoked paprika' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Honey' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.015, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.08, 'pack'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Brik/Spring roll pastry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Carrot' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 1, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.1, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, ii.id, 0.35, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ii.id, 0.4, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ii.id, 0.12, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoked paprika' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lettuce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Parmesan' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.04, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.01, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ii.id, 0.001, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.04, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.025, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.01, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Balsamic vinegar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried basil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.03, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried basil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ii.id, 0.001, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tuna' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives black' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Green beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lettuce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.025, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.01, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dijon mustard' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.25, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.2, 'can'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chickpeas canned' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orzo pasta' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cumin' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lentils red' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Carrot' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cumin' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.015, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Carrot' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Celery' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoked paprika' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bell pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.07, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mushroom' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives black' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pesto sauce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arugula' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ii.id, 0.03, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tuna' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives black' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Parmesan' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Blue cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Feta cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Turkey breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mushroom' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Artichoke hearts' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mushroom' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives black' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Turkey breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Hot green pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cayenne pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.15, 'pack'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lasagna sheets' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.25, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.15, 'pack'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lasagna sheets' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bell pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.07, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mushroom' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.035, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.028, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.15, 'pack'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lasagna sheets' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Turkey breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.006, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoked paprika' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.14, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.14, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Spaghetti' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Anchovies' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives black' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Capers' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.04, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Penne pasta' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Hot green pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.035, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried oregano' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.13, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Spaghetti' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Parmesan' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.16, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Spaghetti' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.28, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato paste' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Carrot' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.03, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lettuce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 0.1, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tortilla' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.1, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.08, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tortilla' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.11, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sunflower oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.08, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 1, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chicken breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cayenne pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lettuce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arugula' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lamb mince' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bell pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tabil spice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ii.id, 0.03, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Turkey breast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 0.005, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoked paprika' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lettuce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mayonnaise' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Akkawi cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mozzarella' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Dried thyme' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sesame seeds' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, ii.id, 0.035, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Spinach' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ii.id, 0.015, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ii.id, 0.025, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ii.id, 0.16, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Spinach' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Akkawi cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ii.id, 0.012, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ii.id, 0.025, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.16, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pizza dough' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Onion' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cumin' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ii.id, 0.025, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.06, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.008, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Yeast' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.5, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 1, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.08, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate chips' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ii.id, 0.004, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Baking powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate chips' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.5, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ii.id, 0.003, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Vanilla extract' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 0.12, 'pack'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Filo/Phyllo pastry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 0.25, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 0.22, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cream cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 1.5, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 0.05, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.2, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.04, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Maple syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ii.id, 0.008, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Gelatin' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ii.id, 0.005, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Vanilla extract' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ii.id, 0.28, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cream cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ii.id, 0.12, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate sauce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orange' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mango' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pineapple' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Honey' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ii.id, 0.005, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Oats' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Honey' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Almonds' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, ii.id, 0.2, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mascarpone' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Espresso' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cocoa powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ii.id, 0.06, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Feta cheese' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olives green' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Labneh' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tomato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cucumber' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Olive oil' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Ground beef' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Potato' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Salt' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Black pepper' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.4, 'can'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chickpeas canned' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Hummus' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 3, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pita bread' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cucumber' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Tahini' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.01, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Garlic' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ii.id, 0.003, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cumin' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Flour' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 0.1, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 2, 'piece'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Eggs' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Butter' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orange' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003c'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003d'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, ii.id, 0.025, 'can'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Condensed milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, ii.id, 0.06, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000040'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, ii.id, 0.024, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, ii.id, 0.16, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Matcha powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, ii.id, 0.24, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, ii.id, 0.03, 'can'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Condensed milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, ii.id, 0.035, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate sauce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, ii.id, 0.2, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cocoa powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, ii.id, 0.28, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000048'::uuid, ii.id, 0.028, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Turkish coffee ground' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, ii.id, 0.008, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Green tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ii.id, 0.008, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Green tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Almonds' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Hazelnuts' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Green tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Hibiscus tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chai tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Honey' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pistachios' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, ii.id, 0.002, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Cinnamon' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000004f'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000050'::uuid, ii.id, 0.024, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, ii.id, 0.03, 'can'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Condensed milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, ii.id, 0.022, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, ii.id, 0.035, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate sauce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, ii.id, 0.2, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, ii.id, 0.014, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Matcha powder' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, ii.id, 0.24, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000055'::uuid, ii.id, 0.03, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Vanilla syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, ii.id, 0.018, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Arabica coffee beans' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, ii.id, 0.18, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, ii.id, 0.015, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Vanilla syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lime' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, ii.id, 0.03, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lime' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mango' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lime' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Passion fruit' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lime' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, ii.id, 0.012, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, ii.id, 0.05, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Lemon juice' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, ii.id, 0.04, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, ii.id, 0.01, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mint' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, ii.id, 0.005, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orange blossom water' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, ii.id, 0.25, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orange' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Carrot' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Apple' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, ii.id, 0.04, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Vanilla syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen yogurt base' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, ii.id, 0.06, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Chocolate sauce' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen yogurt base' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen yogurt base' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mango' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen yogurt base' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, ii.id, 0.22, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, ii.id, 0.18, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pineapple' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen yogurt base' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, ii.id, 0.2, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pineapple' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, ii.id, 0.12, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Coconut milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, ii.id, 0.02, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Sugar' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, ii.id, 0.15, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Orange' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Pineapple' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mango' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, ii.id, 0.015, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Rose syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, ii.id, 0.008, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'English Breakfast tea' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, ii.id, 0.2, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, ii.id, 0.02, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Caramel syrup' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Mango' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.08, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Strawberry' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.08, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Heavy cream' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.025, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Honey' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Almonds' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ii.id, 0.015, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Walnuts' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid, ii.id, 0.1, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Smoothie base mix' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid, ii.id, 0.12, 'kg'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Frozen berries mix' AND ii.is_active = true
LIMIT 1;

INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid, ii.id, 0.15, 'l'
FROM inventory_items ii
WHERE ii.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ii.name_en = 'Whole milk' AND ii.is_active = true
LIMIT 1;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000001'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000001'::uuid, ms.id, 'أصابع موزاريلا', 'Mozzarella Sticks', 20, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Starters' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000002'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000002'::uuid, ms.id, 'أجنحة دجاج', 'Chicken Wings', 25, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Starters' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000003'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000003'::uuid, ms.id, 'سبرينغ رول / بريك', 'Spring Rolls / Brik', 15, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Starters' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000004'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000004'::uuid, ms.id, 'بطاطس مقلية', 'French Fries', 12, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Starters' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000005'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000005'::uuid, ms.id, 'شرائح بطاطس', 'Potato Wedges', 15, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Starters' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000006'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000006'::uuid, ms.id, 'سلطة قيصر', 'Caesar Salad', 20, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Salads' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000007'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000007'::uuid, ms.id, 'سلطة بوراتا', 'Burrata Salad', 25, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Salads' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000008'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000008'::uuid, ms.id, 'سلطة كابريزي', 'Caprese Salad', 25, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Salads' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000009'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000009'::uuid, ms.id, 'سلطة نيسواز', 'Niçoise Salad', 22, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Salads' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000a'::uuid, ms.id, 'شوربة تونسية', 'Tunisian Soup', 15, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Soups' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000b'::uuid, ms.id, 'شوربة عدس', 'Lentil Soup', 12, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Soups' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000c'::uuid, ms.id, 'شوربة دجاج وخضار', 'Chicken Veggie Soup', 12, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Soups' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000d'::uuid, ms.id, 'مارغريتا', 'Margherita', 25, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000e'::uuid, ms.id, 'بيبروني', 'Pepperoni', 28, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000000f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000000f'::uuid, ms.id, 'خضار كثيرة', 'Very Veggie', 25, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000010'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000010'::uuid, ms.id, 'دجاج رانش', 'Chicken Ranch', 30, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000011'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000011'::uuid, ms.id, 'دجاج بيستو', 'Chicken Pesto', 30, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000012'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000012'::uuid, ms.id, 'بيتزا بوراتا', 'Burrata Pizza', 40, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000013'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000013'::uuid, ms.id, 'تونة وبصل', 'Tonno e Cipolla', 28, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000014'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000014'::uuid, ms.id, 'أربع أجبان', 'Quattro Formaggi', 40, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000015'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000015'::uuid, ms.id, 'ريجينا', 'Regina', 30, true, 9, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000016'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000016'::uuid, ms.id, 'فصول أربعة', 'Four Seasons', 38, true, 10, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000017'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000017'::uuid, ms.id, 'أمواج حارة', 'Hot Waves', 32, true, 11, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pizza' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000018'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000018'::uuid, ms.id, 'لازانيا بولونيز', 'Lasagna Bolognese', 25, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000019'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000019'::uuid, ms.id, 'لازانيا دجاج وخضار', 'Lasagna Chicken & Vegetable', 25, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001a'::uuid, ms.id, 'لازانيا لحم مدخن', 'Smoked Ham Lasagna', 25, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001b'::uuid, ms.id, 'بوتانيسكا', 'Puttanesca', 25, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001c'::uuid, ms.id, 'بيني أرابياتا', 'Penne Arrabbiata', 22, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001d'::uuid, ms.id, 'دجاج ألفريدو', 'Chicken Alfredo', 28, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001e'::uuid, ms.id, 'بولونيز', 'Bolognese', 30, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Pasta' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000001f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000001f'::uuid, ms.id, 'مقلوب معاظم', 'Makloub Maazym', 26, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000020'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000020'::uuid, ms.id, 'باجيت فارسي معاظم', 'Baguette Farcie Maazym', 30, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000021'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000021'::uuid, ms.id, 'تاكو فرنسي دجاج', 'French Tacos Chicken', 25, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000022'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000022'::uuid, ms.id, 'تاكو فرنسي لحم', 'French Tacos Beef', 28, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000023'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000023'::uuid, ms.id, 'كورني معاظم', 'Cornet Maazym', 25, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000024'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000024'::uuid, ms.id, 'بانوتزو معاظم', 'Panuzzo Maazym', 25, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000025'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000025'::uuid, ms.id, 'سندويش كليا', 'Kleya Sandwich', 25, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000026'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000026'::uuid, ms.id, 'سندويش مدخن', 'Smoked Sandwich', 25, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Mediterranean Sandwiches' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000027'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000027'::uuid, ms.id, 'منقوشة جبن', 'Mankouch Cheese', 14, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Fatayer' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000028'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000028'::uuid, ms.id, 'منقوشة زعتر', 'Mankouch Zaatar', 12, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Fatayer' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000029'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000029'::uuid, ms.id, 'منقوشة سبانخ', 'Mankouch Spinach', 16, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Fatayer' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002a'::uuid, ms.id, 'منقوشة جبن وسبانخ', 'Mankouch Cheese & Spinach', 18, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Fatayer' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002b'::uuid, ms.id, 'منقوشة لحم', 'Mankouch Meat', 18, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Fatayer' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002c'::uuid, ms.id, 'كرواسون', 'Croissant', 10, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002d'::uuid, ms.id, 'مافن', 'Muffin', 10, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002e'::uuid, ms.id, 'كوكي', 'Cookie', 10, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000002f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000002f'::uuid, ms.id, 'ميل في', 'Millefeuille', 20, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000030'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000030'::uuid, ms.id, 'تشيز كيك', 'Cheesecake', 20, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000031'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000031'::uuid, ms.id, 'بان كيك', 'Pancakes', 15, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000032'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000032'::uuid, ms.id, 'بانا كوتا', 'Panna Cotta', 15, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000033'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000033'::uuid, ms.id, 'سان سيباستيان', 'San Sebastian', 20, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000034'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000034'::uuid, ms.id, 'كريب', 'Crêpes', 18, true, 9, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000035'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000035'::uuid, ms.id, 'سلطة فواكه', 'Fruit Salad', 18, true, 10, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000036'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000036'::uuid, ms.id, 'جرانولا', 'Granola', 15, true, 11, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000037'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000037'::uuid, ms.id, 'تيراميسو', 'Tiramisu', 18, true, 12, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Bakery Corner' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000038'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000038'::uuid, ms.id, 'إفطار متوسطي', 'Mediterranean Breakfast', 50, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Breakfast' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000039'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000039'::uuid, ms.id, 'إفطار كونتيننتال', 'Continental Breakfast', 70, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Breakfast' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003a'::uuid, ms.id, 'إفطار عربي', 'Arabic Breakfast', 50, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Breakfast' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003b'::uuid, ms.id, 'إفطار أطفال', 'Kids Breakfast', 25, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Breakfast' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003c'::uuid, ms.id, 'إسبريسو (١ أونصة)', 'Espresso (1 oz)', 12, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003d'::uuid, ms.id, 'إسبريسو مزدوج', 'Double Espresso (2 oz)', 16, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003e'::uuid, ms.id, 'إسبريسو خاص', 'Special Espresso (1.5 oz)', 16, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000003f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000003f'::uuid, ms.id, 'ماكياتو', 'Macchiato (2 oz)', 14, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000040'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000040'::uuid, ms.id, 'أمريكانو', 'Americano (8 oz)', 16, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000041'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000041'::uuid, ms.id, 'فلات وايت', 'Flat White (7 oz)', 18, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000042'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000042'::uuid, ms.id, 'كابتشينو', 'Cappuccino (8 oz)', 18, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000043'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000043'::uuid, ms.id, 'لاتيه', 'Latte (10 oz)', 18, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000044'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000044'::uuid, ms.id, 'لاتيه ماتشا', 'Matcha Latte (10 oz)', 20, true, 9, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000045'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000045'::uuid, ms.id, 'لاتيه إسباني', 'Spanish Latte (10 oz)', 20, true, 10, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000046'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000046'::uuid, ms.id, 'موكا لاتيه', 'Mocha Latte (10 oz)', 20, true, 11, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000047'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000047'::uuid, ms.id, 'شوكولاتة ساخنة', 'Hot Chocolate (10 oz)', 18, true, 12, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000048'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000048'::uuid, ms.id, 'قهوة V60', 'V60 Coffee (8.5 oz)', 20, true, 13, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000049'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000049'::uuid, ms.id, 'قهوة تركية', 'Turkish Coffee (3 oz)', 14, true, 14, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Coffee & Hot Drinks' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004a'::uuid, ms.id, 'شاي تونسي بالنعناع', 'Tunisian Mint Tea (7 oz)', 10, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Tea & Specialty' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004b'::uuid, ms.id, 'شاي باللوز/البندق', 'Tea w/ Almonds/Hazelnut (7.5 oz)', 16, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Tea & Specialty' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004c'::uuid, ms.id, 'شاي مغربي', 'Moroccan Mint Tea (7 oz)', 16, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Tea & Specialty' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004d'::uuid, ms.id, 'شاي نكهات', 'Flavors Tea (8 oz)', 12, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Tea & Specialty' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004e'::uuid, ms.id, 'شاي بقلاوة معاظم', 'Maazym Baklawa Tea (8 oz)', 22, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Tea & Specialty' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000004f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000004f'::uuid, ms.id, 'V60 مثلج', 'Iced V60 (10 oz)', 20, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000050'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000050'::uuid, ms.id, 'أمريكانو مثلج', 'Iced Americano (11 oz)', 16, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000051'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000051'::uuid, ms.id, 'لاتيه مثلج', 'Iced Latte (12 oz)', 18, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000052'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000052'::uuid, ms.id, 'لاتيه إسباني مثلج', 'Iced Spanish Latte (12 oz)', 20, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000053'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000053'::uuid, ms.id, 'موكا مثلج', 'Iced Mocha Latte (12 oz)', 20, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000054'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000054'::uuid, ms.id, 'ماتشا مثلج', 'Iced Matcha Latte (12 oz)', 20, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000055'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000055'::uuid, ms.id, 'شراب إضافي', 'Extra Syrup (1 oz)', 3, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000056'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000056'::uuid, ms.id, 'مشروب معاظم مخصص', 'Maazym Customized Drink (12 oz)', 25, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'The Iced Classics' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000057'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000057'::uuid, ms.id, 'موهيتو كلاسيكي', 'Classic Mojito (14 oz)', 20, true, 1, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000058'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000058'::uuid, ms.id, 'موهيتو فراولة', 'Strawberry Mojito (14 oz)', 22, true, 2, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000059'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000059'::uuid, ms.id, 'موهيتو مانجو', 'Mango Mojito (14 oz)', 22, true, 3, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005a'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005a'::uuid, ms.id, 'موهيتو فاكهة العاطفة', 'Passion Fruit Mojito (14 oz)', 22, true, 4, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005b'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005b'::uuid, ms.id, 'ليمونادة تونسية', 'Tunisian Lemonade (12 oz)', 15, true, 5, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005c'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005c'::uuid, ms.id, 'عصير طازج معاظم', 'Fresh Juice Maazym (12 oz)', 18, true, 6, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005d'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005d'::uuid, ms.id, 'ميلك شيك فانيليا', 'Vanilla Milkshake (14 oz)', 25, true, 7, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005e'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005e'::uuid, ms.id, 'ميلك شيك شوكولاتة', 'Chocolate Milkshake (14 oz)', 25, true, 8, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b0000000005f'::uuid, 'aaaaaaaa-0000-4000-8000-a0000000005f'::uuid, ms.id, 'ميلك شيك فراولة', 'Strawberry Milkshake (14 oz)', 25, true, 9, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000060'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000060'::uuid, ms.id, 'ميلك شيك مانجو', 'Mango Milkshake (14 oz)', 25, true, 10, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000061'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000061'::uuid, ms.id, 'ميلك شيك أناناس', 'Pineapple Milkshake (14 oz)', 25, true, 11, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000062'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000062'::uuid, ms.id, 'بينيا كولادا', 'Piña Colada (14 oz)', 25, true, 12, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000063'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000063'::uuid, ms.id, 'غروب استوائي', 'Tropical Sunset (14 oz)', 25, true, 13, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000064'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000064'::uuid, ms.id, 'مشروب بوبا', 'Boba Drink (16 oz)', 25, true, 14, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000065'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000065'::uuid, ms.id, 'جواجم معاظم', 'Jwajem Maazym (15 oz)', 25, true, 15, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT 'bbbbbbbb-0000-4000-8000-b00000000066'::uuid, 'aaaaaaaa-0000-4000-8000-a00000000066'::uuid, ms.id, 'سموذي معاظم', 'Smoothie Maazym (14 oz)', 25, true, 16, '00000000-0000-0000-0000-000000000001'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '00000000-0000-0000-0000-000000000001'::uuid AND ms.name_en = 'Cold Drinks & Water' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

COMMIT;
