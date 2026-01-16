--
-- PostgreSQL database dump
--

\restrict uEVbC5v9BQMm7oKegI0VYq0h2iXl1AVftd0rhcaVxkUTZI4o0mE6BjcfaWHvIjJ

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking_seats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_seats (
    booking_id uuid NOT NULL,
    schedule_id uuid NOT NULL,
    seat_id integer NOT NULL
);


ALTER TABLE public.booking_seats OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    schedule_id uuid NOT NULL,
    status character varying(20) NOT NULL,
    total_price numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    expired_at timestamp without time zone CONSTRAINT bookings_expires_at_not_null NOT NULL,
    CONSTRAINT bookings_status_check CHECK (((status)::text = ANY ((ARRAY['RESERVED'::character varying, 'PAID'::character varying, 'CANCELLED'::character varying])::text[])))
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: cinemas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cinemas (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cinemas OWNER TO postgres;

--
-- Name: cinemas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cinemas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cinemas_id_seq OWNER TO postgres;

--
-- Name: cinemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cinemas_id_seq OWNED BY public.cinemas.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genres_id_seq OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: movie_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_genres (
    movie_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.movie_genres OWNER TO postgres;

--
-- Name: movie_people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_people (
    movie_id integer NOT NULL,
    person_id integer NOT NULL,
    role character varying(20) NOT NULL,
    CONSTRAINT movie_people_role_check CHECK (((role)::text = ANY ((ARRAY['director'::character varying, 'actor'::character varying])::text[])))
);


ALTER TABLE public.movie_people OWNER TO postgres;

--
-- Name: movie_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_reviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    movie_id integer NOT NULL,
    user_id uuid NOT NULL,
    rating integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT movie_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.movie_reviews OWNER TO postgres;

--
-- Name: movie_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    studio_id integer NOT NULL,
    show_date date NOT NULL,
    show_time time without time zone NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    movie_id integer NOT NULL,
    CONSTRAINT movie_schedules_price_check CHECK ((price > (0)::numeric))
);


ALTER TABLE public.movie_schedules OWNER TO postgres;

--
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    duration_minutes integer NOT NULL,
    synopsis text,
    language character varying(30),
    age_rating character varying(10),
    poster_url text,
    trailer_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    release_date date NOT NULL,
    end_date date,
    CONSTRAINT chk_movie_run CHECK (((end_date IS NULL) OR (end_date >= release_date))),
    CONSTRAINT movies_duration_minutes_check CHECK ((duration_minutes > 0))
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movies_id_seq OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    logo character varying(255)
);


ALTER TABLE public.payment_methods OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_methods_id_seq OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    payment_method_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(20) NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FAILED'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.people OWNER TO postgres;

--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.people_id_seq OWNER TO postgres;

--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: seats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seats (
    id integer NOT NULL,
    studio_id integer NOT NULL,
    seat_code character varying(5) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT seats_seat_code_check CHECK (((seat_code)::text ~ '^[A-Z][0-9]{1,2}$'::text))
);


ALTER TABLE public.seats OWNER TO postgres;

--
-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seats_id_seq OWNER TO postgres;

--
-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    token uuid NOT NULL,
    user_id uuid NOT NULL,
    expired_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: studios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studios (
    id integer NOT NULL,
    cinema_id integer NOT NULL,
    name character varying(50) NOT NULL,
    total_seats integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT studios_total_seats_check CHECK ((total_seats > 0))
);


ALTER TABLE public.studios OWNER TO postgres;

--
-- Name: studios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.studios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.studios_id_seq OWNER TO postgres;

--
-- Name: studios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.studios_id_seq OWNED BY public.studios.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: verification_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_codes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    code_hash text NOT NULL,
    purpose character varying(30) NOT NULL,
    expired_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.verification_codes OWNER TO postgres;

--
-- Name: cinemas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinemas ALTER COLUMN id SET DEFAULT nextval('public.cinemas_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: seats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


--
-- Name: studios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studios ALTER COLUMN id SET DEFAULT nextval('public.studios_id_seq'::regclass);


--
-- Data for Name: booking_seats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_seats (booking_id, schedule_id, seat_id) FROM stdin;
f3157533-e59a-41a8-bc85-54141662be1d	f4c4b0f4-7290-471c-bf1c-56e3032e4192	151
932e24c6-3963-494f-8c77-161967b78fe9	f4c4b0f4-7290-471c-bf1c-56e3032e4192	169
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, user_id, schedule_id, status, total_price, created_at, updated_at, expired_at) FROM stdin;
f3157533-e59a-41a8-bc85-54141662be1d	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	f4c4b0f4-7290-471c-bf1c-56e3032e4192	PAID	65000.00	2026-01-16 12:43:14.381539+07	2026-01-16 12:43:14.381539+07	2026-01-16 12:53:14.381539
932e24c6-3963-494f-8c77-161967b78fe9	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	f4c4b0f4-7290-471c-bf1c-56e3032e4192	PAID	65000.00	2026-01-16 13:23:01.722754+07	2026-01-16 13:23:01.722754+07	2026-01-16 13:33:01.722754
\.


--
-- Data for Name: cinemas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cinemas (id, name, location, created_at, updated_at, deleted_at) FROM stdin;
1	XXI Tunjungan Plaza	Tunjungan Plaza, Jl. Basuki Rahmat, Surabaya	2026-01-12 17:36:16.223912+07	2026-01-12 17:36:16.223912+07	\N
2	XXI Galaxy Mall	Galaxy Mall, Jl. Dharmahusada Indah, Surabaya	2026-01-12 17:36:16.223912+07	2026-01-12 17:36:16.223912+07	\N
3	XXI Pakuwon Mall	Pakuwon Mall, Jl. Mayjen Yono Suwoyo, Surabaya	2026-01-12 17:36:16.223912+07	2026-01-12 17:36:16.223912+07	\N
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (id, name) FROM stdin;
1	Action
2	Adventure
3	Sci-Fi
4	Fantasy
\.


--
-- Data for Name: movie_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_genres (movie_id, genre_id) FROM stdin;
1	1
1	2
1	3
2	1
2	2
2	3
3	1
3	2
3	4
\.


--
-- Data for Name: movie_people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_people (movie_id, person_id, role) FROM stdin;
1	1	director
1	2	director
2	1	director
2	2	director
3	1	director
1	3	actor
1	4	actor
1	5	actor
2	3	actor
2	4	actor
2	5	actor
3	6	actor
3	7	actor
\.


