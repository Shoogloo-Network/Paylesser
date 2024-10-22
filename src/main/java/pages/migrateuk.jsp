<%-- 
    Document   : loadData
    Created on : Dec 9, 2014, 4:46:56 PM
    Author     : sanith.e
--%>

<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcmigration.*" %>

<%
  try {
    String xmlType = request.getParameter("type") == null ? "" : request.getParameter("type");
    MigrateUK migrateuk = new MigrateUK();
    if ("".equals(xmlType)) {
      migrateuk.migrate();
      out.println("Migration completed");
    } else if ("full".equals(xmlType)) {
      migrateuk.migrateFullData();
      out.println("Migration of full data completed");
    }
    
  } catch (Exception e) {
    Logger.getLogger("MigrateUK.java").log(Level.SEVERE, null, e);
  }
%>