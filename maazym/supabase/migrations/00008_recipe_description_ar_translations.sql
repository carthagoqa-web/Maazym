-- Arabic preparation descriptions (matches description_en). UPDATE only; keeps images and IDs.
-- Apply after 00005–00007 if recipes already exist with English-only descriptions.

BEGIN;

UPDATE recipes SET description_ar = 'موزاريلا قليلة الرطوبة مغطاة بالطحين والبيض والبقسماط ومقلية؛ تقدم مع صلصة طماطم من المعجون والأعشاب.', updated_at = now() WHERE name_en = 'Mozzarella Sticks' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'أجنحة دجاج مقلية مع طلاء بنكهة باربيكيو أو بافلو (عسل وبابريكا ولمحة خل).', updated_at = now() WHERE name_en = 'Chicken Wings' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'عجينة مقرمشة بحشوة خضار أو لحم مفروم متبل (أسلوب بريك تونسي).', updated_at = now() WHERE name_en = 'Spring Rolls / Brik' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'تُقطع البطاطس وتُقلى حتى يصبح لونها ذهبياً؛ يُرشّ عليها الملح.', updated_at = now() WHERE name_en = 'French Fries' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شرائح بطاطس سميكة متبلة، تُخبز في الفرن أو تُقلى في الزيت.', updated_at = now() WHERE name_en = 'Potato Wedges' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'خس على أسلوب الرومين مع بارميزان وقطع خبز محمص وصلصة قيصر (مايونيز وليمون وثوم).', updated_at = now() WHERE name_en = 'Caesar Salad' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بوراتا كريمية مع طماطم وزيت زيتون وقطرات خل بلسمي وريحان.', updated_at = now() WHERE name_en = 'Burrata Salad' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'موزاريلا وطماطم وزيت زيتون ونكهة ريحان (ريحان مجفف).', updated_at = now() WHERE name_en = 'Caprese Salad' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'تونة وبيض وزيتون وبطاطس وفاصوليا خضراء وخلّ بنكهة الفجت.', updated_at = now() WHERE name_en = 'Niçoise Salad' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شوربة طماطم وحمص مع معكرونة أورزو أو لؤلؤ والتوابل (هريسة اختياري).', updated_at = now() WHERE name_en = 'Tunisian Soup' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'عدس أحمر مع بصل وجزر وكمون وزيت زيتون.', updated_at = now() WHERE name_en = 'Lentil Soup' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مرق دجاج من صدر الدجاج والخضار.', updated_at = now() WHERE name_en = 'Chicken Veggie Soup' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Margherita' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Pepperoni' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Very Veggie' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Chicken Ranch' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Chicken Pesto' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Burrata Pizza' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Tonno e Cipolla' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Quattro Formaggi' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Regina' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Four Seasons' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيتزا من فرن احترافي أو فرن حطب؛ الصلصة والجبن والإضافات وفق قائمة معاظم.', updated_at = now() WHERE name_en = 'Hot Waves' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'طبقات رقائق لازانيا مع راغو لحم بقري وبشاميل وموزاريلا.', updated_at = now() WHERE name_en = 'Lasagna Bolognese' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'دجاج وخضار موسمية مع صوص بشاميل وموزاريلا بين طبقات اللازانيا.', updated_at = now() WHERE name_en = 'Lasagna Chicken & Vegetable' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'طبقات لازانيا مع بديل حلال للحم الديك الرومي المدخّن وصوص أبيض وموزاريلا.', updated_at = now() WHERE name_en = 'Smoked Ham Lasagna' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'سباغيتي مع طماطم وأنشوجة وزيتون وكبر وثوم.', updated_at = now() WHERE name_en = 'Puttanesca' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'صلصة طماطم حارة بالثوم مع معكرونة بيني.', updated_at = now() WHERE name_en = 'Penne Arrabbiata' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'صوص ألفريدو كريمي مع صدور دجاج مشوية (كريمة وزبدة وبارميزان).', updated_at = now() WHERE name_en = 'Chicken Alfredo' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'راغو لحم بقري وطماطم يُطبخ على نار هادئة مع سباغيتي أو بيني.', updated_at = now() WHERE name_en = 'Bolognese' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'عجينة مطوية، دجاج أو لحم مشوي، سلطة، جبن، مايونيز.', updated_at = now() WHERE name_en = 'Makloub Maazym' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'باجيت محشو بالبروتين والجبن والبطاطس المقلية داخل الخبز.', updated_at = now() WHERE name_en = 'Baguette Farcie Maazym' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'تورتيلا ملفوفة بدجاج وبطاطس مقلية وصلصة جبن.', updated_at = now() WHERE name_en = 'French Tacos Chicken' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'تورتيلا ملفوفة بلحم مفروم وبطاطس مقلية وصلصة جبن.', updated_at = now() WHERE name_en = 'French Tacos Beef' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'خبز على شكل مخروط بحشوة دجاج حار وجبن.', updated_at = now() WHERE name_en = 'Cornet Maazym' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'سندويش بخبز البيتزا مع موزاريلا ولحم وخضار.', updated_at = now() WHERE name_en = 'Panuzzo Maazym' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مكعبات لحم مشوية مع فلفل وبصل وتوابل تونسية.', updated_at = now() WHERE name_en = 'Kleya Sandwich' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'جبن مدخن وديك رومي حلال وخس وصلصة.', updated_at = now() WHERE name_en = 'Smoked Sandwich' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'خبز مسطح مع ذوبان أجبان عكاوي/موزاريلا.', updated_at = now() WHERE name_en = 'Mankouch Cheese' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'خبز مسطح بخلطة زعتر وزيت زيتون.', updated_at = now() WHERE name_en = 'Mankouch Zaatar' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'سبانخ وبصل وسماق وليمون.', updated_at = now() WHERE name_en = 'Mankouch Spinach' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'سبانخ مع جبن ذائب على الخبز المسطح.', updated_at = now() WHERE name_en = 'Mankouch Cheese & Spinach' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'لحم مفروم وطماطم وبصل وتوابل.', updated_at = now() WHERE name_en = 'Mankouch Meat' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'عجينة معجنات مدهونة بالزبدة على طبقات (كرواسان).', updated_at = now() WHERE name_en = 'Croissant' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مافن حلو (رقائق شوكولاتة / توت / فانيليا).', updated_at = now() WHERE name_en = 'Muffin' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'كوكي برقائق الشوكولاتة.', updated_at = now() WHERE name_en = 'Cookie' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'طبقات عجينة مقرمشة مع كريمة باتسيير.', updated_at = now() WHERE name_en = 'Millefeuille' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حشوة جبن كريمي وقاعدة بسكويت وفاكهة فوقها.', updated_at = now() WHERE name_en = 'Cheesecake' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بان كيك هشّ مع شراب القيقب وتوت.', updated_at = now() WHERE name_en = 'Pancakes' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'كريمة محلاة تُثبت بالجيلاتين مع صلصة فواكه.', updated_at = now() WHERE name_en = 'Panna Cotta' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'تشيز كيك باسكي محروق السطح (جبن كريم وكريمة وبيض).', updated_at = now() WHERE name_en = 'San Sebastian' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'كريب رقيق مع شوكولاتة أو فاكهة.', updated_at = now() WHERE name_en = 'Crêpes' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مزيج فواكه طازجة موسمية.', updated_at = now() WHERE name_en = 'Fruit Salad' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شوفان ومكسرات وعسل؛ يُقدّم مع زبادي أو حليب.', updated_at = now() WHERE name_en = 'Granola' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'كريمة مسكربون وإسبريسو منقوع في إسفنجة (أو بديل خبز) وكاكاو.', updated_at = now() WHERE name_en = 'Tiramisu' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيض وأجبان وزيتون وخبز ولبنة وسلطة.', updated_at = now() WHERE name_en = 'Mediterranean Breakfast' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بيض وبديل نقانق لحم بقري حلال وبطاطس مهروسة وتوست وزبدة.', updated_at = now() WHERE name_en = 'Continental Breakfast' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'فول وأقراص حمص مقلية (فلافل) وحمص وبيض ومخللات وخبز بيتا.', updated_at = now() WHERE name_en = 'Arabic Breakfast' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'بان كيك صغير وبيض مخفوق ومكوّنات عصير طازج.', updated_at = now() WHERE name_en = 'Kids Breakfast' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'جرعة إسبريسو فردية؛ حوالي ٩–١٠ غ قهوة مطحونة مستخلصة.', updated_at = now() WHERE name_en = 'Espresso (1 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'جرعتان إسبريسو؛ حوالي 18–20 غ قهوة مطحونة في الاستخلاص.', updated_at = now() WHERE name_en = 'Double Espresso (2 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو مع حلاوة من الحليب المكثّف.', updated_at = now() WHERE name_en = 'Special Espresso (1.5 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو يُزيّن بحليب مزبد.', updated_at = now() WHERE name_en = 'Macchiato (2 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو ممدّد بماء ساخن.', updated_at = now() WHERE name_en = 'Americano (8 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو مزدوج النكهة مع حليب مخملي.', updated_at = now() WHERE name_en = 'Flat White (7 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وحليب مبخر ورغوة.', updated_at = now() WHERE name_en = 'Cappuccino (8 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو مع كمية أكبر من الحليب المبخر.', updated_at = now() WHERE name_en = 'Latte (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مسحوق ماتشا مع حليب مبخر.', updated_at = now() WHERE name_en = 'Matcha Latte (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وحليب وحليب مكثّف.', updated_at = now() WHERE name_en = 'Spanish Latte (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وصلصة شوكولاتة وحليب مبخر.', updated_at = now() WHERE name_en = 'Mocha Latte (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'كاكاو وحليب وسكر.', updated_at = now() WHERE name_en = 'Hot Chocolate (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'قهوة ترشيح يدوي V60.', updated_at = now() WHERE name_en = 'V60 Coffee (8.5 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'قهوة مطحونة ناعمة مع ماء وسكر اختياري.', updated_at = now() WHERE name_en = 'Turkish Coffee (3 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شاي أخضر ونعناع طازج وسكر.', updated_at = now() WHERE name_en = 'Tunisian Mint Tea (7 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شاي بالنعناع مع مكسرات محمصة.', updated_at = now() WHERE name_en = 'Tea w/ Almonds/Hazelnut (7.5 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شاي أخضر قوي مع نعناع.', updated_at = now() WHERE name_en = 'Moroccan Mint Tea (7 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شاي فواكه أو أعشاب (تشكيلة).', updated_at = now() WHERE name_en = 'Flavors Tea (8 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'شاي مميز بنكهات العسل والمكسرات والقرفة.', updated_at = now() WHERE name_en = 'Maazym Baklawa Tea (8 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'قهوة ترشيح باردة على الثلج.', updated_at = now() WHERE name_en = 'Iced V60 (10 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وماء بارد وثلج.', updated_at = now() WHERE name_en = 'Iced Americano (11 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وحليب بارد وثلج.', updated_at = now() WHERE name_en = 'Iced Latte (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وحليب مكثّف وحليب بارد وثلج.', updated_at = now() WHERE name_en = 'Iced Spanish Latte (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'إسبريسو وشوكولاتة وحليب وثلج.', updated_at = now() WHERE name_en = 'Iced Mocha Latte (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'ماتشا وحليب وثلج.', updated_at = now() WHERE name_en = 'Iced Matcha Latte (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مضخة شراب فانيليا أو كراميل أو بندق.', updated_at = now() WHERE name_en = 'Extra Syrup (1 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مشروب مخصّص حسب ذوق الضيف (قاعدة + شراب + حليب).', updated_at = now() WHERE name_en = 'Maazym Customized Drink (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'ليمون ونعناع وخليط صودا وسكر.', updated_at = now() WHERE name_en = 'Classic Mojito (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'فراولة وليمون ونعناع وسكر.', updated_at = now() WHERE name_en = 'Strawberry Mojito (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مانجو وليمون ونعناع وسكر.', updated_at = now() WHERE name_en = 'Mango Mojito (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'فاكهة الباشن وليمون ونعناع وسكر.', updated_at = now() WHERE name_en = 'Passion Fruit Mojito (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'ليمون ونعناع وماء زهر.', updated_at = now() WHERE name_en = 'Tunisian Lemonade (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'مزيج فواكه طازجة موسمية.', updated_at = now() WHERE name_en = 'Fresh Juice Maazym (12 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حليب وشراب فانيليا وقاعدة زبادي مجمّد.', updated_at = now() WHERE name_en = 'Vanilla Milkshake (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حليب وصلصة شوكولاتة وقاعدة زبادي مجمّد.', updated_at = now() WHERE name_en = 'Chocolate Milkshake (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حليب وفراولة طازجة وقاعدة زبادي مجمّد.', updated_at = now() WHERE name_en = 'Strawberry Milkshake (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حليب ومانجو وقاعدة زبادي مجمّد.', updated_at = now() WHERE name_en = 'Mango Milkshake (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'حليب وأناناس وقاعدة زبادي مجمّد.', updated_at = now() WHERE name_en = 'Pineapple Milkshake (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'أناناس وحليب جوز الهند وثلج مجروش (مزيج).', updated_at = now() WHERE name_en = 'Piña Colada (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'برتقال وأناناس ومانجو وشراب بنكهة غرينادين.', updated_at = now() WHERE name_en = 'Tropical Sunset (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'قاعدة شاي وحليب وشراب كراميل (حبات التابيوكا اختيارية تجارياً).', updated_at = now() WHERE name_en = 'Boba Drink (16 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'فواكه مشكّلة وكريمة ومكسرات وعسل.', updated_at = now() WHERE name_en = 'Jwajem Maazym (15 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

UPDATE recipes SET description_ar = 'فواكه مجمّدة مخلوطة مع قاعدة زبادي.', updated_at = now() WHERE name_en = 'Smoothie Maazym (14 oz)' AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid;

COMMIT;
