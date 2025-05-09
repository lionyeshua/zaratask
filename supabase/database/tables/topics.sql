CREATE TABLE IF NOT EXISTS public.topics (
    id 
    name TEXT NOT NULL,
    owner_id UUID NOT NULL,
    created_at BIGINT NOT NULL,
  CONSTRAINT topics_pkey PRIMARY KEY (id),
  CONSTRAINT topics_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users (id) ON DELETE CASCADE
  ) tablespace pg_default;

CREATE INDEX IF NOT EXISTS idx_topics_owner_id ON public.lists(owner_id);

ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow select, insert, update, delete to owner" 
ON public.topics
AS PERMISSIVE FOR ALL
TO authenticated
USING (((SELECT auth.uid() AS uid) = owner_id))
WITH CHECK ((( SELECT auth.uid() AS uid) = owner_id));