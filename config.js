// Salama Dar configuration.

// 1) Database. Leave as null to run in prototype mode (reports stay on each phone).
//    To go live, paste your Supabase project URL and its *publishable / anon* key
//    (Supabase Dashboard > Project Settings > API). Never paste the service_role key here.
window.SALAMA_CONFIG = null;
// window.SALAMA_CONFIG = {
//   supabaseUrl: "https://YOUR-PROJECT.supabase.co",
//   supabaseAnonKey: "YOUR-ANON-OR-PUBLISHABLE-KEY"
// };

// 2) TMA desk channel buttons. Copy each link ONLY from the official TMA website
//    (www.meteo.go.tz home page), so users never land on a fake account.
//    Any link left as null is simply not shown; the app then tells users where to find them.
window.SALAMA_TMA_LINKS = {
  whatsapp: null,   // e.g. "https://whatsapp.com/channel/...."
  x: null,
  instagram: null,
  facebook: null,
  youtube: null
};
