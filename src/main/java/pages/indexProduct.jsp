<%-- 
    Document   : indexProduct
    Created on : 6 Jul, 2016, 11:47:30 AM
    Author     : IshahaqKhan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.stream.IntStream"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="sdigital.vcpublic.home.MetaTags"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>


<%      String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
        String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
        String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
        String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");   
        int storeRows = 0;
        
        String domainName = "";
        String pageName = "";
        String pageType = "-1";
        domainName = (String) session.getAttribute("domainName");
        pageName = (String) session.getAttribute("pageName");
        VcHome home = VcHome.instance();
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain    
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
        List<Banner> bannerList = home.getBannerByDomainId(domainId);
        String desc = "";
        String topBannerPath = "";
        List<Testimonial> testimonialList = home.getTestimonialByDomainId(domainId);
        FeedMeta meta = SolrUtils.getFeedMeta(domainId, "home", domain.getThemeType());
        String outURL= "http://"+(String)session.getAttribute("domainName") +"/out";  
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
      
     %> 
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
<head>
 <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <%if("www.stagingserver.co.in".equals(domainName)){%>
                <meta name="robots" content="noindex">
        <%}%>			
                         
        <title itemprop="name"><%=meta.getTitle() %></title>
        <meta name="description" content="<%=meta.getMetaDescription()%>">
        <meta name="keywords" content="<%=meta.getMetaKeyword()%>">
        <meta property="og:url"           content="<%=pageUrl%>" />
        <meta property="og:type"          content="website" />
        <meta property="og:image"          content="<%=SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length())%>/images/logo.svg" />
        <meta property="og:title"         content="<%=meta.getTitle()%>" />
        <meta property="og:description"   content="<%=meta.getMetaDescription()%>" /> 
        
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %> 

 <%@include file="products/common/header.jsp" %> 

</head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
<body class="cms-index-index cms-home-page feed">
<div itemscope itemtype="http://schema.org/WebSite">
  <meta itemprop="name" content="<%=domain.getName()%>"/>
  <link rel="canonical" href="<%=pageUrl%>offers" itemprop="url">              
