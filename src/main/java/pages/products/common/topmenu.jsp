<%-- 
    Document   : topmenu
    Created on : 12 Jul, 2016, 12:44:36 PM
    Author     : IshahaqKhan
--%>

<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.pl.products.domains.ProductBrand"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.TreeMap"%>
<%@page import="sdigital.pl.products.domains.ProductCategory"%>
<%
List<Domains> domainsCountry = home.getDomainsCountry();  
List<ProductCategory> topCat = (List<ProductCategory>)request.getAttribute("topCat");
List<ProductBrand> topBrand = (List<ProductBrand>)request.getAttribute("topBrand");
 List<SeoUrl> seoList1 = home.getSeoByDomainId(domainId);
 List<Store> storeListByDomain = home.getStoreByDomainId(domainId);
 String success = session.getAttribute("success") == null ? "" : ((String)session.getAttribute("success")).replaceAll("\\<.*?>", "");  
    String signupUrl = "";
    String cdnPath = "";
    String cdn = "";
    String aboutusUrl = "";
    String privacy = "";
    String contactusUrl = "";
    String hiringUrl = "";
    String managementUrl = "";
    String marquee = "";
    
    if ((null != home.getMarquee(domainId)) && !(home.getMarquee(domainId).equalsIgnoreCase(""))) {    
        marquee = "<div class=\"marquee\">" 
                        + home.getMarquee(domainId) 
                        + "</div>";
    }
        String appId = "";
        appId = home.getAppId(domainId);
         for (SeoUrl seo : seoList1) {
         if (seo.getLanguageId().equals(language.getId()) && SystemConstant.SIGNUP.equals(seo.getPageType())) { // has to change
              signupUrl = seo.getSeoUrl();
         }
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.CONTACT_US.equals(seo.getPageType())) { // has to change
             contactusUrl = seo.getSeoUrl();
        }
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ABOUT_US.equals(seo.getPageType())) { // has to change
          aboutusUrl = seo.getSeoUrl();
        }
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.HIRING.equals(seo.getPageType())) { // has to change
          hiringUrl = seo.getSeoUrl();
        }
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.MANAGEMENT_TEAM.equals(seo.getPageType())) { // has to change
          managementUrl = "http://www.shoogloodigital.com/#meet-team";
        }
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.PRIVACY.equals(seo.getPageType())) { // has to change
          privacy = seo.getSeoUrl();
        }
        
        }         
  if(domainName.startsWith("www")){
      cdn = "http://cdn." + domainName.substring(4, domainName.length());
  }else{
      cdn = "https://cdn" + domainName;
  }  
  if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = "https://cdn3." + domainName.substring(3, domainName.length());
  }
  Map<String,List<FeedMeta>> tagFeedMetaListMap= home.getFeedTagMapByDomainId(domainId);     
  List<FeedMeta> feedTrendingTagList = home.getFeedTrendingTagMapByDomainId(domainId ,"TRENDING SEARCH");   
