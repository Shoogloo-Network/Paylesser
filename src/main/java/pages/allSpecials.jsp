<%-- 
    Document   : allSpecials
    Created on : 1 Mar, 2016, 1 Mar, 2016 11:05:25 AM
    Author     : Vivek
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
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
  //List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
  SeoUrl seoObj = (SeoUrl)request.getAttribute("seo");
  String pageType = SystemConstant.ALL_SPECIALS;
  List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
  List<Specials> allCategoryList = home.getSpecialCatDomainId(domainId);
  List<Specials> allSpecialList = home.getAllSpecial(domainId);
  String storeId = "0";
  String pageTypeFk = "";
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
    <% /*for (SeoUrl s : seoList) {
        if (pageType.equals(s.getPageType())) {
          if (language.getId().equals(s.getLanguageId())) { */
    %>
    <title itemprop="name"><%=seoObj.getPageTitle()%></title>
    <meta name="description" content="<%=seoObj.getMetaDesc()%>">
    <meta name="keywords" content="<%=seoObj.getMetaKeyword()%>">
    <%  /*
            break;
          }
        }
      } */
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
  <!-- ======================Main Wraper Start==================== -->
<div id="wraper" class="inner"> 
<%@include file="common/topMenu.jsp" %>
        <div class="store-middle">
        <div class="container">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="cms-pages">
                        <h1 class="section-title"><%=p.getProperty("public.special.ourspecials")%></h1>
                        
                        <!-- <p class="section-desc">Lorem Ipsum is simply dummy text of the printing and typesetting industry. </p> -->
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">    
                                <div class="special-box-tab">
                                      <a href="<%=pageUrl + allSpecialUrl%>" class="active"><%=p.getProperty("public.special.ourspecials")%></a>
                                   <% 
                                    if(allCategoryList != null) {
                                      for(Specials spcat : allCategoryList){
                                            if (language.getId().equals(spcat.getLanguageId())) {
                                    %>
                                    <a href="<%=pageUrl + spcat.getSeoUrl()%>" class=""><%=spcat.getName()%></a>
                                    <% } } } %>
                                </div>           
                            </div> 
                            <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12"> 
                                <div class="special-item-wraper">
                            <%if (allSpecialList != null) {
                             ArrayList<String> al=new ArrayList<String>();  
                            for(Specials cat : allSpecialList){
                                if(!al.contains(cat.getSeoUrl())){
                                    al.add(cat.getSeoUrl());
                               
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
                            <%} } }%>
                            </div>
                            </div>  
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
</body>
</compress:html>
</html>