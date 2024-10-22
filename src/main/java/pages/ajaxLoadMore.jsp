<%-- 
    Document   : ajaxLoadMore
    Created on : Dec 18, 2014, 2:13:57 PM
    Author     : shabil.b
--%>

<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>

<%
LoginInfo lInfo = new LoginInfo();
lInfo = (LoginInfo)session.getAttribute("userObj");
StringBuffer strBuffer = new StringBuffer();
java.sql.PreparedStatement psQry = null;
java.sql.ResultSet rsQry = null;

int lang = Integer.parseInt(request.getParameter("lan") == null ? "" : request.getParameter("lan"));
String type = request.getParameter("typ") == null ? "" : request.getParameter("typ").replaceAll("\\<.*?>", "");
String offset = request.getParameter("offs") == null ? "" : request.getParameter("offs").replaceAll("\\<.*?>", "");
String qry = "";
int cnt = Integer.parseInt(offset);

Db db = Connect.newDb();
try {
    if("1".equals(type)) {
        qry = "SELECT DISTINCT VO.id, VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_offer VO, vc_offer_lang VOL, vc_store VS "
            + "WHERE VO.id = VOL.offer_id AND VO.store_id = VS.id AND VO.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 "
            + "AND VS.publish = 1 AND VS.trash = 0 AND VOL.language_id = ? ORDER BY VO.id DESC LIMIT 3 OFFSET "+offset;
        
        psQry = db.select().getPreparedStatement(qry);
        psQry.clearParameters();
        psQry.setInt(1, lInfo.getPublicUserId());
        psQry.setInt(2, lang);
        rsQry = psQry.executeQuery();
        
        while(rsQry.next()) {
            cnt++;
            strBuffer.append("<li id=\"shared-"+cnt+"\">");
                strBuffer.append("<p>"+rsQry.getString("offer_heading")+"</p>");
                strBuffer.append("<a href=\""+rsQry.getString("affiliate_url")+"\" target=\"_blank\">"+rsQry.getString("store_url")+"</a>");
            strBuffer.append("</li>");
        }
    }
    else if("2".equals(type) || "3".equals(type)) {
        qry = "SELECT DISTINCT VO.id, VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_offer_acceptance VOA, vc_offer VO, "
            + "vc_offer_lang VOL, vc_store VS WHERE VO.id = VOA.offer_id AND VO.id = VOL.offer_id AND VO.store_id = VS.id "
            + "AND VOA.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0 AND "
            + "VOL.language_id = ? AND VOA.like_dislike = ? ORDER BY VO.id DESC LIMIT 3 OFFSET "+offset;
        
        psQry = db.select().getPreparedStatement(qry);
        psQry.clearParameters();
        psQry.setInt(1, lInfo.getPublicUserId());
        psQry.setInt(2, lang);
        if("2".equals(type)) {
            psQry.setInt(3, 1);
        }
        else {
            psQry.setInt(3, 0);
        }
        rsQry = psQry.executeQuery();
        
        while(rsQry.next()) {
            cnt++;
            strBuffer.append("<li id=\""+("2".equals(type) ? "worked-" : "nworked-")+cnt+"\">");
                strBuffer.append("<p>"+rsQry.getString("offer_heading")+"</p>");
                strBuffer.append("<a href=\""+rsQry.getString("affiliate_url")+"\" target=\"_blank\">"+rsQry.getString("store_url")+"</a>");
            strBuffer.append("</li>");
        }
    }
    else if("4".equals(type)) {
        qry = "SELECT DISTINCT VO.id, VOL.offer_heading, VS.affiliate_url, VS.store_url FROM vc_comments VOA, vc_offer VO, vc_offer_lang VOL, "
            + "vc_store VS WHERE VO.id = VOA.offer_id AND VO.id = VOL.offer_id AND VO.store_id = VS.id AND VOA.public_user_id = ? AND "
            + "VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0 AND VOL.language_id = ? ORDER BY VO.id DESC LIMIT 3 OFFSET "+offset;
        
        psQry = db.select().getPreparedStatement(qry);
        psQry.clearParameters();
        psQry.setInt(1, lInfo.getPublicUserId());
        psQry.setInt(2, lang);
        rsQry = psQry.executeQuery();
        
        while(rsQry.next()) {
            cnt++;
            strBuffer.append("<li id=\"comment-"+cnt+"\">");
                strBuffer.append("<p>"+rsQry.getString("offer_heading")+"</p>");
                strBuffer.append("<a href=\""+rsQry.getString("affiliate_url")+"\" target=\"_blank\">"+rsQry.getString("store_url")+"</a>");
            strBuffer.append("</li>");
        }
    }
    
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.getWriter().write(strBuffer.toString());
}
catch(Exception e) {
    Logger.getLogger("ajaxUserProfile.jsp").log(Level.SEVERE, null, e);
}
finally {
    Cleaner.close(psQry);
    Cleaner.close(rsQry);
    db.select().clean();
    Connect.close(db);
}
%>