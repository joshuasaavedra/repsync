REPSYNC CONNECTION FIX

1. Copy the images folder into your existing REPSYNC project and merge it.
   The included images/js/supabase.js replaces the old shared config.
2. Replace these HTML files:
   - nutrition.html
   - workout-logs.html
   - profile.html
   - my-profile.html
   - muscle-targets.html
3. Keep the Supabase CDN script before images/js/supabase.js on each page.
4. Run the site with VS Code Live Server.

Important:
- The Supabase project URL was corrected to the project URL previously provided.
- The shared client is now exposed as window.supabaseClient.
- Muscle Targets is intentionally routed to the Yearly Activity section inside Workout Logs.
- No database tables or existing data are changed by these front-end fixes.

If the project URL in your Supabase dashboard differs from the one in images/js/supabase.js,
replace SUPABASE_URL with the exact Project URL shown in Supabase > Project Settings > API.
