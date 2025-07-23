-- Fix 1: Add team_password column if it doesn't exist
ALTER TABLE public.management_teams 
ADD COLUMN IF NOT EXISTS team_password TEXT;

-- Fix 2: Add DELETE policy for user_registration_requests
CREATE POLICY "Admins can delete registration requests" 
ON public.user_registration_requests 
FOR DELETE 
USING (true);

-- Fix 3: Add panchayath_id to user_registration_requests if missing
ALTER TABLE public.user_registration_requests 
ADD COLUMN IF NOT EXISTS panchayath_id uuid REFERENCES public.panchayaths(id);