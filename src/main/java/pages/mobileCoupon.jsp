<%-- 
    Document   : mobileCoupon
    Created on : Dec 11, 2014, 2:12:05 PM
    Author     : jincy.p
--%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
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
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%
  java.sql.PreparedStatement psUsedCoupon = null;
  ResultSet rsOffer = null;
  ResultSet rsUsedCount = null;
  ResultSet rsComment = null;
  Db db = Connect.newDb();
  try {
    String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
    String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
    String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
    String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
    String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg").replaceAll("\\<.*?>", "");
    int intOffer = Integer.parseInt(request.getParameter("off") == null ? "0" : request.getParameter("off").replaceAll("\\<.*?>", ""));
    String strLang = request.getParameter("lan") == null ? "" : request.getParameter("lan").replaceAll("\\<.*?>", "");
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    String storeId = "0";
    String strQuery = "";
    String pageType = "0";
    String pageTypeFk = "";
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
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    String terms = "";
    db.execute().insert("INSERT INTO vc_used_coupon (offer_id, public_user_id, domain_id, ip, user_agent, used_date, id) VALUES (?, ?, ?, ?, ?, ?, ?)", new Object[]{intOffer, null, Integer.parseInt(domainId), request.getRemoteAddr(), request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime())}, "vc_used_coupon_seq");
    
    strQuery = "SELECT COALESCE(((COUNT(offer_id)*5)+1),1) used_count_today,offer_id FROM vc_used_coupon WHERE used_date >= current_date AND offer_id = ? GROUP BY offer_id";
    psUsedCoupon = db.select().getPreparedStatement(strQuery);
    psUsedCoupon.clearParameters();
    psUsedCoupon.setInt(1,intOffer);
    rsUsedCount = psUsedCoupon.executeQuery();
    
    strQuery = "SELECT VO.coupon_code AS coupon_code, VOL.offer_heading AS offer_heading, VOL.offer_description AS offer_description, VOL.terms_and_conditions AS terms_and_conditions, "
                + "VS.affiliate_url AS store_url, VSL.name AS store_name FROM vc_offer VO, vc_offer_lang VOL, vc_store VS, vc_store_lang "
                + "VSL WHERE VO.id = VOL.offer_id AND VO.store_id = VS.id AND VO.store_id = VSL.store_id AND VO.id = ? AND "
                + "VOL.language_id = ? AND VSL.language_id = ?";
    psUsedCoupon = db.select().getPreparedStatement(strQuery);
        psUsedCoupon.clearParameters();
        psUsedCoupon.setInt(1, intOffer);
        psUsedCoupon.setInt(2, Integer.parseInt(strLang));
        psUsedCoupon.setInt(3, Integer.parseInt(strLang));
        rsOffer = psUsedCoupon.executeQuery();
    rsComment = db.select().resultSet("SELECT name,comments,add_date FROM vc_comments WHERE publish = 1 and offer_id = ? and domain_id = ?", new Object[]{intOffer,Integer.parseInt(domainId)});
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
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>		
        <title itemprop="name"><%=p.getProperty("public.mobcoupon.title")%></title>
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
        <%@include file="common/topMenu.jsp" %>                    
            <div class="coupon-mobile popup-wrap mobile-popup">
                <div class="popup popup2">
                    <div class="voucher-popup">
                        <div class="voucher-area mobile">
                            <div class="voucher-content">
                              <%
                                if (rsOffer.next()) {
                                  terms = rsOffer.getString("terms_and_conditions");
                              %>
                                <h3 class="clearfix"><%=rsOffer.getString("offer_heading")%></h3>
                                <p class="copy-code"><%=p.getProperty("public.mobcoupon.copy")%></p>
                                <div class="voucher-msg voucher-code">
                                    <p><%=rsOffer.getString("coupon_code")%></p>
                                </div>
                                    <span class="popup-btn"><%=p.getProperty("public.mobcoupon.open")%> <a href="<%=rsOffer.getString("store_url")%>" target="_blank"><%=rsOffer.getString("store_name")%></a> <%=p.getProperty("public.mobcoupon.website")%></span>
                                <%}%>
                            </div>
                        </div>
                        <div class="popup-info">
                            <p>
                                <%
                                if(rsUsedCount.next()){
                                %><%=rsUsedCount.getString("used_count_today")%> <%=p.getProperty("public.mobcoupon.used")%>
                                <%}%> 
                            </p>
                        </div>
                        <div class="popup-tab">
                            <ul class="tab-head">
                                <li class="comments"><a href="#tab-1"><span class="tab-icons"><img src="<%=SystemConstant.PATH%>images/icon-comment-pp.png" alt="image" /></span><%=p.getProperty("public.mobcoupon.comments")%></a></li>
                                <%
                                if(!"".equals(terms)) {
                                %>                                
                                  <li class="terms"><a href="#tab-2"><span class="tab-icons"><img src="<%=SystemConstant.PATH%>images/icon-terms-pp.png" alt="image" /></span><%=p.getProperty("public.mobcoupon.terms")%></a></li>
                                <%
                                }
                                %>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-cnt-section" id="tab-1">
                                  <p id="commentMsg" style="display: none"></p>
                                  <form name="frmComment" id="frmComment" method="post" action="/addcommentdb">
                                    <label><%=p.getProperty("public.mobcoupon.name")%></label>
                                    <input id="userName" name="userName" type="text" class="tab-input" />
                                    <label><%=p.getProperty("public.mobcoupon.add_comment")%></label>
                                    <textarea id="comment" name="comment" cols="4" rows="4" class="tab-textarea"></textarea>                                            
                                    <input id="offerId" name="offerId" type="hidden" value="<%=intOffer%>"/>
                                    <input id="domainId" name="domainId" type="hidden" value="<%=domainId%>"/>
                                    <input id="languageId" name="languageId" type="hidden" value="<%=language.getId()%>"/>
                                    <input id="commentAddedMsg" name="commentAddedMsg" type="hidden" value="<%=msg%>"/>
                                    <a href="javascript:addComment();" class="tab-btn"><%=p.getProperty("public.mobcoupon.post")%></a>
                                  </form>
                                    <%if(rsComment.next()){%>
                                    <h4><%=p.getProperty("public.mobcoupon.recent")%></h4>
                                    <ul class="recent-comments">
                                      <%
                                      do{
                                      %>
                                        <li>
                                            <p>
                                                <%=rsComment.getString("comments")%>
                                            </p>
                                            <%
                                            Date today = new Date();
                                            String commentedTime = rsComment.getString("add_date").substring(0,rsComment.getString("add_date").indexOf("."));
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
                                            if(diffInDays >0 ){
                                            %>
                                            <p class="comment-author"><%=diffInDays%> <%=p.getProperty("public.mobcoupon.days")%> <%=rsComment.getString("name")%></p>
                                            <%}else{%>
                                            <p class="comment-author"><%=diffHours%> <%=p.getProperty("public.mobcoupon.hours")%> <%=rsComment.getString("name")%></p>
                                            <%}%>
                                        </li>  
                                        <%}while(rsComment.next());%>
                                    </ul>
                                        <%
                                              }%>
                                </div>
                                <div class="tab-cnt-section terms-tab" id="tab-2">
                                  <%=terms%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </div>
            <%@include file="common/bottomMenu.jsp" %>
            </section>
        </div>
        <script>
    
    comment = '<%=p.getProperty("public.messages.comment")%>';
    nameRequired = '<%=p.getProperty("public.messages.nameRequired")%>';
    commentRequired = '<%=p.getProperty("public.messages.commentRequired")%>';
</script>
        <%@include file="common/footer.jsp" %>
    </body>
</compress:html>
</html>
<%} catch (Throwable e) {
    Logger.getLogger("mobileCoupon.jsp").log(Level.SEVERE, null, e);
  }finally{
    Cleaner.close(psUsedCoupon);
    Cleaner.close(rsOffer);
    Cleaner.close(rsComment);
    Cleaner.close(rsUsedCount);
    db.select().clean();
    Connect.close(db);    
  }
%>