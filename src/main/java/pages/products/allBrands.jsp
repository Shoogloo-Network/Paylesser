<%-- 
    Document   : allStores
    Created on : 1 Mar, 2016, 1 Mar, 2016 12:03:25 PM
    Author     : Vivek
--%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.TreeMap"%>
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
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
        String langId = CommonUtils.getcntryLangCd(domainId);
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<AllStores> storeListByName = home.getAllStoreByName(domainId+language.getId());
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
        Map<String,List<ProductBrand>> productBrandListMap= home.getAllBrandByDomainId(domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %> 
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">				
        
        <title itemprop="name">All Brands</title>
        <meta name="description" content="All Brands on Paylesser">
        <meta name="keywords" content="Paylesser, All Brands">
        
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
<body class="feed">
    <div id="wraper" class="inner"> 
    <%@include file="common/topmenu.jsp" %>
        <div class="store-middle">
            <div class="container ">
                <div class="row">
                    <!-- -------------------CMS Pages Start------------------------->
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="cms-pages" id="outer-panel" style="margin-top:20px;">
                            <h2>All Brands</h2>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">    
                                    <div class="all-stores-head">
                                        <ul>
                                            <li><a href="#0-9">0-9</a></li>
                                            <li><a href="#A">A</a></li>
                                            <li><a href="#B">B</a></li>
                                            <li><a href="#C">C</a></li>
                                            <li><a href="#D">D</a></li>
                                            <li><a href="#E">E</a></li>
                                            <li><a href="#F">F</a></li>
                                            <li><a href="#G">G</a></li>
                                            <li><a href="#H">H</a></li>
                                            <li><a href="#I">I</a></li>
                                            <li><a href="#J">J</a></li>
                                            <li><a href="#K">K</a></li>
                                            <li><a href="#L">L</a></li>
                                            <li><a href="#M">M</a></li>
                                            <li><a href="#N">N</a></li>
                                            <li><a href="#O">O</a></li>
                                            <li><a href="#P">P</a></li>
                                            <li><a href="#Q">Q</a></li>
                                            <li><a href="#R">R</a></li>
                                            <li><a href="#S">S</a></li>
                                            <li><a href="#T">T</a></li>
                                            <li><a href="#U">U</a></li>
                                            <li><a href="#V">V</a></li>
                                            <li><a href="#w">W</a></li>
                                            <li><a href="#X">X</a></li>
                                            <li><a href="#Y">Y</a></li>
                                            <li><a href="#Z">Z</a></li>
                                        </ul> 
                                    </div>           
                                </div> 
                            </div>      
                            <div class="row">
                              <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">    
                                <div class="store-content-wrap" >
                                        <%
                                        for(Map.Entry BGA:productBrandListMap.entrySet()){  
                                        %>
                                        <div class="store-content" id="<%=BGA.getKey()%>">
                                        <h3><%=BGA.getKey()%><a name="<%=BGA.getKey()%>"></a></h3>
                                          <ul class="store-content-ul">
                                              <% List<ProductBrand> productBrandList =(List<ProductBrand>)BGA.getValue();
                                              for(ProductBrand productBrand:productBrandList){%>
                                               <li> <a href="/<%=SystemConstant.ROOT_URL+"/"+productBrand.getSeo()%>"><%=SolrUtils.toDisplayCase(productBrand.getName())%></a></li>
                                              <%}%>
                                          </ul>
                                          <!--<a href="#mm-0" class="back-to-top btn"><%=p.getProperty("public.all_store.back")%></a>-->
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
        scrollTop: $( $.attr(this, 'href') ).offset().top -260
    }, 500);
});
    }

</script>
</body>
</html>
</compress:html>
<%} catch (Throwable e) {
    Logger.getLogger("allBrands.jsp").log(Level.SEVERE, null, e);
} finally {

}%>
