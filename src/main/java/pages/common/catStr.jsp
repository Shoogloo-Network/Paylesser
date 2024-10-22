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
        String type = request.getParameter("t") == null ? "" : request.getParameter("t").replaceAll("\\<.*?>", "");       
        String rId = request.getParameter("rId") == null ? "" : request.getParameter("rId").replaceAll("\\<.*?>", "");       
        String fPrint = (session.getAttribute("fPrint")!=null)?((String) session.getAttribute("fPrint")):"";
        if(!"".equals(type) && !"".equals(rId) && !"".equals(fPrint)){           
            db = Connect.newDb();
            String query = "select getcurrentdatetimebydomainid("+domainId+") as s";
             ResultSet rs = db.select().resultSet(query, null);
             Timestamp s = null;
             if(rs.next()){
                s =  rs.getTimestamp("s");
             }
            if("1".equals(type)){
                 db.execute().insert("INSERT INTO vc_store_cat_log (domain_id, store_id, fprint,used_date, id) VALUES (?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(domainId), Integer.parseInt(rId), fPrint, s}, "vc_store_cat_log_seq");   
            }else if("2".equals(type)){
                db.execute().insert("INSERT INTO vc_store_cat_log (domain_id, cat_id, fprint,used_date, id) VALUES (?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(domainId), Integer.parseInt(rId), fPrint, s}, "vc_store_cat_log_seq");   
            }
        }
   } catch (Throwable e) {
        Logger.getLogger("track.jsp").log(Level.SEVERE, null, e);
    } finally {
        Connect.close(db);
    } %>
%>    
