-- =============================================
-- MIGRATION: Tunisian/Mediterranean & Coffee Shop Items
-- Adds ~130 new food items to calorie_reference
-- Adds ~130 food + ~96 non-food items to preset_inventory_items
-- =============================================

-- =============================================
-- CALORIE_REFERENCE: Tunisian/Mediterranean Proteins
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Merguez sausage', 'مرقاز', 280.00, 'g', 'Proteins'),
  ('Lamb shoulder', 'كتف خروف', 282.00, 'g', 'Proteins'),
  ('Lamb shank', 'ساق خروف', 201.00, 'g', 'Proteins'),
  ('Lamb mince', 'لحم خروف مفروم', 283.00, 'g', 'Proteins'),
  ('Chicken wings', 'أجنحة دجاج', 203.00, 'g', 'Proteins'),
  ('Chicken liver', 'كبدة دجاج', 119.00, 'g', 'Proteins'),
  ('Sardines', 'سردين', 208.00, 'g', 'Proteins'),
  ('Anchovies', 'أنشوجة', 131.00, 'g', 'Proteins'),
  ('Mussels', 'بلح البحر', 86.00, 'g', 'Proteins'),
  ('Clams', 'محار', 74.00, 'g', 'Proteins'),
  ('Octopus', 'أخطبوط', 82.00, 'g', 'Proteins'),
  ('Snail/Babbouch', 'حلزون/ببوش', 90.00, 'g', 'Proteins'),
  ('Beef liver', 'كبدة بقر', 135.00, 'g', 'Proteins'),
  ('Lamb liver', 'كبدة خروف', 139.00, 'g', 'Proteins'),
  ('Rabbit', 'أرنب', 197.00, 'g', 'Proteins'),
  ('Quail', 'سمان', 134.00, 'g', 'Proteins'),
  ('Dried tuna/Qaddid', 'قديد', 268.00, 'g', 'Proteins');

-- =============================================
-- CALORIE_REFERENCE: Vegetables & Legumes
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Chickpeas dried', 'حمص مجفف', 364.00, 'g', 'Vegetables & Legumes'),
  ('Chickpeas canned', 'حمص معلب', 164.00, 'g', 'Vegetables & Legumes'),
  ('Lentils green', 'عدس أخضر', 352.00, 'g', 'Vegetables & Legumes'),
  ('Lentils red', 'عدس أحمر', 358.00, 'g', 'Vegetables & Legumes'),
  ('Broad beans dried', 'فول مجفف', 341.00, 'g', 'Vegetables & Legumes'),
  ('Broad beans fresh', 'فول أخضر', 88.00, 'g', 'Vegetables & Legumes'),
  ('White beans dried', 'فاصوليا بيضاء مجففة', 333.00, 'g', 'Vegetables & Legumes'),
  ('Turnip', 'لفت', 28.00, 'g', 'Vegetables & Legumes'),
  ('Fennel', 'شمر', 31.00, 'g', 'Vegetables & Legumes'),
  ('Swiss chard', 'سلق', 19.00, 'g', 'Vegetables & Legumes'),
  ('Mallow/Molokhia', 'ملوخية', 26.00, 'g', 'Vegetables & Legumes'),
  ('Preserved lemon', 'ليمون مخلل', 14.00, 'g', 'Vegetables & Legumes'),
  ('Sun-dried tomato', 'طماطم مجففة', 258.00, 'g', 'Vegetables & Legumes'),
  ('Capers', 'كبر', 23.00, 'g', 'Vegetables & Legumes'),
  ('Olives green', 'زيتون أخضر', 145.00, 'g', 'Vegetables & Legumes'),
  ('Olives black', 'زيتون أسود', 115.00, 'g', 'Vegetables & Legumes'),
  ('Artichoke hearts', 'قلوب خرشوف', 47.00, 'g', 'Vegetables & Legumes'),
  ('Hot green pepper', 'فلفل أخضر حار', 40.00, 'g', 'Vegetables & Legumes'),
  ('Dried chili pepper', 'فلفل مجفف', 282.00, 'g', 'Vegetables & Legumes'),
  ('Pumpkin', 'يقطين', 26.00, 'g', 'Vegetables & Legumes'),
  ('Celeriac', 'كرفس جذري', 42.00, 'g', 'Vegetables & Legumes'),
  ('Spring onion', 'بصل أخضر', 32.00, 'g', 'Vegetables & Legumes'),
  ('Dill', 'شبت', 43.00, 'g', 'Vegetables & Legumes'),
  ('Fresh coriander', 'كزبرة طازجة', 23.00, 'g', 'Vegetables & Legumes');

