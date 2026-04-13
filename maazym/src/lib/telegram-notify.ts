export type TelegramTemplateVars = {
  branch_name: string;
  user_name: string;
  order_date: string;
  supplier_name: string;
  total_amount: string;
  items_list: string;
  po_short_id: string;
};

export function applyTelegramTemplate(template: string, vars: TelegramTemplateVars): string {
  let out = template;
  for (const [key, value] of Object.entries(vars)) {
    out = out.split(`{{${key}}}`).join(value);
  }
  return out;
}

export async function sendTelegramMessage(botToken: string, chatId: string, text: string): Promise<{ ok: boolean; error?: string }> {
  const url = `https://api.telegram.org/bot${encodeURIComponent(botToken)}/sendMessage`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: chatId,
      text: text.slice(0, 4096),
      disable_web_page_preview: true,
    }),
  });
  const json = (await res.json()) as { ok?: boolean; description?: string };
  if (!res.ok || !json.ok) {
    return { ok: false, error: json.description || res.statusText };
  }
  return { ok: true };
}
