-- Revision Voice Notes — run this once in Supabase → SQL Editor → New query → Run.
-- It creates the table for your index, the bucket for your audio, and locks both
-- so only the logged-in owner can read or write their own rows and files.

create table if not exists public.notebooks (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  tree       jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.notebooks enable row level security;

drop policy if exists "own notebook read"   on public.notebooks;
drop policy if exists "own notebook write"  on public.notebooks;
drop policy if exists "own notebook update" on public.notebooks;

create policy "own notebook read"   on public.notebooks
  for select using (auth.uid() = user_id);
create policy "own notebook write"  on public.notebooks
  for insert with check (auth.uid() = user_id);
create policy "own notebook update" on public.notebooks
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Private bucket for the audio files.
insert into storage.buckets (id, name, public)
values ('recordings', 'recordings', false)
on conflict (id) do nothing;

-- Each user may only touch files under a folder named after their own user id.
drop policy if exists "own audio read"   on storage.objects;
drop policy if exists "own audio write"  on storage.objects;
drop policy if exists "own audio delete" on storage.objects;

create policy "own audio read" on storage.objects
  for select using (
    bucket_id = 'recordings' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "own audio write" on storage.objects
  for insert with check (
    bucket_id = 'recordings' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "own audio delete" on storage.objects
  for delete using (
    bucket_id = 'recordings' and (storage.foldername(name))[1] = auth.uid()::text
  );
