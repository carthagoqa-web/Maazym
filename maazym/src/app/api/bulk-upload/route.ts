import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role, branch_id')
    .eq('id', user.id)
    .single();

  if (!profile || !['admin', 'manager', 'purchasing_manager'].includes(profile.role)) {
    return NextResponse.json({ error: 'Insufficient permissions' }, { status: 403 });
  }

  const body = await request.json();
  const { type, rows } = body;
  const branchId = profile.branch_id || '00000000-0000-0000-0000-000000000001';

  let inserted = 0;
  let updated = 0;
  const errors: string[] = [];

  try {
    switch (type) {
      case 'inventory_items': {
        const { data: categories } = await supabase
          .from('inventory_categories')
          .select('id, name_en')
          .eq('branch_id', branchId);
        const catMap = new Map((categories || []).map((c: any) => [String(c.name_en).trim().toLowerCase(), c.id]));

        const { data: existingItems } = await supabase
          .from('inventory_items')
          .select('id, name_en')
          .eq('branch_id', branchId)
          .eq('is_active', true);

        const itemsById = new Map((existingItems || []).map((it: { id: string; name_en: string }) => [it.id, it]));
        const nameToId = new Map<string, string>();
        for (const it of existingItems || []) {
          const k = String(it.name_en ?? '').trim().toLowerCase();
          if (k && !nameToId.has(k)) nameToId.set(k, it.id);
        }

        const validUnits = ['kg', 'g', 'l', 'ml', 'piece', 'pack', 'box', 'bag', 'bottle', 'can'];

        function parseUuidCell(v: unknown): string | null {
          const t = String(v ?? '').trim();
          if (!t) return null;
          if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(t)) return null;
          return t;
        }

        function normalizeNameKey(v: unknown): string {
          return String(v ?? '').trim().toLowerCase();
        }

        for (let i = 0; i < rows.length; i++) {
          const row = rows[i] as unknown[];
          let itemIdRaw: unknown;
          let nameAr: unknown;
          let nameEn: unknown;
          let category: unknown;
          let unit: unknown;
          let unitCost: unknown;
          let calories: unknown;

          if (row.length >= 7) {
            [itemIdRaw, nameAr, nameEn, category, unit, unitCost, calories] = row;
          } else if (row.length >= 6) {
            itemIdRaw = null;
            [nameAr, nameEn, category, unit, unitCost, calories] = row;
          } else {
            errors.push(`Row ${i + 2}: Expected 6 columns (legacy) or 7 columns (with Item ID)`);
            continue;
          }

          const nameArStr = String(nameAr ?? '').trim();
          const nameEnStr = String(nameEn ?? '').trim();
          if (!nameArStr || !nameEnStr) {
            errors.push(`Row ${i + 2}: Missing name`);
            continue;
          }

          const catId = catMap.get(String(category ?? '').trim().toLowerCase());
          if (!catId) {
            errors.push(`Row ${i + 2}: Unknown category "${category}"`);
            continue;
          }

          const unitStr = String(unit ?? '').trim();
          if (!validUnits.includes(unitStr)) {
            errors.push(`Row ${i + 2}: Invalid unit "${unit}"`);
            continue;
          }

          const costNum = parseFloat(String(unitCost)) || 0;
          const calStr = String(calories ?? '').trim();
          const caloriesNum =
            calStr === '' ? null : (Number.isFinite(parseFloat(calStr)) ? parseFloat(calStr) : null);

          const uuid = parseUuidCell(itemIdRaw);
          let targetId: string | null = null;
          if (uuid && itemsById.has(uuid)) {
            targetId = uuid;
          } else {
            const byName = nameToId.get(normalizeNameKey(nameEnStr));
            if (byName) targetId = byName;
          }

          const payload = {
            name_ar: nameArStr,
            name_en: nameEnStr,
            category_id: catId,
            unit: unitStr,
            unit_cost: costNum,
            calories_per_unit: caloriesNum,
            branch_id: branchId,
            is_active: true,
          };

          if (targetId) {
            const { error } = await supabase.from('inventory_items').update(payload).eq('id', targetId);
            if (error) {
              errors.push(`Row ${i + 2}: ${error.message}`);
            } else {
              updated++;
              for (const [k, v] of [...nameToId.entries()]) {
                if (v === targetId) nameToId.delete(k);
              }
              nameToId.set(normalizeNameKey(nameEnStr), targetId);
            }
          } else {
            const { data: newRow, error } = await supabase
              .from('inventory_items')
              .insert(payload)
              .select('id, name_en')
              .single();

            if (error) {
              errors.push(`Row ${i + 2}: ${error.message}`);
            } else if (newRow) {
              inserted++;
              itemsById.set(newRow.id, newRow);
              const nk = normalizeNameKey(newRow.name_en);
              if (nk && !nameToId.has(nk)) nameToId.set(nk, newRow.id);
            }
          }
        }
        break;
      }

      case 'suppliers': {
        for (let i = 0; i < rows.length; i++) {
          const [name, contact, phone, email, address, halal] = rows[i];
          if (!name) { errors.push(`Row ${i + 2}: Missing supplier name`); continue; }
          const { error } = await supabase.from('suppliers').insert({
            name, contact_person: contact || null, phone: phone || null,
            email: email || null, address: address || null,
            is_halal_certified: String(halal).toLowerCase() === 'yes',
            branch_id: branchId,
          });
          if (error) { errors.push(`Row ${i + 2}: ${error.message}`); } else { inserted++; }
        }
        break;
      }

      case 'menu_items': {
        const { data: sections } = await supabase
          .from('menu_sections')
          .select('id, name_en')
          .eq('branch_id', branchId);
        const secMap = new Map((sections || []).map((s: any) => [s.name_en.toLowerCase(), s.id]));

        for (let i = 0; i < rows.length; i++) {
          const [nameAr, nameEn, section, price, available] = rows[i];
          if (!nameAr || !nameEn) { errors.push(`Row ${i + 2}: Missing name`); continue; }
          const secId = secMap.get((section || '').toLowerCase());

          const { error } = await supabase.from('menu_items').insert({
            name_ar: nameAr, name_en: nameEn, section_id: secId || null,
            selling_price: parseFloat(price) || 0,
            is_available: String(available).toLowerCase() !== 'no',
            branch_id: branchId,
          });
          if (error) { errors.push(`Row ${i + 2}: ${error.message}`); } else { inserted++; }
        }
        break;
      }

      case 'current_stock': {
        if (!['admin', 'manager', 'purchasing_manager'].includes(profile.role)) {
          return NextResponse.json({ error: 'Admin only' }, { status: 403 });
        }
        const { data: items } = await supabase
          .from('inventory_items')
          .select('id, name_en')
          .eq('branch_id', branchId);
        const itemMap = new Map((items || []).map((it: any) => [it.name_en.toLowerCase(), it.id]));

        for (let i = 0; i < rows.length; i++) {
          const [itemName, qty, minLevel] = rows[i];
          const itemId = itemMap.get((itemName || '').toLowerCase());
          if (!itemId) { errors.push(`Row ${i + 2}: Unknown item "${itemName}"`); continue; }

          const { error } = await supabase.from('stock_levels').update({
            current_quantity: parseFloat(qty) || 0,
            zero_stock_level: parseFloat(minLevel) || 0,
          }).eq('item_id', itemId);
          if (error) { errors.push(`Row ${i + 2}: ${error.message}`); } else { inserted++; }
        }
        break;
      }

      case 'purchase_orders': {
        const { data: suppliers } = await supabase.from('suppliers').select('id, name').eq('branch_id', branchId);
        const supMap = new Map((suppliers || []).map((s: any) => [s.name.toLowerCase(), s.id]));
        const { data: items } = await supabase.from('inventory_items').select('id, name_en').eq('branch_id', branchId);
        const itemMap = new Map((items || []).map((it: any) => [it.name_en.toLowerCase(), it.id]));

        const poGroups = new Map<string, { supplierId: string; orderDate: string; expectedDelivery: string; items: any[] }>();

        for (let i = 0; i < rows.length; i++) {
          const [supName, itemName, qty, unitPrice, orderDate, expectedDelivery] = rows[i];
          const supplierId = supMap.get((supName || '').toLowerCase());
          const itemId = itemMap.get((itemName || '').toLowerCase());
          if (!supplierId) { errors.push(`Row ${i + 2}: Unknown supplier "${supName}"`); continue; }
          if (!itemId) { errors.push(`Row ${i + 2}: Unknown item "${itemName}"`); continue; }

          const key = `${supplierId}_${orderDate}_${expectedDelivery}`;
          if (!poGroups.has(key)) {
            poGroups.set(key, { supplierId, orderDate: String(orderDate), expectedDelivery: String(expectedDelivery), items: [] });
          }
          poGroups.get(key)!.items.push({ itemId, quantity: parseFloat(qty) || 0, unitPrice: parseFloat(unitPrice) || 0 });
        }

        for (const [, group] of poGroups) {
          const total = group.items.reduce((s: number, it: any) => s + it.quantity * it.unitPrice, 0);
          const { data: po, error: poErr } = await supabase.from('purchase_orders').insert({
            supplier_id: group.supplierId, status: 'draft', total_amount: total,
            order_date: group.orderDate, expected_delivery: group.expectedDelivery,
            created_by: user.id, branch_id: branchId,
          }).select().single();

          if (poErr) { errors.push(`PO creation failed: ${poErr.message}`); continue; }

          for (const item of group.items) {
            const { error } = await supabase.from('purchase_order_items').insert({
              po_id: po.id, inventory_item_id: item.itemId,
              quantity: item.quantity, unit_price: item.unitPrice,
            });
            if (error) { errors.push(`PO item: ${error.message}`); } else { inserted++; }
          }
        }
        break;
      }

      case 'waste_logs': {
        const { data: items } = await supabase.from('inventory_items').select('id, name_en').eq('branch_id', branchId);
        const itemMap = new Map((items || []).map((it: any) => [it.name_en.toLowerCase(), it.id]));
        const validReasons = ['expired', 'spoiled', 'preparation', 'other'];

        for (let i = 0; i < rows.length; i++) {
          const [itemName, qty, reason, wasteDate, notes] = rows[i];
          const itemId = itemMap.get((itemName || '').toLowerCase());
          if (!itemId) { errors.push(`Row ${i + 2}: Unknown item "${itemName}"`); continue; }
          if (!validReasons.includes(reason)) { errors.push(`Row ${i + 2}: Invalid reason "${reason}"`); continue; }

          const { error } = await supabase.from('waste_logs').insert({
            item_id: itemId, quantity: parseFloat(qty) || 0,
            reason, waste_date: String(wasteDate),
            logged_by: user.id, notes: notes || null, branch_id: branchId,
          });
          if (error) { errors.push(`Row ${i + 2}: ${error.message}`); } else { inserted++; }
        }
        break;
      }

      default:
        return NextResponse.json({ error: 'Invalid type' }, { status: 400 });
    }
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }

  return NextResponse.json({ inserted, updated, errors, total: rows.length });
}
