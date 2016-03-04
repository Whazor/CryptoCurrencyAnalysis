import com.google.common.util.concurrent.Service;
import org.bitcoinj.core.*;
import org.bitcoinj.kits.WalletAppKit;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.store.BlockStore;
import org.bitcoinj.store.BlockStoreException;
import org.bitcoinj.utils.BriefLogFormatter;

import java.sql.*;

import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

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

        String url = "jdbc:postgresql://localhost/bitcoin"; // user=fred&password=secret&ssl=true
        Connection conn = DriverManager.getConnection(url);


        PreparedStatement statement = conn.prepareStatement("INSERT INTO \"Block\" (\"hashMerkleRoot\", txn_counter) VALUES (?, ?)");

        addBlock(b, statement);
        for (int i = 0; i < 1000; i++) {
            b = peer.getBlock(b.getPrevBlockHash()).get();
            addBlock(b, statement);
        }
        statement.executeBatch();
    }

    private static void addBlock(Block b, PreparedStatement statement) throws SQLException {
        statement.setString(1, b.getHashAsString());
        int size = getSize(b);
        statement.setInt(2, size);
        statement.execute();
        statement.addBatch();
    }

    private static int getSize(Block b) {
        List<Transaction> list = b.getTransactions();
        return list == null ? 0 : list.size();
    }
}
