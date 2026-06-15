--
-- PostgreSQL database dump
--

\restrict RGqnvB5QDffY2pZaLoWM0j9i5XL30uR0rGvvFCImVEaFqT6jKBJU7nufPf54Pfe

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

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
-- Name: recovery_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recovery_test (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.recovery_test OWNER TO postgres;

--
-- Name: recovery_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recovery_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recovery_test_id_seq OWNER TO postgres;

--
-- Name: recovery_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recovery_test_id_seq OWNED BY public.recovery_test.id;


--
-- Name: recovery_test id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_test ALTER COLUMN id SET DEFAULT nextval('public.recovery_test_id_seq'::regclass);


--
-- Data for Name: recovery_test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recovery_test (id, name) FROM stdin;
1	poc11-data-before-incident
\.


--
-- Name: recovery_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recovery_test_id_seq', 1, true);


--
-- Name: recovery_test recovery_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_test
    ADD CONSTRAINT recovery_test_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict RGqnvB5QDffY2pZaLoWM0j9i5XL30uR0rGvvFCImVEaFqT6jKBJU7nufPf54Pfe

