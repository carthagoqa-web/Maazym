-- Generic backfill when description_ar is still empty (custom recipes, old seeds).
-- For MAAZYM PDF menu items, run 00008 after this: it sets real Arabic preparation text matching the English description.
-- Safe to re-run: only updates rows with empty description_ar.

UPDATE recipes
SET description_ar = name_ar || ' — يُحضَّر طازجاً؛ مكونات مختارة وبجودة عالية حسب معايير المطعم.',
    updated_at = now()
WHERE (description_ar IS NULL OR btrim(description_ar) = '')
  AND name_ar IS NOT NULL
  AND btrim(name_ar) <> '';
