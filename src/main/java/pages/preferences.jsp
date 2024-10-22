<%-- 
    Document   : preferences
    Created on : Dec 22, 2014, 11:35:30 AM
    Author     : shabil.b
--%>

<%@page import="java.sql.ResultSet"%>
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
  List<SubscribedStore> subscribedStore = new ArrayList<SubscribedStore>();
  Map<String, List<SubscribedStore>> mapListsubscribedStore = new HashMap<String, List<SubscribedStore>>();
  List<SubscribedCategory> subscribedCategory = new ArrayList<SubscribedCategory>();
  Map<String, List<SubscribedCategory>> mapListsubscribedCategory = new HashMap<String, List<SubscribedCategory>>();
  String name = "";
  LoginInfo lInfo = new LoginInfo();
  if (session.getAttribute("userObj") != null) {
    lInfo = (LoginInfo) session.getAttribute("userObj");
    if (lInfo.getPublicUserName().contains(" ")) {
      name = lInfo.getPublicUserName().substring(0, lInfo.getPublicUserName().indexOf(" "));
    } else {
      name = lInfo.getPublicUserName();
    }
  }
  SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
   java.sql.ResultSet rsFav = null;
  String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
  String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  String qryFav = "SELECT VF.id, VS.image_big FROM vc_favourite_store VF, vc_store VS WHERE VF.store_id = VS.id AND VF.public_user_id = ? "
          + "AND VS.publish = 1 AND VS.trash = 0 ORDER BY VF.id DESC";
  String voucherClass = "";
  String voucherDesc = "";
  String storeId = "0";
  ResultSet rsSubStores = null;
  ResultSet rsSubCat = null;
  ResultSet rsUpdates = null;
  ResultSet rsSubStatus = null;
  ResultSet rsFavStoreCheck = null;
  ResultSet rsCatSeoUrl = null;
  ResultSet rsGenSubCheck = null;
  Db db = Connect.newDb();
  try {
    boolean top = true;
    boolean vouchers = true;
    boolean deals = true;
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    domainName = (String) session.getAttribute("domainName");
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
    String qrySubStatus = "SELECT subscription_status FROM nl_subscription WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ";
    String qryUpdates = "SELECT newsletter_type FROM nl_subscription WHERE public_user_id = ? AND domain_id = ? AND language_id = ? AND subscription_status = 1";
    String qryFavStoreCheck = "SELECT favorite_store_check FROM nl_subscription WHERE domain_id = ? AND language_id = ? AND public_user_id = ? ";
    String qryGenSubCheck = "SELECT nsd.general FROM nl_subscription_details nsd, nl_subscription nsub "
            + "WHERE nsd.subscription_id = nsub.id AND nsub.domain_id = ? AND nsub.language_id = ? "
            + "AND nsub.public_user_id = ? AND nsd.general = 1";
    String qrySubStores = "SELECT vsl.store_id, vsl.name, vsl.seo_url FROM nl_subscription nsub, nl_subscription_details nsd ,vc_store_lang vsl, vc_store vs "
            + "WHERE nsub.id = nsd.subscription_id AND nsub.domain_id = ? AND nsub.language_id = ? "
            + "AND nsub.public_user_id = ? AND nsd.store_id notnull "
            + "AND nsd.general = 0 AND vsl.language_id = nsub.language_id AND nsd.store_id = vsl.store_id "
            + "AND vs.id = vsl.store_id AND vs.trash = 0 AND vs.publish = 1 ORDER BY vsl.name ";
    rsSubStores = db.select().resultSet(qrySubStores, new Object[]{Integer.parseInt(domainId), Integer.parseInt(language.getId()), lInfo.getPublicUserId()});
    subscribedStore = new ArrayList<SubscribedStore>();
    while (rsSubStores.next()) {
      SubscribedStore sStore = new SubscribedStore();
      sStore.setStoreId(rsSubStores.getInt("store_id"));
      sStore.setStoreName(rsSubStores.getString("name"));
      sStore.setSeoUrl(rsSubStores.getString("seo_url"));
      subscribedStore.add(sStore);
    }
    mapListsubscribedStore.put("subscribedStore", subscribedStore);
    String qrySubCat = "SELECT DISTINCT gc.id, gc.name FROM nl_subscription nsub, nl_subscription_details nsd ,gl_category gc "
            + "WHERE nsub.id = nsd.subscription_id AND nsub.domain_id = ? AND nsub.language_id = ? "
            + "AND nsub.public_user_id = ? AND nsd.category_id notnull "
            + "AND gc.publish = 1 "
            + "AND nsd.general = 0 AND gc.language_id = nsub.language_id AND nsd.category_id = gc.id ORDER BY gc.name ";
    rsSubCat = db.select().resultSet(qrySubCat, new Object[]{Integer.parseInt(domainId), Integer.parseInt(language.getId()), lInfo.getPublicUserId()});
    subscribedCategory = new ArrayList<SubscribedCategory>();
    while (rsSubCat.next()) {
      SubscribedCategory sCategory = new SubscribedCategory();
      sCategory.setCategoryId(rsSubCat.getInt("id"));
      sCategory.setCategoryName(rsSubCat.getString("name"));
      rsCatSeoUrl = db.select().resultSet("SELECT seo_url FROM vc_domain_seo_config WHERE page_type = 4 AND pagetype_fk = ? "
              + "AND domain_id = ? AND language_id = ?", new Object[]{rsSubCat.getInt("id"), Integer.parseInt(domainId), Integer.parseInt(language.getId())});
      String seoUrl = "";
      if (rsCatSeoUrl.next()) {
        seoUrl = rsCatSeoUrl.getString("seo_url");
      }
      sCategory.setCategoryUrl(seoUrl);
      subscribedCategory.add(sCategory);
    }
    mapListsubscribedCategory.put("subscribedCategory", subscribedCategory);
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
        <title itemprop="name">Paylesser | <%=p.getProperty("public.saved_coupon.account")%></title>
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
                                        <h2 class="styled-bg"><span class="icon1"><img src="<%=SystemConstant.PATH%>images/My-Account-Preferences.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.myaccntprefer")%></h2>
                                        <div class="favorites-stores content-box">                                      
                                           <form role="form" name="frmUserPref" id="frmUserPref" action="/preferencesdb" method="post">
                                                
                                               <label><%=p.getProperty("public.saved_coupon.howoften")%></label>
                                               <%
                                                    String checkDaily = "", checkWeekly = "", noCheck = "";
                                                    rsSubStatus = db.select().resultSet(qrySubStatus, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(domain.getId()), Integer.parseInt(language.getId())});
                                                    if (rsSubStatus.next()) {
                                                      if (rsSubStatus.getInt("subscription_status") == 0) {
                                                        noCheck = "checked";
                                                      } else if (rsSubStatus.getInt("subscription_status") == 1) {
                                                        rsUpdates = db.select().resultSet(qryUpdates, new Object[]{lInfo.getPublicUserId(), Integer.parseInt(domain.getId()), Integer.parseInt(language.getId())});
                                                        if (rsUpdates.next()) {
                                                          if (rsUpdates.getInt("newsletter_type") == 1) {
                                                            checkDaily = "checked";
                                                          } else if (rsUpdates.getInt("newsletter_type") == 0) {
                                                            checkWeekly = "checked";
                                                          }
                                                        }
                                                      }
                                                    }
                                                  %>
                                               <div class="border">
                                                   <div class="form-group">
                                                       <input type="radio" name="updates" value="1" <%=checkDaily%> /> <%=p.getProperty("public.saved_coupon.dailyupdates")%>                                                
                                                   </div>
                                                   <div class="form-group">
                                                        <input type="radio" name="updates" value="2" <%=checkWeekly%> /> <%=p.getProperty("public.saved_coupon.weeklyupdates")%>
                                                   </div>
                                                   <div class="form-group">
                                                        <input type="radio" name="updates" value="3" <%=noCheck%> /> <%=p.getProperty("public.saved_coupon.stopallupdates")%>
                                                   </div>
                                               </div>
                                               <label><%=p.getProperty("public.saved_coupon.favstores")%></label>
                                                <%
                                          String checkFavStore = "";
                                          rsFavStoreCheck = db.select().resultSet(qryFavStoreCheck, new Object[]{Integer.parseInt(domain.getId()), Integer.parseInt(language.getId()), lInfo.getPublicUserId()});
                                          if (rsFavStoreCheck.next()) {
                                            if (rsFavStoreCheck.getInt("favorite_store_check") == 1) {
                                              checkFavStore = "checked";
                                            }
                                          }
                                        %>
                                        
                                               <div class="border">
                                                   <div class="form-group">
                                                        <input type="checkbox" id="deal-alert" value="1" <%=checkFavStore%>/> <%=p.getProperty("public.saved_coupon.addmyfavstores")%>
                                                   </div>
                                               </div>
                                               <%
                                                String checkGenSub = "";
                                                rsGenSubCheck = db.select().resultSet(qryGenSubCheck, new Object[]{Integer.parseInt(domain.getId()), Integer.parseInt(language.getId()), lInfo.getPublicUserId()});
                                                if (rsGenSubCheck.next()) {
                                                  if (rsGenSubCheck.getInt("general") == 1) {
                                                    checkGenSub = "checked";
                                                  }
                                                }
                                              %>
                                               <label><%=p.getProperty("public.saved_coupon.vcalert")%></label>
                                               <div class="border">
                                                   <div class="form-group">
                                                        <input type="checkbox" id="voucher-alert" value="1" <%=checkGenSub%>/> <%=p.getProperty("public.saved_coupon.differentoffers")%>
                                                   </div>
                                               </div>
                                                  
                                                <div class="form-group">
                                                 <button type="button" class="btn green" onclick="javascript:submitPreferences()"><%=p.getProperty("public.signup.savechanges")%></button>
                                                </div>
                                            </form>   
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
                pubUserId = <%=lInfo.getPublicUserId()%>;
                domainId = <%=domainId%>;
                langId = <%=language.getId()%>
            </script>
<script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("preferences.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rsFav);
    Cleaner.close(rsSubStores);
    Cleaner.close(rsSubCat);
    Cleaner.close(rsSubStatus);
    Cleaner.close(rsUpdates);
    Cleaner.close(rsFavStoreCheck);
    Cleaner.close(rsCatSeoUrl);
    Cleaner.close(rsGenSubCheck);
    db.select().clean();
    Connect.close(db);
  }%>
