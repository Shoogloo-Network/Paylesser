<%--
    Document   : coupon-details
    Created on : 18 Mar, 2016, 18 Mar, 2016 11:20:48 AM
    Author     : Vivek
--%>
<%@page import="java.net.URLEncoder"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.sql.ResultSet"%>
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
  java.sql.PreparedStatement psUsedCoupon = null;
  ResultSet rsOffer = null;
  ResultSet rsUsedCount = null;
  ResultSet rsComment = null;
  ResultSet rsCommentCount = null;
  Db db = Connect.newDb();
  try {
    String success1 = request.getParameter("msg") == null ? "" : request.getParameter("msg").replaceAll("\\<.*?>", "");  
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
    boolean top = true;
    boolean vouchers = true;
    boolean deals = true;
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    domainName = (String) session.getAttribute("domainName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    String voucherClass = "";
    String voucherDesc = "";
    String pageType = "0";
    pageType = SystemConstant.COUPON_DATILS;
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
    //List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
    SeoUrl seoObj = (SeoUrl)request.getAttribute("seo");
    boolean pop = (request.getParameter("h")!=null)?true:false;
    
    //List<VoucherDeals> offerDealList = home.getCouponDetails(db, request.getParameter("vc"), language.getId(), domainId);
    VoucherDeals vd = CommonUtils.getCouponDetail((String)request.getParameter("vc"));
    if(vd==null){
        List<VoucherDeals> offerDealList = home.getCouponDetails(db, request.getParameter("vc"), language.getId(), domainId);
       if(offerDealList!=null && offerDealList.size()>0){
        vd = offerDealList.get(0);
       }else{ %>
           <meta http-equiv="refresh" content="0; url=<%=pageUrl %>" /> 
    <%   }
    }
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    String storeId = "0";
    List<Category> allCategoryList = home.getCatByDomainId(domainId);
    String couponHeading = "";
    String couponCode = "";
    String peopleUsed = "";
    String storeName = "";
    String storeUrl = "";
    String strQuery = "";
    Integer userId = null;
    String terms = "";
    String offerType = "";
    String imagePath = "";
    String StoreSeoUrl = "";
    String similarStoreIds = "0";
    String catIds = "0";
    String catSCIds = "0";
    String id = "";
    String langId = CommonUtils.getcntryLangCd(domainId);
    LoginInfo lInfo = new LoginInfo();
    if (session.getAttribute("userObj") != null) {
      LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
      userId = linfo.getPublicUserId();
    }
    String strLang = language.getId() == null ? "" : language.getId();
    int intOffer = Integer.parseInt(request.getParameter("vc") == null ? "0" : request.getParameter("vc"));
    String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg").replaceAll("\\<.*?>", "");
    //db.execute().insert("INSERT INTO vc_used_coupon (offer_id, public_user_id, domain_id, ip, user_agent, used_date, id) VALUES (?, ?, ?, ?, ?, ?, ?)", new Object[]{intOffer, userId, Integer.parseInt(domainId), request.getRemoteAddr(), request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime())}, "vc_used_coupon_seq");   
    strQuery = "SELECT COALESCE(((COUNT(offer_id)*5)+1),1) used_count_today,offer_id FROM vc_used_coupon WHERE used_date >= current_date AND offer_id = ? GROUP BY offer_id";
    psUsedCoupon = db.select().getPreparedStatement(strQuery);
    psUsedCoupon.clearParameters();
    psUsedCoupon.setInt(1, intOffer);
    rsUsedCount = psUsedCoupon.executeQuery();

    strQuery = "SELECT VO.coupon_code AS coupon_code, VOL.offer_heading AS offer_heading, VOL.offer_description AS offer_description, "
            + "VS.affiliate_url AS store_url, VSL.name AS store_name FROM vc_offer VO, vc_offer_lang VOL, vc_store VS, vc_store_lang "
            + "VSL WHERE VO.id = VOL.offer_id AND VO.store_id = VS.id AND VO.store_id = VSL.store_id AND VO.id = ? AND "
            + "VOL.language_id = ? AND VSL.language_id = ?";
    psUsedCoupon = db.select().getPreparedStatement(strQuery);
    psUsedCoupon.clearParameters();
    psUsedCoupon.setInt(1, intOffer);
    psUsedCoupon.setInt(2, Integer.parseInt(strLang));
    psUsedCoupon.setInt(3, Integer.parseInt(strLang));
    rsOffer = psUsedCoupon.executeQuery();
    rsComment = db.select().resultSet("SELECT name,comments,add_date, replies FROM vc_comments WHERE publish = 1 and offer_id = ? and domain_id = ?", new Object[]{intOffer, Integer.parseInt(domainId)});
    rsCommentCount = db.select().resultSet("SELECT COUNT(*) As count FROM vc_comments WHERE publish = 1 and offer_id = ? and domain_id = ?", new Object[]{intOffer, Integer.parseInt(domainId)});
    int comCount = 0;
    if(rsCommentCount.next()){
        comCount = rsCommentCount.getInt("count");
    }
    List<MetaTags> metaList = home.getMetaByDomainId(domainId);
    List<String> listSimilarStores1 = home.getSimilarStoresTopPages(storeId, domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
  <head>
    <meta charset="utf-8"/>    
    <% /* for (SeoUrl s : seoList) {
        if (SystemConstant.COUPON_DATILS.equals(s.getPageType())) {
          if (language.getId().equals(s.getLanguageId())) { */%>        
     <%
      if (vd != null) {
          String image = "";           
            if(vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                image = (SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length())) + vd.getOfferImage();
              } else {
                image = (SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length()))+ vd.getImageBig();
              } 
         //String wImage = "/pages/ogimage.jsp?image="+image;
         String wImage = SystemConstant.PATH + "images/pl-logo-og.png";
      %>
        <title itemprop="name"><%=vd.getOfferHeading()%></title>
        <meta name="description" content="<%=vd.getOfferDesc().replaceAll("\\<.*?\\>", "")%>">
        <meta property="og:url"           content="<%=pageUrl+seoObj.getSeoUrl()+"?vc="+intOffer%>" />
	<meta property="og:type"          content="website" />
        <meta property="og:image"          content="<%=wImage%>" />
	<meta property="og:title"         content="<%=vd.getOfferHeading()%>" />
	<meta property="og:description"   content="<%=vd.getOfferDesc().replaceAll("\\<.*?\\>", "")%>" />                     
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <% }%>
    <%/*}
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
    <meta name="robots" content="noindex, nofollow">
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
    <div id="wraper" class="inner">   
  <%@include file="common/topMenu.jsp" %> 
    <div class="store-middle">
        <div class="container ">
            <div class="row">  
              <%if(pop){%>
                <div class="col-md-12">
                <div id="get-voucher">                   
                    <div class="get-voucher-inner">
                     <jsp:include page="ajaxCouponPopup.jsp" >
                      <jsp:param name="type" value="2" />
                                <jsp:param name="offerId" value="<%=vd.getId()%>" />
                                <jsp:param name="languageId" value="<%=vd.getLanguageId()%>" />
                            </jsp:include> 
                        <a href="<%=pageUrl + vd.getStoreSeoUrl()%>" style="font-size: 15px;color: #ff8827;text-transform: uppercase; padding-bottom: 10px; display: inline-block;"> <i class="fa fa-arrow-left" aria-hidden="true"></i> Back To Store</a>
                        <div class="social-like" style="float:right">
                            <%
                            String fbUrl = "";
                            try{          
                            fbUrl = URLEncoder.encode(part2, "UTF-8");
                            }catch(Exception e){System.out.println(e);}                     
                            %>
                            <iframe src="https://www.facebook.com/v2.5/plugins/like.php?layout=button_count&href=<%=fbUrl%>" style="height:20px;width:70px;border:0;"></iframe>
                            <div class="g-plusone" data-size="medium" data-href="<%=part2%>"></div>
                        </div>
                    </div> 
                 </div>
                </div>
                <%}%>
                      
                <!-- -------------------Offer List Start------------------------->
                <div class="pull-right col-lg-9 col-md-9 col-sm-12 col-xs-12">
                   <%if(!pop){%>
                    <div class="page-header"><h1><%=part1%>&nbsp;<%=part3%></h1>
                        <div class="social-like" style="float:right">
                            <%
                            String fbUrl = "";
                            try{          
                            fbUrl = URLEncoder.encode(part2, "UTF-8");
                            }catch(Exception e){System.out.println(e);}                     
                            %>
                            <iframe src="https://www.facebook.com/v2.5/plugins/like.php?layout=button_count&href=<%=fbUrl%>" style="height:20px;width:70px;border:0;"></iframe>
                            <div class="g-plusone" data-size="medium" data-href="<%=part2%>"></div>
                        </div>
                    </div>
                    <div class="offer-list">
                        <%
                            if (vd != null) {
                                if (language.getId().equals(vd.getLanguageId())) {
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
                                  if(vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                                    imagePath = cdnPath + vd.getOfferImage();
                                  } else {
                                    imagePath = cdnPath + vd.getImageSmall();
                                  } 
                                  storeId += "," + vd.getStoreId();
                                  couponHeading = vd.getOfferHeading();
                                  couponCode = vd.getCouponCode();
                                  peopleUsed = vd.getUsedCountToday();
                                  storeName = vd.getStoreName();
                                  storeUrl = vd.getStoreUrl();
                                  terms = vd.gettAndc();
                                  offerType = vd.getOfferType();
                                  id = vd.getId();
                                  
                          %>
                        <%@include file="common/deskOffer.jsp" %> 
                        <% } } %>
                    </div>
                    <%}%>
                    <% if(listSimilarStores1 != null){ %>
                    <div class="new-related">
                        <h5><span><%=p.getProperty("public.coupon.related")%></span></h5>                        
                        <ul>
                        <% for (String s : listSimilarStores1) {
                            List<Store> simStoreListById = home.getAllStoreById(s);
                            if(simStoreListById != null) {
                              for (Store st1 : simStoreListById) {
                                if (st1.getLanguageId().equals(language.getId())) {
                                    if(!st1.getId().equals(pageTypeFk)){                                       
                                     similarStoreIds += "," + st1.getId();
                                    }
                                  }
                              }
                            }
                        }

                        List<VoucherDeals> mobileVdListById = new ArrayList<VoucherDeals>();
                        List<VoucherDeals> deskVdListById = new ArrayList<VoucherDeals>();
                        List<VoucherDeals> vdListById = null;
                        vdListById = home.getSimilarStoresOffers(similarStoreIds, language.getId(),catSCIds);   
                        if(vdListById == null || vdListById.size()==0){
                          List<Store> simStoreListById = home.getAllStoresByDomainId(domainId);
                            if(simStoreListById != null) {
                              for (Store st2 : simStoreListById) {
                                if (st2.getLanguageId().equals(language.getId())) {
                                   if(!st2.getId().equals(pageTypeFk)){ 
                                       List<VoucherDeals> vdTempList = home.getAllVDById(st2.getId());
                                       if(vdTempList!=null && vdTempList.size()>0)
                                        vdListById.add(vdTempList.get(0));
                                   } 
                                 }
                                
                              }
                            }                           
                        }
                        if (vdListById != null) {
                           mobileVdListById.clear();
                           deskVdListById.clear();
                         for (VoucherDeals cd : vdListById) {
                            //cd.setBenifitType("0");
                            if("1".equals(cd.getExclusive())){ 
                             if("1".equals(cd.getViewType())){
                                 mobileVdListById.add(0,cd);
                             }else if("0".equals(cd.getViewType())){
                                deskVdListById.add(0,cd);
                             }
                            }else{
                              if("1".equals(cd.getViewType())){
                                 mobileVdListById.add(cd);
                             }else if("0".equals(cd.getViewType())){
                                deskVdListById.add(cd);
                             }  
                            }
                          }
                        }%>    
                        
                        <%
                        int couponCountSimilar = 0;
                        if (deskVdListById != null) {
                          for (VoucherDeals cd : deskVdListById) {
                             if(couponCountSimilar>14)
                                break;
                            if (cd.getLanguageId().equals(language.getId())) {
                              couponCountSimilar++;
                              if ("1".equals(cd.getOfferType())) {
                                  voucherClass = "click-to-code vpop";
                                  voucherDesc = p.getProperty("public.home.get_voucher");
                              } else if ("2".equals(cd.getOfferType()) && (cd.getOfferImage() == null || "".equals(cd.getOfferImage()))) {
                                  voucherClass = "activate-deal-2 u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              } else if ("2".equals(cd.getOfferType()) && (cd.getOfferImage() != null || !"".equals(cd.getOfferImage()))) { //product deal
                                  voucherClass = "activate-deal u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              }
                        %>
                            <li><a class="couponDetails <%=cd.getId()%> cursor-href pointer"><i class="fa fa-tag" aria-hidden="true"></i><%=cd.getOfferHeading()%></a></li>
                        <% } } } %>
                        </ul>
                    </div>
                    <% } %>
                    <div class="comment-wrapper">
                        <%if (rsComment.next()) {%>
                        <h5><span><%=comCount + " Comments"%></span></h5>
                        <ul  class="post-list">
                        <% do { %>
                            <li class="post">
                                <div  class="post-content">
                                    <div class="avatar">
                                        <a href="#" class="user">
                                            <img  src="<%=SystemConstant.PATH%>images/noavatar.png" alt="Avatar">
                                        </a>
                                    </div>
                                    <div class="post-body">
                                        <header class="comment__header">
                                            <a href="#" class="author"><%=rsComment.getString("name")%></a>
                                        </header>
                                        <div class="post-message">
                                            <p><%=rsComment.getString("comments")%> </p>
                                            <%if(rsComment.getString("replies")!=null && !"".equals(rsComment.getString("replies"))){%>
                                                <blockquote  class="post-content" style="margin-top: 20px">
                                                                         
                                                    <div class="post-body">
                                                        <header class="comment__header">
                                                            <a href="#" class="author">Admin</a>
                                                        </header>
                                                        <div class="post-message">
                                                            <p><%=rsComment.getString("replies")%> </p>
                                                        </div>
                                                    </div>
                                                </blockquote>        
                                             <%}%>       
                                        </div>
                                    </div>
                                </div>
                                <!--<ul  class="post-list">
                                    <li class="post">
                                        <div  class="post-content">
                                            <div class="avatar">
                                                <a href="#" class="user">
                                                    <img  src="<%=SystemConstant.PATH%>images/noavatar.png" alt="Avatar">
                                                </a>
                                            </div>
                                            <div class="post-body">
                                                <header class="comment__header">
                                                    <a href="#" class="author">Paylesser India</a>
                                                </header>
                                                <div class="post-message">
                                                    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. 
                                                       </p>
                                                </div>
                                            </div>
                                        </div>
                                        <ul>

                                        </ul>
                                    </li>

                                </ul>-->
                            </li>
                           <%} while (rsComment.next());%> 
                        </ul>
                      <% }%>
                    </div>
                    <div class="comment">
                        <h2><%=p.getProperty("public.coupon.addcomment")%></h2>
                        <p id="commentMsg" style="display: none"></p>
                        <% if(success1.equalsIgnoreCase("OK")){%>
                                <div class="alert alert-success" role="alert" ><%=p.getProperty("public.messages.comment")%></div>
                             <%}%>
                        <form name="frmComment" id="frmComment" method="post" action="/addcommentdb">
                              <!--<label><%=p.getProperty("public.home.coupondetails.name")%></label>-->
                              <input id="userName" name="userName" type="text" class="form-group" placeholder="<%=p.getProperty("public.home.coupondetails.name")%>" style="width:49%;margin-right:1.5%" required/>
                              <input id="email" name="email" type="text" class="form-group" style="width:49%" placeholder="<%=p.getProperty("public.login.email")%>" required /> 
                              <!--<label><%=p.getProperty("public.home.coupondetails.add_comments")%></label>-->
                              <textarea id="comment" name="comment" cols="4" rows="4" class="tab-textarea" placeholder="<%=p.getProperty("public.home.coupondetails.add_comments")%>" required></textarea>                                            
                              <input id="offerId" name="offerId" type="hidden" value="<%=intOffer%>"/>
                              <input id="domainId" name="domainId" type="hidden" value="<%=domainId%>"/>
                              <input id="languageId" name="languageId" type="hidden" value="<%=language.getId()%>"/>
                              <input id="commentAddedMsg" name="commentAddedMsg" type="hidden" value="<%=msg%>"/>
                              <input id="pageType" name="pageType" type="hidden" value="<%=SystemConstant.COUPON_DATILS%>"/>
                              <input id="pageType" name="returnUrl" type="hidden" value="<%=couponDetails%>"/>
                              <a href="javascript:addComment();" class="tab-btn"> <button type="submit" class="btn green"><%=p.getProperty("public.home.coupondetails.post")%></button></a>
                        </form>
                        <%if (rsComment.next()) {%>
	  <h4><%=p.getProperty("public.home.coupondetails.people")%></h4>
	  <ul class="recent-comments">
                <%
                  do {
                %>
                <li>
                  <p>
                        <%=rsComment.getString("comments")%>
                  </p>
                  <%
                        Date today = new Date();
                        String commentedTime = rsComment.getString("add_date").substring(0, rsComment.getString("add_date").indexOf("."));
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        //SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                        String now = sdf.format(today);
                        Date d1 = null;
                        Date d2 = null;
                        d1 = sdf.parse(commentedTime);
                        d2 = sdf.parse(now);
                        long diff = d2.getTime() - d1.getTime();
                        long diffHours = diff / (60 * 60 * 1000);
                        int diffInDays = (int) (diff / (1000 * 60 * 60 * 24));
                        if (diffInDays > 0) {
                  %>
                  <p class="comment-author"><%=diffInDays%> <%=p.getProperty("public.home.coupondetails.days")%> <%=rsComment.getString("name")%></p>
                  <%} else {%>
                  <p class="comment-author"><%=diffHours%> <%=p.getProperty("public.home.coupondetails.hours")%> <%=rsComment.getString("name")%></p>
                  <%}%>
                </li>  
                <%} while (rsComment.next());%>
          </ul>
          <% }%>
          <div class="tab-cnt-section terms-tab" id="tab-2">
	  <%//=terms%>
          </div>
                    </div>
          
                    <!-- -----We Recommend------>
                        <%@include file="common/weRecommend.jsp" %> 
          
                </div>
                <!-- -------------------Offer Item End------------------------->   
                <!-- -------------------Sidebar Start------------------------->
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs hidden-sm">
                    <div class="sidebar">  
                        <!-- -----Side Banner 1----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="1" />
                        </jsp:include>
                         <!-- -----We Recommend------>
                        <%@include file="common/popularStores.jsp" %>                         
                        <!-- -----Side Banner 2----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="2" />
                        </jsp:include>
                        <!-- -----We Recommend------>
                        <%@include file="common/popularCategory.jsp" %>  
                        <!-- -----Side Banner 3----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="3" />
                        </jsp:include>
                        <!-- -----Side Banner 4----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="4" />
                        </jsp:include>
                        <!-- -----Side Banner 5----->
                        <jsp:include page="common/sideBanner.jsp" >
                            <jsp:param name="position" value="5" />
                        </jsp:include>                      
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->
            </div>    
        </div>
    </div>
 </div>          
    <%@include file="common/bottomMenu.jsp" %>
    <%@include file="common/footer.jsp" %>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script>
        comment = '<%=p.getProperty("public.messages.comment")%>';
        nameRequired = '<%=p.getProperty("public.messages.nameRequired")%>';
        commentRequired = '<%=p.getProperty("public.messages.commentRequired")%>';
    </script>
</body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("coupon-details.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(psUsedCoupon);
    Cleaner.close(rsOffer);
    Cleaner.close(rsUsedCount);
    Cleaner.close(rsComment);
    Cleaner.close(rsCommentCount);
    db.select().clean();
    Connect.close(db);
  }
%>