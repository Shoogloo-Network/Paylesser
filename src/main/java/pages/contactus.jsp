<%-- 
    Document   : contactus
    Created on : 4 Mar, 2016, 4 Mar, 2016 14:20:16 PM
    Author     : Vivek
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
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
    String success1 = request.getParameter("msg") == null ? "" : request.getParameter("msg").replaceAll("\\<.*?>", "");
    String requestUrl = request.getRequestURL().toString();
//String requestUrl = "test.vouchercodes.in:8080/vcadmin/faces/public/index.jsp";
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
    String pageType = "0";
    pageType = SystemConstant.CONTACT_US;
    String pageTypeFk = "";
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    String storeId = "0";
    String imagePath = "";
    String conactEmailId = "info@paylesser.com";
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
    <%for (SeoUrl s : seoList) {
        if (SystemConstant.CONTACT_US.equals(s.getPageType())) {
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
     <meta http-equiv="refresh" content="0; url=https://www.paylesser.com/contact-us.html" /> 
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
    <div id="wraper" class="inner"> 
    <%@include file="common/topMenu.jsp" %>
     <div class="store-middle">
        <div class="container wow fadeInDown" data-wow-duration="1000ms" data-wow-delay="600ms">
            <div class="row">
                
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="cms-pages" id="outer-panel">
                        <h2><%=p.getProperty("public.home.contact_us")%></h2>
                        <div class="content-box contact-us">
                         <div class="row">
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
                            <% if(success1.equals("OK")){%>
                                <div class="alert alert-success" role="alert" >Thank you for your feedback</div>
                             <%}%>   
                            <h3><%=p.getProperty("public.contactus.heading1")%> </h3>
                            <p><%=p.getProperty("public.contactus.heading2")%>&nbsp;<a href="mailto:<%=conactEmailId%>"><%=conactEmailId%></a></p>
                            <form name="frmFeedback" id="frmFeedback" method="post" action="/contactusdb">
                                <div class="form-group">
                                    <label><%=p.getProperty("public.signup.name")%> <span id="errName" class="errSpan"></span></label>
                                    <input <input type="text" name="userName" id="userName" class="form-control" maxlength="30" required>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.login.email")%> <span id="errEmail" class="errSpan"></span></label>
                                    <input type="email" name="userEmail" id="userEmail" class="form-control" maxlength="100" required>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.contactus.feedback")%> <span id="errFeedback" class="errSpan"></span></label>
                                    <textarea name="feedback" id="feedback" cols="4" rows="4" maxlength="2147483647" required></textarea>
                                </div>    
                                <div class="form-group">
                                 <button href="javascript:submitForm();" type="submit" class="theme-btn"><%=p.getProperty("public.contactus.button")%></button>
                                </div>
                            </form>
                            </div>
                            <div>   
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"> 
                                <div class="address">
                                <%=home.getContactAddress(domainId)%>
                                </div></div>
                            </div>    
                        </div>
                      </div>
                    </div>
                </div>
                        <!-- -------------------CMS Pages End-------------------------> 
            </div>    
        </div>
    </div>
 </div>
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>
<script src="<%=SystemConstant.PATH%>js/contact.js"></script>

</body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("contactus.jsp").log(Level.SEVERE, null, e);
  }%>