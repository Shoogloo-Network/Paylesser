<%-- 
    Document   : contactusdb
    Created on : Dec 3, 2014, 2:40:04 PM
    Author     : jincy.p
--%>

<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="wawo.util.StringUtil"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  Db db = null;
  try {
    db = Connect.newDb();
    String contactusUrl = "";
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    Integer userId = null;
    if (requestUrl.indexOf("http://") > -1) {
      String[] str1 = requestUrl.split("http://");
      if (str1[1].indexOf("/", 1) > -1) {
        //out.println("<br>....." + str1[1].substring(0, str1[1].indexOf("/", 1)));
        domainName = str1[1].substring(0, str1[1].indexOf("/", 1));
      } else {
        domainName = str1[1];
      }
    }
    VcHome home = VcHome.instance();
    String domainId = home.getDomainId(domainName);
    VcSession vcsession = VcSession.instance();
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
    for (SeoUrl seo : seoList) {
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.CONTACT_US.equals(seo.getPageType())) { // has to change
        contactusUrl = seo.getSeoUrl();
      }
    }
    LoginInfo lInfo = new LoginInfo();
    if (session.getAttribute("userObj") != null) {
      LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
      userId = linfo.getPublicUserId();
    }
    String userName = request.getParameter("userName") == null ? "" : request.getParameter("userName").replaceAll("\\<.*?>", "");
    String userEmail = request.getParameter("userEmail") == null ? "" : request.getParameter("userEmail").replaceAll("\\<.*?>", "");
    String feedback = request.getParameter("feedback") == null ? "" : request.getParameter("feedback").replaceAll("\\<.*?>", "");
    java.sql.Timestamp today = new java.sql.Timestamp(new java.util.Date().getTime());
    db.execute().insert("INSERT INTO vc_contactus(domain_id,public_user_id,name,email,description,ip,user_agent,contactus_date,id)"
            + " VALUES(?,?,?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(domainId), userId, userName, userEmail, feedback, request.getRemoteAddr(), request.getHeader("User-Agent"), today}, "vc_contactus_seq");
    String ok = "OK";
%>
<!DOCTYPE html>
<html>
  <head>		
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">			
    <script src="<%=SystemConstant.PATH%>js/contact.js"></script>
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
  <body onload="javascript:redirect();">
    <form name="frmRedirect" id="frmRedirect" method="post" action="<%=contactusUrl%>">
      <input type="hidden" name="msg" id="msg" value="<%=ok%>"/>
    </form>
  </body>
</compress:html>
</html>
<%
  } catch (Throwable e) {
    Logger.getLogger("contactusdb.jsp").log(Level.SEVERE, null, e);
  } finally {
    db.select().clean();
    Connect.close(db);
  }
%>