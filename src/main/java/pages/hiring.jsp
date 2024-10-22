<%--&lt;%&ndash; --%>
<%--    Document   : hiring--%>
<%--    Created on : 4 Mar, 2016, 4 Mar, 2016 12:55:26 PM--%>
<%--    Author     : Vivek--%>
<%--&ndash;%&gt;--%>
<%--<%@page import="sdigital.vcpublic.config.SystemConstant"%>--%>
<%--<%@page import="sdigital.vcpublic.home.SeoUrl"%>--%>
<%--<%@page import="sdigital.vcpublic.home.HomeConfig"%>--%>
<%--<%@page import="java.util.Properties"%>--%>
<%--<%@page import="sdigital.vcpublic.home.Language"%>--%>
<%--<%@page import="sdigital.vcpublic.home.Domains"%>--%>
<%--<%@page import="java.util.List"%>--%>
<%--<%@page import="sdigital.vcpublic.home.VcSession"%>--%>
<%--<%@page import="sdigital.vcpublic.home.VcHome"%>--%>
<%--<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>

<%--<%--%>
<%--  String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");--%>
<%--  String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log0mail").replaceAll("\\<.*?>", "");--%>
<%--  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");--%>
<%--  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");--%>
<%--  String requestUrl = request.getRequestURL().toString();--%>
<%--  String domainName = "";--%>
<%--  String pageName = "";--%>
<%--  String voucherClass = "";--%>
<%--  String voucherDesc = "";  --%>
<%--  domainName = (String)session.getAttribute("domainName");--%>
<%--  String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";--%>
<%--  VcHome home = VcHome.instance();--%>
<%--  VcSession vcsession = VcSession.instance();--%>
<%--  String domainId = home.getDomainId(domainName);--%>
<%--  List<Domains> domains = home.getDomains(domainId);--%>
<%--  Domains domain = home.getDomain(domains, domainId); // active domain--%>
<%--  List<Language> languages = home.getLanguages(domain.getId());--%>
<%--  Language language = vcsession.getLanguage(session, domain.getId(), languages);--%>
<%--  Properties p = home.getLabels(language.getId());--%>
<%--  HomeConfig homeConfig = home.getConfig(domainId);--%>
<%--  List<SeoUrl> seoList = home.getSeoByDomainId(domainId);--%>
<%--  String pageType = SystemConstant.HIRING;--%>
<%--  List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);--%>
<%--    String storeId = "0";--%>
<%--    String pageTypeFk = "";--%>
<%--    String imagePath = "";--%>
<%--    String langId = CommonUtils.getcntryLangCd(domainId);--%>
<%--List<MetaTags> metaList = home.getMetaByDomainId(domainId);    --%>
<%--%>--%>
<%--<!DOCTYPE html>--%>
<%--<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>--%>
<%--<%@ taglib uri="http://granule.com/tags" prefix="g" %>  --%>
<%--<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> --%>
<%--    --%>
<%--  <head>--%>
<%--    <meta charset="utf-8">--%>
<%--    <meta http-equiv="X-UA-Compatible" content="IE=edge">	--%>
<%--<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>--%>
<%--	<meta name="robots" content="noindex">--%>
<%--<%}%>	--%>
<%--    <%for (SeoUrl s : seoList) {--%>
<%--        if (pageType.equals(s.getPageType())) {--%>
<%--          if (language.getId().equals(s.getLanguageId())) {--%>
<%--    %>--%>
<%--    <title itemprop="name"><%=s.getPageTitle()%></title>--%>
<%--    <meta name="description" content="<%=s.getMetaDesc()%>">--%>
<%--    <meta name="keywords" content="<%=s.getMetaKeyword()%>">--%>
<%--    <%--%>
<%--            break;--%>
<%--          }--%>
<%--        }--%>
<%--      }--%>
<%--    %>--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1">--%>
<%--    <meta name="robots" content="noindex">--%>
<%--        <%--%>
<%--        if(metaList != null) {--%>
<%--          for(MetaTags m : metaList) {--%>
<%--        %>  --%>
<%--        <%=m.getMetaTags()%>--%>
<%--        <%}--%>
<%--        }--%>
<%--        %>   --%>
<%--    <%@include file="common/header.jsp" %>--%>
<%--    </head>--%>
<%--<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">--%>
<%--    <body>--%>
<%--     <div id="wraper" class="inner"> --%>
<%--    <%@include file="common/topMenu.jsp" %>--%>
<%--     <div class="store-middle">--%>
<%--        <div class="container wow fadeInDown" data-wow-duration="1000ms" data-wow-delay="600ms">--%>
<%--            <div class="row">--%>
<%--                                --%>
<%--                <!-- -------------------CMS Pages Start------------------------->--%>
<%--                --%>
<%--                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">--%>
<%--                    <div class="cms-pages">--%>
<%--                        <h2><%=p.getProperty("public.hiring.heading")%></h2>--%>
<%--                         <%--%>
<%--                            List<Hiring> hiringList = home.getHiring();--%>
<%--                              if(hiringList != null) {--%>
<%--                                for (Hiring hiring : hiringList) {                  --%>
<%--                                            if (hiring.getLanguageId().equals(language.getId())) {--%>
<%--                            %>                    --%>
<%--                            <h3><%=hiring.getTitle()%></h3>--%>
<%--                            <p><%=p.getProperty("public.hiring.closing")%> <%=hiring.getExpiry()%></p>--%>
<%--                            <%=hiring.getDescription()%>--%>
<%--                            <a href="mailto:info@vouchercodes.in" class="apply"><%=p.getProperty("public.hiring.apply")%></a>--%>
<%--                        <% } } } %>--%>
<%--                        <!-- -------------------CMS Pages End-------------------------> --%>
<%--                    </div>   --%>
<%--                </div>--%>
<%--            </div>    --%>
<%--        </div>--%>
<%--    </div>--%>
<%--    --%>
<%-- </div>--%>
<%--<%@include file="common/bottomMenu.jsp" %>--%>
<%--<%@include file="common/footer.jsp" %>--%>
<%--</body>--%>
<%--</compress:html>--%>
<%--</html>--%>

<%@ page import="java.util.Date" %>
<html>
<body>
<h1>on hiring page </h1>
<p>The date is: <%= new Date() %></p>
</body>
</html>