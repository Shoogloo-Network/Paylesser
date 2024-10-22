//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.pl.products.utilities;

import info.debatty.java.stringsimilarity.Levenshtein;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.request.UpdateRequest;
import org.apache.solr.client.solrj.request.AbstractUpdateRequest.ACTION;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.response.SpellCheckResponse;
import org.apache.solr.client.solrj.response.SuggesterResponse;
import org.apache.solr.client.solrj.response.Suggestion;
import org.apache.solr.client.solrj.response.TermsResponse;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.SolrInputDocument;
import org.jsoup.Jsoup;
import sdigital.pl.products.domains.Product;
import sdigital.vcpublic.config.SystemConstant;
import sdigital.vcpublic.home.VcHome;

public class SolrDao<T> {
    HttpSolrClient server = null;
    private static final Logger logger = Logger.getLogger(SolrDao.class.getName());

    public SolrDao(String domainId) {
        VcHome home = VcHome.instance();
        this.server = VcHome.getSolr(domainId);
        if (this.server == null) {
            String solrURL = home.getsolrUrl(domainId);

            try {
                this.server = (HttpSolrClient)SolrServerFactory.getInstance().getServer(solrURL);
                this.configureSolr(this.server);
                this.server.ping();
                VcHome.setSolr(domainId, this.server);
            } catch (Exception var5) {
                home.setThemeType(domainId, "COUPON");
            }
        }

    }

    public void put(T dao) {
        this.put(this.createSingletonSet(dao));
    }

    public void put(Collection<T> dao) {
        try {
            UpdateResponse rsp = this.server.addBeans(dao);
            PrintStream var10000 = System.out;
            long var10001 = rsp.getElapsedTime();
            var10000.println("Added documents to solr. Time taken = " + var10001 + ". " + rsp.toString());
        } catch (SolrServerException var3) {
             var3 = var3;
            var3.printStackTrace();
        } catch (IOException var4) {
             var4 = var4;
            var4.printStackTrace();
        }

    }

    public void putDoc(SolrInputDocument doc) {
        this.putDoc(this.createSingletonSet(doc));
    }

    public void putDoc(Collection<SolrInputDocument> docs) {
        try {
            long startTime = System.currentTimeMillis();
            UpdateRequest req = new UpdateRequest();
            req.setAction(ACTION.COMMIT, false, false);
            req.add(docs);
            UpdateResponse rsp = (UpdateResponse)req.process(this.server);
            PrintStream var10000 = System.out;
            long var10001 = rsp.getElapsedTime();
            var10000.print("Added documents to solr. Time taken = " + var10001 + ". " + rsp.toString());
            long endTime = System.currentTimeMillis();
            System.out.println(" , time-taken=" + (double)(endTime - startTime) / 1000.0 + " seconds");
        } catch (SolrServerException var8) {
             var8 = var8;
            var8.printStackTrace();
        } catch (IOException var9) {
             var9 = var9;
            var9.printStackTrace();
        }

    }

