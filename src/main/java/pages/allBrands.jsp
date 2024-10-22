<%-- 
    Document   : allBrands
    Created on : Dec 29, 2014, 4:31:30 PM
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
    //out.println(request.getRequestURL());
        String requestUrl = request.getRequestURL().toString();
    //String requestUrl = "test.vouchercodes.in:8080/vcadmin/faces/public/index.jsp";
        String domainName = "";
        String pageName = "";
        domainName = (String)session.getAttribute("domainName");
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        String tabConfigCalss = "";
        int storeRows = 0;
        int top20 = 0;
        int rowCount = 0;
        int tabType = 4;
        String topBannerPath = "";
        String bottomBannerPath = "";
        String oneBanner = "";
        String newsltrClass = "";
        int popCatCount = 0;
        String popCatClass = "";
        String pageType = SystemConstant.All_BRAND;
        String pageTypeFk = "";
        VcHome home = VcHome.instance();
        String domainId = home.getDomainId(domainName);
        String langId = CommonUtils.getcntryLangCd(domainId);
        VcSession vcsession = VcSession.instance();
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<AllBrands> brandListByName = home.getAllBrandsByName(domainId+language.getId());
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);

%>
<!DOCTYPE html>
    <%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
        
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">			
        <%for (SeoUrl s : seoList) {
                if (SystemConstant.All_BRAND.equals(s.getPageType())) {
                    if (language.getId().equals(s.getLanguageId())) {%>
                    <title itemprop="name"><%=s.getPageTitle()%></title>
                    <meta name="description" content="<%=s.getMetaDesc()%>">
                    <meta name="keywords" content="<%=s.getMetaKeyword()%>">
                    <%
                        break;
                    }
                }
            }%>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%@include file="common/header.jsp" %>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        
   <div id="wraper" class="inner">   
    <%@include file="common/topMenu.jsp" %> 
    <div class="store-middle">
        <div class="container ">
            <div class="row">
                    <!-- Navigation -->
                    <div class="page-content clearfix inner-page all-stores">
                       <div class="main-offers-wrap wrapper clearfix">
                            <h2 class="common-head">All Brands</h2>
                            <ul class="all-stores-head clearfix">
                                <li><a href="#0-9">0-9</a></li>
                                <li><a href="#a">A</a></li>
                                <li><a href="#b">B</a></li>
                                <li><a href="#c">C</a></li>
                                <li><a href="#d">D</a></li>
                                <li><a href="#e">E</a></li>
                                <li><a href="#f">F</a></li>
                                <li><a href="#g">G</a></li>
                                <li><a href="#h">H</a></li>
                                <li><a href="#i">I</a></li>
                                <li><a href="#j">J</a></li>
                                <li><a href="#k">K</a></li>
                                <li><a href="#l">L</a></li>
                                <li><a href="#m">M</a></li>
                                <li><a href="#n">N</a></li>
                                <li><a href="#o">O</a></li>
                                <li><a href="#p">P</a></li>
                                <li><a href="#q">Q</a></li>
                                <li><a href="#r">R</a></li>
                                <li><a href="#s">S</a></li>
                                <li><a href="#t">T</a></li>
                                <li><a href="#u">U</a></li>
                                <li><a href="#v">V</a></li>
                                <li><a href="#w">W</a></li>
                                <li><a href="#x">X</a></li>
                                <li><a href="#y">Y</a></li>
                                <li><a href="#z">Z</a></li>
                            </ul>
                            <div class="store-content-wrap">
                              <%
                              String content = "";
                              if(brandListByName != null) {
                                for(AllBrands as : brandListByName){
                                %>
                                  <div class="store-content" id="<%=as.getAlphabet().toLowerCase()%>">
                                      <h3><%=as.getAlphabet().toUpperCase()%></h3>
                                      <ul class="store-content-ul">
                                        <%=as.getContent()%>
                                      </ul>
                                      <a href="#outer-panel" class="back-to-top"><%=p.getProperty("public.all_store.back")%></a>
                                  </div>
                                <%
                                }
                              }
                              %>  

                            </div>
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
<%} catch (Throwable e) {
        Logger.getLogger("allStores.jsp").log(Level.SEVERE, null, e);
    } finally {

    }%>
