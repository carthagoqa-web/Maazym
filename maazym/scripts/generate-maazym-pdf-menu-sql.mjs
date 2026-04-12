/**
 * Generates supabase/migrations/00005_maazym_pdf_menu.sql
 * Recipes + menu items from MAAZYM MENU V02; omits supplier retail (water, soft drinks, shisha, ice cream scoop).
 * Ingredient lines use inventory_items.name_en from migrations 00002/00003 — skipped if missing in DB.
 */
import { writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { RECIPE_DESCRIPTION_AR } from './recipe-description-ar.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const BRANCH = '00000000-0000-0000-0000-000000000001';

function rid(i) {
  const h = (0xa00000000000 + i).toString(16).padStart(12, '0');
  return `aaaaaaaa-0000-4000-8000-${h}`;
}
function mid(i) {
  const h = (0xb00000000000 + i).toString(16).padStart(12, '0');
  return `bbbbbbbb-0000-4000-8000-${h}`;
}

/** @type {{ en: string, ar: string, price: number, section: string, cat: string, desc: string, desc_ar: string, ing: [string, number, string][] }[]} */
const ROWS = [];

function add(en, ar, price, section, cat, desc, ing) {
  ROWS.push({ en, ar, price, section, cat, desc, desc_ar: '', ing });
}

// --- Starters
add(
  'Mozzarella Sticks',
  'أصابع موزاريلا',
  20,
  'Starters',
  'Appetizers',
  'Breaded low-moisture mozzarella, fried; tomato dip from paste and herbs (restaurant-style breading station).',
  [
    ['Mozzarella', 0.09, 'kg'],
    ['Flour', 0.04, 'kg'],
    ['Eggs', 1.5, 'piece'],
    ['Breadcrumbs', 0.06, 'kg'],
    ['Tomato paste', 0.04, 'kg'],
    ['Dried basil', 0.003, 'kg'],
    ['Sunflower oil', 0.12, 'l'],
    ['Salt', 0.002, 'kg'],
  ]
);
add(
  'Chicken Wings',
  'أجنحة دجاج',
  25,
  'Starters',
  'Appetizers',
  'Fried wings with BBQ or buffalo-style glaze (honey, paprika, vinegar notes).',
  [
    ['Chicken wings', 0.35, 'kg'],
    ['Sunflower oil', 0.15, 'l'],
    ['Flour', 0.03, 'kg'],
    ['Smoked paprika', 0.005, 'kg'],
    ['Honey', 0.02, 'kg'],
    ['Lemon juice', 0.015, 'l'],
    ['Salt', 0.003, 'kg'],
    ['Black pepper', 0.002, 'kg'],
  ]
);
add(
  'Spring Rolls / Brik',
  'سبرينغ رول / بريك',
  15,
  'Starters',
  'Appetizers',
  'Crispy pastry with vegetables or seasoned minced meat (Tunisian brik-style).',
  [
    ['Brik/Spring roll pastry', 0.08, 'pack'],
    ['Potato', 0.06, 'kg'],
    ['Carrot', 0.04, 'kg'],
    ['Onion', 0.04, 'kg'],
    ['Ground beef', 0.1, 'kg'],
    ['Egg', 1, 'piece'],
    ['Sunflower oil', 0.1, 'l'],
    ['Salt', 0.002, 'kg'],
  ]
);
add(
  'French Fries',
  'بطاطس مقلية',
  12,
  'Starters',
  'Appetizers',
  'Cut potatoes, fried golden; salt.',
  [
    ['Potato', 0.35, 'kg'],
    ['Sunflower oil', 0.18, 'l'],
    ['Salt', 0.004, 'kg'],
  ]
);
add(
  'Potato Wedges',
  'شرائح بطاطس',
  15,
  'Starters',
  'Appetizers',
  'Thick-cut seasoned potato wedges, oven or fryer.',
  [
    ['Potato', 0.4, 'kg'],
    ['Sunflower oil', 0.12, 'l'],
    ['Garlic powder', 0.004, 'kg'],
    ['Smoked paprika', 0.003, 'kg'],
    ['Salt', 0.004, 'kg'],
  ]
);

// --- Salads
add(
  'Caesar Salad',
  'سلطة قيصر',
  20,
  'Salads',
  'Salads',
  'Romaine-style on lettuce, parmesan, croutons, Caesar dressing (mayo-lemon-garlic).',
  [
    ['Lettuce', 0.12, 'kg'],
    ['Parmesan', 0.025, 'kg'],
    ['Bread', 0.04, 'piece'],
    ['Mayonnaise', 0.04, 'kg'],
    ['Lemon juice', 0.01, 'l'],
    ['Garlic powder', 0.002, 'kg'],
    ['Black pepper', 0.001, 'kg'],
  ]
);
add(
  'Burrata Salad',
  'سلطة بوراتا',
  25,
  'Salads',
  'Salads',
  'Creamy burrata with tomatoes, olive oil, balsamic drizzle, basil.',
  [
    ['Mozzarella', 0.12, 'kg'],
    ['Heavy cream', 0.04, 'l'],
    ['Tomato', 0.2, 'kg'],
    ['Olive oil', 0.025, 'l'],
    ['Balsamic vinegar', 0.01, 'l'],
    ['Dried basil', 0.002, 'kg'],
    ['Salt', 0.002, 'kg'],
  ]
);
add(
  'Caprese Salad',
  'سلطة كابريزي',
  25,
  'Salads',
  'Salads',
  'Mozzarella, tomato, olive oil, fresh basil note (dried basil).',
  [
    ['Mozzarella', 0.15, 'kg'],
    ['Tomato', 0.22, 'kg'],
    ['Olive oil', 0.03, 'l'],
    ['Dried basil', 0.003, 'kg'],
    ['Salt', 0.002, 'kg'],
    ['Black pepper', 0.001, 'kg'],
  ]
);
add(
  'Niçoise Salad',
  'سلطة نيسواز',
  22,
  'Salads',
  'Salads',
  'Tuna, eggs, olives, potato, green beans, vinaigrette.',
  [
    ['Tuna', 0.12, 'kg'],
    ['Eggs', 2, 'piece'],
    ['Olives black', 0.03, 'kg'],
    ['Potato', 0.15, 'kg'],
    ['Green beans', 0.08, 'kg'],
    ['Lettuce', 0.06, 'kg'],
    ['Olive oil', 0.025, 'l'],
    ['Lemon juice', 0.01, 'l'],
    ['Dijon mustard', 0.01, 'kg'],
  ]
);

// --- Soups
add(
  'Tunisian Soup',
  'شوربة تونسية',
15,
  'Soups',
  'Soups',
  'Tomato-chickpea soup with orzo/pearl pasta and spices (harissa optional).',
  [
    ['Tomato', 0.25, 'kg'],
    ['Chickpeas canned', 0.2, 'can'],
    ['Orzo pasta', 0.05, 'kg'],
    ['Onion', 0.08, 'kg'],
    ['Garlic', 0.015, 'kg'],
    ['Cumin', 0.003, 'kg'],
    ['Olive oil', 0.02, 'l'],
    ['Salt', 0.003, 'kg'],
  ]
);
add(
  'Lentil Soup',
  'شوربة عدس',
  12,
  'Soups',
  'Soups',
  'Red lentils with onion, carrot, cumin, olive oil.',
  [
    ['Lentils red', 0.12, 'kg'],
    ['Onion', 0.1, 'kg'],
    ['Carrot', 0.08, 'kg'],
    ['Cumin', 0.004, 'kg'],
    ['Olive oil', 0.02, 'l'],
    ['Lemon juice', 0.015, 'l'],
    ['Salt', 0.003, 'kg'],
  ]
);
add(
  'Chicken Veggie Soup',
  'شوربة دجاج وخضار',
  12,
  'Soups',
  'Soups',
  'Chicken broth from breast and vegetables.',
  [
    ['Chicken breast', 0.2, 'kg'],
    ['Carrot', 0.08, 'kg'],
    ['Onion', 0.08, 'kg'],
    ['Celery', 0.05, 'kg'],
    ['Salt', 0.004, 'kg'],
    ['Black pepper', 0.002, 'kg'],
  ]
);

// --- Pizza base dough + sauce helper
const pizzaBase = [
  ['Pizza dough', 0.22, 'kg'],
  ['Tomato', 0.15, 'kg'],
  ['Tomato paste', 0.03, 'kg'],
  ['Mozzarella', 0.18, 'kg'],
  ['Olive oil', 0.02, 'l'],
  ['Dried oregano', 0.003, 'kg'],
  ['Salt', 0.002, 'kg'],
];
const pizzas = [
  ['Margherita', 'مارغريتا', 25, [...pizzaBase]],
  [
    'Pepperoni',
    'بيبروني',
    28,
    [...pizzaBase, ['Ground beef', 0.08, 'kg'], ['Smoked paprika', 0.004, 'kg']],
  ],
  [
    'Very Veggie',
    'خضار كثيرة',
    25,
    [...pizzaBase, ['Bell pepper', 0.08, 'kg'], ['Mushroom', 0.07, 'kg'], ['Onion', 0.06, 'kg'], ['Olives black', 0.04, 'kg']],
  ],
  [
    'Chicken Ranch',
    'دجاج رانش',
    30,
    [...pizzaBase, ['Chicken breast', 0.18, 'kg'], ['Mayonnaise', 0.04, 'kg']],
  ],
  [
    'Chicken Pesto',
    'دجاج بيستو',
    30,
    [...pizzaBase, ['Chicken breast', 0.18, 'kg'], ['Pesto sauce', 0.04, 'kg']],
  ],
  [
    'Burrata Pizza',
    'بيتزا بوراتا',
    40,
    [...pizzaBase, ['Mozzarella', 0.1, 'kg'], ['Arugula', 0.04, 'kg'], ['Heavy cream', 0.03, 'l']],
  ],
  [
    'Tonno e Cipolla',
    'تونة وبصل',
    28,
    [...pizzaBase, ['Tuna', 0.12, 'kg'], ['Onion', 0.08, 'kg'], ['Olives black', 0.05, 'kg']],
  ],
  [
    'Quattro Formaggi',
    'أربع أجبان',
    40,
    [...pizzaBase, ['Parmesan', 0.04, 'kg'], ['Blue cheese', 0.03, 'kg'], ['Feta cheese', 0.05, 'kg']],
  ],
  [
    'Regina',
    'ريجينا',
    30,
    [...pizzaBase, ['Turkey breast', 0.1, 'kg'], ['Mushroom', 0.1, 'kg']],
  ],
  [
    'Four Seasons',
    'فصول أربعة',
    38,
    [...pizzaBase, ['Artichoke hearts', 0.06, 'kg'], ['Mushroom', 0.06, 'kg'], ['Olives black', 0.04, 'kg'], ['Turkey breast', 0.08, 'kg']],
  ],
  [
    'Hot Waves',
    'أمواج حارة',
    32,
    [...pizzaBase, ['Ground beef', 0.1, 'kg'], ['Hot green pepper', 0.04, 'kg'], ['Cayenne pepper', 0.002, 'kg']],
  ],
];
for (const [en, ar, price, ing] of pizzas) {
  add(en, ar, price, 'Pizza', 'Main Courses', 'Wood-oven or deck oven pizza; toppings per MAAZYM menu.', ing);
}

// --- Pasta
add(
  'Lasagna Bolognese',
  'لازانيا بولونيز',
  25,
  'Pasta',
  'Main Courses',
  'Layers of pasta sheets, beef ragu, béchamel, mozzarella.',
  [
    ['Lasagna sheets', 0.15, 'pack'],
    ['Ground beef', 0.22, 'kg'],
    ['Tomato paste', 0.08, 'kg'],
    ['Onion', 0.08, 'kg'],
    ['Mozzarella', 0.12, 'kg'],
    ['Milk', 0.25, 'l'],
    ['Butter', 0.04, 'kg'],
    ['Flour', 0.03, 'kg'],
    ['Salt', 0.004, 'kg'],
  ]
);
add(
  'Lasagna Chicken & Vegetable',
  'لازانيا دجاج وخضار',
  25,
  'Pasta',
  'Main Courses',
  'Chicken, seasonal vegetables, béchamel, mozzarella.',
  [
    ['Lasagna sheets', 0.15, 'pack'],
    ['Chicken breast', 0.22, 'kg'],
    ['Bell pepper', 0.08, 'kg'],
    ['Mushroom', 0.07, 'kg'],
    ['Mozzarella', 0.12, 'kg'],
    ['Milk', 0.22, 'l'],
    ['Butter', 0.035, 'kg'],
    ['Flour', 0.028, 'kg'],
    ['Salt', 0.004, 'kg'],
  ]
);
add(
  'Smoked Ham Lasagna',
  'لازانيا لحم مدخن',
  25,
  'Pasta',
  'Main Courses',
  'Layers with halal smoked turkey ham substitute, white sauce, mozzarella.',
  [
    ['Lasagna sheets', 0.15, 'pack'],
    ['Turkey breast', 0.2, 'kg'],
    ['Smoked paprika', 0.006, 'kg'],
    ['Mozzarella', 0.14, 'kg'],
    ['Milk', 0.22, 'l'],
    ['Butter', 0.04, 'kg'],
    ['Flour', 0.03, 'kg'],
    ['Salt', 0.004, 'kg'],
  ]
);
add(
  'Puttanesca',
  'بوتانيسكا',
  25,
  'Pasta',
  'Main Courses',
  'Spaghetti with tomato, anchovies, olives, capers.',
  [
    ['Spaghetti', 0.14, 'kg'],
    ['Tomato', 0.2, 'kg'],
    ['Anchovies', 0.03, 'kg'],
    ['Olives black', 0.05, 'kg'],
    ['Capers', 0.02, 'kg'],
    ['Garlic', 0.015, 'kg'],
    ['Olive oil', 0.04, 'l'],
    ['Salt', 0.002, 'kg'],
  ]
);
add(
  'Penne Arrabbiata',
  'بيني أرابياتا',
  22,
  'Pasta',
  'Main Courses',
  'Spicy tomato-garlic sauce with penne.',
  [
    ['Penne pasta', 0.15, 'kg'],
    ['Tomato', 0.22, 'kg'],
    ['Garlic', 0.02, 'kg'],
    ['Hot green pepper', 0.025, 'kg'],
    ['Olive oil', 0.035, 'l'],
    ['Dried oregano', 0.003, 'kg'],
    ['Salt', 0.003, 'kg'],
  ]
);
add(
  'Chicken Alfredo',
  'دجاج ألفريدو',
  28,
  'Pasta',
  'Main Courses',
  'Creamy Alfredo with grilled chicken (cream, butter, parmesan).',
  [
    ['Spaghetti', 0.13, 'kg'],
    ['Chicken breast', 0.22, 'kg'],
    ['Heavy cream', 0.18, 'l'],
    ['Butter', 0.05, 'kg'],
    ['Parmesan', 0.05, 'kg'],
    ['Garlic powder', 0.003, 'kg'],
    ['Salt', 0.003, 'kg'],
    ['Black pepper', 0.002, 'kg'],
  ]
);
add(
  'Bolognese',
  'بولونيز',
  30,
  'Pasta',
  'Main Courses',
  'Slow beef-tomato ragu with spaghetti or penne.',
  [
    ['Spaghetti', 0.16, 'kg'],
    ['Ground beef', 0.28, 'kg'],
    ['Tomato paste', 0.1, 'kg'],
    ['Onion', 0.1, 'kg'],
    ['Carrot', 0.06, 'kg'],
    ['Garlic', 0.015, 'kg'],
    ['Olive oil', 0.03, 'l'],
    ['Salt', 0.004, 'kg'],
    ['Black pepper', 0.002, 'kg'],
  ]
);

// --- Mediterranean Sandwiches
add(
  'Makloub Maazym',
  'مقلوب معاظم',
  26,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Folded dough, grilled chicken or meat, salad, cheese, mayo.',
  [
    ['Pizza dough', 0.2, 'kg'],
    ['Chicken breast', 0.2, 'kg'],
    ['Lettuce', 0.05, 'kg'],
    ['Tomato', 0.06, 'kg'],
    ['Mozzarella', 0.06, 'kg'],
    ['Mayonnaise', 0.03, 'kg'],
  ]
);
add(
  'Baguette Farcie Maazym',
  'باجيت فارسي معاظم',
  30,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Stuffed baguette with protein, cheese, fries inside.',
  [
    ['Bread', 2, 'piece'],
    ['Chicken breast', 0.22, 'kg'],
    ['Mozzarella', 0.08, 'kg'],
    ['Potato', 0.15, 'kg'],
    ['Sunflower oil', 0.1, 'l'],
    ['Mayonnaise', 0.03, 'kg'],
  ]
);
add(
  'French Tacos Chicken',
  'تاكو فرنسي دجاج',
  25,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Tortilla wrap, chicken, fries, cheese sauce.',
  [
    ['Tortilla', 2, 'piece'],
    ['Chicken breast', 0.2, 'kg'],
    ['Potato', 0.18, 'kg'],
    ['Sunflower oil', 0.1, 'l'],
    ['Mozzarella', 0.1, 'kg'],
    ['Milk', 0.08, 'l'],
    ['Butter', 0.02, 'kg'],
    ['Flour', 0.015, 'kg'],
  ]
);
add(
  'French Tacos Beef',
  'تاكو فرنسي لحم',
  28,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Tortilla, minced beef, fries, cheese sauce.',
  [
    ['Tortilla', 2, 'piece'],
    ['Ground beef', 0.22, 'kg'],
    ['Potato', 0.18, 'kg'],
    ['Sunflower oil', 0.11, 'l'],
    ['Mozzarella', 0.1, 'kg'],
    ['Milk', 0.08, 'l'],
    ['Butter', 0.02, 'kg'],
    ['Flour', 0.015, 'kg'],
  ]
);
add(
  'Cornet Maazym',
  'كورني معاظم',
  25,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Cone bread, spicy chicken filling, cheese.',
  [
    ['Bread', 1, 'piece'],
    ['Chicken breast', 0.2, 'kg'],
    ['Cayenne pepper', 0.003, 'kg'],
    ['Mozzarella', 0.08, 'kg'],
    ['Lettuce', 0.04, 'kg'],
    ['Mayonnaise', 0.025, 'kg'],
  ]
);
add(
  'Panuzzo Maazym',
  'بانوتزو معاظم',
  25,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Pizza-bread sandwich with mozzarella, meat, greens.',
  [
    ['Pizza dough', 0.22, 'kg'],
    ['Mozzarella', 0.12, 'kg'],
    ['Ground beef', 0.12, 'kg'],
    ['Arugula', 0.04, 'kg'],
    ['Tomato', 0.06, 'kg'],
    ['Olive oil', 0.02, 'l'],
  ]
);
add(
  'Kleya Sandwich',
  'سندويش كليا',
  25,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Sautéed meat cubes, peppers, onions, Tunisian spices.',
  [
    ['Bread', 2, 'piece'],
    ['Lamb mince', 0.2, 'kg'],
    ['Bell pepper', 0.1, 'kg'],
    ['Onion', 0.1, 'kg'],
    ['Tabil spice', 0.004, 'kg'],
    ['Olive oil', 0.03, 'l'],
  ]
);
add(
  'Smoked Sandwich',
  'سندويش مدخن',
  25,
  'Mediterranean Sandwiches',
  'Main Courses',
  'Smoked cheese, halal turkey, lettuce, sauce.',
  [
    ['Bread', 2, 'piece'],
    ['Turkey breast', 0.12, 'kg'],
    ['Mozzarella', 0.06, 'kg'],
    ['Smoked paprika', 0.005, 'kg'],
    ['Lettuce', 0.05, 'kg'],
    ['Mayonnaise', 0.03, 'kg'],
  ]
);

// --- Fatayer / Mankouch
add(
  'Mankouch Cheese',
  'منقوشة جبن',
  14,
  'Fatayer',
  'Main Courses',
  'Flatbread with akkawi/mozzarella melt.',
  [
    ['Pizza dough', 0.15, 'kg'],
    ['Akkawi cheese', 0.12, 'kg'],
    ['Mozzarella', 0.06, 'kg'],
    ['Olive oil', 0.02, 'l'],
  ]
);
add(
  'Mankouch Zaatar',
  'منقوشة زعتر',
  12,
  'Fatayer',
  'Main Courses',
  'Flatbread with zaatar mix and olive oil.',
  [
    ['Pizza dough', 0.15, 'kg'],
    ['Dried thyme', 0.02, 'kg'],
    ['Sesame seeds', 0.015, 'kg'],
    ['Olive oil', 0.035, 'l'],
  ]
);
add(
  'Mankouch Spinach',
  'منقوشة سبانخ',
  16,
  'Fatayer',
  'Main Courses',
  'Spinach, onion, sumac, lemon.',
  [
    ['Pizza dough', 0.15, 'kg'],
    ['Spinach', 0.2, 'kg'],
    ['Onion', 0.06, 'kg'],
    ['Lemon juice', 0.015, 'l'],
    ['Olive oil', 0.025, 'l'],
  ]
);
add(
  'Mankouch Cheese & Spinach',
  'منقوشة جبن وسبانخ',
  18,
  'Fatayer',
  'Main Courses',
  'Spinach with melted cheese on flatbread.',
  [
    ['Pizza dough', 0.16, 'kg'],
    ['Spinach', 0.18, 'kg'],
    ['Akkawi cheese', 0.1, 'kg'],
    ['Lemon juice', 0.012, 'l'],
    ['Olive oil', 0.025, 'l'],
  ]
);
add(
  'Mankouch Meat',
  'منقوشة لحم',
  18,
  'Fatayer',
  'Main Courses',
  'Minced beef/lamb, tomato, onion, spices.',
  [
    ['Pizza dough', 0.16, 'kg'],
    ['Ground beef', 0.18, 'kg'],
    ['Tomato', 0.1, 'kg'],
    ['Onion', 0.08, 'kg'],
    ['Cumin', 0.004, 'kg'],
    ['Olive oil', 0.025, 'l'],
  ]
);

// --- Bakery (no Ice Cream)
add(
  'Croissant',
  'كرواسون',
  10,
  'Bakery Corner',
  'Desserts',
  'Laminated butter pastry.',
  [
    ['Butter', 0.08, 'kg'],
    ['Flour', 0.12, 'kg'],
    ['Milk', 0.06, 'l'],
    ['Yeast', 0.008, 'kg'],
    ['Sugar', 0.015, 'kg'],
    ['Eggs', 0.5, 'piece'],
    ['Salt', 0.002, 'kg'],
  ]
);
add(
  'Muffin',
  'مافن',
  10,
  'Bakery Corner',
  'Desserts',
  'Sweet muffin (chocolate chips / berry / vanilla).',
  [
    ['Flour', 0.1, 'kg'],
    ['Sugar', 0.06, 'kg'],
    ['Butter', 0.05, 'kg'],
    ['Eggs', 1, 'piece'],
    ['Milk', 0.08, 'l'],
    ['Chocolate chips', 0.04, 'kg'],
    ['Baking powder', 0.004, 'kg'],
  ]
);
add(
  'Cookie',
  'كوكي',
  10,
  'Bakery Corner',
  'Desserts',
  'Chocolate chip cookie.',
  [
    ['Flour', 0.08, 'kg'],
    ['Butter', 0.06, 'kg'],
    ['Sugar', 0.05, 'kg'],
    ['Chocolate chips', 0.05, 'kg'],
    ['Eggs', 0.5, 'piece'],
    ['Vanilla extract', 0.003, 'l'],
  ]
);
add(
  'Millefeuille',
  'ميل في',
20,
  'Bakery Corner',
  'Desserts',
  'Puff pastry layers with pastry cream.',
  [
    ['Filo/Phyllo pastry', 0.12, 'pack'],
    ['Milk', 0.25, 'l'],
    ['Sugar', 0.08, 'kg'],
    ['Eggs', 2, 'piece'],
    ['Butter', 0.06, 'kg'],
    ['Flour', 0.04, 'kg'],
  ]
);
add(
  'Cheesecake',
  'تشيز كيك',
  20,
  'Bakery Corner',
  'Desserts',
  'Cream cheese filling, crust, fruit topping.',
  [
    ['Cream cheese', 0.22, 'kg'],
    ['Sugar', 0.08, 'kg'],
    ['Eggs', 1.5, 'piece'],
    ['Butter', 0.05, 'kg'],
    ['Flour', 0.04, 'kg'],
    ['Strawberry', 0.08, 'kg'],
  ]
);
add(
  'Pancakes',
  'بان كيك',
  15,
  'Bakery Corner',
  'Desserts',
  'Fluffy pancakes, maple, berries.',
  [
    ['Flour', 0.12, 'kg'],
    ['Milk', 0.2, 'l'],
    ['Eggs', 2, 'piece'],
    ['Butter', 0.03, 'kg'],
    ['Maple syrup', 0.04, 'l'],
    ['Strawberry', 0.06, 'kg'],
    ['Sugar', 0.02, 'kg'],
  ]
);
add(
  'Panna Cotta',
  'بانا كوتا',
  15,
  'Bakery Corner',
  'Desserts',
  'Sweetened cream set with gelatin, fruit coulis.',
  [
    ['Heavy cream', 0.22, 'l'],
    ['Sugar', 0.04, 'kg'],
    ['Gelatin', 0.008, 'kg'],
    ['Strawberry', 0.1, 'kg'],
    ['Vanilla extract', 0.005, 'l'],
  ]
);
add(
  'San Sebastian',
  'سان سيباستيان',
  20,
  'Bakery Corner',
  'Desserts',
  'Burnt Basque-style cheesecake (cream cheese, cream, eggs).',
  [
    ['Cream cheese', 0.28, 'kg'],
    ['Heavy cream', 0.12, 'l'],
    ['Eggs', 3, 'piece'],
    ['Sugar', 0.1, 'kg'],
    ['Flour', 0.025, 'kg'],
  ]
);
add(
  'Crêpes',
  'كريب',
  18,
  'Bakery Corner',
  'Desserts',
  'Thin pancakes with chocolate or fruit.',
  [
    ['Flour', 0.1, 'kg'],
    ['Milk', 0.22, 'l'],
    ['Eggs', 2, 'piece'],
    ['Butter', 0.04, 'kg'],
    ['Chocolate sauce', 0.04, 'kg'],
    ['Sugar', 0.03, 'kg'],
  ]
);
add(
  'Fruit Salad',
  'سلطة فواكه',
  18,
  'Bakery Corner',
  'Desserts',
  'Seasonal fresh fruit mix.',
  [
    ['Orange', 0.12, 'kg'],
    ['Strawberry', 0.1, 'kg'],
    ['Mango', 0.1, 'kg'],
    ['Pineapple', 0.1, 'kg'],
    ['Honey', 0.02, 'kg'],
    ['Mint', 0.005, 'kg'],
  ]
);
add(
  'Granola',
  'جرانولا',
  15,
  'Bakery Corner',
  'Desserts',
  'Oats, nuts, honey; served with yogurt/milk.',
  [
    ['Oats rolled', 0.08, 'kg'],
    ['Honey', 0.03, 'kg'],
    ['Almonds', 0.025, 'kg'],
    ['Whole milk', 0.2, 'l'],
  ]
);
add(
  'Tiramisu',
  'تيراميسو',
  18,
  'Bakery Corner',
  'Desserts',
  'Mascarpone cream, coffee-soaked sponge, cocoa.',
  [
    ['Mascarpone', 0.18, 'kg'],
    ['Eggs', 2, 'piece'],
    ['Sugar', 0.06, 'kg'],
    ['Espresso', 0.04, 'kg'],
    ['Cocoa powder', 0.015, 'kg'],
    ['Ladyfingers', 0.08, 'pack'],
  ]
);

// Tiramisu: sponge substitute
const tira = ROWS.find((r) => r.en === 'Tiramisu');
if (tira) {
  tira.ing = tira.ing.filter((x) => x[0] !== 'Ladyfingers');
  tira.ing.push(['Bread', 0.06, 'piece']);
}

// Granola: rolled oats name in DB is "Oats"
const granola = ROWS.find((r) => r.en === 'Granola');
if (granola) {
  granola.ing = [
    ['Oats', 0.08, 'kg'],
    ['Honey', 0.03, 'kg'],
    ['Almonds', 0.025, 'kg'],
    ['Whole milk', 0.2, 'l'],
  ];
}

// Normalize ingredient names to match inventory_items.name_en
for (const r of ROWS) {
  r.ing = r.ing.map((x) => {
    let [n, q, u] = x;
    if (n === 'Milk') n = 'Whole milk';
    if (n === 'Egg') n = 'Eggs';
    if (n === 'Cream') n = 'Heavy cream';
    return [n, q, u];
  });
}

// --- Breakfast
add(
  'Mediterranean Breakfast',
  'إفطار متوسطي',
  50,
  'Breakfast',
  'Main Courses',
  'Eggs, cheese, olives, bread, labneh, salad.',
  [
    ['Eggs', 3, 'piece'],
    ['Feta cheese', 0.08, 'kg'],
    ['Olives green', 0.06, 'kg'],
    ['Bread', 3, 'piece'],
    ['Labneh', 0.12, 'kg'],
    ['Tomato', 0.1, 'kg'],
    ['Cucumber', 0.08, 'kg'],
    ['Olive oil', 0.02, 'l'],
  ]
);
add(
  'Continental Breakfast',
  'إفطار كونتيننتال',
  70,
  'Breakfast',
  'Main Courses',
  'Eggs, halal beef sausage-style mince patty, potato hash, toast, butter.',
  [
    ['Eggs', 3, 'piece'],
    ['Ground beef', 0.15, 'kg'],
    ['Potato', 0.2, 'kg'],
    ['Bread', 3, 'piece'],
    ['Butter', 0.04, 'kg'],
    ['Salt', 0.003, 'kg'],
    ['Black pepper', 0.002, 'kg'],
  ]
);
add(
  'Arabic Breakfast',
  'إفطار عربي',
  50,
  'Breakfast',
  'Main Courses',
  'Foul, falafel-style chickpea fritters, hummus, eggs, pickles, pita.',
  [
    ['Chickpeas canned', 0.4, 'can'],
    ['Hummus', 0.15, 'kg'],
    ['Eggs', 2, 'piece'],
    ['Pita bread', 3, 'piece'],
    ['Cucumber', 0.08, 'kg'],
    ['Tahini', 0.03, 'kg'],
    ['Lemon juice', 0.01, 'l'],
    ['Garlic', 0.01, 'kg'],
    ['Cumin', 0.003, 'kg'],
  ]
);
add(
  'Kids Breakfast',
  'إفطار أطفال',
  25,
  'Breakfast',
  'Main Courses',
  'Mini pancakes, scrambled eggs, fresh juice components.',
  [
    ['Flour', 0.06, 'kg'],
    ['Milk', 0.1, 'l'],
    ['Eggs', 2, 'piece'],
    ['Sugar', 0.02, 'kg'],
    ['Butter', 0.02, 'kg'],
    ['Orange', 0.2, 'kg'],
  ]
);

// --- Coffee & Hot Drinks (yields approximated from standard espresso/milk ratios; filter per SCAA guidelines)
add(
  'Espresso (1 oz)',
  'إسبريسو (١ أونصة)',
  12,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Single espresso shot (~18–20 g liquid); ~9–10 g ground coffee in (typical double basket yield split).',
  [['Arabica coffee beans', 0.012, 'kg']]
);
add(
  'Double Espresso (2 oz)',
  'إسبريسو مزدوج',
  16,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Two espresso shots; ~18–20 g coffee in.',
  [['Arabica coffee beans', 0.022, 'kg']]
);
add(
  'Special Espresso (1.5 oz)',
  'إسبريسو خاص',
  16,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso shot with condensed milk sweetness.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Condensed milk', 0.025, 'can'],
  ]
);
add(
  'Macchiato (2 oz)',
  'ماكياتو',
  14,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso marked with foamed milk.',
  [
    ['Arabica coffee beans', 0.02, 'kg'],
    ['Whole milk', 0.06, 'l'],
  ]
);
add(
  'Americano (8 oz)',
  'أمريكانو',
  16,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso diluted with hot water.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
  ]
);
add(
  'Flat White (7 oz)',
  'فلات وايت',
  18,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Doubleristretto-style with velvety milk.',
  [
    ['Arabica coffee beans', 0.024, 'kg'],
    ['Whole milk', 0.16, 'l'],
  ]
);
add(
  'Cappuccino (8 oz)',
  'كابتشينو',
  18,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso, steamed milk, foam cap.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Whole milk', 0.18, 'l'],
  ]
);
add(
  'Latte (10 oz)',
  'لاتيه',
  18,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso with more steamed milk.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Whole milk', 0.22, 'l'],
  ]
);
add(
  'Matcha Latte (10 oz)',
  'لاتيه ماتشا',
  20,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Matcha powder with steamed milk.',
  [
    ['Matcha powder', 0.012, 'kg'],
    ['Whole milk', 0.24, 'l'],
    ['Sugar', 0.015, 'kg'],
  ]
);
add(
  'Spanish Latte (10 oz)',
  'لاتيه إسباني',
  20,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso, milk, condensed milk.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Whole milk', 0.18, 'l'],
    ['Condensed milk', 0.03, 'can'],
  ]
);
add(
  'Mocha Latte (10 oz)',
  'موكا لاتيه',
  20,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Espresso, chocolate sauce, steamed milk.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Chocolate sauce', 0.035, 'kg'],
    ['Whole milk', 0.2, 'l'],
  ]
);
add(
  'Hot Chocolate (10 oz)',
  'شوكولاتة ساخنة',
  18,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Cocoa powder, milk, sugar.',
  [
    ['Cocoa powder', 0.025, 'kg'],
    ['Whole milk', 0.28, 'l'],
    ['Sugar', 0.03, 'kg'],
  ]
);
add(
  'V60 Coffee (8.5 oz)',
  'قهوة V60',
  20,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Pour-over filter coffee (manual brew).',
  [['Arabica coffee beans', 0.028, 'kg']]
);
add(
  'Turkish Coffee (3 oz)',
  'قهوة تركية',
  14,
  'Coffee & Hot Drinks',
  'Hot Drinks',
  'Fine-ground coffee, water, optional sugar.',
  [
    ['Turkish coffee ground', 0.015, 'kg'],
    ['Sugar', 0.01, 'kg'],
  ]
);

