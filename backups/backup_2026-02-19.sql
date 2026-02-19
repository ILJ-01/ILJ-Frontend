--
-- PostgreSQL database dump
--

\restrict EQ3ogkajYNChHG9x0FtToJ1RdYtFrbOnHbAv3Ad9wYyvE1xoVxd6hZk2UgjDytr

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.8 (Ubuntu 17.8-1.pgdg24.04+1)

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
DROP POLICY IF EXISTS "Authenticated View Interests" ON public.announcement_interests;
DROP POLICY IF EXISTS "Authenticated Users View All Volunteers" ON public.volunteers;
DROP POLICY IF EXISTS "Authenticated Users View All Project Volunteers" ON public.project_volunteers;
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
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_user_id_fkey;
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
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS update_volunteers_updated_at ON public.volunteers;
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
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_user_id_role_key;
ALTER TABLE IF EXISTS ONLY public.app_roles DROP CONSTRAINT IF EXISTS app_roles_pkey;
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
DROP SEQUENCE IF EXISTS public.ilj_id_seq;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.event_interests;
DROP TABLE IF EXISTS public.app_roles;
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
DROP FUNCTION IF EXISTS storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_prefixes(name text);
DROP FUNCTION IF EXISTS storage.get_prefix(name text);
DROP FUNCTION IF EXISTS storage.get_level(name text);
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.delete_leaf_prefixes(bucket_ids text[], names text[]);
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
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
-- Name: ilj_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ilj_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


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
    status text DEFAULT 'upcoming'::text,
    visibility text DEFAULT 'public'::text,
    CONSTRAINT check_visibility_projects CHECK ((visibility = ANY (ARRAY['public'::text, 'private'::text])))
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
b647579b-981c-47ed-85b7-a29917a0f399	2026-02-17 14:27:10.574273+00	2026-02-17 14:27:10.574273+00	password	2f17dc85-a6c3-4203-93dd-77225ff2cd6f
f90d9587-1898-4587-be00-6e94fb018722	2026-02-18 13:40:20.222042+00	2026-02-18 13:40:20.222042+00	password	eb84114a-328d-43e2-b9c4-0cf839b2a8bd
09efac32-adb8-469b-b7f2-dc02c2a49a56	2026-02-18 15:43:23.294783+00	2026-02-18 15:43:23.294783+00	password	2c2046fe-e997-460e-932c-195ee6f99e2b
01c2d3e6-6ff1-45a8-97e3-97054d8ad161	2026-02-18 19:43:51.631226+00	2026-02-18 19:43:51.631226+00	password	ad3bd5bb-564e-4318-baac-a91f3a0698b0
8ef3ce2a-34a8-4392-ae9d-c786361f91a3	2026-02-19 05:33:11.495155+00	2026-02-19 05:33:11.495155+00	password	815e1970-fd08-4503-b04a-1f358919547b
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
00000000-0000-0000-0000-000000000000	91	wut5vya5yk6x	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-02-17 14:27:10.54502+00	2026-02-18 07:08:48.617389+00	\N	b647579b-981c-47ed-85b7-a29917a0f399
00000000-0000-0000-0000-000000000000	92	2teyblsh2dq7	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-02-18 07:08:48.637901+00	2026-02-18 12:40:44.900648+00	wut5vya5yk6x	b647579b-981c-47ed-85b7-a29917a0f399
00000000-0000-0000-0000-000000000000	94	ndgbksvxo5lr	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-02-18 13:40:20.186582+00	2026-02-18 13:40:20.186582+00	\N	f90d9587-1898-4587-be00-6e94fb018722
00000000-0000-0000-0000-000000000000	93	ex2t226kmwx4	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-02-18 12:40:44.925599+00	2026-02-18 15:42:41.030952+00	2teyblsh2dq7	b647579b-981c-47ed-85b7-a29917a0f399
00000000-0000-0000-0000-000000000000	95	gadxvh3rhntt	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-02-18 15:42:41.052658+00	2026-02-18 15:42:41.052658+00	ex2t226kmwx4	b647579b-981c-47ed-85b7-a29917a0f399
00000000-0000-0000-0000-000000000000	96	cogmqutjvi2g	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-02-18 15:43:23.293362+00	2026-02-19 05:32:04.915543+00	\N	09efac32-adb8-469b-b7f2-dc02c2a49a56
00000000-0000-0000-0000-000000000000	98	2eb7hypglxt7	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-02-19 05:32:04.925817+00	2026-02-19 05:32:04.925817+00	cogmqutjvi2g	09efac32-adb8-469b-b7f2-dc02c2a49a56
00000000-0000-0000-0000-000000000000	99	ge2dekonnal4	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-02-19 05:33:11.493019+00	2026-02-19 05:33:11.493019+00	\N	8ef3ce2a-34a8-4392-ae9d-c786361f91a3
00000000-0000-0000-0000-000000000000	97	auayju3synh5	35c1bb89-4881-4798-a257-8b714d2017dd	t	2026-02-18 19:43:51.591655+00	2026-02-19 06:48:28.085801+00	\N	01c2d3e6-6ff1-45a8-97e3-97054d8ad161
00000000-0000-0000-0000-000000000000	100	g7keu7upfdwm	35c1bb89-4881-4798-a257-8b714d2017dd	f	2026-02-19 06:48:28.105996+00	2026-02-19 06:48:28.105996+00	auayju3synh5	01c2d3e6-6ff1-45a8-97e3-97054d8ad161
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
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
f90d9587-1898-4587-be00-6e94fb018722	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-18 13:40:20.147963+00	2026-02-18 13:40:20.147963+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	103.249.251.128	\N	\N	\N	\N	\N
b647579b-981c-47ed-85b7-a29917a0f399	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-17 14:27:10.513786+00	2026-02-18 15:42:41.085165+00	\N	aal1	\N	2026-02-18 15:42:41.083918	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36	106.192.56.184	\N	\N	\N	\N	\N
09efac32-adb8-469b-b7f2-dc02c2a49a56	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-18 15:43:23.28534+00	2026-02-19 05:32:04.940421+00	\N	aal1	\N	2026-02-19 05:32:04.9398	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36	106.192.62.175	\N	\N	\N	\N	\N
8ef3ce2a-34a8-4392-ae9d-c786361f91a3	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-19 05:33:11.485166+00	2026-02-19 05:33:11.485166+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36	106.192.62.175	\N	\N	\N	\N	\N
01c2d3e6-6ff1-45a8-97e3-97054d8ad161	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-18 19:43:51.548593+00	2026-02-19 06:48:28.135628+00	\N	aal1	\N	2026-02-19 06:48:28.135517	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	152.58.1.159	\N	\N	\N	\N	\N
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
\N	41fcbca1-3193-42ce-8585-95372b4b9d52	authenticated	authenticated	meets.studentlife@gmail.com	$2a$10$9cFA3i./CuWiE7tgoRE1m.8U2vSw2IxZ8/6SfY11kD/7drgVL85DG	2026-02-07 16:44:00.216534+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-014", "last_name": "Test ", "first_name": "Test "}	\N	2026-02-07 16:44:00.216534+00	2026-02-08 17:51:14.217114+00	\N	\N			\N		0	\N		\N	f	\N	f
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
\N	3b05ba3c-4755-4104-a7b9-d7f7846cc4be	authenticated	authenticated	dhiaanjain2@gmail.com	$2a$06$8SQFqpTcPGM/2v7.dAb61.RHCYtBTVI3OMmc1fRnV7akXuBtxADGC	2026-02-10 09:53:38.722481+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-029", "app_role": "volunteer", "last_name": "Jain", "first_name": "Dhiaan"}	\N	2026-02-10 09:53:38.722481+00	2026-02-10 09:53:38.722481+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	9a067c77-bb95-44cc-812e-4557ac17f80a	authenticated	authenticated	aayushishah1556@gmail.com	$2a$06$kTXLpLNQcgbjrgxAPTiOVetW2f.I7gRwlXGVsnKfod4B0bNTL2Fly	2026-02-10 10:10:54.446122+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-030", "app_role": "volunteer", "last_name": "Shah", "first_name": "Aayushi"}	\N	2026-02-10 10:10:54.446122+00	2026-02-10 10:10:54.446122+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	b8f6d90e-b692-4a8a-8cbc-17909331fa73	authenticated	authenticated	ankitsheth8@gmail.com	$2a$06$xu3QPIgahZ6x3JJ6Iszjd.YIoyXU57DBWFS6xuFs7.ATd5DBoEx1a	2026-02-10 10:28:33.582157+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-031", "app_role": "volunteer", "last_name": "Sheth", "first_name": "Ankit"}	\N	2026-02-10 10:28:33.582157+00	2026-02-10 10:28:33.582157+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	60084f34-305e-42b4-8330-70bba97a2126	authenticated	authenticated	yogitapd15@gmail.com	$2a$06$1q3ofYonfetMXYmujRZpF.WTry6Fjkwl3sRdwJlq0yk4uSnLUyFK.	2026-02-10 10:32:49.505559+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-032", "app_role": "volunteer", "last_name": "Sheth", "first_name": "Yogita"}	\N	2026-02-10 10:32:49.505559+00	2026-02-10 10:32:49.505559+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	authenticated	authenticated	yashvi.sanghavi.dombivli@gmail.com	$2a$06$1JUZcxxVb8DWivUdSbmz3eRgqoRZgtCoWdEmASLhdDa0KEff5Wfwy	2026-02-10 14:20:52.226662+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-033", "app_role": "volunteer", "last_name": "Sanghavi", "first_name": "Yashvi"}	\N	2026-02-10 14:20:52.226662+00	2026-02-10 14:20:52.226662+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	4842d49f-c3ea-47a4-bfee-03837bec04a5	authenticated	authenticated	mehtajiana7@gmail.com	$2a$06$a1c05hspLAV/5RGA8jtcyOWk6ixhuw0x4ape/BzkHo1V4ioSQMGAW	2026-02-12 06:31:29.839705+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-047", "app_role": "volunteer", "last_name": "Mehta", "first_name": "Jiana"}	\N	2026-02-12 06:31:29.839705+00	2026-02-12 06:31:29.839705+00	\N	\N			\N		0	\N		\N	f	\N	f
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
\N	0c6384b4-15bd-42b1-a978-317e1d163f8d	authenticated	authenticated	arpitadand5002@gmail.com	$2a$06$0qQJ/B9Q35Pt4nLrzqLuUuC664uLTDdl9asTDUZFIG.Xg25BViAPS	2026-02-12 11:04:39.970126+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-051", "app_role": "volunteer", "last_name": "Dand", "first_name": "Arpita"}	\N	2026-02-12 11:04:39.970126+00	2026-02-12 11:06:01.926167+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d176663a-6707-4d57-bf50-35e3e7b4a964	authenticated	authenticated	mana88shah@gmail.com	$2a$06$r0nAQBivl8GS8k2wJzGD/OmXAyxyR5DTeLlNuT0Jdl9fAFNJqUJW2	2026-02-12 15:47:50.461262+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-052", "app_role": "volunteer", "last_name": "Shah", "first_name": "Manali "}	\N	2026-02-12 15:47:50.461262+00	2026-02-12 15:47:50.461262+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	34e80f19-ddbe-46bf-9a65-83c81104b974	authenticated	authenticated	labdhi1608@gmail.com	$2a$06$r8M0hmyRl2MIQMu25.auz.sMgWhtLImLJ.IqLUTrXunzpjy2I3QSm	2026-02-19 05:30:40.91807+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-069", "app_role": "volunteer", "last_name": "Shah", "first_name": "Labdhi "}	\N	2026-02-19 05:30:40.91807+00	2026-02-19 05:30:40.91807+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	643db578-c5a7-422f-ad51-1ba67a0db590	authenticated	authenticated	dhruvgandhi0506@gmail.com	$2a$06$Vsjhrv5Lf68w8JwnsgFiAOO9T6p69P4QI9RQofWxkAaRfInGzDCG6	2026-02-18 15:58:57.376591+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-062", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Dhruv "}	\N	2026-02-18 15:58:57.376591+00	2026-02-18 15:58:57.376591+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	authenticated	authenticated	prisha.jain@somaiya.edu	$2a$06$VYcjFo/roqRG.j25GEe5nuuiJA1L6pAx/8J4PQNKBTG8ZpVmmyESO	2026-02-13 09:50:12.716586+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-053", "app_role": "volunteer", "last_name": "Jain ", "first_name": "Prisha "}	\N	2026-02-13 09:50:12.716586+00	2026-02-13 09:50:12.716586+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	87f3685f-9952-49ed-8c9f-b7f9a5fbf908	authenticated	authenticated	khushimjain08@gmail.com	$2a$06$36K6tRBc25ldVAv7e84cOeaCCezEse3H7JKetfk2p46blUjrYHXc.	2026-02-13 13:38:15.607808+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-054", "app_role": "volunteer", "last_name": "Jain", "first_name": "Khushi"}	\N	2026-02-13 13:38:15.607808+00	2026-02-13 13:38:15.607808+00	\N	\N			\N		0	\N		\N	f	\N	f
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
\N	2a495f49-f4e5-4dfa-879d-50e43fcca74e	authenticated	authenticated	dhruvigandhi4617@gmail.com	$2a$06$BrDt8JPLwmL1mkmfpYAlD.enwy1lpdTyv5r/lgSL54nXlnqwXpf2i	2026-02-18 19:18:43.510185+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"ilj_id": "ILJ-068", "app_role": "volunteer", "last_name": "Gandhi", "first_name": "Dhruvi "}	\N	2026-02-18 19:18:43.510185+00	2026-02-18 19:18:43.510185+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	35c1bb89-4881-4798-a257-8b714d2017dd	authenticated	authenticated	admin@ilovejinshasan.org	$2a$06$twMqEqICvkr0Acnn8sjyMux7DwYqwg1h88J2j2RDowgaWMYTT1MWO	2026-02-05 06:26:50.462884+00	\N		\N		\N			\N	2026-02-19 05:33:11.482753+00	{"provider": "email", "providers": ["email"]}	{"role": "admin", "email_verified": true}	\N	2026-02-05 06:26:50.404673+00	2026-02-19 06:48:28.121486+00	\N	\N			\N		0	\N		\N	f	\N	f
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
ec4a7a6f-7f0d-478d-87c6-cc4e729800aa	c3d175f3-dd6e-4000-bd32-ebe20b589705	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-02-08 13:31:49.363462+00	pending
ab5b81c6-81f7-4996-b53a-6d918e8ac08f	deed7a1e-10f7-4f6a-906a-aac54bb1f619	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-02-09 07:46:12.067574+00	pending
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, project_code, title, description, banner_url, manager_id, created_at, updated_at, status, visibility) FROM stdin;
deed7a1e-10f7-4f6a-906a-aac54bb1f619	PRJ-001	Digital Jainism	Spreading the timeless wisdom of Jainism through modern channels. Our Promotion of Jainism on Social Media, primarily through the Instagram page @ilovejinshasan, seeks to inspire a global audience by highlighting the profound values and principles of Jain philosophy. Through engaging content  we aim to promote awareness and foster a deeper connection to Jainism. Our social media presence is steadily growing, empowering individuals to embrace teachings if Jainism in everyday life.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.7966996394579555.jpeg	f51b0111-f04d-453a-b6c0-60d9832fba6b	2026-02-01 15:26:54.23616+00	2026-02-01 15:26:54.23616+00	active	public
c3d175f3-dd6e-4000-bd32-ebe20b589705	PRJ-002	Veer Vanshaj: Self Defence Workshop	The Veer Vanshaj - Self Defence Workshop empowers individuals, especially women, with the skills and confidence to protect themselves in any situation. The initiative offers practical self-defence training, focusing on building physical strength, awareness, and mental resilience. Launched with the aim of ensuring safety and independence, the workshops have already gained momentum with multiple successful sessions. Our future vision includes expanding this impactful program across Mumbai, reaching more individuals in need of self-defence training.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.44102312685847256.jpeg	0e833c46-ec3f-4681-8dbc-2bec029d8db1	2026-02-01 15:45:33.519938+00	2026-02-01 15:45:33.519938+00	upcoming	public
134f3fc8-8546-4bb3-b39a-e671bfcb0808	PRJ-003	Jainific	Jainific is an innovative exhibition designed to explore the intersection of ancient Jain principles and modern science. The exhibition features interactive models, charts, and experiments that demonstrate the compatibility of Jain teachings with scientific concepts.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.05016668586183837.jpeg	043bde9c-9ebb-4e8c-8ccb-a975a83eec39	2026-02-01 15:57:18.403327+00	2026-02-01 15:57:18.403327+00	upcoming	public
1736f19b-b817-4bc5-888b-a412f464e03a	PRJ-004	Blogs	Writing content for blogs on Jainism and related topics. These blogs are published on our website ilovejinshasan.org	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.08290226501735143.jpeg	03a59a7d-da67-44b8-88f7-1a0fbe44f706	2026-02-01 16:11:09.638868+00	2026-02-01 16:11:09.638868+00	active	public
e371d3f0-7356-4f5b-8616-300df65bfea7	PRJ-005	Sanskaar Library	The Sanskaar Library is an initiative designed to nurture reading habits and instill moral values in children through curated books. By creating a rotating library system that promotes morals, ethics, principles of Jainism and personal growth, we aim to build a foundation of knowledge and integrity among the younger generation.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.4307583412898245.jpeg	e243534f-6a49-436d-b637-a050b1e32de0	2026-02-02 12:46:26.885341+00	2026-02-02 12:46:26.885341+00	active	public
44528d4e-5308-46ba-aefe-275f5fd1dc71	PRJ-007	Admin work	Admin work not related to any particular project.	\N	a59d9b96-eccd-4b3a-a15f-ad6f693013a7	2026-02-08 12:29:24.547887+00	2026-02-08 12:29:24.547887+00	active	private
9d2e0a72-e048-4e6d-90ab-7930a459f941	PRJ-006	Website development 	Developing and improving our official website into a comprehensive repository of Jain teachings, principles, stories, blogs, articles, and literature. Volunteers contribute by enhancing structure, usability, and content presentation to ensure all resources are available in one accessible digital space.	https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-banners/0.9836200471240258.jpg	0e833c46-ec3f-4681-8dbc-2bec029d8db1	2026-02-08 14:19:08.079624+00	2026-02-08 14:19:08.079624+00	active	private
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, title, description, project_id, event_id, assignee_id, deadline, status, created_at, rating, feedback_comments) FROM stdin;
14de9568-d6a3-40ac-8273-12d3a4066e24	Website 	1.  Add an option in volunteer dashboard to view list of all volunteers to whom he/she is tagged as kalyan mitra. Similar to teamleader hub.\n\n2. Remove brochure\n\n3. Add new team/area of interest.\nTitle: Inhouse Pathshala and Home Schooling.\nDescription: Religious and academic teaching - virtually or in person. This initiative will eventually evolve into a comprehensive home schooling model.\nTeam leader: Jainam Mehta\nAdd three options/sub-team for volunteers interested to join this team - Religious teaching, academic teaching, both.\n\n4. Project managers will approve timesheets of respective volunteers and timesheets of project managers will be approved by Admin.\n\n5. Change password of admin portal. Something not too easy like ilovejinshan.\n\n6. When we click on 'login to apply' in a porject, it takes us to the home page. Instead the login / register window should pop up.\n\n7. Change team leader of content writing to Aayushi Shah from Jainam Mehta\n\n8. Change the hours required for Associate level to 20 from 10.	9d2e0a72-e048-4e6d-90ab-7930a459f941	\N	7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	2026-02-15 21:01:00+00	pending	2026-02-13 15:38:19.845069+00	\N	\N
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
26c4760e-4f7f-4359-979d-2a1b48f5e03b	58be09cf-362d-4919-9a0a-67aa65a5c52e	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Speaker for Samayik Avashyak Reel	2	On-site	Samayik Avashyak Reel	approved	2025-12-22	2026-02-10 17:39:43.828327+00
e871cfbc-ff96-40fa-a39a-b05be3c955a0	4842d49f-c3ea-47a4-bfee-03837bec04a5	134f3fc8-8546-4bb3-b39a-e671bfcb0808	\N	handling the art stall	6	On-site	painting keychains and helping people by assembling the keychains	pending	2026-02-12	2026-02-12 07:39:25.156259+00
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
203181fd-8186-446f-9a11-b902b9ae3da0	4c363395-b574-454e-abb9-bb28a79d09d3	deed7a1e-10f7-4f6a-906a-aac54bb1f619	\N	Shooting video for Deepak Pooja	1	On-site	Went to the nearest Derasar and shot some videos with a friend for the Deepak Pooja. 	pending	2026-02-16	2026-02-17 14:44:05.915115+00
\.