-- =============================================
-- CALORIE_REFERENCE: Tunisian/Mediterranean Spices & Seasonings
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Tabil spice', 'تابل', 280.00, 'g', 'Spices & Seasonings'),
  ('Ras el Hanout', 'رأس الحانوت', 250.00, 'g', 'Spices & Seasonings'),
  ('Caraway seeds', 'كراوية', 333.00, 'g', 'Spices & Seasonings'),
  ('Anise seeds', 'يانسون', 337.00, 'g', 'Spices & Seasonings'),
  ('Dried mint', 'نعناع مجفف', 285.00, 'g', 'Spices & Seasonings'),
  ('Dried rosemary', 'إكليل الجبل مجفف', 331.00, 'g', 'Spices & Seasonings'),
  ('Dried thyme', 'زعتر مجفف', 276.00, 'g', 'Spices & Seasonings'),
  ('Fennel seeds', 'بذور شمر', 345.00, 'g', 'Spices & Seasonings'),
  ('Fenugreek', 'حلبة', 323.00, 'g', 'Spices & Seasonings'),
  ('Nigella seeds', 'حبة البركة', 345.00, 'g', 'Spices & Seasonings'),
  ('Dried parsley', 'بقدونس مجفف', 292.00, 'g', 'Spices & Seasonings'),
  ('Garlic powder', 'بودرة ثوم', 331.00, 'g', 'Spices & Seasonings'),
  ('Onion powder', 'بودرة بصل', 341.00, 'g', 'Spices & Seasonings'),
  ('Cayenne pepper', 'فلفل كايين', 318.00, 'g', 'Spices & Seasonings'),
  ('White pepper', 'فلفل أبيض', 296.00, 'g', 'Spices & Seasonings'),
  ('Smoked paprika', 'بابريكا مدخنة', 282.00, 'g', 'Spices & Seasonings');

-- =============================================
-- CALORIE_REFERENCE: Sauces & Condiments (Harissa already exists)
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Shakshuka sauce', 'صلصة شكشوكة', 45.00, 'g', 'Sauces & Condiments'),
  ('Chermoula', 'شرمولة', 95.00, 'g', 'Sauces & Condiments'),
  ('Mechouia', 'مشوية', 50.00, 'g', 'Sauces & Condiments'),
  ('Slata tounsia', 'سلاطة تونسية', 55.00, 'g', 'Sauces & Condiments'),
  ('Tuna spread', 'سلاطة مشوية بالتن', 120.00, 'g', 'Sauces & Condiments'),
  ('Dijon mustard', 'خردل ديجون', 66.00, 'g', 'Sauces & Condiments'),
  ('Balsamic vinegar', 'خل بلسمي', 88.00, 'ml', 'Sauces & Condiments'),
  ('Red wine vinegar', 'خل أحمر', 19.00, 'ml', 'Sauces & Condiments'),
  ('Apple cider vinegar', 'خل تفاح', 22.00, 'ml', 'Sauces & Condiments'),
  ('Lemon juice', 'عصير ليمون', 22.00, 'ml', 'Sauces & Condiments'),
  ('Orange blossom water', 'ماء زهر البرتقال', 0.00, 'ml', 'Sauces & Condiments'),
  ('Pesto sauce', 'صلصة بيستو', 387.00, 'g', 'Sauces & Condiments'),
  ('Aioli', 'أيولي', 450.00, 'g', 'Sauces & Condiments');

-- =============================================
-- CALORIE_REFERENCE: Grains & Pasta
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Couscous fine', 'كسكس ناعم', 376.00, 'g', 'Grains & Carbs'),
  ('Couscous medium', 'كسكس وسط', 376.00, 'g', 'Grains & Carbs'),
  ('Mloukhia dried', 'ملوخية مجففة', 290.00, 'g', 'Grains & Carbs'),
  ('Semolina', 'سميد', 360.00, 'g', 'Grains & Carbs'),
  ('Spaghetti', 'سباغيتي', 371.00, 'g', 'Grains & Carbs'),
  ('Penne pasta', 'بيني', 371.00, 'g', 'Grains & Carbs'),
  ('Lasagna sheets', 'ألواح لازانيا', 371.00, 'g', 'Grains & Carbs'),
  ('Filo/Phyllo pastry', 'عجينة فيلو', 310.00, 'g', 'Grains & Carbs'),
  ('Brik/Spring roll pastry', 'أوراق بريك', 310.00, 'g', 'Grains & Carbs'),
  ('Pizza dough', 'عجينة بيتزا', 266.00, 'g', 'Grains & Carbs'),
  ('Tabbouleh mix', 'تبولة جاهزة', 340.00, 'g', 'Grains & Carbs'),
  ('Orzo pasta', 'لسان عصفور', 371.00, 'g', 'Grains & Carbs');

