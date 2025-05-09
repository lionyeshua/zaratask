CREATE TABLE IF NOT EXISTS public.settings (
    owner_id UUID NOT NULL,
    dark_mode BOOLEAN NOT NULL,
    created_at BIGINT NOT NULL,
  CONSTRAINT settings_pkey PRIMARY KEY (owner_id),
  CONSTRAINT settings_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users (id) ON DELETE CASCADE
  ) tablespace pg_default;

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow select, insert, update, delete to owner" 
ON public.settings
AS PERMISSIVE FOR ALL
TO authenticated
USING (((SELECT auth.uid() AS uid) = owner_id))
WITH CHECK ((( SELECT auth.uid() AS uid) = owner_id));

-- Database -> Publications -> enable