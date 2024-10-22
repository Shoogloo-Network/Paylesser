<%-- 
    Document   : updateOffers
    Created on : Feb 1, 2017, Feb 1, 2017 11:53:02 AM
    Author     : Rakesh Bhatt
--%>


<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%  if (request != null) {
    String vc = request.getParameter("vc")==null ? "" : request.getParameter("vc");
    String flag = request.getParameter("flag")==null ? "" : request.getParameter("flag");
    //String reportReq = request.getParameter("key")==null ? "" : request.getParameter("report");
    //ResultSet rs = null;
    String query = "";
    Db db = Connect.newDb();
     /* if(!key.equals("zxb0198AS")){
         out.println("You are not authorised, Please don't repeat this activity again");   
         return;  
      }*/
  
    if (null != vc && !vc.isEmpty()) {
        //queryString = java.net.URLDecoder.decode(request.getQueryString());
        try {
            if (flag.equalsIgnoreCase("add"))
                query = "UPDATE vc_offer SET show_on_home=1 WHERE id="+vc+";";
            else
                query = "UPDATE vc_offer SET show_on_home=0 WHERE id="+vc+";";
                db.execute().update(query, null);
                out.println("Added on the home page");

            
        } catch (Exception e) {
            out.println("Failed to add on the home page list.");
            e.printStackTrace();
        }
    } 
}



%>

