--
-- PostgreSQL database dump
--

\restrict yfYuy91DZumcHd4R2cigYF35MrlpYF4Z6C3CF3nHVLLnmcili5VVMVN4AXDS5zb

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.3

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: autograph; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autograph (
    autograph_id integer NOT NULL,
    a_title character varying(50),
    a_description character varying(100),
    created_at date DEFAULT CURRENT_DATE,
    user_id integer NOT NULL,
    autograph_pic_url character varying,
    share_token character varying(255)
);


ALTER TABLE public.autograph OWNER TO postgres;

--
-- Name: autograph_activity; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.autograph_activity OWNER TO postgres;

--
-- Name: autograph_activity_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autograph_activity_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autograph_activity_activity_id_seq OWNER TO postgres;

--
-- Name: autograph_activity_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autograph_activity_activity_id_seq OWNED BY public.autograph_activity.activity_id;


--
-- Name: autograph_autograph_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autograph_autograph_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autograph_autograph_id_seq OWNER TO postgres;

--
-- Name: autograph_autograph_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autograph_autograph_id_seq OWNED BY public.autograph.autograph_id;


--
-- Name: autograph_entry; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.autograph_entry OWNER TO postgres;

--
-- Name: autograph_entry_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autograph_entry_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autograph_entry_entry_id_seq OWNER TO postgres;

--
-- Name: autograph_entry_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autograph_entry_entry_id_seq OWNED BY public.autograph_entry.entry_id;


