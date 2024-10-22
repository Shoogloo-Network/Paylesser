<%-- 
    Document   : savedCoupons
    Created on : Dec 17, 2014, 10:58:20 AM
    Author     : shabil.b
--%>

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

<%
String name = "";
String imagePath = "";
LoginInfo lInfo = new LoginInfo();
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
java.sql.ResultSet rsSaved = null;

String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
String qrySaved = "SELECT COALESCE(TUCNT.used_cnt, 1) used_count_today, TOF.id, TOF.store_id, TOF.coupon_code, TOF.offer_url, TOF.end_date, TOF.offer_like, "
                 + "TOF.offer_dislike, TST.image_small, TST.image_big, TST.affiliate_url, TOFL.offer_heading, TOFL.offer_description, "
                 + "TOF.offer_type, TOF.used_count, TSL.name, TSL.seo_url, TOF.image, TOFL.modified_at, TOFL.language_id FROM vc_offer TOF INNER JOIN vc_saved_coupon VSC ON "
                 + "VSC.offer_id = TOF.id AND VSC.public_user_id = ? LEFT OUTER JOIN (SELECT offer_id AS o_id, ((COUNT(id)*5)+1) AS used_cnt "
                 + "FROM vc_used_coupon WHERE used_date >= current_date GROUP BY offer_id) as TUCNT ON TOF.id = TUCNT.o_id, vc_offer_lang TOFL, "
                 + "vc_store TST, vc_store_lang TSL WHERE TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND "
                 + "TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND "
                 + "TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOFL.language_id = ? AND TSL.language_id = ? "
                 + "ORDER BY VSC.id DESC";

String voucherClass = "";
String voucherDesc = "";
String storeId = "0";

Db db =  Connect.newDb();

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
        } 
        else {
            domainName = str1[1];
        }

        //Check the validity of DOMAIN and get the DOMAIN_PKID and default language ID
        // if exits 
        if (str1[1].indexOf("/", 1) > -1 && str1[1].indexOf("/", 1) < str1[1].length()) {
            pageName = str1[1].substring(str1[1].indexOf("/", 1) + 1, str1[1].length());
        } 
        else { // direct to index page

        }
    }
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
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
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
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
            <title itemprop="name">Paylesser | <%=p.getProperty("public.home.saved_coupons")%></title>
            <meta name="description" content="">
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
                        <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                            <div class="cms-pages">
                                <div class="content-box1">
                                <div class="user-profile-page">
                                <%@include file="common/commonProfile.jsp" %>
                                 <div class="user-profile-body">
                                     <div class="user-body-content">
                                        <h2><%=name%><%=p.getProperty("public.saved_coupon.activity")%></h2>
                                        <div class="coupons-worked body-box"> 
                                            <%rsSaved = db.select().resultSet(qrySaved, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(language.getId()), Integer.parseInt(language.getId())});
                                            List<VoucherDeals> offerList = new ArrayList<VoucherDeals>();
                                            while (rsSaved.next()) {
                                                VoucherDeals vdl = new VoucherDeals();
                                                  vdl.setId(rsSaved.getString("id"));
                                                
                                                  vdl.setCouponCode(rsSaved.getString("coupon_code"));
                                                  vdl.setImageSmall(rsSaved.getString("image_small"));
                                                  vdl.setLanguageId(rsSaved.getString("language_id"));
                                                  vdl.setOfferLike(rsSaved.getString("offer_like"));
                                                  vdl.setOfferType(rsSaved.getString("offer_type"));
                                                  vdl.setUsedCountToday(rsSaved.getString("used_count_today"));
                                                  vdl.setOfferHeading(rsSaved.getString("offer_heading"));
                                                  vdl.setStoreSeoUrl(rsSaved.getString("seo_url"));
                                                  vdl.setOfferImage(rsSaved.getString("image"));
                                                  vdl.setOfferDesc(rsSaved.getString("offer_description"));
                                                  vdl.setEndDate(format.format(rsSaved.getDate("end_date")));
                                                  vdl.setModifiedAt(format.format(rsSaved.getDate("modified_at"))); 
                                                  offerList.add(vdl);
                                                  vdl = null;
                                                }       
                                            
                                            %> 
                                                 <%     
                                                if (offerList.size()>0) {
                                                  for (VoucherDeals vd : offerList) {                                                    
                                                    if (vd.getLanguageId().equals(language.getId())) {                                                      
                                                      if ("1".equals(vd.getOfferType())) {
                                                          voucherClass = "click-to-code vpop";
                                                          voucherDesc = p.getProperty("public.home.get_voucher");
                                                      } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                                          voucherClass = "activate-deal-2 u-deal";
                                                          voucherDesc = p.getProperty("public.category.activate_deal");
                                                      } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                                          voucherClass = "activate-deal u-deal";
                                                          voucherDesc = p.getProperty("public.category.activate_deal");
                                                      }
                                                %>
                                                <%@include file="common/deskOffer.jsp" %> 
                                                <% } } } %>
                                        <% 
                                        else {%>
                                           <p class="warning"><%=p.getProperty("public.saved_coupon.text")%></p>  
                                        <%}%>
                                        </div>
                                    </div>
                                </div>
                                    </div>
                                </div>
                                <!-- -------------------CMS Pages End-------------------------> 
                            </div>   
                        </div>

                       <!-- -------------------Sidebar Start------------------------->
                         <!-- -----Coupon Status------>
                         <%@include file="common/couponStatus.jsp" %>                              
                         <!-- -----Submit Coupon------>
                         <%@include file="common/couponSubmit.jsp" %>
                         <!-- -------------------Sidebar End---------------------------->  
                       
                                
                    </div>    
                </div>
            </div>
            </div>
            <%@include file="common/bottomMenu.jsp" %>
            <%@include file="common/footer.jsp" %>
            <script>
                usrProfile = '<%=p.getProperty("public.home.saved_coupons")%>';
                favStores = '<%=p.getProperty("public.home.favourite_stores")%>';
                accntPrefer = '<%=p.getProperty("public.saved_coupon.account")%>';
            </script>
            <script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
        </body>
</compress:html>
    </html>
<%} 
catch(Throwable e) {
    Logger.getLogger("profile.jsp").log(Level.SEVERE, null, e);
}
finally {
    Cleaner.close(rsSaved);
    db.select().clean();
    Connect.close(db);
}%>