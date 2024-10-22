<%-- 
    Document   : header
    Created on : Nov 12, 2014, 5:45:02 PM
    Author     : sanith.e
--%>
<%@page import="eu.bitwalker.useragentutils.BrowserType"%>
<%@page import="eu.bitwalker.useragentutils.UserAgent"%>
<style>
    @import url('https://fonts.googleapis.com/css?family=Open+Sans:400,300,600');
</style>
<g:compress> 
<link href="<%=SystemConstant.PATH%>css/pl.css" rel="stylesheet" type="text/css" />
</g:compress>
<%if("https".equalsIgnoreCase((String)session.getAttribute("scheme"))){%>   
  <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">  
 <%}%>  
<%if("5".equals(domainId)){%>   
 <link rel="icon" href="<%=SystemConstant.PATH%>images/faviconindia.png" sizes="32x32" type="image/png"/>
 <%}else{%>
  <link rel="icon" href="<%=SystemConstant.PATH%>images/favicon.ico.png" sizes="32x32" type="image/png"/>
<%}%> 
<%if("www.stagingserver.co.in".equalsIgnoreCase((String)session.getAttribute("domainName"))){%>
	<meta name="robots" content="noindex">
<%}%>
<%
if(domain != null && domain.getCustomHeaders() != null){
 out.println(domain.getCustomHeaders());
}
int eventCount = 0;

UserAgent userAgentObj = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
Boolean isMobile = (userAgentObj.getBrowser().getBrowserType()== BrowserType.MOBILE_BROWSER);
%>
<meta name="referrer" content="always">
<meta name="viewport" content="width=device-width, initial-scale=1">
 