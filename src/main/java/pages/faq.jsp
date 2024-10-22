<%-- 
    Document   : faq
    Created on : 7 Mar, 2016, 7 Mar, 2016 15:18:46 PM
    Author     : Vivek
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
    domainName = (String)session.getAttribute("domainName");
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
    String pageType = SystemConstant.ABOUT_US;
    String pageTypeFk = "";
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    String storeId = "0";
    String imagePath = "";
    String langId = CommonUtils.getcntryLangCd(domainId);
    List<MetaTags> metaList = home.getMetaByDomainId(domainId);    
    List<Faq> faqList = home.getFaq(domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title itemprop="name">Frequently Asked Questions</title>
    <meta name="description" content="Check out our frequently asked questions section for your help or ask your question directly if it is not covered in it.">
    <meta name="keywords" content="Frequently Asked Questions, FAQs, Ask Your Question">

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
     <meta http-equiv="refresh" content="0; url=https://www.paylesser.com/faqs.html" /> 
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
    <div id="wraper" class="inner"> 
    <!-- ======================Header Strip Start==================== -->
    <%@include file="common/topMenu.jsp" %>
    <section class="category" style="margin:0">&nbsp;</section>
    <div class="store-middle">
        <div class="container wow fadeInDown" data-wow-duration="1000ms" data-wow-delay="600ms">
            <div class="row">
                 
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="cms-pages" id="outer-panel">
                        <h2><%=p.getProperty("public.faq.faq")%></h2>
                        <div class="content-box">
                        <% if(faqList != null) {
                            for(Faq f : faqList) {
                                if(f.getLanguageId().equals(language.getId())) {
                        %>    
                            <h4><%=f.getQuestion()%></h4>
                            <p><%=f.getAnswer()%></p>
                        
                        <% } } } %>
                        </div>
                        <!-- -------------------CMS Pages End-------------------------> 
                    </div>   
                </div>
            </div>    
        </div>
    </div>
</div>
  <!-- ======================Company Profile End==================== -->
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>

<!-- ======================Main Wraper End======================= --> 
    </body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("aboutus.jsp").log(Level.SEVERE, null, e);
  }%>