    public QueryResponse readAll() {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addSort("price", ORDER.asc);
        query.addFacetField(new String[]{"categorypath"});
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
        } catch (SolrServerException var4) {
             var4 = var4;
            var4.printStackTrace();
        } catch (IOException var5) {
             var5 = var5;
            var5.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readByBrandCategory(String queryString, String facetPrefix, String brandName, int page, long price_min, long price_max, String sort, String store) {
        SolrQuery query = new SolrQuery();
        if (price_max > 0L) {
            query.setQuery("price:[" + price_min + " TO " + price_max + "]");
        } else {
            query.setQuery("*:*");
        }

        query.addFilterQuery(new String[]{"categorypath:" + queryString});
        String[] var10001 = new String[1];
        String[] var10004 = brandName.split("\\|");
        var10001[0] = "manu_exact:\"" + var10004[0].trim() + "\"";
        query.addFilterQuery(var10001);
        if (store != null) {
            query.addFilterQuery(new String[]{"store:(" + store + ")"});
        }

        query.addFacetField(new String[]{"categorypath"});
        query.addFacetField(new String[]{"store"});
        query.setFacetPrefix(facetPrefix.toLowerCase());
        query.setStart((page - 1) * SystemConstant.RECORD_PER_PAGE + 1);
        query.setRows(SystemConstant.RECORD_PER_PAGE);
        query.addGetFieldStatistics(new String[]{"price"});
        if (sort != null) {
            String[] temp = sort.split("_");
            if (!"rel".equals(temp[0])) {
                query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
            }
        }

        query.addSort("random_123", SolrUtils.getSortOrder("asc"));
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var14) {
             var14 = var14;
            var14.printStackTrace();
        } catch (IOException var15) {
             var15 = var15;
            var15.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readByCategory(String queryString, String facetPrefix, int page, long price_min, long price_max, String sort, String store) {
        SolrQuery query = new SolrQuery();
        if (price_max > 0L) {
            if (queryString.contains("women")) {
                query.setQuery("price:[" + price_min + " TO " + price_max + "] -men");
            } else if (queryString.contains("men")) {
                query.setQuery("price:[" + price_min + " TO " + price_max + "] -women");
            } else {
                query.setQuery("price:[" + price_min + " TO " + price_max + "]");
            }
        } else if (queryString.contains("women")) {
            query.setQuery("-men");
        } else if (queryString.contains("men")) {
            query.setQuery("-women");
        } else {
            query.setQuery("*:*");
        }

        query.addFilterQuery(new String[]{"categorypath:" + queryString});
        if (store != null) {
            query.addFilterQuery(new String[]{"store:(" + store + ")"});
        }

        query.addFacetField(new String[]{"categorypath"});
        query.setFacetPrefix(facetPrefix.toLowerCase());
        query.setStart((page - 1) * SystemConstant.RECORD_PER_PAGE + 1);
        query.setRows(SystemConstant.RECORD_PER_PAGE);
        query.addGetFieldStatistics(new String[]{"price"});
        if (sort != null && !"rel".equals(sort)) {
            String[] temp = sort.split("_");
            if (!"rel".equals(temp[0])) {
                query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
            }
        }

        query.addSort("random_123", SolrUtils.getSortOrder("asc"));
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var13) {
             var13 = var13;
            var13.printStackTrace();
        } catch (IOException var14) {
             var14 = var14;
            var14.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readByBrand(String brandName, int page, long price_min, long price_max, String sort, String store) {
        SolrQuery query = new SolrQuery();
        if (price_max > 0L) {
            query.setQuery("price:[" + price_min + " TO " + price_max + "]");
        } else {
            query.setQuery("*:*");
        }

        query.addFilterQuery(new String[]{"manu_exact:\"" + brandName + "\""});
        if (store != null) {
            query.addFilterQuery(new String[]{"store:(" + store + ")"});
        }

        query.addFacetField(new String[]{"categorypath"});
        query.addFacetField(new String[]{"store"});
        query.setStart((page - 1) * SystemConstant.RECORD_PER_PAGE + 1);
        query.setRows(SystemConstant.RECORD_PER_PAGE);
        query.addGetFieldStatistics(new String[]{"price"});
        if (sort != null && !"rel".equals(sort)) {
            String[] temp = sort.split("_");
            if (!"rel".equals(temp[0])) {
                query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
            }
        }

        query.addSort("random_123", SolrUtils.getSortOrder("asc"));
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var12) {
             var12 = var12;
            var12.printStackTrace();
        } catch (IOException var13) {
             var13 = var13;
            var13.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readByBrandWithBrand(String brandName, long price_min, long price_max, String sort, String store) {
        SolrQuery query = new SolrQuery();
        if (price_max > 0L) {
            query.setQuery("price:[" + price_min + " TO " + price_max + "]");
        } else {
            query.setQuery("*:*");
        }

        query.addFilterQuery(new String[]{"manu_exact:\"" + brandName + "\""});
        if (store != null) {
            query.addFilterQuery(new String[]{"store:(" + store + ")"});
        }

        query.addFacetField(new String[]{"manu_exact"});
        query.addFacetField(new String[]{"store"});
        query.addGetFieldStatistics(new String[]{"price"});
        if (sort != null && !"rel".equals(sort)) {
            String[] temp = sort.split("_");
            if (!"rel".equals(temp[0])) {
                query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
            }
        }

        query.addSort("random_123", SolrUtils.getSortOrder("asc"));
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var11) {
             var11 = var11;
            var11.printStackTrace();
        } catch (IOException var12) {
             var12 = var12;
            var12.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readByCategoryWithBrand(String queryString, long price_min, long price_max, String sort, String store) {
        SolrQuery query = new SolrQuery();
        if (price_max > 0L) {
            query.setQuery("price:[" + price_min + " TO " + price_max + "]");
        } else {
            query.setQuery("*:*");
        }

        query.addFilterQuery(new String[]{"categorypath:" + queryString});
        if (store != null) {
            query.addFilterQuery(new String[]{"store:(" + store + ")"});
        }

        query.addFacetField(new String[]{"manu_exact"});
        query.addFacetField(new String[]{"store"});
        query.addGetFieldStatistics(new String[]{"price"});
        if (sort != null && !"rel".equals(sort)) {
            String[] temp = sort.split("_");
            if (!"rel".equals(temp[0])) {
                query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
            }
        }

        query.addSort("random_123", SolrUtils.getSortOrder("asc"));
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (IOException var11) {
             var11 = var11;
            var11.printStackTrace();
        } catch (SolrServerException var12) {
             var12 = var12;
            var12.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readForPath(String queryString) {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addFilterQuery(new String[]{"categorypath:" + queryString});
        query.setRows(0);
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var5) {
             var5 = var5;
            var5.printStackTrace();
        } catch (IOException var6) {
             var6 = var6;
            var6.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readForBrand(String queryString) {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addFilterQuery(new String[]{"manu_exact:\"" + queryString + "\""});
        query.setRows(1);
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (SolrServerException var5) {
             var5 = var5;
            var5.printStackTrace();
        } catch (IOException var6) {
             var6 = var6;
            var6.printStackTrace();
        }

        return rsp;
    }

    public SearchResponse searchProductByName(String name, boolean exactReq, String queryString, String brandName, int page, long price_min, long price_max, String sort, String store) {
        name = Jsoup.parse(name).text();
        SearchResponse response = new SearchResponse();

        IOException rsp;
        try {
            if (!exactReq) {
                List<String> suggestions = this.doAutosuggestFacets(name, 10, (List)null);
                if (null != suggestions && !suggestions.contains(name)) {
                    Iterator var14 = suggestions.iterator();

                    while(var14.hasNext()) {
                        String rsp1 = (String)var14.next();
                        if (!rsp1.contains("in")) {
                            name = rsp1;
                            break;
                        }
                    }
                }
            }

            response.setRelatedSearch(name);
            String filterquery = "";
            if (null != name && !"".equals(name)) {
                if (name.contains(" in ")) {
                    String[] temp = name.split(" in ");
                    name = temp[0];
                    filterquery = temp[1];
                }

                name = "\"" + name + "\"~15";
            }

            SolrQuery query = new SolrQuery(name);
            query.setQuery(name);
            if (null != filterquery && !filterquery.equals("")) {
                query.setParam("fq", new String[]{"+category_exact:\"" + filterquery + "\""});
            }

            if (price_max > 0L) {
                if (name.toLowerCase().contains("women")) {
                    query.setQuery(name + " price:[" + price_min + " TO " + price_max + "] -men -Men");
                } else if (name.toLowerCase().contains("men")) {
                    query.setQuery(name + " price:[" + price_min + " TO " + price_max + "] -women -Women");
                } else {
                    query.setQuery(name + " price:[" + price_min + " TO " + price_max + "]");
                }
            } else if (name.toLowerCase().contains("women")) {
                query.setQuery(name + " -men -Men");
            } else if (name.toLowerCase().contains("men")) {
                query.setQuery(name + " -women Women");
            }

            if (brandName != null) {
                String[] var10001 = new String[1];
                String[] var10004 = brandName.split("\\|");
                var10001[0] = "manu_exact:\"" + var10004[0].trim() + "\"";
                query.addFilterQuery(var10001);
            }

            if (queryString != null) {
                query.addFilterQuery(new String[]{"categorypath:*" + queryString});
            }

            if (store != null) {
                query.addFilterQuery(new String[]{"store:(" + store + ")"});
            }

            query.addFacetField(new String[]{"manu_exact"});
            query.addFacetField(new String[]{"store"});
            query.addFacetField(new String[]{"categorypath"});
            query.setStart((page - 1) * SystemConstant.RECORD_PER_PAGE + 1);
            query.setRows(SystemConstant.RECORD_PER_PAGE);
            query.addGetFieldStatistics(new String[]{"price"});
            if (sort != null && !"rel".equals(sort)) {
                String[] temp = sort.split("_");
                if (!"rel".equals(temp[0])) {
                    query.addSort(temp[0], SolrUtils.getSortOrder(temp[1]));
                }
            }

            query.addSort("random_123", SolrUtils.getSortOrder("asc"));
            rsp = null;
            QueryResponse rsp1 = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Response", rsp});
            response.setResponse(rsp1);
        } catch (SolrServerException var17) {
            SolrServerException var16 = var17;
            var16.printStackTrace();
        } catch (IOException var18) {
            rsp = var18;
            rsp.printStackTrace();
        }

        return response;
    }

    public long searchProductCount(String name) {
        name = Jsoup.parse(name).text();

        try {
            List<String> suggestions = this.doAutosuggestFacets(name, 10, (List)null);
            if (null != suggestions && !suggestions.contains(name)) {
                Iterator var3 = suggestions.iterator();

                while(var3.hasNext()) {
                    String term = (String)var3.next();
                    if (!term.contains("in")) {
                        name = term;
                        break;
                    }
                }
            }

            String filterquery = "";
            if (null != name && !"".equals(name)) {
                if (name.contains(" in ")) {
                    String[] temp = name.split(" in ");
                    name = temp[0];
                    filterquery = temp[1];
                }

                name = "\"" + name + "\"~15";
            }

            SolrQuery query = new SolrQuery(name);
            query.setQuery(name);
            QueryResponse rsp = null;
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Response", rsp});
            if (null != rsp && null != rsp.getResults()) {
                return rsp.getResults().getNumFound() > 0L ? rsp.getResults().getNumFound() - 1L : rsp.getResults().getNumFound();
            }
        } catch (SolrServerException var6) {
             var6 = var6;
            var6.printStackTrace();
        } catch (IOException var7) {
             var7 = var7;
            var7.printStackTrace();
        }

        return 0L;
    }

    public QueryResponse searchProductById(String id) {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addFilterQuery(new String[]{"id:" + id});
        query.addGetFieldStatistics(new String[]{"price"});
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query", query});
        } catch (Exception var5) {
             var5 = var5;
            var5.printStackTrace();
        }

        return rsp;
    }

    public Map<String, List<Suggestion>> suggest(String query) {
        SolrQuery solrQuery = new SolrQuery();
        solrQuery.setRequestHandler("/suggest");
        solrQuery.add(solrQuery);
        solrQuery.setParam("suggest.q", new String[]{query});
        solrQuery.add("group", new String[]{"true"});
        QueryResponse rsp = null;
        SuggesterResponse response = null;

        try {
            rsp = this.server.query(solrQuery);
            response = rsp.getSuggesterResponse();
        } catch (Exception var6) {
             var6 = var6;
            var6.printStackTrace();
        }

        return response.getSuggestions();
    }

    public List<String> doAutosuggestFacets(String prefix, int limit, List<String> getAutosuggestFields) throws SolrServerException, IOException {
        SolrQuery q = new SolrQuery();
        q.setRequestHandler("/terms");
        q.addTermsField("manu");
        q.addTermsField("category");
        q.addTermsField("name");
        q.setTermsPrefix(prefix != null ? prefix.toLowerCase() : "");
        QueryResponse queryResponse = this.server.query(q);
        TermsResponse termsresp = queryResponse.getTermsResponse();
        List<String> terms = new ArrayList();
        if (termsresp.getTerms("manu").isEmpty() && termsresp.getTerms("category").isEmpty() && termsresp.getTerms("name").isEmpty()) {
            SolrQuery query = new SolrQuery();
            query.setRequestHandler("/spell");
            query.setQuery(prefix != null ? prefix.toLowerCase() : "");
            QueryResponse resp = this.server.query(query);
            SpellCheckResponse response = resp.getSpellCheckResponse();
            prefix = response.getCollatedResult();
            if (null == prefix) {
                return null;
            }

            q.setTermsPrefix(prefix.toLowerCase());
            queryResponse = this.server.query(q);
            termsresp = queryResponse.getTermsResponse();
        }

        String facetSearch = "";
        int i;
        if (termsresp.getTerms("manu") != null && !termsresp.getTerms("manu").isEmpty()) {
            for(i = 0; i < termsresp.getTerms("manu").size(); ++i) {
                if (i == 0) {
                    facetSearch = ((TermsResponse.Term)termsresp.getTerms("manu").get(i)).getTerm();
                }

                if (terms.size() > 10 || i == 2) {
                    break;
                }

                if (!terms.contains(((TermsResponse.Term)termsresp.getTerms("manu").get(i)).getTerm())) {
                    terms.add(((TermsResponse.Term)termsresp.getTerms("manu").get(i)).getTerm());
                }
            }
        }

        if (termsresp.getTerms("category") != null && !termsresp.getTerms("category").isEmpty()) {
            for(i = 0; i < termsresp.getTerms("category").size(); ++i) {
                if (facetSearch.equals("") && !((TermsResponse.Term)termsresp.getTerms("category").get(i)).getTerm().contains("accessories")) {
                    facetSearch = ((TermsResponse.Term)termsresp.getTerms("category").get(i)).getTerm();
                }

                if (terms.size() > 10 || i == 2) {
                    break;
                }

                if (!terms.contains(((TermsResponse.Term)termsresp.getTerms("category").get(i)).getTerm())) {
                    terms.add(((TermsResponse.Term)termsresp.getTerms("category").get(i)).getTerm());
                }
            }
        }

        if (termsresp.getTerms("name") != null && !termsresp.getTerms("name").isEmpty()) {
            for(i = 0; i < termsresp.getTerms("name").size(); ++i) {
                if (i == 0 && facetSearch.equals("")) {
                    facetSearch = ((TermsResponse.Term)termsresp.getTerms("name").get(i)).getTerm();
                }

                if (terms.size() > 10 || i == 2) {
                    break;
                }

                if (((TermsResponse.Term)termsresp.getTerms("name").get(i)).getTerm().length() < 30 && !terms.contains(((TermsResponse.Term)termsresp.getTerms("name").get(i)).getTerm())) {
                    terms.add(((TermsResponse.Term)termsresp.getTerms("name").get(i)).getTerm());
                }
            }
        }

        if (facetSearch != null && !facetSearch.isEmpty()) {
            SolrQuery query = new SolrQuery();
            query.setQuery("\"" + facetSearch + "\"~15");
            query.setParam("fq", new String[]{"-category:*accessories*"});
            query.setFacet(true);
            int max = 10;
            query.setFacetLimit(max);
            query.addFacetField(new String[]{"category_exact"});
            query.setFacetMinCount(1);
            QueryResponse resp = this.server.query(query);
            List<FacetField> theFacetsNew = resp.getFacetFields();
            Iterator var13 = theFacetsNew.iterator();

            while(var13.hasNext()) {
                FacetField ff1 = (FacetField)var13.next();
                List facetCountsNew = ff1.getValues();
                if (terms.size() > 10) {
                    return terms;
                }

                if (facetCountsNew != null) {
                    Iterator var16 = facetCountsNew.iterator();

                    while(var16.hasNext()) {
                        FacetField.Count ct1 = (FacetField.Count)var16.next();
                        if (terms.size() > 10) {
                            break;
                        }

                        terms.add(facetSearch + " in " + ct1.getName());
                    }
                }
            }

            return terms;
        } else {
            return terms;
        }
    }

    public SolrDocumentList searchDocsByName(String name) {
        SolrQuery query = new SolrQuery();
        query.setQuery("name:" + name);
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
        } catch (Exception var5) {
             var5 = var5;
            var5.printStackTrace();
            return null;
        }

        SolrDocumentList docs = rsp.getResults();
        return docs;
    }

    private void configureSolr(HttpSolrClient server) {
        server.setConnectionTimeout(5000);
        server.setSoTimeout(5000);
       // server.setDefaultMaxConnectionsPerHost(100);
       // server.setMaxTotalConnections(100);
        server.setFollowRedirects(false);
       // server.setAllowCompression(true);
    }

    private <U> Collection<U> createSingletonSet(U dao) {
        return dao == null ? Collections.emptySet() : Collections.singleton(dao);
    }

    public List<Product> readTopProByCategory(String generateQuery, String catProducts, String prams) {
        List<Product> prods = new ArrayList();
        List<Product> finalProducts = new ArrayList();
        boolean isFailed = false;
        SolrQuery query;
        String[] parameter;
        String[] subCats;
        String q;
        if (catProducts != null && !catProducts.isEmpty() && catProducts.contains("#")) {
            query = new SolrQuery("*:*");
            parameter = catProducts.split("#");
            String[] products = null;
            subCats = null;
            if (parameter.length == 2) {
                products = parameter[1].split("\\|");
                subCats = parameter[0].split("\\|");
                q = "";
                if (null != products && products.length > 0 && null != subCats && subCats.length > 0) {
                    String[] var12 = products;
                    int var13 = products.length;

                    int var14;
                    String fq;
                    for(var14 = 0; var14 < var13; ++var14) {
                        fq = var12[var14];
                        if (null != q && !"".equals(q)) {
                            q = q.concat("OR (\"" + fq + "\"~15)");
                        } else {
                            q = "(\"" + fq + "\"~15)";
                        }
                    }

                    fq = "";
                    String[] var29 = subCats;
                    var14 = subCats.length;

                    for(int var34 = 0; var34 < var14; ++var34) {
                        String sub = var29[var34];
                        if (null != fq && !"".equals(fq)) {
                            fq = fq.concat(" OR \"" + sub + "\"");
                        } else {
                            fq = "+category_exact:(\"" + sub + "\"";
                        }
                    }

                    fq = fq.concat(")");
                    query.setQuery(q);
                    query.setFilterQueries(new String[]{fq});
                    query.setRows(100);
                    query.addSort("random_123", ORDER.asc);
                    logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query: ", query});
                    var29 = null;

                    try {
                        QueryResponse rsp = this.server.query(query);
                        prods = rsp.getBeans(Product.class);
                        Set<String> nameMatch = new HashSet();
                        Iterator var35 = ((List)prods).iterator();

                        label127:
                        while(true) {
                            while(true) {
                                if (!var35.hasNext()) {
                                    break label127;
                                }

                                Product p = (Product)var35.next();
                                Levenshtein l = new Levenshtein();
                                if (finalProducts.size() >= SystemConstant.TOP_PRODUCT_SIZE) {
                                    break label127;
                                }

                                if (finalProducts.isEmpty()) {
                                    finalProducts.add(p);
                                    nameMatch.add(p.getName());
                                } else {
                                    boolean isNew = true;
                                    Iterator var19 = nameMatch.iterator();

                                    while(var19.hasNext()) {
                                        String name = (String)var19.next();
                                        if (0.5 > l.distance(p.getName(), name)) {
                                            isNew = false;
                                        }
                                    }

                                    if (isNew) {
                                        finalProducts.add(p);
                                        nameMatch.add(p.getName());
                                        isNew = true;
                                    }
                                }
                            }
                        }

                        logger.log(Level.INFO, "{0}::{1}", new Object[]{"Products searched from solr: ", ((List)prods).size()});
                        logger.log(Level.INFO, "{0}::{1}", new Object[]{"Products filtered: ", finalProducts.size()});
                        if (finalProducts.size() < SystemConstant.TOP_PRODUCT_SIZE) {
                            isFailed = true;
                        }
                    } catch (SolrServerException var27) {
                        var27.printStackTrace();
                    } catch (IOException var28) {
                        var28.printStackTrace();
                    }
                } else {
                    isFailed = true;
                }
            } else {
                isFailed = true;
            }
        } else {
            isFailed = true;
        }

        if (isFailed) {
            query = new SolrQuery("*:*");
            parameter = null != prams ? prams.split("\\|") : null;
            String sort = "sort".equalsIgnoreCase(parameter[0]) ? parameter[0] : null;
            subCats = null != sort ? sort.split("_") : null;
            if (subCats != null && subCats.length > 1) {
                query.addSort(subCats[0], SolrUtils.getSortOrder(subCats[1]));
            }

            if (generateQuery != null) {
                query.addFilterQuery(new String[]{"categorypath:" + generateQuery});
            }

            query.setRows(SystemConstant.TOP_PRODUCT_SIZE);
            query.addSort("random_123", SolrUtils.getSortOrder("asc"));
            logger.log(Level.INFO, "{0}::{1}", new Object[]{"Query: ", query});
            q = null;

            try {
                if (prods != null) {
                    ((List)prods).clear();
                }

                QueryResponse rsp = this.server.query(query);
                List<Product> prods1 = rsp.getBeans(Product.class);
                Iterator var30 = prods1.iterator();

                while(var30.hasNext()) {
                    Product p = (Product)var30.next();
                    if (finalProducts.size() >= SystemConstant.TOP_PRODUCT_SIZE) {
                        break;
                    }

                    finalProducts.add(p);
                }
            } catch (SolrServerException var25) {
                var25.printStackTrace();
            } catch (IOException var26) {
                var26.printStackTrace();
            }
        }

        return finalProducts;
    }

    public QueryResponse readAllCategoryOfBrand(String brand) {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addFilterQuery(new String[]{"manu_exact:" + brand});
        query.addFacetField(new String[]{"category"});
        query.setRows(0);
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
        } catch (SolrServerException var5) {
             var5 = var5;
            var5.printStackTrace();
        } catch (IOException var6) {
             var6 = var6;
            var6.printStackTrace();
        }

        return rsp;
    }

    public QueryResponse readAllBrandOfCategory(String cat) {
        SolrQuery query = new SolrQuery();
        query.setQuery("*:*");
        query.addFilterQuery(new String[]{"category:" + cat});
        query.addFacetField(new String[]{"manu_exact"});
        query.setRows(0);
        QueryResponse rsp = null;

        try {
            rsp = this.server.query(query);
        } catch (SolrServerException var5) {
             var5 = var5;
            var5.printStackTrace();
        } catch (IOException var6) {
             var6 = var6;
            var6.printStackTrace();
        }

        return rsp;
    }
}
