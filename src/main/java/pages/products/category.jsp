<%-- 
    Document   : category
    Created on : 21 Jun, 2016, 3:59:20 PM
    Author     : IshahaqKhan
--%>

<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.FeedMeta"%>
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
 <%
  try{ 
    String domainName = "";
    String pageName = "";
    String pageType = "-2";
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
    String sortParam = request.getParameter("sort") == null ? "" : request.getParameter("sort").replaceAll("\\<.*?>", "");   
    if("".equals(sortParam)){sortParam="rel_desc";} // default sort param
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    Properties p = home.getLabels(language.getId());
    HomeConfig homeConfig = home.getConfig(domainId);
    List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
    
   List<Product> products = (List<Product>)request.getAttribute("products");
   long numfound = (long)request.getAttribute("noOfRecords");
   List<ProductCategory> categories = (List<ProductCategory>)request.getAttribute("categories");
   List<ProductBrand> brands = (List<ProductBrand>)request.getAttribute("brands");
   List<Breadcrumb> breadcrumbs = (List<Breadcrumb>)request.getAttribute("breadcrumb"); 
   List<String> stores = (List<String>)request.getAttribute("stores");
   List<ProductBrand> similarBrand = (List<ProductBrand>)request.getAttribute("similarBrand");
   //String outURL= (String)request.getAttribute("domainName");
   String outURL= "http://"+(String)session.getAttribute("domainName") +"/out";
   String langId = CommonUtils.getcntryLangCd(domainId);
   
   //double min_price = (double)request.getAttribute("min_price");  moved  to footer
   //double max_price = (double)request.getAttribute("max_price");
  
   FeedMeta meta = SolrUtils.getFeedMeta(domainId, pageName, domain.getThemeType());
 %>
 
 <%
    String currenySysmbol = CommonUtils.getCurrency(domainId);
 %> 
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>

  <html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="description" content="<%=meta.getMetaDescription() %>">
        <meta name="keywords" content="<%=meta.getMetaKeyword() %>">
        <%if(meta.getTitle()!=null && meta.getTitle().trim().length()>0){%>        
            <title itemprop="name"><%=meta.getTitle()%></title>
        <%}else{%>
            <title itemprop="name"><%=SolrUtils.toDisplayCase((String)request.getAttribute("title"))%></title>
        <%}%>
        
        <% if("N".equals(meta.getIndexmeta())){ %>
            <meta name="robots" content="noindex, nofollow">
         <% } %> 
         
         <% 
         String uri = (String) request.getRequestURI();    
         if(request.getParameterNames().hasMoreElements()){ %>
         <link rel="canonical" href="<%= session.getAttribute("scheme")+"://" + domainName + uri.split("\\?")[0]%>">
          <%}%>
        
        <%@include file="common/header.jsp" %>   
        
    </head>      
    <compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">   
    <body class="feed">
      <div id="wraper" class="inner">
        <%@include file="common/topmenu.jsp" %> 
        <!-- ================================Breadcrumb Start===================================--> 
        <div class="category" style="margin:0">
          <div class="container">
            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                    <div id="bradcrumb">
                      <ul>
                          <li itemscope itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/offers" itemprop="url"><span itemprop="title">Offers</span></a></li>
                          <%int size = breadcrumbs.size();
                            int i = 1;
                            for(Breadcrumb breadcrumb : breadcrumbs){ 
                              String name =  breadcrumb.getName().split("\\|")[breadcrumb.getName().split("\\|").length-1];                            
                              if(i==size){
                                 name =  (meta.getH1()!=null)?meta.getH1():name;
                              }
                              if(breadcrumb.getUrl()==null){
                               %>                                           
                                <li itemscope itemtype="http://data-vocabulary.org/Breadcrumb"><span itemprop="title"><%= name %></span></li>
                               <%}else{%>
                                 <li itemscope itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/<%=SystemConstant.ROOT_URL%><%=breadcrumb.getUrl() %>" itemprop="url"><span itemprop="title"><%= name %></span></a></li>
                              <%}}%>
                      </ul>
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
                  <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs hidden-sm">
                      <div class="sidebar" style="margin-top:0">        
                                
                         <!-- -----Related Store------>
                        <% if(categories != null) { %>
                        <div class="side-col categories brand scroll">
                            <h3>
                                <input style="float: left; width:180px;margin-right: 10px;" type="search" class="catFilter form-control"  placeholder="Search Categories"><a href="javascript:void(0)" title="Filter Men" class="menwomen men"><i class="fa fa-male"></i></a><a href="javascript:void(0)" title="Filter Women" class="menwomen women"><i class="fa fa-female"></i></a>
                            </h3>
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
                                    <li class="filterByCat lirow "><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=cat.getSeo() %>" rel="nofollow"><%=menwomen%> <%=cat.getName() %><span><%=cat.getCount() %></span></a></li>
                                    <%} else {%>
                                    <li style="display:none" class="filterByCat lirow "><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=cat.getSeo() %>" rel="nofollow"><%=menwomen%> <%=cat.getName() %><span><%=cat.getCount() %></span></a></li>
                                    <% } } if(countCat>9){%>
                                    <li style="text-align:right;margin:0" class="pointer show-more" onclick="if($(this).text()==='Show More'){$(this).text('Show Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByCat:gt(9)').hide();$(this).text('Show More');}">Show More</li>
                                    <% } %>
                                </ul>                 
                        </div> 
                        <% } %>
                        <%if(similarBrand==null){%>
                            <div class="side-col brand scroll">
                                <h3><input type="search" class="catFilter form-control" placeholder="Search Brands"></h3>
                                    <ul class="store_list">
                                        <% 
                                        int countBra = 0 ;   
                                        for(ProductBrand brand : brands){
                                        if(countBra<10){
                                        countBra++; 
                                        %>
                                        <li class="lirow filterByBra"><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=brand.getSeo() %>" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <%} else {%>
                                        <li style="display:none;" class="lirow filterByBra"><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=brand.getSeo() %>" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <% } } %>      
                                        <li style="text-align:right;margin:0" class="pointer show-more" onclick="if($(this).text()==='Show More'){$(this).text('Show Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByBra:gt(9)').hide();$(this).text('Show More');}">Show More</li>
                                    </ul>                 
                            </div>
                        <%}else{%> 
                            <div class="side-col brand scroll">
                                   <h3><input type="search" class="catFilter form-control" placeholder="Search Similar Brands"> </h3>
                                       
                                       <ul class="store_list">
                                        <%
                                        int countSbra = 0 ;   
                                        for(ProductBrand brand : similarBrand){  
                                        if(countSbra<10){
                                        countSbra++;
                                        %>
                                        <li class="lirow filterBySbra"><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=brand.getSeo() %>" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <%} else {%>
                                        <li style="display:none" class="lirow filterBySbra"><a class="name" href="/<%=SystemConstant.ROOT_URL%><%=brand.getSeo() %>" rel="nofollow"><%=brand.getName() %><span><%=brand.getCount() %></span></a></li>
                                        <%} }%>   
                                        <li style="text-align:right;margin:0" class="pointer show-more" onclick="if($(this).text()==='Show More'){$(this).text('Show Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterBySbra:gt(9)').hide();$(this).text('Show More');}">Show More</li>
                                       </ul> 
                               </div>
                        <%}%>       
                        
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
                                    <li><span class="slideMin"><%=currenySysmbol %>&nbsp; <strong></strong></span> <span class="slideMax"><%=currenySysmbol %>&nbsp; <strong></strong></span></li>
                                </ul>
                            </form>
                        </div>
                        
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
                         
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->
                
                <!-- -------------------Offer List Start------------------------->
                <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    <div class="cat-list">
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header">
                           <div class="row">
                               <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
                                   <%  if(meta.getH1()!=null && meta.getH1().trim().length()>0){%>
                                        <h1><%=meta.getH1()%> <span class="hidden-xs"> (<%=numfound%> Item Found)</span></h1>
                                   <%}else{%>
                                        <h1><%=SolrUtils.toDisplayCase((String)request.getAttribute("title"))%> <span class="hidden-xs"> (<%=numfound%> Item Found)</span></h1>
                                    <%}%>
                                    
                                    <%if(meta.getTopContent()!=null && !"".equals(meta.getTopContent())){%>
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 hidden-xs">
                                            <p><%=meta.getTopContent()%></p>
                                        </div>
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
                            <%for(Product pro : products){ %>
                             <%@include file="common/product.jsp" %>         
                            <% }%> 
                            </div>
                            <%--For displaying next link except for the 1st page --%>
                            <div class="row1">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <%--For displaying Next link --%>
                                        <c:if test="${(currentPage+1) lt noOfPages}">
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
                                        
                  <!-- ================================Content Start===================================--> 
                   <%if(null != meta.getContent()){%>
                    <section class="category hidden-xs">
                       <div class="container">
                         <div class="row">
                            <div class="col-md-9 col-sm-9 col-xs-12 pull-right">
                                <div class="pull-right" style="width: 100%;padding:0 10px;">
                                 <div id="home-intro" class="box">
                                     <%=meta.getContent()%>   
                                 </div>
                            </div>
                           </div>
                           </div>
                       </div>
                     </section>  
                    <%}%> 
                  <!-- ================================Content Start===================================-->                       
                                        
                                        
                </div>    
            </div>
        </div>
</div>
<%@include file="common/bottomMenu.jsp" %> 
<%@include file="common/footer.jsp" %>  
</body>
</html>
</compress:html>


<%} catch (Throwable e) {
        Logger.getLogger("category.jsp").log(Level.SEVERE, null, e);
    } finally {

}%>