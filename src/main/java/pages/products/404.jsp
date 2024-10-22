<%-- 
    Document   : index
    Created on : 7 Mar, 2016, 7 Mar, 2016 16:00:56 PM
    Author     : Vivek
--%>
 <%@page import="sdigital.vcpublic.home.FeedMeta"%>
<%@page import="sdigital.pl.products.domains.Breadcrumb"%>
<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%
    String domainName = "";
    String pageName = "";
    domainName = (String) session.getAttribute("domainName");
    pageName = (String) session.getAttribute("pageName");
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");   
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    Properties p = home.getLabels(language.getId());
    HomeConfig homeConfig = home.getConfig(domainId);
   
 %>
 
 <!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>
 
 <html lang="en">
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">	
        <title itemprop="name">404 error - Page does not exist</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <%@include file="common/header.jsp" %>
    </head>
    <compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">    
    <body class="feed">
         <%@include file="common/topmenu.jsp" %> 
     <!-- ======================Main Wraper Start==================== -->
    <div id="wraper" class="inner"> 
    <div class="error-page">
        <div class="container">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="" style="width:100%;text-align:center">
                        <h3 class="section-title">404 <span>Oops! That page can't be found.</span></h3>
                        <a onclick="history.back()" class="back" style="max-width:180px"><i class="fa fa-long-arrow-left"></i> Go to Back</a>
                    </div>   
                </div>
            </div>    
        </div>
    </div>
    </div>
    <%@include file="common/bottomMenu.jsp" %>                     
    <%@include file="common/footer.jsp" %>
    </body>
</compress:html>
</html>