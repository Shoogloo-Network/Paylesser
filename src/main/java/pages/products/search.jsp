<%-- 
    Document   : category
    Created on : 21 Jun, 2016, 3:59:20 PM
    Author     : IshahaqKhan
--%>

<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="sdigital.pl.products.domains.Breadcrumb"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@page import="sdigital.pl.products.domains.ProductBrand"%>
<%@page import="sdigital.pl.products.domains.ProductCategory"%>
<%@page import="org.apache.solr.client.solrj.response.FacetField"%>
<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="java.util.List"%>
 <%@page import="javax.servlet.http.HttpServletRequest"%>
 <%@page import="javax.servlet.http.HttpServletResponse"%>
 <%@page contentType="text/html" pageEncoding="UTF-8"%>
 <%@page import="java.util.Enumeration"%>
  <%@page import="java.net.URLEncoder"%>
 
  <%
    String domainName = "";
    String pageName = "";
    String pageType = "-3";
    domainName = (String) session.getAttribute("domainName");
    pageName = (String) session.getAttribute("pageName");
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");   
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    Properties p = home.getLabels(language.getId());
    HomeConfig homeConfig = home.getConfig(domainId);
    List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
   List<Product> products = (List<Product>)request.getAttribute("products");
   long numfound = (long)request.getAttribute("noOfRecords");
   List<ProductCategory> categories = (List<ProductCategory>)request.getAttribute("categories");
   List<ProductBrand> brands = (List<ProductBrand>)request.getAttribute("brands"); 
   List<String> stores = (List<String>)request.getAttribute("stores");
   String currPages = request.getParameter("page") == null ? "1" : request.getParameter("page").replaceAll("\\<.*?>", "");
   String sortParam = request.getParameter("sort") == null ? "" : request.getParameter("sort").replaceAll("\\<.*?>", "");   
   if("".equals(sortParam)){sortParam="rel_desc";} // default sort param
   int currPage = Integer.parseInt(currPages);
   
   String str=request.getRequestURL()+"?";
   Enumeration <String> paramNames = request.getParameterNames();
   Boolean flag = false;
   while (paramNames.hasMoreElements())
    {
        String paramName = paramNames.nextElement();
        String[] paramValues = request.getParameterValues(paramName);
        for (int i = 0; i < paramValues.length; i++) 
        {   
            if(paramName.equals("page")){
                int prva = Integer.parseInt(paramValues[i]) +1 ;
                
            str=str + paramName + "=" + prva;
            flag =true;
            
            }else{
               str=str + paramName + "=" + URLEncoder.encode(paramValues[i], "UTF-8");  
            }
        }
        
        str=str+"&";
        
    }
   if (!flag){
                str = str+ "page=2&";
            }
   String hreflnk = str.substring(0,str.length()-1);
   String outURL= "http://"+(String)session.getAttribute("domainName") +"/out";  
   String exactHrefLink = "/search?q=" + URLEncoder.encode((String)request.getAttribute("title"), "UTF-8") + "&exact=" + URLEncoder.encode("true", "UTF-8");
   //double min_price = (double)request.getAttribute("min_price"); // moved  to footer
   //double max_price = (double)request.getAttribute("max_price");
   String langId = CommonUtils.getcntryLangCd(domainId);
   
 %>
 
 <%
    String currenySysmbol = "";
    if("1".equals(domain.getCurrencyType())){
        currenySysmbol = "Rs&nbsp;";
      } else if("2".equals(domain.getCurrencyType())){
        currenySysmbol = "$";
      }else if("3".equals(domain.getCurrencyType())){
        currenySysmbol = "RM";
      }else if("4".equals(domain.getCurrencyType())){
        currenySysmbol = "HKD";
      }else if("5".equals(domain.getCurrencyType())){
        currenySysmbol = "&#x20B9;";
      }else if("6".equals(domain.getCurrencyType())){
        currenySysmbol = "NZ$";
      }else if("7".equals(domain.getCurrencyType())){
        currenySysmbol = "P";
      }else if("8".equals(domain.getCurrencyType())){
        currenySysmbol = "R";
      }else if("9".equals(domain.getCurrencyType())){
        currenySysmbol = "VND";
      }else if("10".equals(domain.getCurrencyType())){
        currenySysmbol = "AED";
      }else if("11".equals(domain.getCurrencyType())){
        currenySysmbol = "?";
      }else if("12".equals(domain.getCurrencyType())){
        currenySysmbol = "R$";
      }else if("13".equals(domain.getCurrencyType())){
        currenySysmbol = "PLN";
      }else if("14".equals(domain.getCurrencyType())){
        currenySysmbol = "QAR";
      }else if("15".equals(domain.getCurrencyType())){
        currenySysmbol = "UAR";
      }else if("16".equals(domain.getCurrencyType())){
        currenySysmbol = "IDR";
      }else if("17".equals(domain.getCurrencyType())){
        currenySysmbol = "Kr";
      }else if("18".equals(domain.getCurrencyType())){
        currenySysmbol = "LKR";
      }else if("19".equals(domain.getCurrencyType())){
        currenySysmbol = "?";
      }else if("20".equals(domain.getCurrencyType())){
        currenySysmbol = "£";
     } else if ("37".equals(domain.getCurrencyType())) {
      currenySysmbol = "&euro;";
      }else if ("39".equals(domain.getCurrencyType())) {
      currenySysmbol = "SAR";
      }   


      String ipAddress = CommonUtils.getClientIP(request);
      String userAgent = request.getHeader("user-agent");
      String fPrint = ""; 
      if (session.getAttribute("fPrint") != null) {
         fPrint = (String)session.getAttribute("fPrint");
      }
      String q = (String)request.getParameter("q");
      q = CommonUtils.sanitizeQuery(q);
      Db db = Connect.newDb();
     
      if(!"182.73.219.210".equals(ipAddress)){
        db.execute().insert("INSERT INTO vc_search_log (domain_id,ip,user_agent, fprint, search_date,query,id) VALUES(?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(domainId), ipAddress, userAgent, fPrint, new Timestamp(new Date().getTime()), q}, "vc_search_log_seq");
      }
     %> 
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %> 
<!DOCTYPE html>
  <html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="robots" content="noindex, nofollow" />
        <title itemprop="name"><%=SolrUtils.toDisplayCase((String)request.getAttribute("title"))%></title>
        <%@include file="common/header.jsp" %>
    </head>
    <compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body onload="javascript:filterpage(<%=currPage%>)" class="feed">
    <div id="wraper" class="inner"> 
    <%@include file="common/topmenu.jsp" %>
      <!-- ================================Breadcrumb Start===================================--> 
        <div class="category" style="margin:0">
          <div class="container">
            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                    <div id="bradcrumb">
                      <ul>                                           
                          <li><a href="/offers">Offers</a></li>
                          <li><%=SolrUtils.toDisplayCase((String)request.getAttribute("title"))%></li>
                      </ul>
                      <!--<p class="hidden-xs"><%=numfound%> Item Found</p>-->
                    </div>
              </div>
            </div>
          </div>
        </div>
      <!-- ================================Breadcrumb End===================================--> 
        <div class="store-middle">
            <div class="container" id="top-category">
                <div class="row">
                    <!-- -------------------Sidebar Start------------------------->
                  <div class="col-lg-3 col-md-3 col-sm-2 col-xs-12 hidden-xs hidden-sm">
                    <div class="sidebar" style="margin-top:0">
                        
                         <!-- -----Related Store------>
                        <% if(categories != null) { %>
                        <div class="side-col categories brand scroll">
                            <h3><input style="width:180px;float:left;margin-right:10px;" type="search" class="catFilter form-control" placeholder="Search Categories" ><a href="#" title="Filter Men" class="menwomen men"><i class="fa fa-male"></i></a><a title="Filter Women" class="menwomen women" href="#"><i class="fa fa-female"></i></a></h3>
                                <ul class="cat_list">
                                    <%
                                    int countCat = 0 ; 
                                    for(ProductCategory cat : categories){
                                        String menwomen=cat.getSeo();
                                        if(menwomen.contains("/men/"))
                                        {
                                            menwomen="Men ";
                                        }
                                        else if(menwomen.contains("/women/"))
                                        {
                                            menwomen="Women ";
                                        }else{
                                            menwomen="";
                                        }
                                    if(countCat<10){
                                    countCat++; 
                                    %>
                                    <li class="filterByCat lirow "><a class="name" href="javascript:filterCategory('<%=cat.getSeo().substring(1)%>')" rel="nofollow"><%=menwomen%><%=cat.getName() %><span><%=cat.getCount() %></span></a></li>
                                    <%} else {%>
                                    <li style="display:none" class="filterByCat lirow "><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=cat.getSeo() %>" rel="nofollow"><%=menwomen%> <%=cat.getName() %><span><%=cat.getCount() %></span></a></li>
                                    <% } } %>
                                    <li style="text-align:right;margin:0" class="pointer show-more" onclick="if($(this).text()==='Show More'){$(this).text('Show Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByCat:gt(9)').hide();$(this).text('Show More');}">Show More</li>
                                </ul>                 
                        </div>
                        <% } %>
                        
                        <div class="side-col brand scroll">
                                <h3><input type="search" class="catFilter form-control" placeholder="Search Brands"></h3>
                                    <ul class="store_list">
                                        <%
                                        int countBra = 0 ; 
                                        for(ProductBrand brand : brands){
                                        if(countBra<10){
                                        countBra++;
                                        %>
                                        <li class="lirow filterByBra"><a class="name" href="javascript:filterBrand('<%=brand.getSeo().substring(1)%>')" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <%} else {%>
                                        <li style="display:none;" class="lirow filterByBra"><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=brand.getSeo() %>" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <% } } %>      
                                        <li style="text-align:right;margin:0" class="pointer show-more" onclick="if($(this).text()==='Show More'){$(this).text('Show Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByBra:gt(9)').hide();$(this).text('Show More');}">Show More</li>                
                                    </ul>           
                        </div>
                                        
                        
                        <div class="side-col price">
                            <h3>Price</h3>
                            <form>
                                <ul>  
                                    <li>
                                        <a>
                                            <input class="myslider" type="text"/>
                                            <span> <button style="margin-left:15px" type="button" class="priceBtn">>></button>   </span> 
                                        </a> 
                                    </li> 
                                    <li><span class="slideMin"><%=currenySysmbol%>&nbsp;<strong></strong></span> <span class="slideMax"><%=currenySysmbol%>&nbsp; <strong></strong></span></li>
                                </ul>
                            </form>
                        </div>                
                             
                        <% if(stores != null) {%>        
                        <div class="side-col store">
                            <h3>Search in Stores</h3>
                                <ul class="store_list store-filter">
                                    <%for(String store : stores){ %>
                                    <li><input type="checkbox" name="store" value="<%=store%>" id="<%=store%>1"/>
                                        <label for="<%=store%>1"></label> <%=SolrUtils.toDisplayCase(store)%>
                                    </li>
                                    <%}%>  
                                    <li> <a href="javascript:filterStore()" class="store-apply">Apply</a></li>
                                </ul>    
                        </div>
                        <% } %>
                        
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->
                
                <!-- -------------------Offer List Start------------------------->
                <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    <div class="cat-list">
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header">
                           <div class="row">
                               <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <%if ( (((String)request.getAttribute("relatedSearch")) != null) &&
                                        (!((String)request.getAttribute("relatedSearch")).isEmpty()) ) { %>
                                        <h1>Showing <%=numfound%> results for "<%=request.getAttribute("relatedSearch")%>"
                                        <span class="instead">Show results for
                                            <a href="<%=exactHrefLink%>"><%=request.getAttribute("title")%></a> instead
                                        </span> 
                                        </h1>                                   
                                    <% } else {%>
                                    <h1>Showing <%=numfound%> results for <%=request.getAttribute("title")%></h1>
                                    <%}%>
                                    <ul id="sort" class="category-select">
                                        <li>Sort By:</li>
                                        <li><a href="javascript:sortProduct('rel_desc')" <%if(sortParam.equalsIgnoreCase("rel_desc")){%> class="active"<% } %>>Relevance</a></li>
                                        <li><a href="javascript:sortProduct('price_asc')" <%if(sortParam.equalsIgnoreCase("price_asc")){%> class="active"<% } %>>Price Low To High</a></li>
                                        <li><a href="javascript:sortProduct('price_desc')" <%if(sortParam.equalsIgnoreCase("price_desc")){%> class="active"<% } %>>Price High To Low</a></li>
                                        <li><a href="javascript:sortProduct('name_desc')" <%if(sortParam.equalsIgnoreCase("name_desc")){%> class="active"<% } %>>Product Name</a></li>
                                    </ul> 
                               </div>
                            </div>
                        </div>
                        
                        <div class="jscroll-container">
                            <div class="row">
                            <%
                                if(products != null && !products.isEmpty()) {
                                    for(Product pro : products){ %>
                                        <%@include file="common/product.jsp" %>         
                            <%      }
                                } else { %> 
                                    <h4 style="margin-left:20px">No Results Found</h4><br />
                                    <p style="font-size:13px;margin-left:20px">
                                    Please check the spelling or try searching for something else.</p>
                             <%}%> 
                            </div>
                            <%--For displaying next link except for the 1st page --%>
                            <div class="row1">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <%--For displaying Next link --%>
                                        <c:if test="${currentPage lt noOfPages}">
                                            <%
                                                //out.println(request.getQueryString());
                                                String parameters = ""  + request.getQueryString();
                                                int index = parameters.indexOf("&page");
                                                if (index > 0) {
                                                    parameters = parameters.substring(0, index);
                                                }
                                                pageContext.setAttribute("parameters", parameters);
                                            %>
                                            <a class="next btn btn-lg" href="?${parameters}&page=${currentPage + 1}" rel="nofollow">Load More..</a>
                                        </c:if>
                                </div>
                            </div>
                        </div>
                    </div>   
                </div>
                </div>    
            </div>
        </div>     
    </div>
<%@include file="common/bottomMenu.jsp" %> 
<%@include file="common/footer.jsp" %>
</body>
</html>
</compress:html>
