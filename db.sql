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
1	0000000000000000068690c7bd7bdc4ee0ee5163a5836f79f6dae07a4f917f7f	1300
2	0000000000000000007a0de83800ed7acaa3064c5e3cd65e925a233ee0eff2a3	1097
3	0000000000000000001de104d12f9124d4ac8c5c076447feb41d4a74d8beaf29	232
4	0000000000000000011cf40825c4a5f11fbdfe93ac9f6ccc1aee2cff51682cdb	1
5	000000000000000006a73ee940967b6a3c5785f3902a23952360d8fdf0e83932	677
6	00000000000000000565713c499844a8ceecca14f8fb51767f819bb67923da08	1533
7	0000000000000000045f0b1364e457bab16f380e3bc4f3efa37b21c9ab0cca8a	2054
8	000000000000000006b2cab74042eb0699009606e842e5a64c6c9e16d4cb80e3	573
9	000000000000000004bc3e15f3e24461693e8d1291cd292e3ba457949010fac7	1625
10	0000000000000000038d91d862ec3523a99c1903b1256608096fcbf732f3db6a	2679
11	000000000000000004ad4c3576899a097d0da6884240f0a1cd58d9f6a0f9b828	3034
12	00000000000000000440ebd4e7c1c014b6767343cceefc5edfbe19b3e3f75f1f	1727
13	000000000000000004a348e0fa7b3346745132971791e75f52640c4ccac80e7c	2372
14	00000000000000000158ed0c504043902c397a831a6695e52f0aa2237838d9c9	1861
15	0000000000000000054137db6e6cc469173cb421ac3ac40deda297e697912458	1612
16	000000000000000000ca1342a44da6e338d6194f60517449805a559e1acec9c7	1216
17	0000000000000000008964a271252e24f31308a4737ca5facd2038ca87ee70f1	275
18	000000000000000003e22a0ad16d98d3067f8462fabda77c2e53c98727612b7a	1264
19	0000000000000000014ab61a888236124d4da2be2ddd25ba7edda92824d3df81	620
20	0000000000000000022c761c2c9265356ff58ce47cecc08de69325a4b350e2a6	123
21	0000000000000000043c8f60220e16674a17ed134cc7426ec02b091bada33fa5	1279
22	0000000000000000040838bcba60eb51f05a24b55b5b779f855a406aa951cf3c	684
23	000000000000000001185864838f668eaf86b0b55b9978be43ff2f2e07944ecb	2135
24	00000000000000000186d0914122d1794c8c3040a1c44533b0de4feb8c9b99f4	821
25	0000000000000000033d76d1979cbf908abbd9e94a5a7a84aedc51dd3aa0d022	741
26	000000000000000004caf85d546365c1758408ab2747bc22ec03bc4f8fea257d	456
27	0000000000000000024e5405db7873cd93dfa5e5fd9b0b9106e9e7fa7cdcea93	1424
28	000000000000000005d0fd12bf1464367d941f55deea94fbfceb36d8db79fddd	2174
29	000000000000000002c27eadc284b9d733e940a06973648d43fc6c3b2e7224df	2424
30	0000000000000000057e5c7d461cd4ff563e8a4e8071df28122231da20c2e0ae	1040
31	000000000000000001e4bfc2f04c06f2b3540e0ad73581035df3837e64e5566f	369
32	00000000000000000307e9cd063338e9c2db4c648088fa09efa44499d391d51c	2134
33	00000000000000000429bfe9f980940f02525528f03e76fca32610dd68ed286d	1862
34	0000000000000000010b2f0fb14774c668268dc506be5fdc8d63b8c09b7c20c5	1856
35	0000000000000000049fd3e402986b00c01231f89b9d1e3159765ede36cb16d7	2836
36	00000000000000000089f5639d0709d3a3e061d277d5937a7f617c25d3ee6fce	2351
37	00000000000000000370c462999f25881e445f3f7b284ebf566550290e393170	1372
38	000000000000000001ef0ff000d68f65f8da6722fafd7e7413f252589c5d6c2b	1515
39	000000000000000005feb8fbd4b53a3d1c2c6a9b60030e4b2862b391305d7939	54
40	000000000000000003ab72130e98d1dbb0c3f643163cec66c6aec51d65371963	832
41	00000000000000000448cd02f23b8f299a421438cd3b7cc4eb5822c53d296388	2387
42	000000000000000004ead97daf7756e98d7438126f3de5a3a6061610c5b00ebb	217
43	00000000000000000403486d1f39f7e4436a3783c1f74baa85be31bed12b09c3	795
44	0000000000000000010bac348f1a42f4b4d7893dc442192dbc6bd2291489d319	920
45	000000000000000002513ac5550c6cf9390eb51bf13d15998a5e08a8b7329a61	1087
46	000000000000000000b9ec8a3c12855d32877c5229c872020c6d01c0ca062c48	1665
47	00000000000000000682166b9e3b01f95c78611641a03a9da93afd93672cbd9c	2474
48	000000000000000004f4efc1b47d641ef86ba319518dc70b56676c09651069a3	1806
49	00000000000000000346b53b7329633296081e671d7b82fe7022ea1c91363742	781
50	0000000000000000011fcf666a9cda6b23d510355131752c6de520d577515e31	337
51	0000000000000000053748287205ab124752e24d63249575ac16bc54b201e02a	1656
52	000000000000000000ede71f605d31b319794f165da3f3c328f57d9ae2827949	107
53	000000000000000003885c270a8d1eb429c1b84fed09f78d3577650a60e7f3aa	1090
54	0000000000000000060a4b07df37aa23328c9f172f82183e3d990d6dbf314b57	824
55	0000000000000000056ea4cbba96b4280ceb6a08905a79a4b570fdbfaa72ff64	710
56	000000000000000000428971e7277e9c817a135ea734553f986e5db7a35f71e5	596
57	000000000000000003bcc021827da972f3930c800236e46bb9e00e6652c9c680	104
58	000000000000000000c4002e8a3a91cfffb5ff41403d49b2e492495f957aaa42	121
59	00000000000000000025ec5be50dcb9d22e830c37f2f249fb43eb0e714f64450	2114
60	000000000000000001c2419647fce4e9fee043d6b3231f5a5c4240266e1dc931	199
61	000000000000000003d385cb5ff268bf329b9a6ee4f92d8ab6917133277a66d0	485
62	00000000000000000354eec4e246a626ce789321565167a8c9d830d63955d960	915
63	0000000000000000033607cf32ef85be166f9ac0fa1543d9dc978d3ce3c79546	1651
64	0000000000000000029d355644a66a4aa75eb1a09c5d2c398b2cc0819a5e407b	1
65	0000000000000000010fd2ea6b422b56b364eb972fc12c735805712daace4f56	92
66	0000000000000000061f1bf7e79fa34f25995f0579fc33e28112421a10076197	736
67	0000000000000000030ed33efe6ed8db08322212fb11d855f71580151885c29d	1
68	0000000000000000050cd1f24091454b2149185ed2afda2e2a4f337773cd1a3a	190
69	00000000000000000572df3e7fe1d9d3f9a036f99c077a5b678674bd84e556a6	812
70	000000000000000003c7de5e76d7a6673d4c658e4deff841c4ca97efa880a3f6	1841
71	000000000000000001006ad8784b217bf313ee7a809b4ee1d88fc42f51131e99	86
72	000000000000000006521a3f88ccd873c9c46485fe43fcd2bc6119f57e11fbc0	483
73	000000000000000004334a5a534a74546adee787faac76a4b128507e1e60a3b0	1047
74	0000000000000000047f57bfe00280b96413f84554d1e9eb1470a126ebf2fbfb	1743
75	000000000000000004812a1ba9c2e324c793b77d58d4ba367711dbb28a292f36	2098
76	00000000000000000126ea2b89f9f166598f48e5ece1901da1c6079235905fe9	2979
77	0000000000000000024f45a9067d84707d2d664caff430abb1f779e3192ff844	1
78	000000000000000005617499f65b746c25a8374fdede37f8bee12354bb28e8d5	1111
79	0000000000000000032b25db5c28e28ec54e356efc0b8d8742a661f2835d0f76	1050
80	00000000000000000290d0a710715a535307136041f7f6f1489aedc537900662	870
81	00000000000000000453c55edb50aa1e54aebaa8a313c1286b3be6aaed678e7f	925
82	00000000000000000107e56d58b7c3a37fd34122a4cea9b2b1db6cbaec89336d	892
83	0000000000000000059cc32b5f8f0d17082ac5812a5c32107c10e206f86f60ce	1315
84	00000000000000000570fd043023c3aebf5b3df555b78868c72da07f7c29953f	677
85	0000000000000000001328aa50adee30495a972250164358292e19ee6e070178	1067
86	000000000000000004e78edf50c8bbd0b228f43d1b8ad68dad159990ecdf2ac0	770
87	0000000000000000039addceb99cf03dba57d686702ea5d278dd6e15c71d3d60	1
88	000000000000000004d9aeb98c268e4334e63c2c00e2e26040f92c797ba395db	1298
89	0000000000000000006ead91c2b72a288d2e74cff3a57a3267b032807e197efa	1915
90	0000000000000000045728783d13ed54c04023d8b207c2f40c068c2cd65f95dc	2145
91	0000000000000000044043899d43a7c2fe978190273bf71a9c6459518c025e14	800
92	000000000000000000f865860a0cfce239c777c5806ad90ad65894979d27e2a8	2032
93	0000000000000000054bd8d84f8fd4a2f9b36e38915b417ea4b68c095a9de937	2600
94	00000000000000000245f4d7cc7f8ce326589fe6923716aae45fe727cf2e7332	2753
95	0000000000000000038fd7522fa59779c5b97fe6f7d19d403a4a44b2ad92a486	2237
96	0000000000000000005d9e3963407b55a35f3f74cdb304a694ce1662c64d799f	2268
97	00000000000000000279e4d49e554d4d983c98836c57244af548cee047ef8463	839
98	0000000000000000002f57989af1faf85e133c29632abda048f57c8d087b186f	1309
99	000000000000000004473af7b8e20234e7e1c2a57343b18ac46f99c2476ab683	1083
100	000000000000000002f34c2fd8aec65eb824ba6cc46071c4a92130d0bc827533	1281
101	0000000000000000024e1abe0c7781c44c39d209fc4ad2bd725a3a75b296f3f9	1525
102	000000000000000001cbd3e68b3e1c2355d168524a2b19b21cfe9e2a56674cdd	1996
103	000000000000000000c0f1881de1659e05aac0613bf0ae981fc3801cc17b313b	1112
104	0000000000000000037136ff27371ccf2b2b256bc435e1961f1dece0ee8eed5b	1138
105	000000000000000005471b249fa2257d5a422d0c3824b66577f4643237cdd76b	1441
106	000000000000000006007d85c3c046778418e28d20b57f7208819b7d24cf198d	1272
107	000000000000000002dd6e9ac62a76c48ed09a154f7302eaaff96bf077668822	840
108	000000000000000002a68da91d23ee32a5533890ab469995e886c963552c1845	2021
109	000000000000000001414570048407c3fbc97f37716ae90ec19e065390decc40	2158
110	0000000000000000034952991b8a1c76390d28dda75a3a8805f7d97a0fa13546	2580
111	000000000000000000cbd559932a3c2ab264b845af69e6dd6f73cc0b62f97362	1989
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

SELECT pg_catalog.setval('"Block_block_id_seq"', 112, true);


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

