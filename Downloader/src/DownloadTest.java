import java.util.concurrent.ExecutionException;

import org.bitcoinj.core.Block;
import org.bitcoinj.core.BlockChain;
import org.bitcoinj.core.Coin;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Peer;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.core.TransactionConfidence;
import org.bitcoinj.core.TransactionOutput;
import org.bitcoinj.kits.WalletAppKit;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.store.BlockStore;
import org.bitcoinj.store.BlockStoreException;
import org.bitcoinj.utils.BriefLogFormatter;

import com.google.common.util.concurrent.Service;

/**
 * Created by martijn on 2016/03/04.
 */
public class DownloadTest {
	
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

        for (int i = 0; i < 1; i++) {
            b = peer.getBlock(b.getPrevBlockHash()).get();
            System.out.println(b.getTime());
            for (Transaction t : b.getTransactions()) {
            	Coin totalOutputValue = Coin.ZERO;
            	for (TransactionOutput output : t.getOutputs()) {
            		Coin value = output.getValue();
            		if (value != null) {
            			totalOutputValue = totalOutputValue.add(value);
            		}
            	}
            	System.out.println("Output: " + coinToString(totalOutputValue));
            	System.out.println(confidenceToString(t.getConfidence()));
            	//System.out.println("Fee: " + coinToString(t.getFee()));
            }
            System.out.println(b.getHashAsString());
        }
    }
    
    public static String coinToString(Coin coin) {
    	if (coin == null) {
    		return "null";
    	}
    	return ""+(coin.getValue()*Coin.SATOSHI.getValue()/((double) Coin.COIN.getValue()));
    }
    
    public static String confidenceToString(TransactionConfidence confidence) {
    	if (confidence == null) {
    		return "null";
    	}
    	return ""+confidence.getDepthInBlocks();
    }
    
}
