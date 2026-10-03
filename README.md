# Salama Dar

A bilingual (Kiswahili/English) flood awareness web app for Dar es Salaam. It shows wards
with a published flood history, how to prepare, health advice and emergency numbers, and it
lets residents send flood reports that volunteers check before they appear on the map.

It is **not** an alert or forecast service. Official forecasts and warnings come only from TMA;
the app's TMA desk sends people straight to TMA's official website and channels.

## What's in this folder

| File | What it is |
|---|---|
| `index.html` | The app (map, report form, prepare, health, emergency, about) |
| `moderate.html` | Volunteer page to approve or reject community reports |
| `config.js` | Where you paste your database keys. `null` = prototype mode |
| `supabase/schema.sql` | The database: tables, security rules, reviewer list |
| `sw.js`, `manifest.webmanifest`, `icon*` | Offline support and "Add to Home screen" |
| `vercel.json` | Hosting settings for Vercel |
| `TESTING.md` | What was tested, results, and a script for testing with residents |

## 0. Fill in the TMA desk links (5 minutes)

Open the official TMA website (www.meteo.go.tz). On its home page, copy the links to TMA's
WhatsApp channel, X, Instagram, Facebook and YouTube into `window.SALAMA_TMA_LINKS` in
`config.js`. Copy them only from TMA's own site so nobody is sent to a fake account.
Links you leave as `null` are hidden.

## 1. Put it online with Vercel (about 10 minutes)

Option A, command line (needs Node.js):
```
npm i -g vercel
cd salama-dar
vercel          # first time: log in, accept the defaults
vercel --prod   # publishes to https://<your-project>.vercel.app
```

Option B, no command line: create a GitHub repository, upload the contents of this folder,
then on vercel.com choose **Add New > Project**, import the repository and click **Deploy**.
There is no build step; Vercel serves the files as they are.

At this point the app works fully except that community reports stay on each phone
(prototype mode).

## 2. Turn on the shared database (Supabase, free tier)

1. Create a project at supabase.com. Pick the region closest to Tanzania that is offered.
2. Open **SQL Editor > New query**, paste all of `supabase/schema.sql`, click **Run**.
3. Open **Project Settings > API** and copy the **Project URL** and the **anon / publishable** key.
   Never use the `service_role` key in this app.
4. In `config.js`, replace `window.SALAMA_CONFIG = null;` with:
   ```js
   window.SALAMA_CONFIG = { supabaseUrl: "https://xxxx.supabase.co", supabaseAnonKey: "your-anon-key" };
   ```
5. In Supabase **Authentication > URL Configuration**, set the Site URL to your Vercel address
   and add `https://<your-project>.vercel.app/moderate.html` to the redirect URLs.
6. Redeploy (`vercel --prod`, or push to GitHub).

### Add a volunteer reviewer
1. The volunteer opens `/moderate.html`, enters their email and clicks the link they receive.
2. The page shows an ID. Run this in the SQL Editor:
   `insert into public.moderators (user_id) values ('THE-ID');`
3. They reload the page and can now approve or reject reports.

### How reports are protected
- Anyone can send a report, but only as "waiting for review". The public cannot set its status.
- The public can only read approved reports, and only the report fields (no reviewer data).
- Reports collect no names, phone numbers or GPS location; they are shown per ward.
- The app shows approved reports for 24 hours.

## 3. Before a public launch

- Confirm the ward list and sources with the PMO Disaster Management Department or municipal councils.
- Have native Kiswahili speakers review all text, and a pharmacist or clinician review the health section.
- Test-call the emergency numbers (112, 114, 115, 190, 199, 180).
- Check with TCRA whether the online content regulations apply to the site.
- Add spam protection to the report form (for example Cloudflare Turnstile) before promoting it widely.
- Line up enough volunteer reviewers to cover the heavy-rain days.

## Updating ward information
Ward details live in the `INFO` object near the top of the script in `index.html`. Each entry
has its sources; keep every claim tied to a source.
