<%-- 
    Document   : articles
    Created on : Jan 13, 2015, 7:01:16 PM
    Author     : shabil.b
--%>

<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%
try {
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
    String store = request.getParameter("s") == null ? "0" : request.getParameter("s").replaceAll("\\<.*?>", "");
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    String voucherClass = "";
    String voucherDesc = "";
    String articleDesc = "";
    String dot = "";
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
    HomeConfig homeConfig = home.getConfig(domainId);
    List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
    String pageType = SystemConstant.NEWSDETAIL;
    String pageTypeFk = "";
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    String storeId = "0";
    String imagePath = "";
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
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>			
            <title itemprop="name"><%=p.getProperty("public.articles.title")%></title>
            <!--<meta name="description" content="">
            <meta name="keywords" content="">-->
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
            <%@include file="common/topMenu.jsp" %>
            <div class="page-content clearfix inner-page static-pages">
                <div class="main-offers-wrap wrapper clearfix">
                    <div class="left-col">
                        <h2 class="styled-bg"><%=p.getProperty("public.articles.header")%></h2>
                        <div class="about-us custom-content">
                            <ul>
                                <%List<Articles> articlesList = home.getArticles(store);
                                if(articlesList != null) {
                                    for(Articles ar : articlesList) {
                                        if(ar.getLanguageId().equals(language.getId())) {
                                            articleDesc = ar.getDescription().replaceAll("\\<.*?>", "");
                                          
                                            if(articleDesc.length() > 314) {
                                              dot = "&nbsp;...";
                                            }%>
                                            <li>
                                                <p class="news" onclick="articles(<%=store%>, <%=ar.getParentId()%>);"><%=ar.getTitle()%></p>
                                                <p>
                                                  <%if(articleDesc.length() > 314) {
                                                    out.print(articleDesc.substring(0, 315)+dot);
                                                  }
                                                  else {
                                                    out.print(articleDesc);
                                                  }%>
                                                </p>
                                            </li>
                                        <%}
                                    }
                                }%>
                            </ul>
                        </div>
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
            <script>
                articlesDet = 'articles-detail';
            </script>
            <script src="<%=SystemConstant.PATH%>js/news.js"></script>
        </body>
</compress:html>
    </html>
<%} catch (Throwable e) {
    Logger.getLogger("articles.jsp").log(Level.SEVERE, null, e);
}%>