<%-- 
    Document   : index
    Created on : 17 Feb, 2016, 17 Feb, 2016 10:56:46 AM
    Author     : Vivek
--%>

<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.*" %>
<%
    try {
        String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
        String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
        String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
        String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
        boolean top = true;
        boolean vouchers = true;
        boolean deals = true;        
        String tabConfigCalss = "";
        int storeRows = 0;
        int rBannerCount = 0;
        int rowCount = 0;
        int tabType = 4;
        String topBannerPath = "";
        String bottomBannerPath = "";
        String oneBanner = "";
        String newsltrClass = "";
        int popCatCount = 0;
        String popCatClass = "";
        String pageType = SystemConstant.HOME;
        String pageTypeFk = "";
        
        
        String domainName = "";
        String pageName = "";
        domainName = (String) session.getAttribute("domainName");
        pageName = (String) session.getAttribute("pageName");
        VcHome home = VcHome.instance();
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain    
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        String pageCnUrl = pageUrl.substring(0, pageUrl.length()-1);
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        List<VoucherDeals> offerDealList = home.getOfferByDomainId(domainId);
        List<VoucherDeals> topOfferList = CommonUtils.filterOnUniqueStore(home.getOfferByDomainId(domainId));
        List<VoucherDeals> voucherList = home.getVoucherByDomainId(domainId);
        List<VoucherDeals> dealList = home.getDealByDomainId(domainId);
        List<Banner> bannerList = home.getBannerByDomainId(domainId);
        List<Category> popCategoryList = home.getPopCatByDomainId(domainId);    
        List<Store> allStoreListByDomain = home.getAllStoresByDomainId(domainId);
        List<VoucherDeals> popOfferList = home.getPopOfferByDomainId(domainId); 
        List<Specials> allCategoryList = home.getSpecialCatDomainId(domainId);
         List<Specials> allSpecialList = home.getAllSpecial(domainId);
        Map<String, String> popCatIdMap = new HashMap<String, String>();
        Map<String, String> popCatIdBgMap = new HashMap<String, String>();
        String currentId = "";
        String voucherClass = "";
        String voucherDesc = "";
        String imagePath = "";
        String storeId = "0";
        String langId = CommonUtils.getcntryLangCd(domainId);
        int top20Counter = 0;
        if (homeConfig.getTabConfigList().size() == 3) {
            tabConfigCalss = "";
        } else if (homeConfig.getTabConfigList().size() == 2) {
            tabConfigCalss = "two-tabs";
        } else if (homeConfig.getTabConfigList().size() == 1) {
            tabConfigCalss = "one-tabs";
        }

        if ("1".equals(homeConfig.getVote()) || "1".equals(homeConfig.getFavouriteStores()) || "1".equals(homeConfig.getSavedCoupons()) || "1".equals(homeConfig.getExpiryDate())) {
            newsltrClass = "newsletter_fl";
            oneBanner = "slider01_fl";
        } else {
            newsltrClass = "newsletter_hl";
            oneBanner = "slider01_hl";
        }

        if (popCategoryList != null) {
            for (Category cat : popCategoryList) {
                if (cat.getLanguageId().equals(language.getId())) {
                    popCatCount++;
                }
            }
        }

        if (popCatCount == 1) {
            popCatClass = "one-tab";
        } else if (popCatCount == 2) {
            popCatClass = "two-tabs";
        } else if (popCatCount == 3) {
            popCatClass = "three-tabs";
        } else if (popCatCount == 4) {
            popCatClass = "four-tabs";
        } else if (popCatCount == 5) {
            popCatClass = "five-tabs";
        } else if (popCatCount == 6) {
            popCatClass = "six-tabs";
        }
        List<Heading> headList = home.getHeading(domainId);
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
        List<Category> categoriesList = home.getCatByDomainId(domainId);
        
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<%
    switch(language.getCode()){
    case "vn" :
        session.setAttribute( "isoCode", "vi" );
        break; 
    case "mx" :
       session.setAttribute( "isoCode", "es" );
       break; 
    case "id" :
       session.setAttribute( "isoCode", "id" );
       break;
    case "FR" :
       session.setAttribute( "isoCode", "fr" );
       break; 
    case "TH" :
       session.setAttribute( "isoCode", "th" );
       break;  
    case "br" :
       session.setAttribute( "isoCode", "pt" );
       break;    
    default : 
       session.setAttribute( "isoCode", "en" );
    }
  %>
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <%if("www.stagingserver.co.in".equals(domainName)){%>
                <meta name="robots" content="noindex">
        <%}%>			
        <%String seoUrl = "";
            for (SeoUrl s : seoList) {
                if (SystemConstant.HOME.equals(s.getPageType())) {
                    if (language.getId().equals(s.getLanguageId())) {                        
                %>                     
        <title itemprop="name"><%=s.getPageTitle()%></title>
        <meta name="description" content="<%=s.getMetaDesc()%>">
        <meta name="keywords" content="<%=s.getMetaKeyword()%>">
        <meta property="og:url"           content="<%=pageUrl%>" />
        <meta property="og:type"          content="website" />
        <meta property="og:image"          content="<%=SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length())%>/images/logo.svg" />
        <meta property="og:title"         content="<%=s.getPageTitle()%>" />
        <meta property="og:description"   content="<%=s.getMetaDesc()%>" /> 
        <%if("5".equals(domainId)){%>
             <link rel="canonical" href="<%=pageCnUrl%>"/>
        <%}else if(!("COUPON".equals(domain.getThemeType()))){ 
             seoUrl = s.getSeoUrl();
             %>            
             <link rel="canonical" href="<%=pageCnUrl%>"/>
        <%}else if(("COUPON".equals(domain.getThemeType()))){
             %>            
             <link rel="canonical" href="<%=pageCnUrl%>"/>     
        <%}%>     
        <%
                        break;
                    }
                }
            }%>
        
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %> 
        <!-- Meta Verification Removed from here -->  
<%@include file="common/header.jsp" %>        
</head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
<body class="cms-index-index cms-home-page"> 
<%//if(!"FEED".equals(domain.getThemeType())){%>    
<div itemscope itemtype="http://schema.org/WebSite">
  <meta itemprop="name" content="<%=domain.getName()%>"/>
  <link rel="canonical" href="<%=pageCnUrl%>" itemprop="url">              
</div> 
<%//}%>    
<div id="page"> 
    <%@include file="common/topMenu.jsp" %>  
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
                                        if ("0".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                    <a href="<%=b.getRedirectUrl()%>" rel="nofollow">
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
                <div class="col-md-4 col-sm-4 col-xs-12 hidden-xs">  
                    <div id="side-upper-banner" >
                        <div class="slider-items">
                              <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for right banner
                                        if ("1".equals(b.getBannerType())) {
                                            rBannerCount++;
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }
                            %>
                              <div class="item">
                                <div class="item-inner"> 
                                    <a href="<%=b.getRedirectUrl()%>" rel="nofollow">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div>   
                            <% } } } }%>
                            
                            <%if(rBannerCount==0){%>
                            
                              <div class="item">
                                <div class="item-inner"> 
                                    <img src="<%=SystemConstant.PATH%>images/side-banner.jpg" alt="" title=""/>
                                </div>
                              </div>   
                            
                            <%}%>
                        </div>    
                    </div>
                </div>
                <!-------Side Upper banner End--------> 
            </div>
        </div>    
      </section>
    <!-- ================================Banner End===================================-->
    
 <!-- ================================Top Coupons Start===================================--> 
 <section class="category">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2><a href="<%=pageUrl + top20OUrl%>"><%=p.getProperty("public.home.topc/o")%></a></h2>
          </div>
        </div>
     </div>    
        <div id="top-coupon" >
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="row">
                        <%//Ishaq For Mobile View and Exclusive
                        List<VoucherDeals> mobileVdListById = new ArrayList<VoucherDeals>();
                        List<VoucherDeals> deskVdListById = new ArrayList<VoucherDeals>();
                        if (topOfferList != null) {
                         for (VoucherDeals vd : topOfferList) {
                            if("1".equals(vd.getExclusive())){ 
                             if("1".equals(vd.getViewType())){
                                 mobileVdListById.add(0,vd);
                             }else if("0".equals(vd.getViewType())){
                                deskVdListById.add(0,vd);
                             }
                            }else{
                              if("1".equals(vd.getViewType())){
                                 mobileVdListById.add(vd);
                             }else if("0".equals(vd.getViewType())){
                                deskVdListById.add(vd);
                             }  
                            }
                          }
                        } 
                        
                        if (deskVdListById != null) {
                            
                                if(!(request.getHeader("User-Agent").indexOf("Mobile") != -1)) {
                                 top20Counter = 0;
                               } 
                                    for (VoucherDeals vd : deskVdListById) {
                                        if (language.getId().equals(vd.getLanguageId())) {
                                          top20Counter++;
                                          if(top20Counter < 13) {
                                            if ("1".equals(vd.getOfferType())) {
                                                voucherClass = "click-to-code vpop";
                                                voucherDesc = p.getProperty("public.home.get_voucher");
                                            } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                                voucherClass = "activate-deal-2 u-deal";
                                                voucherDesc = p.getProperty("public.category.activate_deal");
                                            } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                                voucherClass = "activate-deal u-deal";
                                                voucherDesc = p.getProperty("public.category.activate_deal");
                                            }
                                            if(vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                                              imagePath = cdnPath + vd.getOfferImage();
                                            } else {
                                              imagePath = cdnPath + vd.getImageSmall();
                                            } 
                                            storeId += "," + vd.getStoreId();
                        %>
                        <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6">
                            <div class="item-inner">
                                <div class="item-image">
                                    <a href="<%=pageUrl + vd.getStoreSeoUrl() %>"><img src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreCaption()!=null?vd.getStoreCaption():vd.getStoreName()%>" title="<%=vd.getStoreName()%> offers"></a>
                                </div>
                                <div class="item-info">
                                    <p><%=vd.getOfferHeading()%></p>
                                    <%if ("1".equals(vd.getOfferType())) {%>
                                    <a data-type="20" data-lang="<%=vd.getLanguageId()%>" data-of="<%=vd.getId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-btn"><%=voucherDesc%></a>
                                    <%} else {%>
                                    <a data-of="<%=vd.getId()%>" data-href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="my-btn1 btn-deal"><%=voucherDesc%></a>
                                    <% } %>
                                    <span class="available <%=rtl%>"><%=(home.getStoreOfferCount(vd.getStoreId()))==null?0: Integer.parseInt(home.getStoreOfferCount(vd.getStoreId()))-1%>&nbsp;<%=p.getProperty("public.store.more")%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></span>   
                                </div>
                            </div>
                        </div>  
                        <% } } } } %>        
                    </div> 
                </div>
            </div>
        </div>
    </div>  
  </section>    
 <!-- ================================Top Coupons End===================================-->  
 
 
 <!-- ================================Featured Store Start===================================-->
  <section class="category">
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
              <div class="section-title">
                  <h2><a href="<%=pageUrl + allstoreUrl%>"><%=p.getProperty("public.home.popularstores")%><!--<span><a href=""><%//=p.getProperty("public.home.allstores")%></a></span>--></a></h2>              
              </div>
            </div>
        </div>  
            <% if (storeListByDomain != null) { %>
              <div id="popular-store" >
                <div class="row">
                  <%
                        List<Store> storeList = CommonUtils.getTopStoreList(storeListByDomain, language.getId());
                        for (Store store : storeList) {
                                if (("0".equals(homeConfig.getStoreListRow()) && storeRows < 18) || ("1".equals(homeConfig.getStoreListRow()) && storeRows < 6)) {
                  %>
                  <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6">
                    <div class="item-inner">
                        <div class="item-image">
                            <a href="<%=pageUrl + store.getSeoUrl()%>"><img src="<%=cdnPath + store.getImageBig()%>" alt="<%=store.getName()%> offer" title="<%=store.getName()%> voucher"></a>
                        </div>
                   <!--  <div class="item-info <%=rtl%>">
                        <h4><a href="<%=pageUrl + store.getSeoUrl()%>"><span><%=store.getName()%></span><%=(home.getStoreOfferCount(store.getId()))==null?0: home.getStoreOfferCount(store.getId())%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></a> </h4>
                      </div>    -->    
                    </div>
                  </div> 
                  <% storeRows++; } } %>
                </div>
                
                <div>
                   <ul class="store-list">
                  <% int sNonImg = 0;
                    for (Store store : storeList) {
                     if(sNonImg >= storeRows && sNonImg<54){  
                  %>
                  <li class="col-lg-2 col-md-2 col-sm-4 col-xs-6">
                    <a href="<%=pageUrl + store.getSeoUrl()%>"><span><%=store.getName()%></span></a>
                  </li> 
                  <%} sNonImg++; } %>
                </ul>
              </div>
              </div> 
        <%}%>
        </div>
  </section>
  <!-- ================================Featured Store End===================================-->   
    
    
  <!-- ================================Newsletter Start===================================--> 
  <section class="category hidden-xs" id="counters">
    <div class="container">
      <div class="row">
          <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="subs">
                <input id="emailbottom" type="text" name="emailbottom" class="searchbox" placeholder="<%=p.getProperty("public.home.footer.email")%>" />
                <div id="loadingBottomM" class="loading" style="display:none;"><img src="<%=SystemConstant.PATH%>images/loading.gif" alt="loading"></div>
                <button class="button-submit search-btn-bg" id="button-submit"><%=p.getProperty("public.home.newsletter.subscribe")%></button>
                </div>
          </div>
          
          <div class="col-md-8 col-sm-8 col-xs-12">
                <div class="row">
                    <div class="col-md-3 col-sm-3 col-xs-12">
                         <h3><i class="fa fa-shopping-cart" aria-hidden="true"></i><%=home.getTotalCoupons(domainId) == null ? "1" : home.getTotalCoupons(domainId)%>+<span><%=p.getProperty("public.home.coupons")%></span></h3> 
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-12">
                         <h3><i class="fa fa-tag" aria-hidden="true"></i><%=home.getTodaysCoupons(domainId) == null ? "1" : home.getTodaysCoupons(domainId)%><span><%=p.getProperty("public.home.coupons_used")%></span></h3> 
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-12">
                        <h3><i class="fa fa-facebook-square" aria-hidden="true"></i><div id="fb-count">0</div><span><%=p.getProperty("public.coupon.fbfans")%></span></h3> 
                    </div>
                    <div class="col-md-3 col-sm-3 col-xs-12">
                         <h3><i class="fa fa-truck" aria-hidden="true"></i><%=home.getTotalStores(domainId) == null ? "1" : home.getTotalStores(domainId)%>+<span><%=p.getProperty("public.home.retailers")%></span></h3> 
                    </div> 
                </div>
          </div>
      </div>
    </div>
  </section>
