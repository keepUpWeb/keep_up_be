--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: UserEminds_gender_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserEminds_gender_enum" AS ENUM (
    'Laki-Laki',
    'Perempuan'
);


ALTER TYPE public."UserEminds_gender_enum" OWNER TO postgres;

--
-- Name: level_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.level_enum AS ENUM (
    'very high',
    'high',
    'intermediate',
    'low',
    'very low',
    'normal'
);


ALTER TYPE public.level_enum OWNER TO postgres;

--
-- Name: userEminds_gender_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."userEminds_gender_enum" AS ENUM (
    'Laki-Laki',
    'Perempuan'
);


ALTER TYPE public."userEminds_gender_enum" OWNER TO postgres;

--
-- Name: userEminds_psikologstatus_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."userEminds_psikologstatus_enum" AS ENUM (
    'pending',
    'rejected',
    'approved'
);


ALTER TYPE public."userEminds_psikologstatus_enum" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    answer text NOT NULL,
    score integer NOT NULL,
    "questionIdId" uuid
);


ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: auths; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auths (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "isVerification" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "verificationAt" timestamp without time zone,
    token uuid NOT NULL
);


ALTER TABLE public.auths OWNER TO postgres;

--
-- Name: client_psychologist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_psychologist (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "assignedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updateAt" timestamp without time zone DEFAULT now() NOT NULL,
    "psychologistId" uuid,
    "clientId" uuid
);


ALTER TABLE public.client_psychologist OWNER TO postgres;

--
-- Name: facultys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facultys (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.facultys OWNER TO postgres;

--
-- Name: kuisioners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kuisioners (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kuisioners OWNER TO postgres;

--
-- Name: pre_kuisioner_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_kuisioner_answer (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    answer character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updateAt" timestamp without time zone DEFAULT now() NOT NULL,
    "preQuestionIdId" uuid
);


ALTER TABLE public.pre_kuisioner_answer OWNER TO postgres;

--
-- Name: pre_kuisioner_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_kuisioner_category (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.pre_kuisioner_category OWNER TO postgres;

--
-- Name: pre_kuisioner_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_kuisioner_question (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updateAt" timestamp without time zone DEFAULT now() NOT NULL,
    "categoryId" uuid
);


ALTER TABLE public.pre_kuisioner_question OWNER TO postgres;

--
-- Name: pre_kuisioner_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_kuisioner_user (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "isFinish" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pre_kuisioner_user OWNER TO postgres;

--
-- Name: pre_kuisioner_user_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_kuisioner_user_answer (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "preKuisionerUserId" uuid,
    "preKuisionerAnswerId" uuid
);


ALTER TABLE public.pre_kuisioner_user_answer OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "subKuisionerIdId" uuid
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: subkuisioners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subkuisioners (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "symtompIdId" uuid,
    "kuisionerIdId" uuid
);


ALTER TABLE public.subkuisioners OWNER TO postgres;

--
-- Name: summary_kuisioner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.summary_kuisioner (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    sumarize text NOT NULL,
    "kuisionerFinished" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    user_id uuid
);


ALTER TABLE public.summary_kuisioner OWNER TO postgres;

--
-- Name: symtomps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.symtomps (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.symtomps OWNER TO postgres;

--
-- Name: take_kuisioner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.take_kuisioner (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "isFinish" boolean DEFAULT false NOT NULL,
    report text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "kuisionerId" uuid,
    "userId" uuid
);


ALTER TABLE public.take_kuisioner OWNER TO postgres;

--
-- Name: userEminds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."userEminds" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    "birthDate" date,
    "yearEntry" integer,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    gender public."userEminds_gender_enum",
    "roleId" uuid,
    "facultyId" uuid,
    nim character varying,
    "psikologStatus" public."userEminds_psikologstatus_enum",
    "authId" uuid,
    "preKuisionerId" uuid
);


ALTER TABLE public."userEminds" OWNER TO postgres;

--
-- Name: user_answer_kuisioner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_answer_kuisioner (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userAnswerSubKuisionerId" uuid,
    "answerId" uuid
);


ALTER TABLE public.user_answer_kuisioner OWNER TO postgres;

--
-- Name: user_answer_sub_kuisioner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_answer_sub_kuisioner (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    level public.level_enum,
    score integer,
    "subKuisionerId" uuid,
    "takeKuisionerId" uuid
);


ALTER TABLE public.user_answer_sub_kuisioner OWNER TO postgres;

--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (id, answer, score, "questionIdId") FROM stdin;
d85ccb92-9175-4029-827c-2ccade6984e3	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	673570f0-32cb-4002-b50b-496ca18e4047
6ee66dc9-a0db-4607-b2cf-edc741e28833	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	9580539a-9643-4ee5-8008-c2caf10fd661
fea03c2d-23d1-47d3-ae77-bcea70ea53fb	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	7667e7db-1f79-48c9-a176-bbe9d773781e
28eac750-7a50-439f-bf5d-e07bbb4f496a	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	30924def-0dd1-4a4a-b603-5f8eebcceb70
2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	aba6462a-d11b-496f-a930-7dea1d288429
33fe9d35-2f39-4ca6-bc05-bfad2402ca6d	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	f30be436-3c81-4ed3-9f40-79a608304a5f
951adef9-ef3b-4d3d-880d-a9788b4cbae6	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	e25698f9-143a-422a-9732-95f545082e6d
03999e08-b875-4f63-bf97-c220705ba672	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	673570f0-32cb-4002-b50b-496ca18e4047
1dbbe31c-27f2-47c4-a200-2346d84314b7	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	b536f518-186f-494c-82b9-b7ec4686e714
c8fec09c-b992-463f-97fb-106c29d889bc	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb
20a9c879-f4a5-4486-9161-50701b056327	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	ed9ed04d-aae5-45f1-88ca-a716fec1454e
8edc4a35-a3f2-44a7-bec3-bf08faed7a5f	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	aba6462a-d11b-496f-a930-7dea1d288429
7dbd9b8d-1c22-4a38-a75e-f23e90a4d393	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	30924def-0dd1-4a4a-b603-5f8eebcceb70
f4433601-a483-44d6-8c98-898ff69193d1	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	7667e7db-1f79-48c9-a176-bbe9d773781e
00452b01-da8a-4380-8759-877c80f392dd	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	b536f518-186f-494c-82b9-b7ec4686e714
00b08d53-72ae-4330-934f-2f5290bb24fc	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	f30be436-3c81-4ed3-9f40-79a608304a5f
95c972aa-82e4-4da5-afa0-d2ecfe65d6cb	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	e25698f9-143a-422a-9732-95f545082e6d
33c555fb-64bd-440d-9362-d420ce224c1a	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	673570f0-32cb-4002-b50b-496ca18e4047
26982feb-eba9-4b04-89ea-98535fa61c3d	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	b536f518-186f-494c-82b9-b7ec4686e714
ff0653fc-e130-4ea9-b889-96f4bea63b62	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	7667e7db-1f79-48c9-a176-bbe9d773781e
1e361eae-eb51-4d32-ab0c-cd453bdd2734	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	30924def-0dd1-4a4a-b603-5f8eebcceb70
4e947c6f-446e-4e8e-8cf8-083538146cfe	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	aba6462a-d11b-496f-a930-7dea1d288429
1c8d1edf-ae25-4d10-8b63-3b60fbb9e411	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	f30be436-3c81-4ed3-9f40-79a608304a5f
11063ddf-508e-4281-8dc5-ac4bd1563d0c	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	e25698f9-143a-422a-9732-95f545082e6d
1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9	Tidak terjadi sama sekali pada saya	0	673570f0-32cb-4002-b50b-496ca18e4047
553157a9-f226-49fa-af48-e508f1395f83	Tidak terjadi sama sekali pada saya 	0	650707f9-f62f-452d-bfff-2abbd6337bb0
38670ebf-9e68-40d6-845a-3061a47cafe6	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	970d537c-edd4-4cb9-815a-170694527754
6f474582-2930-4901-9d09-efdf4679f879	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	9f997851-c784-4fea-8928-cf13baf669e4
18db8227-5ee7-4bc7-a44d-b5cc930f2ae6	Tidak terjadi sama sekali pada saya	0	aae60c45-876c-4634-98db-421b06751ac9
ddfa5493-8205-46d9-a29c-4934739cb1b4	Tidak terjadi sama sekali pada saya	0	04e07acf-f306-4ec5-8548-dff939fbba6e
3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2	Tidak terjadi sama sekali pada saya	0	e573d43b-6495-4b1e-9f94-7a9d062b481a
298d4cb0-b557-4ec9-9a50-0a3415affaea	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	ed9ed04d-aae5-45f1-88ca-a716fec1454e
133df2a4-0505-4aed-bdf5-b2dd5e21c7c9	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	9f997851-c784-4fea-8928-cf13baf669e4
cbf0a0b9-a6ab-47ef-aae1-063a82cc006e	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb
868435dd-ab2f-48d0-8fc8-97b29a652c0c	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	9580539a-9643-4ee5-8008-c2caf10fd661
f63199f1-343b-4127-a6ee-1eb0e65b5232	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	970d537c-edd4-4cb9-815a-170694527754
04131970-6b8c-41fa-a21b-57f1b1bbef21	Tidak terjadi sama sekali pada saya	0	93d681f6-75a7-413b-9005-b1249d27210a
b1ae56e1-c683-49c2-95b2-b96f71fc435c	Tidak terjadi sama sekali pada saya	0	3b89d150-a078-486a-a107-e1843db6db6e
b8590cf6-ac78-40f7-b434-dacc456bdd2f	Tidak terjadi sama sekali pada saya	0	51ee586e-6333-4d9d-a961-071a9ac4e1f7
c965fa2d-0ebd-440c-86ce-bab64e06553a	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	970d537c-edd4-4cb9-815a-170694527754
8e5aedfc-077e-4c70-847c-d06a94840fa4	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	9580539a-9643-4ee5-8008-c2caf10fd661
ca965a27-d390-453b-a3cc-69e4ccc791e3	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb
e39910ae-2305-4c95-b7cf-a12676e2c464	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	ed9ed04d-aae5-45f1-88ca-a716fec1454e
24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	9f997851-c784-4fea-8928-cf13baf669e4
b911af8e-191c-476d-bbf6-6848e12ca6cb	Setuju	5	dd485669-4209-44f8-b21b-85751223d073
79325b26-f52e-48bf-9185-b30de43d64d3	Tidak terjadi sama sekali pada saya	0	b536f518-186f-494c-82b9-b7ec4686e714
bd7c933d-b38a-4acf-8053-496d42630b61	Tidak terjadi sama sekali pada saya	0	7667e7db-1f79-48c9-a176-bbe9d773781e
a78e7dbf-eb22-4927-a1ac-a30264a5d1e0	Tidak terjadi sama sekali pada saya	0	30924def-0dd1-4a4a-b603-5f8eebcceb70
9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10	Tidak terjadi sama sekali pada saya	0	aba6462a-d11b-496f-a930-7dea1d288429
d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	650707f9-f62f-452d-bfff-2abbd6337bb0
6eb08218-0a94-451d-bf6d-b3e5c2967b09	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	8b56b1da-d0e0-4aba-b04f-d37855c01594
5cf17261-cfbc-4fbf-aef5-7b3d9eaef478	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	8b56b1da-d0e0-4aba-b04f-d37855c01594
e9befb8e-19e1-4a7b-a030-2fd2ca1537a3	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	650707f9-f62f-452d-bfff-2abbd6337bb0
40c13606-829a-4d32-9a2f-634465feb1b3	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	8b56b1da-d0e0-4aba-b04f-d37855c01594
2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	650707f9-f62f-452d-bfff-2abbd6337bb0
3635d565-2a74-447e-829b-b7e334ef194e	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	aae60c45-876c-4634-98db-421b06751ac9
c7603d88-fad0-487b-9eb7-c3c31a5ca59d	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	04e07acf-f306-4ec5-8548-dff939fbba6e
cdce8b68-4fc8-4d39-b39c-3485307475cb	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	e573d43b-6495-4b1e-9f94-7a9d062b481a
688f2b9a-9285-46e9-9b78-d60977fd9360	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	93d681f6-75a7-413b-9005-b1249d27210a
e904973e-dec8-405b-b085-ad3090267a7a	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	3b89d150-a078-486a-a107-e1843db6db6e
6e8aa530-4d74-4e8c-babd-274b66ba6b69	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	51ee586e-6333-4d9d-a961-071a9ac4e1f7
8a245a89-7254-42d9-b8fd-2eac410a5585	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	51ee586e-6333-4d9d-a961-071a9ac4e1f7
ce19f108-27f8-4df8-9866-8675d9c623f0	Netral	3	6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5
5058bf81-4cd1-4f3f-990f-5767beab04c8	Agak Setuju	4	6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5
63c26fae-f8d7-4507-8433-ffe1f59614e1	Netral	3	26bfbde5-b833-4264-aa9e-63e8a077dfd5
64845272-2299-403b-a285-0a9515b643d8	Agak Setuju	4	26bfbde5-b833-4264-aa9e-63e8a077dfd5
0261cf0e-50e4-4252-a269-ab1d16187042	Netral	3	8ba5fcf1-e420-4147-8398-3f18c57b4f1d
ae3b7895-feda-406e-a6b8-61a8a20dcd3a	Agak Setuju	4	8ba5fcf1-e420-4147-8398-3f18c57b4f1d
1870d9f2-9162-4fbd-bf50-43698022b8da	Netral	3	b58a1c58-369f-4c0c-9201-3a5921171675
84885e6f-7c44-4922-96a5-5f19ce145f96	Agak Setuju	4	b58a1c58-369f-4c0c-9201-3a5921171675
a2d3ea49-f184-41f2-a6b3-26b2fea2338a	Netral	3	dd485669-4209-44f8-b21b-85751223d073
68a35597-81f3-435d-935f-f89ecd6add03	Agak Setuju	4	dd485669-4209-44f8-b21b-85751223d073
a8ac4c5b-f187-46de-ad0e-4e806587c0ea	Sedikit Tidak Setuju	3	687d550f-7c64-439c-b88f-598d55f29f06
e20b945b-e86b-46ac-8513-ebbfaa9a4560	Sedikit Setuju	4	687d550f-7c64-439c-b88f-598d55f29f06
5bd7f24d-e0d3-447e-9942-58a64046ac83	Setuju	5	687d550f-7c64-439c-b88f-598d55f29f06
d8be6eba-fd02-48ef-8424-cbb640b9bd27	Sangat Setuju	6	687d550f-7c64-439c-b88f-598d55f29f06
7fefaab7-e87e-42ca-9bb8-858201cf7172	Sedikit Tidak Setuju	3	d3308666-6dee-4ff5-893f-af9e72504f9f
82c07f83-9ab1-4097-ad30-36e7d81d1340	Sedikit Setuju	4	d3308666-6dee-4ff5-893f-af9e72504f9f
87ea4e24-4b45-4e2a-b731-7a9738806c64	Setuju	5	d3308666-6dee-4ff5-893f-af9e72504f9f
2894cadd-aa58-44ef-a09a-f865f2937bf3	Sangat Setuju	6	d3308666-6dee-4ff5-893f-af9e72504f9f
443894b2-d27a-481b-b1db-dd991498fc5e	Sedikit Tidak Setuju	3	5fd5ab32-a4d5-435a-9507-e4789c359436
aad04f4c-db14-4ef4-9998-686fa9002e11	Sedikit Setuju	4	5fd5ab32-a4d5-435a-9507-e4789c359436
2f41465a-30ef-4518-9af9-564e610a295c	Setuju	5	5fd5ab32-a4d5-435a-9507-e4789c359436
cd28bafd-e93c-4ef2-b99d-85d18e269d5b	Sangat Setuju	6	5fd5ab32-a4d5-435a-9507-e4789c359436
8c3a2086-969e-426d-91db-306fcfaec506	Sedikit Tidak Setuju	3	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed	Sedikit Setuju	4	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
261ef8d9-eeae-44f0-8c52-57315abc0007	Setuju	5	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
d497faaf-de8a-48c5-9e50-89d65255dac8	Sangat Setuju	6	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db	Sedikit Tidak Setuju	3	36d7938a-7c2e-48e2-a99d-608259dc3475
1780c740-f601-4108-9203-fd5a70a9d180	Sedikit Setuju	4	36d7938a-7c2e-48e2-a99d-608259dc3475
8c96bcec-e94f-4470-9096-3b034db6ef57	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	310a3ea6-2196-4e58-8f1c-5016d750d663
b52ffb50-0d1e-4da5-8bf8-2ce37912d821	Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu	1	310a3ea6-2196-4e58-8f1c-5016d750d663
71d05faf-8913-4073-a401-7ee58d09559c	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	3b89d150-a078-486a-a107-e1843db6db6e
6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	93d681f6-75a7-413b-9005-b1249d27210a
282a9ee7-0259-4e07-b343-37c486d94416	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	e573d43b-6495-4b1e-9f94-7a9d062b481a
556e545d-5b80-483d-9b7d-a822172e4a7b	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	04e07acf-f306-4ec5-8548-dff939fbba6e
7e76483f-4b12-4f18-b5bc-cff26c2e81ee	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	aae60c45-876c-4634-98db-421b06751ac9
670afeb2-fa6e-4769-9c38-d7dfaa3be259	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	aae60c45-876c-4634-98db-421b06751ac9
8b764a87-01f9-4624-9f9c-2c8317269799	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	e573d43b-6495-4b1e-9f94-7a9d062b481a
6c0eeba4-a22a-4e64-8058-ab328711b8b0	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	3b89d150-a078-486a-a107-e1843db6db6e
da95f662-6808-4bb7-a04a-f7a5468cd6bb	Setuju	5	b58a1c58-369f-4c0c-9201-3a5921171675
decba44a-23dc-4d6b-b754-4799e45488d6	Tidak Setuju	1	b58a1c58-369f-4c0c-9201-3a5921171675
bb69df93-68c5-4063-a5fd-74ab02d5ba84	Kurang Setuju	2	b58a1c58-369f-4c0c-9201-3a5921171675
84370b0b-27aa-42df-b7d4-5ae28d9acb98	Tidak Setuju	2	36d7938a-7c2e-48e2-a99d-608259dc3475
e34c8419-09e5-4302-a5b4-60b8830419f2	Sangat Tidak Setuju	1	36d7938a-7c2e-48e2-a99d-608259dc3475
3c0e478d-ec46-4585-a584-08b67e891b47	Tidak Setuju	2	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
5cada605-9735-4e39-9f67-e3915eb9ecfb	Sangat Tidak Setuju	1	b10bf59e-921c-4e5d-bdfa-0aeed50e2072
16afbb62-78c6-46b9-9ab7-8ebb322cb626	Tidak Setuju	2	5fd5ab32-a4d5-435a-9507-e4789c359436
3dfad056-e365-45cd-8c74-59b49985eca2	Sangat Tidak Setuju	1	5fd5ab32-a4d5-435a-9507-e4789c359436
4a2063fe-517e-4e6d-b888-337a6a0faf48	Tidak Setuju	2	d3308666-6dee-4ff5-893f-af9e72504f9f
ea88794b-f71a-44aa-8fa5-6bc9556a2afa	Sangat Tidak Setuju	1	d3308666-6dee-4ff5-893f-af9e72504f9f
9a6c3789-1e92-4775-ab6b-055bf8165c5d	Tidak Setuju	2	687d550f-7c64-439c-b88f-598d55f29f06
966a3bcc-d18c-484e-b60e-37cdd682cb84	Sangat Tidak Setuju	1	687d550f-7c64-439c-b88f-598d55f29f06
ced2e89a-0e7a-4427-8c85-b0d557baac68	Kurang Setuju	2	dd485669-4209-44f8-b21b-85751223d073
67ae3aea-4ab7-402b-9c64-9772d924bf69	Tidak Setuju	1	dd485669-4209-44f8-b21b-85751223d073
7fee0783-f025-4da1-8cec-fbcd18b107b0	Setuju	5	8ba5fcf1-e420-4147-8398-3f18c57b4f1d
b0b9724c-158c-4487-b15c-cc77674bde0a	Kurang Setuju	2	8ba5fcf1-e420-4147-8398-3f18c57b4f1d
e9be5267-6bc7-4816-92b9-0823824a3f91	Tidak Setuju	1	8ba5fcf1-e420-4147-8398-3f18c57b4f1d
ab145af8-a7f3-460d-96c2-0955ad99420e	Setuju	5	26bfbde5-b833-4264-aa9e-63e8a077dfd5
c9647eeb-2d2f-49ff-ac2f-7ec2668715b3	Kurang Setuju	2	26bfbde5-b833-4264-aa9e-63e8a077dfd5
8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9	Tidak Setuju	1	26bfbde5-b833-4264-aa9e-63e8a077dfd5
760e0210-eaf2-4bb5-af81-985e4d149200	Setuju	5	6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5
cfdcca34-7fd5-4838-9370-21276899c178	Kurang Setuju	2	6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5
64c02f11-0204-4a11-be07-68ef5b0f36f1	Tidak Setuju	1	6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5
ea45aec4-8eb0-4141-af1f-09195f8b5e3d	Setuju	5	36d7938a-7c2e-48e2-a99d-608259dc3475
0cba341f-4f70-4f9e-b03c-177862b22df3	Sangat Setuju	6	36d7938a-7c2e-48e2-a99d-608259dc3475
eb5ae92f-804a-4e32-991d-5fc2cedc10ad	Sedikit Tidak Setuju	3	de7716e9-894a-443c-9f7c-830ab7e0acdf
70cf216b-709d-45fd-8486-b10b3e5223d9	Sedikit Setuju	4	de7716e9-894a-443c-9f7c-830ab7e0acdf
f9472967-962e-4b39-b318-16a771eba42d	Setuju	5	de7716e9-894a-443c-9f7c-830ab7e0acdf
02dbd7ca-f388-43fd-9548-173a35837682	Sangat Setuju	6	de7716e9-894a-443c-9f7c-830ab7e0acdf
2e537ef7-cbab-42d4-8fd8-eb407ad7f89d	Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu	2	310a3ea6-2196-4e58-8f1c-5016d750d663
5b7f965f-4d06-47aa-bf3d-0e66b47709af	Tidak terjadi sama sekali pada saya	0	310a3ea6-2196-4e58-8f1c-5016d750d663
46d123ae-7693-47a9-9d39-d1316173a1e9	Tidak terjadi sama sekali pada saya 	0	f30be436-3c81-4ed3-9f40-79a608304a5f
00cdb44d-3200-46f0-8757-42e78e569a42	Tidak terjadi sama sekali pada saya 	0	e25698f9-143a-422a-9732-95f545082e6d
be3bbe21-0a5a-4fef-aff3-0e3d5426f984	Tidak terjadi sama sekali pada saya	0	8b56b1da-d0e0-4aba-b04f-d37855c01594
c83b9a45-346e-41f7-ac61-39811253a2a4	Tidak terjadi sama sekali pada saya	0	970d537c-edd4-4cb9-815a-170694527754
6b428caa-622b-47c3-824b-3c755683a21c	Tidak terjadi sama sekali pada saya	0	9580539a-9643-4ee5-8008-c2caf10fd661
011875b1-f030-4ee5-a103-7a5900a6b8b6	Tidak terjadi sama sekali pada saya	0	8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb
1869c4c7-abb6-4cbb-8995-fb6a1e46e076	Tidak terjadi sama sekali pada saya	0	ed9ed04d-aae5-45f1-88ca-a716fec1454e
4974c20a-94d5-4a52-983f-4abba57a225b	Tidak terjadi sama sekali pada saya	0	9f997851-c784-4fea-8928-cf13baf669e4
631d799c-e4cc-4f12-b74e-973dabb21075	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	04e07acf-f306-4ec5-8548-dff939fbba6e
02df8cb1-f817-4182-a8da-24f24737babc	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	93d681f6-75a7-413b-9005-b1249d27210a
34c2c6e6-a3d9-4d0f-97f9-954087748564	Terjadi pada saya sangat sering atau hampir sepanjang waktu	3	51ee586e-6333-4d9d-a961-071a9ac4e1f7
ce0753c0-bd38-45f1-969f-1d8d3e035a69	Tidak Setuju	2	de7716e9-894a-443c-9f7c-830ab7e0acdf
d65c7d3f-40de-42d6-ac23-bf434daaad00	Sangat Tidak Setuju	1	de7716e9-894a-443c-9f7c-830ab7e0acdf
\.


--
-- Data for Name: auths; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auths (id, "isVerification", "createdAt", "verificationAt", token) FROM stdin;
801eb172-3a14-45c0-bf01-b49e7594c5bf	t	2024-10-15 20:03:42.980739	2024-10-15 21:09:59.263	e0323812-da0d-4f1d-8c78-6ec4c08255da
199d2e68-6d78-438d-9d92-e8f0788c8316	t	2024-10-15 21:12:44.147703	2024-10-15 21:13:24.31	1281d633-fadc-4611-b325-a478b7722f63
0122c96e-a16e-4a1a-8ce0-dbc026ea8b3a	t	2024-10-22 15:18:11.473594	2024-10-08 14:20:28.362	266c07ff-0f5b-44bb-991a-bcf2d231e4a4
6b467547-1c2f-4193-9cf3-7c54c35341ec	t	2024-10-22 15:19:03.35485	2024-10-08 14:20:28.362	18e6046f-9100-48a4-b3d9-abbbd260acf0
18c9184a-c88d-4988-a2b7-2f08d43190b3	t	2024-10-24 18:26:08.796213	\N	04b95910-16a0-4692-96ee-2ba90f71fd1c
1b4d0d00-7d71-4e44-9681-56d2daa02822	t	2024-10-24 18:27:23.962936	\N	db842063-4664-4011-8a5f-edbed61124fb
127feaae-b529-4917-8bf1-e0c4f321deaa	t	2024-11-10 21:15:39.047905	2024-11-10 21:20:44.041	022abe26-3d83-4538-9de1-619b1edea9ad
08b8c8d7-8823-4708-8be1-cf337f39133e	t	2024-11-26 14:47:28.193559	2024-11-26 14:49:19.036	0570a63f-7566-4f82-8090-0b0d8dc709a8
83a68f38-1ec3-4919-acc5-ff62e7afa719	t	2024-12-26 10:46:42.223964	2024-12-26 10:48:25.133	a73271dd-9276-45fd-9442-c2c3ac25a173
1a0355a7-39bc-423d-99b1-d350615ba2fd	t	2024-10-08 14:16:27.500155	2024-10-08 14:20:28.362	fb22c8ac-4004-41e4-8f4c-9b9b166566d7
\.


--
-- Data for Name: client_psychologist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_psychologist (id, "assignedAt", "updateAt", "psychologistId", "clientId") FROM stdin;
ae6c5128-53c1-449e-abc7-606d144a153f	2024-10-22 15:19:03.35485	2024-10-22 15:19:03.35485	e889f730-827f-4285-bd6a-6ecc1f7d995d	2f0822f5-1ed5-4ecc-8e9c-93491dc93d04
41c65f52-5c7c-4972-82a2-12b48b8fa003	2024-10-24 18:26:08.796213	2024-10-24 18:26:08.796213	e889f730-827f-4285-bd6a-6ecc1f7d995d	26d52cc3-f2e0-4be1-8cd8-ca2a193a242a
38d5ada5-80e7-4032-bf54-5216ef631eee	2024-10-24 18:27:23.962936	2024-10-24 18:27:23.962936	e889f730-827f-4285-bd6a-6ecc1f7d995d	b7328825-2d44-4b59-a4ba-77d6b42faa3b
0717705b-edf4-4221-b494-a516f92e4045	2024-11-10 21:15:39.047905	2024-11-10 21:15:39.047905	e889f730-827f-4285-bd6a-6ecc1f7d995d	da50cf79-ee3b-4651-8dfe-45e9034057cd
f7b29815-45fa-46b2-99f0-77671aa71635	2024-11-26 14:47:28.193559	2024-11-26 14:47:28.193559	e889f730-827f-4285-bd6a-6ecc1f7d995d	62b4ba92-0209-41a2-bc01-885f1dc14dce
aa9d51d2-e28d-4f55-a70b-162073abd055	2024-12-26 10:46:42.223964	2024-12-26 10:46:42.223964	e889f730-827f-4285-bd6a-6ecc1f7d995d	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
\.


--
-- Data for Name: facultys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facultys (id, name) FROM stdin;
99f6b5b2-b0e5-4bc2-8c4e-bc7f5f6a8842	Fakultas Kedokteran (FK)
eb935226-da6b-45fa-8937-70f51454bde8	Fakultas Teknologi Industri (FTI)
f7c489af-c822-4717-8d7c-31d1096f1b55	Fakultas Hukum (FH)
fa5c9b65-855d-4453-a4eb-e6ed2673ece6	Fakultas Ilmu Agama Islam (FIAI)
bb845b33-71f1-4ab1-9a3c-2c06cd7a76f6	Fakultas Psikologi dan Ilmu Sosial Budaya (FPSB)
f311f5a6-208b-4925-951c-d88798478023	Fakultas Teknik Sipil dan Perencanaan (FTSP)
\.


--
-- Data for Name: kuisioners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kuisioners (id, title, "isActive", "createdAt", "updatedAt") FROM stdin;
3c94344f-7476-44e0-8a31-303c3f6b3bc3	TesKuisioner1	t	2024-10-04 17:32:42.557101	2024-10-04 17:32:42.557101
1667321d-25f3-43ba-b90c-cca473d127d0	Kuisioner Screening 1	t	2024-10-04 17:43:23.202213	2024-10-04 17:43:23.202213
\.


--
-- Data for Name: pre_kuisioner_answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pre_kuisioner_answer (id, answer, "createdAt", "updateAt", "preQuestionIdId") FROM stdin;
e0d080d7-2369-4380-aca0-99ce37553cae	Kedua orangtua masih ada dan hidup serumah	2024-11-10 13:34:15.683325	2024-11-10 13:34:15.683325	6ddadb6e-2103-4d46-807b-7257b44bc332
79ab58c7-06eb-40e0-8016-bcb379a8b31a	Kedua orangtua masih ada, tetapi bercerai	2024-11-10 13:34:15.683325	2024-11-10 13:34:15.683325	6ddadb6e-2103-4d46-807b-7257b44bc332
8010154c-afef-4fca-a7b5-e342d87ebb33	Ayah sudah meninggal	2024-11-10 13:34:15.683325	2024-11-10 13:34:15.683325	6ddadb6e-2103-4d46-807b-7257b44bc332
49b2c173-ea57-4ec9-b05b-06e0e6f380c6	Ibu sudah meninggal	2024-11-10 13:34:15.683325	2024-11-10 13:34:15.683325	6ddadb6e-2103-4d46-807b-7257b44bc332
b90adeb0-ed32-4610-8537-64092c716688	Kedua orangtua sudah meninggal	2024-11-10 13:34:15.683325	2024-11-10 13:34:15.683325	6ddadb6e-2103-4d46-807b-7257b44bc332
2595dd94-330d-48f3-8712-09b306920c8f	Kos/kontrakan	2024-11-10 13:37:43.190767	2024-11-10 13:37:43.190767	6ad26733-1024-4482-8caa-f83d3cc4317b
564e4330-ddc3-43be-92b1-95f88f548128	Tinggal bersama orangtua	2024-11-10 13:37:43.190767	2024-11-10 13:37:43.190767	6ad26733-1024-4482-8caa-f83d3cc4317b
92f613f4-1e47-413d-a71b-eb1c69d72b5f	Tinggal bersama wali/saudara	2024-11-10 13:37:43.190767	2024-11-10 13:37:43.190767	6ad26733-1024-4482-8caa-f83d3cc4317b
0b568e51-231b-4de1-bce9-cad07508c4d5	Lainnya	2024-11-10 13:37:43.190767	2024-11-10 13:37:43.190767	6ad26733-1024-4482-8caa-f83d3cc4317b
3cddc05e-d7b1-4aa0-97e4-aefbc54de4e9	Sangat mendukung saya	2024-11-10 13:38:24.710825	2024-11-10 13:38:24.710825	8408cb5c-0632-4909-8bd0-76c8855c6761
6fa64cba-8e33-4f21-ad1a-b8910c0cd1bb	Cukup mendukung saya	2024-11-10 13:38:24.710825	2024-11-10 13:38:24.710825	8408cb5c-0632-4909-8bd0-76c8855c6761
b95e7e82-5902-47bb-b0f9-ed6579e75835	Kurang mendukung saya	2024-11-10 13:38:24.710825	2024-11-10 13:38:24.710825	8408cb5c-0632-4909-8bd0-76c8855c6761
fbc74a28-5aa7-4731-98f7-835bf27a4c44	Tidak mendukung saya	2024-11-10 13:38:24.710825	2024-11-10 13:38:24.710825	8408cb5c-0632-4909-8bd0-76c8855c6761
b56639b6-6eaf-456d-8dbb-a48783e35d36	Ya	2024-11-10 14:49:52.827893	2024-11-10 14:49:52.827893	45981d6e-420b-4444-9a53-f0b20871c2d9
4e49451c-d907-4760-a915-48507be6125f	Tidak, saya bekerja sendiri	2024-11-10 14:49:52.827893	2024-11-10 14:49:52.827893	45981d6e-420b-4444-9a53-f0b20871c2d9
9c78d8ff-0ad8-4fbf-baf3-f62d12c022dc	Lainnya	2024-11-10 14:49:52.827893	2024-11-10 14:49:52.827893	45981d6e-420b-4444-9a53-f0b20871c2d9
e17e5b10-523f-41e9-8b51-fe72c7a8efb2	Uang bulanan/ penghasilan tidak menentu	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
5600ac15-1a3a-40de-9d9e-d47a3b22cc08	< 1 juta	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
707a34ef-dc8f-45d1-bfe5-029b03cfc89b	1 – 2 juta	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
66620cca-0b58-43d0-b069-0731bacb886d	2,1 – 3 juta	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
92585e7b-2ab8-4046-9ce7-80040d6c967c	3,1 – 4 juta	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
067826c1-4aa8-49b4-9bc2-a1df2e5e09fe	> 4 juta	2024-11-10 14:51:24.041499	2024-11-10 14:51:24.041499	a58602fa-779e-4b71-abc9-13e9b7aa2aee
61cbe538-9722-4d0a-9f16-30c7bc4ed689	Lebih dari cukup	2024-11-10 14:52:16.647723	2024-11-10 14:52:16.647723	4f55d51e-8eea-45fa-b4e4-937e3563d6fa
7b310d79-ae71-4ccc-800f-85a297ae35a0	Cukup	2024-11-10 14:52:16.647723	2024-11-10 14:52:16.647723	4f55d51e-8eea-45fa-b4e4-937e3563d6fa
3299eae7-e628-4a4f-8248-9ea8fbfdb2ab	Kurang	2024-11-10 14:52:16.647723	2024-11-10 14:52:16.647723	4f55d51e-8eea-45fa-b4e4-937e3563d6fa
2b36a789-03e1-41f4-b149-32d010522aa4	Kesulitan	2024-11-10 14:52:16.647723	2024-11-10 14:52:16.647723	4f55d51e-8eea-45fa-b4e4-937e3563d6fa
1ad88c21-1c1d-4261-983f-80387a4fa0a6	Ya	2024-11-10 20:36:26.357733	2024-11-10 20:36:26.357733	27965960-1c66-4cd5-b669-7e0977d29e42
4a0a21cf-31f1-4f2b-a8be-40089bfa17e2	Tidak	2024-11-10 20:36:26.357733	2024-11-10 20:36:26.357733	27965960-1c66-4cd5-b669-7e0977d29e42
bc1dddee-37ba-48c1-a649-be1a12a58d4f	Ya	2024-11-10 20:36:36.989971	2024-11-10 20:36:36.989971	94382b62-06f8-411f-9382-b2826d33dcaf
b22dab23-ddcd-4718-9fb3-dfebbe943af1	Tidak	2024-11-10 20:36:36.989971	2024-11-10 20:36:36.989971	94382b62-06f8-411f-9382-b2826d33dcaf
2003535b-2d42-4656-9326-bb54d2a511bb	Sehat, tidak ada keluhan	2024-11-10 20:37:27.137221	2024-11-10 20:37:27.137221	36be4e12-ec8a-4f91-b964-31619aecec28
bb85766c-2fea-4a09-9dc7-37800bc9eb37	Cukup sehat	2024-11-10 20:37:27.137221	2024-11-10 20:37:27.137221	36be4e12-ec8a-4f91-b964-31619aecec28
0ded37fb-9d47-457f-bca3-f78244b89a46	Kurang sehat	2024-11-10 20:37:27.137221	2024-11-10 20:37:27.137221	36be4e12-ec8a-4f91-b964-31619aecec28
081844b1-f2c4-4f71-af17-f217662f6437	Tidak sehat	2024-11-10 20:37:27.137221	2024-11-10 20:37:27.137221	36be4e12-ec8a-4f91-b964-31619aecec28
5715d6f2-e78e-4f74-a27c-6e2d19b19b0a	Orangtua	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
823cc82a-2f92-4f67-b40e-6af43deb0983	Saudara	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
52e9148b-7cf8-4033-a6cf-ecf6c7f0502a	Keluarga/kerabat lain	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
efc3e2fe-abc5-46fe-9005-0d967d9f8217	Teman dekat	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
f1c98193-fd7b-4a22-ae52-98430306d3d7	Tidak ada	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
571a1ad3-c91e-436b-8d5a-18760f0a56ba	Lainnya	2024-11-10 20:38:30.163395	2024-11-10 20:38:30.163395	5ae83a6e-72f5-4ea4-a3db-6bb1059d8493
a82200ed-e307-426c-8535-d3916bda7fc1	Ya	2024-11-10 20:39:16.232483	2024-11-10 20:39:16.232483	ed47afe2-11f5-4cd8-8bcf-8d1bd09ec6d1
cf81f04b-3f99-429c-83a6-0591b7e32012	Tidak	2024-11-10 20:39:16.232483	2024-11-10 20:39:16.232483	ed47afe2-11f5-4cd8-8bcf-8d1bd09ec6d1
3aea5cbc-8c78-433f-9501-6865241cd5c9	Ya	2024-11-10 20:39:28.053617	2024-11-10 20:39:28.053617	3d19d7c7-eaa5-4cd9-858c-706c377dec99
ee1e94fd-3721-4405-98ea-786e16f4a7bc	Tidak	2024-11-10 20:39:28.053617	2024-11-10 20:39:28.053617	3d19d7c7-eaa5-4cd9-858c-706c377dec99
4b1bab04-eefc-41b6-a08c-e0655ee52d5d	Ya	2024-11-10 20:39:35.909053	2024-11-10 20:39:35.909053	d8b420cf-af92-411a-aeb7-40c06df053dc
89812a1c-c8aa-4f73-8583-59de485a6b87	Tidak	2024-11-10 20:39:35.909053	2024-11-10 20:39:35.909053	d8b420cf-af92-411a-aeb7-40c06df053dc
e15a6873-6bd4-4fcd-9e49-b896c7932b0d	Ya	2024-11-10 20:39:46.375109	2024-11-10 20:39:46.375109	7e5cc8e0-0cc1-4b7d-b19e-c0a6c6739d08
ccaaa507-91e0-46d5-870f-8808da8d7f2f	Tidak	2024-11-10 20:39:46.375109	2024-11-10 20:39:46.375109	7e5cc8e0-0cc1-4b7d-b19e-c0a6c6739d08
\.


--
-- Data for Name: pre_kuisioner_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pre_kuisioner_category (id, name) FROM stdin;
88237acd-387e-4af0-bd13-561dec9ff639	Persepsi terhadap keluarga
9922444b-73da-4bf0-8b30-a5acdfeb1cc4	Persepsi terhadap kondisi finansial
3d037ee2-d746-4f6c-859f-7a26e0791d1b	Persepsi terhadap kondisi kesehatan
0c076252-4743-4523-868e-72a607dc9a45	Persepsi terhadap relasi orang di sekitar
\.


--
-- Data for Name: pre_kuisioner_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pre_kuisioner_question (id, question, "createdAt", "updateAt", "categoryId") FROM stdin;
6ddadb6e-2103-4d46-807b-7257b44bc332	Manakah kondisi orangtua Anda yang sesuai dengan keadaan Anda saat ini?	2024-11-10 13:34:15.633168	2024-11-10 13:34:15.633168	88237acd-387e-4af0-bd13-561dec9ff639
6ad26733-1024-4482-8caa-f83d3cc4317b	Manakah tempat tinggal yang sesuai dengan keadaan Anda saat ini?	2024-11-10 13:37:43.147106	2024-11-10 13:37:43.147106	88237acd-387e-4af0-bd13-561dec9ff639
8408cb5c-0632-4909-8bd0-76c8855c6761	Menurut Anda, sejauh mana tingkat dukungan keluarga terhadap diri Anda selama ini?	2024-11-10 13:38:24.687872	2024-11-10 13:38:24.687872	88237acd-387e-4af0-bd13-561dec9ff639
45981d6e-420b-4444-9a53-f0b20871c2d9	Apakah kebutuhan sehari-hari saat ini dibiayai orangtua atau wali Anda?	2024-11-10 14:49:52.75546	2024-11-10 14:49:52.75546	9922444b-73da-4bf0-8b30-a5acdfeb1cc4
a58602fa-779e-4b71-abc9-13e9b7aa2aee	Manakah uang bulanan atau penghasilan (jika Anda bekerja) berikut yang paling sesuai dengan keadaan Anda?	2024-11-10 14:51:24.014306	2024-11-10 14:51:24.014306	9922444b-73da-4bf0-8b30-a5acdfeb1cc4
4f55d51e-8eea-45fa-b4e4-937e3563d6fa	Menurut Anda, manakah kondisi finansial yang paling menggambarkan diri Anda saat ini?	2024-11-10 14:52:16.616495	2024-11-10 14:52:16.616495	9922444b-73da-4bf0-8b30-a5acdfeb1cc4
27965960-1c66-4cd5-b669-7e0977d29e42	Apakah Anda memiliki riwayat masalah kesehatan yang cukup berat?	2024-11-10 20:36:26.259726	2024-11-10 20:36:26.259726	3d037ee2-d746-4f6c-859f-7a26e0791d1b
94382b62-06f8-411f-9382-b2826d33dcaf	Apakah Anda pernah mengalami persoalan pribadi yang berat sehingga membutuhkan bantuan profesional seperti psikolog atau psikiater dalam 6 bulan terakhir ini?	2024-11-10 20:36:36.960378	2024-11-10 20:36:36.960378	3d037ee2-d746-4f6c-859f-7a26e0791d1b
36be4e12-ec8a-4f91-b964-31619aecec28	Menurut Anda, sejauh mana kondisi kesehatan Anda saat ini?	2024-11-10 20:37:27.112999	2024-11-10 20:37:27.112999	3d037ee2-d746-4f6c-859f-7a26e0791d1b
5ae83a6e-72f5-4ea4-a3db-6bb1059d8493	Pada saat Anda mengalami masalah yang berat atau serius, kepada siapa biasanya Anda mengadu atau curhat ?	2024-11-10 20:38:30.139888	2024-11-10 20:38:30.139888	3d037ee2-d746-4f6c-859f-7a26e0791d1b
ed47afe2-11f5-4cd8-8bcf-8d1bd09ec6d1	Apakah akhir-akhir ini Anda mengalami masalah yang cukup serius dengan orangtua?	2024-11-10 20:39:16.205228	2024-11-10 20:39:16.205228	0c076252-4743-4523-868e-72a607dc9a45
3d19d7c7-eaa5-4cd9-858c-706c377dec99	Apakah akhir-akhir ini Anda mengalami masalah yang cukup serius dengan saudara/kerabat dekat?	2024-11-10 20:39:28.029318	2024-11-10 20:39:28.029318	0c076252-4743-4523-868e-72a607dc9a45
d8b420cf-af92-411a-aeb7-40c06df053dc	Apakah akhir-akhir ini Anda mengalami masalah yang cukup serius dengan teman?	2024-11-10 20:39:35.890857	2024-11-10 20:39:35.890857	0c076252-4743-4523-868e-72a607dc9a45
7e5cc8e0-0cc1-4b7d-b19e-c0a6c6739d08	Apakah akhir-akhir ini Anda mengalami masalah yang cukup serius dengan dosen atau pihak kampus?	2024-11-10 20:39:46.350069	2024-11-10 20:39:46.350069	0c076252-4743-4523-868e-72a607dc9a45
\.


--
-- Data for Name: pre_kuisioner_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pre_kuisioner_user (id, "isFinish", "createdAt") FROM stdin;
2ce2c1e0-05b6-4139-9b9f-b817825e4721	f	2024-11-22 20:57:41.901614
99a32e09-004b-480d-a5eb-a5bec4a33083	t	2024-11-26 14:47:28.193559
80a92ade-79bc-4177-9012-6e7e3fc0f5ed	t	2024-11-10 21:15:39.047905
033fcf78-b3a3-4c81-b7a7-12b5896709b7	t	2024-12-26 10:46:42.223964
\.


--
-- Data for Name: pre_kuisioner_user_answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pre_kuisioner_user_answer (id, "preKuisionerUserId", "preKuisionerAnswerId") FROM stdin;
66b92e4f-ced8-43c1-8108-c681ee6628b8	033fcf78-b3a3-4c81-b7a7-12b5896709b7	e0d080d7-2369-4380-aca0-99ce37553cae
3adcc22e-dac6-418b-8f4d-060b80221519	033fcf78-b3a3-4c81-b7a7-12b5896709b7	2595dd94-330d-48f3-8712-09b306920c8f
a76ddd0a-05d1-4f44-a606-161a09b1e663	033fcf78-b3a3-4c81-b7a7-12b5896709b7	3cddc05e-d7b1-4aa0-97e4-aefbc54de4e9
9b987ef4-b709-40d9-ac8e-51971a93a062	033fcf78-b3a3-4c81-b7a7-12b5896709b7	b56639b6-6eaf-456d-8dbb-a48783e35d36
7bb2590a-4708-4348-aa49-83c2c8fd1057	033fcf78-b3a3-4c81-b7a7-12b5896709b7	92585e7b-2ab8-4046-9ce7-80040d6c967c
1e29d203-dd62-42b9-bafd-59fbf1b67cd3	033fcf78-b3a3-4c81-b7a7-12b5896709b7	7b310d79-ae71-4ccc-800f-85a297ae35a0
2af43318-aa75-433c-b551-152f167757fb	033fcf78-b3a3-4c81-b7a7-12b5896709b7	4a0a21cf-31f1-4f2b-a8be-40089bfa17e2
9aa3057e-f1c8-4997-9505-4849dfca6002	033fcf78-b3a3-4c81-b7a7-12b5896709b7	b22dab23-ddcd-4718-9fb3-dfebbe943af1
ff699b71-11dc-4dab-8072-7bb26c78b2ff	033fcf78-b3a3-4c81-b7a7-12b5896709b7	2003535b-2d42-4656-9326-bb54d2a511bb
d9607e97-4ab0-422c-a523-2a0b04b52194	033fcf78-b3a3-4c81-b7a7-12b5896709b7	5715d6f2-e78e-4f74-a27c-6e2d19b19b0a
503bcd5f-f033-4de2-9d9f-5227ec22f799	033fcf78-b3a3-4c81-b7a7-12b5896709b7	cf81f04b-3f99-429c-83a6-0591b7e32012
9e201b91-a6a8-418a-bc5a-c9da78f13b3a	033fcf78-b3a3-4c81-b7a7-12b5896709b7	ee1e94fd-3721-4405-98ea-786e16f4a7bc
40b78ed9-287d-4d2f-80e5-7d5df63c4e0c	033fcf78-b3a3-4c81-b7a7-12b5896709b7	89812a1c-c8aa-4f73-8583-59de485a6b87
7b3630c4-fdc4-412e-a0fa-a3efe352f5af	033fcf78-b3a3-4c81-b7a7-12b5896709b7	ccaaa507-91e0-46d5-870f-8808da8d7f2f
f76ab86a-99f3-4268-83ec-cccc551fee6f	99a32e09-004b-480d-a5eb-a5bec4a33083	e0d080d7-2369-4380-aca0-99ce37553cae
d3848b99-b4e3-428a-a7df-275736d3c0a4	99a32e09-004b-480d-a5eb-a5bec4a33083	0b568e51-231b-4de1-bce9-cad07508c4d5
877da27b-4f14-410b-bade-345f90785df6	99a32e09-004b-480d-a5eb-a5bec4a33083	b95e7e82-5902-47bb-b0f9-ed6579e75835
9df7ea5a-44d0-45d4-a07b-d5347123a578	99a32e09-004b-480d-a5eb-a5bec4a33083	4e49451c-d907-4760-a915-48507be6125f
11367fbc-6f0f-45af-9daf-83bfb56a84ec	99a32e09-004b-480d-a5eb-a5bec4a33083	707a34ef-dc8f-45d1-bfe5-029b03cfc89b
026bc574-9ac3-49a9-adfc-15c353dd2c80	99a32e09-004b-480d-a5eb-a5bec4a33083	3299eae7-e628-4a4f-8248-9ea8fbfdb2ab
51e6d8ce-c582-4151-b57c-e92183401470	99a32e09-004b-480d-a5eb-a5bec4a33083	4a0a21cf-31f1-4f2b-a8be-40089bfa17e2
46fbeeb8-bc0d-4fe0-a21f-6a8cfd67eefa	99a32e09-004b-480d-a5eb-a5bec4a33083	bc1dddee-37ba-48c1-a649-be1a12a58d4f
a2396077-7447-42f8-a07c-7f7bbe46c1b0	99a32e09-004b-480d-a5eb-a5bec4a33083	2003535b-2d42-4656-9326-bb54d2a511bb
99503cb1-b1d0-4e4f-a073-db2f48a092ce	99a32e09-004b-480d-a5eb-a5bec4a33083	52e9148b-7cf8-4033-a6cf-ecf6c7f0502a
55223556-a1c0-49dc-9690-27c5ca296956	99a32e09-004b-480d-a5eb-a5bec4a33083	cf81f04b-3f99-429c-83a6-0591b7e32012
fb0ca66a-e599-4bad-b121-a985fb357dc8	99a32e09-004b-480d-a5eb-a5bec4a33083	ee1e94fd-3721-4405-98ea-786e16f4a7bc
2961a4bb-0629-4da9-8006-445ae999f481	99a32e09-004b-480d-a5eb-a5bec4a33083	89812a1c-c8aa-4f73-8583-59de485a6b87
e03499a2-1409-42cb-a7f4-e239bf52eb73	99a32e09-004b-480d-a5eb-a5bec4a33083	e15a6873-6bd4-4fcd-9e49-b896c7932b0d
1324689a-9e4c-4932-8245-b852a6327ed7	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	79ab58c7-06eb-40e0-8016-bcb379a8b31a
6bec2146-d2f9-47e5-b885-8a9c95856b4d	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	2595dd94-330d-48f3-8712-09b306920c8f
8405f289-bb5e-45e1-aba6-eb6ff37962e2	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	6fa64cba-8e33-4f21-ad1a-b8910c0cd1bb
77560dfe-2cbf-4108-be97-c6baa8f2b476	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	4e49451c-d907-4760-a915-48507be6125f
e564e3c4-a847-47ee-8dd6-29e98f353677	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	e17e5b10-523f-41e9-8b51-fe72c7a8efb2
6f2399e3-516d-4c15-b762-744f6680e313	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	61cbe538-9722-4d0a-9f16-30c7bc4ed689
929405fb-3f90-42de-ac28-474754066da8	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	4a0a21cf-31f1-4f2b-a8be-40089bfa17e2
a029682f-438f-46aa-bc99-011435286f71	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	bc1dddee-37ba-48c1-a649-be1a12a58d4f
fd782aa5-d756-44a4-945e-504d824df9c3	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	0ded37fb-9d47-457f-bca3-f78244b89a46
a0cef8cd-78bb-4d4e-8e7d-7a1f71762c08	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	5715d6f2-e78e-4f74-a27c-6e2d19b19b0a
dc216a43-c797-46a5-8b2d-afc0a2fef4a2	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	cf81f04b-3f99-429c-83a6-0591b7e32012
b9a822b2-666c-48d9-b3e7-bddd5003191a	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	3aea5cbc-8c78-433f-9501-6865241cd5c9
6fb28911-039d-4ad8-b3d1-cea62ae59f59	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	89812a1c-c8aa-4f73-8583-59de485a6b87
ca2d26d1-4215-42c8-824f-0d92a87474b6	80a92ade-79bc-4177-9012-6e7e3fc0f5ed	e15a6873-6bd4-4fcd-9e49-b896c7932b0d
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, question, "createdAt", "updatedAt", "subKuisionerIdId") FROM stdin;
5fd5ab32-a4d5-435a-9507-e4789c359436	Menyibukkan diri dengan smartphone adalah cara untuk mengubah suasana hati saya 	2024-11-01 19:48:25.366188	2024-11-01 19:48:25.366188	4964861f-962a-416f-b2a0-6a0c93adea91
b10bf59e-921c-4e5d-bdfa-0aeed50e2072	Saya menghabiskan waktu terus-menerus hanya untuk bermain smartphone 	2024-11-01 19:48:34.999383	2024-11-01 19:48:34.999383	4964861f-962a-416f-b2a0-6a0c93adea91
36d7938a-7c2e-48e2-a99d-608259dc3475	Ketika saya tidak dapat menggunakan smartphone saat ingin, saya merasa sedih	2024-11-01 19:48:51.827258	2024-11-01 19:48:51.827258	4964861f-962a-416f-b2a0-6a0c93adea91
de7716e9-894a-443c-9f7c-830ab7e0acdf	Jika saya mencoba mengurangi waktu menggunakan smartphone, saya semakin menggunakannya lebih lama atau lebih sering dari sebelumnya	2024-11-01 19:49:01.581623	2024-11-01 19:49:01.581623	4964861f-962a-416f-b2a0-6a0c93adea91
673570f0-32cb-4002-b50b-496ca18e4047	Test Question	2024-10-16 18:16:10.292342	2025-01-05 19:19:44.528719	cd191bdd-8fea-4d6a-81b5-380de93cad59
e25698f9-143a-422a-9732-95f545082e6d	Saya merasa sulit untuk beristirahat.	2024-10-16 18:14:51.333493	2024-10-16 18:14:51.333493	cd191bdd-8fea-4d6a-81b5-380de93cad59
f30be436-3c81-4ed3-9f40-79a608304a5f	Saya cenderung menunjukkan reaksi berlebihan terhadap suatu situasi.	2024-10-16 18:15:13.301271	2024-10-16 18:15:13.301271	cd191bdd-8fea-4d6a-81b5-380de93cad59
aba6462a-d11b-496f-a930-7dea1d288429	Saya merasa energi saya terkuras karena terlalu cemas.	2024-10-16 18:15:25.10598	2024-10-16 18:15:25.10598	cd191bdd-8fea-4d6a-81b5-380de93cad59
30924def-0dd1-4a4a-b603-5f8eebcceb70	Saya merasa gelisah.	2024-10-16 18:15:33.392361	2024-10-16 18:15:33.392361	cd191bdd-8fea-4d6a-81b5-380de93cad59
7667e7db-1f79-48c9-a176-bbe9d773781e	Saya merasa sulit untuk merasa tenang.	2024-10-16 18:15:43.889965	2024-10-16 18:15:43.889965	cd191bdd-8fea-4d6a-81b5-380de93cad59
b536f518-186f-494c-82b9-b7ec4686e714	Saya sulit untuk bersabar dalam menghadapi gangguan yang terjadi ketika sedang melakukan sesuatu.	2024-10-16 18:16:00.2936	2024-10-16 18:16:00.2936	cd191bdd-8fea-4d6a-81b5-380de93cad59
9f997851-c784-4fea-8928-cf13baf669e4	Saya merasa rongga mulut saya kering.	2024-10-16 18:18:28.15009	2024-10-16 18:18:28.15009	47a65933-fe35-41e9-9610-c55805c92b93
ed9ed04d-aae5-45f1-88ca-a716fec1454e	Saya merasa kesulitan bernafas (misalnya seringkali terengah-engah atau tidak dapat bernapas padahal tidak melakukan aktivitas fisik sebelumnya).	2024-10-16 18:18:50.841694	2024-10-16 18:18:50.841694	47a65933-fe35-41e9-9610-c55805c92b93
8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb	Saya merasa gemetar (misalnya pada tangan).	2024-10-16 18:19:03.101898	2024-10-16 18:19:03.101898	47a65933-fe35-41e9-9610-c55805c92b93
9580539a-9643-4ee5-8008-c2caf10fd661	Saya merasa khawatir dengan situasi dimana saya mungkin menjadi panik dan mempermalukan diri sendiri.	2024-10-16 18:19:16.552386	2024-10-16 18:19:16.552386	47a65933-fe35-41e9-9610-c55805c92b93
970d537c-edd4-4cb9-815a-170694527754	Saya merasa hampir panik.	2024-10-16 18:19:25.9531	2024-10-16 18:19:25.9531	47a65933-fe35-41e9-9610-c55805c92b93
8b56b1da-d0e0-4aba-b04f-d37855c01594	Saya menyadari kondisi jantung saya (seperti meningkatnya atau melemahnya detak jantung) meskipun sedang tidak melakukan aktivitas fisik.	2024-10-16 18:19:42.243747	2024-10-16 18:19:42.243747	47a65933-fe35-41e9-9610-c55805c92b93
650707f9-f62f-452d-bfff-2abbd6337bb0	Saya merasa ketakutan tanpa alasan yang jelas.	2024-10-16 18:20:00.017739	2024-10-16 18:20:00.017739	47a65933-fe35-41e9-9610-c55805c92b93
51ee586e-6333-4d9d-a961-071a9ac4e1f7	Saya sama sekali tidak dapat merasakan perasaan positif (contoh: merasa gembira, bangga, dsb).	2024-10-16 18:25:34.55453	2024-10-16 18:25:34.55453	22fb61dd-f54d-4bec-bb98-26d90f94d16b
3b89d150-a078-486a-a107-e1843db6db6e	Saya merasa sulit berinisiatif melakukan sesuatu.	2024-10-16 18:25:43.546343	2024-10-16 18:25:43.546343	22fb61dd-f54d-4bec-bb98-26d90f94d16b
93d681f6-75a7-413b-9005-b1249d27210a	Saya merasa tidak ada lagi yang bisa saya harapkan.	2024-10-16 18:25:53.086279	2024-10-16 18:25:53.086279	22fb61dd-f54d-4bec-bb98-26d90f94d16b
e573d43b-6495-4b1e-9f94-7a9d062b481a	Saya merasa sedih dan tertekan.	2024-10-16 18:26:01.864186	2024-10-16 18:26:01.864186	22fb61dd-f54d-4bec-bb98-26d90f94d16b
04e07acf-f306-4ec5-8548-dff939fbba6e	Saya tidak bisa merasa antusias terhadap hal apapun.	2024-10-16 18:26:21.887918	2024-10-16 18:26:21.887918	22fb61dd-f54d-4bec-bb98-26d90f94d16b
aae60c45-876c-4634-98db-421b06751ac9	Saya merasa diri saya tidak berharga.	2024-10-16 18:26:30.100978	2024-10-16 18:26:30.100978	22fb61dd-f54d-4bec-bb98-26d90f94d16b
310a3ea6-2196-4e58-8f1c-5016d750d663	Saya merasa hidup ini tidak berarti.	2024-10-16 18:26:37.972583	2024-10-16 18:26:37.972583	22fb61dd-f54d-4bec-bb98-26d90f94d16b
6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5	Saya menunda tugas hingga detik-detik terakhir 	2024-11-01 19:45:06.860722	2024-11-01 19:45:06.860722	744f79d7-2692-422c-9d63-b24cec2f8d6b
26bfbde5-b833-4264-aa9e-63e8a077dfd5	Saya tahu bahwa saya harus mengerjakan tugas kuliah, namun saya tidak melakukannya  	2024-11-01 19:45:19.009721	2024-11-01 19:45:19.009721	744f79d7-2692-422c-9d63-b24cec2f8d6b
8ba5fcf1-e420-4147-8398-3f18c57b4f1d	Saya tergoda untuk melakukan kegiatan lain yang lebih menyenangkan ketika seharusnya mengerjakan tugas kuliah 	2024-11-01 19:45:35.560736	2024-11-01 19:45:35.560736	744f79d7-2692-422c-9d63-b24cec2f8d6b
b58a1c58-369f-4c0c-9201-3a5921171675	Ketika diberi tugas, saya biasanya membiarkan dan tidak mengerjakannya hingga mendekati waktu pengumpulan tugas	2024-11-01 19:45:50.825956	2024-11-01 19:45:50.825956	744f79d7-2692-422c-9d63-b24cec2f8d6b
dd485669-4209-44f8-b21b-85751223d073	Saya sering menunda deadline pengerjaan tugas yang penting 	2024-11-01 19:46:04.849535	2024-11-01 19:46:04.849535	744f79d7-2692-422c-9d63-b24cec2f8d6b
687d550f-7c64-439c-b88f-598d55f29f06	Smartphone adalah hal terpenting dalam hidup saya 	2024-11-01 19:47:57.865295	2024-11-01 19:47:57.865295	4964861f-962a-416f-b2a0-6a0c93adea91
d3308666-6dee-4ff5-893f-af9e72504f9f	Aktivitas saya menggunakan smartphone menyebabkan konflik adalah hal terpenting dalam hidup saya 	2024-11-01 19:48:11.126567	2024-11-01 19:48:11.126567	4964861f-962a-416f-b2a0-6a0c93adea91
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
38d3223a-1260-42bf-a317-67bed6eba681	SUPERADMIN
ef95c08f-856e-49cc-a75a-0ac928b4abcd	ADMIN
76e175bf-25d3-4ab6-83fd-5b6e60e39352	USER
\.


--
-- Data for Name: subkuisioners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subkuisioners (id, title, "createdAt", "updatedAt", "symtompIdId", "kuisionerIdId") FROM stdin;
fe2fd347-14c8-408c-981f-0410e68007f6	SubKuisioner Depresi	2024-10-04 17:44:13.287357	2024-10-04 17:44:13.287357	\N	\N
d0898fec-c1fd-4f88-b87d-3cc51281f796	SubKuisioner Stress	2024-10-04 17:44:43.78784	2024-10-04 17:44:43.78784	\N	\N
cd191bdd-8fea-4d6a-81b5-380de93cad59	SubKuisioner Stress	2024-10-04 19:12:53.351428	2024-10-04 19:12:53.351428	d1401692-5909-41fb-9c4c-b5d2a601c292	1667321d-25f3-43ba-b90c-cca473d127d0
47a65933-fe35-41e9-9610-c55805c92b93	SubKuisioner Kecemasan	2024-10-04 20:07:06.846994	2024-10-04 20:07:06.846994	b549f59f-5f6c-4854-ae82-cef186c15b4f	1667321d-25f3-43ba-b90c-cca473d127d0
22fb61dd-f54d-4bec-bb98-26d90f94d16b	SubKuisioner Depresi	2024-10-16 18:09:08.223513	2024-10-16 18:09:08.223513	52801a1d-32e6-49d8-bed4-162374630e46	1667321d-25f3-43ba-b90c-cca473d127d0
744f79d7-2692-422c-9d63-b24cec2f8d6b	SubKuisioner Prokrastinasi	2024-10-16 18:09:51.779069	2024-10-16 18:09:51.779069	ff065e0a-eddf-4416-b82a-f4666b2e0a1c	1667321d-25f3-43ba-b90c-cca473d127d0
4964861f-962a-416f-b2a0-6a0c93adea91	SubKuisioner Kecanduan Ponsel	2024-10-16 18:10:18.529093	2024-10-16 18:10:18.529093	c4deb597-856f-4a9d-b23d-3d88658341d1	1667321d-25f3-43ba-b90c-cca473d127d0
\.


--
-- Data for Name: summary_kuisioner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.summary_kuisioner (id, sumarize, "kuisionerFinished", "createdAt", user_id) FROM stdin;
bd97a47d-ab28-44b2-936b-3463b908746c	**Ringkasan Hasil Kuisioner dan Analisis Gejala**\n\n**Jumlah Responden dan Hasil Isian:**\n- Total Responden: 2\n- Kuisioner yang digunakan: Kuisioner Screening 1\n\n**Gejala dengan Tingkat Keparahan Tertinggi:**\n1. **Depresi, Kecemasan, dan Stress**:\n   - Responden 1 menunjukkan tingkat keparahan yang sangat tinggi untuk ketiga gejala tersebut.\n   \n2. **Prokrastinasi**:\n   - Responden 1 mengalami prokrastinasi dengan tingkat keparahan tinggi.\n   - Responden 2 menunjukkan tingkat keparahan yang sangat tinggi.\n\n3. **Kecanduan Ponsel**:\n   - Responden 1 memiliki tingkat keparahan sangat tinggi.\n   - Responden 2 memiliki tingkat keparahan sangat rendah.\n\n**Pola Umum Gejala dan Prevalensi:**\n- **Prokrastinasi** dan **Kecanduan Ponsel** muncul pada kedua responden dengan tingkat keparahan yang bervariasi. Prokrastinasi cenderung lebih parah dibandingkan kecanduan ponsel.\n- Gejala **Depresi, Kecemasan, dan Stress** memiliki tingkat keparahan yang sangat tinggi pada satu responden, menunjukkan adanya pola yang konsisten dari gejala-gejala yang saling berkaitan.\n\n**Temuan Utama dan Rekomendasi:**\n- Gejala **Depresi, Kecemasan, dan Stress** dengan tingkat keparahan sangat tinggi pada satu responden memerlukan penanganan segera. Diperlukan pendekatan intervensi yang terarah untuk mengatasi gejala-gejala ini secara efektif.\n- **Prokrastinasi** menonjol sebagai gejala umum dengan tingkat keparahan tinggi/sangat tinggi, menunjukkan kebutuhan akan strategi manajemen waktu dan peningkatan produktivitas bagi responden.\n- **Kecanduan Ponsel** menunjukkan tingkat keparahan yang sangat tinggi pada satu responden, mengindikasikan perlunya strategi pengurangan penggunaan ponsel yang lebih baik, meskipun pada responden lain gejala ini rendah.\n\n**Kesimpulan:**\nPengumpulan data ini mengungkapkan bahwa perhatian khusus perlu diberikan pada gejala depresi, kecemasan, stress, dan prokrastinasi. Intervensi dini dan dukungan profesional dapat membantu mengurangi dampak dari gejala-gejala ini. Memahami pola gejala ini memungkinkan pemangku kepentingan untuk merancang program penanganan yang lebih efektif dan disesuaikan dengan kebutuhan masing-masing individu.	2	2025-01-05 18:31:57.381463	4aeefde1-ab5f-4129-bde2-9feace8e9315
9601d1c5-0e6c-4ac7-b534-8ed11b8671c0	Ringkasan Hasil Kuisioner Gejala Stress, Depresi, Prokrastinasi, Kecanduan Ponsel, dan Kecemasan:\n\n1. **Jumlah Responden:**\n   - Total responden yang mengisi kuisioner adalah 2 orang.\n\n2. **Gejala dengan Tingkat Keparahan Tertinggi:**\n   - Gejala yang menunjukkan tingkat keparahan tertinggi dan konsisten di antara para responden adalah Prokrastinasi, di mana satu responden melaporkan tingkat keparahan "very high".\n   - Kecanduan ponsel bervariasi, dengan satu responden mengalami tingkat keparahan "very high" dan yang lainnya "very low".\n\n3. **Pola Umum Gejala:**\n   - Gejala Depresi, Kecemasan, dan Stress menunjukkan tingkat keparahan "very high" pada responden pertama, menunjukkan bahwa ketiga gejala ini sering muncul secara bersamaan dalam kasus tersebut.\n   - Prokrastinasi juga muncul dengan tingkat keparahan "high" pada responden pertama dan "very high" pada responden kedua, menunjukkan bahwa ini adalah gejala yang umum dan signifikan di antara para responden.\n\n4. **Analisis dan Temuan Utama:**\n   - Ada indikasi kuat bahwa Depresi, Kecemasan, dan Stress sering terjadi bersamaan dengan tingkat keparahan yang tinggi. Ini mengisyaratkan perlunya perhatian khusus pada interaksi dan dampak kumulatif dari ketiga gejala ini.\n   - Prokrastinasi tampaknya menjadi masalah yang signifikan dengan tingkat keparahan tinggi, menunjukkan kebutuhan untuk intervensi yang lebih fokus untuk mengatasi perilaku ini.\n   - Variabilitas dalam kecanduan ponsel menunjukkan bahwa meskipun ini adalah masalah bagi beberapa individu, tingkat keparahannya tidak konsisten di antara para responden.\n\n5. **Kesimpulan dan Rekomendasi:**\n   - Pemangku kepentingan disarankan untuk mempertimbangkan intervensi terpadu yang menargetkan Depresi, Kecemasan, dan Stress secara bersamaan, mengingat tingginya tingkat keparahan dan frekuensi gejala ini.\n   - Program atau strategi untuk mengatasi Prokrastinasi perlu dikembangkan, mengingat prevalensinya yang tinggi dan dampaknya terhadap produktivitas.\n   - Variabilitas dalam kecanduan ponsel menunjukkan perlunya pendekatan yang lebih individual dalam menangani masalah ini.\n\nRingkasan ini memberikan gambaran yang jelas dan terfokus untuk mendukung pengambilan keputusan strategis dalam mengidentifikasi dan menangani gejala-gejala psikologis yang signifikan di antara para responden.	2	2025-01-05 18:56:05.041371	e889f730-827f-4285-bd6a-6ecc1f7d995d
\.


--
-- Data for Name: symtomps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.symtomps (id, name) FROM stdin;
52801a1d-32e6-49d8-bed4-162374630e46	Depresi
d1401692-5909-41fb-9c4c-b5d2a601c292	Stress
ff065e0a-eddf-4416-b82a-f4666b2e0a1c	Prokrastinasi
b549f59f-5f6c-4854-ae82-cef186c15b4f	Kecemasan
c4deb597-856f-4a9d-b23d-3d88658341d1	Kecanduan Ponsel
\.


--
-- Data for Name: take_kuisioner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.take_kuisioner (id, "isFinish", report, "createdAt", "kuisionerId", "userId") FROM stdin;
e3da5d0a-06fe-48ca-bd4f-b9fe41459e87	f	\N	2024-10-22 15:21:27.573551	1667321d-25f3-43ba-b90c-cca473d127d0	2f0822f5-1ed5-4ecc-8e9c-93491dc93d04
4deeb939-3752-4b49-b56e-3812103da357	f		2024-10-24 18:30:32.90965	1667321d-25f3-43ba-b90c-cca473d127d0	26d52cc3-f2e0-4be1-8cd8-ca2a193a242a
a92073af-8017-4f07-98f2-8b02e2e37314	f		2024-10-24 18:40:41.505561	1667321d-25f3-43ba-b90c-cca473d127d0	26d52cc3-f2e0-4be1-8cd8-ca2a193a242a
4d58c012-ae63-42a2-a30c-83117c33f129	f		2024-10-24 18:54:06.62386	1667321d-25f3-43ba-b90c-cca473d127d0	f8997945-4110-495e-813b-f0ee1049fefb
966368b0-883b-4103-a9ff-1c65d5081157	t	#### Depresi\nDepresi dengan skor 28 (kategori sangat tinggi) menunjukkan bahwa individu mungkin mengalami gejala serius seperti perasaan putus asa, hilangnya minat dalam aktivitas yang sebelumnya menyenangkan, dan mungkin juga memiliki pandangan yang sangat negatif terhadap diri sendiri dan masa depan. Dampak dari depresi ini bisa sangat luas, termasuk penurunan motivasi belajar, kesulitan dalam berinteraksi sosial, dan penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani, depresi bisa berkembang menjadi kondisi yang lebih parah, seperti gangguan depresi berat. Disarankan agar individu segera berkonsultasi dengan profesional kesehatan mental untuk mendapatkan terapi yang tepat, seperti terapi kognitif perilaku, serta mempertimbangkan aktivitas yang mendukung kesejahteraan mental seperti meditasi, olahraga ringan, dan kegiatan yang dapat meningkatkan suasana hati.\n\n#### Kecemasan\nKecemasan dengan skor 30 (kategori sangat tinggi) menandakan bahwa individu mungkin sering mengalami rasa takut atau khawatir berlebihan yang tidak proporsional terhadap situasi yang dihadapi. Gejala ini dapat memengaruhi kemampuan untuk berkonsentrasi, menyebabkan gangguan tidur, dan menimbulkan kelelahan mental serta fisik. Untuk mengatasi kecemasan ini, penting untuk mempelajari teknik relaksasi seperti pernapasan dalam atau meditasi mindfulness. Konseling atau psikoterapi juga dianjurkan untuk membantu individu memahami dan mengatasi akar penyebab kecemasan mereka.\n\n#### Stres\nStres dengan skor 26 (kategori tinggi) menunjukkan bahwa individu mengalami tekanan emosional yang signifikan. Hal ini dapat memengaruhi kesejahteraan mental dan fisik, seperti kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas harian. Tingkat stres yang tinggi ini dapat memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan individu untuk berfungsi secara efektif dalam konteks akademik dan sosial. Penting untuk mengidentifikasi sumber stres dan mengembangkan strategi untuk mengelola stres, seperti melalui manajemen waktu yang lebih baik, dan mencari dukungan dari orang-orang terdekat atau profesional.\n\n#### Prokrastinasi\nProkrastinasi dengan skor 17 (kategori menengah) menunjukkan kecenderungan untuk menunda-nunda pekerjaan, yang dapat mengakibatkan peningkatan stres dan kecemasan. Penundaan ini sering kali disebabkan oleh ketakutan akan kegagalan atau ketidakmampuan untuk memulai tugas. Kebiasaan ini bisa memicu siklus negatif di mana tugas yang belum terselesaikan menjadi sumber tekanan tambahan, mengurangi produktivitas dan kualitas hasil akademik. Direkomendasikan untuk menetapkan tujuan yang realistis, membuat jadwal yang terstruktur, dan menggunakan teknik manajemen waktu untuk mengurangi prokrastinasi.\n\n#### Kecanduan Ponsel\nKecanduan ponsel dengan skor 24 (kategori tinggi) mengindikasikan bahwa individu mungkin menghabiskan terlalu banyak waktu dengan perangkat ini, yang dapat mengganggu waktu produktif, mengurangi efisiensi belajar, dan memengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting. Disarankan untuk menetapkan batasan waktu penggunaan ponsel, memanfaatkan aplikasi pengatur waktu atau pemblokir situs, dan mencari kegiatan alternatif yang lebih bermanfaat.\n\n#### Kesimpulan\nSecara keseluruhan, kondisi mental yang dialami oleh individu ini menunjukkan perlunya intervensi menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Penting untuk segera mendapatkan bantuan profesional untuk mengatasi gejala depresi dan kecemasan yang sangat tinggi, serta mengimplementasikan langkah-langkah praktis untuk mengurangi stres dan mengatasi prokrastinasi serta kecanduan ponsel. Dukungan dari keluarga dan orang-orang terdekat juga dapat memberikan pengaruh positif dalam proses pemulihan.	2024-11-26 17:56:55.895785	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
2530cd77-e805-4689-9099-b605cb73249d	t	\N	2024-11-01 20:09:53.148536	1667321d-25f3-43ba-b90c-cca473d127d0	da50cf79-ee3b-4651-8dfe-45e9034057cd
9323f6fd-06c4-465a-877b-019255525458	f	\N	2024-11-26 15:05:46.966012	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
19c97519-65a8-4af9-8ff8-89f7e77bd402	f	\N	2024-11-26 16:45:49.695285	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
3bdbaa33-026e-4676-93c2-ce20ffca58d7	f	\N	2024-11-26 16:49:29.258494	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
326e3a38-4a13-488b-88da-ba31a7be0ce3	f	\N	2024-11-26 16:55:40.67872	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
03cbe549-0cac-43a1-b35c-de9487250b5f	t	Laporan Analisis Psikologis\n\nStress dengan skor 34 (kategori sangat tinggi) menunjukkan bahwa klien mengalami tekanan emosional yang signifikan. Dalam hal ini, stres dapat berdampak serius pada kesejahteraan mental dan fisik klien. Dampaknya termasuk kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas sehari-hari. Tingginya tingkat stres ini juga berpotensi memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan klien untuk berfungsi secara efektif dalam konteks akademik dan sosial. Mengingat klien merasa kurang didukung oleh keluarga, penting untuk mencari sumber dukungan lain, seperti teman atau konselor profesional, untuk membantu mengelola stres ini.\n\nKecemasan dengan skor 28 (kategori sangat tinggi) menandakan bahwa klien mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan. Gejala kecemasan ini dapat mengganggu keseharian klien, menyebabkan gangguan tidur, kesulitan berkonsentrasi, serta meningkatnya kelelahan mental dan fisik. Selain itu, kecemasan yang tinggi ini dapat mengganggu interaksi sosial dan kemampuan klien untuk menghadapi situasi akademik atau sosial yang menantang. Disarankan agar klien mempertimbangkan untuk mengikuti sesi konseling untuk belajar teknik relaksasi dan manajemen kecemasan.\n\nDepresi dengan skor 38 (kategori sangat tinggi) menunjukkan bahwa klien mungkin mengalami perasaan putus asa, hilangnya minat dalam aktivitas sehari-hari, atau perasaan rendah diri. Jika tidak ditangani dengan baik, depresi ini dapat berdampak pada penurunan motivasi belajar, kesulitan berinteraksi sosial, serta kualitas hidup secara keseluruhan. Depresi yang berlangsung lama juga bisa menyebabkan penurunan performa akademik dan isolasi sosial. Mengingat klien pernah mengalami persoalan pribadi yang berat dan membutuhkan bantuan profesional, penting untuk melanjutkan dukungan tersebut untuk mengatasi gejala depresi.\n\nProkrastinasi dengan skor 19 (kategori tinggi) menunjukkan adanya kecenderungan klien untuk menunda-nunda penyelesaian tugas. Kebiasaan ini dapat meningkatkan stres dan kecemasan, terutama ketika tugas-tugas yang belum terselesaikan menumpuk. Prokrastinasi juga dapat mengurangi produktivitas dan kualitas hasil akademik. Disarankan agar klien mengembangkan strategi manajemen waktu yang efektif, seperti membuat jadwal harian atau memecah tugas besar menjadi bagian-bagian yang lebih kecil dan dapat dikelola.\n\nKecanduan ponsel dengan skor 28 (kategori tinggi) menunjukkan bahwa penggunaan ponsel yang berlebihan dapat mengganggu waktu produktif klien, mengurangi efisiensi belajar, serta memengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting, dan pada akhirnya meningkatkan tingkat stres. Disarankan agar klien mencoba untuk membatasi waktu penggunaan ponsel, mungkin dengan menetapkan waktu tertentu dalam sehari untuk mengecek media sosial atau bermain game.\n\nSecara keseluruhan, kondisi mental yang dialami oleh klien memerlukan perhatian dan intervensi segera untuk menghindari dampak negatif pada perkembangan akademik dan kesejahteraan emosional. Disarankan untuk melakukan intervensi melalui konseling psikologis, pelatihan manajemen waktu, serta strategi coping untuk mengurangi dampak negatif dari kecemasan, stres, dan prokrastinasi. Pendampingan yang tepat dapat membantu klien mengembangkan keterampilan untuk menghadapi tantangan akademik dan emosional dengan lebih adaptif.	2024-11-26 16:56:03.489777	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
204727c7-df90-4849-ba43-1197776f6a98	t	Analisis Psikologis Berdasarkan Kuesioner\n\nPersepsi terhadap Keluarga\nDari data yang Anda berikan, terlihat bahwa meskipun kedua orangtua Anda masih ada dan tinggal serumah, Anda merasa bahwa dukungan keluarga terhadap Anda kurang memadai. Kurangnya dukungan keluarga dapat berpengaruh terhadap rasa percaya diri dan kesejahteraan emosional Anda. Dukungan keluarga yang minim bisa menyebabkan perasaan terisolasi dan kurangnya rasa aman. Dalam situasi ini, penting untuk mencoba berkomunikasi secara terbuka dengan anggota keluarga atau mencari dukungan dari kerabat lainnya yang Anda percayai. Jika komunikasi langsung sulit dilakukan, pertimbangkan untuk melibatkan mediator seperti konselor keluarga yang dapat membantu memperbaiki dinamika dalam keluarga.\n\nPersepsi terhadap Kondisi Finansial\nAnda mengungkapkan bahwa Anda mendanai kebutuhan sehari-hari Anda sendiri dengan penghasilan bulanan berkisar antara 1 hingga 2 juta rupiah, yang Anda nilai sebagai kondisi finansial yang kurang. Kondisi finansial yang dianggap kurang dapat menimbulkan stres tambahan, terutama jika Anda merasa tertekan untuk memenuhi kebutuhan hidup dengan penghasilan yang terbatas. Untuk mengatasi hal ini, Anda mungkin perlu merencanakan anggaran yang lebih ketat, mencari peluang untuk meningkatkan pendapatan, atau mencari nasihat keuangan dari profesional. Dukungan dari komunitas atau lembaga sosial juga bisa menjadi solusi sementara untuk meringankan beban finansial.\n\nPersepsi terhadap Kondisi Kesehatan\nMeskipun Anda menilai diri Anda dalam keadaan sehat tanpa keluhan, Anda pernah mengalami persoalan pribadi yang berat dan membutuhkan bantuan profesional dalam enam bulan terakhir. Ini menunjukkan bahwa meskipun kondisi kesehatan fisik Anda baik, ada tantangan emosional yang signifikan. Mencari bantuan dari psikolog atau psikiater adalah langkah yang tepat untuk menangani masalah emosional ini. Menjaga kesehatan mental sama pentingnya dengan kesehatan fisik, dan pastikan Anda terus memantau kesejahteraan emosional Anda serta mencari dukungan bila diperlukan.\n\nPersepsi terhadap Relasi Orang di Sekitar\nAnda tidak mengalami masalah serius dengan orangtua, saudara, atau teman, namun ada masalah dengan dosen atau pihak kampus. Masalah dalam konteks pendidikan dapat memengaruhi motivasi belajar dan kinerja akademik Anda. Penting untuk mengidentifikasi sumber masalah dan mencari solusi yang konstruktif, seperti berdiskusi langsung dengan pihak terkait atau mencari dukungan dari penasihat akademik. Memperbaiki hubungan ini dapat membantu menurunkan stres dan meningkatkan pengalaman belajar Anda.\n\nAnalisis Gejala Psikologis\nStress, kecemasan, dan depresi Anda berada pada tingkat normal dengan skor masing-masing 0, 4, dan 0. Ini menunjukkan bahwa Anda tidak mengalami gejala yang signifikan dalam kategori-kategori ini. Namun, tetap penting untuk menjaga keseimbangan emosi dan mengelola stres agar tidak berkembang menjadi masalah yang lebih serius. Prokrastinasi dan kecanduan ponsel Anda berada pada tingkat sangat rendah dengan skor masing-masing 7 dan 8. Ini menandakan bahwa Anda memiliki kontrol yang baik terhadap kecenderungan untuk menunda-nunda dan penggunaan ponsel yang berlebihan. Tetap pertahankan kebiasaan positif ini dengan terus menerapkan manajemen waktu yang efektif dan menggunakan teknologi secara bijak.\n\nRekomendasi\nSecara keseluruhan, meskipun Anda tidak menunjukkan masalah psikologis yang mendesak berdasarkan skor yang ada, perhatian terhadap dukungan keluarga dan kondisi finansial adalah kunci untuk meningkatkan kesejahteraan emosional Anda. Pertimbangkan untuk melanjutkan sesi konseling untuk menggali lebih dalam persoalan emosional yang pernah dihadapi dan mencari solusi yang tepat bagi tantangan yang sedang dialami. Pendekatan proaktif dalam menangani masalah ini akan membantu Anda mengatasi rintangan emosional dan meningkatkan kualitas hidup secara keseluruhan.	2024-11-26 17:19:45.192039	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
41e32868-2a0f-4fbf-bf86-9ed90dc03386	f	\N	2024-11-26 17:46:42.428848	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
baafb091-f5f8-4edb-bc7a-b8bd769c4f8c	t	#### Depresi\nDepresi dengan skor 28 (kategori sangat tinggi) menunjukkan bahwa individu mungkin mengalami perasaan putus asa, kehilangan minat dalam aktivitas sehari-hari, dan perasaan rendah diri yang signifikan. Kondisi ini dapat berdampak serius pada motivasi belajar, interaksi sosial, dan kualitas hidup secara keseluruhan. Gejala depresi yang tidak ditangani dapat berkembang menjadi kondisi yang lebih parah, mengganggu fungsi harian dan emosional. Sangat disarankan bagi individu untuk mencari bantuan dari profesional kesehatan mental, seperti konselor atau psikolog. Selain itu, aktivitas yang mendukung kesejahteraan mental, seperti olahraga ringan, meditasi, atau hobi yang menenangkan, dapat membantu mengurangi dampak negatif depresi.\n\n#### Kecemasan\nKecemasan dengan skor 32 (kategori sangat tinggi) menandakan bahwa individu mungkin sering merasa gelisah, tegang, dan khawatir berlebihan. Gejala ini dapat mengganggu tidur, mempengaruhi konsentrasi, dan menyebabkan kelelahan mental serta fisik. Kecemasan yang berlebihan dapat berdampak negatif pada berbagai aspek kehidupan, termasuk akademik dan sosial. Direkomendasikan untuk mulai menerapkan teknik relaksasi seperti pernapasan dalam atau meditasi. Konseling psikologis juga dapat membantu individu untuk mengidentifikasi dan mengatasi penyebab utama kecemasan ini.\n\n#### Stres\nStres dengan skor 30 (kategori tinggi) menunjukkan bahwa individu mengalami tekanan emosional yang signifikan. Kondisi ini dapat memengaruhi kesejahteraan mental dan fisik secara serius, serta mengganggu kemampuan untuk menyelesaikan tugas-tugas sehari-hari. Tingginya tingkat stres dapat memperburuk gejala kecemasan dan depresi, serta mengurangi efektivitas dalam konteks akademik dan sosial. Intervensi yang efektif dapat mencakup pengelolaan waktu yang lebih baik, teknik manajemen stres seperti mindfulness, dan dukungan sosial dari keluarga atau teman.\n\n#### Prokrastinasi\nProkrastinasi dengan skor 17 (kategori menengah) menunjukkan bahwa individu cenderung menunda penyelesaian tugas akademik, yang dapat meningkatkan tingkat stres dan kecemasan. Kebiasaan menunda-nunda ini dapat menciptakan siklus negatif di mana tugas yang belum selesai menjadi sumber tekanan tambahan, yang pada akhirnya mengurangi produktivitas dan kualitas hasil akademik. Disarankan untuk mengembangkan strategi manajemen waktu yang efektif, seperti membuat jadwal harian yang realistis dan menetapkan prioritas untuk tugas-tugas penting.\n\n#### Kecanduan Ponsel\nKecanduan ponsel dengan skor 26 (kategori tinggi) menunjukkan adanya risiko gangguan waktu produktif, pengurangan efisiensi belajar, dan kualitas interaksi sosial yang menurun. Ketergantungan pada ponsel dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting, dan pada akhirnya meningkatkan tingkat stres. Disarankan untuk menetapkan batasan penggunaan ponsel, seperti waktu tanpa ponsel selama belajar atau bekerja, serta meningkatkan kegiatan sosial yang tidak melibatkan teknologi.\n\n#### Kesimpulan\nSecara keseluruhan, kondisi mental yang dialami menunjukkan perlunya intervensi menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Penting bagi individu untuk mendapatkan dukungan yang memadai dari lingkungan sekitar, termasuk keluarga dan teman, serta mempertimbangkan untuk berkonsultasi dengan profesional kesehatan mental untuk mendapatkan strategi penanganan yang lebih terarah dan efektif.	2024-11-26 17:49:50.179004	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
86be435d-a92a-47cc-9d30-205523c7bd94	f	\N	2024-11-29 16:41:58.257231	1667321d-25f3-43ba-b90c-cca473d127d0	da50cf79-ee3b-4651-8dfe-45e9034057cd
db00af37-808f-4b83-bb24-1c8467052fac	t	Depresi\nBerdasarkan data, tingkat depresi individu berada dalam kategori normal dengan skor 2. Ini menunjukkan bahwa saat ini individu tidak mengalami gejala depresi yang signifikan. Meskipun demikian, penting untuk tetap memantau kondisi emosional dan psikologis secara berkala karena perubahan situasi atau stresor baru dapat mempengaruhi kesehatan mental. Mempraktikkan kebiasaan yang mendukung kesejahteraan mental seperti berolahraga, tidur yang cukup, dan menjaga hubungan sosial yang positif dapat membantu mempertahankan kondisi ini.\n\nProkrastinasi\nProkrastinasi berada pada tingkat yang sangat tinggi dengan skor 23. Ini menunjukkan bahwa individu mungkin sering menunda-nunda tugas, yang dapat menyebabkan beban kerja menumpuk dan meningkatkan stres. Dampak dari prokrastinasi yang tinggi meliputi penurunan produktivitas akademik dan profesional, serta peningkatan kecemasan dan stres akibat tenggat waktu yang mendekat. Disarankan untuk mempraktikkan strategi manajemen waktu yang efektif, seperti membuat jadwal harian, menetapkan prioritas, dan memecah tugas besar menjadi bagian yang lebih kecil dan lebih mudah dikelola. Selain itu, mencari dukungan dari konselor untuk mengatasi kebiasaan ini dapat menjadi langkah yang bermanfaat.\n\nKecanduan Ponsel\nKecanduan ponsel berada pada tingkat yang sangat rendah dengan skor 9. Ini menunjukkan bahwa individu cenderung memiliki kontrol yang baik terhadap penggunaan ponselnya, sehingga tidak menunjukkan tanda-tanda ketergantungan yang mengganggu. Namun, tetap penting untuk menjaga batasan yang sehat dalam penggunaan teknologi agar tidak mengganggu waktu produktif atau interaksi sosial yang berkualitas. Melanjutkan kebiasaan baik ini dan tetap waspada terhadap potensi peningkatan penggunaan yang tidak sehat adalah langkah bijak.\n\nStres\nTingkat stres tinggi dengan skor 32 menunjukkan bahwa individu sedang mengalami tekanan emosional yang signifikan. Stres yang tinggi dapat memengaruhi kesehatan mental dan fisik, termasuk menyebabkan gangguan tidur, kelelahan, dan penurunan kemampuan untuk berkonsentrasi. Kondisi ini juga dapat menghambat kinerja akademik dan sosial. Untuk mengatasi stres, penting untuk mengidentifikasi sumber stres dan mencari cara untuk menguranginya, seperti melalui teknik relaksasi, olahraga, dan konseling. Mengembangkan strategi coping yang efektif, seperti mindfulness dan perencanaan yang lebih baik, juga dapat membantu dalam mengelola stres.\n\nKecemasan\nKecemasan berada pada tingkat yang sangat tinggi dengan skor 32. Ini menunjukkan bahwa individu mungkin sering merasa gelisah, khawatir berlebihan, dan sulit untuk bersantai. Dampak dari kecemasan yang tinggi termasuk gangguan tidur, kesulitan berkonsentrasi, dan penurunan kesejahteraan secara keseluruhan. Penting untuk mencari bantuan profesional untuk menangani kecemasan ini, seperti konseling atau terapi perilaku kognitif. Selain itu, mempraktikkan teknik relaksasi seperti pernapasan dalam, meditasi, dan olahraga secara teratur dapat membantu menurunkan tingkat kecemasan.\n\nKesimpulan\nSecara keseluruhan, individu menunjukkan gejala prokrastinasi dan kecemasan yang sangat tinggi, serta tingkat stres yang tinggi, yang memerlukan perhatian dan intervensi lebih lanjut. Penting untuk segera menangani gejala ini agar tidak berkembang menjadi masalah yang lebih serius. Konseling psikologis dan pengembangan strategi manajemen stres dan waktu sangat dianjurkan untuk membantu individu mengelola gejala-gejala tersebut dan meningkatkan kualitas hidup. Dukungan dari lingkungan sekitar juga dapat memainkan peran penting dalam proses pemulihan dan pengelolaan kesehatan mental.	2024-11-29 16:42:50.83891	1667321d-25f3-43ba-b90c-cca473d127d0	da50cf79-ee3b-4651-8dfe-45e9034057cd
cc693fe2-2347-41c9-8c09-09c94a28fae2	f	\N	2024-12-02 16:32:34.263872	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
94ac6117-7aff-440a-8b2c-fadd683ca348	t	Stres  \nStres dengan skor 42 yang berada pada tingkat sangat tinggi menunjukkan bahwa individu tersebut mengalami tekanan emosional yang luar biasa. Stres pada tingkat ini dapat mengakibatkan berbagai dampak negatif, termasuk kelelahan fisik dan mental yang kronis, gangguan tidur, dan kesulitan dalam fokus atau konsentrasi. Selain itu, stres yang berkepanjangan dapat mempengaruhi kemampuan individu untuk berfungsi secara efektif dalam lingkungan akademik dan sosial, serta memperburuk kondisi emosional lainnya seperti depresi. Untuk mengelola stres ini, disarankan untuk mencari dukungan dari profesional kesehatan mental, seperti psikolog, yang dapat membantu dalam mengembangkan strategi coping yang efektif. Latihan relaksasi dan teknik manajemen stres seperti meditasi atau yoga juga dapat bermanfaat.\n\nKecemasan  \nKecemasan dengan skor 0 yang berada pada tingkat normal menunjukkan bahwa individu tidak mengalami gejala kecemasan yang signifikan pada saat ini. Hal ini adalah indikator positif bahwa individu dapat menghadapi situasi sehari-hari tanpa perasaan gelisah atau khawatir yang berlebihan. Meskipun demikian, tetap penting untuk menjaga kebiasaan sehat dan strategi coping yang sudah ada agar kecemasan tidak meningkat di masa depan. Jika ada perubahan situasi yang dapat memicu kecemasan, seperti tekanan akademik atau masalah interpersonal, penting untuk segera mengatasinya.\n\nDepresi  \nDepresi dengan skor 30 yang berada pada tingkat sangat tinggi merupakan tanda bahwa individu mungkin mengalami perasaan putus asa, kehilangan minat pada aktivitas yang sebelumnya dinikmati, dan perasaan rendah diri. Kondisi ini dapat secara signifikan mengganggu kesejahteraan emosional dan fisik, serta mempengaruhi motivasi dalam menjalani kehidupan sehari-hari dan interaksi sosial. Intervensi yang tepat sangat diperlukan untuk menangani depresi ini. Konseling psikologis atau terapi kognitif perilaku dapat membantu individu memahami dan mengubah pola pikir negatif. Aktivitas fisik teratur dan menjaga hubungan sosial yang positif juga direkomendasikan untuk mendukung pemulihan.\n\nProkrastinasi  \nProkrastinasi dengan skor 23 yang berada pada tingkat sangat tinggi menunjukkan adanya kebiasaan menunda-nunda yang bisa berdampak negatif pada pencapaian akademik dan produktivitas sehari-hari. Kebiasaan ini dapat menciptakan siklus stres dan kecemasan yang semakin memperburuk situasi, karena tugas-tugas yang tertunda menjadi beban tambahan. Untuk mengatasi prokrastinasi, penting bagi individu untuk mengembangkan keterampilan manajemen waktu yang lebih baik. Membuat daftar prioritas tugas, menetapkan jadwal yang realistis, dan membagi tugas besar menjadi langkah-langkah kecil dapat membantu mengurangi kecenderungan untuk menunda-nunda.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 6 yang berada pada tingkat sangat rendah menunjukkan bahwa penggunaan ponsel tidak menjadi masalah signifikan bagi individu ini. Hal ini berarti bahwa individu dapat menggunakan ponsel secara seimbang tanpa mengganggu waktu produktif atau kualitas hubungan sosial. Namun, penting untuk tetap waspada terhadap potensi peningkatan penggunaan ponsel, terutama dalam situasi stres tinggi atau ketika merasa tertekan, agar tidak berkembang menjadi kebiasaan yang mengganggu.\n\nKesimpulan  \nSecara keseluruhan, analisis menunjukkan bahwa individu mengalami tingkat stres dan depresi yang sangat tinggi, serta kecenderungan kuat untuk menunda-nunda. Kondisi ini memerlukan perhatian dan intervensi segera untuk mencegah dampak negatif yang lebih jauh. Disarankan untuk mendapatkan dukungan dari profesional kesehatan mental dan mengadopsi strategi coping yang sehat untuk mengelola gejala. Meskipun kecemasan dan kecanduan ponsel tidak menjadi masalah saat ini, menjaga kebiasaan sehat dan keseimbangan dalam penggunaan teknologi tetap penting untuk kesejahteraan jangka panjang. Langkah berikutnya termasuk konseling psikologis dan pelatihan manajemen waktu yang dapat membantu individu mengatasi tantangan ini secara efektif.	2024-12-26 15:22:21.26394	1667321d-25f3-43ba-b90c-cca473d127d0	da50cf79-ee3b-4651-8dfe-45e9034057cd
3392340e-0fa6-42e9-9d3b-e97bbcce7281	t	Depresi  \nDepresi dengan skor 32 pada kategori sangat tinggi menunjukkan bahwa individu tersebut mungkin mengalami perasaan yang mendalam seperti putus asa, hilangnya minat terhadap aktivitas yang sebelumnya menyenangkan, dan perasaan tidak berharga. Dampak dari depresi pada tingkat ini dapat sangat signifikan, termasuk menurunnya motivasi untuk menyelesaikan tugas sehari-hari, gangguan dalam hubungan sosial, dan penurunan kinerja akademik atau profesional. Depresi yang tidak ditangani dapat menyebabkan kemunduran dalam kualitas hidup secara keseluruhan dan meningkatkan risiko terhadap masalah kesehatan mental lainnya. Oleh karena itu, sangat disarankan untuk segera mencari bantuan profesional melalui konseling psikologis atau psikiatri, serta mempertimbangkan aktivitas yang bisa meningkatkan kesejahteraan seperti olahraga rutin atau teknik relaksasi.\n\nKecemasan  \nKecemasan dengan skor 32 juga berada pada kategori sangat tinggi, yang menunjukkan bahwa individu mungkin sering merasakan ketegangan, kekhawatiran berlebihan, dan ketidakmampuan untuk bersantai. Dampak dari kecemasan tingkat tinggi termasuk gangguan tidur, kesulitan berkonsentrasi, dan kelelahan yang berlebihan baik secara mental maupun fisik. Kecemasan yang tidak dikelola dengan baik dapat mempengaruhi kemampuan untuk berfungsi dalam kehidupan sehari-hari dan memperburuk kondisi mental lainnya seperti depresi. Direkomendasikan untuk memanfaatkan teknik manajemen kecemasan seperti pernapasan dalam, meditasi, dan keterampilan pengelolaan stres. Konseling juga dapat membantu dalam mengidentifikasi dan mengatasi pemicu utama kecemasan.\n\nStres  \nStres dengan skor 40 dalam kategori sangat tinggi menunjukkan adanya tekanan emosional yang signifikan dan terus-menerus. Stres pada tingkat ini dapat berdampak buruk pada kesehatan fisik dan mental, termasuk kelelahan kronis, gangguan tidur, dan kesulitan menyelesaikan tugas sehari-hari. Stres yang berkepanjangan dapat memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan untuk berfungsi secara efektif dalam lingkungan sosial dan akademik. Untuk mengatasi stres ini, penting untuk mengembangkan strategi coping yang efektif, seperti mengatur waktu dengan lebih baik, memprioritaskan tugas, dan mencari dukungan dari teman atau keluarga. Konsultasi dengan profesional kesehatan mental juga sangat dianjurkan.\n\nProkrastinasi  \nProkrastinasi dengan skor 21 dalam kategori tinggi menunjukkan kebiasaan menunda-nunda yang dapat mengakibatkan penundaan dalam penyelesaian tugas akademik dan profesional. Dampak dari prokrastinasi ini termasuk meningkatnya tingkat stres dan kecemasan akibat tenggat waktu yang semakin dekat dan tugas-tugas yang menumpuk. Kebiasaan ini dapat memicu siklus negatif di mana tugas yang belum terselesaikan menjadi sumber tekanan tambahan, secara signifikan mengurangi produktivitas dan kualitas hasil. Untuk mengatasi prokrastinasi, disarankan untuk menggunakan teknik manajemen waktu yang efektif, seperti membuat daftar prioritas, menetapkan tenggat waktu yang realistis, dan membagi tugas besar menjadi bagian-bagian yang lebih kecil dan dapat dikelola.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 33 dalam kategori sangat tinggi menunjukkan bahwa individu mungkin menghabiskan waktu yang berlebihan pada perangkat tersebut, yang mengganggu waktu produktif dan interaksi sosial. Ketergantungan ini dapat mengalihkan perhatian dari tugas-tugas penting, meningkatkan prokrastinasi, dan pada akhirnya meningkatkan tingkat stres. Untuk mengurangi kecanduan ponsel, penting untuk menetapkan batasan penggunaan, seperti menetapkan waktu bebas ponsel, menggunakan aplikasi pemantau penggunaan, dan mencari aktivitas alternatif yang lebih produktif. Dukungan dari teman dan keluarga juga bisa membantu dalam memoderasi penggunaan ponsel.\n\nKesimpulan  \nSecara keseluruhan, gejala yang dialami oleh individu menunjukkan perlunya intervensi yang menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan pengembangan strategi coping yang efektif dapat membantu dalam mengelola gejala-gejala ini dengan lebih baik. Meningkatkan kesadaran diri dan dukungan sosial yang kuat juga akan berkontribusi dalam meningkatkan kualitas hidup dan kesejahteraan mental secara keseluruhan.	2024-12-26 15:25:49.018067	1667321d-25f3-43ba-b90c-cca473d127d0	da50cf79-ee3b-4651-8dfe-45e9034057cd
326f2692-ea84-4e6a-8e8c-32b2faa39c04	t	Depresi\nDepresi dengan skor 28 (kategori sangat tinggi) menunjukkan bahwa individu mungkin mengalami gejala yang serius seperti perasaan putus asa, kesedihan yang mendalam, dan hilangnya minat atau kesenangan dalam aktivitas yang biasanya disukai. Dampak depresi ini bisa sangat signifikan, mencakup penurunan motivasi untuk belajar, kesulitan dalam mempertahankan hubungan sosial, dan penurunan kualitas hidup secara keseluruhan. Jika tidak segera diatasi, depresi dapat berkembang menjadi gangguan yang lebih serius, yang dapat mempengaruhi kesehatan mental dan fisik individu secara keseluruhan. Disarankan untuk segera mencari bantuan dari profesional kesehatan mental, seperti psikolog atau psikiater, dan terlibat dalam aktivitas yang dapat meningkatkan kesejahteraan mental, seperti olahraga teratur, meditasi, atau aktivitas kreatif.\n\nKecemasan\nKecemasan dengan skor 34 (kategori sangat tinggi) menandakan bahwa individu mungkin sering mengalami perasaan gelisah yang intens, ketegangan yang berlebihan, dan kekhawatiran yang tidak terkendali. Dampaknya dapat meliputi gangguan tidur, kesulitan berkonsentrasi, dan kelelahan mental serta fisik yang kronis. Tingkat kecemasan yang sangat tinggi dapat mengganggu kinerja akademik dan sosial, serta mempengaruhi hubungan interpersonal. Direkomendasikan untuk mencoba teknik manajemen stres seperti latihan pernapasan dalam, meditasi, yoga, atau konseling untuk mengidentifikasi dan mengatasi penyebab utama kecemasan. Intervensi dini sangat penting untuk mencegah dampak jangka panjang dari kecemasan yang tidak terkelola.\n\nStres\nStres dengan skor 20 (kategori menengah) menunjukkan bahwa individu mengalami tekanan emosional yang cukup signifikan, yang dapat mempengaruhi kesejahteraan mental dan fisik. Dampaknya termasuk kelelahan, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas sehari-hari. Stres yang tidak dikelola dengan baik dapat memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan individu untuk berfungsi secara efektif dalam konteks akademik dan sosial. Penting bagi individu untuk mengidentifikasi sumber stres dan mengembangkan strategi coping yang efektif, seperti manajemen waktu yang lebih baik, istirahat yang cukup, dan berbagi perasaan dengan orang-orang terdekat atau profesional.\n\nProkrastinasi\nProkrastinasi dengan skor 20 (kategori tinggi) menunjukkan kecenderungan individu untuk menunda-nunda penyelesaian tugas. Ini dapat berdampak negatif pada kinerja akademik dan meningkatkan tingkat stres dan kecemasan. Kebiasaan menunda-nunda juga dapat memicu siklus negatif di mana tugas yang belum terselesaikan menjadi sumber tekanan tambahan, mengurangi produktivitas dan kualitas hasil akademik. Untuk mengatasi prokrastinasi, individu dapat mencoba menetapkan tujuan yang jelas dan realistis, memecah tugas besar menjadi bagian-bagian yang lebih kecil, dan memberikan penghargaan pada diri sendiri setelah menyelesaikan tugas. Konseling atau pelatihan manajemen waktu juga dapat bermanfaat.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 26 (kategori tinggi) menunjukkan bahwa individu mungkin memiliki ketergantungan yang signifikan pada perangkat ponsel, yang dapat mengganggu waktu produktif, mengurangi efisiensi belajar, dan mempengaruhi kualitas interaksi sosial. Ketergantungan ini juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting, yang pada akhirnya meningkatkan tingkat stres. Disarankan untuk menerapkan batasan waktu penggunaan ponsel, menggunakan aplikasi untuk memonitor penggunaan ponsel, dan mencari aktivitas alternatif yang lebih produktif untuk mengisi waktu luang.\n\nKesimpulan\nSecara keseluruhan, kondisi mental yang dialami oleh individu menunjukkan perlunya intervensi menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, strategi pengelolaan stres, dan pengaturan penggunaan teknologi dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Dukungan dari keluarga dan teman juga sangat penting untuk membantu individu melewati masa-masa sulit ini.	2024-12-26 15:27:09.159095	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
6b283e6d-f7d9-4811-ae30-67d65f1f73bf	f	\N	2024-12-26 15:40:13.688796	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
a3c089fe-66ef-4870-8482-0287539d0ee2	f	\N	2024-12-26 15:40:51.433796	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
e7211f79-0a95-42f8-9fa1-8c5a96c2c417	f	\N	2024-12-26 15:42:39.783924	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
db40c476-c0e7-4c3d-b39a-159797a5d115	t	Stres  \nStres dengan skor 34 (kategori sangat tinggi) menunjukkan bahwa individu tersebut mengalami tekanan emosional yang signifikan. Stres pada tingkat ini dapat berdampak secara serius pada kesejahteraan mental dan fisik, termasuk kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas sehari-hari. Tingginya tingkat stres ini juga dapat memperburuk gejala kecemasan dan depresi serta menurunkan kemampuan individu untuk berfungsi secara efektif dalam konteks akademik dan sosial. Disarankan untuk mencari dukungan melalui konseling psikologis dan belajar teknik manajemen stres seperti mindfulness atau meditasi.\n\nKecemasan  \nKecemasan dengan skor 26 (kategori sangat tinggi) menunjukkan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan. Dampaknya meliputi gangguan tidur, kesulitan berkonsentrasi, dan kelelahan mental serta fisik. Kecemasan pada tingkat ini dapat mengganggu interaksi sosial dan kinerja akademik. Direkomendasikan untuk individu tersebut mencoba teknik relaksasi seperti pernapasan dalam dan mencari konseling untuk menangani penyebab utama kecemasan. Membangun rutinitas harian yang sehat dan teratur juga dapat membantu mengurangi kecemasan.\n\nDepresi  \nDepresi dengan skor 24 (kategori tinggi) menunjukkan bahwa individu mungkin mengalami gejala seperti perasaan putus asa, hilangnya minat dalam aktivitas sehari-hari, atau perasaan rendah diri. Dampak depresi dapat mencakup penurunan motivasi belajar, kesulitan berinteraksi sosial, dan kualitas hidup yang menurun. Jika tidak ditangani, gejala ini dapat berkembang menjadi kondisi yang lebih serius. Disarankan untuk melakukan konseling psikologis dan aktivitas yang mendukung kesejahteraan mental seperti olahraga ringan atau meditasi. Mendapatkan dukungan dari orang-orang terdekat juga dapat membantu dalam mengatasi perasaan ini.\n\nProkrastinasi  \nProkrastinasi dengan skor 16 (kategori menengah) menunjukkan bahwa individu mungkin sering menunda-nunda tugas atau tanggung jawab. Kebiasaan ini dapat menyebabkan penundaan penyelesaian tugas akademik, yang pada gilirannya meningkatkan stres dan kecemasan. Prokrastinasi dapat memicu siklus negatif di mana tugas yang belum terselesaikan menjadi sumber tekanan tambahan, yang akhirnya mengurangi produktivitas dan kualitas hasil akademik. Disarankan untuk mengembangkan keterampilan manajemen waktu dan membuat daftar prioritas untuk meningkatkan efisiensi dan mengurangi prokrastinasi.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 16 (kategori rendah) menunjukkan bahwa meskipun tidak terlalu tinggi, ada potensi bahwa penggunaan ponsel dapat mengganggu waktu produktif individu. Ketergantungan pada ponsel dapat mengurangi efisiensi belajar dan mempengaruhi kualitas interaksi sosial. Disarankan untuk menetapkan batasan waktu penggunaan ponsel dan mengalokasikan waktu untuk aktivitas non-digital yang produktif. Mengembangkan kebiasaan digital yang sehat dapat membantu mencegah peningkatan ketergantungan di masa depan.\n\nKesimpulan  \nSecara keseluruhan, individu mengalami tingkat stres dan kecemasan yang sangat tinggi, yang memerlukan perhatian dan intervensi segera. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Mencari dukungan dari keluarga dan teman dekat juga penting untuk membantu individu menghadapi tantangan yang dihadapi. Dianjurkan untuk melakukan evaluasi berkelanjutan dan menyesuaikan intervensi sesuai perkembangan kondisi individu.	2024-12-26 09:49:57.944895	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
35ee2f75-9a83-469e-b81a-fe7f7964cebd	f	\N	2024-12-26 10:26:24.950065	1667321d-25f3-43ba-b90c-cca473d127d0	62b4ba92-0209-41a2-bc01-885f1dc14dce
0256dd85-a260-457d-8dcd-a9c216e66577	f	\N	2024-12-26 12:04:47.795249	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
78782c19-f448-4830-acfc-5e80288331de	f	\N	2024-12-26 12:07:04.290788	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
f1bf4fc6-666e-4da3-af62-a8e00aca6eb7	t	Depresi\nDengan skor 0 yang menunjukkan tingkat normal, saat ini tidak ada indikasi adanya gejala depresi yang signifikan pada responden. Hal ini menunjukkan tidak adanya perasaan putus asa, hilangnya minat dalam aktivitas sehari-hari, atau perasaan rendah diri yang sering dikaitkan dengan depresi. Kondisi ini mendukung kesejahteraan emosi dan mental yang baik, serta memungkinkan individu untuk menjalani aktivitas sehari-hari secara optimal. Meskipun tidak ada gejala depresi yang teridentifikasi, tetap penting untuk menjaga kesehatan mental dengan menjaga keseimbangan antara aktivitas dan istirahat, serta membangun hubungan sosial yang positif dan suportif.\n\nKecemasan\nSkor 2 yang berada pada tingkat normal menunjukkan bahwa responden tidak mengalami kecemasan yang berlebihan atau mengganggu. Ini berarti responden mampu mengelola perasaan gelisah atau khawatir yang mungkin muncul dalam kehidupan sehari-hari. Kondisi ini memungkinkan responden untuk berkonsentrasi dengan baik, tidur nyenyak, dan menjalani kehidupan sehari-hari dengan tenang. Untuk menjaga kondisi ini, direkomendasikan untuk terus melakukan aktivitas yang mendukung kesehatan mental seperti olahraga teratur, meditasi, atau teknik relaksasi lainnya. Jika ada indikasi peningkatan kecemasan di masa depan, segera cari dukungan dari teman, keluarga, atau profesional.\n\nStres\nSkor 0 yang menunjukkan tingkat stres normal menandakan bahwa responden tidak mengalami tekanan emosional yang signifikan. Responden mampu mengatasi tantangan sehari-hari tanpa merasa kewalahan, yang sangat penting untuk kesejahteraan mental dan fisik. Keberadaan stres yang terkelola dengan baik mendukung produktivitas dan interaksi sosial yang positif. Untuk mempertahankan tingkat stres yang sehat, direkomendasikan untuk menjaga rutinitas yang seimbang, mengatur waktu dengan baik, dan memastikan adanya waktu untuk relaksasi dan kegiatan yang menyenangkan.\n\nProkrastinasi\nDengan skor 5 yang tergolong sangat rendah, responden menunjukkan sedikit kecenderungan untuk menunda-nunda tugas. Hal ini mengindikasikan bahwa responden memiliki kemampuan manajemen waktu yang baik dan cenderung menyelesaikan tugas tepat waktu. Kebiasaan ini dapat meningkatkan produktivitas dan mengurangi potensi stres akibat pekerjaan yang menumpuk. Untuk terus mempertahankan perilaku ini, responden disarankan untuk terus membuat perencanaan tugas yang terstruktur dan menetapkan prioritas yang jelas dalam aktivitas sehari-hari.\n\nKecanduan Ponsel\nSkor 9 yang tergolong sangat rendah menunjukkan bahwa responden tidak memiliki ketergantungan yang signifikan terhadap penggunaan ponsel. Hal ini berarti ponsel tidak menjadi pengalih perhatian utama yang dapat mengganggu produktivitas atau kualitas interaksi sosial. Kondisi ini mendukung fokus yang lebih baik pada tugas-tugas penting dan interaksi yang lebih berkualitas dengan orang-orang di sekitar. Untuk menjaga pola penggunaan ponsel yang sehat, disarankan untuk tetap membatasi waktu layar dan memastikan bahwa penggunaan ponsel tidak mengganggu waktu tidur atau aktivitas penting lainnya.\n\nKesimpulan\nSecara keseluruhan, analisis menunjukkan bahwa responden berada dalam kondisi emosional dan mental yang baik, dengan tingkat depresi, kecemasan, stres, prokrastinasi, dan kecanduan ponsel yang semuanya berada dalam kategori normal atau sangat rendah. Kondisi ini mendukung kesejahteraan hidup yang optimal dan memungkinkan responden untuk menjalani aktivitas sehari-hari dengan efektif. Meskipun demikian, penting untuk terus memantau kesehatan mental dan emosi, serta mencari dukungan jika muncul masalah di kemudian hari. Menjaga gaya hidup sehat dan hubungan sosial yang positif akan sangat bermanfaat dalam mempertahankan kondisi yang baik ini.	2024-12-26 12:10:18.745155	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
dd10ed4c-b861-4c05-8d57-554ed39e121b	t	Depresi  \nDepresi dengan skor 0 menunjukkan bahwa individu tidak mengalami gejala depresi yang signifikan. Hal ini menandakan bahwa individu tersebut tidak menunjukkan tanda-tanda perasaan putus asa, rendah diri, atau hilangnya minat dalam aktivitas sehari-hari yang biasa dialami oleh mereka yang memiliki gejala depresi. Dampak dari tidak adanya gejala depresi ini adalah kemampuan individu untuk menjalani kehidupan sehari-hari dengan lebih positif, serta menjaga hubungan sosial dan akademik tanpa hambatan yang berarti. Sebagai rekomendasi, meskipun tidak ada gejala saat ini, penting untuk tetap menjaga kesehatan mental dengan kegiatan yang menyehatkan seperti olahraga rutin, menjaga komunikasi terbuka dengan orang terdekat, dan mengatur waktu istirahat yang cukup.\n\nKecemasan  \nKecemasan dengan skor 2, yang berada dalam kategori normal, menunjukkan bahwa individu memiliki tingkat kecemasan yang tidak mengganggu keseharian. Kecemasan yang normal dapat membantu dalam meningkatkan kewaspadaan dan kinerja, terutama dalam menghadapi tantangan baru. Namun, penting untuk tetap waspada agar kecemasan tidak meningkat menjadi berlebihan. Dampaknya terhadap kehidupan sehari-hari cenderung minimal, tetapi menjaga keseimbangan tetap penting. Rekomendasinya adalah melakukan teknik relaksasi seperti pernapasan dalam atau meditasi, serta menjaga pola tidur yang teratur untuk memastikan kecemasan tetap terkendali.\n\nStres  \nStres dengan skor 0 mengindikasikan bahwa individu tidak mengalami stres yang berarti saat ini. Ini adalah tanda positif bahwa individu mampu mengelola tekanan sehari-hari dengan efektif, baik dalam konteks personal, sosial, maupun akademik. Dampaknya adalah kesejahteraan emosional yang lebih baik dan kemampuan untuk berpartisipasi dalam kegiatan sehari-hari tanpa hambatan. Meskipun demikian, tetap disarankan untuk menjaga mekanisme coping yang efektif, seperti berolahraga secara teratur, melakukan hobi yang menyenangkan, dan memastikan adanya waktu untuk istirahat dan rekreasi.\n\nProkrastinasi  \nProkrastinasi dengan skor 7 yang berada dalam kategori sangat rendah menunjukkan bahwa individu memiliki kemampuan yang baik dalam mengatur waktu dan menyelesaikan tugas tanpa penundaan yang berarti. Hal ini berdampak positif pada produktivitas akademik dan profesional, serta mengurangi tingkat stres yang sering kali dikaitkan dengan penundaan tugas. Rekomendasinya adalah untuk terus menerapkan strategi manajemen waktu yang efektif dan menjaga disiplin diri agar kebiasaan baik ini tetap terjaga.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 41, meskipun tidak ada kategori yang jelas, dapat menunjukkan adanya penggunaan ponsel yang tinggi. Penggunaan ponsel yang berlebihan berpotensi mengganggu waktu produktif dan kualitas interaksi sosial, serta dapat meningkatkan risiko prokrastinasi. Dampaknya bisa berupa gangguan pada pola tidur dan konsentrasi. Sebagai rekomendasi, disarankan untuk menetapkan batasan waktu penggunaan ponsel, terutama di waktu-waktu yang seharusnya digunakan untuk aktivitas produktif atau istirahat. Menggunakan fitur pengingat waktu layar pada ponsel juga bisa membantu dalam mengelola penggunaan ponsel secara lebih efektif.\n\nKesimpulan  \nSecara keseluruhan, individu menunjukkan kesehatan mental yang baik dengan tidak adanya gejala depresi, kecemasan, atau stres yang berarti. Prokrastinasi juga berada pada tingkat sangat rendah, menunjukkan kemampuan pengelolaan waktu yang baik. Namun, penggunaan ponsel yang tinggi memerlukan perhatian lebih untuk mencegah potensi dampak negatif. Disarankan untuk terus menjaga kebiasaan positif ini dan tetap waspada terhadap perubahan yang mungkin terjadi, serta mempertimbangkan konsultasi dengan profesional jika diperlukan untuk menjaga kesejahteraan mental secara optimal.	2024-12-25 12:54:00.659	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
a9f1d3ed-e9a2-4bdf-9908-fc96002488f5	f	\N	2024-12-26 15:12:06.407465	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
4cff9bb5-a664-428a-b155-dab86c110e10	t	Stres  \nStres dengan skor 42 pada kategori sangat tinggi menunjukkan bahwa individu mengalami tekanan emosional yang signifikan. Kondisi ini dapat berpengaruh besar terhadap kesehatan mental dan fisik. Gejala stres yang dialami bisa termasuk kelelahan kronis, kesulitan tidur, dan gangguan konsentrasi. Stres yang tidak terkelola dengan baik dapat mempengaruhi kinerja akademis, mengurangi produktivitas, dan menghambat kemampuan individu untuk berfungsi secara efektif dalam kehidupan sehari-hari dan interaksi sosial. Direkomendasikan untuk mencari dukungan profesional, seperti konseling psikologis, serta menerapkan teknik manajemen stres seperti meditasi, olahraga teratur, dan relaksasi untuk membantu mengurangi beban stres.\n\nKecemasan  \nKecemasan dengan skor 42 dalam kategori sangat tinggi menunjukkan bahwa individu mungkin sering mengalami perasaan khawatir berlebihan, gelisah, dan tegang. Kondisi ini dapat memengaruhi kualitas tidur, kemampuan untuk berkonsentrasi, dan dapat menyebabkan kelelahan mental serta fisik. Kecemasan yang tinggi dapat menghambat kemampuan individu untuk berpartisipasi dalam aktivitas sosial dan akademis secara optimal. Penting untuk mengidentifikasi dan mengelola pemicu kecemasan dengan bantuan profesional, serta mencoba teknik relaksasi seperti pernapasan dalam dan mindfulness untuk menenangkan pikiran dan tubuh. \n\nDepresi  \nDepresi dengan skor 30 dalam kategori sangat tinggi menunjukkan bahwa individu mungkin mengalami gejala seperti perasaan putus asa, hilangnya minat dalam aktivitas yang sebelumnya dinikmati, atau perasaan rendah diri. Dampak depresi dapat mencakup penurunan motivasi, kesulitan berinteraksi sosial, dan penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani, kondisi ini bisa berkembang menjadi lebih serius. Disarankan untuk segera mencari bantuan dari psikolog atau psikiater untuk mendapatkan dukungan dan terapi yang tepat, serta menjajaki kegiatan yang mendukung kesejahteraan mental seperti olahraga ringan atau aktivitas kreatif.\n\nProkrastinasi  \nProkrastinasi dengan skor 17 dalam kategori menengah menunjukkan bahwa individu terkadang menunda tugas, yang dapat menyebabkan akumulasi pekerjaan dan stres tambahan. Kebiasaan menunda ini dapat berdampak pada pencapaian akademis dan meningkatkan kecemasan. Untuk mengatasi prokrastinasi, disarankan untuk mempraktikkan manajemen waktu yang efektif, membuat jadwal tugas yang terorganisir, dan menetapkan prioritas yang jelas. Mendapatkan dukungan dari teman atau mentor untuk memotivasi penyelesaian tugas juga dapat bermanfaat.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 25 dalam kategori tinggi menunjukkan bahwa individu mungkin menghabiskan banyak waktu dengan ponsel, yang berpotensi mengganggu waktu produktif dan interaksi sosial. Ketergantungan ini dapat memperburuk prokrastinasi dan meningkatkan stres akibat waktu yang terbuang. Direkomendasikan untuk menetapkan batas waktu penggunaan ponsel, menggunakan aplikasi pengingat untuk fokus pada tugas penting, dan mencari alternatif kegiatan yang tidak melibatkan perangkat digital untuk meningkatkan keseimbangan dan kualitas hidup.\n\nKesimpulan  \nSecara keseluruhan, kondisi mental yang dialami menunjukkan perlunya intervensi menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu dalam mengelola gejala secara efektif. Penting untuk segera mengambil langkah untuk mendapatkan dukungan yang tepat dan membangun rutinitas yang mendukung kesejahteraan mental dan emosional.	2024-12-26 15:12:54.303682	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
864341b1-3981-4926-82bd-d47dfb2aa883	f	\N	2024-12-26 15:21:18.285703	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
9beabf06-2c3c-4d71-a1ed-67f8ccf346a3	t	Stres\nStres dengan skor 16 menunjukkan bahwa tingkat stres yang dialami berada pada kategori rendah. Meskipun berada pada tingkat rendah, stres tetap dapat mempengaruhi kesejahteraan mental dan fisik jika tidak dikelola dengan baik. Potensi dampak dari stres ini dapat mencakup perasaan lelah, sedikit iritabilitas, dan menurunnya semangat dalam melakukan aktivitas sehari-hari. Untuk mengatasi stres ini, disarankan untuk melibatkan diri dalam aktivitas relaksasi seperti mendengarkan musik, melakukan olahraga ringan, atau berpartisipasi dalam kegiatan yang menyenangkan. Mengatur waktu secara efektif dan menciptakan rutinitas yang seimbang antara kegiatan akademik dan rekreasi juga dapat membantu mengurangi stres.\n\nKecemasan\nKecemasan dengan skor 18 berada pada kategori tinggi, menunjukkan bahwa individu mungkin sering mengalami perasaan gelisah, khawatir berlebihan, dan ketegangan. Kondisi kecemasan yang tinggi dapat berdampak pada kesulitan berkonsentrasi, gangguan tidur, dan kelelahan baik secara mental maupun fisik. Untuk mengelola kecemasan ini, penting untuk mempelajari teknik-teknik relaksasi seperti pernapasan dalam dan meditasi. Selain itu, terlibat dalam konseling dapat membantu dalam mengidentifikasi dan mengatasi penyebab utama dari kecemasan ini. Dukungan sosial dari keluarga dan teman juga dapat menjadi faktor penting dalam mengurangi perasaan cemas.\n\nDepresi\nDepresi dengan skor 20 berada pada tingkat menengah, yang dapat menunjukkan adanya gejala seperti perasaan putus asa, hilangnya minat dalam aktivitas sehari-hari, atau perasaan rendah diri. Dampak dari depresi ini mungkin termasuk penurunan motivasi dalam belajar, kesulitan berinteraksi sosial, dan menurunnya kualitas hidup secara umum. Jika tidak ditangani, gejala ini berisiko berkembang menjadi kondisi yang lebih serius. Rekomendasi intervensi mencakup konseling psikologis untuk mendukung kesejahteraan mental, serta berpartisipasi dalam aktivitas fisik seperti olahraga ringan atau yoga yang diketahui dapat meningkatkan suasana hati.\n\nProkrastinasi\nProkrastinasi dengan skor 10 menunjukkan bahwa tingkat penundaan dalam penyelesaian tugas berada pada kategori rendah. Meskipun tingkatnya rendah, kebiasaan menunda ini masih perlu diperhatikan untuk menghindari akumulasi tugas yang dapat meningkatkan stres dan kecemasan di kemudian hari. Membuat jadwal yang terstruktur dan menggunakan teknik manajemen waktu seperti menetapkan prioritas dan membuat daftar tugas harian dapat membantu dalam mengurangi prokrastinasi.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 17 berada pada kategori rendah, menunjukkan bahwa penggunaan ponsel belum mengganggu secara signifikan terhadap aktivitas harian. Namun, tetap penting untuk mengawasi penggunaan ponsel agar tidak meningkat ke tingkat yang lebih mengganggu. Membatasi waktu penggunaan ponsel, terutama sebelum tidur, dan memastikan tetap fokus pada interaksi sosial di dunia nyata dapat mencegah berkembangnya ketergantungan yang lebih serius.\n\nKesimpulan\nSecara keseluruhan, kondisi mental yang dialami memerlukan perhatian terutama pada aspek kecemasan dan depresi. Intervensi yang melibatkan konseling psikologis untuk kecemasan dan depresi, serta strategi manajemen waktu dan teknik relaksasi, dapat membantu dalam mengelola gejala dan meningkatkan kesejahteraan secara keseluruhan. Dukungan dari keluarga dan teman, yang telah terbukti sangat mendukung, juga merupakan aset penting dalam proses pemulihan ini.	2024-12-26 15:47:26.259958	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
5b0f38a2-c133-4fe1-ae18-b217976bbc77	t	Depresi  \nDepresi dengan skor 26 yang berada dalam kategori tinggi menunjukkan bahwa individu mungkin mengalami gejala seperti perasaan sangat sedih, putus asa, atau kehilangan minat pada aktivitas yang sebelumnya menyenangkan. Dampak depresi dapat mencakup penurunan motivasi belajar, kesulitan dalam interaksi sosial, dan penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani, gejala ini dapat berkembang menjadi kondisi yang lebih berat dan mempengaruhi kemampuan untuk berfungsi secara efektif dalam kehidupan sehari-hari. Disarankan untuk melakukan konseling psikologis secara rutin dan terlibat dalam aktivitas yang mendukung kesejahteraan mental, seperti olahraga ringan, meditasi, atau kegiatan kreatif.\n\nKecemasan  \nKecemasan dengan skor 24 yang berada dalam kategori sangat tinggi menunjukkan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan yang mungkin tidak proporsional dengan situasi yang dihadapi. Dampaknya dapat meliputi gangguan tidur, kesulitan berkonsentrasi, dan kelelahan baik mental maupun fisik. Kondisi ini juga dapat mempengaruhi performa akademik dan interaksi sosial. Direkomendasikan untuk mencoba teknik relaksasi seperti pernapasan dalam dan meditasi. Selain itu, konseling psikologis dapat membantu untuk mengidentifikasi dan mengatasi penyebab utama dari kecemasan ini.\n\nStres  \nStres dengan skor 16 berada pada tingkat rendah menunjukkan bahwa individu saat ini mungkin tidak mengalami tekanan emosional yang signifikan. Namun, tetap penting untuk mengelola stres agar tidak meningkat dan mempengaruhi kondisi mental dan fisik. Stress management dapat dilakukan dengan aktivitas fisik rutin, menjaga pola tidur yang sehat, dan teknik relaksasi seperti yoga atau meditasi. Dengan demikian, individu dapat mempertahankan kesejahteraan emosional dan fisik serta meningkatkan kualitas hidup.\n\nProkrastinasi  \nProkrastinasi dengan skor 16 yang berada dalam kategori menengah menunjukkan adanya kecenderungan untuk menunda-nunda penyelesaian tugas. Kebiasaan ini dapat berdampak negatif pada kinerja akademik dan meningkatkan tingkat stres serta kecemasan seiring bertumpuknya tugas yang belum diselesaikan. Disarankan untuk menerapkan teknik manajemen waktu seperti membuat daftar tugas, menetapkan prioritas, dan mengatur waktu istirahat secara teratur untuk meningkatkan produktivitas dan mengurangi stres akibat penundaan.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 26 yang berada dalam kategori tinggi menunjukkan bahwa individu mungkin terlalu sering menggunakan ponsel, yang berpotensi mengganggu waktu produktif dan interaksi sosial. Ketergantungan ini dapat menyebabkan penurunan efisiensi belajar dan memicu prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting. Disarankan untuk menetapkan batasan waktu penggunaan ponsel dan mencoba untuk lebih terlibat dalam aktivitas offline, seperti membaca buku atau berolahraga, untuk mengurangi ketergantungan dan meningkatkan keseimbangan hidup.\n\nKesimpulan  \nSecara keseluruhan, analisis terhadap kondisi mental menunjukkan perlunya intervensi yang komprehensif untuk membantu individu mengelola gejala yang dialami. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping yang tepat dapat membantu mengatasi tantangan ini dan meningkatkan kualitas hidup secara keseluruhan. Langkah-langkah ini diharapkan dapat membantu individu mencapai keseimbangan emosional dan fisik yang lebih baik serta meningkatkan performa dalam berbagai aspek kehidupan.	2024-12-26 15:55:29.706677	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
5ac3242c-19f9-4cfa-b097-314278a85af0	t	Depresi\nDepresi dengan skor 18 (kategori menengah) menunjukkan bahwa individu mungkin mengalami gejala seperti perasaan putus asa, kehilangan minat atau kesenangan dalam aktivitas sehari-hari, dan perasaan rendah diri. Dampak dari depresi ini dapat mencakup penurunan motivasi untuk belajar, kesulitan dalam interaksi sosial, serta penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani, gejala ini bisa berkembang menjadi kondisi yang lebih serius. Disarankan untuk segera menjalani konseling psikologis guna mendalami permasalahan yang mendasari. Selain itu, aktivitas yang mendukung kesejahteraan mental seperti olahraga ringan, meditasi, atau kegiatan kreatif juga dapat membantu mengurangi gejala depresi.\n\nKecemasan\nKecemasan dengan skor 14 (kategori menengah) menandakan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan kekhawatiran berlebihan. Dampaknya dapat mencakup gangguan tidur, kesulitan untuk fokus, dan kelelahan mental serta fisik yang berlebihan. Direkomendasikan untuk mencoba teknik relaksasi seperti pernapasan dalam atau meditasi mindfulness. Konseling juga dapat membantu individu mengidentifikasi dan mengatasi penyebab utama dari kecemasan yang dialaminya.\n\nStres\nStres dengan skor 16 (kategori rendah) menunjukkan bahwa individu mengalami tingkat tekanan emosional yang relatif minimal. Meskipun demikian, stres yang tidak dikelola dengan baik dapat meningkat seiring waktu dan mempengaruhi kesejahteraan mental dan fisik. Dampak potensial termasuk kelelahan, gangguan tidur, dan kesulitan konsentrasi. Untuk mengelola stres, disarankan untuk menerapkan teknik manajemen stres seperti membuat jadwal harian yang terstruktur, melakukan aktivitas fisik yang teratur, dan meluangkan waktu untuk hobi rekreasi.\n\nProkrastinasi\nProkrastinasi dengan skor 14 (kategori menengah) menunjukkan adanya kecenderungan untuk menunda-nunda tugas dan tanggung jawab. Kebiasaan ini dapat berdampak pada penyelesaian tugas akademik yang tertunda, yang pada gilirannya dapat meningkatkan tingkat stres dan kecemasan. Untuk mengatasi prokrastinasi, disarankan untuk menerapkan teknik manajemen waktu yang efektif seperti memecah tugas besar menjadi langkah-langkah yang lebih kecil, menetapkan tenggat waktu yang realistis, dan menggunakan alat bantu seperti pengingat atau aplikasi manajemen tugas.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 26 (kategori tinggi) menunjukkan bahwa individu mungkin menghabiskan waktu yang berlebihan dengan ponsel, yang dapat mengganggu produktivitas dan mengurangi efisiensi belajar. Hal ini juga dapat mempengaruhi kualitas interaksi sosial dan meningkatkan prokrastinasi. Direkomendasikan untuk membatasi waktu penggunaan ponsel dengan menetapkan batas waktu harian, menggunakan aplikasi yang memantau dan mengontrol penggunaan ponsel, serta menciptakan zona bebas ponsel selama waktu belajar atau berinteraksi dengan orang lain.\n\nKesimpulan\nSecara keseluruhan, kondisi mental yang dialami oleh individu menunjukkan perlunya intervensi menyeluruh untuk mengelola gejala depresi, kecemasan, stres, prokrastinasi, dan kecanduan ponsel. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan penerapan strategi coping yang efektif dapat membantu individu mengelola gejala tersebut dengan lebih baik dan meningkatkan kualitas hidupnya. Langkah-langkah ini akan memberikan dukungan yang diperlukan untuk mencapai kesejahteraan mental yang optimal dan mengembangkan potensi pribadi secara maksimal.	2024-12-26 15:59:25.408893	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
02a27c27-3bea-4359-b6b7-0fd97cfcef6c	t	Depresi\nDepresi dengan skor 28 (kategori sangat tinggi) menandakan bahwa individu mungkin mengalami gejala seperti perasaan putus asa, kehilangan minat dalam aktivitas sehari-hari, dan perasaan rendah diri yang signifikan. Dampak dari depresi ini sangat luas, mencakup penurunan motivasi untuk belajar, kesulitan dalam menjalin hubungan sosial, dan penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani, gejala tersebut dapat berkembang menjadi kondisi yang lebih serius yang memerlukan intervensi medis. Disarankan untuk segera mencari bantuan dari profesional kesehatan mental melalui konseling psikologis dan mempertimbangkan terapi seperti terapi kognitif perilaku. Selain itu, aktivitas fisik seperti olahraga ringan dan praktik mindfulness dapat membantu mengelola gejala depresi.\n\nKecemasan\nKecemasan dengan skor 28 (kategori sangat tinggi) menunjukkan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan khawatir yang berlebihan. Kecemasan ini dapat berdampak pada berbagai aspek kehidupan, seperti gangguan tidur, kesulitan berkonsentrasi, dan kelelahan mental serta fisik. Rasa cemas yang berlebihan juga dapat mengganggu kinerja akademik dan hubungan sosial. Untuk mengelola kecemasan, teknik relaksasi seperti pernapasan dalam dan meditasi direkomendasikan. Konseling dengan seorang terapis dapat membantu mengidentifikasi dan menangani penyebab utama kecemasan. Selain itu, menjaga rutinitas tidur yang baik dan mengurangi konsumsi kafein juga dapat membantu mengurangi gejala kecemasan.\n\nStres\nStres dengan skor 20 (kategori menengah) menunjukkan adanya tekanan emosional yang signifikan yang dapat mempengaruhi kesejahteraan mental dan fisik. Stres ini dapat menyebabkan kelelahan, gangguan tidur, dan kesulitan dalam menyelesaikan tugas sehari-hari. Meskipun tingkat stres ini tidak setinggi kecemasan dan depresi yang dialami, tetap penting untuk mengelola stres agar tidak memperburuk kondisi mental lainnya. Teknik manajemen stres seperti olahraga teratur, aktivitas hobi yang menyenangkan, dan berbagi cerita dengan orang terdekat dapat membantu mengurangi tingkat stres. Jika stres terus berlanjut atau memburuk, konsultasi dengan seorang profesional kesehatan mental disarankan.\n\nProkrastinasi\nProkrastinasi dengan skor 16 (kategori menengah) menunjukkan kecenderungan untuk menunda-nunda tugas yang dapat menyebabkan penundaan dalam penyelesaian pekerjaan akademik atau tugas lainnya. Kebiasaan ini dapat meningkatkan stres dan kecemasan, menciptakan siklus negatif di mana tugas yang tertunda menjadi sumber tekanan tambahan. Untuk mengatasi prokrastinasi, disarankan untuk menerapkan teknik manajemen waktu yang efektif, seperti membuat jadwal harian, memecah tugas besar menjadi bagian yang lebih kecil, dan menetapkan batas waktu yang realistis. Mengenali dan memahami alasan di balik kebiasaan menunda-nunda juga dapat membantu dalam menemukan strategi yang cocok untuk mengatasi masalah ini.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 23 (kategori menengah) mengindikasikan bahwa penggunaan ponsel berlebihan dapat mengganggu waktu produktif, mengurangi efisiensi belajar, dan mempengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel dapat memperburuk prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan perhatian dari tugas-tugas penting. Untuk mengurangi dampak negatif dari kecanduan ponsel, disarankan untuk menetapkan batasan waktu penggunaan ponsel, menggunakan aplikasi pengelola waktu untuk mengatur penggunaan ponsel, dan menciptakan waktu bebas ponsel untuk berfokus pada aktivitas lain yang lebih produktif.\n\nKesimpulan\nSecara keseluruhan, kondisi mental yang dialami menunjukkan perlunya intervensi yang komprehensif. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan penerapan strategi coping dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Langkah awal yang disarankan adalah berkonsultasi dengan profesional kesehatan mental untuk mendapatkan panduan lebih lanjut dan merancang rencana intervensi yang sesuai dengan kebutuhan individu. Dukungan dari keluarga dan lingkungan sekitar juga menjadi faktor penting dalam proses pemulihan ini.	2024-12-26 16:07:53.613978	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
e271624f-6102-401b-b789-4a6fb86538ac	t	Stres  \nStres dengan tingkat sangat tinggi dan skor 36 menunjukkan bahwa individu mengalami tekanan emosional yang signifikan. Tingkat stres yang sangat tinggi ini dapat memengaruhi kesejahteraan mental dan fisik secara serius, termasuk kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas sehari-hari. Stres yang terus-menerus dapat memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan individu untuk berfungsi secara efektif dalam konteks akademik dan sosial. Disarankan untuk segera mengadopsi teknik manajemen stres seperti meditasi, olahraga teratur, dan konseling psikologis untuk mengatasi penyebab utama stres.\n\nKecemasan  \nKecemasan pada tingkat sangat tinggi dengan skor 34 menunjukkan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan. Dampaknya meliputi gangguan tidur, kesulitan berkonsentrasi, dan kelelahan mental serta fisik. Kecemasan yang tidak tertangani dapat mengganggu performa akademik dan hubungan sosial. Direkomendasikan untuk mencoba teknik relaksasi seperti pernapasan dalam atau yoga, serta konseling untuk mengatasi kecemasan. Mencari dukungan dari keluarga atau teman terdekat juga dapat membantu dalam mengurangi perasaan cemas.\n\nDepresi  \nDepresi dengan skor 22 (kategori tinggi) menandakan adanya gejala seperti perasaan putus asa, hilangnya minat dalam aktivitas sehari-hari, atau perasaan rendah diri. Dampak depresi dapat mencakup penurunan motivasi belajar, kesulitan berinteraksi sosial, dan kualitas hidup yang menurun. Jika tidak ditangani, gejala ini dapat berkembang menjadi kondisi yang lebih serius. Disarankan untuk terlibat dalam konseling psikologis dan menjalani aktivitas yang mendukung kesejahteraan mental seperti olahraga ringan atau meditasi. Mempertahankan rutinitas harian yang terstruktur juga dapat membantu mengurangi gejala depresi.\n\nProkrastinasi  \nProkrastinasi dengan tingkat menengah dan skor 16 menunjukkan kecenderungan untuk menunda penyelesaian tugas. Kebiasaan ini dapat berdampak pada peningkatan stres dan kecemasan karena tugas yang tertunda menjadi sumber tekanan tambahan. Hal ini juga dapat mengurangi produktivitas dan kualitas hasil akademik. Untuk mengatasi prokrastinasi, disarankan untuk menetapkan tujuan yang spesifik dan realistis, menggunakan teknik manajemen waktu yang efektif, serta membangun kebiasaan memulai tugas lebih awal. Dukungan dari teman atau mentor juga dapat bermanfaat dalam mengatasi kebiasaan ini.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan tingkat tinggi dan skor 27 menunjukkan bahwa penggunaan ponsel yang berlebihan dapat mengganggu waktu produktif individu, mengurangi efisiensi belajar, serta memengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting. Disarankan untuk menetapkan batasan waktu penggunaan ponsel, menggunakan aplikasi manajemen waktu, dan menggantikan waktu layar dengan aktivitas yang lebih produktif atau sosial.\n\nKesimpulan  \nSecara keseluruhan, kondisi mental yang dialami oleh individu menunjukkan perlunya intervensi yang komprehensif. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup. Menjaga komunikasi yang terbuka dengan keluarga dan teman, serta mencari dukungan profesional jika diperlukan, akan sangat bermanfaat dalam proses pemulihan.	2024-12-26 16:14:07.163859	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
72d11f8d-7e97-4fa5-93ea-52928a1ed3b9	t	Depresi\nDepresi dengan skor 18 (kategori menengah) menunjukkan bahwa individu mungkin mengalami gejala seperti perasaan sedih yang berkepanjangan, kehilangan minat atau kesenangan dalam aktivitas sehari-hari, serta perasaan bersalah atau tidak berharga. Dampaknya dapat meliputi penurunan motivasi dalam menjalani kegiatan sehari-hari, baik di bidang akademis maupun sosial, serta menurunnya kualitas hidup secara umum. Jika tidak ditangani, gejala depresi ini dapat berkembang menjadi lebih serius, mempengaruhi kesehatan mental dan fisik. Disarankan untuk berkonsultasi dengan seorang profesional, seperti psikolog, untuk mendapatkan dukungan dan strategi coping yang tepat, serta melibatkan diri dalam aktivitas yang meningkatkan kesejahteraan mental seperti olahraga atau meditasi.\n\nKecemasan\nKecemasan dengan skor 18 (kategori tinggi) menunjukkan bahwa individu sering kali mengalami perasaan gelisah, tegang, atau khawatir yang berlebihan. Ini bisa mempengaruhi kualitas tidur, kemampuan untuk berkonsentrasi, serta menyebabkan kelelahan emosional dan fisik. Kecemasan yang tinggi dapat menghambat kemampuan individu untuk berfungsi secara optimal dalam kehidupan sehari-hari, termasuk dalam konteks akademis dan sosial. Direkomendasikan untuk mencoba teknik relaksasi, seperti latihan pernapasan dalam atau meditasi, serta mempertimbangkan konseling untuk mengidentifikasi dan menangani penyebab utama dari kecemasan tersebut.\n\nStres\nStres dengan skor 18 (kategori rendah) menunjukkan bahwa individu tidak mengalami tekanan emosional yang signifikan saat ini. Meskipun demikian, penting untuk tetap waspada dan mengembangkan strategi manajemen stres yang efektif untuk mencegah peningkatan stres di masa mendatang, terutama mengingat gejala kecemasan yang tinggi. Aktivitas seperti olahraga, hobi, atau beristirahat secara teratur dapat membantu menjaga tingkat stres tetap terkendali.\n\nProkrastinasi\nProkrastinasi dengan skor 14 (kategori menengah) menunjukkan adanya kecenderungan untuk menunda-nunda penyelesaian tugas. Ini dapat berdampak negatif pada produktivitas dan meningkatkan tingkat stres dan kecemasan, terutama dalam konteks akademik. Kebiasaan menunda-nunda ini dapat memicu siklus yang kurang produktif, di mana tugas yang tertunda menjadi beban tambahan. Disarankan untuk mengembangkan keterampilan manajemen waktu, menetapkan prioritas, dan membagi tugas besar menjadi bagian-bagian yang lebih kecil untuk memudahkan penyelesaian.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 21 (kategori menengah) menunjukkan bahwa individu memiliki kecenderungan untuk menghabiskan waktu yang signifikan dengan ponsel. Hal ini dapat mengganggu waktu produktif, mengurangi efisiensi belajar, serta mempengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting. Disarankan untuk menetapkan batas waktu penggunaan ponsel, menggunakan aplikasi pengingat untuk mengelola waktu, dan mencari aktivitas alternatif yang lebih bermanfaat.\n\nKesimpulan\nSecara keseluruhan, kondisi mental yang dialami oleh individu menunjukkan perlunya intervensi yang holistik. Kombinasi dari konseling psikologis untuk mengatasi kecemasan dan depresi, pelatihan manajemen waktu untuk mengurangi prokrastinasi, serta strategi coping untuk mengelola stres dan kecanduan ponsel dapat membantu individu mengelola gejala secara efektif dan meningkatkan kualitas hidup secara keseluruhan. Monitoring dan dukungan berkelanjutan dari keluarga dan teman juga dapat berperan penting dalam proses pemulihan.	2024-12-26 16:43:42.152123	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7	t	Depresi  \nDepresi dengan skor 32 (kategori sangat tinggi) menunjukkan bahwa individu mungkin mengalami perasaan putus asa, kehilangan minat dalam aktivitas sehari-hari, atau perasaan rendah diri yang mendalam. Dampak dari depresi ini dapat mencakup penurunan motivasi belajar, kesulitan dalam berinteraksi sosial, serta penurunan kualitas hidup secara keseluruhan. Jika tidak ditangani dengan baik, gejala ini berpotensi berkembang menjadi kondisi yang lebih serius dan mempengaruhi kesejahteraan secara signifikan.\n\nDisarankan untuk segera mencari bantuan dari profesional kesehatan mental, seperti psikolog atau psikiater, guna mendapatkan penanganan yang tepat. Selain itu, individu juga dapat mencoba terlibat dalam aktivitas yang mendukung kesejahteraan mental, seperti olahraga ringan, meditasi, atau kegiatan yang menyenangkan dan menenangkan. Melibatkan diri dalam komunitas atau kelompok dukungan juga dapat memberikan manfaat tambahan dalam mengurangi perasaan terisolasi.\n\nKecemasan  \nKecemasan dengan skor 26 (kategori sangat tinggi) menandakan bahwa individu mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan dalam berbagai situasi. Dampaknya bisa meliputi gangguan tidur, kesulitan dalam berkonsentrasi, serta kelelahan mental dan fisik yang berkepanjangan. Kondisi ini juga dapat mempengaruhi performa akademik dan hubungan sosial secara negatif.\n\nUntuk mengatasi kecemasan, direkomendasikan untuk mencoba teknik relaksasi seperti pernapasan dalam atau meditasi mindfulness. Konseling psikologis juga dapat sangat membantu dalam mengidentifikasi dan menangani penyebab utama dari kecemasan tersebut. Latihan fisik yang teratur dan menjaga pola tidur yang baik juga bisa membantu dalam mengurangi gejala kecemasan.\n\nStres  \nStres dengan skor 22 (kategori menengah) menunjukkan bahwa individu mengalami tekanan emosional yang cukup signifikan, yang dapat memengaruhi kesejahteraan mental dan fisik. Dampak stres ini dapat berupa kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas sehari-hari. Jika dibiarkan, stres dapat memperburuk gejala kecemasan dan depresi serta mengurangi kemampuan untuk berfungsi secara efektif dalam konteks akademik dan sosial.\n\nUntuk mengelola stres, penting untuk mengidentifikasi sumber utama stres dan mencari cara untuk mengatasinya. Teknik manajemen stres seperti olahraga, yoga, atau hobi yang menyenangkan bisa sangat bermanfaat. Selain itu, mengatur waktu dengan baik dan membuat prioritas dalam tugas-tugas harian juga dapat membantu mengurangi beban stres. Konsultasi dengan profesional jika stres mulai mengganggu kehidupan sehari-hari secara signifikan.\n\nProkrastinasi  \nProkrastinasi dengan skor 14 (kategori menengah) menunjukkan bahwa individu mungkin mengalami kebiasaan menunda-nunda yang dapat mempengaruhi penyelesaian tugas. Dampak dari prokrastinasi ini bisa meningkatkan stres dan kecemasan, serta mengurangi produktivitas dan kualitas hasil akademik.\n\nDisarankan untuk mulai menerapkan teknik manajemen waktu yang efektif, seperti membuat jadwal harian dan menetapkan batas waktu yang realistis untuk setiap tugas. Memecah tugas besar menjadi bagian yang lebih kecil juga dapat membuatnya lebih mudah dikelola. Menetapkan lingkungan kerja yang bebas dari gangguan dan menggunakan teknik motivasi diri juga dapat membantu mengurangi prokrastinasi.\n\nKecanduan Ponsel  \nKecanduan ponsel dengan skor 19 (kategori menengah) menunjukkan bahwa penggunaan ponsel mungkin sudah mulai mengganggu waktu produktif individu, mengurangi efisiensi belajar, serta mempengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, mengalihkan fokus dari tugas-tugas penting, dan pada akhirnya meningkatkan tingkat stres.\n\nUntuk mengatasi kecanduan ponsel, disarankan untuk menetapkan batas waktu penggunaan ponsel setiap hari dan mencoba untuk tidak menggunakan ponsel di saat-saat yang tidak penting, seperti sebelum tidur. Menggunakan aplikasi pengingat waktu atau fitur pembatasan pada ponsel juga dapat membantu mengurangi penggunaan yang berlebihan. Mengganti waktu yang dihabiskan untuk ponsel dengan kegiatan lain yang lebih bermanfaat dapat membantu mengurangi ketergantungan secara bertahap.\n\nKesimpulan  \nSecara keseluruhan, kondisi mental yang dialami menunjukkan perlunya intervensi yang menyeluruh dan terfokus. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping yang efektif dapat membantu individu dalam mengelola gejala-gejala tersebut secara lebih baik serta meningkatkan kualitas hidup secara keseluruhan. Langkah awal yang positif adalah dengan mencari dukungan dari profesional dan orang-orang terdekat untuk perjalanan pemulihan yang lebih baik.	2024-12-26 16:51:32.213816	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
5915c42b-fdd7-43b8-9808-5b3a8efae88f	t	Stres\nDengan skor 12, tingkat stres individu berada dalam kategori normal. Ini menunjukkan bahwa saat ini individu mampu mengelola tekanan sehari-hari dengan baik dan tidak mengalami stres yang berlebihan. Stres pada tingkat ini biasanya tidak menimbulkan masalah kesehatan mental atau fisik yang signifikan, dan individu cenderung memiliki mekanisme koping yang efektif untuk menghadapi tantangan yang dihadapinya.\n\nUntuk mengelola stres agar tetap dalam tingkat normal, disarankan agar individu tetap menjaga keseimbangan antara waktu belajar dan istirahat. Melakukan aktivitas fisik secara teratur, seperti berjalan kaki atau berolahraga ringan, dapat membantu meredakan stres. Selain itu, teknik relaksasi seperti meditasi atau pernapasan dalam juga bisa menjadi cara yang efektif untuk menjaga ketenangan pikiran.\n\nKecemasan\nKecemasan dengan skor 2 menunjukkan bahwa individu berada dalam tingkat kecemasan yang sangat rendah. Ini menandakan bahwa individu tidak sering merasa khawatir berlebihan atau gelisah mengenai situasi sehari-hari. Pada tingkat ini, kecemasan tidak mengganggu fungsi sehari-hari dan tidak mempengaruhi kesehatan mental secara negatif.\n\nUntuk mempertahankan tingkat kecemasan yang rendah, individu dapat melanjutkan kebiasaan positif yang telah dilakukan. Menjaga rutinitas harian yang teratur, memastikan waktu tidur yang cukup, dan terlibat dalam aktivitas yang menyenangkan dapat membantu mencegah meningkatnya kecemasan. Jika muncul situasi yang menimbulkan kekhawatiran, berbagi cerita dengan orang terpercaya seperti teman atau keluarga dapat menjadi langkah baik.\n\nDepresi\nDengan skor 8, tingkat depresi individu juga berada dalam kategori normal. Ini menunjukkan bahwa individu tidak mengalami gejala depresi yang signifikan seperti perasaan putus asa atau kehilangan minat yang berkepanjangan. Kondisi ini mencerminkan keseimbangan emosional yang baik dan kemampuan untuk menikmati aktivitas sehari-hari.\n\nUntuk menghindari munculnya gejala depresi, penting untuk terus menjaga hubungan sosial yang positif dan terlibat dalam aktivitas yang memberikan kebahagiaan. Menyisihkan waktu untuk hobi atau kegiatan baru juga dapat menjadi cara efektif untuk meningkatkan suasana hati. Jika individu merasa mulai kehilangan minat atau semangat, mencari dukungan dari teman atau keluarga bisa sangat membantu.\n\nProkrastinasi\nProkrastinasi dengan skor 8 berada dalam tingkat sangat rendah, yang menunjukkan bahwa individu jarang menunda pekerjaan atau tugas yang perlu diselesaikan. Ini berarti individu memiliki kemampuan manajemen waktu yang baik dan cenderung menyelesaikan tugas tepat waktu, yang berdampak positif pada produktivitas akademik dan keseharian.\n\nUntuk mempertahankan kebiasaan baik ini, individu dapat terus membuat daftar prioritas harian atau mingguan untuk tetap fokus pada tugas-tugas penting. Mengatur waktu belajar dan istirahat secara seimbang juga dapat membantu menjaga efisiensi kerja. Jika individu merasa mulai menunda-nunda, menerapkan teknik manajemen waktu seperti metode Pomodoro bisa menjadi solusi yang efektif.\n\nKecanduan Ponsel\nDengan skor 25, kecanduan ponsel berada dalam kategori tinggi. Ini menunjukkan bahwa individu mungkin menghabiskan waktu yang signifikan menggunakan ponsel, yang bisa mengganggu aktivitas sehari-hari, seperti belajar atau bersosialisasi. Ketergantungan ini berpotensi mengganggu produktivitas dan kualitas tidur, serta menambah tingkat stres.\n\nUntuk mengatasi kecanduan ponsel, individu dapat memulai dengan menetapkan batasan waktu penggunaan harian dan menggunakan aplikasi yang memantau durasi penggunaan ponsel. Mengalihkan perhatian ke aktivitas lain seperti membaca atau berolahraga juga bisa membantu. Selain itu, menetapkan waktu tanpa ponsel, khususnya sebelum tidur, dapat meningkatkan kualitas tidur dan membantu mengurangi ketergantungan.\n\nKesimpulan\nSecara keseluruhan, analisis menunjukkan bahwa individu memiliki kesehatan mental yang baik dengan tingkat stres, kecemasan, dan depresi yang berada dalam kategori normal. Namun, perhatian perlu diberikan pada kecanduan ponsel yang tinggi. Dengan langkah-langkah praktis seperti menetapkan batas penggunaan ponsel dan menjaga keseimbangan hidup, individu dapat mengelola gejala ini dengan lebih baik dan meningkatkan kualitas hidup secara keseluruhan.	2024-12-26 17:02:38.713702	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
e508e3a9-e992-4a59-8b31-e01b39bad462	t	Depresi\nDepresi dengan skor 24 (kategori tinggi) menunjukkan bahwa individu mungkin merasakan perasaan putus asa, kehilangan minat pada aktivitas yang biasanya menyenangkan, serta perasaan rendah diri yang signifikan. Dampak dari depresi ini dapat mencakup penurunan motivasi belajar, kesulitan dalam berinteraksi sosial, dan kualitas hidup yang menurun secara keseluruhan. Jika tidak diatasi, kondisi ini bisa berkembang menjadi lebih parah dan mempengaruhi berbagai aspek kehidupan sehari-hari.\n\nUntuk mengatasi gejala depresi, penting bagi individu untuk mencari dukungan dari orang-orang terdekat, seperti teman atau keluarga yang dapat dipercaya. Selain itu, konsultasi dengan profesional kesehatan mental, seperti psikolog, dapat memberikan strategi dan alat untuk mengelola gejala depresi. Mengadopsi rutinitas harian yang sehat, termasuk olahraga teratur dan kegiatan yang meningkatkan kebahagiaan, seperti hobi atau meditasi, juga dapat membantu memperbaiki suasana hati dan meningkatkan kesejahteraan emosional.\n\nKecemasan\nKecemasan dengan skor 18 (kategori tinggi) menandakan bahwa individu sering merasa gelisah, tegang, dan mengalami kekhawatiran berlebihan tentang berbagai aspek kehidupan. Dampak dari kecemasan ini dapat meliputi gangguan tidur, kesulitan berkonsentrasi, dan kelelahan mental maupun fisik yang berkepanjangan. Jika tidak ditangani, kecemasan yang tinggi dapat mengganggu kemampuan untuk berfungsi secara efektif dalam kehidupan sehari-hari.\n\nUntuk meredakan kecemasan, disarankan untuk mencoba teknik relaksasi, seperti pernapasan dalam atau meditasi mindfulness, yang dapat membantu menenangkan pikiran dan tubuh. Mengidentifikasi dan menantang pikiran yang memicu kecemasan melalui konseling juga bisa sangat bermanfaat. Membuat jadwal yang teratur dan memprioritaskan waktu untuk istirahat dan relaksasi dapat membantu mengurangi tingkat kecemasan dan meningkatkan kesejahteraan secara keseluruhan.\n\nStres\nStres dengan skor 20 (kategori menengah) menunjukkan bahwa individu sedang mengalami tekanan emosional yang cukup signifikan, meskipun belum mencapai tingkat yang sangat tinggi. Dampaknya dapat berupa kelelahan, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas harian. Stres yang berlangsung lama juga dapat memperburuk kondisi mental lainnya, seperti kecemasan dan depresi.\n\nUntuk mengelola stres, penting bagi individu untuk mempraktikkan manajemen waktu yang efektif, termasuk menetapkan prioritas dan membagi tugas menjadi bagian-bagian yang lebih kecil dan dapat dikelola. Aktivitas fisik secara teratur, seperti berjalan kaki atau olahraga ringan, dapat membantu mengurangi stres dan meningkatkan suasana hati. Jika stres terus meningkat, berbicara dengan konselor atau terapis dapat memberikan wawasan dan strategi tambahan untuk mengatasi tekanan emosional.\n\nProkrastinasi\nProkrastinasi dengan skor 16 (kategori menengah) menunjukkan bahwa individu cenderung menunda tugas-tugas penting, yang dapat menyebabkan penundaan dalam penyelesaian pekerjaan akademik dan meningkatkan tingkat stres serta kecemasan. Kebiasaan ini bisa menciptakan siklus negatif di mana tugas yang belum terselesaikan menambah beban mental.\n\nUntuk mengurangi prokrastinasi, individu dapat mencoba membuat daftar tugas dengan batas waktu yang jelas dan memecah tugas besar menjadi langkah-langkah yang lebih kecil dan lebih mudah dikelola. Menggunakan teknik manajemen waktu, seperti metode Pomodoro (bekerja selama 25 menit diikuti dengan istirahat singkat), dapat meningkatkan fokus dan produktivitas. Menetapkan lingkungan kerja yang kondusif dan bebas gangguan juga dapat membantu individu tetap on-track dengan tugas-tugas mereka.\n\nKecanduan Ponsel\nKecanduan ponsel dengan skor 19 (kategori menengah) menunjukkan bahwa individu mungkin menghabiskan banyak waktu untuk menggunakan ponsel, yang dapat mengganggu produktivitas dan kualitas interaksi sosial. Ketergantungan ini juga bisa meningkatkan kecenderungan untuk prokrastinasi, karena waktu yang dihabiskan di ponsel dapat mengalihkan perhatian dari tugas-tugas penting.\n\nUntuk mengatasi kecanduan ponsel, individu dapat mencoba menetapkan batasan waktu penggunaan ponsel dan menggunakan aplikasi pengelola waktu untuk memantau penggunaan harian. Mengatur "waktu bebas ponsel" di mana individu tidak menggunakan ponsel, terutama sebelum tidur, dapat membantu mengurangi ketergantungan. Mengalihkan perhatian pada aktivitas lain yang lebih bermanfaat, seperti membaca atau berolahraga, juga dapat membantu mengurangi penggunaan ponsel yang berlebihan.\n\nKesimpulan\nSecara keseluruhan, hasil analisis menunjukkan perlunya perhatian lebih terhadap kesejahteraan mental individu, terutama terkait dengan gejala depresi, kecemasan, dan stres. Dengan kombinasi langkah-langkah seperti mencari dukungan sosial, menerapkan teknik relaksasi, dan manajemen waktu yang efektif, individu dapat mengelola gejala dan meningkatkan kesehatan mental mereka secara bertahap dan efektif. Konsultasi dengan profesional kesehatan mental juga dianjurkan untuk mendapatkan bantuan lanjutan dan strategi penanganan yang lebih terarah.	2024-12-26 17:10:33.695021	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
112e0f11-5dd1-4238-8152-ae6453534921	t	Stres\nStres yang dialami individu dengan skor 30 dalam kategori tinggi menunjukkan adanya tekanan emosional yang signifikan. Hal ini mungkin terjadi karena tuntutan akademik, perasaan kewalahan, atau tantangan lain dalam kehidupan sehari-hari. Dampaknya bisa berupa kelelahan kronis, sulit tidur, atau bahkan kurangnya motivasi untuk melakukan aktivitas yang biasa dinikmati. Individu mungkin merasa terjebak dalam siklus di mana stres memperburuk kesejahteraan mental dan fisik.\n\nUntuk mengelola stres ini, disarankan agar individu mulai menerapkan teknik relaksasi seperti meditasi atau yoga yang dapat membantu menenangkan pikiran. Mengatur waktu dengan membuat jadwal harian juga bisa membantu mengurangi rasa kewalahan. Selain itu, berbicara dengan teman atau keluarga mengenai apa yang dirasakan bisa menawarkan dukungan emosional yang penting.\n\nKecemasan\nDengan skor 28 dan masuk dalam kategori sangat tinggi, kecemasan yang dialami individu bisa sangat mengganggu. Perasaan khawatir yang berlebihan, tegang, dan tidak bisa tenang mungkin sering muncul tanpa alasan yang jelas. Kecemasan ini bisa mengganggu konsentrasi, menyebabkan tidur yang tidak nyenyak, dan menguras energi baik secara mental maupun fisik.\n\nUntuk menghadapi kecemasan ini, individu bisa mencoba latihan pernapasan dalam atau teknik mindfulness untuk mengalihkan fokus dari rasa cemas. Berolahraga secara teratur juga dapat membantu melepaskan hormon endorfin yang dapat meningkatkan suasana hati. Jika memungkinkan, berkonsultasi dengan konselor atau psikolog bisa membantu menemukan akar masalah dan strategi penanganan yang lebih dalam.\n\nDepresi\nDengan skor 26 dan berada pada tingkat tinggi, depresi yang dialami mungkin membuat individu merasa sedih, tidak bersemangat, dan kehilangan minat pada aktivitas sehari-hari. Depresi ini bisa mempengaruhi cara pandang terhadap diri sendiri dan dunia sekitar, serta berdampak pada hubungan sosial.\n\nLangkah pertama yang dapat diambil untuk mengatasi depresi adalah dengan melakukan aktivitas fisik ringan seperti berjalan kaki, yang dapat membantu meningkatkan suasana hati. Menjaga rutinitas harian dan memastikan mendapatkan tidur yang cukup juga penting. Apabila gejala terus berlangsung, mencari bantuan profesional bisa menjadi pilihan terbaik untuk mendapatkan dukungan dan terapi yang sesuai.\n\nProkrastinasi\nProkrastinasi dengan skor 17 pada tingkat menengah menunjukkan bahwa individu cenderung menunda tugas-tugas tertentu. Hal ini bisa menjadi sumber stres tambahan ketika pekerjaan menumpuk di akhir waktu. Kebiasaan ini mungkin disebabkan oleh kurangnya motivasi atau ketakutan akan kegagalan.\n\nUntuk mengatasi prokrastinasi, disarankan agar individu memecah tugas besar menjadi bagian-bagian kecil yang lebih mudah dikelola. Menetapkan tenggat waktu yang realistis dan memberikan diri sendiri penghargaan kecil setelah menyelesaikan tugas dapat membantu meningkatkan motivasi. Mengidentifikasi dan mengubah pola pikir yang mendorong penundaan juga bisa memberikan perubahan positif.\n\nKecanduan Ponsel\nDengan skor 19 dan dalam kategori menengah, kecanduan ponsel menunjukkan bahwa individu mungkin menghabiskan waktu yang berlebihan di depan layar. Hal ini bisa mengganggu waktu belajar, mengurangi produktivitas, dan mempengaruhi interaksi sosial secara langsung.\n\nUntuk mengurangi ketergantungan ini, individu bisa mencoba menetapkan batasan waktu penggunaan ponsel harian dan lebih fokus pada kegiatan tanpa ponsel, seperti membaca buku atau berolahraga. Menggunakan aplikasi yang memantau waktu layar dan menyediakan alarm sebagai pengingat untuk beristirahat dari ponsel juga bisa bermanfaat. Memprioritaskan interaksi tatap muka dibandingkan komunikasi digital dapat membantu memperbaiki kualitas hubungan sosial.\n\nKesimpulan\nSecara keseluruhan, individu mengalami kombinasi gejala yang menunjukkan adanya tekanan mental yang cukup besar. Penting bagi individu untuk mengambil langkah-langkah awal dalam mengelola stres, kecemasan, dan depresi melalui strategi yang telah disebutkan. Dengan dukungan dari orang-orang terdekat dan kemungkinan intervensi profesional, individu dapat meningkatkan kesejahteraan mental dan emosionalnya, serta memperbaiki kualitas hidup secara keseluruhan.	2024-12-26 17:20:57.458567	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd	t	Prokrastinasi\n\nProkrastinasi yang Anda alami mencapai tingkat yang sangat tinggi dengan skor 25. Ini menunjukkan bahwa Anda kerap menunda-nunda tugas atau pekerjaan yang seharusnya diselesaikan. Mungkin Anda merasa kesulitan untuk memulai atau menyelesaikan tugas, sehingga sering kali merasa terburu-buru menjelang batas waktu. Dampak dari prokrastinasi ini bisa berupa peningkatan stres ketika harus menyelesaikan banyak hal dalam waktu singkat, dan mungkin juga mengurangi kualitas hasil pekerjaan Anda. Ini adalah siklus yang bisa menjadi cukup melelahkan, baik secara fisik maupun mental, karena Anda selalu berada di bawah tekanan dari tenggat waktu yang mendekat.\n\nUntuk mengatasi kebiasaan menunda ini, ada beberapa langkah praktis yang bisa Anda coba. Mulailah dengan membuat jadwal harian yang terstruktur dan realistis, serta menetapkan prioritas pada tugas yang paling penting. Cobalah untuk memecah tugas besar menjadi bagian-bagian kecil yang lebih mudah dikelola, sehingga Anda tidak merasa kewalahan. Selain itu, menetapkan batas waktu internal sebelum batas waktu resmi dapat membantu Anda mengerjakan tugas dengan lebih efektif. Jangan lupa untuk memberikan diri Anda waktu istirahat yang cukup untuk menghindari kelelahan.\n\nKecanduan Ponsel\n\nKecanduan ponsel Anda berada pada tingkat yang sangat rendah dengan skor 11, yang berarti penggunaan ponsel Anda masih dalam batas wajar dan tidak menimbulkan masalah berarti. Anda tampaknya mampu mengendalikan penggunaan ponsel sehingga tidak mengganggu aktivitas sehari-hari atau interaksi sosial Anda. Ini adalah hal yang positif, karena penggunaan ponsel yang berlebihan dapat mengarah pada penurunan produktivitas dan gangguan fokus.\n\nMeski demikian, Anda bisa tetap menjaga penggunaan ponsel dalam batas yang sehat dengan menetapkan waktu khusus untuk memeriksa ponsel, misalnya setelah menyelesaikan tugas atau saat istirahat. Cobalah untuk menghindari penggunaan ponsel saat sedang mengerjakan tugas penting, agar bisa lebih fokus. Jika memungkinkan, aktifkan mode "Do Not Disturb" atau matikan notifikasi yang tidak penting untuk mengurangi gangguan.\n\nKesimpulan\n\nSecara keseluruhan, Anda memiliki keseimbangan mental yang baik dengan tingkat kecemasan, stres, dan depresi yang berada pada level normal. Tantangan utama Anda saat ini adalah mengatasi prokrastinasi yang tinggi. Dengan langkah-langkah manajemen waktu dan disiplin diri yang tepat, Anda dapat meningkatkan produktivitas dan mengurangi stres yang diakibatkan oleh penundaan. Sementara itu, penggunaan ponsel yang terkendali merupakan kelebihan yang patut dipertahankan untuk mendukung keseimbangan hidup Anda. Tetaplah berfokus pada strategi yang membantu Anda menjaga kesehatan mental dan produktivitas, serta jangan ragu untuk mencari dukungan jika diperlukan.	2024-12-26 17:23:40.207399	1667321d-25f3-43ba-b90c-cca473d127d0	3fac0f46-0dbf-4069-8fb3-d0234e0472bf
\.


--
-- Data for Name: userEminds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."userEminds" (id, email, username, password, "birthDate", "yearEntry", "createdAt", "updatedAt", gender, "roleId", "facultyId", nim, "psikologStatus", "authId", "preKuisionerId") FROM stdin;
e889f730-827f-4285-bd6a-6ecc1f7d995d	d.raihan2004@gmail.com	Muhammad Daffa Raihan Psikolog	$2b$11$uRwjBFyc3D3zS2/5k..m2u17ZcLzpeloFI7jBBSKBl472yKBEfJsK	\N	2023	2024-10-15 21:12:44.147703	2024-10-17 17:25:54.137475	Laki-Laki	ef95c08f-856e-49cc-a75a-0ac928b4abcd	\N	22523184	approved	199d2e68-6d78-438d-9d92-e8f0788c8316	\N
2f0822f5-1ed5-4ecc-8e9c-93491dc93d04	tesclient3@gmail.com	tes3 client	$2b$11$fBzALn4a/islTkzzz/0XPeST2qvueuuChXSuSvRMEo0X18rGmCm0e	\N	\N	2024-10-22 15:19:03.35485	2024-10-22 15:19:03.35485	Perempuan	76e175bf-25d3-4ab6-83fd-5b6e60e39352	\N	\N	\N	6b467547-1c2f-4193-9cf3-7c54c35341ec	\N
b7328825-2d44-4b59-a4ba-77d6b42faa3b	tesclient5@gmail.com	tes5 client	$2b$11$lCxMIvqbed9XQhmzqpZfhukEjVGwM.opwZxayIX0ehPJi2HjM7tni	\N	\N	2024-10-24 18:27:23.962936	2024-10-24 18:27:23.962936	\N	76e175bf-25d3-4ab6-83fd-5b6e60e39352	\N	\N	\N	1b4d0d00-7d71-4e44-9681-56d2daa02822	\N
f8997945-4110-495e-813b-f0ee1049fefb	tesclient@gmail.com	tes2 client	$2b$11$zs5BRA3TFjc2c483sImeROJg5VZvho1jXhEwRH1mJbLHiSPkuXcXW	\N	\N	2024-10-22 15:18:11.473594	2024-10-22 15:18:11.473594	Laki-Laki	ef95c08f-856e-49cc-a75a-0ac928b4abcd	\N	\N	pending	0122c96e-a16e-4a1a-8ce0-dbc026ea8b3a	\N
26d52cc3-f2e0-4be1-8cd8-ca2a193a242a	tesclient4@gmail.com	tes3 client	$2b$11$xNuw12vSbOU2hyw7VGVhY.neHG9ia9GbKhhQXJpmrHPxHzMa.h0wW	\N	\N	2024-10-24 18:26:08.796213	2024-10-24 18:26:08.796213	Laki-Laki	76e175bf-25d3-4ab6-83fd-5b6e60e39352	\N	\N	\N	18c9184a-c88d-4988-a2b7-2f08d43190b3	\N
4aeefde1-ab5f-4129-bde2-9feace8e9315	22523184@students.uii.ac.id	Muhammad Daffa Raihan SuperAdmin	$2b$11$.zpcwl0hNp5eV9DdKcfw.e8U0vfXGFc0mf/VK6aE3.mofw7K2IWw2	2002-06-04	2022	2024-10-08 14:16:27.500155	2024-11-19 16:09:12.605153	Laki-Laki	38d3223a-1260-42bf-a317-67bed6eba681	eb935226-da6b-45fa-8937-70f51454bde8	22523184	approved	1a0355a7-39bc-423d-99b1-d350615ba2fd	\N
da50cf79-ee3b-4651-8dfe-45e9034057cd	kedathons@gmail.com	Sekar Aroem Kedathon	$2b$11$cBxn1j2EcdvvNT8UOwWd6eRsoC0GRUKccxxjjoLP/qqv6.XliOLTO	2004-04-20	2022	2024-11-10 21:15:39.047905	2024-11-22 00:07:01.084191	Laki-Laki	76e175bf-25d3-4ab6-83fd-5b6e60e39352	99f6b5b2-b0e5-4bc2-8c4e-bc7f5f6a8842	22523184	\N	127feaae-b529-4917-8bf1-e0c4f321deaa	80a92ade-79bc-4177-9012-6e7e3fc0f5ed
62b4ba92-0209-41a2-bc01-885f1dc14dce	daffaraihan2004.work@gmail.com	Muhammad Daffa Raihan	$2b$11$jWdgDGm7V4omsa9K78y9ReF/EidzQNKC5A1M68CAWsjfVZ19H0fC6	2004-04-20	2022	2024-11-26 14:47:28.193559	2024-11-26 17:19:19.107911	Laki-Laki	76e175bf-25d3-4ab6-83fd-5b6e60e39352	99f6b5b2-b0e5-4bc2-8c4e-bc7f5f6a8842	22523184	\N	08b8c8d7-8823-4708-8be1-cf337f39133e	99a32e09-004b-480d-a5eb-a5bec4a33083
3fac0f46-0dbf-4069-8fb3-d0234e0472bf	elangsamudra474@gmail.com	Elang S	$2b$11$qVSHJ1yGORSc0TtzO4tQw.5AwVo/buev8ikKcXJfg/lUBqu0MZn22	2004-06-17	2022	2024-12-26 10:46:42.223964	2024-12-26 11:47:02.495836	Laki-Laki	76e175bf-25d3-4ab6-83fd-5b6e60e39352	bb845b33-71f1-4ab1-9a3c-2c06cd7a76f6	22523008	\N	83a68f38-1ec3-4919-acc5-ff62e7afa719	033fcf78-b3a3-4c81-b7a7-12b5896709b7
\.


--
-- Data for Name: user_answer_kuisioner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_answer_kuisioner (id, "userAnswerSubKuisionerId", "answerId") FROM stdin;
eb8e8f66-eb60-4a05-bcd2-7555e8345200	40568443-059f-47f8-9219-870e40bd310b	d85ccb92-9175-4029-827c-2ccade6984e3
d884375f-9db4-4a14-a065-e19609e96377	40568443-059f-47f8-9219-870e40bd310b	1dbbe31c-27f2-47c4-a200-2346d84314b7
2f481634-2f6e-4c7a-8f12-9d6d3dbc82d4	40568443-059f-47f8-9219-870e40bd310b	f4433601-a483-44d6-8c98-898ff69193d1
1949eba5-271f-41f1-b033-0dc2a114fdae	40568443-059f-47f8-9219-870e40bd310b	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
eef772de-7642-4012-b58b-0660c4e2bbdc	40568443-059f-47f8-9219-870e40bd310b	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
659ac562-600c-4359-9c97-3e4c65419a60	40568443-059f-47f8-9219-870e40bd310b	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
1b587881-2401-405c-a53b-ed2d6d39bcfa	40568443-059f-47f8-9219-870e40bd310b	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
03b8299d-e20a-46bc-86c0-8bcef878b9dc	903a7144-d613-4ded-8956-1522e074a8e4	03999e08-b875-4f63-bf97-c220705ba672
66038237-ddba-4689-823b-3e9d7da490fb	903a7144-d613-4ded-8956-1522e074a8e4	00452b01-da8a-4380-8759-877c80f392dd
bd2cb6b8-2386-4f28-9b0c-ce343f0e82c1	903a7144-d613-4ded-8956-1522e074a8e4	f4433601-a483-44d6-8c98-898ff69193d1
b54ce725-5c46-43c7-a440-cc2c4c23899e	903a7144-d613-4ded-8956-1522e074a8e4	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
e95f1ffb-9f04-4772-b808-aa6554bca8d8	903a7144-d613-4ded-8956-1522e074a8e4	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
ad11b180-169d-484d-b3c7-0e4b0e276f9c	903a7144-d613-4ded-8956-1522e074a8e4	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
3497b7b1-967e-48e1-ad39-02b89622e572	903a7144-d613-4ded-8956-1522e074a8e4	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
97441596-0b36-48c2-8959-c39b93698598	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	8c96bcec-e94f-4470-9096-3b034db6ef57
86730101-104b-48ff-8590-217f63d68401	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
7d44475f-caec-40f2-9360-3ae41d7f52f2	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	631d799c-e4cc-4f12-b74e-973dabb21075
bce2c90c-37b2-42d7-b968-17f2ece8278d	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	8b764a87-01f9-4624-9f9c-2c8317269799
59f55dbf-074e-411b-aebb-b614e0b678c9	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	02df8cb1-f817-4182-a8da-24f24737babc
eae02164-cc01-4a5b-bc50-308aaf7e34e2	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	6c0eeba4-a22a-4e64-8058-ab328711b8b0
ed76876c-b3ab-4d30-8348-2d51143a5b6a	44c6bf49-7e68-4f7a-b30a-66571dbec2a9	8a245a89-7254-42d9-b8fd-2eac410a5585
69732373-bab5-4991-b9b5-06c8aab7a335	eed7b13d-98fe-4d77-bd15-5e82d610719b	02dbd7ca-f388-43fd-9548-173a35837682
1d76f370-874c-49c2-ae22-95911eb69500	eed7b13d-98fe-4d77-bd15-5e82d610719b	0cba341f-4f70-4f9e-b03c-177862b22df3
56aaedcd-c3ff-4795-b3f5-2519b0759100	eed7b13d-98fe-4d77-bd15-5e82d610719b	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
ed12aaf5-70a6-40e1-870e-23bd00cbdd5a	eed7b13d-98fe-4d77-bd15-5e82d610719b	aad04f4c-db14-4ef4-9998-686fa9002e11
23c3bc03-8851-4ab5-a1b3-ce8f2c6c96b3	eed7b13d-98fe-4d77-bd15-5e82d610719b	82c07f83-9ab1-4097-ad30-36e7d81d1340
f04f0481-3652-42e8-a663-14751ed62d45	eed7b13d-98fe-4d77-bd15-5e82d610719b	e20b945b-e86b-46ac-8513-ebbfaa9a4560
1fa657bb-f7b2-479f-8b40-68cf850eb3bf	833c6009-fb14-42d5-88cf-4f29084c893c	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
390a9361-4d47-4c80-87dd-c52ca329d095	833c6009-fb14-42d5-88cf-4f29084c893c	40c13606-829a-4d32-9a2f-634465feb1b3
cf89db63-4267-4090-9f3b-d925423fad42	833c6009-fb14-42d5-88cf-4f29084c893c	c83b9a45-346e-41f7-ac61-39811253a2a4
fe5c8da5-a02d-47c9-a39d-f2fffc9aaa57	833c6009-fb14-42d5-88cf-4f29084c893c	6b428caa-622b-47c3-824b-3c755683a21c
85d3f925-79a1-47c3-b12b-76af06996e2d	833c6009-fb14-42d5-88cf-4f29084c893c	011875b1-f030-4ee5-a103-7a5900a6b8b6
bfd2b423-864a-4f18-9ac8-1be024f6c664	833c6009-fb14-42d5-88cf-4f29084c893c	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
746de8db-5866-4adb-a241-9b987d2c8dca	833c6009-fb14-42d5-88cf-4f29084c893c	4974c20a-94d5-4a52-983f-4abba57a225b
43e67006-adca-4196-b52a-a676e878cc00	c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	67ae3aea-4ab7-402b-9c64-9772d924bf69
4c515dbf-d18a-46c5-ba96-4cb08bada0cd	c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	decba44a-23dc-4d6b-b754-4799e45488d6
0436bff2-3aa2-4d1d-bd88-244359bdc8c3	c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	0261cf0e-50e4-4252-a269-ab1d16187042
9013bf76-53fa-492d-ad20-fc0805e7a434	c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
32554fb9-7b97-4482-a8ab-717bd6a12762	c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	64c02f11-0204-4a11-be07-68ef5b0f36f1
195ebef7-0176-45ca-be5f-15a3abd1aafc	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	03999e08-b875-4f63-bf97-c220705ba672
6ba3f27b-3192-48c3-b99b-f4c2883816b8	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	1dbbe31c-27f2-47c4-a200-2346d84314b7
6e56ff6a-f8d2-4185-9bfc-b90838d51cd2	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	f4433601-a483-44d6-8c98-898ff69193d1
0e45edad-5bd4-40a5-ae1d-6cc7d2b27dac	7f1d35bf-6040-418b-8de5-fc5b885af86c	6e8aa530-4d74-4e8c-babd-274b66ba6b69
528f9213-085e-4dee-9f63-01efd03c0a22	7f1d35bf-6040-418b-8de5-fc5b885af86c	71d05faf-8913-4073-a401-7ee58d09559c
019b71c1-aeaa-4f90-9410-099f30352231	7f1d35bf-6040-418b-8de5-fc5b885af86c	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
2626af75-b18e-4990-88dd-edf431dbc484	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	1e361eae-eb51-4d32-ab0c-cd453bdd2734
b92ed75c-309d-4c84-b1df-b70083e32332	7f1d35bf-6040-418b-8de5-fc5b885af86c	556e545d-5b80-483d-9b7d-a822172e4a7b
43ae7661-7ea3-4f83-8b89-8a010ab804ee	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
1e76da63-7303-4375-93bc-09debf66dbc3	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
2e3465a0-34ea-4db1-8e88-0bfb68434b1d	561d834c-4bbb-4f6c-bd23-780cf6c1fe14	11063ddf-508e-4281-8dc5-ac4bd1563d0c
aed66974-2b69-498f-8841-e4c9c6b0e25a	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	8c96bcec-e94f-4470-9096-3b034db6ef57
bd9eead6-04d7-4bae-89fb-b66ad5613d0e	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
e7c277c0-5025-48b2-9c34-12278b07dc80	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	556e545d-5b80-483d-9b7d-a822172e4a7b
f9a34d04-bec5-49f1-93f3-a87254a2447b	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	282a9ee7-0259-4e07-b343-37c486d94416
f53d5f73-2bbd-4499-a2c9-515c5332964b	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	02df8cb1-f817-4182-a8da-24f24737babc
5b17bd4e-a043-4dc8-9227-0bf67406aa42	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	b1ae56e1-c683-49c2-95b2-b96f71fc435c
89727375-741e-4efd-9828-812ec39ea799	e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	34c2c6e6-a3d9-4d0f-97f9-954087748564
cd032bab-1cfb-4ba5-9af7-47753d96f087	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	ce0753c0-bd38-45f1-969f-1d8d3e035a69
23bea856-fcdc-4484-9b29-66acbb38ec02	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	0cba341f-4f70-4f9e-b03c-177862b22df3
a381e63b-36b5-4f8b-b64b-78c5236cb410	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	8c3a2086-969e-426d-91db-306fcfaec506
014eecf4-3c2a-4590-862f-21f311b2b336	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	cd28bafd-e93c-4ef2-b99d-85d18e269d5b
f2f399a6-8c16-47fb-966f-2362846c8b61	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	82c07f83-9ab1-4097-ad30-36e7d81d1340
09b9ec21-6176-408e-8103-0126d7ae255b	fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	d8be6eba-fd02-48ef-8424-cbb640b9bd27
e29c1008-93a0-450e-b769-979f8fcc19d4	249e3104-ae0b-48b1-9e82-3337f3734413	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
74e8d871-db29-4e82-8984-9d5e469ac6d1	249e3104-ae0b-48b1-9e82-3337f3734413	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
4c2810a6-ffcf-412b-a4ac-8c9e8c92f1ca	3bd66237-7519-4276-8223-ffcff705e372	ff0653fc-e130-4ea9-b889-96f4bea63b62
e4817f84-5e96-4c74-881a-b0ce4da09f35	3bd66237-7519-4276-8223-ffcff705e372	1e361eae-eb51-4d32-ab0c-cd453bdd2734
90ff77e8-a83a-4caa-81ac-331ab84062b8	3bd66237-7519-4276-8223-ffcff705e372	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
64cef9da-e9b6-423b-b1ae-62828799dba3	3bd66237-7519-4276-8223-ffcff705e372	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
381df8b1-6adf-4279-a114-4af6cc26bc37	3bd66237-7519-4276-8223-ffcff705e372	11063ddf-508e-4281-8dc5-ac4bd1563d0c
171969f2-8a45-49df-a8b6-20d3cb4f530c	249e3104-ae0b-48b1-9e82-3337f3734413	38670ebf-9e68-40d6-845a-3061a47cafe6
62a587d6-66f7-4a1f-9b98-2a25c23516ea	6df4440f-a538-40cc-a199-10f8f6757e4b	26982feb-eba9-4b04-89ea-98535fa61c3d
47f17c29-ba27-45ab-9d6e-b2097464cd07	6df4440f-a538-40cc-a199-10f8f6757e4b	ff0653fc-e130-4ea9-b889-96f4bea63b62
8c1c3239-ff82-41b7-abb9-c741b70ceda5	6df4440f-a538-40cc-a199-10f8f6757e4b	1e361eae-eb51-4d32-ab0c-cd453bdd2734
26466b21-3ffc-47c9-9d8d-3451a51dc7d5	6df4440f-a538-40cc-a199-10f8f6757e4b	4e947c6f-446e-4e8e-8cf8-083538146cfe
4ec4b400-98b9-4c90-aae0-1509484193b4	6df4440f-a538-40cc-a199-10f8f6757e4b	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
dc9bfb69-f34b-43c9-813a-1fe075c89ade	6df4440f-a538-40cc-a199-10f8f6757e4b	11063ddf-508e-4281-8dc5-ac4bd1563d0c
5d03a2f3-9ef1-4d08-87dd-ff7506b53e3c	249e3104-ae0b-48b1-9e82-3337f3734413	868435dd-ab2f-48d0-8fc8-97b29a652c0c
70af7163-1e3a-4801-852b-79656c099584	249e3104-ae0b-48b1-9e82-3337f3734413	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
7e541374-e29a-4fa4-bf15-1c7338531fc4	249e3104-ae0b-48b1-9e82-3337f3734413	20a9c879-f4a5-4486-9161-50701b056327
17ccf5f1-7035-42e3-a784-889b5abee7d8	249e3104-ae0b-48b1-9e82-3337f3734413	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
2f377c8c-bb9b-4ac3-adff-e580312f8384	768e25ef-d2dd-4359-9e77-ba152490de39	b911af8e-191c-476d-bbf6-6848e12ca6cb
c26e004f-034f-4249-86ab-f1e7822077c7	768e25ef-d2dd-4359-9e77-ba152490de39	bb69df93-68c5-4063-a5fd-74ab02d5ba84
13325767-1198-46d5-b843-811c99e26751	768e25ef-d2dd-4359-9e77-ba152490de39	0261cf0e-50e4-4252-a269-ab1d16187042
79c1205c-4da6-47fa-81f3-a2682ed6328c	768e25ef-d2dd-4359-9e77-ba152490de39	ab145af8-a7f3-460d-96c2-0955ad99420e
2a833658-1f32-4613-a2fe-6968c5896143	768e25ef-d2dd-4359-9e77-ba152490de39	cfdcca34-7fd5-4838-9370-21276899c178
668ff882-22b9-49b5-846c-65023807aba8	5d12cde5-07bf-4245-a807-5e64209cd3b8	33c555fb-64bd-440d-9362-d420ce224c1a
5ae30437-cb97-4fe8-b4b1-5990f4ccb67c	5d12cde5-07bf-4245-a807-5e64209cd3b8	00452b01-da8a-4380-8759-877c80f392dd
49cad4a8-cdfc-4479-a54d-a4563c5af869	5d12cde5-07bf-4245-a807-5e64209cd3b8	ff0653fc-e130-4ea9-b889-96f4bea63b62
6d1a3a3d-3bd2-4aa3-8fc5-c73384ece9b0	5d12cde5-07bf-4245-a807-5e64209cd3b8	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
16370bd4-bfbd-4fcb-be34-b4ae312a5106	5d12cde5-07bf-4245-a807-5e64209cd3b8	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
14f55a87-3524-4e29-8e83-527dcc239350	5d12cde5-07bf-4245-a807-5e64209cd3b8	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
bccdfebe-be9a-4399-a32d-3056a6dab289	5d12cde5-07bf-4245-a807-5e64209cd3b8	11063ddf-508e-4281-8dc5-ac4bd1563d0c
79e49993-fd6a-43fb-85af-62e4fc112477	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	c8fec09c-b992-463f-97fb-106c29d889bc
4002bb75-8a18-414c-a646-ed3bba1475eb	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	20a9c879-f4a5-4486-9161-50701b056327
0ee6c0b9-34ae-4b61-aedf-ced384866a82	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	133df2a4-0505-4aed-bdf5-b2dd5e21c7c9
fc415908-4933-4345-8fad-98624152cc8b	41b131f6-81f6-462f-9f82-7df42d7eac26	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
e96452e5-8e64-4fa1-98aa-cd277089373b	41b131f6-81f6-462f-9f82-7df42d7eac26	3635d565-2a74-447e-829b-b7e334ef194e
2bfb5d44-a296-44d5-a795-31a285d9f886	41b131f6-81f6-462f-9f82-7df42d7eac26	631d799c-e4cc-4f12-b74e-973dabb21075
569a5f80-d5c7-4489-973e-dc72fa3fef2a	41b131f6-81f6-462f-9f82-7df42d7eac26	282a9ee7-0259-4e07-b343-37c486d94416
2c7f66cd-3275-4eba-86c7-993107df88f9	41b131f6-81f6-462f-9f82-7df42d7eac26	688f2b9a-9285-46e9-9b78-d60977fd9360
81c98b39-2fde-4d50-ab5d-9047f7107818	41b131f6-81f6-462f-9f82-7df42d7eac26	71d05faf-8913-4073-a401-7ee58d09559c
c46d203e-25c5-44be-b90b-d2595cc0b7ad	41b131f6-81f6-462f-9f82-7df42d7eac26	34c2c6e6-a3d9-4d0f-97f9-954087748564
21e2c724-cf3b-42c1-8531-066759e8f591	071d9d1a-c27c-4f47-af10-4155847c7eff	68a35597-81f3-435d-935f-f89ecd6add03
fe000d41-a723-4539-ad74-1e0da3e9a9a9	071d9d1a-c27c-4f47-af10-4155847c7eff	decba44a-23dc-4d6b-b754-4799e45488d6
f3898589-ccb3-4653-a5ee-3180f409b508	071d9d1a-c27c-4f47-af10-4155847c7eff	7fee0783-f025-4da1-8cec-fbcd18b107b0
e9b41ac1-fc2d-4dc7-ae3b-1f3bb193efe4	071d9d1a-c27c-4f47-af10-4155847c7eff	63c26fae-f8d7-4507-8433-ffe1f59614e1
0a181a63-a561-44e4-836a-b8d66ededefa	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
ee8aabb0-b7f7-4ad9-9b7a-61f85ba39e8d	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	40c13606-829a-4d32-9a2f-634465feb1b3
4bb253ee-96b4-4acb-bf8d-8a09da81b615	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	c83b9a45-346e-41f7-ac61-39811253a2a4
b988c3bf-9c9a-4a47-83cd-4abef28ae5a5	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	6ee66dc9-a0db-4607-b2cf-edc741e28833
a47c51e6-430f-4eb2-819c-ceaa7e22a9de	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
989c1819-a564-49af-8e30-3f4296a422dd	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	298d4cb0-b557-4ec9-9a50-0a3415affaea
2d581537-8221-4792-8cf6-cc6112e75f67	f2412d01-ddc5-4be5-8d18-a8e96a1f7816	6f474582-2930-4901-9d09-efdf4679f879
0e644a8d-1578-4707-9187-0245388d70d3	6ed4d027-b7f6-4cac-b801-9567700a6aab	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
35da8f3d-f062-4063-a78a-e809fdb259ea	6ed4d027-b7f6-4cac-b801-9567700a6aab	6eb08218-0a94-451d-bf6d-b3e5c2967b09
9fdb6e9e-d9c9-4b47-ab18-60932b4ac18b	6ed4d027-b7f6-4cac-b801-9567700a6aab	f63199f1-343b-4127-a6ee-1eb0e65b5232
796e824f-16e5-416c-87a9-ebc82394ec15	6ed4d027-b7f6-4cac-b801-9567700a6aab	868435dd-ab2f-48d0-8fc8-97b29a652c0c
18accbcc-fb2f-4db2-af5e-c7e37270aacc	6ed4d027-b7f6-4cac-b801-9567700a6aab	ca965a27-d390-453b-a3cc-69e4ccc791e3
19e97d86-0ed8-4dee-badd-51613873f763	6ed4d027-b7f6-4cac-b801-9567700a6aab	e39910ae-2305-4c95-b7cf-a12676e2c464
4b72692e-51e0-42f6-9665-e5ec01c2bdb1	6ed4d027-b7f6-4cac-b801-9567700a6aab	6f474582-2930-4901-9d09-efdf4679f879
31d8fc2b-60bf-48b8-b10f-0af184495ea8	1524e46e-5520-470d-9b6e-a75037ef66ee	b911af8e-191c-476d-bbf6-6848e12ca6cb
5d8a5609-4838-4464-b4ca-1778cd84704f	1524e46e-5520-470d-9b6e-a75037ef66ee	1870d9f2-9162-4fbd-bf50-43698022b8da
287cbb36-ea10-4075-8187-3e761381a19a	1524e46e-5520-470d-9b6e-a75037ef66ee	0261cf0e-50e4-4252-a269-ab1d16187042
7b910bf4-b548-4f13-8ed3-e37c3d1c0f40	1524e46e-5520-470d-9b6e-a75037ef66ee	63c26fae-f8d7-4507-8433-ffe1f59614e1
177e1632-2ada-4850-9b1a-b5d8ea2e81f6	1524e46e-5520-470d-9b6e-a75037ef66ee	760e0210-eaf2-4bb5-af81-985e4d149200
dcb360d3-c446-4a61-991c-3ff1806779c1	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9
a2ff1408-fee3-4b4a-8bdf-f94f7792f02f	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	79325b26-f52e-48bf-9185-b30de43d64d3
953ba594-fa0e-4bf0-adf8-854025977c5c	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	bd7c933d-b38a-4acf-8053-496d42630b61
406ec68e-ea1b-44d3-aa2d-f05f2145aed7	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
b50dca26-dc40-4683-990e-b1475abe28da	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
effbd803-5c14-407e-b7b6-b89db9a3d715	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	46d123ae-7693-47a9-9d39-d1316173a1e9
c2a95f1b-49cb-4824-a123-a6227be2f938	ccb1113a-ca31-4ba7-a80f-3fd0aac77860	00cdb44d-3200-46f0-8757-42e78e569a42
ff596446-69e6-4bf5-a3e6-438808c0d792	a6597e1a-5220-442d-b65a-3560de514b8b	5b7f965f-4d06-47aa-bf3d-0e66b47709af
26a94a06-bcd3-462c-bdf2-94e1aae239a5	a6597e1a-5220-442d-b65a-3560de514b8b	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
addb9b8f-ca5c-4d01-826f-e4c90972ebef	a6597e1a-5220-442d-b65a-3560de514b8b	ddfa5493-8205-46d9-a29c-4934739cb1b4
b4bf704f-9852-4675-b907-66b554cad377	a6597e1a-5220-442d-b65a-3560de514b8b	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
efbd70c3-3909-4215-a673-843799938032	a6597e1a-5220-442d-b65a-3560de514b8b	04131970-6b8c-41fa-a21b-57f1b1bbef21
1c37b720-884d-4ec2-a448-0672c98b9cbb	a6597e1a-5220-442d-b65a-3560de514b8b	b1ae56e1-c683-49c2-95b2-b96f71fc435c
fb8a3377-b07e-4ca1-8662-38036002db70	a6597e1a-5220-442d-b65a-3560de514b8b	b8590cf6-ac78-40f7-b434-dacc456bdd2f
8aed6282-c500-4a4d-a50d-b805dc447a47	d0976528-cb10-4fe9-874e-837482d34a27	33c555fb-64bd-440d-9362-d420ce224c1a
bee9bf85-a619-467a-9a09-62ad5dceaf1e	d0976528-cb10-4fe9-874e-837482d34a27	26982feb-eba9-4b04-89ea-98535fa61c3d
ab9b6e85-ec41-4679-b9d4-7e46397338c6	d0976528-cb10-4fe9-874e-837482d34a27	ff0653fc-e130-4ea9-b889-96f4bea63b62
4f6a19da-85d2-49db-8a70-a55bbdde40ae	d0976528-cb10-4fe9-874e-837482d34a27	1e361eae-eb51-4d32-ab0c-cd453bdd2734
5f8bdbba-25e4-4b96-a234-34d2533f9dc4	d0976528-cb10-4fe9-874e-837482d34a27	4e947c6f-446e-4e8e-8cf8-083538146cfe
6468bde8-54bc-410f-b9f6-53f00db1de5c	d0976528-cb10-4fe9-874e-837482d34a27	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
8cf17b89-c59d-4358-bcca-ae8860a1122b	d0976528-cb10-4fe9-874e-837482d34a27	11063ddf-508e-4281-8dc5-ac4bd1563d0c
2fc26659-f30b-4eaa-ae8a-72bee2a8a8cb	387fb046-8e8a-48a9-90b6-0c25f9873f5b	d65c7d3f-40de-42d6-ac23-bf434daaad00
61c3adb7-1f5d-4301-93b5-a8603eea59f6	9c796649-76ac-4991-9791-ce310cb528f9	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
fc3538ce-70e4-4eef-838a-d708e3004fce	387fb046-8e8a-48a9-90b6-0c25f9873f5b	84370b0b-27aa-42df-b7d4-5ae28d9acb98
4a4047fe-dfb8-41db-ad18-6b900bc7de6a	9c796649-76ac-4991-9791-ce310cb528f9	40c13606-829a-4d32-9a2f-634465feb1b3
6aeee833-898b-4178-8dd3-9390fd6a8a2a	387fb046-8e8a-48a9-90b6-0c25f9873f5b	3c0e478d-ec46-4585-a584-08b67e891b47
5f7a1056-3f27-488e-b9e2-f24134a1a746	9c796649-76ac-4991-9791-ce310cb528f9	c965fa2d-0ebd-440c-86ce-bab64e06553a
b44f9075-ff6e-42f8-98ff-5ceeddac9d55	387fb046-8e8a-48a9-90b6-0c25f9873f5b	3dfad056-e365-45cd-8c74-59b49985eca2
fd52dd10-33a2-42f0-afc2-39ceaa37feb8	9c796649-76ac-4991-9791-ce310cb528f9	868435dd-ab2f-48d0-8fc8-97b29a652c0c
0df06595-1063-40f5-9e04-f4d5e6266530	387fb046-8e8a-48a9-90b6-0c25f9873f5b	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
5a443787-45b5-4881-ac3b-64d76051a9c5	9c796649-76ac-4991-9791-ce310cb528f9	ca965a27-d390-453b-a3cc-69e4ccc791e3
e625cc05-61d0-4d76-a66e-842e35b74774	387fb046-8e8a-48a9-90b6-0c25f9873f5b	966a3bcc-d18c-484e-b60e-37cdd682cb84
8509a13e-92b2-4f11-9d69-7f12440e0738	9c796649-76ac-4991-9791-ce310cb528f9	e39910ae-2305-4c95-b7cf-a12676e2c464
dc633b46-a467-45e7-a653-20beb974dae6	96af165a-58d0-4853-a43f-8a9862660262	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
a33d1494-59bb-4fe7-b382-c6ea6161c564	9c796649-76ac-4991-9791-ce310cb528f9	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
c6cd4e6a-8589-4f38-846c-714841d7bafa	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	b52ffb50-0d1e-4da5-8bf8-2ce37912d821
d4239e0c-91c5-47f2-8379-c444eb83585a	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	3635d565-2a74-447e-829b-b7e334ef194e
bbf80283-e940-406f-8db4-65f279d7b301	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	c7603d88-fad0-487b-9eb7-c3c31a5ca59d
ba1aa45c-32b8-4841-921a-8125937870c1	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	cdce8b68-4fc8-4d39-b39c-3485307475cb
3dc2c348-03af-406e-a41d-7fd5261abb91	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
a1d661f8-f7ec-4888-9b97-9f77bfcbd424	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	71d05faf-8913-4073-a401-7ee58d09559c
c52a0753-d0f4-4c4f-b6a2-155ee10ea87c	87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	6e8aa530-4d74-4e8c-babd-274b66ba6b69
1249ad91-afaa-4c8e-8b05-ca5545de0a9c	4542865a-e066-4fd2-a431-08a58b6cdda0	ced2e89a-0e7a-4427-8c85-b0d557baac68
de86dbd8-2450-4d89-aa50-771f8945e153	4542865a-e066-4fd2-a431-08a58b6cdda0	decba44a-23dc-4d6b-b754-4799e45488d6
1506ffe1-f43c-4b8f-9c76-4398c31118c9	4542865a-e066-4fd2-a431-08a58b6cdda0	e9be5267-6bc7-4816-92b9-0823824a3f91
60a6f7fa-ea52-44d9-a8ef-114eccb77449	4542865a-e066-4fd2-a431-08a58b6cdda0	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
a791338e-c0ad-408c-bb02-c596c392897d	4542865a-e066-4fd2-a431-08a58b6cdda0	64c02f11-0204-4a11-be07-68ef5b0f36f1
0aecc89f-e5f8-4161-9d62-d6e09afb9b1f	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	ce0753c0-bd38-45f1-969f-1d8d3e035a69
9ed9f651-7ad5-4ee8-8f83-f2c5ab3d5f1d	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	e34c8419-09e5-4302-a5b4-60b8830419f2
3843e2bc-141c-40f2-8e60-33130814343b	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	5cada605-9735-4e39-9f67-e3915eb9ecfb
ea449ebe-89e4-4b33-8d59-74e22af7855c	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	3dfad056-e365-45cd-8c74-59b49985eca2
16cac24e-86d7-465c-969b-a15557444837	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
8a7109dc-bfa2-4a44-a299-a31087349a90	c3b8e252-de8a-4ab2-9bbd-25a78e454d51	966a3bcc-d18c-484e-b60e-37cdd682cb84
2d746886-3e5e-430d-932c-d1a966a25694	96af165a-58d0-4853-a43f-8a9862660262	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
532e4d5d-318d-49d2-96ad-7565cb7194d0	96af165a-58d0-4853-a43f-8a9862660262	38670ebf-9e68-40d6-845a-3061a47cafe6
40104c5d-4eee-4431-9df7-2c8234ddab64	96af165a-58d0-4853-a43f-8a9862660262	8e5aedfc-077e-4c70-847c-d06a94840fa4
e6e567a7-28f3-4271-b003-7bb985e11ae8	96af165a-58d0-4853-a43f-8a9862660262	c8fec09c-b992-463f-97fb-106c29d889bc
56143e5d-9138-4d76-a66c-4aee33b71223	96af165a-58d0-4853-a43f-8a9862660262	298d4cb0-b557-4ec9-9a50-0a3415affaea
5564688c-8719-4745-a2cc-0517c0378ed4	96af165a-58d0-4853-a43f-8a9862660262	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
67d02387-2ca4-40ba-ac19-e548ecec5e78	adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	a2d3ea49-f184-41f2-a6b3-26b2fea2338a
96361956-4aff-4796-aa8f-42413c4aaa40	adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	decba44a-23dc-4d6b-b754-4799e45488d6
e22669b7-83d1-4bb0-99a0-d9ee644c9fb3	adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	ae3b7895-feda-406e-a6b8-61a8a20dcd3a
97c52e43-c288-46bd-8987-198ecdfe59f8	adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	ab145af8-a7f3-460d-96c2-0955ad99420e
96cb8705-4301-4968-97cd-74e9057bb335	adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	760e0210-eaf2-4bb5-af81-985e4d149200
093f6f7a-6dfa-46d8-99a2-51bd76cb4c2b	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	03999e08-b875-4f63-bf97-c220705ba672
2edeb6fe-828c-4de5-b74c-56bb1f2b2943	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	00452b01-da8a-4380-8759-877c80f392dd
6366bbd4-a207-4f7d-9727-d404bccbb7ee	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	ff0653fc-e130-4ea9-b889-96f4bea63b62
f50c4b3b-66cc-4bb2-aa82-c1597e8f4760	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	28eac750-7a50-439f-bf5d-e07bbb4f496a
8400d43e-4e49-4089-bdd5-afbc7e9e3d62	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
dc12caf8-be21-41d5-b186-8a1ad78a7c3b	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
642db53f-9dda-4243-88ec-c9293d1fbf85	4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	951adef9-ef3b-4d3d-880d-a9788b4cbae6
1dbc8e8f-ffb0-4313-bc63-000dc3065261	e2f92da8-3651-440e-b192-8df6fe8d7141	8c96bcec-e94f-4470-9096-3b034db6ef57
09a34ae7-28a5-4b04-b693-2fc2e98cbda7	e2f92da8-3651-440e-b192-8df6fe8d7141	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
2f346384-71c8-468f-ad4b-505e9321c545	e2f92da8-3651-440e-b192-8df6fe8d7141	ddfa5493-8205-46d9-a29c-4934739cb1b4
ea5cbc26-ff97-4f6d-a4c9-d1a11198a1fb	e2f92da8-3651-440e-b192-8df6fe8d7141	cdce8b68-4fc8-4d39-b39c-3485307475cb
96d60b8d-89ea-41f2-8859-c5277e6ee3a6	e2f92da8-3651-440e-b192-8df6fe8d7141	02df8cb1-f817-4182-a8da-24f24737babc
77447cc6-56f2-4c94-86f8-7fb1f5622b69	e2f92da8-3651-440e-b192-8df6fe8d7141	71d05faf-8913-4073-a401-7ee58d09559c
54963630-389c-4834-b989-34fdc028df60	e2f92da8-3651-440e-b192-8df6fe8d7141	34c2c6e6-a3d9-4d0f-97f9-954087748564
a633cdd0-602f-4c88-9972-d328bf3ca588	b935041c-3478-4012-9441-0ce8edf4c322	eb5ae92f-804a-4e32-991d-5fc2cedc10ad
97d3cafa-713d-4f5a-a703-55ae00a1c482	b935041c-3478-4012-9441-0ce8edf4c322	0cba341f-4f70-4f9e-b03c-177862b22df3
cc44c8f1-a776-42d3-bac9-5bf61d8dcd46	b935041c-3478-4012-9441-0ce8edf4c322	3c0e478d-ec46-4585-a584-08b67e891b47
24dce144-862d-41ae-9d37-5baf7ed6bbeb	b935041c-3478-4012-9441-0ce8edf4c322	443894b2-d27a-481b-b1db-dd991498fc5e
03f6d495-e7d1-49d5-9c7d-c82591eb6b12	b935041c-3478-4012-9441-0ce8edf4c322	2894cadd-aa58-44ef-a09a-f865f2937bf3
9a40023d-cbb8-4962-892b-fee6a225d9e9	b935041c-3478-4012-9441-0ce8edf4c322	d8be6eba-fd02-48ef-8424-cbb640b9bd27
34caf23f-6c3d-42d8-9e6b-46f1c2097cdb	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
63395748-35ae-46da-9372-2df2f8973959	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	40c13606-829a-4d32-9a2f-634465feb1b3
9d009ef1-73c7-4372-984a-e50ede1e2621	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	38670ebf-9e68-40d6-845a-3061a47cafe6
a6b6149e-f82b-4cb9-9f2f-b21a99fa6490	3f5060d6-a874-48e0-bbc3-7e2d5f86531f	8e5aedfc-077e-4c70-847c-d06a94840fa4
2712d647-2091-47a5-a589-719ecde5cfc2	071d9d1a-c27c-4f47-af10-4155847c7eff	5058bf81-4cd1-4f3f-990f-5767beab04c8
b0274da0-075a-460a-917c-dcaf9e0df455	859f8423-cf26-444e-9324-d73a4e22cb73	eb5ae92f-804a-4e32-991d-5fc2cedc10ad
992d7340-7240-442c-9de7-d8cd3273d803	859f8423-cf26-444e-9324-d73a4e22cb73	0cba341f-4f70-4f9e-b03c-177862b22df3
ecf28ab0-1631-409e-82c2-55eb3d80f688	859f8423-cf26-444e-9324-d73a4e22cb73	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
a28ebaa6-7786-4a48-b1f7-6135f2f33370	859f8423-cf26-444e-9324-d73a4e22cb73	cd28bafd-e93c-4ef2-b99d-85d18e269d5b
cb7cf0f5-9453-4ce7-8831-707c15ddd4c6	859f8423-cf26-444e-9324-d73a4e22cb73	82c07f83-9ab1-4097-ad30-36e7d81d1340
b0779bb2-ca99-4057-b557-649726eb4cf0	859f8423-cf26-444e-9324-d73a4e22cb73	966a3bcc-d18c-484e-b60e-37cdd682cb84
9ea226cc-8646-4b29-b9f1-3f945d62b00c	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9
5cb7d9f0-0b60-4be2-9d7e-a3f9e6c09162	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	00452b01-da8a-4380-8759-877c80f392dd
8619c6e4-9df4-455e-87df-b1f1b14c6368	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	f4433601-a483-44d6-8c98-898ff69193d1
2c8f98f3-e009-4151-89ca-f5dfc9c1621d	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	28eac750-7a50-439f-bf5d-e07bbb4f496a
78c04836-01ea-42f6-a564-ef647cad08f9	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
0997b592-b941-44fe-a85d-111f5d66b83a	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
e79699b5-d6a2-4982-b9ca-6c7949d15a7d	fc8ca3e9-684f-41f8-9d52-c447cb1ad118	951adef9-ef3b-4d3d-880d-a9788b4cbae6
380d7dbe-9c03-40e7-805e-fa378e3c8e96	d5b30136-c11b-4787-8fe4-ed13002adf7c	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
8d3f0ca8-853e-4e62-ba49-5604968fe4b2	d5b30136-c11b-4787-8fe4-ed13002adf7c	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
25a8069c-a8ef-4ddf-ae93-a563267ba29b	d5b30136-c11b-4787-8fe4-ed13002adf7c	38670ebf-9e68-40d6-845a-3061a47cafe6
2c30051b-0f7b-4f7e-8f57-3e9329b5df58	d5b30136-c11b-4787-8fe4-ed13002adf7c	868435dd-ab2f-48d0-8fc8-97b29a652c0c
eb1ff85e-4f92-42cc-a189-201e0e99e228	d5b30136-c11b-4787-8fe4-ed13002adf7c	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
fe5ba4f5-0724-4171-951f-8b5013ffda09	d5b30136-c11b-4787-8fe4-ed13002adf7c	20a9c879-f4a5-4486-9161-50701b056327
330a6058-ff16-459b-8441-1c5050f61cf0	d5b30136-c11b-4787-8fe4-ed13002adf7c	133df2a4-0505-4aed-bdf5-b2dd5e21c7c9
ef02e0d5-204f-4473-b1ea-5c0716a54c38	c21e286f-dc01-4730-9ecc-38fe39d94892	5b7f965f-4d06-47aa-bf3d-0e66b47709af
14f33288-1c96-4e01-85ca-35246baf1982	c21e286f-dc01-4730-9ecc-38fe39d94892	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
fbf71221-b5ba-42b4-b73f-8fa760219d3a	c21e286f-dc01-4730-9ecc-38fe39d94892	ddfa5493-8205-46d9-a29c-4934739cb1b4
b9de1265-3ecf-4c24-a2f3-5d0380dd3ec7	c21e286f-dc01-4730-9ecc-38fe39d94892	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
b88b93f9-d3ac-406a-a382-426fe69c933e	c21e286f-dc01-4730-9ecc-38fe39d94892	04131970-6b8c-41fa-a21b-57f1b1bbef21
f65f90d1-b65c-4368-8da8-e8bb3586a5f0	c21e286f-dc01-4730-9ecc-38fe39d94892	b1ae56e1-c683-49c2-95b2-b96f71fc435c
c8cdc1c4-8488-4fb2-87d5-b7eb2adfb48a	c21e286f-dc01-4730-9ecc-38fe39d94892	6e8aa530-4d74-4e8c-babd-274b66ba6b69
0dcc5bc7-9b3e-4dec-b2db-389afd3face0	32ef59b3-781f-4608-a9fb-586d9054f4f1	a2d3ea49-f184-41f2-a6b3-26b2fea2338a
99af6b60-fcd0-4b4c-9403-0c76e6286e5d	32ef59b3-781f-4608-a9fb-586d9054f4f1	da95f662-6808-4bb7-a04a-f7a5468cd6bb
d858b45f-7041-4865-a196-0e6cbccca2c0	32ef59b3-781f-4608-a9fb-586d9054f4f1	7fee0783-f025-4da1-8cec-fbcd18b107b0
e97cbc2b-bfbd-453a-89f6-3d9f88c19cd5	32ef59b3-781f-4608-a9fb-586d9054f4f1	ab145af8-a7f3-460d-96c2-0955ad99420e
c6834ff0-e38f-4e1b-9c7a-56165aa4ba30	32ef59b3-781f-4608-a9fb-586d9054f4f1	760e0210-eaf2-4bb5-af81-985e4d149200
970563e0-345a-4c01-8c14-f85ca5f8b573	96667533-3892-4ad6-b13b-f2550df3905d	d65c7d3f-40de-42d6-ac23-bf434daaad00
7fb249f1-a445-40d2-bd5e-8ef82c262feb	96667533-3892-4ad6-b13b-f2550df3905d	e34c8419-09e5-4302-a5b4-60b8830419f2
7df1b80d-3817-40c7-b1c8-596764d0eb81	96667533-3892-4ad6-b13b-f2550df3905d	5cada605-9735-4e39-9f67-e3915eb9ecfb
0ec38b6c-4b21-4503-85b4-9072dcb6e4ea	96667533-3892-4ad6-b13b-f2550df3905d	16afbb62-78c6-46b9-9ab7-8ebb322cb626
9a44325d-8e52-496a-8597-445c05ac437d	96667533-3892-4ad6-b13b-f2550df3905d	4a2063fe-517e-4e6d-b888-337a6a0faf48
200659c4-becd-41c4-8c9c-966cafcd11a2	96667533-3892-4ad6-b13b-f2550df3905d	9a6c3789-1e92-4775-ab6b-055bf8165c5d
d03dfff3-d044-447f-aaa9-b35730b4b225	bd1e5259-8604-4ed5-aa33-216de4fec553	d85ccb92-9175-4029-827c-2ccade6984e3
8edd5e3d-2302-4fa7-9d2f-3ab34e3e71b6	bd1e5259-8604-4ed5-aa33-216de4fec553	1dbbe31c-27f2-47c4-a200-2346d84314b7
51a2289c-5a52-4944-acec-c81808675466	bd1e5259-8604-4ed5-aa33-216de4fec553	f4433601-a483-44d6-8c98-898ff69193d1
03d83ca3-2f98-415e-88fb-76ff7e0b1fa6	bd1e5259-8604-4ed5-aa33-216de4fec553	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
dc935756-224b-42d9-a53b-ff936e028389	bd1e5259-8604-4ed5-aa33-216de4fec553	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
b1ce0cb9-5377-41c1-aab4-ca333e27703e	bd1e5259-8604-4ed5-aa33-216de4fec553	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
dd22cf1f-4355-4898-87d3-e82016c1051c	bd1e5259-8604-4ed5-aa33-216de4fec553	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
38b62a5f-3f31-46b1-85e1-7b3c15f3e713	1eea8a1c-47da-4533-b803-8c61608bbe26	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
f0ef2da7-f01e-41d9-9bc9-9804c114fa10	1eea8a1c-47da-4533-b803-8c61608bbe26	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
bcf509e8-3655-4ca5-8ac5-e0fdaf45df86	1eea8a1c-47da-4533-b803-8c61608bbe26	c83b9a45-346e-41f7-ac61-39811253a2a4
0d054600-49a8-4425-8a9e-0e3118455faa	1eea8a1c-47da-4533-b803-8c61608bbe26	6ee66dc9-a0db-4607-b2cf-edc741e28833
4af0b567-ca6b-4e3c-b85b-fdd1b07d95e2	1eea8a1c-47da-4533-b803-8c61608bbe26	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
d01bc7ef-5f6e-44a5-8fe0-cee4947c1768	1eea8a1c-47da-4533-b803-8c61608bbe26	298d4cb0-b557-4ec9-9a50-0a3415affaea
8befcf03-1e27-4a81-a0ef-9285ff93184d	1eea8a1c-47da-4533-b803-8c61608bbe26	133df2a4-0505-4aed-bdf5-b2dd5e21c7c9
155cbb77-78d7-42a3-957e-f2f850dcc7cc	7741b25b-95e8-486c-865c-6dcf05333eac	5b7f965f-4d06-47aa-bf3d-0e66b47709af
945f08d4-72ed-4622-abd2-242df4e4b9c3	7741b25b-95e8-486c-865c-6dcf05333eac	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
900c9190-da10-417d-a31e-2318f806958c	7741b25b-95e8-486c-865c-6dcf05333eac	556e545d-5b80-483d-9b7d-a822172e4a7b
6442b5bd-3118-4187-8f71-6abfcefbdf77	7741b25b-95e8-486c-865c-6dcf05333eac	cdce8b68-4fc8-4d39-b39c-3485307475cb
d8835bc0-17ee-4cad-9ea7-8901b32fb543	7741b25b-95e8-486c-865c-6dcf05333eac	02df8cb1-f817-4182-a8da-24f24737babc
17f20a13-1a71-4aca-aa27-d09fb02ab659	7741b25b-95e8-486c-865c-6dcf05333eac	71d05faf-8913-4073-a401-7ee58d09559c
1a075abd-ff0b-443c-ab9f-f5c2ab90baaf	7741b25b-95e8-486c-865c-6dcf05333eac	8a245a89-7254-42d9-b8fd-2eac410a5585
902b59ab-bb86-4b5c-9d0f-ff912fdf1e79	182ed03d-6f09-476b-940d-cf251ea869a2	68a35597-81f3-435d-935f-f89ecd6add03
7ab220d0-15cc-4d23-8372-0bb288e59fbc	182ed03d-6f09-476b-940d-cf251ea869a2	bb69df93-68c5-4063-a5fd-74ab02d5ba84
1511e55c-b1b3-4033-b7e3-7499775e7199	182ed03d-6f09-476b-940d-cf251ea869a2	b0b9724c-158c-4487-b15c-cc77674bde0a
4bce45b5-28e1-4ac6-a346-a56c7909fe5f	182ed03d-6f09-476b-940d-cf251ea869a2	63c26fae-f8d7-4507-8433-ffe1f59614e1
c0a47462-d069-4c70-893d-fb4762f1da73	182ed03d-6f09-476b-940d-cf251ea869a2	760e0210-eaf2-4bb5-af81-985e4d149200
06b2f549-825b-4c9f-be19-4229cdc916ee	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	70cf216b-709d-45fd-8486-b10b3e5223d9
e6aa031a-aae6-4f83-91fb-ec68d02ae835	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	e34c8419-09e5-4302-a5b4-60b8830419f2
888a3bc1-ab8f-4f80-8c64-6d06756559b5	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	5cada605-9735-4e39-9f67-e3915eb9ecfb
40d3cccd-e062-4aeb-840f-58f63ef23a02	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	3dfad056-e365-45cd-8c74-59b49985eca2
ee46d89e-7f3c-4f88-a87d-6a6fd20b642c	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	82c07f83-9ab1-4097-ad30-36e7d81d1340
ccc7f02a-3897-4424-bdf3-698b5d07ffe3	aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	5bd7f24d-e0d3-447e-9942-58a64046ac83
5c20d1b5-94db-4fdd-a1b0-dee7621c6b2a	4d22cc5b-0094-455f-9f4b-7905d2980884	d85ccb92-9175-4029-827c-2ccade6984e3
be2a1b4f-21ba-4e1a-b2ce-af8ef8d01555	4d22cc5b-0094-455f-9f4b-7905d2980884	00452b01-da8a-4380-8759-877c80f392dd
5593ee34-69f7-4037-be0c-d4f09de3a358	4d22cc5b-0094-455f-9f4b-7905d2980884	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
66be144c-75e3-4dfa-b631-abbd3a14d93b	4d22cc5b-0094-455f-9f4b-7905d2980884	28eac750-7a50-439f-bf5d-e07bbb4f496a
6b8f8d51-165b-4fb5-a883-fb8028591602	4d22cc5b-0094-455f-9f4b-7905d2980884	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
d070e070-7712-4bcf-824e-343a40dd030a	4d22cc5b-0094-455f-9f4b-7905d2980884	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
e98142f7-52b2-48ff-b290-533cfcbd0366	4d22cc5b-0094-455f-9f4b-7905d2980884	951adef9-ef3b-4d3d-880d-a9788b4cbae6
89bb5665-7a55-4888-963a-da5822f86e3b	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
60cef602-aa50-4e65-bbd2-8a771d4bfef4	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	6eb08218-0a94-451d-bf6d-b3e5c2967b09
c539ed20-6d35-46d6-8ead-b3a7dbc19b2b	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	c83b9a45-346e-41f7-ac61-39811253a2a4
ee3e5aeb-def0-41ba-b5a8-1b6f7dbd485a	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	6b428caa-622b-47c3-824b-3c755683a21c
691ec755-cf5b-4055-9c83-f4558c359596	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	011875b1-f030-4ee5-a103-7a5900a6b8b6
8948a5a3-c7fe-4eda-98c7-8932e492dc52	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
6c2b5824-e88c-4bc3-87ce-0a5ee20bb48e	b03d2be9-5f64-4035-ad28-28f95ffa4e0a	4974c20a-94d5-4a52-983f-4abba57a225b
243f7a7f-7e39-4f3f-a6b0-61655925cb0a	b8aa9425-0877-4f82-b0d8-80b88cf842b7	5b7f965f-4d06-47aa-bf3d-0e66b47709af
dd5a7ef7-728d-4b53-ae87-1a6af91afedd	b8aa9425-0877-4f82-b0d8-80b88cf842b7	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
de23d038-9619-42c2-846c-17cb42118c7b	b8aa9425-0877-4f82-b0d8-80b88cf842b7	ddfa5493-8205-46d9-a29c-4934739cb1b4
799679e6-25e1-4e12-87e4-e81ebcb0a7ba	b8aa9425-0877-4f82-b0d8-80b88cf842b7	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
86fea5cd-b872-4c43-b076-04d263da2014	b8aa9425-0877-4f82-b0d8-80b88cf842b7	04131970-6b8c-41fa-a21b-57f1b1bbef21
044c85d7-efd1-4c32-bf72-0480e8630a87	b8aa9425-0877-4f82-b0d8-80b88cf842b7	b1ae56e1-c683-49c2-95b2-b96f71fc435c
9772809e-3f3c-4b46-ba3e-23d65afa3b39	b8aa9425-0877-4f82-b0d8-80b88cf842b7	6e8aa530-4d74-4e8c-babd-274b66ba6b69
c119821e-a5fc-4b8a-a082-8b2373eb439a	28fdebda-a485-4e4e-810d-81e0271074f7	67ae3aea-4ab7-402b-9c64-9772d924bf69
fd201925-fd01-4da2-8701-79a9d6904d6b	28fdebda-a485-4e4e-810d-81e0271074f7	decba44a-23dc-4d6b-b754-4799e45488d6
ad67e654-a57c-43b1-b1d6-6cd6eac186c1	28fdebda-a485-4e4e-810d-81e0271074f7	e9be5267-6bc7-4816-92b9-0823824a3f91
08d8dea0-aa44-4c0e-a64e-26ff44491eef	28fdebda-a485-4e4e-810d-81e0271074f7	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
d21318f5-9f33-4785-981e-61a168d2031b	28fdebda-a485-4e4e-810d-81e0271074f7	64c02f11-0204-4a11-be07-68ef5b0f36f1
250e7f31-4880-4ce0-9088-36f3ead01b38	358642cb-fa50-4cc7-bc2c-8cd2d060a856	d65c7d3f-40de-42d6-ac23-bf434daaad00
6e8c1b3a-e578-4e69-af01-cd29ea9f5cac	358642cb-fa50-4cc7-bc2c-8cd2d060a856	e34c8419-09e5-4302-a5b4-60b8830419f2
a14dcc89-b3b6-4871-b20f-9bbcda34321d	358642cb-fa50-4cc7-bc2c-8cd2d060a856	5cada605-9735-4e39-9f67-e3915eb9ecfb
83d00b6f-2337-438c-b7a1-585e679aa148	358642cb-fa50-4cc7-bc2c-8cd2d060a856	3dfad056-e365-45cd-8c74-59b49985eca2
3c049b66-c35b-46b6-84e4-7ef6cad5d053	358642cb-fa50-4cc7-bc2c-8cd2d060a856	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
63165c64-99f2-454b-babd-1c361557b79f	358642cb-fa50-4cc7-bc2c-8cd2d060a856	966a3bcc-d18c-484e-b60e-37cdd682cb84
8dd417cc-7a8f-45b1-9b6d-0df6b6a20f9f	43f93762-3ce9-4f32-a91b-4328cdd14506	1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9
2c9cf7aa-1001-4f43-91f5-3f73c404396f	43f93762-3ce9-4f32-a91b-4328cdd14506	79325b26-f52e-48bf-9185-b30de43d64d3
564c99ba-0705-4bc8-b380-1ecb5a851611	43f93762-3ce9-4f32-a91b-4328cdd14506	bd7c933d-b38a-4acf-8053-496d42630b61
e940decc-b8cb-451d-8e3d-e97d65a3ec12	43f93762-3ce9-4f32-a91b-4328cdd14506	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
03016155-2f04-4912-8477-2bb0ff303aaa	43f93762-3ce9-4f32-a91b-4328cdd14506	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
85f534e2-229c-42ee-ad49-3f6918ec1539	43f93762-3ce9-4f32-a91b-4328cdd14506	46d123ae-7693-47a9-9d39-d1316173a1e9
1294a923-6eed-41c7-a43c-04e18973209e	43f93762-3ce9-4f32-a91b-4328cdd14506	00cdb44d-3200-46f0-8757-42e78e569a42
c732dc2a-e81d-4d74-a04e-446ebb00b362	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	553157a9-f226-49fa-af48-e508f1395f83
b8cde5ad-471e-490d-8208-81d8dde33a2e	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	be3bbe21-0a5a-4fef-aff3-0e3d5426f984
5127c05b-4338-42ac-a83a-9333e00cd39b	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	c83b9a45-346e-41f7-ac61-39811253a2a4
c87878e4-8a9a-42c8-8138-2f56192f7aa7	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	8e5aedfc-077e-4c70-847c-d06a94840fa4
be552f73-4f50-4c81-bbf9-4157b4d564e4	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	011875b1-f030-4ee5-a103-7a5900a6b8b6
a06ff5bf-46f7-45f4-8036-e93c1422aee4	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
96949bc5-8291-4167-bf47-bd1ed40a3e63	255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	4974c20a-94d5-4a52-983f-4abba57a225b
a43b3e36-e475-4f58-8e80-5fba44798d28	6f26415f-e609-4a90-9a9b-1e4f341c3b26	5b7f965f-4d06-47aa-bf3d-0e66b47709af
ebae50c7-ba46-4f5a-beb9-a6863e6b232b	6f26415f-e609-4a90-9a9b-1e4f341c3b26	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
aa4905b3-3ffc-49a9-849c-da6573b95d71	6f26415f-e609-4a90-9a9b-1e4f341c3b26	ddfa5493-8205-46d9-a29c-4934739cb1b4
82ceed35-dc44-42d6-83cb-f980a9bc10a7	6f26415f-e609-4a90-9a9b-1e4f341c3b26	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
59f544c3-f589-4664-a139-6f81122ee9ef	6f26415f-e609-4a90-9a9b-1e4f341c3b26	04131970-6b8c-41fa-a21b-57f1b1bbef21
a4d9bc81-8a11-4d28-98eb-eb4cdd66cc12	6f26415f-e609-4a90-9a9b-1e4f341c3b26	b1ae56e1-c683-49c2-95b2-b96f71fc435c
c0f91fa0-eed8-426d-af45-93aca980065f	6f26415f-e609-4a90-9a9b-1e4f341c3b26	b8590cf6-ac78-40f7-b434-dacc456bdd2f
a02cea4a-0039-470e-a792-fcc661b44188	bf789c04-ab45-410b-b2e1-3c5418f6d52d	67ae3aea-4ab7-402b-9c64-9772d924bf69
ba37210e-9b27-49a4-ade1-67b10e9804b0	bf789c04-ab45-410b-b2e1-3c5418f6d52d	decba44a-23dc-4d6b-b754-4799e45488d6
328c5f69-9aca-4283-99b0-d9e13d787b1a	bf789c04-ab45-410b-b2e1-3c5418f6d52d	e9be5267-6bc7-4816-92b9-0823824a3f91
f65419cf-3906-4a8d-a8a9-00012395a0a2	bf789c04-ab45-410b-b2e1-3c5418f6d52d	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
853d22e2-cbf3-4043-8c48-a07e6b8c17eb	bf789c04-ab45-410b-b2e1-3c5418f6d52d	64c02f11-0204-4a11-be07-68ef5b0f36f1
95af82cf-11aa-4a72-b55a-87d7578982b3	14a5204f-dc94-46a5-9436-2c84a8ecebe4	70cf216b-709d-45fd-8486-b10b3e5223d9
e84b4cfa-66c4-4a1f-adee-e290507ee308	14a5204f-dc94-46a5-9436-2c84a8ecebe4	e34c8419-09e5-4302-a5b4-60b8830419f2
a2b7b50a-dd51-4b15-9662-f875e472a7d3	14a5204f-dc94-46a5-9436-2c84a8ecebe4	5cada605-9735-4e39-9f67-e3915eb9ecfb
14a5d91b-e881-4ad8-b9bb-212a37053e88	14a5204f-dc94-46a5-9436-2c84a8ecebe4	3dfad056-e365-45cd-8c74-59b49985eca2
73881de6-56bb-4cfd-af0d-be9d062a613b	14a5204f-dc94-46a5-9436-2c84a8ecebe4	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
2dedfcb7-52ac-4b92-8adc-0d5e445c68e2	14a5204f-dc94-46a5-9436-2c84a8ecebe4	966a3bcc-d18c-484e-b60e-37cdd682cb84
deb65734-78eb-4448-8547-1ebc914a091b	bcd1062c-4670-4789-a2e2-c5689a0443f4	1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9
908bf2e5-f541-4465-9547-e2c93b1efdc8	bcd1062c-4670-4789-a2e2-c5689a0443f4	79325b26-f52e-48bf-9185-b30de43d64d3
9f6beea7-c0aa-417c-aa5b-e88d54907483	bcd1062c-4670-4789-a2e2-c5689a0443f4	bd7c933d-b38a-4acf-8053-496d42630b61
e7c5d701-6db3-4e0b-afd7-69c568ee47ad	bcd1062c-4670-4789-a2e2-c5689a0443f4	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
1ff380c5-881c-446b-b805-d211c8d64eac	bcd1062c-4670-4789-a2e2-c5689a0443f4	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
e8dc4d7a-b173-4717-98ae-480c72aaecfb	bcd1062c-4670-4789-a2e2-c5689a0443f4	46d123ae-7693-47a9-9d39-d1316173a1e9
dacbaa1d-a9ad-403e-8850-09aea15d8bec	bcd1062c-4670-4789-a2e2-c5689a0443f4	00cdb44d-3200-46f0-8757-42e78e569a42
7cf45412-ba4b-47b1-b106-88aaeb86b91c	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
e28f8a07-75a8-4590-a01a-d6de50a8247a	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	be3bbe21-0a5a-4fef-aff3-0e3d5426f984
56f3e9b4-27b5-44a4-aa77-3fb3d180cc5d	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	c83b9a45-346e-41f7-ac61-39811253a2a4
ab9a6211-38d2-42d3-9fec-8de1c5cd9366	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	6b428caa-622b-47c3-824b-3c755683a21c
d7543b8f-41a9-4388-a7c6-0623c3599aa9	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	011875b1-f030-4ee5-a103-7a5900a6b8b6
cc90b957-48e0-45b0-8258-12833b6c857f	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
1888aefd-4aa3-4f13-a17f-8178c1fb3c49	91ac1e34-f21a-4dff-80be-d1b226f7fc0d	4974c20a-94d5-4a52-983f-4abba57a225b
f8351d9c-d7d0-4c93-a049-7f96f98fb824	af39951b-dc84-4de4-a988-cff674af1e74	5b7f965f-4d06-47aa-bf3d-0e66b47709af
458837fb-028e-4c70-86b5-c40ebf0e15b8	af39951b-dc84-4de4-a988-cff674af1e74	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
c6e7596c-7b99-45e9-91dd-bfb83d069ec9	af39951b-dc84-4de4-a988-cff674af1e74	ddfa5493-8205-46d9-a29c-4934739cb1b4
0e9ca3e0-9c53-43fa-b579-a32b15274d63	af39951b-dc84-4de4-a988-cff674af1e74	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
2056ee8c-68d0-440c-96fc-18fae6f69d23	af39951b-dc84-4de4-a988-cff674af1e74	04131970-6b8c-41fa-a21b-57f1b1bbef21
4f9c6cf0-076d-48c6-acf4-ce933b606cd3	af39951b-dc84-4de4-a988-cff674af1e74	b1ae56e1-c683-49c2-95b2-b96f71fc435c
be2243a4-4dd4-43da-89a6-535a0024aaf6	af39951b-dc84-4de4-a988-cff674af1e74	b8590cf6-ac78-40f7-b434-dacc456bdd2f
cd3bcd12-b90d-4d10-a654-13d050bb657c	f23fb250-d5c5-44d4-a4e5-3d73cf4df927	67ae3aea-4ab7-402b-9c64-9772d924bf69
639c1ecd-1561-4812-b919-1bdec7e6dfe7	f23fb250-d5c5-44d4-a4e5-3d73cf4df927	decba44a-23dc-4d6b-b754-4799e45488d6
f130552f-e7ab-4762-b5c4-16c2e3ac5742	f23fb250-d5c5-44d4-a4e5-3d73cf4df927	e9be5267-6bc7-4816-92b9-0823824a3f91
a3a91bce-e432-42db-8756-0b3804bb4a55	f23fb250-d5c5-44d4-a4e5-3d73cf4df927	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
e7609a7a-8908-4eaa-9dfd-b0ac3b85bf6e	f23fb250-d5c5-44d4-a4e5-3d73cf4df927	ce19f108-27f8-4df8-9866-8675d9c623f0
8723be05-c893-4dc5-b0e9-8c77b4662f3a	66e520f1-7fd5-42de-9aae-d48e339e14c6	b911af8e-191c-476d-bbf6-6848e12ca6cb
ba31568f-7913-42c7-bcac-b1b9c84ca0b0	66e520f1-7fd5-42de-9aae-d48e339e14c6	02dbd7ca-f388-43fd-9548-173a35837682
effcadee-3146-4654-ba88-c3cefdbdfd28	66e520f1-7fd5-42de-9aae-d48e339e14c6	0cba341f-4f70-4f9e-b03c-177862b22df3
3bbaf6b6-697a-4b93-8d3d-862d6bf306b3	66e520f1-7fd5-42de-9aae-d48e339e14c6	d497faaf-de8a-48c5-9e50-89d65255dac8
f9bb9cc4-edae-436c-9ac7-37e13dbd1dbb	66e520f1-7fd5-42de-9aae-d48e339e14c6	cd28bafd-e93c-4ef2-b99d-85d18e269d5b
438b665c-0f4d-4fc6-8e49-63e28fc5e43a	66e520f1-7fd5-42de-9aae-d48e339e14c6	2894cadd-aa58-44ef-a09a-f865f2937bf3
ad586c5e-f21e-4f1d-bffa-8bfe5d912c76	66e520f1-7fd5-42de-9aae-d48e339e14c6	d8be6eba-fd02-48ef-8424-cbb640b9bd27
f3f60dbf-b8ce-4d57-9fa1-609029aa1570	25a950e4-1385-4a6b-9004-998c84604324	d85ccb92-9175-4029-827c-2ccade6984e3
698bc567-24cd-40fa-8ed5-873e69a5b0a8	25a950e4-1385-4a6b-9004-998c84604324	00452b01-da8a-4380-8759-877c80f392dd
1be4adca-76ff-42fa-9ad3-39d410cce6fc	25a950e4-1385-4a6b-9004-998c84604324	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
d56a7b2b-7cea-4f73-8fc0-8ffdd2ebd6b6	25a950e4-1385-4a6b-9004-998c84604324	28eac750-7a50-439f-bf5d-e07bbb4f496a
92010473-6e2c-4406-acf7-a3e4aad351bc	25a950e4-1385-4a6b-9004-998c84604324	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
1b99b48a-f14e-4475-84a1-5c1f631a97c3	25a950e4-1385-4a6b-9004-998c84604324	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
606cecac-1296-4efa-b9ea-e3e6754a916a	25a950e4-1385-4a6b-9004-998c84604324	951adef9-ef3b-4d3d-880d-a9788b4cbae6
443db683-392b-477b-a3fa-eedf25f0611b	fc6173cc-26cb-436f-894a-fd61d43a1f12	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
9837624e-6ba4-41e4-9d23-a4ae1367771d	fc6173cc-26cb-436f-894a-fd61d43a1f12	6eb08218-0a94-451d-bf6d-b3e5c2967b09
889e1096-44c2-4710-9a00-5396e5472d2d	fc6173cc-26cb-436f-894a-fd61d43a1f12	38670ebf-9e68-40d6-845a-3061a47cafe6
eef5304c-d230-40db-ba3e-7b2ecc671177	fc6173cc-26cb-436f-894a-fd61d43a1f12	6ee66dc9-a0db-4607-b2cf-edc741e28833
b311bb64-a92e-450c-b5db-241743eda9c1	fc6173cc-26cb-436f-894a-fd61d43a1f12	c8fec09c-b992-463f-97fb-106c29d889bc
8bd03570-2600-4649-808f-55af2c214eb2	fc6173cc-26cb-436f-894a-fd61d43a1f12	20a9c879-f4a5-4486-9161-50701b056327
b8dd9c54-ac8f-482c-a18d-69460a94d971	fc6173cc-26cb-436f-894a-fd61d43a1f12	6f474582-2930-4901-9d09-efdf4679f879
03c0f4b5-ca5a-46a6-956f-7b7766be55c5	9fe2a830-63d8-4f11-9d90-1b86da1c5661	8c96bcec-e94f-4470-9096-3b034db6ef57
cc885ea2-bcac-4afb-b9f7-efc2f04f61d8	9fe2a830-63d8-4f11-9d90-1b86da1c5661	670afeb2-fa6e-4769-9c38-d7dfaa3be259
d31faafc-6524-4fec-8013-e53dd466e6f1	9fe2a830-63d8-4f11-9d90-1b86da1c5661	631d799c-e4cc-4f12-b74e-973dabb21075
57eeb09a-6da5-4f09-8424-4965a650c9d3	9fe2a830-63d8-4f11-9d90-1b86da1c5661	282a9ee7-0259-4e07-b343-37c486d94416
8e43608e-3e0b-4ac3-9be6-2944663f9c97	9fe2a830-63d8-4f11-9d90-1b86da1c5661	688f2b9a-9285-46e9-9b78-d60977fd9360
af90ed6d-9a68-480e-bb07-5eb7b7e6095e	9fe2a830-63d8-4f11-9d90-1b86da1c5661	e904973e-dec8-405b-b085-ad3090267a7a
30ceee40-dfc9-44eb-a8cd-c3bfa2ab5be4	9fe2a830-63d8-4f11-9d90-1b86da1c5661	8a245a89-7254-42d9-b8fd-2eac410a5585
ee1b851b-6df9-4e2c-93f6-c7c5d3d97e4c	12fa7340-727c-4276-a7b2-255d605d893a	8c96bcec-e94f-4470-9096-3b034db6ef57
de3e5517-405a-4eef-9ac2-13cc03ab4251	12fa7340-727c-4276-a7b2-255d605d893a	b911af8e-191c-476d-bbf6-6848e12ca6cb
e54fbe66-7e36-4bc0-ae21-dcb791afa31f	12fa7340-727c-4276-a7b2-255d605d893a	1870d9f2-9162-4fbd-bf50-43698022b8da
92191af4-2182-4c6d-837e-1f2d6212553e	12fa7340-727c-4276-a7b2-255d605d893a	e9be5267-6bc7-4816-92b9-0823824a3f91
96c4279a-d2e9-4e23-9940-d755b2d8f64f	12fa7340-727c-4276-a7b2-255d605d893a	c9647eeb-2d2f-49ff-ac2f-7ec2668715b3
88afd10c-ebd0-4993-a877-b4a14c8316fe	12fa7340-727c-4276-a7b2-255d605d893a	ce19f108-27f8-4df8-9866-8675d9c623f0
fa57668c-9411-4075-8299-5f4ce0f64efa	5c470824-23a5-40ba-b427-c42e80451064	02dbd7ca-f388-43fd-9548-173a35837682
ea0c314a-2bfc-465d-9c6f-4f3e06ab8ca0	5c470824-23a5-40ba-b427-c42e80451064	ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db
0ed76dcb-90d6-41fa-9f83-73a7d7f81b19	5c470824-23a5-40ba-b427-c42e80451064	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
7e1911e7-c054-4199-b61b-65e9a17ffc11	5c470824-23a5-40ba-b427-c42e80451064	2f41465a-30ef-4518-9af9-564e610a295c
979e53ec-c16f-4e0d-82cf-6a8b80c78b53	5c470824-23a5-40ba-b427-c42e80451064	2894cadd-aa58-44ef-a09a-f865f2937bf3
34c224a0-104b-4b90-a798-8c52a0e53ef2	5c470824-23a5-40ba-b427-c42e80451064	966a3bcc-d18c-484e-b60e-37cdd682cb84
31923a9a-4282-4288-adb3-26247981199c	a7ccbf86-1160-45e1-abc9-6b841152d9e8	d85ccb92-9175-4029-827c-2ccade6984e3
3f40fa85-3d03-419d-b9df-846b4ed785a3	a7ccbf86-1160-45e1-abc9-6b841152d9e8	00452b01-da8a-4380-8759-877c80f392dd
19501aa6-9d83-47eb-93bc-e4ee3ccbeb79	a7ccbf86-1160-45e1-abc9-6b841152d9e8	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
1b158123-9f6c-4509-ad00-e52d7af9281d	a7ccbf86-1160-45e1-abc9-6b841152d9e8	28eac750-7a50-439f-bf5d-e07bbb4f496a
ca78af08-1d06-4aef-a4a6-7619c9d3d00f	a7ccbf86-1160-45e1-abc9-6b841152d9e8	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
6fc2be68-851a-42be-ba77-8433dc0c15dd	a7ccbf86-1160-45e1-abc9-6b841152d9e8	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
8a409b5d-3fe6-4d43-9cc5-feb209d5bac8	a7ccbf86-1160-45e1-abc9-6b841152d9e8	951adef9-ef3b-4d3d-880d-a9788b4cbae6
ec84d532-abaa-4ad7-9eca-03c4bd64791c	10315726-5239-4446-9aae-0f342a1e5031	d85ccb92-9175-4029-827c-2ccade6984e3
4ec71d6f-da19-47b5-80e2-4b62eb7edd4c	10315726-5239-4446-9aae-0f342a1e5031	00452b01-da8a-4380-8759-877c80f392dd
82f4fe22-84f2-4596-b012-da0386dd0c72	10315726-5239-4446-9aae-0f342a1e5031	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
7864fa4e-d14c-428c-97ca-0a1389f23127	10315726-5239-4446-9aae-0f342a1e5031	28eac750-7a50-439f-bf5d-e07bbb4f496a
8bfa5b7d-09ef-42c1-a758-19ac6fbefb91	10315726-5239-4446-9aae-0f342a1e5031	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
599986c9-01dd-4dc4-8c02-d4da2a888310	10315726-5239-4446-9aae-0f342a1e5031	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
9ba805c7-8937-4196-b2ee-5e636e09ca6a	10315726-5239-4446-9aae-0f342a1e5031	951adef9-ef3b-4d3d-880d-a9788b4cbae6
91cfd1e9-04c5-42f7-9a11-9d5ec449d117	c8715ee4-a797-4b82-bde7-9a6a35e62169	553157a9-f226-49fa-af48-e508f1395f83
89a3f1aa-35e3-4dad-a23e-e9b8b79923a2	c8715ee4-a797-4b82-bde7-9a6a35e62169	be3bbe21-0a5a-4fef-aff3-0e3d5426f984
0dd4e4c5-db88-43e0-aae3-ba568dd26f0b	c8715ee4-a797-4b82-bde7-9a6a35e62169	c83b9a45-346e-41f7-ac61-39811253a2a4
65aff6cb-7da8-4d1b-8491-6df1d67bca9c	c8715ee4-a797-4b82-bde7-9a6a35e62169	6b428caa-622b-47c3-824b-3c755683a21c
40ef69e7-456c-47b7-bfdc-1b838d2428d7	c8715ee4-a797-4b82-bde7-9a6a35e62169	011875b1-f030-4ee5-a103-7a5900a6b8b6
f0ea8ba3-77cc-4755-8830-8f0860eef414	c8715ee4-a797-4b82-bde7-9a6a35e62169	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
45387230-eef5-40b8-ab1e-5e1d5e2e7aab	c8715ee4-a797-4b82-bde7-9a6a35e62169	4974c20a-94d5-4a52-983f-4abba57a225b
5501ad27-0711-472f-ac36-eea270150a65	9d453036-db53-4334-9dcb-d669f0c6b113	8c96bcec-e94f-4470-9096-3b034db6ef57
d868c1bb-7a9c-4207-a7e9-db3f61fb2865	9d453036-db53-4334-9dcb-d669f0c6b113	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
df349200-69e3-44db-85f1-53c68d54ee59	9d453036-db53-4334-9dcb-d669f0c6b113	c7603d88-fad0-487b-9eb7-c3c31a5ca59d
0fb016a6-c64c-43d0-ba7e-a9b5464724c8	9d453036-db53-4334-9dcb-d669f0c6b113	cdce8b68-4fc8-4d39-b39c-3485307475cb
45506ee2-5e03-4614-a903-ba6a79637ebf	9d453036-db53-4334-9dcb-d669f0c6b113	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
a2fa8ccc-8ab3-44fa-9ae6-bc24d5d96b2f	9d453036-db53-4334-9dcb-d669f0c6b113	6c0eeba4-a22a-4e64-8058-ab328711b8b0
cba5b199-1b07-4d56-a197-9b87caf1134d	9d453036-db53-4334-9dcb-d669f0c6b113	34c2c6e6-a3d9-4d0f-97f9-954087748564
f2d2e274-a596-4f22-bdb6-fd8cb96adca6	dc441274-941e-4512-b49d-faa01f2476de	b911af8e-191c-476d-bbf6-6848e12ca6cb
d4bfc532-653c-4d10-889d-f6903578ce48	dc441274-941e-4512-b49d-faa01f2476de	84885e6f-7c44-4922-96a5-5f19ce145f96
aee64510-906e-4bfe-933b-119e830ca930	dc441274-941e-4512-b49d-faa01f2476de	ae3b7895-feda-406e-a6b8-61a8a20dcd3a
585f90a1-29e2-4be8-b550-2820e6a5eee0	dc441274-941e-4512-b49d-faa01f2476de	ab145af8-a7f3-460d-96c2-0955ad99420e
0e138d68-9bca-4eb5-9d1a-208724998e92	dc441274-941e-4512-b49d-faa01f2476de	760e0210-eaf2-4bb5-af81-985e4d149200
b9c746c2-6751-4d93-bad0-0cb57580e0ab	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	d65c7d3f-40de-42d6-ac23-bf434daaad00
45ba6fd7-bd9d-455d-9b0b-cfbb976061a5	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	e34c8419-09e5-4302-a5b4-60b8830419f2
1c28843f-16e2-4a91-97e5-0b011941dc19	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	5cada605-9735-4e39-9f67-e3915eb9ecfb
af8af463-a84d-4223-b148-113d34f9ae90	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	3dfad056-e365-45cd-8c74-59b49985eca2
9261d3ea-5bc0-447b-b76d-5dd40eb5b06e	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
62ca2463-fbee-48c4-af72-9139962f4bd9	1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	966a3bcc-d18c-484e-b60e-37cdd682cb84
7674198b-259e-4335-9a6d-8df97a75aad2	46144d07-3a15-47ac-a1a5-537fda6ff34b	d85ccb92-9175-4029-827c-2ccade6984e3
de3d4d67-8c8f-40ea-ad59-7a59931d872b	46144d07-3a15-47ac-a1a5-537fda6ff34b	1dbbe31c-27f2-47c4-a200-2346d84314b7
07d9373a-96c5-4a0c-a188-fb9fd04ac299	46144d07-3a15-47ac-a1a5-537fda6ff34b	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
ff6e80f1-5795-437f-8ecd-89284848426e	46144d07-3a15-47ac-a1a5-537fda6ff34b	28eac750-7a50-439f-bf5d-e07bbb4f496a
41caaa61-fffb-4618-9c90-348c3dfdc892	46144d07-3a15-47ac-a1a5-537fda6ff34b	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
b45fe57e-b584-4c5f-9d5f-8b50ed458559	46144d07-3a15-47ac-a1a5-537fda6ff34b	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
72f0e13a-d9a9-4e63-8f50-df3c4831015d	46144d07-3a15-47ac-a1a5-537fda6ff34b	951adef9-ef3b-4d3d-880d-a9788b4cbae6
c286eeaa-a228-4baf-9df0-f4677266f9c3	cb2104f4-abe1-4f00-b346-47f53522e24e	553157a9-f226-49fa-af48-e508f1395f83
70655225-5693-4aa2-8da7-dda8640e087e	cb2104f4-abe1-4f00-b346-47f53522e24e	40c13606-829a-4d32-9a2f-634465feb1b3
1574b9b9-f50e-410e-9eaa-01c29af0c234	cb2104f4-abe1-4f00-b346-47f53522e24e	38670ebf-9e68-40d6-845a-3061a47cafe6
5bbac83b-61b5-460b-b5bf-3fa038e6c9f9	cb2104f4-abe1-4f00-b346-47f53522e24e	6ee66dc9-a0db-4607-b2cf-edc741e28833
7a080fde-c7fb-4b1a-bea6-743c4c13ad24	cb2104f4-abe1-4f00-b346-47f53522e24e	c8fec09c-b992-463f-97fb-106c29d889bc
2ea31143-11fb-459b-9aca-3fefaf41c7c9	cb2104f4-abe1-4f00-b346-47f53522e24e	20a9c879-f4a5-4486-9161-50701b056327
67e3ac49-f89a-4caa-8fb1-3f34f59ee42e	cb2104f4-abe1-4f00-b346-47f53522e24e	6f474582-2930-4901-9d09-efdf4679f879
7523092a-7ba0-480e-a706-defefcfa4c0b	e05541df-7807-4d0e-a467-ceafa39a16e0	8c96bcec-e94f-4470-9096-3b034db6ef57
4fec6412-e40e-474d-8cc7-1cf928c57fbd	e05541df-7807-4d0e-a467-ceafa39a16e0	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
681e11aa-eb65-4e2a-9290-0f1c2a18dd1c	e05541df-7807-4d0e-a467-ceafa39a16e0	631d799c-e4cc-4f12-b74e-973dabb21075
af22c2e9-b1e9-4680-8a0e-50e71d4e6f03	e05541df-7807-4d0e-a467-ceafa39a16e0	282a9ee7-0259-4e07-b343-37c486d94416
26a5ccc6-8d67-4e24-b9e2-a638536a64b1	e05541df-7807-4d0e-a467-ceafa39a16e0	02df8cb1-f817-4182-a8da-24f24737babc
d5834327-00bf-4a13-b037-c829379d7f53	e05541df-7807-4d0e-a467-ceafa39a16e0	6c0eeba4-a22a-4e64-8058-ab328711b8b0
64ac5cc5-b9a8-4767-bed4-3ac0590b60b7	e05541df-7807-4d0e-a467-ceafa39a16e0	b8590cf6-ac78-40f7-b434-dacc456bdd2f
84c6c199-0699-44a7-a7aa-48524c6f8a78	d4ec0dd2-72eb-4b4b-b119-d29704ae8096	b911af8e-191c-476d-bbf6-6848e12ca6cb
54f079be-c879-40a5-aaec-1ab270f1e736	d4ec0dd2-72eb-4b4b-b119-d29704ae8096	84885e6f-7c44-4922-96a5-5f19ce145f96
a952944b-a097-4427-b1e3-b2f3c81434c6	d4ec0dd2-72eb-4b4b-b119-d29704ae8096	7fee0783-f025-4da1-8cec-fbcd18b107b0
0f12305e-73b7-423a-8951-e607b8e8cdef	d4ec0dd2-72eb-4b4b-b119-d29704ae8096	64845272-2299-403b-a285-0a9515b643d8
f37c270b-6e0c-4372-9c15-5dd4c11596d3	d4ec0dd2-72eb-4b4b-b119-d29704ae8096	ce19f108-27f8-4df8-9866-8675d9c623f0
1c244063-9b75-4b8b-8d28-c44f2f01c9a1	aa380614-ba17-4900-aa1b-2ae01e0a7383	02dbd7ca-f388-43fd-9548-173a35837682
837d0e67-d620-4b4b-81e9-dc190cd264de	aa380614-ba17-4900-aa1b-2ae01e0a7383	ea45aec4-8eb0-4141-af1f-09195f8b5e3d
c9966d9d-ff67-4230-8059-0ad9b4295adc	aa380614-ba17-4900-aa1b-2ae01e0a7383	261ef8d9-eeae-44f0-8c52-57315abc0007
6dc99005-aa62-4a90-8c7a-37e84a0c4b38	aa380614-ba17-4900-aa1b-2ae01e0a7383	2f41465a-30ef-4518-9af9-564e610a295c
ba63299a-a92a-4528-b8a8-76f90bb453c3	aa380614-ba17-4900-aa1b-2ae01e0a7383	2894cadd-aa58-44ef-a09a-f865f2937bf3
d0128b9c-8162-4265-ba5c-4ddc725c22f1	aa380614-ba17-4900-aa1b-2ae01e0a7383	d8be6eba-fd02-48ef-8424-cbb640b9bd27
e3f88365-4209-467d-bf34-0933d196927b	b4239d79-cbe5-4517-b88b-c5a6a0884268	d85ccb92-9175-4029-827c-2ccade6984e3
3f3a42de-e16c-4cb2-87b4-712ae4befe47	b4239d79-cbe5-4517-b88b-c5a6a0884268	26982feb-eba9-4b04-89ea-98535fa61c3d
9f6a7ade-6d04-434c-90bf-dfedafa66732	b4239d79-cbe5-4517-b88b-c5a6a0884268	f4433601-a483-44d6-8c98-898ff69193d1
cfe45ff8-581f-4b95-b096-5259de1a1107	b4239d79-cbe5-4517-b88b-c5a6a0884268	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
94d49969-0167-46b7-b655-e7ae7f2a6bc5	b4239d79-cbe5-4517-b88b-c5a6a0884268	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
b5a0e28a-42d1-4e4c-a428-6d095ed4e2c7	b4239d79-cbe5-4517-b88b-c5a6a0884268	46d123ae-7693-47a9-9d39-d1316173a1e9
41f4347f-4ede-495e-92ff-a689ac14fd78	b4239d79-cbe5-4517-b88b-c5a6a0884268	11063ddf-508e-4281-8dc5-ac4bd1563d0c
31b28d5a-d493-4e86-b09b-9e215019513e	f44798d8-f253-4cdd-866a-794755adfd90	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
969caff0-4471-4e4d-9cdb-e47bd776e8a0	f44798d8-f253-4cdd-866a-794755adfd90	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
64d2d3c2-e3ca-4d68-9fed-72a69648ec39	f44798d8-f253-4cdd-866a-794755adfd90	38670ebf-9e68-40d6-845a-3061a47cafe6
e34838e4-d575-454f-a640-f6fe875cb7d3	f44798d8-f253-4cdd-866a-794755adfd90	8e5aedfc-077e-4c70-847c-d06a94840fa4
a4bcef98-0371-40d3-9197-57843c394d2f	f44798d8-f253-4cdd-866a-794755adfd90	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
c5ffcb77-7241-40f0-9608-857c81c837e1	f44798d8-f253-4cdd-866a-794755adfd90	20a9c879-f4a5-4486-9161-50701b056327
d8e0b4bc-8696-4cc2-9222-e5a32b4f0177	f44798d8-f253-4cdd-866a-794755adfd90	6f474582-2930-4901-9d09-efdf4679f879
dde76e13-2780-4258-90c0-e1663ca52c65	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
d921cff5-6838-4552-a2a4-dccb151fd2f4	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	670afeb2-fa6e-4769-9c38-d7dfaa3be259
efccf879-3620-48ef-845d-3ac1ba692a63	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	556e545d-5b80-483d-9b7d-a822172e4a7b
1cfb6d75-0422-4a51-8192-a267eadac1fd	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
f1e70649-c4d1-49b9-b247-f9adf9244c45	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
c479cb0d-2f04-4e05-ac5b-7cc897b3880f	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	6c0eeba4-a22a-4e64-8058-ab328711b8b0
88bc05d7-9a68-48cc-a2fd-4c933471098e	c86927f4-6a88-4b32-b357-eae3dc3ed9d8	8a245a89-7254-42d9-b8fd-2eac410a5585
44f0b7df-badc-4086-b230-b201b88ea9fe	14b700e5-5c68-4a33-8a8b-75dd5c84691d	b911af8e-191c-476d-bbf6-6848e12ca6cb
9c2958c5-7ab0-4945-83e7-d7d4ab89bc03	14b700e5-5c68-4a33-8a8b-75dd5c84691d	84885e6f-7c44-4922-96a5-5f19ce145f96
5fb43b1a-34bf-4ecf-a039-1ef4a486d3e7	14b700e5-5c68-4a33-8a8b-75dd5c84691d	b0b9724c-158c-4487-b15c-cc77674bde0a
78291eaf-ab10-4581-bc3a-4a8c482c3079	14b700e5-5c68-4a33-8a8b-75dd5c84691d	64845272-2299-403b-a285-0a9515b643d8
3412844b-a380-4a41-b9e5-3e8d15bf4b12	14b700e5-5c68-4a33-8a8b-75dd5c84691d	760e0210-eaf2-4bb5-af81-985e4d149200
e0cb6c2b-b4b8-4c86-88d2-1576aee2a574	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	02dbd7ca-f388-43fd-9548-173a35837682
b0288f9c-d42b-4881-98ca-8bd432c53f24	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	1780c740-f601-4108-9203-fd5a70a9d180
69e9966d-92e3-4029-9d70-c1664a39dabb	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
3709b259-3911-48af-ad90-624d84705280	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	3dfad056-e365-45cd-8c74-59b49985eca2
487628ab-6faa-4a0c-8eb9-a8faf2458b2c	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	87ea4e24-4b45-4e2a-b731-7a9738806c64
9dd211ff-63b6-4175-80bd-81e9d576d521	a3f75685-e4b4-4f0a-8f60-0a4be11bd469	d8be6eba-fd02-48ef-8424-cbb640b9bd27
54dea184-1bc3-4c7a-80ad-45b15d284c38	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	d85ccb92-9175-4029-827c-2ccade6984e3
78dc5280-0bac-4baf-8503-9d30643d162b	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	79325b26-f52e-48bf-9185-b30de43d64d3
ab40d9cb-29c8-454f-a444-a4f2301ca116	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	bd7c933d-b38a-4acf-8053-496d42630b61
1b03e054-0e5d-4587-b3bc-471de7587d52	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
4d0000a1-79f0-4585-90ae-3acf463702d4	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
2e8aa1c2-9a91-4c74-9402-33021c64b8b9	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	00b08d53-72ae-4330-934f-2f5290bb24fc
7a4e7484-4d53-4930-94be-00616eae78db	14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	11063ddf-508e-4281-8dc5-ac4bd1563d0c
ef15435b-08ad-43de-9fea-aadab32afcdd	9c175a45-191c-4b05-9cab-7652670b5851	d85ccb92-9175-4029-827c-2ccade6984e3
64207dc7-0874-4aa9-ada6-e4e0dddfb839	9c175a45-191c-4b05-9cab-7652670b5851	1dbbe31c-27f2-47c4-a200-2346d84314b7
0c41b4c0-66e1-44a3-91dc-b0eca2b1bcd1	9c175a45-191c-4b05-9cab-7652670b5851	ff0653fc-e130-4ea9-b889-96f4bea63b62
422315f9-f75a-462c-9bfd-6a8eec023943	9c175a45-191c-4b05-9cab-7652670b5851	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
403f3312-f78f-4440-a0c6-b1477269c760	9c175a45-191c-4b05-9cab-7652670b5851	4e947c6f-446e-4e8e-8cf8-083538146cfe
769dfcd9-a535-46b8-9f5e-08d0b9600570	9c175a45-191c-4b05-9cab-7652670b5851	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
8f40f6a3-2bfb-46b0-9b53-05841fe2f196	9c175a45-191c-4b05-9cab-7652670b5851	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
e45f0adb-8e75-4dd0-b549-8a615bf4b3b5	c6db4692-6194-404b-be31-0ec30013f94c	d85ccb92-9175-4029-827c-2ccade6984e3
763afc88-6e49-4724-a6b7-a71523ced3dd	c6db4692-6194-404b-be31-0ec30013f94c	26982feb-eba9-4b04-89ea-98535fa61c3d
0527dfcf-35a2-48c4-8b6b-1346e0f3f5f4	c6db4692-6194-404b-be31-0ec30013f94c	bd7c933d-b38a-4acf-8053-496d42630b61
19aeafe6-a738-4400-a7ff-f8639b8b1ac2	c6db4692-6194-404b-be31-0ec30013f94c	1e361eae-eb51-4d32-ab0c-cd453bdd2734
9006a69c-1878-44c1-a19e-683adeb580f9	c6db4692-6194-404b-be31-0ec30013f94c	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
c6e03e6d-ff7f-4458-ab1a-bec8b30ece8b	c6db4692-6194-404b-be31-0ec30013f94c	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
c3dad269-7a71-48c2-8cf8-6d8ea64ae4a7	c6db4692-6194-404b-be31-0ec30013f94c	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
2b9f45a6-4c74-45e2-af4e-116bfa9b01e7	7096a2ea-ce01-4064-924c-6dff33ad0925	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
8b473547-31af-485b-97fa-76baf3674f26	7096a2ea-ce01-4064-924c-6dff33ad0925	40c13606-829a-4d32-9a2f-634465feb1b3
f0f20621-2482-4808-a3e0-8bdf5af12d03	7096a2ea-ce01-4064-924c-6dff33ad0925	c965fa2d-0ebd-440c-86ce-bab64e06553a
319e4a81-521a-4340-bd53-9ae7a392a0f8	7096a2ea-ce01-4064-924c-6dff33ad0925	868435dd-ab2f-48d0-8fc8-97b29a652c0c
6f0826e7-2c39-46ab-b2a4-85823d0a42ef	7096a2ea-ce01-4064-924c-6dff33ad0925	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
6f2a4b44-f57b-487d-8e18-e286ba8b3ac3	7096a2ea-ce01-4064-924c-6dff33ad0925	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
09fb21cc-7a78-47ce-8a47-517e55598aee	7096a2ea-ce01-4064-924c-6dff33ad0925	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
0647a9f6-0245-40d8-a7e5-02bb65b87808	2584358d-c2df-4264-9450-48daac65dbe9	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
fa09d756-831a-4050-9a7c-05581c65805f	2584358d-c2df-4264-9450-48daac65dbe9	3635d565-2a74-447e-829b-b7e334ef194e
8e4209a0-03ae-4348-abed-b74950ad2752	2584358d-c2df-4264-9450-48daac65dbe9	556e545d-5b80-483d-9b7d-a822172e4a7b
19bff525-02f2-4214-a77c-7d9fd209b270	2584358d-c2df-4264-9450-48daac65dbe9	282a9ee7-0259-4e07-b343-37c486d94416
576b03b2-1dbe-4701-9893-f057b0473a19	2584358d-c2df-4264-9450-48daac65dbe9	688f2b9a-9285-46e9-9b78-d60977fd9360
fd3a6475-c940-42e6-84d5-47e566f52540	2584358d-c2df-4264-9450-48daac65dbe9	b1ae56e1-c683-49c2-95b2-b96f71fc435c
9fc780a1-6b3c-43dc-98b5-41ff13d7fc97	2584358d-c2df-4264-9450-48daac65dbe9	8a245a89-7254-42d9-b8fd-2eac410a5585
97659269-b7b1-4195-8e8f-aa25e3649ea5	c6573325-183e-4330-a4a2-6504316da50c	68a35597-81f3-435d-935f-f89ecd6add03
e56a28d5-53e7-47e3-98f2-689988925a23	c6573325-183e-4330-a4a2-6504316da50c	bb69df93-68c5-4063-a5fd-74ab02d5ba84
4619c111-f62d-43d0-89c3-dd310726d20d	c6573325-183e-4330-a4a2-6504316da50c	e9be5267-6bc7-4816-92b9-0823824a3f91
da22fc8d-07e9-4865-852e-eca925cb13ed	c6573325-183e-4330-a4a2-6504316da50c	8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9
7cac2e98-742d-4516-a5e5-c6a1a8c031ee	c6573325-183e-4330-a4a2-6504316da50c	cfdcca34-7fd5-4838-9370-21276899c178
eb656e33-00a0-40a0-99ae-880b10e1796d	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	02dbd7ca-f388-43fd-9548-173a35837682
835a853c-818b-4495-b79b-822e2573015c	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	1780c740-f601-4108-9203-fd5a70a9d180
a61674af-5910-4385-8abb-382b49048a81	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	5cada605-9735-4e39-9f67-e3915eb9ecfb
c51e5b9b-98ea-4509-86cf-0944f018de32	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	443894b2-d27a-481b-b1db-dd991498fc5e
e3b1dfdb-1ce0-43ec-bc85-d2664401c0b5	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	4a2063fe-517e-4e6d-b888-337a6a0faf48
418096b5-dc5f-48bc-a1e2-ac6e499ab9b2	4a97d51e-9fd3-4e10-9acc-da509e32f2a0	966a3bcc-d18c-484e-b60e-37cdd682cb84
a65725ea-1473-454b-81ad-d41fa4f2a412	563afc75-a8ba-4ce5-b32f-0bc103e76be4	03999e08-b875-4f63-bf97-c220705ba672
8f49addb-4e12-4a22-9c12-55eb301e4107	563afc75-a8ba-4ce5-b32f-0bc103e76be4	26982feb-eba9-4b04-89ea-98535fa61c3d
467d9430-93bf-4d98-a2f5-93a75a6fb4fe	563afc75-a8ba-4ce5-b32f-0bc103e76be4	f4433601-a483-44d6-8c98-898ff69193d1
8269efa1-27a4-4fd8-a6ff-cf119230844f	563afc75-a8ba-4ce5-b32f-0bc103e76be4	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
e32dd69c-b64b-4bcb-a818-34e5fdd1cf25	563afc75-a8ba-4ce5-b32f-0bc103e76be4	4e947c6f-446e-4e8e-8cf8-083538146cfe
4709d233-34b8-4a9b-a4ae-1acdc6f0d7b6	563afc75-a8ba-4ce5-b32f-0bc103e76be4	00b08d53-72ae-4330-934f-2f5290bb24fc
f0264619-f3c0-47e0-8dad-7a07dce49b71	563afc75-a8ba-4ce5-b32f-0bc103e76be4	00cdb44d-3200-46f0-8757-42e78e569a42
84eab4a1-8db6-45ff-bcd7-acab3f9ca345	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
1f3e0091-26de-4797-bebf-36f782149333	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
18e2ea40-4706-408b-88f5-15c3933a55a8	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	c965fa2d-0ebd-440c-86ce-bab64e06553a
14bf4680-cc1c-4c0e-9fc8-4f35d0dafc18	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	6ee66dc9-a0db-4607-b2cf-edc741e28833
a8cb5610-0ed7-4e5a-b102-fd213ef1e5b4	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	011875b1-f030-4ee5-a103-7a5900a6b8b6
094958f1-d4f8-46d5-ba60-e5e8dac89271	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	298d4cb0-b557-4ec9-9a50-0a3415affaea
5ca2fd6b-4b61-4c94-8cd5-248668bf5057	3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
e3f08271-f39d-4146-a40b-42cc228bbd1a	84a6ce72-37b0-46b7-a01b-c52ce28f814a	8c96bcec-e94f-4470-9096-3b034db6ef57
2a5a0521-e4cd-4b28-96ed-6bf9a1993929	84a6ce72-37b0-46b7-a01b-c52ce28f814a	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
1f38d06a-28a8-48be-9b9e-c968d20f57f8	84a6ce72-37b0-46b7-a01b-c52ce28f814a	556e545d-5b80-483d-9b7d-a822172e4a7b
2a7c3e35-900e-47f7-b9f1-d723812287c0	84a6ce72-37b0-46b7-a01b-c52ce28f814a	cdce8b68-4fc8-4d39-b39c-3485307475cb
8bbbc79a-5491-45ef-9ba9-f4eb138bdc50	84a6ce72-37b0-46b7-a01b-c52ce28f814a	02df8cb1-f817-4182-a8da-24f24737babc
7e5a51ef-b860-4f40-8658-723b7722f168	84a6ce72-37b0-46b7-a01b-c52ce28f814a	e904973e-dec8-405b-b085-ad3090267a7a
9e4653da-fbd0-4361-b5db-3a657132442d	84a6ce72-37b0-46b7-a01b-c52ce28f814a	34c2c6e6-a3d9-4d0f-97f9-954087748564
835ddec7-4c50-4bda-9623-a48239b1a863	a25281bb-680d-4695-8530-51cfd01ac466	b911af8e-191c-476d-bbf6-6848e12ca6cb
a7112925-9e70-4081-ae53-0214cb11550c	a25281bb-680d-4695-8530-51cfd01ac466	84885e6f-7c44-4922-96a5-5f19ce145f96
2bbc7cb8-34dd-4cf0-ad90-5df05fe52c22	a25281bb-680d-4695-8530-51cfd01ac466	b0b9724c-158c-4487-b15c-cc77674bde0a
0328a3ca-547a-4dd9-ae9f-21f4aafc288e	a25281bb-680d-4695-8530-51cfd01ac466	64845272-2299-403b-a285-0a9515b643d8
896d2226-1421-42ca-8c05-bd9257ae2f10	a25281bb-680d-4695-8530-51cfd01ac466	64c02f11-0204-4a11-be07-68ef5b0f36f1
3128b5e9-edc5-4cfd-8cb2-0af61d3b684d	3866af98-75af-4fd3-aee5-967220fad1d5	02dbd7ca-f388-43fd-9548-173a35837682
f3dbf025-a328-426b-af71-36cac9ffd31c	3866af98-75af-4fd3-aee5-967220fad1d5	ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db
169277b0-7e98-4277-ba67-bc5a042b1737	3866af98-75af-4fd3-aee5-967220fad1d5	3c0e478d-ec46-4585-a584-08b67e891b47
d49a520f-0072-47e6-a2b9-b195f95b6a56	3866af98-75af-4fd3-aee5-967220fad1d5	aad04f4c-db14-4ef4-9998-686fa9002e11
27d24c80-656f-416e-bf56-aecac6c30ee1	3866af98-75af-4fd3-aee5-967220fad1d5	87ea4e24-4b45-4e2a-b731-7a9738806c64
5f80bcba-93a1-4e7a-b31f-8b6d8a30f10d	3866af98-75af-4fd3-aee5-967220fad1d5	d8be6eba-fd02-48ef-8424-cbb640b9bd27
c60f3b6b-fa79-4a61-8a7c-3835afe62ae9	db735e71-e936-45be-a569-aaf8ae0c36ed	33c555fb-64bd-440d-9362-d420ce224c1a
5fc9e6da-5d7d-473d-b0b5-6e126a31cbc7	db735e71-e936-45be-a569-aaf8ae0c36ed	79325b26-f52e-48bf-9185-b30de43d64d3
ff17e8bd-ef4e-4ac4-98a9-253aa90efc32	db735e71-e936-45be-a569-aaf8ae0c36ed	f4433601-a483-44d6-8c98-898ff69193d1
8821f9f4-5b05-4a52-b4b0-6e3a5f53bae0	db735e71-e936-45be-a569-aaf8ae0c36ed	1e361eae-eb51-4d32-ab0c-cd453bdd2734
237fba55-8477-408e-91ff-99d73deafe09	db735e71-e936-45be-a569-aaf8ae0c36ed	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
01dac0d4-c644-4428-919e-7485dedfebcc	db735e71-e936-45be-a569-aaf8ae0c36ed	46d123ae-7693-47a9-9d39-d1316173a1e9
98bf579d-61fa-434d-8eb6-66f386c71b3b	db735e71-e936-45be-a569-aaf8ae0c36ed	11063ddf-508e-4281-8dc5-ac4bd1563d0c
6ce25433-9599-4637-9c22-df860cf66d38	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
e5d2f0dc-f8d2-4233-bb8d-a47809561601	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	40c13606-829a-4d32-9a2f-634465feb1b3
05aa0ad1-59d8-408d-841f-392ac1922f37	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	c965fa2d-0ebd-440c-86ce-bab64e06553a
46c423d6-600e-4504-9de5-d172c13d38a9	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	868435dd-ab2f-48d0-8fc8-97b29a652c0c
761e9192-d2d3-46bc-8d75-18ae4f06633b	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	011875b1-f030-4ee5-a103-7a5900a6b8b6
1b561923-04aa-4538-9fb4-e004aef75c7c	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	298d4cb0-b557-4ec9-9a50-0a3415affaea
a02c7052-3dea-48ca-9a6b-fbb8524d035e	1c42a71d-e670-40f8-8a1a-d93fb62b1b30	4974c20a-94d5-4a52-983f-4abba57a225b
fab5f065-d607-44b7-aa90-5ee0e0d066bd	aa25b2c8-7369-45fd-be0c-556b84d09be8	8c96bcec-e94f-4470-9096-3b034db6ef57
66b52cf0-33be-49ac-8eba-d915367e1c63	aa25b2c8-7369-45fd-be0c-556b84d09be8	3635d565-2a74-447e-829b-b7e334ef194e
cff3171a-f397-4b9c-a3ea-84e44335d750	aa25b2c8-7369-45fd-be0c-556b84d09be8	ddfa5493-8205-46d9-a29c-4934739cb1b4
dce95603-fbcd-49a4-b612-46dae18a0c76	aa25b2c8-7369-45fd-be0c-556b84d09be8	282a9ee7-0259-4e07-b343-37c486d94416
68502f20-b371-4588-892f-e8418a7b48ce	aa25b2c8-7369-45fd-be0c-556b84d09be8	688f2b9a-9285-46e9-9b78-d60977fd9360
7371b400-f363-469b-893f-b07ac2ffcc50	aa25b2c8-7369-45fd-be0c-556b84d09be8	b1ae56e1-c683-49c2-95b2-b96f71fc435c
6de88b28-8add-4461-93a7-c879e139fd1d	aa25b2c8-7369-45fd-be0c-556b84d09be8	8a245a89-7254-42d9-b8fd-2eac410a5585
39574eb7-c2a2-460f-bfba-56e50abfcbfe	c08409f3-1545-43de-a121-83d1ee496a84	68a35597-81f3-435d-935f-f89ecd6add03
8b97c8ed-596c-45e4-910e-ac6dd9b3fec1	c08409f3-1545-43de-a121-83d1ee496a84	1870d9f2-9162-4fbd-bf50-43698022b8da
d4b59bc0-9ae3-4a8d-a95d-52eff5921725	c08409f3-1545-43de-a121-83d1ee496a84	ae3b7895-feda-406e-a6b8-61a8a20dcd3a
6af51810-c2ba-4259-b8e5-03785a49f594	c08409f3-1545-43de-a121-83d1ee496a84	c9647eeb-2d2f-49ff-ac2f-7ec2668715b3
8b1d47b7-d17f-461c-9bff-a49817222424	c08409f3-1545-43de-a121-83d1ee496a84	64c02f11-0204-4a11-be07-68ef5b0f36f1
3c0c3056-05d1-4005-95de-eba2bf1ed24a	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	02dbd7ca-f388-43fd-9548-173a35837682
cf99467e-456f-49ff-956d-4c62586da950	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	1780c740-f601-4108-9203-fd5a70a9d180
c6cc1066-b081-4dfd-baea-4f1c293bf846	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	5cada605-9735-4e39-9f67-e3915eb9ecfb
b2f7ce53-cfff-498d-9940-32e102aad54b	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	443894b2-d27a-481b-b1db-dd991498fc5e
9741aa86-4ed3-4a18-8f49-331b3ad7f859	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	2894cadd-aa58-44ef-a09a-f865f2937bf3
a3759f65-85cd-4ad5-8a19-ae2654b0adbc	9dcf89d1-3d18-4b6e-b9a6-731a27207af3	d8be6eba-fd02-48ef-8424-cbb640b9bd27
5f238089-d8ea-4cd6-9c80-a1a8947bf2b6	5372cb10-3c24-4734-8c70-e631785245d9	d85ccb92-9175-4029-827c-2ccade6984e3
d4c2e572-ec7f-496a-908e-b1a84c69e096	5372cb10-3c24-4734-8c70-e631785245d9	26982feb-eba9-4b04-89ea-98535fa61c3d
3b8c74d8-a47f-4655-bfd2-5a9cf91d680f	5372cb10-3c24-4734-8c70-e631785245d9	bd7c933d-b38a-4acf-8053-496d42630b61
15d46ac9-3e82-4f33-93fa-7aae238ddc19	5372cb10-3c24-4734-8c70-e631785245d9	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
be1bc4d1-e67a-4615-8b1a-5001255f5dd1	5372cb10-3c24-4734-8c70-e631785245d9	4e947c6f-446e-4e8e-8cf8-083538146cfe
7abe02e7-a027-48d0-b9e4-6c94b302ba0a	5372cb10-3c24-4734-8c70-e631785245d9	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
172d78fe-0dd5-4141-80bb-647a2690a4f3	5372cb10-3c24-4734-8c70-e631785245d9	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
1cc08161-a5a9-44d4-a265-bff98efa06d5	05fe226f-3069-4057-9817-7fc88069c9c5	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
ee218b66-761c-4673-bbb5-3713b5ab77dc	05fe226f-3069-4057-9817-7fc88069c9c5	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
09402e63-d9c1-4e77-8839-0b593e2dcc7e	05fe226f-3069-4057-9817-7fc88069c9c5	c965fa2d-0ebd-440c-86ce-bab64e06553a
a4290ef1-92cf-4ab1-bb23-68fb3f5ccf8a	05fe226f-3069-4057-9817-7fc88069c9c5	868435dd-ab2f-48d0-8fc8-97b29a652c0c
f2d533be-f101-48c1-a962-c1ef280af200	05fe226f-3069-4057-9817-7fc88069c9c5	c8fec09c-b992-463f-97fb-106c29d889bc
21b4f8f6-c5a4-4610-b1c5-2d553958f40f	05fe226f-3069-4057-9817-7fc88069c9c5	298d4cb0-b557-4ec9-9a50-0a3415affaea
dc66583c-1597-4825-b60f-ded4f83e6a59	05fe226f-3069-4057-9817-7fc88069c9c5	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
432151eb-0f4b-45d7-aaba-4889558e9ba6	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
e877e589-1e96-47bf-a213-5ed73a142415	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
6a916ef2-4139-42c1-9a3f-3ff014d88d2e	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	3635d565-2a74-447e-829b-b7e334ef194e
d724cd9a-4f8e-4358-9671-ae25d0b3b1e1	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	556e545d-5b80-483d-9b7d-a822172e4a7b
bbb81e80-df3c-4adb-9230-832ad9452ee9	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	8b764a87-01f9-4624-9f9c-2c8317269799
5d50497b-b839-45e7-bf33-c9b8482964e0	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	04131970-6b8c-41fa-a21b-57f1b1bbef21
0760ca97-9fed-4d68-9fec-d280f039c0f0	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	e904973e-dec8-405b-b085-ad3090267a7a
82d92abd-43e9-407a-b454-415c826fc61c	1f8b02b9-4f45-4e52-8e18-b1de54821ebc	8a245a89-7254-42d9-b8fd-2eac410a5585
ad857bcc-1819-4987-be92-c3c3e0068c86	33f508b4-4cca-4b0b-9f86-aeffeb83455a	68a35597-81f3-435d-935f-f89ecd6add03
d59583ed-bd09-41b3-a34c-2410395a325d	33f508b4-4cca-4b0b-9f86-aeffeb83455a	bb69df93-68c5-4063-a5fd-74ab02d5ba84
0a180693-66d3-4e3c-b680-1eb4717a564c	33f508b4-4cca-4b0b-9f86-aeffeb83455a	b0b9724c-158c-4487-b15c-cc77674bde0a
779cca0d-d9b6-4943-aa1d-1f0cbb5f5f9d	33f508b4-4cca-4b0b-9f86-aeffeb83455a	63c26fae-f8d7-4507-8433-ffe1f59614e1
9b59a1e5-a721-459e-8bc6-24f1e0c2cff3	33f508b4-4cca-4b0b-9f86-aeffeb83455a	760e0210-eaf2-4bb5-af81-985e4d149200
31b59fa3-fec2-4c93-a387-520a360d8fba	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	02dbd7ca-f388-43fd-9548-173a35837682
a96ba30e-59e9-4388-a2a8-12c4be6e0ae5	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db
bc80e265-ec86-4b43-af08-a70a04905675	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	261ef8d9-eeae-44f0-8c52-57315abc0007
85912f12-6595-431d-aab1-f68330b87c02	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	443894b2-d27a-481b-b1db-dd991498fc5e
9aee56a3-32e9-4031-b6e2-ef06d1e45301	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	82c07f83-9ab1-4097-ad30-36e7d81d1340
961ff17d-787a-4754-8843-edd20ea189e1	a18ed0b1-8c4d-4c17-ae98-20196ee8e837	9a6c3789-1e92-4775-ab6b-055bf8165c5d
700e96a5-cbc5-4e4f-b730-39243a41bca6	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	03999e08-b875-4f63-bf97-c220705ba672
d8d0396a-9a7e-4eb9-8493-1c8b1e5681f2	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	00452b01-da8a-4380-8759-877c80f392dd
bc4b751b-d6f8-4ef9-ab99-a20ef09b32d3	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	f4433601-a483-44d6-8c98-898ff69193d1
810e7c39-f57e-4622-a99f-012390f12171	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	28eac750-7a50-439f-bf5d-e07bbb4f496a
9c1ba0e1-49c8-493f-8e3b-36ad9463f9eb	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
278c2513-8b8e-4925-b2b1-633aaae3bc61	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	33fe9d35-2f39-4ca6-bc05-bfad2402ca6d
16e9d36c-ddae-4506-ab2c-6c6f512e7144	b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
df74b4bc-11e3-418d-ba3c-dcc9a829b774	3ed63113-7fa7-4da7-8647-3120dd964e3b	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
18833095-191a-43bc-9b39-7fac88f88bd5	3ed63113-7fa7-4da7-8647-3120dd964e3b	6eb08218-0a94-451d-bf6d-b3e5c2967b09
1d91bd1b-1ef9-4c20-b183-4e24ca051617	3ed63113-7fa7-4da7-8647-3120dd964e3b	38670ebf-9e68-40d6-845a-3061a47cafe6
ae0d702f-cec2-46ee-b960-4bcd36f9c9a7	3ed63113-7fa7-4da7-8647-3120dd964e3b	868435dd-ab2f-48d0-8fc8-97b29a652c0c
1e1d75ee-f502-4695-b8eb-a068cf6197ed	3ed63113-7fa7-4da7-8647-3120dd964e3b	cbf0a0b9-a6ab-47ef-aae1-063a82cc006e
f69e7eca-a74c-40b7-bf23-69295bcceaae	3ed63113-7fa7-4da7-8647-3120dd964e3b	e39910ae-2305-4c95-b7cf-a12676e2c464
413a2365-9323-40c4-b491-f75a6c26815a	3ed63113-7fa7-4da7-8647-3120dd964e3b	6f474582-2930-4901-9d09-efdf4679f879
68e6fc8a-df24-4e15-bcd4-32d5b39c3296	4a1029f2-a550-431b-a12b-99f20357d31a	b52ffb50-0d1e-4da5-8bf8-2ce37912d821
c9dba461-3016-4191-9d75-8d4b80d4d2dc	4a1029f2-a550-431b-a12b-99f20357d31a	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
95de839d-3be0-4170-a6c0-a6d14b0e4c1c	4a1029f2-a550-431b-a12b-99f20357d31a	631d799c-e4cc-4f12-b74e-973dabb21075
5ed418a1-6096-4d09-9be9-cb307bb9fe75	4a1029f2-a550-431b-a12b-99f20357d31a	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
5153ee48-767f-4b63-a29b-256a71b795ce	4a1029f2-a550-431b-a12b-99f20357d31a	688f2b9a-9285-46e9-9b78-d60977fd9360
342c563f-d3fa-4cad-98e2-58b78a1638fe	4a1029f2-a550-431b-a12b-99f20357d31a	71d05faf-8913-4073-a401-7ee58d09559c
53acea05-a29f-4592-a4a0-6ccae38d5a1e	4a1029f2-a550-431b-a12b-99f20357d31a	8a245a89-7254-42d9-b8fd-2eac410a5585
16ad32e5-7773-41d5-bdb1-fe486209fdd6	81141995-b214-449a-a6b3-d1d268daf34b	b911af8e-191c-476d-bbf6-6848e12ca6cb
4d8db761-b7fa-4d78-89e0-b1e3ee2d19df	81141995-b214-449a-a6b3-d1d268daf34b	1870d9f2-9162-4fbd-bf50-43698022b8da
9ad88fb8-321a-45eb-9a21-9cc1c6404d57	81141995-b214-449a-a6b3-d1d268daf34b	ae3b7895-feda-406e-a6b8-61a8a20dcd3a
976f0cfa-165e-490c-963f-c3faa45b7c39	81141995-b214-449a-a6b3-d1d268daf34b	c9647eeb-2d2f-49ff-ac2f-7ec2668715b3
76bc0b53-6921-4c65-b062-7be566210dcf	81141995-b214-449a-a6b3-d1d268daf34b	cfdcca34-7fd5-4838-9370-21276899c178
d6fda458-8cbc-42d4-a765-0a333e9f5d12	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	f9472967-962e-4b39-b318-16a771eba42d
cd740017-e753-4fdf-b009-90440bc1c99f	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db
525e90ec-9f39-4e74-895b-9147893ef741	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
39412972-0abc-46a7-8dee-d6b78e8e45dd	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	2f41465a-30ef-4518-9af9-564e610a295c
9c7372e3-c337-42fe-8990-6ede43f9f1f7	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	2894cadd-aa58-44ef-a09a-f865f2937bf3
9b60939d-417e-44aa-ba62-f75f4132bf16	cc78fde5-9441-41c6-9ce4-b35ed3e1886e	e20b945b-e86b-46ac-8513-ebbfaa9a4560
d933208d-dbc0-4a17-ac60-f8c18ada632b	dd20f0bd-ce98-4594-b1c4-314ece9be67b	d85ccb92-9175-4029-827c-2ccade6984e3
077581d6-b265-4121-a99c-ac34e09b0fc9	dd20f0bd-ce98-4594-b1c4-314ece9be67b	1dbbe31c-27f2-47c4-a200-2346d84314b7
f4d1496c-3810-4cb6-b24c-f5b02b1ca6d8	dd20f0bd-ce98-4594-b1c4-314ece9be67b	bd7c933d-b38a-4acf-8053-496d42630b61
25418d83-6a20-41de-9ace-addc90cf1c7d	dd20f0bd-ce98-4594-b1c4-314ece9be67b	1e361eae-eb51-4d32-ab0c-cd453bdd2734
6dabd1a0-c5a3-4386-bac3-4a8255f1648a	dd20f0bd-ce98-4594-b1c4-314ece9be67b	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
a68ab005-141b-4815-b049-97ccf2d2bb32	dd20f0bd-ce98-4594-b1c4-314ece9be67b	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
8da599b3-6061-4429-a2d7-5cc305675555	dd20f0bd-ce98-4594-b1c4-314ece9be67b	00cdb44d-3200-46f0-8757-42e78e569a42
e2dacdb0-2325-477d-a853-e7e14f95c6ad	d8bde31d-1759-46d2-87eb-10909e198af5	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
aa7834b7-cc66-43e7-8946-f1cb13b4a5a8	d8bde31d-1759-46d2-87eb-10909e198af5	40c13606-829a-4d32-9a2f-634465feb1b3
385c6efa-c16f-4c28-a949-e18d87491af3	d8bde31d-1759-46d2-87eb-10909e198af5	c965fa2d-0ebd-440c-86ce-bab64e06553a
81bbad1c-9818-4c7c-8db6-7865909d6b6d	d8bde31d-1759-46d2-87eb-10909e198af5	868435dd-ab2f-48d0-8fc8-97b29a652c0c
6d983de9-097f-443d-908a-6c3f288a23d0	d8bde31d-1759-46d2-87eb-10909e198af5	ca965a27-d390-453b-a3cc-69e4ccc791e3
1df5cd2c-9108-4e0b-9616-24337a09ece2	d8bde31d-1759-46d2-87eb-10909e198af5	298d4cb0-b557-4ec9-9a50-0a3415affaea
1b3fad66-14d0-4659-91ba-665e74c30b0c	d8bde31d-1759-46d2-87eb-10909e198af5	4974c20a-94d5-4a52-983f-4abba57a225b
9815c76e-68ff-432d-8807-de184c06ec37	1664c152-0415-4df8-b70e-3612f4f70ccc	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
94e62f2b-2078-4ba7-aa20-60896ea6d83d	1664c152-0415-4df8-b70e-3612f4f70ccc	3635d565-2a74-447e-829b-b7e334ef194e
0b2879f8-c845-481f-a050-4e1aaad69ab8	1664c152-0415-4df8-b70e-3612f4f70ccc	ddfa5493-8205-46d9-a29c-4934739cb1b4
fa1c1736-9c97-4974-a424-9e8b36975727	1664c152-0415-4df8-b70e-3612f4f70ccc	cdce8b68-4fc8-4d39-b39c-3485307475cb
d2694949-a811-4b79-a6c5-915c6148089d	1664c152-0415-4df8-b70e-3612f4f70ccc	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
49c294d5-2313-482e-be5b-f645e9d32b0d	1664c152-0415-4df8-b70e-3612f4f70ccc	71d05faf-8913-4073-a401-7ee58d09559c
686ea389-398f-4b6b-83ef-04dc033a5f1d	1664c152-0415-4df8-b70e-3612f4f70ccc	6e8aa530-4d74-4e8c-babd-274b66ba6b69
900d47a0-af42-433a-8700-c016a37ca32c	ba5700eb-90c5-44a3-bc6a-69851668ddb8	68a35597-81f3-435d-935f-f89ecd6add03
25df0b1f-964f-47c0-b5fc-0f1bd2146a52	ba5700eb-90c5-44a3-bc6a-69851668ddb8	bb69df93-68c5-4063-a5fd-74ab02d5ba84
249ab881-fec7-4b5b-8f74-ac5c178d3ae4	ba5700eb-90c5-44a3-bc6a-69851668ddb8	0261cf0e-50e4-4252-a269-ab1d16187042
4834ebe1-f5e7-4411-9e60-6678e93eebb5	ba5700eb-90c5-44a3-bc6a-69851668ddb8	c9647eeb-2d2f-49ff-ac2f-7ec2668715b3
33cc1f0d-bf14-485d-9bdd-0ca58d8daa13	ba5700eb-90c5-44a3-bc6a-69851668ddb8	ce19f108-27f8-4df8-9866-8675d9c623f0
51226b60-e24c-4aa6-8eb5-ddc9c0c820ee	e367779b-cb54-4779-80b5-d55c7feeef2a	02dbd7ca-f388-43fd-9548-173a35837682
866d1793-b829-4759-afd4-68add4c372f6	e367779b-cb54-4779-80b5-d55c7feeef2a	e34c8419-09e5-4302-a5b4-60b8830419f2
d8431021-12ee-4955-b062-fdd878921514	e367779b-cb54-4779-80b5-d55c7feeef2a	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
0c235069-38ab-47a9-88cb-16ec93ddb608	e367779b-cb54-4779-80b5-d55c7feeef2a	2f41465a-30ef-4518-9af9-564e610a295c
85beffc0-2bc0-4516-b499-d083a358f1d0	e367779b-cb54-4779-80b5-d55c7feeef2a	82c07f83-9ab1-4097-ad30-36e7d81d1340
e7a56637-753f-4498-a8d5-517a64061ebb	e367779b-cb54-4779-80b5-d55c7feeef2a	966a3bcc-d18c-484e-b60e-37cdd682cb84
eecd564d-b968-4e1c-b828-9843c58007c0	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	33c555fb-64bd-440d-9362-d420ce224c1a
13d93840-f994-440f-8914-7f60edb34e08	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	26982feb-eba9-4b04-89ea-98535fa61c3d
8215dd72-b13b-4020-8218-c5d4637d9ca4	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	f4433601-a483-44d6-8c98-898ff69193d1
b3a32526-40fd-4f3a-a2ed-3e2eeb489e59	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	1e361eae-eb51-4d32-ab0c-cd453bdd2734
df1f90a3-567f-4eb9-be03-16a047fb9025	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
20bfc57e-1e47-4cfd-b112-f5322c135bca	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	00b08d53-72ae-4330-934f-2f5290bb24fc
5e3a9a96-e5bc-41c6-a52b-a0426638d746	67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
29372064-a1f4-4c16-8efe-7ce6789fef13	76d8ef1e-3389-431d-a6f2-4d9a260fc101	33c555fb-64bd-440d-9362-d420ce224c1a
ed2ba56a-5d07-488f-b25a-12b5756c5726	76d8ef1e-3389-431d-a6f2-4d9a260fc101	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
b434bbdf-84b8-4b3c-99a2-8ab5a8cf61f8	76d8ef1e-3389-431d-a6f2-4d9a260fc101	6eb08218-0a94-451d-bf6d-b3e5c2967b09
d01eada4-c048-47e4-8f34-61de0a525740	76d8ef1e-3389-431d-a6f2-4d9a260fc101	f63199f1-343b-4127-a6ee-1eb0e65b5232
edd0e8df-9b09-43ea-b382-0f0fc9f75cfc	76d8ef1e-3389-431d-a6f2-4d9a260fc101	868435dd-ab2f-48d0-8fc8-97b29a652c0c
e1f4e094-af4b-4510-9408-d0a8a630a3f6	76d8ef1e-3389-431d-a6f2-4d9a260fc101	011875b1-f030-4ee5-a103-7a5900a6b8b6
f3b05560-9261-487e-9774-d0a71efca81f	76d8ef1e-3389-431d-a6f2-4d9a260fc101	298d4cb0-b557-4ec9-9a50-0a3415affaea
032acad8-1a07-44c8-b48b-890e195c9991	76d8ef1e-3389-431d-a6f2-4d9a260fc101	133df2a4-0505-4aed-bdf5-b2dd5e21c7c9
1142606f-5bb5-4382-b96f-2e5fd51141e9	453b5672-2876-48ea-b0a8-c4a4b54e0db5	8c96bcec-e94f-4470-9096-3b034db6ef57
5201b74b-9223-46e0-8824-f065f69763e7	453b5672-2876-48ea-b0a8-c4a4b54e0db5	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
44cdca25-56b1-4cdf-8998-cca95c1c47ff	453b5672-2876-48ea-b0a8-c4a4b54e0db5	556e545d-5b80-483d-9b7d-a822172e4a7b
2967f88c-7e43-4326-9a16-58d100a301fd	453b5672-2876-48ea-b0a8-c4a4b54e0db5	cdce8b68-4fc8-4d39-b39c-3485307475cb
f9ece8e2-1e9f-47fc-8685-4452d8eaaf99	453b5672-2876-48ea-b0a8-c4a4b54e0db5	02df8cb1-f817-4182-a8da-24f24737babc
ae8b3a83-881f-4bf9-8b32-03cd18bcf342	453b5672-2876-48ea-b0a8-c4a4b54e0db5	71d05faf-8913-4073-a401-7ee58d09559c
41934930-967d-4932-8200-a00ccd5cb385	453b5672-2876-48ea-b0a8-c4a4b54e0db5	34c2c6e6-a3d9-4d0f-97f9-954087748564
493090b2-863e-4519-bbc1-c0ede0d9309c	d41d423c-71a9-4087-9356-a45ef5ad2889	68a35597-81f3-435d-935f-f89ecd6add03
27d4b0e6-8509-49f0-a39b-101371258834	d41d423c-71a9-4087-9356-a45ef5ad2889	bb69df93-68c5-4063-a5fd-74ab02d5ba84
dd7e6e6c-8bdb-4017-9f09-fc7a10fa038d	d41d423c-71a9-4087-9356-a45ef5ad2889	0261cf0e-50e4-4252-a269-ab1d16187042
3d440021-5335-4547-81d0-8d3cda163041	d41d423c-71a9-4087-9356-a45ef5ad2889	63c26fae-f8d7-4507-8433-ffe1f59614e1
494610d7-b6ab-4f05-95ec-617e23fe8b42	d41d423c-71a9-4087-9356-a45ef5ad2889	cfdcca34-7fd5-4838-9370-21276899c178
db1aa167-1365-44b2-8c24-696d36523194	e64f8312-6a9d-4fab-803d-ef398a90a0a1	f9472967-962e-4b39-b318-16a771eba42d
2629ae42-511c-4e1b-9d8b-7f348703296f	e64f8312-6a9d-4fab-803d-ef398a90a0a1	e34c8419-09e5-4302-a5b4-60b8830419f2
52e127e6-e38b-4470-9c96-a0ce3149616b	e64f8312-6a9d-4fab-803d-ef398a90a0a1	8c3a2086-969e-426d-91db-306fcfaec506
a6431d92-6349-4ed7-85e7-0732069c947b	e64f8312-6a9d-4fab-803d-ef398a90a0a1	443894b2-d27a-481b-b1db-dd991498fc5e
05cd4874-385e-4a19-8a9a-c97fb3335b59	e64f8312-6a9d-4fab-803d-ef398a90a0a1	87ea4e24-4b45-4e2a-b731-7a9738806c64
e1cc4a67-9002-418c-913e-250b6af8eca7	e64f8312-6a9d-4fab-803d-ef398a90a0a1	9a6c3789-1e92-4775-ab6b-055bf8165c5d
9708a57a-06d7-4ef7-9969-9f125f05172b	b52aa81a-949e-46c8-b3bb-1333a56a73da	03999e08-b875-4f63-bf97-c220705ba672
1673e3a5-91a0-4722-be71-5b08c347d4e5	b52aa81a-949e-46c8-b3bb-1333a56a73da	79325b26-f52e-48bf-9185-b30de43d64d3
46f08eae-e53a-48e4-a2e0-6c18ff2be6c1	b52aa81a-949e-46c8-b3bb-1333a56a73da	fea03c2d-23d1-47d3-ae77-bcea70ea53fb
0aa04fa2-2c5c-43cb-92e4-e70b811d36af	b52aa81a-949e-46c8-b3bb-1333a56a73da	1e361eae-eb51-4d32-ab0c-cd453bdd2734
7a92aa82-4fa5-402f-abaf-5e35f02bd774	b52aa81a-949e-46c8-b3bb-1333a56a73da	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
efd5fa45-1c20-4adf-842d-f52b1c2df06d	b52aa81a-949e-46c8-b3bb-1333a56a73da	46d123ae-7693-47a9-9d39-d1316173a1e9
8c269ec7-6d34-4a8e-bc0c-f2760db1260b	b52aa81a-949e-46c8-b3bb-1333a56a73da	00cdb44d-3200-46f0-8757-42e78e569a42
8622682a-a078-48be-8c54-6d7e260d27ba	24570a22-d153-461a-9b5e-d5e3919297e5	553157a9-f226-49fa-af48-e508f1395f83
a24fd992-8dfd-4e64-a0fc-4fc405a4fd26	24570a22-d153-461a-9b5e-d5e3919297e5	be3bbe21-0a5a-4fef-aff3-0e3d5426f984
012f1688-a33f-4016-bf6a-d55ba063058e	24570a22-d153-461a-9b5e-d5e3919297e5	c83b9a45-346e-41f7-ac61-39811253a2a4
83743c11-75d1-49d9-b84f-072f1d95ac01	24570a22-d153-461a-9b5e-d5e3919297e5	8e5aedfc-077e-4c70-847c-d06a94840fa4
fbb55b43-ebf5-48b0-9f7b-8494c4ded58f	24570a22-d153-461a-9b5e-d5e3919297e5	011875b1-f030-4ee5-a103-7a5900a6b8b6
d4563534-814c-4d3c-91a8-2f779b6360ae	24570a22-d153-461a-9b5e-d5e3919297e5	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
dc825cf8-315c-41ee-92d7-877b45840a72	24570a22-d153-461a-9b5e-d5e3919297e5	4974c20a-94d5-4a52-983f-4abba57a225b
c2c8889d-5460-437c-81e3-c44ae5dd4aad	01cea9bd-433f-46d9-b678-e93cee216963	5b7f965f-4d06-47aa-bf3d-0e66b47709af
a65c0b52-03a7-4296-aaa9-93a6bbed5a4c	01cea9bd-433f-46d9-b678-e93cee216963	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
6e0aaf26-f52b-4e40-8a5c-cd3771ca7d96	01cea9bd-433f-46d9-b678-e93cee216963	556e545d-5b80-483d-9b7d-a822172e4a7b
5ffdd794-9e9a-4c32-b8f8-4264c84bb33f	01cea9bd-433f-46d9-b678-e93cee216963	cdce8b68-4fc8-4d39-b39c-3485307475cb
6fbf3876-8ae7-4512-8167-02538a76648e	01cea9bd-433f-46d9-b678-e93cee216963	04131970-6b8c-41fa-a21b-57f1b1bbef21
516ac719-504a-44fa-b4d5-952184003f50	01cea9bd-433f-46d9-b678-e93cee216963	e904973e-dec8-405b-b085-ad3090267a7a
127ede36-e864-4921-886d-45574cf825ae	01cea9bd-433f-46d9-b678-e93cee216963	b8590cf6-ac78-40f7-b434-dacc456bdd2f
ff1286bc-08a2-41be-86ba-de31cb3cc494	dae64f11-fc7c-4799-8df8-ad8b6bd0684d	67ae3aea-4ab7-402b-9c64-9772d924bf69
bbe71a2e-def5-4690-9048-aefdb35c1033	dae64f11-fc7c-4799-8df8-ad8b6bd0684d	decba44a-23dc-4d6b-b754-4799e45488d6
549953d4-b915-45a6-8a41-ee81468a18cd	dae64f11-fc7c-4799-8df8-ad8b6bd0684d	0261cf0e-50e4-4252-a269-ab1d16187042
beb56c72-3519-4d68-b9f9-6bf87a64a294	dae64f11-fc7c-4799-8df8-ad8b6bd0684d	c9647eeb-2d2f-49ff-ac2f-7ec2668715b3
0976cda0-83b7-4c0e-9b5f-8aa29e58ac2c	dae64f11-fc7c-4799-8df8-ad8b6bd0684d	64c02f11-0204-4a11-be07-68ef5b0f36f1
f1411d92-5c7c-4bea-be85-1e3d258aa6be	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	eb5ae92f-804a-4e32-991d-5fc2cedc10ad
8edeb650-a934-448f-b524-c7c0ee758b06	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	1780c740-f601-4108-9203-fd5a70a9d180
4236bccc-8865-44d5-ae57-7e5a54333140	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	d497faaf-de8a-48c5-9e50-89d65255dac8
42179828-6249-49db-8f3a-270aa1171835	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	aad04f4c-db14-4ef4-9998-686fa9002e11
befe4052-84cc-4f3b-9b29-ebfc41ef5824	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	87ea4e24-4b45-4e2a-b731-7a9738806c64
cd488633-c85b-412d-8d34-f356e558f596	5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	a8ac4c5b-f187-46de-ad0e-4e806587c0ea
76b6c930-07c0-4691-9616-4528dcdc330f	7a385d2a-ac10-46b4-b707-844fb465a1f2	d85ccb92-9175-4029-827c-2ccade6984e3
9eaf3f7a-90e6-4423-862b-1466fcbd194a	7a385d2a-ac10-46b4-b707-844fb465a1f2	26982feb-eba9-4b04-89ea-98535fa61c3d
b3b9f1f8-03ae-43bb-8c8f-482850a2bb57	7a385d2a-ac10-46b4-b707-844fb465a1f2	f4433601-a483-44d6-8c98-898ff69193d1
d0be8a7b-ba38-4f8d-b8af-c5f3c8361eba	7a385d2a-ac10-46b4-b707-844fb465a1f2	1e361eae-eb51-4d32-ab0c-cd453bdd2734
f2db1253-9f32-49aa-b775-e3c8971252c5	7a385d2a-ac10-46b4-b707-844fb465a1f2	8edc4a35-a3f2-44a7-bec3-bf08faed7a5f
e7bf5b41-9223-4565-9ef1-fcdf6ffa234c	7a385d2a-ac10-46b4-b707-844fb465a1f2	46d123ae-7693-47a9-9d39-d1316173a1e9
27d60100-f890-438a-9627-bc12b56208fd	7a385d2a-ac10-46b4-b707-844fb465a1f2	11063ddf-508e-4281-8dc5-ac4bd1563d0c
8b8da64e-eb4b-44fe-b8a7-e7bab7b9dfd0	9564c82d-0512-455a-b741-e73bf675d1ff	2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c
8e73f39f-22c0-46b8-8350-f1d0046cddd7	9564c82d-0512-455a-b741-e73bf675d1ff	40c13606-829a-4d32-9a2f-634465feb1b3
c663c82d-7638-4b3e-9eb7-bac9f7954246	9564c82d-0512-455a-b741-e73bf675d1ff	f63199f1-343b-4127-a6ee-1eb0e65b5232
6b401ab0-ebd7-4d31-906e-56afffe122e8	9564c82d-0512-455a-b741-e73bf675d1ff	6ee66dc9-a0db-4607-b2cf-edc741e28833
5d1f4b25-d547-4a8f-8af2-3237c5f375c3	9564c82d-0512-455a-b741-e73bf675d1ff	011875b1-f030-4ee5-a103-7a5900a6b8b6
7a67c139-6c5f-43e0-a903-add5a1174730	9564c82d-0512-455a-b741-e73bf675d1ff	e39910ae-2305-4c95-b7cf-a12676e2c464
a38dcf1b-bcd9-479e-a513-0250f96aa86f	9564c82d-0512-455a-b741-e73bf675d1ff	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
c5393063-42fe-4d13-98dc-0f9c40dd938c	ec06a45b-4c17-4636-af76-0eb6b4c52f31	e9befb8e-19e1-4a7b-a030-2fd2ca1537a3
80a10037-867b-4a05-bdfd-6c004264f4f3	ec06a45b-4c17-4636-af76-0eb6b4c52f31	2e537ef7-cbab-42d4-8fd8-eb407ad7f89d
bda2a752-db78-4417-8c9d-75604be9f700	ec06a45b-4c17-4636-af76-0eb6b4c52f31	3635d565-2a74-447e-829b-b7e334ef194e
ac01007b-ab44-4093-be1e-ca827449b7b3	ec06a45b-4c17-4636-af76-0eb6b4c52f31	ddfa5493-8205-46d9-a29c-4934739cb1b4
c7b4a271-5a29-41aa-b24f-2a89a5cef007	ec06a45b-4c17-4636-af76-0eb6b4c52f31	cdce8b68-4fc8-4d39-b39c-3485307475cb
ca43eb8d-4abe-4283-8753-127d95377b95	ec06a45b-4c17-4636-af76-0eb6b4c52f31	6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a
9a9382d9-df70-4a90-b5c5-97224d2b6a46	ec06a45b-4c17-4636-af76-0eb6b4c52f31	6c0eeba4-a22a-4e64-8058-ab328711b8b0
46a09fa7-f907-4825-95ad-db9ac32407b7	ec06a45b-4c17-4636-af76-0eb6b4c52f31	6e8aa530-4d74-4e8c-babd-274b66ba6b69
180e0676-839f-483c-b5da-b1bc6efb10e1	e336aedf-0629-43c3-bea5-248bd3e97924	a2d3ea49-f184-41f2-a6b3-26b2fea2338a
67fd4c37-312c-4715-b4c3-1f9d607231a0	e336aedf-0629-43c3-bea5-248bd3e97924	84885e6f-7c44-4922-96a5-5f19ce145f96
6e1c7c8f-b434-4b27-b640-bc019dac76bb	e336aedf-0629-43c3-bea5-248bd3e97924	7fee0783-f025-4da1-8cec-fbcd18b107b0
195f6fa2-5544-4637-b636-fe3d2083481e	e336aedf-0629-43c3-bea5-248bd3e97924	63c26fae-f8d7-4507-8433-ffe1f59614e1
3e8ce873-88f8-4844-af9b-7ead2196a0d5	e336aedf-0629-43c3-bea5-248bd3e97924	64c02f11-0204-4a11-be07-68ef5b0f36f1
5b601b23-6d69-42c5-bd08-655355a24dd1	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	eb5ae92f-804a-4e32-991d-5fc2cedc10ad
33ef8bb0-e3b3-4946-816d-b8e79b7d90de	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	ecfedda8-87d0-4ec9-8d8c-fa11fc07e4db
5ba23fee-57dc-46c0-a1c6-e3a15355a83c	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	b81d8b51-eb64-4c2c-b5ce-19c90ad4e5ed
554e9d57-6a37-49b3-8383-93475698692f	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	443894b2-d27a-481b-b1db-dd991498fc5e
62b6da00-9971-4249-96a3-d1d9e6e3bf05	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	ea88794b-f71a-44aa-8fa5-6bc9556a2afa
c498d750-b374-4778-9d2e-4a4cf304b152	c25b6e2d-0b20-482f-9f50-44cfc5b2e779	5bd7f24d-e0d3-447e-9942-58a64046ac83
aa7ca2e7-e6ec-4612-b58b-20b41b7fb25b	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	d85ccb92-9175-4029-827c-2ccade6984e3
1df757e4-8d3a-4c2e-89b0-6ee098edaad5	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	00452b01-da8a-4380-8759-877c80f392dd
a3a8ee02-6412-488b-8137-b851ef28d675	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	ff0653fc-e130-4ea9-b889-96f4bea63b62
2c4306c7-7d1a-4e78-b2b0-060732b7d875	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	7dbd9b8d-1c22-4a38-a75e-f23e90a4d393
1aa3bb1d-2320-4c49-b569-1da72af711f6	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	2ba12f1d-4c0b-4e79-be7b-77b8a9f8ab2e
69969382-fe34-477c-982b-45d9c81dabcb	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	1c8d1edf-ae25-4d10-8b63-3b60fbb9e411
55123102-b7f8-47bd-9159-68bc310a98b8	49eb8dfb-537b-4e99-a043-24c5ef0aaae3	95c972aa-82e4-4da5-afa0-d2ecfe65d6cb
dd297fb0-7667-409b-b0ab-713f53d6e927	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	d90b6d6e-c36c-46ff-b7ea-3ab7bc9fd030
f2e303da-8791-408c-8341-046ee33a2fdb	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	5cf17261-cfbc-4fbf-aef5-7b3d9eaef478
8029a45e-cc98-406a-8f8e-cb5d90096e6f	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	c965fa2d-0ebd-440c-86ce-bab64e06553a
f17d9c34-5d74-403e-8d47-881e3761aff9	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	6ee66dc9-a0db-4607-b2cf-edc741e28833
4e340ad5-0fe4-442f-8e3b-725a378dff38	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	ca965a27-d390-453b-a3cc-69e4ccc791e3
9ec7ef87-6b82-4a8b-bded-9d426a3d4e6d	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	20a9c879-f4a5-4486-9161-50701b056327
2b1ca57a-0e0b-434e-9bdb-7ee89df95e21	3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc
6d9dc240-e5bd-4bf9-9b2d-dd39fa486d2f	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	8c96bcec-e94f-4470-9096-3b034db6ef57
b51f8507-36eb-4646-9921-a1474123756c	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	7e76483f-4b12-4f18-b5bc-cff26c2e81ee
d3feeb4d-83d1-43ba-953b-873e3d144b1a	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	c7603d88-fad0-487b-9eb7-c3c31a5ca59d
4eb84785-e18e-4fc8-9f68-d9c0704c1e4a	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	8b764a87-01f9-4624-9f9c-2c8317269799
af9e5252-1003-4146-b4a3-8a7451fab571	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	688f2b9a-9285-46e9-9b78-d60977fd9360
10cf8c77-e584-4d1d-ac7f-46b1253f56ca	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	b1ae56e1-c683-49c2-95b2-b96f71fc435c
fcbc81b8-200e-4423-b07d-0b15225cf418	3820ffa8-9cb5-407f-a8ba-7fca7ea49407	34c2c6e6-a3d9-4d0f-97f9-954087748564
d3e9361a-272e-49d0-aabc-d80d8d38f058	6dfec320-478a-4240-a158-f501ee486b47	a2d3ea49-f184-41f2-a6b3-26b2fea2338a
ce303c11-559e-4680-b244-ccfba3a1a02f	6dfec320-478a-4240-a158-f501ee486b47	84885e6f-7c44-4922-96a5-5f19ce145f96
74328ad4-f231-4495-9e86-0948aaaf2a22	6dfec320-478a-4240-a158-f501ee486b47	0261cf0e-50e4-4252-a269-ab1d16187042
6ab997ae-665c-40ea-92ca-052b63302b92	6dfec320-478a-4240-a158-f501ee486b47	ab145af8-a7f3-460d-96c2-0955ad99420e
9b376818-6051-4cd7-b0c7-a04e74b0160f	6dfec320-478a-4240-a158-f501ee486b47	cfdcca34-7fd5-4838-9370-21276899c178
2f03e383-5951-43dd-a057-82e9b39124f4	f16c27ec-34ab-4540-a8e7-3025f979abeb	70cf216b-709d-45fd-8486-b10b3e5223d9
b85f0615-5e97-4dc1-886c-67e229d7a5ae	f16c27ec-34ab-4540-a8e7-3025f979abeb	84370b0b-27aa-42df-b7d4-5ae28d9acb98
2f50a9d1-d371-4e68-911b-0b5bb00a4ace	f16c27ec-34ab-4540-a8e7-3025f979abeb	8c3a2086-969e-426d-91db-306fcfaec506
e4922a98-854a-4b27-a833-5e2949f80a4a	f16c27ec-34ab-4540-a8e7-3025f979abeb	aad04f4c-db14-4ef4-9998-686fa9002e11
04e80678-8f70-46b8-99c9-2b3f89b1f52e	f16c27ec-34ab-4540-a8e7-3025f979abeb	4a2063fe-517e-4e6d-b888-337a6a0faf48
fc6ae580-440f-42be-a46d-4d75b9e3a9d4	f16c27ec-34ab-4540-a8e7-3025f979abeb	e20b945b-e86b-46ac-8513-ebbfaa9a4560
0fb00fc3-62d3-483f-a95e-cc2b948fde38	fb956d59-0c46-4d59-9263-be3f713a25cf	1cf894cd-ae1a-4232-b2b6-34c0f7b7b8d9
141f5313-c820-46f3-a1c3-915c15da9c5d	fb956d59-0c46-4d59-9263-be3f713a25cf	26982feb-eba9-4b04-89ea-98535fa61c3d
0d2c1b2d-cb4a-408d-9596-31d4c96dade4	fb956d59-0c46-4d59-9263-be3f713a25cf	bd7c933d-b38a-4acf-8053-496d42630b61
c712e11e-d91c-417c-ba8f-2bc37723eaf9	fb956d59-0c46-4d59-9263-be3f713a25cf	a78e7dbf-eb22-4927-a1ac-a30264a5d1e0
e878f7e7-db09-47cc-9149-61d6596ff493	fb956d59-0c46-4d59-9263-be3f713a25cf	9b87cd0c-ccfc-4599-aaf4-b814aa2e7f10
8f5ebe60-c686-45cc-aa04-4602e28c5dcb	fb956d59-0c46-4d59-9263-be3f713a25cf	46d123ae-7693-47a9-9d39-d1316173a1e9
641c5927-21d9-4486-aad4-b2a789be51ec	fb956d59-0c46-4d59-9263-be3f713a25cf	00cdb44d-3200-46f0-8757-42e78e569a42
4966355a-15e4-46a2-9b79-c6d501232e32	be78ac81-8cad-401c-b26b-7bf81dd59ece	553157a9-f226-49fa-af48-e508f1395f83
21351451-2985-4b33-99ac-9fdaaee20f7a	be78ac81-8cad-401c-b26b-7bf81dd59ece	be3bbe21-0a5a-4fef-aff3-0e3d5426f984
28769ac7-e3cf-4b6c-bc2c-c013fc3d84cd	be78ac81-8cad-401c-b26b-7bf81dd59ece	c83b9a45-346e-41f7-ac61-39811253a2a4
39106fda-032b-422b-9462-3fc29b433fc9	be78ac81-8cad-401c-b26b-7bf81dd59ece	6b428caa-622b-47c3-824b-3c755683a21c
5573d814-a33a-4eaa-b796-299b6b3ee564	be78ac81-8cad-401c-b26b-7bf81dd59ece	011875b1-f030-4ee5-a103-7a5900a6b8b6
c6c9d343-2055-4484-b78b-7026de6ae778	be78ac81-8cad-401c-b26b-7bf81dd59ece	1869c4c7-abb6-4cbb-8995-fb6a1e46e076
56135b1b-ff5a-471a-9133-dfadc614c06a	be78ac81-8cad-401c-b26b-7bf81dd59ece	4974c20a-94d5-4a52-983f-4abba57a225b
eee8ec6f-1e50-4844-aee9-a3f7e98bc07f	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	5b7f965f-4d06-47aa-bf3d-0e66b47709af
2551f426-f23e-4331-a938-e0af83fb310b	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	18db8227-5ee7-4bc7-a44d-b5cc930f2ae6
f6b2e921-2132-412d-be3f-e3ffa84eb618	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	ddfa5493-8205-46d9-a29c-4934739cb1b4
2bc52f10-ca10-4103-b481-4c53f2d7ea83	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	3c1d5e1d-5d3b-40d4-b1ea-a88b8690b0c2
a9ceece5-40c4-4f3c-addd-5d98273cb27f	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	04131970-6b8c-41fa-a21b-57f1b1bbef21
86e3ec00-d2d8-41ff-b06b-ccbe72cd9763	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	b1ae56e1-c683-49c2-95b2-b96f71fc435c
2c572652-7847-4e8a-b299-8d95c07299da	6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	b8590cf6-ac78-40f7-b434-dacc456bdd2f
e88f8950-2542-4f60-9bbd-62b9ee0f2b44	28e13f7d-16d1-448a-9c84-3f5c471c4695	b911af8e-191c-476d-bbf6-6848e12ca6cb
022def51-79d0-4775-9c18-19ae135c85a2	28e13f7d-16d1-448a-9c84-3f5c471c4695	da95f662-6808-4bb7-a04a-f7a5468cd6bb
eada8f2c-fe54-4a19-affd-4d317cf5f1d3	28e13f7d-16d1-448a-9c84-3f5c471c4695	7fee0783-f025-4da1-8cec-fbcd18b107b0
7587d50c-87f1-4071-b388-12ff34a888d4	28e13f7d-16d1-448a-9c84-3f5c471c4695	ab145af8-a7f3-460d-96c2-0955ad99420e
f1c893bb-6cb7-488b-b212-bf2acbbfcef9	28e13f7d-16d1-448a-9c84-3f5c471c4695	760e0210-eaf2-4bb5-af81-985e4d149200
40b34722-5dcc-422b-a39e-8b6abfc88152	ced115e2-0960-41e7-80f6-aeec1b778247	ce0753c0-bd38-45f1-969f-1d8d3e035a69
887496a2-90f0-4cf0-bb3b-9e77a7102f76	ced115e2-0960-41e7-80f6-aeec1b778247	84370b0b-27aa-42df-b7d4-5ae28d9acb98
d986f889-c9f4-44de-8614-2b86fd67f044	ced115e2-0960-41e7-80f6-aeec1b778247	3c0e478d-ec46-4585-a584-08b67e891b47
ecdf9091-426c-434b-8127-8003afcc7cf5	ced115e2-0960-41e7-80f6-aeec1b778247	16afbb62-78c6-46b9-9ab7-8ebb322cb626
da18becb-d024-4b6b-972b-f1e70fd3cfbd	ced115e2-0960-41e7-80f6-aeec1b778247	4a2063fe-517e-4e6d-b888-337a6a0faf48
a57f8535-b747-4120-8cca-1fdce34bc897	ced115e2-0960-41e7-80f6-aeec1b778247	966a3bcc-d18c-484e-b60e-37cdd682cb84
\.


--
-- Data for Name: user_answer_sub_kuisioner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_answer_sub_kuisioner (id, level, score, "subKuisionerId", "takeKuisionerId") FROM stdin;
7f1d35bf-6040-418b-8de5-fc5b885af86c	\N	\N	22fb61dd-f54d-4bec-bb98-26d90f94d16b	e3da5d0a-06fe-48ca-bd4f-b9fe41459e87
d23c4fe0-0bf0-48a0-848c-97ca29e80643	high	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	a92073af-8017-4f07-98f2-8b02e2e37314
8f2da221-5998-476d-8f35-2bc4cea6b3e0	low	0	47a65933-fe35-41e9-9610-c55805c92b93	a92073af-8017-4f07-98f2-8b02e2e37314
8bb96d8b-cff1-49d9-b5ee-9dda2bcce74a	normal	0	cd191bdd-8fea-4d6a-81b5-380de93cad59	a92073af-8017-4f07-98f2-8b02e2e37314
dec377d7-704e-4a5a-aae3-ae735a3e225e	normal	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	4d58c012-ae63-42a2-a30c-83117c33f129
646da0d0-9aba-49a3-a7cb-a4aa48b9e5ab	high	0	47a65933-fe35-41e9-9610-c55805c92b93	4d58c012-ae63-42a2-a30c-83117c33f129
2e91d06a-fd02-4384-a8d3-1d87e789197b	low	0	cd191bdd-8fea-4d6a-81b5-380de93cad59	4d58c012-ae63-42a2-a30c-83117c33f129
3bd66237-7519-4276-8223-ffcff705e372	low	17	cd191bdd-8fea-4d6a-81b5-380de93cad59	\N
c21e286f-dc01-4730-9ecc-38fe39d94892	normal	2	22fb61dd-f54d-4bec-bb98-26d90f94d16b	db00af37-808f-4b83-bb24-1c8467052fac
6df4440f-a538-40cc-a199-10f8f6757e4b	normal	13	cd191bdd-8fea-4d6a-81b5-380de93cad59	\N
32ef59b3-781f-4608-a9fb-586d9054f4f1	very high	23	744f79d7-2692-422c-9d63-b24cec2f8d6b	db00af37-808f-4b83-bb24-1c8467052fac
96667533-3892-4ad6-b13b-f2550df3905d	very low	9	4964861f-962a-416f-b2a0-6a0c93adea91	db00af37-808f-4b83-bb24-1c8467052fac
bd1e5259-8604-4ed5-aa33-216de4fec553	very high	34	cd191bdd-8fea-4d6a-81b5-380de93cad59	db40c476-c0e7-4c3d-b39a-159797a5d115
d0976528-cb10-4fe9-874e-837482d34a27	normal	7	cd191bdd-8fea-4d6a-81b5-380de93cad59	2530cd77-e805-4689-9099-b605cb73249d
9c796649-76ac-4991-9791-ce310cb528f9	low	8	47a65933-fe35-41e9-9610-c55805c92b93	2530cd77-e805-4689-9099-b605cb73249d
1eea8a1c-47da-4533-b803-8c61608bbe26	very high	26	47a65933-fe35-41e9-9610-c55805c92b93	db40c476-c0e7-4c3d-b39a-159797a5d115
87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4	normal	9	22fb61dd-f54d-4bec-bb98-26d90f94d16b	2530cd77-e805-4689-9099-b605cb73249d
4542865a-e066-4fd2-a431-08a58b6cdda0	very low	6	744f79d7-2692-422c-9d63-b24cec2f8d6b	2530cd77-e805-4689-9099-b605cb73249d
c3b8e252-de8a-4ab2-9bbd-25a78e454d51	very low	7	4964861f-962a-416f-b2a0-6a0c93adea91	2530cd77-e805-4689-9099-b605cb73249d
40568443-059f-47f8-9219-870e40bd310b	high	28	cd191bdd-8fea-4d6a-81b5-380de93cad59	9323f6fd-06c4-465a-877b-019255525458
f2412d01-ddc5-4be5-8d18-a8e96a1f7816	very high	28	47a65933-fe35-41e9-9610-c55805c92b93	9323f6fd-06c4-465a-877b-019255525458
903a7144-d613-4ded-8956-1522e074a8e4	very high	34	cd191bdd-8fea-4d6a-81b5-380de93cad59	03cbe549-0cac-43a1-b35c-de9487250b5f
6ed4d027-b7f6-4cac-b801-9567700a6aab	very high	28	47a65933-fe35-41e9-9610-c55805c92b93	03cbe549-0cac-43a1-b35c-de9487250b5f
44c6bf49-7e68-4f7a-b30a-66571dbec2a9	very high	38	22fb61dd-f54d-4bec-bb98-26d90f94d16b	03cbe549-0cac-43a1-b35c-de9487250b5f
1524e46e-5520-470d-9b6e-a75037ef66ee	high	19	744f79d7-2692-422c-9d63-b24cec2f8d6b	03cbe549-0cac-43a1-b35c-de9487250b5f
eed7b13d-98fe-4d77-bd15-5e82d610719b	high	28	4964861f-962a-416f-b2a0-6a0c93adea91	03cbe549-0cac-43a1-b35c-de9487250b5f
ccb1113a-ca31-4ba7-a80f-3fd0aac77860	normal	0	cd191bdd-8fea-4d6a-81b5-380de93cad59	204727c7-df90-4849-ba43-1197776f6a98
833c6009-fb14-42d5-88cf-4f29084c893c	normal	4	47a65933-fe35-41e9-9610-c55805c92b93	204727c7-df90-4849-ba43-1197776f6a98
a6597e1a-5220-442d-b65a-3560de514b8b	normal	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	204727c7-df90-4849-ba43-1197776f6a98
c7a466e2-edfe-4cde-9e11-e3f733fcfb0c	very low	7	744f79d7-2692-422c-9d63-b24cec2f8d6b	204727c7-df90-4849-ba43-1197776f6a98
387fb046-8e8a-48a9-90b6-0c25f9873f5b	very low	8	4964861f-962a-416f-b2a0-6a0c93adea91	204727c7-df90-4849-ba43-1197776f6a98
561d834c-4bbb-4f6c-bd23-780cf6c1fe14	high	26	cd191bdd-8fea-4d6a-81b5-380de93cad59	41e32868-2a0f-4fbf-bf86-9ed90dc03386
96af165a-58d0-4853-a43f-8a9862660262	very high	28	47a65933-fe35-41e9-9610-c55805c92b93	41e32868-2a0f-4fbf-bf86-9ed90dc03386
e0a47aaf-4e2b-4fb4-aebf-33ad8adc4bd1	very high	30	22fb61dd-f54d-4bec-bb98-26d90f94d16b	41e32868-2a0f-4fbf-bf86-9ed90dc03386
adfdfc1a-98ef-43ae-a79a-e7bebfb1e7f7	high	18	744f79d7-2692-422c-9d63-b24cec2f8d6b	41e32868-2a0f-4fbf-bf86-9ed90dc03386
fd623626-4b1a-4c9f-bad4-76c0b6e7eae9	high	27	4964861f-962a-416f-b2a0-6a0c93adea91	41e32868-2a0f-4fbf-bf86-9ed90dc03386
4dee1009-ef4a-4c0f-bb4a-c59c78bfc2ee	high	30	cd191bdd-8fea-4d6a-81b5-380de93cad59	baafb091-f5f8-4edb-bc7a-b8bd769c4f8c
249e3104-ae0b-48b1-9e82-3337f3734413	very high	32	47a65933-fe35-41e9-9610-c55805c92b93	baafb091-f5f8-4edb-bc7a-b8bd769c4f8c
e2f92da8-3651-440e-b192-8df6fe8d7141	very high	28	22fb61dd-f54d-4bec-bb98-26d90f94d16b	baafb091-f5f8-4edb-bc7a-b8bd769c4f8c
768e25ef-d2dd-4359-9e77-ba152490de39	intermediate	17	744f79d7-2692-422c-9d63-b24cec2f8d6b	baafb091-f5f8-4edb-bc7a-b8bd769c4f8c
b935041c-3478-4012-9441-0ce8edf4c322	high	26	4964861f-962a-416f-b2a0-6a0c93adea91	baafb091-f5f8-4edb-bc7a-b8bd769c4f8c
5d12cde5-07bf-4245-a807-5e64209cd3b8	high	26	cd191bdd-8fea-4d6a-81b5-380de93cad59	966368b0-883b-4103-a9ff-1c65d5081157
3f5060d6-a874-48e0-bbc3-7e2d5f86531f	very high	30	47a65933-fe35-41e9-9610-c55805c92b93	966368b0-883b-4103-a9ff-1c65d5081157
41b131f6-81f6-462f-9f82-7df42d7eac26	very high	28	22fb61dd-f54d-4bec-bb98-26d90f94d16b	966368b0-883b-4103-a9ff-1c65d5081157
071d9d1a-c27c-4f47-af10-4155847c7eff	intermediate	17	744f79d7-2692-422c-9d63-b24cec2f8d6b	966368b0-883b-4103-a9ff-1c65d5081157
859f8423-cf26-444e-9324-d73a4e22cb73	high	24	4964861f-962a-416f-b2a0-6a0c93adea91	966368b0-883b-4103-a9ff-1c65d5081157
fc8ca3e9-684f-41f8-9d52-c447cb1ad118	high	32	cd191bdd-8fea-4d6a-81b5-380de93cad59	db00af37-808f-4b83-bb24-1c8467052fac
d5b30136-c11b-4787-8fe4-ed13002adf7c	very high	32	47a65933-fe35-41e9-9610-c55805c92b93	db00af37-808f-4b83-bb24-1c8467052fac
7741b25b-95e8-486c-865c-6dcf05333eac	high	24	22fb61dd-f54d-4bec-bb98-26d90f94d16b	db40c476-c0e7-4c3d-b39a-159797a5d115
182ed03d-6f09-476b-940d-cf251ea869a2	intermediate	16	744f79d7-2692-422c-9d63-b24cec2f8d6b	db40c476-c0e7-4c3d-b39a-159797a5d115
aa83efd1-4a52-4c24-a6ae-90861d1fa4ca	low	16	4964861f-962a-416f-b2a0-6a0c93adea91	db40c476-c0e7-4c3d-b39a-159797a5d115
4d22cc5b-0094-455f-9f4b-7905d2980884	very high	42	cd191bdd-8fea-4d6a-81b5-380de93cad59	78782c19-f448-4830-acfc-5e80288331de
b03d2be9-5f64-4035-ad28-28f95ffa4e0a	intermediate	12	47a65933-fe35-41e9-9610-c55805c92b93	78782c19-f448-4830-acfc-5e80288331de
b8aa9425-0877-4f82-b0d8-80b88cf842b7	normal	2	22fb61dd-f54d-4bec-bb98-26d90f94d16b	78782c19-f448-4830-acfc-5e80288331de
28fdebda-a485-4e4e-810d-81e0271074f7	very low	5	744f79d7-2692-422c-9d63-b24cec2f8d6b	78782c19-f448-4830-acfc-5e80288331de
358642cb-fa50-4cc7-bc2c-8cd2d060a856	very low	6	4964861f-962a-416f-b2a0-6a0c93adea91	78782c19-f448-4830-acfc-5e80288331de
43f93762-3ce9-4f32-a91b-4328cdd14506	normal	0	cd191bdd-8fea-4d6a-81b5-380de93cad59	f1bf4fc6-666e-4da3-af62-a8e00aca6eb7
255c9ff7-9d19-4e4a-b24a-6dd6640df8c9	normal	2	47a65933-fe35-41e9-9610-c55805c92b93	f1bf4fc6-666e-4da3-af62-a8e00aca6eb7
6f26415f-e609-4a90-9a9b-1e4f341c3b26	normal	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	f1bf4fc6-666e-4da3-af62-a8e00aca6eb7
bf789c04-ab45-410b-b2e1-3c5418f6d52d	very low	5	744f79d7-2692-422c-9d63-b24cec2f8d6b	f1bf4fc6-666e-4da3-af62-a8e00aca6eb7
14a5204f-dc94-46a5-9436-2c84a8ecebe4	very low	9	4964861f-962a-416f-b2a0-6a0c93adea91	f1bf4fc6-666e-4da3-af62-a8e00aca6eb7
bcd1062c-4670-4789-a2e2-c5689a0443f4	normal	0	cd191bdd-8fea-4d6a-81b5-380de93cad59	dd10ed4c-b861-4c05-8d57-554ed39e121b
91ac1e34-f21a-4dff-80be-d1b226f7fc0d	normal	2	47a65933-fe35-41e9-9610-c55805c92b93	dd10ed4c-b861-4c05-8d57-554ed39e121b
af39951b-dc84-4de4-a988-cff674af1e74	normal	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	dd10ed4c-b861-4c05-8d57-554ed39e121b
f23fb250-d5c5-44d4-a4e5-3d73cf4df927	very low	7	744f79d7-2692-422c-9d63-b24cec2f8d6b	dd10ed4c-b861-4c05-8d57-554ed39e121b
46144d07-3a15-47ac-a1a5-537fda6ff34b	very high	40	cd191bdd-8fea-4d6a-81b5-380de93cad59	3392340e-0fa6-42e9-9d3b-e97bbcce7281
25a950e4-1385-4a6b-9004-998c84604324	very high	42	cd191bdd-8fea-4d6a-81b5-380de93cad59	4cff9bb5-a664-428a-b155-dab86c110e10
fc6173cc-26cb-436f-894a-fd61d43a1f12	very high	42	47a65933-fe35-41e9-9610-c55805c92b93	4cff9bb5-a664-428a-b155-dab86c110e10
9fe2a830-63d8-4f11-9d90-1b86da1c5661	very high	30	22fb61dd-f54d-4bec-bb98-26d90f94d16b	4cff9bb5-a664-428a-b155-dab86c110e10
12fa7340-727c-4276-a7b2-255d605d893a	intermediate	17	744f79d7-2692-422c-9d63-b24cec2f8d6b	4cff9bb5-a664-428a-b155-dab86c110e10
5c470824-23a5-40ba-b427-c42e80451064	high	25	4964861f-962a-416f-b2a0-6a0c93adea91	4cff9bb5-a664-428a-b155-dab86c110e10
66e520f1-7fd5-42de-9aae-d48e339e14c6	very high	41	4964861f-962a-416f-b2a0-6a0c93adea91	dd10ed4c-b861-4c05-8d57-554ed39e121b
a7ccbf86-1160-45e1-abc9-6b841152d9e8	very high	40	cd191bdd-8fea-4d6a-81b5-380de93cad59	864341b1-3981-4926-82bd-d47dfb2aa883
10315726-5239-4446-9aae-0f342a1e5031	very high	42	cd191bdd-8fea-4d6a-81b5-380de93cad59	94ac6117-7aff-440a-8b2c-fadd683ca348
c8715ee4-a797-4b82-bde7-9a6a35e62169	normal	0	47a65933-fe35-41e9-9610-c55805c92b93	94ac6117-7aff-440a-8b2c-fadd683ca348
9d453036-db53-4334-9dcb-d669f0c6b113	very high	30	22fb61dd-f54d-4bec-bb98-26d90f94d16b	94ac6117-7aff-440a-8b2c-fadd683ca348
dc441274-941e-4512-b49d-faa01f2476de	very high	23	744f79d7-2692-422c-9d63-b24cec2f8d6b	94ac6117-7aff-440a-8b2c-fadd683ca348
1fe077c6-949d-466d-9fb7-e3e5e57d6ab2	very low	6	4964861f-962a-416f-b2a0-6a0c93adea91	94ac6117-7aff-440a-8b2c-fadd683ca348
cb2104f4-abe1-4f00-b346-47f53522e24e	very high	32	47a65933-fe35-41e9-9610-c55805c92b93	3392340e-0fa6-42e9-9d3b-e97bbcce7281
e05541df-7807-4d0e-a467-ceafa39a16e0	very high	32	22fb61dd-f54d-4bec-bb98-26d90f94d16b	3392340e-0fa6-42e9-9d3b-e97bbcce7281
d4ec0dd2-72eb-4b4b-b119-d29704ae8096	high	21	744f79d7-2692-422c-9d63-b24cec2f8d6b	3392340e-0fa6-42e9-9d3b-e97bbcce7281
aa380614-ba17-4900-aa1b-2ae01e0a7383	very high	33	4964861f-962a-416f-b2a0-6a0c93adea91	3392340e-0fa6-42e9-9d3b-e97bbcce7281
b4239d79-cbe5-4517-b88b-c5a6a0884268	intermediate	20	cd191bdd-8fea-4d6a-81b5-380de93cad59	326f2692-ea84-4e6a-8e8c-32b2faa39c04
f44798d8-f253-4cdd-866a-794755adfd90	very high	34	47a65933-fe35-41e9-9610-c55805c92b93	326f2692-ea84-4e6a-8e8c-32b2faa39c04
c86927f4-6a88-4b32-b357-eae3dc3ed9d8	very high	28	22fb61dd-f54d-4bec-bb98-26d90f94d16b	326f2692-ea84-4e6a-8e8c-32b2faa39c04
14b700e5-5c68-4a33-8a8b-75dd5c84691d	high	20	744f79d7-2692-422c-9d63-b24cec2f8d6b	326f2692-ea84-4e6a-8e8c-32b2faa39c04
a3f75685-e4b4-4f0a-8f60-0a4be11bd469	high	26	4964861f-962a-416f-b2a0-6a0c93adea91	326f2692-ea84-4e6a-8e8c-32b2faa39c04
14f4fccb-5a95-4bbe-8bc2-1a9ecd0c884e	low	16	cd191bdd-8fea-4d6a-81b5-380de93cad59	a3c089fe-66ef-4870-8482-0287539d0ee2
9c175a45-191c-4b05-9cab-7652670b5851	intermediate	24	cd191bdd-8fea-4d6a-81b5-380de93cad59	e7211f79-0a95-42f8-9fa1-8c5a96c2c417
c6db4692-6194-404b-be31-0ec30013f94c	low	16	cd191bdd-8fea-4d6a-81b5-380de93cad59	9beabf06-2c3c-4d71-a1ed-67f8ccf346a3
7096a2ea-ce01-4064-924c-6dff33ad0925	high	18	47a65933-fe35-41e9-9610-c55805c92b93	9beabf06-2c3c-4d71-a1ed-67f8ccf346a3
2584358d-c2df-4264-9450-48daac65dbe9	intermediate	20	22fb61dd-f54d-4bec-bb98-26d90f94d16b	9beabf06-2c3c-4d71-a1ed-67f8ccf346a3
c6573325-183e-4330-a4a2-6504316da50c	low	10	744f79d7-2692-422c-9d63-b24cec2f8d6b	9beabf06-2c3c-4d71-a1ed-67f8ccf346a3
4a97d51e-9fd3-4e10-9acc-da509e32f2a0	low	17	4964861f-962a-416f-b2a0-6a0c93adea91	9beabf06-2c3c-4d71-a1ed-67f8ccf346a3
563afc75-a8ba-4ce5-b32f-0bc103e76be4	low	16	cd191bdd-8fea-4d6a-81b5-380de93cad59	5b0f38a2-c133-4fe1-ae18-b217976bbc77
3f0c9c68-792c-4b6f-b9e8-d39f7cfe8a6e	very high	24	47a65933-fe35-41e9-9610-c55805c92b93	5b0f38a2-c133-4fe1-ae18-b217976bbc77
84a6ce72-37b0-46b7-a01b-c52ce28f814a	high	26	22fb61dd-f54d-4bec-bb98-26d90f94d16b	5b0f38a2-c133-4fe1-ae18-b217976bbc77
a25281bb-680d-4695-8530-51cfd01ac466	intermediate	16	744f79d7-2692-422c-9d63-b24cec2f8d6b	5b0f38a2-c133-4fe1-ae18-b217976bbc77
3866af98-75af-4fd3-aee5-967220fad1d5	high	26	4964861f-962a-416f-b2a0-6a0c93adea91	5b0f38a2-c133-4fe1-ae18-b217976bbc77
db735e71-e936-45be-a569-aaf8ae0c36ed	low	16	cd191bdd-8fea-4d6a-81b5-380de93cad59	5ac3242c-19f9-4cfa-b097-314278a85af0
1c42a71d-e670-40f8-8a1a-d93fb62b1b30	intermediate	14	47a65933-fe35-41e9-9610-c55805c92b93	5ac3242c-19f9-4cfa-b097-314278a85af0
aa25b2c8-7369-45fd-be0c-556b84d09be8	intermediate	18	22fb61dd-f54d-4bec-bb98-26d90f94d16b	5ac3242c-19f9-4cfa-b097-314278a85af0
c08409f3-1545-43de-a121-83d1ee496a84	intermediate	14	744f79d7-2692-422c-9d63-b24cec2f8d6b	5ac3242c-19f9-4cfa-b097-314278a85af0
9dcf89d1-3d18-4b6e-b9a6-731a27207af3	high	26	4964861f-962a-416f-b2a0-6a0c93adea91	5ac3242c-19f9-4cfa-b097-314278a85af0
5372cb10-3c24-4734-8c70-e631785245d9	intermediate	20	cd191bdd-8fea-4d6a-81b5-380de93cad59	02a27c27-3bea-4359-b6b7-0fd97cfcef6c
05fe226f-3069-4057-9817-7fc88069c9c5	very high	28	47a65933-fe35-41e9-9610-c55805c92b93	02a27c27-3bea-4359-b6b7-0fd97cfcef6c
1f8b02b9-4f45-4e52-8e18-b1de54821ebc	very high	28	22fb61dd-f54d-4bec-bb98-26d90f94d16b	02a27c27-3bea-4359-b6b7-0fd97cfcef6c
33f508b4-4cca-4b0b-9f86-aeffeb83455a	intermediate	16	744f79d7-2692-422c-9d63-b24cec2f8d6b	02a27c27-3bea-4359-b6b7-0fd97cfcef6c
a18ed0b1-8c4d-4c17-ae98-20196ee8e837	intermediate	23	4964861f-962a-416f-b2a0-6a0c93adea91	02a27c27-3bea-4359-b6b7-0fd97cfcef6c
b60aa82a-db87-49b9-a1bf-0c2a0c22b6f5	very high	36	cd191bdd-8fea-4d6a-81b5-380de93cad59	e271624f-6102-401b-b789-4a6fb86538ac
3ed63113-7fa7-4da7-8647-3120dd964e3b	very high	34	47a65933-fe35-41e9-9610-c55805c92b93	e271624f-6102-401b-b789-4a6fb86538ac
4a1029f2-a550-431b-a12b-99f20357d31a	high	22	22fb61dd-f54d-4bec-bb98-26d90f94d16b	e271624f-6102-401b-b789-4a6fb86538ac
81141995-b214-449a-a6b3-d1d268daf34b	intermediate	16	744f79d7-2692-422c-9d63-b24cec2f8d6b	e271624f-6102-401b-b789-4a6fb86538ac
cc78fde5-9441-41c6-9ce4-b35ed3e1886e	high	27	4964861f-962a-416f-b2a0-6a0c93adea91	e271624f-6102-401b-b789-4a6fb86538ac
dd20f0bd-ce98-4594-b1c4-314ece9be67b	low	18	cd191bdd-8fea-4d6a-81b5-380de93cad59	72d11f8d-7e97-4fa5-93ea-52928a1ed3b9
d8bde31d-1759-46d2-87eb-10909e198af5	high	18	47a65933-fe35-41e9-9610-c55805c92b93	72d11f8d-7e97-4fa5-93ea-52928a1ed3b9
1664c152-0415-4df8-b70e-3612f4f70ccc	intermediate	18	22fb61dd-f54d-4bec-bb98-26d90f94d16b	72d11f8d-7e97-4fa5-93ea-52928a1ed3b9
ba5700eb-90c5-44a3-bc6a-69851668ddb8	intermediate	14	744f79d7-2692-422c-9d63-b24cec2f8d6b	72d11f8d-7e97-4fa5-93ea-52928a1ed3b9
e367779b-cb54-4779-80b5-d55c7feeef2a	intermediate	21	4964861f-962a-416f-b2a0-6a0c93adea91	72d11f8d-7e97-4fa5-93ea-52928a1ed3b9
67ef2ef1-f65f-4ebb-8bcc-b4ba48f56bf3	intermediate	22	cd191bdd-8fea-4d6a-81b5-380de93cad59	40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7
76d8ef1e-3389-431d-a6f2-4d9a260fc101	very high	26	47a65933-fe35-41e9-9610-c55805c92b93	40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7
453b5672-2876-48ea-b0a8-c4a4b54e0db5	very high	32	22fb61dd-f54d-4bec-bb98-26d90f94d16b	40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7
d41d423c-71a9-4087-9356-a45ef5ad2889	intermediate	14	744f79d7-2692-422c-9d63-b24cec2f8d6b	40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7
e64f8312-6a9d-4fab-803d-ef398a90a0a1	intermediate	19	4964861f-962a-416f-b2a0-6a0c93adea91	40d91ade-2fc9-4bf3-9b92-2f5d6808d1d7
b52aa81a-949e-46c8-b3bb-1333a56a73da	normal	12	cd191bdd-8fea-4d6a-81b5-380de93cad59	5915c42b-fdd7-43b8-9808-5b3a8efae88f
24570a22-d153-461a-9b5e-d5e3919297e5	normal	2	47a65933-fe35-41e9-9610-c55805c92b93	5915c42b-fdd7-43b8-9808-5b3a8efae88f
01cea9bd-433f-46d9-b678-e93cee216963	normal	8	22fb61dd-f54d-4bec-bb98-26d90f94d16b	5915c42b-fdd7-43b8-9808-5b3a8efae88f
dae64f11-fc7c-4799-8df8-ad8b6bd0684d	very low	8	744f79d7-2692-422c-9d63-b24cec2f8d6b	5915c42b-fdd7-43b8-9808-5b3a8efae88f
5cd04a8a-30ab-41b8-b89d-fd7e7704ee74	high	25	4964861f-962a-416f-b2a0-6a0c93adea91	5915c42b-fdd7-43b8-9808-5b3a8efae88f
7a385d2a-ac10-46b4-b707-844fb465a1f2	intermediate	20	cd191bdd-8fea-4d6a-81b5-380de93cad59	e508e3a9-e992-4a59-8b31-e01b39bad462
9564c82d-0512-455a-b741-e73bf675d1ff	high	18	47a65933-fe35-41e9-9610-c55805c92b93	e508e3a9-e992-4a59-8b31-e01b39bad462
ec06a45b-4c17-4636-af76-0eb6b4c52f31	high	24	22fb61dd-f54d-4bec-bb98-26d90f94d16b	e508e3a9-e992-4a59-8b31-e01b39bad462
e336aedf-0629-43c3-bea5-248bd3e97924	intermediate	16	744f79d7-2692-422c-9d63-b24cec2f8d6b	e508e3a9-e992-4a59-8b31-e01b39bad462
c25b6e2d-0b20-482f-9f50-44cfc5b2e779	intermediate	19	4964861f-962a-416f-b2a0-6a0c93adea91	e508e3a9-e992-4a59-8b31-e01b39bad462
49eb8dfb-537b-4e99-a043-24c5ef0aaae3	high	30	cd191bdd-8fea-4d6a-81b5-380de93cad59	112e0f11-5dd1-4238-8152-ae6453534921
3f1b1df7-f82f-4d80-8ee7-66b36c2fd04c	very high	28	47a65933-fe35-41e9-9610-c55805c92b93	112e0f11-5dd1-4238-8152-ae6453534921
3820ffa8-9cb5-407f-a8ba-7fca7ea49407	high	26	22fb61dd-f54d-4bec-bb98-26d90f94d16b	112e0f11-5dd1-4238-8152-ae6453534921
6dfec320-478a-4240-a158-f501ee486b47	intermediate	17	744f79d7-2692-422c-9d63-b24cec2f8d6b	112e0f11-5dd1-4238-8152-ae6453534921
f16c27ec-34ab-4540-a8e7-3025f979abeb	intermediate	19	4964861f-962a-416f-b2a0-6a0c93adea91	112e0f11-5dd1-4238-8152-ae6453534921
fb956d59-0c46-4d59-9263-be3f713a25cf	normal	2	cd191bdd-8fea-4d6a-81b5-380de93cad59	7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd
be78ac81-8cad-401c-b26b-7bf81dd59ece	normal	0	47a65933-fe35-41e9-9610-c55805c92b93	7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd
6f4dedfd-f3b6-49ac-8111-a3cebbb877a9	normal	0	22fb61dd-f54d-4bec-bb98-26d90f94d16b	7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd
28e13f7d-16d1-448a-9c84-3f5c471c4695	very high	25	744f79d7-2692-422c-9d63-b24cec2f8d6b	7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd
ced115e2-0960-41e7-80f6-aeec1b778247	very low	11	4964861f-962a-416f-b2a0-6a0c93adea91	7d0dcacf-f0f8-4619-89ad-fc9fa426a2cd
\.


--
-- Name: symtomps PK_02f54354c0100899af30805c5ef; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symtomps
    ADD CONSTRAINT "PK_02f54354c0100899af30805c5ef" PRIMARY KEY (id);


--
-- Name: summary_kuisioner PK_03738a1c2b13e97c583c64d7df0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary_kuisioner
    ADD CONSTRAINT "PK_03738a1c2b13e97c583c64d7df0" PRIMARY KEY (id);


--
-- Name: pre_kuisioner_user PK_076c4da1ebdea27a9582997716e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_user
    ADD CONSTRAINT "PK_076c4da1ebdea27a9582997716e" PRIMARY KEY (id);


--
-- Name: kuisioners PK_07e8cd547be28bed054a68ef3e2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuisioners
    ADD CONSTRAINT "PK_07e8cd547be28bed054a68ef3e2" PRIMARY KEY (id);


--
-- Name: questions PK_08a6d4b0f49ff300bf3a0ca60ac; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT "PK_08a6d4b0f49ff300bf3a0ca60ac" PRIMARY KEY (id);


--
-- Name: pre_kuisioner_category PK_0c0ed92e00aa22b02b4d2b9a9c6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_category
    ADD CONSTRAINT "PK_0c0ed92e00aa22b02b4d2b9a9c6" PRIMARY KEY (id);


--
-- Name: auths PK_22fc0631a651972ddc9c5a31090; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auths
    ADD CONSTRAINT "PK_22fc0631a651972ddc9c5a31090" PRIMARY KEY (id);


--
-- Name: pre_kuisioner_question PK_28ba8563f2050aebbd73622adee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_question
    ADD CONSTRAINT "PK_28ba8563f2050aebbd73622adee" PRIMARY KEY (id);


--
-- Name: pre_kuisioner_answer PK_3018352c833572e30e464f91ddf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_answer
    ADD CONSTRAINT "PK_3018352c833572e30e464f91ddf" PRIMARY KEY (id);


--
-- Name: facultys PK_75ecb189fb8887010b2960a3a97; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facultys
    ADD CONSTRAINT "PK_75ecb189fb8887010b2960a3a97" PRIMARY KEY (id);


--
-- Name: user_answer_sub_kuisioner PK_929c0e3dea60ad9cb2447a50a43; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_sub_kuisioner
    ADD CONSTRAINT "PK_929c0e3dea60ad9cb2447a50a43" PRIMARY KEY (id);


--
-- Name: answers PK_9c32cec6c71e06da0254f2226c6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT "PK_9c32cec6c71e06da0254f2226c6" PRIMARY KEY (id);


--
-- Name: roles PK_c1433d71a4838793a49dcad46ab; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "PK_c1433d71a4838793a49dcad46ab" PRIMARY KEY (id);


--
-- Name: subkuisioners PK_c352dc59b1b8ad6e500556d129f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subkuisioners
    ADD CONSTRAINT "PK_c352dc59b1b8ad6e500556d129f" PRIMARY KEY (id);


--
-- Name: userEminds PK_c8928602a623203a2c520205a53; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "PK_c8928602a623203a2c520205a53" PRIMARY KEY (id);


--
-- Name: pre_kuisioner_user_answer PK_ccd6e9e5091c51474d6fffe6dce; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_user_answer
    ADD CONSTRAINT "PK_ccd6e9e5091c51474d6fffe6dce" PRIMARY KEY (id);


--
-- Name: take_kuisioner PK_d92801777a2486a696c8b1804d0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.take_kuisioner
    ADD CONSTRAINT "PK_d92801777a2486a696c8b1804d0" PRIMARY KEY (id);


--
-- Name: client_psychologist PK_ddece54fb9627e193ee56b79c35; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_psychologist
    ADD CONSTRAINT "PK_ddece54fb9627e193ee56b79c35" PRIMARY KEY (id);


--
-- Name: user_answer_kuisioner PK_fd274816a44501d61c5cad0f9fb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_kuisioner
    ADD CONSTRAINT "PK_fd274816a44501d61c5cad0f9fb" PRIMARY KEY (id);


--
-- Name: summary_kuisioner REL_64fff63371143b3c27eeaf5750; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary_kuisioner
    ADD CONSTRAINT "REL_64fff63371143b3c27eeaf5750" UNIQUE (user_id);


--
-- Name: userEminds UQ_6fc1fea0a11de42f33ef56a7951; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "UQ_6fc1fea0a11de42f33ef56a7951" UNIQUE ("preKuisionerId");


--
-- Name: userEminds UQ_b080c584cc25d4737b83c757ed6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "UQ_b080c584cc25d4737b83c757ed6" UNIQUE (email);


--
-- Name: userEminds UQ_e3f4787a3f478612de4c837e30f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "UQ_e3f4787a3f478612de4c837e30f" UNIQUE ("authId");


--
-- Name: take_kuisioner FK_00e0d80df70ca366da4a08175b9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.take_kuisioner
    ADD CONSTRAINT "FK_00e0d80df70ca366da4a08175b9" FOREIGN KEY ("userId") REFERENCES public."userEminds"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_answer_sub_kuisioner FK_3b607654b4595356b72dc902d9f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_sub_kuisioner
    ADD CONSTRAINT "FK_3b607654b4595356b72dc902d9f" FOREIGN KEY ("subKuisionerId") REFERENCES public.subkuisioners(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subkuisioners FK_49c09c38164659b7ae5d4af05c4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subkuisioners
    ADD CONSTRAINT "FK_49c09c38164659b7ae5d4af05c4" FOREIGN KEY ("kuisionerIdId") REFERENCES public.kuisioners(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_answer_kuisioner FK_5894f873f903c6def4ef5b2f607; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_kuisioner
    ADD CONSTRAINT "FK_5894f873f903c6def4ef5b2f607" FOREIGN KEY ("userAnswerSubKuisionerId") REFERENCES public.user_answer_sub_kuisioner(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_answer_kuisioner FK_5a6a01c05c227e9c8029b12559e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_kuisioner
    ADD CONSTRAINT "FK_5a6a01c05c227e9c8029b12559e" FOREIGN KEY ("answerId") REFERENCES public.answers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: summary_kuisioner FK_64fff63371143b3c27eeaf57501; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.summary_kuisioner
    ADD CONSTRAINT "FK_64fff63371143b3c27eeaf57501" FOREIGN KEY (user_id) REFERENCES public."userEminds"(id) ON DELETE CASCADE;


--
-- Name: userEminds FK_6ab3f530a22712eeae7c9e19204; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "FK_6ab3f530a22712eeae7c9e19204" FOREIGN KEY ("roleId") REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userEminds FK_6fc1fea0a11de42f33ef56a7951; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "FK_6fc1fea0a11de42f33ef56a7951" FOREIGN KEY ("preKuisionerId") REFERENCES public.pre_kuisioner_user(id);


--
-- Name: client_psychologist FK_82329cbfd68381fb871564838a4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_psychologist
    ADD CONSTRAINT "FK_82329cbfd68381fb871564838a4" FOREIGN KEY ("psychologistId") REFERENCES public."userEminds"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pre_kuisioner_answer FK_853913b825b8cd00d70136455c0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_answer
    ADD CONSTRAINT "FK_853913b825b8cd00d70136455c0" FOREIGN KEY ("preQuestionIdId") REFERENCES public.pre_kuisioner_question(id);


--
-- Name: pre_kuisioner_user_answer FK_8e192eebe01d40c1e5ba91b7953; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_user_answer
    ADD CONSTRAINT "FK_8e192eebe01d40c1e5ba91b7953" FOREIGN KEY ("preKuisionerAnswerId") REFERENCES public.pre_kuisioner_answer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pre_kuisioner_user_answer FK_900aa9e05bc68c403afb524a222; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_user_answer
    ADD CONSTRAINT "FK_900aa9e05bc68c403afb524a222" FOREIGN KEY ("preKuisionerUserId") REFERENCES public.pre_kuisioner_user(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userEminds FK_a1ba0fa8b12848cfb633d92ee2f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "FK_a1ba0fa8b12848cfb633d92ee2f" FOREIGN KEY ("facultyId") REFERENCES public.facultys(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: take_kuisioner FK_b8ed1473cf1f020847e436085d1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.take_kuisioner
    ADD CONSTRAINT "FK_b8ed1473cf1f020847e436085d1" FOREIGN KEY ("kuisionerId") REFERENCES public.kuisioners(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_answer_sub_kuisioner FK_b90abce5938c3b98582d3fec3c6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answer_sub_kuisioner
    ADD CONSTRAINT "FK_b90abce5938c3b98582d3fec3c6" FOREIGN KEY ("takeKuisionerId") REFERENCES public.take_kuisioner(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pre_kuisioner_question FK_bd474c077fa02056aff7f1718e4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_kuisioner_question
    ADD CONSTRAINT "FK_bd474c077fa02056aff7f1718e4" FOREIGN KEY ("categoryId") REFERENCES public.pre_kuisioner_category(id);


--
-- Name: subkuisioners FK_d619f83180792754d1aa5c3b423; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subkuisioners
    ADD CONSTRAINT "FK_d619f83180792754d1aa5c3b423" FOREIGN KEY ("symtompIdId") REFERENCES public.symtomps(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: questions FK_dec9b356a856a1d62882b2a93c4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT "FK_dec9b356a856a1d62882b2a93c4" FOREIGN KEY ("subKuisionerIdId") REFERENCES public.subkuisioners(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userEminds FK_e3f4787a3f478612de4c837e30f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userEminds"
    ADD CONSTRAINT "FK_e3f4787a3f478612de4c837e30f" FOREIGN KEY ("authId") REFERENCES public.auths(id);


--
-- Name: answers FK_e6803a520e3f9f6ce24819745e5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT "FK_e6803a520e3f9f6ce24819745e5" FOREIGN KEY ("questionIdId") REFERENCES public.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: client_psychologist FK_fb6d400c5a5c092b3ef66a9ec3b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_psychologist
    ADD CONSTRAINT "FK_fb6d400c5a5c092b3ef66a9ec3b" FOREIGN KEY ("clientId") REFERENCES public."userEminds"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

