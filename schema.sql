-- Salama Dar: community flood reports
-- Run once in Supabase: Dashboard > SQL Editor > New query > paste > Run.

create extension if not exists pgcrypto;

create table if not exists public.reports (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  ward        text not null check (char_length(ward) between 2 and 60),
  place       text check (char_length(place) <= 140),
  depth       text not null check (depth in ('ankle','knee','waist','road')),
  note        text check (char_length(note) <= 280),
  lang        text check (lang in ('sw','en')),
  status      text not null default 'pending' check (status in ('pending','approved','rejected')),
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id)
);
create index if not exists reports_status_created on public.reports (status, created_at desc);

create table if not exists public.moderators (
  user_id  uuid primary key references auth.users(id) on delete cascade,
  added_at timestamptz not null default now()
);

alter table public.reports    enable row level security;
alter table public.moderators enable row level security;

-- Helper: is the signed-in user a moderator?
create or replace function public.is_moderator() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.moderators where user_id = auth.uid());
$$;

-- Anyone may submit, but only as a pending, unreviewed report
drop policy if exists "submit pending" on public.reports;
create policy "submit pending" on public.reports for insert to anon, authenticated
  with check (status = 'pending' and reviewed_at is null and reviewed_by is null);

-- The public sees approved reports only
drop policy if exists "read approved" on public.reports;
create policy "read approved" on public.reports for select to anon, authenticated
  using (status = 'approved');

-- Moderators see and update everything
drop policy if exists "mods read" on public.reports;
create policy "mods read" on public.reports for select to authenticated using (public.is_moderator());
drop policy if exists "mods update" on public.reports;
create policy "mods update" on public.reports for update to authenticated
  using (public.is_moderator()) with check (public.is_moderator());

drop policy if exists "mods see self" on public.moderators;
create policy "mods see self" on public.moderators for select to authenticated using (user_id = auth.uid());

-- Column-level limits for the public (anon) role: it can only send the form
-- fields and read the public columns. It can never set status or see reviewers.
revoke all on public.reports from anon;
grant insert (id, ward, place, depth, note, lang) on public.reports to anon;
grant select (id, created_at, ward, place, depth, note) on public.reports to anon;
revoke all on public.moderators from anon;

-- To add a reviewer: they sign in once on /moderate.html, copy the ID it shows, then run:
-- insert into public.moderators (user_id) values ('PASTE-THEIR-ID-HERE');
