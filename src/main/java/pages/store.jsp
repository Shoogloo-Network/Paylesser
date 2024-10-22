<%-- 
    Document   : store.jsp
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:52:39 AM
    Author     : Vivek
--%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="java.text.DateFormat"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
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
  //String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
  //String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
  //String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  //String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  //boolean top = true;
  //boolean vouchers = true;
  //boolean deals = true;
 
  String domainName = "";
  String pageName = "";
  domainName = (String) session.getAttribute("domainName");
  pageName = (String) session.getAttribute("pageName");
  String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
  String pageType = SystemConstant.STORE;
  String voucherClass = "";
  String voucherDesc = "";
  String storeName = "";
  String storeId = "";
  String storeUrl = "";
  String merchantUrl = "";
  String banner = "";
  String bannerUrl = "";
  //int categoryCount = 0;
  String requestUrl1 = "http://" + domainName+"/"+pageName;
  int vote = 0;
  double rating = 0;
  double totalVote = 0;
  String totalVoteFormat = "";
  java.text.DecimalFormat number_format = new java.text.DecimalFormat("#.0");
  VcHome home = VcHome.instance();
  VcSession vcsession = VcSession.instance();
  String domainId = home.getDomainId(domainName);
  //List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domainId); // active domain
  List<Language> languages = home.getLanguages(domainId);
  Language language = vcsession.getLanguage(session, domainId, languages);
  Properties p = home.getLabels(language.getId());
  HomeConfig homeConfig = home.getConfig(domainId);
  //List<SeoUrl> seoList = home.getSeoStoreByDomainId(domainId);
  //Feature #17: Category specific "We Recommend"
  List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
  String pageTypeFk = "";
  String pageTitle = "";
  String metaKey = "";
  String metaDesc = "";
  String news = "";
  String reason = "";
  String affiliateUrl = "";
  String fbLink = "";
  String gpLink = "";
  String pnLink = "";
  String twLink = "";
  String phone = "";
  String email = "";
  String cod = "";
  String netBank = "";
  String moneyBack = "";
  String bannerPosition = "";
  String aboutStore = "";
  String aboutTitle = "";
  String storeChildTitle = "";
  String storeChildDesc = "";
  String url = "";
  //String howToUseUrl = null;
  String pinImage = "";
  String categoryId = null;
  String storeId1 = null;
  String storeIdGt = null;
  String brandId = null;
  String storeBrandId = null;
  String storePageType = "";
  String brandName = "";
  String howTouse = null;
  String titleType = "";
  String pageId = "";
  String date = "";
  String month = "";
  String year = "";
  String titleDate = "";
  String imagePath = "";
  String certified = "";
  String storeCaption = "";
  String childId = null;
  String storeChildHeading = null;
  String storeTopContent = null;
  String appUrl = null;
  String iosUrl = null;
  String affiliate = "";
  String smallImage = "";
  String bigImage = "";
  String similarStoreIds = "0";
  String catIds = "0";
  String catSCIds = "0";
  
  session.setAttribute("page", "store");
  Calendar cal = Calendar.getInstance();
  date = new SimpleDateFormat("dd").format(cal.getTime());
  //month = new SimpleDateFormat("MMMM").format(cal.getTime());
  month = cal.getDisplayName(Calendar.MONTH, Calendar.LONG, new Locale(language.getCode()) );
  year = year = new SimpleDateFormat("YYYY").format(cal.getTime());
  SeoUrl seo2 = CommonUtils.getSeoUrlStore(domainId, pageName, language.getId());
  String langId = CommonUtils.getcntryLangCd(domainId);
  url = SystemConstant.PUBLIC + seo2.getSeoUrl();
  String mDate = null;
  pageTypeFk = seo2.getStoreId();
  childId = seo2.getCategoryId();
  storePageType = seo2.getPageType();
  pageId = seo2.getPageTypeFk();
  pageTitle = seo2.getPageTitle();
  metaKey = seo2.getMetaKeyword();
  metaDesc = seo2.getMetaDesc();
  storeChildTitle = seo2.getStoreChildTitle();
  storeChildDesc = seo2.getStoreChildDesc();  
  storeChildHeading = seo2.getStoreChildHeading();
      
  List<Store> storeListById = home.getAllStoreById(pageTypeFk);
 /* List<SeoUrl> seoListHow = home.getSeoByDomainId(domainId);
  for (SeoUrl seo1 : seoListHow) {
    if (SystemConstant.HOW_TO_USE.equals(seo1.getPageType()) && pageTypeFk.equals(seo1.getPageTypeFk()) && language.getId().equals(seo1.getLanguageId())) {
      howToUseUrl = seo1.getSeoUrl();
      break;
    }
  }*/
  List<StoreCategory> storeCategoryList = home.getStoreCatName(pageTypeFk);
  List<StoreCategory> storeCategorySCList = home.getStoreCatNameSC(pageTypeFk);
  List<StoreBrand> storeBrandList = home.getStoreBrandName(pageTypeFk);
  List<VoucherDeals> vdListById = null;
      if(storeCategoryList != null) {
      for(StoreCategory s: storeCategoryList) {
        if(s.getLanguageId().equals(language.getId())){ 
            catIds  += "," + s.getId();
        }
      }
    }
     if(storeCategorySCList != null) {
      for(StoreCategory s: storeCategorySCList) {
        if(s.getLanguageId().equals(language.getId())){ 
            catSCIds  += "," + s.getId();
        }
      }
    }  
  if (SystemConstant.STORE.equals(storePageType)) {
    titleType = SystemConstant.STORE;
    titleDate = " - " + month + " "+ year;
    vdListById = home.getAllVDById(pageTypeFk);
  } else if (SystemConstant.STORE_CATEGORY.equals(storePageType)) {
    vdListById = home.getStoreCatOfferByStoreId(pageTypeFk, childId);
    if(storeCategoryList != null) {
      for(StoreCategory s: storeCategoryList) {
        if(s.getLanguageId().equals(language.getId())){ 
          if(childId.equals(s.getParentId())){
            brandName = s.getName()+"&nbsp;";
            titleDate = " - " + month + " "+ year;
            break;
          }
        }
      }
    }
  } else if (SystemConstant.STORE_BRAND.equals(storePageType)) {
    vdListById = home.getStorBrandOfferByStoreId(pageTypeFk, childId);
    if(storeBrandList != null) {
      for(StoreBrand s: storeBrandList) {
        if(s.getLanguageId().equals(language.getId())){
          if(childId.equals(s.getParentId())){
            brandName = s.getName()+"&nbsp;";
            titleDate = " - " + month + " "+ year;
            break;
          }
        }
      }
    }    
  }

  //List<Category> popCategoryList = home.getCatByDomainId(domainId);
  List<VoucherDeals> vdExpiredListById = home.getExpiredVouchersStore(pageTypeFk);
  List<MetaTags> metaList = home.getMetaByDomainId(domainId); 
  
  String cdnPath1 = "";
  if(domainName.startsWith("www")){
      cdnPath1 = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath1 = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
 
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage">    
  <head>     
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><%=pageTitle + titleDate%></title>
    <meta name="description" itemprop="description" content="<%=metaDesc%>">
    <meta name="keywords" content="<%=metaKey%>">
    <meta name="viewport" content="width=device-width, initial-scale=1">  
    <%
    if (storeListById != null) {
      for (Store st : storeListById) {
        smallImage = st.getImageSmall();
        storeCaption = st.getStoreCaption();
        if(storeChildHeading ==  null || "".equals(storeChildHeading)){
            storeCaption = storeCaption;
          } else{
            storeCaption = storeChildHeading;
          }
        if (st.getLanguageId().equals(language.getId())) {%>  
        <link rel="canonical" href="<%=pageUrl+st.getSeoUrl()%>" />  
        <meta property="og:url"           content="<%=pageUrl+st.getSeoUrl()%>" />
        <meta property="og:type"          content="website" />
        <meta property="og:image"          content="<%=SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length())+st.getImageBig()%>" />
        <meta property="og:title"         content="<%=pageTitle%>" />
        <meta property="og:description"   content="<%=metaDesc%>" />
    <%         
            storeName = st.getName();
            storeId1 = st.getId();
            storeUrl = st.getSeoUrl();
            merchantUrl = st.getStoreUrl();
            storeIdGt = st.getId();
            pinImage = cdnPath1 + st.getImageBig();
            smallImage = cdnPath1 + st.getImageSmall();
            news = st.getNews();
            reason = st.getReason();
            certified = st.getCertified();
            if("".equals(st.getFbLink()) || st.getFbLink() == null){
              fbLink = "#";
            } else {
              fbLink = st.getFbLink();
            }
            if("".equals(st.getGpLink()) || st.getGpLink() == null){
              gpLink = "#";
            } else {
              gpLink = st.getGpLink();
            }
            if("".equals(st.getTwLink()) || st.getTwLink() == null){
              twLink = "#";
            } else {
              twLink = st.getTwLink();
            }
            if("".equals(st.getPnLink()) || st.getPnLink() == null){
              pnLink = "#";
            } else {
              pnLink = st.getPnLink();
            }                        
            howTouse = st.getHowToUse();
            affiliateUrl = st.getAffiliateUrl();
            cod = st.getCod();
            netBank = st.getNetBank();
            moneyBack = st.getMoneyBack();
            bannerPosition = st.getBannerPosition();
            aboutStore = st.getAboutStore();
            email = st.getEmail();
            phone = st.getPhone();
            aboutTitle = st.getAboutTitle();
            if (st.getBannerImageUpload() != null) {
              banner = cdnPath1 + st.getBannerImageUpload();
            } else if (st.getBannerImageUrl() != null) {
              banner = st.getBannerImageUrl();
            }
            bannerUrl = st.getBannerImageHref();
            vote = Integer.parseInt(st.getVote());
            rating = Double.parseDouble(st.getRating());
            if (vote == 0) {
              vote = 1;
              rating = 1;
            }
            totalVote = rating / vote;
            totalVoteFormat = number_format.format(totalVote);

            affiliate = st.getAffiliate();
            storeTopContent = st.getTopContent();
            appUrl = st.getAppUrl();
            iosUrl = st.getIosUrl();
            bigImage = cdnPath1 + st.getImageBig();        
         }}} %> 
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %> 
        
    <%@include file="common/header.jsp" %>
    </head>
    <compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
    <div id="wraper" class="inner" > 
     <%@include file="common/topMenu.jsp" %>
   
    <!-- ======================Company Profile Start==================== -->
<main>
    <div class="store-middle" >
        <div class="container">
            <div class="row">
                     
                 <!-- -------------------Sidebar Start------------------------->
                 
                 <div class="col-lg-9 col-md-12 col-sm-12 col-xs-12 pull-right">
                     <div class="page-header storeTopContent hidden-xs">
                         <h1><%=storeCaption%></h1>&nbsp;<span class="date"><%=titleDate%></span>
                                    <%if(storeTopContent!=null && !"".equals(storeTopContent)){%>
                                    <%=storeTopContent%>                                    
                                    <%
                                    }
                                    if("1".equals(affiliate)) {
                                    %>
                                    <!-- -----Filter By Type------>
                                    <%@include file="common/filterByTypeTop.jsp" %>
                                    <%
                                    }  
                                    %> 
                                </div>
                 </div>
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs hidden-sm">
                    <div class="sidebar">
                    
                        <!-- -----Profile Logo------>
                        <div class="side-col company-profile">
                            <div class="company-logo">
                                <a href="/sout?id=<%=storeId1%>" target="_blank" rel="nofollow"><img itemprop="image" src="<%=bigImage%>" alt="<%=storeCaption %>"></a>
                              <!--  <a href="<%=affiliateUrl%>" target="_blank" rel="nofollow" style="display:inline-block;width:100%;margin-top:15px;color:#4a4a4a;text-decoration:underline" itemprop="url"><%=p.getProperty("public.store.visit.up")%></a> -->
                            </div>              
                            <div class="rating" id="rate-store" itemscope="" itemtype="http://schema.org/Brand">
                                <meta itemprop="name" content="<%=storeName%>">
                                 <div class="basic" style="margin: 0 auto;" data-average="<%=totalVoteFormat%>" id="totalVote" data-id="1"></div>
                                 <div class="vote" itemprop="aggregateRating" itemscope="" itemtype="http://schema.org/AggregateRating">
                                   <%//=p.getProperty("public.store.n_v")%>
                                   <meta itemprop="ratingCount" content="<%=vote%>"/>
                                   <meta itemprop="ratingValue" content="<%=totalVoteFormat%>"/>
                                   <meta itemprop="bestRating" content="5"/>
                                   <meta itemprop="worstRating" content="0"/>
                                   <meta itemprop="itemReviewed" content="<%=storeName%>"/>
                                   <h3><%=vote%><%if(vote>1){%> users <%}else{%> user <%}%>  rated <%=storeName%>&nbsp;<%=totalVoteFormat%></h3>                         
                               </div>
                            </div>                            
                            <%if ("1".equals(homeConfig.getSocialMedia())) {%>
                             <!--<div class="social-share">
                                  <div style="vertical-align: top;" class="fb-like"  data-href="<%=requestUrl1%>" data-layout="button_count" data-action="like"></div>
                                  <script src="<%=SystemConstant.PATH%>js/platform.js" async defer></script>
                                  <div style="height:20px;width:85px;display:inline-block"><div class="g-plusone" data-size="standard" data-count="true"></div></div>
                                  <a rel="nofollow" target="_blank" href="http://pinterest.com/pin/create/button/?url=<%=requestUrl1%>;media=<%=pinImage%>;description=<%=pageTitle%>" id="pin" class="dnt-alter">
                                      <img style="vertical-align: top;" src="<%=SystemConstant.PATH%>images/pintrest.png" alt="image">
                                  </a>
                              </div> --> 
                            <%
                              }
                            %> 
                            <%if((appUrl!=null && !"".equals(appUrl)) || (iosUrl!=null && !"".equals(iosUrl))){%>
                                <%if(appUrl!=null && !"".equals(appUrl)){%>
                                   <a href="<%=appUrl%>" target="_blank" rel="nofollow" class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/android-app-store.png" alt="Download App"></a>
                                <%}else{%>
                                   <a class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/android-app-store.png" alt="Download App"></a>
                                <%}%>   
                                <%if(iosUrl!=null && !"".equals(iosUrl)){%>   
                                   <a href="<%=iosUrl%>" target="_blank" rel="nofollow" class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/apple-app-store.png" alt="Download App"> </a>
                                <%}else{%>
                                   <a class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/apple-app-store.png" alt="Download App"> </a>
                                <%}%> 
                             <%}%>

                        </div>
                 
                        <%
                            if (!"".equals(banner) && "0".equals(bannerPosition)) {
                        %>  
                        <div class="ad-banner">
                            <a href="<%=bannerUrl%>" target="_blank" rel="nofollow"><img src="<%=banner%>" alt="banner" /></a> 
                        </div>
                        <% } %>
                       
                         <!-- -----Other Info------>
                         <%if ((!"".equals(reason) && reason != null) || (!"".equals(howTouse) && howTouse != null)) { %>
                        <aside class="side-col other-info">
                            <article>
                                                        
                                    <%if (!"".equals(reason) && reason != null) { %>
                                    <div class="reason">
                                        <div class="col-md-2 icon"><i class="fa fa-thumbs-up"></i></div>
                                        <div class="col-md-10"><h2><%=p.getProperty("public.store.reasons")%>&nbsp;<%=storeName%></h2></div>
                                        <div class="col-md-12"><%=reason%></div> 
                                    </div>
                                     <% } if (!"".equals(howTouse) && howTouse != null) { %>
                                        <div class="reason">
                                            <div class="col-md-2 icon"><i class="fa fa-question"></i></div>
                                            <div class="col-md-10"><h4><%=p.getProperty("public.home.howtouse")%>&nbsp;<%=storeName%>&nbsp;<%=p.getProperty("public.home.coupons")%></h4></div>
                                            <div class="col-md-12" style="margin-top:10px;"><%=howTouse%></div> 
                                        </div>
                                    <%}%>
                             </article>
                        </aside>
                        <%}%>
                                
                        <%--
                        if("1".equals(affiliate)) {
                        %>
                        <!-- -----Filter By Type------>
                        <%@include file="common/filterByType.jsp" %>
                        <%
                        }  
                        --%>
                        <!-- -----Side Banner 1----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="1" />
                            <jsp:param name="affiliate" value="<%=affiliate%>" />
                        </jsp:include>
                      
                        <!-- -----Related Category------>
                       <%//@include file="common/relatedCategory.jsp" %>                        
                        
                        <!-- -----Side Banner 2----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="2" />
                            <jsp:param name="affiliate" value="<%=affiliate%>" />
                        </jsp:include>
                        
                        <% if(!isMobile){ %> 
                        <!-- -----Related Store------>
                          <%@include file="common/relatedStores.jsp" %> 
                        <% } %>  
                        <!-- -----Side Banner 1----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="3" />
                            <jsp:param name="affiliate" value="<%=affiliate%>" />
                        </jsp:include>
                        
                        <!-- -----Subscribe------>
                        <%@include file="common/subscribe.jsp" %>  
                      
                        
                        <!-- -----Side Banner 3----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="4" />
                            <jsp:param name="affiliate" value="<%=affiliate%>" />
                        </jsp:include>
                        
                        <!-- -----Related Brand------>
                        <%@include file="common/relatedBrand.jsp" %>                       
                        
                        <!-- -----Side Banner 4----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="5" />
                            <jsp:param name="affiliate" value="<%=affiliate%>" />
                        </jsp:include>
                        
                        
                         <!-- -----Other Info------>
                        <div class="side-col other-info">
                                 <div class="social-list">
                                        <div class="col-md-2 icon"><i class="fa fa-globe"></i></div>
                                        <div class="col-md-10">
                                            <h3 class="visit"><%=storeName+" "+p.getProperty("public.store.visit")%></h3>
                                            <p><a href="/sout?id=<%=storeId1%>" target="_blank" rel="nofollow"><%=merchantUrl%></a></p>
                                        </div> 
                                    </div>
                                    <%
                                       // if ("1".equals(homeConfig.getSocialMedia()) && (!"#".equals(fbLink) || !"#".equals(gpLink) || !"#".equals(pnLink) || !"#".equals(twLink))) {
                                    %> 
                                    <!--<div class="social-list">
                                        <div class="col-md-2 icon"><i class="fa fa-users"></i></div>
                                        <div class="col-md-10">
                                            <h4><%//=p.getProperty("public.store.social")%></h4>
                                            <img src="<%//=smallImage%>" alt="<%//=SolrUtils.toDisplayCase(storeUrl.replace("-", " ")) %>" style="display:none;">
                                            <p class="social-icons">
                                                <%//if(!"#".equals(fbLink)) { %><strong class="icon-fb"> <a class="btn" href="<%//=fbLink%>" target="_blank" ><i class="fa fa-facebook"></i></a> </strong><%// } %>
                                                <%//if(!"#".equals(twLink)) { %><strong class="icon-tw"> <a class="btn" href="<%//=twLink%>" target="_blank" ><i class="fa fa-twitter"></i></a> </strong><%//} %>
                                                <%//if(!"#".equals(gpLink)) { %><strong class="icon-gp"> <a class="btn" href="<%//=gpLink%>" target="_blank" ><i class="fa fa-google-plus"></i></a> </strong><% //} %>
                                                <%//if(!"#".equals(pnLink)) { %><strong class="icon-in"> <a class="btn" href="<%//=pnLink%>" target="_blank" ><i class="fa fa-pinterest-p"></i></a> </strong><% //} %>
                                            </p>
                                        </div> 
                                    </div>-->
                                    <% //} %>
                                    <%
                                    if((phone != null && !"".equals(phone)) || ( email != null && !"".equals(email))) {
                                    %>
                                     <div class="social-list">
                                        <span class="col-md-2 icon"><i class="fa fa-mobile"></i></span>
                                        <span class="col-md-10">
                                            <h4><%=p.getProperty("public.store.customer")%></h4>
                                            <%if(email != null && !"".equals(email)) { %><p class="word-wrap"><%=p.getProperty("public.login.email")%> : <a href="mailto:<%=email%>" rel="nofollow"> <%=email%></a></p><% } %>
                                            <%if(phone != null && !"".equals(phone)) { %><p> <%=p.getProperty("public.store.contact")%> :  <span><%=phone%></span> </p><% } %>
                                        </span> 
                                    </div>
                              
                                    <% } %>
                        </div>
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->        
                        
                
                <!-- -------------------Offer List Start------------------------->
                <div class="pull-right col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header hidden-xs" style="border-bottom: none;margin-bottom: 0">
                           <div class="row"> 
                                
                            </div>                            
                        </div>
                               
                        <div class="m-page-heading">
                         <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                <div class="page-image">
                                    <img alt="<%=storeName%> coupon" title="<%=storeName%> offers" src="<%=smallImage%>">
                                </div>
                            </div>
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                <div class="page-info">
                                    <h3><%=storeCaption%></h3>
                                    <p><img src="<%=SystemConstant.PATH%>images/veri-icon.png" alt="verified">Verified On: <%=date+" "+month+" "+year%></p>

                                    <%if((appUrl!=null && !"".equals(appUrl)) || (iosUrl!=null && !"".equals(iosUrl))){%>
                                        <%if(appUrl!=null && !"".equals(appUrl)){%>
                                           <a href="<%=appUrl%>" class="app lazy" target="_blank" rel="nofollow"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/android-app-store.png" alt="Download App"></a>
                                        <%}else{%>
                                           <a class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/android-app-store.png" alt="Download App"></a>
                                        <%}%>   
                                        <%if(iosUrl!=null && !"".equals(iosUrl)){%>   
                                           <a href="<%=iosUrl%>" class="app lazy" target="_blank" rel="nofollow"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/apple-app-store.png" alt="Download App"> </a>
                                        <%}else{%>
                                           <a class="app lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=SystemConstant.PATH%>images/apple-app-store.png" alt="Download App"> </a>
                                        <%}%> 
                                     <%}%>
                                </div>
                            </div>  
                          </div>
                        <%@include file="common/filterByType.jsp" %>
                        </div>   
                        <!-- -------------------Offer Filter End------------------------->
                    <div class="offer-list">
                        
                        <!-- -------------------Offer Item Start------------------------->
                        <%//Ishaq For Mobile View and Exclusive
                        List<VoucherDeals> mobileVdListById = new ArrayList<VoucherDeals>();
                        List<VoucherDeals> deskVdListById = new ArrayList<VoucherDeals>();
                        if (vdListById != null) {
                        Date firstCDate = new Date(vdListById.get(0).getModifiedAt());                            
                         for (VoucherDeals vd : vdListById) {
                        Date cCDate = new Date(vd.getModifiedAt());
                             if(cCDate.after(firstCDate)){
                                firstCDate = cCDate;                          
                             }
                             mDate = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).format(firstCDate.getTime());
                            // vd.setStoreSeoUrl(null);
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
                        %>    
                        
                        <%
                        if (mobileVdListById != null) {
                          for (VoucherDeals vd : mobileVdListById) {
                            if (vd.getLanguageId().equals(language.getId())) {
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
                        %>
                        <%@include file="common/mobOffer.jsp" %> 
                        <% } } } %>
                        
                        <%
                        if (deskVdListById != null) {
                          for (VoucherDeals vd : deskVdListById) {
                            if (vd.getLanguageId().equals(language.getId())) {
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
                        %>
                        <%@include file="common/deskOffer.jsp" %> 
                        <% } } } %>
                        <!-- -------------------Offer Item End------------------------->
                    </div>                              
                   <% if(vdListById == null && "1".equals(affiliate)) { %>
                   
                    <div class="offer-item desk-offer-content offer">
                       <div class="row">
                          <div class="item-top">
                             <div class="col-lg-2 col-md-2 col-sm-2 col-xs-4">
                                <div class="offer-value">
                                   <figure><img alt="<%=SolrUtils.toDisplayCase(storeUrl.replace("-", " ")) %>" src="<%=smallImage%>"></figure>
                                </div>
                             </div>
                             <div class="col-lg-7 col-md-7 col-sm-7 col-xs-8">
                                <div class="offer-info">
                                   <h3><%=p.getProperty("public.store.default.title")%></h3> 
                                   <p><%=p.getProperty("public.store.default.desc1")%><%=" "+storeName+" "%><%=p.getProperty("public.store.default.desc2")%></p>
                                </div>
                             </div>
                             <div class="col-lg-3 col-md-3 col-sm-3 col-xs-8">
                                 <div class="button-bar"> <a href="/sout?id=<%=storeId1%>" target="_blank" rel="nofollow" class="my-coupon"><span class="get-coupon"><%=p.getProperty("public.category.activate_deal")%></span></a> </div>
                             </div>
                          </div>
                       </div>
                    </div>
                             
                   <%}else if(vdListById == null && !"1".equals(affiliate)){%> 
                   
                   <div class="offer-item desk-offer-content offer">
                       <div class="row">
                          <div class="item-top">
                             <div class="col-lg-2 col-md-2 col-sm-2 col-xs-4">
                                <div class="offer-value">
                                   <figure><img alt="<%=SolrUtils.toDisplayCase(storeUrl.replace("-", " ")) %>" src="<%=smallImage%>"></figure>
                                </div>
                             </div>
                             <div class="col-lg-7 col-md-7 col-sm-7 col-xs-8">
                                <div class="offer-info">
                                   <h3><%=p.getProperty("public.store.no_current_offers")%></h3> 
                                   <p><%=p.getProperty("public.store.no_current_offers_desc")%></p>
                                </div>
                             </div>
                             <div class="col-lg-3 col-md-3 col-sm-3 col-xs-8"> &nbsp; </div>
                          </div>
                       </div>
                    </div>
  
                    <%@include file="common/similarCoupons.jsp" %>              
                   <%}else if(vdListById != null && !"1".equals(affiliate)){%>
                     <%@include file="common/similarCoupons.jsp" %> 
                   <%}%>
                   <% /*
                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date currentDate = new Date();
                    String today="Today";
                    if(mDate != null && dateFormat.format(currentDate).indexOf(mDate)==-1){
                        today="Yesterday";
                        currentDate = DateUtils.addDays(new Date(), -1);                        
                    } 
                    
                   */%>
                    <!--<div class="last-updated">
                       <h3><time itemprop="lastReviewed" datetime="<%//=dateFormat.format(currentDate)%>"><strong>Last Updated:</strong> <%//=today%></time></h3>
                    </div>-->
                   
                   
                 <%//@include file="common/recommendByCat.jsp" %>
                <%
                if (vdExpiredListById != null) {
                %>
                <!-- -------------------Offer List Start------------------------->
                    <div class="new-related">
                        <!-- -------------------Offer Filter Start------------------------->
                        
                        <div class="section-title hidden-xs">
                            <h2><%=storeName%> - <%=p.getProperty("public.home.expired_vouchers")+" "%> </h2>
                        </div>
                        <!-- -------------------Offer Filter End------------------------->
                        <ul>
                        <%
                        int expiredCount = 0;
                        expired = "exp";
                        for (VoucherDeals vd : vdExpiredListById) {
                          if (language.getId().equals(vd.getLanguageId())) {
                            if (expiredCount < 5 && vd.getOfferHeading() != null) {
                                expiredCount++;
                            if ("1".equals(vd.getOfferType())) {
                               voucherClass = "click-to-code vpop";
                               voucherDesc = p.getProperty("public.category.click_code");
                             } else if ("2".equals(vd.getOfferType()) && vd.getOfferImage() == null) {
                               voucherClass = "activate-deal-2";
                               voucherDesc = p.getProperty("public.category.activate_deal");
                             } else if ("2".equals(vd.getOfferType()) && vd.getOfferImage() != null) { //product deal
                               voucherClass = "activate-deal";
                               voucherDesc = p.getProperty("public.category.activate_deal");
                             }

                            String sCurrenySysmbol = CommonUtils.getCurrency(domainId);
                            String sCurrenyValue = "";                           
                            if(vd.getBenifitValue() != null && !"".equals(vd.getBenifitValue())) {
                              sCurrenyValue = vd.getBenifitValue().trim();
                            } 
                        %>
                        <li><span><i class="fa fa-tag" aria-hidden="true"></i><%=vd.getOfferHeading()%></span></li>
                        <% } } } %>
                        </ul>
                    </div>
                <% } %>   
                <% if(isMobile){ 
                    List<String> storesListSimilar=null;
                    if(SystemConstant.STORE.equals(pageType)){
                      storesListSimilar = !"".equals(pageTypeFk) ? home.getSimilarStores(pageTypeFk, domainId) : null;  
                    }else{
                      storesListSimilar = home.getSimilarStoresTopPages(storeId, domainId);  
                    } 
                    int storeCount = 0;  
                    if (storesListSimilar != null && storesListSimilar.size() > 0) {  
                %>
                    <div class="side-col related-stores-mob">
                        <% if(SystemConstant.STORE.equals(pageType)){ %>
                        <h3><%=p.getProperty("public.category.similiar_stores")%></h3>
                        <% } else { %>
                        <h3><%=p.getProperty("public.home.popular")%></h3><% }%>
                        <ul class="mob-similar-store">                        
                        <%
                            for (String s : storesListSimilar) {
                              List<Store> simStoreListById = home.getAllStoreById(s);
                              if(simStoreListById != null) {
                                for (Store st : simStoreListById) {
                                  if (st.getLanguageId().equals(language.getId()) && home.getStoreOfferCount(st.getId())!=null) {
                                    storeCount++;                 
                        %> 
                        <li><a href="<%=pageUrl + st.getSeoUrl()%>"><%= st.getName()%></a></li>
                        <% 
                            } } } 

                            if (storeCount > 5) {
                             break;               
                           }
                        } 
                        %>        
                        </ul>    
                    </div>
                <%} }%>
                
                 <%if(domainId.equals("5") || domainId.equals("18") || domainId.equals("16")||domainId.equals("8")
                         || domainId.equals("24")|| domainId.equals("26")|| domainId.equals("37")
                         || domainId.equals("20")|| domainId.equals("17")|| domainId.equals("19")
                         || domainId.equals("14")|| domainId.equals("33")){
                    String shortname="";
                    if(domainId.equals("5")){shortname="vouchercodesin";}
                    if(domainId.equals("18")){shortname="vouchercodes-hk";}
                    if(domainId.equals("16")){shortname="couponcodes-co-uk";}
                    if(domainId.equals("8")){shortname="aucouponcodes-com-au";}
                    if(domainId.equals("24")){shortname="myvouchercodes-ae";}
                    if(domainId.equals("26")){shortname="vouchercodes-com-br";}
                    if(domainId.equals("37")){shortname="vouchercodes-fr";}
                    if(domainId.equals("20")){shortname="vouchercodes-co-id";}
                    if(domainId.equals("17")){shortname="vouchercodes-com-my";}
                    if(domainId.equals("19")){shortname="myvouchercodes-ph";}
                    if(domainId.equals("14")){shortname="vouchercodescom-sg";}
                    if(domainId.equals("33")){shortname="vouchercodesthai-com";}
                  
                 %>
                 
                        <!-- -------------------Offer Item End------------------------->   
                   <!--<h3>Post Your Comments</h3>
                   <div id="disqus_thread"></div>
                   <script>
                       // var disqus_shortname="<%=shortname%>";(function(){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="//"+disqus_shortname+".disqus.com/embed.js";(document.getElementsByTagName("head")[0]||document.getElementsByTagName("body")[0]).appendChild(n)})();
                   </script>
                   -->
                  <%}%>
                  
                
                <!-- -------------------Offer List End---------------------------->              
                
                <div id="home-intro" class="box hidden-xs">
                    <%
                    if(brandName != null && !"".equals(brandName)) {
                    %>
                    <h2><%=storeChildTitle == null ? "" : storeChildTitle%></h2>
                    <%=storeChildDesc == null ? "" : storeChildDesc%>
                    <%
                    }
                    else {
                    %>
                    <h2><%=aboutTitle == null ? "" : aboutTitle%></h2>
                    <%=aboutStore == null ? "" : aboutStore%>
                  <%
                    }
                  %>
                </div>
                </div>
            </div>  
                         
        </div>
    </div>
    
   
   </main> 
</div>
<!--                  
<%if(mDate!=null){%>                
  <meta itemprop="dateModified" content="<%=mDate%>" />   
<%}%>
-->
<!-- ======================Company Profile End==================== -->
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>
<script type="text/javascript">
    storeId = <%=pageTypeFk%>;
    //userId = <%=loggedIn%>;
    cordStore = 0;
    $(document).ready(function() {
      
     /*setTimeout(function(){        
        $.ajax({
            url: '/pages/common/catStr.jsp?t=1&rId='+storeId,
            success: function (r) {},
            async: true
        });         
     }, 1000);*/   
     
      $('.basic').jRating({
        length: 5,
        step: true,
        bigStarsPath: '<%=SystemConstant.PATH%>images/stars.png'
      });
    });
</script> 
</body>

</compress:html>
</html>

<%} catch (Throwable e) {
        Logger.getLogger("store.jsp").log(Level.SEVERE, null, e);
    } finally {

}%>
