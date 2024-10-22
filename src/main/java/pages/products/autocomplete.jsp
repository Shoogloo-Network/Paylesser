<%-- 
    Document   : autocomplete.jsp
    Created on : 4 Jul, 2016, 11:26:53 AM
    Author     : IshahaqKhan
--%>

<%@page import="sdigital.vcpublic.config.CommonUtils"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="sdigital.vcpublic.home.SearchKey"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.pl.products.utilities.Facet"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.Arrays"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="org.apache.solr.client.solrj.response.Suggestion"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="sdigital.pl.products.utilities.Dumper"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.pl.products.domains.AutoResponse"%>
<%@page import="org.apache.solr.common.SolrDocumentList"%>
<%@page import="org.apache.solr.common.SolrDocument"%>
<%@page import="sdigital.pl.products.utilities.SolrDao"%>
<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="org.apache.solr.client.solrj.response.TermsResponse.Term"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
       
        String domainName = "";
        domainName = (String)session.getAttribute("domainName");
        VcHome home = VcHome.instance();
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId);         

        String name = request.getParameter("name").replaceAll("\\<.*?>", "");
        
        if(name!=null && !"".equals(name) && name.length()>2){       
            List<AutoResponse> resList = new ArrayList<AutoResponse>();                     
            if("FEED".equals(domain.getThemeType())){ // when feed mode use solr

                SolrDao<Product> solrDao = new SolrDao<Product> (domainId);        
                String[] facetFields = {"categorypath","manu","name"};
                //String[] facetFields = {"category_exact"};
                List<String> autoFields = new ArrayList<String>(Arrays.asList(facetFields));
                List<String> suggestions=  solrDao.doAutosuggestFacets(name, 15,autoFields );
                //System.out.println("suggestions: "+suggestions);
                if(suggestions!=null){
                    Collections.reverse(suggestions);
                    int count = 0;
                    for (String suggest : suggestions)
                    {
                        AutoResponse res = new AutoResponse();
                        res.setCategory("Product");
                        res.setValue(suggest);
                        if (suggest.contains(" in ")) {
                            String[] term = suggest.split(" in ");
                            res.setName(term[0] + " in <strong><font color=\"566573\" >" + term[1] + "</font></strong>");
                            resList.add(0,res);
                            count++;
                        } else {
                            res.setName(suggest);
                            resList.add(count,res);
                        }

                    }
                }
            }



            //* default coupon store search *//
            List<Language> languages = home.getLanguages(domainId);
            Language language = vcsession.getLanguage(session, domainId, languages);
            List<SearchKey> searchKey = home.getSearchKey();
            StringBuffer strBuffer = new StringBuffer();
            resList.addAll(0, CommonUtils.getSearchResponse(searchKey, language.getId(), domainId, name));

            Gson gson =new GsonBuilder().disableHtmlEscaping().create();
            out.println(gson.toJson(resList));
        
       }else{
           //* default coupon store search *//
            List<Language> languages = home.getLanguages(domainId);
            Language language = vcsession.getLanguage(session, domainId, languages);
            List<SearchKey> searchKey = home.getSearchKey();

            Gson gson =new GsonBuilder().disableHtmlEscaping().create();
            out.println(gson.toJson(CommonUtils.getSearchResponse(searchKey, language.getId(), domainId, name)));  
            
        }  
%>