%>
<!-- ================================Header Start ===================================-->
  <%if(!"".equals(success)){%> 
   <div class="notification success">
        <p><%=success%></p>
        <span class="close">X</span>
    </div>  
 <%session.removeAttribute("success");}%>  
   
  <header>
   
        <div class="top-strip hidden-xs">
            <div class="container">
               
                   <div class="row">
                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12"> 
                        <ul class="top-social">
                            <li>We are on Social:</li>
                            <%
                            if(domain.getFbLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-facebook-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getFbLink()%>" target="_blank"><i class="fa fa-facebook-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getTwLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-twitter-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getTwLink()%>" target="_blank"><i class="fa fa-twitter-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getGpLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-google-plus-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getGpLink()%>" target="_blank"><i class="fa fa-google-plus-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getPnLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-pinterest-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getPnLink()%>" target="_blank"><i class="fa fa-pinterest-square" aria-hidden="true"></i></a></li>
                            <% } %>
                        </ul>
                    </div>
                    <%if ((null != home.getMarquee(domainId)) && !(home.getMarquee(domainId).equalsIgnoreCase(""))) {%>    
                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 ">
                            <%=marquee%>
                        </div>
                    <%}%>
                    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 pull-right"> 
                        <ul class="top-links">
                            <li><a href="/<%=SystemConstant.ROOT_URL%>/browse-brands">Top Brands</a>
                            <ul>
                                <%if(topBrand!=null){
                                    for(ProductBrand brand : topBrand){%>
                                    <li><a href="/<%=SystemConstant.ROOT_URL%>/<%=brand.getSeo()%>"><span><%=SolrUtils.toDisplayCase(brand.getName())%></span></a></li>
                                <%}}%>
                            </ul>
                            </li>
                             <li><a href="<%=pageUrl+contactusUrl%>" rel="nofollow">Become a Partner</a></li>   
                             <%if("8".equals(domainId) || "14".equals(domainId) || "17".equals(domainId) || "18".equals(domainId) || "19".equals(domainId) || "20".equals(domainId) || "24".equals(domainId) || "36".equals(domainId)){%>
                             <li><a href="http://blog.paylesser.com/<%=domain.getCountryName().toLowerCase().replace(' ', '-')%>" target="_blank">Blog</a></li> 
                             <% } else { %>
                             <li><a href="/blog/" target="_blank">Blog</a></li>        
                             <% } %>               
                            <% String[] sprit = domain.getImage().replace("/images/common/", "") .split("\\.");%>
                       <!--     <li class="flags"><a class="current-flag" href="https://<%=domain.getDomainUrl()%>"><span class="sprite x<%=sprit[0]%>" style="display:block;float:left;height:16px;margin-right:10px;"></span><%=domain.getCountryName()%><i class="fa fa-angle-down" aria-hidden="true"></i></a>
                            <ul class="all-country">
                                <%if (domainsCountry != null && domainsCountry.size() > 1) {
                                for (Domains d : domainsCountry) {
                                if((d.getCountryName().contains("India") || d.getCountryName().contains("United Kingdom") || d.getCountryName().contains("Australia") || d.getCountryName().contains("Malaysia")|| d.getCountryName().contains("Singapore") || d.getCountryName().contains("Indonesia") ||
                                 d.getCountryName().contains("Hong Kong") || d.getCountryName().contains("Philippines"))){ 
                                if (!d.getId().equals(domain.getId())) {
                                String[] sprite = d.getImage().replace("/images/common/", "") .split("\\.");
                                 if(!("5".equals(d.getId()) || "www.stagingserver.co.in".equalsIgnoreCase(d.getDomainUrl()))){ %>
                                <li><a href="https://<%=d.getDomainUrl()%>" rel="nofollow"><span class="sprite x<%=sprite[0]%>"></span><%=d.getCountryName()%></a></li>   
                                <% } } } } }%>
                            </ul>
                            </li>  -->
                        </ul>
                    </div>
                    
                </div>
                
            </div>
        </div>
       <div class="fix-container">
          <div class="container">
            <div class="row">
               <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12"> 
                <div class="logo"> <a title="" href="/"><img alt="Paylesser <%=p.getProperty("public.home.coupons")+" "+p.getProperty("public.store.offers")%>" src="<%=SystemConstant.PATH%>images/pl-logo.png"  /> </a> </div>
              </div>
              <div class="col-lg-8 col-md-8 col-sm-7 col-xs-3">
                  <div class="user-account">
                      <ul>
                          <%if (session.getAttribute("userObj") == null) {%>
                            <li class="login" rel="nofollow"><a href="<%=pageUrl%>user-login" rel="nofollow"> <i class="fa fa-unlock-alt" aria-hidden="true"></i> <%=p.getProperty("public.home.login")%></a></li>                
                            <li class="signup"><a href="<%=pageUrl + signupUrl%>" rel="nofollow"><i class="fa fa-user-plus" aria-hidden="true"></i> <%=p.getProperty("public.home.signup")%></a></li>                                            
                            <% } else { %>
                            <li class="login"><a href="<%=pageUrl%>user-profile"><i class="fa fa-user" aria-hidden="true"></i> <%=p.getProperty("public.home.profile")%></a></li>
                            <li class="signup"><a href="<%=pageUrl%>logout"><i class="fa fa-sign-out" aria-hidden="true"></i> <%=p.getProperty("public.home.logout")%></a></li>                                                            
                           <% } %>                          
                      </ul>
                   </div>
                  <div class="search-box">
                      <form method="get" action="/searchRedirect">                                              
                        <input id="solr_search" type="text" name="q" placeholder="<%=p.getProperty("public.home.search")%>" class="searchbox" maxlength="128" required="required">
                        <button type="submit" title="Search" class="search-btn-bg" ><i class="fa fa-search"></i></button>
                      </form>
                   </div>
              </div>
            </div>
          </div>
        
         <%@ include file="navigation.jsp" %> 
   </div>
  </header>
  <!-- ================================Header End ===================================-->
  <!-- ================================Header End ===================================-->
   <%@ include file="mobileNavigation.jsp" %>

  
  <!-- ================================Trending Search Start===================================--> 
   <!--<div class="trending-search">
       <div class="container">
           <ul>
            <li>Trending Search</li>
            <% //if(feedTrendingTagList!=null) {
                //for(FeedMeta feedmeta:feedTrendingTagList){ %>
                  <li> <a href="<%//=feedmeta.getKey()%>"><%//=SolrUtils.toDisplayCase(feedmeta.getName())%></a></li>                 
            <%//}}%>
           </ul>
       </div>   
    </div>-->    
    <!-- ================================Trending Search End===================================-->
 