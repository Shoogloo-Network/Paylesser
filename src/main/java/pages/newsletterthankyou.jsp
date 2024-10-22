<%-- 
    Document   : index
    Created on : Nov 24, 2014, 10:11:41 AM
    Author     : sanith.e
--%>
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
        String domainName = "";
        String pageName = "";
        domainName = (String) session.getAttribute("domainName");
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        String tabConfigCalss = "";
        int storeRows = 0;
        int top20 = 0;
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
        VcHome home = VcHome.instance();
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
		if(domainId == null) {
			domainId = (String) session.getAttribute("domainId");
		}
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        List<VoucherDeals> offerDealList = home.getOfferByDomainId(domainId);
        List<VoucherDeals> voucherList = home.getVoucherByDomainId(domainId);
        List<VoucherDeals> dealList = home.getDealByDomainId(domainId);
        List<Banner> bannerList = home.getBannerByDomainId(domainId);
        List<Category> popCategoryList = home.getPopCatByDomainId(domainId);
        List<Store> allStoreListByDomain = home.getAllStoresByDomainId(domainId);
        List<VoucherDeals> popOfferList = home.getPopOfferByDomainId(domainId);
        Map<String, String> popCatIdMap = new HashMap<String, String>();
        Map<String, String> popCatIdBgMap = new HashMap<String, String>();
        String currentId = "";
        String voucherClass = "";
        String voucherDesc = "";
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
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html class="no-js"  lang="<%=session.getAttribute("isoCode")%>"> 
    
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <title itemprop="name">Thanks for your subscription</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
         String imagePath = "";
        String storeId = "0";
        int top20Counter = 0;
        %>        
        <%@include file="common/header.jsp" %>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
     <!-- ======================Main Wraper Start==================== -->
    <div id="wraper" class="inner"> 
    <%@include file="common/topMenu.jsp" %>
    <div class="error-page">
        <div class="container">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="" style="width:100%;text-align:center">
                        <h3 class="section-title"><%=p.getProperty("public.home.newsletter.subscribe_thankyou")%></span></h3>
                        <a href="/" class="back" style="max-width:180px">Go to Home</a>
                    </div>   
                </div>
            </div>    
        </div>
    </div>
    <!-- ================================Top Coupons Start===================================--> 
 <section class="category">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="section-title">
              <h2>Top Coupons / Offers</h2>
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
                        if (offerDealList != null) {
                         for (VoucherDeals vd : offerDealList) {
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
                                    <img alt="" src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreCaption()!=null?vd.getStoreCaption():vd.getStoreName()%>">
                                </div>
                                <div class="item-info">
                                    <p><%=vd.getOfferHeading()%></p>
                                    <%if ("1".equals(vd.getOfferType())) {%>
                                    <a data-type="20" data-lang="<%=vd.getLanguageId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-btn"><%=voucherDesc%></a>
                                    <%} else {%>
                                    <a data-of="<%=vd.getId()%>" class="u-deal my-btn"><%=voucherDesc%></a>
                                    <% } %>
                                    <a href="<%=pageUrl + vd.getStoreSeoUrl() %>" class="available"><%=(home.getStoreOfferCount(vd.getStoreId()))==null?0: Integer.parseInt(home.getStoreOfferCount(vd.getStoreId()))-1%> More Offers Available</a>   
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
    </div>
    <%@include file="common/bottomMenu.jsp" %>
    <%@include file="common/footer.jsp" %>
    </body>
    
    
</compress:html>
</html>
<%} catch (Throwable e) {
        Logger.getLogger("newsletterthankyou.jsp").log(Level.SEVERE, null, e);
    } finally {
    }%>