<%-- 
    Document   : search
    Created on : 14 March, 2016, 17 March, 2016 12:47:46 PM
    Author     : Vivek
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
//out.println(request.getRequestURL());
String requestUrl = request.getRequestURL().toString();
String pageName = "";
String domainName = (String)session.getAttribute("domainName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
String voucherClass = "";
String voucherDesc = "";
String pageType = "0";
pageType = SystemConstant.SEARCH_RESULT;
String pageTypeFk = "";
String q = CommonUtils.sanitizeQuery((request.getParameter("q") == null ? "" : request.getParameter("q")));
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId); // active domain
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage(session, domain.getId(), languages);
Properties p = home.getLabels(language.getId());
HomeConfig homeConfig = home.getConfig(domainId);
List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
List<VoucherDeals> offerDealList = home.getSeachResult(q,domainId,language.getId());
List<VoucherDeals> topOfferdDealList = home.getOfferByDomainId(domainId);
List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
String storeId = "0";
String imagePath = "";
int top20Counter = 0;
String langId = CommonUtils.getcntryLangCd(domainId);
List<MetaTags> metaList = home.getMetaByDomainId(domainId);
List<Store> storeListByCoupon = CommonUtils.getUniqueStores(offerDealList);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage">  
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">	
        <%for(SeoUrl s : seoList) {
            if(pageType.equals(s.getPageType())) {
                if(language.getId().equals(s.getLanguageId())) {%>
                    <title itemprop="name"><%=s.getPageTitle()%></title>
                    <meta name="description" content="<%=s.getMetaDesc()%>">
                    <meta name="keywords" content="<%=s.getMetaKeyword()%>">
                <%}
            }
        }%>
        <meta name="viewport" content="width=device-width, initial-scale=1">
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
   <div id="wraper" class="inner">   
  <%@include file="common/topMenu.jsp" %> 
    <div class="store-middle">
        <div class="container ">
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
                        }  %>  
                        
                <!-- -------------------Offer List Start------------------------->
                
                <div class="pull-right col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    <div class="category-list">
                        
                        
                         <!-- ================================Featured Store Start===================================-->
                       <% if (storeListByCoupon != null && storeListByCoupon.size()>0) {%>    
                                                      
                                       <div class="page-header">
                                            <div class="row">
                                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-12 <%=rtl%>">
                                                     <h1 class="<%=lft%>"><%=p.getProperty("public.search.matching")%>&nbsp;"<%=q%>"</h1>
                                                </div>
                                            </div>                        
                                         </div>
                                        <div id="popular-store" >
                                          <div class="row">
                                            <%
                                              int storeRows = 0;                                               
                                              if (storeListByCoupon != null && storeListByCoupon.size()>0) {
                                                  for (Store store : storeListByCoupon) {
                                                      if (language.getId().equals(store.getLanguageId())) {
                                                          if (storeRows < 6) {
                                            %>
                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6">
                                              <div class="item-inner">
                                                  <a href="<%=store.getSeoUrl()%>"><div class="item-image">
                                                      <img src="<%=cdnPath + store.getImageBig()%>" alt="<%=SolrUtils.toDisplayCase(store.getSeoUrl().replace("-", " ")) %>">
                                                   </div></a>                                              
                                              </div>
                                            </div> 
                                            <%}
                                                              storeRows++;
                                                          }
                                                      }
                                                  }
                                             %>
                                          </div>
                                        </div>
                                
                            <!-- ================================Featured Store End===================================-->  
                        <%}%>
                        
                        
                        
                        <%if(offerDealList!=null && offerDealList.size()>0){%>
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header">
                           <div class="row">
                               <div class="col-lg-10 col-md-10 col-sm-10 col-xs-12 <%=rtl%>">
                                    <h1 class="<%=lft%>"><%=p.getProperty("public.search.result")%>&nbsp;"<%=q%>"</h1>
                               </div>
                           </div>                        
                        </div>
                        <%}%>
                        <!-- -------------------Offer Filter End------------------------->
                        <!-- -------------------Offer Item Start------------------------->
                        <%   int couponCount = 0;
                            if(mobileVdListById != null) {
                              for(VoucherDeals vd : mobileVdListById) {
                                if(couponCount>30)
                                   break;  
                                if(language.getId().equals(vd.getLanguageId())) {
                                  couponCount++;  
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
                                  storeId += ","+vd.getStoreId();
                            %>
                             <%@include file="common/mobOffer.jsp" %> 
                             <% } } } %>
                        
                        <%
                        couponCount = 0;    
                        if(deskVdListById != null) {
                          for(VoucherDeals vd : deskVdListById) {
                            if(couponCount>30)
                                break;  
                            if(language.getId().equals(vd.getLanguageId())) {
                              couponCount++;  
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
                              storeId += ","+vd.getStoreId();
                        %>
                        <%@include file="common/deskOffer.jsp" %> 
                        <% } } } %>
                    </div>
                  
                  
                  <%if(offerDealList == null || (offerDealList!=null && offerDealList.size() <= 0)){%>  
                     <!-- ================================Top Coupons Start===================================--> 
                     
                     <div class="page-header">
                           <div class="row">
                               <div class="col-lg-12 col-md-10 col-sm-10 col-xs-12">
                                   <%
                                   long pCount = SolrUtils.getTotalSearchRecord(domain, q);
                                   if(pCount>0){
                                   %>
                                    <h2 class="<%=lft+" "+rtl%>" style="margin-top:0"><%=p.getProperty("public.search.ysearch")%>&nbsp;<b>"<%=q%>"</b>&nbsp;<%=p.getProperty("public.search.notmatch")%><span style="font-size:15px;color: #ccc"> <a style="color:#ff8827;margin-left: 7px" href="/search?q=<%=q%>"> <%=p.getProperty("public.search.explore")%>&nbsp;<%= pCount %>&nbsp;<%=p.getProperty("public.search.mprod")%></a></span></h2>
                                   <%}else{%>
                                    <h2 class="<%=lft+" "+rtl%>" style="margin-top:0"><%=p.getProperty("public.search.ysearch")%>&nbsp;<b>"<%=q%>"</b>&nbsp;<%=p.getProperty("public.search.notmatch")%></h2>
                                   <%}%>
                                   <h3 class="h5" style="font-size:20px;border-top: 2px solid #e9e9e9;padding-top: 20px;margin-top:30px;margin-bottom:20px; color:#000"><%=p.getProperty("public.search.checkout")%></h3>
                               </div>
                           </div>                        
                        </div>
                     
                     <section class="category">
                       <div class="">
                            
                           <div id="top-coupon" >
                               <div class="row">
                                   <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                       <div class="row">
                                           <%//Ishaq For Mobile View and Exclusive
                                           mobileVdListById.clear();
                                           deskVdListById.clear();
                                           if (topOfferdDealList != null) {
                                            for (VoucherDeals vd : topOfferdDealList) {
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
                                           <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6">
                                               <div class="item-inner">
                                                   <div class="item-image">
                                                       <a href="<%=pageUrl + vd.getStoreSeoUrl() %>"><img alt="" src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreCaption()!=null?vd.getStoreCaption():vd.getStoreName()%>"></a>
                                                   </div>
                                                   <div class="item-info">
                                                       <p><%=vd.getOfferHeading()%></p>
                                                       <%if ("1".equals(vd.getOfferType())) {%>
                                                       <a data-type="20" data-lang="<%=vd.getLanguageId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-btn"><%=voucherDesc%></a>
                                                       <%} else {%>
                                                       <a data-of="<%=vd.getId()%>" class="u-deal my-btn1"><%=voucherDesc%></a>
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
                    
                   <%}%> 
                 </div>    
                    
               
                <!-- -------------------Offer Item End------------------------->   
                <!-- -------------------Sidebar Start------------------------->
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs hidden-sm">
                    <div class="sidebar">  
                        <!-- -----Side Banner 1----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="1" />
                        </jsp:include>
                        <!-- -----Related Store------>
                        <%@include file="common/popularStores.jsp" %>
                        <!-- -----Side Banner 2----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="2" />
                        </jsp:include>
                         
                        <!-- -----Side Banner 3----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="3" />
                        </jsp:include>
                        <!-- -----Side Banner 4----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="4" />
                        </jsp:include>
                        <!-- -----Side Banner 5----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="5" />
                        </jsp:include>                      
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->
            </div>    
        </div>
    </div>
 </div>          
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>
</body>
</compress:html>
</html>
<%}
catch(Throwable e) {
    Logger.getLogger("search.jsp").log(Level.SEVERE, null, e);
}%>
