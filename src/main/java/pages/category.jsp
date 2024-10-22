<%-- 
    Document   : category
    Created on : 3 Mar, 2016, 5:18:24 PM
    Author     : IshahaqKhan
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
pageType = SystemConstant.CATEGORY;
String pageTypeFk = "";
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
//List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domainId); // active domain
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage(session, domain.getId(), languages);
Properties p = home.getLabels(language.getId());
HomeConfig homeConfig = home.getConfig(domainId);
//List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
SeoUrl seoObj = (SeoUrl)request.getAttribute("seo");
List<Category> categoriesList = home.getCatByDomainId(domainId);
String catId = request.getParameter("catId") == null ? "" : request.getParameter("catId").replaceAll("\\<.*?>", "");
pageTypeFk = catId;
List<VoucherDeals> offerDealList = home.getCatOfferByDomainId(domainId,catId);
List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
List<StoreCategory> storeCategoryList = home.getStoreCatName(pageTypeFk); 
String storeId = "0";
String catName = "";
String imagePath = "";
List<MetaTags> metaList = home.getMetaByDomainId(domainId);
String content=null;
String topContent = null;
String head = null;
 String langId = CommonUtils.getcntryLangCd(domainId);
pageName = (String) session.getAttribute("pageName");
/*for (SeoUrl seo : seoList) {
    String url = SystemConstant.PUBLIC + seo.getSeoUrl();    
    if (url.equals(pageName)) {       */   
      content = (seoObj.getStoreChildDesc()!=null)?seoObj.getStoreChildDesc().trim():""; 
      head = (seoObj.getStoreChildTitle()!=null)?seoObj.getStoreChildTitle().trim(): ""; 
      topContent = (seoObj.getTopContent()!=null)?seoObj.getTopContent().trim():""; 
  /*    break;
    }
  } */
   
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
<%
          if(categoriesList != null) {
            for(Category cat:categoriesList) {
              if(catId.equals(cat.getId())){
                  if(language.getId().equals(cat.getLanguageId())) {%>
                      <title itemprop="name"><%=cat.getTitle().replaceAll("#DOMAIN#", domainName)%></title>
                      <meta name="description" content="<%=cat.getMetaDescription().replaceAll("#DOMAIN#", domainName)%>">
                      <meta name="keywords" content="<%=cat.getMetaKeyword()%>">
                      <link rel="canonical" href="<%=pageUrl+cat.getSeoUrl()%>" />
        <%
                  break;
                  }
              }
            }
          }
        %>
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
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        
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
                             storeId += ","+vd.getStoreId();
                            }
                          }
                        }  %>            
                       
                <!-- -------------------Offer List Start------------------------->
                <main class="pull-right col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    <div class="offer-list">
                        <!-- -------------------Offer Filter Start------------------------->
                        <div class="page-header">
                           <div class="row">
                               <div class="col-lg-10 col-md-10 col-sm-10 col-xs-12">
                                   <h1><%=(!"".equals(head))?head:headBread%></h1>
                               </div>
                               <%if(topContent!=null && !"".equals(topContent)){%>
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <p><%=topContent%></p>
                                </div>
                               <%}%>
                                    <!--<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pull-right hidden-xs">
                                       <select class="category-select">-->
                                             <%                             
                                             if(categoriesList != null) {
                                                    for(Category cat:categoriesList){
                                                      if(cat.getLanguageId().equals(language.getId())){
                                                        if(catId.equals(cat.getId())){
                                                          catName = cat.getName();
                                                        } 
                                                         %>                              
                                                           <!-- <option value="<%=pageUrl+cat.getSeoUrl()%>" <%=catId.equals(cat.getId()) ? "selected": ""%>><%=cat.getName()%></option>-->
                                                            <%
                                                      }
                                                    }
                                                  }
                                                 %>                              
                                        <!--</select>
                                   </div>
                              <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12 pull-right">
                                <div class="show-item">       
                                    <label>Show: </label>
                                    <select>
                                        <option>10</option>
                                        <option>20</option>
                                    </select>
                                </div>    
                               </div>-->
                                </div>
                            </div>
                        <!-- -------------------Offer Filter End------------------------->
                        
                        <!-- -------------------Offer Item Start------------------------->
                                              
                        <%
                        int couponCount = 0;
                        if (mobileVdListById != null) {
                          for (VoucherDeals vd : mobileVdListById) {
                             if(couponCount>30)
                                break;
                            if (vd.getLanguageId().equals(language.getId())) {
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
                        %>
                        <%@include file="common/mobOffer.jsp" %> 
                        <% } } } %>
                        
                        <%
                        couponCount = 0;
                        if (deskVdListById != null) {
                          for (VoucherDeals vd : deskVdListById) {
                             if(couponCount>30)
                                break;
                            if (vd.getLanguageId().equals(language.getId())) {
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
                        %>
                        <%@include file="common/deskOffer.jsp" %>  
                        <% } } } %>
                    </div> 
                      <!-- -----We Recommend------> 
                     <% //@include file="common/recommendByCat.jsp" %>  
                </main>
                <!-- -------------------Offer Item End------------------------->  
                
                <!-- -------------------Sidebar Start------------------------->
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs hidden-sm">
                    <div class="sidebar">  
                        <!-- -----Side Banner 1----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="1" />
                        </jsp:include>
                       
                         <!-- -----Related Store------>
                        <%@include file="common/relatedStores.jsp" %>
                        
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
                
                <!-- Category description Started -->
                <%if(!(null==content || "".equals(content))){%>
                  <section class="category hidden-xs">
                      <div class="container">
                        <div class="row">
                           <div class="col-md-push-3 col-md-9 col-sm-9 col-xs-12">
                                <div class="pull-right" style="width: 100%;padding:0 10px;">
                                 <div id="home-intro" class="box">
                                     <%= content%>    
                                 </div>
                            </div>
                           </div>       
                          </div>
                      </div>
                    </section>   
               <%}%>
                <!-- Category description End -->    
            </div>       
        </div>
    </div>
 </div> 
 <!-- ======================Company Profile End==================== -->
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>  
 <form id="frm" method="POST"></form>     
    <script>
        catId = <%=catId%>;
         $(document).ready(function() {
             setTimeout(function(){   
                $.ajax({
                      url: '/pages/common/catStr.jsp?t=2&rId='+catId,
                      success: function (r) {},
                      async: true
                  });
              }, 1000);  
          });  
    </script>
    </body>
</compress:html>
</html>
<%}catch(Throwable e) {
    Logger.getLogger("category.jsp").log(Level.SEVERE, null, e);
}
%>        