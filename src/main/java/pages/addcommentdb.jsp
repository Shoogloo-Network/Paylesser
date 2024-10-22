<%-- 
    Document   : addcommentdb
    Created on : Dec 12, 2014, 2:05:21 PM
    Author     : jincy.p
--%>

<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  Db db = null;
  String userName = request.getParameter("userName") == null ? "" : request.getParameter("userName").replaceAll("\\<.*?>", "");
  String email = request.getParameter("email") == null ? "" : request.getParameter("email").replaceAll("\\<.*?>", "");
  String comment = request.getParameter("comment") == null ? "" : request.getParameter("comment").replaceAll("\\<.*?>", "");
  String offerId = request.getParameter("offerId") == null ? "" : request.getParameter("offerId").replaceAll("\\<.*?>", "");
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String languageId = request.getParameter("languageId") == null ? "" : request.getParameter("languageId").replaceAll("\\<.*?>", "");
  String pageType = request.getParameter("pageType") == null ? "" : request.getParameter("pageType").replaceAll("\\<.*?>", "");
  String returnUrl = request.getParameter("returnUrl") == null ? "" : request.getParameter("returnUrl").replaceAll("\\<.*?>", "");
  String domainName = (String) session.getAttribute("domainName");
  String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
  Integer userId = null;
  try {
    LoginInfo lInfo = new LoginInfo();
    if (session.getAttribute("userObj") != null) {
      LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
      userId = linfo.getPublicUserId();
    }
    db = Connect.newDb();
    db.execute().insert("INSERT INTO vc_comments(offer_id,public_user_id,domain_id,name,comments,ip,user_agent,add_date,publish,email, id)"
            + " VALUES(?,?,?,?,?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(offerId), userId, Integer.parseInt(domainId), userName, comment,
              request.getRemoteAddr(), request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime()), 0, email}, "vc_comments_seq");
  } catch (Exception e) {
    Logger.getLogger("addcommentsdb.jsp").log(Level.SEVERE, null, e);
  } finally {
    db.select().clean();
    Connect.close(db);
  }
%>
<!DOCTYPE html>
<html>
  <head>
<%if("26".equals(domainId) || "27".equals(domainId)){%>
	<meta name="robots" content="noindex">
<%}%>		
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
    <title itemprop="name">JSP Page</title>
    <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>	
    <script src="<%=SystemConstant.PATH%>js/main.js"></script>
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
  <body onload="javascript:commentAdded();">
    <%
      if (SystemConstant.COUPON_DATILS.equals(pageType)) {
    %>
    <form name="frmRedirect" id="frmRedirect" method="post" action="<%=pageUrl+returnUrl%>?vc=<%=offerId%>">
      <input type="hidden" name="msg" id="msg" value="ok"/>
    </form>
    <%
    } else {
    %>  
    <form name="frmRedirect" id="frmRedirect" method="post" action="mobile-coupon?off=<%=offerId%>&lan=<%=languageId%>">
      <input type="hidden" name="msg" id="msg" value="ok"/>
    </form>    
    <%
      }
    %>         
  </body>
</compress:html>
</html>
