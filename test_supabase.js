import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.VITE_SUPABASE_URL || 'https://pdcgcqsgzupoyzklvoju.supabase.co';
import fs from 'fs';
const envFile = fs.readFileSync('.env', 'utf-8');
const anonKey = envFile.split('VITE_SUPABASE_ANON_KEY=')[1].split('\n')[0].trim();
const supabase = createClient(supabaseUrl, anonKey);

async function test() {
  const { data, error } = await supabase
    .from('project_volunteers')
    .select('project:projects(*)')
    .eq('volunteer_id', '7da7baeb-2615-4949-bc8c-5e10a3ea5ffd'); // User: Meet
  console.log("Response:", JSON.stringify(data, null, 2));
  if (error) console.error("Error:", error);
}
test();
