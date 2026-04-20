--
-- PostgreSQL database dump
--


-- Dumped from database version 18.3 (Homebrew)
-- Dumped by pg_dump version 18.3 (Homebrew)

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: autograph; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autograph (
    autograph_id integer NOT NULL,
    a_title character varying(50),
    a_description character varying(100),
    created_at date DEFAULT CURRENT_DATE,
    user_id integer NOT NULL,
    autograph_pic_url character varying(500),
    share_token character varying(255)
);


--
-- Name: autograph_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autograph_activity (
    activity_id integer NOT NULL,
    autograph_id integer NOT NULL,
    user_id integer NOT NULL,
    action character varying(50),
    created_at date DEFAULT CURRENT_DATE,
    entry_data jsonb,
    signer_name character varying(100)
);


--
-- Name: autograph_activity_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autograph_activity_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autograph_activity_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autograph_activity_activity_id_seq OWNED BY public.autograph_activity.activity_id;


--
-- Name: autograph_autograph_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autograph_autograph_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autograph_autograph_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autograph_autograph_id_seq OWNED BY public.autograph.autograph_id;


--
-- Name: autograph_entry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autograph_entry (
    entry_id integer NOT NULL,
    link character varying(100),
    content text,
    submitted_at date DEFAULT CURRENT_DATE,
    autograph_id integer NOT NULL,
    user_id integer NOT NULL,
    content_plain text
);


--
-- Name: autograph_entry_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autograph_entry_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autograph_entry_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autograph_entry_entry_id_seq OWNED BY public.autograph_entry.entry_id;


--
-- Name: block; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.block (
    block_id integer NOT NULL,
    user_id integer NOT NULL,
    blocked_user_id integer NOT NULL,
    blocked_at date DEFAULT CURRENT_DATE
);


--
-- Name: block_block_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.block_block_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: block_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.block_block_id_seq OWNED BY public.block.block_id;


