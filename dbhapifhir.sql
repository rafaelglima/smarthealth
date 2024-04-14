--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bt2_job_instance; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.bt2_job_instance (
    id character varying(100) NOT NULL,
    job_cancelled boolean NOT NULL,
    cmb_recs_processed integer,
    cmb_recs_per_sec double precision,
    create_time timestamp without time zone NOT NULL,
    cur_gated_step_id character varying(100),
    definition_id character varying(100) NOT NULL,
    definition_ver integer NOT NULL,
    end_time timestamp without time zone,
    error_count integer,
    error_msg character varying(500),
    est_remaining character varying(100),
    fast_tracking boolean,
    params_json character varying(2000),
    params_json_lob oid,
    progress_pct double precision,
    report oid,
    start_time timestamp without time zone,
    stat character varying(20) NOT NULL,
    tot_elapsed_millis integer,
    update_time timestamp without time zone,
    warning_msg character varying(4000),
    work_chunks_purged boolean NOT NULL
);


ALTER TABLE public.bt2_job_instance OWNER TO hapifhir;

--
-- Name: bt2_work_chunk; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.bt2_work_chunk (
    id character varying(100) NOT NULL,
    create_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    error_count integer NOT NULL,
    error_msg character varying(500),
    instance_id character varying(100) NOT NULL,
    definition_id character varying(100) NOT NULL,
    definition_ver integer NOT NULL,
    records_processed integer,
    seq integer NOT NULL,
    chunk_data oid,
    start_time timestamp without time zone,
    stat character varying(20) NOT NULL,
    tgt_step_id character varying(100) NOT NULL,
    update_time timestamp without time zone,
    warning_msg character varying(4000)
);


ALTER TABLE public.bt2_work_chunk OWNER TO hapifhir;

--
-- Name: hfj_binary_storage_blob; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_binary_storage_blob (
    blob_id character varying(200) NOT NULL,
    blob_data oid NOT NULL,
    content_type character varying(100) NOT NULL,
    blob_hash character varying(128),
    published_date timestamp without time zone NOT NULL,
    resource_id character varying(100) NOT NULL,
    blob_size bigint
);


ALTER TABLE public.hfj_binary_storage_blob OWNER TO hapifhir;

--
-- Name: hfj_blk_export_colfile; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_blk_export_colfile (
    pid bigint NOT NULL,
    res_id character varying(100) NOT NULL,
    collection_pid bigint NOT NULL
);


ALTER TABLE public.hfj_blk_export_colfile OWNER TO hapifhir;

--
-- Name: hfj_blk_export_collection; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_blk_export_collection (
    pid bigint NOT NULL,
    type_filter character varying(1000),
    res_type character varying(40) NOT NULL,
    optlock integer NOT NULL,
    job_pid bigint NOT NULL
);


ALTER TABLE public.hfj_blk_export_collection OWNER TO hapifhir;

