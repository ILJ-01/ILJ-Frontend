--
-- PostgreSQL database dump
--

\restrict D8YFKgMWpwwvHy6QI4o1lqHH8r8Of8NwZVOXBJxdMCs5NXxa988aVzCoDtFeHuG

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7 (Ubuntu 17.7-3.pgdg24.04+1)

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
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Select" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Update" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Select" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Public Insert" ON storage.objects;
DROP POLICY IF EXISTS "Event Banners Insert" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Upload" ON storage.objects;
DROP POLICY IF EXISTS "Volunteers can view own interests" ON public.announcement_interests;
DROP POLICY IF EXISTS "Public read project_volunteers" ON public.project_volunteers;
DROP POLICY IF EXISTS "Public Read Projects" ON public.projects;
DROP POLICY IF EXISTS "Public Read Events" ON public.events;
DROP POLICY IF EXISTS "Public Read Announcements" ON public.announcements;
DROP POLICY IF EXISTS "Projects are public" ON public.projects;
DROP POLICY IF EXISTS "Managers can view interests for their announcements" ON public.announcement_interests;
DROP POLICY IF EXISTS "Allow read own data" ON public.volunteers;
DROP POLICY IF EXISTS "Allow Registration" ON public.volunteers;
DROP POLICY IF EXISTS "Admin Write Projects" ON public.projects;
DROP POLICY IF EXISTS "Admin Write Events" ON public.events;
DROP POLICY IF EXISTS "Admin Write Announcements" ON public.announcements;
DROP POLICY IF EXISTS "Admin Full Access Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Admin Full Access Timesheets" ON public.timesheets;
DROP POLICY IF EXISTS "Admin Full Access Tasks" ON public.tasks;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.prefixes DROP CONSTRAINT IF EXISTS "prefixes_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timesheets DROP CONSTRAINT IF EXISTS timesheets_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_assignee_id_fkey;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_manager_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_project_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_volunteer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_announcement_id_fkey;
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
DROP TRIGGER IF EXISTS prefixes_delete_hierarchy ON storage.prefixes;
DROP TRIGGER IF EXISTS prefixes_create_hierarchy ON storage.prefixes;
DROP TRIGGER IF EXISTS objects_update_create_prefix ON storage.objects;
DROP TRIGGER IF EXISTS objects_insert_create_prefix ON storage.objects;
DROP TRIGGER IF EXISTS objects_delete_delete_prefix ON storage.objects;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS update_volunteers_updated_at ON public.volunteers;
DROP TRIGGER IF EXISTS set_ilj_id ON public.volunteers;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.objects_bucket_id_level_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_prefixes_lower_name;
DROP INDEX IF EXISTS storage.idx_objects_lower_name;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_name_bucket_level_unique;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX IF EXISTS realtime.messages_inserted_at_topic_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
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
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
ALTER TABLE IF EXISTS ONLY supabase_migrations.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY supabase_migrations.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_idempotency_key_key;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.prefixes DROP CONSTRAINT IF EXISTS prefixes_pkey;
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
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_pkey;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_project_code_key;
ALTER TABLE IF EXISTS ONLY public.projects DROP CONSTRAINT IF EXISTS projects_pkey;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_project_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY public.project_volunteers DROP CONSTRAINT IF EXISTS project_volunteers_pkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_pkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_pkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_event_id_volunteer_id_key;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_pkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_pkey;
ALTER TABLE IF EXISTS ONLY public.announcement_interests DROP CONSTRAINT IF EXISTS announcement_interests_announcement_id_volunteer_id_key;
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
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS supabase_migrations.schema_migrations;
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.prefixes;
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
DROP TABLE IF EXISTS public.tasks;
DROP TABLE IF EXISTS public.projects;
DROP TABLE IF EXISTS public.project_volunteers;
DROP TABLE IF EXISTS public.notifications;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.event_interests;
DROP TABLE IF EXISTS public.announcements;
DROP TABLE IF EXISTS public.announcement_interests;
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
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION IF EXISTS storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.prefixes_insert_trigger();
DROP FUNCTION IF EXISTS storage.prefixes_delete_cleanup();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.objects_update_prefix_trigger();
DROP FUNCTION IF EXISTS storage.objects_update_level_trigger();
DROP FUNCTION IF EXISTS storage.objects_update_cleanup();
DROP FUNCTION IF EXISTS storage.objects_insert_prefix_trigger();
DROP FUNCTION IF EXISTS storage.objects_delete_cleanup();
DROP FUNCTION IF EXISTS storage.lock_top_prefixes(bucket_ids text[], names text[]);
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_prefixes(name text);
DROP FUNCTION IF EXISTS storage.get_prefix(name text);
DROP FUNCTION IF EXISTS storage.get_level(name text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.delete_prefix_hierarchy_trigger();
DROP FUNCTION IF EXISTS storage.delete_prefix(_bucket_id text, _name text);
DROP FUNCTION IF EXISTS storage.delete_leaf_prefixes(bucket_ids text[], names text[]);
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS storage.add_prefixes(_bucket_id text, _name text);
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
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.reset_volunteer_password(p_ilj_id text, p_email text, p_new_password text);
DROP FUNCTION IF EXISTS public.register_volunteer_secure(p_first_name text, p_last_name text, p_email text, p_mobile_number text, p_dob date, p_gender text, p_address_line1 text, p_district text, p_city text, p_state text, p_country text, p_pincode text, p_qualification text, p_specialization text, p_occupation text, p_availability_days text, p_participation_mode text, p_password_hash text, p_middle_name text, p_address_line2 text, p_sangh_name text, p_dharmik_studies text, p_occupation_other text, p_hobbies text, p_skills text, p_referred_by text, p_volunteering_preference1 text, p_volunteering_preference2 text, p_volunteering_preference3 text, p_time_commitment text, p_additional_areas text[]);
DROP FUNCTION IF EXISTS public.login_volunteer(p_ilj_id text, p_password text);
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.generate_ilj_id();
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
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
DROP EXTENSION IF EXISTS pg_graphql;
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
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


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
-- Name: generate_ilj_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_ilj_id() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    NEW.ilj_id := 'ILJ-' || LPAD(nextval('public.volunteers_ilj_id_seq')::TEXT, 3, '0');
    RETURN NEW;
END;
$$;


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN (auth.jwt() ->> 'email') = 'admin@ilovejinshasan.org';
END;
$$;


--
-- Name: login_volunteer(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.login_volunteer(p_ilj_id text, p_password text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_user record;
  v_projects json;
BEGIN
  -- Verify using crypt
  SELECT * INTO v_user FROM volunteers 
  WHERE ilj_id = p_ilj_id 
  AND password_hash = crypt(p_password, password_hash);
  
  IF v_user IS NULL THEN
    RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or password');
  ELSE
    SELECT json_agg(p.*) INTO v_projects FROM projects p WHERE p.manager_id = v_user.id;
    
    RETURN json_build_object(
      'success', true, 
      'user', json_build_object(
        'id', v_user.id,
        'ilj_id', v_user.ilj_id,
        'first_name', v_user.first_name,
        'last_name', v_user.last_name,
        'email', v_user.email,
        'role', v_user.rank,
        'managed_projects', COALESCE(v_projects, '[]'::json)
      )
    );
  END IF;
END;
$$;


--
-- Name: register_volunteer_secure(text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.register_volunteer_secure(p_first_name text, p_last_name text, p_email text, p_mobile_number text, p_dob date, p_gender text, p_address_line1 text, p_district text, p_city text, p_state text, p_country text, p_pincode text, p_qualification text, p_specialization text, p_occupation text, p_availability_days text, p_participation_mode text, p_password_hash text, p_middle_name text DEFAULT NULL::text, p_address_line2 text DEFAULT NULL::text, p_sangh_name text DEFAULT NULL::text, p_dharmik_studies text DEFAULT NULL::text, p_occupation_other text DEFAULT NULL::text, p_hobbies text DEFAULT NULL::text, p_skills text DEFAULT NULL::text, p_referred_by text DEFAULT NULL::text, p_volunteering_preference1 text DEFAULT NULL::text, p_volunteering_preference2 text DEFAULT NULL::text, p_volunteering_preference3 text DEFAULT NULL::text, p_time_commitment text DEFAULT NULL::text, p_additional_areas text[] DEFAULT NULL::text[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_new_id uuid;
  v_ilj_id text;
  v_count int;
  v_request_id int;
BEGIN
  -- Check email uniqueness
  SELECT count(*) INTO v_count FROM volunteers WHERE email = p_email;
  IF v_count > 0 THEN
    RETURN json_build_object('success', false, 'error', 'Email already registered');
  END IF;

  v_ilj_id := 'ILJ-' || upper(substring(md5(random()::text) from 1 for 6));

  INSERT INTO volunteers (
    first_name, last_name, email, mobile_number, dob, gender,
    address_line1, district, city, state, country, pincode,
    qualification, specialization, occupation, availability_days, participation_mode,
    password_hash,
    middle_name, address_line2, sangh_name, dharmik_studies, occupation_other,
    hobbies, skills, referred_by,
    volunteering_preference1, volunteering_preference2, volunteering_preference3,
    time_commitment, additional_areas,
    ilj_id
  ) VALUES (
    p_first_name, p_last_name, p_email, p_mobile_number, p_dob, p_gender,
    p_address_line1, p_district, p_city, p_state, p_country, p_pincode,
    p_qualification, p_specialization, p_occupation, p_availability_days, p_participation_mode,
    crypt(p_password_hash, gen_salt('bf')), -- HASHING HERE
    p_middle_name, p_address_line2, p_sangh_name, p_dharmik_studies, p_occupation_other,
    p_hobbies, p_skills, p_referred_by,
    p_volunteering_preference1, p_volunteering_preference2, p_volunteering_preference3,
    p_time_commitment, p_additional_areas,
    v_ilj_id
  ) RETURNING id INTO v_new_id;

  -- Send Email with RAW password
  -- We pass the raw password (p_password_hash) to the email service BEFORE it is lost.
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
    AS $$
DECLARE
  v_user_id uuid;
BEGIN
  -- Verify user exists with matching ILJ ID and Email
  SELECT id INTO v_user_id
  FROM volunteers
  WHERE ilj_id = p_ilj_id 
    AND email = p_email;

  IF v_user_id IS NULL THEN
     RETURN json_build_object('success', false, 'error', 'Invalid ILJ ID or Email');
  END IF;

  -- Update Password with Hash
  UPDATE volunteers
  SET password_hash = crypt(p_new_password, gen_salt('bf'))
  WHERE id = v_user_id;

  RETURN json_build_object('success', true, 'message', 'Password updated successfully');
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
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
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

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
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
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
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
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
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
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
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
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
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
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
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
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
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
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


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
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


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
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


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
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
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
-- Name: event_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_interests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid,
    volunteer_id uuid,
    created_at timestamp with time zone DEFAULT now()
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
-- Name: project_volunteers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_volunteers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    volunteer_id uuid,
    assigned_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'approved'::text
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
    status text DEFAULT 'upcoming'::text
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
    designation text
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
    user_metadata jsonb,
    level integer
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


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
    user_metadata jsonb
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
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
35c1bb89-4881-4798-a257-8b714d2017dd	35c1bb89-4881-4798-a257-8b714d2017dd	{"sub": "35c1bb89-4881-4798-a257-8b714d2017dd", "email": "admin@ilovejinshasan.org", "email_verified": false, "phone_verified": false}	email	2026-02-05 06:26:50.439448+00	2026-02-05 06:26:50.439538+00	2026-02-05 06:26:50.439538+00	551d3f83-66c9-4431-99a8-c390d73ace7f
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

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type) FROM stdin;
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
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
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
00000000-0000-0000-0000-000000000000	35c1bb89-4881-4798-a257-8b714d2017dd	authenticated	authenticated	admin@ilovejinshasan.org	$2a$10$2TONhcjWsJNNuXT80dHTpuqP5EEUUwOewbk5v4/ftaD9nlxFh04MC	2026-02-05 06:26:50.462884+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"role": "admin", "email_verified": true}	\N	2026-02-05 06:26:50.404673+00	2026-02-05 06:26:50.465757+00	\N	\N			\N		0	\N		\N	f	\N	f
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
-- Data for Name: event_interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_interests (id, event_id, volunteer_id, created_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, project_id, title, date, role_needed, description, created_at, banner_url) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, message, is_read, type, created_at) FROM stdin;
\.


--
-- Data for Name: project_volunteers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_volunteers (id, project_id, volunteer_id, assigned_at, status) FROM stdin;
739df2f7-c16b-4514-959c-15e7e1163514	ba3be29b-823c-4421-ad02-7a6677865f22	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-02-02 12:55:05.804763+00	approved
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, project_code, title, description, banner_url, manager_id, created_at, updated_at, status) FROM stdin;
deed7a1e-10f7-4f6a-906a-aac54bb1f619	PRJ-001	Digital Jainism	Spreading the timeless wisdom of Jainism through modern channels. Our Promotion of Jainism on Social Media, primarily through the Instagram page @ilovejinshasan, seeks to inspire a global audience by highlighting the profound values and principles of Jain philosophy. Through engaging content  we aim to promote awareness and foster a deeper connection to Jainism. Our social media presence is steadily growing, empowering individuals to embrace teachings if Jainism in everyday life.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.7966996394579555.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-02-01 15:26:54.23616+00	2026-02-01 15:26:54.23616+00	active
c3d175f3-dd6e-4000-bd32-ebe20b589705	PRJ-002	Veer Vanshaj: Self Defence Workshop	The Veer Vanshaj - Self Defence Workshop empowers individuals, especially women, with the skills and confidence to protect themselves in any situation. The initiative offers practical self-defence training, focusing on building physical strength, awareness, and mental resilience. Launched with the aim of ensuring safety and independence, the workshops have already gained momentum with multiple successful sessions. Our future vision includes expanding this impactful program across Mumbai, reaching more individuals in need of self-defence training.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.44102312685847256.jpeg	0e833c46-ec3f-4681-8dbc-2bec029d8db1	2026-02-01 15:45:33.519938+00	2026-02-01 15:45:33.519938+00	upcoming
134f3fc8-8546-4bb3-b39a-e671bfcb0808	PRJ-003	Jainific	Jainific is an innovative exhibition designed to explore the intersection of ancient Jain principles and modern science. The exhibition features interactive models, charts, and experiments that demonstrate the compatibility of Jain teachings with scientific concepts.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.05016668586183837.jpeg	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	2026-02-01 15:57:18.403327+00	2026-02-01 15:57:18.403327+00	upcoming
1736f19b-b817-4bc5-888b-a412f464e03a	PRJ-004	Blogs	Writing content for blogs on Jainism and related topics. These blogs are published on our website ilovejinshasan.org	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.08290226501735143.jpeg	03a59a7d-da67-44b8-88f7-1a0fbe44f706	2026-02-01 16:11:09.638868+00	2026-02-01 16:11:09.638868+00	active
e371d3f0-7356-4f5b-8616-300df65bfea7	PRJ-005	Sanskaar Library	The Sanskaar Library is an initiative designed to nurture reading habits and instill moral values in children through curated books. By creating a rotating library system that promotes morals, ethics, principles of Jainism and personal growth, we aim to build a foundation of knowledge and integrity among the younger generation.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.4307583412898245.jpeg	e243534f-6a49-436d-b637-a050b1e32de0	2026-02-02 12:46:26.885341+00	2026-02-02 12:46:26.885341+00	active
ba3be29b-823c-4421-ad02-7a6677865f22	PRJ-006	Website Development	Developing and improving our official website into a comprehensive repository of Jain teachings, principles, stories, blogs, articles, and literature. Volunteers contribute by enhancing structure, usability, and content presentation to ensure all resources are available in one accessible digital space.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.5921959842517635.jpeg	0e833c46-ec3f-4681-8dbc-2bec029d8db1	2026-02-02 12:55:05.40945+00	2026-02-02 12:55:05.40945+00	active
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, title, description, project_id, event_id, assignee_id, deadline, status, created_at, rating, feedback_comments) FROM stdin;
\.


--
-- Data for Name: timesheets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.timesheets (id, volunteer_id, project_id, event_id, role, hours, work_mode, description, status, date_worked, created_at) FROM stdin;
\.


--
-- Data for Name: volunteers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.volunteers (id, ilj_id, first_name, middle_name, last_name, dob, age, gender, mobile_number, email, address_line1, address_line2, district, city, state, pincode, country, dharmik_studies, qualification, specialization, occupation, occupation_other, hobbies, skills, referred_by, volunteering_preference1, volunteering_preference2, volunteering_preference3, availability_days, time_commitment, participation_mode, password_hash, created_at, updated_at, additional_areas, sangh_name, kalyan_mitra, team_leader_for, rank, designation) FROM stdin;
7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	ILJ-008	Meet	Bhavesh	Mehta	2005-07-11	20	Male	9172387009	mehtameet115@gmail.com	flat 112 6th floor b-39 mayuri bldg	anand nagar dahisar ( east )	Dahisar	mumbai	Maharashtra	400068	India	\N	B.tech	computer engg	Student	\N	\N	\N	\N	IT & Technical Support	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$QVESi9vOlOWMKqKlaIPnIeIb7YYoC4T4dsbE.ZJC6NLEyB4qeELMW	2026-02-01 18:08:30.862076+00	2026-02-05 06:44:09.82679+00	{}	\N	\N	\N	Intern	\N
0e833c46-ec3f-4681-8dbc-2bec029d8db1	ILJ-004	Smit	\N	Mehta	2000-09-12	25	Male	9022566694	smitmehta50@gmail.com	B.202 Rajeshwari Deep, Ganesh mandir road	Dombivli East	Thane	Dombivli	Maharastra	421201	India	\N	B.Tech	IT	Working Professional	\N	\N	\N	\N	Event Planning & Management	\N	\N	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$6g3DcNvf8R0si234MSjXwujGwLHKZytLCBgWLwH2Gq7joNtpl2oJm	2026-02-01 15:33:50.735119+00	2026-02-05 06:41:41.928014+00	{}	Neminath Jain Sangh Dombivli	\N	Event Planning & Management|IT & Technical Support	Intern	Team Leader
f51b0111-f04d-453a-b6c0-60d9832fba6b	ILJ-002	Aayushi	\N	Sanghavi	2004-08-05	21	Female	8657634527	pritiaayu1@gmail.com	8, Virat Chs	Tilak School Road	Thane	Dombivli	Maharashtra	421201	India	5 Pratikraman. 9 Smaran (except Kalyanmandir)	Bcom.(Completed), Actuarial Science (Pursuing)	Actuarial Science	Student	\N	Drawing, Painting, Listening Music	Graphics, Acting, Public Speaking, AI	\N	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Flexible	\N	Voluntary (Seva-based)	$2a$06$MQ1/wlvTHU9ok7JqDcTGu.ltDD5dsDhZkGt28/.d2agVfQH77PnG.	2026-02-01 15:17:23.134426+00	2026-02-05 06:41:41.928014+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	\N	\N	Public Speaking, Acting & Stage Activities|Graphic Design & Video Editing|Photography & Videography	Intern	Team Leader
dd02c815-1f54-4572-9830-aba8c9aaa18e	ILJ-011	Test	\N	Security	2000-01-01	25	Male	9000000000	securitytest@example.com	Test Address Line 1	Test Address Line 2	Test District	Test City	Test State	000000	India	\N	Testing	Security	Tester	\N	\N	\N	\N	Security Testing	\N	\N	Weekends	\N	Test Mode	$2a$06$caDOPZ1TF2kynK5Wc1PpduosMmvcV1hF764fJYN4P//eCCrnuzi7C	2026-02-02 06:31:35.768807+00	2026-02-05 06:41:41.928014+00	\N	\N	\N	\N	Intern	\N
03a59a7d-da67-44b8-88f7-1a0fbe44f706	ILJ-003	Jainam	Nalinbhai 	Sheth	2000-03-04	25	Male	8879355429	cajainam04@gmail.com	302, Arnath	Sarvoday Nagar 	Mumbai 	Mulund 	Maharashtra	400080	India	Karmgranth	CA	Accounts	Working Professional	\N	Reading 	\N	Jainam Mehta	Public Speaking, Acting & Stage Activities	Research & Documentation	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$kVLflD31LJIirjJKSYQVNe76PCBPL4FAF6UW2x1pleGSBHbW42W6i	2026-02-01 15:25:16.393861+00	2026-02-05 06:41:41.928014+00	{"Defending Jainism on Social media & digital platforms"}	Sarvoday sangh 	\N	Research & Documentation	Intern	Team Leader
7e72384f-5a73-498c-b82e-57dd17a6ea18	ILJ-007	Charmi	Pritesh 	Dedhia	2004-02-24	21	Female	8169639689	charmipdedhia@gmail.com	B-205, Surekha bhuvan	Tilak Nagar Post Office, Dr.R.P.Road	Thane 	Dombivli East 	Maharashtra 	421201	India 	\N	MBA	Marketing 	Student	\N	Teaching, networking	\N	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$2QSvFAjr30hBWY/yHEJT4Oocbj8ObLylufJ4Z26Zo5OWql.vLjaje	2026-02-01 16:58:20.314585+00	2026-02-05 06:41:41.928014+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	\N	\N	Marketing & Outreach	Intern	Team Leader
043bde9c-9ebb-4e8c-8ccb-a975a83eec39	ILJ-005	Labdhi	Mehul	Shah	2000-12-08	25	Female	7028551745	labdhishah128@gmail.com	C-15 Aakardeep Chs, Agarkar Road	Dombivli East	Thane	Mumbai	Maharashtra	421201	India	Navtatva	Advocate	Law	Working Professional	\N	Public speaking.	Compliance and Legal Research	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	Marketing & Outreach	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$hO8WrmzFU1jau5kuW3l5Ueu2isMo8QZ6LxkmWcHcYc7DrB2KOQBde	2026-02-01 15:37:16.131539+00	2026-02-05 06:41:41.928014+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Shri Jay Naminath Swethambar murtipujak Jain Sangh Dombivli East.	\N	\N	Intern	\N
4de93087-ee99-48dc-b3a5-4339c8da81ec	ILJ-006	Jeel	\N	Doshi	1998-11-24	27	Female	9022756278	jdoshi154@gmail.com	A/2 swastik building	Savarkar road	Thane	Dombivli	Maharashtra 	421201	India 	\N	Bcom	Commerce	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	Graphic Design & Video Editing	\N	Flexible	3 hours	Voluntary (Seva-based)	$2a$06$FvEYhrt6vS/GxiOzHlnFtesW68brEr32pI.xq6THACqOxE7Pn7szS	2026-02-01 16:34:33.092509+00	2026-02-05 06:41:41.928014+00	{"Defending Jainism on Social media & digital platforms"}	Neminath jain Sangh nehru maidan 	\N	Pathshala & Educational Activities	Intern	Team Leader
a59d9b96-eccd-4b3a-a15f-ad6f693013a7	ILJ-001	Jainam	\N	Mehta	1999-06-05	26	Male	9167180806	jainammehta519@gmail.com	A-302, Umiya Parijat CHS, Building No. 37	Guru Dattta Mandir Road, Pant Nagar	Mumbai	Ghatkopar (East)	Maharashtra	400075	India	\N	Chartered Accountant	GST	Working Professional	\N	\N	\N	\N	Content Writing (Articles, Blogs, Scripts)	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$/hUFRVODr1rj5v4Uwyf5YeOLyUVTiSmRwq1ywQwcTmc12N/HTFbp6	2026-02-01 15:06:01.194829+00	2026-02-05 06:41:41.928014+00	{}	\N	\N	Content Writing (Articles, Blogs, Scripts)	Intern	Team Leader
e243534f-6a49-436d-b637-a050b1e32de0	ILJ-012	Bhavya	Rajendra	Sanghavi	2001-08-28	24	Female	+918691904575	bhavyarsanghavi99@gmail.com	A/304, jagannath's commerce plaza	Manpada road	Thane	Dombivli east	Maharashtra	421201	India	\N	CA	Finance	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$7n/D1CqJ.0OT6M0zLy9FvOM/g8Fo1aVNg4dHo8coj/jDBSHSN9fG2	2026-02-02 08:28:10.500315+00	2026-02-05 06:41:41.928014+00	{}	\N	\N	\N	Intern	\N
55ca6718-5a82-408d-800d-86cc3c49bbca	ILJ-013	Disha	Sachin 	Gandhi	2006-03-01	19	Female	9969612883	dishagandhi136@gmail.com	207, neelkanth chs fateh ali road behind kdmc office  	Near pp chambers,above Bharat co operative bank 	Thane	Dombivli	Maharashtra 	421201	India	\N	SYBAF 	Accounting and finance 	Student	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	\N	Flexible	5 hours 30 mins	Voluntary (Seva-based)	$2a$06$dG2e9RHJzqc9ThVMvlFYG.F8WSeAwjUVAgYYN/.qkCiTSTrsphibK	2026-02-03 15:40:08.070894+00	2026-02-05 06:41:41.928014+00	{}	Nehru maidan(rakhi) Sangh 	\N	\N	Intern	\N
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
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2026-01-27 05:58:20.30977
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-01-27 05:58:20.344065
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-01-27 05:58:20.358263
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-01-27 05:58:20.363103
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2026-01-27 05:58:20.369528
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-01-27 05:58:20.376027
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-01-27 05:58:20.381054
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2026-01-27 05:58:20.386251
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2026-01-27 05:58:20.391421
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
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2026-01-27 05:58:20.519383
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2026-01-27 05:58:20.536016
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2026-01-27 05:58:20.546789
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2026-01-27 05:58:20.556787
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2026-01-27 05:58:20.563578
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2026-01-27 05:58:20.570723
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2026-01-27 05:58:20.579116
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2026-01-27 05:58:20.586233
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2026-01-27 05:58:20.588244
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2026-01-27 05:58:20.594383
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2026-01-27 05:58:20.600062
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-01-27 05:58:20.606949
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2026-01-27 05:58:20.613075
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2026-01-27 05:58:20.624483
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2026-01-27 05:58:20.630146
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2026-01-27 05:58:20.638233
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2026-01-27 05:58:20.643789
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2026-01-27 05:58:20.650114
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-01-27 05:58:20.656959
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-01-27 05:58:20.66357
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-01-27 05:58:20.674895
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-01-27 05:58:20.679971
48	iceberg-catalog-ids	2666dff93346e5d04e0a878416be1d5fec345d6f	2026-01-27 05:58:20.684887
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-01-27 05:58:20.700169
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
72e27a5f-755e-4b82-b6e5-cbba9405b6e0	project-banners	0.706425260224533.jpg	\N	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-28T19:27:10.000Z", "contentLength": 251852, "httpStatusCode": 200}	f13f4acd-bd68-4ae7-96c9-15af2f3a105f	\N	{}	1
aa35cd30-0cfd-4a0a-88c6-ff7822b3b0c1	project-banners	0.7498233647525495.jpg	\N	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T07:29:08.000Z", "contentLength": 251852, "httpStatusCode": 200}	47a0c27e-9b47-4fe6-abd9-8099d89fcd5c	\N	{}	1
34fbbf00-3fff-4697-8b40-4a59756133fb	event-banners	1769679074311.jpg	\N	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T09:31:16.000Z", "contentLength": 251852, "httpStatusCode": 200}	bc02545e-4c51-4a3b-9870-7978f06374db	\N	{}	1
4d79fac5-70ac-4b6e-9d87-b31dd46649e7	event-banners	1769685751265.jpg	\N	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:22:32.000Z", "contentLength": 251852, "httpStatusCode": 200}	57132961-4797-47e2-aa99-eb20e384b5b1	\N	{}	1
bcb24dd2-ed2f-4a6e-a7fc-5c341fcb673f	event-banners	1769686948705.jpg	\N	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:42:30.000Z", "contentLength": 251852, "httpStatusCode": 200}	0b984452-cd33-4a33-a986-ef81da510840	\N	{}	1
29d2010d-8127-449a-97a6-c1fcd352667c	project-banners	0.7966996394579555.jpeg	\N	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	{"eTag": "\\"16a81774f0e4709822c4e1238625879a\\"", "size": 107144, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:26:54.000Z", "contentLength": 107144, "httpStatusCode": 200}	9581a682-011c-4e1e-90cc-40180be59af6	\N	{}	1
66c54576-ed22-4914-a88e-a21b75227ecd	project-banners	0.44102312685847256.jpeg	\N	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	{"eTag": "\\"a450795afdde0fc5633a3b09102e814b\\"", "size": 93140, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:45:34.000Z", "contentLength": 93140, "httpStatusCode": 200}	15ecb65b-6003-4d81-bde7-74edbf997542	\N	{}	1
35504c10-c092-4c9e-99dc-829035be3264	project-banners	0.05016668586183837.jpeg	\N	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	{"eTag": "\\"7d9c5a4e3d7c6bf87c0346ca9ec3ae8a\\"", "size": 108083, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:57:19.000Z", "contentLength": 108083, "httpStatusCode": 200}	b5053847-6bc8-4fcb-96ad-dfa41fe19de2	\N	{}	1
1a44bd0e-7c65-41de-8754-31a4a951cdcc	project-banners	0.08290226501735143.jpeg	\N	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	{"eTag": "\\"c71325b64f697407be23c2db3b2e6a1e\\"", "size": 110470, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T16:11:09.000Z", "contentLength": 110470, "httpStatusCode": 200}	730b87fd-aba8-40f3-b165-d70fbc9ce907	\N	{}	1
ddf89632-3734-460a-9a83-09fb8286b662	project-banners	0.4307583412898245.jpeg	\N	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	{"eTag": "\\"2885aa813f3d9c184ed2f9e9cc1d8db2\\"", "size": 116818, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:46:27.000Z", "contentLength": 116818, "httpStatusCode": 200}	769d0dc0-3fb2-424d-88a2-d50233e60460	\N	{}	1
e828463f-762b-425c-9753-48f49a1788e0	project-banners	0.5921959842517635.jpeg	\N	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	{"eTag": "\\"9d810b69b13ff72672c5e1bbba2dd7d4\\"", "size": 121719, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:55:05.000Z", "contentLength": 121719, "httpStatusCode": 200}	4b4fcfde-602e-46df-83d7-990ffd85fbb9	\N	{}	1
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
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
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: volunteers_ilj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.volunteers_ilj_id_seq', 13, true);


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
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


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
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


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
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


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
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: volunteers set_ilj_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_ilj_id BEFORE INSERT ON public.volunteers FOR EACH ROW EXECUTE FUNCTION public.generate_ilj_id();


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
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


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
-- Name: events events_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.volunteers(id) ON DELETE CASCADE;


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
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


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
-- Name: timesheets Admin Full Access Timesheets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin Full Access Timesheets" ON public.timesheets USING (public.is_admin());


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
-- Name: volunteers Allow Registration; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow Registration" ON public.volunteers FOR INSERT WITH CHECK (true);


--
-- Name: volunteers Allow read own data; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow read own data" ON public.volunteers FOR SELECT USING (true);


--
-- Name: announcement_interests Managers can view interests for their announcements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Managers can view interests for their announcements" ON public.announcement_interests FOR SELECT USING (true);


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
-- Name: announcement_interests Volunteers can view own interests; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Volunteers can view own interests" ON public.announcement_interests FOR SELECT USING ((auth.uid() = volunteer_id));


--
-- Name: announcement_interests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.announcement_interests ENABLE ROW LEVEL SECURITY;

--
-- Name: announcements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

--
-- Name: event_interests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.event_interests ENABLE ROW LEVEL SECURITY;

--
-- Name: events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: project_volunteers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.project_volunteers ENABLE ROW LEVEL SECURITY;

--
-- Name: projects; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: timesheets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.timesheets ENABLE ROW LEVEL SECURITY;

--
-- Name: volunteers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;

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
-- Name: objects Public Access; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING ((bucket_id = 'project-banners'::text));


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
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

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

\unrestrict D8YFKgMWpwwvHy6QI4o1lqHH8r8Of8NwZVOXBJxdMCs5NXxa988aVzCoDtFeHuG

