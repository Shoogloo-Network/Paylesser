//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.pl.products.utilities;

import org.apache.solr.client.solrj.response.QueryResponse;

public class SearchResponse {
    private String relatedSearch;
    private QueryResponse response;

    public SearchResponse() {
    }

    public String getRelatedSearch() {
        return this.relatedSearch;
    }

    public void setRelatedSearch(String relatedSearch) {
        this.relatedSearch = relatedSearch;
    }

    public QueryResponse getResponse() {
        return this.response;
    }

    public void setResponse(QueryResponse response) {
        this.response = response;
    }
}