--
-- Data for Name: movie_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_reviews (id, movie_id, user_id, rating, created_at) FROM stdin;
70431a89-1422-4ffd-8838-c11d0336c8bf	1	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	4	2026-01-13 20:57:17.507545+07
50b9c2fa-e951-47df-b7bc-a8ef8a96c0a5	1	4062b17f-e1aa-4122-9f38-0a1f55f6eba3	4	2026-01-13 20:57:17.507545+07
f6f5cc8f-5705-4912-a49b-df593232b53a	1	01b07ac0-442d-4de0-ac6e-e02e696ddb20	4	2026-01-13 20:57:17.507545+07
c3bb6cd4-adbe-4d05-a385-7135259cab10	1	878db5e0-815e-47ee-a749-14c5fa7f41d6	5	2026-01-13 20:57:17.507545+07
4659efcc-35eb-4cfe-a160-9c88dc858b00	1	eead3565-7b4c-485e-8f36-cdd7c0ca4f7a	4	2026-01-13 20:57:17.507545+07
fb10d2cf-59e0-4e11-b2de-341f2da27752	1	7bc964bb-1460-4678-9f9d-bd42a35f3cff	5	2026-01-13 20:57:17.507545+07
38918e20-0bb3-4a00-8e46-8332e37e5ceb	2	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	5	2026-01-13 20:57:50.80966+07
b71d0521-db98-46e5-8c54-da8827ffdfce	2	4062b17f-e1aa-4122-9f38-0a1f55f6eba3	5	2026-01-13 20:57:50.80966+07
8e9953c5-d63d-4196-8cf2-1b5781a24fc5	2	01b07ac0-442d-4de0-ac6e-e02e696ddb20	4	2026-01-13 20:57:50.80966+07
bfa67b70-eed7-4deb-9a5e-ecb430e0f8bf	2	878db5e0-815e-47ee-a749-14c5fa7f41d6	5	2026-01-13 20:57:50.80966+07
867b0854-52ee-4948-b14a-e3440adcd566	2	eead3565-7b4c-485e-8f36-cdd7c0ca4f7a	5	2026-01-13 20:57:50.80966+07
825a35f5-0e3a-4469-b3d1-262f0877f1fb	2	7bc964bb-1460-4678-9f9d-bd42a35f3cff	4	2026-01-13 20:57:50.80966+07
49f7152b-b47c-4ed6-8a5a-713a16ec9852	3	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	5	2026-01-13 20:57:55.480122+07
60973f66-d43f-4944-b6bf-b290ea2f884c	3	4062b17f-e1aa-4122-9f38-0a1f55f6eba3	4	2026-01-13 20:57:55.480122+07
6af121e6-4bf5-4c2a-bb78-46ffdf6e0ed2	3	01b07ac0-442d-4de0-ac6e-e02e696ddb20	4	2026-01-13 20:57:55.480122+07
bd512270-ca12-43e8-8187-1e719bad33c6	3	878db5e0-815e-47ee-a749-14c5fa7f41d6	4	2026-01-13 20:57:55.480122+07
6e46ce25-7508-4807-949b-f3840190d5c5	3	eead3565-7b4c-485e-8f36-cdd7c0ca4f7a	5	2026-01-13 20:57:55.480122+07
93b05bf9-f0f0-4701-b972-9fc64593c5eb	3	7bc964bb-1460-4678-9f9d-bd42a35f3cff	5	2026-01-13 20:57:55.480122+07
\.


--
-- Data for Name: movie_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_schedules (id, studio_id, show_date, show_time, price, created_at, updated_at, deleted_at, movie_id) FROM stdin;
1a8ab459-8f7d-4353-a577-1713c735208b	1	2026-01-17	18:30:00	60000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	1
4965f857-df76-4bef-af17-a422b7b3c99c	3	2026-01-17	14:00:00	50000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	3
6a8bd5df-65c5-468b-8ef3-79189cead178	1	2026-01-17	12:00:00	50000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	1
bcb9666f-1203-4069-a98f-cc91cafaa616	3	2026-01-17	20:00:00	60000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	3
f4c4b0f4-7290-471c-bf1c-56e3032e4192	2	2026-01-17	19:30:00	65000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	2
fb59bec8-6ffa-4624-a230-253af35105f1	2	2026-01-17	13:00:00	55000.00	2026-01-13 20:35:16.37924+07	2026-01-13 20:35:16.37924+07	\N	2
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (id, title, duration_minutes, synopsis, language, age_rating, poster_url, trailer_url, created_at, updated_at, deleted_at, release_date, end_date) FROM stdin;
1	Avengers: Infinity War	149	As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged: Thanos.	English	13+	https://image.tmdb.org/t/p/infinity_war.jpg	https://www.youtube.com/watch?v=6ZfuNTqbHE8	2026-01-13 20:30:33.022877+07	2026-01-13 20:30:33.022877+07	\N	2026-01-14	\N
2	Avengers: Endgame	181	After the devastating events of Avengers: Infinity War, the universe is in ruins. The Avengers assemble once more.	English	13+	https://image.tmdb.org/t/p/endgame.jpg	https://www.youtube.com/watch?v=TcMBFSGVi1c	2026-01-13 20:30:33.022877+07	2026-01-13 20:30:33.022877+07	\N	2026-01-14	\N
3	Spider-Man: No Way Home	148	Peter Parker seeks help from Doctor Strange when his identity is revealed, opening the multiverse.	English	13+	https://image.tmdb.org/t/p/no_way_home.jpg	https://www.youtube.com/watch?v=JfVOs4VSpmA	2026-01-13 20:30:33.022877+07	2026-01-13 20:30:33.022877+07	\N	2026-01-14	\N
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_methods (id, name, created_at, updated_at, deleted_at, logo) FROM stdin;
17	Virtual Account BCA	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/bca.png
18	Virtual Account BRI	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/bri.png
19	Virtual Account Mandiri	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/mandiri.png
20	QRIS	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/qris.png
21	E-Wallet OVO	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/ovo.png
22	E-Wallet GoPay	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/gopay.png
23	E-Wallet ShopeePay	2026-01-15 20:18:54.517941+07	2026-01-15 20:18:54.517941+07	\N	/assets/payments/shopeepay.png
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, booking_id, payment_method_id, amount, status, paid_at, created_at) FROM stdin;
d5667064-99eb-4454-afe1-51743ef52d47	f3157533-e59a-41a8-bc85-54141662be1d	20	65000.00	SUCCESS	2026-01-16 12:49:24.410635+07	2026-01-16 12:49:24.410635+07
227cc92f-5ef3-4ab7-84a9-c829c6152766	932e24c6-3963-494f-8c77-161967b78fe9	22	65000.00	SUCCESS	2026-01-16 13:25:22.813806+07	2026-01-16 13:25:22.813806+07
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.people (id, name, avatar_url, created_at) FROM stdin;
1	Anthony Russo	https://image.tmdb.org/t/p/russo_anthony.jpg	2026-01-13 20:31:12.518172+07
2	Joe Russo	https://image.tmdb.org/t/p/russo_joe.jpg	2026-01-13 20:31:12.518172+07
3	Robert Downey Jr.	https://image.tmdb.org/t/p/rdj.jpg	2026-01-13 20:31:12.518172+07
4	Chris Evans	https://image.tmdb.org/t/p/evans.jpg	2026-01-13 20:31:12.518172+07
5	Chris Hemsworth	https://image.tmdb.org/t/p/hemsworth.jpg	2026-01-13 20:31:12.518172+07
6	Tom Holland	https://image.tmdb.org/t/p/holland.jpg	2026-01-13 20:31:12.518172+07
7	Zendaya	https://image.tmdb.org/t/p/zendaya.jpg	2026-01-13 20:31:12.518172+07
\.


