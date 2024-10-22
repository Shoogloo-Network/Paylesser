<%-- 
    Document   : aboutus
    Created on : Dec 5, 2014, 12:40:25 PM
    Author     : jincy.p
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
<%  try {
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    String voucherClass = "";
    String voucherDesc = "";
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
    String pageType = SystemConstant.MANAGEMENT_TEAM;
    String pageTypeFk = "";
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
    <%
      for (SeoUrl s : seoList) {
        if (SystemConstant.MANAGEMENT_TEAM.equals(s.getPageType())) {
          if (language.getId().equals(s.getLanguageId())) {
    %>
    <title itemprop="name"><%=s.getPageTitle()%></title>
    <meta name="description" content="<%=s.getMetaDesc()%>">
    <meta name="keywords" content="<%=s.getMetaKeyword()%>">
    <%
            break;
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
    <%@include file="common/topMenu.jsp" %>
    <div class="content-panel">
      <div class="wrapper clearfix career-page">

        <h1 class="text-style-1"><%=p.getProperty("public.home.meetteam")%></h1>
        <ul class="team-list">
          <%
            List<ManagementTeam> managementList = home.getManagementTeam(domainId);
            if (managementList != null) {
              for (ManagementTeam managementTeam : managementList) {
                if (managementTeam.getLanguageId().equals(language.getId())) {
          %>
          <li>
            <div class="image">
              <img src="<%=cdnPath + managementTeam.getImage()%>" alt="<%=managementTeam.getName()%>"/>              
            </div>
            <div class="image-desc custom-content">
              <h3><%=managementTeam.getName()%></h3>
              <p class="title"><%=managementTeam.getTitle()==null?"":managementTeam.getTitle()%></p>
              <p>
                <%=managementTeam.getDescription()%>
              </p>
            </div>
          </li>
          <%    }
              }
            }
          %>
        </ul>
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
    Logger.getLogger("managementTeam.jsp").log(Level.SEVERE, null, e);
  }%>