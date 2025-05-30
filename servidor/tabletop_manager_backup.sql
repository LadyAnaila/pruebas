--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-27 17:18:00

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
-- TOC entry 227 (class 1259 OID 16455)
-- Name: achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.achievements (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.achievements OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16454)
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.achievements_id_seq OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 226
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;


--
-- TOC entry 225 (class 1259 OID 16442)
-- Name: deck_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deck_cards (
    id integer NOT NULL,
    deck_id integer,
    card_code character varying(50) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.deck_cards OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: deck_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deck_cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deck_cards_id_seq OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 224
-- Name: deck_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deck_cards_id_seq OWNED BY public.deck_cards.id;


--
-- TOC entry 223 (class 1259 OID 16429)
-- Name: decks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.decks (
    id integer NOT NULL,
    user_id integer,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.decks OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16428)
-- Name: decks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.decks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.decks_id_seq OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 222
-- Name: decks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.decks_id_seq OWNED BY public.decks.id;


--
-- TOC entry 233 (class 1259 OID 24647)
-- Name: elimination_rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elimination_rounds (
    id integer NOT NULL,
    event_id integer,
    round_number integer NOT NULL,
    pairings jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.elimination_rounds OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24646)
-- Name: elimination_rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.elimination_rounds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.elimination_rounds_id_seq OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 232
-- Name: elimination_rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.elimination_rounds_id_seq OWNED BY public.elimination_rounds.id;


--
-- TOC entry 221 (class 1259 OID 16410)
-- Name: event_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_participants (
    event_id integer NOT NULL,
    username text NOT NULL
);


ALTER TABLE public.event_participants OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16400)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    date date NOT NULL,
    address character varying(255),
    game_name character varying(100) NOT NULL,
    format character varying(50),
    event_type character varying(50) NOT NULL,
    start_time time without time zone NOT NULL,
    registration_fee numeric(10,2),
    max_participants integer,
    visibility boolean DEFAULT true,
    image_url character varying(255),
    duration integer,
    contact_info text,
    age_restriction character varying(50),
    languages character varying(100),
    cancellation_policy text,
    internal_notes text,
    created_by character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    participants text[],
    tournament_type character varying(50)
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16399)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO postgres;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 219
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 231 (class 1259 OID 16482)
-- Name: tournament_rankings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournament_rankings (
    id integer NOT NULL,
    tournament_id integer,
    username character varying(50),
    "position" integer,
    points integer
);


ALTER TABLE public.tournament_rankings OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16481)
-- Name: tournament_rankings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tournament_rankings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tournament_rankings_id_seq OWNER TO postgres;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 230
-- Name: tournament_rankings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tournament_rankings_id_seq OWNED BY public.tournament_rankings.id;


--
-- TOC entry 235 (class 1259 OID 24662)
-- Name: tournament_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournament_results (
    id integer NOT NULL,
    event_id integer,
    results jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tournament_results OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24661)
-- Name: tournament_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tournament_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tournament_results_id_seq OWNER TO postgres;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 234
-- Name: tournament_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tournament_results_id_seq OWNED BY public.tournament_results.id;


--
-- TOC entry 229 (class 1259 OID 16464)
-- Name: user_achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_achievements (
    id integer NOT NULL,
    username character varying(50),
    achievement_id integer,
    date_earned timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_achievements OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16463)
-- Name: user_achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_achievements_id_seq OWNER TO postgres;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_achievements_id_seq OWNED BY public.user_achievements.id;


