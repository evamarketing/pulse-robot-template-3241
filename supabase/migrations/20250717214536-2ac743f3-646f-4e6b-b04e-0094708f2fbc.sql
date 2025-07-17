-- Create the user_registration_requests table for guest registration
CREATE TABLE IF NOT EXISTS public.user_registration_requests (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT NOT NULL,
  mobile_number TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  approved_by TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(username),
  UNIQUE(mobile_number)
);

-- Enable Row Level Security
ALTER TABLE public.user_registration_requests ENABLE ROW LEVEL SECURITY;

-- Create policies for guest registration
CREATE POLICY "Anyone can create registration requests" 
ON public.user_registration_requests 
FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Users can view their own registration requests" 
ON public.user_registration_requests 
FOR SELECT 
USING (true);

CREATE POLICY "Admins can update registration requests" 
ON public.user_registration_requests 
FOR UPDATE 
USING (true)
WITH CHECK (true);

-- Add trigger for automatic timestamp updates
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_registration_requests_updated_at
  BEFORE UPDATE ON public.user_registration_requests
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();