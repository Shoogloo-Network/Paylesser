<%-- 
    Document   : event
    Created on : 16 Jan, 2017, 11:55:35 AM
    Author     : IshahaqKhan
--%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.config.CommonUtils"%>
<%
    Db db = null;
    try{
        VcHome home = VcHome.instance();
        String domainName = (String) session.getAttribute("domainName");
        String domainId = home.getDomainId(domainName);
        String fPrint = request.getParameter("xkey") == null ? "" : request.getParameter("xkey").replaceAll("\\<.*?>", "");       
        String ipAddress = CommonUtils.getClientIP(request);
        String userAgent = request.getHeader("user-agent");
        db = Connect.newDb();
        Integer uId = null; 
        if (session.getAttribute("userObj") != null) {
            LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
            uId = linfo.getPublicUserId();
        }
        
        if(session.getAttribute("fPrint")==null && !"".equals(fPrint) ){
             session.setAttribute("fPrint", fPrint);
             String query = "select getcurrentdatetimebydomainid("+domainId+") as s";
             ResultSet rs = db.select().resultSet(query, null);
             Timestamp s = null;
             if(rs.next()){
                s =  rs.getTimestamp("s");
             }
             db.execute().insert("INSERT INTO vc_user_fingerprint (session_id, public_user_id, domain_id, ip, user_agent,fprint, used_date, id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", new Object[]{session.getId(), uId, Integer.parseInt(domainId), ipAddress, userAgent, fPrint, s}, "vc_user_fingerprint_seq");   
        }
       
   } catch (Throwable e) {
        Logger.getLogger("event.jsp").log(Level.SEVERE, null, e);
    } finally {
        Connect.close(db);
    } %>
%>    
