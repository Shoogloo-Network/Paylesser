
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vc.encryption.Encryption"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.mailsender.ActivationMail"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.sql.ResultSet"%>
<%
    Db db = Connect.newDb();
    int subscription_status = 0;
    long userId = 0;
    long lastInsertedId = 0;
    long lastInsertedIdPubUser = 0;
    String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
    String pageUrl = request.getParameter("pageUrl") == null ? "" : request.getParameter("pageUrl").replaceAll("\\<.*?>", "");
    String langId = request.getParameter("langId") == null ? "" : request.getParameter("langId").replaceAll("\\<.*?>", "");
    String email = request.getParameter("email") == null ? "" : request.getParameter("email").replaceAll("\\<.*?>", "");
    email = (email!=null)?email.toLowerCase():"";
    String store = request.getParameter("storeId") == null ? "" : request.getParameter("storeId").replaceAll("\\<.*?>", "");
    String category = request.getParameter("catId") == null ? "" : request.getParameter("catId").replaceAll("\\<.*?>", "");
    session.setAttribute("sub_email", email);
    VcHome home = VcHome.instance();
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    Properties p = home.getLabels(langId);
    ResultSet rsUserId = null;
    ResultSet rsEmailExist = null;
    ResultSet rsSubscExist = null;
    String freq = "1";
    String message = "";
    int allowSub = 0;
    String respMessage = "";
    int actSub = 0;
    try {
        //checking whether email is already subscribed in general newsletter
        if (store.equals("") && category.equals("")) {
            rsSubscExist = db.select().resultSet("SELECT nsd.general FROM nl_subscription_details nsd, nl_subscription nsub  "
                    + "WHERE nsd.subscription_id = nsub.id AND nsub.domain_id = ? "
                    + "AND nsub.email = ? "
                    + "AND nsd.general = 1", new Object[]{Integer.parseInt(domainId), email});
            if (!rsSubscExist.next()) {
                allowSub = 1;
            }
        } //checking whether email is already subscribed in store newsletter
        else if (category.equals("")) {
            rsSubscExist = db.select().resultSet("SELECT nsd.store_id FROM nl_subscription_details nsd, nl_subscription nsub  "
                    + "WHERE nsd.subscription_id = nsub.id AND nsub.domain_id = ? "
                    + "AND nsub.email = ? "
                    + "AND nsd.store_id = ?", new Object[]{Integer.parseInt(domainId), email, Integer.parseInt(store)});
            if (!rsSubscExist.next()) {
                allowSub = 1;
            }
        } //checking whether email is already subscribed in category newsletter
        else if (store.equals("")) {
            rsSubscExist = db.select().resultSet("SELECT nsd.category_id FROM nl_subscription_details nsd, nl_subscription nsub  "
                    + "WHERE nsd.subscription_id = nsub.id AND nsub.domain_id = ? "
                    + "AND nsub.email = ? "
                    + "AND nsd.category_id = ?", new Object[]{Integer.parseInt(domainId), email, Integer.parseInt(category)});
            if (!rsSubscExist.next()) {
                allowSub = 1;
            }
        }        
        if (allowSub == 1) {
            //checking whether subscribed user is registered or not
            rsUserId = db.select().resultSet("SELECT id FROM vc_public_user WHERE email = ? AND domain_id = ?", new Object[]{email, Integer.parseInt(domainId)});
            if (rsUserId.next()) {
                userId = rsUserId.getInt("id");
            }           
            String ipAddress = request.getRemoteAddr();
            String userAgent = request.getHeader("user-agent");
            
            if (!email.trim().equals("")) {
                rsEmailExist = db.select().resultSet("SELECT id FROM nl_subscription WHERE email = ? AND domain_id = ?", new Object[]{email, Integer.parseInt(domainId)});
                if (rsEmailExist.next()) {
                    lastInsertedId = rsEmailExist.getInt("id");
                } else {
                    lastInsertedId = db.execute().insert("INSERT INTO nl_subscription (domain_id, language_id, public_user_id, email, subscription_status,newsletter_type,ip,user_agent, id) "
                            + "VALUES(?,?,?,?,?,?,?,?,?)",
                            new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), userId, email, subscription_status, Integer.parseInt(freq), ipAddress, userAgent}, "nl_subscription_seq");
                }
            }
            if (store.equals("") && category.equals("")) {//general
                db.execute().insert("INSERT INTO nl_subscription_details (subscription_id, general,subscription_date, id) "
                        + "VALUES(?,?,?,?)", new Object[]{lastInsertedId, 1, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
            } else if (category.equals("")) {//store
                db.execute().insert("INSERT INTO nl_subscription_details (subscription_id,store_id, general,subscription_date, id) "
                        + "VALUES(?,?,?,?,?)", new Object[]{lastInsertedId, Integer.parseInt(store), 0, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
            } else if (store.equals("")) {//category
                db.execute().insert("INSERT INTO nl_subscription_details (subscription_id,category_id, general,subscription_date, id) "
                        + "VALUES(?,?,?,?,?)", new Object[]{lastInsertedId, Integer.parseInt(category), 0, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
            }
        } else if (allowSub == 0) {
            respMessage = p.getProperty("public.home.newsletter.subscription_exist")+"#exist#";
            rsEmailExist = db.select().resultSet("SELECT id,subscription_status FROM nl_subscription WHERE email = ? AND domain_id = ?", new Object[]{email, Integer.parseInt(domainId)});
            if (rsEmailExist.next()) {
                if (rsEmailExist.getInt("subscription_status") == 0) {
                    respMessage = p.getProperty("public.home.newsletter.email_activate")+"#disabled#";
                    try {
                         String actUrl = pageUrl + "confirmSubscription?email=" + wawo.security.Base64.encodeToString(email, false) + "&domainId=" + wawo.security.Base64.encodeToString(domainId, false);
                         ActivationMail actMail = new ActivationMail();
                         actMail.sendMail(domain, langId, email, actUrl, "", pageUrl, 0, 3);
                         message = "success";
                    } catch (Exception e) {
                        Logger.getLogger("newslettersub.jsp").log(Level.SEVERE, null, e);
                        message = "fail";
                    }
                }
            }
        }
        //sending activation mail to newly subscribed user, if the user email is not in subscription email list
        if (allowSub == 1 && !"".equals(email) && !"".equals(pageUrl)) {
            rsEmailExist = db.select().resultSet("SELECT id,subscription_status FROM nl_subscription WHERE email = ? AND domain_id = ?", new Object[]{email, Integer.parseInt(domainId)});
            String actUrl = pageUrl + "confirmSubscription?email=" + wawo.security.Base64.encodeToString(email, false) + "&domainId=" + wawo.security.Base64.encodeToString(domainId, false);
            if (!rsEmailExist.next()) {
                try {
                    ActivationMail actMail = new ActivationMail();
                    actMail.sendMail(domain, langId, email, actUrl, "", pageUrl, 0, 3);
                    message = "success";
                } catch (Exception e) {
                    Logger.getLogger("newslettersub.jsp").log(Level.SEVERE, null, e);
                    message = "fail";
                }
            } else {
                //again sending activaton mail if not activated email
                if (rsEmailExist.getInt("subscription_status") == 0) {
                    try {
                        ActivationMail actMail = new ActivationMail();
                        actMail.sendMail(domain, langId, email, actUrl, "", pageUrl, 0, 3);
                        message = "success";
                    } catch (Exception e) {
                        Logger.getLogger("newslettersub.jsp").log(Level.SEVERE, null, e);
                        message = "fail";
                    }
                } else {
                    respMessage = p.getProperty("public.home.newsletter.subscription_success")+"#success#";
                }
            }
        }
        if ("success".trim().equals(message)) {
            respMessage = p.getProperty("public.home.newsletter.email_message")+"#success#";
        } else if ("fail".equals(message)) {
            respMessage = p.getProperty("public.home.newsletter.email_not_exist")+"#error#";
        }
        response.getWriter().write(respMessage);
    } catch (Throwable e) {
        Logger.getLogger("newslettersub.jsp").log(Level.SEVERE, null, e);
        response.sendRedirect("/index");
    } finally {
        Cleaner.close(rsUserId);
        Cleaner.close(rsEmailExist);
        Cleaner.close(rsSubscExist);
        db.select().clean();
        db.close();
    }
%>