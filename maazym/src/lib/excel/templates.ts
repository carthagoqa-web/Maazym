import * as XLSX from 'xlsx';

export type TemplateType = 'inventory_items' | 'suppliers' | 'menu_items' | 'current_stock' | 'purchase_orders' | 'waste_logs';

interface TemplateConfig {
  sheetName: string;
  headers: string[];
  sampleRows: (string | number)[][];
  notes: string[];
}

const TEMPLATES: Record<TemplateType, TemplateConfig> = {
  inventory_items: {
    sheetName: 'Inventory Items',
    headers: [
      'Item ID (leave empty for new rows)',
      'Name (Arabic)',
      'Name (English)',
      'Category (English)',
      'Unit (kg/g/l/ml/piece/pack/box/bag/bottle/can)',
      'Unit Cost (QAR)',
      'Calories per Unit (optional)',
    ],
    sampleRows: [
      ['', 'دجاج', 'Chicken Breast', 'Proteins', 'kg', 25.0, 165],
      ['', 'طماطم', 'Tomato', 'Vegetables', 'kg', 3.5, 18],
      ['', 'حليب', 'Whole Milk', 'Dairy', 'l', 5.0, 61],
      ['', 'مناديل', 'Tissues', 'Supplies', 'pack', 2.0, ''],
      ['', 'أكواب ورقية', 'Paper Cups', 'Supplies', 'pack', 8.0, ''],
    ],
    notes: [
      'Export from the Items page to download current rows with real Item IDs — edit costs and re-upload to update without duplicates.',
      'New rows: leave Item ID empty. Existing rows: keep the Item ID or match by Name (English) within your branch.',
      'Categories must match existing inventory categories (English name): Proteins, Vegetables, Fruits, Dairy, Grains, Spices, Oils & Fats, Beverages, Dry Goods, Frozen, Bakery, Sauces & Condiments, Packaging, Cleaning Supplies',
      'Valid units: kg, g, l, ml, piece, pack, box, bag, bottle, can',
      'Calories are optional - leave empty for non-food items',
      'All items must be Halal - no pork or alcohol products',
    ],
  },
  suppliers: {
    sheetName: 'Suppliers',
    headers: ['Supplier Name', 'Contact Person', 'Phone', 'Email', 'Address', 'Halal Certified (yes/no)'],
    sampleRows: [
      ['Al Meera Foods', 'Ahmed Hassan', '+974-5555-1234', 'ahmed@almeera.qa', 'Industrial Area, Doha', 'yes'],
      ['Gulf Supplies Co', 'Sara Ali', '+974-5555-5678', 'sara@gulfsupplies.qa', 'Salwa Road, Doha', 'yes'],
    ],
    notes: [
      'Halal Certified: enter "yes" or "no"',
      'Phone and email are optional but recommended',
    ],
  },
  menu_items: {
    sheetName: 'Menu Items',
    headers: ['Name (Arabic)', 'Name (English)', 'Section (English)', 'Selling Price (QAR)', 'Available (yes/no)'],
    sampleRows: [
      ['برجر لحم', 'Beef Burger', 'Main Courses', 45.00, 'yes'],
      ['سلطة سيزر', 'Caesar Salad', 'Salads', 28.00, 'yes'],
      ['عصير برتقال', 'Orange Juice', 'Beverages', 18.00, 'yes'],
    ],
    notes: [
      'Sections must match existing menu sections (English name): Appetizers, Salads, Main Courses, Desserts, Beverages',
      'Available: enter "yes" or "no"',
      'Recipe linking is done separately in the app after import',
    ],
  },
  current_stock: {
    sheetName: 'Current Stock',
    headers: ['Item Name (English)', 'Current Quantity', 'Minimum Stock Level'],
    sampleRows: [
      ['Chicken Breast', 50.00, 10.00],
      ['Tomato', 30.00, 5.00],
      ['Whole Milk', 20.00, 5.00],
    ],
    notes: [
      'Item names must match existing inventory items (English name)',
      'This updates stock_levels for existing items',
      'Admin only operation',
    ],
  },
  purchase_orders: {
    sheetName: 'Purchase Orders',
    headers: ['Supplier Name', 'Item Name (English)', 'Quantity', 'Unit Price (QAR)', 'Order Date (YYYY-MM-DD)', 'Expected Delivery (YYYY-MM-DD)'],
    sampleRows: [
      ['Al Meera Foods', 'Chicken Breast', 100, 24.00, '2026-04-15', '2026-04-17'],
      ['Al Meera Foods', 'Tomato', 50, 3.00, '2026-04-15', '2026-04-17'],
      ['Gulf Supplies Co', 'Tissues', 200, 1.80, '2026-04-15', '2026-04-18'],
    ],
    notes: [
      'All items for the same supplier + same dates will be grouped into one PO',
      'Supplier names must match existing suppliers',
      'Item names must match existing inventory items (English name)',
      'Dates must be in YYYY-MM-DD format',
    ],
  },
  waste_logs: {
    sheetName: 'Waste Logs',
    headers: ['Item Name (English)', 'Quantity', 'Reason (expired/spoiled/preparation/other)', 'Waste Date (YYYY-MM-DD)', 'Notes'],
    sampleRows: [
      ['Tomato', 2.5, 'spoiled', '2026-04-12', 'Overripe'],
      ['Whole Milk', 1.0, 'expired', '2026-04-12', 'Past expiry date'],
    ],
    notes: [
      'Item names must match existing inventory items (English name)',
      'Valid reasons: expired, spoiled, preparation, other',
      'Stock will be auto-deducted via database trigger',
      'Notes are optional',
    ],
  },
};

