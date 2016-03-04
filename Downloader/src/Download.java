import com.google.common.util.concurrent.Service;
import org.bitcoinj.core.Block;
import org.bitcoinj.core.BlockChain;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Peer;
import org.bitcoinj.kits.WalletAppKit;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.store.BlockStore;
import org.bitcoinj.store.BlockStoreException;
import org.bitcoinj.utils.BriefLogFormatter;

import java.sql.*;

import java.util.concurrent.ExecutionException;

/**
 * Created by nanne on 26/02/16.
 */
public class Download {
    public static void main(String[] args) throws BlockStoreException, ExecutionException, InterruptedException {

        BriefLogFormatter.init();

        NetworkParameters params = MainNetParams.get();


        WalletAppKit kit = new WalletAppKit(MainNetParams.get(), new java.io.File("."), "test");
        Service service = kit.startAsync();
        service.awaitRunning();


        BlockChain chain = kit.chain();
        BlockStore bs = chain.getBlockStore();
        Peer peer = kit.peerGroup().getDownloadPeer();
        Block b = peer.getBlock(bs.getChainHead().getHeader().getHash()).get();



        b.getTime();

        for (int i = 0; i < 1000; i++) {
            b = peer.getBlock(b.getPrevBlockHash()).get(0).getTransactions().get(0).getExchangeRate();

//            b.getTransactions().get(0)
            System.out.println(b.getHashAsString());
        }
    }
}