--
-- Data for Name: seats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seats (id, studio_id, seat_code, created_at, updated_at, deleted_at) FROM stdin;
1	1	A1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
2	1	B1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
3	1	C1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
4	1	D1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
5	1	E1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
6	1	F1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
7	1	G1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
8	1	H1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
9	1	I1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
10	1	J1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
11	1	K1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
12	1	L1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
13	1	M1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
14	1	N1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
15	1	O1	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
16	1	A2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
17	1	B2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
18	1	C2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
19	1	D2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
20	1	E2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
21	1	F2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
22	1	G2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
23	1	H2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
24	1	I2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
25	1	J2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
26	1	K2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
27	1	L2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
28	1	M2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
29	1	N2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
30	1	O2	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
31	1	A3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
32	1	B3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
33	1	C3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
34	1	D3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
35	1	E3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
36	1	F3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
37	1	G3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
38	1	H3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
39	1	I3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
40	1	J3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
41	1	K3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
42	1	L3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
43	1	M3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
44	1	N3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
45	1	O3	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
46	1	A4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
47	1	B4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
48	1	C4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
49	1	D4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
50	1	E4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
51	1	F4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
52	1	G4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
53	1	H4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
54	1	I4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
55	1	J4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
56	1	K4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
57	1	L4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
58	1	M4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
59	1	N4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
60	1	O4	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
61	1	A5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
62	1	B5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
63	1	C5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
64	1	D5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
65	1	E5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
66	1	F5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
67	1	G5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
68	1	H5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
69	1	I5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
70	1	J5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
71	1	K5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
72	1	L5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
73	1	M5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
74	1	N5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
75	1	O5	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
76	1	A6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
77	1	B6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
78	1	C6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
79	1	D6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
80	1	E6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
81	1	F6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
82	1	G6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
83	1	H6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
84	1	I6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
85	1	J6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
86	1	K6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
87	1	L6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
88	1	M6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
89	1	N6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
90	1	O6	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
91	1	A7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
92	1	B7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
93	1	C7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
94	1	D7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
95	1	E7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
96	1	F7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
97	1	G7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
98	1	H7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
99	1	I7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
100	1	J7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
101	1	K7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
102	1	L7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
103	1	M7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
104	1	N7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
105	1	O7	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
106	1	A8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
107	1	B8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
108	1	C8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
109	1	D8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
110	1	E8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
111	1	F8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
112	1	G8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
113	1	H8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
114	1	I8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
115	1	J8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
116	1	K8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
117	1	L8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
118	1	M8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
119	1	N8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
120	1	O8	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
121	1	A9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
122	1	B9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
123	1	C9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
124	1	D9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
125	1	E9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
126	1	F9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
127	1	G9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
128	1	H9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
129	1	I9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
130	1	J9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
131	1	K9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
132	1	L9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
133	1	M9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
134	1	N9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
135	1	O9	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
136	1	A10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
137	1	B10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
138	1	C10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
139	1	D10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
140	1	E10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
141	1	F10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
142	1	G10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
143	1	H10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
144	1	I10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
145	1	J10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
146	1	K10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
147	1	L10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
148	1	M10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
149	1	N10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
150	1	O10	2026-01-13 17:24:14.117002+07	2026-01-13 17:24:14.117002+07	\N
151	2	A1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
152	2	B1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
153	2	C1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
154	2	D1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
155	2	E1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
156	2	F1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
157	2	G1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
158	2	H1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
159	2	I1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
160	2	J1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
161	2	K1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
162	2	L1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
163	2	M1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
164	2	N1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
165	2	O1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
166	2	P1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
167	2	Q1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
168	2	R1	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
169	2	A2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
170	2	B2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
171	2	C2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
172	2	D2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
173	2	E2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
174	2	F2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
175	2	G2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
176	2	H2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
177	2	I2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
178	2	J2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
179	2	K2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
180	2	L2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
181	2	M2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
182	2	N2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
183	2	O2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
184	2	P2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
185	2	Q2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
186	2	R2	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
187	2	A3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
188	2	B3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
189	2	C3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
190	2	D3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
191	2	E3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
192	2	F3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
193	2	G3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
194	2	H3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
195	2	I3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
196	2	J3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
197	2	K3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
198	2	L3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
199	2	M3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
200	2	N3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
201	2	O3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
202	2	P3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
203	2	Q3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
204	2	R3	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
205	2	A4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
206	2	B4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
207	2	C4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
208	2	D4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
209	2	E4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
210	2	F4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
211	2	G4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
212	2	H4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
213	2	I4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
214	2	J4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
215	2	K4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
216	2	L4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
217	2	M4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
218	2	N4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
219	2	O4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
220	2	P4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
221	2	Q4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
222	2	R4	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
223	2	A5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
224	2	B5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
225	2	C5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
226	2	D5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
227	2	E5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
228	2	F5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
229	2	G5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
230	2	H5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
231	2	I5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
232	2	J5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
233	2	K5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
234	2	L5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
235	2	M5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
236	2	N5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
237	2	O5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
238	2	P5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
239	2	Q5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
240	2	R5	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
241	2	A6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
242	2	B6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
243	2	C6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
244	2	D6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
245	2	E6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
246	2	F6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
247	2	G6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
248	2	H6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
249	2	I6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
250	2	J6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
251	2	K6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
252	2	L6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
253	2	M6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
254	2	N6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
255	2	O6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
256	2	P6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
257	2	Q6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
258	2	R6	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
259	2	A7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
260	2	B7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
261	2	C7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
262	2	D7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
263	2	E7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
264	2	F7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
265	2	G7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
266	2	H7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
267	2	I7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
268	2	J7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
269	2	K7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
270	2	L7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
271	2	M7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
272	2	N7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
273	2	O7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
274	2	P7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
275	2	Q7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
276	2	R7	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
277	2	A8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
278	2	B8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
279	2	C8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
280	2	D8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
281	2	E8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
282	2	F8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
283	2	G8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
284	2	H8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
285	2	I8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
286	2	J8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
287	2	K8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
288	2	L8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
289	2	M8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
290	2	N8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
291	2	O8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
292	2	P8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
293	2	Q8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
294	2	R8	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
295	2	A9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
296	2	B9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
297	2	C9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
298	2	D9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
299	2	E9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
300	2	F9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
301	2	G9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
302	2	H9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
303	2	I9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
304	2	J9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
305	2	K9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
306	2	L9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
307	2	M9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
308	2	N9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
309	2	O9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
310	2	P9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
311	2	Q9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
312	2	R9	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
313	2	A10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
314	2	B10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
315	2	C10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
316	2	D10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
317	2	E10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
318	2	F10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
319	2	G10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
320	2	H10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
321	2	I10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
322	2	J10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
323	2	K10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
324	2	L10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
325	2	M10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
326	2	N10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
327	2	O10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
328	2	P10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
329	2	Q10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
330	2	R10	2026-01-13 17:24:22.867823+07	2026-01-13 17:24:22.867823+07	\N
331	3	A1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
332	3	B1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
333	3	C1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
334	3	D1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
335	3	E1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
336	3	F1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
337	3	G1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
338	3	H1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
339	3	I1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
340	3	J1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
341	3	K1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
342	3	L1	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
343	3	A2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
344	3	B2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
345	3	C2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
346	3	D2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
347	3	E2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
348	3	F2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
349	3	G2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
350	3	H2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
351	3	I2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
352	3	J2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
353	3	K2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
354	3	L2	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
355	3	A3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
356	3	B3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
357	3	C3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
358	3	D3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
359	3	E3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
360	3	F3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
361	3	G3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
362	3	H3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
363	3	I3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
364	3	J3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
365	3	K3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
366	3	L3	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
367	3	A4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
368	3	B4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
369	3	C4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
370	3	D4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
371	3	E4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
372	3	F4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
373	3	G4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
374	3	H4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
375	3	I4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
376	3	J4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
377	3	K4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
378	3	L4	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
379	3	A5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
380	3	B5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
381	3	C5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
382	3	D5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
383	3	E5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
384	3	F5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
385	3	G5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
386	3	H5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
387	3	I5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
388	3	J5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
389	3	K5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
390	3	L5	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
391	3	A6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
392	3	B6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
393	3	C6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
394	3	D6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
395	3	E6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
396	3	F6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
397	3	G6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
398	3	H6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
399	3	I6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
400	3	J6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
401	3	K6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
402	3	L6	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
403	3	A7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
404	3	B7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
405	3	C7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
406	3	D7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
407	3	E7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
408	3	F7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
409	3	G7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
410	3	H7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
411	3	I7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
412	3	J7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
413	3	K7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
414	3	L7	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
415	3	A8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
416	3	B8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
417	3	C8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
418	3	D8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
419	3	E8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
420	3	F8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
421	3	G8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
422	3	H8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
423	3	I8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
424	3	J8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
425	3	K8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
426	3	L8	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
427	3	A9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
428	3	B9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
429	3	C9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
430	3	D9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
431	3	E9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
432	3	F9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
433	3	G9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
434	3	H9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
435	3	I9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
436	3	J9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
437	3	K9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
438	3	L9	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
439	3	A10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
440	3	B10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
441	3	C10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
442	3	D10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
443	3	E10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
444	3	F10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
445	3	G10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
446	3	H10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
447	3	I10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
448	3	J10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
449	3	K10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
450	3	L10	2026-01-13 17:24:31.678353+07	2026-01-13 17:24:31.678353+07	\N
451	4	A1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
452	4	B1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
453	4	C1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
454	4	D1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
455	4	E1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
456	4	F1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
457	4	G1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
458	4	H1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
459	4	I1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
460	4	J1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
461	4	K1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
462	4	L1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
463	4	M1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
464	4	N1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
465	4	O1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
466	4	P1	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
467	4	A2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
468	4	B2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
469	4	C2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
470	4	D2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
471	4	E2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
472	4	F2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
473	4	G2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
474	4	H2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
475	4	I2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
476	4	J2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
477	4	K2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
478	4	L2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
479	4	M2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
480	4	N2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
481	4	O2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
482	4	P2	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
483	4	A3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
484	4	B3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
485	4	C3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
486	4	D3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
487	4	E3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
488	4	F3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
489	4	G3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
490	4	H3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
491	4	I3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
492	4	J3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
493	4	K3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
494	4	L3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
495	4	M3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
496	4	N3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
497	4	O3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
498	4	P3	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
499	4	A4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
500	4	B4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
501	4	C4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
502	4	D4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
503	4	E4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
504	4	F4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
505	4	G4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
506	4	H4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
507	4	I4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
508	4	J4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
509	4	K4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
510	4	L4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
511	4	M4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
512	4	N4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
513	4	O4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
514	4	P4	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
515	4	A5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
516	4	B5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
517	4	C5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
518	4	D5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
519	4	E5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
520	4	F5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
521	4	G5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
522	4	H5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
523	4	I5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
524	4	J5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
525	4	K5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
526	4	L5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
527	4	M5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
528	4	N5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
529	4	O5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
530	4	P5	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
531	4	A6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
532	4	B6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
533	4	C6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
534	4	D6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
535	4	E6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
536	4	F6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
537	4	G6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
538	4	H6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
539	4	I6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
540	4	J6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
541	4	K6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
542	4	L6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
543	4	M6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
544	4	N6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
545	4	O6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
546	4	P6	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
547	4	A7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
548	4	B7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
549	4	C7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
550	4	D7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
551	4	E7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
552	4	F7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
553	4	G7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
554	4	H7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
555	4	I7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
556	4	J7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
557	4	K7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
558	4	L7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
559	4	M7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
560	4	N7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
561	4	O7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
562	4	P7	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
563	4	A8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
564	4	B8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
565	4	C8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
566	4	D8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
567	4	E8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
568	4	F8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
569	4	G8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
570	4	H8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
571	4	I8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
572	4	J8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
573	4	K8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
574	4	L8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
575	4	M8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
576	4	N8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
577	4	O8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
578	4	P8	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
579	4	A9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
580	4	B9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
581	4	C9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
582	4	D9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
583	4	E9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
584	4	F9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
585	4	G9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
586	4	H9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
587	4	I9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
588	4	J9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
589	4	K9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
590	4	L9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
591	4	M9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
592	4	N9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
593	4	O9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
594	4	P9	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
595	4	A10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
596	4	B10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
597	4	C10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
598	4	D10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
599	4	E10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
600	4	F10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
601	4	G10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
602	4	H10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
603	4	I10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
604	4	J10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
605	4	K10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
606	4	L10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
607	4	M10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
608	4	N10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
609	4	O10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
610	4	P10	2026-01-13 17:24:40.549959+07	2026-01-13 17:24:40.549959+07	\N
611	5	A1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
612	5	B1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
613	5	C1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
614	5	D1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
615	5	E1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
616	5	F1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
617	5	G1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
618	5	H1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
619	5	I1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
620	5	J1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
621	5	K1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
622	5	L1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
623	5	M1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
624	5	N1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
625	5	O1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
626	5	P1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
627	5	Q1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
628	5	R1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
629	5	S1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
630	5	T1	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
631	5	A2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
632	5	B2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
633	5	C2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
634	5	D2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
635	5	E2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
636	5	F2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
637	5	G2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
638	5	H2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
639	5	I2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
640	5	J2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
641	5	K2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
642	5	L2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
643	5	M2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
644	5	N2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
645	5	O2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
646	5	P2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
647	5	Q2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
648	5	R2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
649	5	S2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
650	5	T2	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
651	5	A3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
652	5	B3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
653	5	C3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
654	5	D3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
655	5	E3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
656	5	F3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
657	5	G3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
658	5	H3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
659	5	I3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
660	5	J3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
661	5	K3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
662	5	L3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
663	5	M3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
664	5	N3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
665	5	O3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
666	5	P3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
667	5	Q3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
668	5	R3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
669	5	S3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
670	5	T3	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
671	5	A4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
672	5	B4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
673	5	C4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
674	5	D4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
675	5	E4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
676	5	F4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
677	5	G4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
678	5	H4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
679	5	I4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
680	5	J4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
681	5	K4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
682	5	L4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
683	5	M4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
684	5	N4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
685	5	O4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
686	5	P4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
687	5	Q4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
688	5	R4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
689	5	S4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
690	5	T4	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
691	5	A5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
692	5	B5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
693	5	C5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
694	5	D5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
695	5	E5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
696	5	F5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
697	5	G5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
698	5	H5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
699	5	I5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
700	5	J5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
701	5	K5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
702	5	L5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
703	5	M5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
704	5	N5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
705	5	O5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
706	5	P5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
707	5	Q5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
708	5	R5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
709	5	S5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
710	5	T5	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
711	5	A6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
712	5	B6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
713	5	C6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
714	5	D6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
715	5	E6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
716	5	F6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
717	5	G6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
718	5	H6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
719	5	I6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
720	5	J6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
721	5	K6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
722	5	L6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
723	5	M6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
724	5	N6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
725	5	O6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
726	5	P6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
727	5	Q6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
728	5	R6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
729	5	S6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
730	5	T6	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
731	5	A7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
732	5	B7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
733	5	C7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
734	5	D7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
735	5	E7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
736	5	F7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
737	5	G7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
738	5	H7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
739	5	I7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
740	5	J7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
741	5	K7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
742	5	L7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
743	5	M7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
744	5	N7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
745	5	O7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
746	5	P7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
747	5	Q7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
748	5	R7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
749	5	S7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
750	5	T7	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
751	5	A8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
752	5	B8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
753	5	C8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
754	5	D8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
755	5	E8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
756	5	F8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
757	5	G8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
758	5	H8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
759	5	I8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
760	5	J8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
761	5	K8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
762	5	L8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
763	5	M8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
764	5	N8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
765	5	O8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
766	5	P8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
767	5	Q8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
768	5	R8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
769	5	S8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
770	5	T8	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
771	5	A9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
772	5	B9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
773	5	C9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
774	5	D9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
775	5	E9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
776	5	F9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
777	5	G9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
778	5	H9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
779	5	I9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
780	5	J9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
781	5	K9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
782	5	L9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
783	5	M9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
784	5	N9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
785	5	O9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
786	5	P9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
787	5	Q9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
788	5	R9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
789	5	S9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
790	5	T9	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
791	5	A10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
792	5	B10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
793	5	C10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
794	5	D10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
795	5	E10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
796	5	F10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
797	5	G10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
798	5	H10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
799	5	I10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
800	5	J10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
801	5	K10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
802	5	L10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
803	5	M10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
804	5	N10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
805	5	O10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
806	5	P10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
807	5	Q10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
808	5	R10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
809	5	S10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
810	5	T10	2026-01-13 17:24:49.956242+07	2026-01-13 17:24:49.956242+07	\N
811	6	A1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
812	6	B1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
813	6	C1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
814	6	D1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
815	6	E1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
816	6	F1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
817	6	G1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
818	6	H1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
819	6	I1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
820	6	J1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
821	6	K1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
822	6	L1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
823	6	M1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
824	6	N1	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
825	6	A2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
826	6	B2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
827	6	C2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
828	6	D2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
829	6	E2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
830	6	F2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
831	6	G2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
832	6	H2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
833	6	I2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
834	6	J2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
835	6	K2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
836	6	L2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
837	6	M2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
838	6	N2	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
839	6	A3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
840	6	B3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
841	6	C3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
842	6	D3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
843	6	E3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
844	6	F3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
845	6	G3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
846	6	H3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
847	6	I3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
848	6	J3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
849	6	K3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
850	6	L3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
851	6	M3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
852	6	N3	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
853	6	A4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
854	6	B4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
855	6	C4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
856	6	D4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
857	6	E4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
858	6	F4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
859	6	G4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
860	6	H4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
861	6	I4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
862	6	J4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
863	6	K4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
864	6	L4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
865	6	M4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
866	6	N4	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
867	6	A5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
868	6	B5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
869	6	C5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
870	6	D5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
871	6	E5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
872	6	F5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
873	6	G5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
874	6	H5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
875	6	I5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
876	6	J5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
877	6	K5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
878	6	L5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
879	6	M5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
880	6	N5	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
881	6	A6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
882	6	B6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
883	6	C6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
884	6	D6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
885	6	E6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
886	6	F6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
887	6	G6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
888	6	H6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
889	6	I6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
890	6	J6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
891	6	K6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
892	6	L6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
893	6	M6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
894	6	N6	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
895	6	A7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
896	6	B7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
897	6	C7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
898	6	D7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
899	6	E7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
900	6	F7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
901	6	G7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
902	6	H7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
903	6	I7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
904	6	J7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
905	6	K7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
906	6	L7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
907	6	M7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
908	6	N7	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
909	6	A8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
910	6	B8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
911	6	C8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
912	6	D8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
913	6	E8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
914	6	F8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
915	6	G8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
916	6	H8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
917	6	I8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
918	6	J8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
919	6	K8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
920	6	L8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
921	6	M8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
922	6	N8	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
923	6	A9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
924	6	B9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
925	6	C9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
926	6	D9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
927	6	E9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
928	6	F9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
929	6	G9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
930	6	H9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
931	6	I9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
932	6	J9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
933	6	K9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
934	6	L9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
935	6	M9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
936	6	N9	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
937	6	A10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
938	6	B10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
939	6	C10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
940	6	D10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
941	6	E10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
942	6	F10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
943	6	G10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
944	6	H10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
945	6	I10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
946	6	J10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
947	6	K10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
948	6	L10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
949	6	M10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
950	6	N10	2026-01-13 17:24:58.270861+07	2026-01-13 17:24:58.270861+07	\N
951	7	A1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
952	7	B1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
953	7	C1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
954	7	D1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
955	7	E1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
956	7	F1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
957	7	G1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
958	7	H1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
959	7	I1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
960	7	J1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
961	7	K1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
962	7	L1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
963	7	M1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
964	7	N1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
965	7	O1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
966	7	P1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
967	7	Q1	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
968	7	A2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
969	7	B2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
970	7	C2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
971	7	D2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
972	7	E2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
973	7	F2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
974	7	G2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
975	7	H2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
976	7	I2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
977	7	J2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
978	7	K2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
979	7	L2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
980	7	M2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
981	7	N2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
982	7	O2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
983	7	P2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
984	7	Q2	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
985	7	A3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
986	7	B3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
987	7	C3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
988	7	D3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
989	7	E3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
990	7	F3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
991	7	G3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
992	7	H3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
993	7	I3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
994	7	J3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
995	7	K3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
996	7	L3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
997	7	M3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
998	7	N3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
999	7	O3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1000	7	P3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1001	7	Q3	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1002	7	A4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1003	7	B4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1004	7	C4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1005	7	D4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1006	7	E4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1007	7	F4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1008	7	G4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1009	7	H4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1010	7	I4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1011	7	J4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1012	7	K4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1013	7	L4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1014	7	M4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1015	7	N4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1016	7	O4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1017	7	P4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1018	7	Q4	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1019	7	A5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1020	7	B5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1021	7	C5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1022	7	D5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1023	7	E5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1024	7	F5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1025	7	G5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1026	7	H5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1027	7	I5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1028	7	J5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1029	7	K5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1030	7	L5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1031	7	M5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1032	7	N5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1033	7	O5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1034	7	P5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1035	7	Q5	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1036	7	A6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1037	7	B6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1038	7	C6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1039	7	D6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1040	7	E6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1041	7	F6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1042	7	G6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1043	7	H6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1044	7	I6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1045	7	J6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1046	7	K6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1047	7	L6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1048	7	M6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1049	7	N6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1050	7	O6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1051	7	P6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1052	7	Q6	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1053	7	A7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1054	7	B7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1055	7	C7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1056	7	D7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1057	7	E7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1058	7	F7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1059	7	G7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1060	7	H7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1061	7	I7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1062	7	J7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1063	7	K7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1064	7	L7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1065	7	M7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1066	7	N7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1067	7	O7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1068	7	P7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1069	7	Q7	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1070	7	A8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1071	7	B8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1072	7	C8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1073	7	D8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1074	7	E8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1075	7	F8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1076	7	G8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1077	7	H8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1078	7	I8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1079	7	J8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1080	7	K8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1081	7	L8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1082	7	M8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1083	7	N8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1084	7	O8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1085	7	P8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1086	7	Q8	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1087	7	A9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1088	7	B9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1089	7	C9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1090	7	D9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1091	7	E9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1092	7	F9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1093	7	G9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1094	7	H9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1095	7	I9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1096	7	J9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1097	7	K9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1098	7	L9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1099	7	M9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1100	7	N9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1101	7	O9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1102	7	P9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1103	7	Q9	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1104	7	A10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1105	7	B10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1106	7	C10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1107	7	D10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1108	7	E10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1109	7	F10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1110	7	G10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1111	7	H10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1112	7	I10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1113	7	J10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1114	7	K10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1115	7	L10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1116	7	M10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1117	7	N10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1118	7	O10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1119	7	P10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1120	7	Q10	2026-01-13 17:25:06.460248+07	2026-01-13 17:25:06.460248+07	\N
1121	8	A1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1122	8	B1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1123	8	C1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1124	8	D1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1125	8	E1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1126	8	F1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1127	8	G1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1128	8	H1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1129	8	I1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1130	8	J1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1131	8	K1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1132	8	L1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1133	8	M1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1134	8	N1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1135	8	O1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1136	8	P1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1137	8	Q1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1138	8	R1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1139	8	S1	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1140	8	A2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1141	8	B2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1142	8	C2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1143	8	D2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1144	8	E2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1145	8	F2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1146	8	G2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1147	8	H2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1148	8	I2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1149	8	J2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1150	8	K2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1151	8	L2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1152	8	M2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1153	8	N2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1154	8	O2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1155	8	P2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1156	8	Q2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1157	8	R2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1158	8	S2	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1159	8	A3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1160	8	B3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1161	8	C3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1162	8	D3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1163	8	E3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1164	8	F3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1165	8	G3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1166	8	H3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1167	8	I3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1168	8	J3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1169	8	K3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1170	8	L3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1171	8	M3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1172	8	N3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1173	8	O3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1174	8	P3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1175	8	Q3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1176	8	R3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1177	8	S3	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1178	8	A4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1179	8	B4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1180	8	C4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1181	8	D4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1182	8	E4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1183	8	F4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1184	8	G4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1185	8	H4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1186	8	I4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1187	8	J4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1188	8	K4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1189	8	L4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1190	8	M4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1191	8	N4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1192	8	O4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1193	8	P4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1194	8	Q4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1195	8	R4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1196	8	S4	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1197	8	A5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1198	8	B5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1199	8	C5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1200	8	D5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1201	8	E5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1202	8	F5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1203	8	G5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1204	8	H5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1205	8	I5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1206	8	J5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1207	8	K5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1208	8	L5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1209	8	M5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1210	8	N5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1211	8	O5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1212	8	P5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1213	8	Q5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1214	8	R5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1215	8	S5	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1216	8	A6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1217	8	B6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1218	8	C6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1219	8	D6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1220	8	E6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1221	8	F6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1222	8	G6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1223	8	H6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1224	8	I6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1225	8	J6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1226	8	K6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1227	8	L6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1228	8	M6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1229	8	N6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1230	8	O6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1231	8	P6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1232	8	Q6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1233	8	R6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1234	8	S6	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1235	8	A7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1236	8	B7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1237	8	C7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1238	8	D7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1239	8	E7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1240	8	F7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1241	8	G7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1242	8	H7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1243	8	I7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1244	8	J7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1245	8	K7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1246	8	L7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1247	8	M7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1248	8	N7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1249	8	O7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1250	8	P7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1251	8	Q7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1252	8	R7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1253	8	S7	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1254	8	A8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1255	8	B8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1256	8	C8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1257	8	D8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1258	8	E8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1259	8	F8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1260	8	G8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1261	8	H8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1262	8	I8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1263	8	J8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1264	8	K8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1265	8	L8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1266	8	M8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1267	8	N8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1268	8	O8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1269	8	P8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1270	8	Q8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1271	8	R8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1272	8	S8	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1273	8	A9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1274	8	B9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1275	8	C9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1276	8	D9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1277	8	E9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1278	8	F9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1279	8	G9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1280	8	H9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1281	8	I9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1282	8	J9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1283	8	K9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1284	8	L9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1285	8	M9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1286	8	N9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1287	8	O9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1288	8	P9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1289	8	Q9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1290	8	R9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1291	8	S9	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1292	8	A10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1293	8	B10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1294	8	C10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1295	8	D10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1296	8	E10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1297	8	F10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1298	8	G10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1299	8	H10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1300	8	I10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1301	8	J10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1302	8	K10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1303	8	L10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1304	8	M10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1305	8	N10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1306	8	O10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1307	8	P10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1308	8	Q10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1309	8	R10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1310	8	S10	2026-01-13 17:25:16.499191+07	2026-01-13 17:25:16.499191+07	\N
1311	9	A1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1312	9	B1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1313	9	C1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1314	9	D1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1315	9	E1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1316	9	F1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1317	9	G1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1318	9	H1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1319	9	I1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1320	9	J1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1321	9	K1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1322	9	L1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1323	9	M1	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1324	9	A2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1325	9	B2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1326	9	C2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1327	9	D2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1328	9	E2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1329	9	F2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1330	9	G2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1331	9	H2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1332	9	I2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1333	9	J2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1334	9	K2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1335	9	L2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1336	9	M2	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1337	9	A3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1338	9	B3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1339	9	C3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1340	9	D3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1341	9	E3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1342	9	F3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1343	9	G3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1344	9	H3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1345	9	I3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1346	9	J3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1347	9	K3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1348	9	L3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1349	9	M3	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1350	9	A4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1351	9	B4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1352	9	C4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1353	9	D4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1354	9	E4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1355	9	F4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1356	9	G4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1357	9	H4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1358	9	I4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1359	9	J4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1360	9	K4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1361	9	L4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1362	9	M4	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1363	9	A5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1364	9	B5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1365	9	C5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1366	9	D5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1367	9	E5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1368	9	F5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1369	9	G5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1370	9	H5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1371	9	I5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1372	9	J5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1373	9	K5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1374	9	L5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1375	9	M5	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1376	9	A6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1377	9	B6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1378	9	C6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1379	9	D6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1380	9	E6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1381	9	F6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1382	9	G6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1383	9	H6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1384	9	I6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1385	9	J6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1386	9	K6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1387	9	L6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1388	9	M6	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1389	9	A7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1390	9	B7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1391	9	C7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1392	9	D7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1393	9	E7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1394	9	F7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1395	9	G7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1396	9	H7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1397	9	I7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1398	9	J7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1399	9	K7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1400	9	L7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1401	9	M7	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1402	9	A8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1403	9	B8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1404	9	C8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1405	9	D8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1406	9	E8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1407	9	F8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1408	9	G8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1409	9	H8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1410	9	I8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1411	9	J8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1412	9	K8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1413	9	L8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1414	9	M8	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1415	9	A9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1416	9	B9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1417	9	C9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1418	9	D9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1419	9	E9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1420	9	F9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1421	9	G9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1422	9	H9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1423	9	I9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1424	9	J9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1425	9	K9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1426	9	L9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1427	9	M9	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1428	9	A10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1429	9	B10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1430	9	C10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1431	9	D10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1432	9	E10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1433	9	F10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1434	9	G10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1435	9	H10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1436	9	I10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1437	9	J10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1438	9	K10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1439	9	L10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
1440	9	M10	2026-01-13 17:25:24.769449+07	2026-01-13 17:25:24.769449+07	\N
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (token, user_id, expired_at, revoked_at, created_at) FROM stdin;
1ab92a73-c6d7-40ed-bad1-18fb4aeb423e	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	2026-01-16 08:03:58.964241+07	\N	2026-01-15 08:03:58.964862+07
3109983d-f36b-48b7-9585-5284f63ba701	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	2026-01-17 11:07:33.415212+07	\N	2026-01-16 11:07:33.415812+07
3ae1c3a4-0b73-4367-aa28-3f6cd643a489	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	2026-01-17 11:12:31.540876+07	\N	2026-01-16 11:12:31.541569+07
b0336213-0f0c-4273-a8d5-71f300069818	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	2026-01-17 13:11:48.372332+07	\N	2026-01-16 13:11:48.372695+07
73d8f83f-71d4-4756-bb4a-48ba021362a3	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	2026-01-17 13:16:26.770452+07	\N	2026-01-16 13:16:26.770589+07
\.


