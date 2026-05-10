-- ══════════════════════════════════════════════════════
--  Reverie — User Deletion RPC Functions
--  Run this in your Supabase SQL Editor
-- ══════════════════════════════════════════════════════

-- 1. Lets a signed-in user delete their OWN auth.users row.
--    security definer = runs with the privileges of the function owner (postgres),
--    which has access to auth.users. The auth.uid() check ensures users can only
--    delete themselves.
create or replace function public.delete_own_auth_user()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from auth.users where id = auth.uid();
end;
$$;

-- Allow any authenticated user to call this
grant execute on function public.delete_own_auth_user() to authenticated;


-- 2. Lets the admin delete ANY user's auth.users row by their UUID.
--    Restricted by RLS policy: only the admin profile (is_admin = true) can call this.
create or replace function public.delete_auth_user_by_id(target_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  caller_is_admin boolean;
begin
  -- Check the caller is an admin
  select is_admin into caller_is_admin
  from public.profiles
  where id = auth.uid();

  if not caller_is_admin then
    raise exception 'Only admins can delete other users';
  end if;

  delete from auth.users where id = target_user_id;
end;
$$;

-- Allow any authenticated user to call this (the function enforces admin check internally)
grant execute on function public.delete_auth_user_by_id(uuid) to authenticated;


-- ── Make sure your admin account has is_admin = true ──────────────────
-- Replace 'justin' with your admin username if different
update public.profiles set is_admin = true where username = 'justin';
