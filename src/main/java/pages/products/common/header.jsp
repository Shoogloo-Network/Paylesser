<%-- 
    Document   : header
    Created on : Nov 12, 2014, 5:45:02 PM
    Author     : sanith.e
--%>

  
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="sdigital.pl.products.domains.ProductCategory"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<style>
    @import url('https://fonts.googleapis.com/css?family=Open+Sans:400,300,600');
</style>
<g:compress>
<link href="<%=SystemConstant.PATH%>css/pl.css" rel="stylesheet" type="text/css" />
</g:compress>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/7.1.0/css/bootstrap-slider.min.css">
<link rel="icon" href="<%=SystemConstant.PATH%>images/favicon.ico.png" sizes="32x32" type="image/png"/>
<meta name="viewport" content="width=device-width, initial-scale=1" />

   
<%if("https".equalsIgnoreCase((String)session.getAttribute("scheme"))){%>   
  <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">  
<%}%> 
<%
if(domain != null && domain.getCustomHeaders() != null){
 out.println(domain.getCustomHeaders());
}
%>