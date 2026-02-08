-- Function to register interest in an event
-- Bypasses RLS to allow volunteers to register even if the RLS policy is strict/broken for anon users
CREATE OR REPLACE FUNCTION public.register_event_interest(p_event_id uuid, p_volunteer_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER -- Runs with privileges of the creator (postgres), bypassing RLS
SET search_path = public -- Secure search path
AS $$
DECLARE
    v_exists boolean;
BEGIN
    -- Check if already interested
    SELECT EXISTS (
        SELECT 1 FROM public.event_interests
        WHERE event_id = p_event_id AND volunteer_id = p_volunteer_id
    ) INTO v_exists;

    IF v_exists THEN
        RETURN jsonb_build_object('success', false, 'message', 'Already interested');
    END IF;

    -- Insert
    INSERT INTO public.event_interests (event_id, volunteer_id)
    VALUES (p_event_id, p_volunteer_id);

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

-- Function to revoke interest in an event
-- Bypasses RLS
CREATE OR REPLACE FUNCTION public.revoke_event_interest(p_event_id uuid, p_volunteer_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    DELETE FROM public.event_interests
    WHERE event_id = p_event_id AND volunteer_id = p_volunteer_id;

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

-- Function to register interest in an announcement (opportunity)
-- Bypasses RLS
CREATE OR REPLACE FUNCTION public.register_announcement_interest(p_announcement_id uuid, p_volunteer_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_exists boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM public.announcement_interests
        WHERE announcement_id = p_announcement_id AND volunteer_id = p_volunteer_id
    ) INTO v_exists;

    IF v_exists THEN
        RETURN jsonb_build_object('success', false, 'message', 'Already interested');
    END IF;

    INSERT INTO public.announcement_interests (announcement_id, volunteer_id)
    VALUES (p_announcement_id, p_volunteer_id);

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

-- Grant execute permissions to anon and authenticated roles
GRANT EXECUTE ON FUNCTION public.register_event_interest(uuid, uuid) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.revoke_event_interest(uuid, uuid) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.register_announcement_interest(uuid, uuid) TO anon, authenticated, service_role;
