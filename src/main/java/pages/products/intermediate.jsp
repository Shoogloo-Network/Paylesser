<%-- 
    Document   : intermediate
    Created on : Mar 15, 2016, 2:47:36 PM
    Author     : Ramavtar Jatav
--%>

<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%
String networkUrl ="/";
Product product = (Product)request.getAttribute("product");
String productName ="";
float productPrice=0;
String productUrl="";
String affIdSnapdeal ="";
String affIdFlipkart ="";
String affIdAmazon ="";


LoginInfo lInfo = new LoginInfo();
String name = "";
if(session.getAttribute("userObj") != null) {
    lInfo = (LoginInfo)session.getAttribute("userObj");
    if(lInfo.getPublicUserName().contains(" ")) {
        name = lInfo.getPublicUserName().substring(0, lInfo.getPublicUserName().indexOf(" "));
    } 
    else {
        name = lInfo.getPublicUserName();
    }
}
SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
int cnt = 1;
// Db db = Connect.newDb();
try {
    boolean top = true;
    boolean vouchers = true;
    boolean deals = true;
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    if (requestUrl.indexOf("http://") > -1) {
        String[] str1 = requestUrl.split("http://");
        if (str1[1].indexOf("/", 1) > -1) {
            domainName = str1[1].substring(0, str1[1].indexOf("/", 1));
        } else {
            domainName = str1[1];
        }

    //Check the validity of DOMAIN and get the DOMAIN_PKID and default language ID
        // if exits 
        if (str1[1].indexOf("/", 1) > -1 && str1[1].indexOf("/", 1) < str1[1].length()) {
            pageName = str1[1].substring(str1[1].indexOf("/", 1) + 1, str1[1].length());
        } else { // direct to index page

        }
    }
    String pageUrl = "http://" + domainName + "/";
    String pageType = "0";
    String pageTypeFk = "";
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
    List<MetaTags> metaList = home.getMetaByDomainId(domainId);
    String voucherClass = "";
    String voucherDesc = "";
    
  if (product!=null){
    productName = product.getName();
    productPrice = product.getPrice();
    productUrl = product.getProducturl();
    Properties prop = new Properties();
	InputStream input = null;
        input = getClass().getResourceAsStream("/feedmeta.properties");
        prop.load(input);
        
       
	
    
    if (product.getProducturl().contains("snapdeal")){
        affIdSnapdeal = prop.getProperty("aff_id_snapdeal");
        networkUrl = product.getProducturl()+ "?utm_source=aff_prog&utm_campaign=afts&offer_id=17&aff_id="+affIdSnapdeal;
    }else if(product.getProducturl().contains("flipkart")){
         affIdFlipkart = prop.getProperty("aff_id_flipkart");
        networkUrl = product.getProducturl()+ "&affid="+affIdFlipkart;
    }else if(product.getProducturl().contains("amazon")){
        affIdAmazon = prop.getProperty("aff_id_amazon");
        networkUrl = product.getProducturl()+ "?tag="+ affIdAmazon;
    }else{ // urls where direct affiliate links are available
        networkUrl = product.getProducturl();
    }   
   
}
String langId = CommonUtils.getcntryLangCd(domainId); 
        
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
    <head>
        <meta charset="utf-8">	
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <title itemprop="name"><%=productName%></title>
        <meta name="robots" content="noindex, nofollow">
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
        <meta http-equiv="refresh" content="2; url=<%=networkUrl %>" />
        
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
        
    <div class="wait">
        <img src="<%=SystemConstant.PATH%>images/pl-logo.png"/>
        <h1>You will be redirected to merchant's page. it might take a few second.</h1>
         <p><img src="<%=SystemConstant.PATH%>images/loader.gif"/></p>
        <h2>Just shop as normal and we take care of the rest.</h2>
        <h3>Please do not press refresh and back button of you browser</h3>
    </div>
    <style>
        .wait{width: 100%;margin: 0 auto;text-align: center;}
        .wait img{max-width: 300px;}
        .wait h1{float: left;width: 100%;font-size: 18px;color: #2c2b2b;}
        .wait h2{float: left;width: 100%;font-size: 24px;color: #ff8827;}
        .wait h3{float: left;width: 100%;font-size: 22px;color: #2c2b2b;}
        .wait p{float: left;width: 100%;font-size: 12px;color: #2c2b2b;}
        
        @media (max-width:767px) {
        .wait{padding:20px;} 
        }
    </style>
<%=domain.getAnalyticsCode()%>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
        Logger.getLogger("intermediate.jsp").log(Level.SEVERE, null, e);
} finally {
  
}%>