-- =============================================
-- CALORIE_REFERENCE: Coffee Shop Beverages
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Arabica coffee beans', 'حبوب قهوة عربية', 0.00, 'g', 'Beverages'),
  ('Robusta coffee beans', 'حبوب قهوة روبوستا', 0.00, 'g', 'Beverages'),
  ('Turkish coffee ground', 'قهوة تركية مطحونة', 0.00, 'g', 'Beverages'),
  ('Decaf coffee', 'قهوة منزوعة الكافيين', 0.00, 'g', 'Beverages'),
  ('Instant coffee', 'قهوة سريعة الذوبان', 2.00, 'g', 'Beverages'),
  ('Chai tea', 'شاي هندي', 1.00, 'ml', 'Beverages'),
  ('Earl Grey tea', 'شاي إيرل غراي', 1.00, 'ml', 'Beverages'),
  ('English Breakfast tea', 'شاي إنجليزي', 1.00, 'ml', 'Beverages'),
  ('Peppermint tea', 'شاي نعناع', 1.00, 'ml', 'Beverages'),
  ('Hibiscus tea', 'شاي كركديه', 0.00, 'ml', 'Beverages'),
  ('Rooibos tea', 'شاي رويبوس', 1.00, 'ml', 'Beverages'),
  ('Oat milk', 'حليب شوفان', 47.00, 'ml', 'Beverages'),
  ('Almond milk', 'حليب لوز', 17.00, 'ml', 'Beverages'),
  ('Coconut milk', 'حليب جوز الهند', 230.00, 'ml', 'Beverages'),
  ('Soy milk', 'حليب صويا', 33.00, 'ml', 'Beverages'),
  ('Whipped cream aerosol', 'كريمة رش', 257.00, 'g', 'Beverages'),
  ('Strawberry syrup', 'شراب فراولة', 260.00, 'ml', 'Beverages'),
  ('Rose syrup', 'شراب ورد', 260.00, 'ml', 'Beverages'),
  ('Lavender syrup', 'شراب لافندر', 260.00, 'ml', 'Beverages'),
  ('Gingerbread syrup', 'شراب جنجر', 260.00, 'ml', 'Beverages');

INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Coconut syrup', 'شراب جوز الهند', 260.00, 'ml', 'Beverages'),
  ('Toffee syrup', 'شراب توفي', 260.00, 'ml', 'Beverages'),
  ('White chocolate sauce', 'صلصة شوكولاتة بيضاء', 450.00, 'g', 'Beverages'),
  ('Chocolate sauce', 'صلصة شوكولاتة', 350.00, 'g', 'Beverages'),
  ('Chai concentrate', 'مركز شاي', 80.00, 'ml', 'Beverages'),
  ('Frozen yogurt base', 'قاعدة فروزن يوغرت', 127.00, 'g', 'Beverages'),
  ('Smoothie base mix', 'خليط سموذي', 300.00, 'g', 'Beverages'),
  ('Acai powder', 'بودرة أكاي', 534.00, 'g', 'Beverages'),
  ('Protein powder', 'بودرة بروتين', 400.00, 'g', 'Beverages'),
  ('Agave syrup', 'شراب أغاف', 310.00, 'ml', 'Beverages');

-- =============================================
-- CALORIE_REFERENCE: Bakery & Desserts
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Marzipan', 'مرصبان', 458.00, 'g', 'Bakery & Desserts'),
  ('Almond paste', 'عجينة لوز', 458.00, 'g', 'Bakery & Desserts'),
  ('Halva/Halwa', 'حلوى', 469.00, 'g', 'Bakery & Desserts'),
  ('Turkish delight/Lokum', 'راحة الحلقوم', 360.00, 'g', 'Bakery & Desserts'),
  ('Baklava syrup/Ater', 'قطر', 320.00, 'ml', 'Bakery & Desserts'),
  ('Phyllo cups', 'أكواب فيلو', 310.00, 'g', 'Bakery & Desserts'),
  ('Kaak/Sesame bread rings', 'كعك', 380.00, 'g', 'Bakery & Desserts'),
  ('Makroudh dates', 'مقروض', 390.00, 'g', 'Bakery & Desserts'),
  ('Samsa/Almond pastry', 'صمصة', 420.00, 'g', 'Bakery & Desserts'),
  ('Bambalouni/Donut mix', 'خليط بمبلوني', 350.00, 'g', 'Bakery & Desserts'),
  ('Assida mix', 'خليط عصيدة', 370.00, 'g', 'Bakery & Desserts'),
  ('Food coloring', 'ألوان طعام', 0.00, 'ml', 'Bakery & Desserts');

-- =============================================
-- CALORIE_REFERENCE: Additional Dairy & Cheese
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Ricotta cheese', 'جبنة ريكوتا', 174.00, 'g', 'Dairy'),
  ('Goat cheese', 'جبنة ماعز', 364.00, 'g', 'Dairy'),
  ('Blue cheese', 'جبنة زرقاء', 353.00, 'g', 'Dairy'),
  ('Brie cheese', 'جبنة بري', 334.00, 'g', 'Dairy'),
  ('Mascarpone', 'ماسكربوني', 429.00, 'g', 'Dairy'),
  ('Clotted cream', 'قشطة', 586.00, 'g', 'Dairy'),
  ('Sour cream', 'كريمة حامضة', 198.00, 'g', 'Dairy');

