<%-- 
    Document   : ajaxFacebook
    Created on : Dec 18, 2014, 12:38:23 PM
    Author     : jincy.p
--%>

<%
  String url = request.getParameter("url") == null ? "" : request.getParameter("url").replaceAll("\\<.*?>", "");
  session.setAttribute("parentUrl", url);
%>