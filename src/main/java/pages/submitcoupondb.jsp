<%-- 
    Document   : submitcoupondb
    Created on : Dec 29, 2014, 12:26:08 PM
    Author     : jincy.p
--%>

<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String domainName = (String)session.getAttribute("domainName");
        String pageUrl = "http://" + domainName;
        
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String storeUrl = request.getParameter("website") == null ? "" : request.getParameter("website").replaceAll("\\<.*?>", "");
  Integer offerSubType = Integer.parseInt(request.getParameter("profile-select") == null ? "" : request.getParameter("profile-select").replaceAll("\\<.*?>", ""));
  String code = request.getParameter("code") == null ? "" : request.getParameter("code").replaceAll("\\<.*?>", "");
  String desc = request.getParameter("discount") == null ? "" : request.getParameter("discount").replaceAll("\\<.*?>", "");
  DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
  Date expiry = (Date)formatter.parse(request.getParameter("expiry") == null ? "" : request.getParameter("expiry").replaceAll("\\<.*?>", ""));
  DateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
  String date = ft.format(expiry);
  String languageId = request.getParameter("languageId") == null ? "" : request.getParameter("languageId").replaceAll("\\<.*?>", "");
  Db db = null;
  ResultSet rs = null;
  ResultSet rsCat = null;
  try {
    db = Connect.newDb();
    LoginInfo lInfo = new LoginInfo();
    Integer userId = null;
    Integer storeId = null;
    Integer offerType = null;
    if(SystemConstant.COUPON_CODES.equals(offerSubType) || SystemConstant.PROMOTIONAL_CODES.equals(offerSubType) || SystemConstant.PRINTABLE_CODES.equals(offerSubType)){
      offerType = 1;
    }
    else{
      offerType = 2;
    }      
    if (session.getAttribute("userObj") != null) {
      LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
      userId = linfo.getPublicUserId();
    }
    rs = db.select().resultSet("SELECT id FROM vc_store WHERE domain_id = ? and store_url = ?", new Object[]{Integer.parseInt(domainId),storeUrl});
    if(rs.next()){
      storeId = rs.getInt("id");
    }
    db.execute().insert("INSERT INTO vc_offer(store_id,public_user_id,coupon_code,start_date,end_date,publish,domain_id,offer_type,offer_subtype,id) VALUES(?,?,?,?,?::date,0,?,?,?,?)",new Object[]{storeId,userId,code,new java.sql.Timestamp(new java.util.Date().getTime()),date,Integer.parseInt(domainId),offerType,offerSubType},"vc_offer_seq");
    rs = null;
    rs = db.select().resultSet("SELECT currval('vc_offer_seq')", null);
    if(rs.next()){
      db.execute().insert("INSERT INTO vc_offer_lang(language_id,offer_id,offer_description,id) VALUES(?,?,?,?)",new Object[]{Integer.parseInt(languageId),rs.getInt(1),desc,},"vc_offer_lang_seq");
    }
    rs = null;
    rs = db.select().resultSet("SELECT currval('vc_offer_lang_seq')", null);
    if(rs.next()){
      db.execute().update("UPDATE vc_offer_lang SET parent_id = ? where id = ?", new Object[]{rs.getInt(1),rs.getInt(1)});
    }
  } catch (Throwable e) {
    Logger.getLogger("submitcoupondb.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    Cleaner.close(rsCat);
    db.select().clean();
    Connect.close(db);
  }
  
%>
<html>
  <head>
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>		
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
    <title itemprop="name">Submit coupon</title>
    <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>
    <script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
  <body onload="javascript:redirect();">
    <form name="frmRedirect" id="frmRedirect" method="post" action="<%=pageUrl+SystemConstant.PROFILE%>">
      <input type="hidden" name="msg" id="msg" value="ok"/>
    </form>
  </body>
</compress:html>
</html>