--
-- TOC entry 218 (class 1259 OID 16386)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role text NOT NULL,
    bio text,
    CONSTRAINT users_role_check CHECK ((role = ANY (ARRAY['player'::text, 'store'::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16385)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4794 (class 2604 OID 16458)
-- Name: achievements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 16445)
-- Name: deck_cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_cards ALTER COLUMN id SET DEFAULT nextval('public.deck_cards_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 16432)
-- Name: decks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decks ALTER COLUMN id SET DEFAULT nextval('public.decks_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 24650)
-- Name: elimination_rounds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elimination_rounds ALTER COLUMN id SET DEFAULT nextval('public.elimination_rounds_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 16403)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 16485)
-- Name: tournament_rankings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rankings ALTER COLUMN id SET DEFAULT nextval('public.tournament_rankings_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 24665)
-- Name: tournament_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_results ALTER COLUMN id SET DEFAULT nextval('public.tournament_results_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 16467)
-- Name: user_achievements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements ALTER COLUMN id SET DEFAULT nextval('public.user_achievements_id_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 16389)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4994 (class 0 OID 16455)
-- Dependencies: 227
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievements (id, name, description) FROM stdin;
\.


--
-- TOC entry 4992 (class 0 OID 16442)
-- Dependencies: 225
-- Data for Name: deck_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deck_cards (id, deck_id, card_code, quantity) FROM stdin;
1	1	01001	1
2	2	01001	3
3	2	01033	2
4	3	01033	4
12	5	01001	1
13	6	01001	1
14	6	01003	2
15	6	01080	2
18	9	01005	1
19	9	01076	2
20	9	01080	2
21	9	01077	2
22	9	01084	2
23	9	01072	2
24	9	01078	2
25	9	01075	2
26	9	01074	2
27	9	01079	2
28	10	01076	3
29	10	01014	2
60	14	01001	1
61	14	01005	1
\.


--
-- TOC entry 4990 (class 0 OID 16429)
-- Dependencies: 223
-- Data for Name: decks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.decks (id, user_id, name, created_at) FROM stdin;
1	4	cosa	2025-05-16 00:15:43.461352
2	4	3 rolands 	2025-05-16 00:44:43.54318
3	4	mazo mega guay 	2025-05-16 00:44:57.582948
5	2	mazo mazo 	2025-05-17 07:55:20.141411
6	4	cosa	2025-05-18 08:16:38.655952
9	5	Mazo de Wendy	2025-05-18 08:54:35.898369
10	2	Mazo 2 	2025-05-18 09:14:30.657439
14	4	ccc	2025-05-21 15:19:24.832426
\.


--
-- TOC entry 5000 (class 0 OID 24647)
-- Dependencies: 233
-- Data for Name: elimination_rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.elimination_rounds (id, event_id, round_number, pairings, created_at) FROM stdin;
\.


--
-- TOC entry 4988 (class 0 OID 16410)
-- Dependencies: 221
-- Data for Name: event_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_participants (event_id, username) FROM stdin;
2	noeliaxx
2	ana
2	beto
2	carla
2	david
2	elena
2	fran
2	gema
2	hector
2	Tiendatienda
5	noelia
\.


--
-- TOC entry 4987 (class 0 OID 16400)
-- Dependencies: 220
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, name, description, date, address, game_name, format, event_type, start_time, registration_fee, max_participants, visibility, image_url, duration, contact_info, age_restriction, languages, cancellation_policy, internal_notes, created_by, created_at, participants, tournament_type) FROM stdin;
1	Torneo de Ajedrez	Un torneo de ajedrez emocionante	2025-06-15	Calle Ficticia 123	Ajedrez	\N	Competencia	10:00:00	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	johndoe	2025-05-14 20:52:41.514658	\N	\N
2	Evento de prueba 	Evento para probar los emparejamientos en caso de torneo suizo. 	2025-05-29	monte ronin	Pokémon TCG		Torneo	02:00:00	5.00	20	t		0						Tiendatienda	2025-05-18 18:31:28.020732	\N	\N
5	Evento nº2	Evento de prueba	2025-05-28	goblin trader valencia 	La Leyenda de los Cinco Anillos: El juego de cartas		Torneo	12:00:00	0.00	0	t	https://drimjuguetes.vtexassets.com/arquivos/ids/603476/La-Leyenda-de-los-5-Anillos--El-Juego-de-Cartas.jpg?v=636933997123730000	0						Tiendatienda	2025-05-25 00:03:52.850603	\N	\N
\.


--
-- TOC entry 4998 (class 0 OID 16482)
-- Dependencies: 231
-- Data for Name: tournament_rankings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tournament_rankings (id, tournament_id, username, "position", points) FROM stdin;
\.


--
-- TOC entry 5002 (class 0 OID 24662)
-- Dependencies: 235
-- Data for Name: tournament_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tournament_results (id, event_id, results, created_at) FROM stdin;
6	2	["Fran", "Tienda", "Ana", "Carla", "Gema", "David", "Noelia", "Beto", "Elena", "Hector"]	2025-05-24 23:16:35.668002
\.


--
-- TOC entry 4996 (class 0 OID 16464)
-- Dependencies: 229
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_achievements (id, username, achievement_id, date_earned) FROM stdin;
\.


--
-- TOC entry 4985 (class 0 OID 16386)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, username, email, password, role, bio) FROM stdin;
1	John Doe	johndoe	john@example.com	hashedpassword123	player	\N
2	NOelia	noelia	noelia@mail.com	$2b$10$4HqqUSSZPNOD9vhEePk.iel5bai12vD7wRdqWcU8xbKhAIDAYeQkC	player	\N
5	Noelia	Noelia	noelial@mail.com	$2b$10$2akPHitZV.hLbryT2vB8ge7KtbXVVbvPn2BL1oVCCUttKVL35T87W	player	\N
6	Perfil tienda	Perfiltienda	tienda@tienda.com	$2b$10$XmGrJufuKw5JXwYsVlUiOuPZPlBr2MEWn3mVy6GvS1jcFAC8WBTfm	store	\N
11	jugadora	jugadora	jugadora@jugadora.com	$2b$10$mGo7fZTI1tK2atlSCC3Lveh2LkJL3hAJGjJdxzDFWQVyLVZdrdq4e	player	\N
12	Tienda23	Tienda23	tiendeo@tienda.com	$2b$10$qPl4p.whlnzuIipl9osqD.tMlTEaXm/JHjemHP1ORcTyJo1ve0WCK	store	\N
16	Ana	ana	ana@email.com	1234	player	\N
17	Beto	beto	beto@email.com	1234	player	\N
18	Carla	carla	carla@email.com	1234	player	\N
19	David	david	david@email.com	1234	player	\N
20	Elena	elena	elena@email.com	1234	player	\N
21	Fran	fran	fran@email.com	1234	player	\N
22	Gema	gema	gema@email.com	1234	player	\N
23	Hector	hector	hector@email.com	1234	player	\N
4	Noelia	noeliaxx	noelianuevo@mail.com	$2b$10$E3rOnQ4IhxA0lSL9bY9x5eRJw1bF4Poi7MSJ4qIct4i.jazi0vYFi	player	holiwi
24	Antonio	Antonio	antonio@mail.com	$2b$10$4QuvcqchRCKS71hhHowtnu3xDi7IlPXFjAKmmQ5uuCee11fcLOE5u	store	\N
13	Tienda	Tiendatienda	tiendatienda@mail.com	$2b$10$T/uHtE4H39UDc7Qa5xmkOuHXZxGzt32SPGkwG30KmCEoDHUtZnY5a	store	Mi biografía de tienda. 
\.


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 226
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.achievements_id_seq', 1, false);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 224
-- Name: deck_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deck_cards_id_seq', 61, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 222
-- Name: decks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.decks_id_seq', 14, true);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 232
-- Name: elimination_rounds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.elimination_rounds_id_seq', 1, false);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 219
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 5, true);


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 230
-- Name: tournament_rankings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tournament_rankings_id_seq', 1, false);


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 234
-- Name: tournament_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tournament_results_id_seq', 6, true);


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_achievements_id_seq', 1, false);


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 24, true);


--
-- TOC entry 4818 (class 2606 OID 16462)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 16448)
-- Name: deck_cards deck_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_cards
    ADD CONSTRAINT deck_cards_pkey PRIMARY KEY (id);


--
-- TOC entry 4814 (class 2606 OID 16435)
-- Name: decks decks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decks
    ADD CONSTRAINT decks_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 24655)
-- Name: elimination_rounds elimination_rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elimination_rounds
    ADD CONSTRAINT elimination_rounds_pkey PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 16416)
-- Name: event_participants event_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_pkey PRIMARY KEY (event_id, username);


--
-- TOC entry 4810 (class 2606 OID 16409)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 16487)
-- Name: tournament_rankings tournament_rankings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rankings
    ADD CONSTRAINT tournament_rankings_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 24670)