<!-- ================================Newsletter Start===================================-->   
    
    
    
    
    <!-- ================================Our Special & Testimonial Start===================================--> 
 <!--   <section class="category">
    <div class="container">
      <div class="row">
        -->
        <!----------Our Special Start--------------->   
    <!--    <div class="col-md-6 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2><a href="<%=pageUrl + allSpecialUrl%>"><%=p.getProperty("public.special.ourspecials")%></a></h2>
          </div>
              <div id="our-special" >
                <div class="slider-items">
                    <% 
                    if(allCategoryList != null) {
                      for(Specials spcat : allCategoryList){
                        if (language.getId().equals(spcat.getLanguageId())) {
                    %>
                    <div class="item">
                        <div class="item-inner">
                          <div class="spacial-box"> 
                              <div class="cat-img"> 
                                  <img src="<%=SystemConstant.PATH%>images/our-spl.jpg" alt="our-special"> 
                                  <h5><%=spcat.getName()%></h5> 
                              </div> 
                              <div class="item-info">
                                    <%
                                    int spCount = 0;
                                    if(allSpecialList != null) {                                      
                                    for(Specials sp : allSpecialList){
                                        if (language.getId().equals(sp.getLanguageId()) && spcat.getCategoryId().equals(sp.getCategoryId())) {
                                            if(spCount < 1){                                                    
                                    %>
                                    <p><a href="<%=sp.getSeoUrl()%>"><%=sp.getName()%></a></p>
                                    <%
                                            }else{
                                              break;
                                            }
                                            spCount++;
                                            }
                                        }
                                    }
                                    %>
                                    <a href="<%=pageUrl + spcat.getSeoUrl()%>" class="my-btn">View All</a>
                        
                                </div> 
                            </div>
                        </div>
                    </div>
                    <% } } } %>
                </div>
              </div>
        </div>   -->
        <!----------Top Brand End--------------->
          
        
        <!----------Testimonial Start--------------->   
     <!--   <div class="col-md-6 col-sm-12 col-xs-12 hidden-xs">
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
        </div>  --> 
        <!----------Testimonial Start--------------->  
          
          
  <!--    </div>
    </div>
  </section>  -->
