<%-- 
    Document   : allStores
    Created on : 1 Mar, 2016, 1 Mar, 2016 12:03:25 PM
    Author     : Vivek
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
        String pageType = SystemConstant.ALL_STORES;
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
        List<AllStores> storeListByName = home.getAllStoreByName(domainId+language.getId());
        //List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        SeoUrl seoObj = (SeoUrl)request.getAttribute("seo");
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
                if (SystemConstant.ALL_STORES.equals(s.getPageType())) {
                    if (language.getId().equals(s.getLanguageId())) { */%>
        <title itemprop="name"><%=seoObj.getPageTitle()%></title>
        <meta name="description" content="<%=seoObj.getMetaDesc()%>">
        <meta name="keywords" content="<%=seoObj.getMetaKeyword()%>">
        <%
                       /* break;
                    }
                }
            } */%>
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
        <div class="container ">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="cms-pages" id="outer-panel">
                        <h2><%=p.getProperty("public.home.popularstores")%></h2>
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">  
                                <% if (storeListByDomain != null) { %>
                                <div id="popular-store" >
                                  <div class="row">
                                        <%
                                                  List<Store> storeList = CommonUtils.getTopStoreList(storeListByDomain, language.getId());
                                                  for (Store store : storeList) {
                                                                  if (("0".equals(homeConfig.getStoreListRow()) && storeRows < 18) || ("1".equals(homeConfig.getStoreListRow()) && storeRows < 12)) {
                                        %>
                                        <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6">
                                          <div class="item-inner">
                                                  <div class="item-image">
                                                      <a href="<%=pageUrl + store.getSeoUrl()%>"><img src="<%=cdnPath + store.getImageBig()%>" alt="<%=store.getName()%> offer" title="<%=store.getName()%> voucher"></a>
                                                  </div>
                                            <!--    <div class="item-info <%=rtl%>">
                                                  <h4><a href="<%=pageUrl + store.getSeoUrl()%>"><span><%=store.getName()%></span><%=(home.getStoreOfferCount(store.getId()))==null?0: home.getStoreOfferCount(store.getId())%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></a> </h4>
                                                </div>     -->   
                                          </div>
                                        </div> 
                                        <% storeRows++; } } %>
                                  </div>
                                </div>
                                <%}%>
                            </div>
                        </div>
                        <h2><%=p.getProperty("public.home.allstores")%></h2>
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">                                 
                                <div class="all-stores-head">
                                    <ul>
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
                                </div>           
                            </div> 
                        </div>
                        
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">    
                            <div class="store-content-wrap" >
                              <%
                              String content = "";
                              for(AllStores as : storeListByName){
                              %>
                              <div class="store-content" id="<%=as.getAlphabet().toLowerCase()%>">
                                      <h3><%=as.getAlphabet().toUpperCase()%></h3>
                                      <ul class="store-content-ul">
                                          <%=as.getContent()%>
                                      </ul>
                                      <!--<a href="#outer-panel" class="back-to-top btn"><%=p.getProperty("public.all_store.back")%></a>-->
                                  </div> 
                                  <%  } %>  
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
<script>
    if($(window).width()>1200){
    $(document).on('click', '.all-stores-head a', function(event){
    event.preventDefault();
    
    $('html, body').animate({    
        scrollTop: $( $.attr(this, 'href') ).offset().top - 130
    }, 500);
});
    }

    
</script>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("allStores.jsp").log(Level.SEVERE, null, e);
} finally {

}%>
