-- Localized outlet name (header, sidebar, login); admin-editable in site_branding
ALTER TABLE site_branding
  ADD COLUMN IF NOT EXISTS outlet_name_en text NOT NULL DEFAULT 'Maazym',
  ADD COLUMN IF NOT EXISTS outlet_name_ar text NOT NULL DEFAULT 'معزم';
