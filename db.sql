--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Block; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Block" (
    block_id integer NOT NULL,
    "hashMerkleRoot" character varying(255),
    txn_counter integer
);


--
-- Name: BlockHeader; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "BlockHeader" (
    id integer NOT NULL,
    "nVersion" smallint,
    "hashPrevBlock" character varying(255),
    "hashMerkleRoot" character varying(255),
    "nTime" timestamp without time zone,
    "nBits" smallint,
    nonce smallint
);


--
-- Name: BlockHeader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "BlockHeader_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: BlockHeader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "BlockHeader_id_seq" OWNED BY "BlockHeader".id;


--
-- Name: Block_block_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Block_block_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Block_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Block_block_id_seq" OWNED BY "Block".block_id;


--
-- Name: Txn; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Txn" (
    txn_id integer NOT NULL,
    "nVersion" smallint,
    "inCounter" smallint,
    "outCounter" smallint,
    lock_time timestamp without time zone,
    block_id integer NOT NULL
);


--
-- Name: TxnIn; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "TxnIn" (
    id integer NOT NULL,
    "hashPrevTxn" character varying(255),
    "txnOut_id" integer NOT NULL,
    "scriptLen" smallint,
    "scriptSig" character varying(255),
    "seqNo" smallint,
    txn_id integer NOT NULL
);


--
-- Name: TxnIn_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "TxnIn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TxnIn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "TxnIn_id_seq" OWNED BY "TxnIn".id;


--
-- Name: TxnIn_txnOut_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "TxnIn_txnOut_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TxnIn_txnOut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "TxnIn_txnOut_id_seq" OWNED BY "TxnIn"."txnOut_id";


--
-- Name: TxnIn_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "TxnIn_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TxnIn_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "TxnIn_txn_id_seq" OWNED BY "TxnIn".txn_id;


--
-- Name: TxnOut; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "TxnOut" (
    id integer NOT NULL,
    value bigint,
    "scriptLen" smallint,
    "scriptPubKey" character varying(255),
    txn_id integer NOT NULL
);


--
-- Name: TxnOut_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "TxnOut_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TxnOut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "TxnOut_id_seq" OWNED BY "TxnOut".id;


--
-- Name: TxnOut_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "TxnOut_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: TxnOut_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "TxnOut_txn_id_seq" OWNED BY "TxnOut".txn_id;


--
-- Name: Txn_block_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Txn_block_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Txn_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Txn_block_id_seq" OWNED BY "Txn".block_id;


--
-- Name: Txn_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Txn_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Txn_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Txn_txn_id_seq" OWNED BY "Txn".txn_id;


--
-- Name: block_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Block" ALTER COLUMN block_id SET DEFAULT nextval('"Block_block_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "BlockHeader" ALTER COLUMN id SET DEFAULT nextval('"BlockHeader_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Txn" ALTER COLUMN txn_id SET DEFAULT nextval('"Txn_txn_id_seq"'::regclass);


--
-- Name: block_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Txn" ALTER COLUMN block_id SET DEFAULT nextval('"Txn_block_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN id SET DEFAULT nextval('"TxnIn_id_seq"'::regclass);


--
-- Name: txnOut_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN "txnOut_id" SET DEFAULT nextval('"TxnIn_txnOut_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN txn_id SET DEFAULT nextval('"TxnIn_txn_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnOut" ALTER COLUMN id SET DEFAULT nextval('"TxnOut_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnOut" ALTER COLUMN txn_id SET DEFAULT nextval('"TxnOut_txn_id_seq"'::regclass);


--
-- Data for Name: Block; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "Block" (block_id, "hashMerkleRoot", txn_counter) FROM stdin;
\.


--
-- Data for Name: BlockHeader; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "BlockHeader" (id, "nVersion", "hashPrevBlock", "hashMerkleRoot", "nTime", "nBits", nonce) FROM stdin;
\.


--
-- Name: BlockHeader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"BlockHeader_id_seq"', 1, false);


--
-- Name: Block_block_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"Block_block_id_seq"', 1, false);


--
-- Data for Name: Txn; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "Txn" (txn_id, "nVersion", "inCounter", "outCounter", lock_time, block_id) FROM stdin;
\.


--
-- Data for Name: TxnIn; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "TxnIn" (id, "hashPrevTxn", "txnOut_id", "scriptLen", "scriptSig", "seqNo", txn_id) FROM stdin;
\.


--
-- Name: TxnIn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"TxnIn_id_seq"', 1, false);


--
-- Name: TxnIn_txnOut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"TxnIn_txnOut_id_seq"', 1, false);


--
-- Name: TxnIn_txn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"TxnIn_txn_id_seq"', 1, false);


--
-- Data for Name: TxnOut; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "TxnOut" (id, value, "scriptLen", "scriptPubKey", txn_id) FROM stdin;
\.


--
-- Name: TxnOut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"TxnOut_id_seq"', 1, false);


--
-- Name: TxnOut_txn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"TxnOut_txn_id_seq"', 1, false);


--
-- Name: Txn_block_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"Txn_block_id_seq"', 1, false);


--
-- Name: Txn_txn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"Txn_txn_id_seq"', 1, false);


--
-- Name: BlockHeader_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "BlockHeader"
    ADD CONSTRAINT "BlockHeader_pkey" PRIMARY KEY (id);


--
-- Name: Block_hashMerkleRoot_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Block"
    ADD CONSTRAINT "Block_hashMerkleRoot_key" UNIQUE ("hashMerkleRoot");


--
-- Name: Block_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Block"
    ADD CONSTRAINT "Block_pkey" PRIMARY KEY (block_id);


--
-- Name: TxnIn_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_pkey" PRIMARY KEY (id);


--
-- Name: TxnOut_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "TxnOut"
    ADD CONSTRAINT "TxnOut_pkey" PRIMARY KEY (id);


--
-- Name: Txn_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Txn"
    ADD CONSTRAINT "Txn_pkey" PRIMARY KEY (txn_id);


--
-- Name: BlockHeader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "BlockHeader"
    ADD CONSTRAINT "BlockHeader_id_fkey" FOREIGN KEY (id) REFERENCES "Block"(block_id);


--
-- Name: TxnIn_txnOut_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_txnOut_id_fkey" FOREIGN KEY ("txnOut_id") REFERENCES "TxnOut"(id);


--
-- Name: TxnIn_txn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_txn_id_fkey" FOREIGN KEY (txn_id) REFERENCES "Txn"(txn_id);


--
-- Name: TxnOut_txn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "TxnOut"
    ADD CONSTRAINT "TxnOut_txn_id_fkey" FOREIGN KEY (txn_id) REFERENCES "Txn"(txn_id);


--
-- Name: Txn_block_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Txn"
    ADD CONSTRAINT "Txn_block_id_fkey" FOREIGN KEY (block_id) REFERENCES "Block"(block_id);


--
-- PostgreSQL database dump complete
--

