ALTER TABLE public.profiles
  ADD COLUMN weight_kg numeric(5,2),
  ADD COLUMN height_cm numeric(5,2),
  ADD CONSTRAINT profiles_weight_kg_range CHECK (weight_kg IS NULL OR (weight_kg >= 20 AND weight_kg <= 400)),
  ADD CONSTRAINT profiles_height_cm_range CHECK (height_cm IS NULL OR (height_cm >= 80 AND height_cm <= 250));

CREATE TABLE public.water_intakes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount_ml integer NOT NULL CHECK (amount_ml >= 1 AND amount_ml <= 10000),
  consumed_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.water_intakes TO authenticated;
GRANT ALL ON public.water_intakes TO service_role;

ALTER TABLE public.water_intakes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Couple can view water intakes"
ON public.water_intakes FOR SELECT TO authenticated
USING (public.is_authorized_user());

CREATE POLICY "Users create own water intakes"
ON public.water_intakes FOR INSERT TO authenticated
WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());

CREATE POLICY "Users update own water intakes"
ON public.water_intakes FOR UPDATE TO authenticated
USING (public.is_authorized_user() AND user_id = auth.uid())
WITH CHECK (public.is_authorized_user() AND user_id = auth.uid());

CREATE POLICY "Users delete own water intakes"
ON public.water_intakes FOR DELETE TO authenticated
USING (public.is_authorized_user() AND user_id = auth.uid());

CREATE TRIGGER water_intakes_updated_at
BEFORE UPDATE ON public.water_intakes
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();