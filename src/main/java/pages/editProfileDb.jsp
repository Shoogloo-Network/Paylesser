<%-- 
    Document   : editProfileDb
    Created on : Dec 23, 2014, 3:41:48 PM
    Author     : shabil.b
--%>

<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vc.encryption.Encryption"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
LoginInfo lInfo = new LoginInfo();
lInfo = (LoginInfo)session.getAttribute("userObj");

String name = request.getParameter("usr-name") == null ? "" : request.getParameter("usr-name").replaceAll("\\<.*?>", "");
String password = request.getParameter("usr-pwd") == null ? "" : request.getParameter("usr-pwd").replaceAll("\\<.*?>", "");
String hidPassword = request.getParameter("hid-pwd") == null ? "" : request.getParameter("hid-pwd").replaceAll("\\<.*?>", "");
String gender = request.getParameter("gender") == null ? "" : request.getParameter("gender").replaceAll("\\<.*?>", "");
String bday = request.getParameter("usr-bday") == null ? "" : request.getParameter("usr-bday").replaceAll("\\<.*?>", "");
String address = request.getParameter("usr-addr") == null ? "" : request.getParameter("usr-addr").replaceAll("\\<.*?>", "");
String city = request.getParameter("userCity") == null ? "" : request.getParameter("userCity").replaceAll("\\<.*?>", "");
String redirect = request.getParameter("red-url") == null ? "" : request.getParameter("red-url").replaceAll("\\<.*?>", "");

SimpleDateFormat dbformat = new SimpleDateFormat("yyyy-mm-dd");
Integer gInt;
Date dob;
if(null!=bday && !"".equals(bday)) {
   try{
       dob = new Date(dbformat.parse(bday).getTime());
   }catch(Exception e){
       dob = null;
   }        
}else{
   dob = null; 
}

if(!"null".equals(gender)){
    gInt = Integer.parseInt(gender);
}else{
    gInt = null;
}

                                
if(!hidPassword.equals(password)) {
    password = Encryption.md5(password);
}

Db db =  Connect.newDb();
try { 
  db.execute().update("UPDATE vc_public_user SET name = ?, password = ?, gender = ?, dob = ?, address = ?, city = ? WHERE id = ?", new Object[]{name, password, gInt, dob, address, city, lInfo.getPublicUserId()});
  lInfo.setPublicUserName(name);
}
catch(Exception e) {
    Logger.getLogger("editProfileDb.jsp").log(Level.SEVERE, null, e);
}
finally {
    db.select().clean();
    Connect.close(db);
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>
        <title itemprop="name">Paylesser | Profile</title>
        <script type="text/javascript">
            var redirect = function() {
                $('#frm-red').submit();
            }
        </script>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body onload="redirect();">
        <form id="frm-red" action="<%=redirect%>edit-profile" method="post">
            <input name="log-status" type="hidden" value="ok"/>
        </form>
    </body>
</compress:html>
</html>