--
-- Data for Name: volunteers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.volunteers (id, ilj_id, first_name, middle_name, last_name, dob, age, gender, mobile_number, email, address_line1, address_line2, district, city, state, pincode, country, dharmik_studies, qualification, specialization, occupation, occupation_other, hobbies, skills, referred_by, volunteering_preference1, volunteering_preference2, volunteering_preference3, availability_days, time_commitment, participation_mode, password_hash, created_at, updated_at, additional_areas, sangh_name, kalyan_mitra, team_leader_for, rank, designation) FROM stdin;
9f90c956-1695-4492-9fc3-569b6e4cc326	ILJ-028	Veerti	Bhavesh 	Gada	1998-01-10	28	Female	8419944145	veertigada12345@gmail.com	A5,Yewteswar Society, 	Rajaji Cross Rd ,3rd lane	Thane 	Dombivli East	Maharashtra 	421 201	India	Pehli Dhoran	Pursuing Medical Coding 	Health Science 	Freelancer / Self-Employed	\N	Arts 	\N	\N	Marketing & Outreach	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$hP9gZSPr/9tJwfwBwpnk0uRHBnHLiWrR9ufb0zKfRaFSkeBxgrLAq	2026-02-10 09:39:21.55993+00	2026-02-10 09:39:21.55993+00	{"Defending Jainism on Social media & digital platforms"}	Sripal Nagar 	\N	\N	Intern	\N
41135cc0-c4af-478a-bc6e-6ef25590fd94	ILJ-036	Shreya	Rajesh	Mehta	2003-11-13	22	Female	9004319199	Shreyamehttaa@gmail.com	A 601 Shraddha Suman apartment 	Mandapeshwar road Borivali west	Mumbai suburban 	Mumbai 	Maharashtra 	400091	India 	\N	B.com	Accounts 	Working Professional	\N	\N	\N	\N	Event Planning & Management	Research & Documentation	Photography & Videography	Weekends	\N	Flexible / Open to Discussion	$2a$06$1h5h196ZfKn6p3y5gAXIDOz3D/WQd6L92tCW2c5hCbrMKRxCMcWFa	2026-02-11 10:13:04.965688+00	2026-02-11 14:06:13.988402+00	{}	Borivali Mandapeshwar Jain sangh 	Aayushi Sanghavi	\N	Intern	\N
4de93087-ee99-48dc-b3a5-4339c8da81ec	ILJ-006	Jeel	\N	Doshi	1998-11-24	27	Female	9022756278	jdoshi154@gmail.com	A/2 swastik building	Savarkar road	Thane	Dombivli	Maharashtra 	421201	India 	\N	Bcom	Commerce	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	Graphic Design & Video Editing	\N	Flexible	3 hours	Voluntary (Seva-based)	$2a$06$FvEYhrt6vS/GxiOzHlnFtesW68brEr32pI.xq6THACqOxE7Pn7szS	2026-02-01 16:34:33.092509+00	2026-02-11 13:45:17.365426+00	{"Defending Jainism on Social media & digital platforms"}	Neminath jain Sangh nehru maidan 	Jainam Mehta	Pathshala & Educational Activities	Associate	Team Leader
33e91007-e2fa-4274-801b-4227ea2f7909	ILJ-019	Hitarth	Chandrakant 	Shah	2006-09-18	19	Male	8850525458	hcs180906@gmail.com	B-108, Rajbhavan Palace	L.T.Road, Near Mannubhai Jewllers, Borivali West 	Borivali West 	Mumbai	Maharashtra	400092	India	2 Pratikaman, 5 Pratikaman, Jeev Vichar, Vairagya Shatak	SYBCOM	Event Management, IT Department 	Student	\N	Social Activities, Management, Photography 	Technical, PR, Photography, Speech	\N	Photography & Videography	Event Planning & Management	Graphic Design & Video Editing	Flexible	2 hours	Flexible / Open to Discussion	$2a$06$Fy0aY6qBFmMSqsGtgSXiUedf1u2U.iFBWWQHf46tZVBW3sXgXmNsa	2026-02-08 14:09:43.688078+00	2026-02-11 13:54:59.415254+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	\N	Ankit Sheth	\N	Intern	\N
60084f34-305e-42b4-8330-70bba97a2126	ILJ-032	Yogita	\N	Sheth	1998-05-14	27	Female	9930964002	yogitapd15@gmail.com	B-10, Radha govind chs	Pandurang Wadi, dombivali east	Thane	Dombivali	Maharashtra	421201	India	2 pratikaman	BAF	Accounts	Homemaker	\N	\N	\N	\N	Event Planning & Management	Pathshala & Educational Activities	Public Speaking, Acting & Stage Activities	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$1q3ofYonfetMXYmujRZpF.WTry6Fjkwl3sRdwJlq0yk4uSnLUyFK.	2026-02-10 10:32:49.505559+00	2026-02-11 14:03:53.321991+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Pandurang wadi jain sangh	Veerti Gada	\N	Intern	\N
73e309c3-69be-4b6c-97bf-b23ee7c5634c	ILJ-034	Ronak	Atul	Doshi 	2002-12-01	23	Male	+918356094919	ronakdoshi2024@gmail.com	09, Mandar CHS, Near Nehru Maidan	Dombivli(East) , Maharashtra	Thane	Dombivli	Maharashtra	421201	India	\N	Int.M.Tech	Geological Technology 	Working Professional	\N	Drawing , Painting 	IT	\N	Pathshala & Educational Activities	\N	\N	Weekends	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$syboBGEsl2RiRNXNtfg8AO4s2NaHSW6UlNdSAN5bvd.Yx1PUkzvSW	2026-02-10 16:27:01.787267+00	2026-02-11 14:05:12.245549+00	{"Building Community & Government Relations"}	Rakhi Sangh	Jainam Sheth	\N	Intern	\N
7da7baeb-2615-4949-bc8c-5e10a3ea5ffd	ILJ-008	Meet	Bhavesh	Mehta	2005-07-11	20	Male	9172387009	mehtameet115@gmail.com	flat 112 6th floor b-39 mayuri bldg	anand nagar dahisar ( east )	Dahisar	mumbai	Maharashtra	400068	India	\N	B.tech	computer engg	Student	\N	\N	\N	\N	IT & Technical Support	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$5XcKEZRRD7bSw.Go19ehnO6Sfag9uxJBgSN9Et9z9F8GtxS466EF6	2026-02-01 18:08:30.862076+00	2026-02-11 14:09:00.446127+00	{}	\N	Smit Mehta	\N	Associate	\N
cd48a9cd-dc2c-420e-874e-f8a50167c9bd	ILJ-041	Veeram	Nilesh	Mehta	2006-10-11	19	Male	9321496298	veerammehta175@gmail.com	B-202, Rajeshwari deep 	Opposite Nehru maidan, Ganesh mandir road	Thane	Dombivili	Maharashtra	421201	India	\N	CA Inter completed	Tax	Student	\N	\N	\N	\N	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$TDegh0sFzUkaUWkBME/TQehHpZA/o0yUtFdpQVWPQcFwt9dnOkNam	2026-02-11 15:47:27.734778+00	2026-02-13 15:08:30.949641+00	{}	Shree Naminath shwetambar murtipujak jain sangh	Jainam Sheth	\N	Intern	\N
f51b0111-f04d-453a-b6c0-60d9832fba6b	ILJ-002	Aayushi	\N	Sanghavi	2004-08-05	21	Female	8657634527	pritiaayu1@gmail.com	8, Virat Chs	Tilak School Road	Thane	Dombivli	Maharashtra	421201	India	5 Pratikraman. 9 Smaran (except Kalyanmandir)	Bcom.(Completed), Actuarial Science (Pursuing)	Actuarial Science	Student	\N	Drawing, Painting, Listening Music	Graphics, Acting, Public Speaking, AI	\N	Graphic Design & Video Editing	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Flexible	\N	Voluntary (Seva-based)	$2a$06$MQ1/wlvTHU9ok7JqDcTGu.ltDD5dsDhZkGt28/.d2agVfQH77PnG.	2026-02-01 15:17:23.134426+00	2026-02-07 14:37:02.694053+00	{"Building Community & Government Relations","Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	\N	\N	Public Speaking, Acting & Stage Activities|Graphic Design & Video Editing|Photography & Videography	Director	Team Leader
0e833c46-ec3f-4681-8dbc-2bec029d8db1	ILJ-004	Smit	\N	Mehta	2000-09-12	25	Male	9022566694	smitmehta50@gmail.com	B.202 Rajeshwari Deep, Ganesh mandir road	Dombivli East	Thane	Dombivli	Maharastra	421201	India	\N	B.Tech	IT	Working Professional	\N	\N	\N	\N	Event Planning & Management	\N	\N	Flexible	7 hours	Voluntary (Seva-based)	$2a$06$6g3DcNvf8R0si234MSjXwujGwLHKZytLCBgWLwH2Gq7joNtpl2oJm	2026-02-01 15:33:50.735119+00	2026-02-07 14:38:01.886106+00	{}	Neminath Jain Sangh Dombivli	\N	Event Planning & Management|IT & Technical Support	Manager	Team Leader
a551cf3f-5282-49ea-b432-7624af5558b2	ILJ-042	Mokshang	Sanjeev Kumar 	Jain	2009-04-05	16	Male	9892941867	mokshangj@gmail.com	5/A , 401 sarvoday garden 	Pandurang wadi near jain mandir	Thane	Dombivli 	Maharashtra 	421201	India	Sakalaratha	10th ssc completed	ARTS	Student	\N	Read and develop my own stories and write	Creative writing, story writing, script writing 	Muktimandan maharaj saheb	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	\N	Weekends	1 hour 30 mins	Flexible / Open to Discussion	$2a$06$NizNl7wOSfdCbgdbNsBOP.5fbVxfMkKNUJgf.XpXJgYZAg8x0QXOq	2026-02-11 15:48:10.046077+00	2026-02-13 15:08:57.846273+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	SMPT Jain sangh pandurang wadi	Jainam Mehta	\N	Intern	\N
2a495f49-f4e5-4dfa-879d-50e43fcca74e	ILJ-068	Dhruvi 	Rikin	Gandhi	2001-09-24	24	Female	9082038358	dhruvigandhi4617@gmail.com	B 208 	Om yamuna madhav savarkar road	Thane	Dombivli	Maharashtra	421201	India	\N	Ca	Ca	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$BrDt8JPLwmL1mkmfpYAlD.enwy1lpdTyv5r/lgSL54nXlnqwXpf2i	2026-02-18 19:18:43.510185+00	2026-02-18 19:18:43.510185+00	{}	\N	\N	\N	Intern	\N
55ca6718-5a82-408d-800d-86cc3c49bbca	ILJ-010	Disha	Sachin 	Gandhi	2006-03-01	19	Female	9969612883	dishagandhi136@gmail.com	207, neelkanth chs fateh ali road behind kdmc office  	Near pp chambers,above Bharat co operative bank 	Thane	Dombivli	Maharashtra 	421201	India	\N	SYBAF 	Accounting and finance 	Student	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	\N	Flexible	5 hours 30 mins	Voluntary (Seva-based)	$2a$06$LiCY8prCDRoqSZShtWkpEOmkOUkMH.pYU6r9TaLvlXkszfKnXedZe	2026-02-03 15:40:08.070894+00	2026-02-16 05:59:40.689589+00	{}	Nehru maidan(rakhi) Sangh 	Aayushi Sanghavi	\N	Intern	\N
043bde9c-9ebb-4e8c-8ccb-a975a83eec39	ILJ-005	Labdhi	Mehul	Shah	2000-12-08	25	Female	7028551745	labdhishah128@gmail.com	C-15 Aakardeep Chs, Agarkar Road	Dombivli East	Thane	Mumbai	Maharashtra	421201	India	Navtatva	Advocate	Law	Working Professional	\N	Public speaking.	Compliance and Legal Research	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Marketing & Outreach	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$hO8WrmzFU1jau5kuW3l5Ueu2isMo8QZ6LxkmWcHcYc7DrB2KOQBde	2026-02-01 15:37:16.131539+00	2026-02-17 13:51:24.971539+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Shri Jay Naminath Swethambar murtipujak Jain Sangh Dombivli East.	\N	\N	Manager	\N
93748e18-e2ba-46c6-8f37-7ebfe143bfe1	ILJ-011	Meet	Paresh 	Salot	2009-02-11	16	Male	8169306806	meetsalot1102@gmail.com	A/103 kamala chs Ltd ,	Dr.mukherjee rd, near ckp hall	Thane	Dombivli 	Maharashtra 	421201	India	\N	11th 	Science 	Student	\N	\N	\N	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Photography & Videography	Flexible	\N	Voluntary (Seva-based)	$2a$06$wBj0tS14Rb6gSFA18Q.UquYgOMlsHimQGQAJDGB231UuO4etbWqCa	2026-02-07 15:46:02.339115+00	2026-02-11 13:48:30.253159+00	{}	Shri naminath shwe.mu.tapa. jain sangh	Smit Mehta	\N	Intern	\N
a59d9b96-eccd-4b3a-a15f-ad6f693013a7	ILJ-001	Jainam	\N	Mehtaa	1999-06-05	26	Male	9167180806	jainammehta519@gmail.com	A-302, Umiya Parijat CHS, Building No. 37	Guru Dattta Mandir Road, Pant Nagar	Mumbai	Ghatkopar (East)	Maharashtra	400075	India	\N	Chartered Accountant	GST	Working Professional	\N	\N	\N	\N	Content Writing (Articles, Blogs, Scripts)	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$/hUFRVODr1rj5v4Uwyf5YeOLyUVTiSmRwq1ywQwcTmc12N/HTFbp6	2026-02-01 15:06:01.194829+00	2026-02-17 14:26:48.319659+00	{}	\N	\N	Content Writing (Articles, Blogs, Scripts)	Manager	Team Leader
03a59a7d-da67-44b8-88f7-1a0fbe44f706	ILJ-003	Jainam	Nalinbhai 	Sheth	2000-03-04	25	Male	8879355429	cajainam04@gmail.com	302, Arnath	Sarvoday Nagar 	Mumbai 	Mulund 	Maharashtra	400080	India	Karmgranth	CA	Accounts	Working Professional	\N	Reading 	\N	Jainam Mehta	Public Speaking, Acting & Stage Activities	Research & Documentation	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$kVLflD31LJIirjJKSYQVNe76PCBPL4FAF6UW2x1pleGSBHbW42W6i	2026-02-01 15:25:16.393861+00	2026-02-07 14:37:14.811975+00	{"Defending Jainism on Social media & digital platforms"}	Sarvoday sangh 	\N	Research & Documentation	Manager	Team Leader
b2bc304c-62d9-4383-8af6-f78a51c94374	ILJ-012	Vatsal	\N	Mehta	2002-09-28	23	Male	9930164403	vatsalm707@gmail.com	A-302, Umiya Parijat	Pant Nagar	Mumbai Suburbans	Ghatkopar (East)	Maharashtra	400075	India	\N	B.Tech	Computer Science	Working Professional	\N	\N	\N	\N	IT & Technical Support	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$Py3dO.c/Snb2w.ZvYT/daO7PlKTU4uvg8OmPJq8XSDe23dvXlbCzq	2026-02-07 15:48:14.029+00	2026-02-11 13:51:07.558803+00	{}	Pant Nagar	Jainam Sheth	\N	Intern	\N
7e72384f-5a73-498c-b82e-57dd17a6ea18	ILJ-007	Charmi	Pritesh 	Dedhia	2004-02-24	21	Female	8169639689	charmipdedhia@gmail.com	B-205, Surekha bhuvan	Tilak Nagar Post Office, Dr.R.P.Road	Thane 	Dombivli East 	Maharashtra 	421201	India 	\N	MBA	Marketing 	Student	\N	Teaching, networking	\N	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$2QSvFAjr30hBWY/yHEJT4Oocbj8ObLylufJ4Z26Zo5OWql.vLjaje	2026-02-01 16:58:20.314585+00	2026-02-07 14:45:04.868654+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	\N	\N	Marketing & Outreach	Associate	Team Leader
232f55ca-9598-4daf-a8ef-5e9be124c975	ILJ-013	Aayush	\N	Vora	2003-12-06	22	Male	8104214059	aayushvora2003@gmail.com	303, Mahavir Heights NX	Ganesh Mandir VP Road	Thane	Dombivli East 	Maharashtra	421201	India	Moti Shanti	CA (pursuing)	Finance	Working Professional	\N	Reading, Music	Excel, PowerPoint, AI Tools, Research	\N	Research & Documentation	Content Writing (Articles, Blogs, Scripts)	Public Speaking, Acting & Stage Activities	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$8O9SoRKyhbA7PUmqpqin3uZwQv9cRFew.H296W9sCkC/G.Agwx/6q	2026-02-07 16:04:41.420873+00	2026-02-11 13:51:35.487628+00	{"Building Community & Government Relations"}	Rakhi Sangh	Jainam Sheth	\N	Intern	\N
d22fd755-c0a9-4474-8280-64d42c126700	ILJ-015	Shikha 	Chirag	Mehta	2005-12-07	20	Female	82919 12131 	shikhacmehta@gmail.com	804, Span height 	Near dmart 150 feet road	Thane 401101	Bhayandar 	Maharashtra 	401101	India	Bhaktamar ongoing 	Bachelor's ongoing 	Pharmacy	Student	\N	Teaching, dancing, sketching , reading etc	Teaching and clear explanation of concepts + deep research \nEffective communication\nInterest in learning and sharing Dharma-based knowledge\nContent understanding and thoughtful participation	\N	Content Writing (Articles, Blogs, Scripts)	Public Speaking, Acting & Stage Activities	Research & Documentation	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$7oCUoAtVZ1D9qykCSSY7L.vV9kHBKkLQT5Kf7qWlwmUAEElhL6FR2	2026-02-08 05:21:07.814826+00	2026-02-11 13:53:28.59966+00	{"Defending Jainism on Social media & digital platforms"}	\N	Aayushi Sanghavi	\N	Intern	\N
fec4a7b5-7a2b-4d5e-9d90-35eee4676aa9	ILJ-016	Avani	\N	Doshi	2007-09-01	18	Female	8652423859	avanidoshi09@gmail.com	701, Suyogs Godavari Krupa 	V.P.cross road, mulund west	Mumbai suburban 	Mumbai	Maharashtra 	400080	India	\N	Pursuing FYBA	Political science 	Student	\N	\N	\N	\N	Research & Documentation	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$ZN8TyYysGCDOahtozOILmuXzzMQwGu.udw7V.0H.C8cTtXR7AmrBW	2026-02-08 13:44:08.339872+00	2026-02-11 13:53:48.153008+00	{}	\N	Jainam Sheth	\N	Assistant Manager	\N
3b05ba3c-4755-4104-a7b9-d7f7846cc4be	ILJ-029	Dhiaan	Tejpal 	Jain	2015-06-05	10	Male	9321944621	dhiaanjain2@gmail.com	Govindanand bldg 2nd floor B/7	Savarkar road near savarkar garden 	Thane	Dombivli East 	Maharashtra 	421201	India	\N	Pursuing for political field 	Political science 	Student	\N	Exploring in all new things 	Creative 	Saachi Jain 	Pathshala & Educational Activities	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$8SQFqpTcPGM/2v7.dAb61.RHCYtBTVI3OMmc1fRnV7akXuBtxADGC	2026-02-10 09:53:38.722481+00	2026-02-13 15:23:18.13986+00	{"Building Community & Government Relations"}	Rakhi Sangh	Veerti Gada	\N	Intern	\N
e243534f-6a49-436d-b637-a050b1e32de0	ILJ-009	Bhavya	Rajendra	Sanghavi	2001-08-28	24	Female	+918691904575	bhavyarsanghavi99@gmail.com	A/304, jagannath's commerce plaza	Manpada road	Thane	Dombivli east	Maharashtra	421201	India	\N	CA	Finance	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$UuMPZfbQ4Vswhg53rLJ1quCooLqXB84rPEowy9eLZfxbwq5Zdic/e	2026-02-02 08:28:10.500315+00	2026-02-15 08:45:13.309362+00	{}	\N	Jainam Sheth	\N	Associate	\N
2c1bcdc5-0564-44d9-be4a-158445f39975	ILJ-020	Heer	Shailesh 	Shah	2006-11-12	19	Female	9702790268	heershah12116@gmail.com	302 gulmohar apartment 	Factory lane 	Maharashtra	Mumbai	Maharashtra	400092	India	\N	Pursuing bcom, cfp	Finance	Student	\N	Explore new things 	Creativity 	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Pathshala & Educational Activities	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$MC98mGw2QZd0UHSDC2fHLe509Um74nZ.mqUAeSUOzDKZ/oGl0WcBC	2026-02-08 15:01:59.839918+00	2026-02-11 13:55:19.053909+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Jambligully jain sangh	Charmi Dedhia	\N	Intern	\N
41fcbca1-3193-42ce-8585-95372b4b9d52	ILJ-014	Test 	\N	Test 	2020-02-06	6	Male	+919172387009	meets.studentlife@gmail.com	B/39, Flat No112, Mayuri Chs Csroad Near Bmc Market	Anand Nagar Dahisar East	Test	Greater Mumbai (M Corp.) (Part)	Maharashtra	400068	India	\N	Test	Test	Student	\N	\N	\N	\N	Research & Documentation	\N	\N	Weekdays	\N	Voluntary (Seva-based)	$2a$10$9cFA3i./CuWiE7tgoRE1m.8U2vSw2IxZ8/6SfY11kD/7drgVL85DG	2026-02-07 16:44:00.216534+00	2026-02-08 17:50:47.999732+00	{"Defending Jainism on Social media & digital platforms"}	\N	\N	Event Planning & Management|Content Writing (Articles, Blogs, Scripts)	Intern	\N
3b54e716-c5a0-4d4c-a616-4e2e2be95539	ILJ-018	Jash	Nikhil 	Shah	2008-09-12	17	Male	8452050129	jash4739@gmail.com	468/478 Chadha Mansion, 3rd floor, flat no 9 , S.V.P Road, Mumbai 400 004	Opera house 	Mumbai 	Mumbai	Maharashtra	400004	India	Completed 2 pratikraman 	12th	Commerce	Student	\N	Editing 	Tech	\N	Graphic Design & Video Editing	\N	\N	Flexible	5 hours	Voluntary (Seva-based)	$2a$06$Fjdv0eGPfGDPlC9m1xrToO/m.OsxkUQdQUfRxwUvYLgKSP74fGbfu	2026-02-08 13:47:57.729658+00	2026-02-11 13:54:34.620081+00	{"Defending Jainism On-field engagement","Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Shri Prathna samaj jain sangh	Jainam Mehta	\N	Intern	\N
fc5dc1e3-762c-442f-9f4c-0f2e2f8080e9	ILJ-026	Siddhi	Paresh	Dedhia	2012-03-21	13	Female	93228 03390 	Siddhi61d@sttherese.in	Gajanan heights b wing 002	Sangeeta wadi shiv mandir road	Thane	Dombivli 	Maharashtra 	421201	India	\N	Study	Study 	Student	\N	\N	\N	\N	Pathshala & Educational Activities	\N	\N	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$qMjxRw/E5grZhJXveF/WJ.ck6ohMNwWqI/vuwwtzVwO3h4qFarBYW	2026-02-09 16:46:53.51547+00	2026-02-11 13:59:27.185065+00	{}	\N	Charmi Dedhia	\N	Intern	\N
2b9ed3d2-4a99-4d9e-b75a-4a5c712d0f38	ILJ-022	Yashvi	Hitendra	Maheta	2007-09-17	18	Female	7208751596	yashvimaheta135@gmail.com	Morya arcade, shiv mandir road, sabgeeta wadi, 2nd floor 206 	Near naivedya hotel	Thane	Dombivli	Maharashtra (dombivli) 	421201	India	\N	Sy B. Com 	Commerce	Student	\N	Writing, reading, 	Technical Skills, Presentation dena	\N	Public Speaking, Acting & Stage Activities	\N	\N	Weekdays	1 hour	Voluntary (Seva-based)	$2a$06$CYpPPqBy10S.QPwGZHpCLOBzv4haiK53QenK9dP0D5edrY7pkSlLq	2026-02-08 19:53:24.892602+00	2026-02-11 13:57:13.08946+00	{"Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	SMPT jain sangh	Jainam Sheth	\N	Intern	\N
481b2283-318d-48b8-94f3-63c9f6fcf7af	ILJ-023	Vatsal	Dipesh	Mehta	2007-09-04	18	Male	8591694356	vatsalmehta5106@gmail.com	Kukreja Complex Bhandup	6B-104	MUMBAI SUBURBAN	Mumbai	Maharashtra	400078	India	\N	Btech	Computer engineering 	Student	\N	Exploring new places and food and learning about new things 	Web development and researching 	\N	IT & Technical Support	Research & Documentation	\N	Weekends	3 hours 30 mins	Voluntary (Seva-based)	$2a$06$N4Zj8tc5nmCT/KuDujmE6.HGShiv.bVkBLZ4/V.UNCrHI0y3MuScq	2026-02-09 09:39:09.593969+00	2026-02-11 13:57:36.399965+00	{}	\N	Ankit Sheth	\N	Intern	\N
7034d767-3884-4660-bdc7-ddcd51cd38c3	ILJ-024	Vividha 	Shrey	Patwa	1995-02-10	30	Female	8511974347	vividhapatwa@gmail.com	"Shrey", 64-A, Bhanushali Nagar 	Mundra Road 	Kutch	Bhuj	Gujarat	370001	India	Studying Gunasthanak, Vairagya shatak and Dandak	B.Arch	Architecture 	Homemaker	\N	Telling Jain stories to children's \nDoing activity related to Jainism, Going on jatra	Explaining Jainism to people deeply	\N	Research & Documentation	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Flexible	4 hours	Flexible / Open to Discussion	$2a$06$b0XjUwzWF4F0sZL6HluBd.7SNlxqpAzsusIJ8F8CzSAMEfpNqnuEq	2026-02-09 14:05:14.864396+00	2026-02-11 13:57:58.97286+00	{"Defending Jainism on Social media & digital platforms","Defending Jainism On-field engagement"}	Khartargach Jain Sangh Bhuj 	Aayushi Sanghavi	\N	Intern	\N
4c363395-b574-454e-abb9-bb28a79d09d3	ILJ-025	Mahek	\N	Shah	2004-10-12	21	Female	+916354984849	shahmahek1210@gmail.com	34/D Haripark society	Ankur, Naranpura, Ahmedabad 	Ahmedabad 	Ahmadabad	Gujarat	380013	India	2 pratikraman	MBA pursuing 	HR & Finance (Dual)	Student	\N	Singing, Playing guitar, Reading spiritual & Non-fiction books.	Communication, presentation, Team coordination, Project Management, Frontend Website Development.	Instagram 	Public Speaking, Acting & Stage Activities	Event Planning & Management	Marketing & Outreach	Weekends	1 hour 30 mins	Flexible / Open to Discussion	$2a$06$YGaEA6W.xEha5BIjMNn3Guxf92F1SvpMuTQjZKj2SwdDrTmXr9pdS	2026-02-09 16:39:41.380421+00	2026-02-11 13:58:57.754623+00	{"Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shri Haripark Shwetambar Murtipujak Jain Sangh	Aayushi Sanghavi	\N	Intern	\N
9a067c77-bb95-44cc-812e-4557ac17f80a	ILJ-030	Aayushi	Bhadresh	Shah	2003-09-15	22	Female	+919820583463	aayushishah1556@gmail.com	101,Sumati Apartment Sambhav CHS,opp Sarvoday jain mandir,mulund west	Sarvoday Nagar, Mulund west	Mumbai	Mumbai	Maharashtra	400080	India	\N	Pursuing CFA	Finance	Student	\N	Content writing\nScript drafting \nResearch and documentation 	\N	Shruti Shah	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	\N	Flexible	2 hours	Voluntary (Seva-based)	$2a$06$kTXLpLNQcgbjrgxAPTiOVetW2f.I7gRwlXGVsnKfod4B0bNTL2Fly	2026-02-10 10:10:54.446122+00	2026-02-11 14:01:22.265865+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Sarvoday Parshwanath Sangh	Jainam Sheth	\N	Intern	\N
c371c0b4-f445-41ec-b6cf-ba6828e59757	ILJ-021	CHARMI	RAJNIKANT 	Doshi	2007-08-30	18	Female	9082051477	charmi2630@gmail.com	B/16, Laxmandham building 	Rajaji Road near madhavi bunglow 	Thane	Dombivli East 	Maharashtra 	421201	India	Nav tattva	Fy ba llb	Law	Student	\N	Outdoor activities	Communication	\N	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$ZtnltbZfDKJSXBwcj8i2pOFmbRA/XjVsUoha88ciYlyXeOMayJgcC	2026-02-08 15:26:44.396583+00	2026-02-13 15:22:24.297193+00	{"Defending Jainism On-field engagement"}	Rajaji road shwetamber murtipujak jain sangh	Charmi Dedhia	\N	Intern	\N
58be09cf-362d-4919-9a0a-67aa65a5c52e	ILJ-035	Snehi	Praful	Vora	2004-07-06	21	Female	93214 21361	Snehivora06@gmail.com	302, Vishnu Bhuvan	Gupte road	Thane 	Dombivali 	Maharashtra	421202	India	5 Pratikaman & 9 Smaran 	CMA (US)	Finance	Working Professional	\N	Content Writing, Content Creation, Podcasting, Acting, Drama 	Content Writing, Content Creation, Podcasting, Acting, Drama, Excel, AI &Automation, Costing	Ayushi Sanghavi	Public Speaking, Acting & Stage Activities	Content Writing (Articles, Blogs, Scripts)	Marketing & Outreach	Weekends	2 hours	Voluntary (Seva-based)	$2a$06$zlGyriG3/CvcPHzv2lAF9O/OwbwqPOm1.SGTJBuVj38RVYsLn2eUu	2026-02-10 17:33:08.82233+00	2026-02-11 14:05:44.768137+00	{"Building Community & Government Relations"}	Naminath Jain Sangh 	Aayushi Sanghavi	\N	Intern	\N
32837c38-a21e-450a-8613-ec2c09f3cc97	ILJ-017	Saachi 	Tejpal 	Jain	2010-11-15	15	Female	9022761552	saachijain808@gmail.com	Govindanand bldg 2nd floor B/7	Savarkar road near savarkar garden 	Thane	Dombivli East 	Maharashtra 	421201	India	\N	Pursuing for m.com	Commerce 	Student	\N	Art and craft 	Creative 	Aayushi Sanghvi 	Event Planning & Management	Photography & Videography	Pathshala & Educational Activities	Weekends	2 hours 30 mins	Voluntary (Seva-based)	$2a$06$gF8HvW9LroYUMUIO/CfECu/q9V1AItADXCEOHK7B6mTf0CAXZMD6i	2026-02-08 13:47:14.371431+00	2026-02-11 13:54:06.182962+00	{"Defending Jainism on Social media & digital platforms"}	Rakhi Sangh	Charmi Dedhia	\N	Intern	\N
b8f6d90e-b692-4a8a-8cbc-17909331fa73	ILJ-031	Ankit	\N	Sheth	1993-02-26	32	Male	7208290085	ankitsheth8@gmail.com	B-10, Radha govind chs 	Pandurang wadi Dombivali East 	Thane	Dombivali	Maharashtra	421201	India	5 pratikaman	Mcom	Finance & Accounts	Working Professional	\N	\N	\N	\N	Event Planning & Management	IT & Technical Support	Research & Documentation	Weekends	4 hours	Voluntary (Seva-based)	$2a$06$xu3QPIgahZ6x3JJ6Iszjd.YIoyXU57DBWFS6xuFs7.ATd5DBoEx1a	2026-02-10 10:28:33.582157+00	2026-02-11 14:01:48.480695+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Pandurang wadi jain sangh	Jainam Mehta	\N	Intern	\N
c7a55082-57f2-47f5-ba94-dc7d5ebd5d8b	ILJ-033	Yashvi	Hemant 	Sanghavi	2007-12-08	18	Female	9423594189	yashvi.sanghavi.dombivli@gmail.com	16/B Matru Ashish CHSL 	Tai Pingle chowk Acharya Tulsi Marg Dombivli East 	Thane 	Dombivli 	Maharashtra 	421201	India 	2 dhoran	BAF 	Accounting and Finance 	Student	\N	Reading	Excel, tally, editing 	\N	Marketing & Outreach	Graphic Design & Video Editing	Research & Documentation	Weekdays	30 mins	Voluntary (Seva-based)	$2a$06$1JUZcxxVb8DWivUdSbmz3eRgqoRZgtCoWdEmASLhdDa0KEff5Wfwy	2026-02-10 14:20:52.226662+00	2026-02-11 14:04:45.734543+00	{}	\N	Charmi Dedhia	\N	Intern	\N
f2179127-e88f-41f3-910a-f9dd0fa2647a	ILJ-037	Aditi	Hitendra	Maheta	2009-09-10	16	Female	+917208751596	aditimaheta720@gmail.com	Morya arcade, shiv mandir road, sabgeeta wadi, 2nd floor 206	Near naivedya hotel	Thane	Dombivli	Maharashtra (dombivli)	421201	India	5 pratikraman. 	11th currently	Arts	Student	\N	Hobbie- video editing,drawing and painting,cricket,reading, \nInterests- voluntary and events management 	Time management 	Marasaheb	Event Planning & Management	Pathshala & Educational Activities	\N	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$UtGX7dfBRPmGEaSxHUCClee0yvCqTekyi092nLjduf5iGMDrCa0wO	2026-02-11 13:37:56.317839+00	2026-02-11 14:06:35.791151+00	{}	SMPT jain sangh	Jainam Sheth	\N	Intern	\N
96c9c515-49dc-4172-95d9-7a57478388c3	ILJ-040	Hiya	\N	Gandhi	2007-10-06	18	Female	9372393772	hiyagandhi624@gmail.com	Raghupati Apts	Tambe Nagar 	Mumbai 	Mulund 	Maharashtra 	400080	India	Laghu shaanti 	12th	Commerce 	Student	\N	editing and painting 	Creative 	\N	Graphic Design & Video Editing	\N	\N	Flexible	5 hours	Voluntary (Seva-based)	$2a$06$bmwflOR5VMUSa96R/7HALulMVqUH4HjOhW4musp9X6hPhJRg7BNnS	2026-02-11 14:45:03.463763+00	2026-02-13 15:07:32.940509+00	{"Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shasan Samrat Shwetambar Murtipujak Jain Sangh	Aayushi Sanghavi	\N	Intern	\N
df0f9941-a563-4844-adf0-3058c435dbf3	ILJ-043	Bhumi	Hitesh	Sanghavi	2003-11-26	22	Female	8928656657	bhumisanghavi2003@gmail.com	202 Ramtirth soc opp nehru maidan	Ganesh mandir road	Thane	Thane	Maharashtra	421201	India	\N	Actuaries	Insurance	Working Professional	\N	Art and Craft	Creative, management	\N	Event Planning & Management	\N	\N	Weekends	1 hour 30 mins	Voluntary (Seva-based)	$2a$06$JXT/qh5eUzXYJ2wSl3XHlOhN0e7sRyLislTBJQDSK3lYaJWU0/Pbu	2026-02-11 16:12:01.955263+00	2026-02-13 15:09:22.440417+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Shri Jay Naminath Murtipujak jain sangh	Labdhi Shah	\N	Intern	\N
6fa7eb3a-f3d8-4de1-92ab-b4a5f058d6eb	ILJ-044	Yesha	\N	Salot	2006-04-18	19	Female	9022227572	yeshasalot@gmail.com	103 kamla chs. Ltd., 	Mukherjee rd.,	Thane	Dombivli(E).	Maharashtra	421201	India	\N	BAF	Accounting and finance 	Student	\N	I like to listening songs, dancing,  enjoying the natures, take interest to learn new things. 	Know the basic technical skills, likes creativity things,etc.	\N	Pathshala & Educational Activities	\N	\N	Weekdays	2 hours	Voluntary (Seva-based)	$2a$06$9Rk..pDsM6NUmBJE8bBVbelpPcHqVn8EoDBlVG3T2x7phZNaNGv1K	2026-02-11 18:16:42.744692+00	2026-02-13 15:09:43.577761+00	{}	Shru jai naminath swe. Mu. Tap. Jain sangh.	Labdhi Shah	\N	Intern	\N
e511ae7b-67bc-45ff-84f7-29be33b3a5e6	ILJ-045	Aayush 	Raji	Sanghavi 	2008-03-11	17	Male	7738326345	aayushsanghavi97@gmail.com	8,Virat chs 	Tilak Nagar school road 	Thane 	Dombivli (east)	Maharashtra 	421201	India 	5 pratikaman,9 samran (except-bhakamar & kalyanamandir)	SSC	Commerce 	Student	\N	\N	\N	\N	Photography & Videography	Public Speaking, Acting & Stage Activities	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$RzmioX9eJRJOTsJWkNFI7.7jSpHxMn28zWjaxvWZJ.cifk8Bpww/6	2026-02-12 04:35:50.529978+00	2026-02-13 15:10:07.644118+00	{"Defending Jainism On-field engagement"}	\N	Charmi Dedhia	\N	Intern	\N
d4c73898-8bda-476d-a068-898c72460441	ILJ-027	Naitik	Mehul	Shah	2009-04-14	16	Male	9076056730	ns4934551@gmail.com	C-15 Aakardeep	 Aagarkar road  near Thakur vadpav	Thane	Dombivli East 	Maharashtra 	421201	India	\N	11th commerce 	Commerce 	Student	\N	To play drums 	I am Drums 	\N	Event Planning & Management	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$ljqCg4ox/hdj/1WQnjNd8uD3ED/L5mkOR0LM/L1I86Sv7tI.OWo.i	2026-02-09 17:09:30.799752+00	2026-02-18 07:52:03.933966+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Rakhi 	LABDHI,RONAK	\N	Intern	\N
fe64f71e-bc1f-4297-af8a-9dfae090e0be	ILJ-046	Kreena	\N	Doshi	2002-11-07	23	Female	8452802210	kreena.b@somaiya.edu	Nilkanth apt	Tilak road	Thane	Dombivli 	Maharashtra	421201	India	\N	CA completed	Commerce	Working Professional	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	Event Planning & Management	Pathshala & Educational Activities	Weekends	\N	Voluntary (Seva-based)	$2a$06$.pKAvuBHNLZNA4e21xVxmOAdHYkEIOmXRXWAEwSRIlocQ9o8Qy.aq	2026-02-12 05:27:29.57057+00	2026-02-13 15:10:48.340369+00	{"Defending Jainism On-field engagement"}	\N	Labdhi Shah	\N	Intern	\N
6a89d207-b9ef-4e2b-9a9a-14b42000db10	ILJ-048	Prachi	Ashok 	Shah	1998-11-13	27	Female	9930759421	prachishah1311@gmail.com	7/samarth krupa	Gograswadi	Thane	Dombivali 	Maharashtra 	421201	India	\N	M.com	Accounts	Working Professional	\N	\N	\N	\N	Pathshala & Educational Activities	Event Planning & Management	\N	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$k.3GeElWVORBaWHpbFEceeceBIhpB7Szr8hNfZKepyzUZBBW1xBbS	2026-02-12 06:34:31.526794+00	2026-02-16 16:29:05.048826+00	{"Defending Jainism On-field engagement"}	Munisuvrat swatamber murtipujak jain sangh	Labdhi Shah	\N	Intern	\N
dd8599b5-9989-4b14-9d33-6e4913e6693e	ILJ-039	Nemil	Yogesh 	Shah	2000-04-23	25	Male	8655449499	nemilyshah@gmail.com	205, Gayatri Apartments, Opp. Canara Bank	S.V.P. Road, Borivali (W)	Mumbai Suburban	Mumbai 	Maharashtra 	400092	India 	5 Pratikaman	B. Tech	Computer Engineering	Working Professional	\N	Reading \nMusic	Software development \n	Muktimandan ms	Research & Documentation	\N	\N	Flexible	4 hours	Voluntary (Seva-based)	$2a$06$4g1b6iQDsWEvnUtgcNqhf.3kxG7zZx.8c10RkBBdNyzlD5teuM4wG	2026-02-11 14:10:09.394196+00	2026-02-13 15:06:57.276783+00	{"Building Community & Government Relations","Defending Jainism On-field engagement"}	Mandpeshwar	Ankit Sheth	\N	Intern	\N
d176663a-6707-4d57-bf50-35e3e7b4a964	ILJ-052	Manali 	\N	Shah	1988-03-31	37	Female	9892903684	mana88shah@gmail.com	81	Windale Cresent	Ontario	Kitchener	Ontario	N2E 3H4	Canada	\N	Mcom	Finance	Working Professional	\N	Listening to Podcasts, Reading books, Walking, Creating Nutrition plan for Family members, Drawing, Stiching 	Data Scientist, good with data pulling and financial analysis, preparing dashboards 	Varaktamala Sahebji and Muktimandan Sahebji	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	Photography & Videography	Flexible	3 hours	Flexible / Open to Discussion	$2a$06$r0nAQBivl8GS8k2wJzGD/OmXAyxyR5DTeLlNuT0Jdl9fAFNJqUJW2	2026-02-12 15:47:50.461262+00	2026-02-13 15:19:55.044283+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	\N	Aayushi Sanghavi	\N	Intern	\N
aded593b-ae3f-4eca-8edf-658f89bb172c	ILJ-038	Khushi	Jayanti	Shah	2006-10-30	19	Female	9821712171	Khushishahh372@gmail.com	Flat no.14, 5th floor Waman Chs	Mahatma Gandhi Rd, Navpada, Vile Parle East	Mumbai	Mumbai	Maharashtra 	400057	India 	Completed 2 pratikraman and jeevichar, vairagya shahtak 	Pursuing Bsc in applied Psychology 	Psychology 	Student	\N	Im a writer, I write, edit podcasts both audio and visual podcasts\nI like reading books 	Problem solving\nWriter \nEditor\n	Prisha jain mulund - +91 72087 70036	Event Planning & Management	\N	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$6FExkkD3TT.a7lJtpl88Reo9FtiOx5H/WqpIWAGNU4KP6dBauvBNS	2026-02-11 13:57:01.840037+00	2026-02-13 15:07:56.882995+00	{"Building Community & Government Relations","Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms"}	Shri Vile Parle Shwetambar Murti Pujak Jain Sangh and Trust	Aayushi Sanghavi	\N	Intern	\N
4842d49f-c3ea-47a4-bfee-03837bec04a5	ILJ-047	Jiana	pravesh	Mehta	2011-08-13	14	Female	8657704561	mehtajiana7@gmail.com	flat number7/A wing/ GowaliaTank building	A•K marg/ above maharaja hotel	mumbai suburban district	Mumbai	maharashta 	400036	india	panch pratikaman full done \nstill doing bhaktamar sutra	pursuing 9th grade education 	commerce	Student	\N	chess \nbaking \nadventure activities like hiking and horse riding 	\N	jeel	Event Planning & Management	Public Speaking, Acting & Stage Activities	Graphic Design & Video Editing	Weekends	3 hours	Voluntary (Seva-based)	$2a$06$a1c05hspLAV/5RGA8jtcyOWk6ixhuw0x4ape/BzkHo1V4ioSQMGAW	2026-02-12 06:31:29.839705+00	2026-02-13 15:15:02.872979+00	{}	shri gowalia tank jain sangh	Aayushi Shah	\N	Intern	\N
8b946c8c-5583-4340-94ac-a0c3801bfb98	ILJ-049	Harshil	Narendrabhai	Daftari	2000-09-23	25	Male	+919228561485	daftariharshil@gmail.com	A-602 Aavli Nine 360	Motera 	Gandhinagar	Near Bhat Circle 	Ahmedabad	380005	India	2 Pratikraman 	MCA	Master of Computer Application 	Working Professional	\N	Traveling \n	Social Media Marketing \nGraphic Designer 	\N	Event Planning & Management	Graphic Design & Video Editing	Photography & Videography	Weekends	3 hours	Paid Basis (Project or Role-based)	$2a$06$IejYZb6i4aYo7V9Y7AIqmOeT8oRIuARvZkgdhbKms1Lciyjqjyh3i	2026-02-12 09:08:15.978922+00	2026-02-13 15:17:26.708072+00	{"Defending Jainism on Social media & digital platforms"}	Sangath 	Smit Mehta	\N	Intern	\N
f854a439-e72d-44fc-8efe-a0f755462a04	ILJ-050	Rutvi	\N	Sanghavi	1998-09-23	27	Female	9870175733	rutvisanghavi5@gmail.com	147/48, Tawawala Bldg, 3rd Floor	Lohar Chawl, Princess Street	Mumbai	Mumbai	Maharashtra	400002	India	\N	B.Des in Communication Design	Graphic Design in Communication Design	Freelancer / Self-Employed	\N	Journaling\nCreative activities\nArts and Crafts	Management\nCreative problem solving\nPlanning, stratergising and analysis\nBusiness Development\nCommunication	\N	Content Writing (Articles, Blogs, Scripts)	Event Planning & Management	Research & Documentation	Flexible	\N	Voluntary (Seva-based)	$2a$06$pd3d59/YUpiikTUgc.sZX.EqD9lmJmilfzSMHo1f/Q1PoxlqOkuZ6	2026-02-12 10:04:52.685918+00	2026-02-13 15:18:08.457325+00	{}	\N	Veerti Gada	\N	Intern	\N
0c6384b4-15bd-42b1-a978-317e1d163f8d	ILJ-051	Arpita	Pankaj 	Dand	2005-06-30	20	Female	9819992563	arpitadand5002@gmail.com	C-52 Sevadham bldg	Rajaji Path	Kalyan	Dombivali	Maharashtra	421201	India	\N	pursuing B.Tech	Computer Engineering	Student	\N	Chess	Technical & Creative	\N	Graphic Design & Video Editing	IT & Technical Support	\N	Flexible	7 hours 30 mins	Flexible / Open to Discussion	$2a$06$0qQJ/B9Q35Pt4nLrzqLuUuC664uLTDdl9asTDUZFIG.Xg25BViAPS	2026-02-12 11:04:39.970126+00	2026-02-13 15:18:29.644658+00	{"Defending Jainism on Social media & digital platforms"}	\N	Aayushi Sanghavi	\N	Intern	\N
c2ec0bda-a63d-40d7-ba6a-e7795fbd26e9	ILJ-053	Prisha 	Mahavir 	Jain 	2005-10-31	20	Female	7208770036	prisha.jain@somaiya.edu	D 501 Ciana Atmosphere 2 	Mulund west	Mumbai 	Mumbai 	Maharashtra 	400080	India 	4 prakaran,3 bhashya 	Pursuing BAMMC	Mass Media 	Student	\N	Singing,dancing,acting 	Performing arts 	Sahebji 	Public Speaking, Acting & Stage Activities	Content Writing (Articles, Blogs, Scripts)	Research & Documentation	Flexible	3 hours 30 mins	Voluntary (Seva-based)	$2a$06$VYcjFo/roqRG.j25GEe5nuuiJA1L6pAx/8J4PQNKBTG8ZpVmmyESO	2026-02-13 09:50:12.716586+00	2026-02-13 15:20:11.589568+00	{"Defending Jainism on Social media & digital platforms"}	Shri Sarvodaya Jain sangh 	Aayushi Sanghavi	\N	Intern	\N
87f3685f-9952-49ed-8c9f-b7f9a5fbf908	ILJ-054	Khushi	Jayant 	Jain	2008-03-04	17	Female	9326222411	khushimjain08@gmail.com	707, Jal , Indraprastha Society 	Satyanagar , Borivali West , Mumbai -92	Mumbai 	Mumbai 	Maharashtra 	400092	India	studied till jeevvichar 	hsc boards	Science Architecture 	Student	\N	art and craft, , drawing 	\N	Sahebji 	Graphic Design & Video Editing	Event Planning & Management	\N	Flexible	9 hours 30 mins	Voluntary (Seva-based)	$2a$06$36K6tRBc25ldVAv7e84cOeaCCezEse3H7JKetfk2p46blUjrYHXc.	2026-02-13 13:38:15.607808+00	2026-02-13 15:20:51.394857+00	{"Defending Jainism on Social media & digital platforms"}	Shree Kalyankari Jain Sangh Satyanagar 	Aayushi Sanghavi	\N	Intern	\N
5a4cbc48-bacb-4728-b9f0-34fe766d9f19	ILJ-057	Nikita	\N	Doshi	1990-06-08	35	Female	8850239182	nikita.doshi08@gmail.com	B-603 Atharv Laxmi	Vile Parle (east)	Mumbai	Mumbai	Maharashtra	400057	India	\N	Masters	Information Management 	Freelancer / Self-Employed	\N	\N	\N	\N	Research & Documentation	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$aLXrvj0Fl4uSJNxb9m9F.uyJl43HLm/ldrt/w/YInEgOSYHw8bqpq	2026-02-16 15:48:18.500292+00	2026-02-16 15:48:18.500292+00	{}	\N	\N	\N	Intern	\N
50ac0f99-6e54-4ab2-bdbd-83463583261a	ILJ-055	Vanshi	jayesh 	vora	2009-04-28	16	Female	9702489256	vanshivora28@gmail.com	A/403 jalaram krupa	nehru road ganpati mandir 	thane	dombivali 	maharashtra 	421201	Indiz	\N	10th pass	Commerce	Student	\N	Dancing 	Drama and dance	\N	Public Speaking, Acting & Stage Activities	Photography & Videography	Marketing & Outreach	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$yS44jowMW2zTsgQjpeUT/etsOMVWmM1rNdQzJpsZ2OA5g5ELrnNtq	2026-02-13 19:50:58.798661+00	2026-02-15 17:18:44.19224+00	{"Defending Jainism on Social media & digital platforms"}	Rakhi	Aayushi Sanghavi	\N	Intern	\N
3d3fb26d-7d06-4d4f-b44d-77831d29ccb5	ILJ-056	Aesha 	Naitik 	Mehta	1998-12-29	27	Female	+917715076582	aeshapshah153@gmail.com	Sangitawadi	Dombivli East 	Thane 	Dombivali	Maharashtra	421201	India	Guruvandan Bhashya 	M.com	Commerce 	Homemaker	\N	Reading, writing, dancing, acting 	Creative , intrested in shashan activities 	Aayushi ben	Content Writing (Articles, Blogs, Scripts)	Pathshala & Educational Activities	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$QI3H.PkZswAMf0J73BqjreNuLbzzcMdwVSF8FQ.p/TDnPTnv432n6	2026-02-16 15:24:52.337521+00	2026-02-16 15:29:11.453875+00	{"Defending Jainism On-field engagement"}	\N	\N	\N	Intern	\N
f24c03cf-533a-4334-badc-b450e0ac0a6b	ILJ-058	Ariha	Manish	Parekh	2009-02-01	17	Female	9892745362	arihaaparekh01@gmail.com	402,Tulsa Niwas Opp. Matruchaya 	Near babji ki jhopdi satyadhyan vidyapith marg 	Thane District 	MUMBAI SUBURBAN	MAHARASHTRA	400080	India	2 Pratikraman Complete \n5th Std Exam Complete 	Currently in 12th std	Persuing Engineering 	Student	\N	Like to do coding and public speaking	Learning coding and a good speaker	\N	IT & Technical Support	Public Speaking, Acting & Stage Activities	\N	Weekends	30 mins	Voluntary (Seva-based)	$2a$06$TnTfPpwX/0DC2mGju6.OaO7Z4eMD0XHvBK6bGANh.bIWhH02vFmZK	2026-02-16 15:50:48.487191+00	2026-02-16 15:50:48.487191+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Zaver Road Sangh Mulund West 	\N	\N	Intern	\N
46d8f688-8929-4f4e-9c02-c1db1a0669ea	ILJ-059	Prisha	Jignesh 	Parmani 	2008-05-15	17	Female	9321359084 	prishaparmani15@gmail.com	Mayuri Building, No 38,Flat number 67	Anand Nagar Dhaisar East 	Mumbai	Mumbai 	Maharashtra	400068	India 	None	12th, would be pursuing neet for mbbs	Science	Student	\N	Speaking, planning, managing, debates	Researching, public speaking	\N	Public Speaking, Acting & Stage Activities	\N	\N	Flexible	1 hour	Voluntary (Seva-based)	$2a$06$Ai1sAsja444zUHMpKsYuKeM/fNoaaL4tzdcSYpawf9nLbT8wESzCu	2026-02-17 13:14:06.601195+00	2026-02-17 13:14:06.601195+00	{"Defending Jainism On-field engagement"}	Nityanand	\N	\N	Intern	\N
a3b8c438-de9a-46b9-b7d5-f9025bc4a1f3	ILJ-060	Twisha 	Kalpesh 	Gandhi	2005-01-02	21	Female	8591189470	twishagandhi363@gmail.com	17 4th floor Sai dham nss road opposite gopi mall Dombivli west 	17 4th floor Sai dham nss road opposite gopi mall Dombivli west 	Thane	Dombivli 	Maharashtra 	421202	India	\N	Baf	Commerce 	Freelancer / Self-Employed	\N	\N	\N	\N	Public Speaking, Acting & Stage Activities	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$sEu16gCPJWobxtCgbVEr0.twuXQrqf41weKDfWa00Jfnh11XQMDxq	2026-02-18 06:36:07.35355+00	2026-02-18 06:36:07.35355+00	{"Defending Jainism On-field engagement","Building Community & Government Relations","Defending Jainism on Social media & digital platforms"}	Naminath jain shangh	\N	\N	Intern	\N
1e3aa9c8-444d-4a0e-970a-d0cec6b1fefd	ILJ-061	aashi	mahesh	maru	2008-10-18	17	Female	9322893350	aashimaru2008@gmail.com	301,Manjunath Tower	opp Miraj Cinema	thane	dombivli	Maharashtra	421201	India	chaitya vandan	12 pursuing 	commerce	Student	\N	music	editing	deepali shah	Graphic Design & Video Editing	Photography & Videography	\N	Weekends	4 hours	Voluntary (Seva-based)	$2a$06$VaPoRaXes5J4/J3TNx0PbuUTiCaX0yopTBNlvQbrUhY1y2hwRIU6G	2026-02-18 10:03:56.589594+00	2026-02-18 10:05:51.348805+00	{"Defending Jainism on Social media & digital platforms"}	Achalgach	\N	\N	Intern	\N
643db578-c5a7-422f-ad51-1ba67a0db590	ILJ-062	Dhruv 	Mitul	Gandhi	2008-04-27	17	Male	9082169119	dhruvgandhi0506@gmail.com	B/410, om rinkoo apartment 	Savarkar road 	Thane	Dombivli 	MAHARASHTRA	421201	India	5 pratikraman	12th	Commerce	Student	\N	\N	\N	\N	Event Planning & Management	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$Vsjhrv5Lf68w8JwnsgFiAOO9T6p69P4QI9RQofWxkAaRfInGzDCG6	2026-02-18 15:58:57.376591+00	2026-02-18 15:58:57.376591+00	{"Defending Jainism On-field engagement"}	Shri jai naminath shwetambar murtipujak tappagach jain sangh 	\N	\N	Intern	\N
ed7667f3-e2c6-4a77-ba9a-6d820d16e1a0	ILJ-064	Nidhee	Mukesh	Vora	2001-08-27	24	Female	8850042706	nidhivora83@gmail.com	D-5 nav vrushali society 	Aagarkar road 	Kalyan	DOMBIVLI EAST	Maharashtra 	421201	India	Dandak	CA, LLB	Commerce, Law	Working Professional	\N	Reading, Drawing, Dancing	Drawing, organize 	\N	Event Planning & Management	\N	\N	Weekends	\N	Voluntary (Seva-based)	$2a$06$XfkXUP60WzETQnmSAoEYceDOX2wGHxeSBvXpaCJTSHkbKUKQQPke6	2026-02-18 16:18:26.033731+00	2026-02-18 16:20:40.84661+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Jay naminath shwetambar murtipujak tapagach jain sangh (rakhi)	\N	\N	Intern	\N
69fbfc39-3ac0-4972-93fb-317e3e50219b	ILJ-063	Labdhi 	Mukesh	Vora	2005-07-28	20	Female	+91 85914 76735	labdhivora1@gmail.com	D/5, Nav Vrushali Society 	Aagarkar Road	Thane	Dombivli 	MAHARASHTRA	421201	India	Shakrastav 	Pursuing BBA LL.B (Third year)	Law	Student	\N	Reading, drawing, 	Researching, organizing 	\N	Research & Documentation	\N	\N	Flexible	\N	Voluntary (Seva-based)	$2a$06$LxuE1lA65sPR7pcRwEVkxuAFLGFQi.IdW7.H3DuhVlQKiNrGjFaeG	2026-02-18 16:17:34.355151+00	2026-02-18 16:21:18.000398+00	{"Defending Jainism On-field engagement","Defending Jainism on Social media & digital platforms","Building Community & Government Relations"}	Jai Naminath Shwetamber Murtipujak Tapagach Jain Sangh	\N	\N	Intern	\N
7c5cb4d3-d911-4ec5-a435-e651d30c13ab	ILJ-065	Virti	9326206167	Gandhi	2009-04-28	16	Female	9326206167	virtigandhi28@gmail.com	B-208,Om yamuna madhav, Veer Savarkar road 	Dombivali east	Thane	Dombivali 	MAHARASHTRA	421201	India	5 pratikraman completed,jivichar completed, learning nav tatva currently 	10th passed by 96%	Commerce 	Student	\N	Art,rangoli, paintings etc	Mehndi artist,artist	Muktimandan m.s	Public Speaking, Acting & Stage Activities	\N	\N	Weekends	\N	Flexible / Open to Discussion	$2a$06$su0TTA8AeUMUZrrKW0SFFehKoWrMmc7GIY1Gs4X4b6mDzjTKs50bC	2026-02-18 17:05:42.536061+00	2026-02-18 17:05:42.536061+00	{}	Neminath shwetambar murtipujak jain sangh	\N	\N	Intern	\N
47485610-8800-4c02-ac12-90808a9ecb94	ILJ-066	Anjali	Mayank 	Vasa 	1997-06-30	28	Female	8767340326	91shah.anjali@gmail.com	A6/302, Vaibhav CHS Ltd, Anand Nagar 	Dahisar East 	Borivali 	Mumbai	Maharashtra 	400068 	India 	Started lately 	M.A.	Arts	Homemaker	\N	Arts, craft	Designing	\N	Pathshala & Educational Activities	Marketing & Outreach	Event Planning & Management	Flexible	30 mins	Voluntary (Seva-based)	$2a$06$wXKb2N5LYWraIPiCZ9BAfeqzDzjWpQBk1wwimVWJulgg4dyiVfqUW	2026-02-18 17:14:02.989741+00	2026-02-18 17:14:02.989741+00	{}	Nityanand Murtipujak Shwetamber Jain Sangh	\N	\N	Intern	\N
57c08aaa-e760-48dd-9772-d8fbea00e722	ILJ-067	Sneha	Karan 	Kothari	1987-09-06	38	Female	9869316823	snehakaran.sk@gmail.com	303, ketan appartment, near Ambika hotel above Rakesh jewellers 	Phadke road 	Thane 	Dombivli 	Maharashtra 	421202	Indian 	5 partikam 	Ty b.com	Games	Homemaker	\N	Cricket, sports 	Ghauli 	Sneha 	Pathshala & Educational Activities	\N	\N	Flexible	1 hour	Flexible / Open to Discussion	$2a$06$dJ6gpCXIQQ.tqsvxtmxW7eRz74Eh1ZaUUiYqWSdMJZHuISPR9U5KO	2026-02-18 18:17:14.004636+00	2026-02-18 18:17:14.004636+00	{}	Rajsthan sangh 	\N	\N	Intern	\N
34e80f19-ddbe-46bf-9a65-83c81104b974	ILJ-069	Labdhi 	Abhay 	Shah	2008-10-16	17	Female	7977800558	labdhi1608@gmail.com	302, Navkar heights 	Bapudatar road near joshi High school 	Thane	Dombivali 	Maharashtra 	421201	India 	Till 2 pratikraman book 	Currently in 12th 	Commerce 	Student	\N	Creativity volunteering 	Creative skills, and some technical skills	\N	Photography & Videography	Pathshala & Educational Activities	\N	Weekends	1 hour	Voluntary (Seva-based)	$2a$06$r8M0hmyRl2MIQMu25.auz.sMgWhtLImLJ.IqLUTrXunzpjy2I3QSm	2026-02-19 05:30:40.91807+00	2026-02-19 05:30:40.91807+00	{"Defending Jainism on Social media & digital platforms"}	Rudhivardhak Parasmani jain sangh 	\N	\N	Intern	\N
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
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-10 15:48:39.61115
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
72e27a5f-755e-4b82-b6e5-cbba9405b6e0	project-banners	0.706425260224533.jpg	\N	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	2026-01-28 19:27:09.702712+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-28T19:27:10.000Z", "contentLength": 251852, "httpStatusCode": 200}	f13f4acd-bd68-4ae7-96c9-15af2f3a105f	\N	{}
aa35cd30-0cfd-4a0a-88c6-ff7822b3b0c1	project-banners	0.7498233647525495.jpg	\N	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	2026-01-29 07:29:08.050945+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T07:29:08.000Z", "contentLength": 251852, "httpStatusCode": 200}	47a0c27e-9b47-4fe6-abd9-8099d89fcd5c	\N	{}
34fbbf00-3fff-4697-8b40-4a59756133fb	event-banners	1769679074311.jpg	\N	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	2026-01-29 09:31:15.254418+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T09:31:16.000Z", "contentLength": 251852, "httpStatusCode": 200}	bc02545e-4c51-4a3b-9870-7978f06374db	\N	{}
4d79fac5-70ac-4b6e-9d87-b31dd46649e7	event-banners	1769685751265.jpg	\N	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	2026-01-29 11:22:31.593076+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:22:32.000Z", "contentLength": 251852, "httpStatusCode": 200}	57132961-4797-47e2-aa99-eb20e384b5b1	\N	{}
bcb24dd2-ed2f-4a6e-a7fc-5c341fcb673f	event-banners	1769686948705.jpg	\N	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	2026-01-29 11:42:29.065244+00	{"eTag": "\\"641bee252f3393cf22d1a4ec7985b9ef\\"", "size": 251852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-29T11:42:30.000Z", "contentLength": 251852, "httpStatusCode": 200}	0b984452-cd33-4a33-a986-ef81da510840	\N	{}
29d2010d-8127-449a-97a6-c1fcd352667c	project-banners	0.7966996394579555.jpeg	\N	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	2026-02-01 15:26:53.899246+00	{"eTag": "\\"16a81774f0e4709822c4e1238625879a\\"", "size": 107144, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:26:54.000Z", "contentLength": 107144, "httpStatusCode": 200}	9581a682-011c-4e1e-90cc-40180be59af6	\N	{}
66c54576-ed22-4914-a88e-a21b75227ecd	project-banners	0.44102312685847256.jpeg	\N	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	2026-02-01 15:45:33.305478+00	{"eTag": "\\"a450795afdde0fc5633a3b09102e814b\\"", "size": 93140, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:45:34.000Z", "contentLength": 93140, "httpStatusCode": 200}	15ecb65b-6003-4d81-bde7-74edbf997542	\N	{}
35504c10-c092-4c9e-99dc-829035be3264	project-banners	0.05016668586183837.jpeg	\N	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	2026-02-01 15:57:18.075387+00	{"eTag": "\\"7d9c5a4e3d7c6bf87c0346ca9ec3ae8a\\"", "size": 108083, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T15:57:19.000Z", "contentLength": 108083, "httpStatusCode": 200}	b5053847-6bc8-4fcb-96ad-dfa41fe19de2	\N	{}
1a44bd0e-7c65-41de-8754-31a4a951cdcc	project-banners	0.08290226501735143.jpeg	\N	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	2026-02-01 16:11:09.064232+00	{"eTag": "\\"c71325b64f697407be23c2db3b2e6a1e\\"", "size": 110470, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-01T16:11:09.000Z", "contentLength": 110470, "httpStatusCode": 200}	730b87fd-aba8-40f3-b165-d70fbc9ce907	\N	{}
ddf89632-3734-460a-9a83-09fb8286b662	project-banners	0.4307583412898245.jpeg	\N	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	2026-02-02 12:46:26.591301+00	{"eTag": "\\"2885aa813f3d9c184ed2f9e9cc1d8db2\\"", "size": 116818, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:46:27.000Z", "contentLength": 116818, "httpStatusCode": 200}	769d0dc0-3fb2-424d-88a2-d50233e60460	\N	{}
e828463f-762b-425c-9753-48f49a1788e0	project-banners	0.5921959842517635.jpeg	\N	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	2026-02-02 12:55:04.94035+00	{"eTag": "\\"9d810b69b13ff72672c5e1bbba2dd7d4\\"", "size": 121719, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-02T12:55:05.000Z", "contentLength": 121719, "httpStatusCode": 200}	4b4fcfde-602e-46df-83d7-990ffd85fbb9	\N	{}
7f9d63a7-0e50-4b6d-bbd2-d42a578602f7	event-banners	1770555171144.jpeg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-08 12:52:51.07972+00	2026-02-08 12:52:51.07972+00	2026-02-08 12:52:51.07972+00	{"eTag": "\\"7d9c5a4e3d7c6bf87c0346ca9ec3ae8a\\"", "size": 108083, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-08T12:52:52.000Z", "contentLength": 108083, "httpStatusCode": 200}	73163a7b-40b8-4fb1-86af-9e6f3ce6dabc	35c1bb89-4881-4798-a257-8b714d2017dd	{}
06826b36-c718-4803-bfb9-3b236e2190c6	project-banners	0.9836200471240258.jpg	35c1bb89-4881-4798-a257-8b714d2017dd	2026-02-08 14:19:07.580985+00	2026-02-08 14:19:07.580985+00	2026-02-08 14:19:07.580985+00	{"eTag": "\\"9d810b69b13ff72672c5e1bbba2dd7d4\\"", "size": 121719, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-02-08T14:19:08.000Z", "contentLength": 121719, "httpStatusCode": 200}	713a3527-a82a-4999-b2d7-f545a329bf65	35c1bb89-4881-4798-a257-8b714d2017dd	{}
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
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 100, true);


--
-- Name: ilj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ilj_id_seq', 14, true);


--
-- Name: volunteers_ilj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.volunteers_ilj_id_seq', 69, true);


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
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

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

\unrestrict EQ3ogkajYNChHG9x0FtToJ1RdYtFrbOnHbAv3Ad9wYyvE1xoVxd6hZk2UgjDytr

