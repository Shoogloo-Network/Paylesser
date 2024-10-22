<%-- 
    Document   : fblogin
    Created on : Dec 17, 2014, 7:45:04 PM
    Author     : jincy.p
--%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.mailsender.ActivationMail"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%
  String fId = request.getParameter("fId") == null ? "" : request.getParameter("fId").replaceAll("\\<.*?>", "");
  String fName = request.getParameter("fName") == null ? "" : request.getParameter("fName").replaceAll("\\<.*?>", "");
  String fEmail = request.getParameter("fEmail") == null ? "" : request.getParameter("fEmail").replaceAll("\\<.*?>", "");
  String fGender = request.getParameter("fGender") == null ? "" : request.getParameter("fGender").replaceAll("\\<.*?>", "");
  String requestUrl = request.getRequestURL().toString();
  java.util.Date lastlogin = null;
  String domainName = "";
  String store = ",";
  String offer = ",";
  int gender = fGender.equals("male") ? 1 : 0;
  int id = 0;
  long lastInsertedId = 0;
  Integer languageId;
  Db db = Connect.newDb();
  ResultSet rsFbId = null;
  ResultSet rsLastLog = null;
  ResultSet rs = null;
  ResultSet rsStore = null;
  ResultSet rsOffer = null;
  ResultSet rsEmail = null;
  try {
    if (requestUrl.indexOf("http://") > -1) {
      String[] str1 = requestUrl.split("http://");
      if (str1[1].indexOf("/", 1) > -1) {
        domainName = str1[1].substring(0, str1[1].indexOf("/", 1));
      } else {
        domainName = str1[1];
      }
    }
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    languageId = Integer.parseInt(language.getId());
    domainName = (String) session.getAttribute("domainName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    java.sql.Timestamp today = new java.sql.Timestamp(new java.util.Date().getTime());
    rsFbId = db.select().resultSet("SELECT id,name,lastlogin FROM vc_public_user WHERE facebook_id=?", new Object[]{Double.parseDouble(fId)});
    if (rsFbId.next()) {
      id = rsFbId.getInt("id");
      fName = rsFbId.getString("name");
      lastlogin = rsFbId.getDate("lastlogin");
      String qry = "SELECT login_at FROM VC_USER_LOG WHERE public_user_id = ? ORDER BY id DESC LIMIT 1";
      rsLastLog = db.select().resultSet(qry, new Object[]{id});
      if (rsLastLog.next()) {
        db.execute().update("UPDATE vc_public_user SET lastlogin = ?::timestamp WHERE id = ?", new Object[]{rsLastLog.getString(1), id});
      }
      rsLastLog = null;
      db.execute().insert("INSERT INTO VC_USER_LOG (login_at, public_user_id, id) VALUES (?, ?, ?)", new Object[]{new java.sql.Timestamp(new java.util.Date().getTime()), id}, "vc_user_log_seq");
      qry = "SELECT VF.store_id FROM vc_favourite_store VF, vc_store VS WHERE VF.store_id = VS.id AND VF.public_user_id = ? "
              + "AND VS.publish = 1 AND VS.trash = 0";
      rsStore = db.select().resultSet(qry, new Object[]{id});
      while (rsStore.next()) {
        store = store + rsStore.getInt(1) + ",";
      }
      qry = "SELECT VS.offer_id FROM vc_saved_coupon VS, vc_offer VO WHERE VS.offer_id = VO.id AND VS.public_user_id = ? AND VO.publish = 1 "
              + "AND VO.trash = 0 AND VO.end_date >= CURRENT_DATE";
      rsOffer = db.select().resultSet(qry, new Object[]{id});
      while (rsOffer.next()) {
        offer = offer + rsOffer.getInt(1) + ",";
      }
    } else {
      rsEmail = db.select().resultSet("SELECT id,name,lastlogin FROM vc_public_user WHERE email=?", new Object[]{fEmail});
      if (rsEmail.next()) {
        id = rsEmail.getInt("id");
        String qry = "SELECT login_at FROM VC_USER_LOG WHERE public_user_id = ? ORDER BY id DESC LIMIT 1";
        rsLastLog = db.select().resultSet(qry, new Object[]{id});
        if (rsLastLog.next()) {
          db.execute().update("UPDATE vc_public_user SET lastlogin = ?::timestamp,facebook_id = ? WHERE id = ?", new Object[]{rsLastLog.getString(1), Double.parseDouble(fId), id});
        }
        rsLastLog = null;
        db.execute().insert("INSERT INTO VC_USER_LOG (login_at, public_user_id, id) VALUES (?, ?, ?)", new Object[]{new java.sql.Timestamp(new java.util.Date().getTime()), id}, "vc_user_log_seq");
        qry = "SELECT VF.store_id FROM vc_favourite_store VF, vc_store VS WHERE VF.store_id = VS.id AND VF.public_user_id = ? "
                + "AND VS.publish = 1 AND VS.trash = 0";
        rsStore = db.select().resultSet(qry, new Object[]{id});
        while (rsStore.next()) {
          store = store + rsStore.getInt(1) + ",";
        }
        qry = "SELECT VS.offer_id FROM vc_saved_coupon VS, vc_offer VO WHERE VS.offer_id = VO.id AND VS.public_user_id = ? AND VO.publish = 1 "
                + "AND VO.trash = 0 AND VO.end_date >= CURRENT_DATE";
        rsOffer = db.select().resultSet(qry, new Object[]{id});
        while (rsOffer.next()) {
          offer = offer + rsOffer.getInt(1) + ",";
        }
      } else {
        db.execute().insert("INSERT INTO vc_public_user(domain_id,name,facebook_id,gender,email,ip,user_agent,reg_date,last_modified,id) VALUES(?,?,?,?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(domainId), fName, Double.parseDouble(fId), gender, fEmail, request.getRemoteAddr(), request.getHeader("User-Agent"), today, today}, "vc_public_user_seq");
        rs = db.select().resultSet("SELECT currval('vc_public_user_seq');", null);
        while (rs.next()) {
          id = rs.getInt(1);
        }
        db.execute().insert("INSERT INTO VC_USER_LOG (login_at, public_user_id, id) VALUES (?, ?, ?)", new Object[]{new java.sql.Timestamp(new java.util.Date().getTime()), id}, "vc_user_log_seq");
        lastInsertedId = db.execute().insert("INSERT INTO nl_subscription (domain_id, language_id, public_user_id, email, subscription_status,newsletter_type,ip,user_agent, id) VALUES(?,?,?,?,?,?,?,?,?)",
                new Object[]{Integer.parseInt(domainId), languageId, id, fEmail, 0, 1, request.getRemoteAddr(), request.getHeader("User-Agent")}, "nl_subscription_seq");
        db.execute().insert("INSERT INTO nl_subscription_details (subscription_id, general,subscription_date, id) VALUES(?,?,?,?)", new Object[]{lastInsertedId, 1, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
        ActivationMail actMail = new ActivationMail();
        actMail.sendMail(domain, languageId.toString(), fEmail, "", fName, pageUrl, 0, 1);
        session.setAttribute("parentUrl", "/profile");
      }

    }
    LoginInfo lInfo = new LoginInfo();
    lInfo.setPublicUserId(id);
    lInfo.setPublicUserName(fName);
    lInfo.setLastLogin(lastlogin);
    session.setAttribute("userObj", lInfo);
    session.setAttribute("favStore", store);
    session.setAttribute("savedOffer", offer);
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    Cleaner.close(rs);
    Cleaner.close(rsFbId);
    Cleaner.close(rsLastLog);
    Cleaner.close(rsStore);
    Cleaner.close(rsOffer);
    db.select().clean();
    Connect.close(db);
  }
%>