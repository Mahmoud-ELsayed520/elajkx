import { createClient } from '@supabase/supabase-js';

/**
 * Safely resolves environment variables across Vite, Next.js, and static/runtime window setups.
 */
function getEnv(key, fallbackKey) {
  try {
    if (typeof import.meta !== 'undefined' && import.meta && import.meta.env) {
      if (import.meta.env[key]) return import.meta.env[key];
      if (fallbackKey && import.meta.env[fallbackKey]) return import.meta.env[fallbackKey];
    }
  } catch (e) {}

  try {
    if (typeof process !== 'undefined' && process && process.env) {
      if (process.env[key]) return process.env[key];
      if (fallbackKey && process.env[fallbackKey]) return process.env[fallbackKey];
    }
  } catch (e) {}

  try {
    if (typeof window !== 'undefined' && window && window.__ENV__) {
      if (window.__ENV__[key]) return window.__ENV__[key];
      if (fallbackKey && window.__ENV__[fallbackKey]) return window.__ENV__[fallbackKey];
    }
  } catch (e) {}

  return '';
}

// Support both Vite (VITE_*) and Next.js / Vercel (NEXT_PUBLIC_*) conventions
const supabaseUrl = getEnv('VITE_SUPABASE_URL', 'NEXT_PUBLIC_SUPABASE_URL');
const supabaseAnonKey = getEnv('VITE_SUPABASE_ANON_KEY', 'NEXT_PUBLIC_SUPABASE_ANON_KEY');

export const isSupabaseConfigured = Boolean(
  supabaseUrl &&
  supabaseAnonKey &&
  supabaseUrl !== 'https://your-project-id.supabase.co' &&
  supabaseAnonKey !== 'your-supabase-anon-key' &&
  supabaseUrl.trim().length > 0 &&
  supabaseAnonKey.trim().length > 0
);

export const supabase = isSupabaseConfigured
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null;
