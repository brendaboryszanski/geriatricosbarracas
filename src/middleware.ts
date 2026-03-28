import { defineMiddleware } from 'astro:middleware';
import { createClient } from '@supabase/supabase-js';

export const onRequest = defineMiddleware(async (context, next) => {
  const url = new URL(context.request.url);

  // Only protect /admin routes (except /admin/login)
  if (url.pathname.startsWith('/admin') && url.pathname !== '/admin/login') {
    const supabase = createClient(
      import.meta.env.SUPABASE_URL,
      import.meta.env.SUPABASE_ANON_KEY
    );

    const accessToken = context.cookies.get('sb-access-token')?.value;
    const refreshToken = context.cookies.get('sb-refresh-token')?.value;

    if (!accessToken || !refreshToken) {
      return context.redirect('/admin/login');
    }

    const { data: { user }, error } = await supabase.auth.setSession({
      access_token: accessToken,
      refresh_token: refreshToken,
    });

    if (error || !user) {
      return context.redirect('/admin/login');
    }

    // Make user available to pages
    context.locals.user = user;
  }

  return next();
});
