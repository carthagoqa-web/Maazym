-- =============================================
-- CALORIE REFERENCE TABLE
-- =============================================
CREATE TABLE calorie_reference (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_en TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  calories_per_unit DECIMAL(10,2) NOT NULL,
  unit TEXT NOT NULL CHECK (unit IN ('kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can')),
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_calorie_ref_name ON calorie_reference(name_en);

ALTER TABLE calorie_reference ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated read calorie_reference" ON calorie_reference FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admin/Manager write calorie_reference" ON calorie_reference FOR ALL USING (get_user_role() IN ('admin', 'manager'));

-- =============================================
-- ADD calories_per_unit TO inventory_items
-- =============================================
ALTER TABLE inventory_items ADD COLUMN calories_per_unit DECIMAL(10,2);

-- =============================================
-- PRESET INVENTORY ITEMS TABLE
-- =============================================
CREATE TABLE preset_inventory_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_en TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  default_unit TEXT NOT NULL CHECK (default_unit IN ('kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can')),
  category TEXT NOT NULL,
  calories_per_unit DECIMAL(10,2),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE preset_inventory_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated read preset_inventory_items" ON preset_inventory_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admin/Manager write preset_inventory_items" ON preset_inventory_items FOR ALL USING (get_user_role() IN ('admin', 'manager'));

-- =============================================
-- SEED: calorie_reference — Proteins (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Chicken breast', 'صدر دجاج', 165.00, 'g', 'Proteins'),
  ('Chicken thigh', 'فخذ دجاج', 209.00, 'g', 'Proteins'),
  ('Lamb', 'لحم ضأن', 294.00, 'g', 'Proteins'),
  ('Beef', 'لحم بقر', 250.00, 'g', 'Proteins'),
  ('Ground beef', 'لحم بقر مفروم', 332.00, 'g', 'Proteins'),
  ('Beef tenderloin', 'تندرلوين بقر', 252.00, 'g', 'Proteins'),
  ('Veal', 'لحم عجل', 172.00, 'g', 'Proteins'),
  ('Turkey breast', 'صدر ديك رومي', 135.00, 'g', 'Proteins'),
  ('Shrimp', 'روبيان', 99.00, 'g', 'Proteins'),
  ('Salmon', 'سلمون', 208.00, 'g', 'Proteins'),
  ('Tuna', 'تونة', 130.00, 'g', 'Proteins'),
  ('White fish (Hammour)', 'سمك هامور', 96.00, 'g', 'Proteins'),
  ('Sea bass', 'سمك باس', 97.00, 'g', 'Proteins'),
  ('Calamari/Squid', 'حبار', 92.00, 'g', 'Proteins'),
  ('Crab meat', 'لحم سلطعون', 97.00, 'g', 'Proteins'),
  ('Lobster', 'كركند', 89.00, 'g', 'Proteins'),
  ('Eggs', 'بيض', 155.00, 'g', 'Proteins');

-- =============================================
-- SEED: calorie_reference — Vegetables (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Tomato', 'طماطم', 18.00, 'g', 'Vegetables'),
  ('Cucumber', 'خيار', 15.00, 'g', 'Vegetables'),
  ('Onion', 'بصل', 40.00, 'g', 'Vegetables'),
  ('Garlic', 'ثوم', 149.00, 'g', 'Vegetables'),
  ('Potato', 'بطاطس', 77.00, 'g', 'Vegetables'),
  ('Sweet potato', 'بطاطا حلوة', 86.00, 'g', 'Vegetables'),
  ('Carrot', 'جزر', 41.00, 'g', 'Vegetables'),
  ('Bell pepper', 'فلفل رومي', 31.00, 'g', 'Vegetables'),
  ('Lettuce', 'خس', 15.00, 'g', 'Vegetables'),
  ('Spinach', 'سبانخ', 23.00, 'g', 'Vegetables'),
  ('Broccoli', 'بروكلي', 34.00, 'g', 'Vegetables'),
  ('Cauliflower', 'قرنبيط', 25.00, 'g', 'Vegetables'),
  ('Zucchini', 'كوسا', 17.00, 'g', 'Vegetables'),
  ('Eggplant', 'باذنجان', 25.00, 'g', 'Vegetables'),
  ('Mushroom', 'فطر', 22.00, 'g', 'Vegetables'),
  ('Corn', 'ذرة', 86.00, 'g', 'Vegetables'),
  ('Green beans', 'فاصوليا خضراء', 31.00, 'g', 'Vegetables'),
  ('Peas', 'بازلاء', 81.00, 'g', 'Vegetables'),
  ('Celery', 'كرفس', 14.00, 'g', 'Vegetables'),
  ('Parsley', 'بقدونس', 36.00, 'g', 'Vegetables'),
  ('Cilantro', 'كزبرة', 23.00, 'g', 'Vegetables'),
  ('Mint', 'نعناع', 44.00, 'g', 'Vegetables'),
  ('Arugula', 'جرجير', 25.00, 'g', 'Vegetables'),
  ('Cabbage', 'ملفوف', 25.00, 'g', 'Vegetables'),
  ('Radish', 'فجل', 16.00, 'g', 'Vegetables'),
  ('Avocado', 'أفوكادو', 160.00, 'g', 'Vegetables'),
  ('Jalapeño', 'هالابينو', 29.00, 'g', 'Vegetables'),
  ('Ginger', 'زنجبيل', 80.00, 'g', 'Vegetables'),
  ('Beetroot', 'شمندر', 43.00, 'g', 'Vegetables'),
  ('Asparagus', 'هليون', 20.00, 'g', 'Vegetables'),
  ('Artichoke', 'خرشوف', 47.00, 'g', 'Vegetables'),
  ('Okra', 'بامية', 33.00, 'g', 'Vegetables'),
  ('Leek', 'كراث', 61.00, 'g', 'Vegetables');

-- =============================================
-- SEED: calorie_reference — Fruits (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Lemon', 'ليمون', 29.00, 'g', 'Fruits'),
  ('Lime', 'ليمون أخضر', 30.00, 'g', 'Fruits'),
  ('Orange', 'برتقال', 47.00, 'g', 'Fruits'),
  ('Strawberry', 'فراولة', 32.00, 'g', 'Fruits'),
  ('Banana', 'موز', 89.00, 'g', 'Fruits'),
  ('Apple', 'تفاح', 52.00, 'g', 'Fruits'),
  ('Mango', 'مانجو', 60.00, 'g', 'Fruits'),
  ('Pineapple', 'أناناس', 50.00, 'g', 'Fruits'),
  ('Watermelon', 'بطيخ', 30.00, 'g', 'Fruits'),
  ('Grapes', 'عنب', 69.00, 'g', 'Fruits'),
  ('Pomegranate', 'رمان', 83.00, 'g', 'Fruits'),
  ('Date (Tamr)', 'تمر', 277.00, 'g', 'Fruits'),
  ('Fig', 'تين', 74.00, 'g', 'Fruits'),
  ('Coconut', 'جوز هند', 354.00, 'g', 'Fruits'),
  ('Kiwi', 'كيوي', 61.00, 'g', 'Fruits'),
  ('Peach', 'خوخ', 39.00, 'g', 'Fruits'),
  ('Blueberry', 'توت أزرق', 57.00, 'g', 'Fruits'),
  ('Raspberry', 'توت أحمر', 52.00, 'g', 'Fruits'),
  ('Passion fruit', 'فاكهة العاطفة', 97.00, 'g', 'Fruits'),
  ('Papaya', 'بابايا', 43.00, 'g', 'Fruits');

-- =============================================
-- SEED: calorie_reference — Dairy (per 100g/100ml)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Whole milk', 'حليب كامل الدسم', 61.00, 'ml', 'Dairy'),
  ('Skim milk', 'حليب خالي الدسم', 34.00, 'ml', 'Dairy'),
  ('Heavy cream', 'كريمة ثقيلة', 340.00, 'ml', 'Dairy'),
  ('Whipping cream', 'كريمة خفق', 292.00, 'ml', 'Dairy'),
  ('Butter', 'زبدة', 717.00, 'g', 'Dairy'),
  ('Cream cheese', 'جبنة كريمية', 342.00, 'g', 'Dairy'),
  ('Cheddar cheese', 'جبنة شيدر', 403.00, 'g', 'Dairy'),
  ('Mozzarella', 'جبنة موزاريلا', 280.00, 'g', 'Dairy'),
  ('Parmesan', 'جبنة بارميزان', 431.00, 'g', 'Dairy'),
  ('Feta cheese', 'جبنة فيتا', 264.00, 'g', 'Dairy'),
  ('Halloumi', 'جبنة حلوم', 321.00, 'g', 'Dairy'),
  ('Labneh', 'لبنة', 154.00, 'g', 'Dairy'),
  ('Yogurt plain', 'زبادي سادة', 59.00, 'g', 'Dairy'),
  ('Greek yogurt', 'زبادي يوناني', 97.00, 'g', 'Dairy'),
  ('Condensed milk', 'حليب مكثف', 321.00, 'ml', 'Dairy'),
  ('Evaporated milk', 'حليب مبخر', 134.00, 'ml', 'Dairy'),
  ('Akkawi cheese', 'جبنة عكاوي', 289.00, 'g', 'Dairy'),
  ('Kashkaval cheese', 'جبنة قشقوان', 377.00, 'g', 'Dairy');

-- =============================================
-- SEED: calorie_reference — Grains & Carbs (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('White rice (cooked)', 'أرز أبيض مطبوخ', 130.00, 'g', 'Grains & Carbs'),
  ('Basmati rice', 'أرز بسمتي', 121.00, 'g', 'Grains & Carbs'),
  ('Brown rice', 'أرز بني', 111.00, 'g', 'Grains & Carbs'),
  ('Pasta (cooked)', 'معكرونة مطبوخة', 131.00, 'g', 'Grains & Carbs'),
  ('Flour', 'دقيق', 364.00, 'g', 'Grains & Carbs'),
  ('Bread', 'خبز', 265.00, 'g', 'Grains & Carbs'),
  ('Pita bread', 'خبز عربي', 275.00, 'g', 'Grains & Carbs'),
  ('Tortilla', 'تورتيلا', 237.00, 'g', 'Grains & Carbs'),
  ('Oats', 'شوفان', 389.00, 'g', 'Grains & Carbs'),
  ('Couscous', 'كسكس', 112.00, 'g', 'Grains & Carbs'),
  ('Bulgur', 'برغل', 83.00, 'g', 'Grains & Carbs'),
  ('Freekeh', 'فريكة', 337.00, 'g', 'Grains & Carbs'),
  ('Quinoa', 'كينوا', 120.00, 'g', 'Grains & Carbs'),
  ('Cornstarch', 'نشا ذرة', 381.00, 'g', 'Grains & Carbs'),
  ('Breadcrumbs', 'بقسماط', 395.00, 'g', 'Grains & Carbs'),
  ('Vermicelli (Sha''riyya)', 'شعيرية', 360.00, 'g', 'Grains & Carbs');

-- =============================================
-- SEED: calorie_reference — Oils & Fats (per 100ml)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Olive oil', 'زيت زيتون', 884.00, 'ml', 'Oils & Fats'),
  ('Vegetable oil', 'زيت نباتي', 884.00, 'ml', 'Oils & Fats'),
  ('Sunflower oil', 'زيت عباد الشمس', 884.00, 'ml', 'Oils & Fats'),
  ('Sesame oil', 'زيت سمسم', 884.00, 'ml', 'Oils & Fats'),
  ('Coconut oil', 'زيت جوز الهند', 862.00, 'ml', 'Oils & Fats'),
  ('Ghee (Samneh)', 'سمن', 900.00, 'ml', 'Oils & Fats'),
  ('Tahini', 'طحينة', 595.00, 'g', 'Oils & Fats');

-- =============================================
-- SEED: calorie_reference — Spices & Seasonings (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Salt', 'ملح', 0.00, 'g', 'Spices & Seasonings'),
  ('Black pepper', 'فلفل أسود', 251.00, 'g', 'Spices & Seasonings'),
  ('Cumin', 'كمون', 375.00, 'g', 'Spices & Seasonings'),
  ('Paprika', 'بابريكا', 282.00, 'g', 'Spices & Seasonings'),
  ('Turmeric', 'كركم', 354.00, 'g', 'Spices & Seasonings'),
  ('Cinnamon', 'قرفة', 247.00, 'g', 'Spices & Seasonings'),
  ('Cardamom', 'هيل', 311.00, 'g', 'Spices & Seasonings'),
  ('Coriander ground', 'كزبرة مطحونة', 298.00, 'g', 'Spices & Seasonings'),
  ('Sumac', 'سماق', 244.00, 'g', 'Spices & Seasonings'),
  ('Za''atar', 'زعتر', 276.00, 'g', 'Spices & Seasonings'),
  ('Baharat', 'بهارات', 235.00, 'g', 'Spices & Seasonings'),
  ('Saffron', 'زعفران', 310.00, 'g', 'Spices & Seasonings'),
  ('Nutmeg', 'جوزة الطيب', 525.00, 'g', 'Spices & Seasonings'),
  ('Cloves', 'قرنفل', 274.00, 'g', 'Spices & Seasonings'),
  ('Dried oregano', 'أوريغانو مجفف', 265.00, 'g', 'Spices & Seasonings'),
  ('Dried basil', 'ريحان مجفف', 233.00, 'g', 'Spices & Seasonings'),
  ('Chili flakes', 'رقائق فلفل حار', 282.00, 'g', 'Spices & Seasonings'),
  ('Bay leaves', 'ورق غار', 313.00, 'g', 'Spices & Seasonings'),
  ('Vanilla extract', 'خلاصة فانيلا', 288.00, 'ml', 'Spices & Seasonings'),
  ('Rose water', 'ماء ورد', 0.00, 'ml', 'Spices & Seasonings');

-- =============================================
-- SEED: calorie_reference — Sauces & Condiments (per 100g/ml)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Tomato paste', 'معجون طماطم', 82.00, 'g', 'Sauces & Condiments'),
  ('Ketchup', 'كاتشب', 112.00, 'g', 'Sauces & Condiments'),
  ('Mayonnaise', 'مايونيز', 680.00, 'g', 'Sauces & Condiments'),
  ('Mustard', 'خردل', 66.00, 'g', 'Sauces & Condiments'),
  ('Soy sauce', 'صلصة صويا', 53.00, 'ml', 'Sauces & Condiments'),
  ('Hot sauce', 'صلصة حارة', 11.00, 'ml', 'Sauces & Condiments'),
  ('Worcestershire sauce', 'صلصة ورسيسترشاير', 78.00, 'ml', 'Sauces & Condiments'),
  ('Vinegar', 'خل', 18.00, 'ml', 'Sauces & Condiments'),
  ('Pomegranate molasses', 'دبس رمان', 250.00, 'ml', 'Sauces & Condiments'),
  ('Honey', 'عسل', 304.00, 'g', 'Sauces & Condiments'),
  ('Maple syrup', 'شراب القيقب', 260.00, 'ml', 'Sauces & Condiments'),
  ('Sugar', 'سكر', 387.00, 'g', 'Sauces & Condiments'),
  ('Brown sugar', 'سكر بني', 380.00, 'g', 'Sauces & Condiments'),
  ('Hummus', 'حمص', 166.00, 'g', 'Sauces & Condiments'),
  ('Baba ganoush', 'بابا غنوج', 130.00, 'g', 'Sauces & Condiments'),
  ('Tzatziki', 'تزاتزيكي', 66.00, 'g', 'Sauces & Condiments'),
  ('Harissa', 'هريسة', 70.00, 'g', 'Sauces & Condiments'),
  ('BBQ sauce', 'صلصة باربكيو', 172.00, 'g', 'Sauces & Condiments');

-- =============================================
-- SEED: calorie_reference — Nuts & Seeds (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Almonds', 'لوز', 579.00, 'g', 'Nuts & Seeds'),
  ('Walnuts', 'جوز', 654.00, 'g', 'Nuts & Seeds'),
  ('Cashews', 'كاجو', 553.00, 'g', 'Nuts & Seeds'),
  ('Pistachios', 'فستق', 560.00, 'g', 'Nuts & Seeds'),
  ('Pine nuts', 'صنوبر', 673.00, 'g', 'Nuts & Seeds'),
  ('Peanuts', 'فول سوداني', 567.00, 'g', 'Nuts & Seeds'),
  ('Sesame seeds', 'بذور سمسم', 573.00, 'g', 'Nuts & Seeds'),
  ('Sunflower seeds', 'بذور عباد الشمس', 584.00, 'g', 'Nuts & Seeds'),
  ('Chia seeds', 'بذور شيا', 486.00, 'g', 'Nuts & Seeds'),
  ('Flaxseeds', 'بذور كتان', 534.00, 'g', 'Nuts & Seeds'),
  ('Hazelnuts', 'بندق', 628.00, 'g', 'Nuts & Seeds'),
  ('Coconut flakes', 'رقائق جوز الهند', 660.00, 'g', 'Nuts & Seeds');

-- =============================================
-- SEED: calorie_reference — Beverages Base Ingredients (per 100g/100ml)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Coffee beans (brewed)', 'حبوب قهوة (مشروب)', 0.00, 'g', 'Beverages'),
  ('Espresso', 'إسبريسو', 2.00, 'ml', 'Beverages'),
  ('Tea', 'شاي', 1.00, 'ml', 'Beverages'),
  ('Cocoa powder', 'مسحوق كاكاو', 228.00, 'g', 'Beverages'),
  ('Chocolate syrup', 'شراب شوكولاتة', 279.00, 'ml', 'Beverages'),
  ('Vanilla syrup', 'شراب فانيلا', 260.00, 'ml', 'Beverages'),
  ('Caramel syrup', 'شراب كراميل', 270.00, 'ml', 'Beverages'),
  ('Hazelnut syrup', 'شراب بندق', 260.00, 'ml', 'Beverages'),
  ('Mint syrup', 'شراب نعناع', 265.00, 'ml', 'Beverages'),
  ('Matcha powder', 'مسحوق ماتشا', 324.00, 'g', 'Beverages'),
  ('Green tea', 'شاي أخضر', 1.00, 'ml', 'Beverages'),
  ('Chamomile tea', 'شاي بابونج', 1.00, 'ml', 'Beverages');

-- =============================================
-- SEED: calorie_reference — Bakery & Dessert Ingredients (per 100g)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Baking powder', 'بيكنج باودر', 53.00, 'g', 'Bakery & Desserts'),
  ('Baking soda', 'بيكنج صودا', 0.00, 'g', 'Bakery & Desserts'),
  ('Yeast', 'خميرة', 325.00, 'g', 'Bakery & Desserts'),
  ('Gelatin', 'جيلاتين', 335.00, 'g', 'Bakery & Desserts'),
  ('Whipped cream', 'كريمة مخفوقة', 257.00, 'g', 'Bakery & Desserts'),
  ('Chocolate chips', 'رقائق شوكولاتة', 535.00, 'g', 'Bakery & Desserts'),
  ('Dark chocolate', 'شوكولاتة داكنة', 598.00, 'g', 'Bakery & Desserts'),
  ('White chocolate', 'شوكولاتة بيضاء', 539.00, 'g', 'Bakery & Desserts'),
  ('Cocoa butter', 'زبدة كاكاو', 884.00, 'g', 'Bakery & Desserts'),
  ('Powdered sugar', 'سكر بودرة', 389.00, 'g', 'Bakery & Desserts');

-- =============================================
-- SEED: preset_inventory_items — Food items (from calorie_reference)
-- =============================================

-- Proteins
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Chicken breast', 'صدر دجاج', 'kg', 'Proteins', 165.00),
  ('Chicken thigh', 'فخذ دجاج', 'kg', 'Proteins', 209.00),
  ('Lamb', 'لحم ضأن', 'kg', 'Proteins', 294.00),
  ('Beef', 'لحم بقر', 'kg', 'Proteins', 250.00),
  ('Ground beef', 'لحم بقر مفروم', 'kg', 'Proteins', 332.00),
  ('Beef tenderloin', 'تندرلوين بقر', 'kg', 'Proteins', 252.00),
  ('Veal', 'لحم عجل', 'kg', 'Proteins', 172.00),
  ('Turkey breast', 'صدر ديك رومي', 'kg', 'Proteins', 135.00),
  ('Shrimp', 'روبيان', 'kg', 'Proteins', 99.00),
  ('Salmon', 'سلمون', 'kg', 'Proteins', 208.00),
  ('Tuna', 'تونة', 'kg', 'Proteins', 130.00),
  ('White fish (Hammour)', 'سمك هامور', 'kg', 'Proteins', 96.00),
  ('Sea bass', 'سمك باس', 'kg', 'Proteins', 97.00),
  ('Calamari/Squid', 'حبار', 'kg', 'Proteins', 92.00),
  ('Crab meat', 'لحم سلطعون', 'kg', 'Proteins', 97.00),
  ('Lobster', 'كركند', 'kg', 'Proteins', 89.00),
  ('Eggs', 'بيض', 'piece', 'Proteins', 78.00);

-- Vegetables
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Tomato', 'طماطم', 'kg', 'Vegetables', 18.00),
  ('Cucumber', 'خيار', 'kg', 'Vegetables', 15.00),
  ('Onion', 'بصل', 'kg', 'Vegetables', 40.00),
  ('Garlic', 'ثوم', 'kg', 'Vegetables', 149.00),
  ('Potato', 'بطاطس', 'kg', 'Vegetables', 77.00),
  ('Sweet potato', 'بطاطا حلوة', 'kg', 'Vegetables', 86.00),
  ('Carrot', 'جزر', 'kg', 'Vegetables', 41.00),
  ('Bell pepper', 'فلفل رومي', 'kg', 'Vegetables', 31.00),
  ('Lettuce', 'خس', 'kg', 'Vegetables', 15.00),
  ('Spinach', 'سبانخ', 'kg', 'Vegetables', 23.00),
  ('Broccoli', 'بروكلي', 'kg', 'Vegetables', 34.00),
  ('Cauliflower', 'قرنبيط', 'kg', 'Vegetables', 25.00),
  ('Zucchini', 'كوسا', 'kg', 'Vegetables', 17.00),
  ('Eggplant', 'باذنجان', 'kg', 'Vegetables', 25.00),
  ('Mushroom', 'فطر', 'kg', 'Vegetables', 22.00),
  ('Corn', 'ذرة', 'kg', 'Vegetables', 86.00),
  ('Green beans', 'فاصوليا خضراء', 'kg', 'Vegetables', 31.00),
  ('Peas', 'بازلاء', 'kg', 'Vegetables', 81.00),
  ('Celery', 'كرفس', 'kg', 'Vegetables', 14.00),
  ('Parsley', 'بقدونس', 'kg', 'Vegetables', 36.00),
  ('Cilantro', 'كزبرة', 'kg', 'Vegetables', 23.00),
  ('Mint', 'نعناع', 'kg', 'Vegetables', 44.00),
  ('Arugula', 'جرجير', 'kg', 'Vegetables', 25.00),
  ('Cabbage', 'ملفوف', 'kg', 'Vegetables', 25.00),
  ('Radish', 'فجل', 'kg', 'Vegetables', 16.00),
  ('Avocado', 'أفوكادو', 'kg', 'Vegetables', 160.00),
  ('Jalapeño', 'هالابينو', 'kg', 'Vegetables', 29.00),
  ('Ginger', 'زنجبيل', 'kg', 'Vegetables', 80.00),
  ('Beetroot', 'شمندر', 'kg', 'Vegetables', 43.00),
  ('Asparagus', 'هليون', 'kg', 'Vegetables', 20.00),
  ('Artichoke', 'خرشوف', 'kg', 'Vegetables', 47.00),
  ('Okra', 'بامية', 'kg', 'Vegetables', 33.00),
  ('Leek', 'كراث', 'kg', 'Vegetables', 61.00);

-- Fruits
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Lemon', 'ليمون', 'kg', 'Fruits', 29.00),
  ('Lime', 'ليمون أخضر', 'kg', 'Fruits', 30.00),
  ('Orange', 'برتقال', 'kg', 'Fruits', 47.00),
  ('Strawberry', 'فراولة', 'kg', 'Fruits', 32.00),
  ('Banana', 'موز', 'kg', 'Fruits', 89.00),
  ('Apple', 'تفاح', 'kg', 'Fruits', 52.00),
  ('Mango', 'مانجو', 'kg', 'Fruits', 60.00),
  ('Pineapple', 'أناناس', 'kg', 'Fruits', 50.00),
  ('Watermelon', 'بطيخ', 'kg', 'Fruits', 30.00),
  ('Grapes', 'عنب', 'kg', 'Fruits', 69.00),
  ('Pomegranate', 'رمان', 'kg', 'Fruits', 83.00),
  ('Date (Tamr)', 'تمر', 'kg', 'Fruits', 277.00),
  ('Fig', 'تين', 'kg', 'Fruits', 74.00),
  ('Coconut', 'جوز هند', 'piece', 'Fruits', 354.00),
  ('Kiwi', 'كيوي', 'kg', 'Fruits', 61.00),
  ('Peach', 'خوخ', 'kg', 'Fruits', 39.00),
  ('Blueberry', 'توت أزرق', 'kg', 'Fruits', 57.00),
  ('Raspberry', 'توت أحمر', 'kg', 'Fruits', 52.00),
  ('Passion fruit', 'فاكهة العاطفة', 'kg', 'Fruits', 97.00),
  ('Papaya', 'بابايا', 'kg', 'Fruits', 43.00);

-- Dairy
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Whole milk', 'حليب كامل الدسم', 'l', 'Dairy', 61.00),
  ('Skim milk', 'حليب خالي الدسم', 'l', 'Dairy', 34.00),
  ('Heavy cream', 'كريمة ثقيلة', 'l', 'Dairy', 340.00),
  ('Whipping cream', 'كريمة خفق', 'l', 'Dairy', 292.00),
  ('Butter', 'زبدة', 'kg', 'Dairy', 717.00),
  ('Cream cheese', 'جبنة كريمية', 'kg', 'Dairy', 342.00),
  ('Cheddar cheese', 'جبنة شيدر', 'kg', 'Dairy', 403.00),
  ('Mozzarella', 'جبنة موزاريلا', 'kg', 'Dairy', 280.00),
  ('Parmesan', 'جبنة بارميزان', 'kg', 'Dairy', 431.00),
  ('Feta cheese', 'جبنة فيتا', 'kg', 'Dairy', 264.00),
  ('Halloumi', 'جبنة حلوم', 'kg', 'Dairy', 321.00),
  ('Labneh', 'لبنة', 'kg', 'Dairy', 154.00),
  ('Yogurt plain', 'زبادي سادة', 'kg', 'Dairy', 59.00),
  ('Greek yogurt', 'زبادي يوناني', 'kg', 'Dairy', 97.00),
  ('Condensed milk', 'حليب مكثف', 'can', 'Dairy', 321.00),
  ('Evaporated milk', 'حليب مبخر', 'can', 'Dairy', 134.00),
  ('Akkawi cheese', 'جبنة عكاوي', 'kg', 'Dairy', 289.00),
  ('Kashkaval cheese', 'جبنة قشقوان', 'kg', 'Dairy', 377.00);

-- Grains & Carbs
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('White rice', 'أرز أبيض', 'kg', 'Grains & Carbs', 130.00),
  ('Basmati rice', 'أرز بسمتي', 'kg', 'Grains & Carbs', 121.00),
  ('Brown rice', 'أرز بني', 'kg', 'Grains & Carbs', 111.00),
  ('Pasta', 'معكرونة', 'kg', 'Grains & Carbs', 131.00),
  ('Flour', 'دقيق', 'kg', 'Grains & Carbs', 364.00),
  ('Bread', 'خبز', 'piece', 'Grains & Carbs', 265.00),
  ('Pita bread', 'خبز عربي', 'piece', 'Grains & Carbs', 275.00),
  ('Tortilla', 'تورتيلا', 'pack', 'Grains & Carbs', 237.00),
  ('Oats', 'شوفان', 'kg', 'Grains & Carbs', 389.00),
  ('Couscous', 'كسكس', 'kg', 'Grains & Carbs', 112.00),
  ('Bulgur', 'برغل', 'kg', 'Grains & Carbs', 83.00),
  ('Freekeh', 'فريكة', 'kg', 'Grains & Carbs', 337.00),
  ('Quinoa', 'كينوا', 'kg', 'Grains & Carbs', 120.00),
  ('Cornstarch', 'نشا ذرة', 'kg', 'Grains & Carbs', 381.00),
  ('Breadcrumbs', 'بقسماط', 'kg', 'Grains & Carbs', 395.00),
  ('Vermicelli (Sha''riyya)', 'شعيرية', 'kg', 'Grains & Carbs', 360.00);

-- Oils & Fats
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Olive oil', 'زيت زيتون', 'l', 'Oils & Fats', 884.00),
  ('Vegetable oil', 'زيت نباتي', 'l', 'Oils & Fats', 884.00),
  ('Sunflower oil', 'زيت عباد الشمس', 'l', 'Oils & Fats', 884.00),
  ('Sesame oil', 'زيت سمسم', 'l', 'Oils & Fats', 884.00),
  ('Coconut oil', 'زيت جوز الهند', 'l', 'Oils & Fats', 862.00),
  ('Ghee (Samneh)', 'سمن', 'kg', 'Oils & Fats', 900.00),
  ('Tahini', 'طحينة', 'kg', 'Oils & Fats', 595.00);

-- Spices & Seasonings
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Salt', 'ملح', 'kg', 'Spices & Seasonings', 0.00),
  ('Black pepper', 'فلفل أسود', 'kg', 'Spices & Seasonings', 251.00),
  ('Cumin', 'كمون', 'kg', 'Spices & Seasonings', 375.00),
  ('Paprika', 'بابريكا', 'kg', 'Spices & Seasonings', 282.00),
  ('Turmeric', 'كركم', 'kg', 'Spices & Seasonings', 354.00),
  ('Cinnamon', 'قرفة', 'kg', 'Spices & Seasonings', 247.00),
  ('Cardamom', 'هيل', 'kg', 'Spices & Seasonings', 311.00),
  ('Coriander ground', 'كزبرة مطحونة', 'kg', 'Spices & Seasonings', 298.00),
  ('Sumac', 'سماق', 'kg', 'Spices & Seasonings', 244.00),
  ('Za''atar', 'زعتر', 'kg', 'Spices & Seasonings', 276.00),
  ('Baharat', 'بهارات', 'kg', 'Spices & Seasonings', 235.00),
  ('Saffron', 'زعفران', 'g', 'Spices & Seasonings', 310.00),
  ('Nutmeg', 'جوزة الطيب', 'kg', 'Spices & Seasonings', 525.00),
  ('Cloves', 'قرنفل', 'kg', 'Spices & Seasonings', 274.00),
  ('Dried oregano', 'أوريغانو مجفف', 'kg', 'Spices & Seasonings', 265.00),
  ('Dried basil', 'ريحان مجفف', 'kg', 'Spices & Seasonings', 233.00),
  ('Chili flakes', 'رقائق فلفل حار', 'kg', 'Spices & Seasonings', 282.00),
  ('Bay leaves', 'ورق غار', 'kg', 'Spices & Seasonings', 313.00),
  ('Vanilla extract', 'خلاصة فانيلا', 'bottle', 'Spices & Seasonings', 288.00),
  ('Rose water', 'ماء ورد', 'bottle', 'Spices & Seasonings', 0.00);

-- Sauces & Condiments
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Tomato paste', 'معجون طماطم', 'can', 'Sauces & Condiments', 82.00),
  ('Ketchup', 'كاتشب', 'bottle', 'Sauces & Condiments', 112.00),
  ('Mayonnaise', 'مايونيز', 'bottle', 'Sauces & Condiments', 680.00),
  ('Mustard', 'خردل', 'bottle', 'Sauces & Condiments', 66.00),
  ('Soy sauce', 'صلصة صويا', 'bottle', 'Sauces & Condiments', 53.00),
  ('Hot sauce', 'صلصة حارة', 'bottle', 'Sauces & Condiments', 11.00),
  ('Worcestershire sauce', 'صلصة ورسيسترشاير', 'bottle', 'Sauces & Condiments', 78.00),
  ('Vinegar', 'خل', 'bottle', 'Sauces & Condiments', 18.00),
  ('Pomegranate molasses', 'دبس رمان', 'bottle', 'Sauces & Condiments', 250.00),
  ('Honey', 'عسل', 'kg', 'Sauces & Condiments', 304.00),
  ('Maple syrup', 'شراب القيقب', 'bottle', 'Sauces & Condiments', 260.00),
  ('Sugar', 'سكر', 'kg', 'Sauces & Condiments', 387.00),
  ('Brown sugar', 'سكر بني', 'kg', 'Sauces & Condiments', 380.00),
  ('Hummus', 'حمص', 'kg', 'Sauces & Condiments', 166.00),
  ('Baba ganoush', 'بابا غنوج', 'kg', 'Sauces & Condiments', 130.00),
  ('Tzatziki', 'تزاتزيكي', 'kg', 'Sauces & Condiments', 66.00),
  ('Harissa', 'هريسة', 'kg', 'Sauces & Condiments', 70.00),
  ('BBQ sauce', 'صلصة باربكيو', 'bottle', 'Sauces & Condiments', 172.00);

-- Nuts & Seeds
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Almonds', 'لوز', 'kg', 'Nuts & Seeds', 579.00),
  ('Walnuts', 'جوز', 'kg', 'Nuts & Seeds', 654.00),
  ('Cashews', 'كاجو', 'kg', 'Nuts & Seeds', 553.00),
  ('Pistachios', 'فستق', 'kg', 'Nuts & Seeds', 560.00),
  ('Pine nuts', 'صنوبر', 'kg', 'Nuts & Seeds', 673.00),
  ('Peanuts', 'فول سوداني', 'kg', 'Nuts & Seeds', 567.00),
  ('Sesame seeds', 'بذور سمسم', 'kg', 'Nuts & Seeds', 573.00),
  ('Sunflower seeds', 'بذور عباد الشمس', 'kg', 'Nuts & Seeds', 584.00),
  ('Chia seeds', 'بذور شيا', 'kg', 'Nuts & Seeds', 486.00),
  ('Flaxseeds', 'بذور كتان', 'kg', 'Nuts & Seeds', 534.00),
  ('Hazelnuts', 'بندق', 'kg', 'Nuts & Seeds', 628.00),
  ('Coconut flakes', 'رقائق جوز الهند', 'kg', 'Nuts & Seeds', 660.00);

-- Beverages
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Coffee beans', 'حبوب قهوة', 'kg', 'Beverages', 0.00),
  ('Espresso', 'إسبريسو', 'kg', 'Beverages', 2.00),
  ('Tea', 'شاي', 'kg', 'Beverages', 1.00),
  ('Cocoa powder', 'مسحوق كاكاو', 'kg', 'Beverages', 228.00),
  ('Chocolate syrup', 'شراب شوكولاتة', 'bottle', 'Beverages', 279.00),
  ('Vanilla syrup', 'شراب فانيلا', 'bottle', 'Beverages', 260.00),
  ('Caramel syrup', 'شراب كراميل', 'bottle', 'Beverages', 270.00),
  ('Hazelnut syrup', 'شراب بندق', 'bottle', 'Beverages', 260.00),
  ('Mint syrup', 'شراب نعناع', 'bottle', 'Beverages', 265.00),
  ('Matcha powder', 'مسحوق ماتشا', 'kg', 'Beverages', 324.00),
  ('Green tea', 'شاي أخضر', 'kg', 'Beverages', 1.00),
  ('Chamomile tea', 'شاي بابونج', 'kg', 'Beverages', 1.00);

-- Bakery & Desserts
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Baking powder', 'بيكنج باودر', 'kg', 'Bakery & Desserts', 53.00),
  ('Baking soda', 'بيكنج صودا', 'kg', 'Bakery & Desserts', 0.00),
  ('Yeast', 'خميرة', 'kg', 'Bakery & Desserts', 325.00),
  ('Gelatin', 'جيلاتين', 'kg', 'Bakery & Desserts', 335.00),
  ('Whipped cream', 'كريمة مخفوقة', 'l', 'Bakery & Desserts', 257.00),
  ('Chocolate chips', 'رقائق شوكولاتة', 'kg', 'Bakery & Desserts', 535.00),
  ('Dark chocolate', 'شوكولاتة داكنة', 'kg', 'Bakery & Desserts', 598.00),
  ('White chocolate', 'شوكولاتة بيضاء', 'kg', 'Bakery & Desserts', 539.00),
  ('Cocoa butter', 'زبدة كاكاو', 'kg', 'Bakery & Desserts', 884.00),
  ('Powdered sugar', 'سكر بودرة', 'kg', 'Bakery & Desserts', 389.00);

-- =============================================
-- SEED: preset_inventory_items — Non-food/Supplies (no calories)
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Paper napkins/Tissues', 'مناديل ورقية', 'pack', 'Supplies', NULL),
  ('Plastic cups', 'أكواب بلاستيكية', 'pack', 'Supplies', NULL),
  ('Paper cups', 'أكواب ورقية', 'pack', 'Supplies', NULL),
  ('Disposable spoons', 'ملاعق بلاستيكية', 'pack', 'Supplies', NULL),
  ('Disposable forks', 'شوك بلاستيكية', 'pack', 'Supplies', NULL),
  ('Disposable knives', 'سكاكين بلاستيكية', 'pack', 'Supplies', NULL),
  ('Plastic straws', 'شاليموه بلاستيكية', 'pack', 'Supplies', NULL),
  ('Paper straws', 'شاليموه ورقية', 'pack', 'Supplies', NULL),
  ('Takeaway containers', 'علب طعام للتوصيل', 'pack', 'Supplies', NULL),
  ('Aluminum foil', 'ورق ألمنيوم', 'piece', 'Supplies', NULL),
  ('Cling wrap/Plastic wrap', 'غلاف بلاستيكي', 'piece', 'Supplies', NULL),
  ('Garbage bags', 'أكياس نفايات', 'pack', 'Supplies', NULL),
  ('Dish soap/Detergent', 'سائل غسيل الأطباق', 'bottle', 'Supplies', NULL),
  ('Hand soap', 'صابون يد', 'bottle', 'Supplies', NULL),
  ('Sanitizer', 'معقم', 'bottle', 'Supplies', NULL),
  ('Kitchen gloves', 'قفازات مطبخ', 'pack', 'Supplies', NULL),
  ('Chef hats', 'قبعات طبخ', 'piece', 'Supplies', NULL),
  ('Aprons', 'مراييل', 'piece', 'Supplies', NULL),
  ('Gas cylinder', 'أسطوانة غاز', 'piece', 'Supplies', NULL),
  ('Charcoal', 'فحم', 'bag', 'Supplies', NULL),
  ('Toothpicks', 'أعواد أسنان', 'pack', 'Supplies', NULL),
  ('Cocktail sticks', 'أعواد كوكتيل', 'pack', 'Supplies', NULL),
  ('Paper bags', 'أكياس ورقية', 'pack', 'Supplies', NULL),
  ('Plastic bags', 'أكياس بلاستيكية', 'pack', 'Supplies', NULL);