// --- Tea & Specialty
add(
  'Tunisian Mint Tea (7 oz)',
  'شاي تونسي بالنعناع',
  10,
  'Tea & Specialty',
  'Hot Drinks',
  'Green tea, fresh mint, sugar.',
  [
    ['Green tea', 0.008, 'kg'],
    ['Mint', 0.02, 'kg'],
    ['Sugar', 0.025, 'kg'],
  ]
);
add(
  'Tea w/ Almonds/Hazelnut (7.5 oz)',
  'شاي باللوز/البندق',
  16,
  'Tea & Specialty',
  'Hot Drinks',
  'Mint tea with toasted nuts.',
  [
    ['Green tea', 0.008, 'kg'],
    ['Mint', 0.015, 'kg'],
    ['Almonds', 0.015, 'kg'],
    ['Hazelnuts', 0.012, 'kg'],
    ['Sugar', 0.02, 'kg'],
  ]
);
add(
  'Moroccan Mint Tea (7 oz)',
  'شاي مغربي',
16,
  'Tea & Specialty',
  'Hot Drinks',
  'Strong green tea with mint.',
  [
    ['Green tea', 0.012, 'kg'],
    ['Mint', 0.025, 'kg'],
    ['Sugar', 0.03, 'kg'],
  ]
);
add(
  'Flavors Tea (8 oz)',
  'شاي نكهات',
  12,
  'Tea & Specialty',
  'Hot Drinks',
  'Fruit or herbal tea selection.',
  [
    ['Hibiscus tea', 0.01, 'kg'],
    ['Sugar', 0.015, 'kg'],
  ]
);
add(
  'Maazym Baklawa Tea (8 oz)',
  'شاي بقلاوة معاظم',
  22,
  'Tea & Specialty',
  'Hot Drinks',
  'Signature spiced tea with honey-nut notes.',
  [
    ['Chai tea', 0.01, 'kg'],
    ['Honey', 0.02, 'kg'],
    ['Pistachios', 0.01, 'kg'],
    ['Cinnamon powder', 0.002, 'kg'],
  ]
);

