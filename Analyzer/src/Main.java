import org.apache.flink.api.common.ExecutionConfig;
import org.apache.flink.api.common.typeinfo.BasicTypeInfo;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.io.jdbc.JDBCInputFormat;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.tuple.Tuple3;
import org.apache.flink.api.java.typeutils.TupleTypeInfo;

/**
 * Created by s158079 on 11/03/2016.
 */
public class Main {

    public static void main (String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        ExecutionConfig executionConfig = env.getConfig();
        org.apache.log4j.BasicConfigurator.configure();
        Class.forName("org.postgresql.Driver");
        // Read data from a relational database using the JDBC input format
        DataSet<Tuple2<Integer, Integer>> dbData =
                env.createInput(
                        JDBCInputFormat.buildJDBCInputFormat()
                                .setDrivername("org.postgresql.Driver")
                                .setDBUrl("jdbc:postgresql://localhost/bitcoin")
                                .setUsername("bitcoin")
                                .setPassword("a")
                                .setQuery("SELECT \"TxnOut\".id, \"TxnIn\".id\n" +
                                        "FROM \"TxnIn\"\n" +
                                        "INNER JOIN \"TxnOut\"\n" +
                                        "ON \"TxnOut\".txn_id = \"TxnIn\".txn_id limit 50")
                                .finish(),
                        new TupleTypeInfo(Tuple2.class, BasicTypeInfo.INT_TYPE_INFO, BasicTypeInfo.INT_TYPE_INFO)
                );
        dbData.print();

    }
}
