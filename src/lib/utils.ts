/**
 * Returns the image URL as-is.
 * Image transformation (render API) requires Supabase Pro plan.
 * Parameters kept for future use when upgrading plans.
 */
export function optimizeImage(url: string, _width = 1920, _quality = 75): string {
  return url ?? '';
}
