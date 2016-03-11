import com.google.common.util.concurrent.Service;
import jooq.database.tables.records.BlockRecord;
import jooq.database.tables.records.TxnRecord;
import jooq.database.tables.records.TxninRecord;
import jooq.database.tables.records.TxnoutRecord;
import org.bitcoinj.core.*;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.kits.WalletAppKit;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.store.BlockStore;
import org.bitcoinj.store.BlockStoreException;
import org.bitcoinj.utils.BriefLogFormatter;
import org.jooq.*;
import org.jooq.impl.DSL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import static jooq.database.Tables.*;

/**
 * Created by nanne on 26/02/16.
 */
public class Download {
    public static void main(String[] args) throws BlockStoreException, ExecutionException, InterruptedException, ClassNotFoundException, SQLException {

        BriefLogFormatter.init();

        NetworkParameters params = MainNetParams.get();


        WalletAppKit kit = new WalletAppKit(MainNetParams.get(), new java.io.File("."), "test");
        Service service = kit.startAsync();
        service.awaitRunning();


        BlockChain chain = kit.chain();
        BlockStore bs = chain.getBlockStore();
        Peer peer = kit.peerGroup().getDownloadPeer();
        Block b = peer.getBlock(bs.getChainHead().getHeader().getHash()).get();

        Class.forName("org.postgresql.Driver");

        String url = "jdbc:postgresql://localhost/bitcoin";

        try (Connection conn = DriverManager.getConnection(url, "bitcoin", "a")) { //user en pass bitcoin&password=a
            DSLContext create = DSL.using(conn, SQLDialect.POSTGRES_9_5);

            for (int i = 0; i < 100; i++) {
                Result<BlockRecord> fetch = create.insertInto(BLOCK, BLOCK.HASHMERKLEROOT, BLOCK.TXN_COUNTER)
                        .values("blasad", 2)
                        .returning(BLOCK.BLOCK_ID)
                        .fetch();
                Integer block_id = fetch.get(0).getValue(BLOCK.BLOCK_ID);

                create.insertInto(BLOCKHEADER,
                        BLOCKHEADER.ID,
                        BLOCKHEADER.NVERSION,
                        BLOCKHEADER.HASHPREVBLOCK,
                        BLOCKHEADER.HASHMERKLEROOT,
                        BLOCKHEADER.NTIME,
                        BLOCKHEADER.NBITS,
                        BLOCKHEADER.NONCE
                ).values(block_id,
                        (short)b.getVersion(),
                        b.getPrevBlockHash().toString(),
                        b.getHashAsString(),
                        new Timestamp(b.getTimeSeconds()),
                        b.getDifficultyTarget(),
                        b.getNonce());


                InsertValuesStep5<TxnRecord, Short, Short, Short, Timestamp, Integer> into = create.insertInto(
                        TXN, TXN.NVERSION, TXN.INCOUNTER, TXN.OUTCOUNTER, TXN.LOCK_TIME, TXN.BLOCK_ID);

                List<Transaction> list = b.getTransactions();
                assert list != null;


                for (Transaction t : list) {
                    Result<TxnRecord> result = into.values((short) t.getVersion(), (short) t.getInputs().size(), (short) t.getOutputs().size(), new Timestamp(t.getLockTime()), block_id)
                            .returning(TXN.TXN_ID)
                            .fetch();
                    Integer txn_id = result.get(0).getValue(TXN.TXN_ID);

                    InsertValuesStep4<TxnoutRecord, Long, Short, String, Integer> insert_txout = create.insertInto(
                            TXNOUT, TXNOUT.VALUE, TXNOUT.SCRIPTLEN, TXNOUT.SCRIPTPUBKEY, TXNOUT.TXN_ID);

                    Map<TransactionOutput, Integer> map = new HashMap<>();
                    for (TransactionOutput tout : t.getOutputs()) {
                        Integer txnId = insert_txout.values(tout.getValue().getValue(),
                                (short) tout.getScriptBytes().length,
                                tout.getScriptPubKey().toString(),
                                txn_id).returning(TXNOUT.ID).fetchOne().getTxnId();
                        map.put(tout, txnId);
                    }

                    InsertValuesStep6<TxninRecord, String, Integer, Short, String, Short, Integer> insert_txin = create.insertInto(
                            TXNIN, TXNIN.HASHPREVTXN, TXNIN.TXNOUT_ID, TXNIN.SCRIPTLEN, TXNIN.SCRIPTSIG, TXNIN.SEQNO, TXNIN.TXN_ID);

                    String prev = "";
                    for (TransactionInput tin : t.getInputs()) {
                        TransactionOutput output = tin.getConnectedOutput();
                        Integer txnOut_id = map.get(output);

                        insert_txin.values(prev, txnOut_id, (short)tin.getScriptBytes().length, tin.getScriptSig().toString(), (short)tin.getSequenceNumber(), txn_id);
                        prev = tin.getHash().toString();
                    }
                }


                b = peer.getBlock(b.getPrevBlockHash()).get();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

//        PreparedStatement blockStmt = conn.prepareStatement("INSERT INTO \"Block\" (\"block_id\", \"hashMerkleRoot\", txn_counter) VALUES (?, ?, ?)");
//        PreparedStatement blockHeaderStmt = conn.prepareStatement("INSERT INTO \"public\".\"BlockHeader\" (\"id\", \"nVersion\", \"hashPrevBlock\", \"hashMerkleRoot\", \"nTime\", \"nBits\", \"nonce\") \n" +
//                "VALUES (?, ?, ?, ?, ?, ?, ?);");
//        PreparedStatement Stmt = conn.prepareStatement("INSERT INTO \"public\".\"Txn\" (\"txn_id\", \"nVersion\", \"inCounter\", \"outCounter\", \"lock_time\", \"block_id\") \n" +
//                "VALUES (?, ?, ?, ?, ?, ?)");
//        int id = 50000;
//

//        addBlock(id, blockStmt, b);
//        addBlockHeader(id, b, blockHeaderStmt);
//        System.out.println(b.getHashAsString());
//        for (int i = 0; i < 100; i++) {
//            b = peer.getBlock(b.getPrevBlockHash()).get();
//            System.out.println(b.getHashAsString());
//            id--;
//            addBlock(id, blockStmt, b);
//            addBlockHeader(id, b, blockHeaderStmt);
//
//            if(i % 1000 == 0) {
//                blockStmt.executeBatch();
//                blockHeaderStmt.executeBatch();
//                blockStmt.clearBatch();
//                blockHeaderStmt.clearBatch();
//            }
//        }
//        blockStmt.executeBatch();
//        blockHeaderStmt.executeBatch();

    }
//    private static void addTx(int id, ){
//
//    }

    private static int getSize(Block b) {
        List<Transaction> list = b.getTransactions();
        return list == null ? 0 : list.size();
    }
}
