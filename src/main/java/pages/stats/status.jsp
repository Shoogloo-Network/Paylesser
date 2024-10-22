<%-- 
    Document   : status
    Created on : Dec 15, 2016, Dec 15, 2016 3:21:07 PM
    Author     : Rakesh Bhatt
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="sdigital.pl.products.utilities.RuntimeExec"%>
<%
    boolean getdata = false;
    getdata = Boolean.valueOf(request.getParameter("getdata")==null ? "" : request.getParameter("getdata"));
    if(!getdata){
       out.println("You are not authorised, Please don't repeat this activity again");
       return;
    }
    RuntimeExec rex = new RuntimeExec();
    String status = rex.getStats();
    System.out.println("Status: " + rex.getStats());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title itemprop="name">Status</title>
    </head>
    <body>
        <h1>Server Status</h1>
        <span><pre><%=status%></pre></span>
    </body>
</html>
