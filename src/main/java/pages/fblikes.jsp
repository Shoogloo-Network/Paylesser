<%-- 
    Document   : fblikes
    Created on : Sep 12, 2016, 1:04:59 PM
    Author     : Shubhra Sinha
--%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.io.IOException"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.select.Elements"%>
<%
    String likes = "";
    try {
        String url = request.getParameter("url") == null ? "" : request.getParameter("url").replaceAll("\\<.*?>", "");
        String fb_url = "https://www.facebook.com/v2.5/plugins/like.php?layout=button_count&href="+url;
        Document doc;
        doc = Jsoup.connect(fb_url).userAgent("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, "
                + "like Gecko) Chrome/51.0.2704.103 Safari/537.36")
                .header("Accept-Language", "en-US")
                .header("X-Forwarded-For","52.32.12.144")
                .timeout(5000).get();
        doc.outputSettings().charset(StandardCharsets.US_ASCII);
        Elements title = doc.getElementsByTag("span");
        for (Element link : title) {
            if (link.toString().contains("<span class=\"_5n6h _2pih\" id=\"u_0_2\">")) {
                likes = link.toString().substring(link.toString().indexOf(">") + 1, link.toString().indexOf("</span>"));
            }
        }
        likes=doc.text().replace("Facebook Like","");
    } catch (Exception e) {
        Logger.getLogger("fblikes.jsp").log(Level.SEVERE, e.getMessage(), e);
    }
    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%= likes %>