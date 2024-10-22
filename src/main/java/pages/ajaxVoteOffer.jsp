<%-- 
    Document   : ajaxVoteOffer
    Created on : Nov 17, 2014, 6:19:36 PM
    Author     : sanith.e
--%>

<%@page import="wawo.util.StringUtil"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.Category"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%
  Db db = null;
  ResultSet rs = null;
  ResultSet rsUrl = null;
  ResultSet rsCount = null;
  PreparedStatement psVote = null;
  PreparedStatement psUrl = null;
  PreparedStatement psCount = null;
  PreparedStatement psURlKey = null;
  ResultSet rsURlKey = null;
  StringBuffer strBuffer = new StringBuffer();
  String offerId = request.getParameter("offerId") == null ? "" : request.getParameter("offerId").replaceAll("\\<.*?>", "");
  Integer uId = null;

  if (session.getAttribute("userObj") != null) {
    LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
    uId = linfo.getPublicUserId();
  }

  String catId = request.getParameter("catId") == null ? "" : request.getParameter("catId").replaceAll("\\<.*?>", "");
  String favId = request.getParameter("id") == null ? "" : request.getParameter("id").replaceAll("\\<.*?>", "");
  String storeId = "";
  Integer userIdInt = null;
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String type = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
  String userAgent = request.getHeader("user-agent");
  String ipAddress = request.getHeader("X-FORWARDED-FOR");
  if ("127.0.0.1".equals(ipAddress)) {
    ipAddress = request.getHeader("X-Real-IP");
  }
  if (ipAddress == null) {
    ipAddress = request.getRemoteAddr();
  }
  VcHome home = VcHome.instance();
  VcSession vcsession = VcSession.instance();
  List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domains, domainId); // active domain
  List<Language> languages = home.getLanguages(domain.getId());
  Language language = vcsession.getLanguage(session, domain.getId(), languages);
  Properties p = home.getLabels(language.getId());
  List<VoucherDeals> offerDealList = home.getOfferByDomainId(domainId);
  List<VoucherDeals> voucherList = home.getVoucherByDomainId(domainId);
  List<VoucherDeals> dealList = home.getDealByDomainId(domainId);
  List<VoucherDeals> popOfferList = home.getPopOfferByDomainId(domainId);
  String paraMeter = "";
   
  try {
    db = Connect.newDb();
    if ("vote-up".equals(type)) {        
      String query = "SELECT offer_like FROM vc_offer WHERE id = ?";
      db.execute().insert("INSERT INTO vc_offer_acceptance(offer_id,public_user_id,domain_id,like_dislike,ip,user_agent,add_date,id) VALUES(?,?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(offerId), uId, Integer.parseInt(domainId), 1, ipAddress, userAgent, new java.sql.Timestamp(new java.util.Date().getTime())}, "vc_offer_acceptance_seq");
      db.execute().update("UPDATE vc_offer SET offer_like = (SELECT offer_like FROM vc_offer WHERE id = ?)+1 WHERE id = ?", new Object[]{Integer.parseInt(offerId), Integer.parseInt(offerId)});
      psVote = db.select().getPreparedStatement(query);
      psVote.clearParameters();
      psVote.setInt(1, Integer.parseInt(offerId));
      rs = psVote.executeQuery();
      while (rs.next()) {          
        if (offerDealList != null) {
          for (VoucherDeals vd : offerDealList) {
            if (vd.getId().equals(offerId)) {
              if ("".equals(storeId)) {
                storeId = vd.getStoreId();
              }
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        if (voucherList != null) {
          for (VoucherDeals vd : voucherList) {
            if (vd.getId().equals(offerId)) {
              if ("".equals(storeId)) {
                storeId = vd.getStoreId();
              }
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        if (dealList != null) {
          for (VoucherDeals vd : dealList) {
            if (vd.getId().equals(offerId)) {
              if ("".equals(storeId)) {
                storeId = vd.getStoreId();
              }
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        if (popOfferList != null) {
          for (VoucherDeals vd : popOfferList) {
            if (vd.getId().equals(offerId)) {
              if ("".equals(storeId)) {
                storeId = vd.getStoreId();
              }
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> vdListById = home.getAllVDById(storeId);
        if (vdListById != null) {
          for (VoucherDeals vd : vdListById) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> top20v = home.getTop20VCByDomainId(domainId);
        if (top20v != null) {
          for (VoucherDeals vd : top20v) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> top20o = home.getTop20OffersByDomainId(domainId);
        if (top20o != null) {
          for (VoucherDeals vd : top20o) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> top20d = home.getTop20DealByDomainId(domainId);
        if (top20d != null) {
          for (VoucherDeals vd : top20d) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> endingSoon = home.getEndingSoonByDomainId(domainId);
        if (endingSoon != null) {
          for (VoucherDeals vd : endingSoon) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        List<VoucherDeals> expiredSoon = home.getExpiredByDomainId(domainId);
        if (expiredSoon != null) {
          for (VoucherDeals vd : expiredSoon) {
            if (vd.getId().equals(offerId)) {
              vd.setOfferLike(rs.getString("offer_like"));
            }
          }
        }
        //if (catId != null) {
        List<Category> categoriesList = home.getCatByDomainId(domainId);
        for (Category cat : categoriesList) {
          List<VoucherDeals> catOfferDealList = home.getCatOfferByDomainId(domainId, cat.getId());
          if (catOfferDealList != null) {
            for (VoucherDeals vd : catOfferDealList) {
              if (vd.getId().equals(offerId)) {
                vd.setOfferLike(rs.getString("offer_like"));
              }
            }
          }
        }
        //}
        strBuffer.append( rs.getInt("offer_like")+"" );
        //strBuffer.append("<div class=\"vote-" + offerId + "\">" + p.getProperty("public.home.vote") + ": " + rs.getInt("offer_like") + " </div>");
       
      }
    } else if ("used-coupon".equals(type)) {
      String sessId = session.getId();
      long lastId = db.execute().insert("INSERT INTO vc_used_coupon (offer_id, public_user_id, domain_id, ip, user_agent, used_date, session_id, id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(offerId), uId, Integer.parseInt(domainId), request.getRemoteAddr(), request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime()), sessId}, "vc_used_coupon_seq");

     // String query = "SELECT TUC.offer_id AS o_id,COUNT(*) AS used_cnt,TVO.offer_like,TS.id FROM vc_used_coupon TUC,vc_offer TVO,vc_store TS WHERE TUC.used_date >= current_date AND TUC.offer_id = ? AND TUC.offer_id = TVO.id AND TS.id = TVO.store_id GROUP BY TUC.offer_id,TVO.offer_like,TS.id";
	 String query = "SELECT TVO.id AS o_id,TVO.used_count AS used_cnt,TVO.offer_like,TS.id FROM vc_offer TVO,vc_store TS WHERE TVO.id = ? AND TS.id = TVO.store_id";
      psVote = db.select().getPreparedStatement(query);
      psVote.clearParameters();
      psVote.setInt(1, Integer.parseInt(offerId));
      rs = psVote.executeQuery();
      while (rs.next()) {
        List<VoucherDeals> vdListById = home.getAllVDById(rs.getString("id"));
        if (vdListById != null) {
          for (VoucherDeals vd : vdListById) {
            if (vd.getId().equals(rs.getString("o_id"))) {
              vd.setOfferLike(rs.getString("offer_like"));
              vd.setUsedCountToday(rs.getString("used_cnt"));
            }
          }
        }
      }
      query = "SELECT offer_url FROM vc_offer WHERE id = ?";
      psUrl = db.select().getPreparedStatement(query);
      psUrl.clearParameters();
      psUrl.setInt(1, Integer.parseInt(offerId));
      rsUrl = psUrl.executeQuery();
      if (rsUrl.next()) {
        String url = rsUrl.getString("offer_url");
        String replace = "";
        paraMeter = "";
        String Q1[];
        boolean resetURL = false;
        String queryAff = "SELECT aff_url,key FROM vc_aff_key";
        psURlKey = db.select().getPreparedStatement(queryAff);
        rsURlKey = psURlKey.executeQuery();
        while (rsURlKey.next()) {
          if (url.contains(rsURlKey.getString("aff_url"))) {
            paraMeter = rsURlKey.getString("key");
            resetURL = true;
            break;
          }
        }
        if (resetURL) {
          //Appending UID = last inserted used coupon id, to affiliate url to track the user
          if (url.indexOf("&" + paraMeter + "=") != -1) {
            Q1 = url.split("&" + paraMeter + "=");
            if (Q1[1].contains("&")) {
              if (Q1[1].startsWith("&")) {
                url = Q1[0] + "&" + paraMeter + "=" + String.valueOf(lastId) + Q1[1];
                strBuffer.append(url);
              } else {
                replace = Q1[1].substring(0, Q1[1].indexOf("&"));
                url = url.replace(replace, String.valueOf(lastId));
                strBuffer.append(url);
              }
            } else {
              replace = url.substring(url.indexOf("&" + paraMeter + "=") + 5, url.length());
              url = url.replace(replace, String.valueOf(lastId));
              strBuffer.append(url);
            }
          } else if (url.indexOf("?" + paraMeter + "=") != -1) {
            Q1 = url.split(paraMeter + "=");
            if (Q1[1].contains("&")) {
              replace = Q1[1].substring(0, Q1[1].indexOf("&"));
              url = url.replace(replace, String.valueOf(lastId));
              strBuffer.append(url);
            } else {
              replace = url.substring(url.indexOf("?" + paraMeter + "=") + 5, url.length());
              url = url.replace(replace, String.valueOf(lastId));
              strBuffer.append(url);
            }
          } else {
            strBuffer.append(url);
            if (url.indexOf("?") != -1) {
              strBuffer.append("&" + paraMeter + "=");
            } else {
              strBuffer.append("?" + paraMeter + "=");
            }
            strBuffer.append(String.valueOf(lastId));
          }
        } else {
          strBuffer.append(url);
        }
      }
      query = "SELECT used_count FROM vc_offer WHERE id = ?";
      psCount = db.select().getPreparedStatement(query);
      psCount.clearParameters();
      psCount.setInt(1, Integer.parseInt(offerId));
      rsCount = psCount.executeQuery();

      if (rsCount.next()) {
        db.execute().update("UPDATE vc_offer SET used_count = ? WHERE id = ?", new Object[]{rsCount.getInt(1) + 1, Integer.parseInt(offerId)});
      }
    } else if ("fav".equals(type)) {
      String favStore = "";
      
      if (session.getAttribute("favStore") != null) {
        favStore = (String) session.getAttribute("favStore");
      }

      psCount = db.select().getPreparedStatement("SELECT COUNT(id) FROM vc_favourite_store WHERE store_id = ? AND public_user_id = ?");
      psCount.clearParameters();
      psCount.setInt(1, Integer.parseInt(favId));
      psCount.setInt(2, uId);
      rs = psCount.executeQuery();

      if (rs.next()) {
        if (rs.getInt(1) > 0) {
          db.execute().delete("DELETE FROM vc_favourite_store WHERE store_id = ? AND public_user_id = ?", new Object[]{Integer.parseInt(favId), uId});
          strBuffer.append("del");
          favStore = favStore.replace("," + Integer.parseInt(favId), "");
        } else {
          db.execute().insert("INSERT INTO vc_favourite_store(store_id, public_user_id, ip, user_agent, id) VALUES (?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(favId), uId, request.getRemoteAddr(), request.getHeader("User-Agent")}, "vc_favourite_store_seq");
          strBuffer.append("add");
          favStore = favStore + Integer.parseInt(favId) + ",";
        }
      }
      session.setAttribute("favStore", favStore);
    } else if ("save".equals(type)) {
      String saveOffer = "";

      if (session.getAttribute("savedOffer") != null) {
        saveOffer = (String) session.getAttribute("savedOffer");
      }

      psCount = db.select().getPreparedStatement("SELECT COUNT(id) FROM vc_saved_coupon WHERE offer_id = ? AND public_user_id = ?");
      psCount.clearParameters();
      psCount.setInt(1, Integer.parseInt(favId));
      psCount.setInt(2, uId);
      rs = psCount.executeQuery();

      if (rs.next()) {
        if (rs.getInt(1) > 0) {
          db.execute().delete("DELETE FROM vc_saved_coupon WHERE offer_id = ? AND public_user_id = ?", new Object[]{Integer.parseInt(favId), uId});
          strBuffer.append("del");
          saveOffer = saveOffer.replace("," + Integer.parseInt(favId), "");
        } else {
          db.execute().insert("INSERT INTO vc_saved_coupon(offer_id, public_user_id, ip, user_agent, id) VALUES (?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(favId), uId, request.getRemoteAddr(), request.getHeader("User-Agent")}, "vc_saved_coupon_seq");
          strBuffer.append("add");
          saveOffer = saveOffer + Integer.parseInt(favId) + ",";
        }
      }
      session.setAttribute("savedOffer", saveOffer);
    } else {
      db.execute().insert("INSERT INTO vc_offer_acceptance(offer_id,public_user_id,domain_id,like_dislike,ip,user_agent,add_date,id) VALUES(?,?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(offerId), userIdInt, Integer.parseInt(domainId), 0, ipAddress, userAgent, new java.sql.Timestamp(new java.util.Date().getTime())}, "vc_offer_acceptance_seq");
      db.execute().update("UPDATE vc_offer SET offer_dislike = (SELECT offer_dislike FROM vc_offer WHERE id = ?)+1 WHERE id = ?", new Object[]{Integer.parseInt(offerId), Integer.parseInt(offerId)});
    }

  } catch (Throwable e) {
    Logger.getLogger("ajaxVoteOffer.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(psVote);
    Cleaner.close(psCount);
    Cleaner.close(psUrl);
    Cleaner.close(psURlKey);
    Cleaner.close(rs);
    Cleaner.close(rsUrl);
    Cleaner.close(rsCount);
    Cleaner.close(rsURlKey);
    db.select().clean();
    db.close();
  }
  response.setContentType("text/html");
  response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
  response.setHeader("Pragma", "no-cache"); //HTTP 1.0
  response.setDateHeader("Expires", 0); //prevents caching at the proxy server
  response.getWriter().write(strBuffer.toString());
%>
