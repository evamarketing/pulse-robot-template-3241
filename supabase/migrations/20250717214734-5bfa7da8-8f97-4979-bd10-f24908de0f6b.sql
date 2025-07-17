-- Add trigger for automatic timestamp updates if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_user_registration_requests_updated_at'
    ) THEN
        CREATE TRIGGER update_user_registration_requests_updated_at
        BEFORE UPDATE ON public.user_registration_requests
        FOR EACH ROW
        EXECUTE FUNCTION public.update_updated_at_column();
    END IF;
END
$$;