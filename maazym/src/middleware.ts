import { NextResponse, type NextRequest } from 'next/server';
import createIntlMiddleware from 'next-intl/middleware';
import { routing } from './i18n/routing';
import { updateSession } from './lib/supabase/middleware';

const intlMiddleware = createIntlMiddleware(routing);

const publicPaths = ['/login'];

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  const pathnameWithoutLocale = pathname.replace(/^\/(ar|en)/, '') || '/';
  const isPublicPath = publicPaths.some((path) => pathnameWithoutLocale.startsWith(path));

  const { user, supabaseResponse } = await updateSession(request);

  if (!user && !isPublicPath) {
    const locale = pathname.match(/^\/(ar|en)/)?.[1] || 'ar';
    const loginUrl = new URL(`/${locale}/login`, request.url);
    return NextResponse.redirect(loginUrl);
  }

  if (user && isPublicPath) {
    const locale = pathname.match(/^\/(ar|en)/)?.[1] || 'ar';
    const dashboardUrl = new URL(`/${locale}`, request.url);
    return NextResponse.redirect(dashboardUrl);
  }

  const intlResponse = intlMiddleware(request);

  supabaseResponse.headers.forEach((value, key) => {
    intlResponse.headers.set(key, value);
  });
  supabaseResponse.cookies.getAll().forEach((cookie) => {
    intlResponse.cookies.set(cookie.name, cookie.value);
  });

  return intlResponse;
}

export const config = {
  matcher: ['/', '/(ar|en)/:path*'],
};