<!-- ================================Top Brand & Testimonial End===================================--> 
    
<!-- ================================Google Ad Start===================================--> 

<section class="category hidden-xs" style="display:none">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
              
        </div>
      </div>
    </div>
  </section>

<!-- ================================Google Ad Start===================================-->    
    
 <!-- ================================Newsletter Start===================================--> 
 <!--<section class="category" id="newsletter">
    <div class="container">
      <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="news-text" >
                <h3><%=p.getProperty("public.home.subscribeldo")%></h3>
              </div>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
                <input id="emailbottom" type="text" name="emailbottom" class="searchbox" placeholder="<%=p.getProperty("public.home.footer.email")%>" />
                <div id="loadingBottomM" class="loading" style="display:none;"><img src="<%=SystemConstant.PATH%>images/loading.gif" alt="loading"></div>
                <button class="button-submit search-btn-bg" id="button-submit"><%=p.getProperty("public.home.newsletter.subscribe")%></button>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
            <%if("5".equals(domainId)) { %>
            <ul style="margin-top:-10px">
                <li><a href="https://play.google.com/store/apps/details?id=com.eteam.vouchercodes&hl=en" target="_blank"><img src="<%=SystemConstant.PATH%>images/android-app.png" style="max-width:150px;"></a></li>
            </ul>
            <% } else { %>
            <ul class="top-social">
                <%
                if(domain.getFbLink() == null) {
                %>
                <li><a rel="nofollow" href="<%=pageUrl%>"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a rel="nofollow" href="<%=domain.getFbLink()%>" target="_blank"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getTwLink() == null) {
                %>
                <li><a rel="nofollow" href="<%=pageUrl%>"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a rel="nofollow" href="<%=domain.getTwLink()%>" target="_blank"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getGpLink() == null) {
                %>
                <li><a rel="nofollow" href="<%=pageUrl%>"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a rel="nofollow" href="<%=domain.getGpLink()%>" target="_blank"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getPnLink() == null) {
                %>
                <li><a rel="nofollow" href="<%=pageUrl%>"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a rel="nofollow" href="<%=domain.getPnLink()%>" target="_blank"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <% } %>
            </ul>
            <% } %>
        </div>  
      </div>
    </div>
  </section> -->
<!-- ================================Newsletter Start===================================-->    

 <!-- ================================Content Start===================================--> 
 
<%String contents = home.getContent(domainId);
if(null != contents && !"".equals(contents)){%>
<section class="category hidden-xs">
   <div class="container">
     <div class="row">
       <div class="col-md-12 col-sm-12 col-xs-12">
             <div id="home-intro" class="box">
                 <%=contents%>   
             </div>
           </div>
       </div>
   </div>
 </section>  
<%}%> 
<!-- ================================Content Start===================================-->  

<%if("17".equals(domainId)){ %>
         <%@include file="common/pr.jsp"%>        
    <%}%>
  
<%@include file="common/bottomMenu.jsp" %>  
</div>  
<%@include file="common/footer.jsp" %> 
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("indexcoupon.jsp").log(Level.SEVERE, null, e);
} finally {

}%>  