-- =============================================
-- CALORIE_REFERENCE: Additional Fruits & Dried Fruits
-- =============================================
INSERT INTO calorie_reference (name_en, name_ar, calories_per_unit, unit, category) VALUES
  ('Dried apricot', 'مشمش مجفف', 241.00, 'g', 'Fruits'),
  ('Dried cranberry', 'توت بري مجفف', 308.00, 'g', 'Fruits'),
  ('Raisins', 'زبيب', 299.00, 'g', 'Fruits'),
  ('Prunes', 'برقوق مجفف', 240.00, 'g', 'Fruits'),
  ('Mixed dried fruits', 'فواكه مجففة مشكلة', 270.00, 'g', 'Fruits'),
  ('Frozen berries mix', 'توت مجمد مشكل', 57.00, 'g', 'Fruits'),
  ('Frozen mango chunks', 'مانجو مجمدة', 60.00, 'g', 'Fruits'),
  ('Medjool dates', 'تمر مجهول', 277.00, 'g', 'Fruits'),
  ('Apricot', 'مشمش', 48.00, 'g', 'Fruits'),
  ('Plum', 'برقوق', 46.00, 'g', 'Fruits'),
  ('Cherry', 'كرز', 50.00, 'g', 'Fruits'),
  ('Grapefruit', 'جريب فروت', 42.00, 'g', 'Fruits');

