-- Public recipe image bucket + RLS so authenticated staff can upload; anonymous can read (public bucket).
-- Also allow chefs/bartenders to edit recipes and recipe_ingredients for their branch (seeded rows often have created_by NULL).

-- ========== Storage: bucket ==========
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'recipe-images',
  'recipe-images',
  true,
  10485760,
  NULL
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- ========== Storage: policies on storage.objects ==========
DROP POLICY IF EXISTS "Public read recipe images" ON storage.objects;
CREATE POLICY "Public read recipe images"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'recipe-images');

DROP POLICY IF EXISTS "Authenticated upload recipe images" ON storage.objects;
CREATE POLICY "Authenticated upload recipe images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'recipe-images');

DROP POLICY IF EXISTS "Authenticated update recipe images" ON storage.objects;
CREATE POLICY "Authenticated update recipe images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'recipe-images')
  WITH CHECK (bucket_id = 'recipe-images');

DROP POLICY IF EXISTS "Authenticated delete recipe images" ON storage.objects;
CREATE POLICY "Authenticated delete recipe images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'recipe-images');

-- ========== Recipes: branch staff can manage branch recipes ==========
DROP POLICY IF EXISTS "Kitchen staff can manage branch recipes" ON recipes;
CREATE POLICY "Kitchen staff can manage branch recipes"
  ON recipes FOR ALL
  TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND branch_id IS NOT NULL
    AND (
      branch_id = get_user_branch_id()
      OR (
        get_user_branch_id() IS NULL
        AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid
      )
    )
  )
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND branch_id IS NOT NULL
    AND (
      branch_id = get_user_branch_id()
      OR (
        get_user_branch_id() IS NULL
        AND branch_id = '00000000-0000-0000-0000-000000000001'::uuid
      )
    )
  );

-- ========== Recipe ingredients: same branch scope for kitchen staff ==========
DROP POLICY IF EXISTS "Kitchen staff can manage branch recipe ingredients" ON recipe_ingredients;
CREATE POLICY "Kitchen staff can manage branch recipe ingredients"
  ON recipe_ingredients FOR ALL
  TO authenticated
  USING (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM recipes r
      WHERE r.id = recipe_ingredients.recipe_id
        AND r.branch_id IS NOT NULL
        AND (
          r.branch_id = get_user_branch_id()
          OR (
            get_user_branch_id() IS NULL
            AND r.branch_id = '00000000-0000-0000-0000-000000000001'::uuid
          )
        )
    )
  )
  WITH CHECK (
    get_user_role() IN ('chef', 'bartender')
    AND EXISTS (
      SELECT 1 FROM recipes r
      WHERE r.id = recipe_ingredients.recipe_id
        AND r.branch_id IS NOT NULL
        AND (
          r.branch_id = get_user_branch_id()
          OR (
            get_user_branch_id() IS NULL
            AND r.branch_id = '00000000-0000-0000-0000-000000000001'::uuid
          )
        )
    )
  );
