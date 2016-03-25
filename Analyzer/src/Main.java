import org.apache.flink.api.common.ExecutionConfig;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.functions.RichFilterFunction;
import org.apache.flink.api.common.typeinfo.BasicTypeInfo;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.operators.DataSink;
import org.apache.flink.api.java.operators.MapOperator;
import org.apache.flink.graph.*;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.io.jdbc.JDBCInputFormat;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.tuple.Tuple3;
import org.apache.flink.api.java.typeutils.TupleTypeInfo;
import org.apache.flink.types.NullValue;
import org.apache.flink.graph.Graph;
import org.apache.flink.util.Collector;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

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

        DataSet<Tuple2<String, String>> data =
                env.createInput(
                        JDBCInputFormat.buildJDBCInputFormat()
                                .setDrivername("org.postgresql.Driver")
                                .setDBUrl("jdbc:postgresql://localhost/bitcoin")
                                .setUsername("bitcoin")
                                .setPassword("a")
                                .setQuery("select \"TxnOut\".address, \"TxnIn\".address\n" +
                                        "from \"TxnIn\"\n" +
                                        "iNNER JOIN \"TxnOut\" USING (txn_id)")
                                .finish(),
                        new TupleTypeInfo(Tuple2.class, BasicTypeInfo.STRING_TYPE_INFO, BasicTypeInfo.STRING_TYPE_INFO)
                );


        DataSet<Vertex<String, NullValue>> vertices = data.flatMap(new FlatMapFunction<Tuple2<String, String>, String>() {
            @Override
            public void flatMap(Tuple2<String, String> tup, Collector<String> collector) throws Exception {
                collector.collect(tup.f0);
                collector.collect(tup.f1);
            }
        }).map(new MapFunction<String, Vertex<String, NullValue>>() {
            @Override
            public Vertex<String, NullValue> map(String s) throws Exception {
                return new Vertex<>(s, NullValue.getInstance());
            }
        })

        DataSet<Edge<String, NullValue>> edges = data.map(new MapFunction<Tuple2<String, String>, Edge<String, NullValue>>() {
            @Override
            public Edge<String, NullValue> map(Tuple2<String, String> tup) throws Exception {
                return new Edge<>(tup.f0, tup.f1, NullValue.getInstance());
            }
        });

        Graph<String, NullValue, NullValue> graph = Graph.fromDataSet(vertices, edges, env);

        MapOperator<Edge<String, NullValue>, String> map = edges.map(new MapFunction<Edge<String, NullValue>, String>() {
            @Override
            public String map(Edge<String, NullValue> ed) throws Exception {
                return ed.getSource() + " -> " + ed.getTarget();
            }
        });
        map.writeAsText("file:///Users/nanne/Projects/School/CryptoCurrencyAnalysis/out/result.dot");
        env.execute();
    }
}