export interface InventoryItemExportRow {
  id: string;
  name_ar: string;
  name_en: string;
  category_name_en: string;
  unit: string;
  unit_cost: number;
  calories_per_unit: number | null;
}

const INVENTORY_EXPORT_HEADERS = [
  'Item ID',
  'Name (Arabic)',
  'Name (English)',
  'Category (English)',
  'Unit (kg/g/l/ml/piece/pack/box/bag/bottle/can)',
  'Unit Cost (QAR)',
  'Calories per Unit (optional)',
] as const;

/** Workbook of current branch items for edit-and-re-import (round-trip with bulk upload). */
export function downloadInventoryItemsExport(rows: InventoryItemExportRow[]) {
  const wb = XLSX.utils.book_new();
  const dataRows: (string | number)[][] = [
    [...INVENTORY_EXPORT_HEADERS],
    ...rows.map((r) => [
      r.id,
      r.name_ar,
      r.name_en,
      r.category_name_en,
      r.unit,
      r.unit_cost,
      r.calories_per_unit ?? '',
    ]),
  ];
  const ws = XLSX.utils.aoa_to_sheet(dataRows);
  const colWidths = INVENTORY_EXPORT_HEADERS.map((h, i) => {
    const lens = rows.map((row) => {
      const cells = [
        row.id,
        row.name_ar,
        row.name_en,
        row.category_name_en,
        row.unit,
        row.unit_cost,
        row.calories_per_unit ?? '',
      ];
      return String(cells[i] ?? '').length;
    });
    const maxLen = Math.max(h.length, ...lens);
    return { wch: Math.min(maxLen + 4, 50) };
  });
  ws['!cols'] = colWidths;
  XLSX.utils.book_append_sheet(wb, ws, TEMPLATES.inventory_items.sheetName);

  const notesWs = XLSX.utils.aoa_to_sheet([
    ['Instructions / Notes'],
    [],
    ...TEMPLATES.inventory_items.notes.map((n, i) => [`${i + 1}. ${n}`]),
    [],
    ['Edit unit cost and other fields, then use Bulk upload on the Items page.'],
    ['Leave Item ID blank on new rows; existing IDs update the same item when you re-import.'],
  ]);
  notesWs['!cols'] = [{ wch: 100 }];
  XLSX.utils.book_append_sheet(wb, notesWs, 'Instructions');

  XLSX.writeFile(wb, 'maazym_inventory_items_export.xlsx');
}

export function downloadTemplate(type: TemplateType) {
  const config = TEMPLATES[type];
  const wb = XLSX.utils.book_new();

  const dataRows = [config.headers, ...config.sampleRows];
  const ws = XLSX.utils.aoa_to_sheet(dataRows);

  const colWidths = config.headers.map((h, i) => {
    const maxLen = Math.max(
      h.length,
      ...config.sampleRows.map((r) => String(r[i] ?? '').length)
    );
    return { wch: Math.min(maxLen + 4, 40) };
  });
  ws['!cols'] = colWidths;

  XLSX.utils.book_append_sheet(wb, ws, config.sheetName);

  const notesWs = XLSX.utils.aoa_to_sheet([
    ['Instructions / Notes'],
    [],
    ...config.notes.map((n, i) => [`${i + 1}. ${n}`]),
    [],
    ['You may delete sample rows before uploading, or export current items from the app and edit that file.'],
    ['Keep the header row exactly as provided.'],
  ]);
  notesWs['!cols'] = [{ wch: 100 }];
  XLSX.utils.book_append_sheet(wb, notesWs, 'Instructions');

  XLSX.writeFile(wb, `maazym_template_${type}.xlsx`);
}

export function parseExcelFile(file: File): Promise<Record<string, any[][]>> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target?.result as ArrayBuffer);
        const wb = XLSX.read(data, { type: 'array' });
        const sheets: Record<string, any[][]> = {};
        wb.SheetNames.forEach((name) => {
          if (name !== 'Instructions') {
            sheets[name] = XLSX.utils.sheet_to_json(wb.Sheets[name], { header: 1 });
          }
        });
        resolve(sheets);
      } catch (err) {
        reject(err);
      }
    };
    reader.onerror = reject;
    reader.readAsArrayBuffer(file);
  });
}

export { TEMPLATES };