</div>     
<div id="page">     
 <%@include file="products/common/topmenu.jsp" %> 

    <!-- ================================Banner Start===================================-->
      <section id="banner">
        <div class="container">
            <div class="row">
                <!-------Main Banner Start-------->
                <div class="col-md-8 col-sm-8 col-xs-12"> 
                    <div id="main-banner" >
                        <div class="slider-items">
                            <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for left banner
                                        if ("2".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                    <a href="<%=b.getRedirectUrl()%>">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div>
                            <% } } } }%>
                        </div>    
                    </div>
                </div>
                <!-------Main Banner End-------->
                
                <!-------Side Upper banner Start-------->
                <div class="col-md-4 col-sm-4 hidden-xs">  
                    <div id="side-upper-banner" >
                        <div class="slider-items">
                            <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for right top banner
                                        if ("3".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                     <a href="<%=b.getRedirectUrl()%>">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div> 
                            <% } } } }%>
                        </div>    
                    </div>
                </div>
                <!-------Side Upper banner End-------->
                
                <!-------Side Bottom banner Start-------->
                <div class="col-md-4 col-sm-4 hidden-xs">  
                    <div id="side-bottom-banner" >
                        <div class="slider-items">
                              <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for right bottom banner
                                        if ("4".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                     <a href="<%=b.getRedirectUrl()%>">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div> 
                            <% } } } }%> 
                        </div>    
                    </div>
                </div>
                <!-------Side Bottom banner End-------->
                
            </div>
        </div>    
      </section>
    <!-- ================================Banner End===================================-->

  
  <!-- ================================Featured Store Start===================================-->
  <section class="category">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2>Featured Stores</h2>
              
          </div>
              <div id="featured-store" >
                <div class="slider-items">
                  <%
                    String offercount=null;            
                    if (storeListByDomain != null) {
                        List<Store> storeList = CommonUtils.getTopStoreList(storeListByDomain, language.getId());
                        for (Store store : storeList) {
                            offercount=home.getStoreOfferCount(store.getId());
                            if(offercount==null)offercount="0";
                                if (("0".equals(homeConfig.getStoreListRow()) && storeRows < 18) || ("1".equals(homeConfig.getStoreListRow()) && storeRows < 12)) {
                  %>
                  <div class="item">
                    <div class="item-inner">
                      <div class="item-img">
                        <div class="item-img-info"> 
                            <a class="product-image"><img src="<%=cdnPath + store.getImageBig()%>" alt="<%=store.getName()%> offer" title="<%=store.getName()%> voucher"></a>
                        </div>
                      </div>
                      <div class="item-info">
                         <h4><a href="<%=pageUrl + store.getSeoUrl()%>"><span><%=store.getName()%></span><%=(offercount)%> Offers Available</a> </h4>
                      </div>
                    </div>
                  </div>
                  <%}
                                    storeRows++;
                                //}
                            }
                        }
                   %>
                </div>
              </div>
        </div>
      </div>
    </div>
  </section>
  <!-- ================================Featured Store End===================================-->  
 
  <!-- ================================Top Categories Start===================================--> 
 <section class="category">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2>Top Offers</h2>
          </div>
        </div>
     </div>    
        <div id="top-category" >
            <div class="row hidden-xs hidden-sm">
                <div class="bhoechie-tab-container">
                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 bhoechie-tab-menu">
                      <div class="list-group">
                     <%if(topCat!=null){
                         String act = "active";
                         for(ProductCategory cat : topCat){
                             
                         %>
                         <a href="/<%=SystemConstant.ROOT_URL%>/<%=cat.getSeo()%>" class="list-group-item text-center + <%=act%>">
                              <i class="fa <%= SolrUtils.getMetaImage(domainId, cat.getSeo()) %>" aria-hidden="true"></i>
                          <span><%=SolrUtils.toDisplayCase(cat.getName())%></span>
                          </a> 
                
                        <%act = "";}}%>   
                      </div>
                    </div>
                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10 bhoechie-tab">
                        <%if(topCat!=null){
                        String act = "active";
                        for(ProductCategory cat : topCat){%>
                        <div class="bhoechie-tab-content + <%=act%>">
                           <div class="row">
                               <%List<Product> products = home.getCatProductByName(domainId, cat.getName());
                               if(products!=null){
                                   for(Product pro : products){
                                       
                               %>
                                 <%@include file="products/common/product.jsp" %>
                                <%}}%>                             
                            </div> 
                                
                        </div>
                      <%act = "";}}%>  
                    </div>
                </div>
                </div>                
                <div class="top-category-mm hidden-lg hidden-md">
                <div class="row">
                    <div class="col-lg-12 col-md-3 col-sm-3 col-xs-6">
                        <div class="item">
                            <div class="item-img">
                                <a class="product-image" href="#"> <img alt="" src=""> </a>
                                <div class="add-to-cart"><a class="" href="#"><span></span> </a></div>
                            </div>
                            <div class="item-info">
                                <h4><a href="#"></a> </h4>
                                <p class="discount"><span></span></p>  
                                <p class="price">
                                    <span class="old">
                                        <img src="" alt="">
                                    </span>
                                    <span class="new"></span></p>
                            </div>
                        </div>
                    </div>                    
                </div>
            </div>    
          </div>
        </div>
  </section>    
    
    
    <!-- ================================Top Brand & Testimonial Start===================================--> 
    <section class="category">
    <div class="container">
      <div class="row">
        
        <!----------Top Brand Start--------------->   
        <div class="col-md-6 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2>Top Brands</h2>
          </div>
              <div id="top-brand" >
                <div class="slider-items">
                 <%if(topBrand!=null){
                     int i = 1;
                     for(ProductBrand brand : topBrand){
                       i = i + 1;
                       if(i%2==0){%>                                              
                       <div class="item">
                        <%}%>
                        <div class="item-inner">
                          <div class="item-img">
                            <div class="item-img-info"> 
                                <a class="product-image"  href="/<%=SystemConstant.ROOT_URL%>/<%=brand.getSeo()%>"> <img alt="<%=brand.getName() %>" src="<%=cdnPath + SolrUtils.getMetaImage(domainId, brand.getSeo()) %>"> </a>
                            </div>
                          </div>
                        </div>
                       <% if(i%2!=0){%>
                    </div>
                    <%}}}%>   
                </div>
              </div>
        </div>
        <!----------Top Brand End--------------->
          
        
        <!----------Testimonial Start--------------->   
        <div class="col-md-6 col-sm-12 col-xs-12 hidden-xs">
          <div class="section-title">
              <h2><%=p.getProperty("public.home.testimonial_head")%></h2>
          </div>
              <div id="testimonial" >
                <div class="slider-items">
                  <%if (testimonialList != null) {
                        for (Testimonial ts : testimonialList) {
                            if (ts.getDescription().length() > 255) {
                                desc = ts.getDescription().substring(0, 255) + "...";
                            } 
                            else {
                                desc = ts.getDescription();
                            }
                 %> 
                  <div class="item">
                    <div class="item-inner">
                      <div class="testi-quote">
                        <p class=""><%=ts.getDescription()%></p>
                      </div>
                      <div class="testi-pic"> 
                        <img alt="" src="<%=SystemConstant.PATH%>images/testimonial-image.png">
                        <span><%=ts.getName()%></span>
                        </div>
                    </div>
                  </div>     
                 <% } } %>
                </div>    
              </div>
        </div>  
        <!----------Testimonial Start--------------->  
          
          
      </div>
    </div>
  </section>
<!-- ================================Top Brand & Testimonial End===================================--> 
    
   
   
 <!-- ================================Newsletter Start===================================--> 
  <section class="category" id="newsletter">
    <div class="container">
      <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="news-text" >
                <h3>Subscribe for Latest Deals and Offers</h3>
              </div>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
                <input id="emailbottom" type="text" name="emailbottom" class="searchbox" placeholder="<%=p.getProperty("public.home.footer.email")%>" />
                <div id="loadingBottomM" class="loading" style="display:none;"><img src="<%=SystemConstant.PATH%>images/loading.gif" alt="loading"></div>
                <button class="button-submit search-btn-bg" id="button-submit">Subscribe</button>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
            <ul class="top-social">
                <%
                if(domain.getFbLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getFbLink()%>" target="_blank"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getTwLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getTwLink()%>" target="_blank"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getGpLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getGpLink()%>" target="_blank"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getPnLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getPnLink()%>" target="_blank"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <% } %>
            </ul>
        </div>  
      </div>
    </div>
  </section>
<!-- ================================Newsletter Start===================================-->    

 <!-- ================================Content Start===================================--> 
<%if(null != meta.getContent()){%>
<section class="category hidden-xs">
   <div class="container">
     <div class="row">
       <div class="col-md-12 col-sm-12 col-xs-12">
             <div id="home-intro" class="box">
                 <%=meta.getContent()%>   
             </div>
           </div>
       </div>
   </div>
 </section>  
<%}%>  
<!-- ================================Content Start===================================-->     
  
    <%@include file="products/common/bottomMenu.jsp" %> 
    
</div>   
    <%@include file="products/common/footer.jsp" %>  
</body>
</html>
</compress:html>
