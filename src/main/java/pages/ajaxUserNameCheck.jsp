<%-- 
    Document   : ajaxUserNameCheck
    Created on : Nov 27, 2014, 1:29:26 PM
    Author     : jincy.p
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%
  Db db = Connect.newDb();
  ResultSet rs = null;
  StringBuffer strBuffer = new StringBuffer();
  try {
    
    String userEmail = request.getParameter("userEmail") == null ? "" : request.getParameter("userEmail").replaceAll("\\<.*?>", "");    
    userEmail = (userEmail!=null)?userEmail.toLowerCase():"";
    Integer domainId = Integer.parseInt(request.getParameter("domainId"));
    rs = db.select().resultSet("SELECT email FROM vc_public_user WHERE email=? AND domain_id=?",new Object[]{userEmail,domainId});
    if(rs.next()){
      strBuffer.append("exist");
    }else{
      strBuffer.append("notExist");
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
        Cleaner.close(rs);
        db.select().clean();
        Connect.close(db);
    }
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.getWriter().write(strBuffer.toString());
%>