// --- Iced Classics (Affogato excluded — ice cream retail)
add(
  'Iced V60 (10 oz)',
  'V60 مثلج',
  20,
  'The Iced Classics',
  'Cold Drinks',
  'Cold filtered coffee over ice.',
  [['Arabica coffee beans', 0.03, 'kg']]
);
add(
  'Iced Americano (11 oz)',
  'أمريكانو مثلج',
  16,
  'The Iced Classics',
  'Cold Drinks',
  'Espresso + cold water + ice.',
  [['Arabica coffee beans', 0.024, 'kg']]
);
add(
  'Iced Latte (12 oz)',
  'لاتيه مثلج',
  18,
  'The Iced Classics',
  'Cold Drinks',
  'Espresso, chilled milk, ice.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Whole milk', 0.22, 'l'],
  ]
);
add(
  'Iced Spanish Latte (12 oz)',
  'لاتيه إسباني مثلج',
  20,
  'The Iced Classics',
  'Cold Drinks',
  'Espresso, condensed milk, cold milk, ice.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Condensed milk', 0.03, 'can'],
    ['Whole milk', 0.18, 'l'],
  ]
);
add(
  'Iced Mocha Latte (12 oz)',
  'موكا مثلج',
  20,
  'The Iced Classics',
  'Cold Drinks',
  'Espresso, chocolate, milk, ice.',
  [
    ['Arabica coffee beans', 0.022, 'kg'],
    ['Chocolate sauce', 0.035, 'kg'],
    ['Whole milk', 0.2, 'l'],
  ]
);
add(
  'Iced Matcha Latte (12 oz)',
  'ماتشا مثلج',
  20,
  'The Iced Classics',
  'Cold Drinks',
  'Matcha, milk, ice.',
  [
    ['Matcha powder', 0.014, 'kg'],
    ['Whole milk', 0.24, 'l'],
    ['Sugar', 0.02, 'kg'],
  ]
);
add(
  'Extra Syrup (1 oz)',
  'شراب إضافي',
3,
  'The Iced Classics',
  'Cold Drinks',
  'Vanilla, caramel, or hazelnut pump.',
  [['Vanilla syrup', 0.03, 'l']]
);
add(
  'Maazym Customized Drink (12 oz)',
  'مشروب معاظم مخصص',
  25,
  'The Iced Classics',
  'Cold Drinks',
  'House blend to guest preference (base + syrup + milk).',
  [
    ['Arabica coffee beans', 0.018, 'kg'],
    ['Whole milk', 0.18, 'l'],
    ['Vanilla syrup', 0.015, 'l'],
  ]
);

