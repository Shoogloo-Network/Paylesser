<%-- 
    Document   : how-to-use
    Created on : Dec 9, 2014, 11:26:14 AM
    Author     : sanith.e
--%>

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
        String requestUrl = request.getRequestURL().toString();
        String domainName = (String) session.getAttribute("domainName");
        String pageName = (String) session.getAttribute("pageName");
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        String pageType = SystemConstant.HOW_TO_USE;
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
        String howToUse = "";
        String url = "";
        String pageTitle = "";
        String metaKey = "";
        String metaDesc = "";
        for (SeoUrl seo : seoList) {
            url = SystemConstant.PUBLIC + seo.getSeoUrl();
            if (url.equals(pageName)) {
                pageTypeFk = seo.getPageTypeFk();
                pageTitle = seo.getPageTitle();
                metaKey = seo.getMetaKeyword();
                metaDesc = seo.getMetaDesc();
                break;
            }
        }
        List<Store> storeListById = home.getStoreById(pageTypeFk);
        if (storeListById != null) {
            for (Store st : storeListById) {
                if (st.getLanguageId().equals(language.getId())) {
                    howToUse = st.getHowToUse();
                }
            }
        }
        String imagePath = "";
        String voucherClass = "";
        String voucherDesc = "";
        String storeId = pageTypeFk;
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
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
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>		
        <title itemprop="name"><%=pageTitle%></title>
        <meta name="description" content="<%=metaDesc%>">
        <meta name="keywords" content="<%=metaKey%>">
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
        <script src="<%=SystemConstant.PATH%>js/home.js"></script>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        <%@include file="common/topMenu.jsp" %>
        <div class="page-content clearfix inner-page static-pages">
            <div class="main-offers-wrap wrapper clearfix">
                <div class="left-col">
                    <h2 class="styled-bg"> <%=p.getProperty("public.howto.heading")%></h2>
                    <%=howToUse == null ? "" : howToUse%>
                </div>
                <div class="right-col">
                    <%@include file="common/rightPanel.jsp" %>
                </div>
            </div>
        </div>
    </div>
    <%@include file="common/bottomMenu.jsp" %>
</section>
</div>
<%@include file="common/footer.jsp" %>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
        Logger.getLogger("how-to-use.jsp").log(Level.SEVERE, null, e);
    } finally {

    }%>