--
-- Name: blocked_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocked_users (
    id integer NOT NULL,
    blocker_profile_id integer NOT NULL,
    blocked_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: blocked_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blocked_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blocked_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blocked_users_id_seq OWNED BY public.blocked_users.id;


--
-- Name: collab; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collab (
    collab_id integer NOT NULL,
    post_id integer NOT NULL,
    shared_with integer NOT NULL
);


--
-- Name: collab_collab_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collab_collab_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collab_collab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collab_collab_id_seq OWNED BY public.collab.collab_id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comment (
    comment_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    content character varying(255) NOT NULL,
    commented_at date DEFAULT CURRENT_DATE
);


--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comment_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- Name: encryption_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encryption_audit_log (
    log_id integer NOT NULL,
    user_id integer NOT NULL,
    action character varying(100) NOT NULL,
    entity_type character varying(50),
    entity_id character varying(255),
    ip_address character varying(45),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE encryption_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.encryption_audit_log IS 'Audit trail for encryption key operations';


--
-- Name: encryption_audit_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.encryption_audit_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: encryption_audit_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.encryption_audit_log_log_id_seq OWNED BY public.encryption_audit_log.log_id;


--
-- Name: encryption_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encryption_keys (
    key_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    encrypted_key bytea NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    iv bytea
);


--
-- Name: COLUMN encryption_keys.iv; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.encryption_keys.iv IS 'IV used when encrypting this key';


--
-- Name: encryption_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encryption_metadata (
    metadata_id integer NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id character varying(255) NOT NULL,
    iv bytea NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE encryption_metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.encryption_metadata IS 'Stores IVs needed for decryption';


--
-- Name: encryption_metadata_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.encryption_metadata_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: encryption_metadata_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.encryption_metadata_metadata_id_seq OWNED BY public.encryption_metadata.metadata_id;


--
-- Name: event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event (
    event_id integer NOT NULL,
    e_title character varying(50),
    e_description character varying(100),
    e_date date DEFAULT CURRENT_DATE,
    created_at date DEFAULT CURRENT_DATE,
    group_id integer,
    event_pic character varying(500)
);


--
-- Name: event_attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_attendance (
    event_id integer NOT NULL
);


--
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_event_id_seq OWNED BY public.event.event_id;


--
-- Name: event_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_group (
    event_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: event_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_user (
    event_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: event_vote; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_vote (
    vote_id integer NOT NULL,
    event_id integer NOT NULL,
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    vote character varying(20) NOT NULL,
    voted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT event_vote_vote_check CHECK (((vote)::text = ANY ((ARRAY['going'::character varying, 'not_going'::character varying, 'maybe'::character varying])::text[])))
);


--
-- Name: event_vote_vote_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_vote_vote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_vote_vote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_vote_vote_id_seq OWNED BY public.event_vote.vote_id;


--
-- Name: feed_comment_likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_comment_likes (
    like_id integer NOT NULL,
    comment_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: feed_comment_likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_comment_likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_comment_likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_comment_likes_like_id_seq OWNED BY public.feed_comment_likes.like_id;


--
-- Name: feed_follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_follows (
    follow_id integer NOT NULL,
    follower_id integer NOT NULL,
    following_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT no_self_follow CHECK ((follower_id <> following_id))
);


--
-- Name: feed_follows_follow_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_follows_follow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_follows_follow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_follows_follow_id_seq OWNED BY public.feed_follows.follow_id;


--
-- Name: feed_post_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_post_comments (
    comment_id integer NOT NULL,
    post_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    parent_comment_id integer,
    comment_text text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: feed_post_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_post_comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_post_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_post_comments_comment_id_seq OWNED BY public.feed_post_comments.comment_id;


--
-- Name: feed_post_likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_post_likes (
    like_id integer NOT NULL,
    post_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: feed_post_likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_post_likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_post_likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_post_likes_like_id_seq OWNED BY public.feed_post_likes.like_id;


--
-- Name: feed_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_posts (
    post_id integer NOT NULL,
    memory_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    caption text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: feed_posts_post_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_posts_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_posts_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_posts_post_id_seq OWNED BY public.feed_posts.post_id;


--
-- Name: feed_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feed_profiles (
    feed_profile_id integer NOT NULL,
    user_id integer NOT NULL,
    feed_username character varying(50) NOT NULL,
    feed_profile_picture_url text,
    feed_bio character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: feed_profiles_feed_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feed_profiles_feed_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_profiles_feed_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feed_profiles_feed_profile_id_seq OWNED BY public.feed_profiles.feed_profile_id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follow (
    follower_id integer NOT NULL,
    following_id integer NOT NULL
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."group" (
    group_id integer NOT NULL,
    g_name character varying(50),
    g_description character varying(100),
    created_at date DEFAULT CURRENT_DATE,
    user_id integer,
    group_pic character varying(500),
    group_url character varying(500)
);


--
-- Name: group_announcement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_announcement (
    announcement_id integer NOT NULL,
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    event_id integer
);


--
-- Name: group_announcement_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_announcement_announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_announcement_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_announcement_announcement_id_seq OWNED BY public.group_announcement.announcement_id;


--
-- Name: group_encryption_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_encryption_keys (
    group_id integer NOT NULL,
    key_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    encrypted_key bytea NOT NULL,
    iv bytea,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: group_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_group_id_seq OWNED BY public."group".group_id;


--
-- Name: group_invite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_invite (
    invite_id integer NOT NULL,
    group_id integer NOT NULL,
    invite_token character varying(64) NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


--
-- Name: group_invite_invite_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_invite_invite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_invite_invite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_invite_invite_id_seq OWNED BY public.group_invite.invite_id;


--
-- Name: group_media_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_media_shares (
    group_id integer NOT NULL,
    media_id integer NOT NULL,
    shared_by_user_id integer NOT NULL,
    shared_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: group_member; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_member (
    group_id integer NOT NULL,
    member_id integer NOT NULL,
    role character varying(50) DEFAULT 'member'::character varying,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


--
-- Name: journal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journal (
    journal_id integer NOT NULL,
    j_title character varying(255),
    j_content text,
    user_id integer NOT NULL,
    journal_pic character varying(500),
    is_in_vault boolean DEFAULT false
);


--
-- Name: journal_journal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.journal_journal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_journal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.journal_journal_id_seq OWNED BY public.journal.journal_id;


--
-- Name: journal_streaks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journal_streaks (
    streak_id integer NOT NULL,
    user_id integer NOT NULL,
    current_streak integer DEFAULT 0,
    longest_streak integer DEFAULT 0,
    last_entry_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: journal_streaks_streak_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.journal_streaks_streak_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_streaks_streak_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.journal_streaks_streak_id_seq OWNED BY public.journal_streaks.streak_id;


--
-- Name: journal_theme; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journal_theme (
    journal_id integer NOT NULL,
    theme_id integer NOT NULL
);


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    like_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    liked_at date DEFAULT CURRENT_DATE
);


--
-- Name: likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.likes_like_id_seq OWNED BY public.likes.like_id;


--
-- Name: media_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_items (
    media_id integer NOT NULL,
    user_id integer NOT NULL,
    filename character varying(500),
    original_filename character varying(500),
    file_path character varying(1000),
    file_size bigint,
    mime_type character varying(100),
    media_type character varying(50),
    title character varying(255),
    description text,
    upload_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_public boolean DEFAULT false,
    storage_bucket character varying(255),
    metadata jsonb,
    is_encrypted boolean DEFAULT false,
    encryption_key_id character varying(255),
    file_hash character varying(255),
    split_count integer DEFAULT 0,
    original_file_size bigint,
    is_split boolean DEFAULT false,
    encryption_iv bytea
);


--
-- Name: media_items_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_items_media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_items_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_items_media_id_seq OWNED BY public.media_items.media_id;


--
-- Name: media_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_shares (
    share_id integer NOT NULL,
    media_id integer NOT NULL,
    share_type character varying(50),
    share_key character varying(255),
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: media_shares_share_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_shares_share_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_shares_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_shares_share_id_seq OWNED BY public.media_shares.share_id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.member (
    member_id integer NOT NULL,
    user_id integer NOT NULL,
    g_role character varying(50),
    joined_at date DEFAULT CURRENT_DATE
);


--
-- Name: member_member_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.member_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: member_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.member_member_id_seq OWNED BY public.member.member_id;


--
-- Name: memory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memory (
    memory_id integer NOT NULL,
    title character varying(255),
    description character varying(500),
    updated_at date DEFAULT CURRENT_DATE,
    user_id integer NOT NULL,
    cover_media_id integer,
    created_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_public boolean DEFAULT false,
    share_key character varying(255),
    expires_at timestamp without time zone,
    is_link_shared boolean DEFAULT false,
    is_in_vault boolean DEFAULT false,
    is_collaborative boolean DEFAULT false,
    collab_share_key character varying(255),
    group_id integer
);


--
-- Name: memory_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memory_media (
    memory_id integer NOT NULL,
    media_id integer NOT NULL,
    added_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: memory_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memory_members (
    id integer NOT NULL,
    memory_id integer NOT NULL,
    user_id integer NOT NULL,
    role character varying(50) DEFAULT 'viewer'::character varying,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: memory_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memory_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memory_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memory_members_id_seq OWNED BY public.memory_members.id;


--
-- Name: memory_memory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memory_memory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memory_memory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memory_memory_id_seq OWNED BY public.memory.memory_id;


--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_preferences (
    pref_id integer NOT NULL,
    user_id integer NOT NULL,
    notif_type character varying(50) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: notification_preferences_pref_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_preferences_pref_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_preferences_pref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_preferences_pref_id_seq OWNED BY public.notification_preferences.pref_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer NOT NULL,
    notif_type character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    link character varying(500),
    is_read boolean DEFAULT false NOT NULL,
    actor_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plans (
    plan_id integer NOT NULL,
    name character varying(50) NOT NULL,
    storage_limit_bytes bigint DEFAULT 0,
    price_monthly numeric(10,2) DEFAULT 0,
    price_annual numeric(10,2) DEFAULT 0,
    max_members integer DEFAULT 1,
    description text,
    memory_limit integer DEFAULT 10
);


--
-- Name: plans_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plans_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plans_plan_id_seq OWNED BY public.plans.plan_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post (
    post_id integer NOT NULL,
    content text,
    created_at date DEFAULT CURRENT_DATE,
    profile_id integer
);


--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_post_id_seq OWNED BY public.post.post_id;


--
-- Name: post_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_reports (
    report_id integer NOT NULL,
    post_id integer NOT NULL,
    reporter_profile_id integer NOT NULL,
    reason character varying(50) DEFAULT 'other'::character varying NOT NULL,
    description text,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    admin_notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reviewed_at timestamp without time zone,
    reviewed_by integer
);


--
-- Name: post_reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_reports_report_id_seq OWNED BY public.post_reports.report_id;


--
-- Name: publicprofile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publicprofile (
    profile_id integer NOT NULL,
    display_name character varying(100),
    bio text,
    profile_picture character varying(500),
    follow_count integer DEFAULT 0
);


--
-- Name: publicprofile_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publicprofile_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publicprofile_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publicprofile_profile_id_seq OWNED BY public.publicprofile.profile_id;


--
-- Name: recap; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recap (
    recap_id integer NOT NULL,
    memory_id integer NOT NULL,
    generated_at date DEFAULT CURRENT_DATE
);


--
-- Name: recap_recap_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recap_recap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recap_recap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recap_recap_id_seq OWNED BY public.recap.recap_id;


--
-- Name: recycle_bin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recycle_bin (
    id integer NOT NULL,
    original_id integer,
    item_type character varying(50),
    user_id integer,
    title character varying(255),
    content text,
    metadata jsonb,
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: recycle_bin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recycle_bin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recycle_bin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recycle_bin_id_seq OWNED BY public.recycle_bin.id;


--
-- Name: repost; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repost (
    repost_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at date DEFAULT CURRENT_DATE
);


--
-- Name: repost_repost_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repost_repost_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repost_repost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repost_repost_id_seq OWNED BY public.repost.repost_id;


--
-- Name: saved_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_posts (
    saved_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    post_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: saved_posts_saved_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_posts_saved_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_posts_saved_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_posts_saved_id_seq OWNED BY public.saved_posts.saved_id;


--
-- Name: share; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.share (
    share_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at date DEFAULT CURRENT_DATE
);


--
-- Name: share_share_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.share_share_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: share_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.share_share_id_seq OWNED BY public.share.share_id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag (
    tag_id integer NOT NULL,
    post_id integer NOT NULL,
    tagged_user_id integer NOT NULL
);


--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_tag_id_seq OWNED BY public.tag.tag_id;


--
-- Name: theme; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.theme (
    theme_id integer NOT NULL,
    t_name character varying(50)
);


--
-- Name: theme_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.theme_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: theme_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.theme_theme_id_seq OWNED BY public.theme.theme_id;


--
-- Name: trash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trash (
    user_id integer NOT NULL
);


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sessions (
    session_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone,
    device_name character varying(100),
    device_type character varying(50),
    ip_address character varying(45),
    user_agent text,
    is_active boolean DEFAULT true
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    salt character varying(255),
    bio text,
    joined_at date DEFAULT CURRENT_DATE,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    profile_picture_url character varying(500),
    master_key_encrypted bytea,
    key_derivation_salt bytea,
    plan_id integer,
    vault_setup_completed boolean DEFAULT false,
    vault_password_hash character varying(255),
    vault_password_salt character varying(255)
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: vault; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vault (
    user_id integer NOT NULL
);


--
-- Name: autograph autograph_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph ALTER COLUMN autograph_id SET DEFAULT nextval('public.autograph_autograph_id_seq'::regclass);


--
-- Name: autograph_activity activity_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_activity ALTER COLUMN activity_id SET DEFAULT nextval('public.autograph_activity_activity_id_seq'::regclass);


--
-- Name: autograph_entry entry_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_entry ALTER COLUMN entry_id SET DEFAULT nextval('public.autograph_entry_entry_id_seq'::regclass);


--
-- Name: block block_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block ALTER COLUMN block_id SET DEFAULT nextval('public.block_block_id_seq'::regclass);


--
-- Name: blocked_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_users ALTER COLUMN id SET DEFAULT nextval('public.blocked_users_id_seq'::regclass);


--
-- Name: collab collab_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collab ALTER COLUMN collab_id SET DEFAULT nextval('public.collab_collab_id_seq'::regclass);


--
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- Name: encryption_audit_log log_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_audit_log ALTER COLUMN log_id SET DEFAULT nextval('public.encryption_audit_log_log_id_seq'::regclass);


--
-- Name: encryption_metadata metadata_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_metadata ALTER COLUMN metadata_id SET DEFAULT nextval('public.encryption_metadata_metadata_id_seq'::regclass);


--
-- Name: event event_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event ALTER COLUMN event_id SET DEFAULT nextval('public.event_event_id_seq'::regclass);


--
-- Name: event_vote vote_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_vote ALTER COLUMN vote_id SET DEFAULT nextval('public.event_vote_vote_id_seq'::regclass);


--
-- Name: feed_comment_likes like_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_comment_likes ALTER COLUMN like_id SET DEFAULT nextval('public.feed_comment_likes_like_id_seq'::regclass);


--
-- Name: feed_follows follow_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_follows ALTER COLUMN follow_id SET DEFAULT nextval('public.feed_follows_follow_id_seq'::regclass);


--
-- Name: feed_post_comments comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.feed_post_comments_comment_id_seq'::regclass);


--
-- Name: feed_post_likes like_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_likes ALTER COLUMN like_id SET DEFAULT nextval('public.feed_post_likes_like_id_seq'::regclass);


--
-- Name: feed_posts post_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_posts ALTER COLUMN post_id SET DEFAULT nextval('public.feed_posts_post_id_seq'::regclass);


--
-- Name: feed_profiles feed_profile_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_profiles ALTER COLUMN feed_profile_id SET DEFAULT nextval('public.feed_profiles_feed_profile_id_seq'::regclass);


--
-- Name: group group_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."group" ALTER COLUMN group_id SET DEFAULT nextval('public.group_group_id_seq'::regclass);


--
-- Name: group_announcement announcement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_announcement ALTER COLUMN announcement_id SET DEFAULT nextval('public.group_announcement_announcement_id_seq'::regclass);


--
-- Name: group_invite invite_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_invite ALTER COLUMN invite_id SET DEFAULT nextval('public.group_invite_invite_id_seq'::regclass);


--
-- Name: journal journal_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal ALTER COLUMN journal_id SET DEFAULT nextval('public.journal_journal_id_seq'::regclass);


--
-- Name: journal_streaks streak_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_streaks ALTER COLUMN streak_id SET DEFAULT nextval('public.journal_streaks_streak_id_seq'::regclass);


--
-- Name: likes like_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes ALTER COLUMN like_id SET DEFAULT nextval('public.likes_like_id_seq'::regclass);


--
-- Name: media_items media_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_items ALTER COLUMN media_id SET DEFAULT nextval('public.media_items_media_id_seq'::regclass);


--
-- Name: media_shares share_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_shares ALTER COLUMN share_id SET DEFAULT nextval('public.media_shares_share_id_seq'::regclass);


--
-- Name: member member_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member ALTER COLUMN member_id SET DEFAULT nextval('public.member_member_id_seq'::regclass);


--
-- Name: memory memory_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory ALTER COLUMN memory_id SET DEFAULT nextval('public.memory_memory_id_seq'::regclass);


--
-- Name: memory_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_members ALTER COLUMN id SET DEFAULT nextval('public.memory_members_id_seq'::regclass);


--
-- Name: notification_preferences pref_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences ALTER COLUMN pref_id SET DEFAULT nextval('public.notification_preferences_pref_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: plans plan_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans ALTER COLUMN plan_id SET DEFAULT nextval('public.plans_plan_id_seq'::regclass);


--
-- Name: post post_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post ALTER COLUMN post_id SET DEFAULT nextval('public.post_post_id_seq'::regclass);


--
-- Name: post_reports report_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports ALTER COLUMN report_id SET DEFAULT nextval('public.post_reports_report_id_seq'::regclass);


--
-- Name: publicprofile profile_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publicprofile ALTER COLUMN profile_id SET DEFAULT nextval('public.publicprofile_profile_id_seq'::regclass);


--
-- Name: recap recap_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recap ALTER COLUMN recap_id SET DEFAULT nextval('public.recap_recap_id_seq'::regclass);


--
-- Name: recycle_bin id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recycle_bin ALTER COLUMN id SET DEFAULT nextval('public.recycle_bin_id_seq'::regclass);


--
-- Name: repost repost_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repost ALTER COLUMN repost_id SET DEFAULT nextval('public.repost_repost_id_seq'::regclass);


--
-- Name: saved_posts saved_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_posts ALTER COLUMN saved_id SET DEFAULT nextval('public.saved_posts_saved_id_seq'::regclass);


--
-- Name: share share_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.share ALTER COLUMN share_id SET DEFAULT nextval('public.share_share_id_seq'::regclass);


--
-- Name: tag tag_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag ALTER COLUMN tag_id SET DEFAULT nextval('public.tag_tag_id_seq'::regclass);


--
-- Name: theme theme_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theme ALTER COLUMN theme_id SET DEFAULT nextval('public.theme_theme_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: autograph_activity autograph_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT autograph_activity_pkey PRIMARY KEY (activity_id);


--
-- Name: autograph_entry autograph_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT autograph_entry_pkey PRIMARY KEY (entry_id);


--
-- Name: autograph autograph_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph
    ADD CONSTRAINT autograph_pkey PRIMARY KEY (autograph_id);


--
-- Name: block block_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (block_id);


--
-- Name: blocked_users blocked_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_users
    ADD CONSTRAINT blocked_users_pkey PRIMARY KEY (id);


--
-- Name: collab collab_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_pkey PRIMARY KEY (collab_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: encryption_audit_log encryption_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_audit_log
    ADD CONSTRAINT encryption_audit_log_pkey PRIMARY KEY (log_id);


--
-- Name: encryption_keys encryption_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT encryption_keys_pkey PRIMARY KEY (key_id);


--
-- Name: encryption_metadata encryption_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_metadata
    ADD CONSTRAINT encryption_metadata_pkey PRIMARY KEY (metadata_id);


--
-- Name: event_attendance event_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_pkey PRIMARY KEY (event_id);


--
-- Name: event_group event_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_pkey PRIMARY KEY (event_id, group_id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- Name: event_user event_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT event_user_pkey PRIMARY KEY (event_id, group_id);


--
-- Name: event_vote event_vote_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_pkey PRIMARY KEY (vote_id);


--
-- Name: feed_comment_likes feed_comment_likes_comment_id_feed_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_comment_id_feed_profile_id_key UNIQUE (comment_id, feed_profile_id);


--
-- Name: feed_comment_likes feed_comment_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_pkey PRIMARY KEY (like_id);


--
-- Name: feed_follows feed_follows_follower_id_following_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_follower_id_following_id_key UNIQUE (follower_id, following_id);


--
-- Name: feed_follows feed_follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_pkey PRIMARY KEY (follow_id);


--
-- Name: feed_post_comments feed_post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_pkey PRIMARY KEY (comment_id);


--
-- Name: feed_post_likes feed_post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_pkey PRIMARY KEY (like_id);


--
-- Name: feed_post_likes feed_post_likes_post_id_feed_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_post_id_feed_profile_id_key UNIQUE (post_id, feed_profile_id);


--
-- Name: feed_posts feed_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_pkey PRIMARY KEY (post_id);


--
-- Name: feed_profiles feed_profiles_feed_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_feed_username_key UNIQUE (feed_username);


--
-- Name: feed_profiles feed_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_pkey PRIMARY KEY (feed_profile_id);


--
-- Name: feed_profiles feed_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_user_id_key UNIQUE (user_id);


--
-- Name: follow follow_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_pkey PRIMARY KEY (follower_id, following_id);


--
-- Name: group_announcement group_announcement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_pkey PRIMARY KEY (announcement_id);


--
-- Name: group_encryption_keys group_encryption_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_pkey PRIMARY KEY (group_id, key_id, user_id);


--
-- Name: group_invite group_invite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_pkey PRIMARY KEY (invite_id);


--
-- Name: group_media_shares group_media_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_pkey PRIMARY KEY (group_id, media_id);


--
-- Name: group_member group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_pkey PRIMARY KEY (group_id, member_id);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (group_id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (journal_id);


--
-- Name: journal_streaks journal_streaks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_streaks
    ADD CONSTRAINT journal_streaks_pkey PRIMARY KEY (streak_id);


--
-- Name: journal_theme journal_theme_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT journal_theme_pkey PRIMARY KEY (journal_id, theme_id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (like_id);


--
-- Name: media_items media_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_items
    ADD CONSTRAINT media_items_pkey PRIMARY KEY (media_id);


--
-- Name: media_shares media_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_shares
    ADD CONSTRAINT media_shares_pkey PRIMARY KEY (share_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_id);


--
-- Name: memory_media memory_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_pkey PRIMARY KEY (memory_id, media_id);


--
-- Name: memory_members memory_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_pkey PRIMARY KEY (id);


--
-- Name: memory memory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT memory_pkey PRIMARY KEY (memory_id);


--
-- Name: notification_preferences notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_pkey PRIMARY KEY (pref_id);


--
-- Name: notification_preferences notification_preferences_user_id_notif_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_user_id_notif_type_key UNIQUE (user_id, notif_type);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (plan_id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: post_reports post_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_pkey PRIMARY KEY (report_id);


--
-- Name: post_reports post_reports_post_id_reporter_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_post_id_reporter_profile_id_key UNIQUE (post_id, reporter_profile_id);


--
-- Name: publicprofile publicprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publicprofile
    ADD CONSTRAINT publicprofile_pkey PRIMARY KEY (profile_id);


--
-- Name: recap recap_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recap
    ADD CONSTRAINT recap_pkey PRIMARY KEY (recap_id);


--
-- Name: recycle_bin recycle_bin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recycle_bin
    ADD CONSTRAINT recycle_bin_pkey PRIMARY KEY (id);


--
-- Name: repost repost_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT repost_pkey PRIMARY KEY (repost_id);


--
-- Name: saved_posts saved_posts_feed_profile_id_post_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_feed_profile_id_post_id_key UNIQUE (feed_profile_id, post_id);


--
-- Name: saved_posts saved_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_pkey PRIMARY KEY (saved_id);


--
-- Name: share share_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT share_pkey PRIMARY KEY (share_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: theme theme_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theme
    ADD CONSTRAINT theme_pkey PRIMARY KEY (theme_id);


--
-- Name: trash trash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trash
    ADD CONSTRAINT trash_pkey PRIMARY KEY (user_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vault vault_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vault
    ADD CONSTRAINT vault_pkey PRIMARY KEY (user_id);


--
-- Name: idx_comments_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_parent_id ON public.feed_post_comments USING btree (parent_comment_id);


--
-- Name: idx_comments_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_post_id ON public.feed_post_comments USING btree (post_id);


--
-- Name: idx_comments_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_profile_id ON public.feed_post_comments USING btree (feed_profile_id);


--
-- Name: idx_feed_follows_follower; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_follows_follower ON public.feed_follows USING btree (follower_id);


--
-- Name: idx_feed_follows_following; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_follows_following ON public.feed_follows USING btree (following_id);


--
-- Name: idx_feed_posts_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_posts_created ON public.feed_posts USING btree (created_at DESC);


--
-- Name: idx_feed_posts_feed_profile; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_posts_feed_profile ON public.feed_posts USING btree (feed_profile_id);


--
-- Name: idx_feed_posts_memory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_posts_memory ON public.feed_posts USING btree (memory_id);


--
-- Name: idx_feed_profiles_feed_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_profiles_feed_username ON public.feed_profiles USING btree (feed_username);


--
-- Name: idx_feed_profiles_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feed_profiles_user_id ON public.feed_profiles USING btree (user_id);


--
-- Name: idx_notif_prefs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_prefs_user_id ON public.notification_preferences USING btree (user_id);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, is_read);


--
-- Name: autograph_activity autograph_activity_autograph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT autograph_activity_autograph_id_fkey FOREIGN KEY (autograph_id) REFERENCES public.autograph(autograph_id) ON DELETE CASCADE;


--
-- Name: autograph_activity autograph_activity_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT autograph_activity_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: autograph_entry autograph_entry_autograph_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT autograph_entry_autograph_id_fkey FOREIGN KEY (autograph_id) REFERENCES public.autograph(autograph_id) ON DELETE CASCADE;


--
-- Name: autograph_entry autograph_entry_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT autograph_entry_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: autograph autograph_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autograph
    ADD CONSTRAINT autograph_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: block block_blocked_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT block_blocked_user_id_fkey FOREIGN KEY (blocked_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: block block_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT block_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: blocked_users blocked_users_blocked_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_users
    ADD CONSTRAINT blocked_users_blocked_profile_id_fkey FOREIGN KEY (blocked_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: blocked_users blocked_users_blocker_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_users
    ADD CONSTRAINT blocked_users_blocker_profile_id_fkey FOREIGN KEY (blocker_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: collab collab_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: collab collab_shared_with_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_shared_with_fkey FOREIGN KEY (shared_with) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: comment comment_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: encryption_audit_log encryption_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_audit_log
    ADD CONSTRAINT encryption_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: encryption_keys encryption_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT encryption_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: event_attendance event_attendance_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_group event_group_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_group event_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event event_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event_user event_user_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT event_user_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_user event_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT event_user_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: feed_comment_likes feed_comment_likes_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.feed_post_comments(comment_id) ON DELETE CASCADE;


--
-- Name: feed_comment_likes feed_comment_likes_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_follows feed_follows_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_follows feed_follows_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_following_id_fkey FOREIGN KEY (following_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.feed_post_comments(comment_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: feed_post_likes feed_post_likes_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_likes feed_post_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: feed_posts feed_posts_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_posts feed_posts_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: feed_profiles feed_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_announcement fk_announcement_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT fk_announcement_event FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE SET NULL;


--
-- Name: memory fk_memory_group; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT fk_memory_group FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE SET NULL;


--
-- Name: follow follow_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: follow follow_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_following_id_fkey FOREIGN KEY (following_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_announcement group_announcement_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_announcement group_announcement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_key_id_fkey FOREIGN KEY (key_id) REFERENCES public.encryption_keys(key_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_invite group_invite_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_invite group_invite_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_shared_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_shared_by_user_id_fkey FOREIGN KEY (shared_by_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_member group_member_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_member group_member_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group group_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: journal_streaks journal_streaks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_streaks
    ADD CONSTRAINT journal_streaks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: journal_theme journal_theme_journal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT journal_theme_journal_id_fkey FOREIGN KEY (journal_id) REFERENCES public.journal(journal_id) ON DELETE CASCADE;


--
-- Name: journal_theme journal_theme_theme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT journal_theme_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.theme(theme_id) ON DELETE CASCADE;


--
-- Name: journal journal_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: likes likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: likes likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: media_items media_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_items
    ADD CONSTRAINT media_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: media_shares media_shares_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_shares
    ADD CONSTRAINT media_shares_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: member member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: memory memory_cover_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT memory_cover_media_id_fkey FOREIGN KEY (cover_media_id) REFERENCES public.media_items(media_id) ON DELETE SET NULL;


--
-- Name: memory_media memory_media_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: memory_media memory_media_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: memory_members memory_members_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: memory_members memory_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: memory memory_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT memory_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notification_preferences notification_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: post post_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.publicprofile(profile_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_reporter_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_reporter_profile_id_fkey FOREIGN KEY (reporter_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(user_id);


--
-- Name: recap recap_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recap
    ADD CONSTRAINT recap_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: recycle_bin recycle_bin_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recycle_bin
    ADD CONSTRAINT recycle_bin_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: repost repost_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT repost_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: repost repost_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT repost_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: saved_posts saved_posts_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: saved_posts saved_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: share share_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT share_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: share share_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT share_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: tag tag_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id) ON DELETE CASCADE;


--
-- Name: tag tag_tagged_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tagged_user_id_fkey FOREIGN KEY (tagged_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: trash trash_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trash
    ADD CONSTRAINT trash_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users users_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(plan_id);


--
-- Name: vault vault_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vault
    ADD CONSTRAINT vault_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


