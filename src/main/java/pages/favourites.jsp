<%-- 
    Document   : favourites
    Created on : Dec 22, 2014, 10:55:00 AM
    Author     : shabil.b
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>

<%
String name = "";
LoginInfo lInfo = new LoginInfo();
if(session.getAttribute("userObj") != null) {
    lInfo = (LoginInfo)session.getAttribute("userObj");
    if(lInfo.getPublicUserName().contains(" ")) {
        name = lInfo.getPublicUserName().substring(0, lInfo.getPublicUserName().indexOf(" "));
    } 
    else {
        name = lInfo.getPublicUserName();
    }
}

SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
java.sql.ResultSet rsFav = null;

String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
String qryFav = "SELECT VF.id AS favId, VS.id AS storeId, VS.image_small AS image, VSL.name AS name, VSL.seo_url AS url FROM vc_favourite_store "
              + "VF, vc_store VS, vc_store_lang VSL WHERE VF.store_id = VS.id AND VS.id = VSL.store_id AND VSL.language_id = ? AND "
              + "VF.public_user_id = ? AND VS.publish = 1 AND VS.trash = 0 ORDER BY VF.id DESC";

String voucherClass = "";
String voucherDesc = "";
String storeId = "0";
String imagePath = "";
Db db =  Connect.newDb();

try {
    boolean top = true;
    boolean vouchers = true;
    boolean deals = true;
    String requestUrl = request.getRequestURL().toString();
    String domainName = (String)session.getAttribute("domainName");
    String pageName = (String)session.getAttribute("pageName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    String pageType = "0";
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
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
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
            <title itemprop="name">Paylesser | <%=p.getProperty("public.home.favourite_stores")%></title>
            <meta name="description" content="">
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
            <!--[if lt IE 7]>
                <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
            <![endif]-->
            <div id="wraper" class="inner">   
            <%@include file="common/topMenu.jsp" %>
            <div class="store-middle">
                <div class="container">
                    <div class="row">
                        <!-- -------------------CMS Pages Start------------------------->
                        <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                            <div class="cms-pages">
                                <div class="content-box1">
                                    <div class="user-profile-page">
                                        <%@include file="common/commonProfile.jsp" %>
                                        <div class="user-profile-body">


                                            <div class="user-body-content">
                                                <h2><span class="icon1"><img src="<%=SystemConstant.PATH%>/images/icon-add-fav.png" alt="icon-add" />
                                                    </span><%=p.getProperty("public.saved_coupon.myfavstores")%><a class="btn orange pull-right" style="padding: 7px 15px;width: auto" href="<%=pageUrl%>add-stores"><%=p.getProperty("public.saved_coupon.addmorestores")%></a></h2>
                                                <div class="favorites-stores content-box">                                      
                                                   <div class="row">
                                                       <%//rsFav.beforeFirst();
                                                        rsFav = db.select().resultSet(qryFav, new Object[]{Integer.parseInt(language.getId()), lInfo.getPublicUserId()});   
                                                        while(rsFav.next()) {%>
                                                         <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" id="<%=rsFav.getString("favId")%>">                                                          
                                                                <a href="<%=pageUrl+rsFav.getString("url")%>">
                                                                    <div class="favorites-item"><img src="<%=cdnPath+rsFav.getString("image")%>" alt="<%=rsFav.getString("name")%>"></div>
                                                                </a>
                                                                <a class="delete-fav pointer" data-fav="<%=rsFav.getString("favId")%>" data-store="<%=rsFav.getString("storeId")%>"><i class="fa fa-trash"></i></a>
                                                            </div> 
                                                        <%}%>
                                                                                                              
                                                    </div> 
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- -------------------CMS Pages End-------------------------> 
                            </div>   
                        </div>
                         <!-- -------------------Sidebar Start------------------------->
                         <!-- -----Coupon Status------>
                         <%@include file="common/couponStatus.jsp" %>                              
                         <!-- -----Submit Coupon------>
                         <%@include file="common/couponSubmit.jsp" %>
                <!-- -------------------Sidebar End----------------------------> 
                 </div>        
                </div>                
            </div>  
                      
        </div>
            <%@include file="common/bottomMenu.jsp" %>
            <%@include file="common/footer.jsp" %>
            <script>
                usrProfile = '<%=p.getProperty("public.home.saved_coupons")%>';
                favStores = '<%=p.getProperty("public.home.favourite_stores")%>';
                accntPrefer = '<%=p.getProperty("public.saved_coupon.account")%>';
            </script>
            <script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
        </body>
</compress:html>
    </html>
<%} 
catch(Throwable e) {
    Logger.getLogger("favourites.jsp").log(Level.SEVERE, null, e);
}
finally {
    Cleaner.close(rsFav);
    db.select().clean();
    Connect.close(db);
}%>