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
    //xmlType value will be full
    String xmlType = request.getParameter("type") == null ? "" : request.getParameter("type");
    MigrateUS migrateus = new MigrateUS();
    if ("".equals(xmlType)) {
      migrateus.migrate();
      out.println("US data migration completed");
    } else if ("full".equals(xmlType)) {
      migrateus.migrateFullData();
      out.println("Complete data migrated for US domain");
    }    
  } catch (Exception e) {
    Logger.getLogger("MigrateUS.java").log(Level.SEVERE, null, e);
  }
%>