--
-- Name: hfj_blk_export_job; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_blk_export_job (
    pid bigint NOT NULL,
    created_time timestamp without time zone NOT NULL,
    exp_time timestamp without time zone,
    job_id character varying(36) NOT NULL,
    request character varying(1024) NOT NULL,
    exp_since timestamp without time zone,
    job_status character varying(10) NOT NULL,
    status_message character varying(500),
    status_time timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.hfj_blk_export_job OWNER TO hapifhir;

--
-- Name: hfj_blk_import_job; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_blk_import_job (
    pid bigint NOT NULL,
    batch_size integer NOT NULL,
    file_count integer NOT NULL,
    job_desc character varying(500),
    job_id character varying(36) NOT NULL,
    row_processing_mode character varying(20) NOT NULL,
    job_status character varying(10) NOT NULL,
    status_message character varying(500),
    status_time timestamp without time zone NOT NULL,
    optlock integer NOT NULL
);


ALTER TABLE public.hfj_blk_import_job OWNER TO hapifhir;

--
-- Name: hfj_blk_import_jobfile; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_blk_import_jobfile (
    pid bigint NOT NULL,
    job_contents oid NOT NULL,
    file_description character varying(500),
    file_seq integer NOT NULL,
    tenant_name character varying(200),
    job_pid bigint NOT NULL
);


ALTER TABLE public.hfj_blk_import_jobfile OWNER TO hapifhir;

--
-- Name: hfj_forced_id; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_forced_id (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    forced_id character varying(100) NOT NULL,
    resource_pid bigint NOT NULL,
    resource_type character varying(100) DEFAULT ''::character varying
);


ALTER TABLE public.hfj_forced_id OWNER TO hapifhir;

--
-- Name: hfj_history_tag; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_history_tag (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    tag_id bigint,
    res_ver_pid bigint NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(40) NOT NULL
);


ALTER TABLE public.hfj_history_tag OWNER TO hapifhir;

--
-- Name: hfj_idx_cmb_tok_nu; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_idx_cmb_tok_nu (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    hash_complete bigint NOT NULL,
    idx_string character varying(500) NOT NULL,
    res_id bigint
);


ALTER TABLE public.hfj_idx_cmb_tok_nu OWNER TO hapifhir;

--
-- Name: hfj_idx_cmp_string_uniq; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_idx_cmp_string_uniq (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    idx_string character varying(500) NOT NULL,
    res_id bigint
);


ALTER TABLE public.hfj_idx_cmp_string_uniq OWNER TO hapifhir;

--
-- Name: hfj_partition; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_partition (
    part_id integer NOT NULL,
    part_desc character varying(200),
    part_name character varying(200) NOT NULL
);


ALTER TABLE public.hfj_partition OWNER TO hapifhir;

--
-- Name: hfj_res_link; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_link (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    src_path character varying(500) NOT NULL,
    src_resource_id bigint NOT NULL,
    source_resource_type character varying(40) NOT NULL,
    target_resource_id bigint,
    target_resource_type character varying(40) NOT NULL,
    target_resource_url character varying(200),
    target_resource_version bigint,
    sp_updated timestamp without time zone
);


ALTER TABLE public.hfj_res_link OWNER TO hapifhir;

--
-- Name: hfj_res_param_present; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_param_present (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    hash_presence bigint,
    sp_present boolean NOT NULL,
    res_id bigint NOT NULL
);


ALTER TABLE public.hfj_res_param_present OWNER TO hapifhir;

--
-- Name: hfj_res_reindex_job; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_reindex_job (
    pid bigint NOT NULL,
    job_deleted boolean NOT NULL,
    reindex_count integer,
    res_type character varying(100),
    suspended_until timestamp without time zone,
    update_threshold_high timestamp without time zone NOT NULL,
    update_threshold_low timestamp without time zone
);


ALTER TABLE public.hfj_res_reindex_job OWNER TO hapifhir;

--
-- Name: hfj_res_search_url; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_search_url (
    res_search_url character varying(768) NOT NULL,
    created_time timestamp without time zone NOT NULL,
    res_id bigint NOT NULL
);


ALTER TABLE public.hfj_res_search_url OWNER TO hapifhir;

--
-- Name: hfj_res_tag; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_tag (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    tag_id bigint,
    res_id bigint,
    res_type character varying(40) NOT NULL
);


ALTER TABLE public.hfj_res_tag OWNER TO hapifhir;

--
-- Name: hfj_res_ver; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_ver (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    res_deleted_at timestamp without time zone,
    res_version character varying(7),
    has_tags boolean NOT NULL,
    res_published timestamp without time zone NOT NULL,
    res_updated timestamp without time zone NOT NULL,
    res_encoding character varying(5) NOT NULL,
    request_id character varying(16),
    res_text oid,
    res_id bigint NOT NULL,
    res_text_vc text,
    res_type character varying(40) NOT NULL,
    res_ver bigint NOT NULL,
    source_uri character varying(100)
);


ALTER TABLE public.hfj_res_ver OWNER TO hapifhir;

--
-- Name: hfj_res_ver_prov; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_res_ver_prov (
    res_ver_pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    request_id character varying(16),
    source_uri character varying(100),
    res_pid bigint NOT NULL
);


ALTER TABLE public.hfj_res_ver_prov OWNER TO hapifhir;

--
-- Name: hfj_resource; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_resource (
    res_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    res_deleted_at timestamp without time zone,
    res_version character varying(7),
    has_tags boolean NOT NULL,
    res_published timestamp without time zone NOT NULL,
    res_updated timestamp without time zone NOT NULL,
    fhir_id character varying(64),
    sp_has_links boolean,
    hash_sha256 character varying(64),
    sp_index_status bigint,
    res_language character varying(20),
    sp_cmpstr_uniq_present boolean,
    sp_cmptoks_present boolean,
    sp_coords_present boolean,
    sp_date_present boolean,
    sp_number_present boolean,
    sp_quantity_nrml_present boolean,
    sp_quantity_present boolean,
    sp_string_present boolean,
    sp_token_present boolean,
    sp_uri_present boolean,
    res_type character varying(40) NOT NULL,
    search_url_present boolean,
    res_ver bigint
);


ALTER TABLE public.hfj_resource OWNER TO hapifhir;

--
-- Name: hfj_resource_modified; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_resource_modified (
    res_id character varying(256) NOT NULL,
    res_ver character varying(8) NOT NULL,
    created_time timestamp without time zone NOT NULL,
    resource_type character varying(40) NOT NULL,
    summary_message character varying(4000) NOT NULL
);


ALTER TABLE public.hfj_resource_modified OWNER TO hapifhir;

--
-- Name: hfj_revinfo; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_revinfo (
    rev bigint NOT NULL,
    revtstmp timestamp without time zone
);


ALTER TABLE public.hfj_revinfo OWNER TO hapifhir;

--
-- Name: hfj_search; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_search (
    pid bigint NOT NULL,
    created timestamp without time zone NOT NULL,
    search_deleted boolean,
    expiry_or_null timestamp without time zone,
    failure_code integer,
    failure_message character varying(500),
    last_updated_high timestamp without time zone,
    last_updated_low timestamp without time zone,
    num_blocked integer,
    num_found integer NOT NULL,
    preferred_page_size integer,
    resource_id bigint,
    resource_type character varying(200),
    search_param_map oid,
    search_query_string oid,
    search_query_string_hash integer,
    search_type integer NOT NULL,
    search_status character varying(10) NOT NULL,
    total_count integer,
    search_uuid character varying(48) NOT NULL,
    optlock_version integer
);


ALTER TABLE public.hfj_search OWNER TO hapifhir;

--
-- Name: hfj_search_include; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_search_include (
    pid bigint NOT NULL,
    search_include character varying(200) NOT NULL,
    inc_recurse boolean NOT NULL,
    revinclude boolean NOT NULL,
    search_pid bigint NOT NULL
);


ALTER TABLE public.hfj_search_include OWNER TO hapifhir;

--
-- Name: hfj_search_result; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_search_result (
    pid bigint NOT NULL,
    search_order integer NOT NULL,
    resource_pid bigint NOT NULL,
    search_pid bigint NOT NULL
);


ALTER TABLE public.hfj_search_result OWNER TO hapifhir;

--
-- Name: hfj_spidx_coords; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_coords (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    sp_latitude double precision,
    sp_longitude double precision
);


ALTER TABLE public.hfj_spidx_coords OWNER TO hapifhir;

--
-- Name: hfj_spidx_date; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_date (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    sp_value_high timestamp without time zone,
    sp_value_high_date_ordinal integer,
    sp_value_low timestamp without time zone,
    sp_value_low_date_ordinal integer
);


ALTER TABLE public.hfj_spidx_date OWNER TO hapifhir;

--
-- Name: hfj_spidx_number; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_number (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    sp_value numeric(19,2)
);


ALTER TABLE public.hfj_spidx_number OWNER TO hapifhir;

--
-- Name: hfj_spidx_quantity; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_quantity (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    hash_identity_and_units bigint,
    hash_identity_sys_units bigint,
    sp_system character varying(200),
    sp_units character varying(200),
    sp_value double precision
);


ALTER TABLE public.hfj_spidx_quantity OWNER TO hapifhir;

--
-- Name: hfj_spidx_quantity_nrml; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_quantity_nrml (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    hash_identity_and_units bigint,
    hash_identity_sys_units bigint,
    sp_system character varying(200),
    sp_units character varying(200),
    sp_value double precision
);


ALTER TABLE public.hfj_spidx_quantity_nrml OWNER TO hapifhir;

--
-- Name: hfj_spidx_string; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_string (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_exact bigint,
    hash_identity bigint,
    hash_norm_prefix bigint,
    sp_value_exact character varying(200),
    sp_value_normalized character varying(200)
);


ALTER TABLE public.hfj_spidx_string OWNER TO hapifhir;

--
-- Name: hfj_spidx_token; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_token (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    hash_sys bigint,
    hash_sys_and_value bigint,
    hash_value bigint,
    sp_system character varying(200),
    sp_value character varying(200)
);


ALTER TABLE public.hfj_spidx_token OWNER TO hapifhir;

--
-- Name: hfj_spidx_uri; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_spidx_uri (
    sp_id bigint NOT NULL,
    partition_date date,
    partition_id integer,
    sp_missing boolean NOT NULL,
    sp_name character varying(100) NOT NULL,
    res_id bigint NOT NULL,
    res_type character varying(100) NOT NULL,
    sp_updated timestamp without time zone,
    hash_identity bigint,
    hash_uri bigint,
    sp_uri character varying(500)
);


ALTER TABLE public.hfj_spidx_uri OWNER TO hapifhir;

--
-- Name: hfj_subscription_stats; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_subscription_stats (
    pid bigint NOT NULL,
    created_time timestamp without time zone NOT NULL,
    res_id bigint
);


ALTER TABLE public.hfj_subscription_stats OWNER TO hapifhir;

--
-- Name: hfj_tag_def; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.hfj_tag_def (
    tag_id bigint NOT NULL,
    tag_code character varying(200),
    tag_display character varying(200),
    tag_system character varying(200),
    tag_type integer NOT NULL,
    tag_user_selected boolean,
    tag_version character varying(30)
);


ALTER TABLE public.hfj_tag_def OWNER TO hapifhir;

--
-- Name: mpi_link; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.mpi_link (
    pid bigint NOT NULL,
    partition_date date,
    partition_id integer,
    created timestamp without time zone NOT NULL,
    eid_match boolean,
    golden_resource_pid bigint NOT NULL,
    new_person boolean,
    link_source integer NOT NULL,
    match_result integer NOT NULL,
    target_type character varying(40),
    person_pid bigint NOT NULL,
    rule_count bigint,
    score double precision,
    target_pid bigint NOT NULL,
    updated timestamp without time zone NOT NULL,
    vector bigint,
    version character varying(16) NOT NULL
);


ALTER TABLE public.mpi_link OWNER TO hapifhir;

--
-- Name: mpi_link_aud; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.mpi_link_aud (
    pid bigint NOT NULL,
    rev bigint NOT NULL,
    revtype smallint,
    partition_date date,
    partition_id integer,
    created timestamp without time zone,
    eid_match boolean,
    golden_resource_pid bigint,
    new_person boolean,
    link_source integer,
    match_result integer,
    target_type character varying(40),
    person_pid bigint,
    rule_count bigint,
    score double precision,
    target_pid bigint,
    updated timestamp without time zone,
    vector bigint,
    version character varying(16)
);


ALTER TABLE public.mpi_link_aud OWNER TO hapifhir;

--
-- Name: npm_package; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.npm_package (
    pid bigint NOT NULL,
    cur_version_id character varying(200),
    package_desc character varying(200),
    package_id character varying(200) NOT NULL,
    updated_time timestamp without time zone NOT NULL
);


ALTER TABLE public.npm_package OWNER TO hapifhir;

--
-- Name: npm_package_ver; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.npm_package_ver (
    pid bigint NOT NULL,
    current_version boolean NOT NULL,
    pkg_desc character varying(200),
    desc_upper character varying(200),
    fhir_version character varying(10) NOT NULL,
    fhir_version_id character varying(20) NOT NULL,
    package_id character varying(200) NOT NULL,
    package_size_bytes bigint NOT NULL,
    saved_time timestamp without time zone NOT NULL,
    updated_time timestamp without time zone NOT NULL,
    version_id character varying(200) NOT NULL,
    package_pid bigint NOT NULL,
    binary_res_id bigint NOT NULL
);


ALTER TABLE public.npm_package_ver OWNER TO hapifhir;

--
-- Name: npm_package_ver_res; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.npm_package_ver_res (
    pid bigint NOT NULL,
    canonical_url character varying(200),
    canonical_version character varying(200),
    file_dir character varying(200),
    fhir_version character varying(10) NOT NULL,
    fhir_version_id character varying(20) NOT NULL,
    file_name character varying(200),
    res_size_bytes bigint NOT NULL,
    res_type character varying(40) NOT NULL,
    updated_time timestamp without time zone NOT NULL,
    packver_pid bigint NOT NULL,
    binary_res_id bigint NOT NULL
);


ALTER TABLE public.npm_package_ver_res OWNER TO hapifhir;

--
-- Name: seq_blkexcol_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_blkexcol_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_blkexcol_pid OWNER TO hapifhir;

--
-- Name: seq_blkexcolfile_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_blkexcolfile_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_blkexcolfile_pid OWNER TO hapifhir;

--
-- Name: seq_blkexjob_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_blkexjob_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_blkexjob_pid OWNER TO hapifhir;

--
-- Name: seq_blkimjob_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_blkimjob_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_blkimjob_pid OWNER TO hapifhir;

--
-- Name: seq_blkimjobfile_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_blkimjobfile_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_blkimjobfile_pid OWNER TO hapifhir;

--
-- Name: seq_cncpt_map_grp_elm_tgt_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_cncpt_map_grp_elm_tgt_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_cncpt_map_grp_elm_tgt_pid OWNER TO hapifhir;

--
-- Name: seq_codesystem_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_codesystem_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_codesystem_pid OWNER TO hapifhir;

--
-- Name: seq_codesystemver_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_codesystemver_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_codesystemver_pid OWNER TO hapifhir;

--
-- Name: seq_concept_desig_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_desig_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_desig_pid OWNER TO hapifhir;

--
-- Name: seq_concept_map_group_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_map_group_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_map_group_pid OWNER TO hapifhir;

--
-- Name: seq_concept_map_grp_elm_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_map_grp_elm_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_map_grp_elm_pid OWNER TO hapifhir;

--
-- Name: seq_concept_map_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_map_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_map_pid OWNER TO hapifhir;

--
-- Name: seq_concept_pc_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_pc_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_pc_pid OWNER TO hapifhir;

--
-- Name: seq_concept_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_pid OWNER TO hapifhir;

--
-- Name: seq_concept_prop_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_concept_prop_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_concept_prop_pid OWNER TO hapifhir;

--
-- Name: seq_empi_link_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_empi_link_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_empi_link_id OWNER TO hapifhir;

--
-- Name: seq_forcedid_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_forcedid_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_forcedid_id OWNER TO hapifhir;

--
-- Name: seq_hfj_revinfo; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_hfj_revinfo
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_hfj_revinfo OWNER TO hapifhir;

--
-- Name: seq_historytag_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_historytag_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_historytag_id OWNER TO hapifhir;

--
-- Name: seq_idxcmbtoknu_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_idxcmbtoknu_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_idxcmbtoknu_id OWNER TO hapifhir;

--
-- Name: seq_idxcmpstruniq_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_idxcmpstruniq_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_idxcmpstruniq_id OWNER TO hapifhir;

--
-- Name: seq_npm_pack; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_npm_pack
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_npm_pack OWNER TO hapifhir;

--
-- Name: seq_npm_packver; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_npm_packver
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_npm_packver OWNER TO hapifhir;

--
-- Name: seq_npm_packverres; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_npm_packverres
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_npm_packverres OWNER TO hapifhir;

--
-- Name: seq_res_reindex_job; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_res_reindex_job
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_res_reindex_job OWNER TO hapifhir;

--
-- Name: seq_reslink_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_reslink_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_reslink_id OWNER TO hapifhir;

--
-- Name: seq_resource_history_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_resource_history_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_resource_history_id OWNER TO hapifhir;

--
-- Name: seq_resource_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_resource_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_resource_id OWNER TO hapifhir;

--
-- Name: seq_resparmpresent_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_resparmpresent_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_resparmpresent_id OWNER TO hapifhir;

--
-- Name: seq_restag_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_restag_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_restag_id OWNER TO hapifhir;

--
-- Name: seq_search; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_search
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_search OWNER TO hapifhir;

--
-- Name: seq_search_inc; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_search_inc
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_search_inc OWNER TO hapifhir;

--
-- Name: seq_search_res; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_search_res
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_search_res OWNER TO hapifhir;

--
-- Name: seq_spidx_coords; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_coords
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_coords OWNER TO hapifhir;

--
-- Name: seq_spidx_date; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_date
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_date OWNER TO hapifhir;

--
-- Name: seq_spidx_number; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_number
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_number OWNER TO hapifhir;

--
-- Name: seq_spidx_quantity; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_quantity
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_quantity OWNER TO hapifhir;

--
-- Name: seq_spidx_quantity_nrml; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_quantity_nrml
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_quantity_nrml OWNER TO hapifhir;

--
-- Name: seq_spidx_string; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_string
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_string OWNER TO hapifhir;

--
-- Name: seq_spidx_token; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_token
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_token OWNER TO hapifhir;

--
-- Name: seq_spidx_uri; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_spidx_uri
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_spidx_uri OWNER TO hapifhir;

--
-- Name: seq_subscription_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_subscription_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_subscription_id OWNER TO hapifhir;

--
-- Name: seq_tagdef_id; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_tagdef_id
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_tagdef_id OWNER TO hapifhir;

--
-- Name: seq_valueset_c_dsgntn_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_valueset_c_dsgntn_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_valueset_c_dsgntn_pid OWNER TO hapifhir;

--
-- Name: seq_valueset_concept_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_valueset_concept_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_valueset_concept_pid OWNER TO hapifhir;

--
-- Name: seq_valueset_pid; Type: SEQUENCE; Schema: public; Owner: hapifhir
--

CREATE SEQUENCE public.seq_valueset_pid
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_valueset_pid OWNER TO hapifhir;

--
-- Name: trm_codesystem; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_codesystem (
    pid bigint NOT NULL,
    code_system_uri character varying(200) NOT NULL,
    current_version_pid bigint,
    cs_name character varying(200),
    res_id bigint
);


ALTER TABLE public.trm_codesystem OWNER TO hapifhir;

--
-- Name: trm_codesystem_ver; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_codesystem_ver (
    pid bigint NOT NULL,
    cs_display character varying(200),
    codesystem_pid bigint,
    cs_version_id character varying(200),
    res_id bigint NOT NULL
);


ALTER TABLE public.trm_codesystem_ver OWNER TO hapifhir;

--
-- Name: trm_concept; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept (
    pid bigint NOT NULL,
    codeval character varying(500) NOT NULL,
    codesystem_pid bigint,
    display character varying(400),
    index_status bigint,
    parent_pids oid,
    code_sequence integer,
    concept_updated timestamp without time zone
);


ALTER TABLE public.trm_concept OWNER TO hapifhir;

--
-- Name: trm_concept_desig; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_desig (
    pid bigint NOT NULL,
    lang character varying(500),
    use_code character varying(500),
    use_display character varying(500),
    use_system character varying(500),
    val character varying(2000) NOT NULL,
    cs_ver_pid bigint,
    concept_pid bigint
);


ALTER TABLE public.trm_concept_desig OWNER TO hapifhir;

--
-- Name: trm_concept_map; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_map (
    pid bigint NOT NULL,
    res_id bigint,
    source_url character varying(200),
    target_url character varying(200),
    url character varying(200) NOT NULL,
    ver character varying(200)
);


ALTER TABLE public.trm_concept_map OWNER TO hapifhir;

--
-- Name: trm_concept_map_group; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_map_group (
    pid bigint NOT NULL,
    concept_map_url character varying(200),
    source_url character varying(200) NOT NULL,
    source_vs character varying(200),
    source_version character varying(200),
    target_url character varying(200) NOT NULL,
    target_vs character varying(200),
    target_version character varying(200),
    concept_map_pid bigint NOT NULL
);


ALTER TABLE public.trm_concept_map_group OWNER TO hapifhir;

--
-- Name: trm_concept_map_grp_element; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_map_grp_element (
    pid bigint NOT NULL,
    source_code character varying(500) NOT NULL,
    concept_map_url character varying(200),
    source_display character varying(500),
    system_url character varying(200),
    system_version character varying(200),
    valueset_url character varying(200),
    concept_map_group_pid bigint NOT NULL
);


ALTER TABLE public.trm_concept_map_grp_element OWNER TO hapifhir;

--
-- Name: trm_concept_map_grp_elm_tgt; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_map_grp_elm_tgt (
    pid bigint NOT NULL,
    target_code character varying(500) NOT NULL,
    concept_map_url character varying(200),
    target_display character varying(500),
    target_equivalence character varying(50),
    system_url character varying(200),
    system_version character varying(200),
    valueset_url character varying(200),
    concept_map_grp_elm_pid bigint NOT NULL
);


ALTER TABLE public.trm_concept_map_grp_elm_tgt OWNER TO hapifhir;

--
-- Name: trm_concept_pc_link; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_pc_link (
    pid bigint NOT NULL,
    child_pid bigint,
    codesystem_pid bigint NOT NULL,
    parent_pid bigint,
    rel_type integer
);


ALTER TABLE public.trm_concept_pc_link OWNER TO hapifhir;

--
-- Name: trm_concept_property; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_concept_property (
    pid bigint NOT NULL,
    prop_codesystem character varying(500),
    prop_display character varying(500),
    prop_key character varying(500) NOT NULL,
    prop_type integer NOT NULL,
    prop_val character varying(500),
    prop_val_lob oid,
    cs_ver_pid bigint,
    concept_pid bigint
);


ALTER TABLE public.trm_concept_property OWNER TO hapifhir;

--
-- Name: trm_valueset; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_valueset (
    pid bigint NOT NULL,
    expansion_status character varying(50) NOT NULL,
    expanded_at timestamp without time zone,
    vsname character varying(200),
    res_id bigint,
    total_concept_designations bigint DEFAULT 0 NOT NULL,
    total_concepts bigint DEFAULT 0 NOT NULL,
    url character varying(200) NOT NULL,
    ver character varying(200)
);


ALTER TABLE public.trm_valueset OWNER TO hapifhir;

--
-- Name: trm_valueset_c_designation; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_valueset_c_designation (
    pid bigint NOT NULL,
    valueset_concept_pid bigint NOT NULL,
    lang character varying(500),
    use_code character varying(500),
    use_display character varying(500),
    use_system character varying(500),
    val character varying(2000) NOT NULL,
    valueset_pid bigint NOT NULL
);


ALTER TABLE public.trm_valueset_c_designation OWNER TO hapifhir;

--
-- Name: trm_valueset_concept; Type: TABLE; Schema: public; Owner: hapifhir
--

CREATE TABLE public.trm_valueset_concept (
    pid bigint NOT NULL,
    codeval character varying(500) NOT NULL,
    display character varying(400),
    index_status bigint,
    valueset_order integer NOT NULL,
    source_direct_parent_pids oid,
    source_pid bigint,
    system_url character varying(200) NOT NULL,
    system_ver character varying(200),
    valueset_pid bigint NOT NULL
);


ALTER TABLE public.trm_valueset_concept OWNER TO hapifhir;

--
-- Data for Name: bt2_job_instance; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.bt2_job_instance (id, job_cancelled, cmb_recs_processed, cmb_recs_per_sec, create_time, cur_gated_step_id, definition_id, definition_ver, end_time, error_count, error_msg, est_remaining, fast_tracking, params_json, params_json_lob, progress_pct, report, start_time, stat, tot_elapsed_millis, update_time, warning_msg, work_chunks_purged) FROM stdin;
\.


--
-- Data for Name: bt2_work_chunk; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.bt2_work_chunk (id, create_time, end_time, error_count, error_msg, instance_id, definition_id, definition_ver, records_processed, seq, chunk_data, start_time, stat, tgt_step_id, update_time, warning_msg) FROM stdin;
\.


--
-- Data for Name: hfj_binary_storage_blob; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_binary_storage_blob (blob_id, blob_data, content_type, blob_hash, published_date, resource_id, blob_size) FROM stdin;
\.


--
-- Data for Name: hfj_blk_export_colfile; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_blk_export_colfile (pid, res_id, collection_pid) FROM stdin;
\.


--
-- Data for Name: hfj_blk_export_collection; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_blk_export_collection (pid, type_filter, res_type, optlock, job_pid) FROM stdin;
\.


--
-- Data for Name: hfj_blk_export_job; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_blk_export_job (pid, created_time, exp_time, job_id, request, exp_since, job_status, status_message, status_time, optlock) FROM stdin;
\.


--
-- Data for Name: hfj_blk_import_job; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_blk_import_job (pid, batch_size, file_count, job_desc, job_id, row_processing_mode, job_status, status_message, status_time, optlock) FROM stdin;
\.


--
-- Data for Name: hfj_blk_import_jobfile; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_blk_import_jobfile (pid, job_contents, file_description, file_seq, tenant_name, job_pid) FROM stdin;
\.


--
-- Data for Name: hfj_forced_id; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_forced_id (pid, partition_date, partition_id, forced_id, resource_pid, resource_type) FROM stdin;
\.


--
-- Data for Name: hfj_history_tag; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_history_tag (pid, partition_date, partition_id, tag_id, res_ver_pid, res_id, res_type) FROM stdin;
\.


--
-- Data for Name: hfj_idx_cmb_tok_nu; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_idx_cmb_tok_nu (pid, partition_date, partition_id, hash_complete, idx_string, res_id) FROM stdin;
\.


--
-- Data for Name: hfj_idx_cmp_string_uniq; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_idx_cmp_string_uniq (pid, partition_date, partition_id, idx_string, res_id) FROM stdin;
\.


--
-- Data for Name: hfj_partition; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_partition (part_id, part_desc, part_name) FROM stdin;
\.


--
-- Data for Name: hfj_res_link; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_link (pid, partition_date, partition_id, src_path, src_resource_id, source_resource_type, target_resource_id, target_resource_type, target_resource_url, target_resource_version, sp_updated) FROM stdin;
\.


--
-- Data for Name: hfj_res_param_present; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_param_present (pid, partition_date, partition_id, hash_presence, sp_present, res_id) FROM stdin;
\.


--
-- Data for Name: hfj_res_reindex_job; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_reindex_job (pid, job_deleted, reindex_count, res_type, suspended_until, update_threshold_high, update_threshold_low) FROM stdin;
\.


--
-- Data for Name: hfj_res_search_url; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_search_url (res_search_url, created_time, res_id) FROM stdin;
\.


--
-- Data for Name: hfj_res_tag; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_tag (pid, partition_date, partition_id, tag_id, res_id, res_type) FROM stdin;
\.


--
-- Data for Name: hfj_res_ver; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_ver (pid, partition_date, partition_id, res_deleted_at, res_version, has_tags, res_published, res_updated, res_encoding, request_id, res_text, res_id, res_text_vc, res_type, res_ver, source_uri) FROM stdin;
\.


--
-- Data for Name: hfj_res_ver_prov; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_res_ver_prov (res_ver_pid, partition_date, partition_id, request_id, source_uri, res_pid) FROM stdin;
\.


--
-- Data for Name: hfj_resource; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_resource (res_id, partition_date, partition_id, res_deleted_at, res_version, has_tags, res_published, res_updated, fhir_id, sp_has_links, hash_sha256, sp_index_status, res_language, sp_cmpstr_uniq_present, sp_cmptoks_present, sp_coords_present, sp_date_present, sp_number_present, sp_quantity_nrml_present, sp_quantity_present, sp_string_present, sp_token_present, sp_uri_present, res_type, search_url_present, res_ver) FROM stdin;
\.


--
-- Data for Name: hfj_resource_modified; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_resource_modified (res_id, res_ver, created_time, resource_type, summary_message) FROM stdin;
\.


--
-- Data for Name: hfj_revinfo; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_revinfo (rev, revtstmp) FROM stdin;
\.


--
-- Data for Name: hfj_search; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_search (pid, created, search_deleted, expiry_or_null, failure_code, failure_message, last_updated_high, last_updated_low, num_blocked, num_found, preferred_page_size, resource_id, resource_type, search_param_map, search_query_string, search_query_string_hash, search_type, search_status, total_count, search_uuid, optlock_version) FROM stdin;
\.


--
-- Data for Name: hfj_search_include; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_search_include (pid, search_include, inc_recurse, revinclude, search_pid) FROM stdin;
\.


--
-- Data for Name: hfj_search_result; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_search_result (pid, search_order, resource_pid, search_pid) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_coords; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_coords (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, sp_latitude, sp_longitude) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_date; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_date (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, sp_value_high, sp_value_high_date_ordinal, sp_value_low, sp_value_low_date_ordinal) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_number; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_number (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, sp_value) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_quantity; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_quantity (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, hash_identity_and_units, hash_identity_sys_units, sp_system, sp_units, sp_value) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_quantity_nrml; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_quantity_nrml (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, hash_identity_and_units, hash_identity_sys_units, sp_system, sp_units, sp_value) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_string; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_string (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_exact, hash_identity, hash_norm_prefix, sp_value_exact, sp_value_normalized) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_token; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_token (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, hash_sys, hash_sys_and_value, hash_value, sp_system, sp_value) FROM stdin;
\.


--
-- Data for Name: hfj_spidx_uri; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_spidx_uri (sp_id, partition_date, partition_id, sp_missing, sp_name, res_id, res_type, sp_updated, hash_identity, hash_uri, sp_uri) FROM stdin;
\.


--
-- Data for Name: hfj_subscription_stats; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_subscription_stats (pid, created_time, res_id) FROM stdin;
\.


--
-- Data for Name: hfj_tag_def; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.hfj_tag_def (tag_id, tag_code, tag_display, tag_system, tag_type, tag_user_selected, tag_version) FROM stdin;
\.


--
-- Data for Name: mpi_link; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.mpi_link (pid, partition_date, partition_id, created, eid_match, golden_resource_pid, new_person, link_source, match_result, target_type, person_pid, rule_count, score, target_pid, updated, vector, version) FROM stdin;
\.


--
-- Data for Name: mpi_link_aud; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.mpi_link_aud (pid, rev, revtype, partition_date, partition_id, created, eid_match, golden_resource_pid, new_person, link_source, match_result, target_type, person_pid, rule_count, score, target_pid, updated, vector, version) FROM stdin;
\.


--
-- Data for Name: npm_package; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.npm_package (pid, cur_version_id, package_desc, package_id, updated_time) FROM stdin;
\.


--
-- Data for Name: npm_package_ver; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.npm_package_ver (pid, current_version, pkg_desc, desc_upper, fhir_version, fhir_version_id, package_id, package_size_bytes, saved_time, updated_time, version_id, package_pid, binary_res_id) FROM stdin;
\.


--
-- Data for Name: npm_package_ver_res; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.npm_package_ver_res (pid, canonical_url, canonical_version, file_dir, fhir_version, fhir_version_id, file_name, res_size_bytes, res_type, updated_time, packver_pid, binary_res_id) FROM stdin;
\.


--
-- Data for Name: trm_codesystem; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_codesystem (pid, code_system_uri, current_version_pid, cs_name, res_id) FROM stdin;
\.


--
-- Data for Name: trm_codesystem_ver; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_codesystem_ver (pid, cs_display, codesystem_pid, cs_version_id, res_id) FROM stdin;
\.


--
-- Data for Name: trm_concept; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept (pid, codeval, codesystem_pid, display, index_status, parent_pids, code_sequence, concept_updated) FROM stdin;
\.


--
-- Data for Name: trm_concept_desig; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_desig (pid, lang, use_code, use_display, use_system, val, cs_ver_pid, concept_pid) FROM stdin;
\.


--
-- Data for Name: trm_concept_map; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_map (pid, res_id, source_url, target_url, url, ver) FROM stdin;
\.


--
-- Data for Name: trm_concept_map_group; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_map_group (pid, concept_map_url, source_url, source_vs, source_version, target_url, target_vs, target_version, concept_map_pid) FROM stdin;
\.


--
-- Data for Name: trm_concept_map_grp_element; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_map_grp_element (pid, source_code, concept_map_url, source_display, system_url, system_version, valueset_url, concept_map_group_pid) FROM stdin;
\.


--
-- Data for Name: trm_concept_map_grp_elm_tgt; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_map_grp_elm_tgt (pid, target_code, concept_map_url, target_display, target_equivalence, system_url, system_version, valueset_url, concept_map_grp_elm_pid) FROM stdin;
\.


--
-- Data for Name: trm_concept_pc_link; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_pc_link (pid, child_pid, codesystem_pid, parent_pid, rel_type) FROM stdin;
\.


--
-- Data for Name: trm_concept_property; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_concept_property (pid, prop_codesystem, prop_display, prop_key, prop_type, prop_val, prop_val_lob, cs_ver_pid, concept_pid) FROM stdin;
\.


--
-- Data for Name: trm_valueset; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_valueset (pid, expansion_status, expanded_at, vsname, res_id, total_concept_designations, total_concepts, url, ver) FROM stdin;
\.


--
-- Data for Name: trm_valueset_c_designation; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_valueset_c_designation (pid, valueset_concept_pid, lang, use_code, use_display, use_system, val, valueset_pid) FROM stdin;
\.


--
-- Data for Name: trm_valueset_concept; Type: TABLE DATA; Schema: public; Owner: hapifhir
--

COPY public.trm_valueset_concept (pid, codeval, display, index_status, valueset_order, source_direct_parent_pids, source_pid, system_url, system_ver, valueset_pid) FROM stdin;
\.


--
-- Name: seq_blkexcol_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_blkexcol_pid', 1, false);


--
-- Name: seq_blkexcolfile_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_blkexcolfile_pid', 1, false);


--
-- Name: seq_blkexjob_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_blkexjob_pid', 1, false);


--
-- Name: seq_blkimjob_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_blkimjob_pid', 1, false);


--
-- Name: seq_blkimjobfile_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_blkimjobfile_pid', 1, false);


--
-- Name: seq_cncpt_map_grp_elm_tgt_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_cncpt_map_grp_elm_tgt_pid', 1, false);


--
-- Name: seq_codesystem_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_codesystem_pid', 1, false);


--
-- Name: seq_codesystemver_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_codesystemver_pid', 1, false);


--
-- Name: seq_concept_desig_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_desig_pid', 1, false);


--
-- Name: seq_concept_map_group_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_map_group_pid', 1, false);


--
-- Name: seq_concept_map_grp_elm_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_map_grp_elm_pid', 1, false);


--
-- Name: seq_concept_map_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_map_pid', 1, false);


--
-- Name: seq_concept_pc_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_pc_pid', 1, false);


--
-- Name: seq_concept_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_pid', 1, false);


--
-- Name: seq_concept_prop_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_concept_prop_pid', 1, false);


--
-- Name: seq_empi_link_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_empi_link_id', 1, false);


--
-- Name: seq_forcedid_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_forcedid_id', 1, false);


--
-- Name: seq_hfj_revinfo; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_hfj_revinfo', 1, false);


--
-- Name: seq_historytag_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_historytag_id', 1, false);


--
-- Name: seq_idxcmbtoknu_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_idxcmbtoknu_id', 1, false);


--
-- Name: seq_idxcmpstruniq_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_idxcmpstruniq_id', 1, false);


--
-- Name: seq_npm_pack; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_npm_pack', 1, false);


--
-- Name: seq_npm_packver; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_npm_packver', 1, false);


--
-- Name: seq_npm_packverres; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_npm_packverres', 1, false);


--
-- Name: seq_res_reindex_job; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_res_reindex_job', 1, false);


--
-- Name: seq_reslink_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_reslink_id', 1, false);


--
-- Name: seq_resource_history_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_resource_history_id', 1, false);


--
-- Name: seq_resource_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_resource_id', 1, false);


--
-- Name: seq_resparmpresent_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_resparmpresent_id', 1, false);


--
-- Name: seq_restag_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_restag_id', 1, false);


--
-- Name: seq_search; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_search', 1, false);


--
-- Name: seq_search_inc; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_search_inc', 1, false);


--
-- Name: seq_search_res; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_search_res', 1, false);


--
-- Name: seq_spidx_coords; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_coords', 1, false);


--
-- Name: seq_spidx_date; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_date', 1, false);


--
-- Name: seq_spidx_number; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_number', 1, false);


--
-- Name: seq_spidx_quantity; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_quantity', 1, false);


--
-- Name: seq_spidx_quantity_nrml; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_quantity_nrml', 1, false);


--
-- Name: seq_spidx_string; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_string', 1, false);


--
-- Name: seq_spidx_token; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_token', 1, false);


--
-- Name: seq_spidx_uri; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_spidx_uri', 1, false);


--
-- Name: seq_subscription_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_subscription_id', 1, false);


--
-- Name: seq_tagdef_id; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_tagdef_id', 1, false);


--
-- Name: seq_valueset_c_dsgntn_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_valueset_c_dsgntn_pid', 1, false);


--
-- Name: seq_valueset_concept_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_valueset_concept_pid', 1, false);


--
-- Name: seq_valueset_pid; Type: SEQUENCE SET; Schema: public; Owner: hapifhir
--

SELECT pg_catalog.setval('public.seq_valueset_pid', 1, false);


--
-- Name: bt2_job_instance bt2_job_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.bt2_job_instance
    ADD CONSTRAINT bt2_job_instance_pkey PRIMARY KEY (id);


--
-- Name: bt2_work_chunk bt2_work_chunk_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.bt2_work_chunk
    ADD CONSTRAINT bt2_work_chunk_pkey PRIMARY KEY (id);


--
-- Name: hfj_binary_storage_blob hfj_binary_storage_blob_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_binary_storage_blob
    ADD CONSTRAINT hfj_binary_storage_blob_pkey PRIMARY KEY (blob_id);


--
-- Name: hfj_blk_export_colfile hfj_blk_export_colfile_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_colfile
    ADD CONSTRAINT hfj_blk_export_colfile_pkey PRIMARY KEY (pid);


--
-- Name: hfj_blk_export_collection hfj_blk_export_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_collection
    ADD CONSTRAINT hfj_blk_export_collection_pkey PRIMARY KEY (pid);


--
-- Name: hfj_blk_export_job hfj_blk_export_job_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_job
    ADD CONSTRAINT hfj_blk_export_job_pkey PRIMARY KEY (pid);


--
-- Name: hfj_blk_import_job hfj_blk_import_job_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_import_job
    ADD CONSTRAINT hfj_blk_import_job_pkey PRIMARY KEY (pid);


--
-- Name: hfj_blk_import_jobfile hfj_blk_import_jobfile_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_import_jobfile
    ADD CONSTRAINT hfj_blk_import_jobfile_pkey PRIMARY KEY (pid);


--
-- Name: hfj_forced_id hfj_forced_id_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_forced_id
    ADD CONSTRAINT hfj_forced_id_pkey PRIMARY KEY (pid);


--
-- Name: hfj_history_tag hfj_history_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_history_tag
    ADD CONSTRAINT hfj_history_tag_pkey PRIMARY KEY (pid);


--
-- Name: hfj_idx_cmb_tok_nu hfj_idx_cmb_tok_nu_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_idx_cmb_tok_nu
    ADD CONSTRAINT hfj_idx_cmb_tok_nu_pkey PRIMARY KEY (pid);


--
-- Name: hfj_idx_cmp_string_uniq hfj_idx_cmp_string_uniq_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_idx_cmp_string_uniq
    ADD CONSTRAINT hfj_idx_cmp_string_uniq_pkey PRIMARY KEY (pid);


--
-- Name: hfj_partition hfj_partition_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_partition
    ADD CONSTRAINT hfj_partition_pkey PRIMARY KEY (part_id);


--
-- Name: hfj_res_link hfj_res_link_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_link
    ADD CONSTRAINT hfj_res_link_pkey PRIMARY KEY (pid);


--
-- Name: hfj_res_param_present hfj_res_param_present_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_param_present
    ADD CONSTRAINT hfj_res_param_present_pkey PRIMARY KEY (pid);


--
-- Name: hfj_res_reindex_job hfj_res_reindex_job_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_reindex_job
    ADD CONSTRAINT hfj_res_reindex_job_pkey PRIMARY KEY (pid);


--
-- Name: hfj_res_search_url hfj_res_search_url_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_search_url
    ADD CONSTRAINT hfj_res_search_url_pkey PRIMARY KEY (res_search_url);


--
-- Name: hfj_res_tag hfj_res_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_tag
    ADD CONSTRAINT hfj_res_tag_pkey PRIMARY KEY (pid);


--
-- Name: hfj_res_ver hfj_res_ver_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver
    ADD CONSTRAINT hfj_res_ver_pkey PRIMARY KEY (pid);


--
-- Name: hfj_res_ver_prov hfj_res_ver_prov_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver_prov
    ADD CONSTRAINT hfj_res_ver_prov_pkey PRIMARY KEY (res_ver_pid);


--
-- Name: hfj_resource_modified hfj_resource_modified_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_resource_modified
    ADD CONSTRAINT hfj_resource_modified_pkey PRIMARY KEY (res_id, res_ver);


--
-- Name: hfj_resource hfj_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_resource
    ADD CONSTRAINT hfj_resource_pkey PRIMARY KEY (res_id);


--
-- Name: hfj_revinfo hfj_revinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_revinfo
    ADD CONSTRAINT hfj_revinfo_pkey PRIMARY KEY (rev);


--
-- Name: hfj_search_include hfj_search_include_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search_include
    ADD CONSTRAINT hfj_search_include_pkey PRIMARY KEY (pid);


--
-- Name: hfj_search hfj_search_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search
    ADD CONSTRAINT hfj_search_pkey PRIMARY KEY (pid);


--
-- Name: hfj_search_result hfj_search_result_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search_result
    ADD CONSTRAINT hfj_search_result_pkey PRIMARY KEY (pid);


--
-- Name: hfj_spidx_coords hfj_spidx_coords_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_coords
    ADD CONSTRAINT hfj_spidx_coords_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_date hfj_spidx_date_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_date
    ADD CONSTRAINT hfj_spidx_date_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_number hfj_spidx_number_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_number
    ADD CONSTRAINT hfj_spidx_number_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_quantity_nrml hfj_spidx_quantity_nrml_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_quantity_nrml
    ADD CONSTRAINT hfj_spidx_quantity_nrml_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_quantity hfj_spidx_quantity_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_quantity
    ADD CONSTRAINT hfj_spidx_quantity_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_string hfj_spidx_string_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_string
    ADD CONSTRAINT hfj_spidx_string_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_token hfj_spidx_token_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_token
    ADD CONSTRAINT hfj_spidx_token_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_spidx_uri hfj_spidx_uri_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_uri
    ADD CONSTRAINT hfj_spidx_uri_pkey PRIMARY KEY (sp_id);


--
-- Name: hfj_subscription_stats hfj_subscription_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_subscription_stats
    ADD CONSTRAINT hfj_subscription_stats_pkey PRIMARY KEY (pid);


--
-- Name: hfj_tag_def hfj_tag_def_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_tag_def
    ADD CONSTRAINT hfj_tag_def_pkey PRIMARY KEY (tag_id);


--
-- Name: hfj_blk_export_job idx_blkex_job_id; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_job
    ADD CONSTRAINT idx_blkex_job_id UNIQUE (job_id);


--
-- Name: hfj_blk_import_job idx_blkim_job_id; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_import_job
    ADD CONSTRAINT idx_blkim_job_id UNIQUE (job_id);


--
-- Name: trm_codesystem_ver idx_codesystem_and_ver; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem_ver
    ADD CONSTRAINT idx_codesystem_and_ver UNIQUE (codesystem_pid, cs_version_id);


--
-- Name: trm_concept idx_concept_cs_code; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept
    ADD CONSTRAINT idx_concept_cs_code UNIQUE (codesystem_pid, codeval);


--
-- Name: trm_concept_map idx_concept_map_url; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map
    ADD CONSTRAINT idx_concept_map_url UNIQUE (url, ver);


--
-- Name: trm_codesystem idx_cs_codesystem; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem
    ADD CONSTRAINT idx_cs_codesystem UNIQUE (code_system_uri);


--
-- Name: mpi_link idx_empi_person_tgt; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link
    ADD CONSTRAINT idx_empi_person_tgt UNIQUE (person_pid, target_pid);


--
-- Name: hfj_forced_id idx_forcedid_resid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_forced_id
    ADD CONSTRAINT idx_forcedid_resid UNIQUE (resource_pid);


--
-- Name: hfj_forced_id idx_forcedid_type_fid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_forced_id
    ADD CONSTRAINT idx_forcedid_type_fid UNIQUE (resource_type, forced_id);


--
-- Name: hfj_idx_cmp_string_uniq idx_idxcmpstruniq_string; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_idx_cmp_string_uniq
    ADD CONSTRAINT idx_idxcmpstruniq_string UNIQUE (idx_string);


--
-- Name: npm_package idx_pack_id; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package
    ADD CONSTRAINT idx_pack_id UNIQUE (package_id);


--
-- Name: npm_package_ver idx_packver; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver
    ADD CONSTRAINT idx_packver UNIQUE (package_id, version_id);


--
-- Name: hfj_partition idx_part_name; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_partition
    ADD CONSTRAINT idx_part_name UNIQUE (part_name);


--
-- Name: hfj_resource idx_res_type_fhir_id; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_resource
    ADD CONSTRAINT idx_res_type_fhir_id UNIQUE (res_type, fhir_id);


--
-- Name: hfj_history_tag idx_reshisttag_tagid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_history_tag
    ADD CONSTRAINT idx_reshisttag_tagid UNIQUE (res_ver_pid, tag_id);


--
-- Name: hfj_res_tag idx_restag_tagid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_tag
    ADD CONSTRAINT idx_restag_tagid UNIQUE (res_id, tag_id);


--
-- Name: hfj_res_ver idx_resver_id_ver; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver
    ADD CONSTRAINT idx_resver_id_ver UNIQUE (res_id, res_ver);


--
-- Name: hfj_search idx_search_uuid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search
    ADD CONSTRAINT idx_search_uuid UNIQUE (search_uuid);


--
-- Name: hfj_search_result idx_searchres_order; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search_result
    ADD CONSTRAINT idx_searchres_order UNIQUE (search_pid, search_order);


--
-- Name: hfj_spidx_uri idx_sp_uri_hash_identity_v2; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_uri
    ADD CONSTRAINT idx_sp_uri_hash_identity_v2 UNIQUE (hash_identity, sp_uri, res_id, partition_id);


--
-- Name: hfj_spidx_uri idx_sp_uri_hash_uri_v2; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_uri
    ADD CONSTRAINT idx_sp_uri_hash_uri_v2 UNIQUE (hash_uri, res_id, partition_id);


--
-- Name: hfj_subscription_stats idx_subsc_resid; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_subscription_stats
    ADD CONSTRAINT idx_subsc_resid UNIQUE (res_id);


--
-- Name: trm_valueset idx_valueset_url; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset
    ADD CONSTRAINT idx_valueset_url UNIQUE (url, ver);


--
-- Name: trm_valueset_concept idx_vs_concept_cscd; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_concept
    ADD CONSTRAINT idx_vs_concept_cscd UNIQUE (valueset_pid, system_url, codeval);


--
-- Name: trm_valueset_concept idx_vs_concept_order; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_concept
    ADD CONSTRAINT idx_vs_concept_order UNIQUE (valueset_pid, valueset_order);


--
-- Name: mpi_link_aud mpi_link_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link_aud
    ADD CONSTRAINT mpi_link_aud_pkey PRIMARY KEY (pid, rev);


--
-- Name: mpi_link mpi_link_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link
    ADD CONSTRAINT mpi_link_pkey PRIMARY KEY (pid);


--
-- Name: npm_package npm_package_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package
    ADD CONSTRAINT npm_package_pkey PRIMARY KEY (pid);


--
-- Name: npm_package_ver npm_package_ver_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver
    ADD CONSTRAINT npm_package_ver_pkey PRIMARY KEY (pid);


--
-- Name: npm_package_ver_res npm_package_ver_res_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver_res
    ADD CONSTRAINT npm_package_ver_res_pkey PRIMARY KEY (pid);


--
-- Name: trm_codesystem trm_codesystem_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem
    ADD CONSTRAINT trm_codesystem_pkey PRIMARY KEY (pid);


--
-- Name: trm_codesystem_ver trm_codesystem_ver_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem_ver
    ADD CONSTRAINT trm_codesystem_ver_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_desig trm_concept_desig_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_desig
    ADD CONSTRAINT trm_concept_desig_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_map_group trm_concept_map_group_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_group
    ADD CONSTRAINT trm_concept_map_group_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_map_grp_element trm_concept_map_grp_element_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_grp_element
    ADD CONSTRAINT trm_concept_map_grp_element_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_map_grp_elm_tgt trm_concept_map_grp_elm_tgt_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_grp_elm_tgt
    ADD CONSTRAINT trm_concept_map_grp_elm_tgt_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_map trm_concept_map_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map
    ADD CONSTRAINT trm_concept_map_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_pc_link trm_concept_pc_link_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_pc_link
    ADD CONSTRAINT trm_concept_pc_link_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept trm_concept_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept
    ADD CONSTRAINT trm_concept_pkey PRIMARY KEY (pid);


--
-- Name: trm_concept_property trm_concept_property_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_property
    ADD CONSTRAINT trm_concept_property_pkey PRIMARY KEY (pid);


--
-- Name: trm_valueset_c_designation trm_valueset_c_designation_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_c_designation
    ADD CONSTRAINT trm_valueset_c_designation_pkey PRIMARY KEY (pid);


--
-- Name: trm_valueset_concept trm_valueset_concept_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_concept
    ADD CONSTRAINT trm_valueset_concept_pkey PRIMARY KEY (pid);


--
-- Name: trm_valueset trm_valueset_pkey; Type: CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset
    ADD CONSTRAINT trm_valueset_pkey PRIMARY KEY (pid);


--
-- Name: fk_codesysver_cs_id; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_codesysver_cs_id ON public.trm_codesystem_ver USING btree (codesystem_pid);


--
-- Name: fk_codesysver_res_id; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_codesysver_res_id ON public.trm_codesystem_ver USING btree (res_id);


--
-- Name: fk_conceptdesig_concept; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_conceptdesig_concept ON public.trm_concept_desig USING btree (concept_pid);


--
-- Name: fk_conceptdesig_csv; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_conceptdesig_csv ON public.trm_concept_desig USING btree (cs_ver_pid);


--
-- Name: fk_conceptprop_concept; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_conceptprop_concept ON public.trm_concept_property USING btree (concept_pid);


--
-- Name: fk_conceptprop_csv; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_conceptprop_csv ON public.trm_concept_property USING btree (cs_ver_pid);


--
-- Name: fk_empi_link_target; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_empi_link_target ON public.mpi_link USING btree (target_pid);


--
-- Name: fk_npm_packverres_packver; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_npm_packverres_packver ON public.npm_package_ver_res USING btree (packver_pid);


--
-- Name: fk_npm_pkv_pkg; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_npm_pkv_pkg ON public.npm_package_ver USING btree (package_pid);


--
-- Name: fk_npm_pkv_resid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_npm_pkv_resid ON public.npm_package_ver USING btree (binary_res_id);


--
-- Name: fk_npm_pkvr_resid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_npm_pkvr_resid ON public.npm_package_ver_res USING btree (binary_res_id);


--
-- Name: fk_searchinc_search; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_searchinc_search ON public.hfj_search_include USING btree (search_pid);


--
-- Name: fk_tcmgelement_group; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_tcmgelement_group ON public.trm_concept_map_grp_element USING btree (concept_map_group_pid);


--
-- Name: fk_tcmgetarget_element; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_tcmgetarget_element ON public.trm_concept_map_grp_elm_tgt USING btree (concept_map_grp_elm_pid);


--
-- Name: fk_tcmgroup_conceptmap; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_tcmgroup_conceptmap ON public.trm_concept_map_group USING btree (concept_map_pid);


--
-- Name: fk_term_conceptpc_child; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_term_conceptpc_child ON public.trm_concept_pc_link USING btree (child_pid);


--
-- Name: fk_term_conceptpc_cs; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_term_conceptpc_cs ON public.trm_concept_pc_link USING btree (codesystem_pid);


--
-- Name: fk_term_conceptpc_parent; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_term_conceptpc_parent ON public.trm_concept_pc_link USING btree (parent_pid);


--
-- Name: fk_trm_valueset_concept_pid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trm_valueset_concept_pid ON public.trm_valueset_c_designation USING btree (valueset_concept_pid);


--
-- Name: fk_trm_vscd_vs_pid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trm_vscd_vs_pid ON public.trm_valueset_c_designation USING btree (valueset_pid);


--
-- Name: fk_trmcodesystem_curver; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trmcodesystem_curver ON public.trm_codesystem USING btree (current_version_pid);


--
-- Name: fk_trmcodesystem_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trmcodesystem_res ON public.trm_codesystem USING btree (res_id);


--
-- Name: fk_trmconceptmap_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trmconceptmap_res ON public.trm_concept_map USING btree (res_id);


--
-- Name: fk_trmvalueset_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX fk_trmvalueset_res ON public.trm_valueset USING btree (res_id);


--
-- Name: idx_blkex_exptime; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_blkex_exptime ON public.hfj_blk_export_job USING btree (exp_time);


--
-- Name: idx_blkim_jobfile_jobid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_blkim_jobfile_jobid ON public.hfj_blk_import_jobfile USING btree (job_pid);


--
-- Name: idx_bt2ji_ct; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_bt2ji_ct ON public.bt2_job_instance USING btree (create_time);


--
-- Name: idx_bt2wc_ii_seq; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_bt2wc_ii_seq ON public.bt2_work_chunk USING btree (instance_id, seq);


--
-- Name: idx_cncpt_map_grp_cd; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_cncpt_map_grp_cd ON public.trm_concept_map_grp_element USING btree (source_code);


--
-- Name: idx_cncpt_mp_grp_elm_tgt_cd; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_cncpt_mp_grp_elm_tgt_cd ON public.trm_concept_map_grp_elm_tgt USING btree (target_code);


--
-- Name: idx_concept_indexstatus; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_concept_indexstatus ON public.trm_concept USING btree (index_status);


--
-- Name: idx_concept_updated; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_concept_updated ON public.trm_concept USING btree (concept_updated);


--
-- Name: idx_empi_gr_tgt; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_empi_gr_tgt ON public.mpi_link USING btree (golden_resource_pid, target_pid);


--
-- Name: idx_empi_match_tgt_ver; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_empi_match_tgt_ver ON public.mpi_link USING btree (match_result, target_pid, version);


--
-- Name: idx_empi_tgt_mr_ls; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_empi_tgt_mr_ls ON public.mpi_link USING btree (target_type, match_result, link_source);


--
-- Name: idx_empi_tgt_mr_score; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_empi_tgt_mr_score ON public.mpi_link USING btree (target_type, match_result, score);


--
-- Name: idx_forceid_fid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_forceid_fid ON public.hfj_forced_id USING btree (forced_id);


--
-- Name: idx_idxcmbtoknu_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_idxcmbtoknu_res ON public.hfj_idx_cmb_tok_nu USING btree (res_id);


--
-- Name: idx_idxcmbtoknu_str; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_idxcmbtoknu_str ON public.hfj_idx_cmb_tok_nu USING btree (idx_string);


--
-- Name: idx_idxcmpstruniq_resource; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_idxcmpstruniq_resource ON public.hfj_idx_cmp_string_uniq USING btree (res_id);


--
-- Name: idx_packverres_url; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_packverres_url ON public.npm_package_ver_res USING btree (canonical_url);


--
-- Name: idx_res_date; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_date ON public.hfj_resource USING btree (res_updated);


--
-- Name: idx_res_fhir_id; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_fhir_id ON public.hfj_resource USING btree (fhir_id);


--
-- Name: idx_res_resid_updated; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_resid_updated ON public.hfj_resource USING btree (res_id, res_updated, partition_id);


--
-- Name: idx_res_tag_res_tag; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_tag_res_tag ON public.hfj_res_tag USING btree (res_id, tag_id, partition_id);


--
-- Name: idx_res_tag_tag_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_tag_tag_res ON public.hfj_res_tag USING btree (tag_id, res_id, partition_id);


--
-- Name: idx_res_type_del_updated; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_res_type_del_updated ON public.hfj_resource USING btree (res_type, res_deleted_at, res_updated, partition_id, res_id);


--
-- Name: idx_reshisttag_resid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_reshisttag_resid ON public.hfj_history_tag USING btree (res_id);


--
-- Name: idx_resparmpresent_hashpres; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resparmpresent_hashpres ON public.hfj_res_param_present USING btree (hash_presence);


--
-- Name: idx_resparmpresent_resid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resparmpresent_resid ON public.hfj_res_param_present USING btree (res_id);


--
-- Name: idx_ressearchurl_res; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_ressearchurl_res ON public.hfj_res_search_url USING btree (res_id);


--
-- Name: idx_ressearchurl_time; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_ressearchurl_time ON public.hfj_res_search_url USING btree (created_time);


--
-- Name: idx_resver_date; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resver_date ON public.hfj_res_ver USING btree (res_updated);


--
-- Name: idx_resver_id_date; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resver_id_date ON public.hfj_res_ver USING btree (res_id, res_updated);


--
-- Name: idx_resver_type_date; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resver_type_date ON public.hfj_res_ver USING btree (res_type, res_updated);


--
-- Name: idx_resverprov_requestid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resverprov_requestid ON public.hfj_res_ver_prov USING btree (request_id);


--
-- Name: idx_resverprov_res_pid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resverprov_res_pid ON public.hfj_res_ver_prov USING btree (res_pid);


--
-- Name: idx_resverprov_sourceuri; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_resverprov_sourceuri ON public.hfj_res_ver_prov USING btree (source_uri);


--
-- Name: idx_rl_src; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_rl_src ON public.hfj_res_link USING btree (src_resource_id);


--
-- Name: idx_rl_tgt_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_rl_tgt_v2 ON public.hfj_res_link USING btree (target_resource_id, src_path, src_resource_id, target_resource_type, partition_id);


--
-- Name: idx_search_created; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_search_created ON public.hfj_search USING btree (created);


--
-- Name: idx_search_restype_hashs; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_search_restype_hashs ON public.hfj_search USING btree (resource_type, search_query_string_hash, created);


--
-- Name: idx_sp_coords_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_coords_hash_v2 ON public.hfj_spidx_coords USING btree (hash_identity, sp_latitude, sp_longitude, res_id, partition_id);


--
-- Name: idx_sp_coords_resid; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_coords_resid ON public.hfj_spidx_coords USING btree (res_id);


--
-- Name: idx_sp_coords_updated; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_coords_updated ON public.hfj_spidx_coords USING btree (sp_updated);


--
-- Name: idx_sp_date_hash_high_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_date_hash_high_v2 ON public.hfj_spidx_date USING btree (hash_identity, sp_value_high, res_id, partition_id);


--
-- Name: idx_sp_date_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_date_hash_v2 ON public.hfj_spidx_date USING btree (hash_identity, sp_value_low, sp_value_high, res_id, partition_id);


--
-- Name: idx_sp_date_ord_hash_high_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_date_ord_hash_high_v2 ON public.hfj_spidx_date USING btree (hash_identity, sp_value_high_date_ordinal, res_id, partition_id);


--
-- Name: idx_sp_date_ord_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_date_ord_hash_v2 ON public.hfj_spidx_date USING btree (hash_identity, sp_value_low_date_ordinal, sp_value_high_date_ordinal, res_id, partition_id);


--
-- Name: idx_sp_date_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_date_resid_v2 ON public.hfj_spidx_date USING btree (res_id, hash_identity, sp_value_low, sp_value_high, sp_value_low_date_ordinal, sp_value_high_date_ordinal, partition_id);


--
-- Name: idx_sp_number_hash_val_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_number_hash_val_v2 ON public.hfj_spidx_number USING btree (hash_identity, sp_value, res_id, partition_id);


--
-- Name: idx_sp_number_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_number_resid_v2 ON public.hfj_spidx_number USING btree (res_id, hash_identity, sp_value, partition_id);


--
-- Name: idx_sp_qnty_nrml_hash_sysun_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_qnty_nrml_hash_sysun_v2 ON public.hfj_spidx_quantity_nrml USING btree (hash_identity_sys_units, sp_value, res_id, partition_id);


--
-- Name: idx_sp_qnty_nrml_hash_un_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_qnty_nrml_hash_un_v2 ON public.hfj_spidx_quantity_nrml USING btree (hash_identity_and_units, sp_value, res_id, partition_id);


--
-- Name: idx_sp_qnty_nrml_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_qnty_nrml_hash_v2 ON public.hfj_spidx_quantity_nrml USING btree (hash_identity, sp_value, res_id, partition_id);


--
-- Name: idx_sp_qnty_nrml_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_qnty_nrml_resid_v2 ON public.hfj_spidx_quantity_nrml USING btree (res_id, hash_identity, hash_identity_sys_units, hash_identity_and_units, sp_value, partition_id);


--
-- Name: idx_sp_quantity_hash_sysun_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_quantity_hash_sysun_v2 ON public.hfj_spidx_quantity USING btree (hash_identity_sys_units, sp_value, res_id, partition_id);


--
-- Name: idx_sp_quantity_hash_un_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_quantity_hash_un_v2 ON public.hfj_spidx_quantity USING btree (hash_identity_and_units, sp_value, res_id, partition_id);


--
-- Name: idx_sp_quantity_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_quantity_hash_v2 ON public.hfj_spidx_quantity USING btree (hash_identity, sp_value, res_id, partition_id);


--
-- Name: idx_sp_quantity_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_quantity_resid_v2 ON public.hfj_spidx_quantity USING btree (res_id, hash_identity, hash_identity_sys_units, hash_identity_and_units, sp_value, partition_id);


--
-- Name: idx_sp_string_hash_exct_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_string_hash_exct_v2 ON public.hfj_spidx_string USING btree (hash_exact, res_id, partition_id);


--
-- Name: idx_sp_string_hash_ident_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_string_hash_ident_v2 ON public.hfj_spidx_string USING btree (hash_identity, res_id, partition_id);


--
-- Name: idx_sp_string_hash_nrm_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_string_hash_nrm_v2 ON public.hfj_spidx_string USING btree (hash_norm_prefix, sp_value_normalized, res_id, partition_id);


--
-- Name: idx_sp_string_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_string_resid_v2 ON public.hfj_spidx_string USING btree (res_id, hash_norm_prefix, partition_id);


--
-- Name: idx_sp_token_hash_s_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_token_hash_s_v2 ON public.hfj_spidx_token USING btree (hash_sys, res_id, partition_id);


--
-- Name: idx_sp_token_hash_sv_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_token_hash_sv_v2 ON public.hfj_spidx_token USING btree (hash_sys_and_value, res_id, partition_id);


--
-- Name: idx_sp_token_hash_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_token_hash_v2 ON public.hfj_spidx_token USING btree (hash_identity, sp_system, sp_value, res_id, partition_id);


--
-- Name: idx_sp_token_hash_v_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_token_hash_v_v2 ON public.hfj_spidx_token USING btree (hash_value, res_id, partition_id);


--
-- Name: idx_sp_token_resid_v2; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_token_resid_v2 ON public.hfj_spidx_token USING btree (res_id, hash_sys_and_value, hash_value, hash_sys, hash_identity, partition_id);


--
-- Name: idx_sp_uri_coords; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_sp_uri_coords ON public.hfj_spidx_uri USING btree (res_id);


--
-- Name: idx_tag_def_tp_cd_sys; Type: INDEX; Schema: public; Owner: hapifhir
--

CREATE INDEX idx_tag_def_tp_cd_sys ON public.hfj_tag_def USING btree (tag_type, tag_code, tag_system, tag_id, tag_version, tag_user_selected);


--
-- Name: hfj_history_tag fk3gc37g8b2c9qcrrccw7s50inw; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_history_tag
    ADD CONSTRAINT fk3gc37g8b2c9qcrrccw7s50inw FOREIGN KEY (tag_id) REFERENCES public.hfj_tag_def(tag_id);


--
-- Name: hfj_res_tag fk4kiphkwif9illrg0jtooom2w1; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_tag
    ADD CONSTRAINT fk4kiphkwif9illrg0jtooom2w1 FOREIGN KEY (tag_id) REFERENCES public.hfj_tag_def(tag_id);


--
-- Name: hfj_blk_export_collection fk_blkexcol_job; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_collection
    ADD CONSTRAINT fk_blkexcol_job FOREIGN KEY (job_pid) REFERENCES public.hfj_blk_export_job(pid);


--
-- Name: hfj_blk_export_colfile fk_blkexcolfile_collect; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_export_colfile
    ADD CONSTRAINT fk_blkexcolfile_collect FOREIGN KEY (collection_pid) REFERENCES public.hfj_blk_export_collection(pid);


--
-- Name: hfj_blk_import_jobfile fk_blkimjobfile_job; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_blk_import_jobfile
    ADD CONSTRAINT fk_blkimjobfile_job FOREIGN KEY (job_pid) REFERENCES public.hfj_blk_import_job(pid);


--
-- Name: bt2_work_chunk fk_bt2wc_instance; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.bt2_work_chunk
    ADD CONSTRAINT fk_bt2wc_instance FOREIGN KEY (instance_id) REFERENCES public.bt2_job_instance(id);


--
-- Name: trm_codesystem_ver fk_codesysver_cs_id; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem_ver
    ADD CONSTRAINT fk_codesysver_cs_id FOREIGN KEY (codesystem_pid) REFERENCES public.trm_codesystem(pid);


--
-- Name: trm_codesystem_ver fk_codesysver_res_id; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem_ver
    ADD CONSTRAINT fk_codesysver_res_id FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: trm_concept fk_concept_pid_cs_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept
    ADD CONSTRAINT fk_concept_pid_cs_pid FOREIGN KEY (codesystem_pid) REFERENCES public.trm_codesystem_ver(pid);


--
-- Name: trm_concept_desig fk_conceptdesig_concept; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_desig
    ADD CONSTRAINT fk_conceptdesig_concept FOREIGN KEY (concept_pid) REFERENCES public.trm_concept(pid);


--
-- Name: trm_concept_desig fk_conceptdesig_csv; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_desig
    ADD CONSTRAINT fk_conceptdesig_csv FOREIGN KEY (cs_ver_pid) REFERENCES public.trm_codesystem_ver(pid);


--
-- Name: trm_concept_property fk_conceptprop_concept; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_property
    ADD CONSTRAINT fk_conceptprop_concept FOREIGN KEY (concept_pid) REFERENCES public.trm_concept(pid);


--
-- Name: trm_concept_property fk_conceptprop_csv; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_property
    ADD CONSTRAINT fk_conceptprop_csv FOREIGN KEY (cs_ver_pid) REFERENCES public.trm_codesystem_ver(pid);


--
-- Name: mpi_link fk_empi_link_golden_resource; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link
    ADD CONSTRAINT fk_empi_link_golden_resource FOREIGN KEY (golden_resource_pid) REFERENCES public.hfj_resource(res_id);


--
-- Name: mpi_link fk_empi_link_person; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link
    ADD CONSTRAINT fk_empi_link_person FOREIGN KEY (person_pid) REFERENCES public.hfj_resource(res_id);


--
-- Name: mpi_link fk_empi_link_target; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link
    ADD CONSTRAINT fk_empi_link_target FOREIGN KEY (target_pid) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_forced_id fk_forcedid_resource; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_forced_id
    ADD CONSTRAINT fk_forcedid_resource FOREIGN KEY (resource_pid) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_history_tag fk_historytag_history; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_history_tag
    ADD CONSTRAINT fk_historytag_history FOREIGN KEY (res_ver_pid) REFERENCES public.hfj_res_ver(pid);


--
-- Name: hfj_idx_cmb_tok_nu fk_idxcmbtoknu_res_id; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_idx_cmb_tok_nu
    ADD CONSTRAINT fk_idxcmbtoknu_res_id FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_idx_cmp_string_uniq fk_idxcmpstruniq_res_id; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_idx_cmp_string_uniq
    ADD CONSTRAINT fk_idxcmpstruniq_res_id FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: npm_package_ver_res fk_npm_packverres_packver; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver_res
    ADD CONSTRAINT fk_npm_packverres_packver FOREIGN KEY (packver_pid) REFERENCES public.npm_package_ver(pid);


--
-- Name: npm_package_ver fk_npm_pkv_pkg; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver
    ADD CONSTRAINT fk_npm_pkv_pkg FOREIGN KEY (package_pid) REFERENCES public.npm_package(pid);


--
-- Name: npm_package_ver fk_npm_pkv_resid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver
    ADD CONSTRAINT fk_npm_pkv_resid FOREIGN KEY (binary_res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: npm_package_ver_res fk_npm_pkvr_resid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.npm_package_ver_res
    ADD CONSTRAINT fk_npm_pkvr_resid FOREIGN KEY (binary_res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_link fk_reslink_source; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_link
    ADD CONSTRAINT fk_reslink_source FOREIGN KEY (src_resource_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_link fk_reslink_target; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_link
    ADD CONSTRAINT fk_reslink_target FOREIGN KEY (target_resource_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_ver fk_resource_history_resource; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver
    ADD CONSTRAINT fk_resource_history_resource FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_param_present fk_resparmpres_resid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_param_present
    ADD CONSTRAINT fk_resparmpres_resid FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_tag fk_restag_resource; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_tag
    ADD CONSTRAINT fk_restag_resource FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_ver_prov fk_resverprov_res_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver_prov
    ADD CONSTRAINT fk_resverprov_res_pid FOREIGN KEY (res_pid) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_res_ver_prov fk_resverprov_resver_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_res_ver_prov
    ADD CONSTRAINT fk_resverprov_resver_pid FOREIGN KEY (res_ver_pid) REFERENCES public.hfj_res_ver(pid);


--
-- Name: hfj_search_include fk_searchinc_search; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_search_include
    ADD CONSTRAINT fk_searchinc_search FOREIGN KEY (search_pid) REFERENCES public.hfj_search(pid);


--
-- Name: hfj_spidx_date fk_sp_date_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_date
    ADD CONSTRAINT fk_sp_date_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_number fk_sp_number_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_number
    ADD CONSTRAINT fk_sp_number_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_quantity fk_sp_quantity_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_quantity
    ADD CONSTRAINT fk_sp_quantity_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_quantity_nrml fk_sp_quantitynm_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_quantity_nrml
    ADD CONSTRAINT fk_sp_quantitynm_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_token fk_sp_token_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_token
    ADD CONSTRAINT fk_sp_token_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_string fk_spidxstr_resource; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_string
    ADD CONSTRAINT fk_spidxstr_resource FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_subscription_stats fk_subsc_resource_id; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_subscription_stats
    ADD CONSTRAINT fk_subsc_resource_id FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: trm_concept_map_grp_element fk_tcmgelement_group; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_grp_element
    ADD CONSTRAINT fk_tcmgelement_group FOREIGN KEY (concept_map_group_pid) REFERENCES public.trm_concept_map_group(pid);


--
-- Name: trm_concept_map_grp_elm_tgt fk_tcmgetarget_element; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_grp_elm_tgt
    ADD CONSTRAINT fk_tcmgetarget_element FOREIGN KEY (concept_map_grp_elm_pid) REFERENCES public.trm_concept_map_grp_element(pid);


--
-- Name: trm_concept_map_group fk_tcmgroup_conceptmap; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map_group
    ADD CONSTRAINT fk_tcmgroup_conceptmap FOREIGN KEY (concept_map_pid) REFERENCES public.trm_concept_map(pid);


--
-- Name: trm_concept_pc_link fk_term_conceptpc_child; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_pc_link
    ADD CONSTRAINT fk_term_conceptpc_child FOREIGN KEY (child_pid) REFERENCES public.trm_concept(pid);


--
-- Name: trm_concept_pc_link fk_term_conceptpc_cs; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_pc_link
    ADD CONSTRAINT fk_term_conceptpc_cs FOREIGN KEY (codesystem_pid) REFERENCES public.trm_codesystem_ver(pid);


--
-- Name: trm_concept_pc_link fk_term_conceptpc_parent; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_pc_link
    ADD CONSTRAINT fk_term_conceptpc_parent FOREIGN KEY (parent_pid) REFERENCES public.trm_concept(pid);


--
-- Name: trm_valueset_c_designation fk_trm_valueset_concept_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_c_designation
    ADD CONSTRAINT fk_trm_valueset_concept_pid FOREIGN KEY (valueset_concept_pid) REFERENCES public.trm_valueset_concept(pid);


--
-- Name: trm_valueset_concept fk_trm_valueset_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_concept
    ADD CONSTRAINT fk_trm_valueset_pid FOREIGN KEY (valueset_pid) REFERENCES public.trm_valueset(pid);


--
-- Name: trm_valueset_c_designation fk_trm_vscd_vs_pid; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset_c_designation
    ADD CONSTRAINT fk_trm_vscd_vs_pid FOREIGN KEY (valueset_pid) REFERENCES public.trm_valueset(pid);


--
-- Name: trm_codesystem fk_trmcodesystem_curver; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem
    ADD CONSTRAINT fk_trmcodesystem_curver FOREIGN KEY (current_version_pid) REFERENCES public.trm_codesystem_ver(pid);


--
-- Name: trm_codesystem fk_trmcodesystem_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_codesystem
    ADD CONSTRAINT fk_trmcodesystem_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: trm_concept_map fk_trmconceptmap_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_concept_map
    ADD CONSTRAINT fk_trmconceptmap_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: trm_valueset fk_trmvalueset_res; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.trm_valueset
    ADD CONSTRAINT fk_trmvalueset_res FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_coords fkc97mpk37okwu8qvtceg2nh9vn; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_coords
    ADD CONSTRAINT fkc97mpk37okwu8qvtceg2nh9vn FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: hfj_spidx_uri fkgxsreutymmfjuwdswv3y887do; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.hfj_spidx_uri
    ADD CONSTRAINT fkgxsreutymmfjuwdswv3y887do FOREIGN KEY (res_id) REFERENCES public.hfj_resource(res_id);


--
-- Name: mpi_link_aud fkkbqi6ie5cmr64rl4a1qbeury1; Type: FK CONSTRAINT; Schema: public; Owner: hapifhir
--

ALTER TABLE ONLY public.mpi_link_aud
    ADD CONSTRAINT fkkbqi6ie5cmr64rl4a1qbeury1 FOREIGN KEY (rev) REFERENCES public.hfj_revinfo(rev);


--
-- PostgreSQL database dump complete
--

