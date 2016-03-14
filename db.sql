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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Block; Type: TABLE; Schema: public; Owner: bitcoin; Tablespace: 
--

CREATE TABLE "Block" (
    block_id integer NOT NULL,
    "hashMerkleRoot" character varying(255),
    txn_counter integer
);


ALTER TABLE "Block" OWNER TO bitcoin;

--
-- Name: BlockHeader; Type: TABLE; Schema: public; Owner: bitcoin; Tablespace: 
--

CREATE TABLE "BlockHeader" (
    id integer NOT NULL,
    "nVersion" smallint,
    "hashPrevBlock" character varying(255),
    "hashMerkleRoot" character varying(255),
    "nTime" timestamp without time zone,
    "nBits" bigint,
    nonce bigint
);


ALTER TABLE "BlockHeader" OWNER TO bitcoin;

--
-- Name: BlockHeader_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "BlockHeader_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "BlockHeader_id_seq" OWNER TO bitcoin;

--
-- Name: BlockHeader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "BlockHeader_id_seq" OWNED BY "BlockHeader".id;


--
-- Name: Block_block_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "Block_block_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Block_block_id_seq" OWNER TO bitcoin;

--
-- Name: Block_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "Block_block_id_seq" OWNED BY "Block".block_id;


--
-- Name: Txn; Type: TABLE; Schema: public; Owner: bitcoin; Tablespace: 
--

CREATE TABLE "Txn" (
    txn_id integer NOT NULL,
    "nVersion" smallint,
    "inCounter" smallint,
    "outCounter" smallint,
    lock_time timestamp without time zone,
    block_id integer NOT NULL
);


ALTER TABLE "Txn" OWNER TO bitcoin;

--
-- Name: TxnIn; Type: TABLE; Schema: public; Owner: bitcoin; Tablespace: 
--

CREATE TABLE "TxnIn" (
    id integer NOT NULL,
    "hashPrevTxn" character varying(255),
    "txnOut_id" integer,
    "scriptLen" smallint,
    "scriptSig" text,
    "seqNo" smallint,
    txn_id integer NOT NULL
);


ALTER TABLE "TxnIn" OWNER TO bitcoin;

--
-- Name: TxnIn_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "TxnIn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TxnIn_id_seq" OWNER TO bitcoin;

--
-- Name: TxnIn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "TxnIn_id_seq" OWNED BY "TxnIn".id;


--
-- Name: TxnIn_txnOut_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "TxnIn_txnOut_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TxnIn_txnOut_id_seq" OWNER TO bitcoin;

--
-- Name: TxnIn_txnOut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "TxnIn_txnOut_id_seq" OWNED BY "TxnIn"."txnOut_id";


--
-- Name: TxnIn_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "TxnIn_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TxnIn_txn_id_seq" OWNER TO bitcoin;

--
-- Name: TxnIn_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "TxnIn_txn_id_seq" OWNED BY "TxnIn".txn_id;


--
-- Name: TxnOut; Type: TABLE; Schema: public; Owner: bitcoin; Tablespace: 
--

CREATE TABLE "TxnOut" (
    id integer NOT NULL,
    value bigint,
    "scriptLen" smallint,
    "scriptPubKey" text,
    txn_id integer NOT NULL
);


ALTER TABLE "TxnOut" OWNER TO bitcoin;

--
-- Name: TxnOut_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "TxnOut_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TxnOut_id_seq" OWNER TO bitcoin;

--
-- Name: TxnOut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "TxnOut_id_seq" OWNED BY "TxnOut".id;


--
-- Name: TxnOut_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "TxnOut_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "TxnOut_txn_id_seq" OWNER TO bitcoin;

--
-- Name: TxnOut_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "TxnOut_txn_id_seq" OWNED BY "TxnOut".txn_id;


--
-- Name: Txn_block_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "Txn_block_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Txn_block_id_seq" OWNER TO bitcoin;

--
-- Name: Txn_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "Txn_block_id_seq" OWNED BY "Txn".block_id;


--
-- Name: Txn_txn_id_seq; Type: SEQUENCE; Schema: public; Owner: bitcoin
--

CREATE SEQUENCE "Txn_txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Txn_txn_id_seq" OWNER TO bitcoin;

--
-- Name: Txn_txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitcoin
--

ALTER SEQUENCE "Txn_txn_id_seq" OWNED BY "Txn".txn_id;


--
-- Name: block_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "Block" ALTER COLUMN block_id SET DEFAULT nextval('"Block_block_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "BlockHeader" ALTER COLUMN id SET DEFAULT nextval('"BlockHeader_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "Txn" ALTER COLUMN txn_id SET DEFAULT nextval('"Txn_txn_id_seq"'::regclass);


--
-- Name: block_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "Txn" ALTER COLUMN block_id SET DEFAULT nextval('"Txn_block_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN id SET DEFAULT nextval('"TxnIn_id_seq"'::regclass);


--
-- Name: txnOut_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN "txnOut_id" SET DEFAULT nextval('"TxnIn_txnOut_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnIn" ALTER COLUMN txn_id SET DEFAULT nextval('"TxnIn_txn_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnOut" ALTER COLUMN id SET DEFAULT nextval('"TxnOut_id_seq"'::regclass);


--
-- Name: txn_id; Type: DEFAULT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnOut" ALTER COLUMN txn_id SET DEFAULT nextval('"TxnOut_txn_id_seq"'::regclass);


--
-- Name: BlockHeader_pkey; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "BlockHeader"
    ADD CONSTRAINT "BlockHeader_pkey" PRIMARY KEY (id);


--
-- Name: Block_hashMerkleRoot_key; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "Block"
    ADD CONSTRAINT "Block_hashMerkleRoot_key" UNIQUE ("hashMerkleRoot");


--
-- Name: Block_pkey; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "Block"
    ADD CONSTRAINT "Block_pkey" PRIMARY KEY (block_id);


--
-- Name: TxnIn_pkey; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_pkey" PRIMARY KEY (id);


--
-- Name: TxnOut_pkey; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "TxnOut"
    ADD CONSTRAINT "TxnOut_pkey" PRIMARY KEY (id);


--
-- Name: Txn_pkey; Type: CONSTRAINT; Schema: public; Owner: bitcoin; Tablespace: 
--

ALTER TABLE ONLY "Txn"
    ADD CONSTRAINT "Txn_pkey" PRIMARY KEY (txn_id);


--
-- Name: BlockHeader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "BlockHeader"
    ADD CONSTRAINT "BlockHeader_id_fkey" FOREIGN KEY (id) REFERENCES "Block"(block_id);


--
-- Name: TxnIn_txnOut_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_txnOut_id_fkey" FOREIGN KEY ("txnOut_id") REFERENCES "TxnOut"(id);


--
-- Name: TxnIn_txn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnIn"
    ADD CONSTRAINT "TxnIn_txn_id_fkey" FOREIGN KEY (txn_id) REFERENCES "Txn"(txn_id);


--
-- Name: TxnOut_txn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "TxnOut"
    ADD CONSTRAINT "TxnOut_txn_id_fkey" FOREIGN KEY (txn_id) REFERENCES "Txn"(txn_id);


--
-- Name: Txn_block_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bitcoin
--

ALTER TABLE ONLY "Txn"
    ADD CONSTRAINT "Txn_block_id_fkey" FOREIGN KEY (block_id) REFERENCES "Block"(block_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: nanne
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nanne;
GRANT ALL ON SCHEMA public TO nanne;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

