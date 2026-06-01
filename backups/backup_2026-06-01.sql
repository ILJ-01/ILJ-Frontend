--
-- PostgreSQL database dump
--

\restrict ydxZOxLGn4y5HFtHpzYtcBRVm3wBNVA46qM7sELitegpocbdVTgXGEN3XelUk0V

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.10 (Ubuntu 17.10-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP PUBLICATION IF EXISTS supabase_realtime;
DROP POLICY IF EXISTS "Public Upload 90asdf9" ON storage.objects;
DROP POLICY IF EXISTS "Public Access 90asdf9" ON storage.objects;
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
DROP POLICY IF EXISTS "Give users access to own folder 1ljdf_3" ON storage.objects;
DROP POLICY IF EXISTS "Give users access to own folder 1ljdf_2" ON storage.objects;
DROP POLICY IF EXISTS "Give users access to own folder 1ljdf_1" ON storage.objects;
DROP POLICY IF EXISTS "Give users access to own folder 1ljdf_0" ON storage.objects;
DROP POLICY IF EXISTS "Give universally upload" ON storage.objects;
DROP POLICY IF EXISTS "Give universally" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Select" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Update" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Select" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Insert" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Insert" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Upload" ON storage.objects;
DROP POLICY IF EXISTS "Volunteers update self" ON public.volunteers;
DROP POLICY IF EXISTS "Volunteers update own data" ON public.volunteers;
DROP POLICY IF EXISTS "Volunteers manage own timesheets" ON public.timesheets;
DROP POLICY IF EXISTS "Volunteers can view own interests" ON public.announcement_interests;
DROP POLICY IF EXISTS "Volunteers Update Self" ON public.volunteers;
DROP POLICY IF EXISTS "View Projects Catalog" ON public.projects;
DROP POLICY IF EXISTS "Users view own roles" ON public.app_roles;
DROP POLICY IF EXISTS "Users see own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users manage own interests" ON public.announcement_interests;
DROP POLICY IF EXISTS "Public read project_volunteers" ON public.project_volunteers;
DROP POLICY IF EXISTS "Public Read Projects" ON public.projects;
DROP POLICY IF EXISTS "Public Read Events" ON public.events;
DROP POLICY IF EXISTS "Public Read Announcements" ON public.announcements;
DROP POLICY IF EXISTS "Projects are public" ON public.projects;
DROP POLICY IF EXISTS "Privileged Manage Projects" ON public.projects;
DROP POLICY IF EXISTS "Privileged Edit All Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Privileged Access All Timesheets" ON public.timesheets;
DROP POLICY IF EXISTS "Managers can view interests for their announcements" ON public.announcement_interests;
DROP POLICY IF EXISTS "Enable select for everyone" ON public.event_registrations;
DROP POLICY IF EXISTS "Enable insert for everyone" ON public.event_registrations;
DROP POLICY IF EXISTS "Enable delete for everyone" ON public.event_registrations;
DROP POLICY IF EXISTS "Authenticated View Interests" ON public.announcement_interests;
DROP POLICY IF EXISTS "Authenticated Users View All Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Authenticated Users View All Project Volunteers" ON public.project_volunteers;
DROP POLICY IF EXISTS "Allow public select inquiries" ON public.project_inquiries;
DROP POLICY IF EXISTS "Allow public select feedback" ON public.project_feedback;
DROP POLICY IF EXISTS "Allow public inserts on kiva_registrations" ON public.kiva_registrations;
DROP POLICY IF EXISTS "Allow public insert inquiries" ON public.project_inquiries;
DROP POLICY IF EXISTS "Allow public insert feedback" ON public.project_feedback;
DROP POLICY IF EXISTS "Allow authenticated reads on kiva_registrations" ON public.kiva_registrations;
DROP POLICY IF EXISTS "Allow all operations on spiritual_tasks" ON public.spiritual_tasks;
DROP POLICY IF EXISTS "Allow all operations on spiritual_task_assignments" ON public.spiritual_task_assignments;
DROP POLICY IF EXISTS "Allow all operations on ideas" ON public.ideas;
DROP POLICY IF EXISTS "Admins/Managers Update Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Admins/Managers Manage Project Volunteers" ON public.project_volunteers;
DROP POLICY IF EXISTS "Admins manage roles" ON public.app_roles;
DROP POLICY IF EXISTS "Admin Write Projects" ON public.projects;
DROP POLICY IF EXISTS "Admin Write Events" ON public.events;
DROP POLICY IF EXISTS "Admin Write Announcements" ON public.announcements;
DROP POLICY IF EXISTS "Admin Full Access Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Admin Full Access Tasks" ON public.tasks;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.team_meetings DROP CONSTRAINT IF EXISTS team_meetings_team_leader_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_assignee_id_fkey;
ALTER TABLE IF EXISTS ONLY public.spiritual_tasks DROP CONSTRAINT IF EXISTS spiritual_tasks_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.spiritual_task_assignments DROP CONSTRAINT IF EXISTS spiritual_task_assignments_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.spiritual_task_assignments DROP CONSTRAINT IF EXISTS spiritual_task_assignments_task_id_fkey;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_parent_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_manager_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_photos DROP CONSTRAINT IF EXISTS project_photos_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_inquiries DROP CONSTRAINT IF EXISTS project_inquiries_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_feedback DROP CONSTRAINT IF EXISTS project_feedback_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_feedback DROP CONSTRAINT IF EXISTS project_feedback_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kiva_registrations DROP CONSTRAINT IF EXISTS kiva_registrations_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.ideas DROP CONSTRAINT IF EXISTS ideas_submitted_by_fkey;
ALTER TABLE IF EXISTS ONLY public.ideas DROP CONSTRAINT IF EXISTS ideas_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_registrations DROP CONSTRAINT IF EXISTS event_registrations_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_announcement_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_oauth_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS update_volunteers_updated_at ON public.volunteers;
DROP TRIGGER IF EXISTS trigger_update_st_updated_at ON public.spiritual_tasks;
DROP TRIGGER IF EXISTS set_ilj_id ON public.volunteers;
DROP TRIGGER IF EXISTS on_volunteer_password_change ON public.volunteers;
DROP TRIGGER IF EXISTS on_volunteer_created ON public.volunteers;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name_lower;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX IF EXISTS realtime.messages_inserted_at_topic_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS public.idx_ideas_submitted_by;
DROP INDEX IF EXISTS public.idx_ideas_status;
DROP INDEX IF EXISTS public.idx_ideas_created_at;
DROP INDEX IF EXISTS auth.webauthn_credentials_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_credentials_credential_id_key;
DROP INDEX IF EXISTS auth.webauthn_challenges_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_challenges_expires_at_idx;
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_pattern_idx;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_oauth_client_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.oauth_consents_user_order_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_user_client_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_client_idx;
DROP INDEX IF EXISTS auth.oauth_clients_deleted_at_idx;
DROP INDEX IF EXISTS auth.oauth_auth_pending_exp_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_oauth_client_states_created_at;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_provider_type_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_identifier_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_enabled_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_created_at_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
ALTER TABLE IF EXISTS ONLY supabase_migrations.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY supabase_migrations.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_idempotency_key_key;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.buckets_vectors DROP CONSTRAINT IF EXISTS buckets_vectors_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_analytics DROP CONSTRAINT IF EXISTS buckets_analytics_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.volunteers DROP CONSTRAINT IF EXISTS volunteers_pkey;
ALTER TABLE IF EXISTS ONLY public.volunteers DROP CONSTRAINT IF EXISTS volunteers_ilj_id_key;
ALTER TABLE IF EXISTS ONLY public.volunteers DROP CONSTRAINT IF EXISTS volunteers_email_key;
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_pkey;
ALTER TABLE IF EXISTS ONLY public.team_meetings DROP CONSTRAINT IF EXISTS team_meetings_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_pkey;
ALTER TABLE IF EXISTS ONLY public.spiritual_tasks DROP CONSTRAINT IF EXISTS spiritual_tasks_pkey;
ALTER TABLE IF EXISTS ONLY public.spiritual_task_assignments DROP CONSTRAINT IF EXISTS spiritual_task_assignments_task_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY public.spiritual_task_assignments DROP CONSTRAINT IF EXISTS spiritual_task_assignments_pkey;
ALTER TABLE IF EXISTS ONLY public.reva_sessions DROP CONSTRAINT IF EXISTS reva_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_project_code_key;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_pkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_project_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_pkey;
ALTER TABLE IF EXISTS ONLY public.project_photos DROP CONSTRAINT IF EXISTS project_photos_pkey;
ALTER TABLE IF EXISTS ONLY public.project_inquiries DROP CONSTRAINT IF EXISTS project_inquiries_pkey;
ALTER TABLE IF EXISTS ONLY public.project_feedback DROP CONSTRAINT IF EXISTS project_feedback_pkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.kiva_registrations DROP CONSTRAINT IF EXISTS kiva_registrations_pkey;
ALTER TABLE IF EXISTS ONLY public.ideas DROP CONSTRAINT IF EXISTS ideas_pkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_pkey;
ALTER TABLE IF EXISTS ONLY public.event_registrations DROP CONSTRAINT IF EXISTS event_registrations_pkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_pkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_event_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_user_id_role_key;
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_pkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_pkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_pkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_announcement_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_pkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_client_unique;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_clients DROP CONSTRAINT IF EXISTS oauth_clients_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_client_states DROP CONSTRAINT IF EXISTS oauth_client_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_id_key;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_code_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_identifier_key;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS supabase_migrations.schema_migrations;
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.buckets_vectors;
DROP TABLE IF EXISTS storage.buckets_analytics;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages;
DROP SEQUENCE IF EXISTS public.volunteers_ilj_id_seq;
DROP TABLE IF EXISTS public.volunteers;
DROP TABLE IF EXISTS public.timesheets;
DROP TABLE IF EXISTS public.team_meetings;
DROP TABLE IF EXISTS public.tasks;
DROP TABLE IF EXISTS public.spiritual_tasks;
DROP TABLE IF EXISTS public.spiritual_task_assignments;
DROP TABLE IF EXISTS public.reva_sessions;
DROP TABLE IF EXISTS public.projects;
DROP TABLE IF EXISTS public.project_volunteers;
DROP TABLE IF EXISTS public.project_photos;
DROP TABLE IF EXISTS public.project_inquiries;
DROP TABLE IF EXISTS public.project_feedback;
DROP TABLE IF EXISTS public.notifications;
DROP TABLE IF EXISTS public.kiva_registrations;
DROP SEQUENCE IF EXISTS public.ilj_id_seq;
DROP TABLE IF EXISTS public.ideas;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.event_registrations;
DROP TABLE IF EXISTS public.event_interests;
DROP TABLE IF EXISTS public.app_roles;
DROP TABLE IF EXISTS public.announcements;
DROP TABLE IF EXISTS public.announcement_interests;
DROP TABLE IF EXISTS auth.webauthn_credentials;
DROP TABLE IF EXISTS auth.webauthn_challenges;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.oauth_consents;
DROP TABLE IF EXISTS auth.oauth_clients;
DROP TABLE IF EXISTS auth.oauth_client_states;
DROP TABLE IF EXISTS auth.oauth_authorizations;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.custom_oauth_providers;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS storage.allow_only_operation(expected_operation text);
DROP FUNCTION IF EXISTS storage.allow_any_operation(expected_operations text[]);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.verify_ilj_login(p_ilj_id text, p_password text);
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.sync_volunteer_password_to_auth();
DROP FUNCTION IF EXISTS public.set_updated_at();
DROP FUNCTION IF EXISTS public.revoke_event_interest(p_event_id uuid, p_volunteer_id uuid);
DROP FUNCTION IF EXISTS public.reset_volunteer_password(p_ilj_id text, p_email text, p_new_password text);
DROP FUNCTION IF EXISTS public.register_volunteer_secure(p_first_name text, p_last_name text, p_email text, p_mobile_number text, p_dob date, p_gender text, p_address_line1 text, p_district text, p_city text, p_state text, p_country text, p_pincode text, p_qualification text, p_specialization text, p_occupation text, p_availability_days text, p_participation_mode text, p_password_hash text, p_middle_name text, p_address_line2 text, p_sangh_name text, p_dharmik_studies text, p_occupation_other text, p_hobbies text, p_skills text, p_referred_by text, p_volunteering_preference1 text, p_volunteering_preference2 text, p_volunteering_preference3 text, p_time_commitment text, p_additional_areas text[], p_age integer);
DROP FUNCTION IF EXISTS public.register_event_interest(p_event_id uuid, p_volunteer_id uuid);
DROP FUNCTION IF EXISTS public.register_announcement_interest(p_announcement_id uuid, p_volunteer_id uuid);
DROP FUNCTION IF EXISTS public.login_volunteer(p_ilj_id text, p_password text);
DROP FUNCTION IF EXISTS public.is_allowed_origin();
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.handle_new_volunteer();
DROP FUNCTION IF EXISTS public.get_user_privilege_level();
DROP FUNCTION IF EXISTS public.generate_ilj_id();
DROP FUNCTION IF EXISTS public.force_sync_auth_password(p_ilj_id text, p_password text);
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS storage.buckettype;
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.oauth_response_type;
DROP TYPE IF EXISTS auth.oauth_registration_type;
DROP TYPE IF EXISTS auth.oauth_client_type;
DROP TYPE IF EXISTS auth.oauth_authorization_status;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS supabase_vault;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS supabase_migrations;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
DROP SCHEMA IF EXISTS pgbouncer;
DROP EXTENSION IF EXISTS pg_net;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
DROP SCHEMA IF EXISTS extensions;
DROP SCHEMA IF EXISTS auth;
--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: -
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: force_sync_auth_password(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.force_sync_auth_password(p_ilj_id text, p_password text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth', 'extensions'
    AS $$
DECLARE
    v_volunteer record;
    v_user_exists boolean;
BEGIN
    -- 1. Get volunteer details including the password_hash
    SELECT id, email, password_hash, first_name, last_name 
    INTO v_volunteer
    FROM public.volunteers
    WHERE upper(ilj_id) = upper(p_ilj_id);

    IF v_volunteer.id IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Volunteer not found');
    END IF;

    -- 2. Check if auth user exists
    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = v_volunteer.id) INTO v_user_exists;

    -- 3. Update or Insert - COPY the existing password_hash instead of generating new
    IF v_user_exists THEN
        -- User exists: copy the EXACT password hash from volunteers table
        UPDATE auth.users
        SET encrypted_password = v_volunteer.password_hash,
            updated_at = now()
        WHERE id = v_volunteer.id;
        
        RETURN json_build_object('success', true, 'action', 'updated');
    ELSE
        -- User does NOT exist in auth: create them with the same password hash
        INSERT INTO auth.users (
            instance_id,
            id,
            aud,
            role,
            email,
            encrypted_password,
            email_confirmed_at,
            raw_app_meta_data,
            raw_user_meta_data,
            created_at,
            updated_at
        ) VALUES (
            '00000000-0000-0000-0000-000000000000',
            v_volunteer.id,
            'authenticated',
            'authenticated',
            v_volunteer.email,
            v_volunteer.password_hash,  -- Use EXISTING hash
            now(),
            '{"provider":"email","providers":["email"]}',
            json_build_object(
                'ilj_id', upper(p_ilj_id),
                'first_name', v_volunteer.first_name,
                'last_name', v_volunteer.last_name
            ),
            now(),
            now()
        );
        
        -- Also insert identity for email provider
        INSERT INTO auth.identities (
            id,
            user_id,
            identity_data,
            provider,
            last_sign_in_at,
            created_at,
            updated_at
        ) VALUES (
            v_volunteer.id,
            v_volunteer.id,
            json_build_object('sub', v_volunteer.id, 'email', v_volunteer.email),
            'email',
            now(),
            now(),
            now()
        );

        RETURN json_build_object('success', true, 'action', 'created');
    END IF;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object('success', false, 'error', SQLERRM);
END;
$$;


--
-- Name: generate_ilj_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_ilj_id() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    IF NEW.ilj_id IS NULL THEN
        NEW.ilj_id := 'ILJ-' || LPAD(nextval('public.volunteers_ilj_id_seq')::TEXT, 3, '0');
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: get_user_privilege_level(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_privilege_level() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_role text;
    v_is_leader boolean;
    v_is_manager boolean;
BEGIN
    -- 1. Check Explicit Roles (app_roles)
    SELECT role INTO v_role FROM public.app_roles WHERE user_id = auth.uid() LIMIT 1;
    IF v_role IS NOT NULL THEN
        RETURN v_role; -- 'admin', 'manager', 'team_leader'
    END IF;

    -- 2. Check Dynamic Manager Status (projects.manager_id)
    -- Managers should have higher privilege than team leaders implicitly
    SELECT EXISTS(SELECT 1 FROM public.projects WHERE manager_id = auth.uid()) INTO v_is_manager;
    
    IF v_is_manager THEN
        RETURN 'manager';
    END IF;

    -- 3. Check Dynamic Leader Status (volunteers.team_leader_for)
    SELECT (team_leader_for IS NOT NULL AND team_leader_for != '') INTO v_is_leader
    FROM public.volunteers 
    WHERE id = auth.uid();
    
    IF v_is_leader THEN
        RETURN 'team_leader';
    END IF;

    -- Default
    RETURN 'volunteer';
END;
$$;


--
-- Name: handle_new_volunteer(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_volunteer() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Insert into auth.users if not exists
  INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    role,
    aud,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.password_hash,
    now(),
    'authenticated',
    'authenticated',
    now(),
    now(),
    '{"provider":"email","providers":["email"]}',
    json_build_object(
        'ilj_id', NEW.ilj_id,
        'first_name', NEW.first_name,
        'last_name', NEW.last_name,
        'app_role', 'volunteer'
    )
  )
  ON CONFLICT (id) DO NOTHING;
  
  -- Insert Identity
  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    NEW.id,
    json_build_object('sub', NEW.id, 'email', NEW.email),
    'email',
    NEW.email,
    now(),
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- 1. Legacy Check (Specific Email)
  IF (auth.jwt() ->> 'email') = 'admin@ilovejinshasan.org' THEN
    RETURN true;
  END IF;

  -- 2. Role Check
  -- Grants admin-level rights to Managers and Team Leaders
  -- Uses get_user_privilege_level() which MUST be SECURITY DEFINER to avoid infinite recursion
  -- when accessed by RLS policies on 'projects' or 'volunteers' tables.
  RETURN get_user_privilege_level() IN ('admin', 'manager', 'team_leader');
END;
$$;


--
-- Name: is_allowed_origin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_allowed_origin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    req_headers json;
    origin_value text;
BEGIN
    -- Get headers from the current request
    req_headers := current_setting('request.headers', true)::json;
    
    -- Extract Origin
    origin_value := req_headers ->> 'origin';
    
    -- Allow if:
    -- 1. It matches our domain
    -- 2. OR if it is null (sometimes server-side functions or specialized clients don't send it, 
    --    but blocking NULL might break internal Supabase tools. use caution.)
    --    Actually, for strict mode, we might want to REQUIRE it, but that breaks Edge Functions potentially.
    --    Let's stick to: If it IS present, it MUST match. 
    --    If it is NOT present, we usually allow (for scripts/internal), OR we block if we want strict web-only.
    --    User asked for "only http requests from https://...", implying web-only.
    
    -- STRICT MODE:
    -- If 'origin' is present, it MUST be the allowed domain.
    -- If 'origin' is missing:
    --    - If role is 'service_role', ALLOW (internal admin)
    --    - If role is 'authenticated' or 'anon', BLOCK (assume it's a script/curl without header)
    
    IF (auth.role() = 'service_role') THEN
        RETURN true;
    END IF;

    -- If origin is present, check it
    IF origin_value IS NOT NULL THEN
        RETURN origin_value = 'https://www.ilovejinshasan.org' OR origin_value = 'http://localhost:5173'; -- Debugging allow localhost
    END IF;

    -- If origin is missing, block for anon/authenticated (likely curl/postman)
    RETURN false;
END;
$$;


--
-- Name: login_volunteer(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.login_volunteer(p_ilj_id text, p_password text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_user record;
    v_password_match boolean;
BEGIN
    -- Find the user by ILJ ID (case-insensitive)
    SELECT * INTO v_user
    FROM public.volunteers
    WHERE upper(ilj_id) = upper(p_ilj_id);

    IF v_user IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or password');
    END IF;

    -- Verify password using pgcrypto
    IF (v_user.password_hash = crypt(p_password, v_user.password_hash)) THEN
        -- Return user data (excluding password_hash)
        RETURN json_build_object(
            'success', true, 
            'user', to_jsonb(v_user) - 'password_hash'
        );
    ELSE
        RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or password');
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object('success', false, 'error', SQLERRM);
END;
$$;


--
-- Name: register_announcement_interest(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.register_announcement_interest(p_announcement_id uuid, p_volunteer_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: register_event_interest(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.register_event_interest(p_event_id uuid, p_volunteer_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
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


--
-- Name: register_volunteer_secure(text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.register_volunteer_secure(p_first_name text, p_last_name text, p_email text, p_mobile_number text, p_dob date, p_gender text, p_address_line1 text, p_district text, p_city text, p_state text, p_country text, p_pincode text, p_qualification text, p_specialization text, p_occupation text, p_availability_days text, p_participation_mode text, p_password_hash text, p_middle_name text DEFAULT NULL::text, p_address_line2 text DEFAULT NULL::text, p_sangh_name text DEFAULT NULL::text, p_dharmik_studies text DEFAULT NULL::text, p_occupation_other text DEFAULT NULL::text, p_hobbies text DEFAULT NULL::text, p_skills text DEFAULT NULL::text, p_referred_by text DEFAULT NULL::text, p_volunteering_preference1 text DEFAULT NULL::text, p_volunteering_preference2 text DEFAULT NULL::text, p_volunteering_preference3 text DEFAULT NULL::text, p_time_commitment text DEFAULT NULL::text, p_additional_areas text[] DEFAULT NULL::text[], p_age integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
  v_new_id uuid;
  v_ilj_id text;
  v_count int;
  v_final_age int;
BEGIN
  -- Check email uniqueness
  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;
  IF v_count > 0 THEN
    RETURN json_build_object('success', false, 'error', 'Email already registered');
  END IF;

  -- Calculate age if not provided
  IF p_age IS NULL AND p_dob IS NOT NULL THEN
    v_final_age := date_part('year', age(p_dob));
  ELSE
    v_final_age := p_age;
  END IF;

  -- Insert WITHOUT providing ilj_id, so the trigger generates it.
  -- We capture the generated ID using RETURNING.
  INSERT INTO volunteers (
    first_name, last_name, email, mobile_number, dob, gender,
    address_line1, district, city, state, country, pincode,
    qualification, specialization, occupation, availability_days, participation_mode,
    password_hash,
    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,
    hobbies, skills, referred_by,
    volunteering_preference1, volunteering_preference2, volunteering_preference3,
    time_commitment, additional_areas,
    age
  ) VALUES (
    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,
    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,
    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,
    crypt(p_password_hash, gen_salt('bf')), -- Hash the password for storage
    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,
    p_hobbies, p_skills, p_referred_by,
    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,
    p_time_commitment, p_additional_areas,
    v_final_age
  ) RETURNING id, ilj_id INTO v_new_id, v_ilj_id;

  -- Send Email with the CORRECT ID (v_ilj_id)
  PERFORM net.http_post(
      url := 'https://pdcgcqsgzupoyzklvoju.supabase.co/functions/v1/send-welcome-email',
      headers := '{"Content-Type": "application/json", "x-admin-secret": "ILJ_INTERNAL_SECRET_2026"}'::jsonb,
      body := json_build_object(
        'to', p_email,
        'ilj_id', v_ilj_id,
        'password', p_password_hash, 
        'first_name', p_first_name,
        'last_name', p_last_name
      )::jsonb
  );

  RETURN json_build_object(
    'success', true,
    'ilj_id', v_ilj_id,
    'email', p_email
  );
END;
$$;


--
-- Name: reset_volunteer_password(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reset_volunteer_password(p_ilj_id text, p_email text, p_new_password text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Check if user exists with matching ILJ ID and Email
    SELECT id INTO v_user_id
    FROM public.volunteers
    WHERE upper(ilj_id) = upper(p_ilj_id)
      AND lower(email) = lower(p_email);

    IF v_user_id IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or Email combination');
    END IF;

    -- Update the password with new hash
    UPDATE public.volunteers
    SET password_hash = crypt(p_new_password, gen_salt('bf'))
    WHERE id = v_user_id;

    RETURN json_build_object('success', true, 'message', 'Password updated successfully');
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object('success', false, 'error', SQLERRM);
END;
$$;


--
-- Name: revoke_event_interest(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.revoke_event_interest(p_event_id uuid, p_volunteer_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    DELETE FROM public.event_interests
    WHERE event_id = p_event_id AND volunteer_id = p_volunteer_id;

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: sync_volunteer_password_to_auth(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_volunteer_password_to_auth() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    -- Only update if password_hash has changed
    IF NEW.password_hash IS DISTINCT FROM OLD.password_hash THEN
        UPDATE auth.users
        SET encrypted_password = NEW.password_hash,
            updated_at = now()
        WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: verify_ilj_login(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verify_ilj_login(p_ilj_id text, p_password text) RETURNS TABLE(email text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT v.email
  FROM public.volunteers v
  WHERE v.ilj_id = p_ilj_id 
  AND (
      v.password_hash = crypt(p_password, v.password_hash)
      OR v.password_hash = p_password -- Handle plain text edge cases if any
  );
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- Name: announcement_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcement_interests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    announcement_id uuid,
    volunteer_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    type text DEFAULT 'general'::text,
    project_id uuid,
    deadline timestamp with time zone
);


--
-- Name: app_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT app_roles_role_check CHECK ((role = ANY (ARRAY['admin'::text, 'team_leader'::text, 'manager'::text])))
);


--
-- Name: event_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_interests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid,
    volunteer_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: event_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_registrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    full_name text NOT NULL,
    whatsapp_number text NOT NULL,
    age text,
    address text,
    sangh_name text,
    payment_screenshot_url text,
    created_at timestamp with time zone DEFAULT now(),
    email text,
    dob date,
    mobile_number text,
    is_vihar_sevika boolean,
    photograph_url text,
    fathers_name text,
    emergency_contact_name text,
    emergency_contact_number text,
    emergency_contact_relation text,
    supported_file_url text,
    payment_date date,
    vihar_seva_head_name text,
    vihar_seva_head_contact text,
    mothers_name text,
    contact_no_3 text,
    education_details text,
    dharmik_education text,
    hobbies text,
    medical_information text
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    title text NOT NULL,
    date timestamp with time zone NOT NULL,
    role_needed text,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    banner_url text
);


--
-- Name: ideas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ideas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    project_id uuid,
    submitted_by uuid NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    admin_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT ideas_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'approved'::text, 'implemented'::text, 'rejected'::text])))
);


--
-- Name: ilj_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ilj_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kiva_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kiva_registrations (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    project_id uuid,
    is_ilj_volunteer boolean DEFAULT false,
    ilj_id text,
    full_name text NOT NULL,
    mobile_number text NOT NULL,
    preferred_dates text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    type text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: project_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_feedback (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    rating integer,
    comments text,
    is_anonymous boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    name text,
    mobile text,
    email text,
    age integer,
    city text,
    is_featured boolean DEFAULT false,
    event_id uuid
);


--
-- Name: project_inquiries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_inquiries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    name text,
    email text,
    mobile text,
    message text,
    created_at timestamp with time zone DEFAULT now(),
    sangh_name text,
    sangh_address text,
    proposed_venue text,
    proposed_dates text,
    how_did_you_know text
);


--
-- Name: project_photos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_photos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    photo_url text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


--
-- Name: project_volunteers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_volunteers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    volunteer_id uuid,
    assigned_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'approved'::text,
    engagement_status text DEFAULT 'pending'::text,
    CONSTRAINT project_volunteers_engagement_status_check CHECK ((engagement_status = ANY (ARRAY['pending'::text, 'contacted'::text, 'introduced'::text, 'active'::text, 'inactive'::text])))
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_code text NOT NULL,
    title text NOT NULL,
    description text,
    banner_url text,
    manager_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'upcoming'::text,
    visibility text DEFAULT 'public'::text,
    next_event_date text,
    is_event_registration_enabled boolean DEFAULT false,
    parent_project_id uuid,
    registration_link text,
    qna_link text,
    CONSTRAINT check_visibility_projects CHECK ((visibility = ANY (ARRAY['public'::text, 'private'::text])))
);


--
-- Name: reva_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reva_sessions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    venue text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: spiritual_task_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spiritual_task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    volunteer_id uuid NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT spiritual_task_assignments_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text])))
);


--
-- Name: spiritual_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spiritual_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    assignment_type text DEFAULT 'specific'::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT spiritual_tasks_assignment_type_check CHECK ((assignment_type = ANY (ARRAY['all'::text, 'specific'::text])))
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    project_id uuid,
    event_id uuid,
    assignee_id uuid,
    deadline timestamp with time zone,
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT now(),
    rating integer,
    feedback_comments text,
    CONSTRAINT tasks_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT tasks_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'completed'::text, 'archived'::text])))
);


--
-- Name: team_meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_meetings (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    team_leader_id uuid,
    team_name character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    meeting_date timestamp with time zone NOT NULL,
    meeting_link character varying(255),
    minutes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: timesheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timesheets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    volunteer_id uuid,
    project_id uuid,
    event_id uuid,
    role text,
    hours numeric NOT NULL,
    work_mode text,
    description text,
    status text DEFAULT 'pending'::text,
    date_worked date NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT timesheets_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


--
-- Name: volunteers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.volunteers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ilj_id text NOT NULL,
    first_name text NOT NULL,
    middle_name text,
    last_name text NOT NULL,
    dob date NOT NULL,
    age integer,
    gender text NOT NULL,
    mobile_number text NOT NULL,
    email text NOT NULL,
    address_line1 text NOT NULL,
    address_line2 text,
    district text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    pincode text NOT NULL,
    country text NOT NULL,
    dharmik_studies text,
    qualification text NOT NULL,
    specialization text NOT NULL,
    occupation text NOT NULL,
    occupation_other text,
    hobbies text,
    skills text,
    referred_by text,
    volunteering_preference1 text NOT NULL,
    volunteering_preference2 text,
    volunteering_preference3 text,
    availability_days text NOT NULL,
    time_commitment text,
    participation_mode text NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    additional_areas text[],
    sangh_name text,
    kalyan_mitra text,
    team_leader_for text,
    rank text DEFAULT 'Intern'::text,
    designation text,
    secondary_designation text,
    is_it_admin boolean DEFAULT false,
    is_onboarding_team boolean DEFAULT false,
    onboarding_status text DEFAULT 'pending'::text,
    assigned_pod text,
    is_pod_team boolean DEFAULT false,
    activity_status text DEFAULT 'Active'::text,
    CONSTRAINT check_secondary_designation CHECK (((secondary_designation IS NULL) OR (secondary_designation = ANY (ARRAY['Chair Person'::text, 'Vice Chair Person'::text])))),
    CONSTRAINT volunteers_onboarding_status_check CHECK ((onboarding_status = ANY (ARRAY['pending'::text, 'contacted'::text, 'onboarded'::text, 'pending_it'::text, 'duplicate'::text, 'pending_onboarding'::text])))
);


--
-- Name: volunteers_ilj_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volunteers_ilj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
35c1bb89-4881-4798-a257-8b714d2017dd	35c1bb89-4881-4798-a257-8b714d2017dd	{"sub": "35c1bb89-4881-4798-a257-8b714d2017dd", "email": "admin@ilovejinshasan.org", "email_verified": false, "phone_verified": false}	email	2026-02-05 06:26:50.439448+00	2026-02-05 06:26:50.439538+00	2026-02-05 06:26:50.439538+00	551d3f83-66c9-4431-99a8-c390d73ace7f
mehtameet115@gmail.com	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	{"sub": "7da7baeb-2615-4949-bc8c-5e10a3ea5ffd", "email": "mehtameet115@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd
smitmehta50@gmail.com	0e833c46-ec3f-4681-8dbc-2bec029d8db1	{"sub": "0e833c46-ec3f-4681-8dbc-2bec029d8db1", "email": "smitmehta50@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	0e833c46-ec3f-4681-8dbc-2bec029d8db1
pritiaayu1@gmail.com	f51b0111-f04d-453a-b6c0-60d9832fba6b	{"sub": "f51b0111-f04d-453a-b6c0-60d9832fba6b", "email": "pritiaayu1@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	f51b0111-f04d-453a-b6c0-60d9832fba6b
securitytest@example.com	dd02c815-1f54-4572-9830-aba8c9aaa18e	{"sub": "dd02c815-1f54-4572-9830-aba8c9aaa18e", "email": "securitytest@example.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	dd02c815-1f54-4572-9830-aba8c9aaa18e
cajainam04@gmail.com	03a59a7d-da67-44b8-88f7-1a0fbe44f706	{"sub": "03a59a7d-da67-44b8-88f7-1a0fbe44f706", "email": "cajainam04@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	03a59a7d-da67-44b8-88f7-1a0fbe44f706
charmipdedhia@gmail.com	7e72384f-5a73-498c-b82e-57dd17a6ea18	{"sub": "7e72384f-5a73-498c-b82e-57dd17a6ea18", "email": "charmipdedhia@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	7e72384f-5a73-498c-b82e-57dd17a6ea18
labdhishah128@gmail.com	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	{"sub": "043bde9c-9ebb-4e8c-8ccb-a975a83eec39", "email": "labdhishah128@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	043bde9c-9ebb-4e8c-8ccb-a975a83eec39
jdoshi154@gmail.com	4de93087-ee99-48dc-b3a5-4339c8da81ec	{"sub": "4de93087-ee99-48dc-b3a5-4339c8da81ec", "email": "jdoshi154@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	4de93087-ee99-48dc-b3a5-4339c8da81ec
jainammehta519@gmail.com	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	{"sub": "a59d9b96-eccd-4b3a-a15f-ad6f693013a7", "email": "jainammehta519@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	a59d9b96-eccd-4b3a-a15f-ad6f693013a7
bhavyarsanghavi99@gmail.com	e243534f-6a49-436d-b637-a050b1e32de0	{"sub": "e243534f-6a49-436d-b637-a050b1e32de0", "email": "bhavyarsanghavi99@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	e243534f-6a49-436d-b637-a050b1e32de0
dishagandhi136@gmail.com	55ca6718-5a82-408d-800d-86cc3c49bbca	{"sub": "55ca6718-5a82-408d-800d-86cc3c49bbca", "email": "dishagandhi136@gmail.com"}	email	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	2026-02-06 14:09:50.304608+00	55ca6718-5a82-408d-800d-86cc3c49bbca
meetsalot1102@gmail.com	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	{"sub": "93748e18-e2ba-46c6-8f37-7ebfe143bfe1", "email": "meetsalot1102@gmail.com"}	email	2026-02-07 15:46:02.339115+00	2026-02-07 15:46:02.339115+00	2026-02-07 15:46:02.339115+00	93748e18-e2ba-46c6-8f37-7ebfe143bfe1
vatsalm707@gmail.com	b2bc304c-62d9-4383-8af6-f78a51c94374	{"sub": "b2bc304c-62d9-4383-8af6-f78a51c94374", "email": "vatsalm707@gmail.com"}	email	2026-02-07 15:48:14.029+00	2026-02-07 15:48:14.029+00	2026-02-07 15:48:14.029+00	b2bc304c-62d9-4383-8af6-f78a51c94374
aayushvora2003@gmail.com	232f55ca-9598-4daf-a8ef-5e9be124c975	{"sub": "232f55ca-9598-4daf-a8ef-5e9be124c975", "email": "aayushvora2003@gmail.com"}	email	2026-02-07 16:04:41.420873+00	2026-02-07 16:04:41.420873+00	2026-02-07 16:04:41.420873+00	232f55ca-9598-4daf-a8ef-5e9be124c975
meets.studentlife@gmail.com	41fcbca1-3193-42ce-8585-95372b4b9d52	{"sub": "41fcbca1-3193-42ce-8585-95372b4b9d52", "email": "meets.studentlife@gmail.com"}	email	2026-02-07 16:44:00.216534+00	2026-02-07 16:44:00.216534+00	2026-02-07 16:44:00.216534+00	41fcbca1-3193-42ce-8585-95372b4b9d52
shikhacmehta@gmail.com	d22fd755-c0a9-4474-8280-64d42c126700	{"sub": "d22fd755-c0a9-4474-8280-64d42c126700", "email": "shikhacmehta@gmail.com"}	email	2026-02-08 05:21:07.814826+00	2026-02-08 05:21:07.814826+00	2026-02-08 05:21:07.814826+00	d22fd755-c0a9-4474-8280-64d42c126700
avanidoshi09@gmail.com	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	{"sub": "fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9", "email": "avanidoshi09@gmail.com"}	email	2026-02-08 13:44:08.339872+00	2026-02-08 13:44:08.339872+00	2026-02-08 13:44:08.339872+00	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9
saachijain808@gmail.com	32837c38-a21e-450a-8613-ec2c09f3cc97	{"sub": "32837c38-a21e-450a-8613-ec2c09f3cc97", "email": "saachijain808@gmail.com"}	email	2026-02-08 13:47:14.371431+00	2026-02-08 13:47:14.371431+00	2026-02-08 13:47:14.371431+00	32837c38-a21e-450a-8613-ec2c09f3cc97
jash4739@gmail.com	3b54e716-c5a0-4d4c-a616-4e2e2be95539	{"sub": "3b54e716-c5a0-4d4c-a616-4e2e2be95539", "email": "jash4739@gmail.com"}	email	2026-02-08 13:47:57.729658+00	2026-02-08 13:47:57.729658+00	2026-02-08 13:47:57.729658+00	3b54e716-c5a0-4d4c-a616-4e2e2be95539
hcs180906@gmail.com	33e91007-e2fa-4274-801b-4227ea2f7909	{"sub": "33e91007-e2fa-4274-801b-4227ea2f7909", "email": "hcs180906@gmail.com"}	email	2026-02-08 14:09:43.688078+00	2026-02-08 14:09:43.688078+00	2026-02-08 14:09:43.688078+00	33e91007-e2fa-4274-801b-4227ea2f7909
heershah12116@gmail.com	2c1bcdc5-0564-44d9-be4a-158445f39975	{"sub": "2c1bcdc5-0564-44d9-be4a-158445f39975", "email": "heershah12116@gmail.com"}	email	2026-02-08 15:01:59.839918+00	2026-02-08 15:01:59.839918+00	2026-02-08 15:01:59.839918+00	2c1bcdc5-0564-44d9-be4a-158445f39975
charmi2630@gmail.com	c371c0b4-f445-41ec-b6cf-ba6828e59757	{"sub": "c371c0b4-f445-41ec-b6cf-ba6828e59757", "email": "charmi2630@gmail.com"}	email	2026-02-08 15:26:44.396583+00	2026-02-08 15:26:44.396583+00	2026-02-08 15:26:44.396583+00	c371c0b4-f445-41ec-b6cf-ba6828e59757
yashvimaheta135@gmail.com	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	{"sub": "2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38", "email": "yashvimaheta135@gmail.com"}	email	2026-02-08 19:53:24.892602+00	2026-02-08 19:53:24.892602+00	2026-02-08 19:53:24.892602+00	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38
vatsalmehta5106@gmail.com	481b2283-318d-48b8-94f3-63c9f6fcf7af	{"sub": "481b2283-318d-48b8-94f3-63c9f6fcf7af", "email": "vatsalmehta5106@gmail.com"}	email	2026-02-09 09:39:09.593969+00	2026-02-09 09:39:09.593969+00	2026-02-09 09:39:09.593969+00	481b2283-318d-48b8-94f3-63c9f6fcf7af
vividhapatwa@gmail.com	7034d767-3884-4660-bdc7-ddcd51cd38c3	{"sub": "7034d767-3884-4660-bdc7-ddcd51cd38c3", "email": "vividhapatwa@gmail.com"}	email	2026-02-09 14:05:14.864396+00	2026-02-09 14:05:14.864396+00	2026-02-09 14:05:14.864396+00	7034d767-3884-4660-bdc7-ddcd51cd38c3
shahmahek1210@gmail.com	4c363395-b574-454e-abb9-bb28a79d09d3	{"sub": "4c363395-b574-454e-abb9-bb28a79d09d3", "email": "shahmahek1210@gmail.com"}	email	2026-02-09 16:39:41.380421+00	2026-02-09 16:39:41.380421+00	2026-02-09 16:39:41.380421+00	4c363395-b574-454e-abb9-bb28a79d09d3
Siddhi61d@sttherese.in	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	{"sub": "fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9", "email": "Siddhi61d@sttherese.in"}	email	2026-02-09 16:46:53.51547+00	2026-02-09 16:46:53.51547+00	2026-02-09 16:46:53.51547+00	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9
ns4934551@gmail.com	d4c73898-8bda-476d-a068-898c72460441	{"sub": "d4c73898-8bda-476d-a068-898c72460441", "email": "ns4934551@gmail.com"}	email	2026-02-09 17:09:30.799752+00	2026-02-09 17:09:30.799752+00	2026-02-09 17:09:30.799752+00	d4c73898-8bda-476d-a068-898c72460441
veertigada12345@gmail.com	9f90c956-1695-4492-9fc3-569b6e4cc326	{"sub": "9f90c956-1695-4492-9fc3-569b6e4cc326", "email": "veertigada12345@gmail.com"}	email	2026-02-10 09:39:21.55993+00	2026-02-10 09:39:21.55993+00	2026-02-10 09:39:21.55993+00	9f90c956-1695-4492-9fc3-569b6e4cc326
dhiaanjain2@gmail.com	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	{"sub": "3b05ba3c-4755-4104-a7b9-d7f7846cc4be", "email": "dhiaanjain2@gmail.com"}	email	2026-02-10 09:53:38.722481+00	2026-02-10 09:53:38.722481+00	2026-02-10 09:53:38.722481+00	3b05ba3c-4755-4104-a7b9-d7f7846cc4be
aayushishah1556@gmail.com	9a067c77-bb95-44cc-812e-4557ac17f80a	{"sub": "9a067c77-bb95-44cc-812e-4557ac17f80a", "email": "aayushishah1556@gmail.com"}	email	2026-02-10 10:10:54.446122+00	2026-02-10 10:10:54.446122+00	2026-02-10 10:10:54.446122+00	9a067c77-bb95-44cc-812e-4557ac17f80a
ankitsheth8@gmail.com	b8f6d90e-b692-4a8a-8cbc-17909331fa73	{"sub": "b8f6d90e-b692-4a8a-8cbc-17909331fa73", "email": "ankitsheth8@gmail.com"}	email	2026-02-10 10:28:33.582157+00	2026-02-10 10:28:33.582157+00	2026-02-10 10:28:33.582157+00	b8f6d90e-b692-4a8a-8cbc-17909331fa73
yogitapd15@gmail.com	60084f34-305e-42b4-8330-70bba97a2126	{"sub": "60084f34-305e-42b4-8330-70bba97a2126", "email": "yogitapd15@gmail.com"}	email	2026-02-10 10:32:49.505559+00	2026-02-10 10:32:49.505559+00	2026-02-10 10:32:49.505559+00	60084f34-305e-42b4-8330-70bba97a2126
yashvi.sanghavi.dombivli@gmail.com	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	{"sub": "c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b", "email": "yashvi.sanghavi.dombivli@gmail.com"}	email	2026-02-10 14:20:52.226662+00	2026-02-10 14:20:52.226662+00	2026-02-10 14:20:52.226662+00	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b
ronakdoshi2024@gmail.com	73e309c3-69be-4b6c-97bf-b23ee7c5634c	{"sub": "73e309c3-69be-4b6c-97bf-b23ee7c5634c", "email": "ronakdoshi2024@gmail.com"}	email	2026-02-10 16:27:01.787267+00	2026-02-10 16:27:01.787267+00	2026-02-10 16:27:01.787267+00	73e309c3-69be-4b6c-97bf-b23ee7c5634c
Snehivora06@gmail.com	58be09cf-362d-4919-9a0a-67aa65a5c52e	{"sub": "58be09cf-362d-4919-9a0a-67aa65a5c52e", "email": "Snehivora06@gmail.com"}	email	2026-02-10 17:33:08.82233+00	2026-02-10 17:33:08.82233+00	2026-02-10 17:33:08.82233+00	58be09cf-362d-4919-9a0a-67aa65a5c52e
Shreyamehttaa@gmail.com	41135cc0-c4af-478a-bc6e-6ef25590fd94	{"sub": "41135cc0-c4af-478a-bc6e-6ef25590fd94", "email": "Shreyamehttaa@gmail.com"}	email	2026-02-11 10:13:04.965688+00	2026-02-11 10:13:04.965688+00	2026-02-11 10:13:04.965688+00	41135cc0-c4af-478a-bc6e-6ef25590fd94
aditimaheta720@gmail.com	f2179127-e88f-41f3-910a-f9dd0fa2647a	{"sub": "f2179127-e88f-41f3-910a-f9dd0fa2647a", "email": "aditimaheta720@gmail.com"}	email	2026-02-11 13:37:56.317839+00	2026-02-11 13:37:56.317839+00	2026-02-11 13:37:56.317839+00	f2179127-e88f-41f3-910a-f9dd0fa2647a
Khushishahh372@gmail.com	aded593b-ae3f-4eca-8edf-658f89bb172c	{"sub": "aded593b-ae3f-4eca-8edf-658f89bb172c", "email": "Khushishahh372@gmail.com"}	email	2026-02-11 13:57:01.840037+00	2026-02-11 13:57:01.840037+00	2026-02-11 13:57:01.840037+00	aded593b-ae3f-4eca-8edf-658f89bb172c
nemilyshah@gmail.com	dd8599b5-9989-4b14-9d33-6e4913e6693e	{"sub": "dd8599b5-9989-4b14-9d33-6e4913e6693e", "email": "nemilyshah@gmail.com"}	email	2026-02-11 14:10:09.394196+00	2026-02-11 14:10:09.394196+00	2026-02-11 14:10:09.394196+00	dd8599b5-9989-4b14-9d33-6e4913e6693e
hiyagandhi624@gmail.com	96c9c515-49dc-4172-95d9-7a57478388c3	{"sub": "96c9c515-49dc-4172-95d9-7a57478388c3", "email": "hiyagandhi624@gmail.com"}	email	2026-02-11 14:45:03.463763+00	2026-02-11 14:45:03.463763+00	2026-02-11 14:45:03.463763+00	96c9c515-49dc-4172-95d9-7a57478388c3
veerammehta175@gmail.com	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	{"sub": "cd48a9cd-dc2c-420e-874e-f8a50167c9bd", "email": "veerammehta175@gmail.com"}	email	2026-02-11 15:47:27.734778+00	2026-02-11 15:47:27.734778+00	2026-02-11 15:47:27.734778+00	cd48a9cd-dc2c-420e-874e-f8a50167c9bd
mokshangj@gmail.com	a551cf3f-5282-49ea-b432-7624af5558b2	{"sub": "a551cf3f-5282-49ea-b432-7624af5558b2", "email": "mokshangj@gmail.com"}	email	2026-02-11 15:48:10.046077+00	2026-02-11 15:48:10.046077+00	2026-02-11 15:48:10.046077+00	a551cf3f-5282-49ea-b432-7624af5558b2
bhumisanghavi2003@gmail.com	df0f9941-a563-4844-adf0-3058c435dbf3	{"sub": "df0f9941-a563-4844-adf0-3058c435dbf3", "email": "bhumisanghavi2003@gmail.com"}	email	2026-02-11 16:12:01.955263+00	2026-02-11 16:12:01.955263+00	2026-02-11 16:12:01.955263+00	df0f9941-a563-4844-adf0-3058c435dbf3
yeshasalot@gmail.com	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	{"sub": "6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb", "email": "yeshasalot@gmail.com"}	email	2026-02-11 18:16:42.744692+00	2026-02-11 18:16:42.744692+00	2026-02-11 18:16:42.744692+00	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb
aayushsanghavi97@gmail.com	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	{"sub": "e511ae7b-67bc-45ff-84f7-29be33b3a5e6", "email": "aayushsanghavi97@gmail.com"}	email	2026-02-12 04:35:50.529978+00	2026-02-12 04:35:50.529978+00	2026-02-12 04:35:50.529978+00	e511ae7b-67bc-45ff-84f7-29be33b3a5e6
kreena.b@somaiya.edu	fe64f71e-bc1f-4297-af8a-9dfae090e0be	{"sub": "fe64f71e-bc1f-4297-af8a-9dfae090e0be", "email": "kreena.b@somaiya.edu"}	email	2026-02-12 05:27:29.57057+00	2026-02-12 05:27:29.57057+00	2026-02-12 05:27:29.57057+00	fe64f71e-bc1f-4297-af8a-9dfae090e0be
mehtajiana7@gmail.com	4842d49f-c3ea-47a4-bfee-03837bec04a5	{"sub": "4842d49f-c3ea-47a4-bfee-03837bec04a5", "email": "mehtajiana7@gmail.com"}	email	2026-02-12 06:31:29.839705+00	2026-02-12 06:31:29.839705+00	2026-02-12 06:31:29.839705+00	4842d49f-c3ea-47a4-bfee-03837bec04a5
prachishah1311@gmail.com	6a89d207-b9ef-4e2b-9a9a-14b42000db10	{"sub": "6a89d207-b9ef-4e2b-9a9a-14b42000db10", "email": "prachishah1311@gmail.com"}	email	2026-02-12 06:34:31.526794+00	2026-02-12 06:34:31.526794+00	2026-02-12 06:34:31.526794+00	6a89d207-b9ef-4e2b-9a9a-14b42000db10
daftariharshil@gmail.com	8b946c8c-5583-4340-94ac-a0c3801bfb98	{"sub": "8b946c8c-5583-4340-94ac-a0c3801bfb98", "email": "daftariharshil@gmail.com"}	email	2026-02-12 09:08:15.978922+00	2026-02-12 09:08:15.978922+00	2026-02-12 09:08:15.978922+00	8b946c8c-5583-4340-94ac-a0c3801bfb98
rutvisanghavi5@gmail.com	f854a439-e72d-44fc-8efe-a0f755462a04	{"sub": "f854a439-e72d-44fc-8efe-a0f755462a04", "email": "rutvisanghavi5@gmail.com"}	email	2026-02-12 10:04:52.685918+00	2026-02-12 10:04:52.685918+00	2026-02-12 10:04:52.685918+00	f854a439-e72d-44fc-8efe-a0f755462a04
arpitadand5002@gmail.com	0c6384b4-15bd-42b1-a978-317e1d163f8d	{"sub": "0c6384b4-15bd-42b1-a978-317e1d163f8d", "email": "arpitadand5002@gmail.com"}	email	2026-02-12 11:04:39.970126+00	2026-02-12 11:04:39.970126+00	2026-02-12 11:04:39.970126+00	0c6384b4-15bd-42b1-a978-317e1d163f8d
mana88shah@gmail.com	d176663a-6707-4d57-bf50-35e3e7b4a964	{"sub": "d176663a-6707-4d57-bf50-35e3e7b4a964", "email": "mana88shah@gmail.com"}	email	2026-02-12 15:47:50.461262+00	2026-02-12 15:47:50.461262+00	2026-02-12 15:47:50.461262+00	d176663a-6707-4d57-bf50-35e3e7b4a964
prisha.jain@somaiya.edu	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	{"sub": "c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9", "email": "prisha.jain@somaiya.edu"}	email	2026-02-13 09:50:12.716586+00	2026-02-13 09:50:12.716586+00	2026-02-13 09:50:12.716586+00	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9
khushimjain08@gmail.com	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	{"sub": "87f3685f-9952-49ed-8c9f-b7f9a5fbf908", "email": "khushimjain08@gmail.com"}	email	2026-02-13 13:38:15.607808+00	2026-02-13 13:38:15.607808+00	2026-02-13 13:38:15.607808+00	87f3685f-9952-49ed-8c9f-b7f9a5fbf908
vanshivora28@gmail.com	50ac0f99-6e54-4ab2-bdbd-83463583261a	{"sub": "50ac0f99-6e54-4ab2-bdbd-83463583261a", "email": "vanshivora28@gmail.com"}	email	2026-02-13 19:50:58.798661+00	2026-02-13 19:50:58.798661+00	2026-02-13 19:50:58.798661+00	50ac0f99-6e54-4ab2-bdbd-83463583261a
aeshapshah153@gmail.com	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	{"sub": "3d3fb26d-7d06-4d4f-b44d-77831d29ccb5", "email": "aeshapshah153@gmail.com"}	email	2026-02-16 15:24:52.337521+00	2026-02-16 15:24:52.337521+00	2026-02-16 15:24:52.337521+00	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5
nikita.doshi08@gmail.com	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	{"sub": "5a4cbc48-bacb-4728-b9f0-34fe766d9f19", "email": "nikita.doshi08@gmail.com"}	email	2026-02-16 15:48:18.500292+00	2026-02-16 15:48:18.500292+00	2026-02-16 15:48:18.500292+00	5a4cbc48-bacb-4728-b9f0-34fe766d9f19
arihaaparekh01@gmail.com	f24c03cf-533a-4334-badc-b450e0ac0a6b	{"sub": "f24c03cf-533a-4334-badc-b450e0ac0a6b", "email": "arihaaparekh01@gmail.com"}	email	2026-02-16 15:50:48.487191+00	2026-02-16 15:50:48.487191+00	2026-02-16 15:50:48.487191+00	f24c03cf-533a-4334-badc-b450e0ac0a6b
prishaparmani15@gmail.com	46d8f688-8929-4f4e-9c02-c1db1a0669ea	{"sub": "46d8f688-8929-4f4e-9c02-c1db1a0669ea", "email": "prishaparmani15@gmail.com"}	email	2026-02-17 13:14:06.601195+00	2026-02-17 13:14:06.601195+00	2026-02-17 13:14:06.601195+00	46d8f688-8929-4f4e-9c02-c1db1a0669ea
twishagandhi363@gmail.com	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	{"sub": "a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3", "email": "twishagandhi363@gmail.com"}	email	2026-02-18 06:36:07.35355+00	2026-02-18 06:36:07.35355+00	2026-02-18 06:36:07.35355+00	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3
aashimaru2008@gmail.com	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	{"sub": "1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd", "email": "aashimaru2008@gmail.com"}	email	2026-02-18 10:03:56.589594+00	2026-02-18 10:03:56.589594+00	2026-02-18 10:03:56.589594+00	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd
dhruvgandhi0506@gmail.com	643db578-c5a7-422f-ad51-1ba67a0db590	{"sub": "643db578-c5a7-422f-ad51-1ba67a0db590", "email": "dhruvgandhi0506@gmail.com"}	email	2026-02-18 15:58:57.376591+00	2026-02-18 15:58:57.376591+00	2026-02-18 15:58:57.376591+00	643db578-c5a7-422f-ad51-1ba67a0db590
labdhivora1@gmail.com	69fbfc39-3ac0-4972-93fb-317e3e50219b	{"sub": "69fbfc39-3ac0-4972-93fb-317e3e50219b", "email": "labdhivora1@gmail.com"}	email	2026-02-18 16:17:34.355151+00	2026-02-18 16:17:34.355151+00	2026-02-18 16:17:34.355151+00	69fbfc39-3ac0-4972-93fb-317e3e50219b
nidhivora83@gmail.com	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	{"sub": "ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0", "email": "nidhivora83@gmail.com"}	email	2026-02-18 16:18:26.033731+00	2026-02-18 16:18:26.033731+00	2026-02-18 16:18:26.033731+00	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0
virtigandhi28@gmail.com	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	{"sub": "7c5cb4d3-d911-4ec5-a435-e651d30c13ab", "email": "virtigandhi28@gmail.com"}	email	2026-02-18 17:05:42.536061+00	2026-02-18 17:05:42.536061+00	2026-02-18 17:05:42.536061+00	7c5cb4d3-d911-4ec5-a435-e651d30c13ab
91shah.anjali@gmail.com	47485610-8800-4c02-ac12-90808a9ecb94	{"sub": "47485610-8800-4c02-ac12-90808a9ecb94", "email": "91shah.anjali@gmail.com"}	email	2026-02-18 17:14:02.989741+00	2026-02-18 17:14:02.989741+00	2026-02-18 17:14:02.989741+00	47485610-8800-4c02-ac12-90808a9ecb94
snehakaran.sk@gmail.com	57c08aaa-e760-48dd-9772-d8fbea00e722	{"sub": "57c08aaa-e760-48dd-9772-d8fbea00e722", "email": "snehakaran.sk@gmail.com"}	email	2026-02-18 18:17:14.004636+00	2026-02-18 18:17:14.004636+00	2026-02-18 18:17:14.004636+00	57c08aaa-e760-48dd-9772-d8fbea00e722
dhruvigandhi4617@gmail.com	2a495f49-f4e5-4dfa-879d-50e43fcca74e	{"sub": "2a495f49-f4e5-4dfa-879d-50e43fcca74e", "email": "dhruvigandhi4617@gmail.com"}	email	2026-02-18 19:18:43.510185+00	2026-02-18 19:18:43.510185+00	2026-02-18 19:18:43.510185+00	2a495f49-f4e5-4dfa-879d-50e43fcca74e
labdhi1608@gmail.com	34e80f19-ddbe-46bf-9a65-83c81104b974	{"sub": "34e80f19-ddbe-46bf-9a65-83c81104b974", "email": "labdhi1608@gmail.com"}	email	2026-02-19 05:30:40.91807+00	2026-02-19 05:30:40.91807+00	2026-02-19 05:30:40.91807+00	34e80f19-ddbe-46bf-9a65-83c81104b974
darshchandura102@gmail.com	a249b221-853f-4065-b6a4-c9ef30d4032f	{"sub": "a249b221-853f-4065-b6a4-c9ef30d4032f", "email": "darshchandura102@gmail.com"}	email	2026-02-19 07:06:15.05819+00	2026-02-19 07:06:15.05819+00	2026-02-19 07:06:15.05819+00	a249b221-853f-4065-b6a4-c9ef30d4032f
harshiiishah30@gmail.com	486cb7fe-4375-44d1-b124-e2460ab1826a	{"sub": "486cb7fe-4375-44d1-b124-e2460ab1826a", "email": "harshiiishah30@gmail.com"}	email	2026-02-19 14:40:54.724837+00	2026-02-19 14:40:54.724837+00	2026-02-19 14:40:54.724837+00	486cb7fe-4375-44d1-b124-e2460ab1826a
shahtanisha2024@gmail.com	9e34793f-4532-4cf0-8e19-bb36a03057d2	{"sub": "9e34793f-4532-4cf0-8e19-bb36a03057d2", "email": "shahtanisha2024@gmail.com"}	email	2026-02-19 17:10:53.107831+00	2026-02-19 17:10:53.107831+00	2026-02-19 17:10:53.107831+00	9e34793f-4532-4cf0-8e19-bb36a03057d2
veermehta232007@gmail.com	32cf8f2e-3643-4301-8fde-d601c27012fc	{"sub": "32cf8f2e-3643-4301-8fde-d601c27012fc", "email": "veermehta232007@gmail.com"}	email	2026-02-19 17:28:32.700838+00	2026-02-19 17:28:32.700838+00	2026-02-19 17:28:32.700838+00	32cf8f2e-3643-4301-8fde-d601c27012fc
akshatparekh24@gmail.com	4524f75e-4135-4a2c-8bfb-02dc30ae126b	{"sub": "4524f75e-4135-4a2c-8bfb-02dc30ae126b", "email": "akshatparekh24@gmail.com"}	email	2026-02-22 05:23:04.784867+00	2026-02-22 05:23:04.784867+00	2026-02-22 05:23:04.784867+00	4524f75e-4135-4a2c-8bfb-02dc30ae126b
vishwadoshi2004@gmail.com	172dbd3e-8074-423c-a82b-16e77ea8a2b2	{"sub": "172dbd3e-8074-423c-a82b-16e77ea8a2b2", "email": "vishwadoshi2004@gmail.com"}	email	2026-02-22 07:47:01.914964+00	2026-02-22 07:47:01.914964+00	2026-02-22 07:47:01.914964+00	172dbd3e-8074-423c-a82b-16e77ea8a2b2
Shruti.s25@skips.in	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	{"sub": "63a204f2-f076-49f5-b7a7-2ac78e2bbcac", "email": "Shruti.s25@skips.in"}	email	2026-02-22 13:12:06.380204+00	2026-02-22 13:12:06.380204+00	2026-02-22 13:12:06.380204+00	63a204f2-f076-49f5-b7a7-2ac78e2bbcac
meetleveledge@gmail.com	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	{"sub": "cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a", "email": "meetleveledge@gmail.com"}	email	2026-02-24 19:27:20.773506+00	2026-02-24 19:27:20.773506+00	2026-02-24 19:27:20.773506+00	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a
ktshah3620@gmail.com	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	{"sub": "9fb2df7d-14fe-4f1f-94f1-19058a6ad723", "email": "ktshah3620@gmail.com"}	email	2026-02-25 14:47:41.769972+00	2026-02-25 14:47:41.769972+00	2026-02-25 14:47:41.769972+00	9fb2df7d-14fe-4f1f-94f1-19058a6ad723
Karanmehta9902@gmail.com	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	{"sub": "30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa", "email": "Karanmehta9902@gmail.com"}	email	2026-02-27 08:39:14.293189+00	2026-02-27 08:39:14.293189+00	2026-02-27 08:39:14.293189+00	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa
dhrutidoshi916@gnail.com	9421c674-7e88-4d96-9cdf-01f31a35c231	{"sub": "9421c674-7e88-4d96-9cdf-01f31a35c231", "email": "dhrutidoshi916@gnail.com"}	email	2026-02-27 09:25:45.386275+00	2026-02-27 09:25:45.386275+00	2026-02-27 09:25:45.386275+00	9421c674-7e88-4d96-9cdf-01f31a35c231
parshvaramani@gmail.com	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	{"sub": "ad3c8d65-6bf2-413e-9081-4c9e72fc43ea", "email": "parshvaramani@gmail.com"}	email	2026-02-27 15:05:38.276365+00	2026-02-27 15:05:38.276365+00	2026-02-27 15:05:38.276365+00	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea
harshshah80652@gmail.com	2e3999e0-fcca-407c-afa9-0ff5c26fae98	{"sub": "2e3999e0-fcca-407c-afa9-0ff5c26fae98", "email": "harshshah80652@gmail.com"}	email	2026-02-27 15:27:14.479549+00	2026-02-27 15:27:14.479549+00	2026-02-27 15:27:14.479549+00	2e3999e0-fcca-407c-afa9-0ff5c26fae98
Mehta.vidhi1994@gmail.com	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	{"sub": "ba609fa2-c117-4b6e-a4ba-938cb0e4f117", "email": "Mehta.vidhi1994@gmail.com"}	email	2026-02-27 15:50:00.182225+00	2026-02-27 15:50:00.182225+00	2026-02-27 15:50:00.182225+00	ba609fa2-c117-4b6e-a4ba-938cb0e4f117
doshihetvi04@gmail.com	1faa2e14-2817-46d8-8f9e-5e7b70855a98	{"sub": "1faa2e14-2817-46d8-8f9e-5e7b70855a98", "email": "doshihetvi04@gmail.com"}	email	2026-02-28 09:19:17.235641+00	2026-02-28 09:19:17.235641+00	2026-02-28 09:19:17.235641+00	1faa2e14-2817-46d8-8f9e-5e7b70855a98
manan.n.vasa@gmail.com	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	{"sub": "42eb89fe-dd23-4238-a7e0-9e1e5189d92f", "email": "manan.n.vasa@gmail.com"}	email	2026-03-01 07:17:45.443105+00	2026-03-01 07:17:45.443105+00	2026-03-01 07:17:45.443105+00	42eb89fe-dd23-4238-a7e0-9e1e5189d92f
krishapshah7080@gmail.com	08f53469-511c-45e6-914a-c4aacc2c4fed	{"sub": "08f53469-511c-45e6-914a-c4aacc2c4fed", "email": "krishapshah7080@gmail.com"}	email	2026-03-01 12:13:58.729145+00	2026-03-01 12:13:58.729145+00	2026-03-01 12:13:58.729145+00	08f53469-511c-45e6-914a-c4aacc2c4fed
dedhia.siddhi.21@gmail.com	f80e1236-fa27-4605-a0c5-3e92f540bc70	{"sub": "f80e1236-fa27-4605-a0c5-3e92f540bc70", "email": "dedhia.siddhi.21@gmail.com"}	email	2026-03-01 12:14:51.493037+00	2026-03-01 12:14:51.493037+00	2026-03-01 12:14:51.493037+00	f80e1236-fa27-4605-a0c5-3e92f540bc70
rashihgada@gmail.com	a8046eca-1c34-4435-aacf-826e49a40e5b	{"sub": "a8046eca-1c34-4435-aacf-826e49a40e5b", "email": "rashihgada@gmail.com"}	email	2026-03-01 13:16:18.221669+00	2026-03-01 13:16:18.221669+00	2026-03-01 13:16:18.221669+00	a8046eca-1c34-4435-aacf-826e49a40e5b
nirav.shah2062@gmail.com	19d835f0-85cf-4457-8aa4-86dea0dd14dc	{"sub": "19d835f0-85cf-4457-8aa4-86dea0dd14dc", "email": "nirav.shah2062@gmail.com"}	email	2026-03-01 16:36:36.353282+00	2026-03-01 16:36:36.353282+00	2026-03-01 16:36:36.353282+00	19d835f0-85cf-4457-8aa4-86dea0dd14dc
Nishita1508@gmail.com	4bf8abb9-f93c-4e9f-838c-10c3069996f9	{"sub": "4bf8abb9-f93c-4e9f-838c-10c3069996f9", "email": "Nishita1508@gmail.com"}	email	2026-03-03 04:07:06.811951+00	2026-03-03 04:07:06.811951+00	2026-03-03 04:07:06.811951+00	4bf8abb9-f93c-4e9f-838c-10c3069996f9
deepalmehta147@gmail.com	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	{"sub": "1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2", "email": "deepalmehta147@gmail.com"}	email	2026-03-04 08:04:18.477762+00	2026-03-04 08:04:18.477762+00	2026-03-04 08:04:18.477762+00	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2
jhalakgandhi09@gmail.com	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	{"sub": "75d39ffb-b85c-49ad-b08c-978bd0e4ea33", "email": "jhalakgandhi09@gmail.com"}	email	2026-03-04 13:45:22.900002+00	2026-03-04 13:45:22.900002+00	2026-03-04 13:45:22.900002+00	75d39ffb-b85c-49ad-b08c-978bd0e4ea33
karaniyasujal@gmail.com	b7a0ba40-6b70-461d-b806-4583cb44019a	{"sub": "b7a0ba40-6b70-461d-b806-4583cb44019a", "email": "karaniyasujal@gmail.com"}	email	2026-03-05 09:00:34.685777+00	2026-03-05 09:00:34.685777+00	2026-03-05 09:00:34.685777+00	b7a0ba40-6b70-461d-b806-4583cb44019a
rjain96933@gmail.com	eae9a0f2-2bd7-467a-aa1c-b59963276dda	{"sub": "eae9a0f2-2bd7-467a-aa1c-b59963276dda", "email": "rjain96933@gmail.com"}	email	2026-03-06 15:43:11.090125+00	2026-03-06 15:43:11.090125+00	2026-03-06 15:43:11.090125+00	eae9a0f2-2bd7-467a-aa1c-b59963276dda
niyatidoshi90@gmail.com	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	{"sub": "308b47f5-d3e6-479a-a0a5-a8be6591e7b8", "email": "niyatidoshi90@gmail.com"}	email	2026-03-07 11:55:40.789982+00	2026-03-07 11:55:40.789982+00	2026-03-07 11:55:40.789982+00	308b47f5-d3e6-479a-a0a5-a8be6591e7b8
paramhgada30@gmail.com	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	{"sub": "1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5", "email": "paramhgada30@gmail.com"}	email	2026-03-10 17:03:52.818109+00	2026-03-10 17:03:52.818109+00	2026-03-10 17:03:52.818109+00	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5
rj02688@gmail.com	b644c23a-6ad3-4c08-ac90-8dc552e7478c	{"sub": "b644c23a-6ad3-4c08-ac90-8dc552e7478c", "email": "rj02688@gmail.com"}	email	2026-03-12 15:48:01.925513+00	2026-03-12 15:48:01.925513+00	2026-03-12 15:48:01.925513+00	b644c23a-6ad3-4c08-ac90-8dc552e7478c
Vishwashaha24@gmail.com	ae7ecff0-d962-497f-943b-4d772e2483b4	{"sub": "ae7ecff0-d962-497f-943b-4d772e2483b4", "email": "Vishwashaha24@gmail.com"}	email	2026-03-12 16:53:12.319897+00	2026-03-12 16:53:12.319897+00	2026-03-12 16:53:12.319897+00	ae7ecff0-d962-497f-943b-4d772e2483b4
nehashah260478@gmail.com	9f6ca714-7578-43d0-b6c2-290e4e6ef413	{"sub": "9f6ca714-7578-43d0-b6c2-290e4e6ef413", "email": "nehashah260478@gmail.com"}	email	2026-03-14 07:26:33.990557+00	2026-03-14 07:26:33.990557+00	2026-03-14 07:26:33.990557+00	9f6ca714-7578-43d0-b6c2-290e4e6ef413
rpd8703@gmail.com	44ae1d67-01ec-47d6-b057-c42404976678	{"sub": "44ae1d67-01ec-47d6-b057-c42404976678", "email": "rpd8703@gmail.com"}	email	2026-03-14 18:39:31.301272+00	2026-03-14 18:39:31.301272+00	2026-03-14 18:39:31.301272+00	44ae1d67-01ec-47d6-b057-c42404976678
vrushti2810@gmail.com	467d6f6c-4cef-4143-9e20-5827d6690cc1	{"sub": "467d6f6c-4cef-4143-9e20-5827d6690cc1", "email": "vrushti2810@gmail.com"}	email	2026-03-19 11:08:55.222805+00	2026-03-19 11:08:55.222805+00	2026-03-19 11:08:55.222805+00	467d6f6c-4cef-4143-9e20-5827d6690cc1
harshsanghavi0512@gmail.com	117f2d44-cb82-475c-bdf9-841f771649d5	{"sub": "117f2d44-cb82-475c-bdf9-841f771649d5", "email": "harshsanghavi0512@gmail.com"}	email	2026-03-21 12:17:57.462827+00	2026-03-21 12:17:57.462827+00	2026-03-21 12:17:57.462827+00	117f2d44-cb82-475c-bdf9-841f771649d5
virtimshah29@gmail.com	4d17c59e-7231-4a0f-bd3f-8294f90e212e	{"sub": "4d17c59e-7231-4a0f-bd3f-8294f90e212e", "email": "virtimshah29@gmail.com"}	email	2026-03-25 03:54:12.504796+00	2026-03-25 03:54:12.504796+00	2026-03-25 03:54:12.504796+00	4d17c59e-7231-4a0f-bd3f-8294f90e212e
priyalshah0500@gmail.com	4d69310b-0603-47ba-9171-644236ecde06	{"sub": "4d69310b-0603-47ba-9171-644236ecde06", "email": "priyalshah0500@gmail.com"}	email	2026-03-26 04:39:42.102004+00	2026-03-26 04:39:42.102004+00	2026-03-26 04:39:42.102004+00	4d69310b-0603-47ba-9171-644236ecde06
meenakshiborana31@gmail.com	ccfcbbd3-ed14-440e-9a04-1e348f45996d	{"sub": "ccfcbbd3-ed14-440e-9a04-1e348f45996d", "email": "meenakshiborana31@gmail.com"}	email	2026-03-26 13:27:43.573258+00	2026-03-26 13:27:43.573258+00	2026-03-26 13:27:43.573258+00	ccfcbbd3-ed14-440e-9a04-1e348f45996d
tejashree.kotak@gmail.com	c97ed6dc-f8d5-4311-a1f8-58a72267a160	{"sub": "c97ed6dc-f8d5-4311-a1f8-58a72267a160", "email": "tejashree.kotak@gmail.com"}	email	2026-03-29 04:27:57.051228+00	2026-03-29 04:27:57.051228+00	2026-03-29 04:27:57.051228+00	c97ed6dc-f8d5-4311-a1f8-58a72267a160
kinjalgada1119@gmail.com	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	{"sub": "2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e", "email": "kinjalgada1119@gmail.com"}	email	2026-03-29 11:54:04.581441+00	2026-03-29 11:54:04.581441+00	2026-03-29 11:54:04.581441+00	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e
nishapunu@gmail.com	3656a4f7-ddaa-4b85-8c89-cde880be3227	{"sub": "3656a4f7-ddaa-4b85-8c89-cde880be3227", "email": "nishapunu@gmail.com"}	email	2026-03-30 13:26:39.967315+00	2026-03-30 13:26:39.967315+00	2026-03-30 13:26:39.967315+00	3656a4f7-ddaa-4b85-8c89-cde880be3227
khyatis2002@gmail.com	abfeb4ea-ff91-472a-8f0e-d458d122e68a	{"sub": "abfeb4ea-ff91-472a-8f0e-d458d122e68a", "email": "khyatis2002@gmail.com"}	email	2026-03-30 14:36:02.512616+00	2026-03-30 14:36:02.512616+00	2026-03-30 14:36:02.512616+00	abfeb4ea-ff91-472a-8f0e-d458d122e68a
nemil199799@gmail.com	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	{"sub": "3b0b4acf-0dd3-4c2d-a146-3734bd3026c2", "email": "nemil199799@gmail.com"}	email	2026-04-08 18:41:38.1296+00	2026-04-08 18:41:38.1296+00	2026-04-08 18:41:38.1296+00	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2
dr.hardikshah05@gmail.com	9b5fd841-5c68-4e82-8d91-95d01943d1aa	{"sub": "9b5fd841-5c68-4e82-8d91-95d01943d1aa", "email": "dr.hardikshah05@gmail.com"}	email	2026-04-10 15:06:31.374527+00	2026-04-10 15:06:31.374527+00	2026-04-10 15:06:31.374527+00	9b5fd841-5c68-4e82-8d91-95d01943d1aa
nitidoshi29@gmail.com	ec777267-0100-4e47-adcd-afa4e8deb872	{"sub": "ec777267-0100-4e47-adcd-afa4e8deb872", "email": "nitidoshi29@gmail.com"}	email	2026-04-18 07:27:24.122416+00	2026-04-18 07:27:24.122416+00	2026-04-18 07:27:24.122416+00	ec777267-0100-4e47-adcd-afa4e8deb872
shahbhavya2209@gmail.com	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	{"sub": "3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec", "email": "shahbhavya2209@gmail.com"}	email	2026-04-19 15:22:28.213841+00	2026-04-19 15:22:28.213841+00	2026-04-19 15:22:28.213841+00	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec
dandsmita1983@gmail.com	e63d4eb5-df96-472d-9b92-dca55f181f78	{"sub": "e63d4eb5-df96-472d-9b92-dca55f181f78", "email": "dandsmita1983@gmail.com"}	email	2026-04-23 12:59:55.630204+00	2026-04-23 12:59:55.630204+00	2026-04-23 12:59:55.630204+00	e63d4eb5-df96-472d-9b92-dca55f181f78
sakshidoshi981@gmail.com	4f596e49-9138-494f-9c00-d4106a457861	{"sub": "4f596e49-9138-494f-9c00-d4106a457861", "email": "sakshidoshi981@gmail.com"}	email	2026-04-23 16:23:13.846596+00	2026-04-23 16:23:13.846596+00	2026-04-23 16:23:13.846596+00	4f596e49-9138-494f-9c00-d4106a457861
omkarkotak753@gmail.com	a968d860-32be-47e9-8d8e-ef6752a3e879	{"sub": "a968d860-32be-47e9-8d8e-ef6752a3e879", "email": "omkarkotak753@gmail.com"}	email	2026-04-23 16:24:18.342018+00	2026-04-23 16:24:18.342018+00	2026-04-23 16:24:18.342018+00	a968d860-32be-47e9-8d8e-ef6752a3e879
labdhimehta04@gmail.com	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	{"sub": "dfe13521-6ab4-4474-b1cc-32ac91e74ea5", "email": "labdhimehta04@gmail.com"}	email	2026-04-24 10:58:02.45842+00	2026-04-24 10:58:02.45842+00	2026-04-24 10:58:02.45842+00	dfe13521-6ab4-4474-b1cc-32ac91e74ea5
diptigandhi304@gmail.com	55dbfa08-450b-42c5-9372-6b24963f36b5	{"sub": "55dbfa08-450b-42c5-9372-6b24963f36b5", "email": "diptigandhi304@gmail.com"}	email	2026-04-26 05:26:38.131793+00	2026-04-26 05:26:38.131793+00	2026-04-26 05:26:38.131793+00	55dbfa08-450b-42c5-9372-6b24963f36b5
aayushishah21073@gmail.com	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	{"sub": "9d559a49-4bd5-4b49-91bc-984ee4bb2b89", "email": "aayushishah21073@gmail.com"}	email	2026-04-26 19:16:28.110525+00	2026-04-26 19:16:28.110525+00	2026-04-26 19:16:28.110525+00	9d559a49-4bd5-4b49-91bc-984ee4bb2b89
arpitashah302@gmail.com	85fd79c7-df83-40a2-90ff-15a51d3d79fd	{"sub": "85fd79c7-df83-40a2-90ff-15a51d3d79fd", "email": "arpitashah302@gmail.com"}	email	2026-04-28 03:45:31.721247+00	2026-04-28 03:45:31.721247+00	2026-04-28 03:45:31.721247+00	85fd79c7-df83-40a2-90ff-15a51d3d79fd
dedhiapuja18@gmail.com	f0d6a329-ff03-4ba6-8006-5742402e06bb	{"sub": "f0d6a329-ff03-4ba6-8006-5742402e06bb", "email": "dedhiapuja18@gmail.com"}	email	2026-05-04 09:56:08.01923+00	2026-05-04 09:56:08.01923+00	2026-05-04 09:56:08.01923+00	f0d6a329-ff03-4ba6-8006-5742402e06bb
sidkitisitti@gmail.com	4b42c12c-6dd7-49fc-8268-24564f5b9204	{"sub": "4b42c12c-6dd7-49fc-8268-24564f5b9204", "email": "sidkitisitti@gmail.com"}	email	2026-05-10 16:05:42.786306+00	2026-05-10 16:05:42.786306+00	2026-05-10 16:05:42.786306+00	4b42c12c-6dd7-49fc-8268-24564f5b9204
Sujatasinghi.com@gmail.com	d868f2b7-f054-4c90-84aa-be0cd7490fa5	{"sub": "d868f2b7-f054-4c90-84aa-be0cd7490fa5", "email": "Sujatasinghi.com@gmail.com"}	email	2026-05-12 11:00:42.408937+00	2026-05-12 11:00:42.408937+00	2026-05-12 11:00:42.408937+00	d868f2b7-f054-4c90-84aa-be0cd7490fa5
shahshruti3113@gmail.com	11fc3990-68cc-4cdb-ad83-fca0ec15799f	{"sub": "11fc3990-68cc-4cdb-ad83-fca0ec15799f", "email": "shahshruti3113@gmail.com"}	email	2026-05-15 09:57:43.159552+00	2026-05-15 09:57:43.159552+00	2026-05-15 09:57:43.159552+00	11fc3990-68cc-4cdb-ad83-fca0ec15799f
kashishmanojjain@gmail.com	539a319d-7e31-4db7-8dec-7d04d92629d3	{"sub": "539a319d-7e31-4db7-8dec-7d04d92629d3", "email": "kashishmanojjain@gmail.com"}	email	2026-05-17 06:16:22.605197+00	2026-05-17 06:16:22.605197+00	2026-05-17 06:16:22.605197+00	539a319d-7e31-4db7-8dec-7d04d92629d3
doshinirag@gmail.com	914b0f69-d854-494a-88d2-d35987b82c79	{"sub": "914b0f69-d854-494a-88d2-d35987b82c79", "email": "doshinirag@gmail.com"}	email	2026-05-17 07:32:00.528542+00	2026-05-17 07:32:00.528542+00	2026-05-17 07:32:00.528542+00	914b0f69-d854-494a-88d2-d35987b82c79
shahnavyam2010@gmail.com	2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e	{"sub": "2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e", "email": "shahnavyam2010@gmail.com"}	email	2026-05-18 06:01:08.698131+00	2026-05-18 06:01:08.698131+00	2026-05-18 06:01:08.698131+00	2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e
vikas_dairyproducts@yahoo.co.in	ecf01a58-0258-4666-b777-aabc6b516035	{"sub": "ecf01a58-0258-4666-b777-aabc6b516035", "email": "vikas_dairyproducts@yahoo.co.in"}	email	2026-05-28 05:11:30.189762+00	2026-05-28 05:11:30.189762+00	2026-05-28 05:11:30.189762+00	ecf01a58-0258-4666-b777-aabc6b516035
kajalsanghavi099@gmail.com	59cfdf9a-bef2-405a-9a65-3247132d7654	{"sub": "59cfdf9a-bef2-405a-9a65-3247132d7654", "email": "kajalsanghavi099@gmail.com"}	email	2026-05-31 07:14:13.34901+00	2026-05-31 07:14:13.34901+00	2026-05-31 07:14:13.34901+00	59cfdf9a-bef2-405a-9a65-3247132d7654
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
3e0f54e9-ec9b-4192-9dad-3324eb929c30	2026-05-18 15:50:48.551626+00	2026-05-18 15:50:48.551626+00	password	518e7393-516a-4efb-b852-1cdf1a660043
b6b06714-6448-4e61-a153-29a67e433de0	2026-05-18 16:59:57.727569+00	2026-05-18 16:59:57.727569+00	password	4090866a-8b48-45ea-a40e-781d074f6d31
8f510f02-0d37-4f73-b7fd-44533a4362ad	2026-05-19 17:16:11.401439+00	2026-05-19 17:16:11.401439+00	password	43265577-0ad4-4e45-ad57-5e6527e356da
8466b0ff-2c28-4781-a2b7-57ea3ec3a588	2026-05-20 06:50:21.066323+00	2026-05-20 06:50:21.066323+00	password	4e45c56e-700a-471b-aeea-3a3449167f61
129c91d2-ed4d-453e-8be2-1285d019a179	2026-05-20 08:30:26.456959+00	2026-05-20 08:30:26.456959+00	password	7a7318e9-0824-4730-a087-8e5ec8f5dad9
de0fa9f7-ce65-4532-87a4-c5b5e2f992cd	2026-05-20 18:36:59.039456+00	2026-05-20 18:36:59.039456+00	password	304abcbe-c25a-4316-8ffd-0d180772f9fe
74e077eb-da15-45a4-8647-ab75740438ae	2026-05-21 09:39:47.776746+00	2026-05-21 09:39:47.776746+00	password	2a87cef1-d0cc-4311-a290-d9a3e9c4d6c6
caaddb52-44f5-4e36-8cc9-1b0901f86df6	2026-05-22 09:21:54.036862+00	2026-05-22 09:21:54.036862+00	password	29abf40d-5ace-4de2-8b11-e5a3cf04e16c
264e739c-1364-49b7-bdfb-79aff93a5369	2026-05-22 17:36:14.808725+00	2026-05-22 17:36:14.808725+00	password	9ebeeb55-fef2-46e7-80d5-6e41b59fa7ce
76bfa5b1-b775-4c2b-8d19-7ec47e973ec8	2026-05-23 16:03:11.159967+00	2026-05-23 16:03:11.159967+00	password	73ef7991-2091-4ab2-af6e-062b0cf1a777
3fc21922-6ae1-4a49-93a4-23e55e4447a9	2026-05-24 16:11:46.302608+00	2026-05-24 16:11:46.302608+00	password	0902eb82-165a-4023-9fef-48cb563a8aa5
fb5af6ba-ac8e-46c1-8478-bf70957f04e5	2026-05-24 19:37:10.882455+00	2026-05-24 19:37:10.882455+00	password	016c41bb-0d38-4d8e-bc84-ca37ec9d6925
0541f967-f7eb-4808-928e-9ed3eb77e974	2026-05-25 06:20:47.700488+00	2026-05-25 06:20:47.700488+00	password	f5cd8722-fb5d-4dbc-9790-00339bf2dfcb
62eb771f-e8bf-4cfb-a33b-6ae63f315f3c	2026-05-25 12:39:37.117011+00	2026-05-25 12:39:37.117011+00	password	e085443b-8873-405a-b1f1-4e20d8bc981c
6a5c7990-7f85-425f-ae4a-ce055920694d	2026-05-25 12:52:47.230649+00	2026-05-25 12:52:47.230649+00	password	a2d662a8-f8ef-43dd-ac2d-7cd6388eb75a
df5a4570-e500-4bcc-81d0-55e255885321	2026-05-27 07:04:23.191804+00	2026-05-27 07:04:23.191804+00	password	787f8934-e358-4c37-a232-d79ed11afd10
d0bd5b0d-86e4-469c-97a1-7b6f16254693	2026-05-27 15:34:26.851404+00	2026-05-27 15:34:26.851404+00	password	bbc54745-1e0d-4820-bd48-6ca8ffaaa009
b597b80d-fe1b-4d5e-b17d-fa08eeb9c694	2026-05-29 14:10:57.823712+00	2026-05-29 14:10:57.823712+00	password	9c95db11-fbca-4259-95de-72aff75e3c64
f9751b4f-a902-4bc5-a09c-7ec4361ab3e8	2026-05-30 04:44:43.601198+00	2026-05-30 04:44:43.601198+00	password	67958ade-8304-40c5-8e36-9677113cd0b4
4aecb9ef-5049-47d5-868c-0dca08ec469d	2026-05-30 12:32:13.990446+00	2026-05-30 12:32:13.990446+00	password	bec87f49-64c1-4c71-bd89-7b11d91aede2
bbd44a26-9db9-4aca-820f-9f9ca19c7ba3	2026-05-30 12:36:13.418306+00	2026-05-30 12:36:13.418306+00	password	219dff7d-0bf5-4654-8acc-730a2f475b91
1910089f-0735-43a9-85cd-9f97193364c0	2026-05-31 13:44:00.250499+00	2026-05-31 13:44:00.250499+00	password	4cd798d3-7199-4ce7-b35b-a44979d0c4e6
4f297633-acac-4234-b03f-da9263eee0df	2026-05-31 13:51:15.647978+00	2026-05-31 13:51:15.647978+00	password	e842b69a-f51e-4a29-9c57-4727e4bc86d5
660180dd-e991-4e05-bafb-8b7faf691973	2026-05-31 17:32:12.710328+00	2026-05-31 17:32:12.710328+00	password	7a2b205c-66b3-428a-8bad-fd27a538869b
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	427	xdt7rduyarad	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 15:50:48.53981+00	2026-05-18 17:24:08.934833+00	\N	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	429	xmwoop6vxmne	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 17:24:08.951634+00	2026-05-18 18:25:22.445128+00	xdt7rduyarad	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	430	axypmchvjq2f	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 18:25:22.467027+00	2026-05-18 19:25:26.578452+00	xmwoop6vxmne	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	431	xhfpv5bjc3io	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 19:25:26.593339+00	2026-05-18 21:21:53.066285+00	axypmchvjq2f	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	428	r24msr5t66ua	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 16:59:57.704625+00	2026-05-19 06:14:53.020001+00	\N	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	433	aohkb3qhci7c	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-19 06:14:53.038907+00	2026-05-19 09:36:14.215666+00	r24msr5t66ua	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	435	tdl6npofw5ib	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-19 17:16:11.374525+00	2026-05-20 06:50:14.449257+00	\N	8f510f02-0d37-4f73-b7fd-44533a4362ad
00000000-0000-0000-0000-000000000000	436	aj6xobyy2tq7	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-20 06:50:14.476242+00	2026-05-20 06:50:14.476242+00	tdl6npofw5ib	8f510f02-0d37-4f73-b7fd-44533a4362ad
00000000-0000-0000-0000-000000000000	437	nlsh2kcxe6p2	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 06:50:21.063678+00	2026-05-20 08:30:20.981108+00	\N	8466b0ff-2c28-4781-a2b7-57ea3ec3a588
00000000-0000-0000-0000-000000000000	438	h4wbhneeqa4u	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-20 08:30:20.997494+00	2026-05-20 08:30:20.997494+00	nlsh2kcxe6p2	8466b0ff-2c28-4781-a2b7-57ea3ec3a588
00000000-0000-0000-0000-000000000000	432	fn7l3tnuqfj7	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-18 21:21:53.084679+00	2026-05-20 09:11:05.480646+00	xhfpv5bjc3io	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	440	yuy5eiflqipl	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 09:11:05.494546+00	2026-05-20 12:41:03.535202+00	fn7l3tnuqfj7	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	441	wgwlf3gourns	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 12:41:03.561865+00	2026-05-20 15:03:12.033354+00	yuy5eiflqipl	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	442	gzubon5kfzra	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 15:03:12.05156+00	2026-05-20 18:34:44.991747+00	wgwlf3gourns	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	443	zgq5uxkjeiza	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-20 18:34:45.010463+00	2026-05-20 18:34:45.010463+00	gzubon5kfzra	3e0f54e9-ec9b-4192-9dad-3324eb929c30
00000000-0000-0000-0000-000000000000	434	hdcoebrdmwjn	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-19 09:36:14.239893+00	2026-05-20 18:38:35.773041+00	aohkb3qhci7c	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	439	3vg3lgaiaj3q	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 08:30:26.45403+00	2026-05-21 04:42:16.87854+00	\N	129c91d2-ed4d-453e-8be2-1285d019a179
00000000-0000-0000-0000-000000000000	445	2zwarhljm7ni	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 18:38:35.778358+00	2026-05-21 06:21:36.319757+00	hdcoebrdmwjn	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	448	mqiy3xd5pti5	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-21 09:39:47.751059+00	2026-05-21 09:39:47.751059+00	\N	74e077eb-da15-45a4-8647-ab75740438ae
00000000-0000-0000-0000-000000000000	447	cjym4hiksrp7	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-21 06:21:36.347115+00	2026-05-22 08:23:03.17906+00	2zwarhljm7ni	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	450	c5u7iwnbdrzb	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-22 09:21:54.012257+00	2026-05-22 09:21:54.012257+00	\N	caaddb52-44f5-4e36-8cc9-1b0901f86df6
00000000-0000-0000-0000-000000000000	449	h2wehmv2oicr	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-22 08:23:03.207132+00	2026-05-22 16:52:00.403904+00	cjym4hiksrp7	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	444	x4kz2xupnga7	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-20 18:36:59.028961+00	2026-05-22 17:35:57.409504+00	\N	de0fa9f7-ce65-4532-87a4-c5b5e2f992cd
00000000-0000-0000-0000-000000000000	452	4ddaslacuvxm	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-22 17:35:57.423763+00	2026-05-22 17:35:57.423763+00	x4kz2xupnga7	de0fa9f7-ce65-4532-87a4-c5b5e2f992cd
00000000-0000-0000-0000-000000000000	451	dymh7uat4rjm	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-22 16:52:00.424611+00	2026-05-23 15:27:52.83769+00	h2wehmv2oicr	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	446	tghvxbneuqgo	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-21 04:42:16.89827+00	2026-05-23 16:02:29.292775+00	3vg3lgaiaj3q	129c91d2-ed4d-453e-8be2-1285d019a179
00000000-0000-0000-0000-000000000000	455	af3f3nptzmsb	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-23 16:02:29.312965+00	2026-05-23 16:02:29.312965+00	tghvxbneuqgo	129c91d2-ed4d-453e-8be2-1285d019a179
00000000-0000-0000-0000-000000000000	456	opwy4utsj4nl	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-23 16:03:11.134549+00	2026-05-24 16:11:39.36394+00	\N	76bfa5b1-b775-4c2b-8d19-7ec47e973ec8
00000000-0000-0000-0000-000000000000	457	znnxqsxzsa3p	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-24 16:11:39.387256+00	2026-05-24 16:11:39.387256+00	opwy4utsj4nl	76bfa5b1-b775-4c2b-8d19-7ec47e973ec8
00000000-0000-0000-0000-000000000000	453	jwhz6omtmobf	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-22 17:36:14.807202+00	2026-05-24 19:36:40.547653+00	\N	264e739c-1364-49b7-bdfb-79aff93a5369
00000000-0000-0000-0000-000000000000	459	56f3jpwvz3rt	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-24 19:36:40.573127+00	2026-05-24 19:36:40.573127+00	jwhz6omtmobf	264e739c-1364-49b7-bdfb-79aff93a5369
00000000-0000-0000-0000-000000000000	454	qmntwlv67z25	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-23 15:27:52.863535+00	2026-05-25 07:21:36.670074+00	dymh7uat4rjm	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	461	icsbdfvnio7j	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-25 06:20:47.677066+00	2026-05-25 12:39:24.24522+00	\N	0541f967-f7eb-4808-928e-9ed3eb77e974
00000000-0000-0000-0000-000000000000	463	4eedvvptz7ff	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-25 12:39:24.261588+00	2026-05-25 12:39:24.261588+00	icsbdfvnio7j	0541f967-f7eb-4808-928e-9ed3eb77e974
00000000-0000-0000-0000-000000000000	464	yti4d2vtsqme	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-25 12:39:37.114953+00	2026-05-25 12:39:37.114953+00	\N	62eb771f-e8bf-4cfb-a33b-6ae63f315f3c
00000000-0000-0000-0000-000000000000	462	taboi4hpla6x	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-25 07:21:36.701372+00	2026-05-25 12:52:16.745434+00	qmntwlv67z25	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	465	osyvskah2yus	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-25 12:52:16.756907+00	2026-05-25 12:52:16.756907+00	taboi4hpla6x	b6b06714-6448-4e61-a153-29a67e433de0
00000000-0000-0000-0000-000000000000	466	u6j64o2hd5wt	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-25 12:52:47.227468+00	2026-05-25 14:14:50.522262+00	\N	6a5c7990-7f85-425f-ae4a-ce055920694d
00000000-0000-0000-0000-000000000000	467	sye7ud72jmq6	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-25 14:14:50.550703+00	2026-05-25 18:47:59.309438+00	u6j64o2hd5wt	6a5c7990-7f85-425f-ae4a-ce055920694d
00000000-0000-0000-0000-000000000000	468	cpdanfkvsdua	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-25 18:47:59.338915+00	2026-05-25 18:47:59.338915+00	sye7ud72jmq6	6a5c7990-7f85-425f-ae4a-ce055920694d
00000000-0000-0000-0000-000000000000	458	7ex6xq3nzdry	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-24 16:11:46.299464+00	2026-05-26 16:52:11.793197+00	\N	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	460	nyyxi4twspqn	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-24 19:37:10.881117+00	2026-05-27 07:04:11.254746+00	\N	fb5af6ba-ac8e-46c1-8478-bf70957f04e5
00000000-0000-0000-0000-000000000000	470	6z4cwpiagddq	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-27 07:04:11.274179+00	2026-05-27 07:04:11.274179+00	nyyxi4twspqn	fb5af6ba-ac8e-46c1-8478-bf70957f04e5
00000000-0000-0000-0000-000000000000	471	roqlfrbagnex	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-27 07:04:23.190339+00	2026-05-27 08:42:43.752431+00	\N	df5a4570-e500-4bcc-81d0-55e255885321
00000000-0000-0000-0000-000000000000	472	govqbi2o22e7	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-27 08:42:43.776373+00	2026-05-27 08:42:43.776373+00	roqlfrbagnex	df5a4570-e500-4bcc-81d0-55e255885321
00000000-0000-0000-0000-000000000000	469	nq3ark66dcy5	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-26 16:52:11.812058+00	2026-05-27 16:04:52.078531+00	7ex6xq3nzdry	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	474	y6y6hf7j4oj4	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-27 16:04:52.093428+00	2026-05-28 16:37:09.176333+00	nq3ark66dcy5	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	475	43apzlo3jghz	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-28 16:37:09.205043+00	2026-05-29 02:37:25.348591+00	y6y6hf7j4oj4	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	476	hwwgrlbwuxmq	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-29 02:37:25.365854+00	2026-05-29 14:02:28.845487+00	43apzlo3jghz	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	473	p5lgedqsqp3z	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-27 15:34:26.808592+00	2026-05-31 13:43:47.154103+00	\N	d0bd5b0d-86e4-469c-97a1-7b6f16254693
00000000-0000-0000-0000-000000000000	477	azzyuzqtkoik	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-29 14:02:28.872896+00	2026-05-29 14:02:28.872896+00	hwwgrlbwuxmq	3fc21922-6ae1-4a49-93a4-23e55e4447a9
00000000-0000-0000-0000-000000000000	478	of6f4yxxrs3f	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-29 14:10:57.793057+00	2026-05-30 12:32:00.245609+00	\N	b597b80d-fe1b-4d5e-b17d-fa08eeb9c694
00000000-0000-0000-0000-000000000000	480	ti6zfefbkhok	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-30 12:32:00.2648+00	2026-05-30 12:32:00.2648+00	of6f4yxxrs3f	b597b80d-fe1b-4d5e-b17d-fa08eeb9c694
00000000-0000-0000-0000-000000000000	481	roac22ftrjh3	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-30 12:32:13.989078+00	2026-05-30 17:10:22.525071+00	\N	4aecb9ef-5049-47d5-868c-0dca08ec469d
00000000-0000-0000-0000-000000000000	483	jnyphromnbu2	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-30 17:10:22.547157+00	2026-05-30 17:10:22.547157+00	roac22ftrjh3	4aecb9ef-5049-47d5-868c-0dca08ec469d
00000000-0000-0000-0000-000000000000	479	upafb5pfqtsg	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-30 04:44:43.561974+00	2026-05-31 09:47:57.664485+00	\N	f9751b4f-a902-4bc5-a09c-7ec4361ab3e8
00000000-0000-0000-0000-000000000000	485	3leliyw57cvq	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 13:43:47.170748+00	2026-05-31 13:43:47.170748+00	p5lgedqsqp3z	d0bd5b0d-86e4-469c-97a1-7b6f16254693
00000000-0000-0000-0000-000000000000	482	sjv7j7korydi	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-30 12:36:13.409611+00	2026-05-31 13:51:00.75618+00	\N	bbd44a26-9db9-4aca-820f-9f9ca19c7ba3
00000000-0000-0000-0000-000000000000	487	h2yxbolkbo4w	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 13:51:00.764502+00	2026-05-31 13:51:00.764502+00	sjv7j7korydi	bbd44a26-9db9-4aca-820f-9f9ca19c7ba3
00000000-0000-0000-0000-000000000000	488	xeeselitqgcv	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 13:51:15.622346+00	2026-05-31 13:51:15.622346+00	\N	4f297633-acac-4234-b03f-da9263eee0df
00000000-0000-0000-0000-000000000000	486	slwck7p532a2	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-31 13:44:00.248919+00	2026-05-31 15:20:03.896576+00	\N	1910089f-0735-43a9-85cd-9f97193364c0
00000000-0000-0000-0000-000000000000	489	3q4nalzvbqs3	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 15:20:03.920836+00	2026-05-31 15:20:03.920836+00	slwck7p532a2	1910089f-0735-43a9-85cd-9f97193364c0
00000000-0000-0000-0000-000000000000	484	h7225opdv5wn	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-05-31 09:47:57.682041+00	2026-05-31 16:59:52.925779+00	upafb5pfqtsg	f9751b4f-a902-4bc5-a09c-7ec4361ab3e8
00000000-0000-0000-0000-000000000000	490	jcaqbrxgskxa	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 16:59:52.934156+00	2026-05-31 16:59:52.934156+00	h7225opdv5wn	f9751b4f-a902-4bc5-a09c-7ec4361ab3e8
00000000-0000-0000-0000-000000000000	491	gistqmjqzxoh	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-05-31 17:32:12.690023+00	2026-05-31 17:32:12.690023+00	\N	660180dd-e991-4e05-bafb-8b7faf691973
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
b6b06714-6448-4e61-a153-29a67e433de0	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-18 16:59:57.675871+00	2026-05-25 12:52:16.777261+00	\N	aal1	\N	2026-05-25 12:52:16.777158	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	103.249.251.159	\N	\N	\N	\N	\N
8f510f02-0d37-4f73-b7fd-44533a4362ad	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-19 17:16:11.346611+00	2026-05-20 06:50:14.516421+00	\N	aal1	\N	2026-05-20 06:50:14.516307	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.19	\N	\N	\N	\N	\N
8466b0ff-2c28-4781-a2b7-57ea3ec3a588	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-20 06:50:21.056823+00	2026-05-20 08:30:21.023126+00	\N	aal1	\N	2026-05-20 08:30:21.022997	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.19	\N	\N	\N	\N	\N
6a5c7990-7f85-425f-ae4a-ce055920694d	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-25 12:52:47.219321+00	2026-05-25 18:47:59.372346+00	\N	aal1	\N	2026-05-25 18:47:59.372223	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	103.249.251.159	\N	\N	\N	\N	\N
d0bd5b0d-86e4-469c-97a1-7b6f16254693	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-27 15:34:26.763719+00	2026-05-31 13:43:47.197182+00	\N	aal1	\N	2026-05-31 13:43:47.197049	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.139	\N	\N	\N	\N	\N
fb5af6ba-ac8e-46c1-8478-bf70957f04e5	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-24 19:37:10.87218+00	2026-05-27 07:04:11.303065+00	\N	aal1	\N	2026-05-27 07:04:11.302949	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.178	\N	\N	\N	\N	\N
3e0f54e9-ec9b-4192-9dad-3324eb929c30	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-18 15:50:48.52721+00	2026-05-20 18:34:45.039248+00	\N	aal1	\N	2026-05-20 18:34:45.038534	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.143	\N	\N	\N	\N	\N
df5a4570-e500-4bcc-81d0-55e255885321	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-27 07:04:23.175871+00	2026-05-27 08:42:43.802415+00	\N	aal1	\N	2026-05-27 08:42:43.802288	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.178	\N	\N	\N	\N	\N
74e077eb-da15-45a4-8647-ab75740438ae	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-21 09:39:47.720065+00	2026-05-21 09:39:47.720065+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	152.58.47.22	\N	\N	\N	\N	\N
bbd44a26-9db9-4aca-820f-9f9ca19c7ba3	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-30 12:36:13.386968+00	2026-05-31 13:51:00.78067+00	\N	aal1	\N	2026-05-31 13:51:00.780559	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.15	\N	\N	\N	\N	\N
caaddb52-44f5-4e36-8cc9-1b0901f86df6	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-22 09:21:53.977102+00	2026-05-22 09:21:53.977102+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	208.127.165.130	\N	\N	\N	\N	\N
4f297633-acac-4234-b03f-da9263eee0df	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-31 13:51:15.574576+00	2026-05-31 13:51:15.574576+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.15	\N	\N	\N	\N	\N
de0fa9f7-ce65-4532-87a4-c5b5e2f992cd	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-20 18:36:59.014554+00	2026-05-22 17:35:57.445402+00	\N	aal1	\N	2026-05-22 17:35:57.445299	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.143	\N	\N	\N	\N	\N
3fc21922-6ae1-4a49-93a4-23e55e4447a9	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-24 16:11:46.293205+00	2026-05-29 14:02:28.914056+00	\N	aal1	\N	2026-05-29 14:02:28.913934	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.19	\N	\N	\N	\N	\N
129c91d2-ed4d-453e-8be2-1285d019a179	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-20 08:30:26.448479+00	2026-05-23 16:02:29.33584+00	\N	aal1	\N	2026-05-23 16:02:29.335723	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.15	\N	\N	\N	\N	\N
76bfa5b1-b775-4c2b-8d19-7ec47e973ec8	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-23 16:03:11.089821+00	2026-05-24 16:11:39.422188+00	\N	aal1	\N	2026-05-24 16:11:39.422055	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.12	\N	\N	\N	\N	\N
264e739c-1364-49b7-bdfb-79aff93a5369	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-22 17:36:14.793192+00	2026-05-24 19:36:40.60393+00	\N	aal1	\N	2026-05-24 19:36:40.603808	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	103.249.251.165	\N	\N	\N	\N	\N
1910089f-0735-43a9-85cd-9f97193364c0	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-31 13:44:00.236271+00	2026-05-31 15:20:03.954228+00	\N	aal1	\N	2026-05-31 15:20:03.954117	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	152.58.44.6	\N	\N	\N	\N	\N
0541f967-f7eb-4808-928e-9ed3eb77e974	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-25 06:20:47.640288+00	2026-05-25 12:39:24.294037+00	\N	aal1	\N	2026-05-25 12:39:24.293926	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	152.58.47.168	\N	\N	\N	\N	\N
62eb771f-e8bf-4cfb-a33b-6ae63f315f3c	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-25 12:39:37.101623+00	2026-05-25 12:39:37.101623+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	152.58.47.168	\N	\N	\N	\N	\N
b597b80d-fe1b-4d5e-b17d-fa08eeb9c694	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-29 14:10:57.760571+00	2026-05-30 12:32:00.298317+00	\N	aal1	\N	2026-05-30 12:32:00.297585	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.28	\N	\N	\N	\N	\N
f9751b4f-a902-4bc5-a09c-7ec4361ab3e8	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-30 04:44:43.52587+00	2026-05-31 16:59:52.956367+00	\N	aal1	\N	2026-05-31 16:59:52.956259	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36	103.249.251.175	\N	\N	\N	\N	\N
4aecb9ef-5049-47d5-868c-0dca08ec469d	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-30 12:32:13.981893+00	2026-05-30 17:10:27.109625+00	\N	aal1	\N	2026-05-30 17:10:27.109532	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	183.87.167.28	\N	\N	\N	\N	\N
660180dd-e991-4e05-bafb-8b7faf691973	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-31 17:32:12.654402+00	2026-05-31 17:32:12.654402+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36	42.106.216.248	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	authenticated	authenticated	mehtameet115@gmail.com	$2a$06$QVESi9vOlOWMKqKlaIPnIeIb7YYoC4T4dsbE.ZJC6NLEyB4qeELMW	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-008", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Meet"}	f	2026-02-01 18:08:30.862076+00	2026-02-05 06:44:09.82679+00	9172387009	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0e833c46-ec3f-4681-8dbc-2bec029d8db1	authenticated	authenticated	smitmehta50@gmail.com	$2a$06$6g3DcNvf8R0si234MSjXwujGwLHKZytLCBgWLwH2Gq7joNtpl2oJm	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-004", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Smit"}	f	2026-02-01 15:33:50.735119+00	2026-02-05 06:41:41.928014+00	9022566694	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f51b0111-f04d-453a-b6c0-60d9832fba6b	authenticated	authenticated	pritiaayu1@gmail.com	$2a$06$MQ1/wlvTHU9ok7JqDcTGu.ltDD5dsDhZkGt28/.d2agVfQH77PnG.	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-002", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Aayushi"}	f	2026-02-01 15:17:23.134426+00	2026-02-05 06:41:41.928014+00	8657634527	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	dd02c815-1f54-4572-9830-aba8c9aaa18e	authenticated	authenticated	securitytest@example.com	$2a$06$caDOPZ1TF2kynK5Wc1PpduosMmvcV1hF764fJYN4P//eCCrnuzi7C	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-011", "app_role": "volunteer", "last_name": "Security", "first_name": "Test"}	f	2026-02-02 06:31:35.768807+00	2026-02-05 06:41:41.928014+00	9000000000	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	03a59a7d-da67-44b8-88f7-1a0fbe44f706	authenticated	authenticated	cajainam04@gmail.com	$2a$06$kVLflD31LJIirjJKSYQVNe76PCBPL4FAF6UW2x1pleGSBHbW42W6i	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-003", "app_role": "volunteer", "last_name": "Sheth", "first_name": "Jainam"}	f	2026-02-01 15:25:16.393861+00	2026-02-05 06:41:41.928014+00	8879355429	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7e72384f-5a73-498c-b82e-57dd17a6ea18	authenticated	authenticated	charmipdedhia@gmail.com	$2a$06$2QSvFAjr30hBWY/yHEJT4Oocbj8ObLylufJ4Z26Zo5OWql.vLjaje	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-007", "app_role": "volunteer", "last_name": "Dedhia", "first_name": "Charmi"}	f	2026-02-01 16:58:20.314585+00	2026-02-05 06:41:41.928014+00	8169639689	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	authenticated	authenticated	labdhishah128@gmail.com	$2a$06$hO8WrmzFU1jau5kuW3l5Ueu2isMo8QZ6LxkmWcHcYc7DrB2KOQBde	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-005", "app_role": "volunteer", "last_name": "Shah", "first_name": "Labdhi"}	f	2026-02-01 15:37:16.131539+00	2026-02-05 06:41:41.928014+00	7028551745	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4de93087-ee99-48dc-b3a5-4339c8da81ec	authenticated	authenticated	jdoshi154@gmail.com	$2a$06$FvEYhrt6vS/GxiOzHlnFtesW68brEr32pI.xq6THACqOxE7Pn7szS	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-006", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Jeel"}	f	2026-02-01 16:34:33.092509+00	2026-02-05 06:41:41.928014+00	9022756278	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	authenticated	authenticated	jainammehta519@gmail.com	$2a$06$/hUFRVODr1rj5v4Uwyf5YeOLyUVTiSmRwq1ywQwcTmc12N/HTFbp6	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-001", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Jainam"}	f	2026-02-01 15:06:01.194829+00	2026-02-05 06:41:41.928014+00	9167180806	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e243534f-6a49-436d-b637-a050b1e32de0	authenticated	authenticated	bhavyarsanghavi99@gmail.com	$2a$06$UuMPZfbQ4Vswhg53rLJ1quCooLqXB84rPEowy9eLZfxbwq5Zdic/e	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-012", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Bhavya"}	f	2026-02-02 08:28:10.500315+00	2026-02-15 08:45:13.309362+00	+918691904575	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	55ca6718-5a82-408d-800d-86cc3c49bbca	authenticated	authenticated	dishagandhi136@gmail.com	$2a$06$LiCY8prCDRoqSZShtWkpEOmkOUkMH.pYU6r9TaLvlXkszfKnXedZe	2026-02-06 14:09:50.304608+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-013", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Disha"}	f	2026-02-03 15:40:08.070894+00	2026-02-16 05:59:40.689589+00	9969612883	\N			\N		0	\N		\N	f	\N	f
\N	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	authenticated	authenticated	meetsalot1102@gmail.com	$2a$06$wBj0tS14Rb6gSFA18Q.UquYgOMlsHimQGQAJDGB231UuO4etbWqCa	2026-02-07 15:46:02.339115+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-013", "app_role": "volunteer", "last_name": "Salot", "first_name": "Meet"}	\N	2026-02-07 15:46:02.339115+00	2026-02-07 15:46:02.339115+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	b2bc304c-62d9-4383-8af6-f78a51c94374	authenticated	authenticated	vatsalm707@gmail.com	$2a$06$Py3dO.c/Snb2w.ZvYT/daO7PlKTU4uvg8OmPJq8XSDe23dvXlbCzq	2026-02-07 15:48:14.029+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-014", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Vatsal"}	\N	2026-02-07 15:48:14.029+00	2026-02-07 15:48:14.029+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	232f55ca-9598-4daf-a8ef-5e9be124c975	authenticated	authenticated	aayushvora2003@gmail.com	$2a$06$8O9SoRKyhbA7PUmqpqin3uZwQv9cRFew.H296W9sCkC/G.Agwx/6q	2026-02-07 16:04:41.420873+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-016", "app_role": "volunteer", "last_name": "Vora", "first_name": "Aayush"}	\N	2026-02-07 16:04:41.420873+00	2026-02-07 16:04:41.420873+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9f90c956-1695-4492-9fc3-569b6e4cc326	authenticated	authenticated	veertigada12345@gmail.com	$2a$06$hP9gZSPr/9tJwfwBwpnk0uRHBnHLiWrR9ufb0zKfRaFSkeBxgrLAq	2026-02-10 09:39:21.55993+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-028", "app_role": "volunteer", "last_name": "Gada", "first_name": "Veerti"}	\N	2026-02-10 09:39:21.55993+00	2026-02-10 09:39:21.55993+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d22fd755-c0a9-4474-8280-64d42c126700	authenticated	authenticated	shikhacmehta@gmail.com	$2a$06$7oCUoAtVZ1D9qykCSSY7L.vV9kHBKkLQT5Kf7qWlwmUAEElhL6FR2	2026-02-08 05:21:07.814826+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-015", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Shikha "}	\N	2026-02-08 05:21:07.814826+00	2026-02-08 05:21:07.814826+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	481b2283-318d-48b8-94f3-63c9f6fcf7af	authenticated	authenticated	vatsalmehta5106@gmail.com	$2a$06$N4Zj8tc5nmCT/KuDujmE6.HGShiv.bVkBLZ4/V.UNCrHI0y3MuScq	2026-02-09 09:39:09.593969+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-023", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Vatsal"}	\N	2026-02-09 09:39:09.593969+00	2026-02-09 09:39:09.593969+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	authenticated	authenticated	avanidoshi09@gmail.com	$2a$06$ZN8TyYysGCDOahtozOILmuXzzMQwGu.udw7V.0H.C8cTtXR7AmrBW	2026-02-08 13:44:08.339872+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-016", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Avani"}	\N	2026-02-08 13:44:08.339872+00	2026-02-08 13:44:08.339872+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	32837c38-a21e-450a-8613-ec2c09f3cc97	authenticated	authenticated	saachijain808@gmail.com	$2a$06$gF8HvW9LroYUMUIO/CfECu/q9V1AItADXCEOHK7B6mTf0CAXZMD6i	2026-02-08 13:47:14.371431+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-017", "app_role": "volunteer", "last_name": "Jain", "first_name": "Saachi "}	\N	2026-02-08 13:47:14.371431+00	2026-02-08 13:47:14.371431+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3b54e716-c5a0-4d4c-a616-4e2e2be95539	authenticated	authenticated	jash4739@gmail.com	$2a$06$Fjdv0eGPfGDPlC9m1xrToO/m.OsxkUQdQUfRxwUvYLgKSP74fGbfu	2026-02-08 13:47:57.729658+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-018", "app_role": "volunteer", "last_name": "Shah", "first_name": "Jash"}	\N	2026-02-08 13:47:57.729658+00	2026-02-08 13:47:57.729658+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	33e91007-e2fa-4274-801b-4227ea2f7909	authenticated	authenticated	hcs180906@gmail.com	$2a$06$TYGXi8BpS5JE4DMbZcTGs.fpzWUqr43tNmXoDv.HQ.0OdFKOze2xe	2026-02-08 14:09:43.688078+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-019", "app_role": "volunteer", "last_name": "Shah", "first_name": "Hitarth"}	\N	2026-02-08 14:09:43.688078+00	2026-02-08 14:09:43.688078+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4c363395-b574-454e-abb9-bb28a79d09d3	authenticated	authenticated	shahmahek1210@gmail.com	$2a$06$YGaEA6W.xEha5BIjMNn3Guxf92F1SvpMuTQjZKj2SwdDrTmXr9pdS	2026-02-09 16:39:41.380421+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-025", "app_role": "volunteer", "last_name": "Shah", "first_name": "Mahek"}	\N	2026-02-09 16:39:41.380421+00	2026-02-09 16:41:12.870043+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	7034d767-3884-4660-bdc7-ddcd51cd38c3	authenticated	authenticated	vividhapatwa@gmail.com	$2a$06$b0XjUwzWF4F0sZL6HluBd.7SNlxqpAzsusIJ8F8CzSAMEfpNqnuEq	2026-02-09 14:05:14.864396+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-024", "app_role": "volunteer", "last_name": "Patwa", "first_name": "Vividha "}	\N	2026-02-09 14:05:14.864396+00	2026-02-09 14:05:14.864396+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	authenticated	authenticated	yashvimaheta135@gmail.com	$2a$06$CYpPPqBy10S.QPwGZHpCLOBzv4haiK53QenK9dP0D5edrY7pkSlLq	2026-02-08 19:53:24.892602+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-022", "app_role": "volunteer", "last_name": "Maheta", "first_name": "Yashvi"}	\N	2026-02-08 19:53:24.892602+00	2026-02-08 19:53:24.892602+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2c1bcdc5-0564-44d9-be4a-158445f39975	authenticated	authenticated	heershah12116@gmail.com	$2a$06$MC98mGw2QZd0UHSDC2fHLe509Um74nZ.mqUAeSUOzDKZ/oGl0WcBC	2026-02-08 15:01:59.839918+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-020", "app_role": "volunteer", "last_name": "Shah", "first_name": "Heer"}	\N	2026-02-08 15:01:59.839918+00	2026-02-08 15:01:59.839918+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c371c0b4-f445-41ec-b6cf-ba6828e59757	authenticated	authenticated	charmi2630@gmail.com	$2a$06$ZtnltbZfDKJSXBwcj8i2pOFmbRA/XjVsUoha88ciYlyXeOMayJgcC	2026-02-08 15:26:44.396583+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-021", "app_role": "volunteer", "last_name": "Doshi", "first_name": "CHARMI"}	\N	2026-02-08 15:26:44.396583+00	2026-02-08 15:26:44.396583+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d4c73898-8bda-476d-a068-898c72460441	authenticated	authenticated	ns4934551@gmail.com	$2a$06$ljqCg4ox/hdj/1WQnjNd8uD3ED/L5mkOR0LM/L1I86Sv7tI.OWo.i	2026-02-09 17:09:30.799752+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-027", "app_role": "volunteer", "last_name": "Shah", "first_name": "Naitik"}	\N	2026-02-09 17:09:30.799752+00	2026-02-09 17:13:03.651986+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	authenticated	authenticated	Siddhi61d@sttherese.in	$2a$06$qMjxRw/E5grZhJXveF/WJ.ck6ohMNwWqI/vuwwtzVwO3h4qFarBYW	2026-02-09 16:46:53.51547+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-026", "app_role": "volunteer", "last_name": "Dedhia", "first_name": "Siddhi"}	\N	2026-02-09 16:46:53.51547+00	2026-02-09 16:46:53.51547+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	41fcbca1-3193-42ce-8585-95372b4b9d52	authenticated	authenticated	meets.studentlife@gmail.com	$2a$06$7M0fAI2/mraK0Pdxm9F6bOZ8FIOeGbLybKdWQwQJqIUeyH/5.cSBe	2026-02-07 16:44:00.216534+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-014", "last_name": "Test ", "first_name": "Test "}	\N	2026-02-07 16:44:00.216534+00	2026-03-28 13:04:57.07689+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	authenticated	authenticated	dhiaanjain2@gmail.com	$2a$06$8SQFqpTcPGM/2v7.dAb61.RHCYtBTVI3OMmc1fRnV7akXuBtxADGC	2026-02-10 09:53:38.722481+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-029", "app_role": "volunteer", "last_name": "Jain", "first_name": "Dhiaan"}	\N	2026-02-10 09:53:38.722481+00	2026-02-10 09:53:38.722481+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9a067c77-bb95-44cc-812e-4557ac17f80a	authenticated	authenticated	aayushishah1556@gmail.com	$2a$06$kTXLpLNQcgbjrgxAPTiOVetW2f.I7gRwlXGVsnKfod4B0bNTL2Fly	2026-02-10 10:10:54.446122+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-030", "app_role": "volunteer", "last_name": "Shah", "first_name": "Aayushi"}	\N	2026-02-10 10:10:54.446122+00	2026-02-10 10:10:54.446122+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	b8f6d90e-b692-4a8a-8cbc-17909331fa73	authenticated	authenticated	ankitsheth8@gmail.com	$2a$06$xu3QPIgahZ6x3JJ6Iszjd.YIoyXU57DBWFS6xuFs7.ATd5DBoEx1a	2026-02-10 10:28:33.582157+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-031", "app_role": "volunteer", "last_name": "Sheth", "first_name": "Ankit"}	\N	2026-02-10 10:28:33.582157+00	2026-02-10 10:28:33.582157+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	60084f34-305e-42b4-8330-70bba97a2126	authenticated	authenticated	yogitapd15@gmail.com	$2a$06$1q3ofYonfetMXYmujRZpF.WTry6Fjkwl3sRdwJlq0yk4uSnLUyFK.	2026-02-10 10:32:49.505559+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-032", "app_role": "volunteer", "last_name": "Sheth", "first_name": "Yogita"}	\N	2026-02-10 10:32:49.505559+00	2026-02-10 10:32:49.505559+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	authenticated	authenticated	yashvi.sanghavi.dombivli@gmail.com	$2a$06$1JUZcxxVb8DWivUdSbmz3eRgqoRZgtCoWdEmASLhdDa0KEff5Wfwy	2026-02-10 14:20:52.226662+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-033", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Yashvi"}	\N	2026-02-10 14:20:52.226662+00	2026-02-10 14:20:52.226662+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	73e309c3-69be-4b6c-97bf-b23ee7c5634c	authenticated	authenticated	ronakdoshi2024@gmail.com	$2a$06$syboBGEsl2RiRNXNtfg8AO4s2NaHSW6UlNdSAN5bvd.Yx1PUkzvSW	2026-02-10 16:27:01.787267+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-034", "app_role": "volunteer", "last_name": "Doshi ", "first_name": "Ronak"}	\N	2026-02-10 16:27:01.787267+00	2026-02-10 16:29:54.089024+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	58be09cf-362d-4919-9a0a-67aa65a5c52e	authenticated	authenticated	Snehivora06@gmail.com	$2a$06$zlGyriG3/CvcPHzv2lAF9O/OwbwqPOm1.SGTJBuVj38RVYsLn2eUu	2026-02-10 17:33:08.82233+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-035", "app_role": "volunteer", "last_name": "Vora", "first_name": "Snehi"}	\N	2026-02-10 17:33:08.82233+00	2026-02-10 17:33:08.82233+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	df0f9941-a563-4844-adf0-3058c435dbf3	authenticated	authenticated	bhumisanghavi2003@gmail.com	$2a$06$JXT/qh5eUzXYJ2wSl3XHlOhN0e7sRyLislTBJQDSK3lYaJWU0/Pbu	2026-02-11 16:12:01.955263+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-043", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Bhumi"}	\N	2026-02-11 16:12:01.955263+00	2026-02-11 16:12:01.955263+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	6a89d207-b9ef-4e2b-9a9a-14b42000db10	authenticated	authenticated	prachishah1311@gmail.com	$2a$06$k.3GeElWVORBaWHpbFEceeceBIhpB7Szr8hNfZKepyzUZBBW1xBbS	2026-02-12 06:34:31.526794+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-048", "app_role": "volunteer", "last_name": "Shah in", "first_name": "Prachi"}	\N	2026-02-12 06:34:31.526794+00	2026-02-12 06:34:31.526794+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	41135cc0-c4af-478a-bc6e-6ef25590fd94	authenticated	authenticated	Shreyamehttaa@gmail.com	$2a$06$1h5h196ZfKn6p3y5gAXIDOz3D/WQd6L92tCW2c5hCbrMKRxCMcWFa	2026-02-11 10:13:04.965688+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-036", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Shreya"}	\N	2026-02-11 10:13:04.965688+00	2026-02-11 10:13:04.965688+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	f2179127-e88f-41f3-910a-f9dd0fa2647a	authenticated	authenticated	aditimaheta720@gmail.com	$2a$06$UtGX7dfBRPmGEaSxHUCClee0yvCqTekyi092nLjduf5iGMDrCa0wO	2026-02-11 13:37:56.317839+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-037", "app_role": "volunteer", "last_name": "Maheta", "first_name": "Aditi"}	\N	2026-02-11 13:37:56.317839+00	2026-02-11 13:37:56.317839+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	authenticated	authenticated	yeshasalot@gmail.com	$2a$06$9Rk..pDsM6NUmBJE8bBVbelpPcHqVn8EoDBlVG3T2x7phZNaNGv1K	2026-02-11 18:16:42.744692+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-044", "app_role": "volunteer", "last_name": "Salot", "first_name": "Yesha"}	\N	2026-02-11 18:16:42.744692+00	2026-02-11 18:16:42.744692+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	aded593b-ae3f-4eca-8edf-658f89bb172c	authenticated	authenticated	Khushishahh372@gmail.com	$2a$06$6FExkkD3TT.a7lJtpl88Reo9FtiOx5H/WqpIWAGNU4KP6dBauvBNS	2026-02-11 13:57:01.840037+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-038", "app_role": "volunteer", "last_name": "Shah", "first_name": "Khushi"}	\N	2026-02-11 13:57:01.840037+00	2026-02-11 13:57:01.840037+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	dd8599b5-9989-4b14-9d33-6e4913e6693e	authenticated	authenticated	nemilyshah@gmail.com	$2a$06$4g1b6iQDsWEvnUtgcNqhf.3kxG7zZx.8c10RkBBdNyzlD5teuM4wG	2026-02-11 14:10:09.394196+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-039", "app_role": "volunteer", "last_name": "Shah", "first_name": "Nemil"}	\N	2026-02-11 14:10:09.394196+00	2026-02-11 14:13:40.902768+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	96c9c515-49dc-4172-95d9-7a57478388c3	authenticated	authenticated	hiyagandhi624@gmail.com	$2a$06$bmwflOR5VMUSa96R/7HALulMVqUH4HjOhW4musp9X6hPhJRg7BNnS	2026-02-11 14:45:03.463763+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-040", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Hiya"}	\N	2026-02-11 14:45:03.463763+00	2026-02-11 14:45:03.463763+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	authenticated	authenticated	veerammehta175@gmail.com	$2a$06$TDegh0sFzUkaUWkBME/TQehHpZA/o0yUtFdpQVWPQcFwt9dnOkNam	2026-02-11 15:47:27.734778+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-041", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Veeram"}	\N	2026-02-11 15:47:27.734778+00	2026-02-11 15:47:27.734778+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	8b946c8c-5583-4340-94ac-a0c3801bfb98	authenticated	authenticated	daftariharshil@gmail.com	$2a$06$IejYZb6i4aYo7V9Y7AIqmOeT8oRIuARvZkgdhbKms1Lciyjqjyh3i	2026-02-12 09:08:15.978922+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-049", "app_role": "volunteer", "last_name": "Daftari", "first_name": "Harshil"}	\N	2026-02-12 09:08:15.978922+00	2026-02-12 09:08:15.978922+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	a551cf3f-5282-49ea-b432-7624af5558b2	authenticated	authenticated	mokshangj@gmail.com	$2a$06$NizNl7wOSfdCbgdbNsBOP.5fbVxfMkKNUJgf.XpXJgYZAg8x0QXOq	2026-02-11 15:48:10.046077+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-042", "app_role": "volunteer", "last_name": "Jain", "first_name": "Mokshang"}	\N	2026-02-11 15:48:10.046077+00	2026-02-11 15:48:10.046077+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	authenticated	authenticated	aayushsanghavi97@gmail.com	$2a$06$RzmioX9eJRJOTsJWkNFI7.7jSpHxMn28zWjaxvWZJ.cifk8Bpww/6	2026-02-12 04:35:50.529978+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-045", "app_role": "volunteer", "last_name": "Sanghavi ", "first_name": "Aayush "}	\N	2026-02-12 04:35:50.529978+00	2026-02-12 04:35:50.529978+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	fe64f71e-bc1f-4297-af8a-9dfae090e0be	authenticated	authenticated	kreena.b@somaiya.edu	$2a$06$.pKAvuBHNLZNA4e21xVxmOAdHYkEIOmXRXWAEwSRIlocQ9o8Qy.aq	2026-02-12 05:27:29.57057+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-046", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Kreena"}	\N	2026-02-12 05:27:29.57057+00	2026-02-12 05:27:29.57057+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	f854a439-e72d-44fc-8efe-a0f755462a04	authenticated	authenticated	rutvisanghavi5@gmail.com	$2a$06$pd3d59/YUpiikTUgc.sZX.EqD9lmJmilfzSMHo1f/Q1PoxlqOkuZ6	2026-02-12 10:04:52.685918+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-050", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Rutvi"}	\N	2026-02-12 10:04:52.685918+00	2026-02-12 10:04:52.685918+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4842d49f-c3ea-47a4-bfee-03837bec04a5	authenticated	authenticated	mehtajiana7@gmail.com	$2a$06$cyG5B.1tITvGpQhfr9q4B.4vQ1N.OqATr7/f2oqQQYAnPUHtx/4Iq	2026-02-12 06:31:29.839705+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-047", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Jiana"}	\N	2026-02-12 06:31:29.839705+00	2026-04-03 03:58:52.799375+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	0c6384b4-15bd-42b1-a978-317e1d163f8d	authenticated	authenticated	arpitadand5002@gmail.com	$2a$06$0qQJ/B9Q35Pt4nLrzqLuUuC664uLTDdl9asTDUZFIG.Xg25BViAPS	2026-02-12 11:04:39.970126+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-051", "app_role": "volunteer", "last_name": "Dand", "first_name": "Arpita"}	\N	2026-02-12 11:04:39.970126+00	2026-02-12 11:06:01.926167+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	34e80f19-ddbe-46bf-9a65-83c81104b974	authenticated	authenticated	labdhi1608@gmail.com	$2a$06$r8M0hmyRl2MIQMu25.auz.sMgWhtLImLJ.IqLUTrXunzpjy2I3QSm	2026-02-19 05:30:40.91807+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-069", "app_role": "volunteer", "last_name": "Shah", "first_name": "Labdhi "}	\N	2026-02-19 05:30:40.91807+00	2026-02-19 05:30:40.91807+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	643db578-c5a7-422f-ad51-1ba67a0db590	authenticated	authenticated	dhruvgandhi0506@gmail.com	$2a$06$Vsjhrv5Lf68w8JwnsgFiAOO9T6p69P4QI9RQofWxkAaRfInGzDCG6	2026-02-18 15:58:57.376591+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-062", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Dhruv "}	\N	2026-02-18 15:58:57.376591+00	2026-02-18 15:58:57.376591+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	authenticated	authenticated	prisha.jain@somaiya.edu	$2a$06$VYcjFo/roqRG.j25GEe5nuuiJA1L6pAx/8J4PQNKBTG8ZpVmmyESO	2026-02-13 09:50:12.716586+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-053", "app_role": "volunteer", "last_name": "Jain ", "first_name": "Prisha "}	\N	2026-02-13 09:50:12.716586+00	2026-02-13 09:50:12.716586+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	69fbfc39-3ac0-4972-93fb-317e3e50219b	authenticated	authenticated	labdhivora1@gmail.com	$2a$06$LxuE1lA65sPR7pcRwEVkxuAFLGFQi.IdW7.H3DuhVlQKiNrGjFaeG	2026-02-18 16:17:34.355151+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-063", "app_role": "volunteer", "last_name": "Vora", "first_name": "Labdhi "}	\N	2026-02-18 16:17:34.355151+00	2026-02-18 16:17:34.355151+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	46d8f688-8929-4f4e-9c02-c1db1a0669ea	authenticated	authenticated	prishaparmani15@gmail.com	$2a$06$Ai1sAsja444zUHMpKsYuKeM/fNoaaL4tzdcSYpawf9nLbT8wESzCu	2026-02-17 13:14:06.601195+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-059", "app_role": "volunteer", "last_name": "Parmani ", "first_name": "Prisha"}	\N	2026-02-17 13:14:06.601195+00	2026-02-17 13:14:06.601195+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	authenticated	authenticated	nidhivora83@gmail.com	$2a$06$XfkXUP60WzETQnmSAoEYceDOX2wGHxeSBvXpaCJTSHkbKUKQQPke6	2026-02-18 16:18:26.033731+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-064", "app_role": "volunteer", "last_name": "Vora", "first_name": "Nidhee"}	\N	2026-02-18 16:18:26.033731+00	2026-02-18 16:18:26.033731+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	authenticated	authenticated	twishagandhi363@gmail.com	$2a$06$sEu16gCPJWobxtCgbVEr0.twuXQrqf41weKDfWa00Jfnh11XQMDxq	2026-02-18 06:36:07.35355+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-060", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Twisha "}	\N	2026-02-18 06:36:07.35355+00	2026-02-18 06:36:07.35355+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	authenticated	authenticated	virtigandhi28@gmail.com	$2a$06$su0TTA8AeUMUZrrKW0SFFehKoWrMmc7GIY1Gs4X4b6mDzjTKs50bC	2026-02-18 17:05:42.536061+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-065", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Virti"}	\N	2026-02-18 17:05:42.536061+00	2026-02-18 17:05:42.536061+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	authenticated	authenticated	aashimaru2008@gmail.com	$2a$06$VaPoRaXes5J4/J3TNx0PbuUTiCaX0yopTBNlvQbrUhY1y2hwRIU6G	2026-02-18 10:03:56.589594+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-061", "app_role": "volunteer", "last_name": "maru", "first_name": "aashi"}	\N	2026-02-18 10:03:56.589594+00	2026-02-18 10:03:56.589594+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	authenticated	authenticated	aeshapshah153@gmail.com	$2a$06$QI3H.PkZswAMf0J73BqjreNuLbzzcMdwVSF8FQ.p/TDnPTnv432n6	2026-02-16 15:24:52.337521+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-056", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Aesha "}	\N	2026-02-16 15:24:52.337521+00	2026-02-16 15:24:52.337521+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	50ac0f99-6e54-4ab2-bdbd-83463583261a	authenticated	authenticated	vanshivora28@gmail.com	$2a$06$yS44jowMW2zTsgQjpeUT/etsOMVWmM1rNdQzJpsZ2OA5g5ELrnNtq	2026-02-13 19:50:58.798661+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-055", "app_role": "volunteer", "last_name": "vora", "first_name": "Vanshi"}	\N	2026-02-13 19:50:58.798661+00	2026-02-13 19:50:58.798661+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	authenticated	authenticated	nikita.doshi08@gmail.com	$2a$06$aLXrvj0Fl4uSJNxb9m9F.uyJl43HLm/ldrt/w/YInEgOSYHw8bqpq	2026-02-16 15:48:18.500292+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-057", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Nikita"}	\N	2026-02-16 15:48:18.500292+00	2026-02-16 15:48:18.500292+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	f24c03cf-533a-4334-badc-b450e0ac0a6b	authenticated	authenticated	arihaaparekh01@gmail.com	$2a$06$TnTfPpwX/0DC2mGju6.OaO7Z4eMD0XHvBK6bGANh.bIWhH02vFmZK	2026-02-16 15:50:48.487191+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-058", "app_role": "volunteer", "last_name": "Parekh", "first_name": "Ariha"}	\N	2026-02-16 15:50:48.487191+00	2026-02-16 15:50:48.487191+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	47485610-8800-4c02-ac12-90808a9ecb94	authenticated	authenticated	91shah.anjali@gmail.com	$2a$06$wXKb2N5LYWraIPiCZ9BAfeqzDzjWpQBk1wwimVWJulgg4dyiVfqUW	2026-02-18 17:14:02.989741+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-066", "app_role": "volunteer", "last_name": "Vasa ", "first_name": "Anjali"}	\N	2026-02-18 17:14:02.989741+00	2026-02-18 17:14:02.989741+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	57c08aaa-e760-48dd-9772-d8fbea00e722	authenticated	authenticated	snehakaran.sk@gmail.com	$2a$06$dJ6gpCXIQQ.tqsvxtmxW7eRz74Eh1ZaUUiYqWSdMJZHuISPR9U5KO	2026-02-18 18:17:14.004636+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-067", "app_role": "volunteer", "last_name": "Kothari", "first_name": "Sneha"}	\N	2026-02-18 18:17:14.004636+00	2026-02-18 18:17:14.004636+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d176663a-6707-4d57-bf50-35e3e7b4a964	authenticated	authenticated	mana88shah@gmail.com	$2a$06$G2FMq2nzTQiRVc6x0EEuVO2OCJE8AoPgDo6qJZTCCWyhDvN7S0zC.	2026-02-12 15:47:50.461262+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-052", "app_role": "volunteer", "last_name": "Shah", "first_name": "Manali "}	\N	2026-02-12 15:47:50.461262+00	2026-03-03 16:16:19.617124+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2a495f49-f4e5-4dfa-879d-50e43fcca74e	authenticated	authenticated	dhruvigandhi4617@gmail.com	$2a$06$BrDt8JPLwmL1mkmfpYAlD.enwy1lpdTyv5r/lgSL54nXlnqwXpf2i	2026-02-18 19:18:43.510185+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-068", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Dhruvi "}	\N	2026-02-18 19:18:43.510185+00	2026-02-18 19:18:43.510185+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	authenticated	authenticated	khushimjain08@gmail.com	$2a$06$.zOXWYRmyUAVPOe90TOS0.xjG77cRbIb02Rwn1d7/adoQV8c8LOoe	2026-02-13 13:38:15.607808+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-054", "app_role": "volunteer", "last_name": "Jain", "first_name": "Khushi"}	\N	2026-02-13 13:38:15.607808+00	2026-03-12 14:39:58.09446+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	35c1bb89-4881-4798-a257-8b714d2017dd	authenticated	authenticated	admin@ilovejinshasan.org	$2a$06$twMqEqICvkr0Acnn8sjyMux7DwYqwg1h88J2j2RDowgaWMYTT1MWO	2026-02-05 06:26:50.462884+00	\N		\N		\N			\N	2026-05-31 17:32:12.65336+00	{"provider": "email", "providers": ["email"]}	{"role": "admin", "email_verified": true}	\N	2026-02-05 06:26:50.404673+00	2026-05-31 17:32:12.707408+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	a249b221-853f-4065-b6a4-c9ef30d4032f	authenticated	authenticated	darshchandura102@gmail.com	$2a$06$FMEuuLDb.N50NRHpylQsYOnDaD5ZwcD1MCMkGtPpMlMW8UVokZXRO	2026-02-19 07:06:15.05819+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-070", "app_role": "volunteer", "last_name": "Chandura", "first_name": "Darsh"}	\N	2026-02-19 07:06:15.05819+00	2026-02-19 07:06:15.05819+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	486cb7fe-4375-44d1-b124-e2460ab1826a	authenticated	authenticated	harshiiishah30@gmail.com	$2a$06$KXcHfqyEmrkParMxfh44v.scA5S9n/L53jSCEC2ogpxYtcP0Lq5P2	2026-02-19 14:40:54.724837+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-071", "app_role": "volunteer", "last_name": "Shah", "first_name": "Harshi"}	\N	2026-02-19 14:40:54.724837+00	2026-02-19 14:40:54.724837+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9e34793f-4532-4cf0-8e19-bb36a03057d2	authenticated	authenticated	shahtanisha2024@gmail.com	$2a$06$DV1V3x82H.IUzt57mLSbGeTgSaKtroBHYye38sLF8QgcMxaLJ879i	2026-02-19 17:10:53.107831+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-072", "app_role": "volunteer", "last_name": "Shah", "first_name": "Tanisha"}	\N	2026-02-19 17:10:53.107831+00	2026-02-19 17:10:53.107831+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	32cf8f2e-3643-4301-8fde-d601c27012fc	authenticated	authenticated	veermehta232007@gmail.com	$2a$06$1KtGab0uJ8NS3HJBk//SZ.aXoYR/62Mnyav6nfsWfex.nssmkfXYe	2026-02-19 17:28:32.700838+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-073", "app_role": "volunteer", "last_name": "Mehta ", "first_name": "Veeram"}	\N	2026-02-19 17:28:32.700838+00	2026-02-19 17:28:32.700838+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4524f75e-4135-4a2c-8bfb-02dc30ae126b	authenticated	authenticated	akshatparekh24@gmail.com	$2a$06$hf/x11Q5Uqf7lxYzM.ls.OdfUJzj3Q6IOiZNfRiEA8Zspk.xD42E.	2026-02-22 05:23:04.784867+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-074", "app_role": "volunteer", "last_name": "Parekh", "first_name": "Akshat"}	\N	2026-02-22 05:23:04.784867+00	2026-02-22 05:23:04.784867+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	172dbd3e-8074-423c-a82b-16e77ea8a2b2	authenticated	authenticated	vishwadoshi2004@gmail.com	$2a$06$.R0EPKzq6HZtFVAm8ve41.UPMbxnVWnc/WwnGaPE7d4AQtM3V5Gj.	2026-02-22 07:47:01.914964+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-075", "app_role": "volunteer", "last_name": "Doshi ", "first_name": "Vishwa "}	\N	2026-02-22 07:47:01.914964+00	2026-02-22 07:47:01.914964+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	authenticated	authenticated	Shruti.s25@skips.in	$2a$06$lqCl77P3pUkU0zNsyytNvOAu8G14UKLOg08/QLT/OJNdjmksl3G2m	2026-02-22 13:12:06.380204+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-076", "app_role": "volunteer", "last_name": "Dalal", "first_name": "Shruti"}	\N	2026-02-22 13:12:06.380204+00	2026-02-22 13:12:06.380204+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	authenticated	authenticated	meetleveledge@gmail.com	$2a$06$HhuKnrPZn2j/DbNhnwejX.FDd1/j7J/s4kWTyaPSLmIGjRq8aIlt6	2026-02-24 19:27:20.773506+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-077", "app_role": "volunteer", "last_name": "test", "first_name": "Test"}	\N	2026-02-24 19:27:20.773506+00	2026-02-24 19:27:20.773506+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	authenticated	authenticated	ktshah3620@gmail.com	$2a$06$yLpmXwWf8QU57OEsF6rpleoyo1jCsvKLGwDvhumoaxyBNMGqelef2	2026-02-25 14:47:41.769972+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-078", "app_role": "volunteer", "last_name": "Shah", "first_name": "Kathan"}	\N	2026-02-25 14:47:41.769972+00	2026-02-25 14:47:41.769972+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	authenticated	authenticated	Karanmehta9902@gmail.com	$2a$06$mRuBr0F.qHtq7k2fUakAsOs.1/JqseQ.IjPb1HP75rmvl7rgdWiGy	2026-02-27 08:39:14.293189+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-079", "app_role": "volunteer", "last_name": "Mehta ", "first_name": "Karan "}	\N	2026-02-27 08:39:14.293189+00	2026-02-27 08:39:14.293189+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9421c674-7e88-4d96-9cdf-01f31a35c231	authenticated	authenticated	dhrutidoshi916@gnail.com	$2a$06$MpeQFjoQilanSAtcew3N7e.anrHeXdHW5Ng50Zb.QT03KF1.TCrQe	2026-02-27 09:25:45.386275+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-080", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Dhruti "}	\N	2026-02-27 09:25:45.386275+00	2026-02-27 09:25:45.386275+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	authenticated	authenticated	parshvaramani@gmail.com	$2a$06$QMG.556KMHoJW78900eyBezPa8vwuWtW1CV.YkELarO6tsSs4TIVe	2026-02-27 15:05:38.276365+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-081", "app_role": "volunteer", "last_name": "Ramani", "first_name": "Parshva"}	\N	2026-02-27 15:05:38.276365+00	2026-02-27 15:11:32.501956+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2e3999e0-fcca-407c-afa9-0ff5c26fae98	authenticated	authenticated	harshshah80652@gmail.com	$2a$06$LONoaKcluCKeGEjYl5IN9ueHVF10JIeL783g1cK.WcYbblTrPU/VS	2026-02-27 15:27:14.479549+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-082", "app_role": "volunteer", "last_name": "Shah", "first_name": "Harsh"}	\N	2026-02-27 15:27:14.479549+00	2026-02-27 15:27:14.479549+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	authenticated	authenticated	Mehta.vidhi1994@gmail.com	$2a$06$K15Tgyw0LEI9zObq22oJ5uz/IsgvbAE6arBh3p/f40h.gx7FoMua2	2026-02-27 15:50:00.182225+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-083", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Vidhi"}	\N	2026-02-27 15:50:00.182225+00	2026-02-27 15:50:00.182225+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	1faa2e14-2817-46d8-8f9e-5e7b70855a98	authenticated	authenticated	doshihetvi04@gmail.com	$2a$06$usMSRtlc364Vsn3l8Gsip.NwMQ7CwYbwcQysSEPjj6ttLtzrgyys6	2026-02-28 09:19:17.235641+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-084", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Hetvi"}	\N	2026-02-28 09:19:17.235641+00	2026-02-28 09:19:17.235641+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	08f53469-511c-45e6-914a-c4aacc2c4fed	authenticated	authenticated	krishapshah7080@gmail.com	$2a$06$1y0i9SPeJibDZMTKe5yimOdeySY8Qiyrc8aFQG2r.Zpph/ehIasgC	2026-03-01 12:13:58.729145+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-086", "app_role": "volunteer", "last_name": "Shah", "first_name": "Krisha "}	\N	2026-03-01 12:13:58.729145+00	2026-03-01 12:13:58.729145+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	f80e1236-fa27-4605-a0c5-3e92f540bc70	authenticated	authenticated	dedhia.siddhi.21@gmail.com	$2a$06$9kxRG33uKoJSlTnTaQS67OqUIY0QmxpSiNzCZ2pXVWf09HgK6xtp.	2026-03-01 12:14:51.493037+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-087", "app_role": "volunteer", "last_name": "Dedhia", "first_name": "Siddhi"}	\N	2026-03-01 12:14:51.493037+00	2026-03-01 12:14:51.493037+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	a8046eca-1c34-4435-aacf-826e49a40e5b	authenticated	authenticated	rashihgada@gmail.com	$2a$06$XtOiAPB.2bpqghygMVcut.kLYclsnoakYU4o.IpsF96Kja5KbGMoC	2026-03-01 13:16:18.221669+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-088", "app_role": "volunteer", "last_name": "Gada", "first_name": "Rashi"}	\N	2026-03-01 13:16:18.221669+00	2026-03-01 13:16:18.221669+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	19d835f0-85cf-4457-8aa4-86dea0dd14dc	authenticated	authenticated	nirav.shah2062@gmail.com	$2a$06$vCd1aaPaCpcphEILxJsRMeteY8.5.qCPDpSttcOcASuuh3.uFCW9G	2026-03-01 16:36:36.353282+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-089", "app_role": "volunteer", "last_name": "Shah", "first_name": "Nirav"}	\N	2026-03-01 16:36:36.353282+00	2026-03-01 16:36:36.353282+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4bf8abb9-f93c-4e9f-838c-10c3069996f9	authenticated	authenticated	Nishita1508@gmail.com	$2a$06$bseavzu9HBtUlyjTvtf7p.Kdr4ng5Ivq.w4xS.RwWwYKh40cjjhWi	2026-03-03 04:07:06.811951+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-090", "app_role": "volunteer", "last_name": "Vasa", "first_name": "Nishita"}	\N	2026-03-03 04:07:06.811951+00	2026-03-03 04:07:06.811951+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	authenticated	authenticated	deepalmehta147@gmail.com	$2a$06$g.FwiDfKIvgXHzafLsklY.2ApcfT8mNj2BzNEgaT/uOW.7pB31hkm	2026-03-04 08:04:18.477762+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-091", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Deepal"}	\N	2026-03-04 08:04:18.477762+00	2026-03-04 08:04:18.477762+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	authenticated	authenticated	jhalakgandhi09@gmail.com	$2a$06$bcJDL68rDFuaPXJ4818ep..Ox1OFJA59XjvRJislRdYXc4onUoUze	2026-03-04 13:45:22.900002+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-092", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Jhalak"}	\N	2026-03-04 13:45:22.900002+00	2026-03-04 13:45:22.900002+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	b7a0ba40-6b70-461d-b806-4583cb44019a	authenticated	authenticated	karaniyasujal@gmail.com	$2a$06$KJaUXBeFDP98xR5fkVDzluuhT9la1/RRx.Uzp4taSZt1hXdGup4Uy	2026-03-05 09:00:34.685777+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-093", "app_role": "volunteer", "last_name": "Karaniya", "first_name": "Sujal"}	\N	2026-03-05 09:00:34.685777+00	2026-03-05 09:00:34.685777+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	eae9a0f2-2bd7-467a-aa1c-b59963276dda	authenticated	authenticated	rjain96933@gmail.com	$2a$06$N/kPGlMOOOnLThPGZCU.Oeo0TODLQG1uQk9DORIn87qC6BP6WrK1a	2026-03-06 15:43:11.090125+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-094", "app_role": "volunteer", "last_name": "Siyal", "first_name": "Rahul"}	\N	2026-03-06 15:43:11.090125+00	2026-03-06 15:43:11.090125+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	authenticated	authenticated	niyatidoshi90@gmail.com	$2a$06$C5sDYs1Zlq9UK/P.KssH2.WRRgUmDu6TwOafo27EDt3wBM/UwuN8m	2026-03-07 11:55:40.789982+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-095", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Niyati"}	\N	2026-03-07 11:55:40.789982+00	2026-03-07 11:55:40.789982+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	authenticated	authenticated	paramhgada30@gmail.com	$2a$06$QRdDRgNjk/erASa3h.y1ueX4rjE20.Qxl1geRjB6MQcDEktwz1uE6	2026-03-10 17:03:52.818109+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-096", "app_role": "volunteer", "last_name": "Gada", "first_name": "Param"}	\N	2026-03-10 17:03:52.818109+00	2026-03-10 17:03:52.818109+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ae7ecff0-d962-497f-943b-4d772e2483b4	authenticated	authenticated	Vishwashaha24@gmail.com	$2a$06$D6xoYpmXdehOe631MI1.weFaS0QU8Tp.NYiXlS23grsc78kLiA5X.	2026-03-12 16:53:12.319897+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-098", "app_role": "volunteer", "last_name": "Shah", "first_name": "Vishwa"}	\N	2026-03-12 16:53:12.319897+00	2026-03-12 16:53:12.319897+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	b644c23a-6ad3-4c08-ac90-8dc552e7478c	authenticated	authenticated	rj02688@gmail.com	$2a$06$Yu53SiV68IQ3Mtjr3rrsbOilZNanslCY0L4cxoimysChmEjSLtAgy	2026-03-12 15:48:01.925513+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-097", "app_role": "volunteer", "last_name": "Jain", "first_name": "Rahul"}	\N	2026-03-12 15:48:01.925513+00	2026-03-13 01:48:29.401109+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9f6ca714-7578-43d0-b6c2-290e4e6ef413	authenticated	authenticated	nehashah260478@gmail.com	$2a$06$cq0.5zBsDAh0qh/dHBdu5erCMlJ8u9vlWFnXVixT25TfJcEc2uWsG	2026-03-14 07:26:33.990557+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-099", "app_role": "volunteer", "last_name": "Shah", "first_name": "Neha "}	\N	2026-03-14 07:26:33.990557+00	2026-03-14 07:26:33.990557+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	authenticated	authenticated	manan.n.vasa@gmail.com	$2a$06$pyqvj79bRFilAlXRLqHNBeQb/UZtFJTo4evlamhBd6Tu9G8xWw96C	2026-03-01 07:17:45.443105+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-085", "app_role": "volunteer", "last_name": "Vasa", "first_name": "Manan"}	\N	2026-03-01 07:17:45.443105+00	2026-03-14 16:14:18.289211+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	44ae1d67-01ec-47d6-b057-c42404976678	authenticated	authenticated	rpd8703@gmail.com	$2a$06$eX9swhdQU0nbzPlWDY81O.BCnXQ0QRD4U/anMybgdRN2f.fPBiw5a	2026-03-14 18:39:31.301272+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-100", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Riddhi"}	\N	2026-03-14 18:39:31.301272+00	2026-03-14 18:39:31.301272+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	467d6f6c-4cef-4143-9e20-5827d6690cc1	authenticated	authenticated	vrushti2810@gmail.com	$2a$06$.1.25SA5YOTz8/fHNplIBujK/2qqN6WI54YEx5AcFsdaHu.wHNF/S	2026-03-19 11:08:55.222805+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-101", "app_role": "volunteer", "last_name": "shah", "first_name": "vrushti"}	\N	2026-03-19 11:08:55.222805+00	2026-03-19 11:11:16.280005+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	117f2d44-cb82-475c-bdf9-841f771649d5	authenticated	authenticated	harshsanghavi0512@gmail.com	$2a$06$JtXDuElSFbsesUkzYajELOv8bZbzf2YDniBmUmfIUisnchTYqofkK	2026-03-21 12:17:57.462827+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-102", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Harsh"}	\N	2026-03-21 12:17:57.462827+00	2026-03-21 12:17:57.462827+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4d69310b-0603-47ba-9171-644236ecde06	authenticated	authenticated	priyalshah0500@gmail.com	$2a$06$z.ESNzrKVZ5IJNVAU86TLOZ6I1Wz1LahNLKet5xpz.fNCZjWx4r2K	2026-03-26 04:39:42.102004+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-104", "app_role": "volunteer", "last_name": "Shah", "first_name": "Priyal"}	\N	2026-03-26 04:39:42.102004+00	2026-03-26 04:39:42.102004+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ccfcbbd3-ed14-440e-9a04-1e348f45996d	authenticated	authenticated	meenakshiborana31@gmail.com	$2a$06$Bn/nCsb2pRaLWiW.cVKS9O2PwXj8LFZOss8IgnKMGprbR1YFvVqiu	2026-03-26 13:27:43.573258+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-105", "app_role": "volunteer", "last_name": "Borana", "first_name": "Meenakshi"}	\N	2026-03-26 13:27:43.573258+00	2026-03-26 13:30:56.342451+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c97ed6dc-f8d5-4311-a1f8-58a72267a160	authenticated	authenticated	tejashree.kotak@gmail.com	$2a$06$P9G7YKYyMOnBqECBY0M9NOYbvmO3MMTBQ5eLtudhYq5wdMgHAfd5y	2026-03-29 04:27:57.051228+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-106", "app_role": "volunteer", "last_name": "SHAH", "first_name": "TEJASHREE"}	\N	2026-03-29 04:27:57.051228+00	2026-03-29 04:27:57.051228+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	authenticated	authenticated	kinjalgada1119@gmail.com	$2a$06$zAlhfIZhvLqhAj./EG7HtOjPrwqzRSpX6VZMooA60GsPC9YKvODuG	2026-03-29 11:54:04.581441+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-107", "app_role": "volunteer", "last_name": "Gada", "first_name": "Prisha "}	\N	2026-03-29 11:54:04.581441+00	2026-03-29 11:54:04.581441+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3656a4f7-ddaa-4b85-8c89-cde880be3227	authenticated	authenticated	nishapunu@gmail.com	$2a$06$Rauht81iQZnTyAU1SsK80.U2bENjEca.hKT7M0RAPnGfY7JcIjPcy	2026-03-30 13:26:39.967315+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-108", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Punya "}	\N	2026-03-30 13:26:39.967315+00	2026-03-30 13:26:39.967315+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	abfeb4ea-ff91-472a-8f0e-d458d122e68a	authenticated	authenticated	khyatis2002@gmail.com	$2a$06$yQFOmtOTZIEsNO2pFyp4UOaa4OHb64EprDd2DAvFagboMZlphBvZ2	2026-03-30 14:36:02.512616+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-109", "app_role": "volunteer", "last_name": "Sanghavi ", "first_name": "Khyati "}	\N	2026-03-30 14:36:02.512616+00	2026-03-30 14:36:02.512616+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	authenticated	authenticated	nemil199799@gmail.com	$2a$06$tE6rPk84ihFE9ni130IhgugtY6c3Go1OwY2dNK.cmAvX5a.DRfAP.	2026-04-08 18:41:38.1296+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-110", "app_role": "volunteer", "last_name": "Shah", "first_name": "Nemil"}	\N	2026-04-08 18:41:38.1296+00	2026-04-08 18:41:38.1296+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ec777267-0100-4e47-adcd-afa4e8deb872	authenticated	authenticated	nitidoshi29@gmail.com	$2a$06$z9HGzZLXp3AMVkDTjFddtO3smqyp9zjpF51rNkll8HxtQdv8/BgBi	2026-04-18 07:27:24.122416+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-112", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Niti"}	\N	2026-04-18 07:27:24.122416+00	2026-04-18 07:27:24.122416+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	authenticated	authenticated	shahbhavya2209@gmail.com	$2a$06$tWMjsnZDz0LfMSiQPi.uLulySKkibqa/Io5T5ftXz2M/xW/GN8k1a	2026-04-19 15:22:28.213841+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-113", "app_role": "volunteer", "last_name": "Shah", "first_name": "Bhavya "}	\N	2026-04-19 15:22:28.213841+00	2026-04-19 15:22:28.213841+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	e63d4eb5-df96-472d-9b92-dca55f181f78	authenticated	authenticated	dandsmita1983@gmail.com	$2a$06$O2A.wkgAIPnk6lPmx.y6e.aLcWLdBKSLbot2GrxWi1NzDUZMcE1y6	2026-04-23 12:59:55.630204+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-114", "app_role": "volunteer", "last_name": "Dand", "first_name": "Apeksha"}	\N	2026-04-23 12:59:55.630204+00	2026-04-23 13:01:13.129762+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	a968d860-32be-47e9-8d8e-ef6752a3e879	authenticated	authenticated	omkarkotak753@gmail.com	$2a$06$xsUFHxQ/lfMtI27nepWLMefCC/TeeicnadB468mvSFyFRUAwr7LaC	2026-04-23 16:24:18.342018+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-116", "app_role": "volunteer", "last_name": "kotak", "first_name": "omkar"}	\N	2026-04-23 16:24:18.342018+00	2026-04-23 16:24:18.342018+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	914b0f69-d854-494a-88d2-d35987b82c79	authenticated	authenticated	doshinirag@gmail.com	$2a$06$/1XknQ/awPmQDrD.mUIGKef2vgA55g1EE.t/O4c972C3Ry334JBpe	2026-05-17 07:32:00.528542+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-126", "app_role": "volunteer", "last_name": "Doshi", "first_name": "Nirag"}	\N	2026-05-17 07:32:00.528542+00	2026-05-17 07:32:00.528542+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4d17c59e-7231-4a0f-bd3f-8294f90e212e	authenticated	authenticated	virtimshah29@gmail.com	$2a$06$.U3skLzMae5ZN3wqmr/wa.Jqqe5pxVguBV2dl4BieRNP/OlPdoZJK	2026-03-25 03:54:12.504796+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-103", "app_role": "volunteer", "last_name": "Manish ", "first_name": "Virti "}	\N	2026-03-25 03:54:12.504796+00	2026-04-23 16:47:36.69239+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	authenticated	authenticated	labdhimehta04@gmail.com	$2a$06$xkbXfuQ.dm0o3nFb9URCTut5tINmB49.n4FWyW/0qxgWUy4L8ZcRS	2026-04-24 10:58:02.45842+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-117", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Labdhi"}	\N	2026-04-24 10:58:02.45842+00	2026-04-24 10:58:02.45842+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	55dbfa08-450b-42c5-9372-6b24963f36b5	authenticated	authenticated	diptigandhi304@gmail.com	$2a$06$6em.dcX64FZezWVAS.TkG.PL7ZhWQqjGnvRDgiyZPNeyrX9iVccMy	2026-04-26 05:26:38.131793+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-118", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Dipti"}	\N	2026-04-26 05:26:38.131793+00	2026-04-26 05:26:38.131793+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	authenticated	authenticated	aayushishah21073@gmail.com	$2a$06$K7Nuad1uQ7ssB6UQ7ju1Eej/J20sWNVSzPVtIgY/CrODUmY9Frf.W	2026-04-26 19:16:28.110525+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-119", "app_role": "volunteer", "last_name": "Shah", "first_name": "Ayushi shah"}	\N	2026-04-26 19:16:28.110525+00	2026-04-26 19:16:28.110525+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	85fd79c7-df83-40a2-90ff-15a51d3d79fd	authenticated	authenticated	arpitashah302@gmail.com	$2a$06$QkV/EdnOKCdqYC8kBesAEupXqXceSrrOZPhYl1H8fZ7A90d6D87lS	2026-04-28 03:45:31.721247+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-120", "app_role": "volunteer", "last_name": "Shah", "first_name": "Arpita"}	\N	2026-04-28 03:45:31.721247+00	2026-04-28 03:45:31.721247+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	f0d6a329-ff03-4ba6-8006-5742402e06bb	authenticated	authenticated	dedhiapuja18@gmail.com	$2a$06$QxaQBAb.a4t/fd5fmT.ju.4Csj0INYZQwuy6RWtM.KSZsyqgYjvm.	2026-05-04 09:56:08.01923+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-121", "app_role": "volunteer", "last_name": "Dedhia", "first_name": "Puja"}	\N	2026-05-04 09:56:08.01923+00	2026-05-04 09:56:08.01923+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4b42c12c-6dd7-49fc-8268-24564f5b9204	authenticated	authenticated	sidkitisitti@gmail.com	$2a$06$Dh0kMv.tMSV5fC3thQqm.OClw5WuKIWNLLkYoegBScA2md9OKEvYO	2026-05-10 16:05:42.786306+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-122", "app_role": "volunteer", "last_name": "Singhi ", "first_name": "Jainaam "}	\N	2026-05-10 16:05:42.786306+00	2026-05-10 16:05:42.786306+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4f596e49-9138-494f-9c00-d4106a457861	authenticated	authenticated	sakshidoshi981@gmail.com	$2a$06$wAvMRn.1QH/hF9/BzGK1N.e6UXh0YxwmrgOGEtr8cijUv8pxGhZF6	2026-04-23 16:23:13.846596+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-115", "app_role": "volunteer", "last_name": "doshi", "first_name": "Sakshi"}	\N	2026-04-23 16:23:13.846596+00	2026-05-11 08:10:38.399539+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d868f2b7-f054-4c90-84aa-be0cd7490fa5	authenticated	authenticated	Sujatasinghi.com@gmail.com	$2a$06$Q83No0GKEljgsZKPxv29le0HL5/ZxYU2KJkAMNPpSUV9IFm2vMB9C	2026-05-12 11:00:42.408937+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-123", "app_role": "volunteer", "last_name": "Singhi", "first_name": "Dr. Sujata"}	\N	2026-05-12 11:00:42.408937+00	2026-05-12 11:00:42.408937+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9b5fd841-5c68-4e82-8d91-95d01943d1aa	authenticated	authenticated	dr.hardikshah05@gmail.com	$2a$06$63ITsVo4jI8ezKLiIedBAea9mHLxM3DB5OzXT1qS/k9PplIIwpTE.	2026-04-10 15:06:31.374527+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-111", "app_role": "volunteer", "last_name": "Shah", "first_name": "DrHardik"}	\N	2026-04-10 15:06:31.374527+00	2026-05-15 08:33:43.901546+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	11fc3990-68cc-4cdb-ad83-fca0ec15799f	authenticated	authenticated	shahshruti3113@gmail.com	$2a$06$eiwsq0j.A.mHrtMr5MDFv.1FIT/Pv/0XhRFYWmS6020QJHd.tVwcO	2026-05-15 09:57:43.159552+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-124", "app_role": "volunteer", "last_name": "Shah", "first_name": "Shruti"}	\N	2026-05-15 09:57:43.159552+00	2026-05-15 09:57:43.159552+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	539a319d-7e31-4db7-8dec-7d04d92629d3	authenticated	authenticated	kashishmanojjain@gmail.com	$2a$06$c1B1TI11I25J6GHUAZCEDu51sU6Hkbp5wtwVMv4uE8jVlvl7iXz42	2026-05-17 06:16:22.605197+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-125", "app_role": "volunteer", "last_name": "Jain ", "first_name": "Kashish"}	\N	2026-05-17 06:16:22.605197+00	2026-05-17 06:16:22.605197+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e	authenticated	authenticated	shahnavyam2010@gmail.com	$2a$06$YnQi497vr4QJWRrBCDIXsua3JS6.d/OInA3e2S5in3PLkgM0UNDxa	2026-05-18 06:01:08.698131+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-127", "app_role": "volunteer", "last_name": "Shah", "first_name": "Navyam"}	\N	2026-05-18 06:01:08.698131+00	2026-05-18 06:14:30.941909+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	ecf01a58-0258-4666-b777-aabc6b516035	authenticated	authenticated	vikas_dairyproducts@yahoo.co.in	$2a$06$YD2jkpn5uPYzKBqmiOj2QOr86P6ZNXvbVdcgupAr9pt9UkGkHWoCq	2026-05-28 05:11:30.189762+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-128", "app_role": "volunteer", "last_name": "GULAB CHAND", "first_name": "PARMAR "}	\N	2026-05-28 05:11:30.189762+00	2026-05-28 05:11:30.189762+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	59cfdf9a-bef2-405a-9a65-3247132d7654	authenticated	authenticated	kajalsanghavi099@gmail.com	$2a$06$F5kXnL.vXThL8dXbxTVgVOKjoTtV6gCz6rI8NHnr42HoyaLLyOfeO	2026-05-31 07:14:13.34901+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-129", "app_role": "volunteer", "last_name": "Shah ", "first_name": "Kajal"}	\N	2026-05-31 07:14:13.34901+00	2026-05-31 07:14:13.34901+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: announcement_interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.announcement_interests (id, announcement_id, volunteer_id, created_at) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.announcements (id, title, message, created_by, created_at, type, project_id, deadline) FROM stdin;
\.


--
-- Data for Name: app_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_roles (id, user_id, role, created_at) FROM stdin;
9b9794c6-2c5a-4469-b182-1831b217710d	35c1bb89-4881-4798-a257-8b714d2017dd	admin	2026-02-06 14:21:41.506364+00
\.


--
-- Data for Name: event_interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_interests (id, event_id, volunteer_id, created_at) FROM stdin;
\.


--
-- Data for Name: event_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_registrations (id, project_id, full_name, whatsapp_number, age, address, sangh_name, payment_screenshot_url, created_at, email, dob, mobile_number, is_vihar_sevika, photograph_url, fathers_name, emergency_contact_name, emergency_contact_number, emergency_contact_relation, supported_file_url, payment_date, vihar_seva_head_name, vihar_seva_head_contact, mothers_name, contact_no_3, education_details, dharmik_education, hobbies, medical_information) FROM stdin;
bcc235b4-38cf-4143-a924-f489fde8180a	c3d175f3-dd6e-4000-bd32-ebe20b589705	Test	999999999	\N	ABCD	\N	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/event-payments/1773488297927-ark9x3oa6bc.jpeg	2026-03-14 11:38:21.440288+00	test@test.com	2000-01-01	9999999999	f	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/event-payments/photo-1773488298916-uskxg1up7lg.jpeg	ABC	XYZ	0000000000	POE	\N	2026-03-14	\N	\N	\N	\N	\N	\N	\N	\N
9e532f62-db25-4318-bf7d-62a9fb875fff	7b25f17b-43dc-431b-bd80-2a0033602e75	DrHardik Shah	9930409832	38	D-1403 , Viento Lakeshore Greens	Vimal Jin Sangh , Palava	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/event-payments/1776493397872-2o85rq0sh99.jpeg	2026-04-18 06:23:19.944446+00	dr.hardikshah10@gmail.com	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
90423711-fb6e-4f02-891e-cae84efc0688	7b25f17b-43dc-431b-bd80-2a0033602e75	Hardik Shah	9930409832	38	D-1403 , Viento , Lakeshore greens , Khoni Palava.	\N	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/event-payments/1776582085184-ayzy2kl2t7r.jpeg	2026-04-19 07:01:30.176592+00	dr.hardikshah05@gmail.com	1988-04-23	8850186491	f	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/event-payments/photo-1776582086417-2ab7028htfr.jpeg	Jaysukh Shah	\N	\N	\N	\N	2026-04-19	\N	\N	Sushila Shah	\N	B.D.S.	2 Pratikraman	\N	None
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, project_id, title, date, role_needed, description, created_at, banner_url) FROM stdin;
\.


--
-- Data for Name: ideas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ideas (id, title, description, project_id, submitted_by, status, admin_notes, created_at, updated_at) FROM stdin;
05e68f10-a7f0-4a35-8a8d-fd8761740b13	test	test	e371d3f0-7356-4f5b-8616-300df65bfea7	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending		2026-03-12 11:47:05.479552+00	2026-03-14 09:14:13.043+00
a5514528-705b-427d-b768-b70c0b31b1b4	test	test	\N	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	implemented	\N	2026-04-03 16:47:22.144528+00	2026-04-03 16:47:45.411+00
61e4a485-039a-4e84-a649-55a9708d02fe	Jainific passport	Everyone who enters gets a passport with their entry money for free or with cost, depends.And that passport will have different stall names according to age.Like if we think that young adults like teens should definitely visit a particular game we add it to the passport. The passport will also contain a map of the area where the event is being held. To help navigating their way through stalls annd know where exactly they wanna gom. It will also contain information about I❤️jinshashan as an organisation, its current projects, how we are built as an organisation and how we are functioning.	134f3fc8-8546-4bb3-b39a-e671bfcb0808	4842d49f-c3ea-47a4-bfee-03837bec04a5	reviewed	Thank you for your idea. We will definitely think on this. Just keep  Suggesting such  wonderful ideas	2026-04-03 04:08:32.10104+00	2026-04-06 15:29:20.976+00
922753ed-0f14-4c15-aa60-919d55699748	Difference between syadvad and anekantvad	I have generally observed between jain and non jain community that people are not clear with the difference between these two concepts. If some teacher or sir speaks about it ,the students are going to believe it irrespective of it being actually true or no..because sometimes teachers( especially of other communities) themselves dont the difference. It would be nice if it comes from sahebji's end so that we can explain and prove its authenticity.	\N	1faa2e14-2817-46d8-8f9e-5e7b70855a98	reviewed	Thank you for suggesting this idea. We have taken note of this.	2026-03-23 13:00:25.421875+00	2026-05-06 11:19:12.223+00
a179f147-d36d-41df-a4e5-e0d56b4f27bd	1 reflection Sunday - from content to change	While our current initiatives - reels, quizzes, and digital content...are highly engaging, there is an opportunity to further strengthen their impact by ensuring they lead to real-life behavioral change, not just consumption.\nI propose introducing a structured weekly initiative called “Reflection Sunday.”\nThe idea is to dedicate one day each week to pause, reflect, and assess how the content shared throughout the week has influenced individual actions.\nEvery Sunday, the community can be prompted with 2–3 simple yet meaningful questions such as:\nWhat is one value or practice you implemented this week?\nWhat motivated you to take that step?\nWhat challenges did you face while applying it?\nThis can be seamlessly integrated using existing platforms like WhatsApp or Instagram, or via a simple Google Form—requiring minimal additional resources.\nA few authentic responses can then be shared (with consent) to highlight real stories of change, thereby inspiring others within the community.\nThis initiative aligns strongly with the core philosophy of Jainism, particularly the practice of self-reflection and introspection (similar to Pratikraman), but reimagined in a format that resonates with today’s youth.\nProblem it addresses:\nCurrently, there is no structured mechanism to track whether our content is translating into meaningful personal growth or lifestyle changes.\nImpact:\nTransforms passive engagement into active implementation\nEncourages consistency in practicing values\nBuilds a culture of self-awareness and accountability\nStrengthens the emotional and spiritual depth of the community\nIn essence, this initiative can help evolve our platform from being content-driven to transformation-driven, creating a more lasting and meaningful impact.	deed7a1e-10f7-4f6a-906a-aac54bb1f619	d22fd755-c0a9-4474-8280-64d42c126700	reviewed	Can you please provide us a specific to-do list or a task Which Will help us to implement this idea	2026-03-24 02:40:07.398353+00	2026-04-06 15:25:35.545+00
2d6ae9e2-4747-4c0e-9d8c-e7a4c290d681	Script for drama: Be satisfied with what you have.	I have recently read a book written by Matt Haig. \nThe story of the book is like there is one girl with whom everything is going wrong in life and she commits suicide but instead of dying she reaches a library where she is offered to try numerous chances to undo the wrong decisions which she had taken due to which her life was bad. \n\nAfter experiencing numerous life she comes to conclusion that what she had in her life was far superior then what she experienced in other life even if it meant that she would have to struggle. \n\nMoral : Be happy with what you have. In event of chasing things which you dont you might end losing which you have.	\N	117f2d44-cb82-475c-bdf9-841f771649d5	pending	\N	2026-05-03 15:04:58.714203+00	2026-05-03 15:04:58.714203+00
1eb6d449-88a3-4013-b289-4096a696f437	test	test	9d2e0a72-e048-4e6d-90ab-7930a459f941	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	rejected	\N	2026-05-02 12:43:12.908588+00	2026-05-15 14:32:06.908+00
9d0830d7-b995-483a-9532-a285bd1d4b5e	Increment in members recruitment	We might start rewarding our members for refering new members to join lij in points.\nThe process might be, each member will get a special referal code (just like of influences) and while new registrations, they might get option to put the reference code which must reward the person registering and person referring...	\N	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-05-20 16:11:28.726554+00	2026-05-20 16:11:28.726554+00
5373b451-2eaa-4e4d-a343-5f9a993fce00	UI/UX design suggestions for Spiritual Tasks and gamification of the same	Currently in the Spiritual Task, one can only mark the task as completed if they have done that consistently for 7 days minimum but at times we do a task but it may happen consistently for 7 days. I had talked to Aayushi ben about this and was assured that even if we complete the task on 7 non-consecutive days, we can mark as complete which is very helpful. I do have 3 suggestions for this regardless:\n\n1) Instead of just marking it as complete, we can let volunteers mark as checkbox and have 7 boxes/circles so they can tick/mark it as and when they do because in todays busy schedule we often forget if we completed  6 days or 7 days and it can create wrong markings as well. And making ticks boxes also encourages us to tick multiple items in a day.\nExample - One day I read a book and sat in silence while also wrote things and people I am grateful about, I can individually mark all 3 tasks and see a progress bar which encourages me to stay consistent.\nThis also helps to do multiple things in a day as once the task is marked as completed, our psyche forgets about it and we may be less likely to continue for more than 7 days.\n\n2) Have it for more than 7 days, sure we can mark the task as completed once we hit the 7 mark checkpoint but it can reset and continue for more, this gamifies the process and encourages to continue in life more. Prime example would be of Duolingo, the language learning app. You hit 7 days mark of learning, hurray, now aim for 10 days and so one. It can either reset or continue, the later is prefered.\n\n3) Have the option to unmark/undo as well, if someone is browsing for the first time or if someone accidently marks it as complete, there is no way to go back, this also results in inaccuracy, once 7 days are consistently marked, it's submitted but prior to that, marking whole thing as one big task, atleast we can have an undo button to correct our mistakes.	\N	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-05-21 08:34:19.477881+00	2026-05-21 08:34:19.477881+00
\.


--
-- Data for Name: kiva_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.kiva_registrations (id, project_id, is_ilj_volunteer, ilj_id, full_name, mobile_number, preferred_dates, created_at) FROM stdin;
0874028e-6cf0-46e4-ac7c-9797ebafc670	1ba3dd33-5e3b-43b0-a272-a1a978804d39	f	\N	Shruti Shah	9372674176	Sat, 30 May 2026 to Sun, 31 May 2026	2026-05-15 09:55:03.105687+00
25c2d847-ef25-4268-85cd-6d2ca73148ec	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-050	Rutvi Sanghavi	9870175733	Sat, 30 May, 2026 to Sun, 31 May, 2026	2026-05-20 15:47:46.741823+00
7dbcc4ee-7413-46ed-937f-0c7f66edaf9b	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-030	Aayushi Shah	+919820583463	Sat, 6 Jun, 2026 to Sun, 7 Jun, 2026	2026-05-20 15:59:06.882574+00
dbbfe381-7f7a-40aa-9e2d-359222a4e9ac	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-002	A	8	Sat, 6 Jun, 2026 to Sun, 7 Jun, 2026	2026-05-20 18:36:16.782065+00
b5e273b4-683c-4c58-a0c4-b9b87944148e	1ba3dd33-5e3b-43b0-a272-a1a978804d39	f	\N	Aayushi Sanghavi	8657634527	Sat, 6 Jun, 2026 to Sun, 7 Jun, 2026	2026-05-20 18:54:51.047769+00
2ae48ccd-2a05-4ea5-896e-9f05ce4e0c7f	1ba3dd33-5e3b-43b0-a272-a1a978804d39	f	\N	Navyam nirav shah	8169800591	Sat, 23 May, 2026 to Sun, 24 May, 2026	2026-05-21 08:54:10.627189+00
2ff728ee-4a10-4250-b473-f7bb64bd3b4b	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-116	omkar kotak	9022312250	Sat, 6 Jun 2026 to Sun, 7 Jun 2026	2026-05-21 12:36:28.34306+00
58c10cef-43a7-4ed5-a3be-c1df51e1e916	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-002	Aayushi Sanghavi	8657634527	Sat, 6 Jun, 2026 to Sun, 7 Jun, 2026	2026-05-22 08:23:38.473292+00
6914d8c5-eed4-46a4-a1b2-247e63822a15	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-030	Aayushi Shah	+919820583463	Sat, 30 May, 2026 to Sun, 31 May, 2026	2026-05-25 11:55:53.43898+00
1c4226dd-8736-4db0-aa19-5b5472f210b0	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-116	omkar kotak	9022312250	Sat, 30 May 2026 to Sun, 31 May 2026	2026-05-25 12:36:39.529621+00
3bfa181f-fb9c-44be-bc7a-f4f1772edeba	1ba3dd33-5e3b-43b0-a272-a1a978804d39	t	ILJ-003	Jainam Sheth	8879355429	Sat, 30 May, 2026 to Sun, 31 May, 2026	2026-05-25 15:13:32.995184+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, message, is_read, type, created_at) FROM stdin;
\.


--
-- Data for Name: project_feedback; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_feedback (id, project_id, rating, comments, is_anonymous, created_at, name, mobile, email, age, city, is_featured, event_id) FROM stdin;
\.


--
-- Data for Name: project_inquiries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_inquiries (id, project_id, name, email, mobile, message, created_at, sangh_name, sangh_address, proposed_venue, proposed_dates, how_did_you_know) FROM stdin;
d270b742-9f14-44d8-a65f-ae902b23a27e	134f3fc8-8546-4bb3-b39a-e671bfcb0808	Meet  Mehta	mehtameet115@gmail.com	9172387009	test	2026-02-24 19:33:11.499001+00	\N	\N	\N	\N	\N
13679ab0-4547-4fe7-bef9-763187cd5745	8cb7137b-6d45-494b-afaa-b6e8019305c3	Aayushi Sanghavi	pritiaayu1@gmail.com	8657634527	Dombivali \nEstimated Participants: 50	2026-05-20 18:44:47.751963+00					
2b1b6490-7813-4361-86e6-179eb78c87e2	644691e8-6498-4d89-a46b-3f0184c94dc1	Navyam Shah	shahnavyam2010@gmail.com	8169800591	Where is the shibir?duration and time of shibir? Can j also bring my frnds along  who are not members here ?	2026-05-21 08:49:24.631249+00	\N	\N	\N	\N	\N
\.


--
-- Data for Name: project_photos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_photos (id, project_id, photo_url, created_at) FROM stdin;
c4bc8bc4-fe45-4757-88ec-d0b19abe686d	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320105400-i6vyjvuy7wf.jpg	2026-03-12 12:55:18.885382+00
8899321d-27a2-4d70-a95b-1d70026ccc13	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320106691-noog5u9erep.jpeg	2026-03-12 12:55:19.723381+00
0cae5277-c1c9-42ca-afd6-d07a22a6628d	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320107511-8a6eny7vw5b.jpeg	2026-03-12 12:55:20.437171+00
b50f94fe-495a-4ea7-b6b5-c0ccd2caa815	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320108221-szv8w3uxopg.jpeg	2026-03-12 12:55:21.208485+00
ee50e5fd-52f7-42d0-bdad-0b8d35788cf1	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320108997-7y7yayic9nv.jpeg	2026-03-12 12:55:21.996651+00
0ef3031c-7c5e-42c2-b44f-c36ea6c4e139	c3d175f3-dd6e-4000-bd32-ebe20b589705	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320109780-to3xzqcu3f7.jpeg	2026-03-12 12:55:22.675547+00
6ee360bd-99e0-43bf-a3c7-d5d2fa56676f	e371d3f0-7356-4f5b-8616-300df65bfea7	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320526539-d7312ufoc1d.jpg	2026-03-12 13:02:19.995199+00
d2f346b7-ee27-48ab-9849-4ecce327a112	e371d3f0-7356-4f5b-8616-300df65bfea7	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320527771-isq9yn9j0nj.jpg	2026-03-12 13:02:21.304106+00
fb716a5b-00e0-4261-a404-0897543f9919	e371d3f0-7356-4f5b-8616-300df65bfea7	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320529063-vcv6c7dem3.jpg	2026-03-12 13:02:22.109118+00
e4581858-ce9e-49c7-84aa-2c66ebf585e8	e371d3f0-7356-4f5b-8616-300df65bfea7	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773320530704-xssqixikkd.jpg	2026-03-12 13:02:24.033536+00
7ba4a255-8227-4523-b9f4-3182b85fdaf5	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460902163-mi4hfxggw.jpeg	2026-03-14 04:01:57.971873+00
e3010594-cea4-47ea-a23a-17fc0f332254	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460904225-4o842l2l777.jpeg	2026-03-14 04:01:58.807713+00
6e221fe0-266b-40fc-97d1-e7b98a4dc72f	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460905034-x4njpawnuro.jpeg	2026-03-14 04:01:59.515737+00
a07dbf2e-960e-4b79-bebd-7fe8ccc5858d	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460905708-ejhabbxmbcn.jpeg	2026-03-14 04:02:00.438659+00
ef2adf00-8621-48ab-a4c2-ee0382b7cf34	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460906627-88j9ehw4ka.jpeg	2026-03-14 04:02:01.118513+00
fd634020-a232-439e-8d05-553f1d1f91d8	134f3fc8-8546-4bb3-b39a-e671bfcb0808	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/1773460907315-io89vnshwq.jpeg	2026-03-14 04:02:01.979923+00
\.


--
-- Data for Name: project_volunteers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_volunteers (id, project_id, volunteer_id, assigned_at, status, engagement_status) FROM stdin;
9b2c1d07-aded-4d43-a076-10781c4752e2	7b25f17b-43dc-431b-bd80-2a0033602e75	b8f6d90e-b692-4a8a-8cbc-17909331fa73	2026-05-15 14:17:41.418809+00	approved	pending
4f26640c-7577-4c9f-b1cc-a4c5ad91ffd3	1736f19b-b817-4bc5-888b-a412f464e03a	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	2026-05-18 17:24:44.007997+00	approved	active
21095afa-ee0a-4836-b950-62424e2f436e	9d2e0a72-e048-4e6d-90ab-7930a459f941	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-18 17:25:36.980372+00	approved	pending
5d352eec-7488-4842-a8f6-a4707eeb5b0d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-29 14:11:26.5399+00	approved	pending
648a07b2-a1c9-4f13-91e2-6668a9e7d313	deed7a1e-10f7-4f6a-906a-aac54bb1f619	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-29 14:11:26.5399+00	approved	pending
21c40626-e7ed-4d45-b259-0b44e715aa4f	deed7a1e-10f7-4f6a-906a-aac54bb1f619	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	2026-05-29 14:11:26.5399+00	approved	pending
84e69fba-e5a8-42c3-b72e-d2c3586bf761	44528d4e-5308-46ba-aefe-275f5fd1dc71	41fcbca1-3193-42ce-8585-95372b4b9d52	2026-05-11 15:57:39.398506+00	approved	pending
6e7a0bea-d9ea-4aa1-81ef-1560c47a924b	c3d175f3-dd6e-4000-bd32-ebe20b589705	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	2026-05-14 15:10:33.780219+00	approved	active
e45f7741-fed2-4ece-a412-d6fba4044587	134f3fc8-8546-4bb3-b39a-e671bfcb0808	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-14 15:14:44.912429+00	approved	active
6fb10a1d-6572-4d87-a5ce-e53e6fd807e1	1ba3dd33-5e3b-43b0-a272-a1a978804d39	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-14 15:14:44.912429+00	approved	active
03f4bade-cd85-4fcf-b031-95f140a4ff28	07a9510b-0845-4adc-a964-cf115e1dff22	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-14 15:14:44.912429+00	approved	active
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, project_code, title, description, banner_url, manager_id, created_at, updated_at, status, visibility, next_event_date, is_event_registration_enabled, parent_project_id, registration_link, qna_link) FROM stdin;
644691e8-6498-4d89-a46b-3f0184c94dc1	PRJ-008-01	Reconnect: with Soul, Shasan and Nature	Unplug from the digital world and ground yourself in what matters. Reconnect offers a unique space to explore the harmony between your Soul, our Shasan, and the beauty of Nature. Join us to refresh your spirit and find your center.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.009730189570724579.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-14 14:46:44.348065+00	2026-05-14 14:46:44.348065+00	upcoming	public		f	7b25f17b-43dc-431b-bd80-2a0033602e75	https://example.com/register	https://example.com/qna
c3d175f3-dd6e-4000-bd32-ebe20b589705	PRJ-002	Veer Vanshaj: Self Defence Workshop	The Veer Vanshaj - Self Defence Workshop empowers individuals, especially women, with the skills and confidence to protect themselves in any situation. The initiative offers practical self-defence training, focusing on building physical strength, awareness, and mental resilience. Launched with the aim of ensuring safety and independence, the workshops have already gained momentum with multiple successful sessions. Our future vision includes expanding this impactful program across Mumbai, reaching more individuals in need of self-defence training.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.8871190093364836.jpeg	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-02-01 15:45:33.519938+00	2026-02-01 15:45:33.519938+00	upcoming	public	23 May 2026	t	\N	\N	\N
1ba3dd33-5e3b-43b0-a272-a1a978804d39	PRJ-009	KIVA	The name KIVA finds its roots in Prakrit, meaning कृपा (blessings). This initiative is built on the belief that by selflessly tending to the needs of animals, we receive their silent, powerful blessings in return.\n\nKIVA invites everyone to dedicate one weekend to mindful service in our partnered Panjrapols (animal sanctuaries) to engage in ground-level care, from feeding and grooming to assisting in the maintenance of the sanctuary.\n\nJoin us for two days of labor and love. Step away from the hustle of daily life and earn the "Kiva" of animals who have nowhere else to go.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.7953297959784796.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-06 16:29:49.183746+00	2026-05-06 16:29:49.183746+00	upcoming	public	\N	f	\N	\N	\N
e371d3f0-7356-4f5b-8616-300df65bfea7	PRJ-005	Sanskaar Library	The Sanskaar Library is an initiative designed to nurture reading habits and instill moral values in children through curated books. By creating a rotating library system that promotes morals, ethics, principles of Jainism and personal growth, we aim to build a foundation of knowledge and integrity among the younger generation.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.4307583412898245.jpeg	e243534f-6a49-436d-b637-a050b1e32de0	2026-02-02 12:46:26.885341+00	2026-02-02 12:46:26.885341+00	active	public		f	\N	\N	\N
9d2e0a72-e048-4e6d-90ab-7930a459f941	PRJ-006	IT & Tech	Developing and improving our official website into a comprehensive repository of Jain teachings, principles, stories, blogs, articles, and literature. Volunteers contribute by enhancing structure, usability, and content presentation to ensure all resources are available in one accessible digital space.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.9836200471240258.jpg	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-02-08 14:19:08.079624+00	2026-02-08 14:19:08.079624+00	active	private		f	\N	\N	\N
134f3fc8-8546-4bb3-b39a-e671bfcb0808	PRJ-003	Jainific	Jainific is an innovative exhibition designed to explore the intersection of ancient Jain principles and modern science. The exhibition features interactive models, charts, and experiments that demonstrate the compatibility of Jain teachings with scientific concepts.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.05016668586183837.jpeg	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-02-01 15:57:18.403327+00	2026-02-01 15:57:18.403327+00	upcoming	public		f	\N	\N	\N
07a9510b-0845-4adc-a964-cf115e1dff22	PRJ-011	People Management	People Management		7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-05-13 11:40:37.147418+00	2026-05-13 11:40:37.147418+00	active	private		f	\N	\N	\N
2f659c83-734d-47a1-bf62-17c5104e00e4	PRJ-012	Pathshala 	Pathshala 	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.748476061607198.jpg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-19 17:19:19.733371+00	2026-05-19 17:19:19.733371+00	upcoming	public	\N	f	\N	\N	\N
7b25f17b-43dc-431b-bd80-2a0033602e75	PRJ-008	Spiritual Shibir	Our Shibirs (spiritual retreats) are designed as immersive experiences to help you pause, reflect, and realign with your inner values. Moving beyond theoretical knowledge, these retreats focus on the practical application of ancient wisdom in our fast-paced, modern lives.\nWhether it is a single-day Sunday gathering or a multi-day intensive, each Shibir is crafted to be interactive, relatable, and deeply impactful. We combine traditional teachings with contemporary insights, ensuring the experience is accessible to today’s youth while staying rooted in core philosophical principles.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.8749523258806222.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-04-12 11:16:58.734146+00	2026-04-12 11:16:58.734146+00	upcoming	public	 31st Dec 2026 to 2nd Jan 2027	t	\N	\N	\N
8cb7137b-6d45-494b-afaa-b6e8019305c3	PRJ-010	REVA - Experience the Divine	REVA is a monthly devotional initiative designed to help you detach from the world’s noise. Experience devotion in its purest form, led by the ethereal and meditative vibrations of a handpan. With no loud instruments or distractions, we leave the chaos of the world behind to reconnect with our inner self and the Divine. Our venue changes every month to keep the experience intimate. Stay tuned for our next location as we invite you to join us, pause for a moment, and find your stillness.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.18227134542660983.png	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-07 17:19:56.834639+00	2026-05-07 17:19:56.834639+00	upcoming	public		f	\N	\N	\N
44528d4e-5308-46ba-aefe-275f5fd1dc71	PRJ-007	Admin work	Admin work not related to any particular project.		a59d9b96-eccd-4b3a-a15f-ad6f693013a7	2026-02-08 12:29:24.547887+00	2026-02-08 12:29:24.547887+00	active	private		f	\N	\N	\N
1736f19b-b817-4bc5-888b-a412f464e03a	PRJ-004	Knowledge and Blogs	Writing content for blogs on Jainism and related topics. These blogs are published on our website ilovejinshasan.org	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.08290226501735143.jpeg	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	2026-02-01 16:11:09.638868+00	2026-02-01 16:11:09.638868+00	active	public		f	\N	\N	\N
deed7a1e-10f7-4f6a-906a-aac54bb1f619	PRJ-001	Digital Jinshasan	Spreading the timeless wisdom of Jainism through modern channels. Our Promotion of Jainism on Social Media, primarily through the Instagram page @ilovejinshasan, seeks to inspire a global audience by highlighting the profound values and principles of Jain philosophy. Through engaging content  we aim to promote awareness and foster a deeper connection to Jainism. Our social media presence is steadily growing, empowering individuals to embrace teachings of Jainism in everyday life.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.7966996394579555.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-02-01 15:26:54.23616+00	2026-02-01 15:26:54.23616+00	active	public		f	\N	\N	\N
\.


--
-- Data for Name: reva_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reva_sessions (id, date, "time", venue, created_at, updated_at) FROM stdin;
9e991358-96a8-48ba-a4ef-d6ed491a5f0a	2026-05-17	19:00:00	Anand Nagar, Dahisar	2026-05-14 15:29:03.501529+00	2026-05-14 15:29:03.501529+00
96e484ea-1f68-43f5-a752-e6ebe98e8877	2026-05-24	19:00:00	Daulatnagar, Borivali (East)	2026-05-20 18:46:43.590149+00	2026-05-20 18:46:43.590149+00
\.


--
-- Data for Name: spiritual_task_assignments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spiritual_task_assignments (id, task_id, volunteer_id, status, completed_at, created_at) FROM stdin;
58278342-d9dc-44d2-8b65-9141219ecf70	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-03-14 15:52:39.41+00	2026-03-14 15:12:27.454791+00
20b8f2bd-d45c-438a-9817-ebbbc4f39f37	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-03-14 15:12:27.454791+00
4d0df84b-b37f-4a72-b211-78aee329f621	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-03-14 15:12:27.454791+00
27294aba-6068-4771-9e69-cd1c6495d127	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-03-14 15:12:27.454791+00
0ea7c7d7-d20b-4ed8-a00e-8de009162587	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-03-14 15:12:27.454791+00
a0ecbdb2-66a2-46fb-81be-4ca6cabd8436	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-03-14 15:12:27.454791+00
7bba8827-f446-4b52-b443-ee7d60cf02ad	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-03-14 15:12:27.454791+00
52f36de3-b06a-47ae-83ec-77ddf2b04fb0	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-03-14 15:12:27.454791+00
f7b55764-ddc7-4d9c-adaa-75c852d2841d	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-03-14 15:12:27.454791+00
bdc07df4-a158-41c9-8661-b7f2e8e89e0c	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-03-14 15:12:27.454791+00
8f54318c-9153-4070-a78d-d570311ef42d	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-03-14 15:12:27.454791+00
6a55a3f7-ded5-4284-8149-4f76445e192b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-03-14 15:12:27.454791+00
5ed16dd4-da56-4742-a3a8-3ceb9d2277f2	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-03-14 15:12:27.454791+00
8b6813d4-a663-4bac-93bf-767ae71913ce	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-03-14 15:12:27.454791+00
4d9800a3-60f7-4dfc-aeb7-aeb8bc5166f5	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-03-14 15:12:27.454791+00
b57deb3d-3e70-425e-b27c-01ca5bdf9ea4	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-03-14 15:12:27.454791+00
65326883-052d-4249-bf41-d2f1b56ec0c5	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-03-14 15:12:27.454791+00
d933117b-d08b-4145-8a2a-e04df197a1cd	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-03-14 15:12:27.454791+00
b8dd3f34-700a-405d-a546-61bfa041d476	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-03-14 15:12:27.454791+00
1e97e629-5761-42d5-8469-02d85c664224	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-03-14 15:12:27.454791+00
8e1f569b-c9ec-4247-a823-695e2821f0bd	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-03-14 15:12:27.454791+00
5c9c7f55-1703-4cba-9090-679f01930e4b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-03-14 15:12:27.454791+00
d95fa2c5-5241-4163-b3d1-b2c75af8eacc	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-03-14 15:12:27.454791+00
03dd3083-14fa-42d9-9eef-628cb836e140	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-03-14 15:12:27.454791+00
e0e784a7-f7e6-43b1-be1c-12a54ec87b93	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-03-14 15:12:27.454791+00
08dd4f7e-9e72-477b-bc5d-427cb9bf7b02	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-03-14 15:12:27.454791+00
69c4344f-c769-48da-be3a-3cb912d8a81e	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-03-14 15:12:27.454791+00
33149942-f0d7-49bb-9ff5-864f4eb71642	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-03-14 15:12:27.454791+00
9949449a-67fe-4854-b955-5f4137fdfa0b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-03-14 15:12:27.454791+00
95bb0da3-f078-4bcf-94d3-f23155ecfb25	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-03-14 15:12:27.454791+00
a0c8f02d-acad-4cb0-85b1-405f5ee4e6c6	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-03-14 15:12:27.454791+00
44161574-4b5d-4ed8-b882-44264b1ee846	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-03-14 15:12:27.454791+00
3e64ff05-8550-42c5-8d8c-048e18f466ad	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-03-14 15:12:27.454791+00
e47dbbe3-bd30-41f4-a442-9fc829b68bbb	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-03-14 15:12:27.454791+00
bcab2dd6-635f-4c08-be24-e9f9cf6b4cdc	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-03-14 15:12:27.454791+00
9a912893-d3dd-41f2-a653-2dad76e8edf7	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-03-14 15:12:27.454791+00
d40f14a8-1009-4fc8-8e1a-47dbd8cf6c96	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-03-14 15:12:27.454791+00
681bb967-821a-47fa-870f-2bbe8aff0032	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-03-14 15:12:27.454791+00
86ccd4e9-0396-4e84-9644-41af8ee0ce31	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-03-14 15:12:27.454791+00
c8bc7601-13ae-461a-b87d-0c42fce8eb26	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-03-14 15:12:27.454791+00
7ac1a5ca-6dcb-469d-a715-130af9743d7b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-03-14 15:12:27.454791+00
bd4d86c1-b0f0-4151-86bc-9a590a2c2a80	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-03-14 15:12:27.454791+00
27f1efe1-ec7b-43b5-bf62-b58f0f653ad4	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-03-14 15:12:27.454791+00
13d83b2f-b908-4b4c-aaa2-6ebef010c666	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-03-14 15:12:27.454791+00
4bc44650-6961-4e48-bf8b-8ef77f585040	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-03-14 15:12:27.454791+00
6c5beaab-acb5-4b3d-899e-42ff5ea79faa	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-03-14 15:12:27.454791+00
d6ed5745-3730-4a3c-a29a-cac488fb80f7	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-03-14 15:12:27.454791+00
911d0db4-d3e3-4d54-8efd-bb5443d77141	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-03-14 15:12:27.454791+00
d7b33701-d65c-4908-b0ad-ef6443cd9b7b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-03-14 15:12:27.454791+00
ac77a531-45aa-4290-be7a-1d599d8ed615	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-03-14 15:12:27.454791+00
1c7b8475-f8fb-4d2f-94ce-6afca4d33e7f	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-03-14 15:12:27.454791+00
cffa3cfa-35a2-496d-b464-c1d9109c32bf	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-03-14 15:12:27.454791+00
bb86cb4f-c074-4312-a526-d0aaacd8ad25	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-03-14 15:12:27.454791+00
d7448df1-9dc2-4688-9e10-0841a4c10863	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-03-14 15:12:27.454791+00
02a62c89-bba6-4c4d-b785-ce6008abcec9	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-03-14 15:12:27.454791+00
424c5dcf-145e-442d-8ea9-8fb998952204	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-03-14 15:12:27.454791+00
e710e235-1998-4ed1-8fb8-46f7c0e48874	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-03-14 15:12:27.454791+00
8b74f3df-c2f6-481b-b40c-22456f8f5301	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-03-14 15:12:27.454791+00
aa85d8d1-1c1a-4b9d-999a-1328bc608c21	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-03-14 15:12:27.454791+00
79660491-9d96-4631-ade8-0260fae3e119	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	d22fd755-c0a9-4474-8280-64d42c126700	pending	\N	2026-03-14 15:12:27.454791+00
aa0d1711-a585-4f44-b657-88561085bff2	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-03-14 15:12:27.454791+00
c4d65aa5-70f8-4710-a967-02e8a5a46984	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-03-14 15:12:27.454791+00
39a9f207-a338-46cf-be86-a0621037a094	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-03-14 15:12:27.454791+00
34c7ad83-f3f9-4727-bf4a-a88b340c13a8	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-03-14 15:12:27.454791+00
dba2e5d4-3166-4c8d-ac4b-e4f371ed6f3e	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-03-14 15:12:27.454791+00
0ed856cc-728f-459c-a26d-d295ffe47d30	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-03-14 15:12:27.454791+00
69a595a4-a5d4-4e4f-ae3b-a0b34d61ea25	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-03-14 15:12:27.454791+00
fb8a64b2-7876-4a3d-828c-e450a0769fe6	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-03-14 15:12:27.454791+00
804659b7-8fdc-4c0e-8a54-211d3f99d310	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-03-14 15:12:27.454791+00
83a81d0a-76ef-43d1-b430-bf240748215b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-03-14 15:12:27.454791+00
091ae704-8622-4a43-a51b-690357d396d4	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-03-14 15:12:27.454791+00
5f0f3af7-362c-4432-ad93-0474843168dd	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-03-14 15:12:27.454791+00
e0c89afb-c270-40c0-baa8-3805c16d1945	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-03-14 15:12:27.454791+00
625689fd-2a79-47ee-9b2e-12506ee205eb	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-03-14 15:12:27.454791+00
204d0ab9-4346-4a42-97c2-2096900f6d82	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	completed	2026-03-14 16:01:48.484+00	2026-03-14 15:12:27.454791+00
b677a971-b02c-4fa3-8f9e-4ba070e2f4b6	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	completed	2026-03-14 16:02:02.949+00	2026-03-14 15:12:27.454791+00
22f9c175-22a1-468e-9bf7-aaf83bbedefa	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-03-15 18:46:45.686+00	2026-03-14 15:12:27.454791+00
40ca3062-e6d5-4c4b-a60f-6b896d37bac0	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	03a59a7d-da67-44b8-88f7-1a0fbe44f706	completed	2026-03-16 15:18:33.061+00	2026-03-14 15:12:27.454791+00
e643ad32-b8b8-4de5-805e-c37e000f920b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	2c1bcdc5-0564-44d9-be4a-158445f39975	completed	2026-03-17 18:26:47.295+00	2026-03-14 15:12:27.454791+00
d48ddc61-c7e7-4701-86e3-091a3643aa81	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	32837c38-a21e-450a-8613-ec2c09f3cc97	completed	2026-03-17 18:29:18.822+00	2026-03-14 15:12:27.454791+00
9ecf5127-c261-467c-8d62-daebdf910483	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	completed	2026-03-20 14:02:14.548+00	2026-03-14 15:12:27.454791+00
016b3e1e-266e-47f4-be21-1ce584a7c40b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	3b54e716-c5a0-4d4c-a616-4e2e2be95539	completed	2026-04-05 18:27:39.072+00	2026-03-14 15:12:27.454791+00
f1e48920-e980-4557-a5cb-a874e1b5350b	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	dd8599b5-9989-4b14-9d33-6e4913e6693e	completed	2026-04-14 06:49:13.595+00	2026-03-14 15:12:27.454791+00
38129fd6-a57d-4136-8bf2-73c01738f599	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-04-19 12:53:52.032+00	2026-03-14 15:12:27.454791+00
2fb6383b-02a0-4850-999b-d1626d152bdd	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:48.586+00	2026-03-14 15:12:27.454791+00
ce6dc0d9-5759-4674-9168-9d4f9e5b8c38	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-03-14 15:12:27.454791+00
911899ab-cd8c-4a66-bf21-bee9b4dcff8c	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-03-14 15:12:27.454791+00
aa54420f-8b9d-4645-86c6-2d929c003700	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-03-14 15:12:27.454791+00
7a47f9a8-0906-4b18-a860-0c299c3ecdee	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-03-14 15:12:27.454791+00
44bc193e-f7d4-4dff-84cd-7bfb47c6e7c8	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-03-14 15:12:27.454791+00
a4b9ead4-5b2a-40b8-8c0b-6231c403b71f	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-03-14 15:12:27.454791+00
f34ee1f3-91ec-4a80-bcca-1cf64fd807fa	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-03-14 15:12:27.454791+00
a47ee694-9b05-4fdb-ba4d-1e193304c186	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-03-14 15:12:27.454791+00
087c1d72-69dd-40e6-920a-696a222f6e42	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-03-14 15:12:27.454791+00
9ba422ba-3133-4c38-a994-b84689a6baa8	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-03-14 15:12:27.454791+00
31e31c0a-7834-4d10-af10-c633fbf65e91	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-03-14 15:12:27.454791+00
ebc96d04-d19b-4cb4-abdc-3be74eb6d256	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	completed	2026-03-20 04:52:38.145+00	2026-03-14 15:12:27.454791+00
c06c541b-4cb1-41ab-8d16-c1839f323ecf	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	60084f34-305e-42b4-8330-70bba97a2126	completed	2026-03-20 18:59:56.28+00	2026-03-14 15:12:27.454791+00
18f16b72-b94a-4e08-a243-43254177607c	23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-03-20 19:00:43.862+00	2026-03-14 15:12:27.454791+00
3f8ff875-be8b-458a-ae76-cb4f649466cc	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-03-23 05:31:23.631292+00
a2d5e087-9234-4226-9f4b-3f2846171b46	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-03-23 05:31:23.631292+00
5dc8bbd4-643e-4c26-a7ce-b2afd7db4233	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-03-23 05:31:23.631292+00
857337e0-970c-4735-9dd9-21e6b1d5ea71	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-03-23 05:31:23.631292+00
51339765-76dc-4f58-a38e-76421b0a87b9	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-03-23 05:31:23.631292+00
57c836b9-a720-4165-a519-7c5c5a9e7a3b	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-03-23 05:31:23.631292+00
963fe412-f269-48eb-9637-5425797ef4d1	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-03-23 05:31:23.631292+00
434dcd22-dd0b-4664-94f7-78e9122d6721	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-03-23 05:31:23.631292+00
a564d0fb-4e0e-44ad-80a6-fdf7a8b2a344	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-03-23 05:31:23.631292+00
b96663eb-fa15-4488-a071-94509fe580b4	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-03-23 05:31:23.631292+00
7f200948-e4c9-4409-82bf-f235ec861b04	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-03-23 05:31:23.631292+00
32529fa0-7bcb-4011-af57-f9284aea84e2	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-03-23 05:31:23.631292+00
b325b781-9713-414e-b142-cc589b9f4abb	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-03-23 05:31:23.631292+00
3e57bc69-733b-4e24-bffc-153f1f6fbd31	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-03-23 05:31:23.631292+00
e92b201a-cd99-4dcf-9529-d36de3b9dc7b	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-03-23 05:31:23.631292+00
0384c5f7-99c5-4e83-ba00-40d39ffa7a7f	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-03-23 05:31:23.631292+00
64038d62-54da-44ed-948b-08a69a1247fc	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-03-23 05:31:23.631292+00
536627b7-dac3-4857-b57c-658bdb7fd6d9	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-03-23 05:31:23.631292+00
6355084f-84bf-4897-91d3-720a97227ab4	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-03-23 05:31:23.631292+00
b285d59b-3c36-453c-b2fb-8b854ec4787c	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-03-23 05:31:23.631292+00
f57d136e-ca45-444a-a5c0-59cfbb5aadb9	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-03-23 05:31:23.631292+00
9952f0cd-465b-472d-9f20-d09bfa66aae8	5ba72415-5ff8-4a25-aede-b919ffdbc917	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-05-26 16:32:32.349+00	2026-05-18 06:42:47.113639+00
c05888b2-4ccd-4599-99ff-b1ec61b51574	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-03-23 05:31:23.631292+00
bf192bb6-9dc6-4718-80fa-ab1db5d71907	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-03-23 05:31:23.631292+00
45056ecb-da0e-4474-b75c-0eece8ab1cdf	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-03-23 05:31:23.631292+00
49b21716-ccac-44db-9c57-7e3571845142	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-03-23 05:31:23.631292+00
ab61fcc2-9082-4f69-9466-2f7cb6efb2c4	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-03-23 05:31:23.631292+00
060506e5-8f63-4dec-834c-8b5abb506709	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-03-23 05:31:23.631292+00
c1d2c1e3-c748-434f-ab3e-d38e81792f4a	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-03-23 05:31:23.631292+00
ed86e337-d075-4647-8abc-aff04a9554e0	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-03-23 05:31:23.631292+00
5a78f943-2026-4801-92e2-e55df28c0498	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-03-23 05:31:23.631292+00
99bf68fc-de0c-42ea-8e27-b7c843bdbe7e	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-03-23 05:31:23.631292+00
153b7f2d-3491-4a23-991e-697beeb1b89d	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	pending	\N	2026-03-23 05:31:23.631292+00
d12f01fb-2581-428a-ade0-ab1aafc1101a	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-03-23 05:31:23.631292+00
a585d3f7-0d56-4862-8044-df762f92dafc	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-03-23 05:31:23.631292+00
6903ed10-4e21-47d0-b245-096994b06b9f	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-03-23 05:31:23.631292+00
b32dcb2c-37c8-439b-ba92-b47f91a9ba85	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-03-23 05:31:23.631292+00
fa4d084b-d629-437e-ba93-011e895451d8	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-03-23 05:31:23.631292+00
2385539b-ffe6-44f3-b2fe-ea1d3092c250	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-03-23 05:31:23.631292+00
fb28ae9b-0c41-40f2-9d1f-d30de5cd4810	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-03-23 05:31:23.631292+00
a87da2e8-a39e-451d-b555-58009a70abe5	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-03-23 05:31:23.631292+00
9c0fca5c-5f98-42d2-bbd6-379ff085fa23	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-03-23 05:31:23.631292+00
a08f0251-dde9-4c0a-9740-ffc1c63f7266	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-03-23 05:31:23.631292+00
3ecf5624-c601-4b93-aaf1-a4d2a95143a5	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-03-23 05:31:23.631292+00
8311f008-0f0b-46e4-a095-bc2aad408bc8	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-03-23 05:31:23.631292+00
f4d7e98b-9159-4e54-b08d-c6bce0ff3390	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-03-23 05:31:23.631292+00
6256064d-c879-4153-901c-0b5996a93ab6	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-03-23 05:31:23.631292+00
26706040-cdae-4ff3-ac0a-3b61a9c605e2	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-03-23 05:31:23.631292+00
3a08582a-fb84-408e-92b6-abe10128207d	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-03-23 05:31:23.631292+00
4f90672c-9037-442d-9411-9ca68113bae9	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-03-23 05:31:23.631292+00
e4702ff5-bdce-4feb-af93-3481aada183e	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-03-23 05:31:23.631292+00
94934262-5335-4b54-a320-1bb0d2fd5e57	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-03-23 05:31:23.631292+00
b9759c48-7f7f-4998-8257-44bcff0b2907	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-03-23 05:31:23.631292+00
04f85564-159c-481f-966f-4aafb7d5ab83	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-03-23 05:31:23.631292+00
dafc3917-9921-4bb8-a172-71c50497d966	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-03-23 05:31:23.631292+00
2a5b2d62-46b0-4d1c-b4ef-746c648efb91	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-03-23 05:31:23.631292+00
4418fc78-4ef1-4090-8e5f-4b868a21f7a3	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-03-23 05:31:23.631292+00
fb2ef919-27ac-407d-accf-22dc75f582aa	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-03-23 05:31:23.631292+00
53f958f7-2fcf-4e03-bb16-829bed336cd5	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-03-24 03:24:59.346+00	2026-03-23 05:31:23.631292+00
8b6fd4b1-dcee-4883-809d-2a23501b6704	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	completed	2026-03-24 14:58:45.536+00	2026-03-23 05:31:23.631292+00
23847582-cc75-44c8-9be3-38ca133ebecf	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-03-24 16:51:06.914+00	2026-03-23 05:31:23.631292+00
03945b0b-6b9f-4ac1-9be4-5d3decb7bd74	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-03-28 16:52:14.661+00	2026-03-23 05:31:23.631292+00
2a4e2a08-b618-4d2c-a0e7-245b265e938a	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	7e72384f-5a73-498c-b82e-57dd17a6ea18	completed	2026-03-29 06:36:28.168+00	2026-03-23 05:31:23.631292+00
5775f72e-8f97-4459-af2f-38401aba694f	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-03-31 11:26:12.481+00	2026-03-23 05:31:23.631292+00
8a136e62-0456-4cbf-a85a-548302bcf35b	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	completed	2026-04-02 18:55:51.265+00	2026-03-23 05:31:23.631292+00
f9fd76b7-ea4a-4a34-9358-c892226fb232	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	completed	2026-04-04 16:53:33.463+00	2026-03-23 05:31:23.631292+00
6af68e5d-5ead-4b6d-a36e-fb36044efc08	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	f854a439-e72d-44fc-8efe-a0f755462a04	completed	2026-04-05 08:04:17.051+00	2026-03-23 05:31:23.631292+00
6387f985-5430-4ca5-b4a3-659b2a12f2a8	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	3b54e716-c5a0-4d4c-a616-4e2e2be95539	completed	2026-04-05 18:27:37.765+00	2026-03-23 05:31:23.631292+00
857f31e8-49d8-4270-89a7-24dc9da1ac26	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:47.239+00	2026-03-23 05:31:23.631292+00
3a2e18bd-aac5-4b3a-93a9-a2cf2a0709be	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	232f55ca-9598-4daf-a8ef-5e9be124c975	completed	2026-05-11 06:15:50.608+00	2026-03-23 05:31:23.631292+00
687b7f64-c9e6-4e28-83c4-8e7f229e6c98	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-03-23 05:31:23.631292+00
311bc46e-2130-46d1-97ee-3ba4cd9e6d6c	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-03-23 05:31:23.631292+00
cfb73244-c6bf-44ec-80a2-c6d1375c2243	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-03-23 05:31:23.631292+00
4e18c4bd-96af-4708-a6ab-81ed304e6daf	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-03-23 05:31:23.631292+00
e6c396b8-96ff-4b6d-ae42-603e62e28d1b	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-03-23 05:31:23.631292+00
bb69a346-5180-45d4-a89c-165283840db8	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-03-23 05:31:23.631292+00
d5fc0344-dcb9-4972-b2da-07c915d6da05	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-03-23 05:31:23.631292+00
375cb554-c0f7-4c04-8f2a-16d99c905e63	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-03-23 05:31:23.631292+00
fe312807-cd35-4704-90d0-44399d04ade8	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-03-23 05:31:23.631292+00
5189896c-fe8a-4a45-8b5a-cb776effdc2b	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-03-23 05:31:23.631292+00
d57ba26c-5d7d-461e-9204-c98c006ca613	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-03-23 05:31:23.631292+00
5a2e60c1-02f1-4fc1-b411-b93af8f43908	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-03-23 05:31:23.631292+00
bd35453d-e09e-4454-b2ef-c2bf1da7b386	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-03-23 05:31:23.631292+00
29b3c2a2-4dbe-4d2c-b98b-a95c7c0f5b4d	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-03-23 05:31:23.631292+00
c6541d3b-3b77-4723-864f-0d91dd43a8d4	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-03-23 05:31:23.631292+00
b9e16d79-badf-4e3a-9830-a484c66a0904	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-03-23 05:31:23.631292+00
005c0381-9f1e-4585-8a40-448cfc742e35	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-03-23 05:31:23.631292+00
00bc5802-300b-4a6a-a228-3234f595da19	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-03-23 05:31:23.631292+00
0049c833-dbbc-4553-9075-90cd09808c22	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-03-23 05:31:23.631292+00
6313af71-90ec-4da3-80b1-9bc85347421c	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-03-23 05:31:23.631292+00
b6a2d657-d39e-4287-8e79-0684fd01e6a7	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-03-23 05:31:23.631292+00
6b267d25-8c24-4db0-8038-32b7cd6b3abf	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-03-23 05:31:23.631292+00
f2ba5bc5-3fac-412a-aeb5-13a60fa6c9a9	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-03-23 05:31:23.631292+00
9c1e15d5-f6ee-40c4-a877-988015b53049	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-03-23 05:31:23.631292+00
cb6eb895-d04d-44bf-a6c2-ce9ee6252105	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-03-23 05:31:23.631292+00
cc039d3c-ae26-40c2-b4f2-44fa710ca435	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-03-23 05:31:23.631292+00
7eb3c482-e629-49e0-8d52-9436d8e5602c	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-03-29 06:26:10.101+00	2026-03-23 05:31:23.631292+00
4ad000eb-3fe9-43a6-b1a7-6df837bc6bce	58253918-bc28-4443-a9f2-31f05e65a9aa	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-03-30 06:01:11.528465+00
28611672-79d9-4e4d-9f8f-ed2d6c411908	58253918-bc28-4443-a9f2-31f05e65a9aa	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-03-30 06:01:11.528465+00
4f5ffe96-cf33-4db6-934f-d4bd8e026906	58253918-bc28-4443-a9f2-31f05e65a9aa	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-03-30 06:01:11.528465+00
ca3c2ce4-d69d-4e7c-bc4d-61cf0d8b25be	58253918-bc28-4443-a9f2-31f05e65a9aa	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-03-30 06:01:11.528465+00
222f9352-3ed4-4d31-99e0-d78cee979e7b	58253918-bc28-4443-a9f2-31f05e65a9aa	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-03-30 06:01:11.528465+00
986dbed8-b97d-478f-ab33-a6c40ca99806	58253918-bc28-4443-a9f2-31f05e65a9aa	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-03-30 06:01:11.528465+00
ee3805ee-9407-405d-9eef-2d9fe193234f	58253918-bc28-4443-a9f2-31f05e65a9aa	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-03-30 06:01:11.528465+00
152330d0-87f7-4a6f-9450-312d336c2232	58253918-bc28-4443-a9f2-31f05e65a9aa	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-03-30 06:01:11.528465+00
88cdb34c-00fb-4c36-a70e-85ca218290e4	58253918-bc28-4443-a9f2-31f05e65a9aa	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-03-30 06:01:11.528465+00
92d34008-ee4e-489b-b612-7c8317801d58	58253918-bc28-4443-a9f2-31f05e65a9aa	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-03-30 06:01:11.528465+00
9b352780-eda1-46dd-b063-4d01d695ed04	58253918-bc28-4443-a9f2-31f05e65a9aa	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-03-30 06:01:11.528465+00
c379b11c-2097-4e96-81f0-ffa299e2be61	58253918-bc28-4443-a9f2-31f05e65a9aa	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-03-30 06:01:11.528465+00
29b145de-7cc2-49e2-9765-0966ec6d4c55	58253918-bc28-4443-a9f2-31f05e65a9aa	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-03-30 06:01:11.528465+00
aea90e14-af89-4402-9e1c-97d805565a69	58253918-bc28-4443-a9f2-31f05e65a9aa	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-03-30 06:01:11.528465+00
2846cf47-dba6-495c-96a4-f78bd54a48a1	58253918-bc28-4443-a9f2-31f05e65a9aa	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-03-30 06:01:11.528465+00
f8c86aca-7ee9-43a0-9778-adff36bafd27	58253918-bc28-4443-a9f2-31f05e65a9aa	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-03-30 06:01:11.528465+00
bf6c9815-ea44-48fa-bacb-5f2c109fd0a8	58253918-bc28-4443-a9f2-31f05e65a9aa	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-03-30 06:01:11.528465+00
e15e22c4-743b-42d7-97c6-7b7681928d6a	58253918-bc28-4443-a9f2-31f05e65a9aa	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-03-30 06:01:11.528465+00
85553eb7-e68a-4f02-a5c4-8681e65d472a	58253918-bc28-4443-a9f2-31f05e65a9aa	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-03-30 06:01:11.528465+00
f3a878cc-364e-4e5a-8914-3fa106279d49	58253918-bc28-4443-a9f2-31f05e65a9aa	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-03-30 06:01:11.528465+00
5667549f-96c7-4700-a722-7e26e07d0e2e	58253918-bc28-4443-a9f2-31f05e65a9aa	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-03-30 06:01:11.528465+00
d896462e-426b-4261-a1b8-0607309a97c9	58253918-bc28-4443-a9f2-31f05e65a9aa	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-03-30 06:01:11.528465+00
2a6bcbed-2ba6-4698-8c57-176ce6b87d71	58253918-bc28-4443-a9f2-31f05e65a9aa	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-03-30 06:01:11.528465+00
730b58ec-a984-495f-9310-f61dae3ebbd4	58253918-bc28-4443-a9f2-31f05e65a9aa	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-03-30 06:01:11.528465+00
a3c9f90f-6cc4-4a08-894b-d3f9040c25c1	58253918-bc28-4443-a9f2-31f05e65a9aa	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-03-30 06:01:11.528465+00
778e6a43-ca1b-4be2-b71c-80af71716d23	58253918-bc28-4443-a9f2-31f05e65a9aa	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-03-30 06:01:11.528465+00
a2a042b7-c7bb-47c6-84d9-91265c9147b1	58253918-bc28-4443-a9f2-31f05e65a9aa	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-03-30 06:01:11.528465+00
3c2530d5-2358-4bfc-9767-e79562ad4241	58253918-bc28-4443-a9f2-31f05e65a9aa	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-03-30 06:01:11.528465+00
1a2bf0b7-3580-49b7-b1a3-71d0e8802368	58253918-bc28-4443-a9f2-31f05e65a9aa	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-03-30 06:01:11.528465+00
64a4cf52-8657-4590-96fd-ec5953ff5a96	58253918-bc28-4443-a9f2-31f05e65a9aa	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-03-30 06:01:11.528465+00
36614ced-5716-4526-9796-82a24f4a6cc4	58253918-bc28-4443-a9f2-31f05e65a9aa	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-03-30 06:01:11.528465+00
35897386-6d1e-4dc3-87e6-4ab70f4ec171	58253918-bc28-4443-a9f2-31f05e65a9aa	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-03-30 06:01:11.528465+00
4d3ca5b2-5f52-4396-b655-37ced577395f	58253918-bc28-4443-a9f2-31f05e65a9aa	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-03-30 06:01:11.528465+00
0accf05c-c57e-4f1d-8e73-91826db47ef0	58253918-bc28-4443-a9f2-31f05e65a9aa	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-03-30 06:01:11.528465+00
77e31045-241f-414d-9361-2e3c7acaec64	58253918-bc28-4443-a9f2-31f05e65a9aa	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-03-30 06:01:11.528465+00
22d80bf2-923b-4882-ac16-f2ef34cd7309	58253918-bc28-4443-a9f2-31f05e65a9aa	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-03-30 06:01:11.528465+00
00958fa9-f411-43f3-b048-fa872c115eff	58253918-bc28-4443-a9f2-31f05e65a9aa	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-03-30 06:01:11.528465+00
72d5b2ac-6e28-439c-97f8-6755fc44c7f4	58253918-bc28-4443-a9f2-31f05e65a9aa	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-03-30 06:01:11.528465+00
6b0d2111-b461-4f9e-9227-cb49f1471a23	58253918-bc28-4443-a9f2-31f05e65a9aa	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-03-30 06:01:11.528465+00
5257ff71-1c57-4be4-9d97-dcd8d3d18228	58253918-bc28-4443-a9f2-31f05e65a9aa	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-03-30 06:01:11.528465+00
6e694350-7b54-4967-91e5-5d665140aef1	58253918-bc28-4443-a9f2-31f05e65a9aa	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-03-30 06:01:11.528465+00
9a804354-9321-4a2b-a463-2ac320ab0525	58253918-bc28-4443-a9f2-31f05e65a9aa	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-03-30 06:01:11.528465+00
9599bc69-af29-42a3-8e64-76233e5369f6	58253918-bc28-4443-a9f2-31f05e65a9aa	2c1bcdc5-0564-44d9-be4a-158445f39975	completed	2026-03-30 07:18:46.438+00	2026-03-30 06:01:11.528465+00
b93d24fb-6c06-4490-887c-b05e40bcb2d2	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	60084f34-305e-42b4-8330-70bba97a2126	completed	2026-03-30 18:50:10.487+00	2026-03-23 05:31:23.631292+00
4286d4d7-9f20-4c82-8420-342372d3bcaa	58253918-bc28-4443-a9f2-31f05e65a9aa	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-04-03 03:59:53.12+00	2026-03-30 06:01:11.528465+00
9ddc700e-6051-446b-a754-62533e3379ed	58253918-bc28-4443-a9f2-31f05e65a9aa	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	completed	2026-04-02 18:55:35.723+00	2026-03-30 06:01:11.528465+00
440b85cb-f371-4df0-9cbe-0532e36413a8	58253918-bc28-4443-a9f2-31f05e65a9aa	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	completed	2026-04-03 16:57:50.174+00	2026-03-30 06:01:11.528465+00
04bb382a-00c6-4afe-b3f9-8e264e476f96	58253918-bc28-4443-a9f2-31f05e65a9aa	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	completed	2026-04-04 16:53:32.143+00	2026-03-30 06:01:11.528465+00
9cdfa2b8-d7b9-4886-a763-e0cea392e324	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	completed	2026-04-05 05:36:11.698+00	2026-03-23 05:31:23.631292+00
602215d9-d0f8-4e90-aa60-f905334fdf93	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	completed	2026-04-05 08:21:56.418+00	2026-03-23 05:31:23.631292+00
0713d954-1746-4ca6-a90a-e90ad6bbe20a	58253918-bc28-4443-a9f2-31f05e65a9aa	3b54e716-c5a0-4d4c-a616-4e2e2be95539	completed	2026-04-05 18:27:36.2+00	2026-03-30 06:01:11.528465+00
4f72184e-0e41-4eab-a016-2a1b0f7e76f4	58253918-bc28-4443-a9f2-31f05e65a9aa	4de93087-ee99-48dc-b3a5-4339c8da81ec	completed	2026-04-06 06:18:06.349+00	2026-03-30 06:01:11.528465+00
5e093a42-f3b3-43ef-a33d-8677e7146bf1	58253918-bc28-4443-a9f2-31f05e65a9aa	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-04-06 17:34:08.452+00	2026-03-30 06:01:11.528465+00
46f7012e-ba86-4270-9c7c-53fd876c9853	58253918-bc28-4443-a9f2-31f05e65a9aa	dd8599b5-9989-4b14-9d33-6e4913e6693e	completed	2026-04-14 06:49:09.516+00	2026-03-30 06:01:11.528465+00
d6b1710e-c8cf-47a6-b209-e4bd21be8e67	58253918-bc28-4443-a9f2-31f05e65a9aa	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-04-19 12:53:36.526+00	2026-03-30 06:01:11.528465+00
65db5a5d-3d85-436d-8bd3-58eb3d3977f4	58253918-bc28-4443-a9f2-31f05e65a9aa	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:45.391+00	2026-03-30 06:01:11.528465+00
913d6d93-9ff6-47e4-a643-f033e81433eb	58253918-bc28-4443-a9f2-31f05e65a9aa	f51b0111-f04d-453a-b6c0-60d9832fba6b	completed	2026-05-21 07:12:48.542+00	2026-03-30 06:01:11.528465+00
357e938e-5442-42b8-b149-a246b081bd16	58253918-bc28-4443-a9f2-31f05e65a9aa	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-03-30 06:01:11.528465+00
37e0c5fe-1c58-47e9-a7a4-212c7752b371	58253918-bc28-4443-a9f2-31f05e65a9aa	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-03-30 06:01:11.528465+00
002708ba-57de-4932-b557-d19f687987d4	58253918-bc28-4443-a9f2-31f05e65a9aa	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-03-30 06:01:11.528465+00
97adfc94-0f06-45f7-a32a-16009e280c33	58253918-bc28-4443-a9f2-31f05e65a9aa	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-03-30 06:01:11.528465+00
18df415f-9f63-440e-9b95-fb712de8ab15	58253918-bc28-4443-a9f2-31f05e65a9aa	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-03-30 06:01:11.528465+00
2952c31c-41ed-439a-9072-66557d44ca28	58253918-bc28-4443-a9f2-31f05e65a9aa	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-03-30 06:01:11.528465+00
f3890bfc-c809-43f6-b530-3a1c17df307e	58253918-bc28-4443-a9f2-31f05e65a9aa	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-03-30 06:01:11.528465+00
891932bd-082c-4837-9a40-6b1de2160586	58253918-bc28-4443-a9f2-31f05e65a9aa	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-03-30 06:01:11.528465+00
c0064500-70b2-4e25-a368-6f99ba9b66a1	58253918-bc28-4443-a9f2-31f05e65a9aa	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-03-30 06:01:11.528465+00
dc68ba8d-1aaf-4252-8d75-883f277633fd	58253918-bc28-4443-a9f2-31f05e65a9aa	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-03-30 06:01:11.528465+00
c6a4acb1-28dc-47e3-b6bf-873fbaf61427	58253918-bc28-4443-a9f2-31f05e65a9aa	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-03-30 06:01:11.528465+00
71f6fc89-25fc-4cf3-9c2d-2fd3d2141136	58253918-bc28-4443-a9f2-31f05e65a9aa	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-03-30 06:01:11.528465+00
44c32610-42b2-43f0-af47-998ec72f5193	58253918-bc28-4443-a9f2-31f05e65a9aa	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-03-30 06:01:11.528465+00
6b5e1be9-774e-4c0a-aed8-16cfd28938af	58253918-bc28-4443-a9f2-31f05e65a9aa	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-03-30 06:01:11.528465+00
98bd7e75-00bb-43bc-af95-10a3d62aebd9	58253918-bc28-4443-a9f2-31f05e65a9aa	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-03-30 06:01:11.528465+00
662880f4-32eb-44b2-b822-95f629e33fc4	58253918-bc28-4443-a9f2-31f05e65a9aa	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-03-30 06:01:11.528465+00
9ce8d606-4353-4485-99c8-9ba0372279f2	58253918-bc28-4443-a9f2-31f05e65a9aa	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-03-30 06:01:11.528465+00
e8e888c8-31c6-4de5-93ca-e12e51171632	58253918-bc28-4443-a9f2-31f05e65a9aa	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-03-30 06:01:11.528465+00
23efdb11-7f2e-4af2-af06-ae83236cdee1	58253918-bc28-4443-a9f2-31f05e65a9aa	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-03-30 06:01:11.528465+00
17bfd74d-e63e-4f96-b27a-376063a61e74	58253918-bc28-4443-a9f2-31f05e65a9aa	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-03-30 06:01:11.528465+00
571918bc-d9a6-497e-bad1-0e531f8e9291	58253918-bc28-4443-a9f2-31f05e65a9aa	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-03-30 06:01:11.528465+00
4eeb8c4c-3e51-4e94-bf58-7ae56f5d917b	58253918-bc28-4443-a9f2-31f05e65a9aa	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-03-30 06:01:11.528465+00
5a870611-bdca-40b1-a35f-7206473bd342	58253918-bc28-4443-a9f2-31f05e65a9aa	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-03-30 06:01:11.528465+00
3cd6c55d-2e89-4ed3-aa6c-746a56a07bcb	58253918-bc28-4443-a9f2-31f05e65a9aa	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-03-30 06:01:11.528465+00
4c55c9a9-a5d5-4496-a9d4-585ad54a190e	58253918-bc28-4443-a9f2-31f05e65a9aa	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-03-30 06:01:11.528465+00
fe99fa51-0943-4d4d-a5e8-8b9b42fc427a	58253918-bc28-4443-a9f2-31f05e65a9aa	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-03-30 06:01:11.528465+00
078362ab-11df-45bc-88f7-926e99269e25	58253918-bc28-4443-a9f2-31f05e65a9aa	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-03-30 06:01:11.528465+00
928c8849-8486-40d4-a8fa-d8fb042e548b	58253918-bc28-4443-a9f2-31f05e65a9aa	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-03-30 06:01:11.528465+00
5bf408cf-61df-462a-9a23-bdb019b3d32e	58253918-bc28-4443-a9f2-31f05e65a9aa	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-03-30 06:01:11.528465+00
36e7deb8-1fad-46d2-bce4-b6680c401053	58253918-bc28-4443-a9f2-31f05e65a9aa	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-03-30 06:01:11.528465+00
1a6fb922-8567-4114-8037-97d0658b41b6	58253918-bc28-4443-a9f2-31f05e65a9aa	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-03-30 06:01:11.528465+00
9e667bbc-0dae-4f9c-9c95-04d577eb5ebf	58253918-bc28-4443-a9f2-31f05e65a9aa	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-03-30 06:01:11.528465+00
a30c2c22-01ef-4ec9-affd-c6f6a13f5cdb	58253918-bc28-4443-a9f2-31f05e65a9aa	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-03-30 06:01:11.528465+00
bd2db2c9-32d2-4b8a-a148-bbec089ac95b	58253918-bc28-4443-a9f2-31f05e65a9aa	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-03-30 06:01:11.528465+00
4ced6f9e-25ec-451a-9c38-6054c1e9e98e	58253918-bc28-4443-a9f2-31f05e65a9aa	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-03-30 06:01:11.528465+00
d15353b2-2d35-4f32-9738-88eae946bf1c	58253918-bc28-4443-a9f2-31f05e65a9aa	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-03-30 06:01:11.528465+00
5d253e52-8c43-4fe0-b21d-ff6a2c13a37e	58253918-bc28-4443-a9f2-31f05e65a9aa	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-03-30 06:01:11.528465+00
e584fec8-bd8e-4ea0-9c57-0b12f83cfa99	58253918-bc28-4443-a9f2-31f05e65a9aa	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-03-30 06:01:11.528465+00
29d59666-74ba-4f20-b24c-464b59e343e0	58253918-bc28-4443-a9f2-31f05e65a9aa	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-03-30 06:01:11.528465+00
503eac9d-70ba-4f73-b74d-5dce315879a8	58253918-bc28-4443-a9f2-31f05e65a9aa	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-03-30 06:01:11.528465+00
85fed02b-d57b-48a6-b73b-6c86c1c20ced	58253918-bc28-4443-a9f2-31f05e65a9aa	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-03-30 06:01:11.528465+00
05dd7d92-4c07-4908-99c3-be06a1b723ec	58253918-bc28-4443-a9f2-31f05e65a9aa	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-03-30 06:01:11.528465+00
9e259a49-d38a-415f-a5a8-d3f539e73c88	58253918-bc28-4443-a9f2-31f05e65a9aa	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-03-30 06:01:11.528465+00
4ff2c86d-0b01-49da-b005-05b94e7de901	58253918-bc28-4443-a9f2-31f05e65a9aa	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-03-30 06:01:11.528465+00
1f23e669-3548-47dc-8e46-bb6d05977a29	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	2c1bcdc5-0564-44d9-be4a-158445f39975	completed	2026-03-30 07:18:49.069+00	2026-03-23 05:31:23.631292+00
b7256943-5f52-472c-aa28-0b1aa71b1524	58253918-bc28-4443-a9f2-31f05e65a9aa	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	completed	2026-03-31 06:03:28.886+00	2026-03-30 06:01:11.528465+00
216108b4-d20e-4162-97e8-70a8ac87df6e	58253918-bc28-4443-a9f2-31f05e65a9aa	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-04-04 17:28:34.318+00	2026-03-30 06:01:11.528465+00
116720e8-4a15-4b8b-8db3-b65d9d17f05f	58253918-bc28-4443-a9f2-31f05e65a9aa	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	completed	2026-04-05 05:36:03.387+00	2026-03-30 06:01:11.528465+00
56cd7cef-9aed-4814-8ae6-df658e2e42b3	58253918-bc28-4443-a9f2-31f05e65a9aa	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-04-05 05:57:24.8+00	2026-03-30 06:01:11.528465+00
0ad26bd4-fb56-4b0f-b8ef-cf1c7439c519	58253918-bc28-4443-a9f2-31f05e65a9aa	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	completed	2026-04-05 08:21:40.713+00	2026-03-30 06:01:11.528465+00
83e0d6dd-2dfb-48d0-9ba3-0ac740392ff5	113d7187-252f-40d4-a1ec-e258d6ed1923	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-04-06 06:16:10.125875+00
a73f2851-a061-46bb-b320-7274417d91e2	113d7187-252f-40d4-a1ec-e258d6ed1923	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-04-06 06:16:10.125875+00
06cdd0b9-c2f0-4c23-b740-514496bc1fcb	113d7187-252f-40d4-a1ec-e258d6ed1923	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-04-06 06:16:10.125875+00
e7b5b8bf-d7ac-4f6a-a7e7-64317115ee6a	113d7187-252f-40d4-a1ec-e258d6ed1923	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-04-06 06:16:10.125875+00
3a8e7b52-d9af-4101-b6c7-0e7181cc6e76	113d7187-252f-40d4-a1ec-e258d6ed1923	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-04-06 06:16:10.125875+00
8108777c-64ca-4b9a-b448-473cba2195c3	113d7187-252f-40d4-a1ec-e258d6ed1923	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-04-06 06:16:10.125875+00
cc062aeb-87c0-4ba0-af51-271c189c885c	113d7187-252f-40d4-a1ec-e258d6ed1923	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-04-06 06:16:10.125875+00
ad8f3569-dbc5-4fdc-85a8-ce403bccf19e	113d7187-252f-40d4-a1ec-e258d6ed1923	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-04-06 06:16:10.125875+00
f6cf210e-56e5-40fa-aeb8-0a37342a66c2	113d7187-252f-40d4-a1ec-e258d6ed1923	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-04-06 06:16:10.125875+00
edbd1079-b9e0-499b-beaf-4e947f5c011f	113d7187-252f-40d4-a1ec-e258d6ed1923	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-04-06 06:16:10.125875+00
f6803fc8-da53-41cc-8419-2b7fc6e2b7af	113d7187-252f-40d4-a1ec-e258d6ed1923	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-04-06 06:16:10.125875+00
88733c26-d1ea-42f1-a9ec-b0714f94b32a	113d7187-252f-40d4-a1ec-e258d6ed1923	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-04-06 06:16:10.125875+00
f5f4206f-e0e7-4f8a-b4a0-6fc1bda37b84	113d7187-252f-40d4-a1ec-e258d6ed1923	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-04-06 06:16:10.125875+00
910c2910-c8f8-4314-a9fc-2cab322bd05d	113d7187-252f-40d4-a1ec-e258d6ed1923	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-04-06 06:16:10.125875+00
c392a31b-db0b-4531-b16e-44068e9f7b08	113d7187-252f-40d4-a1ec-e258d6ed1923	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-04-06 06:16:10.125875+00
582a398f-9a83-4d1c-84b8-b3555114fe65	113d7187-252f-40d4-a1ec-e258d6ed1923	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-04-06 06:16:10.125875+00
45c53f8c-2b0f-4058-8cf4-1445405930d6	113d7187-252f-40d4-a1ec-e258d6ed1923	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-04-06 06:16:10.125875+00
6944256e-c468-45c9-8bc4-f1e3048c255c	113d7187-252f-40d4-a1ec-e258d6ed1923	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-04-06 06:16:10.125875+00
3f8b08c6-2a3f-439c-88ae-840832766265	113d7187-252f-40d4-a1ec-e258d6ed1923	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-04-06 06:16:10.125875+00
2a2f7fef-6857-4c82-80e4-eeb412648bec	113d7187-252f-40d4-a1ec-e258d6ed1923	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-04-06 06:16:10.125875+00
70aa236f-84b6-4dbe-a1da-458cc28bd2e3	113d7187-252f-40d4-a1ec-e258d6ed1923	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-04-06 06:16:10.125875+00
48381b53-5da2-4525-9ac1-7ddd0709d3bd	113d7187-252f-40d4-a1ec-e258d6ed1923	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-04-06 06:16:10.125875+00
4be037ae-43da-4368-ac79-6a3c3a08aa2b	113d7187-252f-40d4-a1ec-e258d6ed1923	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-04-06 06:16:10.125875+00
e1ddd766-aa9b-4d59-9957-7429c1455064	113d7187-252f-40d4-a1ec-e258d6ed1923	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-04-06 06:16:10.125875+00
5d60cbf0-1c3b-4b64-989c-aef7fb41086f	113d7187-252f-40d4-a1ec-e258d6ed1923	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-04-06 06:16:10.125875+00
fc695110-3721-44b3-8f16-f452a6fbd60b	113d7187-252f-40d4-a1ec-e258d6ed1923	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-04-06 06:16:10.125875+00
19e37bb6-b294-49db-879c-a25cfd70aaf6	113d7187-252f-40d4-a1ec-e258d6ed1923	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-04-06 06:16:10.125875+00
934f8fbf-1deb-4b6c-a399-afbaea639ff1	113d7187-252f-40d4-a1ec-e258d6ed1923	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-04-06 06:16:10.125875+00
e467c11e-77b8-4c54-983d-d453ade87928	58253918-bc28-4443-a9f2-31f05e65a9aa	b7a0ba40-6b70-461d-b806-4583cb44019a	completed	2026-04-11 03:33:28.163+00	2026-03-30 06:01:11.528465+00
46b019cf-d23f-4d7e-b117-0d1154622dbb	113d7187-252f-40d4-a1ec-e258d6ed1923	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-04-12 16:58:05.291+00	2026-04-06 06:16:10.125875+00
46a6fa51-7021-4ac1-8d2a-a2262b2bb47d	113d7187-252f-40d4-a1ec-e258d6ed1923	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-04-16 10:23:44.673+00	2026-04-06 06:16:10.125875+00
615da427-f8c7-4cb2-ab41-b6fa67ddb241	113d7187-252f-40d4-a1ec-e258d6ed1923	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-04-19 12:53:35.189+00	2026-04-06 06:16:10.125875+00
c045c7e9-19fd-4138-8507-39d7c8878d26	58253918-bc28-4443-a9f2-31f05e65a9aa	60084f34-305e-42b4-8330-70bba97a2126	completed	2026-04-19 15:21:39.886+00	2026-03-30 06:01:11.528465+00
cec8464a-64bb-4768-97a3-5ac8c0166e9e	58253918-bc28-4443-a9f2-31f05e65a9aa	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:33.27+00	2026-03-30 06:01:11.528465+00
3985f2ab-b190-4f24-b5e9-ce6d6c5acafa	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:37.177+00	2026-03-23 05:31:23.631292+00
87751021-cd3a-4606-a017-6778bde54bff	113d7187-252f-40d4-a1ec-e258d6ed1923	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-04-06 06:16:10.125875+00
23ba8c92-4f75-43f7-b699-006c0e30cd5c	113d7187-252f-40d4-a1ec-e258d6ed1923	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-04-06 06:16:10.125875+00
5e1be5ea-1453-4a57-a8b7-e6f40cd5ff7a	113d7187-252f-40d4-a1ec-e258d6ed1923	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-04-06 06:16:10.125875+00
b23fd3c4-5e02-4900-804b-5f3fb6926615	113d7187-252f-40d4-a1ec-e258d6ed1923	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-04-06 06:16:10.125875+00
23ead739-9d23-4a11-bcd6-0dcbbdf72890	113d7187-252f-40d4-a1ec-e258d6ed1923	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-04-06 06:16:10.125875+00
83f191ae-a640-4fc0-a20b-338c49f9a820	113d7187-252f-40d4-a1ec-e258d6ed1923	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-04-06 06:16:10.125875+00
b688f6af-f8e6-4f3a-b21b-6693ef368ddf	113d7187-252f-40d4-a1ec-e258d6ed1923	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:31.034+00	2026-04-06 06:16:10.125875+00
018a5d75-8bc0-4359-9bfa-5329b0c05155	113d7187-252f-40d4-a1ec-e258d6ed1923	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-04-06 06:16:10.125875+00
98e2b8f6-5b00-46fb-bb5d-37c8cee39666	113d7187-252f-40d4-a1ec-e258d6ed1923	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-04-06 06:16:10.125875+00
81c12c73-cacf-4aab-bb87-17685d33cd03	113d7187-252f-40d4-a1ec-e258d6ed1923	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-04-06 06:16:10.125875+00
fa649ffa-9e39-4365-b7d9-c993e8989394	113d7187-252f-40d4-a1ec-e258d6ed1923	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-04-06 06:16:10.125875+00
f0526d1e-1515-4481-90a0-acba00090b00	113d7187-252f-40d4-a1ec-e258d6ed1923	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-04-06 06:16:10.125875+00
69b11691-0191-483e-a56d-55a568c134fd	113d7187-252f-40d4-a1ec-e258d6ed1923	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-04-06 06:16:10.125875+00
328aa43f-f991-4fa9-8e1d-ca03dc4e8b95	113d7187-252f-40d4-a1ec-e258d6ed1923	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-04-06 06:16:10.125875+00
681ca274-f012-48d3-8bad-6a07033b1e31	113d7187-252f-40d4-a1ec-e258d6ed1923	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-04-06 06:16:10.125875+00
ebbdf4d2-4205-4a14-9700-3fa220a1680e	113d7187-252f-40d4-a1ec-e258d6ed1923	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-04-06 06:16:10.125875+00
1079be2b-34ef-4276-aabe-fe4fda2e325a	113d7187-252f-40d4-a1ec-e258d6ed1923	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-04-06 06:16:10.125875+00
53a7f2d2-5278-4ebf-907f-a3fa78d951a2	113d7187-252f-40d4-a1ec-e258d6ed1923	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-04-06 06:16:10.125875+00
a1a13d2b-1141-4ba6-bcd4-6a6c838a765b	113d7187-252f-40d4-a1ec-e258d6ed1923	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-04-06 06:16:10.125875+00
68c651af-71f1-4187-b8f1-2b65e857e11e	113d7187-252f-40d4-a1ec-e258d6ed1923	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-04-06 06:16:10.125875+00
aee83668-6b07-4c9b-a49d-032fd4716235	113d7187-252f-40d4-a1ec-e258d6ed1923	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-04-06 06:16:10.125875+00
34947814-b683-4c92-9508-38e48304d489	113d7187-252f-40d4-a1ec-e258d6ed1923	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-04-06 06:16:10.125875+00
1774a138-958d-464f-8d05-256b1c500009	113d7187-252f-40d4-a1ec-e258d6ed1923	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-04-06 06:16:10.125875+00
a6d365b2-e955-44c9-abf9-f38942b34917	113d7187-252f-40d4-a1ec-e258d6ed1923	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-04-06 06:16:10.125875+00
d10a7d14-bedc-4d5b-8b8e-a23e2adfaf31	113d7187-252f-40d4-a1ec-e258d6ed1923	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-04-06 06:16:10.125875+00
dbd439a3-08ff-4572-a107-e8999c180c9c	113d7187-252f-40d4-a1ec-e258d6ed1923	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-04-06 06:16:10.125875+00
60f42173-639e-43ed-9807-f067c770434f	113d7187-252f-40d4-a1ec-e258d6ed1923	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-04-06 06:16:10.125875+00
fab8f46e-8ab2-4782-a056-0c9d19404a3b	113d7187-252f-40d4-a1ec-e258d6ed1923	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-04-06 06:16:10.125875+00
007eb90c-70cd-4fa0-b5a6-71dd11f24fcc	113d7187-252f-40d4-a1ec-e258d6ed1923	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-04-06 06:16:10.125875+00
3a209792-0dde-40a7-968a-20e6b33f823e	113d7187-252f-40d4-a1ec-e258d6ed1923	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-04-06 06:16:10.125875+00
cce1582d-7fc9-4ff2-ae65-0229ef2142ff	113d7187-252f-40d4-a1ec-e258d6ed1923	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-04-06 06:16:10.125875+00
cbdebe57-b19d-44f1-b2b2-6f6f0fdd89ed	113d7187-252f-40d4-a1ec-e258d6ed1923	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-04-06 06:16:10.125875+00
dc06aeda-b1be-434a-a5c5-41b61a542df0	113d7187-252f-40d4-a1ec-e258d6ed1923	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-04-06 06:16:10.125875+00
510d22ad-1cc2-45be-beec-5b8bc605ea09	113d7187-252f-40d4-a1ec-e258d6ed1923	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-04-06 06:16:10.125875+00
f75031c4-be57-417f-86b0-659b1b34c0f1	113d7187-252f-40d4-a1ec-e258d6ed1923	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-04-06 06:16:10.125875+00
219db183-0457-4a9d-b668-3767ea96e2cd	113d7187-252f-40d4-a1ec-e258d6ed1923	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-04-06 06:16:10.125875+00
5f320738-007f-464c-9f39-3a75a0801e88	113d7187-252f-40d4-a1ec-e258d6ed1923	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-04-06 06:16:10.125875+00
26e232e8-dc3d-4831-9749-1d47fe67bd94	113d7187-252f-40d4-a1ec-e258d6ed1923	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-04-06 06:16:10.125875+00
595aa671-b671-47f9-aed8-68604c68a98b	113d7187-252f-40d4-a1ec-e258d6ed1923	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-04-06 06:16:10.125875+00
4e0addc8-4151-4c0e-8d57-c3cffe9178e7	113d7187-252f-40d4-a1ec-e258d6ed1923	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-04-06 06:16:10.125875+00
415591f4-91bf-421d-aabf-46b2c0232680	113d7187-252f-40d4-a1ec-e258d6ed1923	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-04-06 06:16:10.125875+00
3d2fa8af-cba2-4d2f-9789-b3db64b78245	113d7187-252f-40d4-a1ec-e258d6ed1923	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-04-06 06:16:10.125875+00
b63f030c-c4be-4930-afff-9f75e1ccb0d3	113d7187-252f-40d4-a1ec-e258d6ed1923	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-04-06 06:16:10.125875+00
d2eb79e1-affc-4426-a153-a587d6c329fe	113d7187-252f-40d4-a1ec-e258d6ed1923	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-04-06 06:16:10.125875+00
41cc6314-62cc-44aa-b616-09ad7912485c	113d7187-252f-40d4-a1ec-e258d6ed1923	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-04-06 06:16:10.125875+00
a4bb46be-a611-4c44-865c-79518e43b44f	113d7187-252f-40d4-a1ec-e258d6ed1923	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-04-06 06:16:10.125875+00
d09e408a-49b2-4309-ab26-7938c8ba443c	113d7187-252f-40d4-a1ec-e258d6ed1923	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-04-06 06:16:10.125875+00
cbb3728d-643f-46f7-ad1c-08e1329b6213	113d7187-252f-40d4-a1ec-e258d6ed1923	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-04-06 06:16:10.125875+00
e00d3b4f-6374-4d9d-83c2-9eddcc394f5b	113d7187-252f-40d4-a1ec-e258d6ed1923	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-04-06 06:16:10.125875+00
ae27ea44-ea60-45f5-a5f1-375b109d3f27	113d7187-252f-40d4-a1ec-e258d6ed1923	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-04-06 06:16:10.125875+00
2190ecee-288c-4591-a163-cfb6cf20f20f	113d7187-252f-40d4-a1ec-e258d6ed1923	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-04-06 06:16:10.125875+00
2ab92df0-e499-4a43-9112-f8d5ba35db5f	113d7187-252f-40d4-a1ec-e258d6ed1923	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-04-06 06:16:10.125875+00
dcecccaf-1420-4b93-a840-e7ded737c5db	113d7187-252f-40d4-a1ec-e258d6ed1923	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-04-06 06:16:10.125875+00
b6e52196-7bc8-427b-ad47-804fa3827212	113d7187-252f-40d4-a1ec-e258d6ed1923	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-04-06 06:16:10.125875+00
cdd5a284-133d-4f8a-8a82-c29e5ccbce39	113d7187-252f-40d4-a1ec-e258d6ed1923	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-04-06 06:16:10.125875+00
eface53c-33b6-4e3b-aab5-fded0d9c1bed	113d7187-252f-40d4-a1ec-e258d6ed1923	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-04-06 06:16:10.125875+00
bc3a9893-c80e-4e07-ba37-b43f309840fa	113d7187-252f-40d4-a1ec-e258d6ed1923	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-04-06 06:16:10.125875+00
a8be4b0a-a8b8-4f41-a383-a2019f0b2b9a	113d7187-252f-40d4-a1ec-e258d6ed1923	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-04-06 06:16:10.125875+00
f982b6b6-95fe-4afc-b25c-1fadc5476c6b	113d7187-252f-40d4-a1ec-e258d6ed1923	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-04-06 06:16:10.125875+00
bd307af3-7c88-4d3c-a846-f6dab57d6bd8	113d7187-252f-40d4-a1ec-e258d6ed1923	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-04-06 06:16:10.125875+00
a61545e8-42e9-47ef-aa0f-7ae37216238d	113d7187-252f-40d4-a1ec-e258d6ed1923	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-04-06 06:16:10.125875+00
f144bd24-d78c-4722-bc2c-ce1adcbf5285	113d7187-252f-40d4-a1ec-e258d6ed1923	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-04-06 06:16:10.125875+00
8a7f543f-f5bb-454a-9e8c-000a375545ed	113d7187-252f-40d4-a1ec-e258d6ed1923	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-04-06 06:16:10.125875+00
e1f047c3-ac7c-4f4c-8e95-dc64a95338d2	113d7187-252f-40d4-a1ec-e258d6ed1923	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-04-06 06:16:10.125875+00
51037320-30f9-4ac2-891d-21646c4f688e	113d7187-252f-40d4-a1ec-e258d6ed1923	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-04-06 06:16:10.125875+00
d6ea1108-ef26-4387-924b-722771dff8b7	113d7187-252f-40d4-a1ec-e258d6ed1923	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-04-06 06:16:10.125875+00
dd5b53c5-fb22-46a1-8c3c-efec5f444154	113d7187-252f-40d4-a1ec-e258d6ed1923	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-04-06 06:16:10.125875+00
4f7edc91-2698-4ffd-8c8b-3be2796ab2de	113d7187-252f-40d4-a1ec-e258d6ed1923	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-04-06 06:16:10.125875+00
23f86b79-5f84-42ba-92c8-d987dd6ee653	113d7187-252f-40d4-a1ec-e258d6ed1923	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-04-06 06:16:10.125875+00
d7d92ec6-c3a4-4015-a5f2-f98cd387ef25	113d7187-252f-40d4-a1ec-e258d6ed1923	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-04-06 06:16:10.125875+00
2de0f971-523e-4020-8799-609f5b45b95d	113d7187-252f-40d4-a1ec-e258d6ed1923	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-04-06 06:16:10.125875+00
be595794-07af-494c-a9bf-0b15c7aa6091	58253918-bc28-4443-a9f2-31f05e65a9aa	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-04-07 16:28:02.952+00	2026-03-30 06:01:11.528465+00
377a9743-88fd-4080-81bf-9be443ea2581	113d7187-252f-40d4-a1ec-e258d6ed1923	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	completed	2026-04-08 06:33:04.734+00	2026-04-06 06:16:10.125875+00
12372510-b3f6-4f79-a7df-475de3796a24	113d7187-252f-40d4-a1ec-e258d6ed1923	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-04-12 09:20:02.157+00	2026-04-06 06:16:10.125875+00
089807df-6e02-4d80-8de4-d82bd2606ceb	4e340c6a-9c8a-4e52-8e0a-957d42581f11	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-04-13 03:03:25.940077+00
b88b7ccb-c92b-4d9b-93de-d16bd9d18e09	4e340c6a-9c8a-4e52-8e0a-957d42581f11	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-04-13 03:03:25.940077+00
64629f14-2b35-4e4a-a77a-08281d75ef55	4e340c6a-9c8a-4e52-8e0a-957d42581f11	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-04-13 03:03:25.940077+00
58bfcf82-37b4-4ec3-ac2f-b689d5cf61db	4e340c6a-9c8a-4e52-8e0a-957d42581f11	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-04-13 03:03:25.940077+00
530ec9a0-51e8-406d-8355-3c27cc129018	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-04-13 03:03:25.940077+00
725fcdb1-2fc1-4977-8b52-ba5ee6c50d7f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-04-13 03:03:25.940077+00
9a33f633-54be-4c63-ac11-1ec1eb5aa5fc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-04-13 03:03:25.940077+00
8409a7eb-44dc-494b-890f-ca397134c947	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-04-13 03:03:25.940077+00
1fc00039-cd49-425f-9387-712001619045	4e340c6a-9c8a-4e52-8e0a-957d42581f11	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-04-13 03:03:25.940077+00
bc97ef14-be18-444d-b7c0-233509cab47f	113d7187-252f-40d4-a1ec-e258d6ed1923	60084f34-305e-42b4-8330-70bba97a2126	completed	2026-04-19 15:21:42.841+00	2026-04-06 06:16:10.125875+00
80786eff-3fee-4bcf-be32-1fc80a5eb3f5	113d7187-252f-40d4-a1ec-e258d6ed1923	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:44.237+00	2026-04-06 06:16:10.125875+00
2ccd959a-33d6-4a5d-abbe-7f685334c317	113d7187-252f-40d4-a1ec-e258d6ed1923	f854a439-e72d-44fc-8efe-a0f755462a04	completed	2026-05-17 06:48:00.92+00	2026-04-06 06:16:10.125875+00
ed2302da-2860-41ea-8acf-aa5e34dca6b3	4e340c6a-9c8a-4e52-8e0a-957d42581f11	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-04-13 03:03:25.940077+00
57cdcf5f-2f8a-4d54-9620-f83c808cf847	4e340c6a-9c8a-4e52-8e0a-957d42581f11	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-04-13 03:03:25.940077+00
9c5f49e5-4918-4511-9174-3371c98e143b	4e340c6a-9c8a-4e52-8e0a-957d42581f11	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-04-13 03:03:25.940077+00
45eae848-5b39-4fcc-af90-29515710458a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-04-13 03:03:25.940077+00
3ff36baf-2005-464a-add5-11259295fec9	4e340c6a-9c8a-4e52-8e0a-957d42581f11	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-04-13 03:03:25.940077+00
d5219989-2b8e-47f2-8ed7-91ad383d5e6e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-04-13 03:03:25.940077+00
0f8ad8c1-9bd3-47b9-b77b-ecd58386f1b1	4e340c6a-9c8a-4e52-8e0a-957d42581f11	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-04-13 03:03:25.940077+00
70d1e04e-072d-4dd3-b4ce-fc07e3998638	4e340c6a-9c8a-4e52-8e0a-957d42581f11	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-04-13 03:03:25.940077+00
387fc66c-13ce-4d0c-816a-850924bfc6b5	4e340c6a-9c8a-4e52-8e0a-957d42581f11	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-04-13 03:03:25.940077+00
90a9bf26-a3ce-439f-9f27-2abeea30a8bc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-04-13 03:03:25.940077+00
d18b609c-2da2-481e-a3c7-7fe570757076	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-04-13 03:03:25.940077+00
93f52b88-0187-43a6-a1a8-8c3c427a0e15	4e340c6a-9c8a-4e52-8e0a-957d42581f11	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-04-13 03:03:25.940077+00
7cbab641-59ed-4a2b-a4ea-926b9852b1f1	4e340c6a-9c8a-4e52-8e0a-957d42581f11	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-04-13 03:03:25.940077+00
af00b0e1-9cd5-43a3-9973-31f56df0de34	4e340c6a-9c8a-4e52-8e0a-957d42581f11	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-04-13 03:03:25.940077+00
1e332bf4-88ec-484a-9dce-714ddc297126	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-04-13 03:03:25.940077+00
6a09da0d-f6ff-4031-8ab6-92641676fd1a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-04-13 03:03:25.940077+00
fa1b3f28-cb04-4d87-ae91-3f6d0451842e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-04-13 03:03:25.940077+00
18f3dd66-a90b-4ede-a597-aa97bc28a647	4e340c6a-9c8a-4e52-8e0a-957d42581f11	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-04-13 03:03:25.940077+00
a5e0f982-f94f-4d2d-86a5-f8daeee06ccf	4e340c6a-9c8a-4e52-8e0a-957d42581f11	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-04-13 03:03:25.940077+00
473d5766-61e1-4382-ba11-8675f8db213e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-04-13 03:03:25.940077+00
da495186-4c5c-4a83-bd83-a339f0606b3d	4e340c6a-9c8a-4e52-8e0a-957d42581f11	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-04-13 03:03:25.940077+00
d91d8a2c-4b35-4f0c-a753-5c72881703b5	4e340c6a-9c8a-4e52-8e0a-957d42581f11	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-04-13 03:03:25.940077+00
0769de7f-f745-48e7-b27b-f56f190b60b6	4e340c6a-9c8a-4e52-8e0a-957d42581f11	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-04-13 03:03:25.940077+00
22e8e632-fe47-405f-83e6-6397c95cce0f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-04-13 03:03:25.940077+00
308cb8e3-11af-4b59-b7e0-0ee9a45e4f37	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-04-13 03:03:25.940077+00
34eee47f-f4e0-4392-a7c7-21d3044a6749	4e340c6a-9c8a-4e52-8e0a-957d42581f11	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-04-13 03:03:25.940077+00
eedbe9b3-d95c-4aac-b78e-3f7fa52e5f0e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:28.61+00	2026-04-13 03:03:25.940077+00
3b1af55d-4e2c-411d-a3e4-97e3d12fb9e2	4e340c6a-9c8a-4e52-8e0a-957d42581f11	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-04-13 03:03:25.940077+00
c44278ee-5d4d-4136-8708-3df768e9d71a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-04-13 03:03:25.940077+00
e1498cb6-de2e-4d9a-9c49-2378672df77b	4e340c6a-9c8a-4e52-8e0a-957d42581f11	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-04-13 03:03:25.940077+00
1fcbd017-87d7-4e9c-9368-8f44db686ec4	4e340c6a-9c8a-4e52-8e0a-957d42581f11	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	pending	\N	2026-04-13 03:03:25.940077+00
91146950-f623-4f35-83e2-35854c181092	4e340c6a-9c8a-4e52-8e0a-957d42581f11	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-04-13 03:03:25.940077+00
ff2af5f6-0dbe-4a77-a03e-01439a5536e6	4e340c6a-9c8a-4e52-8e0a-957d42581f11	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-04-13 03:03:25.940077+00
efe496d9-6564-4531-b343-622e9b68e92c	4e340c6a-9c8a-4e52-8e0a-957d42581f11	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-04-13 03:03:25.940077+00
ed909b46-e39c-4a90-b634-00e45f0cb2c2	4e340c6a-9c8a-4e52-8e0a-957d42581f11	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-04-13 03:03:25.940077+00
3e5f6fc6-e2a4-446d-a382-cfd3900ffbd8	4e340c6a-9c8a-4e52-8e0a-957d42581f11	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-04-13 03:03:25.940077+00
8823418c-4497-4489-8312-c4c66b265f2b	4e340c6a-9c8a-4e52-8e0a-957d42581f11	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-04-13 03:03:25.940077+00
16103f70-1e72-47e5-a848-2a6a53c5200a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-04-13 03:03:25.940077+00
0fae5673-e0c6-44eb-8aa6-d105a6c01ff4	4e340c6a-9c8a-4e52-8e0a-957d42581f11	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-04-13 03:03:25.940077+00
60e0f594-9f14-4121-b41c-08d5b89eb4cb	4e340c6a-9c8a-4e52-8e0a-957d42581f11	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-04-13 03:03:25.940077+00
740388a6-930d-41d5-af2e-e40839ed37d9	4e340c6a-9c8a-4e52-8e0a-957d42581f11	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-04-13 03:03:25.940077+00
ebf3b6e1-c03f-4351-b3d5-13eea20dc6dc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-04-13 03:03:25.940077+00
353c04b8-e7b0-417e-80eb-395913be7b0e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-04-13 03:03:25.940077+00
50ce704a-e46d-4e7a-b4c9-cda847bf6061	4e340c6a-9c8a-4e52-8e0a-957d42581f11	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-04-13 03:03:25.940077+00
a850c64a-8959-4741-9929-7236d9c3b9cc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-04-13 03:03:25.940077+00
c3ecca77-d9c8-444c-9144-8e8d8f185216	4e340c6a-9c8a-4e52-8e0a-957d42581f11	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-04-13 03:03:25.940077+00
febc918d-5175-4f14-8d21-9e0b5c88bd95	4e340c6a-9c8a-4e52-8e0a-957d42581f11	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-04-13 03:03:25.940077+00
62680981-c8d5-4243-9aa2-09a3512fd734	4e340c6a-9c8a-4e52-8e0a-957d42581f11	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-04-13 03:03:25.940077+00
dda5be37-133a-44e2-b378-bbc166fd168f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-04-13 03:03:25.940077+00
ae4f5aab-3ed1-40c4-8689-d14599840ac7	4e340c6a-9c8a-4e52-8e0a-957d42581f11	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-04-13 03:03:25.940077+00
2ef8a3f9-d913-470f-bbf1-e6a5cedfc5f8	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-04-13 03:03:25.940077+00
67023745-0ed9-472a-a152-c05735f7e84b	4e340c6a-9c8a-4e52-8e0a-957d42581f11	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-04-13 03:03:25.940077+00
c6f99cc5-ff73-4abc-a719-4b31cf3089cc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-04-13 03:03:25.940077+00
e8b5e8d3-5abe-4d56-8ec9-d6f4f6137600	4e340c6a-9c8a-4e52-8e0a-957d42581f11	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-04-13 03:03:25.940077+00
18507817-ed5b-4377-9c62-985d19c59182	4e340c6a-9c8a-4e52-8e0a-957d42581f11	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-04-13 03:03:25.940077+00
30100f64-44f7-46b1-b12f-16282cf541a3	4e340c6a-9c8a-4e52-8e0a-957d42581f11	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-04-13 03:03:25.940077+00
5700b4c6-0bbb-451f-b3cf-0210920dbdf2	4e340c6a-9c8a-4e52-8e0a-957d42581f11	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-04-13 03:03:25.940077+00
75fc3802-2931-4199-a820-f7620c93911e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-04-13 03:03:25.940077+00
184685b4-b243-4af7-8871-740269b4178c	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-04-13 03:03:25.940077+00
07359c6a-dd81-4a9f-b81a-df79b7ebd9e8	4e340c6a-9c8a-4e52-8e0a-957d42581f11	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-04-13 03:03:25.940077+00
440160fc-bcd9-4969-ab37-3e8b81b7e695	4e340c6a-9c8a-4e52-8e0a-957d42581f11	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-04-13 03:03:25.940077+00
d0e9f5e9-3cc4-461e-a2ae-96befc86ff47	4e340c6a-9c8a-4e52-8e0a-957d42581f11	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-04-13 03:03:25.940077+00
d32854bc-06ed-4b35-84b9-9c0e195d7fcd	4e340c6a-9c8a-4e52-8e0a-957d42581f11	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-04-13 03:03:25.940077+00
c19d7d2b-d7a6-4aa7-ac33-da1dac6f0056	4e340c6a-9c8a-4e52-8e0a-957d42581f11	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-04-13 03:03:25.940077+00
ecd199b0-ffda-4327-ba2a-5f156c01fea2	4e340c6a-9c8a-4e52-8e0a-957d42581f11	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-04-13 03:03:25.940077+00
1d36957d-41ce-4e7b-adf3-cd833120bf72	4e340c6a-9c8a-4e52-8e0a-957d42581f11	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-04-13 03:03:25.940077+00
39e0fa05-3902-4d35-8981-7393f8b7c136	4e340c6a-9c8a-4e52-8e0a-957d42581f11	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-04-13 03:03:25.940077+00
c40c51c1-8e93-47d1-8b74-d89bf4c0ef77	4e340c6a-9c8a-4e52-8e0a-957d42581f11	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-04-13 03:03:25.940077+00
85340269-8847-4f39-90ba-8027c2c0c092	4e340c6a-9c8a-4e52-8e0a-957d42581f11	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-04-13 03:03:25.940077+00
af54b241-2541-4b15-ac51-1a556eff1b12	4e340c6a-9c8a-4e52-8e0a-957d42581f11	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-04-13 03:03:25.940077+00
71a02fda-8d49-43b6-a73d-8a8b81020313	4e340c6a-9c8a-4e52-8e0a-957d42581f11	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-04-13 03:03:25.940077+00
aa43c356-29f3-499e-ab4c-9f889ee8c14f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-04-13 03:03:25.940077+00
b402b0f8-0a3c-46f2-bdcb-c04cf502868f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-04-13 03:03:25.940077+00
cbcd1e7e-978e-428b-99a1-65b801c7bbbb	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-04-13 03:03:25.940077+00
fa7840bf-a837-4d43-855b-72548169ebfc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-04-13 03:03:25.940077+00
08797513-a446-4f56-b5f9-de77eb104f25	4e340c6a-9c8a-4e52-8e0a-957d42581f11	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-04-13 03:03:25.940077+00
ab3e73d9-d149-4d48-9240-38bf27e51ab9	4e340c6a-9c8a-4e52-8e0a-957d42581f11	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-04-13 03:03:25.940077+00
9674200a-ec08-4c0f-9971-0ff4708e5223	4e340c6a-9c8a-4e52-8e0a-957d42581f11	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-04-13 03:03:25.940077+00
a7c63e0b-fad4-4955-abb8-d78fd6930a4a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-04-13 03:03:25.940077+00
b555dcdd-8354-4702-bb69-6ea2c83a62d3	4e340c6a-9c8a-4e52-8e0a-957d42581f11	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-04-13 03:03:25.940077+00
d3f59a84-8405-4df9-b18a-103f7481a372	4e340c6a-9c8a-4e52-8e0a-957d42581f11	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-04-13 03:03:25.940077+00
d5f69606-c1d5-491a-8b10-5d866376059b	4e340c6a-9c8a-4e52-8e0a-957d42581f11	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-04-19 12:53:40.896+00	2026-04-13 03:03:25.940077+00
b0c3c321-cf18-4315-a04d-3342494b5115	4e340c6a-9c8a-4e52-8e0a-957d42581f11	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-04-19 15:22:10.765+00	2026-04-13 03:03:25.940077+00
7c00a38b-5701-494e-9158-baa916ec2a84	4e340c6a-9c8a-4e52-8e0a-957d42581f11	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-04-20 01:35:40.929+00	2026-04-13 03:03:25.940077+00
6e18f4c5-73e1-4c84-8f26-a9c7c4007f7a	4e340c6a-9c8a-4e52-8e0a-957d42581f11	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:42.533+00	2026-04-13 03:03:25.940077+00
99594a41-7a11-46ea-8823-b32f702be293	4e340c6a-9c8a-4e52-8e0a-957d42581f11	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-05-21 06:57:35.064+00	2026-04-13 03:03:25.940077+00
880b0f42-6a72-4d8b-96ea-e1bd17fcb08e	4e340c6a-9c8a-4e52-8e0a-957d42581f11	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-04-13 03:03:25.940077+00
8ddca6e8-2586-46e8-9a95-d103adff40ae	4e340c6a-9c8a-4e52-8e0a-957d42581f11	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-04-13 03:03:25.940077+00
96ea2be6-2d72-4414-83aa-60091f62ffe1	4e340c6a-9c8a-4e52-8e0a-957d42581f11	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-04-13 03:03:25.940077+00
2c9cb91f-5a5d-4f0f-b89b-832a94319630	4e340c6a-9c8a-4e52-8e0a-957d42581f11	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-04-13 03:03:25.940077+00
441fa021-107b-47de-8dc3-5d4615ceab94	4e340c6a-9c8a-4e52-8e0a-957d42581f11	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-04-13 03:03:25.940077+00
77fd3dc0-0512-4b9e-b391-5f9f365946cc	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-04-13 03:03:25.940077+00
8e0bd0f7-07e6-4001-a92b-165a24cb2b76	4e340c6a-9c8a-4e52-8e0a-957d42581f11	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-04-13 03:03:25.940077+00
9385cd15-c242-461b-81e5-186dde8ac9ce	4e340c6a-9c8a-4e52-8e0a-957d42581f11	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-04-13 03:03:25.940077+00
192a0414-631c-4fe8-a0f2-c9b293201cd2	4e340c6a-9c8a-4e52-8e0a-957d42581f11	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-04-13 03:03:25.940077+00
f27db7a3-e31a-4b18-8798-b75b07122b35	4e340c6a-9c8a-4e52-8e0a-957d42581f11	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-04-13 03:03:25.940077+00
bc01e4bf-c80d-4703-992a-a40b5ea18d87	4e340c6a-9c8a-4e52-8e0a-957d42581f11	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-04-13 03:03:25.940077+00
c9e56c5a-c131-4c48-a29b-815d3bcbded5	4e340c6a-9c8a-4e52-8e0a-957d42581f11	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-04-13 03:03:25.940077+00
a6b4e776-8930-4ba3-94ef-be65170ed3d7	c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	dd8599b5-9989-4b14-9d33-6e4913e6693e	completed	2026-04-14 06:49:11.711+00	2026-03-23 05:31:23.631292+00
2a7cdb57-ed54-44b0-a8c5-0fc81399f7c0	113d7187-252f-40d4-a1ec-e258d6ed1923	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-04-14 07:08:39.139+00	2026-04-06 06:16:10.125875+00
f4f7fb9c-630d-47e5-8f9b-900f1bb895c8	113d7187-252f-40d4-a1ec-e258d6ed1923	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-04-19 05:49:00.076+00	2026-04-06 06:16:10.125875+00
3bf0999f-a40a-4c12-b476-4317c6d5a26f	4e340c6a-9c8a-4e52-8e0a-957d42581f11	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-04-19 05:49:05.787+00	2026-04-13 03:03:25.940077+00
dfa33fe6-88c6-4742-9731-849829965ed1	4e340c6a-9c8a-4e52-8e0a-957d42581f11	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	completed	2026-04-19 15:08:24.333+00	2026-04-13 03:03:25.940077+00
550c5884-6c68-44a6-af1e-1ac005de1d98	4e340c6a-9c8a-4e52-8e0a-957d42581f11	60084f34-305e-42b4-8330-70bba97a2126	completed	2026-04-19 15:21:48.063+00	2026-04-13 03:03:25.940077+00
9cd029e9-948c-4dc9-a895-3992e1fd061c	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-04-20 12:36:57.065493+00
e0c476c2-0270-4bfc-8c30-19fcd5c4b40d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-04-20 12:36:57.065493+00
8e2bd0a5-57a5-4340-8fc7-951c232c3750	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-04-20 12:36:57.065493+00
4a7b6aa5-69e3-4050-8103-c44f0aa969ee	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-04-20 12:36:57.065493+00
823ee636-1e41-4ef0-bbd6-46914dac530d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-04-20 12:36:57.065493+00
711c9643-df81-4d81-9aed-ee1b90a8e2ca	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-04-20 12:36:57.065493+00
b2ba3d70-52d9-47b2-b038-432002621547	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-04-20 12:36:57.065493+00
02d70fe1-ed78-4126-b657-7b7fee09be3e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-04-20 12:36:57.065493+00
6d20a144-aef0-4fb6-9f06-63bb1dd48050	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-04-20 12:36:57.065493+00
b301bcaf-651f-47e6-8347-03febcd4e626	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-04-20 12:36:57.065493+00
b5a6907e-b10e-4379-9c98-59101bb95f9d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-04-20 12:36:57.065493+00
36a6769e-88a6-41db-b2b5-5cfd6445f5ad	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-04-20 12:36:57.065493+00
53f506bc-81c6-4fba-b723-cb1c90b6e3d8	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-04-20 12:36:57.065493+00
3daf7b13-2703-48ca-a363-65e8d2d81a5e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-04-20 12:36:57.065493+00
fc642b93-4282-4561-85c4-04342d6f6e5e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-04-20 12:36:57.065493+00
82febd9b-db91-405f-bbeb-7fcfdc64a6b5	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-04-20 12:36:57.065493+00
e2e85d46-5e48-4bdb-9ec5-4b3cb445a2c2	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-04-20 12:36:57.065493+00
311045c9-b18a-4def-8473-fca1598dba80	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-04-20 12:36:57.065493+00
5502af35-9986-4596-aca3-036376f3615b	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-04-20 12:36:57.065493+00
b741ad36-77f3-43e4-bb0d-e57a0d3b550d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-04-20 12:36:57.065493+00
8ff26991-cd80-4cbb-ad97-756a0119a9a5	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-04-20 12:36:57.065493+00
867a86d1-7c11-4cf5-a3c3-3c0e7843779a	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-04-20 12:36:57.065493+00
1458a0e2-1049-4059-a537-8b10c3940d75	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-04-20 12:36:57.065493+00
2359e80f-cd61-4c0f-9724-1512e53ad977	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-04-20 12:36:57.065493+00
8a2c9663-5fc4-4236-a978-37e813b78cd8	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-04-20 12:36:57.065493+00
01976844-516f-41fb-ad12-c6d361c8fcdb	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	486cb7fe-4375-44d1-b124-e2460ab1826a	pending	\N	2026-04-20 12:36:57.065493+00
8a7ea873-04b5-4e5b-a544-81829c3b7b32	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-04-20 12:36:57.065493+00
1c8fc512-f531-4484-b2b2-d02321b64232	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-04-20 12:36:57.065493+00
86f1c031-f7c3-4d04-ad7d-960cf0113392	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-04-20 12:36:57.065493+00
8055dc27-1e7c-4824-acb7-81cd4c87ff2a	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-04-20 12:36:57.065493+00
e2482774-4609-482a-8799-a20c74bd8101	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-04-20 12:36:57.065493+00
8348da3a-c291-4976-86d8-88f7e9fba0fb	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-04-20 12:36:57.065493+00
f748f9a1-f547-4499-9165-71161ace96ff	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-04-20 12:36:57.065493+00
14e845a0-7a5b-44c6-97a4-0c5e32ea0d33	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-04-20 12:36:57.065493+00
13fbf52f-438d-46e2-8a91-034ed36f77bd	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-04-20 12:36:57.065493+00
72c95b2d-2e5b-462f-85d4-e01c301fd062	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-04-20 12:36:57.065493+00
faffc481-91df-411e-8025-1d28c12995fb	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-04-20 12:36:57.065493+00
d0409840-5b15-4d34-b30f-cd4352b93866	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-04-20 12:36:57.065493+00
ad22dcb8-4cb3-4abd-ab64-db5f22c44c50	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-04-20 12:36:57.065493+00
e15be574-0483-44e7-b160-46c9ea792771	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-04-20 12:36:57.065493+00
6e22e123-b062-4fef-a2cc-dedb3171168d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-04-20 12:36:57.065493+00
bc830189-4a7a-43d6-a49f-ea144ba8de8a	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-04-20 12:36:57.065493+00
eac522a9-eb75-4172-8eca-83ebd35ad89c	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-04-20 12:36:57.065493+00
870a4598-edd9-4bd5-9939-0411afc6e834	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-04-20 12:36:57.065493+00
b1ede5e2-bc2c-444b-bcdc-13dc5a7b5cac	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-04-20 12:36:57.065493+00
01b6ce66-557d-4b67-958e-70fa5d38378b	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-04-20 12:36:57.065493+00
bb116dae-1528-46d4-817e-853c2688d508	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-04-20 12:36:57.065493+00
dd94b2ea-8ccc-40a5-a8d4-fd65909bff56	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-04-20 12:36:57.065493+00
a87d91ca-aa07-48a8-93ae-a94a3ded57b9	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-04-20 12:36:57.065493+00
36dfddb0-83ff-4602-b5b6-11c0012fb193	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-04-20 12:36:57.065493+00
3c3be6ad-907e-40d7-9a2a-7795f70b1e52	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-04-20 12:36:57.065493+00
7f4a078a-3e22-4e98-ac7e-7636e08efadc	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-04-20 12:36:57.065493+00
878b98c0-dbe8-4b63-967d-899e5b1abaa5	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-04-20 12:36:57.065493+00
3af1e31e-5b0a-4957-a888-0a5df2e4a355	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-04-20 12:36:57.065493+00
ceec5450-eaa5-45cd-8e1a-e21b32069ff6	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-04-20 12:36:57.065493+00
91391158-169c-4252-a5a0-41b82b0e07b3	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-04-20 12:36:57.065493+00
49e73933-8730-4ce4-936d-015501e0afaf	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-04-20 12:36:57.065493+00
4b6c7134-da4f-4047-8a8c-b72405b5c6e6	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-04-20 12:36:57.065493+00
4875aa57-c5b4-488c-b2c0-e131e1e89493	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-04-20 12:36:57.065493+00
c18a9da4-f7e8-43c2-ad6b-181b39a9289e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-04-20 12:36:57.065493+00
8893605f-147c-44e7-bf4b-608ed95b68d0	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-04-20 12:36:57.065493+00
ee8629da-27d4-49aa-9a10-c3e79fa3d218	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-04-26 07:23:11.876+00	2026-04-20 12:36:57.065493+00
b56b69d8-c341-4f5c-9148-de7f4b0ee545	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	d4c73898-8bda-476d-a068-898c72460441	completed	2026-04-26 17:37:39.894+00	2026-04-20 12:36:57.065493+00
d4b754df-fa01-495a-9830-055d1b7a5671	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-05-01 17:35:30.491+00	2026-04-20 12:36:57.065493+00
fc6b9185-5d1d-401f-99e4-9273346cf6ca	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-05-03 07:10:22.303+00	2026-04-20 12:36:57.065493+00
a1aa7be8-a838-48e0-9861-00b1ab4707af	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	232f55ca-9598-4daf-a8ef-5e9be124c975	completed	2026-05-11 06:15:41.761+00	2026-04-20 12:36:57.065493+00
ba594d2f-570b-4913-8f34-bc7614d9ea08	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-05-18 14:20:32.817+00	2026-04-20 12:36:57.065493+00
ec2aab39-9961-42c2-a5b3-c0f67a03ec0d	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-04-20 12:36:57.065493+00
cb271b2c-b73a-4c14-8c90-d95c9e1d178b	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-04-20 12:36:57.065493+00
81f99c05-2cbc-4f7d-9afe-5473eb82c68c	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-04-20 12:36:57.065493+00
0b32f2a4-6701-4333-b8b6-8692bb12c045	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-04-20 12:36:57.065493+00
27978d40-25c6-4923-ad45-14d62c62bd21	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-04-20 12:36:57.065493+00
ff1aad69-fe7f-45e0-bf33-c91a967444bc	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-04-20 12:36:57.065493+00
fe470d00-8f0a-4ad5-ae86-561b59c95533	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-04-20 12:36:57.065493+00
161cb89d-46c1-4d25-be14-1c76fb1c374e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-04-20 12:36:57.065493+00
0431fc3e-0c82-4f79-9c9b-0f4bb4168482	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-04-20 12:36:57.065493+00
aa656217-a4f3-4a2a-917e-2f71e6a2a4d3	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-04-20 12:36:57.065493+00
1aebb855-f417-47b7-9dbf-5b68fad44044	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-04-20 12:36:57.065493+00
82a9ba81-24c4-442e-94f1-a9acf37d39c8	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-04-20 12:36:57.065493+00
4f29fe58-c81a-4100-be99-2f67db40a828	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-04-20 12:36:57.065493+00
9e4680b6-e182-41d2-8d6a-c60d51336462	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-04-20 12:36:57.065493+00
74c339ca-5842-4fa3-aecc-c8392eea9f40	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-04-20 12:36:57.065493+00
5162cbca-3ba8-4cc1-83b4-f14c1aa6f98f	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-04-20 12:36:57.065493+00
15d88bc6-a341-484f-812c-f90144345abb	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-04-20 12:36:57.065493+00
a82c9ccd-546d-4486-91e8-f26e91d47628	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-04-20 12:36:57.065493+00
f38b0b31-d16b-44b0-a70c-29b4b8bd29f5	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-04-20 12:36:57.065493+00
563d57b2-60f7-4192-a341-cdb35c6a2c19	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-04-20 12:36:57.065493+00
ff2b63e8-5df4-476a-91e3-8f48bef281b9	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-04-20 12:36:57.065493+00
df75d078-af26-4208-b5a3-bdfbc8caa01a	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-04-20 12:36:57.065493+00
726797a3-5476-41e4-a24a-48d080a32b05	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-04-20 12:36:57.065493+00
02df20bc-2ad7-4bcd-8017-98f367209b6c	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-04-20 12:36:57.065493+00
3f8712e8-c699-4e15-a445-56f5adf2246e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-04-20 12:36:57.065493+00
d115547d-4bd5-4f63-98ed-b6ac2beed1e9	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-04-20 12:36:57.065493+00
de4f0582-1973-4a5c-a219-199f5da74841	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-04-20 12:36:57.065493+00
e5336be7-cf62-4a6a-abc0-8231c7f27a0f	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-04-20 12:36:57.065493+00
c83b1ec6-8fa2-41c2-96c2-577fc5a57f8e	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-04-20 12:36:57.065493+00
1c6d17c3-8aee-4833-b47a-e7aa88709002	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-04-20 12:36:57.065493+00
15440918-367a-4449-80f7-fe5abd9a4516	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-04-20 12:36:57.065493+00
719f9c2c-0484-46ab-971a-a51f0e0b7e63	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-04-20 12:36:57.065493+00
576ecbba-735e-4864-9184-5d500d6a37c2	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-04-20 12:36:57.065493+00
32414041-694d-496b-a97b-77c960e258c9	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-04-20 12:36:57.065493+00
c37903e0-5820-4728-ae6c-ea06d3ac3dc7	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-04-20 12:36:57.065493+00
ea93de1a-fdb4-4bde-a24f-edac725aaacc	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-04-20 12:36:57.065493+00
73cf5c64-33d0-4efc-a6ac-6acdede2405a	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-04-20 12:36:57.065493+00
0a0bfb1b-d1f8-4e03-87f5-e3632c436425	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-04-20 12:36:57.065493+00
dcafc4ed-ab65-4f48-bb4a-c000f71e2a1b	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-04-20 12:36:57.065493+00
8733674c-dd99-4294-891d-e09f17f524d7	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-04-20 12:36:57.065493+00
c25ee5ad-3603-46ae-ba4e-b3e0a1655b41	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-04-20 12:36:57.065493+00
3bf91ca7-63b2-4034-bb39-9a3327653db1	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-04-20 12:36:57.065493+00
dfd8e5ab-e849-482d-b42d-d204a43a6d66	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	481b2283-318d-48b8-94f3-63c9f6fcf7af	completed	2026-04-21 07:05:03.123+00	2026-04-20 12:36:57.065493+00
660b411c-af0b-410b-b603-17ff53ea8baa	4e340c6a-9c8a-4e52-8e0a-957d42581f11	f854a439-e72d-44fc-8efe-a0f755462a04	completed	2026-04-22 14:34:36.586+00	2026-04-13 03:03:25.940077+00
d4952807-04a6-4657-9ca3-02da82aa211e	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-04-28 16:02:13.822116+00
b98fdc83-414b-429e-b76b-03b00f0c102e	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-04-28 16:02:13.822116+00
6a142451-b22e-41f4-86e3-5075c5a4d346	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-04-28 16:02:13.822116+00
e37b08e9-5699-43dd-8606-0ad5038afcc0	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-04-28 16:02:13.822116+00
1fa4ae36-a65a-4bc6-a4b5-63bb68c14d3f	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-04-28 16:02:13.822116+00
65955b1e-50e1-4a8a-80c4-738376103eed	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-04-28 16:02:13.822116+00
a5f4dd85-138d-47f6-aaa4-018297d37a23	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-04-28 16:02:13.822116+00
59bb67e2-bb10-4d3e-af1b-d9122ee163fc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-04-28 16:02:13.822116+00
a79133e9-7d8a-4920-9744-8941f26a8078	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-04-28 16:02:13.822116+00
f59252dc-5722-4bf0-aa8c-a2d222882800	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:26.876+00	2026-04-20 12:36:57.065493+00
1599fd4e-532b-4796-b903-f4f7330796a7	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	e63d4eb5-df96-472d-9b92-dca55f181f78	pending	\N	2026-04-28 16:02:13.822116+00
0d58986f-d20e-4680-8c40-c0067a427743	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-04-28 16:02:13.822116+00
94d6026a-ac49-452c-af11-430ebe152f51	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-04-28 16:02:13.822116+00
f2617987-dbed-4a75-b639-64285c3d296e	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	85fd79c7-df83-40a2-90ff-15a51d3d79fd	pending	\N	2026-04-28 16:02:13.822116+00
4ac00fa0-7e97-4cd8-9175-1a6cebaf2335	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-04-28 16:02:13.822116+00
ffaffbb0-f1f1-4779-a03e-016c015aef57	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	pending	\N	2026-04-28 16:02:13.822116+00
b18e0a40-2380-4fb5-86b4-1872d0361c59	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-04-28 16:02:13.822116+00
ab58c131-ddef-4a3d-b126-c81c928137e6	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-04-28 16:02:13.822116+00
8a29dccb-3f83-414b-94ce-4c8604b62888	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-04-28 16:02:13.822116+00
8824e873-e1ee-4fec-a4f3-fb45368d8a75	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-04-28 16:02:13.822116+00
6d460450-a1f4-4aff-ae1f-cb401d955449	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-04-28 16:02:13.822116+00
24bc44dc-5b02-4275-94a1-f0d69c7cd727	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-04-28 16:02:13.822116+00
6a23dbcd-03a8-4b19-994b-1a180e57f855	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-04-28 16:02:13.822116+00
8df9b01d-44d1-4818-b93b-d12d2138a9fa	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-04-28 16:02:13.822116+00
3c277486-8d81-4292-8e6f-cbb09cb15b05	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-04-28 16:02:13.822116+00
b824bf7d-7bc1-4309-9ad2-780fcfe27af6	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-04-28 16:02:13.822116+00
9001db12-df2c-465f-9d67-6e8f3bc03d73	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-04-28 16:02:13.822116+00
d440fba5-a9b3-4c75-8b93-f71970723f82	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	55dbfa08-450b-42c5-9372-6b24963f36b5	pending	\N	2026-04-28 16:02:13.822116+00
bd60f45e-2efa-4f48-bc89-192262e7aaa4	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-04-28 16:02:13.822116+00
6c002859-ad6f-4745-adb1-3ab36a95114c	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-04-28 16:02:13.822116+00
f70b128d-f069-4e0e-bc41-734e4fb36de3	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-04-28 16:02:13.822116+00
8cf99603-c021-4f8f-8359-8b080c118d15	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	486cb7fe-4375-44d1-b124-e2460ab1826a	pending	\N	2026-04-28 16:02:13.822116+00
f5d0cacb-252d-4f2f-954b-526e02b32bd0	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-04-28 16:02:13.822116+00
6ccefb1c-83c5-464d-baf5-9f8ae6749e9c	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-04-28 16:02:13.822116+00
2d90ca76-bdf2-419e-b465-32045b6044ce	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-04-28 16:02:13.822116+00
a2fa489e-7f2f-476c-91a3-fdfd957a0b08	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-04-28 16:02:13.822116+00
871af849-d4e6-4d39-b48a-cfa4e203e548	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-04-28 16:02:13.822116+00
af586428-e08e-4276-8db7-c4433b2a14fc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-04-28 16:02:13.822116+00
c3aed1c8-a9af-4be2-98a2-d6df04684af0	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-04-28 16:02:13.822116+00
542f5a57-e6a6-4728-b6ff-470308628b65	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-05-03 07:10:25.346+00	2026-04-28 16:02:13.822116+00
12525b53-4388-45c4-8e9e-40cc6891f0ff	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	f854a439-e72d-44fc-8efe-a0f755462a04	completed	2026-05-11 17:38:23.516+00	2026-04-20 12:36:57.065493+00
84a3b4a1-c0c8-40e5-960f-6bc4c73c5cef	aae2af18-ffe3-45ba-a4d3-f26a5f93305b	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-05-21 06:57:33.583+00	2026-04-20 12:36:57.065493+00
6e2de44d-ac79-4cd3-aab3-2444fc3d0eb4	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-04-28 16:02:13.822116+00
d7f1590e-71a1-4624-98ba-a7e3aeae4600	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-04-28 16:02:13.822116+00
c94b5f32-5515-4976-82f9-e3c335606f6e	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-04-28 16:02:13.822116+00
5d649ad6-92f0-4784-b1ab-a136285ae2f9	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:24.485+00	2026-04-28 16:02:13.822116+00
400be73e-8895-4c9e-8f41-bec0e39bb07d	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-04-28 16:02:13.822116+00
142a3854-9b66-48bc-81a0-40388e9316fc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-04-28 16:02:13.822116+00
885ffed6-2553-44ab-b150-e18d5a3f8f06	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-04-28 16:02:13.822116+00
088dc4a8-36ba-4142-8740-f9e19c6ce724	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-04-28 16:02:13.822116+00
79d29462-a69c-4045-bf13-6c873c3a0a8b	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-04-28 16:02:13.822116+00
a8bc959b-e55e-4ef1-af08-9f15f3af4d6d	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-04-28 16:02:13.822116+00
bc61a0c1-3f5f-446d-a676-95a6baad6ab8	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	pending	\N	2026-04-28 16:02:13.822116+00
d793778a-9e29-4fb8-8f61-3502aded791f	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-04-28 16:02:13.822116+00
d45d29aa-6391-4ac0-9fe4-54bb958dfbe0	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-04-28 16:02:13.822116+00
90696bfe-8365-489a-b453-774550406327	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-04-28 16:02:13.822116+00
2433d0c9-9805-4390-960a-bc0b5d012082	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-04-28 16:02:13.822116+00
063a47f0-b63a-4d30-9aac-13799ee33767	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-04-28 16:02:13.822116+00
dc05250f-8d03-4218-a037-413ffe32a3a5	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-04-28 16:02:13.822116+00
5f348413-e0a4-478e-9304-b83c007f22cc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-04-28 16:02:13.822116+00
211bbf2d-6ac0-4393-8ddb-942aade71ef6	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-04-28 16:02:13.822116+00
3510129d-e6ca-40e7-b646-5c8fb89b9432	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-04-28 16:02:13.822116+00
5d0f22b1-b8f8-4d8a-b5dd-189c9e4dbced	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-04-28 16:02:13.822116+00
ac57c04b-9c3c-4eba-8a21-1f5c8fbd64e2	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	d4c73898-8bda-476d-a068-898c72460441	pending	\N	2026-04-28 16:02:13.822116+00
9025e504-28c9-40af-8652-c4752e1e73b6	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-04-28 16:02:13.822116+00
ac3f33fe-b96f-4c23-a0d1-6a1f1dc8b843	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-04-28 16:02:13.822116+00
57a9d142-1f57-4b85-be7f-1973c50c0d6b	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-04-28 16:02:13.822116+00
b7e20d59-516c-4f03-9c59-bfe09b86f838	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-04-28 16:02:13.822116+00
10ef6b64-f478-462d-a510-d722dcffef42	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-04-28 16:02:13.822116+00
c4fc411f-7a9b-44b2-a50c-a586a175d9a1	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-04-28 16:02:13.822116+00
c3745c95-149c-4bd3-a3eb-4b50050bae0d	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-04-28 16:02:13.822116+00
e8dea39d-f43a-4cea-916e-b7b069fa3601	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-04-28 16:02:13.822116+00
8604d8b0-4ea2-4c30-b6d9-a75a7cb40def	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-04-28 16:02:13.822116+00
204aa219-ec8f-4327-80d6-7e976e60f7ac	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a968d860-32be-47e9-8d8e-ef6752a3e879	pending	\N	2026-04-28 16:02:13.822116+00
005e2ded-9c26-4e45-9df1-5af96540a910	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-04-28 16:02:13.822116+00
0f0c7b73-89f7-4b2a-ab49-5074514bce3c	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-04-28 16:02:13.822116+00
ad0d1467-05be-44c2-8444-711cdeea6a2d	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-04-28 16:02:13.822116+00
b59d413b-0df5-4aad-bd91-de27a7db6ead	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-04-28 16:02:13.822116+00
4245d198-9e03-4478-bc28-e0bd5e4eca53	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-04-28 16:02:13.822116+00
bf136d90-e321-465b-87d7-a086c3b92f9d	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-04-28 16:02:13.822116+00
27905512-53c5-4183-93d0-115bf4632dac	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-04-28 16:02:13.822116+00
c3ba1861-50cb-42a0-ab4c-82b22b039f51	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-04-28 16:02:13.822116+00
1281f1c8-cc70-4300-af65-8961050f6f40	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-04-28 16:02:13.822116+00
b6bc9fb3-f7ac-4550-8c93-6223486e3b0a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-04-28 16:02:13.822116+00
2bd36401-7f2b-4de2-8acb-80a9a20b25ad	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-04-28 16:02:13.822116+00
d95d4cec-e5f3-4028-ac55-af57d03e1a02	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-04-28 16:02:13.822116+00
3f483561-a420-4a92-8d62-fa22e52fc3dd	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-04-28 16:02:13.822116+00
8bbd4168-d459-49ef-9908-bc64a7c99a27	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-04-28 16:02:13.822116+00
fbf7a57d-9e99-48f1-ae25-f20103244232	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4f596e49-9138-494f-9c00-d4106a457861	pending	\N	2026-04-28 16:02:13.822116+00
d9a65de1-c6cc-4b13-9cca-030139930b4a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-04-28 16:02:13.822116+00
7dc248de-5cef-4ac5-9d3e-3bcb278548ea	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-04-28 16:02:13.822116+00
a6477a32-8984-48e7-a9de-0cab0c741eee	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-04-28 16:02:13.822116+00
cedb9c2c-7a51-4af3-85bb-d119722950b3	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-04-28 16:02:13.822116+00
fdf89605-cf98-47ff-99f2-420ad79d5c8b	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-04-28 16:02:13.822116+00
a3d9a8bc-fd2a-4a54-bea6-2c844c3181fc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-04-28 16:02:13.822116+00
bf84988d-656b-4ac3-800c-f31a015cb36a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-04-28 16:02:13.822116+00
3a924de8-6024-417f-af1a-5818c171079c	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-04-28 16:02:13.822116+00
19daa5b0-f977-4ae7-894c-2bde2ffb201a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-04-28 16:02:13.822116+00
04199868-d940-4ce5-b5c4-6f811677027c	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-04-28 16:02:13.822116+00
959261fb-adf1-4cf2-afe6-a12e2e73bd13	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-04-28 16:02:13.822116+00
0b2a8dfd-ee5c-4fc0-880d-bbbde55cbda5	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-04-28 16:02:13.822116+00
2b4df8a4-ee6d-40f5-863a-5765d224b719	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-04-28 16:02:13.822116+00
f87af7b5-85ff-495a-872a-a03d9d6a7df9	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-04-28 16:02:13.822116+00
85dd8879-f1b0-44ee-a532-f11b3e68f3d3	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-04-28 16:02:13.822116+00
ebd69d7b-8535-48b0-bb95-bbd595ea81cc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-04-28 16:02:13.822116+00
9f78c559-d759-4e57-a36a-f27e561859d2	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-04-28 16:02:13.822116+00
1dd1d24e-d513-4f66-8ad1-488792eb4950	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-04-28 16:02:13.822116+00
413ff557-e3a1-42eb-88e3-3d2361d2eba1	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-04-28 16:02:13.822116+00
dc0d5e93-d141-490c-a376-637c506d415a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-04-28 16:02:13.822116+00
f5966b79-1082-481b-b10f-f3a5f1c8057b	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-04-28 16:02:13.822116+00
0ab83013-0b21-41f7-881d-35283cc52bd5	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-04-28 16:02:13.822116+00
18f8747e-9e2b-4cf4-a115-b0f375ed0919	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-04-28 16:02:13.822116+00
cc78a5f4-73c5-46b0-91fc-1035589f9abf	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-04-28 16:02:13.822116+00
520995b4-8348-4cbd-b44a-583bb6e58fbc	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-04-28 16:02:13.822116+00
ba2fa918-98ca-4b2b-a802-12b256da88a6	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-04-28 16:02:13.822116+00
d84f8134-3cfe-44da-8b2c-50d4b1b810a7	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-04-28 16:02:13.822116+00
3da9cf42-1b55-40d2-9aa7-da6d95e408c0	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-04-28 16:02:13.822116+00
c051d037-723f-45e2-a230-37f0ef550153	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-04-28 16:02:13.822116+00
ce632642-34fb-498b-b829-f81dd0997f62	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-04-28 16:02:13.822116+00
2d0da5b2-14fb-4daa-95a0-dbf8fb3e54d4	9145ca8b-2991-413f-a617-7dabbc4e9c53	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-05-04 05:49:45.325594+00
1c313b70-c34d-439b-bf5d-7d0ea2e1a4f4	9145ca8b-2991-413f-a617-7dabbc4e9c53	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-05-04 05:49:45.325594+00
a7ffb2bf-a8fc-45dd-be48-a08eb5e8e323	9145ca8b-2991-413f-a617-7dabbc4e9c53	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-05-04 05:49:45.325594+00
8d3127bd-8344-4817-a191-5d758f56b8e5	9145ca8b-2991-413f-a617-7dabbc4e9c53	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-05-04 05:49:45.325594+00
408e9d9c-6e94-4018-b111-618d30d57548	9145ca8b-2991-413f-a617-7dabbc4e9c53	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-05-04 05:49:45.325594+00
71f99e24-f914-4a71-aae9-b0316f7c5be9	9145ca8b-2991-413f-a617-7dabbc4e9c53	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-05-04 05:49:45.325594+00
b354425e-645d-4c29-80b0-96cd51bdf628	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-05-06 17:01:46.863+00	2026-04-28 16:02:13.822116+00
13c13423-85ba-4d88-9e22-30f30f7c0a30	9145ca8b-2991-413f-a617-7dabbc4e9c53	4524f75e-4135-4a2c-8bfb-02dc30ae126b	completed	2026-05-07 17:45:56.086+00	2026-05-04 05:49:45.325594+00
e8c68009-9a8b-4290-966a-c7208c8e9290	9145ca8b-2991-413f-a617-7dabbc4e9c53	232f55ca-9598-4daf-a8ef-5e9be124c975	completed	2026-05-11 06:15:35.831+00	2026-05-04 05:49:45.325594+00
0fab0af3-8a45-4c94-8f56-0f80f89993fd	9145ca8b-2991-413f-a617-7dabbc4e9c53	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-05-04 05:49:45.325594+00
763cd584-281d-46c0-8d5f-27d4c062e2ef	9145ca8b-2991-413f-a617-7dabbc4e9c53	e63d4eb5-df96-472d-9b92-dca55f181f78	pending	\N	2026-05-04 05:49:45.325594+00
432c93b3-fa8b-4af1-8866-000ac227cc40	9145ca8b-2991-413f-a617-7dabbc4e9c53	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-05-04 05:49:45.325594+00
e3f587f9-dd87-4f6c-8dad-e743a182a90a	9145ca8b-2991-413f-a617-7dabbc4e9c53	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-05-04 05:49:45.325594+00
1a710142-50e5-40ff-81e2-1734691ab505	9145ca8b-2991-413f-a617-7dabbc4e9c53	85fd79c7-df83-40a2-90ff-15a51d3d79fd	pending	\N	2026-05-04 05:49:45.325594+00
303eb68f-db2a-4314-afbf-782c6b4b7569	9145ca8b-2991-413f-a617-7dabbc4e9c53	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-05-04 05:49:45.325594+00
ce839d56-3a87-483c-80fa-5031805f276a	9145ca8b-2991-413f-a617-7dabbc4e9c53	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	pending	\N	2026-05-04 05:49:45.325594+00
31885d90-84c0-4958-b27f-baaad4ed9845	9145ca8b-2991-413f-a617-7dabbc4e9c53	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-05-04 05:49:45.325594+00
22ad42ca-b7f8-443c-b11c-92349cbb666e	9145ca8b-2991-413f-a617-7dabbc4e9c53	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-05-04 05:49:45.325594+00
cf81850e-aad6-4637-99d4-f04c4f58ecb2	9145ca8b-2991-413f-a617-7dabbc4e9c53	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-05-04 05:49:45.325594+00
e2fc5e05-2153-4a43-b7dc-80b01d525843	9145ca8b-2991-413f-a617-7dabbc4e9c53	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-05-04 05:49:45.325594+00
5c1215ce-7a01-422a-819d-25a08cb6b30c	9145ca8b-2991-413f-a617-7dabbc4e9c53	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-05-04 05:49:45.325594+00
e803b866-b6d0-40f5-b993-3894ea7d229b	9145ca8b-2991-413f-a617-7dabbc4e9c53	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-05-04 05:49:45.325594+00
750ac015-f8a7-4c94-8b38-856f409d2e04	9145ca8b-2991-413f-a617-7dabbc4e9c53	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-05-04 05:49:45.325594+00
84f18845-cb81-41f9-9cff-799cf6e3ee64	9145ca8b-2991-413f-a617-7dabbc4e9c53	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-05-04 05:49:45.325594+00
2e41beeb-1a1d-4aab-bfe0-776609a7e62f	9145ca8b-2991-413f-a617-7dabbc4e9c53	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-05-04 05:49:45.325594+00
fd780444-275f-428d-8ee0-eabb1bd395d3	9145ca8b-2991-413f-a617-7dabbc4e9c53	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-05-04 05:49:45.325594+00
399a9a36-00c3-48c9-90c7-54a4cca42b3a	9145ca8b-2991-413f-a617-7dabbc4e9c53	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-05-04 05:49:45.325594+00
087b71bd-d5c4-48ea-82d1-7629da0893a1	9145ca8b-2991-413f-a617-7dabbc4e9c53	55dbfa08-450b-42c5-9372-6b24963f36b5	pending	\N	2026-05-04 05:49:45.325594+00
49f2f4d9-0ab8-4ede-8ac1-5b1a7428d33b	9145ca8b-2991-413f-a617-7dabbc4e9c53	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-05-04 05:49:45.325594+00
ebeae87a-0fdd-43e0-ae97-066a4dec5c36	9145ca8b-2991-413f-a617-7dabbc4e9c53	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-05-04 05:49:45.325594+00
c0ed5085-8fa3-49ed-84a2-54861e8e3cc8	9145ca8b-2991-413f-a617-7dabbc4e9c53	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-05-04 05:49:45.325594+00
6ca07375-93c8-40ac-ac4d-84c1daf2293f	9145ca8b-2991-413f-a617-7dabbc4e9c53	117f2d44-cb82-475c-bdf9-841f771649d5	pending	\N	2026-05-04 05:49:45.325594+00
b441f19b-be2a-426a-897a-292038a16e97	9145ca8b-2991-413f-a617-7dabbc4e9c53	486cb7fe-4375-44d1-b124-e2460ab1826a	pending	\N	2026-05-04 05:49:45.325594+00
bfe35810-fe65-4930-87c3-ff8ef2d416aa	9145ca8b-2991-413f-a617-7dabbc4e9c53	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-05-04 05:49:45.325594+00
c9b51164-1e7c-4516-8cee-a7dcad80e50c	9145ca8b-2991-413f-a617-7dabbc4e9c53	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-05-04 05:49:45.325594+00
f0bd8e74-4514-456b-a4ef-e492480e6f57	9145ca8b-2991-413f-a617-7dabbc4e9c53	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-05-04 05:49:45.325594+00
5ef68ab3-b5d4-4e80-9c9c-b6a14b6c7ccc	9145ca8b-2991-413f-a617-7dabbc4e9c53	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-05-04 05:49:45.325594+00
d747c4df-bac6-4a23-b77b-2458e29b5fc0	9145ca8b-2991-413f-a617-7dabbc4e9c53	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-05-04 05:49:45.325594+00
121f0f17-9ddc-4db9-b062-376aa4ea962a	9145ca8b-2991-413f-a617-7dabbc4e9c53	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-05-04 05:49:45.325594+00
807e2b74-e710-460c-b0f2-f69951d33eaa	9145ca8b-2991-413f-a617-7dabbc4e9c53	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-05-04 05:49:45.325594+00
ef2fb4fa-aa17-42ba-8903-1b647e22664c	9145ca8b-2991-413f-a617-7dabbc4e9c53	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-05-04 05:49:45.325594+00
c622d4c4-f2f4-46a3-b6db-4a7cb57d06c5	9145ca8b-2991-413f-a617-7dabbc4e9c53	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-05-04 05:49:45.325594+00
6ed9c37e-a1e8-495c-b505-eb5b9bba4dfe	9145ca8b-2991-413f-a617-7dabbc4e9c53	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-05-04 05:49:45.325594+00
c5a170ef-5fa8-4244-a8f1-0528933fbe7f	9145ca8b-2991-413f-a617-7dabbc4e9c53	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:22.623+00	2026-05-04 05:49:45.325594+00
d46967ae-7ce4-4a86-822c-8eb75dd0e3f1	9145ca8b-2991-413f-a617-7dabbc4e9c53	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-05-04 05:49:45.325594+00
a7c933e7-ee3c-4f9b-95b5-28d24a94968b	9145ca8b-2991-413f-a617-7dabbc4e9c53	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-05-04 05:49:45.325594+00
16a9776f-c72f-4c18-93e2-1f71704d287e	9145ca8b-2991-413f-a617-7dabbc4e9c53	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-05-04 05:49:45.325594+00
5fcd51ed-9995-4fa4-ad06-5788e2962f2f	9145ca8b-2991-413f-a617-7dabbc4e9c53	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-05-04 05:49:45.325594+00
a0bcf459-1e1f-4e31-9e72-d68c14abcd61	9145ca8b-2991-413f-a617-7dabbc4e9c53	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-05-04 05:49:45.325594+00
7b37d800-2709-46b0-90b6-02759f97d6b3	9145ca8b-2991-413f-a617-7dabbc4e9c53	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-05-04 05:49:45.325594+00
95c0dcb6-0539-4e5b-a296-02766434cb3c	9145ca8b-2991-413f-a617-7dabbc4e9c53	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-05-04 05:49:45.325594+00
4403b943-ce9a-44cd-920a-8fbb5ea0dedb	9145ca8b-2991-413f-a617-7dabbc4e9c53	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	pending	\N	2026-05-04 05:49:45.325594+00
a2c60d79-6c07-4fbb-9d71-3e2a6f6c5897	9145ca8b-2991-413f-a617-7dabbc4e9c53	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-05-04 05:49:45.325594+00
917a8e04-fd24-409d-bf99-dee9ac174e31	9145ca8b-2991-413f-a617-7dabbc4e9c53	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-05-04 05:49:45.325594+00
d538ca62-7e0a-4e4b-8917-8d1b8462df55	9145ca8b-2991-413f-a617-7dabbc4e9c53	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-05-04 05:49:45.325594+00
f5fdf9d1-13e9-4e6e-91f5-658f556c8d32	9145ca8b-2991-413f-a617-7dabbc4e9c53	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-05-04 05:49:45.325594+00
b7c6b984-e4bf-46aa-8aa5-97c85ab995aa	9145ca8b-2991-413f-a617-7dabbc4e9c53	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-05-04 05:49:45.325594+00
296d237b-4861-4879-acf6-ded0e87308d2	9145ca8b-2991-413f-a617-7dabbc4e9c53	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-05-04 05:49:45.325594+00
0d9a25bc-bffa-469f-926c-49c3bef709a7	9145ca8b-2991-413f-a617-7dabbc4e9c53	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-05-04 05:49:45.325594+00
d0b1dc4b-297a-45d8-9091-415c5e920588	9145ca8b-2991-413f-a617-7dabbc4e9c53	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-05-04 05:49:45.325594+00
6555ce36-6726-4353-af59-645fda4db73e	9145ca8b-2991-413f-a617-7dabbc4e9c53	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-05-04 05:49:45.325594+00
8976d085-e4e9-403f-bd5f-2738eb62a499	9145ca8b-2991-413f-a617-7dabbc4e9c53	d4c73898-8bda-476d-a068-898c72460441	pending	\N	2026-05-04 05:49:45.325594+00
7651eda4-5172-4151-834a-072ff2fac22e	9145ca8b-2991-413f-a617-7dabbc4e9c53	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-05-04 05:49:45.325594+00
189eb28d-0f7e-460e-80fd-88519f2d694f	9145ca8b-2991-413f-a617-7dabbc4e9c53	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-05-04 05:49:45.325594+00
2e9a9426-0b86-40b7-9270-a0e200fa979a	9145ca8b-2991-413f-a617-7dabbc4e9c53	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-05-04 05:49:45.325594+00
0c0771d1-53b5-49df-90ab-8937b4453cb1	9145ca8b-2991-413f-a617-7dabbc4e9c53	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-05-04 05:49:45.325594+00
8d4cb89e-a69f-4717-9949-b66d76392bd1	9145ca8b-2991-413f-a617-7dabbc4e9c53	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-05-04 05:49:45.325594+00
0f2ac221-85b7-41ad-b089-9ed15b74bd6e	9145ca8b-2991-413f-a617-7dabbc4e9c53	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-05-04 05:49:45.325594+00
ce57d5ae-1359-40e3-b52c-00c0f5d09a14	9145ca8b-2991-413f-a617-7dabbc4e9c53	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-05-04 05:49:45.325594+00
07a3b3a3-5de5-49ad-85e1-51825fcc6f8a	9145ca8b-2991-413f-a617-7dabbc4e9c53	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-05-04 05:49:45.325594+00
3b41384a-411b-4c51-ac40-489247ed1e81	9145ca8b-2991-413f-a617-7dabbc4e9c53	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-05-04 05:49:45.325594+00
9b7e4822-75bd-4277-a24a-5d56556690ab	9145ca8b-2991-413f-a617-7dabbc4e9c53	a968d860-32be-47e9-8d8e-ef6752a3e879	pending	\N	2026-05-04 05:49:45.325594+00
8659d72e-3971-4238-a272-c0cf7343e18e	9145ca8b-2991-413f-a617-7dabbc4e9c53	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-05-04 05:49:45.325594+00
afda697f-0bb2-49d6-b53b-643969ad15d4	9145ca8b-2991-413f-a617-7dabbc4e9c53	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-05-04 05:49:45.325594+00
b2981960-7641-4a96-bcda-c4b5e60315b2	9145ca8b-2991-413f-a617-7dabbc4e9c53	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-05-04 05:49:45.325594+00
9d5f1608-3d41-476b-80d0-a3c1a1e30df9	9145ca8b-2991-413f-a617-7dabbc4e9c53	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-05-04 05:49:45.325594+00
28dd6c1f-484b-4993-a3d1-b1019aead085	9145ca8b-2991-413f-a617-7dabbc4e9c53	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-05-04 05:49:45.325594+00
a7cf1c7c-da75-417e-867b-baa383f935c0	9145ca8b-2991-413f-a617-7dabbc4e9c53	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-05-04 05:49:45.325594+00
d938be71-99f4-44d0-bf20-15392272dc9f	9145ca8b-2991-413f-a617-7dabbc4e9c53	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-05-04 05:49:45.325594+00
b197431e-d189-4597-87ca-293d5c9a921b	9145ca8b-2991-413f-a617-7dabbc4e9c53	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-05-04 05:49:45.325594+00
2849135d-4b5d-458a-9c60-5ecaa2be7018	9145ca8b-2991-413f-a617-7dabbc4e9c53	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-05-04 05:49:45.325594+00
f5554f66-6bf1-401b-97a8-df7164f82c20	9145ca8b-2991-413f-a617-7dabbc4e9c53	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-05-04 05:49:45.325594+00
d58c68c4-ff02-406b-b8ed-0ca73b41b980	9145ca8b-2991-413f-a617-7dabbc4e9c53	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-05-04 05:49:45.325594+00
f1a248d9-f7bb-491c-81dc-1e4993a65f4f	9145ca8b-2991-413f-a617-7dabbc4e9c53	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-05-04 05:49:45.325594+00
5a9ff1b4-7dbb-4d77-940a-ef0f3540bc8b	9145ca8b-2991-413f-a617-7dabbc4e9c53	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-05-04 05:49:45.325594+00
e9901d80-3bb0-4945-b2fa-e7a1f4e8649c	9145ca8b-2991-413f-a617-7dabbc4e9c53	4f596e49-9138-494f-9c00-d4106a457861	pending	\N	2026-05-04 05:49:45.325594+00
8349d92c-0e51-4d17-b820-24cb166a6ff4	9145ca8b-2991-413f-a617-7dabbc4e9c53	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-05-04 05:49:45.325594+00
3be9536c-2565-4269-b034-f56b8f6a38d4	9145ca8b-2991-413f-a617-7dabbc4e9c53	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-05-04 05:49:45.325594+00
0cc2e4da-de69-4530-80e7-13ebfcb467f6	9145ca8b-2991-413f-a617-7dabbc4e9c53	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-05-04 05:49:45.325594+00
31d2f626-9c35-4e94-b954-542b33a4a7e7	9145ca8b-2991-413f-a617-7dabbc4e9c53	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-05-04 05:49:45.325594+00
8b7cbcf6-5858-4908-958f-6a37fc6aa83a	9145ca8b-2991-413f-a617-7dabbc4e9c53	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-05-04 05:49:45.325594+00
f26e183b-f3a2-4ed5-a621-dd97d9a1e17d	9145ca8b-2991-413f-a617-7dabbc4e9c53	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-05-04 05:49:45.325594+00
e99120e4-eea1-495d-ad41-1779d67b9564	9145ca8b-2991-413f-a617-7dabbc4e9c53	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-05-11 16:44:14.946+00	2026-05-04 05:49:45.325594+00
91c926c8-ffca-4438-94c0-590381f5946b	9145ca8b-2991-413f-a617-7dabbc4e9c53	f854a439-e72d-44fc-8efe-a0f755462a04	completed	2026-05-17 06:47:30.109+00	2026-05-04 05:49:45.325594+00
b0b0d5aa-d287-406c-8514-61185f89b989	9145ca8b-2991-413f-a617-7dabbc4e9c53	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-05-18 14:20:52.906+00	2026-05-04 05:49:45.325594+00
509cd5fa-69cf-46aa-90b5-d9e5cb1616a8	9145ca8b-2991-413f-a617-7dabbc4e9c53	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-05-04 05:49:45.325594+00
71f3ef16-a8eb-4661-8795-ab39091dc468	9145ca8b-2991-413f-a617-7dabbc4e9c53	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-05-04 05:49:45.325594+00
1317a4cb-47b5-413a-8d61-870223a41387	9145ca8b-2991-413f-a617-7dabbc4e9c53	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-05-04 05:49:45.325594+00
3965f1ed-6157-41a8-808f-fd71d2ffaae9	9145ca8b-2991-413f-a617-7dabbc4e9c53	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-05-04 05:49:45.325594+00
d588643f-5981-4b1c-9a86-b7ed1d8302de	9145ca8b-2991-413f-a617-7dabbc4e9c53	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-05-04 05:49:45.325594+00
438573f1-d173-4494-9f67-74af8489ef90	9145ca8b-2991-413f-a617-7dabbc4e9c53	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-05-04 05:49:45.325594+00
dd480a58-d177-485d-a6de-5f822af8e2fc	9145ca8b-2991-413f-a617-7dabbc4e9c53	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-05-04 05:49:45.325594+00
09f4b8e5-e68b-4e53-aa36-27d1119e44af	9145ca8b-2991-413f-a617-7dabbc4e9c53	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-05-04 05:49:45.325594+00
8c93992a-7a3b-4975-82a3-bb488eccb500	9145ca8b-2991-413f-a617-7dabbc4e9c53	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-05-04 05:49:45.325594+00
ad8f1b6f-0bc4-431c-9e75-aa49a523e7e7	9145ca8b-2991-413f-a617-7dabbc4e9c53	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-05-04 05:49:45.325594+00
0df22474-44c8-446c-8720-898b90361d09	9145ca8b-2991-413f-a617-7dabbc4e9c53	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-05-04 05:49:45.325594+00
d935dc00-b9f7-4e6c-be6b-c776af20f0ce	9145ca8b-2991-413f-a617-7dabbc4e9c53	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-05-04 05:49:45.325594+00
01f4f416-dfbc-4358-8b05-5f28f7d436a6	9145ca8b-2991-413f-a617-7dabbc4e9c53	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-05-04 05:49:45.325594+00
e1b77d8b-80d9-4594-8e2b-c34741308662	9145ca8b-2991-413f-a617-7dabbc4e9c53	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-05-04 05:49:45.325594+00
b6ba85a4-6c54-4e34-ad59-d45045dad3b3	9145ca8b-2991-413f-a617-7dabbc4e9c53	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-05-04 05:49:45.325594+00
faad00c8-cfab-439e-8978-8b2ce6a16d9d	9145ca8b-2991-413f-a617-7dabbc4e9c53	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-05-04 05:49:45.325594+00
05481c22-bbf8-4985-b5f4-b64691a36507	9145ca8b-2991-413f-a617-7dabbc4e9c53	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-05-04 05:49:45.325594+00
89beb185-24d1-4eae-8da9-4e4c7489e140	9145ca8b-2991-413f-a617-7dabbc4e9c53	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-05-04 05:49:45.325594+00
efbc6baa-5fec-4e87-91ee-778cd78e679a	9145ca8b-2991-413f-a617-7dabbc4e9c53	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-05-04 05:49:45.325594+00
ff3fb1d6-12d9-477b-89c5-57131b86e359	9145ca8b-2991-413f-a617-7dabbc4e9c53	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-05-04 05:49:45.325594+00
b601ce68-8f55-4ab1-afa3-822658848c3f	9145ca8b-2991-413f-a617-7dabbc4e9c53	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-05-04 05:49:45.325594+00
1051b98d-5ed9-4481-bd73-5f4a2df88c5c	9145ca8b-2991-413f-a617-7dabbc4e9c53	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-05-04 05:49:45.325594+00
e9a3e127-12c3-4392-b4c5-c2499a51b4ed	9145ca8b-2991-413f-a617-7dabbc4e9c53	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-05-04 05:49:45.325594+00
fe3dd079-4a2b-440a-a4ee-a572ed1757ea	9145ca8b-2991-413f-a617-7dabbc4e9c53	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-05-04 05:49:45.325594+00
e01bedc8-2437-4991-8ab9-90fcb4fb626a	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-05-04 15:08:41.747+00	2026-04-28 16:02:13.822116+00
e693a840-3b77-411a-97ec-4de8b9b4f2b2	9145ca8b-2991-413f-a617-7dabbc4e9c53	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-05-04 15:08:43.145+00	2026-05-04 05:49:45.325594+00
c82c109e-8ba2-4898-b3fd-4d5ea6f99dc4	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-05-11 11:41:59.916689+00
aa1471a4-92c8-4354-a492-4b2bc54f3037	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-05-11 11:41:59.916689+00
135e6032-f7ff-449f-97c1-229ab79e205a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-05-11 11:41:59.916689+00
53d7c1f6-b303-4cbd-ad55-1a7ba85f2cfd	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-05-11 11:41:59.916689+00
f0f62640-8ba7-4380-b557-858124f13931	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-05-11 11:41:59.916689+00
e45946ec-951e-4913-8266-21f3a3c719e0	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-05-11 11:41:59.916689+00
59740e90-d861-4b66-9743-1de4d7704f78	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-05-11 11:41:59.916689+00
6b4eca54-09c9-4952-8f55-ba2097a1eb63	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-05-11 11:41:59.916689+00
8278215d-2d2a-4cca-8156-33b13d38619a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-05-11 11:41:59.916689+00
195374f5-8da3-4407-aae6-f729f11dff47	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	completed	2026-05-26 16:32:31.546+00	2026-05-11 11:41:59.916689+00
58aaa468-2b40-44f5-87c4-524b29c7b201	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	e63d4eb5-df96-472d-9b92-dca55f181f78	pending	\N	2026-05-11 11:41:59.916689+00
56f91848-b5f0-4e52-a866-a6b3274bdba6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-05-11 11:41:59.916689+00
4400726a-a1c2-47ff-a122-0b10dbd75f6c	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	85fd79c7-df83-40a2-90ff-15a51d3d79fd	pending	\N	2026-05-11 11:41:59.916689+00
4087b956-6bad-4813-b347-a80b064b929d	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-05-11 11:41:59.916689+00
e3716468-c327-44ff-b56a-216f1688d55a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-05-11 11:41:59.916689+00
8c428326-9c66-497b-8e27-4084e13dd152	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	pending	\N	2026-05-11 11:41:59.916689+00
1148a39e-1807-4982-89b6-7c8df72fa4a0	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-05-11 11:41:59.916689+00
bbac468e-1fe0-4572-bdd4-161e98d6191c	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-05-11 11:41:59.916689+00
e7a46c5b-b2f0-4868-a463-9584c5370cc0	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-05-11 11:41:59.916689+00
e505aee2-dbed-4923-a042-825b25dde92b	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-05-11 11:41:59.916689+00
9653da66-b7cf-4c9a-b5e6-97be8e46a538	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-05-11 11:41:59.916689+00
9f9e8c1c-13fc-45c2-9f93-60cec54388ee	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-05-11 11:41:59.916689+00
e444175b-faa4-4856-8ef1-40ca10fec870	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-05-11 11:41:59.916689+00
73e51e4c-19f6-44c8-95f1-9f3daa4c6f68	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-05-11 11:41:59.916689+00
34eb92c5-9868-45a7-be67-cf63d4fc2438	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-05-11 11:41:59.916689+00
e848d2b6-c231-4f05-861a-2c0216967f80	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-05-11 11:41:59.916689+00
64375dca-7eef-4037-907f-40ffb3e2eb81	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-05-11 11:41:59.916689+00
28022d21-4436-4286-a614-fdb29fa045d8	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	55dbfa08-450b-42c5-9372-6b24963f36b5	pending	\N	2026-05-11 11:41:59.916689+00
26197564-aa9c-4cf9-8496-cd08667eb38b	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-05-11 11:41:59.916689+00
5d71cd58-b2e8-4f98-a475-1ac3f780e5d9	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-05-11 11:41:59.916689+00
a16a9577-736f-47a3-8077-562966968b65	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-05-11 11:41:59.916689+00
f3db9a98-9160-4bec-a268-4ec87c76cf2c	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-05-11 11:41:59.916689+00
600ed926-f3e7-4556-a990-ee640c07ad88	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-05-11 11:41:59.916689+00
69e7f26e-8313-4b20-be85-a40da375e2e6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-05-11 11:41:59.916689+00
28471a6e-83d0-4888-b823-a2d2eadd4a77	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-05-11 11:41:59.916689+00
32ebf15e-3dc3-470b-9e51-0c38601f5ba4	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-05-11 11:41:59.916689+00
0819f5e6-81e7-438d-bd5b-eac620e9190f	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4b42c12c-6dd7-49fc-8268-24564f5b9204	pending	\N	2026-05-11 11:41:59.916689+00
77b2031b-bb83-4732-93e0-6dd82cd4115f	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-05-11 11:41:59.916689+00
7fa73856-b8c6-4332-b899-ea2e5f441405	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-05-11 11:41:59.916689+00
fd24f565-b2a4-4b72-8f81-a365865efda6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-05-11 11:41:59.916689+00
6deea353-38e9-471c-aa47-1cdddf6a458f	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-05-11 11:41:59.916689+00
b7e4296c-7d47-44a9-85cd-b92781c22419	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-05-11 11:41:59.916689+00
6d44a27e-44f9-45d5-bf53-6a4507c9edd4	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-05-11 11:41:59.916689+00
e09e24b6-52d0-4e3a-9951-a7b9fea4b86f	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-05-11 11:41:59.916689+00
cbdc1cfa-630a-454d-acf0-9c4f6e0ce229	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-05-11 11:41:59.916689+00
65b38134-74d1-4e95-992a-2b1a63fd48cf	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-05-11 11:41:59.916689+00
7e2d4452-4d2c-4332-bc86-33740cfbfb94	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-05-11 11:41:59.916689+00
9e4d9a01-2dec-426c-af54-e34155aa572b	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-05-11 11:41:59.916689+00
ac24d291-b8c1-4aed-9310-e3d07e656784	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-05-11 11:41:59.916689+00
db45d7dc-d9b4-4071-963b-64167eff0c57	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	pending	\N	2026-05-11 11:41:59.916689+00
10d74322-c9cd-40f3-b60a-5f2cf9915bdd	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-05-11 11:41:59.916689+00
1642193a-5fa1-4ee0-9652-b9d8e9b00ee9	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-05-11 11:41:59.916689+00
b7d3beea-708b-4715-96c8-b65304389ec6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-05-11 11:41:59.916689+00
c4e1b099-22fc-47a1-9b64-1e2c6849f165	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-05-11 11:41:59.916689+00
9a67b1e7-7656-47cf-a95e-e1cff683185a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-05-11 11:41:59.916689+00
ebe120f8-d8f6-407f-89b4-da0b9a107c51	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-05-11 11:41:59.916689+00
431b02f9-8db9-419f-a97a-41aa423427aa	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-05-11 11:41:59.916689+00
52edc6a6-3e29-4a8e-a3d8-668296ddbbce	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-05-11 11:41:59.916689+00
cf8aff43-9d1f-49b0-9f10-644d168f8bc8	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-05-18 07:12:05.667+00	2026-05-11 11:41:59.916689+00
e50df7a0-4ed8-4107-a67e-2ba3c64eeb37	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-05-21 08:44:58.203+00	2026-05-11 11:41:59.916689+00
90104671-a69c-4531-a6be-fee88d0c458b	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-05-11 11:41:59.916689+00
1ddadea2-487c-4afb-814f-51c2a96007b1	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	d4c73898-8bda-476d-a068-898c72460441	pending	\N	2026-05-11 11:41:59.916689+00
75242463-cdbc-47a0-8498-1784048d6b80	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-05-11 11:41:59.916689+00
880e5187-b8c0-4ac4-a118-b794b35dbaab	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-05-11 11:41:59.916689+00
49e4cc55-6e1c-4989-8669-87bbb4cc43c5	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-05-11 11:41:59.916689+00
70166047-4d5f-4791-9d8f-13438d294ccb	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-05-11 11:41:59.916689+00
0bb6c6c6-5f77-480f-ac28-a5f66a3e9f10	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-05-11 11:41:59.916689+00
903f98b4-fbc6-4662-bcff-069db3d28122	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-05-11 11:41:59.916689+00
90086f93-aca3-4905-ac61-ae2402098d9d	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-05-11 11:41:59.916689+00
b47e4943-b7c4-4a83-9ece-34eef2202eb6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-05-11 11:41:59.916689+00
fafeaf37-8926-4249-bd49-1f9d45aa43cd	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-05-11 11:41:59.916689+00
9c7644fb-9d73-4d83-8c18-abf74b7c6500	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a968d860-32be-47e9-8d8e-ef6752a3e879	pending	\N	2026-05-11 11:41:59.916689+00
763c8ee4-bc89-40d0-89e7-c171e900f4b6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-05-11 11:41:59.916689+00
6970cd3d-a0de-4849-a44a-997105b11933	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-05-11 11:41:59.916689+00
3cd92ad9-31a2-4d7d-ae91-389b44646578	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-05-11 11:41:59.916689+00
2b57ec97-88ad-4f9c-af4d-210e74fb67b1	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-05-11 11:41:59.916689+00
8c2a1f3a-fc3f-4c0f-8109-95fc7c728d11	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-05-11 11:41:59.916689+00
fc953516-9630-4eda-abb1-b1e405dec9eb	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-05-11 11:41:59.916689+00
b05c86d4-df71-4c16-b2ee-7040becb2bbe	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-05-11 11:41:59.916689+00
4cba3fd1-1282-443f-bf33-a6a0bfcea4b0	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f0d6a329-ff03-4ba6-8006-5742402e06bb	pending	\N	2026-05-11 11:41:59.916689+00
39118b15-939a-454a-88b5-8800e8a4be06	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-05-11 11:41:59.916689+00
bb72e344-abc7-4450-b29f-0f880a569e14	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-05-11 11:41:59.916689+00
03a96ee4-832e-46ac-b69d-7fd62e0aaf25	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-05-11 11:41:59.916689+00
23363183-5044-434f-8b6b-6707fb54fec9	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-05-11 11:41:59.916689+00
e0efbc59-71c0-45c7-88f4-3fcf0d59a82e	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-05-11 11:41:59.916689+00
3e35053f-ed97-40bd-a90f-d7e5c2886042	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-05-11 11:41:59.916689+00
b3aa424c-5192-4481-8a49-f49e3ff12066	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-05-11 11:41:59.916689+00
5c953117-2f65-4326-8782-8678c842441e	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4f596e49-9138-494f-9c00-d4106a457861	pending	\N	2026-05-11 11:41:59.916689+00
24d52d2b-36d7-4de3-8769-f631a4c7e339	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	d22fd755-c0a9-4474-8280-64d42c126700	pending	\N	2026-05-11 11:41:59.916689+00
4d039052-1867-4779-80bb-2fd078540c2c	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-05-11 11:41:59.916689+00
c8d6b12a-0454-4597-bf48-e85a8d9e8b7d	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-05-11 11:41:59.916689+00
28294d31-bfa5-49aa-8a8c-91e32634c269	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-05-11 11:41:59.916689+00
ac3bf742-cdd4-40eb-a294-53de2ea6b56a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-05-11 11:41:59.916689+00
33df86a9-f542-4422-8e76-664d6b5127ed	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-05-11 11:41:59.916689+00
4bbb4334-a2af-459a-aa5f-29306da96f68	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-05-11 11:41:59.916689+00
39d9638b-d431-4bfb-9027-a5d82c13016a	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-05-11 11:41:59.916689+00
00508201-3e64-4393-99e6-e64fada1f1df	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-05-11 11:41:59.916689+00
84daab5c-0215-4b0f-bf58-379e531d0251	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-05-11 11:41:59.916689+00
ba99fbb6-71c0-4bc5-ab01-0d2ead454cf2	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-05-11 11:41:59.916689+00
695fdd3b-7e60-4b76-a753-e5c308e0f1af	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-05-11 11:41:59.916689+00
684597c2-933d-41e5-9d02-82740f85a7d6	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-05-11 11:41:59.916689+00
f3f3fd21-1362-4b09-8807-de01f9791099	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-05-11 11:41:59.916689+00
b6afe342-a14b-4d11-acda-69882308bbcc	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-05-11 11:41:59.916689+00
0924c93a-e461-44cd-a3f1-f8c1e3326183	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-05-11 11:41:59.916689+00
9412023e-19f4-4b2c-9079-86c14f4154b8	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-05-11 11:41:59.916689+00
360261ad-557d-4274-9478-4f09c42f9e6d	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-05-11 11:41:59.916689+00
63e7da1a-f983-4fc8-a527-a70f8334bc1e	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-05-11 11:41:59.916689+00
5152f120-d10f-44e1-9c3a-b39579828a54	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-05-11 11:41:59.916689+00
3d4ab68f-4c21-4c6b-8e38-3228d58cd048	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-05-11 11:41:59.916689+00
30be0c7a-290b-4f41-abc2-18468b42a98f	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-05-11 11:41:59.916689+00
dfb79d7e-678d-4916-a194-fe96d6263fea	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-05-11 11:41:59.916689+00
97f022de-8bdf-4a88-b368-cad756376bff	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-05-11 11:41:59.916689+00
3774cf8c-9436-4df1-af3f-44252652feac	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-05-11 11:41:59.916689+00
13ddbc72-6a84-445c-a522-53a16ac15f16	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-05-11 11:41:59.916689+00
0639b03c-4922-453e-bc6a-6dd8cd80e431	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-05-11 11:41:59.916689+00
4969c730-e7de-414d-a8db-b613f28e999d	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-05-11 11:41:59.916689+00
a65bb717-6965-4b43-98b9-c7f3a6fdb829	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-05-11 11:41:59.916689+00
053148fd-4b06-4bd7-ac35-6d3a8e04692e	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-05-11 11:41:59.916689+00
ca4bba21-4048-45bd-be7f-44210dd2fe87	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-05-11 11:41:59.916689+00
3032c151-0f23-4a1b-99d4-dcd71486fa63	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	4842d49f-c3ea-47a4-bfee-03837bec04a5	completed	2026-05-13 11:18:36.892+00	2026-05-11 11:41:59.916689+00
c88a7d77-2da3-4d70-98ee-83d597c0e7ee	5ba72415-5ff8-4a25-aede-b919ffdbc917	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-05-18 06:42:47.113639+00
c6f1e40d-a1d9-43b4-b59e-36b2f5888f07	5ba72415-5ff8-4a25-aede-b919ffdbc917	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-05-18 06:42:47.113639+00
ec41804d-f682-49ff-afd2-ab6b160a2833	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:20.589+00	2026-05-11 11:41:59.916689+00
3f6d2709-f295-4d2d-b406-269b5b97232f	5ba72415-5ff8-4a25-aede-b919ffdbc917	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-05-18 06:42:47.113639+00
20596196-690f-4b21-97f5-3a25c3f4eb4f	5ba72415-5ff8-4a25-aede-b919ffdbc917	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-05-18 06:42:47.113639+00
07c9077b-a2c8-4f77-9069-8a35fc329dd5	5ba72415-5ff8-4a25-aede-b919ffdbc917	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-05-18 06:42:47.113639+00
75d96c4e-4f9c-4787-8766-c8abd1f468a7	5ba72415-5ff8-4a25-aede-b919ffdbc917	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-05-18 06:42:47.113639+00
85e5b4b8-00a3-439d-96ac-7791588bb266	5ba72415-5ff8-4a25-aede-b919ffdbc917	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-05-18 06:42:47.113639+00
3c6d0e95-3f78-48e0-8682-829a2fd1554c	5ba72415-5ff8-4a25-aede-b919ffdbc917	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-05-18 06:42:47.113639+00
a7493b4b-6c12-406c-892e-c939e18fe13e	5ba72415-5ff8-4a25-aede-b919ffdbc917	e63d4eb5-df96-472d-9b92-dca55f181f78	pending	\N	2026-05-18 06:42:47.113639+00
a196e6cd-6db6-4458-a055-57a2f375b150	5ba72415-5ff8-4a25-aede-b919ffdbc917	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-05-18 06:42:47.113639+00
79b7bdc4-0748-4b69-92fa-1222d3641e0c	5ba72415-5ff8-4a25-aede-b919ffdbc917	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-05-18 06:42:47.113639+00
db623f3d-99e7-444a-9518-4f24d16706ea	5ba72415-5ff8-4a25-aede-b919ffdbc917	85fd79c7-df83-40a2-90ff-15a51d3d79fd	pending	\N	2026-05-18 06:42:47.113639+00
e71e131a-0f50-4861-a80f-d2cba979edd6	5ba72415-5ff8-4a25-aede-b919ffdbc917	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-05-18 06:42:47.113639+00
f3f6de09-7db9-4200-9802-06055739b8a3	5ba72415-5ff8-4a25-aede-b919ffdbc917	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	pending	\N	2026-05-18 06:42:47.113639+00
8a3b9d68-4364-4c45-8bbb-ad96d13d4740	5ba72415-5ff8-4a25-aede-b919ffdbc917	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-05-18 06:42:47.113639+00
6aa0acc5-0316-439d-b716-49c866e85245	5ba72415-5ff8-4a25-aede-b919ffdbc917	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-05-18 06:42:47.113639+00
56c73a5d-503b-49b0-bcb2-1328ebd21c96	5ba72415-5ff8-4a25-aede-b919ffdbc917	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-05-18 06:42:47.113639+00
f163c2a2-c2b2-478a-a986-ef984a0059f8	5ba72415-5ff8-4a25-aede-b919ffdbc917	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-05-18 06:42:47.113639+00
d3dcc1c9-48cb-4a09-8c0a-26098c5a4cb2	5ba72415-5ff8-4a25-aede-b919ffdbc917	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-05-18 06:42:47.113639+00
95fdc262-f5fc-4ae1-b8af-320cbd334137	5ba72415-5ff8-4a25-aede-b919ffdbc917	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-05-18 06:42:47.113639+00
618399e1-9aa2-4410-94df-229936e0b656	5ba72415-5ff8-4a25-aede-b919ffdbc917	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-05-18 06:42:47.113639+00
ec2e719c-ab79-48ca-a9ed-4ae5063c6437	5ba72415-5ff8-4a25-aede-b919ffdbc917	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-05-18 06:42:47.113639+00
7c304a3b-9a63-46ba-bc10-9f675945f398	5ba72415-5ff8-4a25-aede-b919ffdbc917	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-05-18 06:42:47.113639+00
c66e8016-c5aa-4203-a1ff-455441f8775e	5ba72415-5ff8-4a25-aede-b919ffdbc917	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-05-18 06:42:47.113639+00
367f989c-b9c0-47a1-99b8-d05160b1f156	5ba72415-5ff8-4a25-aede-b919ffdbc917	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-05-18 06:42:47.113639+00
4f8c6bdc-c782-4f58-a80b-b5ab9fd49e42	5ba72415-5ff8-4a25-aede-b919ffdbc917	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-05-25 02:17:39.783+00	2026-05-18 06:42:47.113639+00
66d86946-d518-4b8c-8fe0-9dc6c70104e9	5ba72415-5ff8-4a25-aede-b919ffdbc917	55dbfa08-450b-42c5-9372-6b24963f36b5	pending	\N	2026-05-18 06:42:47.113639+00
a32e88d1-eff6-4d33-9002-d5aa9afc3fd9	5ba72415-5ff8-4a25-aede-b919ffdbc917	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-05-18 06:42:47.113639+00
169256d0-3ce3-4f74-8091-b21d7f45d06f	5ba72415-5ff8-4a25-aede-b919ffdbc917	d868f2b7-f054-4c90-84aa-be0cd7490fa5	pending	\N	2026-05-18 06:42:47.113639+00
ef40ab2d-daa7-4482-a754-d96cb253b6fd	5ba72415-5ff8-4a25-aede-b919ffdbc917	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-05-18 06:42:47.113639+00
9ea3f20f-bb44-406b-aa52-7a547996c58d	5ba72415-5ff8-4a25-aede-b919ffdbc917	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-05-18 06:42:47.113639+00
1b7d697e-1212-4c2f-b72e-6634495c10d9	5ba72415-5ff8-4a25-aede-b919ffdbc917	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-05-18 06:42:47.113639+00
b942f846-e30e-4fa4-a903-5f149409b01e	5ba72415-5ff8-4a25-aede-b919ffdbc917	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-05-18 06:42:47.113639+00
f01af2a3-7afb-4c20-8d3f-d1b3f84d2521	5ba72415-5ff8-4a25-aede-b919ffdbc917	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-05-18 06:42:47.113639+00
743b1ff2-e391-49a3-87f1-0a67b03dbd8e	5ba72415-5ff8-4a25-aede-b919ffdbc917	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-05-18 06:42:47.113639+00
43daa178-116a-425c-8489-318675940c16	5ba72415-5ff8-4a25-aede-b919ffdbc917	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-05-18 06:42:47.113639+00
44eb6238-2fba-4bd9-bbd0-8fb5066258a7	5ba72415-5ff8-4a25-aede-b919ffdbc917	4b42c12c-6dd7-49fc-8268-24564f5b9204	pending	\N	2026-05-18 06:42:47.113639+00
9052099d-b29d-47ce-8dd8-8f930a208b9b	5ba72415-5ff8-4a25-aede-b919ffdbc917	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-05-18 06:42:47.113639+00
90f9c68a-a46e-4cc8-ba47-07b44eb3bbcf	5ba72415-5ff8-4a25-aede-b919ffdbc917	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-05-18 06:42:47.113639+00
617a7db5-5711-4a2d-bf2b-25aa5854ff51	5ba72415-5ff8-4a25-aede-b919ffdbc917	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-05-18 06:42:47.113639+00
c58ad173-c616-4014-9d55-5d5881b21950	5ba72415-5ff8-4a25-aede-b919ffdbc917	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-05-18 06:42:47.113639+00
592f799e-5688-48b5-9e38-2d43d2f943e2	5ba72415-5ff8-4a25-aede-b919ffdbc917	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-05-18 06:42:47.113639+00
ebcc13ed-f5bc-42f7-840e-6d23dff431cb	5ba72415-5ff8-4a25-aede-b919ffdbc917	4842d49f-c3ea-47a4-bfee-03837bec04a5	pending	\N	2026-05-18 06:42:47.113639+00
73920bd5-2deb-4fd9-a717-4b04023e782f	5ba72415-5ff8-4a25-aede-b919ffdbc917	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-05-18 06:42:47.113639+00
9e87e20f-1537-47b3-a55a-a36dcb8414dc	5ba72415-5ff8-4a25-aede-b919ffdbc917	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:17.937+00	2026-05-18 06:42:47.113639+00
2e6ed320-feb0-4ac7-b74d-c5396f4e0f22	5ba72415-5ff8-4a25-aede-b919ffdbc917	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-05-18 06:42:47.113639+00
439b63eb-b20e-4bf0-9f1b-fae63d7500d0	5ba72415-5ff8-4a25-aede-b919ffdbc917	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-05-18 06:42:47.113639+00
19bfb1d0-82ba-4f65-94bd-3a27ac4cc543	5ba72415-5ff8-4a25-aede-b919ffdbc917	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-05-18 06:42:47.113639+00
c102ebfd-f7e8-44eb-8fdf-526b863ebbbf	5ba72415-5ff8-4a25-aede-b919ffdbc917	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-05-18 06:42:47.113639+00
7c6e9120-e4ad-41fa-99d3-b563f7386605	5ba72415-5ff8-4a25-aede-b919ffdbc917	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-05-18 06:42:47.113639+00
f157f0bf-5468-48a6-a63a-63b47aabf883	5ba72415-5ff8-4a25-aede-b919ffdbc917	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-05-18 06:42:47.113639+00
b249d4cc-c6ba-4927-a2ec-a6b950ff528e	5ba72415-5ff8-4a25-aede-b919ffdbc917	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	pending	\N	2026-05-18 06:42:47.113639+00
e3bd881e-1058-4720-8f07-a2b85adb962a	5ba72415-5ff8-4a25-aede-b919ffdbc917	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-05-18 06:42:47.113639+00
2e465468-2f80-4b0f-94de-8fcd5adedda1	5ba72415-5ff8-4a25-aede-b919ffdbc917	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-05-18 06:42:47.113639+00
7ed802f7-5858-4ef0-b72d-ae2379399b6f	5ba72415-5ff8-4a25-aede-b919ffdbc917	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-05-18 06:42:47.113639+00
2681190f-270f-4e52-8866-36001d5a955d	5ba72415-5ff8-4a25-aede-b919ffdbc917	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-05-18 06:42:47.113639+00
8095b794-9047-49f9-9dbe-43aaf82ef997	5ba72415-5ff8-4a25-aede-b919ffdbc917	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-05-18 06:42:47.113639+00
a8384299-8831-41a6-a9d1-0d9edc0b4e83	5ba72415-5ff8-4a25-aede-b919ffdbc917	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-05-18 06:42:47.113639+00
fe2ffed4-cac4-48ee-9c1b-fb7aa581ada0	5ba72415-5ff8-4a25-aede-b919ffdbc917	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-05-18 06:42:47.113639+00
451d037e-65d2-4ebe-9708-b1c6235b7d0d	5ba72415-5ff8-4a25-aede-b919ffdbc917	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-05-18 06:42:47.113639+00
9f4b5e6b-415c-48e8-9d92-1175e0a99a02	5ba72415-5ff8-4a25-aede-b919ffdbc917	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-05-18 06:42:47.113639+00
711dbbad-14fe-49e6-a4e1-0aaf3f068bb5	5ba72415-5ff8-4a25-aede-b919ffdbc917	d4c73898-8bda-476d-a068-898c72460441	pending	\N	2026-05-18 06:42:47.113639+00
acdefb65-5e6e-4863-a139-18354a9619ca	5ba72415-5ff8-4a25-aede-b919ffdbc917	2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e	pending	\N	2026-05-18 06:42:47.113639+00
eee746d3-36b2-46c5-96d5-e9b618c6f835	5ba72415-5ff8-4a25-aede-b919ffdbc917	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-05-18 06:42:47.113639+00
8d570a57-68fb-46d0-bd4e-4b8856b3f2d9	5ba72415-5ff8-4a25-aede-b919ffdbc917	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-05-18 06:42:47.113639+00
aa31a0be-bfbd-442b-b8d9-901809939833	5ba72415-5ff8-4a25-aede-b919ffdbc917	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-05-18 06:42:47.113639+00
02e09886-0250-4a3d-bb37-7259157eebe2	5ba72415-5ff8-4a25-aede-b919ffdbc917	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-05-18 06:42:47.113639+00
e45c04cb-b1d7-4d3f-a439-9b1a80490f68	5ba72415-5ff8-4a25-aede-b919ffdbc917	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-05-18 06:42:47.113639+00
cb7da82f-a25e-431c-9768-9c79a6c046d2	5ba72415-5ff8-4a25-aede-b919ffdbc917	914b0f69-d854-494a-88d2-d35987b82c79	pending	\N	2026-05-18 06:42:47.113639+00
ab5329f8-10f0-4f1b-bce1-ea8cbdbe4938	5ba72415-5ff8-4a25-aede-b919ffdbc917	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-05-18 06:42:47.113639+00
37b992de-0d9d-4341-a1f9-c1249616d888	5ba72415-5ff8-4a25-aede-b919ffdbc917	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-05-18 06:42:47.113639+00
64dc213e-0098-4488-b757-116c653b6e36	5ba72415-5ff8-4a25-aede-b919ffdbc917	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-05-18 06:42:47.113639+00
f1c15d0c-a20c-42ad-9b85-42d676af65f6	5ba72415-5ff8-4a25-aede-b919ffdbc917	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-05-18 06:42:47.113639+00
7eb7562d-951d-4254-af7b-7df1920dba74	5ba72415-5ff8-4a25-aede-b919ffdbc917	a968d860-32be-47e9-8d8e-ef6752a3e879	pending	\N	2026-05-18 06:42:47.113639+00
a78a5c18-2356-4f1c-b398-5ab46271214f	5ba72415-5ff8-4a25-aede-b919ffdbc917	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-05-18 06:42:47.113639+00
a1793b3e-2436-4f31-b8cd-104f30448be8	5ba72415-5ff8-4a25-aede-b919ffdbc917	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-05-18 06:42:47.113639+00
2430db4c-e6a3-4df2-811b-9e173b26eec8	5ba72415-5ff8-4a25-aede-b919ffdbc917	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-05-18 06:42:47.113639+00
f9ab8ec6-027b-4618-ac52-0743e7b55ccf	5ba72415-5ff8-4a25-aede-b919ffdbc917	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-05-18 06:42:47.113639+00
8026520d-54ba-479b-b0ef-00146fe08422	5ba72415-5ff8-4a25-aede-b919ffdbc917	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-05-18 06:42:47.113639+00
be4a08f8-f0d3-4a16-bdfb-2f099f548237	5ba72415-5ff8-4a25-aede-b919ffdbc917	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-05-18 06:42:47.113639+00
3723e478-e30c-4fbb-a31d-1ae2444d66f0	5ba72415-5ff8-4a25-aede-b919ffdbc917	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-05-18 06:42:47.113639+00
128ed32c-6107-40e4-8c16-66156dbfc1fc	5ba72415-5ff8-4a25-aede-b919ffdbc917	f0d6a329-ff03-4ba6-8006-5742402e06bb	pending	\N	2026-05-18 06:42:47.113639+00
ba55ca39-3432-47a5-99a2-529a054eb7eb	5ba72415-5ff8-4a25-aede-b919ffdbc917	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-05-18 06:42:47.113639+00
b612db5c-3b1f-42d0-bd3b-0ce9fb9c4d82	5ba72415-5ff8-4a25-aede-b919ffdbc917	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-05-18 06:42:47.113639+00
6bdfc630-51f0-4f3c-ac8e-0ffb0a53a708	5ba72415-5ff8-4a25-aede-b919ffdbc917	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-05-18 06:42:47.113639+00
75ccfdc2-f4fc-4bce-af6a-d291d8e8151d	5ba72415-5ff8-4a25-aede-b919ffdbc917	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-05-18 06:42:47.113639+00
8590f2d5-13c5-4e1a-8f5a-38fc49733964	5ba72415-5ff8-4a25-aede-b919ffdbc917	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-05-18 06:42:47.113639+00
1dfc6d18-2516-4efa-b53b-730e04df8943	5ba72415-5ff8-4a25-aede-b919ffdbc917	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-05-18 06:42:47.113639+00
884577d5-1eb8-4127-9e1a-40b19b8f5d12	5ba72415-5ff8-4a25-aede-b919ffdbc917	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-05-18 06:42:47.113639+00
0af030b2-ebbb-48a0-a578-e837642960ee	5ba72415-5ff8-4a25-aede-b919ffdbc917	4f596e49-9138-494f-9c00-d4106a457861	pending	\N	2026-05-18 06:42:47.113639+00
2bc96aba-6c46-4987-a702-6ae3f1280bae	5ba72415-5ff8-4a25-aede-b919ffdbc917	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-05-18 06:42:47.113639+00
3fc86873-5282-460e-9025-83119cb61aca	5ba72415-5ff8-4a25-aede-b919ffdbc917	11fc3990-68cc-4cdb-ad83-fca0ec15799f	pending	\N	2026-05-18 06:42:47.113639+00
7de7538b-19bd-4a5a-a760-4cabf12957f9	5ba72415-5ff8-4a25-aede-b919ffdbc917	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-05-18 06:42:47.113639+00
19ec36e9-4288-404e-aa6c-06301765ea9a	5ba72415-5ff8-4a25-aede-b919ffdbc917	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-05-18 06:42:47.113639+00
8874105b-3df7-4ba0-bb82-b5234d344f88	5ba72415-5ff8-4a25-aede-b919ffdbc917	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-05-18 06:42:47.113639+00
0eda6672-7e02-4e22-837d-a2cbf9d2f9ea	5ba72415-5ff8-4a25-aede-b919ffdbc917	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-05-18 06:42:47.113639+00
4b272fce-495d-4484-bf18-7381d5b01cdf	5ba72415-5ff8-4a25-aede-b919ffdbc917	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-05-18 06:42:47.113639+00
357cbba7-c381-4147-85e4-f1bc978e4704	5ba72415-5ff8-4a25-aede-b919ffdbc917	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-05-18 06:42:47.113639+00
555e4656-b665-46b0-9119-deeac6ec4874	5ba72415-5ff8-4a25-aede-b919ffdbc917	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-05-18 06:42:47.113639+00
af5f36e1-ab94-4f06-9f33-6320fcdfe085	5ba72415-5ff8-4a25-aede-b919ffdbc917	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-05-18 06:42:47.113639+00
644f8511-16a2-45eb-8f0a-dc6f9d2425db	5ba72415-5ff8-4a25-aede-b919ffdbc917	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-05-18 06:42:47.113639+00
15a2fb65-bce1-4505-9712-e795aed964f8	5ba72415-5ff8-4a25-aede-b919ffdbc917	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-05-18 06:42:47.113639+00
e3608a9b-5e98-4d3a-b7e5-dd29a533e224	5ba72415-5ff8-4a25-aede-b919ffdbc917	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-05-18 06:42:47.113639+00
d5bd4961-eb10-4ad0-8381-0b618dd16bfc	5ba72415-5ff8-4a25-aede-b919ffdbc917	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-05-18 06:42:47.113639+00
18b10e63-bcac-4f36-a3cb-25deff44eb52	5ba72415-5ff8-4a25-aede-b919ffdbc917	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-05-18 06:42:47.113639+00
4d759458-11ed-4536-8fc7-d6a7df6b36a3	5ba72415-5ff8-4a25-aede-b919ffdbc917	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-05-18 06:42:47.113639+00
e6963ef2-d507-429e-ba01-8d7c954e487b	5ba72415-5ff8-4a25-aede-b919ffdbc917	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-05-18 06:42:47.113639+00
aaa08b4b-1f4f-4a00-aaed-bf065b78e989	5ba72415-5ff8-4a25-aede-b919ffdbc917	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-05-18 06:42:47.113639+00
bb3d0b11-36af-4050-98fb-71db84f0d438	5ba72415-5ff8-4a25-aede-b919ffdbc917	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-05-18 06:42:47.113639+00
414ea2a5-2fc8-45ed-a197-71c8d72b26db	5ba72415-5ff8-4a25-aede-b919ffdbc917	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-05-21 06:57:19.136+00	2026-05-18 06:42:47.113639+00
2f946353-38e2-4c16-b2f3-6e6df6d8b393	5ba72415-5ff8-4a25-aede-b919ffdbc917	486cb7fe-4375-44d1-b124-e2460ab1826a	completed	2026-05-21 08:45:00.957+00	2026-05-18 06:42:47.113639+00
6c824413-92b2-4d1a-b02b-069ba66827a2	5ba72415-5ff8-4a25-aede-b919ffdbc917	117f2d44-cb82-475c-bdf9-841f771649d5	completed	2026-05-25 02:47:51.394+00	2026-05-18 06:42:47.113639+00
8955d12a-5e0d-4d3b-945e-211a5b5d1798	5ba72415-5ff8-4a25-aede-b919ffdbc917	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-05-18 06:42:47.113639+00
447d39c2-7c59-432b-9ec2-3c25558f8356	5ba72415-5ff8-4a25-aede-b919ffdbc917	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-05-18 06:42:47.113639+00
e6a300e3-a08e-416d-943d-44b12a999725	5ba72415-5ff8-4a25-aede-b919ffdbc917	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-05-18 06:42:47.113639+00
78568e87-9977-4ed2-afa5-5651c8121ed7	5ba72415-5ff8-4a25-aede-b919ffdbc917	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-05-18 06:42:47.113639+00
02fde4e2-07f2-4097-ab81-eb0085fcd811	5ba72415-5ff8-4a25-aede-b919ffdbc917	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-05-18 06:42:47.113639+00
9ff7668d-a272-47f8-a557-b2056d7df0c4	5ba72415-5ff8-4a25-aede-b919ffdbc917	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-05-18 06:42:47.113639+00
f179416f-9057-42a3-80e8-2bf1cbd171a7	5ba72415-5ff8-4a25-aede-b919ffdbc917	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-05-18 06:42:47.113639+00
a8a30db7-5865-4062-a647-f823f174e655	5ba72415-5ff8-4a25-aede-b919ffdbc917	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-05-18 06:42:47.113639+00
388fe30d-ba82-4796-b9fa-4b8fd917dcaa	5ba72415-5ff8-4a25-aede-b919ffdbc917	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-05-18 06:42:47.113639+00
8aa3d484-76eb-4efc-bcff-1d17c34d232e	5ba72415-5ff8-4a25-aede-b919ffdbc917	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-05-18 06:42:47.113639+00
1aff56f4-22c9-4c32-8df8-33915575f292	5ba72415-5ff8-4a25-aede-b919ffdbc917	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-05-18 06:42:47.113639+00
f93bb340-c490-4258-af2f-b8e064559e53	5ba72415-5ff8-4a25-aede-b919ffdbc917	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-05-18 06:42:47.113639+00
71ec943f-616d-4cc0-86ff-fe01ad085638	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-05-18 14:20:42.818+00	2026-04-28 16:02:13.822116+00
d1f778de-913a-4572-ac01-2e83c1847a65	5ba72415-5ff8-4a25-aede-b919ffdbc917	539a319d-7e31-4db7-8dec-7d04d92629d3	completed	2026-05-20 09:09:02.592+00	2026-05-18 06:42:47.113639+00
dbd7adca-114f-4f6c-9fa0-d0811457b8a4	5ba72415-5ff8-4a25-aede-b919ffdbc917	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	completed	2026-05-20 16:02:47.593+00	2026-05-18 06:42:47.113639+00
af998bff-9691-4376-964d-edc08ff5a143	9145ca8b-2991-413f-a617-7dabbc4e9c53	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-05-21 06:57:24.382+00	2026-05-04 05:49:45.325594+00
d15afd11-9465-4cb2-ba66-ab48343628b3	21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	d22fd755-c0a9-4474-8280-64d42c126700	completed	2026-05-21 06:57:28.354+00	2026-04-28 16:02:13.822116+00
e3f7b2ba-8dc9-497e-95d1-5222ac47ea66	ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	b8f6d90e-b692-4a8a-8cbc-17909331fa73	completed	2026-05-25 02:17:15.516+00	2026-05-11 11:41:59.916689+00
20113a19-0ca5-4c26-953d-49f06fe679d0	ff7017c4-6112-41e2-b62b-c606f392e04a	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	pending	\N	2026-05-25 06:22:44.939077+00
8e8d440b-62ae-44c7-821c-f5d18fbacf1c	ff7017c4-6112-41e2-b62b-c606f392e04a	232f55ca-9598-4daf-a8ef-5e9be124c975	pending	\N	2026-05-25 06:22:44.939077+00
649a7d0b-e6dc-4aeb-bb5d-b2f237bfa454	ff7017c4-6112-41e2-b62b-c606f392e04a	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	pending	\N	2026-05-25 06:22:44.939077+00
1f05bb16-11e8-4a1c-a4f6-e6175dbba38d	ff7017c4-6112-41e2-b62b-c606f392e04a	9a067c77-bb95-44cc-812e-4557ac17f80a	pending	\N	2026-05-25 06:22:44.939077+00
8d9b0a6d-8e3c-4e3b-a16b-a72b768274a9	ff7017c4-6112-41e2-b62b-c606f392e04a	f51b0111-f04d-453a-b6c0-60d9832fba6b	pending	\N	2026-05-25 06:22:44.939077+00
e8119daa-0460-42e2-9f04-28338854c8f5	ff7017c4-6112-41e2-b62b-c606f392e04a	f2179127-e88f-41f3-910a-f9dd0fa2647a	pending	\N	2026-05-25 06:22:44.939077+00
62d23cfe-806e-4335-aec4-ebd05cfc4117	ff7017c4-6112-41e2-b62b-c606f392e04a	3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	pending	\N	2026-05-25 06:22:44.939077+00
04d9ff88-76c6-4bb4-936b-7f858703dcde	ff7017c4-6112-41e2-b62b-c606f392e04a	4524f75e-4135-4a2c-8bfb-02dc30ae126b	pending	\N	2026-05-25 06:22:44.939077+00
e0b65dbb-84cd-4c03-ba54-3a38344e45da	ff7017c4-6112-41e2-b62b-c606f392e04a	47485610-8800-4c02-ac12-90808a9ecb94	pending	\N	2026-05-25 06:22:44.939077+00
20e61ccc-787e-4edd-8289-b8ce4e21143f	ff7017c4-6112-41e2-b62b-c606f392e04a	b8f6d90e-b692-4a8a-8cbc-17909331fa73	pending	\N	2026-05-25 06:22:44.939077+00
12e817de-f421-484b-adc3-cdf37b30f1bc	ff7017c4-6112-41e2-b62b-c606f392e04a	e63d4eb5-df96-472d-9b92-dca55f181f78	pending	\N	2026-05-25 06:22:44.939077+00
54f399b7-10a0-41d7-96e5-b2b362d16636	ff7017c4-6112-41e2-b62b-c606f392e04a	f24c03cf-533a-4334-badc-b450e0ac0a6b	pending	\N	2026-05-25 06:22:44.939077+00
8316f95c-8007-43e4-8c69-59f268edd528	ff7017c4-6112-41e2-b62b-c606f392e04a	0c6384b4-15bd-42b1-a978-317e1d163f8d	pending	\N	2026-05-25 06:22:44.939077+00
f9c5f9ed-6779-41aa-b74b-f91d65186135	ff7017c4-6112-41e2-b62b-c606f392e04a	85fd79c7-df83-40a2-90ff-15a51d3d79fd	pending	\N	2026-05-25 06:22:44.939077+00
eca9c848-357d-429b-ac1d-00dbc5d1f185	ff7017c4-6112-41e2-b62b-c606f392e04a	fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	pending	\N	2026-05-25 06:22:44.939077+00
94e437ce-dc55-49d5-a39d-17c502b86882	ff7017c4-6112-41e2-b62b-c606f392e04a	9d559a49-4bd5-4b49-91bc-984ee4bb2b89	pending	\N	2026-05-25 06:22:44.939077+00
f5abd1d2-b0a7-42f5-9048-39f80fe36e92	ff7017c4-6112-41e2-b62b-c606f392e04a	e243534f-6a49-436d-b637-a050b1e32de0	pending	\N	2026-05-25 06:22:44.939077+00
9056320c-7b19-47ce-b109-dc3bba928ac5	ff7017c4-6112-41e2-b62b-c606f392e04a	3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	pending	\N	2026-05-25 06:22:44.939077+00
4e35d84f-ba52-4ffa-a012-b60f12e094ff	ff7017c4-6112-41e2-b62b-c606f392e04a	df0f9941-a563-4844-adf0-3058c435dbf3	pending	\N	2026-05-25 06:22:44.939077+00
ad083a85-12da-4f4e-85ae-39ea0868e143	ff7017c4-6112-41e2-b62b-c606f392e04a	7e72384f-5a73-498c-b82e-57dd17a6ea18	pending	\N	2026-05-25 06:22:44.939077+00
da0be66d-14dd-4c96-ad2c-b466117fb995	ff7017c4-6112-41e2-b62b-c606f392e04a	c371c0b4-f445-41ec-b6cf-ba6828e59757	pending	\N	2026-05-25 06:22:44.939077+00
7adc6c91-bb80-42bf-91d0-4eb2c1168fba	ff7017c4-6112-41e2-b62b-c606f392e04a	a249b221-853f-4065-b6a4-c9ef30d4032f	pending	\N	2026-05-25 06:22:44.939077+00
422e9e1d-af88-44d3-b81a-a4ca2d9b0e8b	ff7017c4-6112-41e2-b62b-c606f392e04a	1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	pending	\N	2026-05-25 06:22:44.939077+00
e6f8f80f-0bdf-47e8-bee9-59811e0155ed	ff7017c4-6112-41e2-b62b-c606f392e04a	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	pending	\N	2026-05-25 06:22:44.939077+00
ceafe9e8-4679-4c5f-8323-55c7c8e94cd1	ff7017c4-6112-41e2-b62b-c606f392e04a	9421c674-7e88-4d96-9cdf-01f31a35c231	pending	\N	2026-05-25 06:22:44.939077+00
231dcdc6-0772-4dab-95ef-bcc86509e87c	ff7017c4-6112-41e2-b62b-c606f392e04a	643db578-c5a7-422f-ad51-1ba67a0db590	pending	\N	2026-05-25 06:22:44.939077+00
cbab2bb9-07f9-460e-bad4-cdffd65b4a25	ff7017c4-6112-41e2-b62b-c606f392e04a	2a495f49-f4e5-4dfa-879d-50e43fcca74e	pending	\N	2026-05-25 06:22:44.939077+00
6281fc20-3e68-47df-bb5d-26a6739aea0d	ff7017c4-6112-41e2-b62b-c606f392e04a	55dbfa08-450b-42c5-9372-6b24963f36b5	pending	\N	2026-05-25 06:22:44.939077+00
81b612a2-0905-4890-8b1a-065a5c418555	ff7017c4-6112-41e2-b62b-c606f392e04a	55ca6718-5a82-408d-800d-86cc3c49bbca	pending	\N	2026-05-25 06:22:44.939077+00
e3bdc5aa-973a-4492-90fd-8cd2da011a01	ff7017c4-6112-41e2-b62b-c606f392e04a	d868f2b7-f054-4c90-84aa-be0cd7490fa5	pending	\N	2026-05-25 06:22:44.939077+00
478db264-5803-4e17-ad74-b4c574230126	ff7017c4-6112-41e2-b62b-c606f392e04a	9b5fd841-5c68-4e82-8d91-95d01943d1aa	pending	\N	2026-05-25 06:22:44.939077+00
5e34bb4c-2a6c-4a6c-9415-c6f5458a9169	ff7017c4-6112-41e2-b62b-c606f392e04a	2e3999e0-fcca-407c-afa9-0ff5c26fae98	pending	\N	2026-05-25 06:22:44.939077+00
c5ed4806-6e9f-4366-94f3-276a0df10aac	ff7017c4-6112-41e2-b62b-c606f392e04a	117f2d44-cb82-475c-bdf9-841f771649d5	pending	\N	2026-05-25 06:22:44.939077+00
5b91105c-bac2-4083-b870-c32e1232d8e8	ff7017c4-6112-41e2-b62b-c606f392e04a	486cb7fe-4375-44d1-b124-e2460ab1826a	pending	\N	2026-05-25 06:22:44.939077+00
fb625862-55ae-41cc-b982-ce444c29fe3f	ff7017c4-6112-41e2-b62b-c606f392e04a	8b946c8c-5583-4340-94ac-a0c3801bfb98	pending	\N	2026-05-25 06:22:44.939077+00
4cd08dbf-93d3-416b-922a-cff7f3aa73a3	ff7017c4-6112-41e2-b62b-c606f392e04a	2c1bcdc5-0564-44d9-be4a-158445f39975	pending	\N	2026-05-25 06:22:44.939077+00
cc6f55ed-561e-4f17-84a3-ed9a496d22d4	ff7017c4-6112-41e2-b62b-c606f392e04a	1faa2e14-2817-46d8-8f9e-5e7b70855a98	pending	\N	2026-05-25 06:22:44.939077+00
4cff4a43-cdab-45db-8a52-0e5e2ae69057	ff7017c4-6112-41e2-b62b-c606f392e04a	33e91007-e2fa-4274-801b-4227ea2f7909	pending	\N	2026-05-25 06:22:44.939077+00
5f532e5d-12ec-4dd4-a0ac-12492dc5b912	ff7017c4-6112-41e2-b62b-c606f392e04a	96c9c515-49dc-4172-95d9-7a57478388c3	pending	\N	2026-05-25 06:22:44.939077+00
5be10a62-68b3-4134-8406-f3ba440b1e4b	ff7017c4-6112-41e2-b62b-c606f392e04a	4b42c12c-6dd7-49fc-8268-24564f5b9204	pending	\N	2026-05-25 06:22:44.939077+00
1f8a4193-8006-406b-a6aa-671770d2c69c	ff7017c4-6112-41e2-b62b-c606f392e04a	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	pending	\N	2026-05-25 06:22:44.939077+00
1c2c4cf9-b7d1-4775-9e21-49e353affeae	ff7017c4-6112-41e2-b62b-c606f392e04a	03a59a7d-da67-44b8-88f7-1a0fbe44f706	pending	\N	2026-05-25 06:22:44.939077+00
59e31c70-f734-48e7-9ec3-a69d64cbdb13	ff7017c4-6112-41e2-b62b-c606f392e04a	3b54e716-c5a0-4d4c-a616-4e2e2be95539	pending	\N	2026-05-25 06:22:44.939077+00
7b4ed4be-5c5c-44f0-8d64-3b8d060c04c3	ff7017c4-6112-41e2-b62b-c606f392e04a	4de93087-ee99-48dc-b3a5-4339c8da81ec	pending	\N	2026-05-25 06:22:44.939077+00
71cbcb88-4683-4d93-8bb0-25cc0ddf2511	ff7017c4-6112-41e2-b62b-c606f392e04a	75d39ffb-b85c-49ad-b08c-978bd0e4ea33	pending	\N	2026-05-25 06:22:44.939077+00
547a7ae3-62e2-4d72-b768-dd79165fdb5c	ff7017c4-6112-41e2-b62b-c606f392e04a	4842d49f-c3ea-47a4-bfee-03837bec04a5	pending	\N	2026-05-25 06:22:44.939077+00
7f3b34a7-b919-42d7-8518-381f0f8e2065	ff7017c4-6112-41e2-b62b-c606f392e04a	30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	pending	\N	2026-05-25 06:22:44.939077+00
483e9463-8f1a-4a41-8b0b-c5e2948c613f	ff7017c4-6112-41e2-b62b-c606f392e04a	539a319d-7e31-4db7-8dec-7d04d92629d3	pending	\N	2026-05-25 06:22:44.939077+00
9a06494f-7b4e-4b37-9bd1-3db36eaced6f	ff7017c4-6112-41e2-b62b-c606f392e04a	9fb2df7d-14fe-4f1f-94f1-19058a6ad723	pending	\N	2026-05-25 06:22:44.939077+00
3a26401c-a29b-4925-aad3-80a1df69acc2	ff7017c4-6112-41e2-b62b-c606f392e04a	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	pending	\N	2026-05-25 06:22:44.939077+00
0faf9770-ffd6-47e5-80a6-1551be1fec40	ff7017c4-6112-41e2-b62b-c606f392e04a	aded593b-ae3f-4eca-8edf-658f89bb172c	pending	\N	2026-05-25 06:22:44.939077+00
c00c3708-bf13-4cae-8b1a-c0a7d69c5cb6	ff7017c4-6112-41e2-b62b-c606f392e04a	abfeb4ea-ff91-472a-8f0e-d458d122e68a	pending	\N	2026-05-25 06:22:44.939077+00
92df0b9d-ea3e-4c2b-a3f1-bcc7251d8b39	ff7017c4-6112-41e2-b62b-c606f392e04a	fe64f71e-bc1f-4297-af8a-9dfae090e0be	pending	\N	2026-05-25 06:22:44.939077+00
fe14b80c-a896-43fe-b026-d8cb7c5fe339	ff7017c4-6112-41e2-b62b-c606f392e04a	08f53469-511c-45e6-914a-c4aacc2c4fed	pending	\N	2026-05-25 06:22:44.939077+00
86dbe81c-45ec-4694-9b38-641a9e7c9287	ff7017c4-6112-41e2-b62b-c606f392e04a	dfe13521-6ab4-4474-b1cc-32ac91e74ea5	pending	\N	2026-05-25 06:22:44.939077+00
62175535-ddef-4dcd-b04b-f3dd1156a14a	ff7017c4-6112-41e2-b62b-c606f392e04a	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	pending	\N	2026-05-25 06:22:44.939077+00
6543be4d-e3b4-444a-84ce-7c8253fd2644	ff7017c4-6112-41e2-b62b-c606f392e04a	69fbfc39-3ac0-4972-93fb-317e3e50219b	pending	\N	2026-05-25 06:22:44.939077+00
c4cacb5b-e7cc-4ab5-b462-244113d04cc9	ff7017c4-6112-41e2-b62b-c606f392e04a	34e80f19-ddbe-46bf-9a65-83c81104b974	pending	\N	2026-05-25 06:22:44.939077+00
aba57572-7bec-49c2-ae66-f82e70ea405a	ff7017c4-6112-41e2-b62b-c606f392e04a	4c363395-b574-454e-abb9-bb28a79d09d3	pending	\N	2026-05-25 06:22:44.939077+00
2d344374-3e23-495c-914a-2122e9a856c4	ff7017c4-6112-41e2-b62b-c606f392e04a	d176663a-6707-4d57-bf50-35e3e7b4a964	pending	\N	2026-05-25 06:22:44.939077+00
5ae1ba19-0177-4fc4-ae3a-14f5b3e8a6fd	ff7017c4-6112-41e2-b62b-c606f392e04a	42eb89fe-dd23-4238-a7e0-9e1e5189d92f	pending	\N	2026-05-25 06:22:44.939077+00
97624ae1-4ef2-422e-9fe7-bade76fa636b	ff7017c4-6112-41e2-b62b-c606f392e04a	ccfcbbd3-ed14-440e-9a04-1e348f45996d	pending	\N	2026-05-25 06:22:44.939077+00
9da6eca5-dd48-4384-9900-454d8d1cfed6	ff7017c4-6112-41e2-b62b-c606f392e04a	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	pending	\N	2026-05-25 06:22:44.939077+00
89b1356e-4ea9-475b-9d68-9f5240f6720b	ff7017c4-6112-41e2-b62b-c606f392e04a	93748e18-e2ba-46c6-8f37-7ebfe143bfe1	pending	\N	2026-05-25 06:22:44.939077+00
2f602377-44ee-443c-baa5-bab3107a1e85	ff7017c4-6112-41e2-b62b-c606f392e04a	a551cf3f-5282-49ea-b432-7624af5558b2	pending	\N	2026-05-25 06:22:44.939077+00
1a7463f2-4fca-4918-a0f0-42d680dac01a	ff7017c4-6112-41e2-b62b-c606f392e04a	d4c73898-8bda-476d-a068-898c72460441	pending	\N	2026-05-25 06:22:44.939077+00
d7b0d835-b61e-45b5-9296-09f5e610a583	ff7017c4-6112-41e2-b62b-c606f392e04a	2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e	pending	\N	2026-05-25 06:22:44.939077+00
961192db-6388-48dd-9f2c-c0fba4fd5f15	ff7017c4-6112-41e2-b62b-c606f392e04a	9f6ca714-7578-43d0-b6c2-290e4e6ef413	pending	\N	2026-05-25 06:22:44.939077+00
cdddc324-7b6f-46f3-8bfa-0ceefe655e26	ff7017c4-6112-41e2-b62b-c606f392e04a	3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	pending	\N	2026-05-25 06:22:44.939077+00
4dd77371-06c1-4d5d-97fe-f9ee44185e59	ff7017c4-6112-41e2-b62b-c606f392e04a	dd8599b5-9989-4b14-9d33-6e4913e6693e	pending	\N	2026-05-25 06:22:44.939077+00
ad19eab4-488b-4f2a-a786-270339637e34	ff7017c4-6112-41e2-b62b-c606f392e04a	ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	pending	\N	2026-05-25 06:22:44.939077+00
c73c748d-b520-4868-86f0-ce55181ead5f	ff7017c4-6112-41e2-b62b-c606f392e04a	5a4cbc48-bacb-4728-b9f0-34fe766d9f19	pending	\N	2026-05-25 06:22:44.939077+00
d01029ac-4b73-4530-9ebc-8f785b259661	ff7017c4-6112-41e2-b62b-c606f392e04a	914b0f69-d854-494a-88d2-d35987b82c79	pending	\N	2026-05-25 06:22:44.939077+00
b0325ee2-e913-422a-956b-4bd5f131fc70	ff7017c4-6112-41e2-b62b-c606f392e04a	19d835f0-85cf-4457-8aa4-86dea0dd14dc	pending	\N	2026-05-25 06:22:44.939077+00
4fd6d82e-d418-4106-9a2a-9cdb186cd334	ff7017c4-6112-41e2-b62b-c606f392e04a	4bf8abb9-f93c-4e9f-838c-10c3069996f9	pending	\N	2026-05-25 06:22:44.939077+00
36757fde-002e-410d-afd6-3e9be4914d27	ff7017c4-6112-41e2-b62b-c606f392e04a	ec777267-0100-4e47-adcd-afa4e8deb872	pending	\N	2026-05-25 06:22:44.939077+00
9b0956fc-ca1c-4ad0-8207-43bf2a239667	ff7017c4-6112-41e2-b62b-c606f392e04a	308b47f5-d3e6-479a-a0a5-a8be6591e7b8	pending	\N	2026-05-25 06:22:44.939077+00
0c0f6012-5255-4e33-bb2b-1b58d74599fe	ff7017c4-6112-41e2-b62b-c606f392e04a	a968d860-32be-47e9-8d8e-ef6752a3e879	pending	\N	2026-05-25 06:22:44.939077+00
1ee930d0-8162-4ffd-8750-e511c770ba22	ff7017c4-6112-41e2-b62b-c606f392e04a	1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	pending	\N	2026-05-25 06:22:44.939077+00
2206bbfb-6816-40fe-acc5-86f523f70e81	ff7017c4-6112-41e2-b62b-c606f392e04a	ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	pending	\N	2026-05-25 06:22:44.939077+00
de13f59d-fd7c-4335-9e5a-5ce4d824b801	ff7017c4-6112-41e2-b62b-c606f392e04a	6a89d207-b9ef-4e2b-9a9a-14b42000db10	pending	\N	2026-05-25 06:22:44.939077+00
18405684-5352-4ba6-827b-fa45bd93d10f	ff7017c4-6112-41e2-b62b-c606f392e04a	46d8f688-8929-4f4e-9c02-c1db1a0669ea	pending	\N	2026-05-25 06:22:44.939077+00
2d59abe1-cc07-4658-8359-776e7777c46b	ff7017c4-6112-41e2-b62b-c606f392e04a	2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	pending	\N	2026-05-25 06:22:44.939077+00
0ea8daa7-88aa-4514-88ff-4849b084febf	ff7017c4-6112-41e2-b62b-c606f392e04a	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	pending	\N	2026-05-25 06:22:44.939077+00
58b9db7a-bac0-4267-b58c-20b490f41272	ff7017c4-6112-41e2-b62b-c606f392e04a	4d69310b-0603-47ba-9171-644236ecde06	pending	\N	2026-05-25 06:22:44.939077+00
b4d5e751-ae58-49e5-978c-31e6faafc647	ff7017c4-6112-41e2-b62b-c606f392e04a	f0d6a329-ff03-4ba6-8006-5742402e06bb	pending	\N	2026-05-25 06:22:44.939077+00
528ab82e-bed8-4bdf-abe4-6f523fec41e4	ff7017c4-6112-41e2-b62b-c606f392e04a	3656a4f7-ddaa-4b85-8c89-cde880be3227	pending	\N	2026-05-25 06:22:44.939077+00
4bb83609-4013-429d-8376-ce381749fd1e	ff7017c4-6112-41e2-b62b-c606f392e04a	eae9a0f2-2bd7-467a-aa1c-b59963276dda	pending	\N	2026-05-25 06:22:44.939077+00
b72abccd-b65d-48f4-8746-80f4833043eb	ff7017c4-6112-41e2-b62b-c606f392e04a	b644c23a-6ad3-4c08-ac90-8dc552e7478c	pending	\N	2026-05-25 06:22:44.939077+00
915d7db6-8959-4c2d-979f-36cb4dcded54	ff7017c4-6112-41e2-b62b-c606f392e04a	a8046eca-1c34-4435-aacf-826e49a40e5b	pending	\N	2026-05-25 06:22:44.939077+00
f4ff5bca-150e-4521-ad2e-44a35cb9469c	ff7017c4-6112-41e2-b62b-c606f392e04a	73e309c3-69be-4b6c-97bf-b23ee7c5634c	pending	\N	2026-05-25 06:22:44.939077+00
2920a270-970b-4179-979b-ae61b2e37dcb	ff7017c4-6112-41e2-b62b-c606f392e04a	f854a439-e72d-44fc-8efe-a0f755462a04	pending	\N	2026-05-25 06:22:44.939077+00
bbfb9f90-0e26-4386-9ca3-85237d6a27a5	ff7017c4-6112-41e2-b62b-c606f392e04a	32837c38-a21e-450a-8613-ec2c09f3cc97	pending	\N	2026-05-25 06:22:44.939077+00
25bc859e-fc34-44c9-9aa2-1bbdc5710972	ff7017c4-6112-41e2-b62b-c606f392e04a	4f596e49-9138-494f-9c00-d4106a457861	pending	\N	2026-05-25 06:22:44.939077+00
4088310a-5ad7-4df5-902f-4f149dfc411e	ff7017c4-6112-41e2-b62b-c606f392e04a	d22fd755-c0a9-4474-8280-64d42c126700	pending	\N	2026-05-25 06:22:44.939077+00
9f70626a-55c3-4e1c-aacc-bca04d8bfebb	ff7017c4-6112-41e2-b62b-c606f392e04a	41135cc0-c4af-478a-bc6e-6ef25590fd94	pending	\N	2026-05-25 06:22:44.939077+00
d53b2fcd-d3a2-4075-a7b8-81b01ab3af41	ff7017c4-6112-41e2-b62b-c606f392e04a	63a204f2-f076-49f5-b7a7-2ac78e2bbcac	pending	\N	2026-05-25 06:22:44.939077+00
9f6fcb73-5e5b-44e0-af5e-a631ed7f54f2	ff7017c4-6112-41e2-b62b-c606f392e04a	11fc3990-68cc-4cdb-ad83-fca0ec15799f	pending	\N	2026-05-25 06:22:44.939077+00
ff383ca2-55be-4539-ace8-421eba21555d	ff7017c4-6112-41e2-b62b-c606f392e04a	fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	pending	\N	2026-05-25 06:22:44.939077+00
787ceb02-34b8-4375-acd2-171b8be8a2c0	ff7017c4-6112-41e2-b62b-c606f392e04a	f80e1236-fa27-4605-a0c5-3e92f540bc70	pending	\N	2026-05-25 06:22:44.939077+00
c540c78e-20e6-49d4-95d3-690e8788e070	ff7017c4-6112-41e2-b62b-c606f392e04a	0e833c46-ec3f-4681-8dbc-2bec029d8db1	pending	\N	2026-05-25 06:22:44.939077+00
7fad9a40-46ee-41d8-932c-a795767abaff	ff7017c4-6112-41e2-b62b-c606f392e04a	57c08aaa-e760-48dd-9772-d8fbea00e722	pending	\N	2026-05-25 06:22:44.939077+00
155774b8-1f61-4ae7-a2d8-8ed8896033cc	ff7017c4-6112-41e2-b62b-c606f392e04a	58be09cf-362d-4919-9a0a-67aa65a5c52e	pending	\N	2026-05-25 06:22:44.939077+00
0b318630-1ec6-4668-aa3b-495bc779134c	ff7017c4-6112-41e2-b62b-c606f392e04a	b7a0ba40-6b70-461d-b806-4583cb44019a	pending	\N	2026-05-25 06:22:44.939077+00
06c24a28-1ab0-4e43-aefa-a75dd472743a	ff7017c4-6112-41e2-b62b-c606f392e04a	9e34793f-4532-4cf0-8e19-bb36a03057d2	pending	\N	2026-05-25 06:22:44.939077+00
adc8d97c-828e-4d34-9346-bc5b30bd8296	ff7017c4-6112-41e2-b62b-c606f392e04a	c97ed6dc-f8d5-4311-a1f8-58a72267a160	pending	\N	2026-05-25 06:22:44.939077+00
6b0f6009-80fe-4bc7-94a0-e70bb7e1b834	ff7017c4-6112-41e2-b62b-c606f392e04a	cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	pending	\N	2026-05-25 06:22:44.939077+00
b82d7fdc-4f79-4a15-80d6-e9722c9dfc27	ff7017c4-6112-41e2-b62b-c606f392e04a	41fcbca1-3193-42ce-8585-95372b4b9d52	pending	\N	2026-05-25 06:22:44.939077+00
8fab79dd-916d-4856-b5c0-fc19f65d1435	ff7017c4-6112-41e2-b62b-c606f392e04a	a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	pending	\N	2026-05-25 06:22:44.939077+00
12a2f285-6145-49b3-8889-93dafa7945b2	ff7017c4-6112-41e2-b62b-c606f392e04a	50ac0f99-6e54-4ab2-bdbd-83463583261a	pending	\N	2026-05-25 06:22:44.939077+00
a50ef010-dd0b-4137-94de-988d3939eed5	ff7017c4-6112-41e2-b62b-c606f392e04a	481b2283-318d-48b8-94f3-63c9f6fcf7af	pending	\N	2026-05-25 06:22:44.939077+00
14b503b4-ce8d-4259-959a-c18b691d4e42	ff7017c4-6112-41e2-b62b-c606f392e04a	b2bc304c-62d9-4383-8af6-f78a51c94374	pending	\N	2026-05-25 06:22:44.939077+00
898ad6bb-78ac-455f-bd69-06e2faf84541	ff7017c4-6112-41e2-b62b-c606f392e04a	cd48a9cd-dc2c-420e-874e-f8a50167c9bd	pending	\N	2026-05-25 06:22:44.939077+00
f0e5a13c-7c1b-4a1a-bb1c-d3fa860a735b	ff7017c4-6112-41e2-b62b-c606f392e04a	32cf8f2e-3643-4301-8fde-d601c27012fc	pending	\N	2026-05-25 06:22:44.939077+00
34d1df47-23c2-4fba-becd-a78cff74723b	ff7017c4-6112-41e2-b62b-c606f392e04a	9f90c956-1695-4492-9fc3-569b6e4cc326	pending	\N	2026-05-25 06:22:44.939077+00
ecc1ffd3-eae0-46cf-8457-e2804b77bcd1	ff7017c4-6112-41e2-b62b-c606f392e04a	ba609fa2-c117-4b6e-a4ba-938cb0e4f117	pending	\N	2026-05-25 06:22:44.939077+00
93c36bdb-de3c-455a-869c-cc01dcb26f9b	ff7017c4-6112-41e2-b62b-c606f392e04a	7c5cb4d3-d911-4ec5-a435-e651d30c13ab	pending	\N	2026-05-25 06:22:44.939077+00
0e1d2023-031a-4b5e-86b4-a957e0a5e810	ff7017c4-6112-41e2-b62b-c606f392e04a	4d17c59e-7231-4a0f-bd3f-8294f90e212e	pending	\N	2026-05-25 06:22:44.939077+00
6b56b54d-66be-4511-831e-77f9d8679eeb	ff7017c4-6112-41e2-b62b-c606f392e04a	ae7ecff0-d962-497f-943b-4d772e2483b4	pending	\N	2026-05-25 06:22:44.939077+00
38489741-265e-4ce4-8282-d84ccdf68920	ff7017c4-6112-41e2-b62b-c606f392e04a	172dbd3e-8074-423c-a82b-16e77ea8a2b2	pending	\N	2026-05-25 06:22:44.939077+00
1815d772-fa0b-4124-b7f6-e04aa05f802b	ff7017c4-6112-41e2-b62b-c606f392e04a	7034d767-3884-4660-bdc7-ddcd51cd38c3	pending	\N	2026-05-25 06:22:44.939077+00
26a191aa-2059-4d6f-8c7a-74b800f00ceb	ff7017c4-6112-41e2-b62b-c606f392e04a	467d6f6c-4cef-4143-9e20-5827d6690cc1	pending	\N	2026-05-25 06:22:44.939077+00
0a57346e-b91f-43d3-a838-dce660c215b6	ff7017c4-6112-41e2-b62b-c606f392e04a	2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	pending	\N	2026-05-25 06:22:44.939077+00
61bb2052-e2f1-4b18-8b72-d09d35686daf	ff7017c4-6112-41e2-b62b-c606f392e04a	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	pending	\N	2026-05-25 06:22:44.939077+00
e8a395cd-9187-4d71-bea2-4174b1b0e7ad	ff7017c4-6112-41e2-b62b-c606f392e04a	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	pending	\N	2026-05-25 06:22:44.939077+00
85a1838f-4f63-4bd2-bbd8-846456c00b45	ff7017c4-6112-41e2-b62b-c606f392e04a	60084f34-305e-42b4-8330-70bba97a2126	pending	\N	2026-05-25 06:22:44.939077+00
d35f1b16-5c02-42d8-a5a9-0e6d324a48b7	ff7017c4-6112-41e2-b62b-c606f392e04a	44ae1d67-01ec-47d6-b057-c42404976678	completed	2026-05-31 14:24:12.139+00	2026-05-25 06:22:44.939077+00
\.


--
-- Data for Name: spiritual_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spiritual_tasks (id, title, description, assignment_type, created_by, created_at, updated_at) FROM stdin;
23ee7f44-7a2c-4659-b29c-1ecc8ce5ad1c	27 Navkar Mantra	Recite 27 Navkar Mantra minimum 7 times	all	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	2026-03-14 15:12:27.24429+00	2026-03-22 19:36:51.747834+00
c57d4d24-83fe-45ca-b3bb-fe8344b88a9a	Bow to your elders	Bow to your parents, Grand parents and everyone elder than you	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-03-23 05:31:23.169235+00	2026-03-23 05:31:23.169235+00
58253918-bc28-4443-a9f2-31f05e65a9aa	Don't waste food	Listen to your hunger- only serve what you need.	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-03-30 06:01:11.137002+00	2026-03-30 06:01:11.137002+00
113d7187-252f-40d4-a1ec-e258d6ed1923	Gratitude expression before sleeping	Before going to sleep every night, take a few minutes to express gratitude for your day	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-04-06 06:16:09.648776+00	2026-04-06 06:16:09.648776+00
4e340c6a-9c8a-4e52-8e0a-957d42581f11	Appreciating atleast 3 people everyday	Make a conscious effort each day to appreciate atleast 3 people around you	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-04-13 03:03:25.571278+00	2026-04-13 03:03:25.571278+00
aae2af18-ffe3-45ba-a4d3-f26a5f93305b	Connecting with nature through observation	Observe a tree for few minutes each day to feel calm and reconnect with nature	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-04-20 12:36:51.680508+00	2026-04-20 12:36:51.680508+00
21b6bcd0-c9de-4ab4-9f27-b1bd6831ee99	Mind Detox	Avoid using phones and all electronic gadgets between 11:00 pm to 6:00 am	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-04-28 16:02:13.492308+00	2026-04-28 16:02:13.492308+00
9145ca8b-2991-413f-a617-7dabbc4e9c53	15 minutes of silence	Take 15 minutes to stay quiet everyday helps calm mind	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-05-04 05:49:44.989803+00	2026-05-04 05:49:44.989803+00
ddaa0984-5fd7-414c-8de6-5aa4ecc7578d	Reading a good Book for 15 minutes daily	Reading can create a big impact on our personality, mindset and growth over time	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-05-11 11:41:59.419298+00	2026-05-11 11:41:59.419298+00
5ba72415-5ff8-4a25-aede-b919ffdbc917	Spreading positivity through appreciation	Kind words of appreciation can brighten someone's day and spread positivity	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-05-18 06:42:46.791494+00	2026-05-18 06:42:46.791494+00
ff7017c4-6112-41e2-b62b-c606f392e04a	Daily Journalising for self reflection	Writing the experiences of day in a dairy helps in expressing thoughts, emotions	all	7e72384f-5a73-498c-b82e-57dd17a6ea18	2026-05-25 06:22:44.360404+00	2026-05-25 06:22:44.360404+00
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, title, description, project_id, event_id, assignee_id, deadline, status, created_at, rating, feedback_comments) FROM stdin;
67ab99b4-a4c4-4340-b70a-1e519a1ff4a0	Blog on fasting and it's benefits 	Prepare a blog on benefits of Fasting on health for Genz	\N	\N	d176663a-6707-4d57-bf50-35e3e7b4a964	2026-02-28 00:00:00+00	pending	2026-02-26 07:03:40.480363+00	\N	\N
10c5c07a-6668-4366-9dc5-79fd2d4b898c	Prepare content for saathiyo and akshat pooja	Prepare content for saathiyo and akshat pooja	\N	\N	9a067c77-bb95-44cc-812e-4557ac17f80a	2026-03-22 00:00:00+00	pending	2026-03-05 17:41:08.968061+00	\N	\N
e23f5629-c44e-4ffa-a9b5-6bea2a308f4c	Prepare content for 3 dhagli and siddh shila	Prepare content for 3 dhagli and siddh shila	\N	\N	9a067c77-bb95-44cc-812e-4557ac17f80a	2026-03-29 00:00:00+00	pending	2026-03-05 17:41:40.939152+00	\N	\N
07956526-6ccd-46b6-bb44-6d2d97e61339	Prepare content for logic behind Vandana	Prepare content for logic behind Vandana	\N	\N	9a067c77-bb95-44cc-812e-4557ac17f80a	2026-03-15 00:00:00+00	in_progress	2026-03-05 17:40:40.681903+00	\N	\N
7b6bce02-1f92-4b5e-894e-47cb7da6c123	Prepare content for Vandittu mudra	Prepare content for Vandittu mudra	\N	\N	9a067c77-bb95-44cc-812e-4557ac17f80a	2026-03-08 00:00:00+00	completed	2026-03-05 17:39:56.275409+00	\N	\N
14de9568-d6a3-40ac-8273-12d3a4066e24	Website 	1.  Add an option in volunteer dashboard to view list of all volunteers to whom he/she is tagged as kalyan mitra. Similar to teamleader hub.\n\n2. Remove brochure\n\n3. Add new team/area of interest.\nTitle: Inhouse Pathshala and Home Schooling.\nDescription: Religious and academic teaching - virtually or in person. This initiative will eventually evolve into a comprehensive home schooling model.\nTeam leader: Jainam Mehta\nAdd three options/sub-team for volunteers interested to join this team - Religious teaching, academic teaching, both.\n\n4. Project managers will approve timesheets of respective volunteers and timesheets of project managers will be approved by Admin.\n\n5. Change password of admin portal. Something not too easy like ilovejinshan.\n\n6. When we click on 'login to apply' in a porject, it takes us to the home page. Instead the login / register window should pop up.\n\n7. Change team leader of content writing to Aayushi Shah from Jainam Mehta\n\n8. Change the hours required for Associate level to 20 from 10.	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-02-15 21:01:00+00	completed	2026-02-13 15:38:19.845069+00	5	test
7f6f3ea2-b1b9-492f-b274-2a6761b4da0f	test	test	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-06 00:00:00+00	completed	2026-05-02 12:47:07.830988+00	\N	\N
9bb16f6d-2636-4085-8642-e092c4525d63	test	test	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-05-08 00:00:00+00	pending	2026-05-02 13:27:41.255381+00	\N	\N
a2a0fba0-9d03-49a1-a0b7-6dd55b1a99a9	Voiceover for 3rd reason Reel		deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-05-17 00:00:00+00	completed	2026-05-16 05:00:09.090544+00	5	Awesome
13f20284-45d1-4900-ba59-96b8b6eb9ec0	test	test	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	e511ae7b-67bc-45ff-84f7-29be33b3a5e6	2026-05-07 00:00:00+00	completed	2026-05-16 05:22:30.980196+00	\N	\N
\.


--
-- Data for Name: team_meetings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.team_meetings (id, team_leader_id, team_name, title, meeting_date, meeting_link, minutes, created_at) FROM stdin;
ed70b1d1-85b1-4af2-b0a8-93df86be673a	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	IT & Technical Support	test	2026-05-15 20:01:00+00	test		2026-05-02 13:29:27.708066+00
\.


--
-- Data for Name: timesheets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.timesheets (id, volunteer_id, project_id, event_id, role, hours, work_mode, description, status, date_worked, created_at) FROM stdin;
b415b238-1ce8-462c-88a8-ba4c7454695d	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	1	Online	Edited Jainific highlights	approved	2026-02-03	2026-02-17 15:40:12.946133+00
24e94adb-1086-4d4b-a5cf-16c5456b7321	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing, Coordination	0.5	Online	Edited Jainific Highlights and Coordinated with Hiya ben for dhoop pooja reel	approved	2026-02-04	2026-02-17 15:48:22.177172+00
91eabc63-b344-48b0-ac00-ba30d91183cb	7e72384f-5a73-498c-b82e-57dd17a6ea18	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel shoot 	2.5	On-site	Gant reel shoot 	approved	2026-02-04	2026-02-18 05:22:25.366852+00
32971465-c131-4cd5-b192-d1c3d001d63e	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordination	0.5	Online	Coordinated with Hiya ben for dhoop pooja reel	approved	2026-02-07	2026-02-17 15:51:20.919426+00
9a2b2d63-72bd-453a-8ea9-8f690a228e2e	4c363395-b574-454e-abb9-bb28a79d09d3	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Acted in Aprigrah video	2	On-site	Inacted 2 parts of aparigrah videos at riverfront, Ahmedabad 	approved	2026-02-08	2026-02-17 14:52:14.751438+00
511c0bc8-790a-4aa8-923b-8754579e5ba0	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	3	Online	Edited why do we ring bell & generated AI images for the same	approved	2026-02-11	2026-02-17 15:52:09.482062+00
9adc8624-35c3-4f8c-b06b-881b19ad7890	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	\N	\N	website dev 	1	Online	added new feature for registration.	approved	2026-02-08	2026-02-08 12:59:51.232027+00
203181fd-8186-446f-9a11-b902b9ae3da0	4c363395-b574-454e-abb9-bb28a79d09d3	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Shooting video for Deepak Pooja	1	On-site	Went to the nearest Derasar and shot some videos with a friend for the Deepak Pooja. 	approved	2026-02-16	2026-02-17 14:44:05.915115+00
26c4760e-4f7f-4359-979d-2a1b48f5e03b	58be09cf-362d-4919-9a0a-67aa65a5c52e	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Speaker for Samayik Avashyak Reel	2	On-site	Samayik Avashyak Reel	approved	2025-12-22	2026-02-10 17:39:43.828327+00
5c55955e-e84a-43be-b4e2-623ea8e2066a	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	\N	\N	test	2	Online	test	rejected	2026-02-08	2026-02-08 13:08:37.307443+00
aefcbb69-756e-4d57-8bd8-d8e615bc8cd6	6a89d207-b9ef-4e2b-9a9a-14b42000db10	\N	\N	Pathshala activites 	1	On-site	Games	approved	2025-12-26	2026-02-12 17:22:22.656748+00
83223a12-6b37-4097-aecb-c08e1df30476	6a89d207-b9ef-4e2b-9a9a-14b42000db10	\N	\N	Pathshala activites 	1	On-site	Games	approved	2025-12-12	2026-02-12 17:21:37.322694+00
f8dfbc75-8bb6-4281-9cce-f82f63f0e1fd	6a89d207-b9ef-4e2b-9a9a-14b42000db10	\N	\N	Pathshala activites	1	On-site	Games	approved	2025-12-05	2026-02-12 17:20:34.104962+00
79409399-15d0-49f0-9474-c3bd1db05203	58be09cf-362d-4919-9a0a-67aa65a5c52e	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Guide	8	On-site	Guide for Anekantawada and Psychology of emotions	approved	2026-02-10	2026-02-10 17:38:00.555813+00
93a72475-d3ca-4029-a459-5720d63eb4a2	6a89d207-b9ef-4e2b-9a9a-14b42000db10	e371d3f0-7356-4f5b-8616-300df65bfea7	\N	Put a cover on the books	1	On-site	16 books	approved	2026-01-24	2026-02-12 17:16:34.138431+00
fade2f93-610b-4449-864b-8505d08a57d5	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Admin work	2	On-site	Coordination for data transfer in hard drive, with printer for library stickers and receipt books. Preparing list of volunteers for 5K followers on insta felicitation.	approved	2026-02-15	2026-02-15 17:16:51.907118+00
2b2ff82b-37c8-447c-8735-9bc61704cfd6	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Content writing 	2	Online	Content writing for Chaityavandan mudra	approved	2026-02-15	2026-02-15 17:13:05.181534+00
6736a1f5-5c1e-411c-9ab7-54599ee37b4b	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	Website testing 	1	Online	Testing website and suggesting required changes 	approved	2026-02-15	2026-02-15 17:14:22.803137+00
46769bd6-31fa-4ce5-8275-1e58e7e9a293	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Volunteering	12	On-site	Volunteered the event.	approved	2026-01-18	2026-02-17 13:47:07.356461+00
6d5c8c84-627a-482b-b4bd-e48c642ccdc6	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Admin	850	Hybrid	Admin work, coordination, content writing, etc.	approved	2026-02-16	2026-02-21 11:34:41.324403+00
d992e302-9396-4f2d-88d9-d359433e7eaa	f51b0111-f04d-453a-b6c0-60d9832fba6b	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Guide	7	On-site	Guide	approved	2025-10-12	2026-02-21 17:21:25.025633+00
ad978b9e-7485-4359-a67e-02adca06cbaa	f51b0111-f04d-453a-b6c0-60d9832fba6b	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Scripts Preparation	30	Online	Prepared Scripts for 10 Topics (Nov 2025 -Dec 2025)	approved	2025-12-21	2026-02-21 17:24:25.887888+00
d5da8ab4-c18e-4c71-99d1-ae7ddfd9c07d	481b2283-318d-48b8-94f3-63c9f6fcf7af	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Volunteering 	6	On-site	I was a volunteer at the 3rd floor 	approved	2026-01-18	2026-02-22 06:43:04.073997+00
18801500-ae82-4524-90d8-a44fdd7f1eec	f51b0111-f04d-453a-b6c0-60d9832fba6b	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Guide	8	On-site	Guide 	approved	2026-01-18	2026-02-21 17:19:44.192798+00
c0325062-bb5f-4013-a237-aa93b87f388a	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Planning, Cordination, Voiceovers, Editing, Overall Management and Arrangement	805	Hybrid	Management of Social Media Account, Arrangements for shooting, planning and editing reels, cordination etc (from 25th July to 17th Feb)	approved	2026-02-17	2026-02-21 17:17:42.598163+00
43f13077-b093-4a53-96c1-9db6e4940db2	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Planning, discussion, cordination	1.5	Online	Planning, dicussions and cordination work for upcoming content	approved	2026-02-18	2026-02-21 17:12:05.677265+00
6ee9e562-227f-41c3-9aaa-df9fe2f9e804	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reviewing and Discussing new ideas	1.5	On-site	Reviewing reel and discussing ideas with arpita ben for the upcoming reels	approved	2026-02-19	2026-02-21 17:08:25.25512+00
a889378c-676f-4832-8af8-f1f3220f3de0	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Planning and cordination	2	Online	Cordinated with Arpita ben for editing purpose, disha ben and prisha ben for shooting purpose, Mahek ben for video sorting and Aayushi ben for scripts and shoot arrangements	approved	2026-02-20	2026-02-21 17:05:09.097273+00
da382812-1176-47d6-98d1-00ccf1bbc191	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Voiceover and Cordination	2.5	Online	Voiceover, Cordinated with Arpita Ben, Disha Ben and Prisha Ben for shooting and editing purpose.	approved	2026-02-21	2026-02-21 17:00:42.857152+00
295effea-a0c1-45db-839e-412785a53863	55ca6718-5a82-408d-800d-86cc3c49bbca	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Shooting 	2	On-site	Did the shoot for darpan pooja video	approved	2026-02-14	2026-02-22 13:18:10.659326+00
bce76c96-9910-4446-a92e-fb08b2ce3c11	55ca6718-5a82-408d-800d-86cc3c49bbca	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Supervising the shoot	2	On-site	Supervising the shoot \nCoordinated before shoot with members 	approved	2026-02-02	2026-02-22 13:16:09.428994+00
e033eeb2-3ed2-4aa7-8340-7496a719c7c0	55ca6718-5a82-408d-800d-86cc3c49bbca	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel shoot ( on cam )	1	On-site	I contributed in digital awareness through reel in dhoop pooja video 	approved	2026-01-25	2026-02-22 13:21:32.131259+00
4909ab41-9b92-470a-95e9-57f48971744c	03a59a7d-da67-44b8-88f7-1a0fbe44f706	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Blog writing 	2	Online	Blog writing 	approved	2026-02-16	2026-02-26 06:57:43.957289+00
06103cd3-f929-4941-8c88-c86b69d2042e	03a59a7d-da67-44b8-88f7-1a0fbe44f706	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Setup of topics and ILJ Publicity 	10	On-site	Helped in arranging topics in exhibition along with explaining others what ILJ is and part time guide too	approved	2026-01-18	2026-02-26 06:52:20.652621+00
84347053-d1f7-4e40-80db-5bbdc80ab762	03a59a7d-da67-44b8-88f7-1a0fbe44f706	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Udaan Event	6	On-site	Publicity of I love Jinshashan in Udaan event 	approved	2026-01-17	2026-02-26 06:53:07.753109+00
7bf38eaa-a81c-480a-b0d3-905e8c2e396e	4de93087-ee99-48dc-b3a5-4339c8da81ec	\N	\N	Pathshala game	4	On-site	Prepared questions based on jain dharma and played in pathshala 	approved	2026-02-20	2026-02-24 09:37:50.293553+00
468d1372-727d-4085-94c7-a5b3cabf1a59	232f55ca-9598-4daf-a8ef-5e9be124c975	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Hemchandracharya Research	2	On-site	Blog post on Diksha divas	approved	2026-02-06	2026-02-26 12:53:05.323523+00
179a5b2f-6234-45de-b27f-32575ba50f14	232f55ca-9598-4daf-a8ef-5e9be124c975	\N	\N	Research on crimes against children in schools 	0.5	Online	Finding studies, stats and data on the internet	approved	2026-02-19	2026-02-26 12:54:01.589566+00
e871cfbc-ff96-40fa-a39a-b05be3c955a0	4842d49f-c3ea-47a4-bfee-03837bec04a5	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	handling the art stall	6	On-site	painting keychains and helping people by assembling the keychains	approved	2026-02-12	2026-02-12 07:39:25.156259+00
ef787271-9bbf-4e64-820a-80d669c9edc8	03a59a7d-da67-44b8-88f7-1a0fbe44f706	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Blog research 	1	Online	Blog research 	approved	2026-02-23	2026-02-26 06:53:59.548567+00
06777803-7bec-47b5-adcb-69735fc600ee	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	3	Online	Edited Fagan Sud Teras reel 	approved	2026-02-24	2026-02-26 17:47:07.285965+00
6de11415-66b1-427c-9cf2-11fc32a1c052	7e72384f-5a73-498c-b82e-57dd17a6ea18	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Admin Task 	1	Online	Putting messages individually to everyone and other small things 	approved	2026-03-01	2026-03-01 06:09:52.302791+00
e0a074c5-5f63-4569-a19b-b7f60f21aec2	4de93087-ee99-48dc-b3a5-4339c8da81ec	\N	\N	Pathshala activity	2	On-site	Pathshala activity friday	approved	2026-02-27	2026-03-01 12:22:38.13065+00
848e0115-d0bc-4541-9412-3d394c0e3f3b	6a89d207-b9ef-4e2b-9a9a-14b42000db10	\N	\N	Pathshala activities	1	On-site	Game	approved	2026-02-20	2026-02-26 15:13:03.175509+00
72d952b8-794a-4a97-84f7-8aba166303de	7e72384f-5a73-498c-b82e-57dd17a6ea18	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Shooting 	1.5	On-site	Went for a shoot of Corriender 	approved	2026-02-28	2026-03-01 06:08:53.168397+00
d7669d9a-ea5b-4573-b7ec-ebd1f67cea1a	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	2	Online	Edited Holi Reel 	approved	2026-02-28	2026-02-28 15:55:07.10923+00
68b23c1a-3cad-4faf-83e6-114ae071db41	7e72384f-5a73-498c-b82e-57dd17a6ea18	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Messaging	1.5	Online	creating contacts, sending excel sheet to kalyanmitra and adding everyone in new groups 	approved	2026-03-03	2026-03-03 15:35:12.356237+00
e2101ba6-1ba3-4e60-bd1f-9e9797d02df2	d176663a-6707-4d57-bf50-35e3e7b4a964	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Writing Blogs	2	Online	Blog on 18 Paapsthānak	approved	2026-03-02	2026-03-03 16:05:04.902001+00
9cc3aa0b-081f-4299-9842-37e16cb3fb17	58be09cf-362d-4919-9a0a-67aa65a5c52e	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel Shooting 	2	On-site	Dry fruit reel	approved	2026-02-28	2026-03-14 16:00:56.403231+00
8865896e-a454-4ac0-ba3c-d4b6234ca746	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating AI Images 	1	Online	Generated AI images for Coriander, Deepak Pooja, Dry Fruits & Katashana	approved	2026-03-03	2026-03-15 17:39:08.120801+00
2f189fd4-95bd-457f-84c7-8a4cde82efb6	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordinating 	0.5	Online	Coordinated with Tanisha ben for coriander reel,Niti ben for dry fruits reel 	approved	2026-03-12	2026-03-15 17:41:41.603813+00
f79da69e-8f75-4aab-a44e-b1196ca788a1	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Video Editing	3	Online	Edited coriander reel which describes why we avoid eating coriander and certain green leafy vegetables after fagan sud 13	approved	2026-03-14	2026-03-14 15:24:37.358714+00
c45938c5-8ddc-46c8-9daf-ae85fcc34d06	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Video editing 	3	Online	Edited Darpan pooja reel 	approved	2026-03-06	2026-03-14 15:31:05.062767+00
5d3dd84a-4cc4-44bf-9ad9-3d9a12054abf	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	2	Online	Edited Deepak Pooja Reel	approved	2026-03-04	2026-03-15 17:35:56.037346+00
7a1c0a6d-5941-4e88-b1f4-c7801164adc4	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	2	Online	Edited Why do we apply Tilak reel	approved	2026-03-17	2026-03-22 05:50:54.517341+00
988c942c-625f-4285-b3fc-a794d6e34e27	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel editing	4	Online	Reel edited - Katashana\nThe hours mentioned is from scratch to approved.	approved	2026-03-23	2026-03-24 07:52:27.277139+00
dbca7a82-6772-43c1-990d-986313119808	7e72384f-5a73-498c-b82e-57dd17a6ea18	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	reel shooting	3	Online	shooting done for veer vanshaj 4.O in ville parle 	approved	2026-03-16	2026-03-24 07:52:39.026322+00
cee431ce-c05c-4a80-b352-eca4abbdfa3d	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordination	0.5	Online	Coordination with Sujal bhai for Why do we use Katashanu reel	approved	2026-03-20	2026-03-30 17:18:35.652085+00
2c1656ab-cbd8-45a8-b941-da904eafab4a	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Content writing 	0.5	Online	Vandana script editing 	approved	2026-03-27	2026-03-29 06:27:19.519144+00
2751258e-bdd7-43c4-ac9f-baadcd79b1c1	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Content writing 	0.5	Online	Edited logic behind Vandana script	approved	2026-03-31	2026-04-02 14:23:24.685977+00
00ff919e-a451-4d87-bbe7-8b5d66474c9f	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordination	1	Online	Coordinated with Hiya ben for Mahavir Janma Kalyanak reel & generated AI images for the same	approved	2026-03-30	2026-03-30 17:16:49.931151+00
482f008b-97ab-4864-92d9-16b2739fd37a	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel editing	3	Online	Chaityavandan reel edited 	approved	2026-04-04	2026-04-11 03:33:10.116951+00
58252a89-0e0b-4dfc-af37-81de7f25f16d	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Model Making 	1	Hybrid	 Model for Rebirth concept 	approved	2026-04-11	2026-04-12 09:19:24.571497+00
952f97b0-a7f4-4739-9287-ea01852f4a5a	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Model 	1.5	Hybrid	Model for Rebirth concept 	approved	2026-04-10	2026-04-12 09:19:54.690445+00
44e0a00b-5e67-4c95-977e-cb3d4a5bfb64	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Model 	0.5	Hybrid	Model for rebirth topic 	approved	2026-04-09	2026-04-09 17:03:21.838647+00
e085463d-41dd-46e0-b95b-a6ece53dd3a3	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	script 	1	Online	With reference to the script given , made pointers of the same so that it can be easy to the one explaining the topic .	approved	2026-04-01	2026-04-07 16:25:32.451296+00
240bec7e-3eae-445f-a853-b8daf4a8e167	486cb7fe-4375-44d1-b124-e2460ab1826a	\N	\N	Editing	2	Online	I re-edited the video on Chaityavandan using some provided changes 	approved	2026-03-28	2026-03-28 16:52:01.130739+00
152dbbc5-f077-4f24-9998-e640b768c2af	96c9c515-49dc-4172-95d9-7a57478388c3	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	14	Online	Reel on Mahaveer Janma kalyanak 	approved	2026-03-28	2026-04-05 05:37:39.041995+00
dd362aca-c3fb-4ba6-bf64-8cf9a7d7c9af	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	script 	0.5	Online	Made pointers for the script .	approved	2026-03-27	2026-04-07 16:26:41.5697+00
d5b6e47a-9603-44a0-b5a7-de4b104b752c	486cb7fe-4375-44d1-b124-e2460ab1826a	\N	\N	Editing 	1.5	Online	I edited video on Chaityavandan 	approved	2026-03-26	2026-03-28 16:50:57.850203+00
d30d24ea-f41f-41d2-b338-b184162470a7	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	script 	1	Online	made pointers for the script 	approved	2026-03-26	2026-04-07 16:27:47.396768+00
4756e859-f82f-4640-86e6-deacce918d3c	d22fd755-c0a9-4474-8280-64d42c126700	\N	\N	Content writing 	0.5	Online	I made 2 scripts of dialogue nd voice over for logic behind Vandana	approved	2026-03-24	2026-03-24 02:30:01.281764+00
59c78abd-c355-4dd1-9260-46ba560b2ad3	7e72384f-5a73-498c-b82e-57dd17a6ea18	\N	\N	general meeting for discussion 	2	Online	with all the core members	approved	2026-03-24	2026-03-24 07:51:09.931328+00
af39bf89-bd31-446c-ab89-c3e6b1ed2463	6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	\N	\N	Played games	1	Hybrid	Played religious games to everyone in pathshala	approved	2026-03-20	2026-04-05 08:43:02.497474+00
b4b92340-9c99-4efe-af5f-11f62903fa16	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	\N	\N	Reels 	1	Online	Sharing reels with many people for a week for normally spending 10 mins on Instagram 	approved	2026-03-14	2026-03-15 05:22:10.909552+00
56a438af-f734-4dc0-b10a-3193e3a772ec	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	reviewing edits	0.5	Online	reviewing edits	approved	2026-03-04	2026-03-05 06:12:53.075665+00
be9bbfe7-561b-439c-b0bb-c4b3675004b5	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	cordination and explanation	1	Online	Cordinating and explaining the upcoming edits 	approved	2026-03-02	2026-03-05 06:05:04.951259+00
301aafe8-2052-4367-bd35-fc5fb2167b8c	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reviewing	0.5	Online	reviewing edit	approved	2026-02-28	2026-03-05 06:09:12.623171+00
90e29ef7-7a4d-4d40-8ea9-6fa4ee004541	f51b0111-f04d-453a-b6c0-60d9832fba6b	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	cordination	0.5	Online	Cordinated with Arpita ben, Mahek ben, Disha ben and Prisha ben.	approved	2026-02-27	2026-02-28 08:24:55.582411+00
6bd0ed7a-b4f2-43a1-9160-55135f0c2cbd	f2179127-e88f-41f3-910a-f9dd0fa2647a	\N	\N	Teaching	2	On-site	Children's ne game ramadi, (5-parmeshthi na color) 	approved	2026-02-27	2026-03-07 14:04:41.705718+00
27be542b-109c-40d8-a8db-d0b983024a4a	6a89d207-b9ef-4e2b-9a9a-14b42000db10	\N	\N	Game	1	On-site	Pathshala activites 	approved	2026-02-27	2026-03-01 16:12:49.291621+00
5856374b-aa49-4cb7-b766-b3bbd93edc4a	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	\N	\N	Sharing 	0.5	Online	Instagram reels shared with more than 20 persons 	approved	2026-02-22	2026-03-01 12:28:55.880624+00
c0397243-5a1b-4004-9e44-f14368b227f2	4842d49f-c3ea-47a4-bfee-03837bec04a5	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	teaching	6	On-site	Handling the art stall(keychain making) 	approved	2026-01-18	2026-03-14 16:18:47.049397+00
3c4b4ff8-e7d2-48b5-b08f-3a7d9b06af7b	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Updating quiz winners name	1	Online	Updating weekly quiz winners of Why do we use Katashanu , Mahavir Janma Kalyanak, Chaityavandan & Akshat Pooja Reel	approved	2026-04-22	2026-04-22 10:09:14.029834+00
8434b216-b0cd-4c4e-97bc-c930831f0995	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	1	Online	Edited an appreciation banner 	approved	2026-04-16	2026-04-27 13:26:05.69551+00
8d2d0804-8899-4b5b-b3ef-0465cce103cc	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Creating Banner	2	Online	Creating banner for Winter Camp 2026	approved	2026-04-09	2026-04-17 09:18:44.592336+00
01f496f1-5257-46b4-9931-e9cd89e88787	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating AI images	0.5	Online	Generated AI images for Akshat Pooja Reel & Coordinated with Aashi Ben regarding the same	approved	2026-04-08	2026-04-17 09:17:41.031208+00
9580d911-0020-4545-9447-d5e869259a8f	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	4	Online	Generated AI video for Muhpatti Reel	approved	2026-04-07	2026-04-17 09:15:55.442166+00
7a5f2026-6845-4428-af79-bd0ee631efc6	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Designing	0.5	Online	Designed banner for spiritual tasks	approved	2026-04-05	2026-04-05 17:09:03.538498+00
b332120b-104d-4b82-81e8-3ef09a0b0a6a	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordination	0.5	Online	Coordination with Sujal bhai for Chaityavandan reel & generated AI images for the same.	approved	2026-04-04	2026-04-05 17:08:19.968501+00
75f6a4da-78f1-48ae-afc2-434bd40ec043	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	test	5	On-site	test	approved	2026-05-02	2026-05-02 12:54:54.968853+00
3afedf6d-318e-45c3-91ba-4b1517dd7185	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Editing	1.5	Online	Editing for reel	approved	2026-04-29	2026-05-01 09:57:15.784447+00
39b9efbf-6b58-4b6e-8dbd-dc04644968cb	7e72384f-5a73-498c-b82e-57dd17a6ea18	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Admin related task	2.5	Online	Calling, sheet updating, coordinating with people Management,etc 	approved	2026-04-29	2026-05-01 15:31:24.885136+00
ca85f450-132a-4a8d-8d6a-98ff9eb2ae80	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	pointers for the script 	1	Online	made pointers for the script 	approved	2026-04-14	2026-04-14 18:23:08.797528+00
eb5971ad-ebe3-4972-87e8-79a4df68bbe8	481b2283-318d-48b8-94f3-63c9f6fcf7af	\N	\N	content writing 	2	Online	writing shibir content on the topic minimalism 	approved	2026-04-29	2026-05-02 06:20:28.696776+00
d8f05089-da4b-41ba-98da-2912b80b7d5f	481b2283-318d-48b8-94f3-63c9f6fcf7af	7b25f17b-43dc-431b-bd80-2a0033602e75	\N	content writing 	1.5	Online	writing shibir content on the topic minimalism	approved	2026-05-30	2026-05-02 06:22:22.814042+00
ff9642af-da13-47a2-8ea6-7552c4664d7b	4842d49f-c3ea-47a4-bfee-03837bec04a5	\N	\N	Designing and editing	2	Online	Making the currency for IlJ and its events	approved	2026-04-28	2026-04-28 11:16:51.797852+00
872874b3-a8f9-441c-9b5a-727664199a55	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Logo designing	1	Online	Desigining of logo for reva reel	approved	2026-04-28	2026-04-28 11:50:41.252149+00
c3f7eced-77d6-441b-97e6-1f57826e04ca	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Meeting	4	Online	Conducted meeting for Graphics team & prepared points for the same & coordinating with team members regarding the meeting points	approved	2026-04-26	2026-04-28 11:50:02.160488+00
8c85b90d-6815-4401-830c-b3c62de5d902	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Script making 	1	Online	made script in english 	approved	2026-04-24	2026-04-24 16:56:34.68748+00
4b0724e8-fc25-47a9-bb7b-cbfd6e3d46e7	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating banner & Coordination	1.5	Online	Generating banner for monthly quiz announcement & coordinated with Riddhi ben for Sanskar Library & with Tanisha ben for Reva reel	approved	2026-04-24	2026-04-28 11:48:02.741954+00
9af92e5a-3f7b-4768-8837-c128cb4ffeb0	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating	1	Online	Generated AI images for Global crisis reel & coordinated with Sujal bhai regarding same	approved	2026-04-23	2026-04-28 11:46:16.780137+00
d8536802-338a-4c13-bfcf-500c5a34d1ce	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Script making	1	Online	made pointers for the script 	approved	2026-04-21	2026-04-24 16:57:47.892653+00
1b5655d2-6535-4b0d-9714-6beca1ae0f2b	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Script Pointers 	1.5	Hybrid	Made pointers for mind reading topic and searched for examples 	approved	2026-04-12	2026-04-12 16:37:21.618021+00
b5195f87-4b86-4b1a-8417-3bca0c749a2b	55ca6718-5a82-408d-800d-86cc3c49bbca	e371d3f0-7356-4f5b-8616-300df65bfea7	\N	Visiting Pandurang vadi pathshala 	1.5	On-site	Visited pandurang wadi pathshala took the feedback of children & did the announcement for competition 	approved	2026-02-16	2026-02-22 13:24:35.891984+00
6f23ccd1-179b-4395-bfb0-d41d916459b1	4524f75e-4135-4a2c-8bfb-02dc30ae126b	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	e	0.5	On-site	zsfffdd	approved	2026-05-07	2026-05-07 17:21:27.310315+00
2a694bd0-f909-49b2-b3e0-92762eb9009e	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Editing and Script 	3.5	Online	Editing for reels and pointers in english for script 	approved	2026-05-02	2026-05-03 16:36:54.555126+00
f0ae28c7-e204-47eb-8a53-dec3fa5256f7	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing images 	1	Online	I had generated banners from AI using chatgpt and Copilot, so I had to do some modifications in them and also below it. 	approved	2026-05-09	2026-05-11 08:18:04.818329+00
671b9a4f-5ab8-44d4-8740-bd75a04e9204	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	1	On-site	So I had generated some images before hand about the reasons PDF and I was given a task to recreate and edit some of them, I tried from 7 to 8 images one out of got a thumbs up in other images I couldn't do well. 	approved	2026-05-05	2026-05-11 08:37:45.898454+00
cfb0d259-4f7e-4783-ac31-acba846ff3d8	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	monthly mega quiz promotion reel	4.5	Online	Edited reel for monthly mega quiz (jethalal reel)	approved	2026-05-04	2026-05-06 08:30:16.65871+00
d21f3add-9640-4e57-8420-564824df7c6b	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	1	Online	Work done for second reason from the 5 reasons PDF. Generateed images from AI as required.	approved	2026-05-02	2026-05-11 08:30:56.054208+00
00d21cfa-fdab-4760-8a69-1a027c53e6cd	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	1	Online	I walked on the first reason for the five reasons PDF. I generated images from AI and submitted them to arpita di.	approved	2026-05-01	2026-05-11 08:24:46.065143+00
86399cc2-bab2-45bb-8abe-abea411cc3fa	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	1	Online	So for making a real about a topic 5 reasons I was working on the introduction part of images on this day. 	approved	2026-04-30	2026-05-11 08:23:13.232464+00
b83ebec5-ee4d-4a4d-87c9-9691eb9a58c6	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Global Crisis	4	Online	Editing done for this reel	approved	2026-04-25	2026-05-06 08:26:54.839336+00
4be6393f-13d1-45a0-a585-77e4a51ecc40	7e72384f-5a73-498c-b82e-57dd17a6ea18	c3d175f3-dd6e-4000-bd32-ebe20b589705	\N	Calls 	1.5	Online	Calls to them who have attended demo session	approved	2026-05-04	2026-05-06 08:21:02.904516+00
d7ff7b6c-0557-4bdb-b716-bed17fec9849	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  Creation	0.5	Online	Scripts for Anekantvaad shibhir	approved	2026-05-03	2026-05-03 14:59:12.896886+00
3170d761-576f-4127-b6c6-7dbecf7c5cf8	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  Creation	0.5	Online	Scripts for Anekantvaad shibhir	approved	2026-05-01	2026-05-03 14:58:42.466914+00
ccb6d0e7-71bc-45af-b829-9a4804176c20	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  Creation	2	On-site	Scripts for Anekantvaad shibhir	approved	2026-04-25	2026-05-03 14:58:12.871693+00
894ed454-c98c-4936-b810-7f5861fed76a	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  Creation	0.5	Online	Podcast series for four bases of anekantvaad	approved	2026-04-22	2026-05-03 14:56:08.380511+00
91de55fd-b18e-42cc-af38-d796e2f3adec	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  creation	0.5	Online	Podcast series on 4 fours of anekantvaad	approved	2026-04-20	2026-05-03 14:54:26.067234+00
0c7044b8-674f-4405-b22d-982fbf6f5f59	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content  Creation	0.5	Online	Podcast series for four bases of anekantvaad	approved	2026-04-21	2026-05-03 14:55:49.943281+00
a34caf6f-5a55-4e3d-b79e-30092cb8019d	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generate images	1	Online	I generated images for swastik reel. Used chat gpt, generated and edited likewise.	approved	2026-05-28	2026-05-30 17:11:54.081865+00
7d9b28eb-5de2-41d1-95c7-7d1b3ec98834	1faa2e14-2817-46d8-8f9e-5e7b70855a98	7b25f17b-43dc-431b-bd80-2a0033602e75	\N	Content writing 	2	On-site	Wrote poems and content/script for the reels	pending	2026-05-26	2026-05-31 14:03:18.67991+00
f2de8e36-740c-4626-8333-36a6a87d84a3	7e72384f-5a73-498c-b82e-57dd17a6ea18	1ba3dd33-5e3b-43b0-a272-a1a978804d39	\N	Visiting gaushala	5	On-site	went to bhiwandi to visit shree gopal gaushala 	pending	2026-05-31	2026-05-31 14:07:57.456661+00
a5e7400b-6bb2-4299-8287-bbe5c89c1aa7	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	8cb7137b-6d45-494b-afaa-b6e8019305c3	\N	Editing for REVA reel	0.5	Online	generated ai images 	approved	2026-05-12	2026-05-13 05:16:04.189028+00
c51a6b30-8033-4a60-8dda-8289facfa12a	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating and Editing images for reels 	1.5	Online	So I have to generate images from AI about the content I am given, so I use chatgpt and Copilot for generating the images and then send it to person who sent me this. And do some modifications as they need 	approved	2026-05-11	2026-05-11 08:16:18.887782+00
de7729d5-a7fc-45c5-9b98-6bfd55ddd67c	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating image	2	Online	I had given at ask to generate 4 banners for the upcoming events VEER VANSHAJ. I made some and then there were some modifications needed so I made some new ones and that's what I did that day.	approved	2026-05-08	2026-05-11 08:39:52.908649+00
f5e86020-b733-49f0-b2fa-c8b268d94217	117f2d44-cb82-475c-bdf9-841f771649d5	\N	\N	Content creation	2	Online	Scripts for Anekantvaad shibhir	approved	2026-05-10	2026-05-13 02:46:40.917+00
a21b6105-cb52-4427-97e4-dfacd20a44dd	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	1	Online	Edited Banner for Reva - Experience the divine	approved	2026-05-14	2026-05-15 15:58:28.602322+00
c21b3002-d7af-48a1-8b28-b2713e8c149e	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel Editing	3	Online	Reel edited:- From the 5 Reasons one is - Time	approved	2026-05-14	2026-05-15 14:05:18.468379+00
1fc05119-bc54-4a12-b7e6-fd24f3ea6ceb	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating images	2	Online	Worked on Reason 3 and 5 of '5 reasons pdf'. Generating images for reason 5 and doing modification of images of 3rd reason. 	approved	2026-05-13	2026-05-15 05:36:57.836014+00
798e820f-687e-410a-a4d8-192e7288f91f	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating images 	2	Online	Worked on Reason 3 and 4 of '5 reasons pdf'. Generating images about both reasons and doing modification in 3rd reason. 	approved	2026-05-12	2026-05-15 05:34:52.184636+00
612dc83a-a54d-4e78-99ab-e1b493942698	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	5	Online	Edited Reva - experience the divine reel 	approved	2026-05-10	2026-05-15 16:00:24.176802+00
50979451-7405-4d1d-a4a7-a4ca3c4c01f0	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	\N	\N	Meeting	1	Online	attended the volunteers meeting	pending	2026-05-20	2026-05-21 08:00:08.259887+00
35c09eb7-7bfc-4b8a-b43e-33fd5f124da1	f854a439-e72d-44fc-8efe-a0f755462a04	\N	\N	Kalyan Mitra Meetup and Catching up	1.5	Online	Called multiple Kalyan Mitras to know about them and attended the Kalyan Mitra online meet to learn more about the 2 new pods, Reva and Kiva.	pending	2026-05-20	2026-05-21 08:36:46.755185+00
5cc90fd3-5824-4505-a7cf-2f4c8b42674d	55dbfa08-450b-42c5-9372-6b24963f36b5	\N	\N	Attendee	1	Online	Attended the meeting.	pending	2026-05-20	2026-05-21 14:13:43.513718+00
9c1d0acf-ab5e-484d-9ee2-e5822582f0d9	a551cf3f-5282-49ea-b432-7624af5558b2	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Scripting	3	Hybrid	Scripted a shibir script for topic about food and nutrition in jainism	approved	2026-05-17	2026-05-17 13:01:15.924119+00
27b042b4-4725-4272-ab53-0a4ca64c218b	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Content Creation	1	Online	Content creation for Minimalism shibhir	approved	2026-05-15	2026-05-18 07:11:52.64451+00
3533a9c2-6ff7-4d2e-ae87-f41157e2611c	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Content creation	0.5	Online	Content creation for Anekantvaad shibhir 	approved	2026-05-13	2026-05-18 07:11:08.845319+00
f4a7ad88-4add-4e30-a8e9-7112c1730d0f	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Content Creation	0.5	Online	Anekantvaad Shibhir planning	approved	2026-05-12	2026-05-18 07:10:19.429054+00
c3e4488c-cbf2-4000-a815-9099a4895f8f	d22fd755-c0a9-4474-8280-64d42c126700	7b25f17b-43dc-431b-bd80-2a0033602e75	\N	Content writing 	7	Online	Completed finaaaly today on forgiveness \nForgot to upload on daily basis..\nBut approx it took 1 week nd daily 1 1.5 hr to write nd frame + think a part of it...so approximately 7 hrs maybe	approved	2026-05-10	2026-05-21 07:01:27.754605+00
0b41a075-4668-4070-835d-4df24c47a611	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Script Making 	0.5	Online	made pointers for script and excel sheet 	pending	2026-05-22	2026-05-22 16:56:21.590556+00
61bacb81-6e76-4ec3-8810-641e399f6007	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Group meeting	1	Online	Group meeting	pending	2026-05-20	2026-05-23 09:42:29.787313+00
027592d5-c01f-459c-9a83-354e4fa8f7a2	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Content creation	2.5	Online	Drafting fot Mindfulness script - Anger	approved	2026-05-23	2026-05-23 09:43:10.64281+00
72896177-2078-41b4-9458-5ee274386191	0c6384b4-15bd-42b1-a978-317e1d163f8d	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Coordination	12	Online	Coordinated with Tanisha ben for Reva reel, Aashi ben for Introduction of 5 reasons, Sujal bhai - Monthly Quiz reel & 1st & 3rd Reason , Khushi ben - Monthly Quiz,Reva Reel Niti Ben - 2nd Reason, Harshil Bhai - for cover pages, Sakshi ben - generating AI images, Jash Bhai - for designing Veer Vanshaj Banner & Sanskar Library banner & Attended meet on 20th may	approved	2026-05-23	2026-05-23 08:49:55.302873+00
504c8c03-243b-47d7-a58b-92d99c1da475	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Content creation	1	Online	Drafting for Minimalism shibhir	approved	2026-05-19	2026-05-23 09:41:59.57039+00
3c6addd1-f39a-4092-a376-90f061d092ab	117f2d44-cb82-475c-bdf9-841f771649d5	1736f19b-b817-4bc5-888b-a412f464e03a	\N	Shibhir planning	3	On-site	Planning of Shibhir activities with sahebji	pending	2026-05-24	2026-05-25 02:47:43.392831+00
4a09f581-08b1-4c0a-beb1-dda0a5fefad9	55dbfa08-450b-42c5-9372-6b24963f36b5	8cb7137b-6d45-494b-afaa-b6e8019305c3	\N	Managing the event	2	On-site	Managed the execution of the REVA event! 	approved	2026-05-17	2026-05-21 14:14:45.448109+00
9e66202a-7256-4c6d-871d-d8035634dbfc	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	8cb7137b-6d45-494b-afaa-b6e8019305c3	\N	Editing 	0.5	Online	Reel editing for REVA 	approved	2026-05-18	2026-05-20 16:25:32.524349+00
bdc912b2-3460-48f5-ae2c-d498052e3fa6	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	8cb7137b-6d45-494b-afaa-b6e8019305c3	\N	Editing 	0.5	Online	Reel editing for REVA	approved	2026-05-19	2026-05-20 16:25:11.253726+00
0e178fc3-c265-4a71-8ce2-12d936ff1382	9e34793f-4532-4cf0-8e19-bb36a03057d2	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	3	Online	Edited Reva event highlights reel held in dahisar 	approved	2026-05-21	2026-05-25 11:43:52.89994+00
8e118a7f-7ff1-43de-8823-59d8f12efdfd	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Compilation of Data for content writing 	3	On-site	I read from multiple sources about 7 nd 8 papasthanak nd 1 2 Karma \nDaily approx ½ hr since 23rd may to 28th May	approved	2026-05-28	2026-05-28 23:40:01.584959+00
d332726f-12e9-40b3-af12-d7049dda5bdd	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Content writing eote 	2	On-site	Wrote a script On 1 nd 2 karma 	approved	2026-05-29	2026-05-29 00:25:02.635523+00
0115d0b7-bc46-4ba3-a6e3-cd90129abf96	4f596e49-9138-494f-9c00-d4106a457861	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Generating 	1	Online	Generated images for conclusion of 5 reasons pdf. 	approved	2026-05-23	2026-05-28 02:50:22.306497+00
7b244f91-5b1d-4bca-944c-ac5441956faf	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	1.5	Online	editing for REVA reel	approved	2026-05-22	2026-05-22 16:57:00.491667+00
3624a877-f72d-4c69-8b56-e69e5993cb1a	b7a0ba40-6b70-461d-b806-4583cb44019a	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Reel Editing	2.5	Online	Reel edited:- From the 5 reasons third is - Destiny	approved	2026-05-22	2026-05-25 14:38:50.34411+00
4461bd06-8136-432d-8221-a2ce4bd9f62b	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing	20	Online	white rice and intro to 5 reasons reel editing and post	approved	2026-05-16	2026-05-16 10:01:00.886956+00
55940598-7f41-4f45-9dd6-5bff8db2ff7f	1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Posting	1	Online	per week min 3-4 reels posting	approved	2026-05-16	2026-05-16 10:02:00.517463+00
eb6855eb-f825-46f5-bc25-bf1d74ece41b	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	0.5	Online	editing for the REVA reel 	pending	2026-05-29	2026-05-30 05:33:48.083349+00
f0890e3b-f31c-4fe1-9785-b251a3f2b056	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Content writing	3	On-site	Wrote a content on 7th nd 8th papasthanak	approved	2026-05-30	2026-05-30 06:53:00.969071+00
e015e49d-ec7c-4e3e-a828-30ae435ed29a	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	Script making 	1	Online	made pointers for the script 	approved	2026-05-29	2026-05-30 05:33:08.104666+00
b7991de9-962d-498e-be40-c1963e6225e8	d22fd755-c0a9-4474-8280-64d42c126700	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Editing 	2	On-site	I edited the content I wrote on karma like language nd voice over dialogue part	approved	2026-05-30	2026-05-30 06:51:57.460926+00
0a371d74-e1e2-4459-b957-7091a883482b	1faa2e14-2817-46d8-8f9e-5e7b70855a98	7b25f17b-43dc-431b-bd80-2a0033602e75	\N	Content writing 	1	On-site	We finalised the script for the digital and graphics team to be used in shibir.	pending	2026-05-29	2026-05-31 14:02:28.359103+00
12568ea2-7c5b-432d-8514-a1e3938decba	7e72384f-5a73-498c-b82e-57dd17a6ea18	44528d4e-5308-46ba-aefe-275f5fd1dc71	\N	Refund process	2	Online	full refund process work from messages to excel everything done for veer vanshaj 	pending	2026-05-31	2026-05-31 14:08:49.316358+00
\.


--
-- Data for Name: volunteers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.volunteers (id, ilj_id, first_name, middle_name, last_name, dob, age, gender, mobile_number, email, address_line1, address_line2, district, city, state, pincode, country, dharmik_studies, qualification, specialization, occupation, occupation_other, hobbies, skills, referred_by, volunteering_preference1, volunteering_preference2, volunteering_preference3, availability_days, time_commitment, participation_mode, password_hash, created_at, updated_at, additional_areas, sangh_name, kalyan_mitra, team_leader_for, rank, designation, secondary_designation, is_it_admin, is_onboarding_team, onboarding_status, assigned_pod, is_pod_team, activity_status) FROM stdin;
41135cc0-c4af-478a-bc6e-6ef25590fd94	ILJ-036	Shreya	Rajesh	Mehta	2003-11-13	22	Female	9004319199	Shreyamehttaa@gmail.com	A 601 Shraddha Suman apartment 	Mandapeshwar road Borivali west	Mumbai suburban 	Mumbai 	Maharashtra 	400091	India 	\N	B.com	Accounts 	Working Professional	\N	\N	\N	\N	Event Planning & Management	Research & Documentation	Photography & Videography	Weekends	\N	Flexible / Open to Discussion	$2a$06$1h5h196ZfKn6p3y5gAXIDOz3D/WQd6L92tCW2c5hCbrMKRxCMcWFa	2026-02-11 10:13:04.965688+00	2026-02-11 14:06:13.988402+00	{}	Borivali Mandapeshwar Jain sangh 	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
0e833c46-ec3f-4681-8dbc-2bec029d8db1	ILJ-004	Smit	\N	Mehta	2000-09-12	25	Male	9022566694	smitmehta50@gmail.com	B.202 Rajeshwari Deep, Ganesh mandir road	Dombivli East	Thane	Dombivli	Maharastra	421201	India	\N	B.Tech	IT	Working Professional	\N	\N	\N	\N	Event Planning & Management	\N	\N	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$6g3DcNvf8R0si234MSjXwujGwLHKZytLCBgWLwH2Gq7joNtpl2oJm	2026-02-01 15:33:50.735119+00	2026-05-18 17:41:28.731674+00	{}	Neminath Jain Sangh Dombivli	Jainam Mehta	\N	Manager	\N	\N	f	f	pending_onboarding	\N	f	Active
2a495f49-f4e5-4dfa-879d-50e43fcca74e	ILJ-068	Dhruvi 	Rikin	Gandhi	2001-09-24	24	Female	9082038358	dhruvigandhi4617@gmail.com	B 208 	Om yamuna madhav savarkar road	Thane	Dombivli	Maharashtra	421201	India	\N	Ca	Ca	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$BrDt8JPLwmL1mkmfpYAlD.enwy1lpdTyv5r/lgSL54nXlnqwXpf2i	2026-02-18 19:18:43.510185+00	2026-05-12 10:34:45.469308+00	{}	\N	Rutvi Sanghavi	\N	Associate	\N	\N	f	f	pending	\N	f	Active
33e91007-e2fa-4274-801b-4227ea2f7909	ILJ-019	Hitarth	Chandrakant 	Shah	2006-09-18	19	Male	8850525458	hcs180906@gmail.com	B-108, Rajbhavan Palace	L.T.Road, Near Mannubhai Jewllers, Borivali West 	Borivali West 	Mumbai	Maharashtra	400092	India	2 Pratikaman, 5 Pratikaman, Jeev Vichar, Vairagya Shatak	SYBCOM	Event Management, IT Department 	Student	\N	Social Activities, Management, Photography 	Technical, PR, Photography, Speech	\N	Photography & Videography	Event Planning & Management	Graphic Design & Video Editing	Flexible	2 hours	Flexible / Open to Discussion	$2a$06$Fy0aY6qBFmMSqsGtgSXiUedf1u2U.iFBWWQHf46tZVBW3sXgXmNsa	2026-02-08 14:09:43.688078+00	2026-05-12 09:14:31.53795+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9f90c956-1695-4492-9fc3-569b6e4cc326	ILJ-028	Veerti	Bhavesh 	Gada	1998-01-10	28	Female	8419944145	veertigada12345@gmail.com	A5,Yewteswar Society, 	Rajaji Cross Rd ,3rd lane	Thane 	Dombivli East	Maharashtra 	421 201	India	Pehli Dhoran	Pursuing Medical Coding 	Health Science 	Freelancer / Self-Employed	\N	Arts 	\N	\N	Marketing & Outreach	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$hP9gZSPr/9tJwfwBwpnk0uRHBnHLiWrR9ufb0zKfRaFSkeBxgrLAq	2026-02-10 09:39:21.55993+00	2026-05-18 15:57:38.007402+00	{"Defending Jainism on Social media & digital platforms"}	Sripal Nagar 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a551cf3f-5282-49ea-b432-7624af5558b2	ILJ-042	Mokshang	Sanjeev Kumar 	Jain	2009-04-05	17	Male	9892941867	mokshangj@gmail.com	5/A , 401 sarvoday garden 	Pandurang wadi near jain mandir	Thane	Dombivli 	Maharashtra 	421201	India	Sakalaratha	11th arts 	ARTS	Student	\N	Read and develop my own stories and write	Creative writing, story writing, script writing 	Muktimandan maharaj saheb	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	\N	Weekends	1 hour 30 mins	Flexible / Open to Discussion	$2a$06$NizNl7wOSfdCbgdbNsBOP.5fbVxfMkKNUJgf.XpXJgYZAg8x0QXOq	2026-02-11 15:48:10.046077+00	2026-05-20 15:57:42.27789+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	SMPT Jain sangh pandurang wadi	Jainam Mehta	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4de93087-ee99-48dc-b3a5-4339c8da81ec	ILJ-006	Jeel	\N	Doshi	1998-11-24	27	Female	9022756279	jdoshi154@gmail.com	A/2 swastik building	Savarkar road	Thane	Dombivli	Maharashtra 	421201	India 	\N	Bcom	Commerce	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	Graphic Design & Video Editing	\N	Flexible	3 hours	Voluntary (Seva-based)	$2a$06$FvEYhrt6vS/GxiOzHlnFtesW68brEr32pI.xq6THACqOxE7Pn7szS	2026-02-01 16:34:33.092509+00	2026-05-18 17:41:44.824047+00	{"Defending Jainism on Social media & digital platforms"}	Neminath jain Sangh nehru maidan 	Aayushi Sanghavi	Pathshala & Educational Activities	Associate	\N	\N	f	f	pending_onboarding	\N	f	Active
73e309c3-69be-4b6c-97bf-b23ee7c5634c	ILJ-034	Ronak	Atul	Doshi 	2002-12-01	23	Male	+918356094919	ronakdoshi2024@gmail.com	09, Mandar CHS, Near Nehru Maidan	Dombivli(East) , Maharashtra	Thane	Dombivli	Maharashtra	421201	India	\N	Int.M.Tech	Geological Technology 	Working Professional	\N	Drawing , Painting 	IT	\N	Pathshala & Educational Activities	\N	\N	Weekends	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$syboBGEsl2RiRNXNtfg8AO4s2NaHSW6UlNdSAN5bvd.Yx1PUkzvSW	2026-02-10 16:27:01.787267+00	2026-05-12 09:33:51.09431+00	{"Building Community & Government Relations"}	Rakhi Sangh	Jainam Mehta	\N	Intern	\N	\N	f	f	pending	\N	f	Active
7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	ILJ-008	Meet	Bhavesh	Mehta	2005-07-11	20	Male	9172387009	mehtameet115@gmail.com	flat 112 6th floor b-39 mayuri bldg	anand nagar dahisar ( east )	Dahisar	mumbai	Maharashtra	400068	India	\N	B.tech	computer engg	Student	\N	xyz abc\n\n\n	\N	\N	IT & Technical Support	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$5XcKEZRRD7bSw.Go19ehnO6Sfag9uxJBgSN9Et9z9F8GtxS466EF6	2026-02-01 18:08:30.862076+00	2026-05-18 18:09:40.256213+00	{}	\N	Ankit Sheth	IT & Technical Support	Associate	\N	\N	t	t	pending_onboarding	Digital Jainism, Jainific, KIVA, Website development , People Management	t	Active
60084f34-305e-42b4-8330-70bba97a2126	ILJ-032	Yogita	\N	Sheth	1998-05-14	27	Female	9930964002	yogitapd15@gmail.com	B-10, Radha govind chs	Pandurang Wadi, dombivali east	Thane	Dombivali	Maharashtra	421201	India	2 pratikaman	BAF	Accounts	Homemaker	\N	\N	\N	\N	Event Planning & Management	Pathshala & Educational Activities	Public Speaking, Acting & Stage Activities	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$1q3ofYonfetMXYmujRZpF.WTry6Fjkwl3sRdwJlq0yk4uSnLUyFK.	2026-02-10 10:32:49.505559+00	2026-05-18 15:57:53.200268+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Pandurang wadi jain sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
cd48a9cd-dc2c-420e-874e-f8a50167c9bd	ILJ-041	Veeram	Nilesh	Mehta	2006-10-11	19	Male	9321496298	veerammehta175@gmail.com	B-202, Rajeshwari deep 	Opposite Nehru maidan, Ganesh mandir road	Thane	Dombivili	Maharashtra	421201	India	\N	CA Inter completed	Tax	Student	\N	\N	\N	\N	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$TDegh0sFzUkaUWkBME/TQehHpZA/o0yUtFdpQVWPQcFwt9dnOkNam	2026-02-11 15:47:27.734778+00	2026-05-12 09:36:36.670885+00	{}	Shree Naminath shwetambar murtipujak jain sangh	Jainam Mehta	\N	Associate	\N	\N	f	f	pending	\N	f	Active
55ca6718-5a82-408d-800d-86cc3c49bbca	ILJ-010	Disha	Sachin 	Gandhi	2006-03-01	19	Female	9969612883	dishagandhi136@gmail.com	207, neelkanth chs fateh ali road behind kdmc office  	Near pp chambers,above Bharat co operative bank 	Thane	Dombivli	Maharashtra 	421201	India	\N	SYBAF 	Accounting and finance 	Student	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	\N	Flexible	5 hours 30 mins	Voluntary (Seva-based)	$2a$06$LiCY8prCDRoqSZShtWkpEOmkOUkMH.pYU6r9TaLvlXkszfKnXedZe	2026-02-03 15:40:08.070894+00	2026-02-16 05:59:40.689589+00	{}	Nehru maidan(rakhi) Sangh 	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4524f75e-4135-4a2c-8bfb-02dc30ae126b	ILJ-074	Akshat	\N	Parekh	2003-06-24	22	Male	7977654639	akshatparekh24@gmail.com	101, Haresh Niwas	Shivaji Road, Near Nehru Maidan, Dombivli (E)	Thane	Dombivli 	Maharashtra 	421201	India	\N	B. Tech	Computer Science 	Working Professional	\N	\N	\N	\N	IT & Technical Support	Event Planning & Management	\N	Flexible	3 hours	Voluntary (Seva-based)	$2a$06$hf/x11Q5Uqf7lxYzM.ls.OdfUJzj3Q6IOiZNfRiEA8Zspk.xD42E.	2026-02-22 05:23:04.784867+00	2026-05-12 10:08:05.889219+00	{}	Rakhi jain sangh	Jainam Mehta	\N	Intern	\N	\N	f	f	pending	\N	f	Active
93748e18-e2ba-46c6-8f37-7ebfe143bfe1	ILJ-011	Meet	Paresh 	Salot	2009-02-11	16	Male	8169306806	meetsalot1102@gmail.com	A/103 kamala chs Ltd ,	Dr.mukherjee rd, near ckp hall	Thane	Dombivli 	Maharashtra 	421201	India	\N	11th 	Science 	Student	\N	\N	\N	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Photography & Videography	Flexible	\N	Voluntary (Seva-based)	$2a$06$wBj0tS14Rb6gSFA18Q.UquYgOMlsHimQGQAJDGB231UuO4etbWqCa	2026-02-07 15:46:02.339115+00	2026-05-12 09:05:08.352615+00	{}	Shri naminath shwe.mu.tapa. jain sangh	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
043bde9c-9ebb-4e8c-8ccb-a975a83eec39	ILJ-005	Labdhi	Mehul	Shah	2000-12-08	25	Female	7028551745	labdhishah128@gmail.com	C-15 Aakardeep Chs, Agarkar Road	Dombivli East	Thane	Mumbai	Maharashtra	421201	India	Navtatva	Advocate	Law	Working Professional	\N	Public speaking.	Compliance and Legal Research	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$hO8WrmzFU1jau5kuW3l5Ueu2isMo8QZ6LxkmWcHcYc7DrB2KOQBde	2026-02-01 15:37:16.131539+00	2026-05-18 17:41:36.424151+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Shri Jay Naminath Swethambar murtipujak Jain Sangh Dombivli East.	Aayushi Sanghavi	\N	Manager	\N	\N	f	f	pending_onboarding	\N	f	Active
232f55ca-9598-4daf-a8ef-5e9be124c975	ILJ-013	Aayush	\N	Vora	2003-12-06	22	Male	8104214059	aayushvora2003@gmail.com	303, Mahavir Heights NX	Ganesh Mandir VP Road	Thane	Dombivli East 	Maharashtra	421201	India	Moti Shanti	CA (pursuing)	Finance	Working Professional	\N	Reading, Music	Excel, PowerPoint, AI Tools, Research	\N	Research & Documentation	Content Writing (Articles, Blogs, Scripts)	Public Speaking, Acting & Stage Activities	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$8O9SoRKyhbA7PUmqpqin3uZwQv9cRFew.H296W9sCkC/G.Agwx/6q	2026-02-07 16:04:41.420873+00	2026-05-12 09:09:57.105192+00	{"Building Community & Government Relations"}	Rakhi Sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
d22fd755-c0a9-4474-8280-64d42c126700	ILJ-015	Shikha 	Chirag	Mehta	2005-12-07	20	Female	82919 12131 	shikhacmehta@gmail.com	804, Span height 	Near dmart 150 feet road	Thane 401101	Bhayandar 	Maharashtra 	401101	India	Bhaktamar ongoing 	Bachelor's ongoing 	Pharmacy	Student	\N	Teaching, dancing, sketching , reading etc	Teaching and clear explanation of concepts + deep research \nEffective communication\nInterest in learning and sharing Dharma-based knowledge\nContent understanding and thoughtful participation	\N	Content Writing (Articles, Blogs, Scripts)	Public Speaking, Acting & Stage Activities	Research & Documentation	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$7oCUoAtVZ1D9qykCSSY7L.vV9kHBKkLQT5Kf7qWlwmUAEElhL6FR2	2026-02-08 05:21:07.814826+00	2026-05-12 09:11:01.97707+00	{"Defending Jainism on Social media & digital platforms"}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	ILJ-016	Avani	\N	Doshi	2007-09-01	18	Female	8652423859	avanidoshi09@gmail.com	701, Suyogs Godavari Krupa 	V.P.cross road, mulund west	Mumbai suburban 	Mumbai	Maharashtra 	400080	India	\N	Pursuing FYBA	Political science 	Student	\N	\N	\N	\N	Research & Documentation	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$ZN8TyYysGCDOahtozOILmuXzzMQwGu.udw7V.0H.C8cTtXR7AmrBW	2026-02-08 13:44:08.339872+00	2026-05-12 09:12:05.873014+00	{}	\N	Rutvi Sanghavi	\N	Assistant Manager	\N	\N	f	f	pending	\N	f	Active
3b05ba3c-4755-4104-a7b9-d7f7846cc4be	ILJ-029	Dhiaan	Tejpal 	Jain	2015-06-05	10	Male	9321944621	dhiaanjain2@gmail.com	Govindanand bldg 2nd floor B/7	Savarkar road near savarkar garden 	Thane	Dombivli East 	Maharashtra 	421201	India	\N	Pursuing for political field 	Political science 	Student	\N	Exploring in all new things 	Creative 	Saachi Jain 	Pathshala & Educational Activities	Photography & Videography	Event Planning & Management	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$8SQFqpTcPGM/2v7.dAb61.RHCYtBTVI3OMmc1fRnV7akXuBtxADGC	2026-02-10 09:53:38.722481+00	2026-05-12 09:29:16.576217+00	{"Building Community & Government Relations"}	Rakhi Sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
7e72384f-5a73-498c-b82e-57dd17a6ea18	ILJ-007	Charmi	Pritesh 	Dedhia	2004-02-24	22	Female	8169639689	charmipdedhia@gmail.com	B-205, Surekha bhuvan	Tilak Nagar Post Office, Dr.R.P.Road	Thane 	Dombivli East 	Maharashtra 	421201	India 	\N	MBA	Marketing 	Student	\N	Teaching, networking	\N	\N	Marketing & Outreach	Event Planning & Management	Public Speaking, Acting & Stage Activities	Flexible	\N	Voluntary (Seva-based)	$2a$06$2QSvFAjr30hBWY/yHEJT4Oocbj8ObLylufJ4Z26Zo5OWql.vLjaje	2026-02-01 16:58:20.314585+00	2026-05-18 17:41:50.831273+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Parasmani Jain Sangh	Aayushi Sanghavi	Marketing & Outreach	Associate	\N	Vice Chair Person	f	t	pending_onboarding	\N	f	Active
b2bc304c-62d9-4383-8af6-f78a51c94374	ILJ-012	Vatsal	\N	Mehta	2002-09-28	23	Male	9930164403	vatsalm707@gmail.com	A-302, Umiya Parijat	Pant Nagar	Mumbai Suburbans	Ghatkopar (East)	Maharashtra	400075	India	\N	B.Tech	Computer Science	Working Professional	\N	\N	\N	\N	IT & Technical Support	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$Py3dO.c/Snb2w.ZvYT/daO7PlKTU4uvg8OmPJq8XSDe23dvXlbCzq	2026-02-07 15:48:14.029+00	2026-05-12 09:05:34.47165+00	{}	Pant Nagar	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9e34793f-4532-4cf0-8e19-bb36a03057d2	ILJ-072	Tanisha	Bhupat	Shah	2003-12-20	22	Female	8657442650	shahtanisha2024@gmail.com	702, Shivam	Valji Laddha Road, Mulund West	Mumbai Suburban	Mumbai	Maharashtra 	400080	India	\N	BMS	Bachelor of Management Studies - Marketing 	Working Professional	\N	\N	\N	\N	Graphic Design & Video Editing	\N	\N	Flexible	2 hours 30 mins	Flexible / Open to Discussion	$2a$06$DV1V3x82H.IUzt57mLSbGeTgSaKtroBHYye38sLF8QgcMxaLJ879i	2026-02-19 17:10:53.107831+00	2026-02-21 10:58:10.664423+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
e243534f-6a49-436d-b637-a050b1e32de0	ILJ-009	Bhavya	Rajendra	Sanghavi	2001-08-28	24	Female	+918691904575	bhavyarsanghavi99@gmail.com	A/304, jagannath's commerce plaza	Manpada road	Thane	Dombivli east	Maharashtra	421201	India	\N	CA	Finance	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$UuMPZfbQ4Vswhg53rLJ1quCooLqXB84rPEowy9eLZfxbwq5Zdic/e	2026-02-02 08:28:10.500315+00	2026-05-18 17:42:21.353489+00	{}	\N	Aayushi Sanghavi	\N	Associate	\N	\N	f	f	pending_onboarding	\N	f	Active
7034d767-3884-4660-bdc7-ddcd51cd38c3	ILJ-024	Vividha 	Shrey	Patwa	1995-02-10	30	Female	8511974347	vividhapatwa@gmail.com	"Shrey", 64-A, Bhanushali Nagar 	Mundra Road 	Kutch	Bhuj	Gujarat	370001	India	Studying Gunasthanak, Vairagya shatak and Dandak	B.Arch	Architecture 	Homemaker	\N	Telling Jain stories to children's \nDoing activity related to Jainism, Going on jatra	Explaining Jainism to people deeply	\N	Research & Documentation	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Flexible	4 hours	Flexible / Open to Discussion	$2a$06$b0XjUwzWF4F0sZL6HluBd.7SNlxqpAzsusIJ8F8CzSAMEfpNqnuEq	2026-02-09 14:05:14.864396+00	2026-05-12 09:18:01.171699+00	{"Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	Khartargach Jain Sangh Bhuj 	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	ILJ-022	Yashvi	Hitendra	Maheta	2007-09-17	18	Female	7208751596	yashvimaheta135@gmail.com	Morya arcade, shiv mandir road, sabgeeta wadi, 2nd floor 206 	Near naivedya hotel	Thane	Dombivli	Maharashtra (dombivli) 	421201	India	\N	Sy B. Com 	Commerce	Student	\N	Writing, reading, 	Technical Skills, Presentation dena	\N	Public Speaking, Acting & Stage Activities	\N	\N	Weekdays	1 hour	Voluntary (Seva-based)	$2a$06$CYpPPqBy10S.QPwGZHpCLOBzv4haiK53QenK9dP0D5edrY7pkSlLq	2026-02-08 19:53:24.892602+00	2026-05-12 09:16:23.322172+00	{"Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	SMPT jain sangh	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4c363395-b574-454e-abb9-bb28a79d09d3	ILJ-025	Mahek	\N	Shah	2004-10-12	21	Female	+916354984849	shahmahek1210@gmail.com	34/D Haripark society	Ankur, Naranpura, Ahmedabad 	Ahmedabad 	Ahmadabad	Gujarat	380013	India	2 pratikraman	MBA pursuing 	HR & Finance (Dual)	Student	\N	Singing, Playing guitar, Reading spiritual & Non-fiction books.	Communication, presentation, Team coordination, Project Management, Frontend Website Development.	Instagram 	Public Speaking, Acting & Stage Activities	Event Planning & Management	Marketing & Outreach	Weekends	1 hour 30 mins	Flexible / Open to Discussion	$2a$06$YGaEA6W.xEha5BIjMNn3Guxf92F1SvpMuTQjZKj2SwdDrTmXr9pdS	2026-02-09 16:39:41.380421+00	2026-05-15 08:30:11.557015+00	{"Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shri Haripark Shwetambar Murtipujak Jain Sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
481b2283-318d-48b8-94f3-63c9f6fcf7af	ILJ-023	Vatsal	Dipesh	Mehta	2007-09-04	18	Male	8591694356	vatsalmehta5106@gmail.com	406-Bwing	Shakti shopping arcade	MUMBAI SUBURBAN	Mumbai	Maharashtra	400078	India	\N	Btech	Computer engineering 	Student	\N	Exploring new places and food and learning about new things 	Web development and researching 	\N	IT & Technical Support	Research & Documentation	Content Writing (Articles, Blogs, Scripts)	Weekends	3 hours 30 mins	Voluntary (Seva-based)	$2a$06$N4Zj8tc5nmCT/KuDujmE6.HGShiv.bVkBLZ4/V.UNCrHI0y3MuScq	2026-02-09 09:39:09.593969+00	2026-05-20 15:43:36.091351+00	{}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	ILJ-026	Siddhi	Paresh	Dedhia	2012-03-21	13	Female	93228 03390 	Siddhi61d@sttherese.in	Gajanan heights b wing 002	Sangeeta wadi shiv mandir road	Thane	Dombivli 	Maharashtra 	421201	India	\N	Study	Study 	Student	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$qMjxRw/E5grZhJXveF/WJ.ck6ohMNwWqI/vuwwtzVwO3h4qFarBYW	2026-02-09 16:46:53.51547+00	2026-05-12 09:27:43.606137+00	{}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
3b54e716-c5a0-4d4c-a616-4e2e2be95539	ILJ-018	Jash	Nikhil 	Shah	2008-09-12	17	Male	8452050129	jash4739@gmail.com	468/478 Chadha Mansion, 3rd floor, flat no 9 , S.V.P Road, Mumbai 400 004	Opera house 	Mumbai 	Mumbai	Maharashtra	400004	India	Completed 2 pratikraman 	12th	Commerce	Student	\N	Editing 	Tech	\N	Graphic Design & Video Editing	\N	\N	Flexible	5 hours	Voluntary (Seva-based)	$2a$06$Fjdv0eGPfGDPlC9m1xrToO/m.OsxkUQdQUfRxwUvYLgKSP74fGbfu	2026-02-08 13:47:57.729658+00	2026-05-12 09:13:22.610556+00	{"Defending Jainism On-field engagement","Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Shri Prathna samaj jain sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
2c1bcdc5-0564-44d9-be4a-158445f39975	ILJ-020	Heer	Shailesh 	Shah	2006-11-12	19	Female	9702790268	heershah12116@gmail.com	302 gulmohar apartment 	Factory lane 	Maharashtra	Mumbai	Maharashtra	400092	India	\N	Pursuing bcom, cfp	Finance	Student	\N	Explore new things 	Creativity 	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Pathshala & Educational Activities	Flexible	15 mins	Voluntary (Seva-based)	$2a$06$MC98mGw2QZd0UHSDC2fHLe509Um74nZ.mqUAeSUOzDKZ/oGl0WcBC	2026-02-08 15:01:59.839918+00	2026-05-12 09:15:28.765731+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Jambligully jain sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
41fcbca1-3193-42ce-8585-95372b4b9d52	ILJ-014	Test 	\N	Test 	2020-02-06	6	Male	+919172387009	meets.studentlife@gmail.com	B/39, Flat No112, Mayuri Chs Csroad Near Bmc Market	Anand Nagar Dahisar East	Test	Greater Mumbai (M Corp.) (Part)	Maharashtra	400068	India	\N	Test	Test	Student	\N	\N	\N	\N	Research & Documentation	\N	\N	Weekdays	\N	Voluntary (Seva-based)	$2a$06$7M0fAI2/mraK0Pdxm9F6bOZ8FIOeGbLybKdWQwQJqIUeyH/5.cSBe	2026-02-07 16:44:00.216534+00	2026-05-03 17:10:51.492746+00	{"Defending Jainism on Social media & digital platforms"}	\N	Meet Mehta	Event Planning & Management|Content Writing (Articles, Blogs, Scripts)	Intern	\N	\N	f	f	onboarded	Admin work	f	Active
c371c0b4-f445-41ec-b6cf-ba6828e59757	ILJ-021	CHARMI	RAJNIKANT 	Doshi	2007-08-30	18	Female	9082051477	charmi2630@gmail.com	B/16, Laxmandham building 	Rajaji Road near madhavi bunglow 	Thane	Dombivli East 	Maharashtra 	421201	India	Nav tattva	Fy ba llb	Law	Student	\N	Outdoor activities	Communication	\N	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$ZtnltbZfDKJSXBwcj8i2pOFmbRA/XjVsUoha88ciYlyXeOMayJgcC	2026-02-08 15:26:44.396583+00	2026-03-14 11:14:22.451513+00	{"Defending Jainism On-field engagement"}	Rajaji road shwetamber murtipujak jain sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
f2179127-e88f-41f3-910a-f9dd0fa2647a	ILJ-037	Aditi	Hitendra	Maheta	2009-09-10	16	Female	+917208751596	aditimaheta720@gmail.com	Morya arcade, shiv mandir road, sabgeeta wadi, 2nd floor 206	Near naivedya hotel	Thane	Dombivli	Maharashtra (dombivli)	421201	India	5 pratikraman. 	11th currently	Arts	Student	\N	Hobbie- video editing,drawing and painting,cricket,reading, \nInterests- voluntary and events management 	Time management 	Marasaheb	Event Planning & Management	Pathshala & Educational Activities	\N	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$UtGX7dfBRPmGEaSxHUCClee0yvCqTekyi092nLjduf5iGMDrCa0wO	2026-02-11 13:37:56.317839+00	2026-05-18 15:59:05.311353+00	{}	SMPT jain sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
b8f6d90e-b692-4a8a-8cbc-17909331fa73	ILJ-031	Ankit	\N	Sheth	1993-02-26	32	Male	7208290085	ankitsheth8@gmail.com	B-10, Radha govind chs 	Pandurang wadi Dombivali East 	Thane	Dombivali	Maharashtra	421201	India	5 pratikaman	Mcom	Finance & Accounts	Working Professional	\N	\N	\N	\N	Event Planning & Management	IT & Technical Support	Research & Documentation	Weekends	4 hours	Voluntary (Seva-based)	$2a$06$xu3QPIgahZ6x3JJ6Iszjd.YIoyXU57DBWFS6xuFs7.ATd5DBoEx1a	2026-02-10 10:28:33.582157+00	2026-05-12 09:30:24.318146+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Pandurang wadi jain sangh	DrHardik Shah	\N	Associate	\N	\N	f	f	pending	\N	f	Active
df0f9941-a563-4844-adf0-3058c435dbf3	ILJ-043	Bhumi	Hitesh	Sanghavi	2003-11-26	22	Female	8928656657	bhumisanghavi2003@gmail.com	202 Ramtirth soc opp nehru maidan	Ganesh mandir road	Thane	Thane	Maharashtra	421201	India	\N	Actuaries	Insurance	Working Professional	\N	Art and Craft	Creative, management	\N	Event Planning & Management	\N	\N	Weekends	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$JXT/qh5eUzXYJ2wSl3XHlOhN0e7sRyLislTBJQDSK3lYaJWU0/Pbu	2026-02-11 16:12:01.955263+00	2026-05-12 09:37:42.158753+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shri Jay Naminath Murtipujak jain sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
32837c38-a21e-450a-8613-ec2c09f3cc97	ILJ-017	Saachi 	Tejpal 	Jain	2010-11-15	15	Female	9022761552	saachijain808@gmail.com	Govindanand bldg 2nd floor B/7	Savarkar road near savarkar garden 	Thane	Dombivli East 	Maharashtra 	421201	India	\N	Pursuing for professionalism in baking	Commerce 	Student	\N	Art and craft 	Creative 	Aayushi Sanghvi 	Event Planning & Management	Photography & Videography	Pathshala & Educational Activities	Flexible	1 hours 30 mins	Voluntary (Seva-based)	$2a$06$gF8HvW9LroYUMUIO/CfECu/q9V1AItADXCEOHK7B6mTf0CAXZMD6i	2026-02-08 13:47:14.371431+00	2026-05-12 09:12:51.687864+00	{"Defending Jainism on Social media & digital platforms"}	Rakhi Sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	ILJ-044	Yesha	\N	Salot	2006-04-18	19	Female	9022227572	yeshasalot@gmail.com	103 kamla chs. Ltd., 	Mukherjee rd.,	Thane	Dombivli(E).	Maharashtra	421201	India	\N	BAF	Accounting and finance 	Student	\N	I like to listening songs, dancing,  enjoying the natures, take interest to learn new things. 	Know the basic technical skills, likes creativity things,etc.	\N	Pathshala & Educational Activities	\N	\N	Weekdays	2 hours	Voluntary (Seva-based)	$2a$06$9Rk..pDsM6NUmBJE8bBVbelpPcHqVn8EoDBlVG3T2x7phZNaNGv1K	2026-02-11 18:16:42.744692+00	2026-05-12 09:38:49.782198+00	{}	Shru jai naminath swe. Mu. Tap. Jain sangh.	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
fe64f71e-bc1f-4297-af8a-9dfae090e0be	ILJ-046	Kreena	\N	Doshi	2002-11-07	23	Female	8452802210	kreena.b@somaiya.edu	Nilkanth apt	Tilak road	Thane	Dombivli 	Maharashtra	421201	India	\N	CA completed	Commerce	Working Professional	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	Pathshala & Educational Activities	Weekends	\N	Voluntary (Seva-based)	$2a$06$.pKAvuBHNLZNA4e21xVxmOAdHYkEIOmXRXWAEwSRIlocQ9o8Qy.aq	2026-02-12 05:27:29.57057+00	2026-05-12 10:41:32.434304+00	{"Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Associate	\N	\N	f	f	pending	\N	f	Active
e511ae7b-67bc-45ff-84f7-29be33b3a5e6	ILJ-045	Aayush 	Raju	Sanghavi 	2008-03-11	18	Male	7738326345	aayushsanghavi97@gmail.com	8,Virat chs 	Tilak Nagar school road 	Thane 	Dombivli (east)	Maharashtra 	421201	India 	5 pratikaman,9 samran (except-bhakamar & kalyanamandir)	HSC	Commerce 	Student	\N	\N	\N	\N	Photography & Videography	Public Speaking, Acting & Stage Activities	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$RzmioX9eJRJOTsJWkNFI7.7jSpHxMn28zWjaxvWZJ.cifk8Bpww/6	2026-02-12 04:35:50.529978+00	2026-05-18 15:51:41.154124+00	{"Defending Jainism On-field engagement"}	\N	Jainam Mehta	\N	Intern	\N	\N	f	f	onboarded	Digital Jinshasan	f	Active
c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	ILJ-033	Yashvi	Hemant 	Sanghavi	2007-12-08	18	Female	9423594189	yashvi.sanghavi.dombivli@gmail.com	16/B Matru Ashish CHSL 	Tai Pingle chowk Acharya Tulsi Marg Dombivli East 	Thane 	Dombivli 	Maharashtra 	421201	India 	2 dhoran	BAF 	Accounting and Finance 	Student	\N	Reading	Excel, tally, editing 	\N	Marketing & Outreach	Graphic Design & Video Editing	Research & Documentation	Weekdays	30 mins	Voluntary (Seva-based)	$2a$06$1JUZcxxVb8DWivUdSbmz3eRgqoRZgtCoWdEmASLhdDa0KEff5Wfwy	2026-02-10 14:20:52.226662+00	2026-05-12 09:32:58.814638+00	{}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
d4c73898-8bda-476d-a068-898c72460441	ILJ-027	Naitik	Mehul	Shah	2009-04-14	16	Male	9076056730	ns4934551@gmail.com	C-15 Aakardeep	 Aagarkar road  near Thakur vadpav	Thane	Dombivli East 	Maharashtra 	421201	India	\N	11th commerce 	Commerce 	Student	\N	To play drums 	I am Drums 	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$ljqCg4ox/hdj/1WQnjNd8uD3ED/L5mkOR0LM/L1I86Sv7tI.OWo.i	2026-02-09 17:09:30.799752+00	2026-05-12 09:28:23.039224+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Rakhi 	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
96c9c515-49dc-4172-95d9-7a57478388c3	ILJ-040	Hiya	\N	Gandhi	2007-10-06	18	Female	9372393772	hiyagandhi624@gmail.com	Raghupati Apts	Tambe Nagar 	Mumbai 	Mulund 	Maharashtra 	400080	India	Laghu shaanti 	12th	Commerce 	Student	\N	editing and painting 	Creative 	\N	Graphic Design & Video Editing	\N	\N	Flexible	5 hours	Voluntary (Seva-based)	$2a$06$bmwflOR5VMUSa96R/7HALulMVqUH4HjOhW4musp9X6hPhJRg7BNnS	2026-02-11 14:45:03.463763+00	2026-04-05 05:34:01.437273+00	{"Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shasan Samrat Shwetambar Murtipujak Jain Sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
1dcb9d9a-41a7-48c8-83fa-74f46d8b77d2	ILJ-091	Deepal	\N	Mehta	2002-10-16	23	Female	+917710036191	deepalmehta147@gmail.com	Mayuri Chs Anand Nagar Dahisar East	Anand nagar	Mumbai	Mumbai	Maharashtra	400068	India	\N	Pgdm	Finance 	Working Professional	\N	\N	\N	\N	Event Planning & Management	\N	\N	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$g.FwiDfKIvgXHzafLsklY.2ApcfT8mNj2BzNEgaT/uOW.7pB31hkm	2026-03-04 08:04:18.477762+00	2026-05-15 08:29:47.261732+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
dd8599b5-9989-4b14-9d33-6e4913e6693e	ILJ-039	Nemil	Yogesh 	Shah	2000-04-23	25	Male	8655449499	nemilyshah@gmail.com	205, Gayatri Apartments, Opp. Canara Bank	S.V.P. Road, Borivali (W)	Mumbai Suburban	Mumbai 	Maharashtra 	400092	India 	5 Pratikaman	B. Tech	Computer Engineering	Working Professional	\N	Reading \nMusic	Software development \n	Muktimandan ms	Research & Documentation	\N	\N	Flexible	4 hours	Voluntary (Seva-based)	$2a$06$4g1b6iQDsWEvnUtgcNqhf.3kxG7zZx.8c10RkBBdNyzlD5teuM4wG	2026-02-11 14:10:09.394196+00	2026-02-13 15:06:57.276783+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Mandpeshwar	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
aded593b-ae3f-4eca-8edf-658f89bb172c	ILJ-038	Khushi	Jayanti	Shah	2006-10-30	19	Female	9821712171	Khushishahh372@gmail.com	Flat no.14, 5th floor Waman Chs	Mahatma Gandhi Rd, Navpada, Vile Parle East	Mumbai	Mumbai	Maharashtra 	400057	India 	Completed 2 pratikraman and jeevichar, vairagya shahtak 	Pursuing Bsc in applied Psychology 	Psychology 	Student	\N	Im a writer, I write, edit podcasts both audio and visual podcasts\nI like reading books 	Problem solving\nWriter \nEditor\n	Prisha jain mulund - +91 72087 70036	Event Planning & Management	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$6FExkkD3TT.a7lJtpl88Reo9FtiOx5H/WqpIWAGNU4KP6dBauvBNS	2026-02-11 13:57:01.840037+00	2026-02-13 15:07:56.882995+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Shri Vile Parle Shwetambar Murti Pujak Jain Sangh and Trust	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
d176663a-6707-4d57-bf50-35e3e7b4a964	ILJ-052	Manali 	\N	Shah	1988-03-31	37	Female	9892903684	mana88shah@gmail.com	81	Windale Cresent	Ontario	Kitchener	Ontario	N2E 3H4	Canada	\N	Mcom	Finance	Working Professional	\N	Listening to Podcasts, Reading books, Walking, Creating Nutrition plan for Family members, Drawing, Stiching 	Data Scientist, good with data pulling and financial analysis, preparing dashboards 	Varaktamala Sahebji and Muktimandan Sahebji	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	Photography & Videography	Flexible	3 hours	Flexible / Open to Discussion	$2a$06$G2FMq2nzTQiRVc6x0EEuVO2OCJE8AoPgDo6qJZTCCWyhDvN7S0zC.	2026-02-12 15:47:50.461262+00	2026-03-03 16:16:19.617124+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
6a89d207-b9ef-4e2b-9a9a-14b42000db10	ILJ-048	Prachi	Ashok 	Shah	1998-11-13	27	Female	9930759421	prachishah1311@gmail.com	7/samarth krupa	Gograswadi	Thane	Dombivali 	Maharashtra 	421201	India	\N	M.com	Accounts	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	Event Planning & Management	\N	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$k.3GeElWVORBaWHpbFEceeceBIhpB7Szr8hNfZKepyzUZBBW1xBbS	2026-02-12 06:34:31.526794+00	2026-05-12 10:40:50.069704+00	{"Defending Jainism On-field engagement"}	Munisuvrat swatamber murtipujak jain sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
8b946c8c-5583-4340-94ac-a0c3801bfb98	ILJ-049	Harshil	Narendrabhai	Daftari	2000-09-23	25	Male	+919228561485	daftariharshil@gmail.com	A-602 Aavli Nine 360	Motera 	Gandhinagar	Near Bhat Circle 	Ahmedabad	380005	India	2 Pratikraman 	MCA	Master of Computer Application 	Working Professional	\N	Traveling \n	Social Media Marketing \nGraphic Designer 	\N	Event Planning & Management	Graphic Design & Video Editing	Photography & Videography	Weekends	3 hours	Paid Basis (Project or Role-based)	$2a$06$IejYZb6i4aYo7V9Y7AIqmOeT8oRIuARvZkgdhbKms1Lciyjqjyh3i	2026-02-12 09:08:15.978922+00	2026-05-12 10:40:19.240406+00	{"Defending Jainism on Social media & digital platforms"}	Sangath 	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
5a4cbc48-bacb-4728-b9f0-34fe766d9f19	ILJ-057	Nikita	\N	Doshi	1990-06-08	35	Female	8850239182	nikita.doshi08@gmail.com	B-603 Atharv Laxmi	Vile Parle (east)	Mumbai	Mumbai	Maharashtra	400057	India	\N	Masters	Information Management 	Freelancer / Self-Employed	\N	\N	\N	\N	Research & Documentation	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$aLXrvj0Fl4uSJNxb9m9F.uyJl43HLm/ldrt/w/YInEgOSYHw8bqpq	2026-02-16 15:48:18.500292+00	2026-02-21 10:46:26.785311+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
0c6384b4-15bd-42b1-a978-317e1d163f8d	ILJ-051	Arpita	Pankaj 	Dand	2005-06-30	20	Female	9819992563	arpitadand5002@gmail.com	C-52 Sevadham bldg	Rajaji Path	Kalyan	Dombivali	Maharashtra	421201	India	\N	pursuing B.Tech	Computer Engineering	Student	\N	Chess	Technical & Creative	\N	Graphic Design & Video Editing	IT & Technical Support	\N	Flexible	7 hours 30 mins	Flexible / Open to Discussion	$2a$06$0qQJ/B9Q35Pt4nLrzqLuUuC664uLTDdl9asTDUZFIG.Xg25BViAPS	2026-02-12 11:04:39.970126+00	2026-05-18 16:04:59.426665+00	{"Defending Jainism on Social media & digital platforms"}	\N	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
87f3685f-9952-49ed-8c9f-b7f9a5fbf908	ILJ-054	Khushi	Jayant 	Jain	2008-03-04	17	Female	9326222411	khushimjain08@gmail.com	707, Jal , Indraprastha Society 	Satyanagar , Borivali West , Mumbai -92	Mumbai 	Mumbai 	Maharashtra 	400092	India	studied till jeevvichar 	hsc boards	Science Architecture 	Student	\N	art and craft, , drawing 	\N	Sahebji 	Graphic Design & Video Editing	Event Planning & Management	\N	Flexible	9 hours 30 mins	Voluntary (Seva-based)	$2a$06$.zOXWYRmyUAVPOe90TOS0.xjG77cRbIb02Rwn1d7/adoQV8c8LOoe	2026-02-13 13:38:15.607808+00	2026-05-12 10:39:18.803958+00	{"Defending Jainism on Social media & digital platforms"}	Shree Kalyankari Jain Sangh Satyanagar 	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4842d49f-c3ea-47a4-bfee-03837bec04a5	ILJ-047	Jiana	Pravesh	Mehta	2011-08-13	14	Female	8657704561	mehtajiana7@gmail.com	flat number7/A wing/ GowaliaTank building	A•K marg/ above maharaja hotel	mumbai suburban district	Mumbai	maharashta 	400036	india	panch pratikaman full done \nstill doing bhaktamar sutra	pursuing 10th grade education 	commerce	Student	\N	cycling,baking,hiking,clay moulding	chess(district level),skating(state level),roll ball(district level)	jheel	Event Planning & Management	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$cyG5B.1tITvGpQhfr9q4B.4vQ1N.OqATr7/f2oqQQYAnPUHtx/4Iq	2026-02-12 06:31:29.839705+00	2026-05-12 10:41:13.450242+00	{}	shri gowalia tank jain sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
50ac0f99-6e54-4ab2-bdbd-83463583261a	ILJ-055	Vanshi	jayesh 	vora	2009-04-28	16	Female	9702489256	vanshivora28@gmail.com	A/403 jalaram krupa	nehru road ganpati mandir 	thane	dombivali 	maharashtra 	421201	Indiz	\N	10th pass	Commerce	Student	\N	Dancing 	Drama and dance	\N	Public Speaking, Acting & Stage Activities	Photography & Videography	Marketing & Outreach	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$yS44jowMW2zTsgQjpeUT/etsOMVWmM1rNdQzJpsZ2OA5g5ELrnNtq	2026-02-13 19:50:58.798661+00	2026-05-12 10:38:28.488258+00	{"Defending Jainism on Social media & digital platforms"}	Rakhi	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	ILJ-061	aashi	mahesh	maru	2008-10-18	17	Female	9322893350	aashimaru2008@gmail.com	301,Manjunath Tower	opp Miraj Cinema	thane	dombivli	Maharashtra	421201	India	chaitya vandan	12 pursuing 	commerce	Student	\N	music	editing	deepali shah	Graphic Design & Video Editing	Photography & Videography	\N	Weekends	4 hours	Voluntary (Seva-based)	$2a$06$VaPoRaXes5J4/J3TNx0PbuUTiCaX0yopTBNlvQbrUhY1y2hwRIU6G	2026-02-18 10:03:56.589594+00	2026-05-12 10:36:15.242251+00	{"Defending Jainism on Social media & digital platforms"}	Achalgach	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
7c5cb4d3-d911-4ec5-a435-e651d30c13ab	ILJ-065	Virti	9326206167	Gandhi	2009-04-28	16	Female	9326206167	virtigandhi28@gmail.com	B-208,Om yamuna madhav, Veer Savarkar road 	Dombivali east	Thane	Dombivali 	MAHARASHTRA	421201	India	5 pratikraman completed,jivichar completed, learning nav tatva currently 	10th passed by 96%	Commerce 	Student	\N	Art,rangoli, paintings etc	Mehndi artist,artist	Muktimandan m.s	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	\N	Flexible / Open to Discussion	$2a$06$su0TTA8AeUMUZrrKW0SFFehKoWrMmc7GIY1Gs4X4b6mDzjTKs50bC	2026-02-18 17:05:42.536061+00	2026-02-21 10:52:24.101687+00	{}	Neminath shwetambar murtipujak jain sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
643db578-c5a7-422f-ad51-1ba67a0db590	ILJ-062	Dhruv 	Mitul	Gandhi	2008-04-27	17	Male	9082169119	dhruvgandhi0506@gmail.com	B/410, om rinkoo apartment 	Savarkar road 	Thane	Dombivli 	MAHARASHTRA	421201	India	5 pratikraman	12th	Commerce	Student	\N	\N	\N	\N	Event Planning & Management	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$Vsjhrv5Lf68w8JwnsgFiAOO9T6p69P4QI9RQofWxkAaRfInGzDCG6	2026-02-18 15:58:57.376591+00	2026-05-12 10:35:57.771311+00	{"Defending Jainism On-field engagement"}	Shri jai naminath shwetambar murtipujak tappagach jain sangh 	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	ILJ-056	Aesha 	Naitik 	Mehta	1998-12-29	27	Female	+917715076582	aeshapshah153@gmail.com	Sangitawadi	Dombivli East 	Thane 	Dombivali	Maharashtra	421201	India	Guruvandan Bhashya 	M.com	Commerce 	Homemaker	\N	Reading, writing, dancing, acting 	Creative , intrested in shashan activities 	Aayushi ben	Content Writing (Articles, Blogs, Scripts)	Pathshala & Educational Activities	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$QI3H.PkZswAMf0J73BqjreNuLbzzcMdwVSF8FQ.p/TDnPTnv432n6	2026-02-16 15:24:52.337521+00	2026-02-21 10:45:36.503554+00	{"Defending Jainism On-field engagement"}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
69fbfc39-3ac0-4972-93fb-317e3e50219b	ILJ-063	Labdhi 	Mukesh	Vora	2005-07-28	20	Female	+91 85914 76735	labdhivora1@gmail.com	D/5, Nav Vrushali Society 	Aagarkar Road	Thane	Dombivli 	MAHARASHTRA	421201	India	Shakrastav 	Pursuing BBA LL.B (Third year)	Law	Student	\N	Reading, drawing, 	Researching, organizing 	\N	Research & Documentation	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$LxuE1lA65sPR7pcRwEVkxuAFLGFQi.IdW7.H3DuhVlQKiNrGjFaeG	2026-02-18 16:17:34.355151+00	2026-05-18 15:59:48.269974+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Jai Naminath Shwetamber Murtipujak Tapagach Jain Sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	ILJ-060	Twisha 	Kalpesh 	Gandhi	2005-01-02	21	Female	8591189470	twishagandhi363@gmail.com	17 4th floor Sai dham nss road opposite gopi mall Dombivli west 	17 4th floor Sai dham nss road opposite gopi mall Dombivli west 	Thane	Dombivli 	Maharashtra 	421202	India	\N	Baf	Commerce 	Freelancer / Self-Employed	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$sEu16gCPJWobxtCgbVEr0.twuXQrqf41weKDfWa00Jfnh11XQMDxq	2026-02-18 06:36:07.35355+00	2026-02-21 10:48:44.189121+00	{"Defending Jainism On-field engagement","Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Naminath jain shangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
46d8f688-8929-4f4e-9c02-c1db1a0669ea	ILJ-059	Prisha	Jignesh 	Parmani 	2008-05-15	17	Female	9321359084 	prishaparmani15@gmail.com	Mayuri Building, No 38,Flat number 67	Anand Nagar Dhaisar East 	Mumbai	Mumbai 	Maharashtra	400068	India 	None	12th, would be pursuing neet for mbbs	Science	Student	\N	Speaking, planning, managing, debates	Researching, public speaking	\N	Public Speaking, Acting & Stage Activities	\N	\N	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$Ai1sAsja444zUHMpKsYuKeM/fNoaaL4tzdcSYpawf9nLbT8wESzCu	2026-02-17 13:14:06.601195+00	2026-05-12 10:37:10.324489+00	{"Defending Jainism On-field engagement"}	Nityanand	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
47485610-8800-4c02-ac12-90808a9ecb94	ILJ-066	Anjali	Mayank 	Vasa 	1997-06-30	28	Female	8767340326	91shah.anjali@gmail.com	A6/302, Vaibhav CHS Ltd, Anand Nagar 	Dahisar East 	Borivali 	Mumbai	Maharashtra 	400068 	India 	Started lately 	M.A.	Arts	Homemaker	\N	Arts, craft	Designing	\N	Pathshala & Educational Activities	Marketing & Outreach	Event Planning & Management	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$wXKb2N5LYWraIPiCZ9BAfeqzDzjWpQBk1wwimVWJulgg4dyiVfqUW	2026-02-18 17:14:02.989741+00	2026-02-21 10:52:47.198606+00	{}	Nityanand Murtipujak Shwetamber Jain Sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	ILJ-064	Nidhee	Mukesh	Vora	2001-08-27	24	Female	8850042706	nidhivora83@gmail.com	D-5 nav vrushali society 	Aagarkar road 	Kalyan	DOMBIVLI EAST	Maharashtra 	421201	India	Dandak	CA, LLB	Commerce, Law	Working Professional	\N	Reading, Drawing, Dancing	Drawing, organize 	\N	Event Planning & Management	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$XfkXUP60WzETQnmSAoEYceDOX2wGHxeSBvXpaCJTSHkbKUKQQPke6	2026-02-18 16:18:26.033731+00	2026-05-12 10:35:40.321787+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Jay naminath shwetambar murtipujak tapagach jain sangh (rakhi)	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a59d9b96-eccd-4b3a-a15f-ad6f693013a7	ILJ-001	Jainam	\N	Mehta	1999-06-05	26	Male	9167180806	jainammehta519@gmail.com	A-302, Umiya Parijat CHS, Building No. 37	Guru Dattta Mandir Road, Pant Nagar	Mumbai	Ghatkopar (East)	Maharashtra	400075	India	\N	Chartered Accountant	GST	Working Professional	\N	\N	\N	\N	Content Writing (Articles, Blogs, Scripts)	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$/hUFRVODr1rj5v4Uwyf5YeOLyUVTiSmRwq1ywQwcTmc12N/HTFbp6	2026-02-01 15:06:01.194829+00	2026-05-18 17:40:57.780357+00	{}	\N	Aayushi Sanghavi	Content Writing (Articles, Blogs, Scripts)	Manager	\N	Vice Chair Person	f	f	pending_onboarding	Knowledge and Blogs	t	Active
486cb7fe-4375-44d1-b124-e2460ab1826a	ILJ-071	Harshi	Nilesh	Shah	2004-12-30	21	Female	9152077520	harshiiishah30@gmail.com	3/36 Kamal Building, Opposite Gopi Birla School, Walkeshwar road	.	Mumbai	Mumbai	Maharashtra 	400006	India	Completed 2 Pratikram	Pursuing BA ( Currently in TY) & Completed Graphic and Video Editing Certificate Course	Arts, Editing & Design(Graphics) 	Student	\N	Reading, Listening to music & Travelling \nInterests in camping, bhakti nights, playing board games and doing adventurous things	Creativity, Interpersonal skills & Adaptability 	\N	Graphic Design & Video Editing	\N	\N	Flexible	2-3 hours	Voluntary (Seva-based)	$2a$06$KXcHfqyEmrkParMxfh44v.scA5S9n/L53jSCEC2ogpxYtcP0Lq5P2	2026-02-19 14:40:54.724837+00	2026-05-21 08:46:06.623576+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Suparshvanath Jain Sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
34e80f19-ddbe-46bf-9a65-83c81104b974	ILJ-069	Labdhi 	Abhay 	Shah	2008-10-16	17	Female	7977800558	labdhi1608@gmail.com	302, Navkar heights 	Bapudatar road near joshi High school 	Thane	Dombivali 	Maharashtra 	421201	India 	Till 2 pratikraman book 	Currently in 12th 	Commerce 	Student	\N	Creativity volunteering 	Creative skills, and some technical skills	\N	Photography & Videography	Pathshala & Educational Activities	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$r8M0hmyRl2MIQMu25.auz.sMgWhtLImLJ.IqLUTrXunzpjy2I3QSm	2026-02-19 05:30:40.91807+00	2026-02-21 10:54:50.80872+00	{"Defending Jainism on Social media & digital platforms"}	Rudhivardhak Parasmani jain sangh 	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a249b221-853f-4065-b6a4-c9ef30d4032f	ILJ-070	Darsh	\N	Chandura	2000-07-22	25	Male	9768903798	darshchandura102@gmail.com	B-1004, Kanchangiri Apartments	Kandivali East	Kandivali	Mumbai - 400101	Maharashtra	400101	India	\N	Masters	Data Science and AI	Working Professional	\N	\N	\N	Smit Bhai 	IT & Technical Support	Public Speaking, Acting & Stage Activities	\N	Flexible	4 hours	Voluntary (Seva-based)	$2a$06$FMEuuLDb.N50NRHpylQsYOnDaD5ZwcD1MCMkGtPpMlMW8UVokZXRO	2026-02-19 07:06:15.05819+00	2026-05-12 10:34:12.126514+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Ashok Nagar Jain Sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
57c08aaa-e760-48dd-9772-d8fbea00e722	ILJ-067	Sneha	Karan 	Kothari	1987-09-06	38	Female	9869316823	snehakaran.sk@gmail.com	303, ketan appartment, near Ambika hotel above Rakesh jewellers 	Phadke road 	Thane 	Dombivli 	Maharashtra 	421202	Indian 	5 partikam 	Ty b.com	Games	Homemaker	\N	Cricket, sports 	Ghauli 	Sneha 	Pathshala & Educational Activities	\N	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$dJ6gpCXIQQ.tqsvxtmxW7eRz74Eh1ZaUUiYqWSdMJZHuISPR9U5KO	2026-02-18 18:17:14.004636+00	2026-05-18 16:00:10.49441+00	{}	Rajsthan sangh 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
63a204f2-f076-49f5-b7a7-2ac78e2bbcac	ILJ-076	Shruti	Nilesh	Dalal	2004-11-19	21	Female	9328413486	Shruti.s25@skips.in	14 tenament kalpataru part 1	Mirambica school road Naranpura 	Ahmedabad 	Ahmedabad 	Gujarat 	380013	India 	Attichar	Post graduate diploma management 	Management ( marketing and finance)	Student	\N	Drawing dancing 	Creative	Mahek shah	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Event Planning & Management	Weekends	4 hours	Flexible / Open to Discussion	$2a$06$lqCl77P3pUkU0zNsyytNvOAu8G14UKLOg08/QLT/OJNdjmksl3G2m	2026-02-22 13:12:06.380204+00	2026-02-27 16:11:33.383286+00	{}	Mirambica murti pujak jain sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
172dbd3e-8074-423c-a82b-16e77ea8a2b2	ILJ-075	Vishwa 	Ashwin 	Doshi 	2004-08-09	21	Female	8369086349	vishwadoshi2004@gmail.com	803, Marathon ZaverArcade Zaver Road opp. Jain Temple 	Mulund -  West Mumbai - 400080	Mulund 	Mumbai	Maharashtra	400080	India	\N	BBI ( Bachelor's in Banking And Insurance 	Commerce 	Student	\N	Enjoy learning new things 	Sketching 	\N	Research & Documentation	\N	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$.R0EPKzq6HZtFVAm8ve41.UPMbxnVWnc/WwnGaPE7d4AQtM3V5Gj.	2026-02-22 07:47:01.914964+00	2026-05-12 10:07:41.323316+00	{"Defending Jainism on Social media & digital platforms"}	Zaveroad jain Sangh 	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
32cf8f2e-3643-4301-8fde-d601c27012fc	ILJ-073	Veeram	Paras	Mehta 	2007-12-23	18	Male	8286694081	veermehta232007@gmail.com	B - 603, Sai Anand, Anand Nagar	C.S. Road, Dahisar (East), Mumbai - 400068	Mumbai Suburban 	Mumbai	Maharashtra 	400068	India	2 Pratikaman, Panch Pratikaman 	BCom	Commerce 	Student	\N	Sports	Data collection, Management 	\N	Research & Documentation	\N	\N	Flexible	4 hours	Voluntary (Seva-based)	$2a$06$1KtGab0uJ8NS3HJBk//SZ.aXoYR/62Mnyav6nfsWfex.nssmkfXYe	2026-02-19 17:28:32.700838+00	2026-05-12 10:32:52.960706+00	{}	Nityanand Shwetambar Murtipujak Jain Sangh	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
42eb89fe-dd23-4238-a7e0-9e1e5189d92f	ILJ-085	Manan	Nileshbhai 	Vasa	2004-05-27	21	Male	9510427576	manan.n.vasa@gmail.com	503, A.H heritage 	K.d road, Gautam Ashish society- Vile Parle W	Vile Parle w	Mumbai	Maharashtra	400056	IN	2 pratikaman	Pursuing MBA	Commerce 	Student	\N	\N	\N	Manan Vasa	Research & Documentation	\N	\N	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$pyqvj79bRFilAlXRLqHNBeQb/UZtFJTo4evlamhBd6Tu9G8xWw96C	2026-03-01 07:17:45.443105+00	2026-05-12 10:01:18.524705+00	{}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
2e3999e0-fcca-407c-afa9-0ff5c26fae98	ILJ-082	Harsh	Sanjay	Shah	2005-10-24	20	Male	9867000323	harshshah80652@gmail.com	A-12, Tej Kiran society 	Ram mandir Road, Vile Parle East	Maharashtra 	Mumbai	Maharashtra 	400057	India	\N	B Tech	Electronics and Telecommunication Engineering 	Student	\N	Playing instruments, to make something creative with limited resources 	Planning, creative	Mukti Mandan marasaheb 	Event Planning & Management	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$LONoaKcluCKeGEjYl5IN9ueHVF10JIeL783g1cK.WcYbblTrPU/VS	2026-02-27 15:27:14.479549+00	2026-05-12 10:03:18.97658+00	{"Building Community & Government Relations"}	Vile Parle East sangh 	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
cee8ac7e-c40f-4501-a738-a7a2cd3c2e0a	ILJ-077	Test	test	test	2020-01-31	6	Male	+919172387009	meetleveledge@gmail.com	--	anand nagar dahisar ( east )	d	mumbai	Maharashtra	400068	India	\N	test	test	Student	\N	test	test	\N	Photography & Videography	Inhouse Pathshala and Home Schooling	Research & Documentation	Weekends	30 mins	Paid Basis (Project or Role-based)	$2a$06$HhuKnrPZn2j/DbNhnwejX.FDd1/j7J/s4kWTyaPSLmIGjRq8aIlt6	2026-02-24 19:27:20.773506+00	2026-05-14 15:10:33.169165+00	{"Defending Jainism On-field engagement"}	\N	\N	\N	Intern	\N	\N	f	f	onboarded	Veer Vanshaj: Self Defence Workshop	f	Active
9fb2df7d-14fe-4f1f-94f1-19058a6ad723	ILJ-078	Kathan	Chandresh	Shah	2000-06-03	25	Male	+91 8454946494	ktshah3620@gmail.com	601/ Vishranti Society, Dixit Road	Vile parle East, Near satellite Hotel	Maharashtra	Mumbai	Maharashtra 	400057	India	5 Pratikaman	B.com	Finance and Management	Freelancer / Self-Employed	\N	Travel	Creative and Tech	Muktimandan Ms	Event Planning & Management	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Flexible	4 hours	Flexible / Open to Discussion	$2a$06$yLpmXwWf8QU57OEsF6rpleoyo1jCsvKLGwDvhumoaxyBNMGqelef2	2026-02-25 14:47:41.769972+00	2026-05-12 10:06:13.3062+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Shree Vile Parle Shwetambar Murtipujak Jain Sangh & Charities	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
30c7b9f7-6d37-4d5a-a0c2-b6d1b0feb0aa	ILJ-079	Karan 	Pradeep 	Mehta 	1999-02-26	27	Male	7710931721	Karanmehta9902@gmail.com	1303 ,A-wing, manibhadra tower 	Sarvodaya Nagar, 	Mumbai Suburban	Mulund West 	Maharashtra 	400080	India 	\N	B.com	Business and generative ai	Freelancer / Self-Employed	\N	\N	\N	\N	Graphic Design & Video Editing	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$mRuBr0F.qHtq7k2fUakAsOs.1/JqseQ.IjPb1HP75rmvl7rgdWiGy	2026-02-27 08:39:14.293189+00	2026-05-12 10:05:49.457315+00	{}	\N	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9421c674-7e88-4d96-9cdf-01f31a35c231	ILJ-080	Dhruti 	Jatin	Doshi	2003-02-26	23	Female	9321186391	dhrutidoshi916@gnail.com	12 , Hare Govind , opp to Subhas Dairy	Kelkar road , Ramnagar 	Thane	Dombivali (e)	Maharashtra 	421201	India	\N	Completed Graduation, Pursuing MBA	Finance	Homemaker	\N	\N	\N	\N	Research & Documentation	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$MpeQFjoQilanSAtcew3N7e.anrHeXdHW5Ng50Zb.QT03KF1.TCrQe	2026-02-27 09:25:45.386275+00	2026-02-27 16:14:08.139882+00	{"Building Community & Government Relations"}	Pandurang wadi	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ad3c8d65-6bf2-413e-9081-4c9e72fc43ea	ILJ-081	Parshva	Kalpesh	Ramani	2006-08-27	19	Male	9423570698	parshvaramani@gmail.com	CKP Hall	R.G.G. Road , NR	Thane	Dombivli	Maharashtra	421201	India	\N	UNDER GRADUATE	FINANCE	Student	\N	writting,acting and exploring	writting scripts, directing,recording	\N	Photography & Videography	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$QMG.556KMHoJW78900eyBezPa8vwuWtW1CV.YkELarO6tsSs4TIVe	2026-02-27 15:05:38.276365+00	2026-05-12 10:03:40.383695+00	{"Building Community & Government Relations"}	Rakhi sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
08f53469-511c-45e6-914a-c4aacc2c4fed	ILJ-086	Krisha 	Paresh	Shah	2006-04-04	19	Female	+919653667146	krishapshah7080@gmail.com	A/17 SHUBH APARTMENT	NEAR SITARAM CHOWK , KRISHANAGAR	Ahemdabad 	AHEMDABAD	Gujarat	382345	India	\N	BCom /cs 	Commerce	Student	\N	Dancing teaching reading books 	Management editing photography	\N	Public Speaking, Acting & Stage Activities	Pathshala & Educational Activities	Photography & Videography	Weekends	6 hours	Voluntary (Seva-based)	$2a$06$1y0i9SPeJibDZMTKe5yimOdeySY8Qiyrc8aFQG2r.Zpph/ehIasgC	2026-03-01 12:13:58.729145+00	2026-05-18 16:03:07.796674+00	{"Building Community & Government Relations"}	\N	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
1faa2e14-2817-46d8-8f9e-5e7b70855a98	ILJ-084	Hetvi	Bhavesh 	Doshi	2004-08-14	21	Female	8828489009	doshihetvi04@gmail.com	701, godavari Krupa 	V.p. cross road, near Gupta niwas	Kurla	Mulund, mumbai	Maharashtra	400080	India 	Bal dhoran	FYBA	Economics and yoga trainer	Student	\N	Painting, studying, cycling,	Writing, speaking, leadership roles	Muktimandan Maharaj 	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	\N	Weekends	2 hours	Flexible / Open to Discussion	$2a$06$usMSRtlc364Vsn3l8Gsip.NwMQ7CwYbwcQysSEPjj6ttLtzrgyys6	2026-02-28 09:19:17.235641+00	2026-05-12 10:02:01.529457+00	{}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	ILJ-053	Prisha 	Mahavir 	Jain 	2005-10-31	20	Female	7208770036	prisha.jain@somaiya.edu	D 501 Ciana Atmosphere 2 	Mulund west	Mumbai 	Mumbai 	Maharashtra 	400080	India 	4 prakaran,3 bhashya 	Pursuing BAMMC	Mass Media 	Student	\N	Singing,dancing,acting 	Performing arts 	Sahebji 	Public Speaking, Acting & Stage Activities	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	Flexible	3 hours 30 mins	Voluntary (Seva-based)	$2a$06$VYcjFo/roqRG.j25GEe5nuuiJA1L6pAx/8J4PQNKBTG8ZpVmmyESO	2026-02-13 09:50:12.716586+00	2026-05-18 15:59:27.853992+00	{"Defending Jainism on Social media & digital platforms"}	Shri Sarvodaya Jain sangh 	Manali  Shah	\N	Associate	\N	\N	f	f	pending	\N	f	Active
ba609fa2-c117-4b6e-a4ba-938cb0e4f117	ILJ-083	Vidhi	Praful	Mehta	1992-12-08	33	Female	9819975233	Mehta.vidhi1994@gmail.com	2, Premal Society 	Agarkar Road 	Thane	DOMBIVLI 	Maharashtra 	421201	India	2 Pratikraman, 1st karma granth (arth), Jeevichar (arth).	Mcom	Craft.	Freelancer / Self-Employed	\N	Crafting 	Video editing. 	Muktimandan Vijayji Maharasaheb 	Graphic Design & Video Editing	\N	\N	Flexible	30 mins	Flexible / Open to Discussion	$2a$06$K15Tgyw0LEI9zObq22oJ5uz/IsgvbAE6arBh3p/f40h.gx7FoMua2	2026-02-27 15:50:00.182225+00	2026-05-18 16:02:55.171668+00	{"Defending Jainism on Social media & digital platforms"}	Jai Neminath Murtipujak Shwetambar Jain Sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
f80e1236-fa27-4605-a0c5-3e92f540bc70	ILJ-087	Siddhi	\N	Dedhia	2012-03-21	13	Female	93228 03390 	dedhia.siddhi.21@gmail.com	Gajanan heights b wing 002	Sangeeta wadi shiv mandir road	Thane	Dombivli 	Maharashtra 	421201	India	\N	Study 	Study	Student	\N	\N	\N	Maharasaheb	Pathshala & Educational Activities	Event Planning & Management	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$9kxRG33uKoJSlTnTaQS67OqUIY0QmxpSiNzCZ2pXVWf09HgK6xtp.	2026-03-01 12:14:51.493037+00	2026-03-01 12:42:10.403901+00	{}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a8046eca-1c34-4435-aacf-826e49a40e5b	ILJ-088	Rashi	Hitesh	Gada	2005-09-07	20	Female	8779645715	rashihgada@gmail.com	702/A, Neeragovind, 	S.N rd, Tambenagar, Mulund (w)	Kurla	Mulund	Maharastra	400080	India 	\N	CFA Lvl 1	Finance, investing	Student	\N	Group Actvities,  Drawing & sketcking, Reading books	Dance Choreographer,  Good knowledge of Chess, Understating of Financial concepts & markets.	\N	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Photography & Videography	Weekdays	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$XtOiAPB.2bpqghygMVcut.kLYclsnoakYU4o.IpsF96Kja5KbGMoC	2026-03-01 13:16:18.221669+00	2026-03-01 15:46:40.498406+00	{"Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
19d835f0-85cf-4457-8aa4-86dea0dd14dc	ILJ-089	Nirav	B	Shah	1990-09-24	35	Male	+91 9022177967	nirav.shah2062@gmail.com	B-005 jayesh jyot	Near gomantak hotel 	Thane	Dombivli east	Maharashtra 	421201	India	\N	CA	Finance	Working Professional	\N	\N	\N	\N	Research & Documentation	Event Planning & Management	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$vCd1aaPaCpcphEILxJsRMeteY8.5.qCPDpSttcOcASuuh3.uFCW9G	2026-03-01 16:36:36.353282+00	2026-03-06 17:24:09.87608+00	{}	Rakhi jain sangh dombivli 	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
b7a0ba40-6b70-461d-b806-4583cb44019a	ILJ-093	Sujal	Kamal	Karaniya	2003-11-29	22	Male	9359136562	karaniyasujal@gmail.com	21, 2-B wing Oswal Residency Charnipada	Anjurphata Bhiwandi	Thane	Bhiwandi 	Maharashtra 	421302	India	\N	MBA	Marketing	Student	\N	\N	\N	\N	Graphic Design & Video Editing	Photography & Videography	Event Planning & Management	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$KJaUXBeFDP98xR5fkVDzluuhT9la1/RRx.Uzp4taSZt1hXdGup4Uy	2026-03-05 09:00:34.685777+00	2026-05-12 09:58:04.439576+00	{}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
75d39ffb-b85c-49ad-b08c-978bd0e4ea33	ILJ-092	Jhalak	Praful	Gandhi	2009-12-18	16	Female	9769252009	jhalakgandhi09@gmail.com	Saikrupa bldg 2 floor 8 room no	Gupte road opp apple hospital	Thane	Dombivali 	MAHARASHTRA	421202	India 	\N	Ssc	Commerce	Student	\N	Managing everything 	Mehandi artist ,managing 	Sangh	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	2 hours 30 mins	Flexible / Open to Discussion	$2a$06$bcJDL68rDFuaPXJ4818ep..Ox1OFJA59XjvRJislRdYXc4onUoUze	2026-03-04 13:45:22.900002+00	2026-05-12 09:58:32.755385+00	{"Building Community & Government Relations"}	Naminath jain murtipujak shwetambar sangh dombivali west	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4bf8abb9-f93c-4e9f-838c-10c3069996f9	ILJ-090	Nishita	Nirav 	Vasa	1986-08-15	39	Female	8779937952	Nishita1508@gmail.com	A/302, jayesh Jyot building 	Senapati Bapat Marg, near gomantak lunch home 	Kalyan	Dombivali 	Maharashtra 	421201	India	2 pratikraman 	CA	Finance	Working Professional	\N	\N	\N	Jainam bhai 	Inhouse Pathshala and Home Schooling	Event Planning & Management	Research & Documentation	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$bseavzu9HBtUlyjTvtf7p.Kdr4ng5Ivq.w4xS.RwWwYKh40cjjhWi	2026-03-03 04:07:06.811951+00	2026-05-12 10:00:22.23064+00	{}	Shree jay neminath swetambar murtipujak jain sangh nehru maidan 	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
03a59a7d-da67-44b8-88f7-1a0fbe44f706	ILJ-003	Jainam	Nalinbhai 	Sheth	2000-03-04	25	Male	8879355429	cajainam04@gmail.com	302, Arnath	Sarvoday Nagar 	Mumbai 	Mulund 	Maharashtra	400080	India	Karmgranth	CA	Accounts	Working Professional	\N	Reading 	\N	Jainam Mehta	Public Speaking, Acting & Stage Activities	Research & Documentation	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$kVLflD31LJIirjJKSYQVNe76PCBPL4FAF6UW2x1pleGSBHbW42W6i	2026-02-01 15:25:16.393861+00	2026-05-18 17:41:20.506937+00	{"Defending Jainism on Social media & digital platforms"}	Sarvoday sangh 	Jainam Mehta	\N	Manager	\N	\N	f	f	pending_onboarding	\N	f	Active
9a067c77-bb95-44cc-812e-4557ac17f80a	ILJ-030	Aayushi	Bhadresh	Shah	2003-09-15	22	Female	+919820583463	aayushishah1556@gmail.com	101,Sumati Apartment Sambhav CHS,opp Sarvoday jain mandir,mulund west	Sarvoday Nagar, Mulund west	Mumbai	Mumbai	Maharashtra	400080	India	\N	Pursuing CFA	Finance	Student	\N	Content writing\nScript drafting \nResearch and documentation 	\N	Shruti Shah	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	\N	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$kTXLpLNQcgbjrgxAPTiOVetW2f.I7gRwlXGVsnKfod4B0bNTL2Fly	2026-02-10 10:10:54.446122+00	2026-05-12 09:29:52.168654+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Sarvoday Parshwanath Sangh	Aayushi Sanghavi	Content Writing (Articles, Blogs, Scripts)	Associate	\N	\N	f	f	pending	\N	f	Active
1d0c758c-fa1d-48fd-8ed6-e6a4f9a976d5	ILJ-096	Param	\N	Gada	2010-03-30	15	Male	9653202224	paramhgada30@gmail.com	A/702, Neera Govind	S.N Road, Mulund W	Mumbai	Mumbai	Maharashtra 	400080	India	5 Pratikaman	10th	Commerce 	Student	\N	Debating, Jain Philosophy	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	Pathshala & Educational Activities	Weekends	\N	Voluntary (Seva-based)	$2a$06$QRdDRgNjk/erASa3h.y1ueX4rjE20.Qxl1geRjB6MQcDEktwz1uE6	2026-03-10 17:03:52.818109+00	2026-05-12 09:56:31.634611+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
f51b0111-f04d-453a-b6c0-60d9832fba6b	ILJ-002	Aayushi	\N	Sanghavi	2004-08-05	21	Female	8657634527	pritiaayu1@gmail.com	8, Virat Chs	Tilak School Road	Thane	Dombivli	Maharashtra	421201	India	5 Pratikraman. 9 Smaran (except Kalyanmandir)	Bcom.(Completed), Actuarial Science (Pursuing)	Actuarial Science	Student	\N	Drawing, Painting, Listening Music	Graphics, Acting, Public Speaking, AI	\N	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Flexible	\N	Voluntary (Seva-based)	$2a$06$MQ1/wlvTHU9ok7JqDcTGu.ltDD5dsDhZkGt28/.d2agVfQH77PnG.	2026-02-01 15:17:23.134426+00	2026-05-18 17:41:12.153962+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	\N	Jainam Mehta	Public Speaking, Acting & Stage Activities|Graphic Design & Video Editing|Photography & Videography	Director	\N	Chair Person	t	t	pending_onboarding	Digital Jinshasan	t	Active
308b47f5-d3e6-479a-a0a5-a8be6591e7b8	ILJ-095	Niyati	Maulik	Mehta	1996-09-18	29	Female	9969288130	niyatidoshi90@gmail.com	702, ram kutir 	Sarojini road, vile Parle west	Mumbai Suburban 	Mumbai	Maharashtra 	400056	India	\N	Mcom , diploma in commercial art	Accounts 	Homemaker	\N	\N	\N	\N	Pathshala & Educational Activities	Event Planning & Management	\N	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$C5sDYs1Zlq9UK/P.KssH2.WRRgUmDu6TwOafo27EDt3wBM/UwuN8m	2026-03-07 11:55:40.789982+00	2026-05-12 09:56:56.341733+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4d69310b-0603-47ba-9171-644236ecde06	ILJ-104	Priyal	Rupesh	Shah	2003-09-27	22	Female	9967710560	priyalshah0500@gmail.com	601, C wing Panchsheel Gardens 	Mahavir nagar, Kandivali 	Mumbai	Mumbai	Maharashtra 	4000037	India	\N	Bcom	Finance 	Working Professional	\N	\N	Currently working as a social media manager and designer at creative agency 	\N	Graphic Design & Video Editing	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$z.ESNzrKVZ5IJNVAU86TLOZ6I1Wz1LahNLKet5xpz.fNCZjWx4r2K	2026-03-26 04:39:42.102004+00	2026-05-12 09:52:08.359829+00	{"Defending Jainism on Social media & digital platforms"}	Devkaran Mansion Princess Street Marine lines	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9f6ca714-7578-43d0-b6c2-290e4e6ef413	ILJ-099	Neha 	Hiren 	Shah	1978-03-26	47	Female	9082956348 	nehashah260478@gmail.com	A/303,304 marble arch 	T.p.s rd ,Above Gujarati Seva Mandal 	Borivali West 	Mumbai 	Maharashtra 	400092	India	2 pratikaman 	B	B.Com , DBM	Homemaker	\N	Cooking reading 	\N	\N	Inhouse Pathshala and Home Schooling	Event Planning & Management	\N	Flexible	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$cq0.5zBsDAh0qh/dHBdu5erCMlJ8u9vlWFnXVixT25TfJcEc2uWsG	2026-03-14 07:26:33.990557+00	2026-05-12 09:55:03.415173+00	{"Building Community & Government Relations"}	Shree kalpataru marudhar jain sangh	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
117f2d44-cb82-475c-bdf9-841f771649d5	ILJ-102	Harsh	Bhavesh	Sanghavi	2001-12-05	24	Male	8779013669	harshsanghavi0512@gmail.com	Q902, 9th floor, panchsheel garden	Mahavir nagar, kandivali west	Mumbai	MUMBAI	MAHARASHTRA	400067	India	Upto Jeev vichar	CA	FInance	Working Professional	\N	\N	\N	\N	Research & Documentation	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$JtXDuElSFbsesUkzYajELOv8bZbzf2YDniBmUmfIUisnchTYqofkK	2026-03-21 12:17:57.462827+00	2026-05-12 09:53:03.486467+00	{}	\N	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
44ae1d67-01ec-47d6-b057-c42404976678	ILJ-100	Riddhi	Paresh 	Doshi	2003-07-08	22	Female	+91 7021193194	rpd8703@gmail.com	Vijay apartment 	Kisan nagar 	Thane 	Thane 	Maharashtra 	400604	India	5 pratikraman 	MMS	Marketing 	Student	\N	Digital  marketing " graphic design, dancing , event management 	I have own graphic handle @nemishgraphics \nI am taking home patshala at 2/3 place 	Charmi dedhia 	Photography & Videography	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$eX9swhdQU0nbzPlWDY81O.BCnXQ0QRD4U/anMybgdRN2f.fPBiw5a	2026-03-14 18:39:31.301272+00	2026-05-12 09:53:53.945259+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Dharmanath tapagach jain sangh mulund checknaka 	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ae7ecff0-d962-497f-943b-4d772e2483b4	ILJ-098	Vishwa	\N	Shah	2005-09-23	20	Male	+91 93722 87323	Vishwashaha24@gmail.com	2202, 22nd Floor, Earth Castle	Sikkanagar, V.P Road, 	Mumbai	Mumbai	Maharashtra	400004	India	5 Pratikrman, 9 Smaran, 4 Prakaran, 3 Bhashya	BFM	Finance	Student	\N	\N	\N	\N	Event Planning & Management	\N	\N	Flexible	\N	Flexible / Open to Discussion	$2a$06$D6xoYpmXdehOe631MI1.weFaS0QU8Tp.NYiXlS23grsc78kLiA5X.	2026-03-12 16:53:12.319897+00	2026-05-12 09:55:29.075316+00	{}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
b644c23a-6ad3-4c08-ac90-8dc552e7478c	ILJ-097	Rahul	Jain 	Jain	1999-06-23	26	Male	8619707473	rj02688@gmail.com	02	New mochi colony 	Rajasthan 	Pali Marwar 	Rajasthan 	306401	India	2 partikaman 	B com	.	Freelancer / Self-Employed	\N	Jain Dharmik activity 	Jainism 	I love jinshashan contact 	Event Planning & Management	\N	\N	Flexible	\N	Paid Basis (Project or Role-based)	$2a$06$Yu53SiV68IQ3Mtjr3rrsbOilZNanslCY0L4cxoimysChmEjSLtAgy	2026-03-12 15:48:01.925513+00	2026-05-12 09:56:01.250667+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Seth navalchand supary jain dev ki pedi Tapagach sangh	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
eae9a0f2-2bd7-467a-aa1c-b59963276dda	ILJ-094	Rahul	Madanlal	Siyal	1999-05-27	26	Male	7710904277	rjain96933@gmail.com	502, Pragji sunderji apartment 	N s road	Mumbai	Mumbai	Maharashtra	400080	India	\N	Bcom (A&F)	Accounting	Freelancer / Self-Employed	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	1 hour	Flexible / Open to Discussion	$2a$06$N/kPGlMOOOnLThPGZCU.Oeo0TODLQG1uQk9DORIn87qC6BP6WrK1a	2026-03-06 15:43:11.090125+00	2026-05-12 09:57:38.797944+00	{}	\N	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
467d6f6c-4cef-4143-9e20-5827d6690cc1	ILJ-101	vrushti	hitesh	shah	2007-10-28	18	Female	8169386609	vrushti2810@gmail.com	sadguru seva sadan 8, block no. 7	rajaji path, near madhavi bungalow 	thane 	dombivli ( e )	maharashtra 	421 201	india	\N	Pursuing CS, FYBBI	company secretary 	Student	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Inhouse Pathshala and Home Schooling	\N	Flexible	3 hours	Flexible / Open to Discussion	$2a$06$.1.25SA5YOTz8/fHNplIBujK/2qqN6WI54YEx5AcFsdaHu.wHNF/S	2026-03-19 11:08:55.222805+00	2026-05-18 16:03:25.254896+00	{}	shri rajaji road jain sangh 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
3656a4f7-ddaa-4b85-8c89-cde880be3227	ILJ-108	Punya 	Malay	Sanghavi	2009-11-12	16	Female	9137601957	nishapunu@gmail.com	D/8 Guru Milan	R.P.Road opp tilak nagar post office	Thane	Dombivli 	Maharashtra	421201	India	\N	SSC	N/A	Student	\N	Playing, Dancing, Listening music, travelling 	\N	Aayushi Sanghavi	Graphic Design & Video Editing	Photography & Videography	\N	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$Rauht81iQZnTyAU1SsK80.U2bENjEca.hKT7M0RAPnGfY7JcIjPcy	2026-03-30 13:26:39.967315+00	2026-05-18 16:03:58.887924+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Ruddhivardhak Parasmani Jain Sangh	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ec777267-0100-4e47-adcd-afa4e8deb872	ILJ-112	Niti	\N	Doshi	2000-10-29	25	Female	9022612486	nitidoshi29@gmail.com	B-16, Shree Sai Darshan	Sangeet aadi, l. N. Road, Dombivali	Maharashtra	dombivali	Maharashtra	421201	India	5 pratikaman	B. Com	Accounts	Working Professional	\N	\N	\N	\N	Graphic Design & Video Editing	\N	\N	Flexible	30 mins	Flexible / Open to Discussion	$2a$06$z9HGzZLXp3AMVkDTjFddtO3smqyp9zjpF51rNkll8HxtQdv8/BgBi	2026-04-18 07:27:24.122416+00	2026-04-18 07:27:24.122416+00	{}	Shree Shreyashkar parshwava bhakti shwetambar murtipujak jain sangha	\N	\N	Intern	\N	\N	f	f	pending	\N	f	Active
e63d4eb5-df96-472d-9b92-dca55f181f78	ILJ-114	Apeksha	Pankaj	Dand	2010-11-19	15	Female	8692057814	dandsmita1983@gmail.com	C-52 Sevadham 	RAJAJI PATH	Thane 	Dombivali 	Maharashtra 	421201	India	1st dhoran	10th 	Null	Student	\N	Drawing Mehendi cycling 	\N	Arpita Dand 	Event Planning & Management	Public Speaking, Acting & Stage Activities	\N	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$O2A.wkgAIPnk6lPmx.y6e.aLcWLdBKSLbot2GrxWi1NzDUZMcE1y6	2026-04-23 12:59:55.630204+00	2026-05-12 09:48:31.781547+00	{}	RAJAJI PATH Jain Sangh 	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
3ef2bb9b-f81e-433f-a71a-3e0dad5b07ec	ILJ-113	Bhavya 	Hitesh 	Shah	2004-09-22	21	Male	9224680410	shahbhavya2209@gmail.com	Sadguru Seva Sadan 8, Block no.7, Rajaji road	Near Madhavi Bungalow	Thane 	Dombivli ( E )	Maharashtra 	421201	India	2 pratikraman, 5 pratikraman, Navsmaran, Vitragstotra, Vairagyashatak, Shant sudharas 	Post graduation 	Finance	Student	\N	Jain singer 	Music 	\N	Event Planning & Management	\N	\N	Weekends	1 hour	Flexible / Open to Discussion	$2a$06$tWMjsnZDz0LfMSiQPi.uLulySKkibqa/Io5T5ftXz2M/xW/GN8k1a	2026-04-19 15:22:28.213841+00	2026-05-18 18:12:04.614989+00	{"Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shri Rajaji road jain sangh	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4f596e49-9138-494f-9c00-d4106a457861	ILJ-115	Sakshi	\N	doshi	2007-02-19	19	Female	+919819164615	sakshidoshi981@gmail.com	402, A-60, Shyamla CHS, Anand Nagar, 	Dahisar East	Munbai Suburban	Mumbai	Maharashtra	400068	India	2 pratikaman done 	BMS (First year))	Marketing, management 	Student	\N	Basic Editing, Doing Art	Creative, Basic Editing	Mukti mandan Sahebji	Graphic Design & Video Editing	\N	\N	Flexible	1 hour	Paid Basis (Project or Role-based)	$2a$06$wAvMRn.1QH/hF9/BzGK1N.e6UXh0YxwmrgOGEtr8cijUv8pxGhZF6	2026-04-23 16:23:13.846596+00	2026-05-18 16:04:19.490615+00	{"Defending Jainism on Social media & digital platforms"}	Nityanand jain sangh 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
2c76bf3d-0b94-4acc-bc8f-c12e9f3ce95e	ILJ-107	Prisha 	Hiten 	Gada	2016-01-01	10	Female	8082164470	kinjalgada1119@gmail.com	403, pujari niwas 	Behind Bank of Baroda 	Vile Parle East 	Mumbai	Maharashtra 	400057	India 	Nothing 	Std 4th	Student 	Student	\N	\N	\N	\N	Inhouse Pathshala and Home Schooling	\N	\N	Weekends	\N	Flexible / Open to Discussion	$2a$06$zAlhfIZhvLqhAj./EG7HtOjPrwqzRSpX6VZMooA60GsPC9YKvODuG	2026-03-29 11:54:04.581441+00	2026-05-12 09:50:40.874227+00	{}	Chintamani parshwanath sangh	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
abfeb4ea-ff91-472a-8f0e-d458d122e68a	ILJ-109	Khyati 	\N	Sanghavi 	2002-09-17	23	Female	9136170112	khyatis2002@gmail.com	13, Pali Bhuvan 	Park Road 	Mumbai Suburban	Mumbai	Maharashtra 	400057	India	\N	B.com	Finance 	Working Professional	\N	Filming & On field management 	\N	\N	Event Planning & Management	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$yQFOmtOTZIEsNO2pFyp4UOaa4OHb64EprDd2DAvFagboMZlphBvZ2	2026-03-30 14:36:02.512616+00	2026-05-12 09:50:08.307259+00	{}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
c97ed6dc-f8d5-4311-a1f8-58a72267a160	ILJ-106	TEJASHREE	HARDIK	SHAH	1988-01-14	38	Female	7021376402	tejashree.kotak@gmail.com	VIENTO -D / 1403 , LAKESHORE GREENS 	KHONI PALAVA	THANE	DOMBIVLI 	MAHARASHTRA 	421204	INDIA	\N	BMS & Pursuing CA	People management 	Homemaker	\N	\N	Creative 	P.P.MUKTIMANDAN VIJAYJI M.S.	Event Planning & Management	\N	\N	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$P9G7YKYyMOnBqECBY0M9NOYbvmO3MMTBQ5eLtudhYq5wdMgHAfd5y	2026-03-29 04:27:57.051228+00	2026-05-12 09:51:15.323081+00	{}	Shree Vimal Jin Sangh - Palava	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ccfcbbd3-ed14-440e-9a04-1e348f45996d	ILJ-105	Meenakshi	\N	Borana	1996-04-29	29	Female	+919893822161	meenakshiborana31@gmail.com	New Balaji Nagar	Opp. Jyoti convent school 	Ratlam 	Ratlam	Madhya Pradesh	457001	India	Samayik, Chetyavandan, stuti, Stawan.	CA	Finance 	Working Professional	\N	Dance, Music, Food exploring, Travelling.	Finance, Cake baking, communication, management.	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	\N	Flexible	3 hours	Paid Basis (Project or Role-based)	$2a$06$Bn/nCsb2pRaLWiW.cVKS9O2PwXj8LFZOss8IgnKMGprbR1YFvVqiu	2026-03-26 13:27:43.573258+00	2026-05-12 09:51:39.603988+00	{"Defending Jainism on Social media & digital platforms"}	Tristutik shree sangh Teen thui	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending_it	\N	f	Active
3b0b4acf-0dd3-4c2d-a146-3734bd3026c2	ILJ-110	Nemil	\N	Shah	1997-09-09	28	Male	8488026306	nemil199799@gmail.com	12 B Shantinath society	Behalf Simandhar Jain Temple	Gujarat	Mehsana	Gujarat	384002	India	\N	MCOM	commerce	Working Professional	\N	\N	Accounts , Technical , Google Sheet , AppSheet	\N	IT & Technical Support	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$tE6rPk84ihFE9ni130IhgugtY6c3Go1OwY2dNK.cmAvX5a.DRfAP.	2026-04-08 18:41:38.1296+00	2026-05-15 08:25:04.465458+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Shree Mehsana Upnagar Jain Sangh	Ankit Sheth	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9b5fd841-5c68-4e82-8d91-95d01943d1aa	ILJ-111	DrHardik	\N	Shah	1988-04-23	37	Male	9930409832	dr.hardikshah05@gmail.com	Viento D / 1403	Lakeshore Greens , Khoni Palava	Thane	Dombivli 	Maharashtra 	421204	India	\N	B.D.S.	Dentistry	Working Professional	\N	\N	\N	P.P.MuktiMandan Vijayji M.S.	Event Planning & Management	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$63ITsVo4jI8ezKLiIedBAea9mHLxM3DB5OzXT1qS/k9PplIIwpTE.	2026-04-10 15:06:31.374527+00	2026-05-15 08:33:43.901546+00	{"Building Community & Government Relations"}	Vimaljin Sangh - Palava	Jainam Mehta	\N	Intern	\N	\N	f	f	pending	\N	f	Active
9d559a49-4bd5-4b49-91bc-984ee4bb2b89	ILJ-119	Ayushi shah	\N	Shah	2003-07-21	22	Male	9372582001	aayushishah21073@gmail.com	406 sangeeta enclave sarvodaya nagar 	Mulund West 	Mumbai 	Mumbai 	Maharashtra 	400080	India 	5 partikaman	Graduate 	Finance	Working Professional	\N	\N	\N	\N	Event Planning & Management	Research & Documentation	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$K7Nuad1uQ7ssB6UQ7ju1Eej/J20sWNVSzPVtIgY/CrODUmY9Frf.W	2026-04-26 19:16:28.110525+00	2026-05-12 09:43:41.497522+00	{"Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
a968d860-32be-47e9-8d8e-ef6752a3e879	ILJ-116	omkar	jayesh	kotak	2005-04-10	21	Male	9022312250	omkarkotak753@gmail.com	palava	gograswadi 	thane	mumbai 	maharashtra 	421201	india 	\N	currently pursuing computer science 	computer science 	Student	\N	photography and videography 	\N	\N	IT & Technical Support	\N	\N	Weekends	30 mins	Paid Basis (Project or Role-based)	$2a$06$xsUFHxQ/lfMtI27nepWLMefCC/TeeicnadB468mvSFyFRUAwr7LaC	2026-04-23 16:24:18.342018+00	2026-05-18 15:52:03.739448+00	{}	\N	DrHardik Shah	\N	Intern	\N	\N	f	t	pending	\N	f	Active
f0d6a329-ff03-4ba6-8006-5742402e06bb	ILJ-121	Puja	\N	Dedhia	1996-01-14	30	Female	07738485801	dedhiapuja18@gmail.com	Princess Street	Pathakwadi, Lohar Chawl, Kalbadevi	Mumbai	Mumbai	Maharashtra	400002	India	\N	MA in Clinical Psychology 	Psychology 	Freelancer / Self-Employed	\N	Learning new things, art, music	\N	Mukti Mandan M.S. 	Research & Documentation	Content Writing (Articles, Blogs, Scripts)	\N	Flexible	5 hours	Flexible / Open to Discussion	$2a$06$QxaQBAb.a4t/fd5fmT.ju.4Csj0INYZQwuy6RWtM.KSZsyqgYjvm.	2026-05-04 09:56:08.01923+00	2026-05-11 08:30:32.419759+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
dfe13521-6ab4-4474-b1cc-32ac91e74ea5	ILJ-117	Labdhi	Mehul	Mehta	2008-05-04	17	Female	8454949219	labdhimehta04@gmail.com	LBS Road , Bhandup West Mumbai 400078	Shrinathdham society behind madras cafe , Bhandup 	Kurla	Mumbai 	Maharashtra	400078	India	2 std	12 th	Commerce 	Student	\N	Reading n mehndi 	\N	\N	Event Planning & Management	Content Writing (Articles, Blogs, Scripts)	Photography & Videography	Weekends	2 hours 30 mins	Voluntary (Seva-based)	$2a$06$xkbXfuQ.dm0o3nFb9URCTut5tINmB49.n4FWyW/0qxgWUy4L8ZcRS	2026-04-24 10:58:02.45842+00	2026-05-12 09:47:02.27201+00	{"Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
85fd79c7-df83-40a2-90ff-15a51d3d79fd	ILJ-120	Arpita	Ketan	Shah	2000-01-14	26	Female	+919029433992	arpitashah302@gmail.com	A-11 prem rose tambe nagar mulund (west) mumbai-08	Near jain temple,opposite amrut tower	Kurla	Mumbai	Maharashtra	400080	India	5 pratikaman	M.com	Accounts	Working Professional	\N	Reading, listening to music, learn new things	\N	\N	Pathshala & Educational Activities	Public Speaking, Acting & Stage Activities	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$QkV/EdnOKCdqYC8kBesAEupXqXceSrrOZPhYl1H8fZ7A90d6D87lS	2026-04-28 03:45:31.721247+00	2026-05-12 09:43:12.142402+00	{"Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4d17c59e-7231-4a0f-bd3f-8294f90e212e	ILJ-103	Virti 	Shah	Manish 	2008-07-29	17	Female	+44919326481638	virtimshah29@gmail.com	Swami Vivekanand Rd	Malad shopping centre sv road near Sai Baba mandir opposite to metro shoes A wing 4 floor flat no 22 	Maharashtra	Mumbai	Maharashtra	400064	India	2 partikam done \nStavans doing 	12 hsc boards this year pursuing baf 	Company secretary teacher training 	Student	\N	Singing traving photography 	Dancing 	Instagram and ms 	Public Speaking, Acting & Stage Activities	Event Planning & Management	Inhouse Pathshala and Home Schooling	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$.U3skLzMae5ZN3wqmr/wa.Jqqe5pxVguBV2dl4BieRNP/OlPdoZJK	2026-03-25 03:54:12.504796+00	2026-05-18 16:03:41.956586+00	{"Defending Jainism on Social media & digital platforms"}	Devkaran murji jain sangh 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
4b42c12c-6dd7-49fc-8268-24564f5b9204	ILJ-122	Jainaam 	Rakesh 	Singhi 	1998-11-26	27	Male	8850640956	sidkitisitti@gmail.com	A wing 301-302 Meena Apartments Malad West. Kasturba road. 	Auris Serenity Tower 2 - 704. Malad West. 	Mumbai 	Mumbai 	Maharashtra 	400064	India 	\N	Bachelors in Music 	Guitar Major with Audio Engineering 	Freelancer / Self-Employed	\N	Music and travelling. 	Music 	Guruji 	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	\N	Flexible / Open to Discussion	$2a$06$Dh0kMv.tMSV5fC3thQqm.OClw5WuKIWNLLkYoegBScA2md9OKEvYO	2026-05-10 16:05:42.786306+00	2026-05-18 18:05:04.453079+00	{"Building Community & Government Relations"}	\N	Dr. Sujata Singhi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
f24c03cf-533a-4334-badc-b450e0ac0a6b	ILJ-058	Ariha	Manish	Parekh	2009-02-01	17	Female	9892745362	arihaaparekh01@gmail.com	402,Tulsa Niwas Opp. Matruchaya 	Near babji ki jhopdi satyadhyan vidyapith marg 	Thane District 	MUMBAI SUBURBAN	MAHARASHTRA	400080	India	2 Pratikraman Complete \n5th Std Exam Complete 	Currently in 12th std	Persuing Engineering 	Student	\N	Like to do coding and public speaking	Learning coding and a good speaker	\N	IT & Technical Support	Public Speaking, Acting & Stage Activities	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$TnTfPpwX/0DC2mGju6.OaO7Z4eMD0XHvBK6bGANh.bIWhH02vFmZK	2026-02-16 15:50:48.487191+00	2026-05-12 10:37:43.455048+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Zaver Road Sangh Mulund West 	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
55dbfa08-450b-42c5-9372-6b24963f36b5	ILJ-118	Dipti	\N	Gandhi	1973-07-22	52	Female	9320455202	diptigandhi304@gmail.com	A-504, Shree Aashirwad Building	Anand Nagar, Dahisar East 	Mumbai Suburban 	Mumbai 	Maharashtra 	400068	India	9 tatva	12th pass	Science	Homemaker	\N	Singing, public speaking, cooking	\N	\N	Event Planning & Management	\N	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$6em.dcX64FZezWVAS.TkG.PL7ZhWQqjGnvRDgiyZPNeyrX9iVccMy	2026-04-26 05:26:38.131793+00	2026-05-18 16:04:32.738942+00	{}	\N	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
f854a439-e72d-44fc-8efe-a0f755462a04	ILJ-050	Rutvi	\N	Sanghavi	1998-09-23	27	Female	9870175733	rutvisanghavi5@gmail.com	147/48, Tawawala Bldg, 3rd Floor	Lohar Chawl, Princess Street	Mumbai	Mumbai	Maharashtra	400002	India	\N	B.Des in Communication Design	Graphic Design in Communication Design	Freelancer / Self-Employed	\N	Journaling\nCreative activities\nArts and Crafts	Management\nCreative problem solving\nPlanning, stratergising and analysis\nBusiness Development\nCommunication	\N	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	Research & Documentation	Flexible	\N	Voluntary (Seva-based)	$2a$06$pd3d59/YUpiikTUgc.sZX.EqD9lmJmilfzSMHo1f/Q1PoxlqOkuZ6	2026-02-12 10:04:52.685918+00	2026-05-12 10:39:55.824191+00	{}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
11fc3990-68cc-4cdb-ad83-fca0ec15799f	ILJ-124	Shruti	Chetan	Shah	2003-11-03	22	Female	9372674176	shahshruti3113@gmail.com	601/A, Meghdoot CHS	PK road, Mulund west	Mumbai suburban 	Mumbai	Maharashtra	400080	India	2 dhoran	BCom, ca finalist	Ca 	Student	\N	Reading 	\N	\N	Event Planning & Management	\N	\N	Flexible	3 hours	Voluntary (Seva-based)	$2a$06$eiwsq0j.A.mHrtMr5MDFv.1FIT/Pv/0XhRFYWmS6020QJHd.tVwcO	2026-05-15 09:57:43.159552+00	2026-05-18 18:05:48.291769+00	{}	Zaver road sangh 	Aayushi Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
539a319d-7e31-4db7-8dec-7d04d92629d3	ILJ-125	Kashish	Manoj 	Jain 	2003-11-11	22	Female	9633894567 	kashishmanojjain@gmail.com	1804/A wing Shanti Kamal Lalbaugh 	Near Soman Nagar Chinchpokli	Mumbai 	Mumbai 	Maharashtra 	400012	India 	Navkar mantra 	Bachelors 	Marketing in Smm and digital marketing 	Freelancer / Self-Employed	\N	I love to eat and explore places,learn more about history and Temples 	Editing,Canva,Adobe premiere pro,communication skills	Muktimantan Marashabhji 	Graphic Design & Video Editing	Photography & Videography	\N	Flexible	5 hours	Paid Basis (Project or Role-based)	$2a$06$c1B1TI11I25J6GHUAZCEDu51sU6Hkbp5wtwVMv4uE8jVlvl7iXz42	2026-05-17 06:16:22.605197+00	2026-05-18 18:02:18.216631+00	{"Building Community & Government Relations"}	Shantikamal Jain sangh 	Rutvi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
58be09cf-362d-4919-9a0a-67aa65a5c52e	ILJ-035	Snehi	Praful	Vora	2004-07-06	21	Female	93214 21361	Snehivora06@gmail.com	302, Vishnu Bhuvan	Gupte road	Thane 	Dombivali 	Maharashtra	421202	India	5 Pratikaman & 9 Smaran 	CMA (US)	Finance	Working Professional	\N	Content Writing, Content Creation, Podcasting, Acting, Drama 	Content Writing, Content Creation, Podcasting, Acting, Drama, Excel, AI &Automation, Costing	Ayushi Sanghavi	Public Speaking, Acting & Stage Activities	Content Writing (Articles, Blogs, Scripts)	Marketing & Outreach	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$zlGyriG3/CvcPHzv2lAF9O/OwbwqPOm1.SGTJBuVj38RVYsLn2eUu	2026-02-10 17:33:08.82233+00	2026-05-18 15:58:14.584543+00	{"Building Community & Government Relations"}	Naminath Jain Sangh 	Manali  Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
914b0f69-d854-494a-88d2-d35987b82c79	ILJ-126	Nirag	\N	Doshi	2000-06-14	25	Male	7698851611	doshinirag@gmail.com	Kavya Apartment, Times of India Road	Anandnagar	Ahmedabad	Ahmedabad	Gujarat	380015	India	Panch Pratikaman	BSc	Physics	Working Professional	\N	Travelling, photography, swimming 	Tech, Canva, VN	Krisha Shah	Public Speaking, Acting & Stage Activities	Photography & Videography	Event Planning & Management	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$/1XknQ/awPmQDrD.mUIGKef2vgA55g1EE.t/O4c972C3Ry334JBpe	2026-05-17 07:32:00.528542+00	2026-05-18 18:02:52.663802+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	\N	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
2542f1d3-b3a5-4a93-a0ad-062fd0d4cb7e	ILJ-127	Navyam	Nirav	Shah	2010-10-12	15	Male	81698 00591 	shahnavyam2010@gmail.com	140	Railway Police Colony, Ghatkopar East	Mumbai	Mumbai	Maharashtra	400075	India	\N	SSC	Science 	Student	\N	Talking,internet surfig,cricket	Using AI	Kathan shah	Research & Documentation	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Weekends	2 hours	Flexible / Open to Discussion	$2a$06$YnQi497vr4QJWRrBCDIXsua3JS6.d/OInA3e2S5in3PLkgM0UNDxa	2026-05-18 06:01:08.698131+00	2026-05-18 18:03:03.901036+00	{"Defending Jainism On-field engagement"}	Dineshbhuvan	DrHardik Shah	\N	Intern	\N	\N	f	f	pending	\N	f	Active
d868f2b7-f054-4c90-84aa-be0cd7490fa5	ILJ-123	Dr. Sujata	Rakesh	Singhi	1969-05-12	57	Female	9820649229	Sujatasinghi.com@gmail.com	704, Tower 2, Auris Serenity, Kanchpada Malad west	Kanchpada	Malad	Mumbai	Maharashtra	400064	India	\N	Ph.D, D.litt	Author, TEDx Speaker, Scientist-Sound as Medicine and Spiritual Sciences	Freelancer / Self-Employed	\N	Training youth on Meditation, Spiritual Sciences  globally. \n\n	Sound Medicine Master Trainer, Scientist, International Keynote Speaker, Licensed Life and Leadership Coach\nWww.sujatasinghi.com	Muniraj Shri Muktimandan Sahebji	Public Speaking, Acting & Stage Activities	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	Flexible	\N	Flexible / Open to Discussion	$2a$06$Q83No0GKEljgsZKPxv29le0HL5/ZxYU2KJkAMNPpSUV9IFm2vMB9C	2026-05-12 11:00:42.408937+00	2026-05-18 18:05:23.08797+00	{"Defending Jainism On-field engagement","Building Community & Government Relations"}	\N	Aayushi Sanghavi	\N	Intern	\N	\N	f	f	pending	\N	f	Active
ecf01a58-0258-4666-b777-aabc6b516035	ILJ-128	PARMAR 	PRAVIN 	GULAB CHAND	1955-11-01	70	Male	9321562536	vikas_dairyproducts@yahoo.co.in	19, Rege bldg. 1st floor 	Bhai Jivanji lane 	Maharashtra 	Mumbai-4,00,002	Maharashtra	400002	India	5 - Pratikraman	B.com	Commerce-Marketing 	Freelancer / Self-Employed	\N	Study religious books & singing	Public speaking 	No one.	Public Speaking, Acting & Stage Activities	Pathshala & Educational Activities	Inhouse Pathshala and Home Schooling	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$YD2jkpn5uPYzKBqmiOj2QOr86P6ZNXvbVdcgupAr9pt9UkGkHWoCq	2026-05-28 05:11:30.189762+00	2026-05-28 05:11:30.189762+00	{"Building Community & Government Relations"}	\N	\N	\N	Intern	\N	\N	f	f	pending	\N	f	Active
59cfdf9a-bef2-405a-9a65-3247132d7654	ILJ-129	Kajal	Vijay 	Shah 	1997-03-16	29	Female	7208840354	kajalsanghavi099@gmail.com	Neelkanth enclave ,901/C , 	Near Shreya’s cinema, Ghatkopar West 	Mumbai -sub 	Mumbai 	Maharashtra 	400086 	India 	5 pratikraman 	BA LLB	Arts 	Other	I’m doing share market and in free time promoting my crochet business 	Reading, movies 	Creativity 	Harsh 	Graphic Design & Video Editing	Event Planning & Management	Photography & Videography	Weekdays	2 hours	Voluntary (Seva-based)	$2a$06$F5kXnL.vXThL8dXbxTVgVOKjoTtV6gCz6rI8NHnr42HoyaLLyOfeO	2026-05-31 07:14:13.34901+00	2026-05-31 07:14:13.34901+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Sangani 	\N	\N	Intern	\N	\N	f	f	pending	\N	f	Active
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-01-27 10:59:36
20211116045059	2026-01-27 10:59:36
20211116050929	2026-01-27 10:59:37
20211116051442	2026-01-27 10:59:38
20211116212300	2026-01-27 10:59:39
20211116213355	2026-01-27 10:59:39
20211116213934	2026-01-27 10:59:40
20211116214523	2026-01-27 10:59:41
20211122062447	2026-01-27 10:59:42
20211124070109	2026-01-27 10:59:42
20211202204204	2026-01-27 10:59:43
20211202204605	2026-01-27 10:59:44
20211210212804	2026-01-27 10:59:46
20211228014915	2026-01-27 10:59:47
20220107221237	2026-01-27 10:59:47
20220228202821	2026-01-27 10:59:48
20220312004840	2026-01-27 10:59:49
20220603231003	2026-01-27 10:59:50
20220603232444	2026-01-27 10:59:51
20220615214548	2026-01-27 10:59:51
20220712093339	2026-01-27 10:59:52
20220908172859	2026-01-27 10:59:53
20220916233421	2026-01-27 10:59:54
20230119133233	2026-01-27 10:59:54
20230128025114	2026-01-27 10:59:55
20230128025212	2026-01-27 10:59:56
20230227211149	2026-01-27 10:59:57
20230228184745	2026-01-27 10:59:57
20230308225145	2026-01-27 10:59:58
20230328144023	2026-01-27 10:59:59
20231018144023	2026-01-27 10:59:59
20231204144023	2026-01-27 11:00:01
20231204144024	2026-01-27 11:00:01
20231204144025	2026-01-27 11:00:02
20240108234812	2026-01-27 11:00:03
20240109165339	2026-01-27 11:00:03
20240227174441	2026-01-27 11:00:05
20240311171622	2026-01-27 11:00:05
20240321100241	2026-01-27 11:00:07
20240401105812	2026-01-27 11:00:09
20240418121054	2026-01-27 11:00:10
20240523004032	2026-01-27 11:00:12
20240618124746	2026-01-27 11:00:13
20240801235015	2026-01-27 11:00:14
20240805133720	2026-01-27 11:00:14
20240827160934	2026-01-27 11:00:15
20240919163303	2026-01-27 11:00:16
20240919163305	2026-01-27 11:00:17
20241019105805	2026-01-27 11:00:17
20241030150047	2026-01-27 11:00:20
20241108114728	2026-01-27 11:00:21
20241121104152	2026-01-27 11:00:22
20241130184212	2026-01-27 11:00:22
20241220035512	2026-01-27 11:00:23
20241220123912	2026-01-27 11:00:24
20241224161212	2026-01-27 11:00:25
20250107150512	2026-01-27 11:00:25
20250110162412	2026-01-27 11:00:26
20250123174212	2026-01-27 11:00:27
20250128220012	2026-01-27 11:00:27
20250506224012	2026-01-27 11:00:28
20250523164012	2026-01-27 11:00:29
20250714121412	2026-01-27 11:00:29
20250905041441	2026-01-27 11:00:30
20251103001201	2026-01-27 11:00:31
20251120212548	2026-02-05 06:36:31
20251120215549	2026-02-05 06:36:32
20260218120000	2026-03-01 11:08:45
20260326120000	2026-05-21 09:32:56
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
project-banners	project-banners	\N	2026-01-28 19:24:54.350792+00	2026-01-28 19:24:54.350792+00	t	f	\N	\N	\N	STANDARD
event-banners	event-banners	\N	2026-01-29 09:29:16.433055+00	2026-01-29 09:29:16.433055+00	t	f	\N	\N	\N	STANDARD
project-gallery	project-gallery	\N	2026-03-09 17:01:08.98993+00	2026-03-09 17:01:08.98993+00	t	f	\N	\N	\N	STANDARD
event-payments	event-payments	\N	2026-03-09 17:51:04.428173+00	2026-03-09 17:51:04.428173+00	t	f	\N	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-01-27 05:58:20.267872
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-01-27 05:58:20.30474
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-01-27 05:58:20.344065
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-01-27 05:58:20.358263
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-01-27 05:58:20.363103
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-01-27 05:58:20.376027
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-01-27 05:58:20.381054
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-01-27 05:58:20.397011
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-01-27 05:58:20.403386
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-01-27 05:58:20.40833
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-01-27 05:58:20.413406
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-01-27 05:58:20.445575
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-01-27 05:58:20.450703
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-01-27 05:58:20.455642
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-01-27 05:58:20.460695
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-01-27 05:58:20.468701
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-01-27 05:58:20.473572
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-01-27 05:58:20.480574
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-01-27 05:58:20.494124
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-01-27 05:58:20.503297
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-01-27 05:58:20.508356
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-01-27 05:58:20.51423
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-01-27 05:58:20.606949
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-01-27 05:58:20.656959
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-01-27 05:58:20.66357
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-01-27 05:58:20.674895
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-01-27 05:58:20.679971
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-01-27 05:58:20.700169
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-01-27 05:58:20.30977
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-01-27 05:58:20.369528
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-01-27 05:58:20.386251
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-01-27 05:58:20.391421
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-01-27 05:58:20.519383
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-01-27 05:58:20.536016
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-01-27 05:58:20.546789
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-01-27 05:58:20.556787
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-01-27 05:58:20.563578
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-01-27 05:58:20.570723
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-01-27 05:58:20.579116
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-01-27 05:58:20.586233
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-01-27 05:58:20.588244
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-01-27 05:58:20.594383
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-01-27 05:58:20.600062
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-01-27 05:58:20.613075
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-01-27 05:58:20.624483
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-01-27 05:58:20.630146
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-01-27 05:58:20.638233
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-01-27 05:58:20.643789
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-01-27 05:58:20.650114
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-01-27 05:58:20.684887
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-10 15:48:39.181609
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-10 15:48:39.36777
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-10 15:48:39.371536
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-10 15:48:39.597867
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-10 15:48:39.600998
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-10 15:48:39.603122
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-07 15:58:52.254153
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-07 15:58:52.30608
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-02-10 15:48:39.61115
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-05-06 07:39:21.165288
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-05-06 07:39:21.226766
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
72e27a5f-755e-4b82-b6e5-cbba9405b6e0	project-banners	0.706425260224533.jpg	\N	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-28T19:27:10.000Z", "contentLength": 251852, "httpStatusCode": 200}	f13f4acd-bd68-4ae7-96c9-15af2f3a105f	\N	{}
cd2bc014-c3a1-4c8e-b5f1-5e3f5d515364	project-gallery	event-payments/.emptyFolderPlaceholder	\N	2026-03-14 10:21:05.743831+00	2026-03-14 10:21:05.743831+00	2026-03-14 10:21:05.743831+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T10:21:05.749Z", "contentLength": 0, "httpStatusCode": 200}	9bff2c68-3178-49b5-8124-134e2b99059d	\N	{}
aa35cd30-0cfd-4a0a-88c6-ff7822b3b0c1	project-banners	0.7498233647525495.jpg	\N	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T07:29:08.000Z", "contentLength": 251852, "httpStatusCode": 200}	47a0c27e-9b47-4fe6-abd9-8099d89fcd5c	\N	{}
34fbbf00-3fff-4697-8b40-4a59756133fb	event-banners	1769679074311.jpg	\N	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T09:31:16.000Z", "contentLength": 251852, "httpStatusCode": 200}	bc02545e-4c51-4a3b-9870-7978f06374db	\N	{}
0807c07f-ab93-4f81-88ba-57b27f10f003	project-gallery	event-payments/1776493397872-2o85rq0sh99.jpeg	\N	2026-04-18 06:23:19.070489+00	2026-04-18 06:23:19.070489+00	2026-04-18 06:23:19.070489+00	{"eTag": "\\"f3e083760bbf2e32dcfe9dd192c4fd04\\"", "size": 35282, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-18T06:23:20.000Z", "contentLength": 35282, "httpStatusCode": 200}	f2be701d-271e-4f86-b790-b67407b7230c	\N	{}
4d79fac5-70ac-4b6e-9d87-b31dd46649e7	event-banners	1769685751265.jpg	\N	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:22:32.000Z", "contentLength": 251852, "httpStatusCode": 200}	57132961-4797-47e2-aa99-eb20e384b5b1	\N	{}
bcb24dd2-ed2f-4a6e-a7fc-5c341fcb673f	event-banners	1769686948705.jpg	\N	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:42:30.000Z", "contentLength": 251852, "httpStatusCode": 200}	0b984452-cd33-4a33-a986-ef81da510840	\N	{}
97c795c5-247a-4bcd-84cd-e889a14cc191	project-banners	0.009730189570724579.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-15 14:29:08.421211+00	2026-05-15 14:29:08.421211+00	2026-05-15 14:29:08.421211+00	{"eTag": "\\"0f546eb3ba60b63682ffe526be2a5189\\"", "size": 129292, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-15T14:29:09.000Z", "contentLength": 129292, "httpStatusCode": 200}	2bc767f3-f0c8-4c8c-bc91-928812b4bce6	35c1bb89-4881-4798-a257-8b714d2017dd	{}
29d2010d-8127-449a-97a6-c1fcd352667c	project-banners	0.7966996394579555.jpeg	\N	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	{"eTag": "\\"16a81774f0e4709822c4e1238625879a\\"", "size": 107144, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:26:54.000Z", "contentLength": 107144, "httpStatusCode": 200}	9581a682-011c-4e1e-90cc-40180be59af6	\N	{}
66c54576-ed22-4914-a88e-a21b75227ecd	project-banners	0.44102312685847256.jpeg	\N	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	{"eTag": "\\"a450795afdde0fc5633a3b09102e814b\\"", "size": 93140, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:45:34.000Z", "contentLength": 93140, "httpStatusCode": 200}	15ecb65b-6003-4d81-bde7-74edbf997542	\N	{}
35504c10-c092-4c9e-99dc-829035be3264	project-banners	0.05016668586183837.jpeg	\N	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	{"eTag": "\\"7d9c5a4e3d7c6bf87c0346ca9ec3ae8a\\"", "size": 108083, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:57:19.000Z", "contentLength": 108083, "httpStatusCode": 200}	b5053847-6bc8-4fcb-96ad-dfa41fe19de2	\N	{}
1a44bd0e-7c65-41de-8754-31a4a951cdcc	project-banners	0.08290226501735143.jpeg	\N	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	{"eTag": "\\"c71325b64f697407be23c2db3b2e6a1e\\"", "size": 110470, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T16:11:09.000Z", "contentLength": 110470, "httpStatusCode": 200}	730b87fd-aba8-40f3-b165-d70fbc9ce907	\N	{}
ddf89632-3734-460a-9a83-09fb8286b662	project-banners	0.4307583412898245.jpeg	\N	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	{"eTag": "\\"2885aa813f3d9c184ed2f9e9cc1d8db2\\"", "size": 116818, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:46:27.000Z", "contentLength": 116818, "httpStatusCode": 200}	769d0dc0-3fb2-424d-88a2-d50233e60460	\N	{}
e828463f-762b-425c-9753-48f49a1788e0	project-banners	0.5921959842517635.jpeg	\N	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	{"eTag": "\\"9d810b69b13ff72672c5e1bbba2dd7d4\\"", "size": 121719, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:55:05.000Z", "contentLength": 121719, "httpStatusCode": 200}	4b4fcfde-602e-46df-83d7-990ffd85fbb9	\N	{}
7f9d63a7-0e50-4b6d-bbd2-d42a578602f7	event-banners	1770555171144.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-08 12:52:51.07972+00	2026-02-08 12:52:51.07972+00	2026-02-08 12:52:51.07972+00	{"eTag": "\\"7d9c5a4e3d7c6bf87c0346ca9ec3ae8a\\"", "size": 108083, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-08T12:52:52.000Z", "contentLength": 108083, "httpStatusCode": 200}	73163a7b-40b8-4fb1-86af-9e6f3ce6dabc	35c1bb89-4881-4798-a257-8b714d2017dd	{}
06826b36-c718-4803-bfb9-3b236e2190c6	project-banners	0.9836200471240258.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-08 14:19:07.580985+00	2026-02-08 14:19:07.580985+00	2026-02-08 14:19:07.580985+00	{"eTag": "\\"9d810b69b13ff72672c5e1bbba2dd7d4\\"", "size": 121719, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-08T14:19:08.000Z", "contentLength": 121719, "httpStatusCode": 200}	713a3527-a82a-4999-b2d7-f545a329bf65	35c1bb89-4881-4798-a257-8b714d2017dd	{}
30a8b519-e1dd-4e68-9276-e2ad86c28b2d	project-gallery	event-payments/1776582085184-ayzy2kl2t7r.jpeg	\N	2026-04-19 07:01:26.134426+00	2026-04-19 07:01:26.134426+00	2026-04-19 07:01:26.134426+00	{"eTag": "\\"96708346dc79bca3de3a08883a632989\\"", "size": 35388, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-19T07:01:27.000Z", "contentLength": 35388, "httpStatusCode": 200}	770dd053-a7d3-4c04-8565-2d28c97be70f	\N	{}
493f16ea-1c4a-4a61-b5ec-8e40b8dab07b	project-gallery	event-payments/photo-1776582086417-2ab7028htfr.jpeg	\N	2026-04-19 07:01:29.751213+00	2026-04-19 07:01:29.751213+00	2026-04-19 07:01:29.751213+00	{"eTag": "\\"2cbbac5eebcd8afa20f16e39ef78aea7\\"", "size": 3545716, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-19T07:01:30.000Z", "contentLength": 3545716, "httpStatusCode": 200}	5c8c7fce-02cd-4e98-a2ad-8c02e5981216	\N	{}
8cf9e97e-7b70-4051-b3c4-884c84bd2c54	project-banners	0.748476061607198.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-19 17:19:19.312662+00	2026-05-19 17:19:19.312662+00	2026-05-19 17:19:19.312662+00	{"eTag": "\\"29185f4b094ccc385cca36c2b463203f\\"", "size": 1486246, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-19T17:19:20.000Z", "contentLength": 1486246, "httpStatusCode": 200}	5ffda6cd-e893-499f-ae3a-ca877c940d3e	35c1bb89-4881-4798-a257-8b714d2017dd	{}
7950990d-4afc-4777-b479-d4ef68165082	project-gallery	event-payments/1773488297927-ark9x3oa6bc.jpeg	\N	2026-03-14 11:38:20.810925+00	2026-03-14 11:38:20.810925+00	2026-03-14 11:38:20.810925+00	{"eTag": "\\"96e575c099e7df77e4ed2504ca388ff2\\"", "size": 46555, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T11:38:21.000Z", "contentLength": 46555, "httpStatusCode": 200}	19d5e768-0023-4e59-951e-16b97a66a3d7	\N	{}
b7ecf2b3-a2ce-4f39-aa0a-5db0e043aab4	project-gallery	event-payments/photo-1773488298916-uskxg1up7lg.jpeg	\N	2026-03-14 11:38:21.172549+00	2026-03-14 11:38:21.172549+00	2026-03-14 11:38:21.172549+00	{"eTag": "\\"96e575c099e7df77e4ed2504ca388ff2\\"", "size": 46555, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T11:38:22.000Z", "contentLength": 46555, "httpStatusCode": 200}	4851e591-5962-44d2-8975-b941bb671242	\N	{}
14b2704c-59c5-47f4-a493-5edb5bb91e68	project-gallery	1773320105400-i6vyjvuy7wf.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:18.636331+00	2026-03-12 12:55:18.636331+00	2026-03-12 12:55:18.636331+00	{"eTag": "\\"41cad476546a107632d06ff84916fbbd\\"", "size": 2596939, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:19.000Z", "contentLength": 2596939, "httpStatusCode": 200}	c6e622ea-81a8-4cd6-8d57-3b6660a2ea8c	35c1bb89-4881-4798-a257-8b714d2017dd	{}
e8814619-8ff1-4c5f-b34e-e858c604854a	project-gallery	1773320106691-noog5u9erep.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:19.517449+00	2026-03-12 12:55:19.517449+00	2026-03-12 12:55:19.517449+00	{"eTag": "\\"ad0fd46a7960eab8ec2d375b8bdc55b2\\"", "size": 1206552, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:20.000Z", "contentLength": 1206552, "httpStatusCode": 200}	dbe9fdb4-47ff-4b4b-883e-84bc4febfd8c	35c1bb89-4881-4798-a257-8b714d2017dd	{}
14737f53-9520-46de-bb55-7cfb3462c472	project-banners	0.8871190093364836.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-02 06:48:07.245885+00	2026-05-02 06:48:07.245885+00	2026-05-02 06:48:07.245885+00	{"eTag": "\\"79caefb8687aadd471d369dd8a2be05f\\"", "size": 116048, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-02T06:48:08.000Z", "contentLength": 116048, "httpStatusCode": 200}	d3818163-35aa-42a2-bec1-1424655b88fd	35c1bb89-4881-4798-a257-8b714d2017dd	{}
9919533b-29d0-4696-8ddf-37176028d508	project-gallery	1773320107511-8a6eny7vw5b.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:20.22623+00	2026-03-12 12:55:20.22623+00	2026-03-12 12:55:20.22623+00	{"eTag": "\\"cd5197609845dfdd843c40625baea19c\\"", "size": 485970, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:21.000Z", "contentLength": 485970, "httpStatusCode": 200}	fd10f13b-e0bd-4a40-8d24-83d65a4ee317	35c1bb89-4881-4798-a257-8b714d2017dd	{}
664443bc-c8a1-4543-8276-c081fa0059c2	project-gallery	1773320108221-szv8w3uxopg.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:20.955431+00	2026-03-12 12:55:20.955431+00	2026-03-12 12:55:20.955431+00	{"eTag": "\\"b4c1f1bb53e7621b856fe4bb0e8cfc95\\"", "size": 650526, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:21.000Z", "contentLength": 650526, "httpStatusCode": 200}	220c5aa5-fa05-4b88-869e-f8f5df3b9e75	35c1bb89-4881-4798-a257-8b714d2017dd	{}
ea8daa5d-3d8a-4519-af43-7d1ca81257ae	project-gallery	1773320108997-7y7yayic9nv.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:21.793823+00	2026-03-12 12:55:21.793823+00	2026-03-12 12:55:21.793823+00	{"eTag": "\\"9492f39634a5bba5c08d7b88eeb41daf\\"", "size": 780880, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:22.000Z", "contentLength": 780880, "httpStatusCode": 200}	c58235a7-19ca-48eb-b9f1-f1e41b027818	35c1bb89-4881-4798-a257-8b714d2017dd	{}
a866bb22-b42c-4d30-bcef-4bdee6108f8f	project-gallery	1773320109780-to3xzqcu3f7.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 12:55:22.486817+00	2026-03-12 12:55:22.486817+00	2026-03-12 12:55:22.486817+00	{"eTag": "\\"7b6d982ea4a3e3dd28d2cb25ac093ccd\\"", "size": 586189, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T12:55:23.000Z", "contentLength": 586189, "httpStatusCode": 200}	759b52bb-875b-495d-b06e-a03b7bba3070	35c1bb89-4881-4798-a257-8b714d2017dd	{}
8ad965ab-484f-40df-8361-72bb4b5d45bc	project-gallery	1773320526539-d7312ufoc1d.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 13:02:19.755269+00	2026-03-12 13:02:19.755269+00	2026-03-12 13:02:19.755269+00	{"eTag": "\\"1f22c9edbad6c624a9933bd547a929b6\\"", "size": 194810, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T13:02:20.000Z", "contentLength": 194810, "httpStatusCode": 200}	4e118543-1e81-4a61-a55c-2bfc02fd4af1	35c1bb89-4881-4798-a257-8b714d2017dd	{}
d7adbad7-bcce-44fd-b54f-6a3eafce34ef	project-gallery	1773320527771-isq9yn9j0nj.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 13:02:21.084173+00	2026-03-12 13:02:21.084173+00	2026-03-12 13:02:21.084173+00	{"eTag": "\\"94d45e3d9e388dc032ef10176dd781e0\\"", "size": 1768342, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T13:02:21.000Z", "contentLength": 1768342, "httpStatusCode": 200}	b8527b54-bb80-435e-aff1-626fcf1c95e5	35c1bb89-4881-4798-a257-8b714d2017dd	{}
e7f27bad-1d67-4bf7-998a-bc7185be6ef8	project-banners	0.8749523258806222.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-04-12 11:16:58.404346+00	2026-04-12 11:16:58.404346+00	2026-04-12 11:16:58.404346+00	{"eTag": "\\"1bbd745f72027b5479852f02f0870880\\"", "size": 86875, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-04-12T11:16:59.000Z", "contentLength": 86875, "httpStatusCode": 200}	a4b95abb-683b-48da-8c35-c2362c86a8f8	35c1bb89-4881-4798-a257-8b714d2017dd	{}
067cf1cc-87d7-49e9-8daf-5196fc6c5d21	project-gallery	1773320529063-vcv6c7dem3.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 13:02:21.908381+00	2026-03-12 13:02:21.908381+00	2026-03-12 13:02:21.908381+00	{"eTag": "\\"f745362a1d0b1c674970f9983ecad61c\\"", "size": 991262, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T13:02:22.000Z", "contentLength": 991262, "httpStatusCode": 200}	259abfc0-a342-479c-b683-2ea899df09fd	35c1bb89-4881-4798-a257-8b714d2017dd	{}
ee360cf2-e23b-4a11-b3a4-3a6dcfd2846c	project-gallery	1773320529871-bs4y6iwijv5.HEIC	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 13:02:22.756985+00	2026-03-12 13:02:22.756985+00	2026-03-12 13:02:22.756985+00	{"eTag": "\\"51353fec1fb3493dcae0b1d3922dae1a\\"", "size": 1323902, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T13:02:23.000Z", "contentLength": 1323902, "httpStatusCode": 200}	3b66629d-6fa0-47a3-817e-541aeb3e8df2	35c1bb89-4881-4798-a257-8b714d2017dd	{}
a3f0901f-8071-436f-b42e-da417463bc41	project-banners	0.7953297959784796.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-06 16:29:48.369151+00	2026-05-06 16:29:48.369151+00	2026-05-06 16:29:48.369151+00	{"eTag": "\\"2d80a725396ba6190a4e76dbf7569787\\"", "size": 147154, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-06T16:29:49.000Z", "contentLength": 147154, "httpStatusCode": 200}	7889325c-da6d-43a0-91c7-04ae5386ef25	35c1bb89-4881-4798-a257-8b714d2017dd	{}
594bc89e-cf71-4aab-b76a-a274aeac234b	project-gallery	1773320530704-xssqixikkd.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-12 13:02:23.856401+00	2026-03-12 13:02:23.856401+00	2026-03-12 13:02:23.856401+00	{"eTag": "\\"895fdedfbc3b317b86a8c6fe3e80dce7\\"", "size": 842422, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-12T13:02:24.000Z", "contentLength": 842422, "httpStatusCode": 200}	84de48e7-e3f0-49ac-8bec-ff17c34533ac	35c1bb89-4881-4798-a257-8b714d2017dd	{}
1dba73c4-eda7-4dd7-9f40-b000f2d1154a	project-gallery	1773460902163-mi4hfxggw.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:01:57.191939+00	2026-03-14 04:01:57.191939+00	2026-03-14 04:01:57.191939+00	{"eTag": "\\"c3e77b4b849ef31966e1f08f3594cdeb\\"", "size": 100394, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:01:58.000Z", "contentLength": 100394, "httpStatusCode": 200}	56163db4-6174-40a9-ba60-e3c75b6d740a	35c1bb89-4881-4798-a257-8b714d2017dd	{}
719210f5-5b8e-44b0-b7e2-ded939aa338d	project-gallery	1773460904225-4o842l2l777.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:01:58.563695+00	2026-03-14 04:01:58.563695+00	2026-03-14 04:01:58.563695+00	{"eTag": "\\"e56e10af83aaf9cab66c1e5c00e6e286\\"", "size": 163196, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:01:59.000Z", "contentLength": 163196, "httpStatusCode": 200}	4810b7a6-7ff4-4726-93e6-d73f98a6d828	35c1bb89-4881-4798-a257-8b714d2017dd	{}
41ebaf73-bb99-436f-affa-281c4e0251ae	project-gallery	1773460905034-x4njpawnuro.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:01:59.319271+00	2026-03-14 04:01:59.319271+00	2026-03-14 04:01:59.319271+00	{"eTag": "\\"025a5e7366873b3cf6873ecb9105e2b6\\"", "size": 117074, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:02:00.000Z", "contentLength": 117074, "httpStatusCode": 200}	7a9d92d1-3b20-4dfa-8b20-e46349649571	35c1bb89-4881-4798-a257-8b714d2017dd	{}
01cbdc40-aef0-47ef-8d41-365747ccc8b9	project-gallery	1773460905708-ejhabbxmbcn.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:02:00.113647+00	2026-03-14 04:02:00.113647+00	2026-03-14 04:02:00.113647+00	{"eTag": "\\"0f8c49ce238c876e0c42cdc7cf9bffed\\"", "size": 247382, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:02:01.000Z", "contentLength": 247382, "httpStatusCode": 200}	12d487e6-d9d8-4e11-93bb-4e490341d1fa	35c1bb89-4881-4798-a257-8b714d2017dd	{}
3dc2b361-fd90-45c3-9477-f452d3ff6974	project-gallery	1773460906627-88j9ehw4ka.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:02:00.908405+00	2026-03-14 04:02:00.908405+00	2026-03-14 04:02:00.908405+00	{"eTag": "\\"4e31b76eb4d456c60ec564d609644351\\"", "size": 141389, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:02:01.000Z", "contentLength": 141389, "httpStatusCode": 200}	58572a82-c374-4d59-a0c5-157e07f4f8e5	35c1bb89-4881-4798-a257-8b714d2017dd	{}
3b145d7e-e833-4b64-8476-26a50430d7bf	project-gallery	1773460907315-io89vnshwq.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-03-14 04:02:01.65119+00	2026-03-14 04:02:01.65119+00	2026-03-14 04:02:01.65119+00	{"eTag": "\\"b26a8f1b62ff25676bff6bcbf605ea26\\"", "size": 105179, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T04:02:02.000Z", "contentLength": 105179, "httpStatusCode": 200}	77b683a3-43a1-482d-9c91-c80df22d43a3	35c1bb89-4881-4798-a257-8b714d2017dd	{}
3fdaa5a1-8cdf-447f-84ee-0a50867aebe3	event-payments	.emptyFolderPlaceholder	\N	2026-03-14 10:17:30.879924+00	2026-03-14 10:17:30.879924+00	2026-03-14 10:17:30.879924+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-03-14T10:17:30.885Z", "contentLength": 0, "httpStatusCode": 200}	6be304f1-2acd-4d30-b6e3-807d8fff3efa	\N	{}
9787e4f1-4ec7-481d-be59-6d61fd4015b0	project-banners	0.18227134542660983.png	35c1bb89-4881-4798-a257-8b714d2017dd	2026-05-07 17:19:56.144993+00	2026-05-07 17:19:56.144993+00	2026-05-07 17:19:56.144993+00	{"eTag": "\\"ded85a6094ca23a98878726c1554df2b\\"", "size": 1315591, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-05-07T17:19:57.000Z", "contentLength": 1315591, "httpStatusCode": 200}	558491dd-4e1f-4be8-b330-5290e82f2c75	35c1bb89-4881-4798-a257-8b714d2017dd	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20260127171349	{"\n-- Create a sequence for ILJ IDs\nCREATE SEQUENCE IF NOT EXISTS volunteers_ilj_id_seq START WITH 1;\n\n-- Create volunteers table\nCREATE TABLE IF NOT EXISTS public.volunteers (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    ilj_id TEXT UNIQUE NOT NULL,\n    \n    -- Personal Information\n    first_name TEXT NOT NULL,\n    middle_name TEXT,\n    last_name TEXT NOT NULL,\n    dob DATE NOT NULL,\n    age INTEGER,\n    gender TEXT NOT NULL,\n    \n    -- Contact Information\n    mobile_number TEXT NOT NULL,\n    email TEXT NOT NULL UNIQUE,\n    \n    -- Address\n    address_line1 TEXT NOT NULL,\n    address_line2 TEXT,\n    district TEXT NOT NULL,\n    city TEXT NOT NULL,\n    state TEXT NOT NULL,\n    pincode TEXT NOT NULL,\n    country TEXT NOT NULL,\n    \n    -- Educational & Dharmik Background\n    dharmik_studies TEXT,\n    qualification TEXT NOT NULL,\n    specialization TEXT NOT NULL,\n    \n    -- Occupation\n    occupation TEXT NOT NULL,\n    occupation_other TEXT,\n    \n    -- Interests & Capabilities\n    hobbies TEXT,\n    skills TEXT,\n    \n    -- Referral\n    referred_by TEXT,\n    \n    -- Volunteering Preferences\n    volunteering_preference1 TEXT NOT NULL,\n    volunteering_preference2 TEXT,\n    volunteering_preference3 TEXT,\n    \n    -- Availability & Participation\n    availability_days TEXT NOT NULL,\n    time_commitment TEXT,\n    participation_mode TEXT NOT NULL,\n    \n    -- Authentication\n    password_hash TEXT NOT NULL,\n    \n    -- Timestamps\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW()\n);\n\n-- Create function to generate ILJ ID\nCREATE OR REPLACE FUNCTION generate_ilj_id()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.ilj_id := 'ILJ-' || LPAD(nextval('volunteers_ilj_id_seq')::TEXT, 3, '0');\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n\n-- Create trigger to auto-generate ILJ ID on insert\nDROP TRIGGER IF EXISTS set_ilj_id ON public.volunteers;\nCREATE TRIGGER set_ilj_id\n    BEFORE INSERT ON public.volunteers\n    FOR EACH ROW\n    EXECUTE FUNCTION generate_ilj_id();\n\n-- Enable Row Level Security\nALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;\n\n-- Create policy to allow anonymous inserts (for registration)\nCREATE POLICY \\"Allow anonymous insert\\" ON public.volunteers\n    FOR INSERT\n    WITH CHECK (true);\n\n-- Create policy to allow users to read their own data\nCREATE POLICY \\"Allow read own data\\" ON public.volunteers\n    FOR SELECT\n    USING (true);\n\n-- Create updated_at trigger\nCREATE OR REPLACE FUNCTION update_updated_at_column()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n\nDROP TRIGGER IF EXISTS update_volunteers_updated_at ON public.volunteers;\nCREATE TRIGGER update_volunteers_updated_at\n    BEFORE UPDATE ON public.volunteers\n    FOR EACH ROW\n    EXECUTE FUNCTION update_updated_at_column();\n"}	create_volunteers_table	meets.studentlife@gmail.com	\N	\N
20260127171621	{"\n-- Fix search_path for generate_ilj_id function\nCREATE OR REPLACE FUNCTION public.generate_ilj_id()\nRETURNS TRIGGER \nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    NEW.ilj_id := 'ILJ-' || LPAD(nextval('public.volunteers_ilj_id_seq')::TEXT, 3, '0');\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n\n-- Fix search_path for update_updated_at_column function\nCREATE OR REPLACE FUNCTION public.update_updated_at_column()\nRETURNS TRIGGER\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n"}	fix_function_search_paths	meets.studentlife@gmail.com	\N	\N
20260128191703	{"-- Create projects table\nCREATE TABLE IF NOT EXISTS public.projects (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    project_code TEXT NOT NULL UNIQUE, -- e.g. PRJ-001\n    title TEXT NOT NULL,\n    description TEXT,\n    banner_url TEXT,\n    manager_id UUID REFERENCES public.volunteers(id),\n    created_at TIMESTAMPTZ DEFAULT now(),\n    updated_at TIMESTAMPTZ DEFAULT now()\n);\n\n-- Enable RLS\nALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;\n\n-- Create policy for public read (everyone can see projects)\nCREATE POLICY \\"Projects are public\\" ON public.projects FOR SELECT USING (true);\n-- Create policy for authenticated insert/update (only admins/authenticated users)\n-- For now, just allowing all operations for simplicity since auth is basic in frontend\nCREATE POLICY \\"Enable all for public\\" ON public.projects USING (true) WITH CHECK (true);\n\n\n-- Create project_volunteers junction table\nCREATE TABLE IF NOT EXISTS public.project_volunteers (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,\n    volunteer_id UUID REFERENCES public.volunteers(id) ON DELETE CASCADE,\n    assigned_at TIMESTAMPTZ DEFAULT now(),\n    UNIQUE(project_id, volunteer_id)\n);\n\n-- Enable RLS\nALTER TABLE public.project_volunteers ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Public read project_volunteers\\" ON public.project_volunteers FOR SELECT USING (true);\nCREATE POLICY \\"Enable all for project_volunteers\\" ON public.project_volunteers USING (true) WITH CHECK (true);\n"}	create_projects_schema	meets.studentlife@gmail.com	\N	\N
20260128192454	{"-- Add status column to projects table\nALTER TABLE public.projects ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'upcoming';\n\n-- Create a storage bucket for project banners if it doesn't exist\nINSERT INTO storage.buckets (id, name, public) \nVALUES ('project-banners', 'project-banners', true)\nON CONFLICT (id) DO NOTHING;\n\n-- Set up storage policies for project banners\n-- Allow public access to view\nCREATE POLICY \\"Public Access\\" ON storage.objects FOR SELECT USING (bucket_id = 'project-banners');\n\n-- Allow authenticated users (admin) to upload\nCREATE POLICY \\"Authenticated Upload\\" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'project-banners');\n"}	add_status_and_storage_retry	meets.studentlife@gmail.com	\N	\N
20260128193836	{"ALTER TABLE public.project_volunteers \nADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'approved';\n\n-- Update existing records to match default if needed (though default handles new ones, existing nulls would be an issue if not set, but ADD COLUMN ... DEFAULT usually backfills)\nUPDATE public.project_volunteers SET status = 'approved' WHERE status IS NULL;\n"}	add_status_to_project_volunteers	meets.studentlife@gmail.com	\N	\N
20260128195523	{"ALTER TABLE public.volunteers ADD COLUMN IF NOT EXISTS additional_areas TEXT[] DEFAULT NULL;"}	add_additional_areas_to_volunteers	meets.studentlife@gmail.com	\N	\N
20260128200349	{"ALTER TABLE public.volunteers ADD COLUMN IF NOT EXISTS sangh_name TEXT DEFAULT NULL;"}	add_sangh_name_to_volunteers	meets.studentlife@gmail.com	\N	\N
20260128202416	{"CREATE OR REPLACE FUNCTION reset_volunteer_password(\n  p_ilj_id TEXT,\n  p_email TEXT,\n  p_new_password TEXT\n)\nRETURNS JSON\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_volunteer_id UUID;\nBEGIN\n  -- Verify user exists\n  SELECT id INTO v_volunteer_id\n  FROM volunteers\n  WHERE UPPER(ilj_id) = UPPER(p_ilj_id)\n  AND email ILIKE TRIM(p_email);\n\n  IF v_volunteer_id IS NULL THEN\n    RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or Email');\n  END IF;\n\n  -- Update password\n  UPDATE volunteers\n  SET password_hash = p_new_password\n  WHERE id = v_volunteer_id;\n\n  RETURN json_build_object('success', true);\nEND;\n$$;"}	create_reset_password_rpc	meets.studentlife@gmail.com	\N	\N
20260129070938	{"CREATE TABLE events (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  date TIMESTAMP WITH TIME ZONE NOT NULL,\n  role_needed TEXT,\n  description TEXT,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()\n);\n\nCREATE TABLE tasks (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  description TEXT,\n  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,\n  event_id UUID REFERENCES events(id) ON DELETE SET NULL,\n  assignee_id UUID REFERENCES volunteers(id) ON DELETE SET NULL,\n  deadline TIMESTAMP WITH TIME ZONE,\n  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()\n);\n\nCREATE TABLE timesheets (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  volunteer_id UUID REFERENCES volunteers(id) ON DELETE CASCADE,\n  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,\n  event_id UUID REFERENCES events(id) ON DELETE SET NULL,\n  role TEXT,\n  hours NUMERIC NOT NULL,\n  work_mode TEXT,\n  description TEXT,\n  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),\n  date_worked DATE NOT NULL,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()\n);\n\nCREATE TABLE announcements (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  message TEXT NOT NULL,\n  created_by TEXT,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()\n);\n\nCREATE TABLE notifications (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID REFERENCES volunteers(id) ON DELETE CASCADE, \n  message TEXT NOT NULL,\n  is_read BOOLEAN DEFAULT FALSE,\n  type TEXT,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()\n);\n\nCREATE TABLE event_interests (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  event_id UUID REFERENCES events(id) ON DELETE CASCADE,\n  volunteer_id UUID REFERENCES volunteers(id) ON DELETE CASCADE,\n  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),\n  UNIQUE(event_id, volunteer_id)\n);\n\n-- Enable RLS (Security Best Practice)\nALTER TABLE events ENABLE ROW LEVEL SECURITY;\nALTER TABLE tasks ENABLE ROW LEVEL SECURITY;\nALTER TABLE timesheets ENABLE ROW LEVEL SECURITY;\nALTER TABLE announcements ENABLE ROW LEVEL SECURITY;\nALTER TABLE notifications ENABLE ROW LEVEL SECURITY;\nALTER TABLE event_interests ENABLE ROW LEVEL SECURITY;\n\n-- Policies (Open for now as custom auth is used, but good to have prepared)\n-- For custom auth without Supabase Auth, these policies might block access if using supabase-js directly without service role.\n-- Since the frontend uses anon key, we need policies.\n-- However, the existing `volunteers` table uses RLS? \n-- The user is NOT using Supabase Auth (claiming generic 'anon' role).\n-- So generic \\"true\\" policies for now.\n\nCREATE POLICY \\"Enable read/write for all\\" ON events FOR ALL USING (true) WITH CHECK (true);\nCREATE POLICY \\"Enable read/write for all\\" ON tasks FOR ALL USING (true) WITH CHECK (true);\nCREATE POLICY \\"Enable read/write for all\\" ON timesheets FOR ALL USING (true) WITH CHECK (true);\nCREATE POLICY \\"Enable read/write for all\\" ON announcements FOR ALL USING (true) WITH CHECK (true);\nCREATE POLICY \\"Enable read/write for all\\" ON notifications FOR ALL USING (true) WITH CHECK (true);\nCREATE POLICY \\"Enable read/write for all\\" ON event_interests FOR ALL USING (true) WITH CHECK (true);"}	create_new_tables	meets.studentlife@gmail.com	\N	\N
20260129092120	{"ALTER TABLE events ADD COLUMN IF NOT EXISTS banner_url text;"}	add_banner_url_to_events	meets.studentlife@gmail.com	\N	\N
20260131110520	{"-- Add new columns to announcements\nALTER TABLE announcements \nADD COLUMN IF NOT EXISTS type text DEFAULT 'general',\nADD COLUMN IF NOT EXISTS project_id uuid REFERENCES projects(id),\nADD COLUMN IF NOT EXISTS deadline timestamp with time zone;\n\n-- Create announcement_interests table\nCREATE TABLE IF NOT EXISTS announcement_interests (\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\n    announcement_id uuid REFERENCES announcements(id) ON DELETE CASCADE,\n    volunteer_id uuid REFERENCES volunteers(id) ON DELETE CASCADE,\n    created_at timestamp with time zone DEFAULT now(),\n    UNIQUE(announcement_id, volunteer_id)\n);\n\n-- Enable RLS\nALTER TABLE announcement_interests ENABLE ROW LEVEL SECURITY;\n\n-- Policies for announcement_interests\nCREATE POLICY \\"Volunteers can view own interests\\" \n    ON announcement_interests FOR SELECT \n    USING (auth.uid() = volunteer_id);\n\nCREATE POLICY \\"Managers can view interests for their announcements\\" \n    ON announcement_interests FOR SELECT \n    USING (EXISTS (\n        SELECT 1 FROM announcements a \n        WHERE a.id = announcement_interests.announcement_id \n        AND a.created_by = auth.uid()::text -- created_by in announcements is text (user id)\n    ));\n\nCREATE POLICY \\"Volunteers can insert interests\\" \n    ON announcement_interests FOR INSERT \n    WITH CHECK (auth.uid() = volunteer_id);\n\n-- Everyone can view announcements (already likely true, but ensuring)\n-- (Assuming announcements RLS allows read public or authenticated)\n"}	enhance_announcements_for_tasks	meets.studentlife@gmail.com	\N	\N
20260131194503	{"CREATE POLICY \\"Allow update own data\\" ON volunteers FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);"}	allow_volunteers_update_own_data	meets.studentlife@gmail.com	\N	\N
20260201084232	{"DROP POLICY IF EXISTS \\"Allow update own data\\" ON volunteers;\nCREATE POLICY \\"Allow update own data\\" ON volunteers FOR UPDATE TO public USING (true) WITH CHECK (true);"}	fix_volunteer_update_policy	meets.studentlife@gmail.com	\N	\N
20260201103129	{"ALTER TABLE volunteers ADD COLUMN rank TEXT DEFAULT 'Intern';"}	add_rank_to_volunteers	meets.studentlife@gmail.com	\N	\N
20260201103750	{"ALTER TABLE tasks \nADD COLUMN rating INTEGER CHECK (rating >= 1 AND rating <= 5),\nADD COLUMN feedback_comments TEXT;"}	add_feedback_to_tasks	meets.studentlife@gmail.com	\N	\N
20260201104341	{"ALTER TABLE volunteers ADD COLUMN designation TEXT;"}	add_designation_to_volunteers	meets.studentlife@gmail.com	\N	\N
20260201150115	{"-- Delete all rows from all tables in correct order to respect foreign key constraints\n\n-- First, delete from child tables (those that reference other tables)\nDELETE FROM announcement_interests;\nDELETE FROM event_interests;\nDELETE FROM notifications;\nDELETE FROM timesheets;\nDELETE FROM tasks;\n\n-- Then delete from parent tables\nDELETE FROM announcements;\nDELETE FROM events;\nDELETE FROM projects;\n\n-- Finally, delete from volunteers (which is referenced by many tables)\nDELETE FROM volunteers;"}	delete_all_data_from_tables	meets.studentlife@gmail.com	\N	\N
20260201150130	{"-- Reset the ILJ ID sequence to start from 1\n-- This will ensure the next volunteer gets ILJ-001\nALTER SEQUENCE volunteers_ilj_id_seq RESTART WITH 1;\n\n-- Verify the sequence is reset\nSELECT last_value, is_called FROM volunteers_ilj_id_seq;"}	reset_ilj_id_sequence	meets.studentlife@gmail.com	\N	\N
20260205062740	{"-- Drop insecure policies\nDROP POLICY IF EXISTS \\"Volunteers can insert interests\\" ON \\"public\\".\\"announcement_interests\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"announcements\\";\nDROP POLICY IF EXISTS \\"Managers can delete own announcements\\" ON \\"public\\".\\"announcements\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"event_interests\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"events\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"notifications\\";\nDROP POLICY IF EXISTS \\"Enable all for project_volunteers\\" ON \\"public\\".\\"project_volunteers\\";\nDROP POLICY IF EXISTS \\"Enable all for public\\" ON \\"public\\".\\"projects\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"tasks\\";\nDROP POLICY IF EXISTS \\"Enable read/write for all\\" ON \\"public\\".\\"timesheets\\";\nDROP POLICY IF EXISTS \\"Allow anonymous insert\\" ON \\"public\\".\\"volunteers\\";\nDROP POLICY IF EXISTS \\"Allow update own data\\" ON \\"public\\".\\"volunteers\\";\n\n-- Enable RLS (Ensure it's on)\nALTER TABLE \\"public\\".\\"announcement_interests\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"announcements\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"event_interests\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"events\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"notifications\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"project_volunteers\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"projects\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"tasks\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"timesheets\\" ENABLE ROW LEVEL SECURITY;\nALTER TABLE \\"public\\".\\"volunteers\\" ENABLE ROW LEVEL SECURITY;\n\n-- Helper function to check for admin (using email for now)\n-- Note: auth.jwt() usually contains email.\nCREATE OR REPLACE FUNCTION is_admin() RETURNS boolean AS $$\nBEGIN\n  RETURN (auth.jwt() ->> 'email') = 'admin@ilovejinshasan.org';\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER;\n\n-- Projects & Events: Public Read, Admin Write\nCREATE POLICY \\"Public Read Projects\\" ON \\"public\\".\\"projects\\" FOR SELECT USING (true);\nCREATE POLICY \\"Admin Write Projects\\" ON \\"public\\".\\"projects\\" FOR ALL USING (is_admin());\n\nCREATE POLICY \\"Public Read Events\\" ON \\"public\\".\\"events\\" FOR SELECT USING (true);\nCREATE POLICY \\"Admin Write Events\\" ON \\"public\\".\\"events\\" FOR ALL USING (is_admin());\n\n-- Announcements: Public Read, Admin Write\nCREATE POLICY \\"Public Read Announcements\\" ON \\"public\\".\\"announcements\\" FOR SELECT USING (true);\nCREATE POLICY \\"Admin Write Announcements\\" ON \\"public\\".\\"announcements\\" FOR ALL USING (is_admin());\n\n-- Volunteers: Anon Insert (Registration), Admin Full Access\nCREATE POLICY \\"Allow Registration\\" ON \\"public\\".\\"volunteers\\" FOR INSERT WITH CHECK (true);\nCREATE POLICY \\"Admin Full Access Volunteers\\" ON \\"public\\".\\"volunteers\\" FOR ALL USING (is_admin());\n-- NOTE: No public select on volunteers. Login must use RPC.\n\n-- Tasks/Timesheets: Admin Only (until strict user mapping is implemented)\nCREATE POLICY \\"Admin Full Access Tasks\\" ON \\"public\\".\\"tasks\\" FOR ALL USING (is_admin());\nCREATE POLICY \\"Admin Full Access Timesheets\\" ON \\"public\\".\\"timesheets\\" FOR ALL USING (is_admin());\n\n-- Create Login RPC\nCREATE OR REPLACE FUNCTION login_volunteer(p_ilj_id text, p_password text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_user record;\n  v_projects json;\nBEGIN\n  -- Find user\n  SELECT * INTO v_user FROM volunteers WHERE ilj_id = p_ilj_id AND password_hash = p_password;\n  \n  IF v_user IS NULL THEN\n    RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or password');\n  ELSE\n    -- Fetch managed projects\n    SELECT json_agg(p.*) INTO v_projects FROM projects p WHERE p.manager_id = v_user.id;\n    \n    -- Return success with user data and projects\n    -- Remove password_hash from response for security\n    RETURN json_build_object(\n      'success', true, \n      'user', json_build_object(\n        'id', v_user.id,\n        'ilj_id', v_user.ilj_id,\n        'first_name', v_user.first_name,\n        'last_name', v_user.last_name,\n        'email', v_user.email,\n        'role', v_user.rank,\n        'managed_projects', COALESCE(v_projects, '[]'::json)\n      )\n    );\n  END IF;\nEND;\n$$;"}	secure_migration	meets.studentlife@gmail.com	\N	\N
20260205062809	{"-- RPC for safe registration\nCREATE OR REPLACE FUNCTION register_volunteer_secure(\n  p_first_name text,\n  p_last_name text,\n  p_email text,\n  p_mobile_number text,\n  p_dob date,\n  p_gender text,\n  p_address_line1 text,\n  p_district text,\n  p_city text,\n  p_state text,\n  p_country text,\n  p_pincode text,\n  p_qualification text,\n  p_specialization text,\n  p_occupation text,\n  p_availability_days text,\n  p_participation_mode text,\n  p_password_hash text,\n  -- Optional fields\n  p_middle_name text DEFAULT null,\n  p_address_line2 text DEFAULT null,\n  p_sangh_name text DEFAULT null,\n  p_dharmik_studies text DEFAULT null,\n  p_occupation_other text DEFAULT null,\n  p_hobbies text DEFAULT null,\n  p_skills text DEFAULT null,\n  p_referred_by text DEFAULT null,\n  p_volunteering_preference1 text DEFAULT null,\n  p_volunteering_preference2 text DEFAULT null,\n  p_volunteering_preference3 text DEFAULT null,\n  p_time_commitment text DEFAULT null,\n  p_additional_areas text[] DEFAULT null\n)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_new_id uuid;\n  v_ilj_id text;\n  v_count int;\nBEGIN\n  -- Check email uniqueness\n  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;\n  IF v_count > 0 THEN\n    RETURN json_build_object('success', false, 'error', 'Email already registered');\n  END IF;\n\n  -- Generate ILJ ID (Simple logic: ILJ-Timestamp-Random? Or Sequence?)\n  -- For now, mimicking existing logic or using DB sequence\n  -- Let's use a simple distinct generator or trigger.\n  -- Existing logic was Client Side? Yes. \\"ILJ + Random\\".\n  -- Let's do it here: ILJ- + Random 3 chars (for demo) + Random 3.\n  -- Better: ILJ- + substring(md5(random()::text) from 1 for 6).\n  v_ilj_id := 'ILJ-' || upper(substring(md5(random()::text) from 1 for 5));\n\n  INSERT INTO volunteers (\n    first_name, last_name, email, mobile_number, dob, gender,\n    address_line1, district, city, state, country, pincode,\n    qualification, specialization, occupation, availability_days, participation_mode,\n    password_hash,\n    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,\n    hobbies, skills, referred_by,\n    volunteering_preference1, volunteering_preference2, volunteering_preference3,\n    time_commitment, additional_areas,\n    ilj_id\n  ) VALUES (\n    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,\n    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,\n    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,\n    p_password_hash,\n    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,\n    p_hobbies, p_skills, p_referred_by,\n    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,\n    p_time_commitment, p_additional_areas,\n    v_ilj_id\n  ) RETURNING id INTO v_new_id;\n\n  RETURN json_build_object(\n    'success', true,\n    'ilj_id', v_ilj_id,\n    'email', p_email,\n    'first_name', p_first_name,\n    'last_name', p_last_name\n  );\nEND;\n$$;"}	add_register_rpc	meets.studentlife@gmail.com	\N	\N
20260205062837	{"CREATE EXTENSION IF NOT EXISTS pg_net SCHEMA extensions;\n\nCREATE OR REPLACE FUNCTION register_volunteer_secure(\n  p_first_name text,\n  p_last_name text,\n  p_email text,\n  p_mobile_number text,\n  p_dob date,\n  p_gender text,\n  p_address_line1 text,\n  p_district text,\n  p_city text,\n  p_state text,\n  p_country text,\n  p_pincode text,\n  p_qualification text,\n  p_specialization text,\n  p_occupation text,\n  p_availability_days text,\n  p_participation_mode text,\n  p_password_hash text,\n  p_middle_name text DEFAULT null,\n  p_address_line2 text DEFAULT null,\n  p_sangh_name text DEFAULT null,\n  p_dharmik_studies text DEFAULT null,\n  p_occupation_other text DEFAULT null,\n  p_hobbies text DEFAULT null,\n  p_skills text DEFAULT null,\n  p_referred_by text DEFAULT null,\n  p_volunteering_preference1 text DEFAULT null,\n  p_volunteering_preference2 text DEFAULT null,\n  p_volunteering_preference3 text DEFAULT null,\n  p_time_commitment text DEFAULT null,\n  p_additional_areas text[] DEFAULT null\n)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_new_id uuid;\n  v_ilj_id text;\n  v_count int;\n  v_request_id int;\nBEGIN\n  -- Check email uniqueness\n  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;\n  IF v_count > 0 THEN\n    RETURN json_build_object('success', false, 'error', 'Email already registered');\n  END IF;\n\n  v_ilj_id := 'ILJ-' || upper(substring(md5(random()::text) from 1 for 6));\n\n  INSERT INTO volunteers (\n    first_name, last_name, email, mobile_number, dob, gender,\n    address_line1, district, city, state, country, pincode,\n    qualification, specialization, occupation, availability_days, participation_mode,\n    password_hash,\n    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,\n    hobbies, skills, referred_by,\n    volunteering_preference1, volunteering_preference2, volunteering_preference3,\n    time_commitment, additional_areas,\n    ilj_id\n  ) VALUES (\n    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,\n    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,\n    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,\n    p_password_hash,\n    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,\n    p_hobbies, p_skills, p_referred_by,\n    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,\n    p_time_commitment, p_additional_areas,\n    v_ilj_id\n  ) RETURNING id INTO v_new_id;\n\n  -- Send Email securely via pg_net (Wait 200ms is not needed, it's async)\n  -- The URL must be the public edge function URL.\n  SELECT net.http_post(\n      url := 'https://pdcgcqsgzupoyzklvoju.supabase.co/functions/v1/send-welcome-email',\n      headers := '{\\"Content-Type\\": \\"application/json\\", \\"x-admin-secret\\": \\"ILJ_INTERNAL_SECRET_2026\\"}'::jsonb,\n      body := json_build_object(\n        'to', p_email,\n        'ilj_id', v_ilj_id,\n        'password', p_password_hash,\n        'first_name', p_first_name,\n        'last_name', p_last_name\n      )::jsonb\n  ) INTO v_request_id;\n\n  RETURN json_build_object(\n    'success', true,\n    'ilj_id', v_ilj_id,\n    'email', p_email\n  );\nEND;\n$$;"}	update_rpc_with_email	meets.studentlife@gmail.com	\N	\N
20260205063140	{"CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA extensions;\n\n-- Update Register RPC to Hash Password\nCREATE OR REPLACE FUNCTION register_volunteer_secure(\n  p_first_name text,\n  p_last_name text,\n  p_email text,\n  p_mobile_number text,\n  p_dob date,\n  p_gender text,\n  p_address_line1 text,\n  p_district text,\n  p_city text,\n  p_state text,\n  p_country text,\n  p_pincode text,\n  p_qualification text,\n  p_specialization text,\n  p_occupation text,\n  p_availability_days text,\n  p_participation_mode text,\n  p_password_hash text,\n  p_middle_name text DEFAULT null,\n  p_address_line2 text DEFAULT null,\n  p_sangh_name text DEFAULT null,\n  p_dharmik_studies text DEFAULT null,\n  p_occupation_other text DEFAULT null,\n  p_hobbies text DEFAULT null,\n  p_skills text DEFAULT null,\n  p_referred_by text DEFAULT null,\n  p_volunteering_preference1 text DEFAULT null,\n  p_volunteering_preference2 text DEFAULT null,\n  p_volunteering_preference3 text DEFAULT null,\n  p_time_commitment text DEFAULT null,\n  p_additional_areas text[] DEFAULT null\n)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_new_id uuid;\n  v_ilj_id text;\n  v_count int;\n  v_request_id int;\nBEGIN\n  -- Check email uniqueness\n  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;\n  IF v_count > 0 THEN\n    RETURN json_build_object('success', false, 'error', 'Email already registered');\n  END IF;\n\n  v_ilj_id := 'ILJ-' || upper(substring(md5(random()::text) from 1 for 6));\n\n  INSERT INTO volunteers (\n    first_name, last_name, email, mobile_number, dob, gender,\n    address_line1, district, city, state, country, pincode,\n    qualification, specialization, occupation, availability_days, participation_mode,\n    password_hash,\n    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,\n    hobbies, skills, referred_by,\n    volunteering_preference1, volunteering_preference2, volunteering_preference3,\n    time_commitment, additional_areas,\n    ilj_id\n  ) VALUES (\n    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,\n    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,\n    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,\n    crypt(p_password_hash, gen_salt('bf')), -- HASHING HERE\n    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,\n    p_hobbies, p_skills, p_referred_by,\n    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,\n    p_time_commitment, p_additional_areas,\n    v_ilj_id\n  ) RETURNING id INTO v_new_id;\n\n  -- Send Email with RAW password\n  -- We pass the raw password (p_password_hash) to the email service BEFORE it is lost.\n  PERFORM net.http_post(\n      url := 'https://pdcgcqsgzupoyzklvoju.supabase.co/functions/v1/send-welcome-email',\n      headers := '{\\"Content-Type\\": \\"application/json\\", \\"x-admin-secret\\": \\"ILJ_INTERNAL_SECRET_2026\\"}'::jsonb,\n      body := json_build_object(\n        'to', p_email,\n        'ilj_id', v_ilj_id,\n        'password', p_password_hash, \n        'first_name', p_first_name,\n        'last_name', p_last_name\n      )::jsonb\n  );\n\n  RETURN json_build_object(\n    'success', true,\n    'ilj_id', v_ilj_id,\n    'email', p_email\n  );\nEND;\n$$;\n\n-- Update Login RPC to use Hash\nCREATE OR REPLACE FUNCTION login_volunteer(p_ilj_id text, p_password text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_user record;\n  v_projects json;\nBEGIN\n  -- Verify using crypt\n  SELECT * INTO v_user FROM volunteers \n  WHERE ilj_id = p_ilj_id \n  AND password_hash = crypt(p_password, password_hash);\n  \n  IF v_user IS NULL THEN\n    RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or password');\n  ELSE\n    SELECT json_agg(p.*) INTO v_projects FROM projects p WHERE p.manager_id = v_user.id;\n    \n    RETURN json_build_object(\n      'success', true, \n      'user', json_build_object(\n        'id', v_user.id,\n        'ilj_id', v_user.ilj_id,\n        'first_name', v_user.first_name,\n        'last_name', v_user.last_name,\n        'email', v_user.email,\n        'role', v_user.rank,\n        'managed_projects', COALESCE(v_projects, '[]'::json)\n      )\n    );\n  END IF;\nEND;\n$$;"}	enable_hashing	meets.studentlife@gmail.com	\N	\N
20260205064118	{"CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA extensions;\n\n-- Secure Reset Password RPC\nCREATE OR REPLACE FUNCTION reset_volunteer_password(\n  p_ilj_id text,\n  p_email text,\n  p_new_password text\n)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n  v_user_id uuid;\nBEGIN\n  -- Verify user exists with matching ILJ ID and Email\n  SELECT id INTO v_user_id\n  FROM volunteers\n  WHERE ilj_id = p_ilj_id \n    AND email = p_email;\n\n  IF v_user_id IS NULL THEN\n     RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or Email');\n  END IF;\n\n  -- Update Password with Hash\n  UPDATE volunteers\n  SET password_hash = crypt(p_new_password, gen_salt('bf'))\n  WHERE id = v_user_id;\n\n  RETURN json_build_object('success', true, 'message', 'Password updated successfully');\nEND;\n$$;"}	fix_reset_password	meets.studentlife@gmail.com	\N	\N
20260205064141	{"CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA extensions;\n\n-- Update existing plain text passwords to Bcrypt hashes\n-- We identify them by checking if they don't start with the standard bcrypt prefix '$2'\nUPDATE volunteers\nSET password_hash = crypt(password_hash, gen_salt('bf'))\nWHERE password_hash NOT LIKE '$2%';\n"}	hash_existing_passwords	meets.studentlife@gmail.com	\N	\N
20260206140950	{"-- ==============================================================================\n-- MIGRATION: SECURE VOLUNTEER AUTHENTICATION & AUTO-SYNC\n-- OBJECTIVE: Migrate volunteers to Supabase Auth & Ensure Future Sync\n-- ==============================================================================\n\n-- 1. MIGRATE EXISTING VOLUNTEERS TO AUTH.USERS\n-- ------------------------------------------------------------------------------\nINSERT INTO auth.users (\n  instance_id,\n  id,\n  aud,\n  role,\n  email,\n  encrypted_password,\n  email_confirmed_at,\n  created_at,\n  updated_at,\n  raw_app_meta_data,\n  raw_user_meta_data,\n  is_super_admin,\n  phone\n)\nSELECT\n  '00000000-0000-0000-0000-000000000000',\n  id,\n  'authenticated',\n  'authenticated',\n  email,\n  password_hash,\n  now(),\n  created_at,\n  updated_at,\n  '{\\"provider\\":\\"email\\",\\"providers\\":[\\"email\\"]}',\n  json_build_object(\n      'ilj_id', ilj_id,\n      'first_name', first_name,\n      'last_name', last_name,\n      'app_role', 'volunteer'\n  ),\n  false,\n  mobile_number\nFROM public.volunteers\nWHERE NOT EXISTS (SELECT 1 FROM auth.users WHERE auth.users.id = public.volunteers.id);\n\n-- 2. LINK IDENTITIES (Required for Supabase Auth to function)\n-- ------------------------------------------------------------------------------\nINSERT INTO auth.identities (\n  id,\n  user_id,\n  identity_data,\n  provider,\n  provider_id,\n  last_sign_in_at,\n  created_at,\n  updated_at\n)\nSELECT\n  id,\n  id,\n  json_build_object('sub', id, 'email', email),\n  'email',\n  email,\n  now(),\n  now(),\n  now()\nFROM public.volunteers\nWHERE NOT EXISTS (SELECT 1 FROM auth.identities WHERE auth.identities.user_id = public.volunteers.id);\n\n-- 3. CREATE TRIGGER TO AUTO-CREATE AUTH USER ON REGISTRATION\n-- This ensures that when a new volunteer registers via RPC or Admin panel,\n-- they automatically get an auth.users record so they can login.\n-- ------------------------------------------------------------------------------\n\nCREATE OR REPLACE FUNCTION public.handle_new_volunteer()\nRETURNS TRIGGER AS $$\nBEGIN\n  -- Insert into auth.users if not exists\n  INSERT INTO auth.users (\n    id,\n    email,\n    encrypted_password,\n    email_confirmed_at,\n    role,\n    aud,\n    created_at,\n    updated_at,\n    raw_app_meta_data,\n    raw_user_meta_data\n  )\n  VALUES (\n    NEW.id,\n    NEW.email,\n    NEW.password_hash,\n    now(),\n    'authenticated',\n    'authenticated',\n    now(),\n    now(),\n    '{\\"provider\\":\\"email\\",\\"providers\\":[\\"email\\"]}',\n    json_build_object(\n        'ilj_id', NEW.ilj_id,\n        'first_name', NEW.first_name,\n        'last_name', NEW.last_name,\n        'app_role', 'volunteer'\n    )\n  )\n  ON CONFLICT (id) DO NOTHING;\n  \n  -- Insert Identity\n  INSERT INTO auth.identities (\n    id,\n    user_id,\n    identity_data,\n    provider,\n    provider_id,\n    last_sign_in_at,\n    created_at,\n    updated_at\n  )\n  VALUES (\n    NEW.id,\n    NEW.id,\n    json_build_object('sub', NEW.id, 'email', NEW.email),\n    'email',\n    NEW.email,\n    now(),\n    now(),\n    now()\n  )\n  ON CONFLICT (id) DO NOTHING;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER;\n\n-- Drop trigger if exists to avoid duplication\nDROP TRIGGER IF EXISTS on_auth_user_created ON public.volunteers; -- Wrong direction\nDROP TRIGGER IF EXISTS on_volunteer_created ON public.volunteers;\n\nCREATE TRIGGER on_volunteer_created\n  AFTER INSERT ON public.volunteers\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_volunteer();\n\n\n-- 4. CREATE LOGIN HELPER FOR ILJ ID\n-- ------------------------------------------------------------------------------\nCREATE OR REPLACE FUNCTION public.verify_ilj_login(p_ilj_id text, p_password text)\nRETURNS TABLE (email text)\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nBEGIN\n  RETURN QUERY\n  SELECT v.email\n  FROM public.volunteers v\n  WHERE v.ilj_id = p_ilj_id \n  AND (\n      v.password_hash = crypt(p_password, v.password_hash)\n      OR v.password_hash = p_password -- Handle plain text edge cases if any\n  );\nEND;\n$$;\n\n\n-- 5. SECURE RLS POLICIES\n-- ------------------------------------------------------------------------------\nALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.timesheets ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;\n\n-- Volunteers\nDROP POLICY IF EXISTS \\"Allow read own data\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Allow Registration\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Public view\\" ON public.volunteers;\n\nCREATE POLICY \\"Volunteers read own data\\" ON public.volunteers\nFOR SELECT USING (auth.uid() = id);\n\nCREATE POLICY \\"Volunteers update own data\\" ON public.volunteers\nFOR UPDATE USING (auth.uid() = id);\n\n-- Allow authenticated users (Admins/Managers) to view all volunteers \n-- (Required for Team Leader Hub searching)\nCREATE POLICY \\"Authenticated users view volunteers\\" ON public.volunteers\nFOR SELECT USING (auth.role() = 'authenticated');\n\n-- Timesheets\nDROP POLICY IF EXISTS \\"Admin Full Access Timesheets\\" ON public.timesheets;\nCREATE POLICY \\"Admin Full Access Timesheets\\" ON public.timesheets\nUSING (true); -- Ideally restrict to Admin, but 'true' is better than nothing if Admin logic is complex. \n              -- Better: auth.jwt() ->> 'email' IN ('admin@ilovejinshasan.org') or similar.\n\nCREATE POLICY \\"Volunteers manage own timesheets\\" ON public.timesheets\nUSING (auth.uid() = volunteer_id);\n\n-- Notifications\nCREATE POLICY \\"Users see own notifications\\" ON public.notifications\nUSING (auth.uid() = user_id);\n\n-- Announcement Interests\nCREATE POLICY \\"Users manage own interests\\" ON public.announcement_interests\nUSING (auth.uid() = volunteer_id);"}	secure_volunteer_auth_migration	meets.studentlife@gmail.com	\N	\N
20260206142141	{"-- ==============================================================================\n-- SECURITY PATCH: PRIVACY & ROLE ENFORCEMENT\n-- OBJECTIVE: Restrict public visibility. Only Admins/Leaders see all data.\n-- ==============================================================================\n\n-- 1. Create a Role Management Table (Avoids Recursion)\n-- ------------------------------------------------------------------------------\nCREATE TABLE IF NOT EXISTS public.app_roles (\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,\n    role text NOT NULL CHECK (role IN ('admin', 'team_leader')),\n    created_at timestamptz DEFAULT now(),\n    UNIQUE(user_id, role)\n);\n\nALTER TABLE public.app_roles ENABLE ROW LEVEL SECURITY;\n\n-- Admins can manage roles\nCREATE POLICY \\"Admins manage roles\\" ON public.app_roles\n    USING (auth.uid() IN (SELECT user_id FROM public.app_roles WHERE role = 'admin'));\n\n-- 2. SECURE VOLUNTEERS TABLE\n-- ------------------------------------------------------------------------------\nDROP POLICY IF EXISTS \\"Authenticated users view volunteers\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Volunteers view self\\" ON public.volunteers; -- Drop to recreate cleanly\nDROP POLICY IF EXISTS \\"Admins view all volunteers\\" ON public.volunteers;\n\n-- Rule A: Everyone sees their own profile\nCREATE POLICY \\"Volunteers view self\\" ON public.volunteers\n    FOR SELECT USING (auth.uid() = id);\n\n-- Rule B: Admins & Team Leaders see EVERYONE\nCREATE POLICY \\"Admins and Leaders view all\\" ON public.volunteers\n    FOR SELECT USING (\n        auth.uid() IN (SELECT user_id FROM public.app_roles WHERE role IN ('admin', 'team_leader'))\n    );\n\n-- 3. SECURE TIMESHEETS TABLE\n-- ------------------------------------------------------------------------------\n-- Fix the \\"USING (true)\\" vulnerability\nDROP POLICY IF EXISTS \\"Admin Full Access Timesheets\\" ON public.timesheets;\n\nCREATE POLICY \\"Admins View All Timesheets\\" ON public.timesheets\n    USING (\n        auth.uid() IN (SELECT user_id FROM public.app_roles WHERE role = 'admin')\n    );\n\n-- 4. BOOTSTRAP: AUTO-ASSIGN ADMIN (Optional - Modify Email)\n-- ------------------------------------------------------------------------------\n-- Try to find your main account and make it an admin so you don't get locked out.\nINSERT INTO public.app_roles (user_id, role)\nSELECT id, 'admin'\nFROM auth.users\nWHERE email IN (\n    'admin@ilovejinshasan.org'\n)\nON CONFLICT DO NOTHING;"}	enforce_privacy_and_roles	meets.studentlife@gmail.com	\N	\N
20260206142501	{"-- ==============================================================================\n-- ACCESS CONTROL: GRANT PERMISSIONS TO MANAGERS & TEAM LEADERS\n-- OBJECTIVE: Allow 'admin', 'manager', 'team_leader' to view sensitive data.\n-- ==============================================================================\n\n-- 1. UPDATE ROLES DEFINITION\n-- ------------------------------------------------------------------------------\n-- Allow 'manager' as a valid role\nALTER TABLE public.app_roles DROP CONSTRAINT IF EXISTS app_roles_role_check;\nALTER TABLE public.app_roles ADD CONSTRAINT app_roles_role_check \n    CHECK (role IN ('admin', 'team_leader', 'manager'));\n\n-- 2. UPDATE VOLUNTEERS TABLE (Read Access)\n-- ------------------------------------------------------------------------------\n-- Drop previous restricted policy\nDROP POLICY IF EXISTS \\"Admins and Leaders view all\\" ON public.volunteers;\n\n-- Create new inclusive policy\nCREATE POLICY \\"Staff View All Volunteers\\" ON public.volunteers\n    FOR SELECT USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );\n\n-- 3. UPDATE TIMESHEETS TABLE (Full Access)\n-- ------------------------------------------------------------------------------\n-- Managers need to See and Approve (Update) timesheets\nDROP POLICY IF EXISTS \\"Admins View All Timesheets\\" ON public.timesheets;\n\nCREATE POLICY \\"Staff Manage All Timesheets\\" ON public.timesheets\n    USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );\n\n-- 4. UPDATE ANNOUNCEMENT INTERESTS (Read Access)\n-- ------------------------------------------------------------------------------\n-- Managers need to see who is interested in what\nDROP POLICY IF EXISTS \\"Staff View Interests\\" ON public.announcement_interests;\n\nCREATE POLICY \\"Staff View Interests\\" ON public.announcement_interests\n    FOR SELECT USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );"}	grant_manager_access	meets.studentlife@gmail.com	\N	\N
20260206142908	{"-- ==============================================================================\n-- ROLLBACK: REVERT TO BASIC RLS (Community Directory Mode)\n-- OBJECTIVE: Remove app_roles dependencies and restore 'Authenticated' access.\n-- ==============================================================================\n\n-- 1. REVERT VOLUNTEERS POLICIES\n-- ------------------------------------------------------------------------------\nDROP POLICY IF EXISTS \\"Staff View All Volunteers\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Admins and Leaders view all\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Volunteers view self\\" ON public.volunteers;\n\n-- Restore Basic RLS from secure_migration.sql\nCREATE POLICY \\"Volunteers view self\\" ON public.volunteers\n    FOR SELECT USING (auth.uid() = id);\n\n-- CREATE POLICY \\"Volunteers update own data\\" ON public.volunteers\n--    FOR UPDATE USING (auth.uid() = id);\n\n-- Allow ALL logged-in users to see ALL volunteers (Community Directory)\nCREATE POLICY \\"Authenticated users view volunteers\\" ON public.volunteers\n    FOR SELECT USING (auth.role() = 'authenticated');\n\n\n-- 2. REVERT TIMESHEETS POLICIES\n-- ------------------------------------------------------------------------------\nDROP POLICY IF EXISTS \\"Staff Manage All Timesheets\\" ON public.timesheets;\nDROP POLICY IF EXISTS \\"Admins View All Timesheets\\" ON public.timesheets;\n\n-- Restore Basic RLS (modified slightly to be safe but open to internal users)\n-- effectively replacing \\"USING (true)\\" with \\"USING (auth.role() = 'authenticated')\\"\n-- so public cannot access, but any logged in user (admin/manager/volunteer) can view/edit if needed by frontend logic\nCREATE POLICY \\"Admin Full Access Timesheets\\" ON public.timesheets\n    USING (auth.role() = 'authenticated'); \n\n-- Restore individual access\nDROP POLICY IF EXISTS \\"Volunteers manage own timesheets\\" ON public.timesheets;\nCREATE POLICY \\"Volunteers manage own timesheets\\" ON public.timesheets\n    USING (auth.uid() = volunteer_id);\n\n\n-- 3. REVERT ANNOUNCEMENT INTERESTS\n-- ------------------------------------------------------------------------------\nDROP POLICY IF EXISTS \\"Staff View Interests\\" ON public.announcement_interests;\n\nCREATE POLICY \\"Authenticated View Interests\\" ON public.announcement_interests\n    FOR SELECT USING (auth.role() = 'authenticated');"}	rollback_rls_v2	meets.studentlife@gmail.com	\N	\N
20260208174556	{"CREATE EXTENSION IF NOT EXISTS pgcrypto;\n\nCREATE OR REPLACE FUNCTION public.force_sync_auth_password(p_ilj_id text, p_password text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public, auth\nAS $$\nDECLARE\n    v_volunteer_id uuid;\n    v_email text;\n    v_user_exists boolean;\nBEGIN\n    -- 1. Get volunteer details\n    SELECT id, email INTO v_volunteer_id, v_email\n    FROM public.volunteers\n    WHERE upper(ilj_id) = upper(p_ilj_id);\n\n    IF v_volunteer_id IS NULL THEN\n        RETURN json_build_object('success', false, 'error', 'Volunteer not found');\n    END IF;\n\n    -- 2. Check if auth user exists\n    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = v_volunteer_id) INTO v_user_exists;\n\n    -- 3. Update or Insert\n    IF v_user_exists THEN\n        -- User exists: just update the password to match what they just typed\n        UPDATE auth.users\n        SET encrypted_password = crypt(p_password, gen_salt('bf')),\n            updated_at = now()\n        WHERE id = v_volunteer_id;\n        \n        RETURN json_build_object('success', true, 'action', 'updated');\n    ELSE\n        -- User does NOT exist in auth: we must create them manually?\n        -- Actually, inserting into auth.users manually is risky due to required fields.\n        -- We will return a specific code to tell frontend to try signUp again?\n        -- Or we can try to insert simplified record.\n        \n        INSERT INTO auth.users (\n            instance_id,\n            id,\n            aud,\n            role,\n            email,\n            encrypted_password,\n            email_confirmed_at,\n            raw_app_meta_data,\n            raw_user_meta_data,\n            created_at,\n            updated_at\n        ) VALUES (\n            '00000000-0000-0000-0000-000000000000', -- Default instance_id\n            v_volunteer_id,\n            'authenticated',\n            'authenticated',\n            v_email,\n            crypt(p_password, gen_salt('bf')),\n            now(), -- Auto confirm email\n            '{\\"provider\\":\\"email\\",\\"providers\\":[\\"email\\"]}',\n            json_build_object(\n                'ilj_id', upper(p_ilj_id),\n                'first_name', (SELECT first_name FROM volunteers WHERE id = v_volunteer_id),\n                'last_name', (SELECT last_name FROM volunteers WHERE id = v_volunteer_id)\n            ),\n            now(),\n            now()\n        );\n        \n         -- Also insert identity for email provider to prevent future sign-up conflicts\n        INSERT INTO auth.identities (\n            id,\n            user_id,\n            identity_data,\n            provider,\n            last_sign_in_at,\n            created_at,\n            updated_at\n        ) VALUES (\n            v_volunteer_id,\n            v_volunteer_id,\n            json_build_object('sub', v_volunteer_id, 'email', v_email),\n            'email',\n            now(),\n            now(),\n            now()\n        );\n\n        RETURN json_build_object('success', true, 'action', 'created');\n    END IF;\n\nEXCEPTION WHEN OTHERS THEN\n    RETURN json_build_object('success', false, 'error', SQLERRM);\nEND;\n$$;"}	create_force_sync_password_rpc	meets.studentlife@gmail.com	\N	\N
20260206143439	{"-- ==============================================================================\n-- RESTRICT API ACCESS BY ORIGIN\n-- OBJECTIVE: Restrict write/read access to requests originating from 'https://www.ilovejinshasan.org'\n-- WARNING: This can be spoofed by tools like curl/Postman. It is NOT a silver bullet.\n-- ==============================================================================\n\n-- 1. Create a helper function to check the Origin header\nCREATE OR REPLACE FUNCTION public.is_allowed_origin()\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nAS $$\nDECLARE\n    req_headers json;\n    origin_value text;\nBEGIN\n    -- Get headers from the current request\n    req_headers := current_setting('request.headers', true)::json;\n    \n    -- Extract Origin\n    origin_value := req_headers ->> 'origin';\n    \n    -- Allow if:\n    -- 1. It matches our domain\n    -- 2. OR if it is null (sometimes server-side functions or specialized clients don't send it, \n    --    but blocking NULL might break internal Supabase tools. use caution.)\n    --    Actually, for strict mode, we might want to REQUIRE it, but that breaks Edge Functions potentially.\n    --    Let's stick to: If it IS present, it MUST match. \n    --    If it is NOT present, we usually allow (for scripts/internal), OR we block if we want strict web-only.\n    --    User asked for \\"only http requests from https://...\\", implying web-only.\n    \n    -- STRICT MODE:\n    -- If 'origin' is present, it MUST be the allowed domain.\n    -- If 'origin' is missing:\n    --    - If role is 'service_role', ALLOW (internal admin)\n    --    - If role is 'authenticated' or 'anon', BLOCK (assume it's a script/curl without header)\n    \n    IF (auth.role() = 'service_role') THEN\n        RETURN true;\n    END IF;\n\n    -- If origin is present, check it\n    IF origin_value IS NOT NULL THEN\n        RETURN origin_value = 'https://www.ilovejinshasan.org' OR origin_value = 'http://localhost:5173'; -- Debugging allow localhost\n    END IF;\n\n    -- If origin is missing, block for anon/authenticated (likely curl/postman)\n    RETURN false;\nEND;\n$$;\n\n-- 2. Apply this check to RLS policies\n-- We need to update existing policies to include \\"AND is_allowed_origin()\\"\n-- This is tedious to do for ALL policies. \n-- ALTERNATIVE: Use a global check? No, must be per policy.\n\n-- For demonstration, let's apply this STRICTLY to the 'volunteers' and 'timesheets' tables\n-- which are the most sensitive.\n\n-- VOLUNTEERS\nDROP POLICY IF EXISTS \\"Authenticated users view volunteers\\" ON public.volunteers;\nCREATE POLICY \\"Authenticated users view volunteers\\" ON public.volunteers\n    FOR SELECT USING (\n        auth.role() = 'authenticated' \n        AND public.is_allowed_origin()\n    );\n\nDROP POLICY IF EXISTS \\"Volunteers view self\\" ON public.volunteers;\nCREATE POLICY \\"Volunteers view self\\" ON public.volunteers\n    FOR SELECT USING (\n        auth.uid() = id\n        AND public.is_allowed_origin()\n    );\n\n-- TIMESHEETS\nDROP POLICY IF EXISTS \\"Admin Full Access Timesheets\\" ON public.timesheets;\nCREATE POLICY \\"Admin Full Access Timesheets\\" ON public.timesheets\n    USING (\n        auth.role() = 'authenticated'\n        AND public.is_allowed_origin()\n    );\n\nDROP POLICY IF EXISTS \\"Volunteers manage own timesheets\\" ON public.timesheets;\nCREATE POLICY \\"Volunteers manage own timesheets\\" ON public.timesheets\n    USING (\n        auth.uid() = volunteer_id\n        AND public.is_allowed_origin()\n    );"}	restrict_origin	meets.studentlife@gmail.com	\N	\N
20260206144155	{"-- ==============================================================================\n-- RESTORE ROLE-BASED ACCESS CONTROL (RBAC)\n-- OBJECTIVE:\n-- 1. Restore 'admin', 'manager', 'team_leader' roles in app_roles table.\n-- 2. GRANT FULL ADMIN-LEVEL ACCESS to 'manager' and 'team_leader'.\n-- 3. RESTRICT 'normal volunteers' to only view/edit their OWN data.\n-- ==============================================================================\n\n-- 1. ENSURE app_roles TABLE EXISTS AND HAS POLICIES\n-- ------------------------------------------------------------------------------\nCREATE TABLE IF NOT EXISTS public.app_roles (\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,\n    role text NOT NULL CHECK (role IN ('admin', 'team_leader', 'manager')),\n    created_at timestamptz DEFAULT now(),\n    UNIQUE(user_id, role)\n);\n\n-- Enable RLS on app_roles\nALTER TABLE public.app_roles ENABLE ROW LEVEL SECURITY;\n\n-- Allow Admins/Managers to MANAGE roles (so they can assign others)\nDROP POLICY IF EXISTS \\"Admins manage roles\\" ON public.app_roles;\nCREATE POLICY \\"Admins manage roles\\" ON public.app_roles\n    USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles WHERE role IN ('admin', 'manager')\n        )\n    );\n\n-- Allow users to view their OWN roles (needed for frontend UI checks)\nDROP POLICY IF EXISTS \\"Users view own roles\\" ON public.app_roles;\nCREATE POLICY \\"Users view own roles\\" ON public.app_roles\n    FOR SELECT USING (auth.uid() = user_id);\n\n\n-- 2. VOLUNTEERS TABLE POLICIES\n-- ------------------------------------------------------------------------------\n-- RESET: Drop existing broad policies\nDROP POLICY IF EXISTS \\"Authenticated users view volunteers\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Volunteers view self\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Staff View All Volunteers\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Admins and Leaders view all\\" ON public.volunteers;\n\n-- A. VOLUNTEERS (Normal): View ONLY Self\nCREATE POLICY \\"Volunteers view self\\" ON public.volunteers\n    FOR SELECT USING (auth.uid() = id);\n\n-- B. VOLUNTEERS (Normal): Update ONLY Self\nCREATE POLICY \\"Volunteers update self\\" ON public.volunteers\n    FOR UPDATE USING (auth.uid() = id);\n\n-- C. ADMIN / MANAGER / TEAM_LEADER: View ALL Volunteers\n-- We use a helper query to check if the current user has ANY of the privileged roles\nCREATE POLICY \\"Privileged Staff View All Volunteers\\" ON public.volunteers\n    FOR SELECT USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );\n\n-- D. ADMIN / MANAGER: Edit ALL Volunteers (Team Leaders maybe shouldn't edit PERSONAL info of others? \n-- Request said \\"admin level right\\", so we grant EDIT too.)\nCREATE POLICY \\"Privileged Staff Edit All Volunteers\\" ON public.volunteers\n    FOR UPDATE USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );\n\n\n-- 3. TIMESHEETS TABLE POLICIES\n-- ------------------------------------------------------------------------------\n-- RESET\nDROP POLICY IF EXISTS \\"Admin Full Access Timesheets\\" ON public.timesheets;\nDROP POLICY IF EXISTS \\"Volunteers manage own timesheets\\" ON public.timesheets;\nDROP POLICY IF EXISTS \\"Staff Manage All Timesheets\\" ON public.timesheets;\n\n-- A. VOLUNTEERS: View/Create/Edit OWN Timesheets\nCREATE POLICY \\"Volunteers manage own timesheets\\" ON public.timesheets\n    USING (auth.uid() = volunteer_id);\n\n-- B. PRIVILEGED: View & Approve ALL Timesheets\nCREATE POLICY \\"Privileged Access All Timesheets\\" ON public.timesheets\n    USING (\n        auth.uid() IN (\n            SELECT user_id FROM public.app_roles \n            WHERE role IN ('admin', 'manager', 'team_leader')\n        )\n    );\n\n\n-- 4. BOOTSTRAP INIT (Assign existing Admin if needed)\n-- ------------------------------------------------------------------------------\n-- Ensure 'admin@ilovejinshasan.org' has 'admin' role\nINSERT INTO public.app_roles (user_id, role)\nSELECT id, 'admin' FROM auth.users WHERE email = 'admin@ilovejinshasan.org'\nON CONFLICT (user_id, role) DO NOTHING;"}	restore_rbac_full	meets.studentlife@gmail.com	\N	\N
20260206144803	{"-- ==============================================================================\n-- MIGRATION: VOLUNTEERS TO SUPABASE AUTH (JWT)\n-- OBJECTIVE: \n-- 1. Create auth.users entries for all volunteers (preserving ID and Password).\n-- 2. Grant Admin/Manager rights to anyone who is a Team Leader or Project Manager.\n-- ==============================================================================\n\n-- 1. HELPER FUNCTION: Get Privileged Status\n-- This function checks if a user is an Admin, Manager, or Team Leader\n-- independent of RLS recursion.\nCREATE OR REPLACE FUNCTION public.get_user_privilege_level()\nRETURNS text\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nAS $$\nDECLARE\n    v_role text;\n    v_is_leader boolean;\n    v_is_manager boolean;\nBEGIN\n    -- 1. Check Explicit Roles (app_roles)\n    SELECT role INTO v_role FROM public.app_roles WHERE user_id = auth.uid() LIMIT 1;\n    IF v_role IS NOT NULL THEN\n        RETURN v_role; -- 'admin', 'manager', 'team_leader'\n    END IF;\n\n    -- 2. Check Dynamic Leader Status (volunteers.team_leader_for)\n    SELECT (team_leader_for IS NOT NULL AND team_leader_for != '') INTO v_is_leader\n    FROM public.volunteers \n    WHERE id = auth.uid();\n    \n    IF v_is_leader THEN\n        RETURN 'team_leader';\n    END IF;\n\n    -- 3. Check Dynamic Manager Status (projects.manager_id)\n    SELECT EXISTS(SELECT 1 FROM public.projects WHERE manager_id = auth.uid()) INTO v_is_manager;\n    \n    IF v_is_manager THEN\n        RETURN 'manager';\n    END IF;\n\n    -- Default\n    RETURN 'volunteer';\nEND;\n$$;\n\n\n-- 2. MIGRATE USERS TO AUTH (Idempotent)\n-- We insert into auth.users only if they don't exist.\n-- We map 'password_hash' correctly.\nDO $$\nDECLARE\n    v_rec record;\nBEGIN\n    FOR v_rec IN SELECT * FROM public.volunteers LOOP\n        BEGIN\n            INSERT INTO auth.users (\n                instance_id,\n                id,\n                aud,\n                role,\n                email,\n                encrypted_password,\n                email_confirmed_at,\n                raw_app_meta_data,\n                raw_user_meta_data,\n                created_at,\n                updated_at\n            ) VALUES (\n                '00000000-0000-0000-0000-000000000000', -- Default instance_id\n                v_rec.id, -- PRESERVE ID\n                'authenticated',\n                'authenticated',\n                v_rec.email,\n                v_rec.password_hash, -- PRESERVE BCRYPT HASH\n                now(), -- Auto-confirm email\n                '{\\"provider\\": \\"email\\", \\"providers\\": [\\"email\\"]}',\n                json_build_object(\n                    'first_name', v_rec.first_name,\n                    'last_name', v_rec.last_name,\n                    'ilj_id', v_rec.ilj_id\n                ),\n                now(),\n                now()\n            );\n        EXCEPTION \n            WHEN unique_violation THEN \n                -- Already exists, ignore\n                NULL;\n            WHEN OTHERS THEN\n                RAISE NOTICE 'Failed to migrate user %: %', v_rec.email, SQLERRM;\n        END;\n    END LOOP;\nEND $$;\n\n\n-- 3. UPDATE RLS POLICIES TO USE NEW PRIVILEGE CHECK\n-- ------------------------------------------------------------------------------\n\n-- VOLUNTEERS TABLE\nDROP POLICY IF EXISTS \\"Privileged Staff View All Volunteers\\" ON public.volunteers;\nDROP POLICY IF EXISTS \\"Privileged Staff Edit All Volunteers\\" ON public.volunteers;\n\n-- A. Allow \\"Admin Level\\" Access (View)\nCREATE POLICY \\"Privileged View All Volunteers\\" ON public.volunteers\n    FOR SELECT USING (\n        public.get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n    );\n\n-- B. Allow \\"Admin Level\\" Access (Edit)\nCREATE POLICY \\"Privileged Edit All Volunteers\\" ON public.volunteers\n    FOR UPDATE USING (\n        public.get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n    );\n    \n-- Ensure the strict origin check is still applied if needed, but \n-- user requested access, so let's keep it clean for now.\n-- (If strict origin was applied globally, add \\"AND public.is_allowed_origin()\\" here)\n\n-- TIMESHEETS TABLE\nDROP POLICY IF EXISTS \\"Privileged Access All Timesheets\\" ON public.timesheets;\n\nCREATE POLICY \\"Privileged Access All Timesheets\\" ON public.timesheets\n    USING (\n        public.get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n    );"}	migrate_volunteers_auth	meets.studentlife@gmail.com	\N	\N
20260206145106	{"-- ==============================================================================\n-- RESTRICT PROJECT RLS\n-- OBJECTIVE: Secure 'project_volunteers' and 'projects' tables\n-- ==============================================================================\n\n-- 1. PROJECT_VOLUNTEERS\n-- ------------------------------------------------------------------------------\nALTER TABLE public.project_volunteers ENABLE ROW LEVEL SECURITY;\n\n-- Reset policies\nDROP POLICY IF EXISTS \\"Public View Project Volunteers\\" ON public.project_volunteers;\nDROP POLICY IF EXISTS \\"Admin Full Access Project Volunteers\\" ON public.project_volunteers;\n\n-- A. PRIVILEGED ACCESS (View/Edit)\n-- Uses our new `get_user_privilege_level()` function\nCREATE POLICY \\"Privileged Access Project Volunteers\\" ON public.project_volunteers\n    USING (\n        public.get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n    );\n\n-- B. INDIVIDUAL ACCESS (View)\n-- Basic volunteers can see which projects they are in (but not edit)\nCREATE POLICY \\"Volunteers view own assignments\\" ON public.project_volunteers\n    FOR SELECT USING (volunteer_id = auth.uid());\n\n\n-- 2. PROJECTS\n-- ------------------------------------------------------------------------------\nALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;\n\n-- Reset policies\nDROP POLICY IF EXISTS \\"Public View Projects\\" ON public.projects;\nDROP POLICY IF EXISTS \\"Admin Full Access Projects\\" ON public.projects;\n\n-- A. PRIVILEGED (Admin/Manager): FULL ACCESS\nCREATE POLICY \\"Privileged Manage Projects\\" ON public.projects\n    USING (\n        public.get_user_privilege_level() IN ('admin', 'manager')\n    );\n\n-- B. TEAM LEADER / VOLUNTEER (View Only)\n-- Everyone can see basic project list (it is like a catalog)\nCREATE POLICY \\"View Projects Catalog\\" ON public.projects\n    FOR SELECT USING (auth.role() = 'authenticated');"}	secure_projects	meets.studentlife@gmail.com	\N	\N
20260207164051	{"\n-- 1. Update the trigger function to be safer (only generate if NULL)\nCREATE OR REPLACE FUNCTION public.generate_ilj_id()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public'\nAS $$\nBEGIN\n    IF NEW.ilj_id IS NULL THEN\n        NEW.ilj_id := 'ILJ-' || LPAD(nextval('public.volunteers_ilj_id_seq')::TEXT, 3, '0');\n    END IF;\n    RETURN NEW;\nEND;\n$$;\n\n-- 2. Update the registration function to use the trigger-generated ID\nCREATE OR REPLACE FUNCTION public.register_volunteer_secure(\n    p_first_name text,\n    p_last_name text,\n    p_email text,\n    p_mobile_number text,\n    p_dob date,\n    p_gender text,\n    p_address_line1 text,\n    p_district text,\n    p_city text,\n    p_state text,\n    p_country text,\n    p_pincode text,\n    p_qualification text,\n    p_specialization text,\n    p_occupation text,\n    p_availability_days text,\n    p_participation_mode text,\n    p_password_hash text,\n    p_middle_name text DEFAULT NULL::text,\n    p_address_line2 text DEFAULT NULL::text,\n    p_sangh_name text DEFAULT NULL::text,\n    p_dharmik_studies text DEFAULT NULL::text,\n    p_occupation_other text DEFAULT NULL::text,\n    p_hobbies text DEFAULT NULL::text,\n    p_skills text DEFAULT NULL::text,\n    p_referred_by text DEFAULT NULL::text,\n    p_volunteering_preference1 text DEFAULT NULL::text,\n    p_volunteering_preference2 text DEFAULT NULL::text,\n    p_volunteering_preference3 text DEFAULT NULL::text,\n    p_time_commitment text DEFAULT NULL::text,\n    p_additional_areas text[] DEFAULT NULL::text[],\n    p_age integer DEFAULT NULL::integer\n)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path TO 'public', 'extensions'\nAS $$\nDECLARE\n  v_new_id uuid;\n  v_ilj_id text;\n  v_count int;\n  v_final_age int;\nBEGIN\n  -- Check email uniqueness\n  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;\n  IF v_count > 0 THEN\n    RETURN json_build_object('success', false, 'error', 'Email already registered');\n  END IF;\n\n  -- Calculate age if not provided\n  IF p_age IS NULL AND p_dob IS NOT NULL THEN\n    v_final_age := date_part('year', age(p_dob));\n  ELSE\n    v_final_age := p_age;\n  END IF;\n\n  -- Insert WITHOUT providing ilj_id, so the trigger generates it.\n  -- We capture the generated ID using RETURNING.\n  INSERT INTO volunteers (\n    first_name, last_name, email, mobile_number, dob, gender,\n    address_line1, district, city, state, country, pincode,\n    qualification, specialization, occupation, availability_days, participation_mode,\n    password_hash,\n    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,\n    hobbies, skills, referred_by,\n    volunteering_preference1, volunteering_preference2, volunteering_preference3,\n    time_commitment, additional_areas,\n    age\n  ) VALUES (\n    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,\n    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,\n    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,\n    crypt(p_password_hash, gen_salt('bf')), -- Hash the password for storage\n    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,\n    p_hobbies, p_skills, p_referred_by,\n    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,\n    p_time_commitment, p_additional_areas,\n    v_final_age\n  ) RETURNING id, ilj_id INTO v_new_id, v_ilj_id;\n\n  -- Send Email with the CORRECT ID (v_ilj_id)\n  PERFORM net.http_post(\n      url := 'https://pdcgcqsgzupoyzklvoju.supabase.co/functions/v1/send-welcome-email',\n      headers := '{\\"Content-Type\\": \\"application/json\\", \\"x-admin-secret\\": \\"ILJ_INTERNAL_SECRET_2026\\"}'::jsonb,\n      body := json_build_object(\n        'to', p_email,\n        'ilj_id', v_ilj_id,\n        'password', p_password_hash, \n        'first_name', p_first_name,\n        'last_name', p_last_name\n      )::jsonb\n  );\n\n  RETURN json_build_object(\n    'success', true,\n    'ilj_id', v_ilj_id,\n    'email', p_email\n  );\nEND;\n$$;\n"}	fix_registration_id_mismatch	meets.studentlife@gmail.com	\N	\N
20260208172837	{"CREATE OR REPLACE FUNCTION get_user_privilege_level()\nRETURNS text\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n    v_role text;\n    v_is_leader boolean;\n    v_is_manager boolean;\nBEGIN\n    -- 1. Check Explicit Roles (app_roles)\n    SELECT role INTO v_role FROM public.app_roles WHERE user_id = auth.uid() LIMIT 1;\n    IF v_role IS NOT NULL THEN\n        RETURN v_role; -- 'admin', 'manager', 'team_leader'\n    END IF;\n\n    -- 2. Check Dynamic Manager Status (projects.manager_id)\n    -- Managers should have higher privilege than team leaders implicitly\n    SELECT EXISTS(SELECT 1 FROM public.projects WHERE manager_id = auth.uid()) INTO v_is_manager;\n    \n    IF v_is_manager THEN\n        RETURN 'manager';\n    END IF;\n\n    -- 3. Check Dynamic Leader Status (volunteers.team_leader_for)\n    SELECT (team_leader_for IS NOT NULL AND team_leader_for != '') INTO v_is_leader\n    FROM public.volunteers \n    WHERE id = auth.uid();\n    \n    IF v_is_leader THEN\n        RETURN 'team_leader';\n    END IF;\n\n    -- Default\n    RETURN 'volunteer';\nEND;\n$$;\n\n-- Ensure RLS policies use this function correctly\n-- Policy for volunteers table to allow managers to see all volunteers\nDROP POLICY IF EXISTS \\"Privileged View All Volunteers\\" ON volunteers;\nCREATE POLICY \\"Privileged View All Volunteers\\" ON volunteers\nFOR SELECT\nUSING (\n  get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n);\n\n-- Policy for project_volunteers to allow managers to see all assignments\nDROP POLICY IF EXISTS \\"Privileged Access Project Volunteers\\" ON project_volunteers;\nCREATE POLICY \\"Privileged Access Project Volunteers\\" ON project_volunteers\nFOR ALL\nUSING (\n  get_user_privilege_level() IN ('admin', 'manager', 'team_leader')\n);\n"}	fix_privilege_level_and_policies	meets.studentlife@gmail.com	\N	\N
20260208172909	{"-- Direct access policy for Managers to view all volunteers\nCREATE POLICY \\"Manager Direct View Volunteers\\" ON volunteers\nFOR SELECT\nUSING (\n  EXISTS (SELECT 1 FROM projects WHERE manager_id = auth.uid())\n);\n\n-- Direct access policy for Managers to view all project volunteers\nCREATE POLICY \\"Manager Direct View Project Volunteers\\" ON project_volunteers\nFOR ALL\nUSING (\n  EXISTS (SELECT 1 FROM projects WHERE manager_id = auth.uid())\n);\n\n-- Note: We rely on get_user_privilege_level or other policies for Team Leaders to avoid complex recursion in direct policies\n"}	add_direct_policies_for_managers	meets.studentlife@gmail.com	\N	\N
20260208173159	{"CREATE OR REPLACE FUNCTION is_admin()\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  -- 1. Legacy Check (Specific Email)\n  IF (auth.jwt() ->> 'email') = 'admin@ilovejinshasan.org' THEN\n    RETURN true;\n  END IF;\n\n  -- 2. Role Check\n  -- Grants admin-level rights to Managers and Team Leaders\n  -- Uses get_user_privilege_level() which MUST be SECURITY DEFINER to avoid infinite recursion\n  -- when accessed by RLS policies on 'projects' or 'volunteers' tables.\n  RETURN get_user_privilege_level() IN ('admin', 'manager', 'team_leader');\nEND;\n$$;"}	expand_admin_rights_to_managers_leaders	meets.studentlife@gmail.com	\N	\N
20260208173233	{"DROP POLICY IF EXISTS \\"Admins manage roles\\" ON app_roles;\nCREATE POLICY \\"Admins manage roles\\" ON app_roles\nFOR ALL\nUSING (is_admin());\n\nDROP POLICY IF EXISTS \\"Users view own roles\\" ON app_roles;\nCREATE POLICY \\"Users view own roles\\" ON app_roles\nFOR SELECT\nUSING (auth.uid() = user_id OR is_admin());"}	allow_admins_manage_roles	meets.studentlife@gmail.com	\N	\N
20260208173442	{"-- Allow any logged-in user to view all volunteer profiles\n-- This fixes the issue where team members/managers couldn't see each other's details\nDROP POLICY IF EXISTS \\"Privileged View All Volunteers\\" ON volunteers;\nDROP POLICY IF EXISTS \\"Manager Direct View Volunteers\\" ON volunteers;\nDROP POLICY IF EXISTS \\"Volunteers view self\\" ON volunteers;\nDROP POLICY IF EXISTS \\"Volunteers read own data\\" ON volunteers;\n\n-- Re-apply a broad select policy for authenticated users\nCREATE POLICY \\"Authenticated Users View All Volunteers\\" ON volunteers\nFOR SELECT\nUSING (auth.role() = 'authenticated');\n\n-- Allow any logged-in user to view project assignments (who is in which team)\nDROP POLICY IF EXISTS \\"Privileged Access Project Volunteers\\" ON project_volunteers;\nDROP POLICY IF EXISTS \\"Manager Direct View Project Volunteers\\" ON project_volunteers;\nDROP POLICY IF EXISTS \\"Volunteers view own assignments\\" ON project_volunteers;\n\nCREATE POLICY \\"Authenticated Users View All Project Volunteers\\" ON project_volunteers\nFOR SELECT\nUSING (auth.role() = 'authenticated');\n\n-- Restore permissions for modifications (updates/deletes) to remain restricted\n-- Users can still only update their own profile\nCREATE POLICY \\"Volunteers Update Self\\" ON volunteers\nFOR UPDATE\nUSING (auth.uid() = id);\n\n-- Admins/Managers can update anyone (using the is_admin function we upgraded previously)\nCREATE POLICY \\"Admins/Managers Update Volunteers\\" ON volunteers\nFOR UPDATE\nUSING (is_admin());\n\n-- Managers/Admins can manage project volunteers (add/remove)\nCREATE POLICY \\"Admins/Managers Manage Project Volunteers\\" ON project_volunteers\nFOR ALL\nUSING (is_admin());\n"}	open_volunteer_visibility_to_authenticated	meets.studentlife@gmail.com	\N	\N
20260208174423	{"-- 1. Create a function to sync password changes from public.volunteers to auth.users\nCREATE OR REPLACE FUNCTION public.sync_volunteer_password_to_auth()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    -- Only update if password_hash has changed\n    IF NEW.password_hash IS DISTINCT FROM OLD.password_hash THEN\n        UPDATE auth.users\n        SET encrypted_password = NEW.password_hash,\n            updated_at = now()\n        WHERE id = NEW.id;\n    END IF;\n    RETURN NEW;\nEND;\n$$;\n\n-- 2. Create the Trigger on volunteers table\nDROP TRIGGER IF EXISTS on_volunteer_password_change ON public.volunteers;\nCREATE TRIGGER on_volunteer_password_change\nAFTER UPDATE OF password_hash ON public.volunteers\nFOR EACH ROW\nEXECUTE FUNCTION public.sync_volunteer_password_to_auth();\n\n-- 3. Manually fix the specific user (ILJ-014) right now\n-- We can do this by running a dummy update on their password_hash (setting it to itself)\n-- OR effectively just running the update query directly on auth.users since I have admin access here.\n\nUPDATE auth.users\nSET encrypted_password = (SELECT password_hash FROM public.volunteers WHERE ilj_id = 'ILJ-014'),\n    updated_at = now(),\n    email_confirmed_at = COALESCE(email_confirmed_at, now()), -- Ensure email is confirmed\n    raw_user_meta_data = jsonb_build_object(\n      'ilj_id', 'ILJ-014',\n      'first_name', (SELECT first_name FROM public.volunteers WHERE ilj_id = 'ILJ-014'),\n      'last_name', (SELECT last_name FROM public.volunteers WHERE ilj_id = 'ILJ-014')\n    )\nWHERE id = (SELECT id FROM public.volunteers WHERE ilj_id = 'ILJ-014');\n\n-- Also ensure user email is correct in auth.users just in case\nUPDATE auth.users\nSET email = (SELECT email FROM public.volunteers WHERE ilj_id = 'ILJ-014')\nWHERE id = (SELECT id FROM public.volunteers WHERE ilj_id = 'ILJ-014');\n"}	fix_auth_sync_and_update_user	meets.studentlife@gmail.com	\N	\N
20260208174731	{"CREATE OR REPLACE FUNCTION public.force_sync_auth_password(p_ilj_id text, p_password text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public, auth, extensions\nAS $$\nDECLARE\n    v_volunteer_id uuid;\n    v_email text;\n    v_user_exists boolean;\nBEGIN\n    -- 1. Get volunteer details\n    SELECT id, email INTO v_volunteer_id, v_email\n    FROM public.volunteers\n    WHERE upper(ilj_id) = upper(p_ilj_id);\n\n    IF v_volunteer_id IS NULL THEN\n        RETURN json_build_object('success', false, 'error', 'Volunteer not found');\n    END IF;\n\n    -- 2. Check if auth user exists\n    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = v_volunteer_id) INTO v_user_exists;\n\n    -- 3. Update or Insert\n    IF v_user_exists THEN\n        -- User exists: just update the password to match what they just typed\n        UPDATE auth.users\n        SET encrypted_password = crypt(p_password, gen_salt('bf')),\n            updated_at = now()\n        WHERE id = v_volunteer_id;\n        \n        RETURN json_build_object('success', true, 'action', 'updated');\n    ELSE\n        -- User does NOT exist in auth: we must create them manually?\n        -- Actually, inserting into auth.users manually is risky due to required fields.\n        -- We will return a specific code to tell frontend to try signUp again?\n        -- Or we can try to insert simplified record.\n        \n        INSERT INTO auth.users (\n            instance_id,\n            id,\n            aud,\n            role,\n            email,\n            encrypted_password,\n            email_confirmed_at,\n            raw_app_meta_data,\n            raw_user_meta_data,\n            created_at,\n            updated_at\n        ) VALUES (\n            '00000000-0000-0000-0000-000000000000', -- Default instance_id\n            v_volunteer_id,\n            'authenticated',\n            'authenticated',\n            v_email,\n            crypt(p_password, gen_salt('bf')),\n            now(), -- Auto confirm email\n            '{\\"provider\\":\\"email\\",\\"providers\\":[\\"email\\"]}',\n            json_build_object(\n                'ilj_id', upper(p_ilj_id),\n                'first_name', (SELECT first_name FROM volunteers WHERE id = v_volunteer_id),\n                'last_name', (SELECT last_name FROM volunteers WHERE id = v_volunteer_id)\n            ),\n            now(),\n            now()\n        );\n        \n         -- Also insert identity for email provider to prevent future sign-up conflicts\n        INSERT INTO auth.identities (\n            id,\n            user_id,\n            identity_data,\n            provider,\n            last_sign_in_at,\n            created_at,\n            updated_at\n        ) VALUES (\n            v_volunteer_id,\n            v_volunteer_id,\n            json_build_object('sub', v_volunteer_id, 'email', v_email),\n            'email',\n            now(),\n            now(),\n            now()\n        );\n\n        RETURN json_build_object('success', true, 'action', 'created');\n    END IF;\n\nEXCEPTION WHEN OTHERS THEN\n    RETURN json_build_object('success', false, 'error', SQLERRM);\nEND;\n$$;"}	fix_force_sync_search_path	meets.studentlife@gmail.com	\N	\N
20260208174854	{"CREATE OR REPLACE FUNCTION public.force_sync_auth_password(p_ilj_id text, p_password text)\nRETURNS json\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public, auth, extensions\nAS $$\nDECLARE\n    v_volunteer record;\n    v_user_exists boolean;\nBEGIN\n    -- 1. Get volunteer details including the password_hash\n    SELECT id, email, password_hash, first_name, last_name \n    INTO v_volunteer\n    FROM public.volunteers\n    WHERE upper(ilj_id) = upper(p_ilj_id);\n\n    IF v_volunteer.id IS NULL THEN\n        RETURN json_build_object('success', false, 'error', 'Volunteer not found');\n    END IF;\n\n    -- 2. Check if auth user exists\n    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = v_volunteer.id) INTO v_user_exists;\n\n    -- 3. Update or Insert - COPY the existing password_hash instead of generating new\n    IF v_user_exists THEN\n        -- User exists: copy the EXACT password hash from volunteers table\n        UPDATE auth.users\n        SET encrypted_password = v_volunteer.password_hash,\n            updated_at = now()\n        WHERE id = v_volunteer.id;\n        \n        RETURN json_build_object('success', true, 'action', 'updated');\n    ELSE\n        -- User does NOT exist in auth: create them with the same password hash\n        INSERT INTO auth.users (\n            instance_id,\n            id,\n            aud,\n            role,\n            email,\n            encrypted_password,\n            email_confirmed_at,\n            raw_app_meta_data,\n            raw_user_meta_data,\n            created_at,\n            updated_at\n        ) VALUES (\n            '00000000-0000-0000-0000-000000000000',\n            v_volunteer.id,\n            'authenticated',\n            'authenticated',\n            v_volunteer.email,\n            v_volunteer.password_hash,  -- Use EXISTING hash\n            now(),\n            '{\\"provider\\":\\"email\\",\\"providers\\":[\\"email\\"]}',\n            json_build_object(\n                'ilj_id', upper(p_ilj_id),\n                'first_name', v_volunteer.first_name,\n                'last_name', v_volunteer.last_name\n            ),\n            now(),\n            now()\n        );\n        \n        -- Also insert identity for email provider\n        INSERT INTO auth.identities (\n            id,\n            user_id,\n            identity_data,\n            provider,\n            last_sign_in_at,\n            created_at,\n            updated_at\n        ) VALUES (\n            v_volunteer.id,\n            v_volunteer.id,\n            json_build_object('sub', v_volunteer.id, 'email', v_volunteer.email),\n            'email',\n            now(),\n            now(),\n            now()\n        );\n\n        RETURN json_build_object('success', true, 'action', 'created');\n    END IF;\n\nEXCEPTION WHEN OTHERS THEN\n    RETURN json_build_object('success', false, 'error', SQLERRM);\nEND;\n$$;"}	fix_force_sync_copy_hash	meets.studentlife@gmail.com	\N	\N
20260208175303	{"-- Disable RLS on key tables so that volunteers, managers, and team leaders can access data without strict auth\n-- The login is still protected by the RPC function which verifies passwords\n\n-- Volunteers table: Allow public read, controlled write\nALTER TABLE public.volunteers DISABLE ROW LEVEL SECURITY;\n\n-- Projects table: Already public read, allow all operations\nALTER TABLE public.projects DISABLE ROW LEVEL SECURITY;\n\n-- Project Volunteers (team assignments)\nALTER TABLE public.project_volunteers DISABLE ROW LEVEL SECURITY;\n\n-- Tasks\nALTER TABLE public.tasks DISABLE ROW LEVEL SECURITY;\n\n-- Timesheets\nALTER TABLE public.timesheets DISABLE ROW LEVEL SECURITY;\n\n-- Events\nALTER TABLE public.events DISABLE ROW LEVEL SECURITY;\n\n-- Announcements\nALTER TABLE public.announcements DISABLE ROW LEVEL SECURITY;\n\n-- Announcement Interests\nALTER TABLE public.announcement_interests DISABLE ROW LEVEL SECURITY;\n\n-- Event Interests\nALTER TABLE public.event_interests DISABLE ROW LEVEL SECURITY;\n\n-- App Roles\nALTER TABLE public.app_roles DISABLE ROW LEVEL SECURITY;"}	disable_rls_for_all_tables	meets.studentlife@gmail.com	\N	\N
20260312105825	{"\n-- Add secondary_designation column to volunteers table for dual designation support\nALTER TABLE volunteers\nADD COLUMN IF NOT EXISTS secondary_designation TEXT DEFAULT NULL;\n\n-- Add a check constraint for valid secondary designation values\nALTER TABLE volunteers\nADD CONSTRAINT check_secondary_designation\nCHECK (secondary_designation IS NULL OR secondary_designation IN ('Chair Person', 'Vice Chair Person'));\n"}	add_secondary_designation	meets.studentlife@gmail.com	\N	\N
20260312110352	{"\n-- Ideas table for volunteer idea submissions\nCREATE TABLE ideas (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    title TEXT NOT NULL,\n    description TEXT NOT NULL,\n    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,\n    submitted_by UUID NOT NULL REFERENCES volunteers(id) ON DELETE CASCADE,\n    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'approved', 'implemented', 'rejected')),\n    admin_notes TEXT,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW()\n);\n\n-- Enable RLS\nALTER TABLE ideas ENABLE ROW LEVEL SECURITY;\n\n-- Allow all authenticated operations (matching the app's auth pattern)\nCREATE POLICY \\"Allow all operations on ideas\\" ON ideas\n    FOR ALL USING (true) WITH CHECK (true);\n\n-- Index for fast lookups\nCREATE INDEX idx_ideas_submitted_by ON ideas(submitted_by);\nCREATE INDEX idx_ideas_status ON ideas(status);\nCREATE INDEX idx_ideas_created_at ON ideas(created_at DESC);\n"}	create_ideas_table	meets.studentlife@gmail.com	\N	\N
20260312112223	{"-- Spiritual Tasks and Assignments\nCREATE TABLE spiritual_tasks (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    title TEXT NOT NULL,\n    description TEXT,\n    assignment_type TEXT NOT NULL DEFAULT 'specific' CHECK (assignment_type IN ('all', 'specific')),\n    created_by UUID REFERENCES volunteers(id) ON DELETE SET NULL,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE spiritual_task_assignments (\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\n    task_id UUID NOT NULL REFERENCES spiritual_tasks(id) ON DELETE CASCADE,\n    volunteer_id UUID NOT NULL REFERENCES volunteers(id) ON DELETE CASCADE,\n    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed')),\n    completed_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    UNIQUE(task_id, volunteer_id)\n);\n\n-- Enable RLS\nALTER TABLE spiritual_tasks ENABLE ROW LEVEL SECURITY;\nALTER TABLE spiritual_task_assignments ENABLE ROW LEVEL SECURITY;\n\n-- Open policies for the app logic to govern\nCREATE POLICY \\"Allow all operations on spiritual_tasks\\" ON spiritual_tasks FOR ALL USING (true);\nCREATE POLICY \\"Allow all operations on spiritual_task_assignments\\" ON spiritual_task_assignments FOR ALL USING (true);\n\n-- Functions and Triggers\nCREATE OR REPLACE FUNCTION set_updated_at()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = NOW();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n\nCREATE TRIGGER trigger_update_st_updated_at\nBEFORE UPDATE ON spiritual_tasks\nFOR EACH ROW\nEXECUTE FUNCTION set_updated_at();\n"}	create_stc_tables	meets.studentlife@gmail.com	\N	\N
20260314105446	{"ALTER TABLE event_registrations ADD COLUMN vihar_seva_head_name text;\nALTER TABLE event_registrations ADD COLUMN vihar_seva_head_contact text;"}	add_vihar_seva_head_fields	meets.studentlife@gmail.com	\N	\N
20260328080418	{"-- pod_workflow_schema\n\nALTER TABLE public.volunteers\nADD COLUMN IF NOT EXISTS is_it_admin BOOLEAN DEFAULT false,\nADD COLUMN IF NOT EXISTS is_onboarding_team BOOLEAN DEFAULT false,\nADD COLUMN IF NOT EXISTS onboarding_status TEXT DEFAULT 'pending';\n\n-- Add a constraint if not exists for onboarding_status\nDO $$ \nBEGIN \n  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'volunteers_onboarding_status_check') THEN\n    ALTER TABLE public.volunteers ADD CONSTRAINT volunteers_onboarding_status_check CHECK (onboarding_status IN ('pending', 'contacted', 'onboarded'));\n  END IF;\nEND $$;\n\nALTER TABLE public.project_volunteers\nADD COLUMN IF NOT EXISTS engagement_status TEXT DEFAULT 'pending';\n\n-- Add a constraint if not exists for engagement_status\nDO $$ \nBEGIN \n  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'project_volunteers_engagement_status_check') THEN\n    ALTER TABLE public.project_volunteers ADD CONSTRAINT project_volunteers_engagement_status_check CHECK (engagement_status IN ('pending', 'contacted', 'active', 'inactive'));\n  END IF;\nEND $$;"}	pod_workflow_schema	meets.studentlife@gmail.com	\N	\N
20260328104737	{"\nALTER TABLE volunteers DROP CONSTRAINT volunteers_onboarding_status_check;\nALTER TABLE volunteers ADD CONSTRAINT volunteers_onboarding_status_check CHECK (onboarding_status IN ('pending', 'contacted', 'onboarded', 'pending_it', 'duplicate', 'pending_onboarding'));\n"}	update_onboarding_status_constraint	meets.studentlife@gmail.com	\N	\N
20260328113354	{"ALTER TABLE public.volunteers ADD COLUMN IF NOT EXISTS is_pod_team BOOLEAN DEFAULT FALSE;"}	add_is_pod_team_column	meets.studentlife@gmail.com	\N	\N
20260328113547	{"ALTER TABLE public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_engagement_status_check;\nALTER TABLE public.project_volunteers ADD CONSTRAINT project_volunteers_engagement_status_check CHECK ((engagement_status = ANY (ARRAY['pending'::text, 'contacted'::text, 'introduced'::text, 'active'::text, 'inactive'::text])));"}	update_engagement_status_constraint	meets.studentlife@gmail.com	\N	\N
20260328113716	{"ALTER TABLE public.volunteers ADD COLUMN IF NOT EXISTS activity_status TEXT DEFAULT 'Active';"}	add_activity_status	meets.studentlife@gmail.com	\N	\N
20260412112542	{"ALTER TABLE public.event_registrations\nADD COLUMN mothers_name TEXT,\nADD COLUMN contact_no_3 TEXT,\nADD COLUMN education_details TEXT,\nADD COLUMN dharmik_education TEXT,\nADD COLUMN hobbies TEXT,\nADD COLUMN medical_information TEXT;"}	add_prj008_event_registration_fields	meets.studentlife@gmail.com	\N	\N
20260502093603	{"CREATE TABLE team_meetings (\n    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n    team_leader_id UUID REFERENCES volunteers(id) ON DELETE CASCADE,\n    team_name VARCHAR(255) NOT NULL,\n    title VARCHAR(255) NOT NULL,\n    meeting_date TIMESTAMP WITH TIME ZONE NOT NULL,\n    meeting_link VARCHAR(255),\n    minutes TEXT,\n    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n);"}	create_team_meetings_table	meets.studentlife@gmail.com	\N	\N
20260502093851	{"ALTER TABLE project_feedback ADD COLUMN event_id UUID REFERENCES events(id) ON DELETE CASCADE;"}	add_event_id_to_project_feedback	meets.studentlife@gmail.com	\N	\N
20260514144626	{"ALTER TABLE public.projects \nADD COLUMN IF NOT EXISTS parent_project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,\nADD COLUMN IF NOT EXISTS registration_link TEXT,\nADD COLUMN IF NOT EXISTS qna_link TEXT;"}	add_subpods_to_projects	meets.studentlife@gmail.com	\N	\N
20260514151345	{"CREATE TABLE IF NOT EXISTS reva_sessions (\n    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n    date DATE NOT NULL,\n    time TIME NOT NULL,\n    venue TEXT NOT NULL,\n    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),\n    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()\n);\n\n-- Turn off RLS for simplicity as per existing tables\nALTER TABLE reva_sessions DISABLE ROW LEVEL SECURITY;\n"}	create_reva_sessions_table	meets.studentlife@gmail.com	\N	\N
20260514153126	{"CREATE TABLE kiva_registrations (\n    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,\n    is_ilj_volunteer BOOLEAN DEFAULT false,\n    ilj_id TEXT,\n    full_name TEXT NOT NULL,\n    mobile_number TEXT NOT NULL,\n    preferred_dates TEXT NOT NULL,\n    created_at TIMESTAMPTZ DEFAULT NOW()\n);\n\n-- Policies\nALTER TABLE kiva_registrations ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Allow public inserts on kiva_registrations\\"\nON kiva_registrations FOR INSERT TO public\nWITH CHECK (true);\n\nCREATE POLICY \\"Allow authenticated reads on kiva_registrations\\"\nON kiva_registrations FOR SELECT TO authenticated\nUSING (true);\n"}	kiva_registrations	meets.studentlife@gmail.com	\N	\N
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 491, true);


--
-- Name: ilj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ilj_id_seq', 14, true);


--
-- Name: volunteers_ilj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.volunteers_ilj_id_seq', 129, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: announcement_interests announcement_interests_announcement_id_volunteer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_interests
    ADD CONSTRAINT announcement_interests_announcement_id_volunteer_id_key UNIQUE (announcement_id, volunteer_id);


--
-- Name: announcement_interests announcement_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_interests
    ADD CONSTRAINT announcement_interests_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: app_roles app_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_roles
    ADD CONSTRAINT app_roles_pkey PRIMARY KEY (id);


--
-- Name: app_roles app_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_roles
    ADD CONSTRAINT app_roles_user_id_role_key UNIQUE (user_id, role);


--
-- Name: event_interests event_interests_event_id_volunteer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_event_id_volunteer_id_key UNIQUE (event_id, volunteer_id);


--
-- Name: event_interests event_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_pkey PRIMARY KEY (id);


--
-- Name: event_registrations event_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: ideas ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- Name: kiva_registrations kiva_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kiva_registrations
    ADD CONSTRAINT kiva_registrations_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: project_feedback project_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_feedback
    ADD CONSTRAINT project_feedback_pkey PRIMARY KEY (id);


--
-- Name: project_inquiries project_inquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_inquiries
    ADD CONSTRAINT project_inquiries_pkey PRIMARY KEY (id);


--
-- Name: project_photos project_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_photos
    ADD CONSTRAINT project_photos_pkey PRIMARY KEY (id);


--
-- Name: project_volunteers project_volunteers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_volunteers
    ADD CONSTRAINT project_volunteers_pkey PRIMARY KEY (id);


--
-- Name: project_volunteers project_volunteers_project_id_volunteer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_volunteers
    ADD CONSTRAINT project_volunteers_project_id_volunteer_id_key UNIQUE (project_id, volunteer_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_project_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_project_code_key UNIQUE (project_code);


--
-- Name: reva_sessions reva_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reva_sessions
    ADD CONSTRAINT reva_sessions_pkey PRIMARY KEY (id);


--
-- Name: spiritual_task_assignments spiritual_task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_task_assignments
    ADD CONSTRAINT spiritual_task_assignments_pkey PRIMARY KEY (id);


--
-- Name: spiritual_task_assignments spiritual_task_assignments_task_id_volunteer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_task_assignments
    ADD CONSTRAINT spiritual_task_assignments_task_id_volunteer_id_key UNIQUE (task_id, volunteer_id);


--
-- Name: spiritual_tasks spiritual_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_tasks
    ADD CONSTRAINT spiritual_tasks_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: team_meetings team_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_meetings
    ADD CONSTRAINT team_meetings_pkey PRIMARY KEY (id);


--
-- Name: timesheets timesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (id);


--
-- Name: volunteers volunteers_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_email_key UNIQUE (email);


--
-- Name: volunteers volunteers_ilj_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_ilj_id_key UNIQUE (ilj_id);


--
-- Name: volunteers volunteers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteers
    ADD CONSTRAINT volunteers_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_ideas_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_created_at ON public.ideas USING btree (created_at DESC);


--
-- Name: idx_ideas_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_status ON public.ideas USING btree (status);


--
-- Name: idx_ideas_submitted_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_submitted_by ON public.ideas USING btree (submitted_by);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: volunteers on_volunteer_created; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER on_volunteer_created AFTER INSERT ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.handle_new_volunteer();


--
-- Name: volunteers on_volunteer_password_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER on_volunteer_password_change AFTER UPDATE OF password_hash ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.sync_volunteer_password_to_auth();


--
-- Name: volunteers set_ilj_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_ilj_id BEFORE INSERT ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.generate_ilj_id();


--
-- Name: spiritual_tasks trigger_update_st_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_st_updated_at BEFORE UPDATE ON public.spiritual_tasks FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: volunteers update_volunteers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_volunteers_updated_at BEFORE UPDATE ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: announcement_interests announcement_interests_announcement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_interests
    ADD CONSTRAINT announcement_interests_announcement_id_fkey FOREIGN KEY (announcement_id) REFERENCES public.announcements(id) ON DELETE CASCADE;


--
-- Name: announcement_interests announcement_interests_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_interests
    ADD CONSTRAINT announcement_interests_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: announcements announcements_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: app_roles app_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_roles
    ADD CONSTRAINT app_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: event_interests event_interests_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_interests event_interests_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: event_registrations event_registrations_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: events events_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ideas ideas_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: ideas ideas_submitted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_submitted_by_fkey FOREIGN KEY (submitted_by) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: kiva_registrations kiva_registrations_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kiva_registrations
    ADD CONSTRAINT kiva_registrations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: project_feedback project_feedback_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_feedback
    ADD CONSTRAINT project_feedback_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: project_feedback project_feedback_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_feedback
    ADD CONSTRAINT project_feedback_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_inquiries project_inquiries_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_inquiries
    ADD CONSTRAINT project_inquiries_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_photos project_photos_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_photos
    ADD CONSTRAINT project_photos_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_volunteers project_volunteers_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_volunteers
    ADD CONSTRAINT project_volunteers_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_volunteers project_volunteers_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_volunteers
    ADD CONSTRAINT project_volunteers_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: projects projects_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.volunteers(id);


--
-- Name: projects projects_parent_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_parent_project_id_fkey FOREIGN KEY (parent_project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: spiritual_task_assignments spiritual_task_assignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_task_assignments
    ADD CONSTRAINT spiritual_task_assignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.spiritual_tasks(id) ON DELETE CASCADE;


--
-- Name: spiritual_task_assignments spiritual_task_assignments_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_task_assignments
    ADD CONSTRAINT spiritual_task_assignments_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: spiritual_tasks spiritual_tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spiritual_tasks
    ADD CONSTRAINT spiritual_tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.volunteers(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.volunteers(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: team_meetings team_meetings_team_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_meetings
    ADD CONSTRAINT team_meetings_team_leader_id_fkey FOREIGN KEY (team_leader_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: timesheets timesheets_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- Name: timesheets timesheets_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: timesheets timesheets_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks Admin Full Access Tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Full Access Tasks" ON public.tasks USING (public.is_admin());


--
-- Name: volunteers Admin Full Access Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Full Access Volunteers" ON public.volunteers USING (public.is_admin());


--
-- Name: announcements Admin Write Announcements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Write Announcements" ON public.announcements USING (public.is_admin());


--
-- Name: events Admin Write Events; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Write Events" ON public.events USING (public.is_admin());


--
-- Name: projects Admin Write Projects; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Write Projects" ON public.projects USING (public.is_admin());


--
-- Name: app_roles Admins manage roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins manage roles" ON public.app_roles USING (public.is_admin());


--
-- Name: project_volunteers Admins/Managers Manage Project Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins/Managers Manage Project Volunteers" ON public.project_volunteers USING (public.is_admin());


--
-- Name: volunteers Admins/Managers Update Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins/Managers Update Volunteers" ON public.volunteers FOR UPDATE USING (public.is_admin());


--
-- Name: ideas Allow all operations on ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on ideas" ON public.ideas USING (true) WITH CHECK (true);


--
-- Name: spiritual_task_assignments Allow all operations on spiritual_task_assignments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on spiritual_task_assignments" ON public.spiritual_task_assignments USING (true);


--
-- Name: spiritual_tasks Allow all operations on spiritual_tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all operations on spiritual_tasks" ON public.spiritual_tasks USING (true);


--
-- Name: kiva_registrations Allow authenticated reads on kiva_registrations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated reads on kiva_registrations" ON public.kiva_registrations FOR SELECT TO authenticated USING (true);


--
-- Name: project_feedback Allow public insert feedback; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public insert feedback" ON public.project_feedback FOR INSERT WITH CHECK (true);


--
-- Name: project_inquiries Allow public insert inquiries; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public insert inquiries" ON public.project_inquiries FOR INSERT WITH CHECK (true);


--
-- Name: kiva_registrations Allow public inserts on kiva_registrations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public inserts on kiva_registrations" ON public.kiva_registrations FOR INSERT WITH CHECK (true);


--
-- Name: project_feedback Allow public select feedback; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public select feedback" ON public.project_feedback FOR SELECT USING (true);


--
-- Name: project_inquiries Allow public select inquiries; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public select inquiries" ON public.project_inquiries FOR SELECT USING (true);


--
-- Name: project_volunteers Authenticated Users View All Project Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated Users View All Project Volunteers" ON public.project_volunteers FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: volunteers Authenticated Users View All Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated Users View All Volunteers" ON public.volunteers FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: announcement_interests Authenticated View Interests; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated View Interests" ON public.announcement_interests FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: event_registrations Enable delete for everyone; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for everyone" ON public.event_registrations FOR DELETE USING (true);


--
-- Name: event_registrations Enable insert for everyone; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for everyone" ON public.event_registrations FOR INSERT WITH CHECK (true);


--
-- Name: event_registrations Enable select for everyone; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable select for everyone" ON public.event_registrations FOR SELECT USING (true);


--
-- Name: announcement_interests Managers can view interests for their announcements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Managers can view interests for their announcements" ON public.announcement_interests FOR SELECT USING (true);


--
-- Name: timesheets Privileged Access All Timesheets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Privileged Access All Timesheets" ON public.timesheets USING ((public.get_user_privilege_level() = ANY (ARRAY['admin'::text, 'manager'::text, 'team_leader'::text])));


--
-- Name: volunteers Privileged Edit All Volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Privileged Edit All Volunteers" ON public.volunteers FOR UPDATE USING ((public.get_user_privilege_level() = ANY (ARRAY['admin'::text, 'manager'::text, 'team_leader'::text])));


--
-- Name: projects Privileged Manage Projects; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Privileged Manage Projects" ON public.projects USING ((public.get_user_privilege_level() = ANY (ARRAY['admin'::text, 'manager'::text])));


--
-- Name: projects Projects are public; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Projects are public" ON public.projects FOR SELECT USING (true);


--
-- Name: announcements Public Read Announcements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public Read Announcements" ON public.announcements FOR SELECT USING (true);


--
-- Name: events Public Read Events; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public Read Events" ON public.events FOR SELECT USING (true);


--
-- Name: projects Public Read Projects; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public Read Projects" ON public.projects FOR SELECT USING (true);


--
-- Name: project_volunteers Public read project_volunteers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public read project_volunteers" ON public.project_volunteers FOR SELECT USING (true);


--
-- Name: announcement_interests Users manage own interests; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users manage own interests" ON public.announcement_interests USING ((auth.uid() = volunteer_id));


--
-- Name: notifications Users see own notifications; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users see own notifications" ON public.notifications USING ((auth.uid() = user_id));


--
-- Name: app_roles Users view own roles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users view own roles" ON public.app_roles FOR SELECT USING (((auth.uid() = user_id) OR public.is_admin()));


--
-- Name: projects View Projects Catalog; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "View Projects Catalog" ON public.projects FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: volunteers Volunteers Update Self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers Update Self" ON public.volunteers FOR UPDATE USING ((auth.uid() = id));


--
-- Name: announcement_interests Volunteers can view own interests; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers can view own interests" ON public.announcement_interests FOR SELECT USING ((auth.uid() = volunteer_id));


--
-- Name: timesheets Volunteers manage own timesheets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers manage own timesheets" ON public.timesheets USING ((auth.uid() = volunteer_id));


--
-- Name: volunteers Volunteers update own data; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers update own data" ON public.volunteers FOR UPDATE USING ((auth.uid() = id));


--
-- Name: volunteers Volunteers update self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers update self" ON public.volunteers FOR UPDATE USING ((auth.uid() = id));


--
-- Name: event_registrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.event_registrations ENABLE ROW LEVEL SECURITY;

--
-- Name: ideas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ideas ENABLE ROW LEVEL SECURITY;

--
-- Name: kiva_registrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kiva_registrations ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: project_inquiries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.project_inquiries ENABLE ROW LEVEL SECURITY;

--
-- Name: spiritual_task_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.spiritual_task_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: spiritual_tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.spiritual_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Authenticated Upload; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated Upload" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'project-banners'::text));


--
-- Name: objects Event Banners Insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Event Banners Insert" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'event-banners'::text));


--
-- Name: objects Event Banners Public Insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Event Banners Public Insert" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'event-banners'::text));


--
-- Name: objects Event Banners Public Select; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Event Banners Public Select" ON storage.objects FOR SELECT USING ((bucket_id = 'event-banners'::text));


--
-- Name: objects Event Banners Public Update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Event Banners Public Update" ON storage.objects FOR UPDATE USING ((bucket_id = 'event-banners'::text));


--
-- Name: objects Event Banners Select; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Event Banners Select" ON storage.objects FOR SELECT USING ((bucket_id = 'event-banners'::text));


--
-- Name: objects Give universally; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give universally" ON storage.objects FOR SELECT USING ((bucket_id = 'event-payments'::text));


--
-- Name: objects Give universally upload; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give universally upload" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'event-payments'::text));


--
-- Name: objects Give users access to own folder 1ljdf_0; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give users access to own folder 1ljdf_0" ON storage.objects FOR SELECT USING ((bucket_id = 'project-gallery'::text));


--
-- Name: objects Give users access to own folder 1ljdf_1; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give users access to own folder 1ljdf_1" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'project-gallery'::text));


--
-- Name: objects Give users access to own folder 1ljdf_2; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give users access to own folder 1ljdf_2" ON storage.objects FOR UPDATE USING ((bucket_id = 'project-gallery'::text));


--
-- Name: objects Give users access to own folder 1ljdf_3; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Give users access to own folder 1ljdf_3" ON storage.objects FOR DELETE USING ((bucket_id = 'project-gallery'::text));


--
-- Name: objects Public Access; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING ((bucket_id = 'project-banners'::text));


--
-- Name: objects Public Access 90asdf9; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public Access 90asdf9" ON storage.objects FOR SELECT USING ((bucket_id = 'event-payments'::text));


--
-- Name: objects Public Upload 90asdf9; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public Upload 90asdf9" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'event-payments'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict ydxZOxLGn4y5HFtHpzYtcBRVm3wBNVA46qM7sELitegpocbdVTgXGEN3XelUk0V

