<%-- 
    Document   : sitemap
    Created on : May 3, 2016, 3:12:27 PM
    Author     : Ishahaq Khan
--%>

<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.io.*"%>
<%@page contentType="application/xml" pageEncoding="UTF-8" language="java"%>

<%
  String domainName = (String) session.getAttribute("domainName");
  VcHome home = VcHome.instance();
  Integer domainId = Integer.parseInt(home.getDomainId(domainName));
  String domainUrl = "https".equals(request.getHeader("X-Forwarded-Proto"))?"https://" + domainName + "/":"http://" + domainName + "/";
  %>
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">   
  <%Db db = null;
  ResultSet rs = null;
  try {
    String query = "";
    db = Connect.newDb();
    query = "SELECT * FROM vc_feed_meta WHERE domain_id = ? AND object_type IN (1, 2, 3)";
    rs = db.select().resultSet(query, new Object[]{domainId});
    while(rs.next()){
        String seoUrl = rs.getString("key");
        if(!seoUrl.contains("&")){
        %>  
        
        <url>
            <loc><%=domainUrl+ SystemConstant.ROOT_URL+"/"+ seoUrl%></loc>
            <changefreq>monthly</changefreq>
            <priority>0.6</priority>
        </url>
   <%}
 }%>  
  </urlset>
    
    <%
} catch (Throwable e) {
    Logger.getLogger("sitemap_feed.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    db.select().clean();
    db.close();
  }

%>


