CREATE OR REPLACE FUNCTION public.is_authorized_user()
RETURNS boolean LANGUAGE sql STABLE SECURITY INVOKER SET search_path = public
AS $$ SELECT EXISTS (SELECT 1 FROM public.authorized_users WHERE lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))) $$;
REVOKE ALL ON FUNCTION public.is_authorized_user() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_authorized_user() TO authenticated;
REVOKE ALL ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM authenticated;