<%-- 
    Document   : ajaxSearchKey
    Created on : Dec 24, 2014, 10:05:04 AM
    Author     : sanith.e
--%>

<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.SearchKey"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="java.util.List"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%
  try {
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
    List<Language> languages = home.getLanguages(domainId);
    Language language = vcsession.getLanguage(session, domainId, languages);
    List<SearchKey> searchKey = home.getSearchKey();
    StringBuffer strBuffer = new StringBuffer();
    if (searchKey != null) {
      for (SearchKey sk : searchKey) {
        if (sk.getLanguageId().equals(language.getId())) {
          if (sk.getDomainId().equals(domainId)) {
            if (strBuffer.length() <= 0) {
              strBuffer.append(sk.getName());
            } else {
              strBuffer.append("," + sk.getName() + "");
            }
          }
        }
      }
    }
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.getWriter().write(strBuffer.toString());
  } catch (Throwable e) {
    Logger.getLogger("ajaxSearchKey.jsp").log(Level.SEVERE, null, e);
  } finally {

  }
%>
