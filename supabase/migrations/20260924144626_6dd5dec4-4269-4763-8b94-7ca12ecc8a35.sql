CREATE TYPE public.app_role AS ENUM ('master');
CREATE TYPE public.checkin_status AS ENUM ('pending', 'confirmed', 'completed', 'absent');

CREATE TABLE public.authorized_users (
  email text PRIMARY KEY,
  display_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.authorized_users TO authenticated;
GRANT ALL ON public.authorized_users TO service_role;
ALTER TABLE public.authorized_users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authorized users can read allowlist" ON public.authorized_users FOR SELECT TO authenticated USING (lower(email) = lower(coalesce(auth.jwt() ->> 'email', '')));

INSERT INTO public.authorized_users (email, display_name) VALUES
  ('gabrieljbarbosa.contato@gmail.com', 'Gabriel'),
  ('vidasil73@gmail.com', 'Esther');

CREATE OR REPLACE FUNCTION public.is_authorized_user()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$ SELECT EXISTS (SELECT 1 FROM public.authorized_users WHERE lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))) $$;
GRANT EXECUTE ON FUNCTION public.is_authorized_user() TO authenticated;

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY,
  email text NOT NULL UNIQUE,
  display_name text NOT NULL,
  avatar_url text,
  goals text[] NOT NULL DEFAULT '{}',
  fitness_level text NOT NULL DEFAULT 'iniciante',
  restrictions text,
  equipment text[] NOT NULL DEFAULT '{}',
  preferences text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Couple can view profiles" ON public.profiles FOR SELECT TO authenticated USING (public.is_authorized_user());
CREATE POLICY "Users create own profile" ON public.profiles FOR INSERT TO authenticated WITH CHECK (public.is_authorized_user() AND id = auth.uid() AND lower(email) = lower(coalesce(auth.jwt() ->> 'email', '')));
CREATE POLICY "Users update own profile" ON public.profiles FOR UPDATE TO authenticated USING (id = auth.uid() AND public.is_authorized_user()) WITH CHECK (id = auth.uid() AND public.is_authorized_user());
CREATE POLICY "Users delete own profile" ON public.profiles FOR DELETE TO authenticated USING (id = auth.uid() AND public.is_authorized_user());

CREATE TABLE public.user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  role public.app_role NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);
GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own roles" ON public.user_roles FOR SELECT TO authenticated USING (user_id = auth.uid() AND public.is_authorized_user());

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role public.app_role)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$ SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role) $$;
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated;

CREATE TABLE public.activities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_by uuid NOT NULL,
  title text NOT NULL,
  modality text NOT NULL,
  starts_at timestamptz NOT NULL,
  duration_minutes integer NOT NULL DEFAULT 60 CHECK (duration_minutes > 0 AND duration_minutes <= 600),
  notes text,
  participant_ids uuid[] NOT NULL DEFAULT '{}',
  generated_workout_id uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.activities TO authenticated;
GRANT ALL ON public.activities TO service_role;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Couple can view activities" ON public.activities FOR SELECT TO authenticated USING (public.is_authorized_user());
CREATE POLICY "Couple can create activities" ON public.activities FOR INSERT TO authenticated WITH CHECK (public.is_authorized_user() AND created_by = auth.uid());
CREATE POLICY "Couple can update activities" ON public.activities FOR UPDATE TO authenticated USING (public.is_authorized_user()) WITH CHECK (public.is_authorized_user());
CREATE POLICY "Couple can delete activities" ON public.activities FOR DELETE TO authenticated USING (public.is_authorized_user());

CREATE TABLE public.activity_checkins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  activity_id uuid NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  status public.checkin_status NOT NULL DEFAULT 'pending',
  absence_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (activity_id, user_id),
  CHECK (status <> 'absent' OR length(trim(coalesce(absence_reason, ''))) > 0)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.activity_checkins TO authenticated;
GRANT ALL ON public.activity_checkins TO service_role;
ALTER TABLE public.activity_checkins ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Couple can view checkins" ON public.activity_checkins FOR SELECT TO authenticated USING (public.is_authorized_user());
CREATE POLICY "Users create own checkins" ON public.activity_checkins FOR INSERT TO authenticated WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users update own checkins" ON public.activity_checkins FOR UPDATE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid()) WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users delete own checkins" ON public.activity_checkins FOR DELETE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid());

CREATE TABLE public.meals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  photo_path text NOT NULL,
  meal_type text NOT NULL,
  eaten_at timestamptz NOT NULL DEFAULT now(),
  comment text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.meals TO authenticated;
GRANT ALL ON public.meals TO service_role;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Couple can view meals" ON public.meals FOR SELECT TO authenticated USING (public.is_authorized_user());
CREATE POLICY "Users create own meals" ON public.meals FOR INSERT TO authenticated WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users update own meals" ON public.meals FOR UPDATE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid()) WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users delete own meals" ON public.meals FOR DELETE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid());

CREATE TABLE public.generated_workouts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  title text NOT NULL,
  goal text NOT NULL,
  fitness_level text NOT NULL,
  duration_minutes integer NOT NULL,
  muscle_groups text[] NOT NULL DEFAULT '{}',
  equipment text[] NOT NULL DEFAULT '{}',
  limitations text,
  exercises jsonb NOT NULL DEFAULT '[]'::jsonb,
  guidance text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.generated_workouts TO authenticated;
GRANT ALL ON public.generated_workouts TO service_role;
ALTER TABLE public.generated_workouts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Couple can view generated workouts" ON public.generated_workouts FOR SELECT TO authenticated USING (public.is_authorized_user());
CREATE POLICY "Users create own generated workouts" ON public.generated_workouts FOR INSERT TO authenticated WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users update own generated workouts" ON public.generated_workouts FOR UPDATE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid()) WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());
CREATE POLICY "Users delete own generated workouts" ON public.generated_workouts FOR DELETE TO authenticated USING (public.is_authorized_user() AND user_id = auth.uid());

ALTER TABLE public.activities ADD CONSTRAINT activities_generated_workout_id_fkey FOREIGN KEY (generated_workout_id) REFERENCES public.generated_workouts(id) ON DELETE SET NULL;

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql SET search_path = public AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;
CREATE TRIGGER profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER activities_updated_at BEFORE UPDATE ON public.activities FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER checkins_updated_at BEFORE UPDATE ON public.activity_checkins FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER meals_updated_at BEFORE UPDATE ON public.meals FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER generated_workouts_updated_at BEFORE UPDATE ON public.generated_workouts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE POLICY "Authorized couple can view meal photos" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'meal-photos' AND public.is_authorized_user());
CREATE POLICY "Users upload own meal photos" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'meal-photos' AND public.is_authorized_user() AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Users update own meal photos" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'meal-photos' AND owner_id = auth.uid()::text) WITH CHECK (bucket_id = 'meal-photos' AND owner_id = auth.uid()::text);
CREATE POLICY "Users delete own meal photos" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'meal-photos' AND owner_id = auth.uid()::text);