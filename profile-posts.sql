-- REPSYNC COMMUNITY FEED: run this in Supabase SQL Editor.
-- Every authenticated REPSYNC member can read every post.
-- Members can only create and delete posts belonging to their own user ID.

create table if not exists public.profile_posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null default '',
  image_url text,
  created_at timestamptz not null default now(),
  constraint profile_posts_body_or_image check (length(trim(body)) > 0 or image_url is not null)
);

alter table public.profile_posts enable row level security;
grant select, insert, delete on public.profile_posts to authenticated;

-- Remove earlier policy variants so the community-wide read rule is unambiguous.
drop policy if exists "Users can read own profile posts" on public.profile_posts;
drop policy if exists "Authenticated users can read community posts" on public.profile_posts;
drop policy if exists "Anyone can read community posts" on public.profile_posts;
drop policy if exists "Users can create own profile posts" on public.profile_posts;
drop policy if exists "Users can delete own profile posts" on public.profile_posts;

create policy "Authenticated users can read community posts"
on public.profile_posts for select to authenticated using (true);

create policy "Users can create own profile posts"
on public.profile_posts for insert to authenticated
with check (auth.uid() = user_id);

create policy "Users can delete own profile posts"
on public.profile_posts for delete to authenticated
using (auth.uid() = user_id);

-- Public image URLs let signed-in community members see post photos.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('community-posts', 'community-posts', true, 5242880,
        array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set
  public = true,
  file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp'];

drop policy if exists "Users can upload own community post photos" on storage.objects;
drop policy if exists "Public can view community post photos" on storage.objects;
drop policy if exists "Users can delete own community post photos" on storage.objects;

create policy "Users can upload own community post photos"
on storage.objects for insert to authenticated
with check (bucket_id = 'community-posts' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Public can view community post photos"
on storage.objects for select to public
using (bucket_id = 'community-posts');

create policy "Users can delete own community post photos"
on storage.objects for delete to authenticated
using (bucket_id = 'community-posts' and (storage.foldername(name))[1] = auth.uid()::text);

-- Optional realtime updates while Feed is open. Ignore the duplicate-publication error.
do $$
begin
  alter publication supabase_realtime add table public.profile_posts;
exception when duplicate_object then null;
end $$;
