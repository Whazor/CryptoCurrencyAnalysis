import java.util.List;
import java.util.concurrent.ExecutionException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.bitcoinj.core.Block;
import org.bitcoinj.core.BlockChain;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Peer;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.kits.WalletAppKit;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.store.BlockStore;
import org.bitcoinj.store.BlockStoreException;
import org.bitcoinj.utils.BriefLogFormatter;

import com.google.common.util.concurrent.Service;

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

        String url = "jdbc:postgresql://localhost/bitcoin?user=bitcoin&password=a"; // user=fred&password=secret&ssl=true
        Connection conn = DriverManager.getConnection(url);


        PreparedStatement blockStmt = conn.prepareStatement("INSERT INTO \"Block\" (\"block_id\", \"hashMerkleRoot\", txn_counter) VALUES (?, ?, ?)");
        PreparedStatement blockHeaderStmt = conn.prepareStatement("INSERT INTO \"public\".\"BlockHeader\" (\"id\", \"nVersion\", \"hashPrevBlock\", \"hashMerkleRoot\", \"nTime\", \"nBits\", \"nonce\") \n" +
                "VALUES (?, ?, ?, ?, ?, ?, ?);");
        int id = 50000;

        addBlock(id, blockStmt, b);
        addBlockHeader(id, b, blockHeaderStmt);
        for (int i = 0; i < 100; i++) {
            b = peer.getBlock(b.getPrevBlockHash()).get();
            id--;
            addBlock(id, blockStmt, b);
            addBlockHeader(id, b, blockHeaderStmt);

            if(i % 1000 == 0) {
                blockStmt.executeBatch();
                blockHeaderStmt.executeBatch();
                blockStmt.clearBatch();
                blockHeaderStmt.clearBatch();
            }
        }
        blockStmt.executeBatch();
        blockHeaderStmt.executeBatch();

    }

    private static void addBlockHeader(int id, Block b, PreparedStatement blockHeaderStmt) throws SQLException {
        blockHeaderStmt.setInt(1, id);
        blockHeaderStmt.setInt(2, (int) b.getVersion());
        blockHeaderStmt.setString(3, b.getPrevBlockHash().toString());
        blockHeaderStmt.setString(4, b.getHashAsString());
        blockHeaderStmt.setTimestamp(5, new Timestamp(b.getTimeSeconds()));
        blockHeaderStmt.setLong(6, b.getDifficultyTarget());
        blockHeaderStmt.setLong(7, b.getNonce());
        blockHeaderStmt.addBatch();
    }

    private static void addBlock(int id, PreparedStatement statement, Block b) throws SQLException {
        statement.setInt(1, id);
        statement.setString(2, b.getHashAsString());
        int size = getSize(b);
        statement.setInt(3, size);
        statement.addBatch();
    }

    private static int getSize(Block b) {
        List<Transaction> list = b.getTransactions();
        return list == null ? 0 : list.size();
    }
}