--
-- Name: block; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block (
    block_id integer NOT NULL,
    user_id integer NOT NULL,
    blocked_user_id integer NOT NULL,
    blocked_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.block OWNER TO postgres;

--
-- Name: block_block_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.block_block_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.block_block_id_seq OWNER TO postgres;

--
-- Name: block_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.block_block_id_seq OWNED BY public.block.block_id;


--
-- Name: blocked_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blocked_users (
    id integer NOT NULL,
    blocker_profile_id integer NOT NULL,
    blocked_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blocked_users OWNER TO postgres;

--
-- Name: blocked_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blocked_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blocked_users_id_seq OWNER TO postgres;

--
-- Name: blocked_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blocked_users_id_seq OWNED BY public.blocked_users.id;


--
-- Name: collab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collab (
    collab_id integer NOT NULL,
    post_id integer NOT NULL,
    shared_with integer NOT NULL
);


ALTER TABLE public.collab OWNER TO postgres;

--
-- Name: collab_collab_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collab_collab_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collab_collab_id_seq OWNER TO postgres;

--
-- Name: collab_collab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collab_collab_id_seq OWNED BY public.collab.collab_id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    comment_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    content character varying(255) NOT NULL,
    commented_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comment_comment_id_seq OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- Name: encryption_audit_log; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.encryption_audit_log OWNER TO postgres;

--
-- Name: TABLE encryption_audit_log; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.encryption_audit_log IS 'Audit trail for encryption key operations';


--
-- Name: encryption_audit_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encryption_audit_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.encryption_audit_log_log_id_seq OWNER TO postgres;

--
-- Name: encryption_audit_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encryption_audit_log_log_id_seq OWNED BY public.encryption_audit_log.log_id;


--
-- Name: encryption_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encryption_keys (
    key_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    encrypted_key bytea NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    iv bytea
);


ALTER TABLE public.encryption_keys OWNER TO postgres;

--
-- Name: COLUMN encryption_keys.iv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.encryption_keys.iv IS 'IV used when encrypting this key';


--
-- Name: encryption_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encryption_metadata (
    metadata_id integer NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id character varying(255) NOT NULL,
    iv bytea NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.encryption_metadata OWNER TO postgres;

--
-- Name: TABLE encryption_metadata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.encryption_metadata IS 'Stores IVs needed for decryption';


--
-- Name: encryption_metadata_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encryption_metadata_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.encryption_metadata_metadata_id_seq OWNER TO postgres;

--
-- Name: encryption_metadata_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encryption_metadata_metadata_id_seq OWNED BY public.encryption_metadata.metadata_id;


--
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    event_id integer NOT NULL,
    e_title character varying(50),
    e_description character varying(100),
    e_date date DEFAULT CURRENT_DATE,
    created_at date DEFAULT CURRENT_DATE,
    group_id integer,
    event_pic character varying
);


ALTER TABLE public.event OWNER TO postgres;

--
-- Name: event_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_attendance (
    event_id integer NOT NULL
);


ALTER TABLE public.event_attendance OWNER TO postgres;

--
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_event_id_seq OWNER TO postgres;

--
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_event_id_seq OWNED BY public.event.event_id;


--
-- Name: event_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_group (
    event_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.event_group OWNER TO postgres;

--
-- Name: event_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_user (
    event_id integer NOT NULL,
    group_id integer CONSTRAINT event_user_user_id_not_null NOT NULL
);


ALTER TABLE public.event_user OWNER TO postgres;

--
-- Name: event_vote; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.event_vote OWNER TO postgres;

--
-- Name: event_vote_vote_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_vote_vote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_vote_vote_id_seq OWNER TO postgres;

--
-- Name: event_vote_vote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_vote_vote_id_seq OWNED BY public.event_vote.vote_id;


--
-- Name: feed_comment_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_comment_likes (
    like_id integer NOT NULL,
    comment_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.feed_comment_likes OWNER TO postgres;

--
-- Name: TABLE feed_comment_likes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feed_comment_likes IS 'Stores likes on comments';


--
-- Name: COLUMN feed_comment_likes.comment_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_comment_likes.comment_id IS 'Reference to the comment being liked';


--
-- Name: COLUMN feed_comment_likes.feed_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_comment_likes.feed_profile_id IS 'Reference to the profile that liked the comment';


--
-- Name: feed_comment_likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_comment_likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_comment_likes_like_id_seq OWNER TO postgres;

--
-- Name: feed_comment_likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_comment_likes_like_id_seq OWNED BY public.feed_comment_likes.like_id;


--
-- Name: feed_follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_follows (
    follow_id integer NOT NULL,
    follower_id integer NOT NULL,
    following_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT no_self_follow CHECK ((follower_id <> following_id))
);


ALTER TABLE public.feed_follows OWNER TO postgres;

--
-- Name: feed_follows_follow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_follows_follow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_follows_follow_id_seq OWNER TO postgres;

--
-- Name: feed_follows_follow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_follows_follow_id_seq OWNED BY public.feed_follows.follow_id;


--
-- Name: feed_post_comments; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.feed_post_comments OWNER TO postgres;

--
-- Name: TABLE feed_post_comments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feed_post_comments IS 'Stores comments on feed posts';


--
-- Name: COLUMN feed_post_comments.post_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_comments.post_id IS 'Reference to the post being commented on';


--
-- Name: COLUMN feed_post_comments.feed_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_comments.feed_profile_id IS 'Reference to the profile of the commenter';


--
-- Name: COLUMN feed_post_comments.parent_comment_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_comments.parent_comment_id IS 'Reference to parent comment for replies (NULL if top-level)';


--
-- Name: COLUMN feed_post_comments.comment_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_comments.comment_text IS 'The comment content';


--
-- Name: feed_post_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_post_comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_post_comments_comment_id_seq OWNER TO postgres;

--
-- Name: feed_post_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_post_comments_comment_id_seq OWNED BY public.feed_post_comments.comment_id;


--
-- Name: feed_post_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_post_likes (
    like_id integer NOT NULL,
    post_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.feed_post_likes OWNER TO postgres;

--
-- Name: TABLE feed_post_likes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feed_post_likes IS 'Stores likes on posts';


--
-- Name: COLUMN feed_post_likes.post_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_likes.post_id IS 'Reference to the post being liked';


--
-- Name: COLUMN feed_post_likes.feed_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feed_post_likes.feed_profile_id IS 'Reference to the profile that liked the post';


--
-- Name: feed_post_likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_post_likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_post_likes_like_id_seq OWNER TO postgres;

--
-- Name: feed_post_likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_post_likes_like_id_seq OWNED BY public.feed_post_likes.like_id;


--
-- Name: feed_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_posts (
    post_id integer NOT NULL,
    memory_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    caption text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.feed_posts OWNER TO postgres;

--
-- Name: feed_posts_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_posts_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_posts_post_id_seq OWNER TO postgres;

--
-- Name: feed_posts_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_posts_post_id_seq OWNED BY public.feed_posts.post_id;


--
-- Name: feed_profiles; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.feed_profiles OWNER TO postgres;

--
-- Name: feed_profiles_feed_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_profiles_feed_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_profiles_feed_profile_id_seq OWNER TO postgres;

--
-- Name: feed_profiles_feed_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_profiles_feed_profile_id_seq OWNED BY public.feed_profiles.feed_profile_id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follow (
    follower_id integer NOT NULL,
    following_id integer NOT NULL
);


ALTER TABLE public.follow OWNER TO postgres;

--
-- Name: group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."group" (
    group_id integer NOT NULL,
    g_name character varying(50),
    g_description character varying(100),
    created_at date DEFAULT CURRENT_DATE,
    user_id integer,
    group_pic character varying,
    group_url character varying
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- Name: group_announcement; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.group_announcement OWNER TO postgres;

--
-- Name: group_announcement_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_announcement_announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.group_announcement_announcement_id_seq OWNER TO postgres;

--
-- Name: group_announcement_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_announcement_announcement_id_seq OWNED BY public.group_announcement.announcement_id;


--
-- Name: group_encryption_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_encryption_keys (
    group_id integer NOT NULL,
    key_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    encrypted_key bytea NOT NULL,
    iv bytea,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.group_encryption_keys OWNER TO postgres;

--
-- Name: COLUMN group_encryption_keys.iv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.group_encryption_keys.iv IS 'IV used when encrypting this key for this user';


--
-- Name: group_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.group_group_id_seq OWNER TO postgres;

--
-- Name: group_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_group_id_seq OWNED BY public."group".group_id;


--
-- Name: group_invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_invite (
    invite_id integer NOT NULL,
    group_id integer NOT NULL,
    invite_token character varying(64) NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


ALTER TABLE public.group_invite OWNER TO postgres;

--
-- Name: group_invite_invite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_invite_invite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.group_invite_invite_id_seq OWNER TO postgres;

--
-- Name: group_invite_invite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_invite_invite_id_seq OWNED BY public.group_invite.invite_id;


--
-- Name: group_media_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_media_shares (
    group_id integer NOT NULL,
    media_id integer NOT NULL,
    shared_by_user_id integer NOT NULL,
    shared_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.group_media_shares OWNER TO postgres;

--
-- Name: group_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_member (
    group_id integer NOT NULL,
    member_id integer NOT NULL,
    role character varying(50),
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.group_member OWNER TO postgres;

--
-- Name: journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal (
    journal_id integer NOT NULL,
    j_title character varying(50),
    j_content text,
    user_id integer NOT NULL,
    journal_pic character varying,
    is_in_vault boolean DEFAULT false
);


ALTER TABLE public.journal OWNER TO postgres;

--
-- Name: journal_journal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_journal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_journal_id_seq OWNER TO postgres;

--
-- Name: journal_journal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_journal_id_seq OWNED BY public.journal.journal_id;


--
-- Name: journal_streaks; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.journal_streaks OWNER TO postgres;

--
-- Name: journal_streaks_streak_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.journal_streaks_streak_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_streaks_streak_id_seq OWNER TO postgres;

--
-- Name: journal_streaks_streak_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.journal_streaks_streak_id_seq OWNED BY public.journal_streaks.streak_id;


--
-- Name: journal_theme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal_theme (
    journal_id integer NOT NULL,
    theme_id integer NOT NULL
);


ALTER TABLE public.journal_theme OWNER TO postgres;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.likes (
    like_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    liked_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.likes OWNER TO postgres;

--
-- Name: likes_like_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.likes_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_like_id_seq OWNER TO postgres;

--
-- Name: likes_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.likes_like_id_seq OWNED BY public.likes.like_id;


--
-- Name: media_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media_items (
    media_id integer NOT NULL,
    user_id integer NOT NULL,
    filename character varying(255) NOT NULL,
    original_filename character varying(255) NOT NULL,
    file_path character varying(512) NOT NULL,
    file_size bigint,
    mime_type character varying(100),
    media_type character varying(20),
    title character varying(255),
    description text,
    upload_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_public boolean DEFAULT false,
    storage_bucket character varying(100),
    metadata jsonb,
    is_encrypted boolean DEFAULT true,
    encryption_key_id character varying(255),
    file_hash character varying(255),
    split_count integer DEFAULT 1,
    original_file_size bigint,
    is_split boolean DEFAULT false,
    encryption_iv bytea,
    CONSTRAINT media_items_media_type_check CHECK (((media_type)::text = ANY (ARRAY[('IMAGE'::character varying)::text, ('VIDEO'::character varying)::text, ('AUDIO'::character varying)::text, ('DOCUMENT'::character varying)::text])))
);


ALTER TABLE public.media_items OWNER TO postgres;

--
-- Name: COLUMN media_items.encryption_iv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.media_items.encryption_iv IS 'IV used to encrypt this media file';


--
-- Name: media_items_media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_items_media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_items_media_id_seq OWNER TO postgres;

--
-- Name: media_items_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_items_media_id_seq OWNED BY public.media_items.media_id;


--
-- Name: media_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media_shares (
    share_id integer NOT NULL,
    media_id integer NOT NULL,
    share_type character varying(20),
    share_key character varying(255),
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT media_shares_share_type_check CHECK (((share_type)::text = ANY (ARRAY[('PUBLIC'::character varying)::text, ('LINK'::character varying)::text, ('GROUP'::character varying)::text])))
);


ALTER TABLE public.media_shares OWNER TO postgres;

--
-- Name: media_shares_share_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_shares_share_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_shares_share_id_seq OWNER TO postgres;

--
-- Name: media_shares_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_shares_share_id_seq OWNED BY public.media_shares.share_id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    member_id integer NOT NULL,
    user_id integer,
    g_role character varying(100),
    joined_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.member OWNER TO postgres;

--
-- Name: member_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.member_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.member_member_id_seq OWNER TO postgres;

--
-- Name: member_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.member_member_id_seq OWNED BY public.member.member_id;


--
-- Name: memory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memory (
    memory_id integer NOT NULL,
    title character varying(100) NOT NULL,
    description character varying(255),
    updated_at date,
    user_id integer NOT NULL,
    cover_media_id integer,
    created_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_public boolean DEFAULT false,
    share_key character varying(255),
    expires_at timestamp without time zone,
    is_link_shared boolean DEFAULT false,
    is_in_vault boolean DEFAULT false,
    is_collaborative boolean DEFAULT false,
    collab_share_key character varying(20),
    group_id integer
);


ALTER TABLE public.memory OWNER TO postgres;

--
-- Name: memory_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memory_media (
    memory_id integer NOT NULL,
    media_id integer NOT NULL,
    added_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.memory_media OWNER TO postgres;

--
-- Name: memory_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memory_members (
    id integer NOT NULL,
    memory_id integer NOT NULL,
    user_id integer NOT NULL,
    role character varying(20) DEFAULT 'member'::character varying NOT NULL,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.memory_members OWNER TO postgres;

--
-- Name: memory_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memory_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.memory_members_id_seq OWNER TO postgres;

--
-- Name: memory_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_members_id_seq OWNED BY public.memory_members.id;


--
-- Name: memory_memory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memory_memory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.memory_memory_id_seq OWNER TO postgres;

--
-- Name: memory_memory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_memory_id_seq OWNED BY public.memory.memory_id;


--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_preferences (
    pref_id integer NOT NULL,
    user_id integer NOT NULL,
    notif_type character varying(50) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_preferences OWNER TO postgres;

--
-- Name: notification_preferences_pref_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_preferences_pref_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_preferences_pref_id_seq OWNER TO postgres;

--
-- Name: notification_preferences_pref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_preferences_pref_id_seq OWNED BY public.notification_preferences.pref_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    plan_id integer NOT NULL,
    name character varying(50) NOT NULL,
    storage_limit_bytes bigint NOT NULL,
    price_monthly numeric(10,2) NOT NULL,
    price_annual numeric(10,2) NOT NULL,
    max_members integer DEFAULT 1,
    description text,
    memory_limit integer DEFAULT '-1'::integer
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- Name: plans_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plans_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plans_plan_id_seq OWNER TO postgres;

--
-- Name: plans_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plans_plan_id_seq OWNED BY public.plans.plan_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post (
    post_id integer NOT NULL,
    content text NOT NULL,
    created_at date DEFAULT CURRENT_DATE,
    profile_id integer NOT NULL
);


ALTER TABLE public.post OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.post_post_id_seq OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_post_id_seq OWNED BY public.post.post_id;


--
-- Name: post_reports; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.post_reports OWNER TO postgres;

--
-- Name: post_reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.post_reports_report_id_seq OWNER TO postgres;

--
-- Name: post_reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_reports_report_id_seq OWNED BY public.post_reports.report_id;


--
-- Name: publicprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicprofile (
    profile_id integer NOT NULL,
    display_name character varying(100),
    bio text,
    profile_picture character varying(255),
    follow_count integer DEFAULT 0
);


ALTER TABLE public.publicprofile OWNER TO postgres;

--
-- Name: publicprofile_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publicprofile_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publicprofile_profile_id_seq OWNER TO postgres;

--
-- Name: publicprofile_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publicprofile_profile_id_seq OWNED BY public.publicprofile.profile_id;


--
-- Name: recap; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recap (
    recap_id integer NOT NULL,
    memory_id integer NOT NULL,
    generated_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.recap OWNER TO postgres;

--
-- Name: recap_recap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recap_recap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recap_recap_id_seq OWNER TO postgres;

--
-- Name: recap_recap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recap_recap_id_seq OWNED BY public.recap.recap_id;


--
-- Name: recycle_bin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recycle_bin (
    id integer NOT NULL,
    original_id integer NOT NULL,
    item_type character varying(30) NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text,
    metadata jsonb,
    deleted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.recycle_bin OWNER TO postgres;

--
-- Name: recycle_bin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recycle_bin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recycle_bin_id_seq OWNER TO postgres;

--
-- Name: recycle_bin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recycle_bin_id_seq OWNED BY public.recycle_bin.id;


--
-- Name: repost; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repost (
    repost_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.repost OWNER TO postgres;

--
-- Name: repost_repost_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repost_repost_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repost_repost_id_seq OWNER TO postgres;

--
-- Name: repost_repost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repost_repost_id_seq OWNED BY public.repost.repost_id;


--
-- Name: saved_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_posts (
    saved_id integer NOT NULL,
    feed_profile_id integer NOT NULL,
    post_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.saved_posts OWNER TO postgres;

--
-- Name: saved_posts_saved_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.saved_posts_saved_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.saved_posts_saved_id_seq OWNER TO postgres;

--
-- Name: saved_posts_saved_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.saved_posts_saved_id_seq OWNED BY public.saved_posts.saved_id;


--
-- Name: share; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.share (
    share_id integer NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at date DEFAULT CURRENT_DATE
);


ALTER TABLE public.share OWNER TO postgres;

--
-- Name: share_share_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.share_share_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.share_share_id_seq OWNER TO postgres;

--
-- Name: share_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.share_share_id_seq OWNED BY public.share.share_id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id integer NOT NULL,
    post_id integer NOT NULL,
    tagged_user_id integer NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_tag_id_seq OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_tag_id_seq OWNED BY public.tag.tag_id;


--
-- Name: theme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.theme (
    theme_id integer NOT NULL,
    t_name character varying(50)
);


ALTER TABLE public.theme OWNER TO postgres;

--
-- Name: theme_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.theme_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.theme_theme_id_seq OWNER TO postgres;

--
-- Name: theme_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.theme_theme_id_seq OWNED BY public.theme.theme_id;


--
-- Name: trash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trash (
    user_id integer NOT NULL
);


ALTER TABLE public.trash OWNER TO postgres;

--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    session_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    device_name character varying(255),
    device_type character varying(50),
    ip_address character varying(45),
    user_agent text,
    is_active boolean DEFAULT true
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    salt character varying(255) NOT NULL,
    bio text,
    joined_at date DEFAULT CURRENT_DATE,
    is_active boolean,
    last_login timestamp without time zone,
    profile_picture_url character varying(255),
    master_key_encrypted bytea,
    key_derivation_salt bytea,
    plan_id integer DEFAULT 1,
    vault_setup_completed boolean DEFAULT false,
    vault_password_hash character varying(255),
    vault_password_salt character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: vault; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vault (
    user_id integer NOT NULL
);


ALTER TABLE public.vault OWNER TO postgres;

--
-- Name: autograph autograph_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph ALTER COLUMN autograph_id SET DEFAULT nextval('public.autograph_autograph_id_seq'::regclass);


--
-- Name: autograph_activity activity_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_activity ALTER COLUMN activity_id SET DEFAULT nextval('public.autograph_activity_activity_id_seq'::regclass);


--
-- Name: autograph_entry entry_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_entry ALTER COLUMN entry_id SET DEFAULT nextval('public.autograph_entry_entry_id_seq'::regclass);


--
-- Name: block block_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block ALTER COLUMN block_id SET DEFAULT nextval('public.block_block_id_seq'::regclass);


--
-- Name: blocked_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocked_users ALTER COLUMN id SET DEFAULT nextval('public.blocked_users_id_seq'::regclass);


--
-- Name: collab collab_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collab ALTER COLUMN collab_id SET DEFAULT nextval('public.collab_collab_id_seq'::regclass);


--
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- Name: encryption_audit_log log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_audit_log ALTER COLUMN log_id SET DEFAULT nextval('public.encryption_audit_log_log_id_seq'::regclass);


--
-- Name: encryption_metadata metadata_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_metadata ALTER COLUMN metadata_id SET DEFAULT nextval('public.encryption_metadata_metadata_id_seq'::regclass);


--
-- Name: event event_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event ALTER COLUMN event_id SET DEFAULT nextval('public.event_event_id_seq'::regclass);


--
-- Name: event_vote vote_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote ALTER COLUMN vote_id SET DEFAULT nextval('public.event_vote_vote_id_seq'::regclass);


--
-- Name: feed_comment_likes like_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_comment_likes ALTER COLUMN like_id SET DEFAULT nextval('public.feed_comment_likes_like_id_seq'::regclass);


--
-- Name: feed_follows follow_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_follows ALTER COLUMN follow_id SET DEFAULT nextval('public.feed_follows_follow_id_seq'::regclass);


--
-- Name: feed_post_comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.feed_post_comments_comment_id_seq'::regclass);


--
-- Name: feed_post_likes like_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_likes ALTER COLUMN like_id SET DEFAULT nextval('public.feed_post_likes_like_id_seq'::regclass);


--
-- Name: feed_posts post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_posts ALTER COLUMN post_id SET DEFAULT nextval('public.feed_posts_post_id_seq'::regclass);


--
-- Name: feed_profiles feed_profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_profiles ALTER COLUMN feed_profile_id SET DEFAULT nextval('public.feed_profiles_feed_profile_id_seq'::regclass);


--
-- Name: group group_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group" ALTER COLUMN group_id SET DEFAULT nextval('public.group_group_id_seq'::regclass);


--
-- Name: group_announcement announcement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_announcement ALTER COLUMN announcement_id SET DEFAULT nextval('public.group_announcement_announcement_id_seq'::regclass);


--
-- Name: group_invite invite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_invite ALTER COLUMN invite_id SET DEFAULT nextval('public.group_invite_invite_id_seq'::regclass);


--
-- Name: journal journal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal ALTER COLUMN journal_id SET DEFAULT nextval('public.journal_journal_id_seq'::regclass);


--
-- Name: journal_streaks streak_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_streaks ALTER COLUMN streak_id SET DEFAULT nextval('public.journal_streaks_streak_id_seq'::regclass);


--
-- Name: likes like_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes ALTER COLUMN like_id SET DEFAULT nextval('public.likes_like_id_seq'::regclass);


--
-- Name: media_items media_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_items ALTER COLUMN media_id SET DEFAULT nextval('public.media_items_media_id_seq'::regclass);


--
-- Name: media_shares share_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_shares ALTER COLUMN share_id SET DEFAULT nextval('public.media_shares_share_id_seq'::regclass);


--
-- Name: member member_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member ALTER COLUMN member_id SET DEFAULT nextval('public.member_member_id_seq'::regclass);


--
-- Name: memory memory_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory ALTER COLUMN memory_id SET DEFAULT nextval('public.memory_memory_id_seq'::regclass);


--
-- Name: memory_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_members ALTER COLUMN id SET DEFAULT nextval('public.memory_members_id_seq'::regclass);


--
-- Name: notification_preferences pref_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_preferences ALTER COLUMN pref_id SET DEFAULT nextval('public.notification_preferences_pref_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: plans plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans ALTER COLUMN plan_id SET DEFAULT nextval('public.plans_plan_id_seq'::regclass);


--
-- Name: post post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post ALTER COLUMN post_id SET DEFAULT nextval('public.post_post_id_seq'::regclass);


--
-- Name: post_reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports ALTER COLUMN report_id SET DEFAULT nextval('public.post_reports_report_id_seq'::regclass);


--
-- Name: publicprofile profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicprofile ALTER COLUMN profile_id SET DEFAULT nextval('public.publicprofile_profile_id_seq'::regclass);


--
-- Name: recap recap_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap ALTER COLUMN recap_id SET DEFAULT nextval('public.recap_recap_id_seq'::regclass);


--
-- Name: recycle_bin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recycle_bin ALTER COLUMN id SET DEFAULT nextval('public.recycle_bin_id_seq'::regclass);


--
-- Name: repost repost_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repost ALTER COLUMN repost_id SET DEFAULT nextval('public.repost_repost_id_seq'::regclass);


--
-- Name: saved_posts saved_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_posts ALTER COLUMN saved_id SET DEFAULT nextval('public.saved_posts_saved_id_seq'::regclass);


--
-- Name: share share_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.share ALTER COLUMN share_id SET DEFAULT nextval('public.share_share_id_seq'::regclass);


--
-- Name: tag tag_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN tag_id SET DEFAULT nextval('public.tag_tag_id_seq'::regclass);


--
-- Name: theme theme_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.theme ALTER COLUMN theme_id SET DEFAULT nextval('public.theme_theme_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: autograph; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autograph (autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url, share_token) FROM stdin;
10	hesanda	vsfvs	2026-02-18	30	1771383546073_tempImagewzJAUZ.png	\N
11	Hesanda tests autograph book	yeah	2026-02-25	28	1772011878797_391e11fcd3561b9346a3a548807a081a.jpg	U7LHLdsL5Z17
\.


--
-- Data for Name: autograph_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autograph_activity (activity_id, autograph_id, user_id, action, created_at, entry_data, signer_name) FROM stdin;
\.


--
-- Data for Name: autograph_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autograph_entry (entry_id, link, content, submitted_at, autograph_id, user_id, content_plain) FROM stdin;
1	U7LHLdsL5Z17	\n                                        <!-- Red margin line -->\n                                        \n\n                                        <!-- Writing Area -->\n                                        <div class="message-text" id="" style="position: absolute; top: 10%; left: 10%; width: 80%; cursor: grab;">my autograph entry</div>\n\n                                        <!-- Decorations Container -->\n                                        <div class="decorations-container" id="decorationsContainer">\n                                            <!-- Draggable emojis/stickers will be added here -->\n                                        <div class="decoration " draggable="true" style="top: 9.547069%; left: 28.720757%; cursor: grab; z-index: 10;">🎈</div><div class="decoration " draggable="true" style="top: 12.207021%; left: 28.439299%; cursor: grab; z-index: 10;">🎓</div><div class="decoration " draggable="true" style="top: 11.169239%; left: 30.641418%; cursor: grab; z-index: 10;">🌸</div></div>\n\n                                        <!-- Author Name Input -->\n                                        <div class="author-input-wrapper" style="position: absolute; inset: 85% auto auto 60%; cursor: grab; z-index: 10;">\n                                            <div class="author-signature">- lhesanda</div>\n                                        </div>\n                                    	2026-02-27	11	29	my autograph entry
2	U7LHLdsL5Z17	\n                                        <!-- Red margin line -->\n                                        \n\n                                        <!-- Writing Area -->\n                                        <div class="message-text" id="" style="position: absolute; top: 10%; left: 10%; width: 80%; cursor: grab; z-index: 2;">test 01</div>\n\n                                        <!-- Decorations Container -->\n                                        <div class="decorations-container" id="decorationsContainer">\n                                            <!-- Draggable emojis/stickers will be added here -->\n                                        <div class="decoration " draggable="true" style="top: 10.678152%; left: 18.648053%; cursor: grab; z-index: 10;">💜</div><div class="decoration " draggable="true" style="top: 6.831656%; left: 16.618162%; cursor: grab; z-index: 10;">✨</div><div class="decoration " draggable="true" style="top: 14.26178%; left: 17.512482%; cursor: grab; z-index: 10;">🎈</div></div>\n\n                                        <!-- Author Name Input -->\n                                        <div class="author-input-wrapper" style="position: absolute; inset: 85% auto auto 60%; cursor: grab; z-index: 10;">\n                                            <div class="author-signature">- lhesanda</div>\n                                        </div>\n                                    	2026-02-28	11	29	test 01
3	U7LHLdsL5Z17	\n                                        <!-- Red margin line -->\n                                        \n\n                                        <!-- Writing Area -->\n                                        <div class="message-text" id="" style="position: absolute; top: 10%; left: 10%; width: 80%; cursor: grab; z-index: 2;">ertyuio</div>\n\n                                        <!-- Decorations Container -->\n                                        <div class="decorations-container" id="decorationsContainer">\n                                            <!-- Draggable emojis/stickers will be added here -->\n                                        <div class="decoration " draggable="true" style="top: 5.734375%; left: 19.631148%; cursor: grab; z-index: 10;">❤️</div><div class="decoration " draggable="true" style="top: 6.083333%; left: 15.894809%; cursor: grab; z-index: 10;">🎈</div><div class="decoration " draggable="true" style="top: 10.315104%; left: 19.815574%; cursor: grab; z-index: 10;">🌸</div></div>\n\n                                        <!-- Author Name Input -->\n                                        <div class="author-input-wrapper" style="position: absolute; inset: 85% auto auto 60.10929%; cursor: grab; z-index: 10;">\n                                            <div class="author-signature">- hesanda</div>\n                                        </div>\n                                    	2026-02-28	11	29	ertyuio
4	U7LHLdsL5Z17	\n                                        <!-- Red margin line -->\n                                        \n\n                                        <!-- Writing Area -->\n                                        <div class="message-text" id="" style="position: absolute; top: 10%; left: 10%; width: 80%; cursor: grab; z-index: 2;">latest one</div>\n\n                                        <!-- Decorations Container -->\n                                        <div class="decorations-container" id="decorationsContainer"><div class="decoration " draggable="true" style="top: 51.929743%; left: 41.562145%; cursor: grab;">🎈</div><div class="decoration " draggable="true" style="top: 59.856345%; left: 18.397594%; cursor: grab;">💜</div></div>\n\n                                        <!-- Author Name Input -->\n                                        <div class="author-input-wrapper" style="position: absolute; inset: 85% auto auto 60.10929%; cursor: grab; z-index: 10;">\n                                            <div class="author-signature">- latest</div>\n                                        </div>\n                                    	2026-02-28	11	29	latest one
\.


--
-- Data for Name: block; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block (block_id, user_id, blocked_user_id, blocked_at) FROM stdin;
\.


--
-- Data for Name: blocked_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blocked_users (id, blocker_profile_id, blocked_profile_id, created_at) FROM stdin;
\.


--
-- Data for Name: collab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collab (collab_id, post_id, shared_with) FROM stdin;
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (comment_id, post_id, user_id, content, commented_at) FROM stdin;
\.


--
-- Data for Name: encryption_audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encryption_audit_log (log_id, user_id, action, entity_type, entity_id, ip_address, "timestamp") FROM stdin;
\.


--
-- Data for Name: encryption_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encryption_keys (key_id, user_id, encrypted_key, created_at, iv) FROM stdin;
a72ecc27-896b-45a8-b5c2-fe6a70801326	28	\\xaf62b6570412c9b825452177813f44aaff0f1bc53ff9f566ffb4bcecc49f902e605df1b45877c5ca5b9531732be6fcf1	2026-03-08 11:49:02.328036	\\x14fc6e62b80854cc3597cedf
3115c06c-0fe7-4024-b437-03055ef27766	28	\\x99df4e6f2ce7664461f5b8b834970161a6ae9dbbf7799a44252bdc6997eba5fdbacefa32be880546e215908713f3bfd0	2026-03-08 11:51:26.417269	\\x91629db60f08c3e8fc145c1b
\.


--
-- Data for Name: encryption_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encryption_metadata (metadata_id, entity_type, entity_id, iv, created_at) FROM stdin;
1	user_master_key	22	\\x602a8c1346f20101cf3c1867	2025-12-03 12:12:25.196255
2	user_master_key	23	\\x42dc9128827a35fdfa0772d0	2025-12-05 12:26:22.223893
3	user_master_key	24	\\x566503fb942e665165d4a397	2025-12-10 11:24:01.668915
4	user_master_key	27	\\x12ab7db7a8c5644025b27505	2025-12-10 11:45:20.728398
5	user_master_key	28	\\x4f5f869daf92681565354107	2026-01-17 09:19:34.754523
6	user_master_key	29	\\xd8c8cb522f6a480149c39753	2026-01-19 09:15:26.797552
7	user_master_key	30	\\xd76fae25d26ec0e1a7ba8777	2026-01-19 10:39:17.237533
9	user_master_key	32	\\x5d657f5af6a155e488d872ab	2026-01-19 12:45:49.134124
10	user_master_key	33	\\x470461b2120258810a6999eb	2026-01-19 13:29:44.166718
13	user_master_key	36	\\xa89d0d2d7167972f46d028ab	2026-01-31 19:17:47.722023
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event (event_id, e_title, e_description, e_date, created_at, group_id, event_pic) FROM stdin;
5	vow	vdw	2026-02-13	2026-02-08	7	\N
6	1234567	sdfghj	2026-02-20	2026-02-18	9	media_uploads/event_b36c81db-66b6-4ea0-a8eb-7b7e137c223e.jpg
7	hesanda ge bday eka	asdfgb	2026-10-02	2026-03-01	7	\N
\.


--
-- Data for Name: event_attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_attendance (event_id) FROM stdin;
\.


--
-- Data for Name: event_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_group (event_id, group_id, created_at) FROM stdin;
5	7	2026-03-01 11:20:18.051849
6	9	2026-03-01 11:20:18.051849
7	7	2026-03-12 06:58:09.680477
7	9	2026-03-12 06:58:09.680477
\.


--
-- Data for Name: event_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_user (event_id, group_id) FROM stdin;
\.


--
-- Data for Name: event_vote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_vote (vote_id, event_id, group_id, user_id, vote, voted_at) FROM stdin;
1	7	7	28	going	2026-03-01 12:16:28.251092
5	7	9	28	going	2026-03-07 10:49:42.088447
\.


--
-- Data for Name: feed_comment_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_comment_likes (like_id, comment_id, feed_profile_id, created_at) FROM stdin;
1	2	1	2026-02-09 09:07:38.024387
3	2	2	2026-02-12 09:14:20.580024
5	1	1	2026-03-12 07:10:30.870432
\.


--
-- Data for Name: feed_follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_follows (follow_id, follower_id, following_id, created_at) FROM stdin;
1	2	1	2026-02-10 08:29:23.590081
3	1	2	2026-03-12 07:10:44.820988
\.


--
-- Data for Name: feed_post_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_post_comments (comment_id, post_id, feed_profile_id, parent_comment_id, comment_text, created_at, updated_at) FROM stdin;
1	1	1	\N	First Comment	2026-02-09 08:58:17.420641	2026-02-09 08:58:17.420641
2	2	1	\N	hi this is my first comment	2026-02-09 09:07:34.199847	2026-02-09 09:07:34.199847
3	2	1	2	@hesnada mmm	2026-02-09 09:07:52.870832	2026-02-09 09:07:52.870832
4	1	1	1	@hesnada okay	2026-02-09 09:08:01.687599	2026-02-09 09:08:01.687599
6	1	2	1	@hesnada this is a reply for that comment	2026-02-10 08:28:42.694298	2026-02-10 08:28:42.694298
7	2	2	2	@hesnada the	2026-02-12 09:04:34.400396	2026-02-12 09:04:34.400396
8	1	2	1	@hesnada reply to that comment	2026-02-12 09:13:03.139878	2026-02-12 09:13:03.139878
9	2	2	2	@hesnada why this is not working	2026-02-12 09:14:25.297614	2026-02-12 09:14:25.297614
10	2	1	2	@hesnada hii	2026-02-12 15:48:58.376765	2026-02-12 15:48:58.376765
\.


--
-- Data for Name: feed_post_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_post_likes (like_id, post_id, feed_profile_id, created_at) FROM stdin;
1	1	1	2026-02-09 09:08:09.747644
4	1	2	2026-02-10 08:28:56.009024
5	2	2	2026-02-10 08:28:58.463752
6	2	1	2026-02-12 15:48:50.324644
\.


--
-- Data for Name: feed_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_posts (post_id, memory_id, feed_profile_id, caption, created_at, updated_at) FROM stdin;
1	16	1		2026-01-31 18:52:24.546466	2026-01-31 18:52:24.546466
2	17	1		2026-02-07 16:04:18.602191	2026-02-07 16:04:18.602191
3	22	1	This is an encrypted one. lets see others can see this or not	2026-03-12 07:11:35.671152	2026-03-12 07:11:35.671152
\.


--
-- Data for Name: feed_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_profiles (feed_profile_id, user_id, feed_username, feed_profile_picture_url, feed_bio, created_at, updated_at) FROM stdin;
2	29	hessssss	/uploads/feed-profiles/feed_29_aa80d95f-1d2f-4180-848a-4c8c81eb9e63.jpg	second one I think	2026-02-10 08:28:26.832	2026-02-10 08:28:26.832
1	28	hesnada	/uploads/feed-profiles/feed_28_025794d8-49c9-4bc1-ba9c-ee49adbb86b8.png	this is my first pro	2026-01-31 18:48:04.201	2026-03-12 07:11:02.474
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.follow (follower_id, following_id) FROM stdin;
\.


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."group" (group_id, g_name, g_description, created_at, user_id, group_pic, group_url) FROM stdin;
8	mnmn		2026-01-26	30	\N	nkllnknl
7	Hesanda's first group (cant add members)	hehe	2026-01-17	28	/resources/db images/group_96130885-6e19-4522-81a0-67794f2b1cb7.png	hehe
9	asdfghjklkjhgfredfrgh	qwertyuio	2026-01-26	28	/resources/db images/group_10eae6f4-ebe2-4c57-be99-3b026b52bbb4.jpeg	123456789
\.


--
-- Data for Name: group_announcement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_announcement (announcement_id, group_id, user_id, title, content, created_at, event_id) FROM stdin;
1	7	28	qwertyui	qwertyhujik	2026-01-26 09:38:40.233	\N
2	9	28	New Event: 1234567	A new event '1234567' has been scheduled for 2026-02-20.\n\nDetails: sdfghj	2026-02-18 11:13:32.288	6
3	7	28	New Event: hesanda ge bday eka	A new event 'hesanda ge bday eka' has been scheduled for 2026-10-02.\n\nDetails: asdfgb	2026-03-01 11:54:25.603	7
4	9	28	New Event: hesanda ge bday eka	A new event 'hesanda ge bday eka' has been scheduled for 2026-10-02.\n\nDetails: asdfgb	2026-03-01 11:54:25.617	7
\.


--
-- Data for Name: group_encryption_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_encryption_keys (group_id, key_id, user_id, encrypted_key, iv, created_at) FROM stdin;
\.


--
-- Data for Name: group_invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_invite (invite_id, group_id, invite_token, created_by, created_at, is_active) FROM stdin;
2	9	56420fc31d184343	28	2026-01-26 09:42:13.086	t
3	9	21bef88a4d3b4693	28	2026-01-26 09:52:44.074	t
4	9	f45da739305242a4	28	2026-01-26 10:27:29.524	t
5	9	305d20ade8f64d37	28	2026-02-14 06:45:02.555	t
\.


--
-- Data for Name: group_media_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_media_shares (group_id, media_id, shared_by_user_id, shared_at) FROM stdin;
\.


--
-- Data for Name: group_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_member (group_id, member_id, role, joined_at, status) FROM stdin;
9	28	admin	2026-01-26 09:40:26.672	active
9	29	viewer	2026-02-14 06:45:40.372	active
\.


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal (journal_id, j_title, j_content, user_id, journal_pic, is_in_vault) FROM stdin;
13	19th January 2026	{"htmlContent":"hhgklj","decorations":[]}	28	\N	f
17	3rd March 2026	{"htmlContent":"fggvbvbvbvbvbbvbvbv<div>ghjkl</div><div>dfghjmk</div><div>ghjk</div><div>hjk</div><div>hjk</div><div>hjk</div><div>hjkl</div><div>hjk</div><div>hjk</div><div>bnm</div><div>bnm,</div><div>b</div><div>hjm,</div><div>nmk,</div><div>jkl</div><div>jkl</div><div>nkm,</div><div>m,</div><div>m,.</div><div>m,</div><div>m,</div><div>nm,.</div><div>m,.</div><div><br></div>","decorations":[{"content":"🌸","className":"decoration ","top":"15.0091%","left":"26.1964%"},{"content":"♡","className":"decoration heart","top":"21.9661%","left":"63.1204%"}],"backgroundTheme":"/resources/assets/journal4.jpg"}	28	\N	f
15	28th February 2026	{"htmlContent":"dvfwqgvreve","decorations":[{"content":"🎈","className":"decoration emoji","top":"2.19792%","left":"23.3272%"},{"content":"☀️","className":"decoration emoji","top":"2.10547%","left":"18.099%"},{"content":"☀️","className":"decoration emoji","top":"13.7214%","left":"22.6126%"}],"backgroundTheme":"/resources/assets/journal1.png"}	28	\N	f
18	19th January 2026	{"htmlContent":"gewgewgew","decorations":[{"content":"🎈","className":"decoration emoji","top":"27.0904%","left":"76.6209%"},{"content":"💜","className":"decoration emoji","top":"7.80599%","left":"17.2327%"},{"content":"🎊","className":"decoration emoji","top":"8.35026%","left":"12.7987%"}],"backgroundTheme":"/resources/assets/journal1.png"}	28		f
\.


--
-- Data for Name: journal_streaks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal_streaks (streak_id, user_id, current_streak, longest_streak, last_entry_date, created_at, updated_at) FROM stdin;
2	29	0	0	\N	2026-01-19 09:51:06.625537	2026-01-19 09:51:06.625537
4	30	0	0	\N	2026-01-26 09:22:13.963101	2026-01-26 09:22:13.963101
3	28	0	1	2026-03-03	2026-01-19 13:08:04.910094	2026-03-06 09:25:28.82548
\.


--
-- Data for Name: journal_theme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal_theme (journal_id, theme_id) FROM stdin;
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.likes (like_id, post_id, user_id, liked_at) FROM stdin;
\.


--
-- Data for Name: media_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media_items (media_id, user_id, filename, original_filename, file_path, file_size, mime_type, media_type, title, description, upload_timestamp, is_public, storage_bucket, metadata, is_encrypted, encryption_key_id, file_hash, split_count, original_file_size, is_split, encryption_iv) FROM stdin;
11	28	bf5cb617-10cd-4974-ac64-fec78c3900df_spideywallpaper.jpg	spideywallpaper.jpg	media_uploads/bf5cb617-10cd-4974-ac64-fec78c3900df_spideywallpaper.jpg	117345	image/jpeg	IMAGE	spideywallpaper.jpg	\N	2026-01-19 08:24:44.574629	f	\N	\N	f	\N	\N	1	117345	f	\N
13	28	1de3b0de-fe46-4907-87df-d3b4d42cb9a3_spideywallpaper.jpg	spideywallpaper.jpg	media_uploads/1de3b0de-fe46-4907-87df-d3b4d42cb9a3_spideywallpaper.jpg	117345	image/jpeg	IMAGE	spideywallpaper.jpg	\N	2026-01-19 09:06:29.019568	f	\N	\N	f	\N	\N	1	117345	f	\N
14	28	0e684226-1e85-4f4c-b623-3a797dfb68ad_finalwalll.jpg	finalwalll.jpg	media_uploads/0e684226-1e85-4f4c-b623-3a797dfb68ad_finalwalll.jpg	40739	image/jpeg	IMAGE	finalwalll.jpg	\N	2026-01-19 13:51:00.116795	f	\N	\N	f	\N	\N	1	40739	f	\N
15	28	999f6207-0f2c-4ae5-88c1-ab4b70b9ee68_spideywallpaper.jpg	spideywallpaper.jpg	media_uploads/999f6207-0f2c-4ae5-88c1-ab4b70b9ee68_spideywallpaper.jpg	117345	image/jpeg	IMAGE	spideywallpaper.jpg	\N	2026-01-26 09:29:38.789783	f	\N	\N	f	\N	\N	1	117345	f	\N
16	28	01274d83-af6c-4bbc-8491-077850f57187_binara.events-662.jpg	binara.events-662.jpg	media_uploads/01274d83-af6c-4bbc-8491-077850f57187_binara.events-662.jpg	139483	image/jpeg	IMAGE	binara.events-662.jpg	\N	2026-01-31 18:52:22.368839	f	\N	\N	f	\N	\N	1	139483	f	\N
17	28	0e153e40-efd5-4049-9c30-98621727822c_625325559_1325983819575462_5235682478018915155_n.jpg	625325559_1325983819575462_5235682478018915155_n.jpg	media_uploads/0e153e40-efd5-4049-9c30-98621727822c_625325559_1325983819575462_5235682478018915155_n.jpg	769310	image/jpeg	IMAGE	625325559_1325983819575462_5235682478018915155_n.jpg	\N	2026-02-07 16:04:16.886233	f	\N	\N	f	\N	\N	1	769310	f	\N
18	28	ea6fae30-8d1f-4d58-b32e-3347ead48dc0_binara.events-487.jpg	binara.events-487.jpg	media_uploads/ea6fae30-8d1f-4d58-b32e-3347ead48dc0_binara.events-487.jpg	167797	image/jpeg	IMAGE	binara.events-487.jpg	\N	2026-02-07 16:04:16.913088	f	\N	\N	f	\N	\N	1	167797	f	\N
19	28	f09b134b-a648-4879-b89d-1ade6fa0c730_IMG_0869.heic	IMG_0869.heic	media_uploads/f09b134b-a648-4879-b89d-1ade6fa0c730_IMG_0869.heic	263952	image/heic	IMAGE	IMG_0869.heic	\N	2026-02-13 13:51:06.114682	f	\N	\N	f	\N	\N	1	263952	f	\N
20	28	fceb0295-4cc2-413a-93db-be058ac6ffb4_finalwalll.jpg	finalwalll.jpg	media_uploads/fceb0295-4cc2-413a-93db-be058ac6ffb4_finalwalll.jpg	40739	image/jpeg	IMAGE	finalwalll.jpg	\N	2026-02-13 13:51:41.828616	f	\N	\N	f	\N	\N	1	40739	f	\N
21	28	15fd9894-8f89-44b9-bc90-5b68f7b51101_625325559_1325983819575462_5235682478018915155_n.jpg	625325559_1325983819575462_5235682478018915155_n.jpg	media_uploads/15fd9894-8f89-44b9-bc90-5b68f7b51101_625325559_1325983819575462_5235682478018915155_n.jpg	769310	image/jpeg	IMAGE	625325559_1325983819575462_5235682478018915155_n.jpg	\N	2026-02-14 06:44:29.973873	f	\N	\N	f	\N	\N	1	769310	f	\N
22	28	6df79124-9d23-4c69-8a20-9aae034bcc12_IMG_1602.HEIC	IMG_1602.HEIC	media_uploads/6df79124-9d23-4c69-8a20-9aae034bcc12_IMG_1602.HEIC	3356103	image/heic	IMAGE	IMG_1602.HEIC	\N	2026-02-18 11:12:32.70285	f	\N	\N	f	\N	\N	1	3356103	f	\N
23	28	bf55d9e0-dd58-4b73-b32d-fcaaed98cca2.enc	jdb vs jpa cover.webp	media_uploads/bf55d9e0-dd58-4b73-b32d-fcaaed98cca2.enc	6991	image/webp	IMAGE	jdb vs jpa cover.webp	\N	2026-03-08 11:49:02.338159	f	\N	\N	t	a72ecc27-896b-45a8-b5c2-fe6a70801326	\N	1	6975	f	\\xf2248ed40783657bad149220
24	28	f104c956-0f98-45bc-ba26-e7487bb3ef6b.enc	campus_tour (1).mp4	media_uploads/f104c956-0f98-45bc-ba26-e7487bb3ef6b.enc	11869752	video/mp4	VIDEO	campus_tour (1).mp4	\N	2026-03-08 11:51:26.427674	f	\N	\N	t	3115c06c-0fe7-4024-b437-03055ef27766	\N	1	11869736	f	\\xfc3ba882088653760bfaa3a6
\.


--
-- Data for Name: media_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media_shares (share_id, media_id, share_type, share_key, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (member_id, user_id, g_role, joined_at) FROM stdin;
\.


--
-- Data for Name: memory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory (memory_id, title, description, updated_at, user_id, cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, is_in_vault, is_collaborative, collab_share_key, group_id) FROM stdin;
13	Hess'first collab memory	Created on 2026-01-05	2026-01-19	28	\N	2026-01-19 09:06:29.000025	f	\N	\N	f	f	t	RamUe1CgB3Yn8i	\N
14	test	Created on 2026-01-01	2026-01-19	28	\N	2026-01-19 13:51:00.092421	f	\N	\N	f	f	t	53wf4GgVd4SiAr	\N
15	hobo	Created on 2026-01-01	2026-01-26	28	\N	2026-01-26 09:29:38.778938	f	\N	\N	f	f	f	\N	\N
16	first feed memory	Created on 2026-01-02	2026-01-31	28	\N	2026-01-31 18:52:22.331604	f	\N	\N	f	f	f	\N	\N
17	heheh	Created on 2026-01-15	2026-02-07	28	\N	2026-02-07 16:04:16.859753	f	\N	\N	f	f	f	\N	\N
18	Collab memory by Hesanda	Created on 2026-02-06	2026-02-13	28	\N	2026-02-13 13:51:06.037703	f	\N	\N	f	f	t	\N	\N
19	hehe	Created on 2026-01-02	2026-02-13	28	\N	2026-02-13 13:51:41.787374	f	\N	\N	f	f	t	\N	\N
20	this is a group memory	Created on 2026-02-06	2026-02-14	28	\N	2026-02-14 06:44:29.900097	f	\N	\N	f	f	f	\N	9
21	1234567	Created on 2026-02-05	2026-02-18	28	\N	2026-02-18 11:12:32.679701	f	\N	\N	f	f	f	\N	7
22	encrypted one	Created on 200031-01-10	2026-03-08	28	\N	2026-03-08 11:49:02.283218	f	\N	\N	f	f	f	\N	\N
23	encrypted collab	Created on 2003-02-01	2026-03-08	28	\N	2026-03-08 11:51:26.097401	f	\N	\N	f	f	t	5JEDaEHoburr5U	\N
\.


--
-- Data for Name: memory_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_media (memory_id, media_id, added_timestamp) FROM stdin;
13	13	2026-01-19 09:06:29.029038
14	14	2026-01-19 13:51:00.126003
15	15	2026-01-26 09:29:38.800494
16	16	2026-01-31 18:52:22.383472
17	17	2026-02-07 16:04:16.901893
17	18	2026-02-07 16:04:16.926552
18	19	2026-02-13 13:51:06.130397
19	20	2026-02-13 13:51:41.84486
20	21	2026-02-14 06:44:30.009877
21	22	2026-02-18 11:12:32.712459
22	23	2026-03-08 11:49:02.348698
23	24	2026-03-08 11:51:26.435893
\.


--
-- Data for Name: memory_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_members (id, memory_id, user_id, role, joined_at) FROM stdin;
2	13	28	owner	2026-01-19 09:06:29.009079
5	14	28	owner	2026-01-19 13:51:00.104826
7	18	28	owner	2026-02-13 13:51:06.09059
8	19	28	owner	2026-02-13 13:51:41.807573
9	23	28	owner	2026-03-08 11:51:26.110311
10	23	29	member	2026-03-08 11:52:08.591203
\.


--
-- Data for Name: notification_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_preferences (pref_id, user_id, notif_type, enabled, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, user_id, notif_type, title, message, link, is_read, actor_id, created_at) FROM stdin;
7	28	comments_reactions	New Comment	commented on your post	/feed	f	29	2026-03-02 08:47:57.954914
8	28	comments_reactions	New Like	liked your post	/feed	f	29	2026-03-02 08:47:57.954914
9	28	memory_uploads	New Upload	uploaded 3 photos to Summer Vibes	/memories	f	29	2026-03-02 08:47:57.954914
10	28	group_announcements	Announcement	New announcement posted in Family Group	/groups	f	\N	2026-03-02 08:47:57.954914
11	28	event_updates	Event Update	The Beach Party event has been updated	/events	f	\N	2026-03-02 08:47:57.954914
12	28	comments_reactions	New Autograph Entry	wrote in your autograph book	/autographs	f	29	2026-03-02 08:47:57.954914
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plans (plan_id, name, storage_limit_bytes, price_monthly, price_annual, max_members, description, memory_limit) FROM stdin;
1	Basic	21474836480	0.00	0.00	1	Free tier with 20GB storage	50
2	Premium	268435456000	2.99	2.39	1	Premium tier with 250GB storage	-1
3	Pro	1099511627776	5.99	4.79	1	Pro tier with 1TB storage	-1
4	Family	2199023255552	9.99	7.99	6	Family tier with 2TB storage	-1
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post (post_id, content, created_at, profile_id) FROM stdin;
\.


--
-- Data for Name: post_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_reports (report_id, post_id, reporter_profile_id, reason, description, status, admin_notes, created_at, reviewed_at, reviewed_by) FROM stdin;
1	3	1	spam	\N	pending	\N	2026-03-12 07:49:31.076048	\N	\N
\.


--
-- Data for Name: publicprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicprofile (profile_id, display_name, bio, profile_picture, follow_count) FROM stdin;
\.


--
-- Data for Name: recap; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recap (recap_id, memory_id, generated_at) FROM stdin;
\.


--
-- Data for Name: recycle_bin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recycle_bin (id, original_id, item_type, user_id, title, content, metadata, deleted_at) FROM stdin;
\.


--
-- Data for Name: repost; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repost (repost_id, post_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: saved_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saved_posts (saved_id, feed_profile_id, post_id, created_at) FROM stdin;
1	1	1	2026-02-07 17:41:07.72696
\.


--
-- Data for Name: share; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.share (share_id, post_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (tag_id, post_id, tagged_user_id) FROM stdin;
\.


--
-- Data for Name: theme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.theme (theme_id, t_name) FROM stdin;
\.


--
-- Data for Name: trash; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trash (user_id) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sessions (session_id, user_id, created_at, expires_at, device_name, device_type, ip_address, user_agent, is_active) FROM stdin;
1297AAFA5B7B07A4D28222F3B1703A66	28	2026-01-17 09:19:34.772	2026-01-18 09:19:34.772	Unknown Device	Unknown	Unknown IP	Unknown Browser	t
39A277B9F72CBAF6C6D84BD16E381E98	28	2026-01-17 09:47:35.975	2026-01-18 09:47:35.975	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
1E722C9BC33ACCDFC2493B527CD0FA76	28	2026-01-17 10:16:07.55	2026-01-18 10:16:07.55	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
449F11F4DF3A2825A9E45DC6922DCC90	28	2026-01-17 10:35:17.454	2026-01-18 10:35:17.454	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
967EE32ABC74806504533CC0C9C92CE6	28	2026-01-17 11:11:13.984	2026-01-18 11:11:13.984	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
3738CC781F341A45F5FBB2920B0787A1	28	2026-01-17 11:23:43.77	2026-01-18 11:23:43.77	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
377004354C94DC18C38758EF49AB8D31	28	2026-01-17 11:29:45.474	2026-01-18 11:29:45.474	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
75FD377C815AA52505554B9B1F955F2E	28	2026-01-17 13:28:37.554	2026-01-18 13:28:37.555	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
D25ADAB440D0C1E90D6D66506602077F	28	2026-01-17 13:36:10.142	2026-01-18 13:36:10.142	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
2B09FA36ABE7CFFCB0E8052AA33C73C1	28	2026-01-17 14:05:47.291	2026-01-18 14:05:47.291	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
7F63A01486A5F3A4E238D39278B98458	28	2026-01-17 18:18:50.325	2026-01-18 18:18:50.325	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
A98D8258D44A890DEE4EE7BE79B7B14C	28	2026-01-17 18:19:45.406	2026-01-18 18:19:45.406	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6F884ED39388C6D0867DBF188E31907E	28	2026-01-19 08:08:13.243	2026-01-20 08:08:13.243	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
BCE8DCB076F05DC02BAB7C45C8B15FBE	28	2026-01-19 08:24:10.847	2026-01-20 08:24:10.847	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
EC056736352720504F8A8E06D1D6A5E2	28	2026-01-19 09:03:24.418	2026-01-20 09:03:24.418	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4B58AEB7D1D14D13DB6A727C6F2300F8	28	2026-01-19 09:14:10.821	2026-01-20 09:14:10.821	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
00E209B2A424BA5ECF6E53757EA99F3F	29	2026-01-19 09:15:26.809	2026-01-20 09:15:26.809	Unknown Device	Unknown	Unknown IP	Unknown Browser	t
3F9CDFA30D33A12616CB93E429949C2C	29	2026-01-19 09:15:34.626	2026-01-20 09:15:34.626	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
C70FAC65CB9EB50455013C511E3214BE	29	2026-01-19 09:15:45.181	2026-01-20 09:15:45.181	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
A295E37E378195434BEB86A5D014B136	29	2026-01-19 09:27:53.526	2026-01-20 09:27:53.526	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
6EACBE83D4B0CE30CFD73E4FB99AEE11	28	2026-01-19 09:28:06.526	2026-01-20 09:28:06.526	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
CA4E395DD046FE7F07F46EBF628473EF	29	2026-01-19 09:28:35.042	2026-01-20 09:28:35.042	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
ADF280996BFD12926BDCDA7466B291B4	28	2026-01-19 09:35:43.246	2026-01-20 09:35:43.246	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
F31DFA8C03DDACA830DA95CD3D89E07C	29	2026-01-19 09:35:55.839	2026-01-20 09:35:55.839	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
CE7C854F8516A69CF45A1B7EE20A5A3A	29	2026-01-19 09:47:34.745	2026-01-20 09:47:34.745	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
5E2B9FCE4004D17B381C5DAD34F81FA4	29	2026-01-19 10:38:36.262	2026-01-20 10:38:36.262	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
C5F69D520D26644E069555364CB3259E	30	2026-01-19 10:39:17.258	2026-01-20 10:39:17.258	Unknown Device	Unknown	Unknown IP	Unknown Browser	f
198C199E2E7FB960E73F5DCACC6A0DF1	30	2026-01-19 10:39:25.054	2026-01-20 10:39:25.054	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
EA1B2294D48736CA7E465C1BAD09D8A9	30	2026-01-19 12:18:35.188	2026-01-20 12:18:35.189	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9AE91102DDA71BF8DB4571BB6A5C6046	30	2026-01-19 12:37:20.622	2026-01-20 12:37:20.622	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
ECB8F64E50B8093C6EC7635565B3963C	30	2026-01-19 12:44:17.033	2026-01-20 12:44:17.033	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
01C899CA61272EB2DC82BF82FFF39FB7	32	2026-01-19 12:45:49.148	2026-01-20 12:45:49.148	Unknown Device	Unknown	Unknown IP	Unknown Browser	f
ECB603CE72EB9EB13C45619884FA1E07	30	2026-01-19 12:46:14.135	2026-01-20 12:46:14.135	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
39CD2ADA9907B35416A63BBD23010D23	30	2026-01-19 12:54:42.533	2026-01-20 12:54:42.534	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
7AC731DCE147A904348E2801905A53F1	30	2026-01-19 12:58:20.062	2026-01-20 12:58:20.062	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
662B34C5D033339B823D58F2128F52FE	30	2026-01-19 13:20:34.336	2026-01-20 13:20:34.336	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
B9DF49BE8822A5BF4F74CB2429F5EBA7	30	2026-01-19 13:23:20.389	2026-01-20 13:23:20.39	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
63BBFC1B56AC2E64FF672B12AFBADA83	28	2026-01-30 15:41:46.004	2026-01-31 15:41:46.004	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
82ABED115D0F65F38CA6CD6A2BB79745	29	2026-01-19 13:51:37.95	2026-01-20 13:51:37.95	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
70FB6D56FDDFC2A684F48C7D28151B65	29	2026-01-19 13:51:47.077	2026-01-20 13:51:47.077	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
8F40FD984CCF51B8A9D75137A56DF4D2	30	2026-01-19 13:57:31.221	2026-01-20 13:57:31.221	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
0C5ABDB16DE574219757B5CE0EDBE57C	30	2026-01-26 09:22:02.113	2026-01-27 09:22:02.113	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
F7AFE0FCAA0804EA4A204844580664EC	30	2026-01-26 09:29:13.597	2026-01-27 09:29:13.597	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
14DC88FB5B46130D1E434296B9BEEC0F	28	2026-01-26 09:29:23.423	2026-01-27 09:29:23.423	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
1BCE19A2E4CB7E32317CB4D4BC51B271	28	2026-01-26 09:34:01.278	2026-01-27 09:34:01.279	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9605910D1916FB1DDC7B34CF0223BF8F	28	2026-01-26 09:37:10.259	2026-01-27 09:37:10.26	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
AAED0CD00C733B0CC153E58A52A0A49F	29	2026-01-26 09:41:36.482	2026-01-27 09:41:36.482	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
542C313E86D84285B5E99D54A1A77F02	29	2026-01-26 09:41:46.983	2026-01-27 09:41:46.983	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9677A06D561AB424BDC76AFD4CCAE020	29	2026-01-26 09:52:39.067	2026-01-27 09:52:39.067	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
466B5BBEC7A431F48337A515A6D3B603	29	2026-01-26 09:53:15.831	2026-01-27 09:53:15.831	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6CB4D71D37F244BA59EE4440351B3DA6	28	2026-01-26 10:27:16.084	2026-01-27 10:27:16.085	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
C8C7B8A69FED758ED074D43CDB919175	28	2026-01-26 10:33:08.493	2026-01-27 10:33:08.494	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
5CEB8D998B0681AC7D9598B3CC345408	28	2026-01-30 15:23:34.807	2026-01-31 15:23:34.807	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
BBF7A40BA4D6FFE30B4D0BA51CBEE9B2	28	2026-01-30 15:26:57.018	2026-01-31 15:26:57.019	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
0A2E69F2C8F8DD43C576F90EFC7022F0	28	2026-01-30 15:44:56.821	2026-01-31 15:44:56.821	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
D16A06419C38DDA8861AF4C8E55A3A7D	28	2026-01-30 15:45:56.219	2026-01-31 15:45:56.219	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
90B9A2CFBA67F5EC28BCF4FA928E5359	29	2026-01-30 15:46:06.687	2026-01-31 15:46:06.687	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
78F5114061B3C6AF7B1AB771ACED3E8F	29	2026-01-30 16:32:12.762	2026-01-31 16:32:12.762	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
CB387BCE6ED9250DC2F34F0DA82F17BE	28	2026-01-31 18:47:46.655	2026-02-01 18:47:46.655	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9298F565FE5396688351D0D685F714B4	28	2026-01-31 19:01:35.625	2026-02-01 19:01:35.626	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4CE7D39BC2C9C4617BCDF606D9AE62A7	28	2026-01-31 19:07:56.565	2026-02-01 19:07:56.565	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4AF6E5573B17BFF4E25DCFD68855FA6F	28	2026-01-31 19:12:24.171	2026-02-01 19:12:24.171	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
24257CC8D1E73CCB60C5F18639929986	36	2026-01-31 19:17:47.739	2026-02-01 19:17:47.739	Unknown Device	Unknown	Unknown IP	Unknown Browser	t
DEF15F0AB4E2E45BDD0C909F50442277	28	2026-01-31 19:25:13.151	2026-02-01 19:25:13.151	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
A96AAA09B6B607B77FC2312F4265697D	28	2026-01-31 19:33:28.26	2026-02-01 19:33:28.26	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
647E2044691098CC492A405AE9A11BC7	28	2026-01-31 19:36:08.009	2026-02-01 19:36:08.009	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
6565CA926FFBE226E1669FA78AEF7C4F	28	2026-01-31 19:38:13.766	2026-02-01 19:38:13.766	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6AA501BBEF48FBF182DFF33F4421ECA2	28	2026-02-05 17:43:57.239	2026-02-06 17:43:57.239	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
F2FE013C09102ED3D351252A8B1581E6	28	2026-02-05 18:14:13.252	2026-02-06 18:14:13.252	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6D323D54105860955D5F902FD4EEA392	28	2026-02-05 18:27:49.116	2026-02-06 18:27:49.117	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
D61C3E50F75E830C73A6BF8647F062EA	28	2026-02-05 19:05:53.871	2026-02-06 19:05:53.871	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9CCEBCF398E09003E459B4CB07C6D5AD	28	2026-02-07 15:57:30.007	2026-02-08 15:57:30.008	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
07DB589C4958FECB5BB4F1927D508144	28	2026-02-07 16:01:04.757	2026-02-08 16:01:04.757	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
A7052FBF43C07B9A8DD35986AD90D2D6	28	2026-02-07 16:55:46.65	2026-02-08 16:55:46.65	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4ACF8C3DFE9DD8AEB463FC86EB65827A	28	2026-02-07 16:59:00.513	2026-02-08 16:59:00.513	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9266539B121CA6901AD915DC310027C1	28	2026-02-07 17:07:10.427	2026-02-08 17:07:10.427	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
49F4CC5E1E348288A4E94CEF8B858060	28	2026-02-07 17:29:29.934	2026-02-08 17:29:29.935	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
97FF4DC38C84CBD9EC0F4AD6739C531C	28	2026-02-07 17:40:15.36	2026-02-08 17:40:15.36	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
5DEFC2E245B0812B8636BCC96EA9431A	28	2026-02-07 17:40:56.611	2026-02-08 17:40:56.612	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
48912A313F29B3E1856158E01B8569AD	28	2026-02-08 16:28:07.232	2026-02-09 16:28:07.232	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
786B7A3F66D738A43B27BC11E7D760D4	28	2026-02-08 16:30:35.542	2026-02-09 16:30:35.542	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
BF758FBB260C62F0FD1DA8CB46B3A85F	28	2026-02-08 16:30:48.228	2026-02-09 16:30:48.228	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E099C4B468D56D86A8BAFF936828FF5B	28	2026-02-08 17:28:25.18	2026-02-09 17:28:25.18	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
826B8B435BEDE8EBEEA244D8BE0EB1AB	28	2026-02-08 17:46:33.393	2026-02-09 17:46:33.393	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6D9DC55DB79CE7752274037FB7126602	28	2026-02-08 17:55:55.85	2026-02-09 17:55:55.85	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
B095249B5AE00DC3947A6661DD1601FE	28	2026-02-08 18:24:23.161	2026-02-09 18:24:23.161	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
618D956AD75E8B9CD053F09D914B5CDD	28	2026-02-08 18:29:07.249	2026-02-09 18:29:07.249	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4C327F4AED9071DE7B343938E9C637BF	28	2026-02-08 18:29:58.779	2026-02-09 18:29:58.78	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
15897DA4E6F63BB6334B3E3C100E9FF3	28	2026-02-08 18:56:39.701	2026-02-09 18:56:39.701	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
C93B2BED0256F70D1580EA544C486D08	28	2026-02-08 19:03:05.324	2026-02-09 19:03:05.324	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4336D819E90D432973D3E39C1D330A62	28	2026-02-08 19:09:43.681	2026-02-09 19:09:43.681	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
53671B016C66AECD7CB04A968C4F6A4E	28	2026-02-08 19:19:01.32	2026-02-09 19:19:01.321	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
AD84F9ED1EBE147B4BEF0ABC9A81E870	28	2026-02-08 19:24:09.46	2026-02-09 19:24:09.46	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
C9063796E6C2C213C9D21BE37DF4F008	28	2026-02-09 08:26:17.951	2026-02-10 08:26:17.951	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
0BF350BD3A25DC1134F6236E4D97298F	28	2026-02-09 08:28:36.487	2026-02-10 08:28:36.487	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
7390E76577A56B96CA0996C38C661108	28	2026-02-09 08:55:42.36	2026-02-10 08:55:42.361	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
5197446DFBB9383C98D55176F95CF773	28	2026-02-09 08:57:02.347	2026-02-10 08:57:02.347	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
E650CC8E0BDB6D898D9A4FFB3525A151	28	2026-02-09 08:58:05.598	2026-02-10 08:58:05.598	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
D1DDC5642CA1486A07071F8E8F18F111	28	2026-02-09 09:06:08.264	2026-02-10 09:06:08.265	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
7F8BD59C973D2B2CEFBF0E3A2E156449	28	2026-02-09 09:06:40.977	2026-02-10 09:06:40.977	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
635D1AA622A3EB2C8E378E66AF14221B	28	2026-02-09 09:07:13.101	2026-02-10 09:07:13.102	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
001E11ECE289D0FCC3676462903DB217	28	2026-02-09 12:38:10.635	2026-02-10 12:38:10.636	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
3560B9E326CC0232501CABDE9D2D9621	28	2026-02-09 12:46:00.728	2026-02-10 12:46:00.729	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
904B2BA1DB859D23E3491102D456951A	28	2026-02-09 12:48:43.809	2026-02-10 12:48:43.81	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
65B37C762476A60EFBBD62F998AC81F5	28	2026-02-09 12:49:34.527	2026-02-10 12:49:34.527	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6B1D762BA807A3C47FB029060425AC3B	28	2026-02-09 19:36:58.366	2026-02-10 19:36:58.367	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
46302C889111B2F07763D1B42D054FD7	28	2026-02-10 08:24:54.97	2026-02-11 08:24:54.97	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
F096E4547B4F2E566A9ECDB1BBB221A5	29	2026-02-10 08:28:04.353	2026-02-11 08:28:04.353	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
536D1C9F76BD761E00563668D7A79381	28	2026-02-10 08:29:43.722	2026-02-11 08:29:43.722	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
CBCAEE6C9BEB844212719AE7DEE746E3	28	2026-02-12 08:32:17.144	2026-02-13 08:32:17.144	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9630A952FC5B0F2D8BB0C1A81990570B	28	2026-02-12 09:00:45.135	2026-02-13 09:00:45.136	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9EE63203B6F2FDB253F280BD739EFEC7	28	2026-02-12 09:04:11.55	2026-02-13 09:04:11.55	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
F7220CFF8CD25CCC6FBE57F561303185	29	2026-02-12 09:04:26.616	2026-02-13 09:04:26.616	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6C52358CB7470465378EFA358C3E9751	29	2026-02-12 09:12:51.879	2026-02-13 09:12:51.88	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4800454919BEABD0771046878317A248	29	2026-02-12 09:14:15.299	2026-02-13 09:14:15.299	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
9ADCF82665DA13C6AC15D36880002DC5	29	2026-02-12 09:23:44.191	2026-02-13 09:23:44.191	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
3B11AFDEE1346104B1C18D182297EE66	29	2026-02-12 09:25:42.368	2026-02-13 09:25:42.368	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
B704F2834FC9A89DAB9025667F53C1F0	29	2026-02-12 10:11:00.606	2026-02-13 10:11:00.606	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
D7E45163B91CECF4979C56E8E5731334	28	2026-02-12 15:25:09.452	2026-02-13 15:25:09.453	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
B3619C1A587275D27E85907F32D404C0	28	2026-02-12 16:58:46.514	2026-02-13 16:58:46.515	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
498174DBEB3A5F6FB9950A0880D4F18C	28	2026-02-13 13:47:57.004	2026-02-14 13:47:57.004	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
B4359B6C3A264399B2B445D3001F3C7C	28	2026-02-13 20:48:49.735	2026-02-14 20:48:49.735	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
1860985C3B0233C1ED6A668AEB1D1B4F	28	2026-02-14 06:43:48.738	2026-02-15 06:43:48.738	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	f
CD5C640C7DD49C2DFD77F7494DEB5BFC	28	2026-02-14 06:45:20.988	2026-02-15 06:45:20.988	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
EFF515D5997101A5C4C95A0FA7E62D36	29	2026-02-14 06:45:36.172	2026-02-15 06:45:36.172	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
AA49EBD0EC5B223B61D46478F7841EEB	28	2026-02-14 07:20:09.737	2026-02-15 07:20:09.737	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
BE2F1A9F0C6D447673A6F8486FAD120F	29	2026-02-14 07:20:53.353	2026-02-15 07:20:53.353	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
6DC9E274AAF3A2E90CFE497AA745DE9B	28	2026-02-14 08:16:33.251	2026-02-15 08:16:33.252	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
BE4271B51A99E4E8268E2947AC645CB4	29	2026-02-14 08:18:17.527	2026-02-15 08:18:17.527	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
C35C0097E3DE85D35CAA4F02BF62474C	28	2026-02-14 12:22:42.91	2026-02-15 12:22:42.911	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
7A54224E6273ADFF882DCE87CB2A3E4C	28	2026-02-14 16:16:44.605	2026-02-15 16:16:44.606	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D806283326F868322AE72D10EDD76997	28	2026-02-14 16:49:19.199	2026-02-15 16:49:19.199	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
102C1D366E0976AB93F5B8CDF129DC3F	28	2026-02-14 21:42:53.119	2026-02-15 21:42:53.119	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D0F99C1DC231CF351D2697D790E754AE	28	2026-02-14 21:53:04.961	2026-02-15 21:53:04.962	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
1BAACE1B465A6AB6991531FAD2237D52	28	2026-02-14 21:57:45.774	2026-02-15 21:57:45.774	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
54AB5723508FBBD1A7A75E0F3F7EFA1E	28	2026-02-16 15:54:28.788	2026-02-17 15:54:28.788	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
70E36950F8823667C8CBE29EBE47949C	28	2026-02-16 16:09:38.929	2026-02-17 16:09:38.929	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
6EC1FB69227E26F3F036469233796522	28	2026-02-16 18:35:53.202	2026-02-17 18:35:53.203	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
0DB16CB321F80F5793270BB13DD51E8B	28	2026-02-16 18:47:10.664	2026-02-17 18:47:10.664	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E9D6AE42BD44E6E5BD9400E10C5B8753	28	2026-02-16 18:47:58.255	2026-02-17 18:47:58.256	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
1D8B55BE1FEB4BF1CFA941B21088A872	28	2026-02-16 18:50:26.169	2026-02-17 18:50:26.171	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
9A3A4632FF96BCA0A8C1F937159BD207	28	2026-02-16 19:43:49.663	2026-02-17 19:43:49.664	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CDD6DDFD3FFE7F9550ACAFF4C1E25E86	28	2026-02-17 07:28:25.08	2026-02-18 07:28:25.08	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
B0C7131B081DE0B9C7EC26403D9BE3FD	28	2026-02-17 07:34:03.052	2026-02-18 07:34:03.052	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
AB243C13114B26094D05C506BACB7FCF	28	2026-02-17 08:51:26.917	2026-02-18 08:51:26.917	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
A2AAF0FE37E799CDC891C6D3CAED46BB	28	2026-02-17 09:00:05.175	2026-02-18 09:00:05.175	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
50F69911D350728F83C2E75EDB30F24A	28	2026-02-17 09:09:23.585	2026-02-18 09:09:23.586	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
90B93F4C848C4BB146B4CFA8F9C314C4	28	2026-02-17 09:32:53.925	2026-02-18 09:32:53.928	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
496BF42A2BAFFE6A37D6DFD608EFE494	28	2026-02-17 09:41:33.123	2026-02-18 09:41:33.123	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
59D0003B8EBA0F9FD3EB2AB4518BD79D	28	2026-02-17 09:48:44.055	2026-02-18 09:48:44.056	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
A8ABFCA2DD4A6235772C0AD4238408AD	28	2026-02-17 12:32:48.32	2026-02-18 12:32:48.321	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
C227B4FF287BF5BE27E1EF424DE2F4EA	28	2026-02-17 18:46:14.305	2026-02-18 18:46:14.305	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	f
B68BC624338997AFD016B156480E9293	30	2026-02-17 18:47:20.136	2026-02-18 18:47:20.136	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4B1759A690B7E745C894C7C7566E3847	28	2026-02-18 08:22:35.451	2026-02-19 08:22:35.451	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
7870DFD5A6142F9BCA93BFDDB582696E	30	2026-02-18 08:27:43.142	2026-02-19 08:27:43.142	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
602BC1FFF844F8F2AEC192474F07F814	28	2026-02-18 10:42:17.444	2026-02-19 10:42:17.444	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
8D4D1688B57D56924601D266DDE48DB6	30	2026-02-18 13:18:47.865	2026-02-19 13:18:47.865	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
DFAA61C8012AE7D67B7945BC8A2EEC5D	28	2026-02-18 13:18:55.001	2026-02-19 13:18:55.001	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
4F987997A0B054A83306ACF314273A37	28	2026-02-18 13:56:04.023	2026-02-19 13:56:04.023	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
A34F61EC5E4181736B2EEC8533CA5BC5	30	2026-02-18 14:17:21.343	2026-02-19 14:17:21.343	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	f
89FB6E6DA1006408D3AC3A5B191426CB	28	2026-02-18 14:18:15.351	2026-02-19 14:18:15.351	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15	t
E92BC4DA229723109E0B9B10E704C830	28	2026-02-25 11:26:38.722	2026-02-26 11:26:38.723	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
8B0AB9065C49C8E96E33E912D6B35259	28	2026-02-25 11:34:44.477	2026-02-26 11:34:44.478	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
16DB6B01D39DA7CE5008C9AE017C49E2	28	2026-02-25 11:40:37.691	2026-02-26 11:40:37.692	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E4C19D128CADA384CD14536D8CBD5CAF	28	2026-02-25 11:43:46.295	2026-02-26 11:43:46.295	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
0BEDDE0EF3AF91C4AEB41C775BC39C53	28	2026-02-25 11:48:07.969	2026-02-26 11:48:07.969	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
45525E6C3FD607662F9E06113D226309	28	2026-02-25 11:54:45.221	2026-02-26 11:54:45.221	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
3E1DA556A6D954ECC22FF4D9588AA793	28	2026-02-25 12:26:14.298	2026-02-26 12:26:14.298	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
7375D0811D740E61B4014B7A33C6A47E	28	2026-02-25 12:30:04.384	2026-02-26 12:30:04.384	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
5CA6A39109814409AFFBA9473C94F885	28	2026-02-25 12:40:48.722	2026-02-26 12:40:48.722	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
FCD6F30969C41E7501D52C9DBEF76A6E	28	2026-02-25 13:20:23.938	2026-02-26 13:20:23.938	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
B19AE3256F86FBD27DCB70F00C1C1212	28	2026-02-25 14:59:42.06	2026-02-26 14:59:42.06	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E41433BC6A8BCDFBFE7FB249D405EE58	28	2026-02-26 13:27:54.399	2026-02-27 13:27:54.4	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
F8BA847D1E4ED44509064227C989068F	28	2026-02-26 13:45:31.645	2026-02-27 13:45:31.646	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
57F7063499B912645FDB6FCDEC04CF0F	28	2026-02-26 13:58:19.653	2026-02-27 13:58:19.653	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
2D43B7C215772894B1074542E681A028	28	2026-02-26 14:14:13.125	2026-02-27 14:14:13.125	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
C3B8ECE886A133FC2A6CCF0023D39724	28	2026-02-26 14:45:08.891	2026-02-27 14:45:08.892	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
C5F868A5D82E8E4787BD05D68879F1CB	29	2026-02-26 14:45:46.51	2026-02-27 14:45:46.51	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
5372F89DCB81933F864DAB311267079D	28	2026-02-27 08:17:58.434	2026-02-28 08:17:58.434	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
AE6E46DC2AE1659B43A738B41138F9C4	28	2026-02-27 08:29:31.661	2026-02-28 08:29:31.661	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
BE991A5626704F250E63667DC382F283	28	2026-02-27 08:47:28.447	2026-02-28 08:47:28.448	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CC58F3DF671C8F115CE63EC35AA2E7CC	28	2026-02-27 08:51:03.551	2026-02-28 08:51:03.551	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
77F0BB44BD679D201C99F030033EF3D2	28	2026-02-27 08:53:53.451	2026-02-28 08:53:53.451	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
94BEE4963E4A6CE70024CA4B5B4D9A54	28	2026-02-27 08:55:12.938	2026-02-28 08:55:12.938	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
970E5C35B7B417929EF1E45295CFD656	28	2026-02-27 08:56:08.769	2026-02-28 08:56:08.769	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D7A2167E4832AAA1E0550F0EDD64FF19	28	2026-02-27 12:11:44.91	2026-02-28 12:11:44.91	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
76CCA9E81787B3C84BA8A33776A6D37C	28	2026-02-27 12:15:15.773	2026-02-28 12:15:15.773	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
72EAC96E906652FCE3CDC1C0C9BC3DAE	29	2026-02-27 12:16:05.306	2026-02-28 12:16:05.306	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
D419B87A00A942DF745D2B84882BF4CA	28	2026-02-27 12:21:23.464	2026-02-28 12:21:23.465	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
303E3B35D95E3127AD9B88E9F8DE7097	29	2026-02-27 12:21:50.304	2026-02-28 12:21:50.304	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
4B49CDDA72E965DD7A18A80797632175	28	2026-02-27 12:46:17.496	2026-02-28 12:46:17.497	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
14F68F04D4384DF3933FBD2747B64F03	29	2026-02-27 12:46:31.996	2026-02-28 12:46:31.996	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
51C1738E3DF695CAD67872CD3CABB335	28	2026-02-28 10:26:28.791	2026-03-01 10:26:28.792	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
570FB37FCB4537823F59FE43550AF055	29	2026-02-28 10:26:44.707	2026-03-01 10:26:44.707	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
B2AF7E063E351A86173DAC1B7019780E	28	2026-02-28 13:29:24.326	2026-03-01 13:29:24.327	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
194D4C09D766EC507DDAAF8B8BA30BCD	28	2026-02-28 13:30:23.871	2026-03-01 13:30:23.871	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
A5DD9C7FDC64F77EAAC9424D87F94ADE	28	2026-02-28 13:33:01.191	2026-03-01 13:33:01.191	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
7D0CFCB6082E8EC8A903D3D5455D0D19	28	2026-02-28 15:22:42.732	2026-03-01 15:22:42.732	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
EF23B8A598C657944CC907B565338D16	28	2026-02-28 15:28:00.281	2026-03-01 15:28:00.281	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
32A6259DA4B1119CDC35CD48DFA8BF9D	28	2026-02-28 15:30:31.528	2026-03-01 15:30:31.529	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
DB3045BA6F0FF141C9A06F8846695DB9	28	2026-02-28 15:33:09.277	2026-03-01 15:33:09.278	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
14E92232E3634D0452B3FE11F73A9E59	28	2026-02-28 15:35:37.299	2026-03-01 15:35:37.299	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
42835FAB58C80B9BAB7E4E07EAB6B7A0	28	2026-02-28 15:40:21.853	2026-03-01 15:40:21.853	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
568EC16EC28156EE3381BF1C080C24FC	28	2026-02-28 16:04:46.912	2026-03-01 16:04:46.913	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
139B30BD6CEF1F68CE348261F6E1EC0C	28	2026-02-28 16:14:04.447	2026-03-01 16:14:04.447	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
63D87605D7A0573690C1A547C2A376E4	29	2026-02-28 16:15:22.116	2026-03-01 16:15:22.116	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
8FE41DD9B9F5B570F31373A2D88150D1	28	2026-02-28 16:19:50.784	2026-03-01 16:19:50.784	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
9BF7FA59EABF8EA9C71BF171CD874E5B	29	2026-02-28 16:20:56.782	2026-03-01 16:20:56.782	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
64CFFCEEE710C36C083DEA7A7DB12831	28	2026-03-01 07:48:16.922	2026-03-02 07:48:16.923	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
3D25F1A4A6771C23BF23CBD03BBBC236	28	2026-03-01 08:07:30.548	2026-03-02 08:07:30.548	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D04B6986F1CB2B905B64EB2C6D473428	28	2026-03-01 08:37:01.688	2026-03-02 08:37:01.688	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
BA63B4F12568095FFEA7C4475DD5FAEF	28	2026-03-01 08:39:06.549	2026-03-02 08:39:06.55	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
639CFD3396914AA180A49049C4626DB0	28	2026-03-01 10:06:55.195	2026-03-02 10:06:55.195	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
35B9B079FCA70E3790DABC0266B84245	30	2026-03-01 10:15:36.501	2026-03-02 10:15:36.501	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
628642222AC61C35AEA86D21AB9621FD	28	2026-03-01 10:58:39.661	2026-03-02 10:58:39.662	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
25142B4A987A089E644B2860DA131D5A	28	2026-03-01 11:02:56.901	2026-03-02 11:02:56.901	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CCC96C05E86766475D41FEBB09F87C05	28	2026-02-28 13:02:25.809	2026-03-01 13:02:25.809	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	f
0923CFFCB5FC3925670D09748160D2E9	28	2026-03-01 11:52:26.816	2026-03-02 11:52:26.817	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
B365AB9B76F540DE5016A6E984964980	28	2026-03-01 11:53:43.395	2026-03-02 11:53:43.395	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
F3AD037E88039C9316B5F901E1DDBD8F	28	2026-03-01 12:16:11.074	2026-03-02 12:16:11.074	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
C5AEEBD0AF2B5CE461DAD08BBB1FCB28	28	2026-03-01 12:30:34.659	2026-03-02 12:30:34.659	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
A29DEE34187A55097195A86D731E5351	28	2026-03-01 14:13:20.973	2026-03-02 14:13:20.973	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
3CABCBF89C114481778D77BCC9AE51F7	28	2026-03-01 14:25:49.332	2026-03-02 14:25:49.332	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
0CFCEC82C7027852752A7A3B7F3A6F9D	28	2026-03-01 14:27:31.317	2026-03-02 14:27:31.318	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
26C6843E9367D7E5C746B9DF38016843	28	2026-03-01 17:12:19.813	2026-03-02 17:12:19.813	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
44F4951633C48D96423517867CEBB0F8	28	2026-03-01 17:17:44.707	2026-03-02 17:17:44.708	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
64D9482EA6AB259BD77DDBDE4D12B7A6	28	2026-03-01 17:28:49.656	2026-03-02 17:28:49.657	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E613DD8C0CE8BDA56633B57FC920FD91	28	2026-03-01 17:30:42.575	2026-03-02 17:30:42.575	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
07185724E68CD4F8F6DFDFFCC02CE761	28	2026-03-01 17:33:21.032	2026-03-02 17:33:21.032	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
057B52CC9CA575FA2ACC8CB3B47340E3	28	2026-03-02 08:15:53.784	2026-03-03 08:15:53.784	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
1F5CAB6F702B7B3C9CC0B53F059F8FFD	28	2026-03-02 08:39:40.987	2026-03-03 08:39:40.988	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
3130C0BD0D974755F09117F119ED8A8B	28	2026-03-02 09:12:41.079	2026-03-03 09:12:41.08	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
C8D197CEEA5A42BC7E0BE94AA9C04787	28	2026-03-02 10:19:47.271	2026-03-03 10:19:47.271	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	t
197718946D887C98B13E335E28C97D82	28	2026-03-02 10:36:12.734	2026-03-03 10:36:12.735	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
96F575CB16FCD4CF505EC27249B03FE5	28	2026-03-03 09:21:03.402	2026-03-04 09:21:03.402	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
5EF5440FB8CA76CE14DFF52814B48391	28	2026-03-03 10:23:24.947	2026-03-04 10:23:24.947	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
6F918A9FCB44BF791FD288C13ABCBA45	28	2026-03-03 10:25:38.261	2026-03-04 10:25:38.261	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	t
3741DD830BAEE693FCC77D729ABBF35E	28	2026-03-03 10:35:57.059	2026-03-04 10:35:57.059	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
F17B4E998AC015B7275D71200AE9EE3D	28	2026-03-03 10:38:25.275	2026-03-04 10:38:25.276	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
6883D9635FB8615A9CBC4D069FA08194	28	2026-03-03 11:55:23.753	2026-03-04 11:55:23.753	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
0097551483D55705D30EE3FAB504F508	28	2026-03-03 12:49:04.042	2026-03-04 12:49:04.043	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
8E617F9E4A71671579CDE7518E4F6AB2	28	2026-03-06 09:25:26.553	2026-03-07 09:25:26.553	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
B43B656339C46F5F559DD4E89E34A3DA	28	2026-03-06 09:33:29.808	2026-03-07 09:33:29.808	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	t
692D090DB2D37147DFA589468D07AF37	28	2026-03-07 07:40:11.606	2026-03-08 07:40:11.607	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
39F74C74C3FF78AA637F01B7D2F443B6	28	2026-03-07 10:48:49.581	2026-03-08 10:48:49.581	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
22B47BA818F99997E3216435DC317A27	28	2026-03-08 11:46:11.138	2026-03-09 11:46:11.138	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
85B30562DC3D3BF5E83B298B5EDF7870	28	2026-03-08 11:48:38.911	2026-03-09 11:48:38.912	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
F33094E8083188F4BC3F6C3C429B4AE9	29	2026-03-08 11:52:04.839	2026-03-09 11:52:04.839	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
2CC01B8CA214A4750CB3DA8382967BE2	28	2026-03-08 11:58:28.495	2026-03-09 11:58:28.495	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
BE46CD8117CC1B93EF7363EBC1014CA5	28	2026-03-08 12:05:24.815	2026-03-09 12:05:24.815	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CBFC37A10A7B163C6B5E4D38E1831E87	28	2026-03-09 05:09:14.062	2026-03-10 05:09:14.062	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
474A767B49C6A9B2019E58E188D1CAE4	28	2026-03-09 10:53:29.331	2026-03-10 10:53:29.332	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
E6909E2B1009CF3945EEECB15AB94FE0	28	2026-03-09 11:20:31.105	2026-03-10 11:20:31.106	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D33263BCF8A99B36329F337BD28C2C65	30	2026-03-10 18:34:23.686	2026-03-11 18:34:23.687	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
EE095FD23718A16EC948FD58F40D0230	30	2026-03-10 18:39:38.47	2026-03-11 18:39:38.47	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
CE8B208C1BF09B719068E7637DBEFB23	28	2026-03-11 14:55:49.692	2026-03-12 14:55:49.693	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CCAF719346B2819E5DE88F6DD0AD6B6C	30	2026-03-11 14:56:11.612	2026-03-12 14:56:11.612	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
6646FB6E8F9499CB4F6AB2BFE9BE3570	28	2026-03-12 06:54:44.43	2026-03-13 06:54:44.43	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
77B51E40F0C0BABEB31527289701F187	28	2026-03-12 07:05:47.692	2026-03-13 07:05:47.693	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
230E03CC074371741EB8DC721FE96478	28	2026-03-12 07:10:19.369	2026-03-13 07:10:19.369	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
CADF51AA51CADB1687A95D592161415C	29	2026-03-12 07:14:49.343	2026-03-13 07:14:49.343	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
D79A413F1553E186574D247C2B9B0433	28	2026-03-12 07:18:26.251	2026-03-13 07:18:26.251	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
D38EE849391E124880DD99E397132518	30	2026-03-12 07:19:11.193	2026-03-13 07:19:11.193	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
B81409252A1624B894F142EFE4B78A22	30	2026-03-12 07:48:41.252	2026-03-13 07:48:41.252	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
95B97F3223F0C76F1952A31C745D2192	28	2026-03-12 07:49:25.288	2026-03-13 07:49:25.288	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
681D666AAC860290E07F311AC51032D3	28	2026-03-12 08:00:42.383	2026-03-13 08:00:42.383	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	t
6432FC98145DC075A6FC4901D3D5B636	30	2026-03-12 08:00:53.503	2026-03-13 08:00:53.503	Mac	Desktop	0:0:0:0:0:0:0:1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url, master_key_encrypted, key_derivation_salt, plan_id, vault_setup_completed, vault_password_hash, vault_password_salt) FROM stdin;
29	Hesstesting	lhesanda@gmail.com	2BN5/1L02DukqqKURZM/EYByHt2SJm3S5/2MgVz6jYk=	upOlWF/9X3vOpKktOQvJoQ==	hehe	2026-01-19	t	\N	/resources/assets/everlylogo.png	\\xf50310ce62ef286624ab1ddb5cbe496c33b4f744549f5fe030b5721b036228d671fbc2c792d403fe9a59a31a07de639e	\\x2ed94921871f4779d31eba03b57f92ecc0cbc97d243da03ef3588fff54e1fcf0	1	f	\N	\N
30	admin	admin@admin.admin	81OTEsePxYRUxeNIoCitRUAWBwpesN/zEAj4Lfbo3XA=	29RRezB1flQ2pQGdJ2IgZA==	admin	2026-01-19	t	\N	/resources/assets/everlylogo.png	\\xd486f43fa949d2cf9fb2c976bffd2f5ca55b53ccf206727182f7ffba063038ac277f25d0b9920552860896a7527a6d1b	\\x76c61387f732ef8c62e8eb812fcb6c4c5d6cec5caf6851dd723e27afb1bbe29f	1	f	\N	\N
32	testReal	test2@test.com	P6Hr7SfoW6uyo/E68BViE8YFhx9iKqVtzVaa1yBbehU=	RwRlkVKSSE0xCGtrp5v6Yw==		2026-01-19	t	\N	/resources/assets/everlylogo.png	\\x84b937fd21ecefc5a3d287d3ff855dc02cfe400ff36893d7bf95dd3e8582f5d82ec8d54b0f66b05f0ad6f86b7b2a5271	\\x4155a6ec3185961c2dcf979039d4615abbd0bff964742504b0a2933bd294e46b	1	f	\N	\N
36	Bot Test	bot@example.com	oDBoo+XuY+NX6yvIQM3CtQmNxYC1KfhI1CxHyK8hw+o=	Tg7CECoe1rE7nka5EgZjMw==	Just testing the memory selection page.	2026-01-31	t	\N	/resources/assets/everlylogo.png	\\xe00136d3846b59b65153c7d0128515f4eac44243426328ef9176e645b9b4907d51e94320e1a69e8c1e1a0d0f253ec808	\\xa354ffd7de14be27397f6517630c179f524058b02a9e44847fc5708d133d8702	1	f	\N	\N
28	Hesanda	nhesanda@gmail.com	NNYbLfUbSwCXOHCEsb6HTyMljU9pO07NBPdhotx6rls=	jVRc0pJQSWd2e1cEd6HlOA==	Hesanda	2026-01-17	t	\N	/resources/assets/everlylogo.png	\\xcd552887d012889b9f724daea00fc4de139924560facd639c6fd21a001609252b88443eb3a869dce59b992567462237d	\\x76b9774f336d1cff41d2a3197546a35576f9e17960b2ab3c833558e2ab8c8aa7	1	t	xLG9556TFp/wG5bJYymbGLD9Wv+syCB0IpNr7UJZmQg=	ANehnEiX3n7kg2xNJUjohw==
33	test1	testuser@test.com	kCrcZiHv+t9uzeS5yJzq/PCUcKC0WBtRTvrC3Zq1v3M=	3//TtOnAhpqtECOuJ7lAWQ==		2026-01-19	f	\N	/resources/assets/everlylogo.png	\\xe5ad7d2481e24181ad28bd85c251d4da892a05e2ba9bddd4fd688659fd8133035f88e7a57cf1be80393ad9c243609d7c	\\x9d2c01dc0c5498a0c18e9e1fda626200a4966b4d36b23343bf6528ec6c7731dc	1	f	\N	\N
\.


--
-- Data for Name: vault; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vault (user_id) FROM stdin;
\.


--
-- Name: autograph_activity_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autograph_activity_activity_id_seq', 1, false);


--
-- Name: autograph_autograph_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autograph_autograph_id_seq', 11, true);


--
-- Name: autograph_entry_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autograph_entry_entry_id_seq', 4, true);


--
-- Name: block_block_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.block_block_id_seq', 1, false);


--
-- Name: blocked_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blocked_users_id_seq', 1, true);


--
-- Name: collab_collab_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collab_collab_id_seq', 1, false);


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_comment_id_seq', 1, false);


--
-- Name: encryption_audit_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encryption_audit_log_log_id_seq', 1, false);


--
-- Name: encryption_metadata_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encryption_metadata_metadata_id_seq', 13, true);


--
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_event_id_seq', 7, true);


--
-- Name: event_vote_vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_vote_vote_id_seq', 5, true);


--
-- Name: feed_comment_likes_like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_comment_likes_like_id_seq', 5, true);


--
-- Name: feed_follows_follow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_follows_follow_id_seq', 3, true);


--
-- Name: feed_post_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_post_comments_comment_id_seq', 11, true);


--
-- Name: feed_post_likes_like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_post_likes_like_id_seq', 6, true);


--
-- Name: feed_posts_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_posts_post_id_seq', 3, true);


--
-- Name: feed_profiles_feed_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_profiles_feed_profile_id_seq', 2, true);


--
-- Name: group_announcement_announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_announcement_announcement_id_seq', 4, true);


--
-- Name: group_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_group_id_seq', 9, true);


--
-- Name: group_invite_invite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_invite_invite_id_seq', 5, true);


--
-- Name: journal_journal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_journal_id_seq', 18, true);


--
-- Name: journal_streaks_streak_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.journal_streaks_streak_id_seq', 4, true);


--
-- Name: likes_like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.likes_like_id_seq', 1, false);


--
-- Name: media_items_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_items_media_id_seq', 24, true);


--
-- Name: media_shares_share_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_shares_share_id_seq', 1, false);


--
-- Name: member_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_member_id_seq', 1, false);


--
-- Name: memory_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_members_id_seq', 10, true);


--
-- Name: memory_memory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_memory_id_seq', 23, true);


--
-- Name: notification_preferences_pref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_preferences_pref_id_seq', 1, false);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 12, true);


--
-- Name: plans_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plans_plan_id_seq', 4, true);


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_post_id_seq', 1, false);


--
-- Name: post_reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_reports_report_id_seq', 1, true);


--
-- Name: publicprofile_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publicprofile_profile_id_seq', 1, false);


--
-- Name: recap_recap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recap_recap_id_seq', 1, false);


--
-- Name: recycle_bin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recycle_bin_id_seq', 2, true);


--
-- Name: repost_repost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repost_repost_id_seq', 1, false);


--
-- Name: saved_posts_saved_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.saved_posts_saved_id_seq', 3, true);


--
-- Name: share_share_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.share_share_id_seq', 1, false);


--
-- Name: tag_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_tag_id_seq', 1, false);


--
-- Name: theme_theme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.theme_theme_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 36, true);


--
-- Name: autograph_activity autograph_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT autograph_activity_pkey PRIMARY KEY (activity_id);


--
-- Name: autograph_entry autograph_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT autograph_entry_pkey PRIMARY KEY (entry_id);


--
-- Name: autograph autograph_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph
    ADD CONSTRAINT autograph_pkey PRIMARY KEY (autograph_id);


--
-- Name: autograph autograph_share_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph
    ADD CONSTRAINT autograph_share_token_key UNIQUE (share_token);


--
-- Name: block block_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (block_id);


--
-- Name: blocked_users blocked_users_blocker_profile_id_blocked_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocked_users
    ADD CONSTRAINT blocked_users_blocker_profile_id_blocked_profile_id_key UNIQUE (blocker_profile_id, blocked_profile_id);


--
-- Name: blocked_users blocked_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blocked_users
    ADD CONSTRAINT blocked_users_pkey PRIMARY KEY (id);


--
-- Name: collab collab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_pkey PRIMARY KEY (collab_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: encryption_audit_log encryption_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_audit_log
    ADD CONSTRAINT encryption_audit_log_pkey PRIMARY KEY (log_id);


--
-- Name: encryption_keys encryption_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT encryption_keys_pkey PRIMARY KEY (key_id);


--
-- Name: encryption_metadata encryption_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_metadata
    ADD CONSTRAINT encryption_metadata_pkey PRIMARY KEY (metadata_id);


--
-- Name: event_attendance event_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_pkey PRIMARY KEY (event_id);


--
-- Name: event_group event_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_pkey PRIMARY KEY (event_id, group_id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- Name: event_user event_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT event_user_pkey PRIMARY KEY (event_id, group_id);


--
-- Name: event_vote event_vote_event_id_group_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_event_id_group_id_user_id_key UNIQUE (event_id, group_id, user_id);


--
-- Name: event_vote event_vote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_pkey PRIMARY KEY (vote_id);


--
-- Name: feed_comment_likes feed_comment_likes_comment_id_feed_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_comment_id_feed_profile_id_key UNIQUE (comment_id, feed_profile_id);


--
-- Name: feed_comment_likes feed_comment_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_pkey PRIMARY KEY (like_id);


--
-- Name: feed_follows feed_follows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_pkey PRIMARY KEY (follow_id);


--
-- Name: feed_post_comments feed_post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_pkey PRIMARY KEY (comment_id);


--
-- Name: feed_post_likes feed_post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_pkey PRIMARY KEY (like_id);


--
-- Name: feed_post_likes feed_post_likes_post_id_feed_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_post_id_feed_profile_id_key UNIQUE (post_id, feed_profile_id);


--
-- Name: feed_posts feed_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_pkey PRIMARY KEY (post_id);


--
-- Name: feed_profiles feed_profiles_feed_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_feed_username_key UNIQUE (feed_username);


--
-- Name: feed_profiles feed_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_pkey PRIMARY KEY (feed_profile_id);


--
-- Name: follow follow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_pkey PRIMARY KEY (follower_id, following_id);


--
-- Name: group_announcement group_announcement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_pkey PRIMARY KEY (announcement_id);


--
-- Name: group_encryption_keys group_encryption_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_pkey PRIMARY KEY (group_id, key_id, user_id);


--
-- Name: group_invite group_invite_invite_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_invite_token_key UNIQUE (invite_token);


--
-- Name: group_invite group_invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_pkey PRIMARY KEY (invite_id);


--
-- Name: group_media_shares group_media_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_pkey PRIMARY KEY (group_id, media_id);


--
-- Name: group_member group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_pkey PRIMARY KEY (group_id, member_id);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (group_id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (journal_id);


--
-- Name: journal_streaks journal_streaks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_streaks
    ADD CONSTRAINT journal_streaks_pkey PRIMARY KEY (streak_id);


--
-- Name: journal_theme journal_theme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT journal_theme_pkey PRIMARY KEY (journal_id, theme_id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (like_id);


--
-- Name: media_items media_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_items
    ADD CONSTRAINT media_items_pkey PRIMARY KEY (media_id);


--
-- Name: media_shares media_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_shares
    ADD CONSTRAINT media_shares_pkey PRIMARY KEY (share_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_id);


--
-- Name: memory_media memory_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_pkey PRIMARY KEY (memory_id, media_id);


--
-- Name: memory_members memory_members_memory_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_memory_id_user_id_key UNIQUE (memory_id, user_id);


--
-- Name: memory_members memory_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_pkey PRIMARY KEY (id);


--
-- Name: memory memory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT memory_pkey PRIMARY KEY (memory_id);


--
-- Name: notification_preferences notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_pkey PRIMARY KEY (pref_id);


--
-- Name: notification_preferences notification_preferences_user_id_notif_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_user_id_notif_type_key UNIQUE (user_id, notif_type);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: plans plans_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_name_key UNIQUE (name);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (plan_id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: post_reports post_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_pkey PRIMARY KEY (report_id);


--
-- Name: post_reports post_reports_post_id_reporter_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_post_id_reporter_profile_id_key UNIQUE (post_id, reporter_profile_id);


--
-- Name: publicprofile publicprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicprofile
    ADD CONSTRAINT publicprofile_pkey PRIMARY KEY (profile_id);


--
-- Name: recap recap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap
    ADD CONSTRAINT recap_pkey PRIMARY KEY (recap_id);


--
-- Name: recycle_bin recycle_bin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recycle_bin
    ADD CONSTRAINT recycle_bin_pkey PRIMARY KEY (id);


--
-- Name: repost repost_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT repost_pkey PRIMARY KEY (repost_id);


--
-- Name: saved_posts saved_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_pkey PRIMARY KEY (saved_id);


--
-- Name: share share_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT share_pkey PRIMARY KEY (share_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: theme theme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.theme
    ADD CONSTRAINT theme_pkey PRIMARY KEY (theme_id);


--
-- Name: trash trash_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trash
    ADD CONSTRAINT trash_pkey PRIMARY KEY (user_id);


--
-- Name: feed_follows unique_follow; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT unique_follow UNIQUE (follower_id, following_id);


--
-- Name: saved_posts unique_saved_post; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT unique_saved_post UNIQUE (feed_profile_id, post_id);


--
-- Name: journal_streaks unique_user_streak; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_streaks
    ADD CONSTRAINT unique_user_streak UNIQUE (user_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vault vault_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault
    ADD CONSTRAINT vault_pkey PRIMARY KEY (user_id);


--
-- Name: idx_autograph_share_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_autograph_share_token ON public.autograph USING btree (share_token) WHERE (share_token IS NOT NULL);


--
-- Name: idx_comment_likes_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comment_likes_comment_id ON public.feed_comment_likes USING btree (comment_id);


--
-- Name: idx_comment_likes_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comment_likes_profile_id ON public.feed_comment_likes USING btree (feed_profile_id);


--
-- Name: idx_comments_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_created_at ON public.feed_post_comments USING btree (created_at DESC);


--
-- Name: idx_comments_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_parent_id ON public.feed_post_comments USING btree (parent_comment_id);


--
-- Name: idx_comments_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_post_id ON public.feed_post_comments USING btree (post_id);


--
-- Name: idx_comments_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_profile_id ON public.feed_post_comments USING btree (feed_profile_id);


--
-- Name: idx_encryption_audit_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encryption_audit_action ON public.encryption_audit_log USING btree (action, "timestamp");


--
-- Name: idx_encryption_audit_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encryption_audit_user ON public.encryption_audit_log USING btree (user_id, "timestamp");


--
-- Name: idx_encryption_keys_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encryption_keys_user ON public.encryption_keys USING btree (user_id, key_id);


--
-- Name: idx_encryption_metadata_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encryption_metadata_lookup ON public.encryption_metadata USING btree (entity_type, entity_id);


--
-- Name: idx_event_group_event; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_group_event ON public.event_group USING btree (event_id);


--
-- Name: idx_event_group_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_group_group ON public.event_group USING btree (group_id);


--
-- Name: idx_event_vote_event_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_vote_event_group ON public.event_vote USING btree (event_id, group_id);


--
-- Name: idx_event_vote_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_vote_user ON public.event_vote USING btree (user_id);


--
-- Name: idx_feed_follows_follower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_follows_follower ON public.feed_follows USING btree (follower_id);


--
-- Name: idx_feed_follows_following; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_follows_following ON public.feed_follows USING btree (following_id);


--
-- Name: idx_feed_posts_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_posts_created ON public.feed_posts USING btree (created_at DESC);


--
-- Name: idx_feed_posts_feed_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_posts_feed_profile ON public.feed_posts USING btree (feed_profile_id);


--
-- Name: idx_feed_posts_memory; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_posts_memory ON public.feed_posts USING btree (memory_id);


--
-- Name: idx_feed_profiles_feed_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_profiles_feed_username ON public.feed_profiles USING btree (feed_username);


--
-- Name: idx_feed_profiles_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feed_profiles_user_id ON public.feed_profiles USING btree (user_id);


--
-- Name: idx_group_encryption_keys_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_encryption_keys_lookup ON public.group_encryption_keys USING btree (group_id, user_id);


--
-- Name: idx_media_encrypted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_media_encrypted ON public.media_items USING btree (user_id, is_encrypted) WHERE (is_encrypted = true);


--
-- Name: idx_media_upload_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_media_upload_time ON public.media_items USING btree (upload_timestamp);


--
-- Name: idx_media_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_media_user_id ON public.media_items USING btree (user_id);


--
-- Name: idx_memory_collab_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_memory_collab_key ON public.memory USING btree (collab_share_key) WHERE (collab_share_key IS NOT NULL);


--
-- Name: idx_memory_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_memory_group_id ON public.memory USING btree (group_id) WHERE (group_id IS NOT NULL);


--
-- Name: idx_memory_members_memory; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_memory_members_memory ON public.memory_members USING btree (memory_id);


--
-- Name: idx_memory_members_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_memory_members_user ON public.memory_members USING btree (user_id);


--
-- Name: idx_notif_prefs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_prefs_user_id ON public.notification_preferences USING btree (user_id);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, is_read);


--
-- Name: idx_post_likes_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_likes_post_id ON public.feed_post_likes USING btree (post_id);


--
-- Name: idx_post_likes_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_likes_profile_id ON public.feed_post_likes USING btree (feed_profile_id);


--
-- Name: idx_post_reports_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_reports_created_at ON public.post_reports USING btree (created_at DESC);


--
-- Name: idx_post_reports_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_reports_post_id ON public.post_reports USING btree (post_id);


--
-- Name: idx_post_reports_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_reports_status ON public.post_reports USING btree (status);


--
-- Name: idx_saved_posts_post; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_saved_posts_post ON public.saved_posts USING btree (post_id);


--
-- Name: idx_saved_posts_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_saved_posts_profile ON public.saved_posts USING btree (feed_profile_id);


--
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_active ON public.users USING btree (user_id) WHERE (is_active = true);


--
-- Name: encryption_audit_log encryption_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_audit_log
    ADD CONSTRAINT encryption_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: encryption_keys encryption_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT encryption_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: event_group event_group_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_group event_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_group
    ADD CONSTRAINT event_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: event_vote event_vote_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_vote
    ADD CONSTRAINT event_vote_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: feed_comment_likes feed_comment_likes_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.feed_post_comments(comment_id) ON DELETE CASCADE;


--
-- Name: feed_comment_likes feed_comment_likes_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_comment_likes
    ADD CONSTRAINT feed_comment_likes_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_follows feed_follows_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_follows feed_follows_following_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_follows
    ADD CONSTRAINT feed_follows_following_id_fkey FOREIGN KEY (following_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.feed_post_comments(comment_id) ON DELETE CASCADE;


--
-- Name: feed_post_comments feed_post_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_comments
    ADD CONSTRAINT feed_post_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: feed_post_likes feed_post_likes_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_post_likes feed_post_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_post_likes
    ADD CONSTRAINT feed_post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: feed_posts feed_posts_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: feed_posts feed_posts_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_posts
    ADD CONSTRAINT feed_posts_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: feed_profiles feed_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_profiles
    ADD CONSTRAINT feed_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_announcement fk_announcement_event; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT fk_announcement_event FOREIGN KEY (event_id) REFERENCES public.event(event_id) ON DELETE SET NULL;


--
-- Name: autograph_activity fk_autograph; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT fk_autograph FOREIGN KEY (autograph_id) REFERENCES public.autograph(autograph_id) ON DELETE CASCADE;


--
-- Name: autograph_entry fk_autograph; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT fk_autograph FOREIGN KEY (autograph_id) REFERENCES public.autograph(autograph_id);


--
-- Name: block fk_blocked; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT fk_blocked FOREIGN KEY (blocked_user_id) REFERENCES public.users(user_id);


--
-- Name: encryption_keys fk_encryption_keys_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT fk_encryption_keys_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: event_attendance fk_event; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES public.event(event_id);


--
-- Name: event_user fk_event; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES public.event(event_id);


--
-- Name: event_user fk_event_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT fk_event_group FOREIGN KEY (group_id) REFERENCES public."group"(group_id);


--
-- Name: follow fk_follower; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fk_follower FOREIGN KEY (follower_id) REFERENCES public.users(user_id);


--
-- Name: follow fk_following; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fk_following FOREIGN KEY (following_id) REFERENCES public.users(user_id);


--
-- Name: event fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES public."group"(group_id);


--
-- Name: group_member fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES public."group"(group_id);


--
-- Name: group_encryption_keys fk_group_encryption_keys_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT fk_group_encryption_keys_group FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys fk_group_encryption_keys_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT fk_group_encryption_keys_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: journal_theme fk_journal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT fk_journal FOREIGN KEY (journal_id) REFERENCES public.journal(journal_id);


--
-- Name: group_member fk_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: recap fk_memory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap
    ADD CONSTRAINT fk_memory FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id);


--
-- Name: memory fk_memory_cover_media; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT fk_memory_cover_media FOREIGN KEY (cover_media_id) REFERENCES public.media_items(media_id);


--
-- Name: memory fk_memory_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT fk_memory_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: collab fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: comment fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: likes fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: repost fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: share fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: tag fk_post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: post fk_profile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES public.publicprofile(profile_id);


--
-- Name: journal_theme fk_theme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_theme
    ADD CONSTRAINT fk_theme FOREIGN KEY (theme_id) REFERENCES public.theme(theme_id);


--
-- Name: autograph fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: autograph_activity fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_activity
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: autograph_entry fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autograph_entry
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: block fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: collab fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collab
    ADD CONSTRAINT fk_user FOREIGN KEY (shared_with) REFERENCES public.users(user_id);


--
-- Name: comment fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: event_user fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_user
    ADD CONSTRAINT fk_user FOREIGN KEY (group_id) REFERENCES public.users(user_id);


--
-- Name: group fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: journal fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: journal_streaks fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal_streaks
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: likes fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: member fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: memory fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: repost fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repost
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: share fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.share
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: tag fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT fk_user FOREIGN KEY (tagged_user_id) REFERENCES public.users(user_id);


--
-- Name: trash fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trash
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: vault fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vault
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: group_announcement group_announcement_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_announcement group_announcement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_announcement
    ADD CONSTRAINT group_announcement_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_key_id_fkey FOREIGN KEY (key_id) REFERENCES public.encryption_keys(key_id) ON DELETE CASCADE;


--
-- Name: group_encryption_keys group_encryption_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_encryption_keys
    ADD CONSTRAINT group_encryption_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: group_invite group_invite_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- Name: group_invite group_invite_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_invite
    ADD CONSTRAINT group_invite_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: group_media_shares group_media_shares_shared_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_media_shares
    ADD CONSTRAINT group_media_shares_shared_by_user_id_fkey FOREIGN KEY (shared_by_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: media_items media_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_items
    ADD CONSTRAINT media_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: media_shares media_shares_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_shares
    ADD CONSTRAINT media_shares_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: memory memory_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory
    ADD CONSTRAINT memory_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON DELETE SET NULL;


--
-- Name: memory_media memory_media_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_items(media_id) ON DELETE CASCADE;


--
-- Name: memory_media memory_media_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_media
    ADD CONSTRAINT memory_media_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: memory_members memory_members_memory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_memory_id_fkey FOREIGN KEY (memory_id) REFERENCES public.memory(memory_id) ON DELETE CASCADE;


--
-- Name: memory_members memory_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_members
    ADD CONSTRAINT memory_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notification_preferences notification_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_reporter_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_reporter_profile_id_fkey FOREIGN KEY (reporter_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: post_reports post_reports_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reports
    ADD CONSTRAINT post_reports_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(user_id);


--
-- Name: saved_posts saved_posts_feed_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_feed_profile_id_fkey FOREIGN KEY (feed_profile_id) REFERENCES public.feed_profiles(feed_profile_id) ON DELETE CASCADE;


--
-- Name: saved_posts saved_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_posts
    ADD CONSTRAINT saved_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.feed_posts(post_id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: users users_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(plan_id);


--
-- PostgreSQL database dump complete
--

\unrestrict yfYuy91DZumcHd4R2cigYF35MrlpYF4Z6C3CF3nHVLLnmcili5VVMVN4AXDS5zb

