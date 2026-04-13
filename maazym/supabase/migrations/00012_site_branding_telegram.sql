-- Site logo (public read path) + Telegram integration (admin-only secrets)
-- Storage bucket site-assets: public read, admin-only write

CREATE TABLE site_branding (
  id smallint PRIMARY KEY CHECK (id = 1),
  logo_path text,
  updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO site_branding (id, logo_path) VALUES (1, NULL);

CREATE TABLE site_integrations (
  id smallint PRIMARY KEY CHECK (id = 1),
  telegram_bot_token text,
  telegram_chat_id text,
  telegram_message_template text NOT NULL DEFAULT $tmpl$🛒 Purchase order submitted

Branch: {{branch_name}}
Ordered by: {{user_name}}
Order date: {{order_date}}
Supplier: {{supplier_name}}
Total: {{total_amount}} QAR

Items:
{{items_list}}

Ref: #{{po_short_id}}$tmpl$,
  updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO site_integrations (id, telegram_bot_token, telegram_chat_id)
VALUES (1, NULL, NULL);

ALTER TABLE site_branding ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_integrations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "site_branding_select_public" ON site_branding
  FOR SELECT TO anon, authenticated
  USING (true);

CREATE POLICY "site_branding_admin_write" ON site_branding
  FOR ALL TO authenticated
  USING (get_user_role() = 'admin')
  WITH CHECK (get_user_role() = 'admin');

CREATE POLICY "site_integrations_admin_only" ON site_integrations
  FOR ALL TO authenticated
  USING (get_user_role() = 'admin')
  WITH CHECK (get_user_role() = 'admin');

-- ---------------------------------------------------------------------------
-- Storage: site-assets (public logo URL for login page)
-- ---------------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'site-assets',
  'site-assets',
  true,
  2097152,
  ARRAY['image/png', 'image/jpeg', 'image/webp', 'image/svg+xml', 'image/gif']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Public read site assets" ON storage.objects;
CREATE POLICY "Public read site assets"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'site-assets');

DROP POLICY IF EXISTS "Admin insert site assets" ON storage.objects;
CREATE POLICY "Admin insert site assets"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'site-assets'
    AND (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

DROP POLICY IF EXISTS "Admin update site assets" ON storage.objects;
CREATE POLICY "Admin update site assets"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'site-assets'
    AND (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  )
  WITH CHECK (
    bucket_id = 'site-assets'
    AND (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );

DROP POLICY IF EXISTS "Admin delete site assets" ON storage.objects;
CREATE POLICY "Admin delete site assets"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'site-assets'
    AND (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
  );
