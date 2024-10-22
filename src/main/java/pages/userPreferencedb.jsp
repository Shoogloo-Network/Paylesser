<%-- 
    Document   : ajaxRemoveStore
    Created on : Dec 22, 2014, 7:03:12 PM
    Author     : paulson.j
--%>

<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.SubscribedStore"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String updatesel = request.getParameter("updatesel") == null ? "" : request.getParameter("updatesel").replaceAll("\\<.*?>", "");
  String deal = request.getParameter("deal") == null ? "" : request.getParameter("deal").replaceAll("\\<.*?>", "");
  String voucher = request.getParameter("voucher") == null ? "" : request.getParameter("voucher").replaceAll("\\<.*?>", "");
  String delstoreid = request.getParameter("delstoreid") == null ? "" : request.getParameter("delstoreid").replaceAll("\\<.*?>", "");
  String delcatid = request.getParameter("delcatid") == null ? "" : request.getParameter("delcatid").replaceAll("\\<.*?>", "");
  String pubUserId = request.getParameter("pubUserId") == null ? "" : request.getParameter("pubUserId").replaceAll("\\<.*?>", "");
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String langId = request.getParameter("langId") == null ? "" : request.getParameter("langId").replaceAll("\\<.*?>", "");
  Db db = Connect.newDb();
  ResultSet rsFav = null;
  ResultSet rsFavStore = null;
  ResultSet rsSubscriptionId = null;
  ResultSet rsSubscribedStoreList = null;
  ResultSet rsGenSub = null;
  ResultSet rsEmailExist = null;
  try {
    if (updatesel.equals("1")) {//daily subscription
      db.execute().update("UPDATE nl_subscription SET subscription_status = 1, newsletter_type = 1 WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ",
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
    } else if (updatesel.equals("2")) {//weekly subscription
      db.execute().update("UPDATE nl_subscription SET subscription_status = 1, newsletter_type = 0 WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ",
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
    } else if (updatesel.equals("3")) {//no subscription
      db.execute().update("UPDATE nl_subscription SET subscription_status = 0 WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ",
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
    }
    if (deal.equals("1")) {
      int subId = 0;
      rsSubscriptionId = db.select().resultSet("SELECT id FROM nl_subscription WHERE domain_id = ? AND language_id = ? AND public_user_id = ? ",
              new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), Integer.parseInt(pubUserId)});
      if (rsSubscriptionId.next()) {
        subId = rsSubscriptionId.getInt("id");
      }
      rsFavStore = db.select().resultSet("SELECT vfs.store_id, vsl.name FROM vc_favourite_store vfs, vc_store vs, vc_store_lang vsl WHERE vfs.public_user_id = ? "
              + "AND vfs.store_id = vsl.store_id AND vs.trash = 0 AND vs.publish = 1 AND vsl.language_id = ? AND vs.id = vfs.store_id AND vs.domain_id = ? "
              + "AND vs.id = vsl.store_id ", 
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(langId), Integer.parseInt(domainId)});
      while (rsFavStore.next()) {
        rsSubscribedStoreList = db.select().resultSet("SELECT vsl.store_id, vsl.name, vsl.seo_url FROM nl_subscription nsub, nl_subscription_details nsd ,vc_store_lang vsl, vc_store vs "
                + "WHERE nsub.id = nsd.subscription_id AND nsub.domain_id = ? AND nsub.language_id = ? "
                + "AND nsub.public_user_id = ? AND nsd.store_id notnull "
                + "AND nsd.general = 0 AND vsl.language_id = nsub.language_id AND nsd.store_id = vsl.store_id "
                + "AND vs.domain_id = nsub.domain_id "
                + "AND vs.id = vsl.store_id AND vs.trash = 0 AND vs.publish = 1 ORDER BY vsl.name ",
                new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), Integer.parseInt(pubUserId)});
        int allow = 1;
        while (rsSubscribedStoreList.next()) {
          if (rsSubscribedStoreList.getInt("store_id") == rsFavStore.getInt("store_id")) {
            allow = 0;
            break;
          }
        }
        if (allow == 1) {
          db.execute().insert("INSERT INTO nl_subscription_details (subscription_id,store_id, general,subscription_date, favourite_store_subscription, id) "
                  + "VALUES(?,?,?,?,?,?)", new Object[]{subId, rsFavStore.getInt("store_id"), 0, new java.sql.Timestamp(new java.util.Date().getTime()), 1}, "nl_subscription_details_seq");
        }
      }
      db.execute().update("UPDATE nl_subscription SET favorite_store_check = 1 WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ",
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
    } else {
      db.execute().delete("DELETE FROM nl_subscription_details WHERE favourite_store_subscription = 1 AND subscription_id = (SELECT id FROM nl_subscription WHERE domain_id = ? AND language_id = ? AND public_user_id = ? )",
              new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), Integer.parseInt(pubUserId)});
      db.execute().update("UPDATE nl_subscription SET favorite_store_check = 0 WHERE public_user_id = ? AND domain_id = ? AND language_id = ? ",
              new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
    }
    if (voucher.equals("1")) {
      long lastInsertedId = 0;
      String qryGenSub = "SELECT nsd.general FROM nl_subscription_details nsd, nl_subscription nsub "
              + "WHERE nsd.subscription_id = nsub.id AND nsub.domain_id = ? AND nsub.language_id = ? "
              + "AND nsub.public_user_id = ? AND nsd.general = 1";
      rsGenSub = db.select().resultSet(qryGenSub, new Object[]{Integer.parseInt(domainId), Integer.parseInt(langId), Integer.parseInt(pubUserId)});
      if (!rsGenSub.next()) {
        rsEmailExist = db.select().resultSet("SELECT id FROM nl_subscription WHERE public_user_id = ? AND domain_id = ? AND language_id = ?",
                new Object[]{Integer.parseInt(pubUserId), Integer.parseInt(domainId), Integer.parseInt(langId)});
        if (rsEmailExist.next()) {
          lastInsertedId = rsEmailExist.getInt("id");
        }
        db.execute().insert("INSERT INTO nl_subscription_details (subscription_id, general,subscription_date, id) "
                + "VALUES(?,?,?,?)", new Object[]{lastInsertedId, 1, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
      }
    } else {
      db.execute().delete("DELETE FROM nl_subscription_details WHERE general = 1 AND subscription_id = ( SELECT id FROM nl_subscription "
              + " WHERE public_user_id = ? )", new Object[]{Integer.parseInt(pubUserId)});
    }
    //delete store
    delstoreid = delstoreid.replaceFirst(",", "");
    List<String> delstoreidList = Arrays.asList(delstoreid.split(","));
    int storeId;
    for (String storeid : delstoreidList) {
      if (storeid.equals("")) {
        storeId = 0;
      } else {
        storeId = Integer.parseInt(storeid);
      }
      db.execute().delete("DELETE FROM nl_subscription_details WHERE store_id = ? AND subscription_id = ( SELECT id FROM nl_subscription "
              + " WHERE public_user_id = ? )", new Object[]{storeId, Integer.parseInt(pubUserId)});
    }
    //delete category
    delcatid = delcatid.replaceFirst(",", "");
    List<String> delcatidList = Arrays.asList(delcatid.split(","));
    int catId;
    for (String catid : delcatidList) {
      if (catid.equals("")) {
        catId = 0;
      } else {
        catId = Integer.parseInt(catid);
      }
      db.execute().delete("DELETE FROM nl_subscription_details WHERE category_id = ? AND subscription_id = ( SELECT id FROM nl_subscription "
              + " WHERE public_user_id = ? )", new Object[]{catId, Integer.parseInt(pubUserId)});
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    Cleaner.close(rsFavStore);
    Cleaner.close(rsGenSub);
    Cleaner.close(rsEmailExist);
    Cleaner.close(rsFav);
    Cleaner.close(rsSubscriptionId);
    Cleaner.close(rsSubscribedStoreList);
    db.select().clean();
    Connect.close(db);
  }
%>
