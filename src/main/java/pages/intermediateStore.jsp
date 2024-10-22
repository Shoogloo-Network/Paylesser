<%-- 
    Document   : intermediate
    Created on : Mar 15, 2016, 2:47:36 PM
    Author     : Ishahaq Khan
--%>

<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.PreparedStatement"%>
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%
    //Db db = null;
    ResultSet rsOffer = null;
    try{
    String domainName = "";
    String pageName = "";
    domainName = (String) session.getAttribute("domainName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    Properties p = home.getLabels(language.getId());
    //db = Connect.newDb();
    String stId = (String)request.getParameter("id")==null ? "0" : request.getParameter("id");
    List<Store> storeListById = home.getAllStoreById(stId);
    Store st = storeListById.get(0);
    String langId = CommonUtils.getcntryLangCd(domainId);
    
%>


<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
    <head>
        <meta charset="utf-8">	
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <title itemprop="name"><%= st.getMetaTitle() %></title>
        <meta name="robots" content="noindex, nofollow">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%@include file="common/header.jsp" %>
        <meta http-equiv="refresh" content="0; url=<%=st.getAffiliateUrl() %>" />          
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        
     <div class="wait">
        <img src="<%=SystemConstant.PATH%>images/pl-logo.png"/>
        <h1><%=p.getProperty("public.intermediate.redirected")%></h1>
        <p><img src="<%=SystemConstant.PATH%>images/loader.gif"/></p>
        <h2><%=p.getProperty("public.intermediate.shop")%></h2>
        <h3><%=p.getProperty("public.intermediate.refresh")%></h3>
    </div>
    
    
    <style>
        .wait{width: 100%;margin: 0 auto;text-align: center;}
        .wait img{max-width: 300px;}
        .wait h1{float: left;width: 100%;font-size: 18px;color: #2c2b2b;}
        .wait h2{float: left;width: 100%;font-size: 24px;color: #ff8827;}
        .wait h3{float: left;width: 100%;font-size: 22px;color: #2c2b2b;}
        .wait p{float: left;width: 100%;font-size: 12px;color: #2c2b2b;}
        
        @media (max-width:767px) {
        .wait{padding:20px;} 
        }
    </style>
       
   

<script>
    usrProfile = '<%=p.getProperty("public.home.saved_coupons")%>';
    favStores = '<%=p.getProperty("public.home.favourite_stores")%>';
    accntPrefer = '<%=p.getProperty("public.saved_coupon.account")%>';
    success = '<%=p.getProperty("public.messages.success")%>';
    expirymsg = '<%=p.getProperty("public.messages.expiry")%>';
    codemsg = '<%=p.getProperty("public.messages.code")%>';
    websitemsg = '<%=p.getProperty("public.messages.website")%>';
    websiteInvalid = '<%=p.getProperty("public.messages.websiteInvalid")%>';
</script>
<script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
<%=domain.getAnalyticsCode()%>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
        Logger.getLogger("intermediateStore.jsp").log(Level.SEVERE, null, e);
} finally {
    Cleaner.close(rsOffer);
   // db.select().clean();
    //Connect.close(db);
} %>
