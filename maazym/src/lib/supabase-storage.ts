/**
 * Older clients sometimes stored public bucket URLs without the `/public/` segment,
 * which returns 400 when loaded. Normalize to the canonical public object path.
 */
export function normalizePublicStorageUrl(url: string | null | undefined): string | null {
  if (!url) return null;
  const broken = /\/storage\/v1\/object\/(?!public\/)([^/]+)\//;
  if (broken.test(url)) {
    return url.replace('/storage/v1/object/', '/storage/v1/object/public/');
  }
  return url;
}
