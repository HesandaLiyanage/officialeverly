-- Create autograph_activity table for tracking when users write in autograph books
CREATE TABLE IF NOT EXISTS public.autograph_activity (
    activity_id SERIAL PRIMARY KEY,
    autograph_id INTEGER NOT NULL,
    writer_user_id INTEGER NOT NULL,
    writer_username VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activity_autograph FOREIGN KEY (autograph_id)
        REFERENCES public.autograph (autograph_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_activity_user FOREIGN KEY (writer_user_id)
        REFERENCES public.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_autograph_activity_autograph_id ON public.autograph_activity (autograph_id);
CREATE INDEX IF NOT EXISTS idx_autograph_activity_created_at ON public.autograph_activity (created_at DESC);
