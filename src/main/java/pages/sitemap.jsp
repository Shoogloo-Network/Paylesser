<%-- 
    Document   : sitemap
    Created on : May 3, 2016, 3:12:27 PM
    Author     : Ishahaq Khan
--%>

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
  List<Domains> domains = home.getDomains(home.getDomainId(domainName));
  Domains domain = home.getDomain(domains, home.getDomainId(domainName)); // active domain
%>
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc><%=domainUrl.substring(0, domainUrl.length()-1)%></loc>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
    </url> 
         
  <%Db db = null;
  ResultSet rs = null;
  try {
    String query = "";
    db = Connect.newDb();
    query = "SELECT * FROM vc_sitemap_view WHERE domain_id = ? AND publish=1 AND archieved=0 AND generate=1";
    rs = db.select().resultSet(query, new Object[]{domainId});
    while(rs.next()){
            String storePriority = rs.getString("store_priority");
            String seo = rs.getString("seo");
            String ppc = rs.getString("ppc");
            String pageType = rs.getString("page_type");
            String seoUrl = rs.getString("seo_url");
            Date modified = rs.getDate("last_modified");
            String frequency = rs.getString("frequency");
            Double priority = rs.getDouble("priority");
            if(!seoUrl.contains("&") && !"6".equals(pageType)){
            %>   

            <url>
                <loc><%=domainUrl+ seoUrl%></loc>
                <%if((frequency!=null) && "3".equals(pageType) && ("1".equals(seo) || "1".equals(ppc) || Integer.parseInt(storePriority)<20)){%>
                <changefreq><%= frequency %></changefreq>
                <% } else if(frequency!=null && "3".equals(pageType)) { %>
                <changefreq>weekly</changefreq>
                <% } else { %>
                <changefreq><%= frequency %></changefreq>
                <% } if((priority!=null) && "3".equals(pageType) && ("1".equals(seo) || "1".equals(ppc) || Integer.parseInt(storePriority)<20)){%>
                <priority><%= priority %></priority>
                <% } else if(frequency!=null && "3".equals(pageType)) { %>
                <priority>0.7</priority>
                <% } else { %>
                <priority><%= priority %></priority>
                <% } %>
            </url>
        
            <%}
 }%>  
  </urlset>
    
    <%
} catch (Throwable e) {
    Logger.getLogger("sitemap.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    db.select().clean();
    db.close();
  }

%>


