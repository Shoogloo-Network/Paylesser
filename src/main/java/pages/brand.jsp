<%-- 
    Document   : brand
    Created on : Dec 29, 2014, 2:25:23 PM
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
<%@page import="sdigital.vcpublic.config.*"%>
<%
try {
String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");  
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
boolean top = true;
boolean vouchers = true;
boolean deals = true;
//out.println(request.getRequestURL());
String requestUrl = request.getRequestURL().toString();
//String requestUrl = "test.vouchercodes.in:8080/vcadmin/faces/public/index.jsp";
String domainName = "";
String pageName = "";
domainName = (String)session.getAttribute("domainName");
pageName = (String)session.getAttribute("pageName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
String voucherClass = "";
String voucherDesc = "";
String pageType = "0";
pageType = SystemConstant.BRAND;
String pageTypeFk = "";
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId); // active domain
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage((HttpSession) session, domain.getId(), languages);
Properties p = home.getLabels(language.getId());
HomeConfig homeConfig = home.getConfig(domainId);
List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
List<Brand> brandList = home.getBrandByDomainId(domainId);
String brandId = null;

  if(brandList != null) {
    for(Brand b : brandList) {
      if(pageName.equals(b.getSeoUrl()))
        if(b.getLanguageId().equals(language.getId())) {
          brandId = b.getId();
          break;
        }
    }
  }

pageTypeFk = brandId;
List<VoucherDeals> offerDealList = home.getBrandOfferByDomainId(domainId,brandId);
List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
String storeId = "0";
String catName = "";
String imagePath = "";
String langId = CommonUtils.getcntryLangCd(domainId);
%>
<!DOCTYPE html> 
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">				
        <%
          if(brandList != null) {
            for(Brand brand:brandList) {
              if(brandId.equals(brand.getId())){
                  if(language.getId().equals(brand.getLanguageId())) {%>
                      <title itemprop="name"><%=brand.getTitle()%></title>
                      <meta name="description" content="<%=brand.getMetaDescription()%>">
                      <meta name="keywords" content="<%=brand.getMetaKeyword()%>">
        <%
                  break;
                  }
              }
            }
          }
        %>
        <meta name="viewport" content="width=device-width, initial-scale=1">

    <%@include file="common/header.jsp" %>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
   <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        
   <div id="wraper" class="inner">   
    <%@include file="common/topMenu.jsp" %> 
    <div class="store-middle">
        <div class="container ">
            <div class="row">
                    <!-- Navigation -->
                    <div class="page-content clearfix inner-page merchant-page">
                       <div class="main-offers-wrap wrapper clearfix">
                            <h2 class="common-head"><%=p.getProperty("public.category.categories")%></h2>
                            <select class="left-col category-select" id="category-select">
<%
                                
                                if(brandList != null) {
                                  for(Brand brand:brandList){
                                    if(brand.getLanguageId().equals(language.getId())){
                                      if(brandId.equals(brand.getId())){
                                        catName = brand.getName();
                                      } 
%>                              
                                          <option value="<%=pageUrl+brand.getSeoUrl()%>" <%=brandId.equals(brand.getId()) ? "selected": ""%>><%=brand.getName()%></option>
<%
                                    }
                                  }
                                }
%>                                      
                            </select>
                            <div class="left-col">
                                <h2 class="styled-bg"><%=catName%></h2>
                                <div class="deal-tab-wrap">
                                    <div class="offer-tab-content">
                                      <%
                                      if(offerDealList != null) {
                                        for(VoucherDeals vd : offerDealList) {
                                          if(language.getId().equals(vd.getLanguageId())) {
                                            if ("1".equals(vd.getOfferType())) {
                                              voucherClass = "click-to-code vpop";
                                              voucherDesc = p.getProperty("public.category.click_code");
                                            } else if ("2".equals(vd.getOfferType()) && vd.getOfferImage() == null) {
                                              voucherClass = "activate-deal u-deal";
                                              voucherDesc = p.getProperty("public.category.activate_deal");
                                            } else if ("2".equals(vd.getOfferType()) && vd.getOfferImage() != null) { //product deal
                                              voucherClass = "activate-deal u-deal";
                                              voucherDesc = p.getProperty("public.category.activate_deal");
                                            }
                                            storeId += ","+vd.getStoreId();
                                      %>
                                            <ul class="offer-list">
                                                <li>
                                                    <ul class="offer-item clearfix">
                                                        <li class="company-logo image-offer">
                                                            <div class="mobile-left-cnt">
                                                                <figure>
                                                                  <a href="<%=pageUrl + vd.getStoreSeoUrl()%>">
                                                                    <img src="<%=vd.getOfferImage() != null ? cdnPath + vd.getOfferImage() : cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%>"/>
                                                                  </a>  
                                                                </figure>
                                                            </div>
                                                        </li>
                                                        <li class="offer-desc">
                                                            <h2><a><%=vd.getOfferHeading()%></a></h2>
                                                            <ul class="reveal-coupon clearfix">
                                                                <li>
                                                                    <%if("1".equals(vd.getOfferType())) {%>
                                                                        <a data-type="20" data-lang="<%=vd.getLanguageId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> cursor-href"><%=voucherDesc%></a>
                                                                    <%}
                                                                    else {%>
                                                                        <a data-of="<%=vd.getId()%>" class="<%=voucherClass%> cursor-href" target="_blank"><%=voucherDesc%></a>
                                                                    <%}%>
                                                                </li>
                                                                <%if ("1".equals(vd.getOfferType())) {%>                                                                
                                                                    <li class="screen">
                                                                        <a data-type="21" data-lang="<%=vd.getLanguageId()%>" id="21-<%=vd.getId()%>" class="reveal-code vpop cursor-href"></a>
                                                                    </li>
                                                                <%}%>
                                                            </ul>
                                                            <p class="screen">
                                                               <%=vd.getOfferDesc()%>
                                                            </p> 
                                                            <%
                                                              if ("1".equals(homeConfig.getNumberPeoples())) {
                                                            %>                                                            
                                                                <ul class="offer-icons clearfix">
                                                                    <li class="people-used"><p><%=vd.getUsedCountToday()%> <%=p.getProperty("public.category.used")%></p></li>
                                                                </ul>  
                                                            <%
                                                              }
                                                            %>                                             
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="offer-details-wrap screen">
                                                    <ul class="offer-details ul-reset clearfix">
                                                    <%
                                                      if ("1".equals(homeConfig.getUpdatedDate())) {
                                                    %>                        
                                                      <li class="update-date"><%=p.getProperty("public.category.updated_on")%> <%=vd.getModifiedAt() != null ? vd.getModifiedAt() : ""%></li>
                                                    <%
                                                      }
                                                      if ("1".equals(homeConfig.getVote())) {
                                                    %>
                                                      <li class="vote-up <%=vd.getId()%>"><a class="cursor-href"><img src="<%=SystemConstant.PATH%>images/icon-vote-up.png" alt="image"/></a></li>
                                                        <li class="vote-down <%=vd.getId()%>"><a class="cursor-href"><img src="<%=SystemConstant.PATH%>images/icon-vote-down.png" alt="image"/></a></li>
                                                        <li class="vote-count count-<%=vd.getId()%>"><div class="vote-<%=vd.getId()%>"><%=p.getProperty("public.home.vote")%>: <%=vd.getOfferLike()%></div></li>
                                                    <%
                                                      }
                                                      if ("1".equals(homeConfig.getFavouriteStores())) {
                                                    %> 
                                                        <li class="favourite">
                                                            <a href="<%=session.getAttribute("userObj") == null ? "javascript:logFav(1)" : "javascript:fav(1, "+vd.getStoreId()+")"%>" class="fav-<%=vd.getStoreId()%>">
                                                                <img src="<%=favStores.contains(","+vd.getStoreId()+",") ? SystemConstant.PATH+"images/icon-fav.png" : SystemConstant.PATH+"images/dis-fav.png"%>" alt="image"/>
                                                            </a>
                                                        </li>
                                                    <%
                                                      }
                                                      if ("1".equals(homeConfig.getSavedCoupons())) {
                                                    %>
                                                        <li class="rated">
                                                            <a href="<%=session.getAttribute("userObj") == null ? "javascript:logFav(2)" : "javascript:fav(2, "+vd.getId()+")"%>" class="save-<%=vd.getId()%>">
                                                                <img src="<%=savedOffers.contains(","+vd.getId()+",") ? SystemConstant.PATH+"images/icon-save.png" : SystemConstant.PATH+"images/dis-save.png"%>" alt="image"/>
                                                            </a>
                                                        </li>
                                                    <%
                                                      }
                                                      if ("1".equals(homeConfig.getExpiryDate())) {
                                                    %>
                                                        <li class="expiry"><%=p.getProperty("public.home.ends_on")%> <%=vd.getEndDate()%></li>
                                                    <%
                                                      }
                                                    %>   
                                                    </ul>
                                                </li>
                                            </ul>
                                      <%
                                          }
                                        }
                                      }
                                      %>                                        
                                    </div>
                                </div>
                            </div>
                                    
                       </div>   
                          
                       </div>
                   
                </div>       
        </div>
    </div>
 </div> 
 <!-- ======================Company Profile End==================== -->
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>               
                              
        <script>
            brandId = <%=brandId%>;
        </script>
    </body>
</compress:html>
</html>
<%}
catch(Throwable e) {
    Logger.getLogger("brand.jsp").log(Level.SEVERE, null, e);
}
%>