-- =============================================
-- PRESET_INVENTORY_ITEMS: Tunisian/Mediterranean Proteins
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Merguez sausage', 'مرقاز', 'kg', 'Proteins', 280.00),
  ('Lamb shoulder', 'كتف خروف', 'kg', 'Proteins', 282.00),
  ('Lamb shank', 'ساق خروف', 'kg', 'Proteins', 201.00),
  ('Lamb mince', 'لحم خروف مفروم', 'kg', 'Proteins', 283.00),
  ('Chicken wings', 'أجنحة دجاج', 'kg', 'Proteins', 203.00),
  ('Chicken liver', 'كبدة دجاج', 'kg', 'Proteins', 119.00),
  ('Sardines', 'سردين', 'kg', 'Proteins', 208.00),
  ('Anchovies', 'أنشوجة', 'kg', 'Proteins', 131.00),
  ('Mussels', 'بلح البحر', 'kg', 'Proteins', 86.00),
  ('Clams', 'محار', 'kg', 'Proteins', 74.00),
  ('Octopus', 'أخطبوط', 'kg', 'Proteins', 82.00),
  ('Snail/Babbouch', 'حلزون/ببوش', 'kg', 'Proteins', 90.00),
  ('Beef liver', 'كبدة بقر', 'kg', 'Proteins', 135.00),
  ('Lamb liver', 'كبدة خروف', 'kg', 'Proteins', 139.00),
  ('Rabbit', 'أرنب', 'kg', 'Proteins', 197.00),
  ('Quail', 'سمان', 'piece', 'Proteins', 134.00),
  ('Dried tuna/Qaddid', 'قديد', 'kg', 'Proteins', 268.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Vegetables & Legumes
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Chickpeas dried', 'حمص مجفف', 'kg', 'Vegetables & Legumes', 364.00),
  ('Chickpeas canned', 'حمص معلب', 'can', 'Vegetables & Legumes', 164.00),
  ('Lentils green', 'عدس أخضر', 'kg', 'Vegetables & Legumes', 352.00),
  ('Lentils red', 'عدس أحمر', 'kg', 'Vegetables & Legumes', 358.00),
  ('Broad beans dried', 'فول مجفف', 'kg', 'Vegetables & Legumes', 341.00),
  ('Broad beans fresh', 'فول أخضر', 'kg', 'Vegetables & Legumes', 88.00),
  ('White beans dried', 'فاصوليا بيضاء مجففة', 'kg', 'Vegetables & Legumes', 333.00),
  ('Turnip', 'لفت', 'kg', 'Vegetables & Legumes', 28.00),
  ('Fennel', 'شمر', 'kg', 'Vegetables & Legumes', 31.00),
  ('Swiss chard', 'سلق', 'kg', 'Vegetables & Legumes', 19.00),
  ('Mallow/Molokhia', 'ملوخية', 'kg', 'Vegetables & Legumes', 26.00),
  ('Preserved lemon', 'ليمون مخلل', 'kg', 'Vegetables & Legumes', 14.00),
  ('Sun-dried tomato', 'طماطم مجففة', 'kg', 'Vegetables & Legumes', 258.00),
  ('Capers', 'كبر', 'kg', 'Vegetables & Legumes', 23.00),
  ('Olives green', 'زيتون أخضر', 'kg', 'Vegetables & Legumes', 145.00),
  ('Olives black', 'زيتون أسود', 'kg', 'Vegetables & Legumes', 115.00),
  ('Artichoke hearts', 'قلوب خرشوف', 'kg', 'Vegetables & Legumes', 47.00),
  ('Hot green pepper', 'فلفل أخضر حار', 'kg', 'Vegetables & Legumes', 40.00),
  ('Dried chili pepper', 'فلفل مجفف', 'kg', 'Vegetables & Legumes', 282.00),
  ('Pumpkin', 'يقطين', 'kg', 'Vegetables & Legumes', 26.00);

INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Celeriac', 'كرفس جذري', 'kg', 'Vegetables & Legumes', 42.00),
  ('Spring onion', 'بصل أخضر', 'kg', 'Vegetables & Legumes', 32.00),
  ('Dill', 'شبت', 'kg', 'Vegetables & Legumes', 43.00),
  ('Fresh coriander', 'كزبرة طازجة', 'kg', 'Vegetables & Legumes', 23.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Spices & Seasonings
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Tabil spice', 'تابل', 'g', 'Spices & Seasonings', 280.00),
  ('Ras el Hanout', 'رأس الحانوت', 'g', 'Spices & Seasonings', 250.00),
  ('Caraway seeds', 'كراوية', 'g', 'Spices & Seasonings', 333.00),
  ('Anise seeds', 'يانسون', 'g', 'Spices & Seasonings', 337.00),
  ('Dried mint', 'نعناع مجفف', 'g', 'Spices & Seasonings', 285.00),
  ('Dried rosemary', 'إكليل الجبل مجفف', 'g', 'Spices & Seasonings', 331.00),
  ('Dried thyme', 'زعتر مجفف', 'g', 'Spices & Seasonings', 276.00),
  ('Fennel seeds', 'بذور شمر', 'g', 'Spices & Seasonings', 345.00),
  ('Fenugreek', 'حلبة', 'g', 'Spices & Seasonings', 323.00),
  ('Nigella seeds', 'حبة البركة', 'g', 'Spices & Seasonings', 345.00),
  ('Dried parsley', 'بقدونس مجفف', 'g', 'Spices & Seasonings', 292.00),
  ('Garlic powder', 'بودرة ثوم', 'g', 'Spices & Seasonings', 331.00),
  ('Onion powder', 'بودرة بصل', 'g', 'Spices & Seasonings', 341.00),
  ('Cayenne pepper', 'فلفل كايين', 'g', 'Spices & Seasonings', 318.00),
  ('White pepper', 'فلفل أبيض', 'g', 'Spices & Seasonings', 296.00),
  ('Smoked paprika', 'بابريكا مدخنة', 'g', 'Spices & Seasonings', 282.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Sauces & Condiments
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Shakshuka sauce', 'صلصة شكشوكة', 'kg', 'Sauces & Condiments', 45.00),
  ('Chermoula', 'شرمولة', 'kg', 'Sauces & Condiments', 95.00),
  ('Mechouia', 'مشوية', 'kg', 'Sauces & Condiments', 50.00),
  ('Slata tounsia', 'سلاطة تونسية', 'kg', 'Sauces & Condiments', 55.00),
  ('Tuna spread', 'سلاطة مشوية بالتن', 'kg', 'Sauces & Condiments', 120.00),
  ('Dijon mustard', 'خردل ديجون', 'bottle', 'Sauces & Condiments', 66.00),
  ('Balsamic vinegar', 'خل بلسمي', 'bottle', 'Sauces & Condiments', 88.00),
  ('Red wine vinegar', 'خل أحمر', 'bottle', 'Sauces & Condiments', 19.00),
  ('Apple cider vinegar', 'خل تفاح', 'bottle', 'Sauces & Condiments', 22.00),
  ('Lemon juice', 'عصير ليمون', 'bottle', 'Sauces & Condiments', 22.00),
  ('Orange blossom water', 'ماء زهر البرتقال', 'bottle', 'Sauces & Condiments', 0.00),
  ('Pesto sauce', 'صلصة بيستو', 'bottle', 'Sauces & Condiments', 387.00),
  ('Aioli', 'أيولي', 'kg', 'Sauces & Condiments', 450.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Grains & Pasta
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Couscous fine', 'كسكس ناعم', 'kg', 'Grains & Carbs', 376.00),
  ('Couscous medium', 'كسكس وسط', 'kg', 'Grains & Carbs', 376.00),
  ('Mloukhia dried', 'ملوخية مجففة', 'kg', 'Grains & Carbs', 290.00),
  ('Semolina', 'سميد', 'kg', 'Grains & Carbs', 360.00),
  ('Spaghetti', 'سباغيتي', 'kg', 'Grains & Carbs', 371.00),
  ('Penne pasta', 'بيني', 'kg', 'Grains & Carbs', 371.00),
  ('Lasagna sheets', 'ألواح لازانيا', 'pack', 'Grains & Carbs', 371.00),
  ('Filo/Phyllo pastry', 'عجينة فيلو', 'pack', 'Grains & Carbs', 310.00),
  ('Brik/Spring roll pastry', 'أوراق بريك', 'pack', 'Grains & Carbs', 310.00),
  ('Pizza dough', 'عجينة بيتزا', 'kg', 'Grains & Carbs', 266.00),
  ('Tabbouleh mix', 'تبولة جاهزة', 'kg', 'Grains & Carbs', 340.00),
  ('Orzo pasta', 'لسان عصفور', 'kg', 'Grains & Carbs', 371.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Coffee Shop Beverages
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Arabica coffee beans', 'حبوب قهوة عربية', 'kg', 'Beverages', 0.00),
  ('Robusta coffee beans', 'حبوب قهوة روبوستا', 'kg', 'Beverages', 0.00),
  ('Turkish coffee ground', 'قهوة تركية مطحونة', 'kg', 'Beverages', 0.00),
  ('Decaf coffee', 'قهوة منزوعة الكافيين', 'kg', 'Beverages', 0.00),
  ('Instant coffee', 'قهوة سريعة الذوبان', 'kg', 'Beverages', 2.00),
  ('Chai tea', 'شاي هندي', 'kg', 'Beverages', 1.00),
  ('Earl Grey tea', 'شاي إيرل غراي', 'kg', 'Beverages', 1.00),
  ('English Breakfast tea', 'شاي إنجليزي', 'kg', 'Beverages', 1.00),
  ('Peppermint tea', 'شاي نعناع', 'kg', 'Beverages', 1.00),
  ('Hibiscus tea', 'شاي كركديه', 'kg', 'Beverages', 0.00),
  ('Rooibos tea', 'شاي رويبوس', 'kg', 'Beverages', 1.00),
  ('Oat milk', 'حليب شوفان', 'l', 'Beverages', 47.00),
  ('Almond milk', 'حليب لوز', 'l', 'Beverages', 17.00),
  ('Coconut milk', 'حليب جوز الهند', 'l', 'Beverages', 230.00),
  ('Soy milk', 'حليب صويا', 'l', 'Beverages', 33.00),
  ('Whipped cream aerosol', 'كريمة رش', 'can', 'Beverages', 257.00),
  ('Strawberry syrup', 'شراب فراولة', 'bottle', 'Beverages', 260.00),
  ('Rose syrup', 'شراب ورد', 'bottle', 'Beverages', 260.00),
  ('Lavender syrup', 'شراب لافندر', 'bottle', 'Beverages', 260.00),
  ('Gingerbread syrup', 'شراب جنجر', 'bottle', 'Beverages', 260.00);

INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Coconut syrup', 'شراب جوز الهند', 'bottle', 'Beverages', 260.00),
  ('Toffee syrup', 'شراب توفي', 'bottle', 'Beverages', 260.00),
  ('White chocolate sauce', 'صلصة شوكولاتة بيضاء', 'bottle', 'Beverages', 450.00),
  ('Chocolate sauce', 'صلصة شوكولاتة', 'bottle', 'Beverages', 350.00),
  ('Chai concentrate', 'مركز شاي', 'bottle', 'Beverages', 80.00),
  ('Frozen yogurt base', 'قاعدة فروزن يوغرت', 'kg', 'Beverages', 127.00),
  ('Smoothie base mix', 'خليط سموذي', 'kg', 'Beverages', 300.00),
  ('Acai powder', 'بودرة أكاي', 'kg', 'Beverages', 534.00),
  ('Protein powder', 'بودرة بروتين', 'kg', 'Beverages', 400.00),
  ('Agave syrup', 'شراب أغاف', 'bottle', 'Beverages', 310.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Bakery & Desserts
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Marzipan', 'مرصبان', 'kg', 'Bakery & Desserts', 458.00),
  ('Almond paste', 'عجينة لوز', 'kg', 'Bakery & Desserts', 458.00),
  ('Halva/Halwa', 'حلوى', 'kg', 'Bakery & Desserts', 469.00),
  ('Turkish delight/Lokum', 'راحة الحلقوم', 'kg', 'Bakery & Desserts', 360.00),
  ('Baklava syrup/Ater', 'قطر', 'bottle', 'Bakery & Desserts', 320.00),
  ('Phyllo cups', 'أكواب فيلو', 'pack', 'Bakery & Desserts', 310.00),
  ('Kaak/Sesame bread rings', 'كعك', 'kg', 'Bakery & Desserts', 380.00),
  ('Makroudh dates', 'مقروض', 'kg', 'Bakery & Desserts', 390.00),
  ('Samsa/Almond pastry', 'صمصة', 'kg', 'Bakery & Desserts', 420.00),
  ('Bambalouni/Donut mix', 'خليط بمبلوني', 'kg', 'Bakery & Desserts', 350.00),
  ('Assida mix', 'خليط عصيدة', 'kg', 'Bakery & Desserts', 370.00),
  ('Food coloring', 'ألوان طعام', 'bottle', 'Bakery & Desserts', 0.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Additional Dairy & Cheese
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Ricotta cheese', 'جبنة ريكوتا', 'kg', 'Dairy', 174.00),
  ('Goat cheese', 'جبنة ماعز', 'kg', 'Dairy', 364.00),
  ('Blue cheese', 'جبنة زرقاء', 'kg', 'Dairy', 353.00),
  ('Brie cheese', 'جبنة بري', 'kg', 'Dairy', 334.00),
  ('Mascarpone', 'ماسكربوني', 'kg', 'Dairy', 429.00),
  ('Clotted cream', 'قشطة', 'kg', 'Dairy', 586.00),
  ('Sour cream', 'كريمة حامضة', 'kg', 'Dairy', 198.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Additional Fruits & Dried Fruits
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Dried apricot', 'مشمش مجفف', 'kg', 'Fruits', 241.00),
  ('Dried cranberry', 'توت بري مجفف', 'kg', 'Fruits', 308.00),
  ('Raisins', 'زبيب', 'kg', 'Fruits', 299.00),
  ('Prunes', 'برقوق مجفف', 'kg', 'Fruits', 240.00),
  ('Mixed dried fruits', 'فواكه مجففة مشكلة', 'kg', 'Fruits', 270.00),
  ('Frozen berries mix', 'توت مجمد مشكل', 'kg', 'Fruits', 57.00),
  ('Frozen mango chunks', 'مانجو مجمدة', 'kg', 'Fruits', 60.00),
  ('Medjool dates', 'تمر مجهول', 'kg', 'Fruits', 277.00),
  ('Apricot', 'مشمش', 'kg', 'Fruits', 48.00),
  ('Plum', 'برقوق', 'kg', 'Fruits', 46.00),
  ('Cherry', 'كرز', 'kg', 'Fruits', 50.00),
  ('Grapefruit', 'جريب فروت', 'kg', 'Fruits', 42.00);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Cutlery (Supplies, NULL calories)
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Dinner fork', 'شوكة طعام', 'piece', 'Supplies', NULL),
  ('Dinner knife', 'سكين طعام', 'piece', 'Supplies', NULL),
  ('Dinner spoon', 'ملعقة طعام', 'piece', 'Supplies', NULL),
  ('Dessert fork', 'شوكة حلويات', 'piece', 'Supplies', NULL),
  ('Dessert spoon', 'ملعقة حلويات', 'piece', 'Supplies', NULL),
  ('Teaspoon', 'ملعقة شاي', 'piece', 'Supplies', NULL),
  ('Soup spoon', 'ملعقة شوربة', 'piece', 'Supplies', NULL),
  ('Steak knife', 'سكين ستيك', 'piece', 'Supplies', NULL),
  ('Butter knife', 'سكين زبدة', 'piece', 'Supplies', NULL),
  ('Fish knife', 'سكين سمك', 'piece', 'Supplies', NULL),
  ('Cake server', 'ملعقة كيك', 'piece', 'Supplies', NULL),
  ('Serving fork', 'شوكة تقديم', 'piece', 'Supplies', NULL),
  ('Serving spoon', 'ملعقة تقديم', 'piece', 'Supplies', NULL),
  ('Salad tongs', 'ملقط سلطة', 'piece', 'Supplies', NULL),
  ('Ice cream scoop', 'مغرفة آيس كريم', 'piece', 'Supplies', NULL),
  ('Ladle', 'مغرفة', 'piece', 'Supplies', NULL),
  ('Sugar tongs', 'ملقط سكر', 'piece', 'Supplies', NULL),
  ('Chopsticks', 'عيدان أكل', 'pack', 'Supplies', NULL);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Crockery & Glassware (Supplies, NULL calories)
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Dinner plate', 'طبق رئيسي', 'piece', 'Supplies', NULL),
  ('Side plate', 'طبق جانبي', 'piece', 'Supplies', NULL),
  ('Dessert plate', 'طبق حلويات', 'piece', 'Supplies', NULL),
  ('Bread plate', 'طبق خبز', 'piece', 'Supplies', NULL),
  ('Soup bowl', 'زبدية شوربة', 'piece', 'Supplies', NULL),
  ('Salad bowl', 'زبدية سلطة', 'piece', 'Supplies', NULL),
  ('Cereal bowl', 'زبدية حبوب', 'piece', 'Supplies', NULL),
  ('Serving platter', 'طبق تقديم كبير', 'piece', 'Supplies', NULL),
  ('Serving bowl large', 'زبدية تقديم كبيرة', 'piece', 'Supplies', NULL),
  ('Sauce dish/Ramekin', 'صحن صلصة', 'piece', 'Supplies', NULL),
  ('Gravy boat', 'إبريق صلصة', 'piece', 'Supplies', NULL),
  ('Tea cup', 'فنجان شاي', 'piece', 'Supplies', NULL),
  ('Tea saucer', 'صحن فنجان شاي', 'piece', 'Supplies', NULL),
  ('Coffee cup', 'فنجان قهوة', 'piece', 'Supplies', NULL),
  ('Espresso cup', 'فنجان إسبريسو', 'piece', 'Supplies', NULL),
  ('Espresso saucer', 'صحن إسبريسو', 'piece', 'Supplies', NULL),
  ('Cappuccino cup', 'فنجان كابتشينو', 'piece', 'Supplies', NULL),
  ('Latte glass', 'كوب لاتيه', 'piece', 'Supplies', NULL),
  ('Coffee mug', 'كوب قهوة', 'piece', 'Supplies', NULL),
  ('Water glass', 'كوب ماء', 'piece', 'Supplies', NULL);

INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Juice glass', 'كوب عصير', 'piece', 'Supplies', NULL),
  ('Tea glass/Istikan', 'كاسة شاي', 'piece', 'Supplies', NULL),
  ('Tumbler glass', 'كوب تمبلر', 'piece', 'Supplies', NULL),
  ('Shot glass', 'كوب شوت', 'piece', 'Supplies', NULL),
  ('Sugar bowl', 'سكرية', 'piece', 'Supplies', NULL),
  ('Cream jug', 'إبريق كريمة', 'piece', 'Supplies', NULL),
  ('Teapot', 'إبريق شاي', 'piece', 'Supplies', NULL),
  ('Coffee pot/Dallah', 'دلة قهوة', 'piece', 'Supplies', NULL),
  ('French press', 'فرنش بريس', 'piece', 'Supplies', NULL),
  ('Water pitcher/Jug', 'إبريق ماء', 'piece', 'Supplies', NULL),
  ('Salt shaker', 'مملحة', 'piece', 'Supplies', NULL),
  ('Pepper mill', 'مطحنة فلفل', 'piece', 'Supplies', NULL),
  ('Napkin holder', 'حامل مناديل', 'piece', 'Supplies', NULL),
  ('Bread basket', 'سلة خبز', 'piece', 'Supplies', NULL),
  ('Coaster', 'قاعدة أكواب', 'piece', 'Supplies', NULL);

-- =============================================
-- PRESET_INVENTORY_ITEMS: Kitchen Equipment & Supplies (NULL calories)
-- =============================================
INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Cutting board', 'لوح تقطيع', 'piece', 'Supplies', NULL),
  ('Chef knife', 'سكين شيف', 'piece', 'Supplies', NULL),
  ('Paring knife', 'سكين تقشير', 'piece', 'Supplies', NULL),
  ('Bread knife', 'سكين خبز', 'piece', 'Supplies', NULL),
  ('Sharpening steel', 'مبراة سكاكين', 'piece', 'Supplies', NULL),
  ('Mixing bowls', 'أوعية خلط', 'piece', 'Supplies', NULL),
  ('Measuring cups', 'أكواب قياس', 'piece', 'Supplies', NULL),
  ('Measuring spoons', 'ملاعق قياس', 'piece', 'Supplies', NULL),
  ('Whisk', 'مضرب بيض', 'piece', 'Supplies', NULL),
  ('Spatula', 'ملعقة مسطحة', 'piece', 'Supplies', NULL),
  ('Tongs', 'ملقط مطبخ', 'piece', 'Supplies', NULL),
  ('Peeler', 'مقشرة', 'piece', 'Supplies', NULL),
  ('Grater', 'مبشرة', 'piece', 'Supplies', NULL),
  ('Colander/Strainer', 'مصفاة', 'piece', 'Supplies', NULL),
  ('Sieve', 'غربال', 'piece', 'Supplies', NULL),
  ('Rolling pin', 'شوبك', 'piece', 'Supplies', NULL),
  ('Baking tray', 'صينية خبز', 'piece', 'Supplies', NULL),
  ('Muffin tray', 'صينية مافن', 'piece', 'Supplies', NULL),
  ('Cake mold', 'قالب كيك', 'piece', 'Supplies', NULL),
  ('Piping bags', 'أكياس تزيين', 'pack', 'Supplies', NULL);

INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('Parchment paper', 'ورق زبدة', 'piece', 'Supplies', NULL),
  ('Food wrap/Film', 'غلاف طعام', 'piece', 'Supplies', NULL),
  ('Coffee filter paper', 'فلتر قهوة', 'pack', 'Supplies', NULL),
  ('Espresso tamper', 'مكبس إسبريسو', 'piece', 'Supplies', NULL),
  ('Milk frothing jug', 'إبريق رغوة حليب', 'piece', 'Supplies', NULL),
  ('Cocktail shaker', 'شيكر', 'piece', 'Supplies', NULL),
  ('Blender cups', 'أكواب خلاط', 'piece', 'Supplies', NULL),
  ('Ice bucket', 'دلو ثلج', 'piece', 'Supplies', NULL),
  ('Tray/Serving tray', 'صينية تقديم', 'piece', 'Supplies', NULL),
  ('Menu holder', 'حامل قائمة', 'piece', 'Supplies', NULL),
  ('Table number stand', 'حامل أرقام طاولات', 'piece', 'Supplies', NULL),
  ('Bill holder', 'حامل فاتورة', 'piece', 'Supplies', NULL),
  ('Candle holder', 'حامل شموع', 'piece', 'Supplies', NULL),
  ('Flower vase', 'مزهرية', 'piece', 'Supplies', NULL),
  ('Tablecloth', 'مفرش طاولة', 'piece', 'Supplies', NULL),
  ('Cloth napkins', 'مناديل قماش', 'piece', 'Supplies', NULL),
  ('Placemat', 'قاعدة صحن', 'piece', 'Supplies', NULL),
  ('Uniform chef coat', 'معطف شيف', 'piece', 'Supplies', NULL),
  ('Waiter vest', 'صدرية نادل', 'piece', 'Supplies', NULL),
  ('Hairnet', 'شبكة شعر', 'pack', 'Supplies', NULL);

INSERT INTO preset_inventory_items (name_en, name_ar, default_unit, category, calories_per_unit) VALUES
  ('First aid kit', 'صندوق إسعافات أولية', 'piece', 'Supplies', NULL),
  ('Fire extinguisher', 'طفاية حريق', 'piece', 'Supplies', NULL),
  ('Pest control supplies', 'مستلزمات مكافحة حشرات', 'pack', 'Supplies', NULL);
