<%-- 
    Document   : CategorySpecial
    Created on : 2 Mar, 2016, 2 Mar, 2016 10:44:29 AM
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
<%
  String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
  String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log0mail").replaceAll("\\<.*?>", "");
  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  String requestUrl = request.getRequestURL().toString();
  String domainName = "";
  String pageName = "";
  pageName = (String) session.getAttribute("pageName");
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
  String pageType = SystemConstant.SPECIAL_CATEGORY;
  List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
  String catId = request.getParameter("d") == null ? "" : request.getParameter("d").replaceAll("\\<.*?>", "");
  String catName = home.getSpecialCat(catId);
  String langId = CommonUtils.getcntryLangCd(domainId);
  //String[] catDets = catDet;
  //String catId = catDets[0];
  //String catName = catDets[1];
  List<Specials> allCategoryList = home.getCategorySpecial(domainId,catId);
  List<Specials> allCategories = home.getSpecialCatDomainId(domainId);
  //session.setAttribute("similarspecialcatid", catId);
  String storeId = "0";
  String pageTypeFk = "";
  String active = "";
  List<MetaTags> metaList = home.getMetaByDomainId(domainId);  
%>
<!DOCTYPE html> 
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">				
    <%
        if(seoList != null) {
          for (SeoUrl s : seoList) {
            if (catId.equals(s.getPageTypeFk()) && pageType.equals(s.getPageType())) {
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
        }
    %>
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
  <div id="wraper" class="inner"> 
  <%@include file="common/topMenu.jsp" %>
  <div class="store-middle">
        <div class="container">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="cms-pages">
                        <h1 class="section-title"><%=catName%></h1>
                       <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">    
                                <div class="special-box-tab">
                                   <a href="<%=pageUrl + allSpecialUrl%>" ><%=p.getProperty("public.special.ourspecials")%></a>
                                   <% 
                                    if(allCategories != null) {
                                      for(Specials spcat : allCategories){
                                          active = "";
                                        if (language.getId().equals(spcat.getLanguageId())) {
                                         if (pageName.equals(pageUrl + spcat.getSeoUrl())){
                                             active = "active";
                                         }
                                    %>
                                    <a href="<%=pageUrl + spcat.getSeoUrl()%>" class="<%=active%>"><%=spcat.getName()%></a>
                                    <% } } } %>
                                </div>           
                            </div> 
                            <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12"> 
                            <%if (allCategoryList != null) {
                            for(Specials cat : allCategoryList){
                                if (language.getId().equals(cat.getLanguageId())) {
                            %>
                            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">    
                                <div class="special-item">
                                   <figure>
                                       <a href="<%=pageUrl + cat.getSeoUrl()%>"><img src="<%=cdnPath +cat.getImage()%>" alt="image" class="img-responsive"></a>
                                    </figure>
                                    <p class="txt">
                                        <a href="<%=pageUrl + cat.getSeoUrl()%>"><%=cat.getName()%></a>
                                    </p>
                                </div>           
                            </div> 
                            <% } } }%> 
                            </div>
                        </div>
                        <!-- -------------------CMS Pages End-------------------------> 
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

