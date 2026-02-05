-- Run this SQL in your Supabase SQL Editor to create the table for Instagram Reels

create table if not exists instagram_reels (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  url text not null,
  description text,
  is_active boolean default true
);

-- Enable Row Level Security
alter table instagram_reels enable row level security;

-- Create policy to allow public read access
create policy "Allow public read access"
  on instagram_reels
  for select
  using (true);

-- Create policy to allow authenticated admins (or Service Role) to insert/update
-- Adjust this policy based on your auth requirements. For now, we allow authenticated users (like admins).
create policy "Allow authenticated insert"
  on instagram_reels
  for insert
  to authenticated
  with check (true);

-- Insert initial data (same as fallback)
insert into instagram_reels (url, description) values
('https://www.instagram.com/reel/DRChmRwDAUA/', 'Initial Reel 1'),
('https://www.instagram.com/reel/DQwpP6uDNmZ/', 'Initial Reel 2'),
('https://www.instagram.com/reel/DQWpQozDO0x/', 'Initial Reel 3'),
('https://www.instagram.com/reel/DP85PjnDPn-/', 'Initial Reel 4'),
('https://www.instagram.com/reel/DQrRS-_DHdp/', 'Initial Reel 5');
