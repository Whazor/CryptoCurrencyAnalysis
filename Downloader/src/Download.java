import com.google.common.util.concurrent.Service;
import jooq.database.tables.records.*;
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
import java.util.Arrays;
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
                try {
					Result<BlockRecord> fetch = create.insertInto(BLOCK, BLOCK.HASHMERKLEROOT, BLOCK.TXN_COUNTER)
							.values(b.getHashAsString(), b.getTransactions().size())
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
							new Timestamp(b.getTimeSeconds() * 1000),
							b.getDifficultyTarget(),
							b.getNonce()).execute();


//					InsertValuesStep5<TxnRecord, Short, Short, Short, Timestamp, Integer> into = create.insertInto(
//							TXN, TXN.NVERSION, TXN.INCOUNTER, TXN.OUTCOUNTER, TXN.LOCK_TIME, TXN.BLOCK_ID);

					List<Transaction> list = b.getTransactions();
					assert list != null;


					for (Transaction t : list) {
						Integer txn_id = create.insertInto(TXN, TXN.HASH, TXN.BLOCK_ID).values(t.getHashAsString(), block_id)
								.returning(TXN.ID)
								.fetchOne().getValue(TXN.ID);

						for (TransactionInput tin : t.getInputs()) {
							try {
								String from = tin.getFromAddress().toString();
								create.insertInto(TXNIN, TXNIN.TXN_ID, TXNIN.ADDRESS).values(txn_id, from).execute();
							} catch (ScriptException ignored) {}
						}

						for (TransactionOutput tout : t.getOutputs()) {
							Address address = tout.getAddressFromP2PKHScript(params);

							if(address != null) {
								String to = address.toString();
								create.insertInto(TXNOUT, TXNOUT.TXN_ID, TXNOUT.ADDRESS).values(txn_id, to).execute();
							}

//									InsertValuesStep3<TransactionRecord, String, String, Integer> insertInto = create.insertInto(TRANSACTION, TRANSACTION.FROM_ADDRESS, TRANSACTION.TO_ADDRESS, TRANSACTION.BLOCK_ID);
//									insertInto.values(from, to, block_id).execute();
						}

					}
				} catch (Exception e) {
					e.printStackTrace();
				}

                b = peer.getBlock(b.getPrevBlockHash()).get();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