-- Name: tournament_results tournament_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_results
    ADD CONSTRAINT tournament_results_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 24677)
-- Name: tournament_results unique_event_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_results
    ADD CONSTRAINT unique_event_id UNIQUE (event_id);


--
-- TOC entry 4820 (class 2606 OID 16470)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 16398)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4806 (class 2606 OID 16394)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 2606 OID 16396)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4832 (class 2606 OID 16449)
-- Name: deck_cards deck_cards_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_cards
    ADD CONSTRAINT deck_cards_deck_id_fkey FOREIGN KEY (deck_id) REFERENCES public.decks(id) ON DELETE CASCADE;


--
-- TOC entry 4831 (class 2606 OID 16436)
-- Name: decks decks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decks
    ADD CONSTRAINT decks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4837 (class 2606 OID 24656)
-- Name: elimination_rounds elimination_rounds_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elimination_rounds
    ADD CONSTRAINT elimination_rounds_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- TOC entry 4829 (class 2606 OID 16417)
-- Name: event_participants event_participants_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 4830 (class 2606 OID 16422)
-- Name: event_participants event_participants_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON DELETE CASCADE;


--
-- TOC entry 4835 (class 2606 OID 16488)
-- Name: tournament_rankings tournament_rankings_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rankings
    ADD CONSTRAINT tournament_rankings_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES public.events(id);


--
-- TOC entry 4836 (class 2606 OID 16493)
-- Name: tournament_rankings tournament_rankings_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_rankings
    ADD CONSTRAINT tournament_rankings_username_fkey FOREIGN KEY (username) REFERENCES public.users(username);


--
-- TOC entry 4838 (class 2606 OID 24671)
-- Name: tournament_results tournament_results_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournament_results
    ADD CONSTRAINT tournament_results_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- TOC entry 4833 (class 2606 OID 16476)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id);


--
-- TOC entry 4834 (class 2606 OID 16471)
-- Name: user_achievements user_achievements_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_username_fkey FOREIGN KEY (username) REFERENCES public.users(username);


-- Completed on 2025-05-27 17:18:00

--
-- PostgreSQL database dump complete
--

