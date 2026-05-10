-- ════════════════════════════════════════════
--  Reverie — Supabase Schema
--  Run this in your Supabase SQL Editor
-- ════════════════════════════════════════════

-- Enable UUID extension (usually already enabled)
create extension if not exists "pgcrypto";

-- ── Profiles ────────────────────────────────
-- Extends Supabase auth.users with display info
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  username    text unique not null,
  email       text,
  avatar_url  text,
  is_admin    boolean default false,
  created_at  timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

create policy "Users can update their own profile"
  on public.profiles for update using (auth.uid() = id);

-- ── Ratings ─────────────────────────────────
create table if not exists public.ratings (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles(id) on delete cascade,
  spotify_id      text not null,
  track_name      text not null,
  artist_name     text not null,
  album_name      text not null,
  album_art       text,
  duration_ms     integer,
  score           numeric(3,1) not null check (score >= 1 and score <= 10),
  note            text,
  rated_at        timestamptz default now(),
  unique(user_id, spotify_id)
);

alter table public.ratings enable row level security;

create policy "Ratings are viewable by everyone"
  on public.ratings for select using (true);

create policy "Users can insert their own ratings"
  on public.ratings for insert with check (auth.uid() = user_id);

create policy "Users can update their own ratings"
  on public.ratings for update using (auth.uid() = user_id);

create policy "Users can delete their own ratings"
  on public.ratings for delete using (auth.uid() = user_id);

-- ── Follows ──────────────────────────────────
create table if not exists public.follows (
  follower_id  uuid not null references public.profiles(id) on delete cascade,
  following_id uuid not null references public.profiles(id) on delete cascade,
  created_at   timestamptz default now(),
  primary key (follower_id, following_id)
);

alter table public.follows enable row level security;

create policy "Follows are viewable by everyone"
  on public.follows for select using (true);

create policy "Users can manage their own follows"
  on public.follows for insert with check (auth.uid() = follower_id);

create policy "Users can unfollow"
  on public.follows for delete using (auth.uid() = follower_id);

-- ── Trigger: auto-create profile on signup ───
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── Indexes ─────────────────────────────────
create index if not exists ratings_user_id_idx on public.ratings(user_id);
create index if not exists ratings_spotify_id_idx on public.ratings(spotify_id);
create index if not exists ratings_rated_at_idx on public.ratings(rated_at desc);
create index if not exists follows_follower_idx on public.follows(follower_id);
create index if not exists follows_following_idx on public.follows(following_id);
