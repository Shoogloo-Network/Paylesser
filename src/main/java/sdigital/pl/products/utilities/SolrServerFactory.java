//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.pl.products.utilities;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.impl.HttpSolrClient;

public class SolrServerFactory {
    Map<String, SolrClient> urlToServer = new ConcurrentHashMap();
    static SolrServerFactory instance = new SolrServerFactory();

    public static SolrServerFactory getInstance() {
        return instance;
    }

    private SolrServerFactory() {
    }

    public SolrClient getServer(String solrURL) {
        if (this.urlToServer.containsKey(solrURL)) {
            return (SolrClient)this.urlToServer.get(solrURL);
        } else {
            SolrClient server = new HttpSolrClient.Builder(solrURL).build();
            this.urlToServer.put(solrURL, server);
            return server;
        }
    }
}
