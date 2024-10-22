<%-- 
    Document   : ajaxCoupon
    Created on : Dec 23, 2014, 2:39:06 PM
    Author     : jincy.p
--%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>

<%
    String type = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
    String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
    String langId = request.getParameter("langId") == null ? "" : request.getParameter("langId").replaceAll("\\<.*?>", "");
    String param = request.getParameter("param") == null ? "" : request.getParameter("param").replaceAll("\\<.*?>", "");
    String storename = request.getParameter("storename") == null ? "" : request.getParameter("storename").replace("---","&").replaceAll("\\<.*?>", "");
    String catname = request.getParameter("catname") == null ? "" : request.getParameter("catname").replace("---","&").replaceAll("\\<.*?>", "");
    int pubUserId = 0;
    LoginInfo lInfo = new LoginInfo();
    if (session.getAttribute("userObj") != null) {
        lInfo = (LoginInfo) session.getAttribute("userObj");
        pubUserId = lInfo.getPublicUserId();
    }
    String domainName = (String) session.getAttribute("domainName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    StringBuffer strBuffer = new StringBuffer();
    Db db = Connect.newDb();
    ResultSet rs = null;
    ResultSet rsCat = null;
    ResultSet rsStoreId = null;
    ResultSet rsCatId = null;
    ResultSet rsSubscriptionId = null;
    ResultSet rsCatSeoUrl = null;
    try {
        if (!"".equals(storename)) {    //after selecting auto suggested store
            int subId = 0;
            rsSubscriptionId = db.select().resultSet("SELECT id FROM nl_subscription WHERE domain_id = ? AND language_id = ? AND public_user_id = ? ",
                    new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), pubUserId});
            if (rsSubscriptionId.next()) {
                subId = rsSubscriptionId.getInt("id");
            }
            rsStoreId = db.select().resultSet("SELECT vsl.store_id, vsl.seo_url FROM vc_store vs, vc_store_lang vsl "
                    + "WHERE vs.id = vsl.store_id AND vs.domain_id = ? AND vs.publish = 1 AND vs.trash = 0 "
                    + "AND vsl.name = ? AND vsl.language_id = ?", new Object[]{Integer.parseInt(domainId), storename, Integer.parseInt(langId)});
            if (rsStoreId.next()) {
                db.execute().insert("INSERT INTO nl_subscription_details (subscription_id,store_id, general,subscription_date, favourite_store_subscription, id) "
                        + "VALUES(?,?,?,?,?,?)", new Object[]{subId, rsStoreId.getInt("store_id"), 0, new java.sql.Timestamp(new java.util.Date().getTime()), 0}, "nl_subscription_details_seq");
            }
            //strBuffer.append("<li id=\"ss_" + rsStoreId.getInt("store_id") + "\">");
            //strBuffer.append("<a href=\""+pageUrl+rsStoreId.getString("seo_url") + "\" class=\"store-name\">" + storename + "</a>");
            //strBuffer.append("<a href=\"javascript:deleteStore(" + rsStoreId.getInt("store_id") + ")\" class=\"delete-store\"></a>");
            //strBuffer.append("</li>");
        } else if (!"".equals(catname)) {   //after selecting auto suggested cat
            int subId = 0;
            rsSubscriptionId = db.select().resultSet("SELECT id FROM nl_subscription WHERE domain_id = ? AND language_id = ? AND public_user_id = ? ",
                    new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), pubUserId});
            if (rsSubscriptionId.next()) {
                subId = rsSubscriptionId.getInt("id");
            }
            rsCatId = db.select().resultSet("SELECT gc.id FROM gl_category gc, bg_category_domain bcd "
                    + "WHERE gc.name = ? AND gc.language_id = ? AND gc.publish = 1 AND bcd.category_id = gc.id "
                    + "AND bcd.domain_id = ? AND bcd.publish = 1 ", new Object[]{catname, Integer.parseInt(langId), Integer.parseInt(domainId)});
            if (rsCatId.next()) {
                rsCatSeoUrl = db.select().resultSet("SELECT seo_url FROM vc_domain_seo_config WHERE page_type = 4 AND pagetype_fk = ? "
                        + "AND domain_id = ? AND language_id = ?", new Object[]{rsCatId.getInt("id"), Integer.parseInt(domainId), Integer.parseInt(langId)});
                db.execute().insert("INSERT INTO nl_subscription_details (subscription_id,category_id, general,subscription_date, favourite_store_subscription, id) "
                        + "VALUES(?,?,?,?,?,?)", new Object[]{subId, rsCatId.getInt("id"), 0, new java.sql.Timestamp(new java.util.Date().getTime()), 0}, "nl_subscription_details_seq");
            }
            String seoUrl = "";
            if (rsCatSeoUrl.next()) {
                seoUrl = rsCatSeoUrl.getString("seo_url");
            }
            //strBuffer.append("<li id=\"ss_"+rsCatId.getInt("id")+"\">");
            //strBuffer.append("<a href=\""+pageUrl+seoUrl+"\" class=\"store-name\">"+ catname +"</a>");
            //strBuffer.append("<a href=\"javascript:deleteCategory("+rsCatId.getInt("id")+")\" class=\"delete-store\"></a>");
            //strBuffer.append("</li>");
        }
        if ("store".equals(type)) { 
            if ("storename".equals(param)) {    // auto complete search for store
                rs = db.select().resultSet("SELECT vsl.name FROM vc_store vs, vc_store_lang vsl "
                        + "WHERE vs.publish = 1 AND vs.trash = 0 AND vs.id = vsl.store_id "
                        + "AND vs.domain_id = ? AND vsl.language_id = ? AND vsl.name NOT IN "
                        + "(SELECT vsl.name FROM nl_subscription nsub, nl_subscription_details nsd ,vc_store_lang vsl, vc_store vs "
                        + "WHERE nsub.id = nsd.subscription_id AND nsub.domain_id = ? AND nsub.language_id = ? "
                        + "AND nsub.public_user_id = ? AND nsd.store_id NOTNULL "
                        + "AND nsd.general = 0 AND vsl.language_id = nsub.language_id AND nsd.store_id = vsl.store_id "
                        + "AND vs.id = vsl.store_id AND vs.trash = 0 AND vs.publish = 1 ORDER BY vsl.name )",
                        new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), Integer.parseInt(domainId), Integer.parseInt(langId), pubUserId});
                while (rs.next()) {
                    if (strBuffer.length() <= 0) {
                        strBuffer.append(rs.getString("name"));
                    } else {
                        strBuffer.append("," + rs.getString("name"));
                    }
                }
            } else if ("catname".equals(param)) {   // auto complete search for cat
                rs = db.select().resultSet("SELECT gc.name FROM gl_category gc, bg_category_domain bcd WHERE gc.language_id = ? AND gc.publish = 1 "
                        + "AND bcd.category_id = gc.id AND bcd.domain_id = ? AND bcd.publish = 1 AND gc.name NOT IN "
                        + "(SELECT DISTINCT gc.name FROM nl_subscription nsub, nl_subscription_details nsd ,gl_category gc "
                        + "WHERE nsub.id = nsd.subscription_id AND nsub.domain_id = ? AND nsub.language_id = ? "
                        + "AND nsub.public_user_id = ? AND nsd.category_id NOTNULL "
                        + "AND gc.publish = 1 "
                        + "AND nsd.general = 0 AND gc.language_id = nsub.language_id AND nsd.category_id = gc.id ORDER BY gc.name )",
                        new Object[]{Integer.parseInt(langId), Integer.parseInt(domainId), Integer.parseInt(domainId), Integer.parseInt(langId), pubUserId});
                while (rs.next()) {
                    if (strBuffer.length() <= 0) {
                        strBuffer.append(rs.getString("name"));
                    } else {
                        strBuffer.append("," + rs.getString("name"));
                    }
                }
            } else {
                rs = db.select().resultSet("SELECT store_url FROM vc_store where publish = '1' and domain_id = ? ", new Object[]{Integer.parseInt(domainId)});//and store_url like ? ,pattern
                while (rs.next()) {
                    if (strBuffer.length() <= 0) {
                        strBuffer.append(rs.getString("store_url"));
                    } else {
                        strBuffer.append("," + rs.getString("store_url"));
                    }
                }
            }
        }
        if ("cat".equals(type)) {   
            String store = request.getParameter("pattern") == null ? "" : request.getParameter("pattern").replaceAll("\\<.*?>", "");
            rs = db.select().resultSet("SELECT id FROM vc_store WHERE domain_id = ? and store_url = ?", new Object[]{Integer.parseInt(domainId), store});
            while (rs.next()) {
                rsCat = db.select().resultSet("SELECT name FROM gl_category WHERE id = (SELECT category_id FROM bg_store_category where store_id = ?)", new Object[]{rs.getInt("id")});
                while (rsCat.next()) {
                    if (strBuffer.length() <= 0) {
                        strBuffer.append(rsCat.getString("name"));
                    } else {
                        strBuffer.append("," + rsCat.getString("name"));
                    }
                }
            }
        }
        if ("storeChk".equals(type)) {
            String storeUrl = request.getParameter("storeUrl") == null ? "" : request.getParameter("storeUrl").replaceAll("\\<.*?>", "");
            rs = db.select().resultSet("SELECT id FROM vc_store WHERE domain_id = ? and store_url = ?", new Object[]{Integer.parseInt(domainId), storeUrl});
            while (rs.next()) {
                strBuffer.append("ok");
            }
        }
        response.setContentType("text/html");
        response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
        response.setHeader("Pragma", "no-cache"); //HTTP 1.0
        response.setDateHeader("Expires", 0); //prevents caching at the proxy server
        response.getWriter().write(strBuffer.toString());
    } catch (Throwable e) {
        Logger.getLogger("ajaxCoupon.jsp").log(Level.SEVERE, null, e);
    } finally {
        Cleaner.close(rs);
        Cleaner.close(rsCat);
        Cleaner.close(rsStoreId);
        Cleaner.close(rsCatId);
        Cleaner.close(rsCatSeoUrl);
        Cleaner.close(rsSubscriptionId);
        db.select().clean();
        Connect.close(db);
    }
%>