// --- Cold Drinks & Water (kitchen-made only; no bottled retail)
add(
  'Classic Mojito (14 oz)',
  'موهيتو كلاسيكي',
  20,
  'Cold Drinks & Water',
  'Mocktails',
  'Lime, mint, soda-style mixer, sugar.',
  [
    ['Lime', 0.06, 'kg'],
    ['Mint', 0.015, 'kg'],
    ['Sugar', 0.03, 'kg'],
    ['Lemon juice', 0.02, 'l'],
  ]
);
add(
  'Strawberry Mojito (14 oz)',
  'موهيتو فراولة',
  22,
  'Cold Drinks & Water',
  'Mocktails',
  'Strawberry, lime, mint, sugar.',
  [
    ['Strawberry', 0.12, 'kg'],
    ['Lime', 0.04, 'kg'],
    ['Mint', 0.012, 'kg'],
    ['Sugar', 0.025, 'kg'],
  ]
);
add(
  'Mango Mojito (14 oz)',
  'موهيتو مانجو',
  22,
  'Cold Drinks & Water',
  'Mocktails',
  'Mango, lime, mint, sugar.',
  [
    ['Mango', 0.15, 'kg'],
    ['Lime', 0.04, 'kg'],
    ['Mint', 0.012, 'kg'],
    ['Sugar', 0.025, 'kg'],
  ]
);
add(
  'Passion Fruit Mojito (14 oz)',
  'موهيتو فاكهة العاطفة',
  22,
  'Cold Drinks & Water',
  'Mocktails',
  'Passion fruit, lime, mint, sugar.',
  [
    ['Passion fruit', 0.08, 'kg'],
    ['Lime', 0.04, 'kg'],
    ['Mint', 0.012, 'kg'],
    ['Sugar', 0.025, 'kg'],
  ]
);
add(
  'Tunisian Lemonade (12 oz)',
  'ليمونادة تونسية',
  15,
  'Cold Drinks & Water',
  'Fresh Juices',
  'Lemon, mint, orange blossom water.',
  [
    ['Lemon juice', 0.05, 'l'],
    ['Sugar', 0.04, 'kg'],
    ['Mint', 0.01, 'kg'],
    ['Orange blossom water', 0.005, 'l'],
  ]
);
add(
  'Fresh Juice Maazym (12 oz)',
  'عصير طازج معاظم',
  18,
  'Cold Drinks & Water',
  'Fresh Juices',
  'Seasonal fresh fruit blend.',
  [
    ['Orange', 0.25, 'kg'],
    ['Carrot', 0.1, 'kg'],
 ['Apple', 0.15, 'kg'],
  ]
);
add(
  'Vanilla Milkshake (14 oz)',
  'ميلك شيك فانيليا',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Milk, vanilla syrup, frozen yogurt base.',
  [
    ['Whole milk', 0.22, 'l'],
    ['Vanilla syrup', 0.04, 'l'],
    ['Frozen yogurt base', 0.12, 'kg'],
  ]
);
add(
  'Chocolate Milkshake (14 oz)',
  'ميلك شيك شوكولاتة',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Milk, chocolate sauce, frozen yogurt base.',
  [
    ['Whole milk', 0.22, 'l'],
    ['Chocolate sauce', 0.06, 'kg'],
    ['Frozen yogurt base', 0.12, 'kg'],
  ]
);
add(
  'Strawberry Milkshake (14 oz)',
  'ميلك شيك فراولة',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Milk, fresh strawberry, frozen yogurt base.',
  [
    ['Whole milk', 0.22, 'l'],
    ['Strawberry', 0.15, 'kg'],
    ['Frozen yogurt base', 0.1, 'kg'],
  ]
);
add(
  'Mango Milkshake (14 oz)',
  'ميلك شيك مانجو',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Milk, mango, frozen yogurt base.',
  [
    ['Whole milk', 0.22, 'l'],
    ['Mango', 0.18, 'kg'],
    ['Frozen yogurt base', 0.1, 'kg'],
  ]
);
add(
  'Pineapple Milkshake (14 oz)',
  'ميلك شيك أناناس',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Milk, pineapple, frozen yogurt base.',
  [
    ['Whole milk', 0.22, 'l'],
    ['Pineapple', 0.18, 'kg'],
    ['Frozen yogurt base', 0.1, 'kg'],
  ]
);
add(
  'Piña Colada (14 oz)',
  'بينيا كولادا',
  25,
  'Cold Drinks & Water',
  'Mocktails',
  'Pineapple, coconut milk, crushed ice blend.',
  [
    ['Pineapple', 0.2, 'kg'],
    ['Coconut milk', 0.12, 'l'],
    ['Sugar', 0.02, 'kg'],
  ]
);
add(
  'Tropical Sunset (14 oz)',
  'غروب استوائي',
  25,
  'Cold Drinks & Water',
  'Mocktails',
  'Orange, pineapple, grenadine-style syrup, mango.',
  [
    ['Orange', 0.15, 'kg'],
    ['Pineapple', 0.12, 'kg'],
    ['Mango', 0.1, 'kg'],
    ['Rose syrup', 0.015, 'l'],
  ]
);
add(
  'Boba Drink (16 oz)',
  'مشروب بوبا',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Tea base, milk, caramel syrup (tapioca pearls optional retail).',
  [
    ['English Breakfast tea', 0.008, 'kg'],
    ['Whole milk', 0.2, 'l'],
    ['Caramel syrup', 0.02, 'l'],
  ]
);
add(
  'Jwajem Maazym (15 oz)',
  'جواجم معاظم',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Mixed fruit, cream, nuts, honey.',
  [
    ['Mango', 0.1, 'kg'],
    ['Strawberry', 0.08, 'kg'],
    ['Heavy cream', 0.08, 'l'],
    ['Honey', 0.025, 'kg'],
    ['Almonds', 0.015, 'kg'],
    ['Walnuts', 0.015, 'kg'],
  ]
);
add(
  'Smoothie Maazym (14 oz)',
  'سموذي معاظم',
  25,
  'Cold Drinks & Water',
  'Cold Drinks',
  'Blended frozen fruit with yogurt base.',
  [
    ['Smoothie base mix', 0.1, 'kg'],
    ['Frozen berries mix', 0.12, 'kg'],
    ['Whole milk', 0.15, 'l'],
  ]
);

