// REPSYNC SUPABASE CONNECTION
// Load the Supabase CDN library before this file on every authenticated page.

(() => {
    const SUPABASE_URL = 'https://jwcyfrdrcsesilwxunmt.supabase.co';
    const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_LN0QSVpbe1O8fTV_AZAKnw_uU1-Mo3G';

    if (!window.supabase || typeof window.supabase.createClient !== 'function') {
        console.error('REPSYNC: Supabase library failed to load. Check the CDN script.');
        return;
    }

    // Prevent duplicate clients if the shared file is included more than once.
    if (!window.supabaseClient) {
        window.supabaseClient = window.supabase.createClient(
            SUPABASE_URL,
            SUPABASE_PUBLISHABLE_KEY
        );
        console.log('REPSYNC Supabase connected!');
    }
})();
