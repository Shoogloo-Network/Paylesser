<%-- 
    Document   : profile
    Created on : Mar 15, 2016, 2:47:36 PM
    Author     : IshahaqKhan
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
    java.sql.ResultSet rsShared = null;
    
    java.sql.ResultSet rsWorked = null;
    
    java.sql.ResultSet rsComments = null;
    
    

    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
    
    String qryShared = "SELECT DISTINCT VO.id,VO.used_count, VOL.modified_at, VS.image_small, VO.end_date, VOL.offer_description, VOL.seo_url, VO.offer_type,VO.offer_like, VO.coupon_code, VO.image, VOL.language_id, VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_offer VO, vc_offer_lang VOL, vc_store VS "
            + "WHERE VO.id = VOL.offer_id AND VO.store_id = VS.id AND VO.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 "
            + "AND VS.publish = 1 AND VS.trash = 0 AND VOL.language_id = ? ORDER BY VO.id DESC LIMIT 3 OFFSET 0";

    String qryWorked = "SELECT DISTINCT VO.id,VO.used_count, VOL.modified_at, VS.image_small, VO.end_date, VOL.offer_description, VOL.seo_url, VO.offer_type, VO.offer_like, VO.coupon_code, VO.image,VOL.language_id,  VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_offer_acceptance VOA, vc_offer VO, "
            + "vc_offer_lang VOL, vc_store VS WHERE VO.id = VOA.offer_id AND VO.id = VOL.offer_id AND VO.store_id = VS.id "
            + "AND VOA.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0 AND "
            + "VOL.language_id = ? AND VOA.like_dislike = ? ORDER BY VO.id DESC LIMIT 3 OFFSET 0";

    String qryComments = "SELECT DISTINCT VO.id,VO.used_count, VOL.modified_at, VS.image_small, VO.end_date, VOL.offer_description, VOL.seo_url, VO.offer_type, VO.offer_like, VO.coupon_code, VO.image,VOL.language_id, VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_comments VOA, vc_offer VO, vc_offer_lang VOL, "
            + "vc_store VS WHERE VO.id = VOA.offer_id AND VO.id = VOL.offer_id AND VO.store_id = VS.id AND VOA.public_user_id = ? AND "
            + "VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0 AND VOL.language_id = ? ORDER BY VO.id DESC LIMIT 3 OFFSET 0";

    
    int cnt = 1;

    Db db = Connect.newDb();

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
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
        String voucherClass = "";
        String voucherDesc = "";
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
        <title itemprop="name">Paylesser | <%=p.getProperty("public.home.profile")%></title>
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
        <link href="<%=SystemConstant.PATH%>css/mixins.css?ver=1.0" media="screen, projection" rel="stylesheet" type="text/css" />
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
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
                                        <h2><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Coupons-Shared.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.c_shared")%></h2>
                                        <div class="coupons-worked body-box"> 
                                            <%rsShared = db.select().resultSet(qryShared, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(language.getId())});
                                            List<VoucherDeals> offerList = new ArrayList<VoucherDeals>();
                                            while (rsShared.next()) {
                                                VoucherDeals vdl = new VoucherDeals();
                                                  vdl.setId(rsShared.getString("id"));
                                                
                                                  vdl.setCouponCode(rsShared.getString("coupon_code"));
                                                  vdl.setImageSmall(rsShared.getString("image_small"));
                                                  vdl.setLanguageId(rsShared.getString("language_id"));
                                                  vdl.setOfferLike(rsShared.getString("offer_like"));
                                                  vdl.setOfferType(rsShared.getString("offer_type"));
                                                  vdl.setUsedCountToday(rsShared.getString("used_count"));
                                                  vdl.setOfferHeading(rsShared.getString("offer_heading"));
                                                  vdl.setStoreSeoUrl(rsShared.getString("seo_url"));
                                                  vdl.setOfferImage(rsShared.getString("image"));
                                                  vdl.setOfferDesc(rsShared.getString("offer_description"));
                                                  vdl.setEndDate(format.format(rsShared.getDate("end_date")));
                                                  vdl.setModifiedAt(format.format(rsShared.getDate("modified_at"))); 
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
                                            <p class="no-data"><%=p.getProperty("public.saved_coupon.not_shared")%></p>  
                                        <%}%>
                                        </div> 
                                        <h2><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Coupons-Worked.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.worked")%></h2>
                                        <div class="coupons-worked body-box">  
                                            <%
                                            offerList = new ArrayList<VoucherDeals>();   
                                            rsWorked = db.select().resultSet(qryWorked, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(language.getId()), 1});                                                                                      
                                            while (rsWorked.next()) {
                                                VoucherDeals vdl = new VoucherDeals();
                                                  vdl.setId(rsWorked.getString("id"));
                                                
                                                  vdl.setCouponCode(rsWorked.getString("coupon_code"));
                                                  vdl.setImageSmall(rsWorked.getString("image_small"));
                                                  vdl.setLanguageId(rsWorked.getString("language_id"));
                                                  vdl.setOfferLike(rsWorked.getString("offer_like"));
                                                  vdl.setOfferType(rsWorked.getString("offer_type"));
                                                  vdl.setUsedCountToday(rsWorked.getString("used_count"));
                                                  vdl.setOfferHeading(rsWorked.getString("offer_heading"));
                                                  vdl.setStoreSeoUrl(rsWorked.getString("seo_url"));
                                                  vdl.setOfferImage(rsWorked.getString("image"));
                                                  vdl.setOfferDesc(rsWorked.getString("offer_description"));
                                                  vdl.setEndDate(format.format(rsWorked.getDate("end_date"))); 
                                                  vdl.setModifiedAt(format.format(rsWorked.getDate("modified_at")));
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
                                            <p class="no-data"><%=p.getProperty("public.saved_coupon.not_liked")%></p>  
                                        <%}
                                        if (rsWorked != null) {
                                            Cleaner.close(rsWorked);
                                        }%>
                                      
                                        </div> 
                                        <h2 class="styled-bg"><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Coupons-not-Worked.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.not_worked")%></h2>
                                        <div class="coupons-worked body-box">  
                                            <%
                                            offerList = new ArrayList<VoucherDeals>();    
                                            rsWorked = db.select().resultSet(qryWorked, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(language.getId()), 0});
                                            while (rsWorked.next()) {
                                                VoucherDeals vdl = new VoucherDeals();
                                                  vdl.setId(rsWorked.getString("id"));
                                                
                                                  vdl.setCouponCode(rsWorked.getString("coupon_code"));
                                                  vdl.setImageSmall(rsWorked.getString("image_small"));
                                                  vdl.setLanguageId(rsWorked.getString("language_id"));
                                                  vdl.setOfferLike(rsWorked.getString("offer_like"));
                                                  vdl.setOfferType(rsWorked.getString("offer_type"));
                                                  vdl.setUsedCountToday(rsWorked.getString("used_count"));
                                                  vdl.setOfferHeading(rsWorked.getString("offer_heading"));
                                                  vdl.setStoreSeoUrl(rsWorked.getString("seo_url"));
                                                  vdl.setOfferImage(rsWorked.getString("image"));
                                                  vdl.setOfferDesc(rsWorked.getString("offer_description"));
                                                  vdl.setEndDate(format.format(rsWorked.getDate("end_date"))); 
                                                  vdl.setModifiedAt(format.format(rsWorked.getDate("modified_at")));
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
                                            <p class="no-data"><%=p.getProperty("public.saved_coupon.not_disliked")%></p>
                                        <%}
                                         if (rsWorked != null) {
                                            Cleaner.close(rsWorked);
                                        }
                                        %>
                                                
                                        </div> 
                                        <h2 class="styled-bg"><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Comments-made.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.comments")%></h2>
                                        <div class="coupons-worked body-box">  
                                            <%
                                            offerList = new ArrayList<VoucherDeals>();    
                                            rsComments = db.select().resultSet(qryComments, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(language.getId())});
                                            while (rsComments.next()) {
                                                VoucherDeals vdl = new VoucherDeals();
                                                  vdl.setId(rsComments.getString("id"));
                                                
                                                  vdl.setCouponCode(rsComments.getString("coupon_code"));
                                                  vdl.setImageSmall(rsComments.getString("image_small"));
                                                  vdl.setLanguageId(rsComments.getString("language_id"));
                                                  vdl.setOfferLike(rsComments.getString("offer_like"));
                                                  vdl.setOfferType(rsComments.getString("offer_type"));
                                                  vdl.setUsedCountToday(rsComments.getString("used_count"));
                                                  vdl.setOfferHeading(rsComments.getString("offer_heading"));
                                                  vdl.setStoreSeoUrl(rsComments.getString("seo_url"));
                                                  vdl.setOfferImage(rsComments.getString("image"));
                                                  vdl.setOfferDesc(rsComments.getString("offer_description"));
                                                  vdl.setEndDate(format.format(rsComments.getDate("end_date"))); 
                                                  vdl.setModifiedAt(format.format(rsComments.getDate("modified_at")));
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
                                            <p class="no-data"><%=p.getProperty("public.saved_coupon.no_comments")%></p>
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
    
    <input id="off-shared" type="hidden" value="0"/>
    <input id="off-worked" type="hidden" value="0"/>
    <input id="off-n-worked" type="hidden" value="0"/>
    <input id="off-made" type="hidden" value="0"/>    
       
        
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>
<script>
    usrProfile = '<%=p.getProperty("public.home.saved_coupons")%>';
    favStores = '<%=p.getProperty("public.home.favourite_stores")%>';
    accntPrefer = '<%=p.getProperty("public.saved_coupon.account")%>';
    success = '<%=p.getProperty("public.messages.success")%>';
    expirymsg = '<%=p.getProperty("public.messages.expiry")%>';
    codemsg = '<%=p.getProperty("public.messages.code")%>';
    websitemsg = '<%=p.getProperty("public.messages.website")%>';
    websiteInvalid = '<%=p.getProperty("public.messages.websiteInvalid")%>';
</script>
<script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
        Logger.getLogger("profile.jsp").log(Level.SEVERE, null, e);
} finally {
    Cleaner.close(rsShared);
    Cleaner.close(rsWorked);
    Cleaner.close(rsComments);
    db.select().clean();
    Connect.close(db);
}%>