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
    "nBits" bigint,
    nonce bigint
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
    hash character varying(255),
    block_id integer,
    id integer NOT NULL
);


--
-- Name: TxnIn; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "TxnIn" (
    address character varying(255),
    txn_id integer
);


--
-- Name: TxnOut; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "TxnOut" (
    address character varying(255),
    txn_id integer
);


--
-- Name: Txn_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Txn_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Txn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Txn_id_seq" OWNED BY "Txn".id;


--
-- Name: block_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Block" ALTER COLUMN block_id SET DEFAULT nextval('"Block_block_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "BlockHeader" ALTER COLUMN id SET DEFAULT nextval('"BlockHeader_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Txn" ALTER COLUMN id SET DEFAULT nextval('"Txn_id_seq"'::regclass);


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
-- Name: Txn_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Txn"
    ADD CONSTRAINT "Txn_pkey" PRIMARY KEY (id);


--
-- Name: BlockHeader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "BlockHeader"
    ADD CONSTRAINT "BlockHeader_id_fkey" FOREIGN KEY (id) REFERENCES "Block"(block_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nanne;
GRANT ALL ON SCHEMA public TO nanne;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: Block; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Block" FROM PUBLIC;
REVOKE ALL ON TABLE "Block" FROM bitcoin;
GRANT ALL ON TABLE "Block" TO bitcoin;


--
-- Name: BlockHeader; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "BlockHeader" FROM PUBLIC;
REVOKE ALL ON TABLE "BlockHeader" FROM bitcoin;
GRANT ALL ON TABLE "BlockHeader" TO bitcoin;


--
-- Name: BlockHeader_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE "BlockHeader_id_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE "BlockHeader_id_seq" FROM bitcoin;
GRANT ALL ON SEQUENCE "BlockHeader_id_seq" TO bitcoin;


--
-- Name: Block_block_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE "Block_block_id_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE "Block_block_id_seq" FROM bitcoin;
GRANT ALL ON SEQUENCE "Block_block_id_seq" TO bitcoin;


--
-- Name: Txn; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Txn" FROM PUBLIC;
REVOKE ALL ON TABLE "Txn" FROM nanne;
GRANT ALL ON TABLE "Txn" TO nanne;
GRANT ALL ON TABLE "Txn" TO bitcoin;


--
-- Name: TxnIn; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "TxnIn" FROM PUBLIC;
REVOKE ALL ON TABLE "TxnIn" FROM nanne;
GRANT ALL ON TABLE "TxnIn" TO nanne;
GRANT ALL ON TABLE "TxnIn" TO bitcoin;


--
-- Name: TxnOut; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "TxnOut" FROM PUBLIC;
REVOKE ALL ON TABLE "TxnOut" FROM nanne;
GRANT ALL ON TABLE "TxnOut" TO nanne;
GRANT ALL ON TABLE "TxnOut" TO bitcoin;


--
-- Name: Txn_id_seq; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON SEQUENCE "Txn_id_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE "Txn_id_seq" FROM nanne;
GRANT ALL ON SEQUENCE "Txn_id_seq" TO nanne;
GRANT SELECT,USAGE ON SEQUENCE "Txn_id_seq" TO bitcoin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE nanne IN SCHEMA public REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE nanne IN SCHEMA public REVOKE ALL ON TABLES  FROM nanne;
ALTER DEFAULT PRIVILEGES FOR ROLE nanne IN SCHEMA public GRANT ALL ON TABLES  TO bitcoin;


--
-- PostgreSQL database dump complete
--

