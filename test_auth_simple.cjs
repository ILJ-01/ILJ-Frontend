const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://pdcgcqsgzupoyzklvoju.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkY2djcXNnenVwb3l6a2x2b2p1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0OTM0MDUsImV4cCI6MjA4NTA2OTQwNX0.Adh2epzvTt0jmif6x6FdJr0YphHtZ_spciyg9z1Et0s';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function run() {
    console.log("Testing signInWithPassword...");
    const { data, error } = await supabase.auth.signInWithPassword({
        email: 'smitmehta50@gmail.com',
        password: 'test12345'
    });
    if (error) {
        console.error("Auth Error:", error);
    } else {
        console.log("Auth Success! Session user id:", data.user?.id);
    }
}

run();