--
-- Data for Name: studios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studios (id, cinema_id, name, total_seats, created_at, updated_at, deleted_at) FROM stdin;
1	1	Studio 1	150	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
2	1	Studio 2	180	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
3	1	Studio 3	120	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
4	2	Studio 1	160	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
5	2	Studio 2	200	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
6	2	Studio 3	140	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
7	3	Studio 1	170	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
8	3	Studio 2	190	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
9	3	Studio 3	130	2026-01-13 17:20:43.365009+07	2026-01-13 17:20:43.365009+07	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, name, password_hash, created_at, updated_at, deleted_at, is_active) FROM stdin;
01b07ac0-442d-4de0-ac6e-e02e696ddb20	user2@mail.com	user2	hash	2026-01-13 20:55:19.899514+07	2026-01-13 20:55:19.899514+07	\N	t
3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	bayu19fr@gmail.com	Bayu Firmansyah	$2a$10$CWhlhlyfjFMChUaUi8wV7uEkeE4mw8az0p0Jc8eC.owcSoLhix9dS	2026-01-12 00:08:24.744418+07	2026-01-12 00:08:24.744418+07	\N	t
4062b17f-e1aa-4122-9f38-0a1f55f6eba3	user1@mail.com	user1	hash	2026-01-13 20:55:19.899514+07	2026-01-13 20:55:19.899514+07	\N	t
7bc964bb-1460-4678-9f9d-bd42a35f3cff	user5@mail.com	user5	hash	2026-01-13 20:55:19.899514+07	2026-01-13 20:55:19.899514+07	\N	t
878db5e0-815e-47ee-a749-14c5fa7f41d6	user3@mail.com	user3	hash	2026-01-13 20:55:19.899514+07	2026-01-13 20:55:19.899514+07	\N	t
eead3565-7b4c-485e-8f36-cdd7c0ca4f7a	user4@mail.com	user4	hash	2026-01-13 20:55:19.899514+07	2026-01-13 20:55:19.899514+07	\N	t
92282f1a-80a5-4b04-a8b9-4b67493447e7	silfi@gmail.com	Silfi Dian Putri	$2a$10$LUHRJrcmYabw9sXJ8asxE.phN71lCqw1qkRJ.54oakb31Yli0z2MW	2026-01-15 17:48:18.071613+07	2026-01-15 17:48:18.071613+07	\N	t
\.


