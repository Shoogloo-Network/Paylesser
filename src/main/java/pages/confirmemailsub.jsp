
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcpublic.mailsender.ActivationMail"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.sql.ResultSet"%>
<%
    Db db = Connect.newDb();
    String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
    String email = request.getParameter("email") == null ? "" : request.getParameter("email").replaceAll("\\<.*?>", "");
    domainId = new String(wawo.security.Base64.decode(domainId));
    email = new String(wawo.security.Base64.decode(email));
    ResultSet rsEmailExist = null;
    try {
        if (!"".equals(email) && !"".equals(domainId)) {
            rsEmailExist = db.select().resultSet("SELECT subscription_status FROM nl_subscription WHERE email = ? AND domain_id = ?", new Object[]{email, Integer.parseInt(domainId)});
            if (rsEmailExist.next()) {
                if (rsEmailExist.getInt("subscription_status") == 0) {
                    db.execute().update("UPDATE nl_subscription SET subscription_status = 1 WHERE domain_id = ? AND email = ?", new Object[]{Integer.parseInt(domainId), email});
                }
            }
        }               
    } catch (Exception e) {
        Logger.getLogger("confirmemailsub.jsp").log(Level.SEVERE, null, e);
    } finally {        
        Cleaner.close(rsEmailExist);
        db.select().clean();
        db.close();
    }
%>
<html> 
  <head>	
    <script> 
      function submitIt(){ 
        document.frmSubmit.submit(); 
      } 
    </script> 
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true"> 
  <body onload="javascript:submitIt()"> 
    <form action="/newsletterthankyou" method="post" name="frmSubmit" id="frmSubmit"> 
      <input type="hidden" name="domainId" id="domainId" value="<%=domainId%>"/> 
      <input type="hidden" name="email" id="email" value="<%=email%>"/>
    </form> 
  </body>
</compress:html> 
</html>
