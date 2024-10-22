<%-- 
    Document   : top-20-d
    Created on : 4 Mar, 2016, 4 Mar, 2016 16:15:39 PM
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
//String requestUrl = "test.vouchercodes.in:8080/vcadmin/faces/public/index.jsp";
String domainName = "";
String pageName = "";
domainName = (String)session.getAttribute("domainName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
String voucherClass = "";
String voucherDesc = "";
String pageType = "0";
pageType = SystemConstant.TOP_20_D;
String pageTypeFk = "";
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
List<VoucherDeals> offerDealList = home.getTop20DealByDomainId(domainId);
List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
String storeId = "0";
String imagePath = "";
int top20Counter = 0;
String langId = CommonUtils.getcntryLangCd(domainId);
List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">		
    <%for(SeoUrl s : seoList) {
        if(SystemConstant.TOP_20_D.equals(s.getPageType())) {
            if(language.getId().equals(s.getLanguageId())) {%>
                <title itemprop="name"><%=s.getPageTitle()%></title>
                <meta name="description" content="<%=s.getMetaDesc()%>">
                <meta name="keywords" content="<%=s.getMetaKeyword()%>">
            <%}
        }
    }%>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex">
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
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header">
                           <div class="row">
                               <div class="col-lg-10 col-md-10 col-sm-10 col-xs-12">
                                    <h1><%=p.getProperty("public.topdeals")%></h1>
                               </div>
                           </div>
                            
                        </div>
                        <!-- -------------------Offer Filter End------------------------->
                        <!-- -------------------Offer Item Start------------------------->
                        <%
                            if(mobileVdListById != null) {
                              for(VoucherDeals vd : mobileVdListById) {
                                if(language.getId().equals(vd.getLanguageId())) {
                                  top20Counter++;
                                  if(top20Counter < 21) {
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
                        <% } } } }%>
                        
                        <%
                        if(deskVdListById != null) {
                        if(!(request.getHeader("User-Agent").indexOf("Mobile") != -1)) {
                              top20Counter = 0;
                            }   
                          for(VoucherDeals vd : deskVdListById) {
                            if(language.getId().equals(vd.getLanguageId())) {
                              top20Counter++;
                              if(top20Counter < 21) {
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
                        <% } } } }%>
                    </div>
                     <!-- -----We Recommend------>
                 <%@include file="common/weRecommend.jsp" %> 
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
    Logger.getLogger("top-20-d.jsp").log(Level.SEVERE, null, e);
}%>