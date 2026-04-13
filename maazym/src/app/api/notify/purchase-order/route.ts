import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { createServiceClient } from '@/lib/supabase/service';
import { applyTelegramTemplate, sendTelegramMessage } from '@/lib/telegram-notify';

function shortPoId(id: string) {
  return id.replace(/-/g, '').slice(0, 8).toUpperCase();
}

export async function POST(request: NextRequest) {
  let body: { purchase_order_id?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });
  }

  const purchaseOrderId = body.purchase_order_id;
  if (!purchaseOrderId || typeof purchaseOrderId !== 'string') {
    return NextResponse.json({ error: 'purchase_order_id required' }, { status: 400 });
  }

  const userClient = await createClient();
  const {
    data: { user },
  } = await userClient.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { data: poCheck, error: checkErr } = await userClient
    .from('purchase_orders')
    .select('id, status')
    .eq('id', purchaseOrderId)
    .maybeSingle();

  if (checkErr || !poCheck) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }
  if (poCheck.status !== 'submitted') {
    return NextResponse.json({ error: 'Order is not submitted' }, { status: 400 });
  }

  const service = createServiceClient();
  if (!service) {
    return NextResponse.json(
      { error: 'Server configuration: service role key missing', skipped: true },
      { status: 503 }
    );
  }

  const { data: integration } = await service.from('site_integrations').select('*').eq('id', 1).maybeSingle();

  const token = integration?.telegram_bot_token?.trim();
  const chatId = integration?.telegram_chat_id?.trim();
  if (!token || !chatId) {
    return NextResponse.json({ ok: true, skipped: true, reason: 'telegram_not_configured' });
  }

  const { data: po, error: poErr } = await service
    .from('purchase_orders')
    .select(
      `
      id,
      created_by,
      order_date,
      total_amount,
      status,
      branch_id,
      supplier:suppliers ( name ),
      items:purchase_order_items (
        quantity,
        inventory_item:inventory_items ( name_ar, name_en, unit )
      )
    `
    )
    .eq('id', purchaseOrderId)
    .maybeSingle();

  if (poErr || !po) {
    return NextResponse.json({ error: 'Failed to load order' }, { status: 500 });
  }

  const { data: branch } = po.branch_id
    ? await service.from('branches').select('name_ar, name_en').eq('id', po.branch_id).maybeSingle()
    : { data: null };

  const { data: creator } = po.created_by
    ? await service.from('profiles').select('full_name').eq('id', po.created_by).maybeSingle()
    : { data: null };

  const userName = creator?.full_name?.trim() || '—';
  const branchName = branch
    ? `${branch.name_en}${branch.name_ar && branch.name_ar !== branch.name_en ? ` / ${branch.name_ar}` : ''}`
    : '—';

  const supplierName = (po.supplier as { name?: string } | null)?.name ?? '—';

  const items = (po.items || []) as unknown as {
    quantity: number;
    inventory_item?: { name_en: string; name_ar: string; unit: string } | null;
  }[];

  const itemsList = items
    .map((line) => {
      const inv = line.inventory_item;
      const label = inv ? `${inv.name_en} (${inv.unit})` : 'Item';
      return `• ${label} × ${line.quantity}`;
    })
    .join('\n');

  const template =
    integration?.telegram_message_template?.trim() ||
    `Purchase order submitted\n\nBranch: {{branch_name}}\nOrdered by: {{user_name}}\nOrder date: {{order_date}}\nSupplier: {{supplier_name}}\nTotal: {{total_amount}} QAR\n\nItems:\n{{items_list}}\n\nRef: #{{po_short_id}}`;

  const text = applyTelegramTemplate(template, {
    branch_name: branchName,
    user_name: userName,
    order_date: String(po.order_date),
    supplier_name: supplierName,
    total_amount: Number(po.total_amount).toFixed(2),
    items_list: itemsList || '—',
    po_short_id: shortPoId(po.id),
  });

  const send = await sendTelegramMessage(token, chatId, text);
  if (!send.ok) {
    return NextResponse.json({ ok: false, error: send.error || 'Telegram send failed' }, { status: 502 });
  }

  return NextResponse.json({ ok: true });
}
