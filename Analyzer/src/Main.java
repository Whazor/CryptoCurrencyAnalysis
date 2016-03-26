import org.apache.flink.api.common.ExecutionConfig;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.typeinfo.BasicTypeInfo;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.io.jdbc.JDBCInputFormat;
import org.apache.flink.api.java.operators.MapOperator;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.tuple.Tuple3;
import org.apache.flink.api.java.typeutils.TupleTypeInfo;
import org.apache.flink.graph.Edge;
import org.apache.flink.graph.Graph;
import org.apache.flink.graph.Vertex;
import org.apache.flink.types.NullValue;
import org.apache.flink.util.Collector;

/**
 * Created by s158079 on 11/03/2016.
 */
@SuppressWarnings("unchecked")
public class Main {

    public static void main (String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        ExecutionConfig executionConfig = env.getConfig();
        org.apache.log4j.BasicConfigurator.configure();
        Class.forName("org.postgresql.Driver");
        // Read data from a relational database using the JDBC input format

        DataSet<Tuple3<String, String, Integer>> data =
                env.createInput(
                        JDBCInputFormat.buildJDBCInputFormat()
                                .setDrivername("org.postgresql.Driver")
                                .setDBUrl("jdbc:postgresql://localhost/bitcoin")
                                .setUsername("bitcoin")
                                .setPassword("a")
                                .setQuery("select \"TxnOut\".address, \"TxnIn\".address, extract(epoch from \"BlockHeader\".\"nTime\")\n" +
                                        "from \"TxnIn\"\n" +
                                        "INNER JOIN \"TxnOut\" USING (txn_id)\n" +
                                        "INNER JOIN \"Txn\" ON txn_id = \"Txn\".id\n" +
                                        "INNER JOIN \"BlockHeader\" ON \"Txn\".block_id = \"BlockHeader\".id")
                                .finish(),
                        new TupleTypeInfo(Tuple2.class, BasicTypeInfo.STRING_TYPE_INFO, BasicTypeInfo.STRING_TYPE_INFO, BasicTypeInfo.INT_TYPE_INFO)
                );



        DataSet<Vertex<String, NullValue>> vertices = data.flatMap(new FlatMapFunction<Tuple3<String, String, Integer>, String>() {
            @Override
            public void flatMap(Tuple3<String, String, Integer> tup, Collector<String> collector) throws Exception {
                collector.collect(tup.f0);
                collector.collect(tup.f1);
            }
        }).map(new MapFunction<String, Vertex<String, NullValue>>() {
            @Override
            public Vertex<String, NullValue> map(String s) throws Exception {
                return new Vertex<>(s, NullValue.getInstance());
            }
        });

        DataSet<Edge<String, Integer>> edges = data.map(new MapFunction<Tuple3<String, String, Integer>, Edge<String, Integer>>() {
            @Override
            public Edge<String, Integer> map(Tuple3<String, String, Integer> tup) throws Exception {
                return new Edge<>(tup.f0, tup.f1, tup.f2);
            }
        });

        Graph<String, NullValue, Integer> set = Graph.fromDataSet(vertices, edges, env);


        MapOperator<Edge<String, Integer>, String> map = edges.map(new MapFunction<Edge<String, Integer>, String>() {
            @Override
            public String map(Edge<String, Integer> ed) throws Exception {
                return ed.getSource().hashCode() + " -> " + ed.getTarget().hashCode();
            }
        });
        map.writeAsText("file:///Users/nanne/Projects/School/CryptoCurrencyAnalysis/out/result.dot");
        env.execute();
    }
}