--
-- Data for Name: verification_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_codes (id, user_id, code_hash, purpose, expired_at, used_at, created_at) FROM stdin;
5143da54-76e5-4a2c-9113-103683222a2c	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	$2a$10$UMx9mIUgB3KmTqjqCXzzMeRTUBkiZ455bVle7N0w4j1XZZbZKItsK	login	2026-01-12 00:21:16.162169+07	\N	2026-01-12 00:16:16.16299+07
f24e40ed-36e8-45b2-8ba5-3879055bad62	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	$2a$10$TGmP7Egosx/waiycMels0uhGgB..YyhrzToLBrhN4CrqY.3QTnyqi	login	2026-01-12 00:28:18.894235+07	\N	2026-01-12 00:23:18.895098+07
10217e1f-d41b-49c2-a097-af05ad6b0881	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	$2a$10$cW8cjOyjm2.Rj4IqniaJYevKEsgjHRhNSpp4lPlQKRUt34BDcUsxe	login	2026-01-12 00:31:47.824023+07	\N	2026-01-12 00:26:47.82466+07
bd59b9d1-52b4-4a5f-90f0-de9372c2293a	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	$2a$10$ErcCuEUJ2F2bAs26IRyWZ.2B6hD4bIHXi1PbDWE/qu2Ki17owDsGm	login	2026-01-12 00:33:39.843645+07	\N	2026-01-12 00:28:39.844951+07
cb700c78-c89b-4c81-810d-457ba90b2eec	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	$2a$10$KLtGGhs553RmgkfW8LIkF.Or6zmSocsVe28tN7oRVJ/.mw5X7E2ky	login	2026-01-12 00:37:00.624101+07	\N	2026-01-12 00:32:00.626186+07
737abe72-9da5-4df3-a420-c6e740f6ce43	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	372551	login	2026-01-15 08:00:40.622695+07	\N	2026-01-15 07:55:40.625347+07
d07eda66-07b2-4306-a014-08ae5ce3f345	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	622145	login	2026-01-15 08:05:38.192258+07	\N	2026-01-15 08:00:38.19281+07
930b40ae-4ebf-45c2-ae11-1918fa397ac9	92282f1a-80a5-4b04-a8b9-4b67493447e7	187929	register	2026-01-15 17:53:18.074854+07	\N	2026-01-15 17:48:18.071613+07
8f16ffab-d546-4e88-8299-e475c2f7db50	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	989652	login	2026-01-16 11:11:13.030164+07	\N	2026-01-16 11:06:13.032418+07
d4170dad-3295-49d5-a28a-9da6e9f7aca1	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	329705	login	2026-01-16 11:17:07.324773+07	\N	2026-01-16 11:12:07.325217+07
bd3abf60-edfc-4170-94da-9993eefe073e	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	970054	login	2026-01-16 13:16:02.190307+07	2026-01-16 13:11:48.37122+07	2026-01-16 13:11:02.191533+07
79d2840e-7988-4ab8-93ff-b04c6bdfac4a	3ffb92db-0711-4c88-a94e-b8bd3a6c7f50	702364	login	2026-01-16 13:20:25.225557+07	2026-01-16 13:16:26.768651+07	2026-01-16 13:15:25.226525+07
\.