// Post-ingredient normalization (again for newly added rows)
for (const r of ROWS) {
  r.ing = r.ing.map((x) => {
    let [n, q, u] = x;
    if (n === 'Milk') n = 'Whole milk';
    if (n === 'Egg') n = 'Eggs';
    if (n === 'Cream') n = 'Heavy cream';
    return [n, q, u];
  });
}

// Fix inventory names that may differ
const invAlias = { 'Cinnamon powder': 'Cinnamon' };
for (const r of ROWS) {
  r.ing = r.ing.map((x) => {
    const n = invAlias[x[0]] ?? x[0];
    return [n, x[1], x[2]];
  });
}

for (const r of ROWS) {
  const mapped = RECIPE_DESCRIPTION_AR[r.en];
  if (mapped == null) {
    console.warn('[gen-menu] Missing RECIPE_DESCRIPTION_AR for:', r.en);
  }
  r.desc_ar =
    mapped ??
    `${r.ar} — يُرجى إكمال وصف خطوات التحضير بالعربية في دفتر الوصفات.`;
}

function esc(s) {
  return String(s).replace(/'/g, "''");
}

const recipeUuids = ROWS.map((_, i) => rid(i + 1));
const menuUuids = ROWS.map((_, i) => mid(i + 1));

let sql = `-- MAAZYM MENU V02: recipes + menu_items (kitchen & café). Excludes: Ice Cream, Shisha, Soft Drinks & Water retail.
-- Run after migrations 00001–00004. Requires inventory_items + categories + menu_sections for branch ${BRANCH}.
-- Ingredient rows only inserted when inventory_items.name_en matches.

BEGIN;

DELETE FROM recipe_ingredients WHERE recipe_id IN (${recipeUuids.map((u) => `'${u}'::uuid`).join(', ')});
DELETE FROM menu_items WHERE id IN (${menuUuids.map((u) => `'${u}'::uuid`).join(', ')});
DELETE FROM recipes WHERE id IN (${recipeUuids.map((u) => `'${u}'::uuid`).join(', ')});

`;

for (let i = 0; i < ROWS.length; i++) {
  const r = ROWS[i];
  const uuid = recipeUuids[i];
  sql += `INSERT INTO recipes (id, category_id, name_ar, name_en, description_ar, description_en, branch_id, prep_time_minutes, serving_size)
SELECT '${uuid}'::uuid, c.id, '${esc(r.ar)}', '${esc(r.en)}', '${esc(r.desc_ar)}', '${esc(r.desc)}', '${BRANCH}'::uuid, 20, 1
FROM categories c WHERE c.branch_id = '${BRANCH}'::uuid AND c.name_en = '${esc(r.cat)}' AND c.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en, description_ar = EXCLUDED.description_ar, description_en = EXCLUDED.description_en,
  category_id = EXCLUDED.category_id, updated_at = now();

`;
}

for (let i = 0; i < ROWS.length; i++) {
  const r = ROWS[i];
  const uuid = recipeUuids[i];
  for (const [name, qty, unit] of r.ing) {
    sql += `INSERT INTO recipe_ingredients (recipe_id, inventory_item_id, quantity, unit)
SELECT '${uuid}'::uuid, ii.id, ${qty}, '${unit}'
FROM inventory_items ii
WHERE ii.branch_id = '${BRANCH}'::uuid AND ii.name_en = '${esc(name)}' AND ii.is_active = true
LIMIT 1;

`;
  }
}

// display_order: per section
const orderBySection = {};
for (let i = 0; i < ROWS.length; i++) {
  const r = ROWS[i];
  orderBySection[r.section] = (orderBySection[r.section] ?? 0) + 1;
  const ord = orderBySection[r.section];
  const muid = menuUuids[i];
  const ruuid = recipeUuids[i];
  sql += `INSERT INTO menu_items (id, recipe_id, section_id, name_ar, name_en, selling_price, is_available, display_order, branch_id)
SELECT '${muid}'::uuid, '${ruuid}'::uuid, ms.id, '${esc(r.ar)}', '${esc(r.en)}', ${r.price}, true, ${ord}, '${BRANCH}'::uuid
FROM menu_sections ms
WHERE ms.branch_id = '${BRANCH}'::uuid AND ms.name_en = '${esc(r.section)}' AND ms.is_active = true
LIMIT 1
ON CONFLICT (id) DO UPDATE SET
  recipe_id = EXCLUDED.recipe_id, section_id = EXCLUDED.section_id, name_ar = EXCLUDED.name_ar, name_en = EXCLUDED.name_en,
  selling_price = EXCLUDED.selling_price, display_order = EXCLUDED.display_order;

`;
}

sql += `COMMIT;
`;

const out = join(__dirname, '..', 'supabase', 'migrations', '00005_maazym_pdf_menu.sql');
writeFileSync(out, sql, 'utf8');
console.log('Wrote', out, ROWS.length, 'recipes/menu items');

const patchPath = join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '00008_recipe_description_ar_translations.sql'
);
const branchUuid = `'${BRANCH}'::uuid`;
let patchSql = `-- Arabic preparation descriptions (matches description_en). UPDATE only; keeps images and IDs.
-- Apply after 00005–00007 if recipes already exist with English-only descriptions.

BEGIN;

`;
for (const r of ROWS) {
  patchSql += `UPDATE recipes SET description_ar = '${esc(r.desc_ar)}', updated_at = now() WHERE name_en = '${esc(r.en)}' AND branch_id = ${branchUuid};

`;
}
patchSql += `COMMIT;
`;
writeFileSync(patchPath, patchSql, 'utf8');
console.log('Wrote', patchPath);
