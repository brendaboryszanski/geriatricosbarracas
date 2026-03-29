/**
 * Transforms a Supabase Storage URL to use the image render API,
 * which resizes/compresses the image on-the-fly.
 */
export function optimizeImage(url: string, width = 1920, quality = 75): string {
  if (!url) return url;
  if (!url.includes('/storage/v1/object/public/')) return url;
  return (
    url.replace('/storage/v1/object/public/', '/storage/v1/render/image/public/') +
    `?width=${width}&quality=${quality}`
  );
}