--
-- Name: cinemas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cinemas_id_seq', 3, true);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 4, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 3, true);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_methods_id_seq', 23, true);


--
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.people_id_seq', 7, true);


--
-- Name: seats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seats_id_seq', 1440, true);


--
-- Name: studios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.studios_id_seq', 9, true);


--
-- Name: booking_seats booking_seats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_seats
    ADD CONSTRAINT booking_seats_pkey PRIMARY KEY (booking_id, seat_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: cinemas cinemas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinemas
    ADD CONSTRAINT cinemas_pkey PRIMARY KEY (id);


--
-- Name: genres genres_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_name_key UNIQUE (name);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: movie_genres movie_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_genres
    ADD CONSTRAINT movie_genres_pkey PRIMARY KEY (movie_id, genre_id);


--
-- Name: movie_people movie_people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_people
    ADD CONSTRAINT movie_people_pkey PRIMARY KEY (movie_id, person_id, role);


--
-- Name: movie_reviews movie_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_reviews
    ADD CONSTRAINT movie_reviews_pkey PRIMARY KEY (id);


--
-- Name: movie_schedules movie_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_schedules
    ADD CONSTRAINT movie_schedules_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_name_key UNIQUE (name);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (token);


--
-- Name: studios studios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studios
    ADD CONSTRAINT studios_pkey PRIMARY KEY (id);


--
-- Name: cinemas uq_cinemas_name_location; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cinemas
    ADD CONSTRAINT uq_cinemas_name_location UNIQUE (name, location);


--
-- Name: movie_reviews uq_movie_user_rating; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_reviews
    ADD CONSTRAINT uq_movie_user_rating UNIQUE (movie_id, user_id);


--
-- Name: payments uq_payment_booking; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT uq_payment_booking UNIQUE (booking_id);


--
-- Name: movie_schedules uq_schedule; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_schedules
    ADD CONSTRAINT uq_schedule UNIQUE (studio_id, show_date, show_time);


--
-- Name: seats uq_seat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT uq_seat UNIQUE (studio_id, seat_code);


--
-- Name: studios uq_studio_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studios
    ADD CONSTRAINT uq_studio_name UNIQUE (cinema_id, name);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: verification_codes verification_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_codes
    ADD CONSTRAINT verification_codes_pkey PRIMARY KEY (id);


--
-- Name: idx_booking_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_booking_schedule ON public.bookings USING btree (schedule_id);


--
-- Name: idx_movies_now_showing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_movies_now_showing ON public.movies USING btree (release_date, end_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_schedule_date_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_date_time ON public.movie_schedules USING btree (show_date, show_time);


--
-- Name: booking_seats booking_seats_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_seats
    ADD CONSTRAINT booking_seats_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: booking_seats booking_seats_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_seats
    ADD CONSTRAINT booking_seats_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.movie_schedules(id);


--
-- Name: booking_seats booking_seats_seat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_seats
    ADD CONSTRAINT booking_seats_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES public.seats(id);


--
-- Name: bookings bookings_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.movie_schedules(id);


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: movie_genres movie_genres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_genres
    ADD CONSTRAINT movie_genres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE CASCADE;


--
-- Name: movie_genres movie_genres_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_genres
    ADD CONSTRAINT movie_genres_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_people movie_people_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_people
    ADD CONSTRAINT movie_people_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_people movie_people_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_people
    ADD CONSTRAINT movie_people_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: movie_reviews movie_reviews_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_reviews
    ADD CONSTRAINT movie_reviews_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_reviews movie_reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_reviews
    ADD CONSTRAINT movie_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: movie_schedules movie_schedules_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_schedules
    ADD CONSTRAINT movie_schedules_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: movie_schedules movie_schedules_studio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_schedules
    ADD CONSTRAINT movie_schedules_studio_id_fkey FOREIGN KEY (studio_id) REFERENCES public.studios(id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: payments payments_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: seats seats_studio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_studio_id_fkey FOREIGN KEY (studio_id) REFERENCES public.studios(id);


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: studios studios_cinema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studios
    ADD CONSTRAINT studios_cinema_id_fkey FOREIGN KEY (cinema_id) REFERENCES public.cinemas(id);


--
-- Name: verification_codes verification_codes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_codes
    ADD CONSTRAINT verification_codes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict uEVbC5v9BQMm7oKegI0VYq0h2iXl1AVftd0rhcaVxkUTZI4o0mE6BjcfaWHvIjJ

