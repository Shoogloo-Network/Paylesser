<%-- 
    Document   : ajaxVote
    Created on : Nov 15, 2014, 11:42:03 AM
    Author     : sanith.e
--%>

<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="sdigital.vcpublic.home.*"%>
<%
  java.text.DecimalFormat number_format = new java.text.DecimalFormat("#.0");
  Db db = null;
  ResultSet rs = null;
  PreparedStatement psVote = null;
  StringBuffer strBuffer = new StringBuffer();
  String storeId = request.getParameter("storeId") == null ? "" : request.getParameter("storeId").replaceAll("\\<.*?>", "");
  String rate = request.getParameter("rate") == null ? "" : request.getParameter("rate").replaceAll("\\<.*?>", "");
  double totalVote = 0;
  String totalVoteFormat = "";
  String requestUrl = request.getRequestURL().toString();
  String domainName = "";
  domainName = (String)session.getAttribute("domainName");
  VcHome home = VcHome.instance();
  VcSession vcsession = VcSession.instance();
  String domainId = home.getDomainId(domainName);
  List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domains, domainId); // active domain
  List<Language> languages = home.getLanguages(domain.getId());
  Language language = vcsession.getLanguage(session, domain.getId(), languages);
  Properties p = home.getLabels(language.getId());
  List<Store> storeListById = home.getAllStoreById(storeId);
  try {
    String query = "SELECT vote,rating FROM vc_store WHERE id = ?";
    db = Connect.newDb();
    db.execute().update("UPDATE vc_store SET vote = (SELECT vote FROM vc_store WHERE id = ?)+1 WHERE id = ?", new Object[]{Integer.parseInt(storeId), Integer.parseInt(storeId)});
    db.execute().update("UPDATE vc_store SET rating = (SELECT rating FROM vc_store WHERE id = ?)+ ? WHERE id = ?", new Object[]{Integer.parseInt(storeId), Integer.parseInt(rate), Integer.parseInt(storeId)});
    psVote = db.select().getPreparedStatement(query);
    psVote.clearParameters();
    psVote.setInt(1, Integer.parseInt(storeId));
    rs = psVote.executeQuery();
    while (rs.next()) {
      totalVote = rs.getDouble("rating") / rs.getInt("vote");
      totalVoteFormat = number_format.format(totalVote);
      for (Store st : storeListById) {
        st.setVote(rs.getString("vote"));
        st.setRating(rs.getString("rating"));
      }
      //strBuffer.append("<div id=\"vote\">");
      // strBuffer.append("<ul class=\"rating ul-reset clearfix\" style=\"padding-left:228px;\">");
      // strBuffer.append("<div class=\"exemple\">");
      // strBuffer.append("<div class=\"basic\" data-average=" + totalVoteFormat + " data-id=\"1\"></div>");
      // strBuffer.append("</div>");
      // strBuffer.append("</ul>");
      strBuffer.append("<p class=\"rate-store-vote\">" + p.getProperty("public.ajaxvote.num_votes") + " - " + rs.getInt("vote") + " "+ p.getProperty("public.ajaxvote.votes") +" "+ totalVoteFormat + " / 5.0</p>");
      // strBuffer.append("</div>");
    }

  } catch (Throwable e) {
    Logger.getLogger("ajaxVote.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    Cleaner.close(psVote);
    db.select().clean();
    db.close();
  }
  response.setContentType("text/html");
  response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
  response.setHeader("Pragma", "no-cache"); //HTTP 1.0
  response.setDateHeader("Expires", 0); //prevents caching at the proxy server
  response.getWriter().write(strBuffer.toString());
%>