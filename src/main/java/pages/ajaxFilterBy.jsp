<%-- 
    Document   : ajaxFilterBy
    Created on : Nov 10, 2014, 12:01:56 PM
    Author     : sanith.e
--%>


<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>
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
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
  StringBuffer strBuffer = new StringBuffer();
  Map<String, String> mapDupStore = new HashMap<String, String>();
  String type = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String languageId = request.getParameter("languageId") == null ? "" : request.getParameter("languageId").replaceAll("\\<.*?>", "");
  String categoryId = request.getParameter("categoryId") == null ? "" : request.getParameter("categoryId").replaceAll("\\<.*?>", "");
  String subCategoryId = request.getParameter("subCategoryId") == null ? "" : request.getParameter("subCategoryId").replaceAll("\\<.*?>", "");
  String subCatFilter = request.getParameter("subCatFilter") == null ? "" : request.getParameter("subCatFilter").replaceAll("\\<.*?>", "");
  String cord = request.getParameter("cord") == null ? "" : request.getParameter("cord").replaceAll("\\<.*?>", "");
  String tab = request.getParameter("tab") == null ? "" : request.getParameter("tab").replaceAll("\\<.*?>", "");
  String pageUrl = request.getParameter("pageUrl") == null ? "" : request.getParameter("pageUrl").replaceAll("\\<.*?>", "");
  String idInSession = "";
  String src = "";
  String href = "";
  String orderBy = "";
  String domainName = (String)session.getAttribute("domainName");
  String cdnPath = "";
  if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
  VcHome home = VcHome.instance();
  Properties p = home.getLabels(languageId);
  HomeConfig homeConfig = home.getConfig(domainId);
  if ("1".equals(type) || "4".equals(type)) {
    orderBy = "TOF.used_count DESC";
  } else if ("2".equals(type)) {
    orderBy = "TOF.offer_like DESC";
  } else if ("3".equals(type)) {
    orderBy = "TOF.start_date DESC";
  } else if ("5".equals(type)) {
    orderBy = "TOF.offer_type ASC";
  } else if ("6".equals(type)) {
    orderBy = "TOF.offer_type DESC";
  } else if ("7".equals(type)) {
    orderBy = "TOF.used_count DESC";
  }
  String filterCorD = "";
  String filterSubCat = "";
  String filterSubCatFrom = "";
  if ("1".equals(cord)) {
    filterCorD = " AND TOF.offer_type = 1 ";
  } else if ("2".equals(cord)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 5 ";
  } else if ("4".equals(cord)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 4 ";
  } else if ("5".equals(cord)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 6 ";
  } else {
    filterCorD = "";
  }
  if (!"0".equals(subCatFilter) && !"0".equals(subCategoryId)) {
    filterSubCat = " AND TBSC.subcategory_id = " + subCategoryId + " AND TBSC.offer_id = TOF.id ";
    filterSubCatFrom = ",bg_offer_subcategory TBSC ";
  }

  int rowCount = 0;
  String voucherClass = "";
  String voucherDesc = "";
  try {
    String query = "";
    db = Connect.newDb();
    query = "SELECT TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOB.category_id,TOF.coupon_code,TOF.offer_url,"
            + "TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type,TST.image_small,TST.image_big,TST.store_url,"
            + "TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TSEO.seo_url "
            + "FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_category TOB,vc_store_lang TSL,vc_domain_seo_config TSEO "
            + filterSubCatFrom
            + "WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date "
            + "AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TSEO.archieved = 0 "
            + "AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id "
            + "AND TOFL.language_id = TSL.language_id AND TST.domain_id = " + domainId + " "
            + "AND TOFL.language_id = " + languageId + " AND TOB.category_id = " + categoryId + " "
            + filterCorD
            + filterSubCat
            + "ORDER BY " + orderBy + "";
    rs = db.select().resultSet(query, null);
    List<VoucherDeals> mobileOfferList = new ArrayList<VoucherDeals>();
    List<VoucherDeals> deskOfferList = new ArrayList<VoucherDeals>();
    while (rs.next()) {
        VoucherDeals vdl = new VoucherDeals();
          vdl.setId(rs.getString("id"));
          vdl.setDomainId(rs.getString("domain_id"));
          vdl.setStoreId(rs.getString("store_id"));
          vdl.setStoreId(rs.getString("category_id"));
          vdl.setStoreId(rs.getString("coupon_code"));
          vdl.setImageSmall(rs.getString("image_small"));
          vdl.setLanguageId(rs.getString("language_id"));
          vdl.setOfferLike(rs.getString("offer_like"));
          vdl.setOfferType(rs.getString("offer_type"));
          vdl.setStoreId(rs.getString("store_id"));
          vdl.setOfferHeading(rs.getString("offer_heading"));
          vdl.setStoreName(rs.getString("name"));
          vdl.setStoreSeoUrl(rs.getString("seo_url"));
          vdl.setOfferImage(rs.getString("image"));
          vdl.setOfferDesc(rs.getString("offer_description"));
          vdl.setEndDate(sdf.format(rs.getDate("end_date")));
        if("1".equals(rs.getString("view_type"))){            
            mobileOfferList.add(vdl);
            vdl = null;
        } else if("0".equals(rs.getString("view_type"))){
            deskOfferList.add(vdl);
            vdl = null;
        }       
    }
    if(deskOfferList != null){
        strBuffer.append("<div class=\"col-6\">");
        strBuffer.append("<ul class=\"offer-list desk-offer-content\">");
        for(VoucherDeals vd : deskOfferList) {
          if (rowCount < 8) {
            if (mapDupStore.get(vd.getStoreId() + vd.getLanguageId() + vd.getOfferType()) == null) {
              mapDupStore.put(vd.getStoreId() + vd.getLanguageId() + vd.getOfferType(), "value");
              if ("1".equals(vd.getOfferType())) {
                voucherClass = "get-voucher vpop";
                voucherDesc = p.getProperty("public.home.get_voucher");
              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                voucherClass = "activate-deal-1 u-deal";
                voucherDesc = p.getProperty("public.category.activate_deal");
              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) {
                voucherClass = "activate-deal-prod u-deal";
                voucherDesc = p.getProperty("public.category.activate_deal");
              }
              String image = "";
              if (vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                image = cdnPath + vd.getOfferImage();
              } else {
                image = cdnPath + vd.getImageSmall();
              }
              strBuffer.append("<li>");
              strBuffer.append("<ul class=\"offer-item clearfix\">");
              strBuffer.append("<li class=\"company-logo\"><figure><a href=" + pageUrl + vd.getStoreSeoUrl() + " ><img src=\"" + image + "\" alt=" + vd.getStoreName() + "/></a></figure></li>");
              strBuffer.append("<li class=\"offer-desc\">");
              strBuffer.append("<h2 class=\"screen\"><a class=\"couponDetails " + vd.getId() + " cursor-href\">" + vd.getOfferHeading() + "</a></h2>");
              strBuffer.append("<h2 class=\"mobile\"><a class=\"couponDetails " + vd.getId() + " cursor-href\">" + vd.getOfferHeading() + "</a></h2>");
              strBuffer.append("<p class=\"screen tagline-p\"></p>");
              strBuffer.append("<a data-of=\"" + vd.getId() + "\" data-type=\"" + tab + "\" data-lang=" + vd.getLanguageId() + " class=\"cursor-href " + voucherClass + "\" id=" + tab + "-" + vd.getId() + ">" + voucherDesc + "</a><a href=" + pageUrl + vd.getStoreSeoUrl() + ">" + p.getProperty("public.home.seeall_coupons") + " »</a>");
              strBuffer.append("<ul class=\"offer-icons clearfix\">");
              if ("1".equals(homeConfig.getVote())) {
                strBuffer.append("<li class=\"vote-up " + vd.getId() + "\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-vote-up.png\" alt=\"image\"/></a></li>");
                strBuffer.append("<li class=\"vote-down " + vd.getId() + "\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-vote-down.png\" alt=\"image\"/></a></li>");
                strBuffer.append("<li class=\"vote-count count-" + vd.getId() + "\"><div class=\"vote-" + vd.getId() + "\">Vote: " + vd.getOfferLike() + "</div></li>");
              }
              if ("1".equals(homeConfig.getFavouriteStores())) {
                //strBuffer.append("<li class=\"like\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-like.png\" alt=\"image\"/></a></li>");
                if (session.getAttribute("favStore") != null) {
                  idInSession = (String) session.getAttribute("favStore");
                }
                src = idInSession.contains("," + vd.getStoreId() + ",") ? SystemConstant.PATH + "images/icon-fav.png" : SystemConstant.PATH + "images/dis-fav.png";
                href = session.getAttribute("userObj") == null ? "javascript:logFav(1)" : "javascript:fav(1, " + vd.getStoreId() + ")";

                strBuffer.append("<li class=\"favourite\">");
                strBuffer.append("<a href=\"" + href + "\" class=\"fav-" + vd.getStoreId() + "\">");
                strBuffer.append("<img src=\"" + src + "\" alt=\"image\"/>");
                strBuffer.append("</a>");
                strBuffer.append("</li>");
              }
              if ("1".equals(homeConfig.getSavedCoupons())) {
                //strBuffer.append("<li class=\"like\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-star.png\" alt=\"image\"/></a></li>");
                if (session.getAttribute("savedOffer") != null) {
                  idInSession = (String) session.getAttribute("savedOffer");
                }
                src = idInSession.contains("," + vd.getId() + ",") ? SystemConstant.PATH + "images/icon-save.png" : SystemConstant.PATH + "images/dis-save.png";
                href = session.getAttribute("userObj") == null ? "javascript:logFav(2)" : "javascript:fav(2, " + vd.getId() + ")";

                strBuffer.append("<li class=\"rated\">");
                strBuffer.append("<a href=\"" + href + "\" class=\"save-" + vd.getId() + "\">");
                strBuffer.append("<img src=\"" + src + "\" alt=\"image\"/>");
                strBuffer.append("</a>");
                strBuffer.append("</li>");
              }
              if ("1".equals(homeConfig.getExpiryDate())) {
                strBuffer.append("<li class=\"expiry\">" + p.getProperty("public.home.ends_on") + " " + vd.getEndDate() + "</li>");
              }
              strBuffer.append("</ul>");
              strBuffer.append("</li>");
              strBuffer.append("</ul>");
              strBuffer.append("</li>");
              rowCount++;
              if (rowCount % 4 == 0) {
                strBuffer.append("</ul></div><div class=\"col-6\"><ul class=\"offer-list desk-offer-content\">");

              }
            }
          }
        }

        strBuffer.append("</ul>");
        strBuffer.append("</div>");
    }
    if(mobileOfferList != null){
        strBuffer.append("<div class=\"col-6\">");
        strBuffer.append("<ul class=\"offer-list mobile-offer-content\">");
        for(VoucherDeals vd : mobileOfferList) {
          if (rowCount < 8) {
            if (mapDupStore.get(vd.getStoreId() + vd.getLanguageId() + vd.getOfferType()) == null) {
              mapDupStore.put(vd.getStoreId() + vd.getLanguageId() + vd.getOfferType(), "value");
              if ("1".equals(vd.getOfferType())) {
                voucherClass = "get-voucher vpop";
                voucherDesc = p.getProperty("public.home.get_voucher");
              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                voucherClass = "activate-deal-1 u-deal";
                voucherDesc = p.getProperty("public.category.activate_deal");
              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) {
                voucherClass = "activate-deal-prod u-deal";
                voucherDesc = p.getProperty("public.category.activate_deal");
              }
              String image = "";
              if (vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                image = cdnPath + vd.getOfferImage();
              } else {
                image = cdnPath + vd.getImageSmall();
              }
              strBuffer.append("<li>");
              strBuffer.append("<ul class=\"offer-item clearfix\">");
              strBuffer.append("<li class=\"company-logo\"><figure><a href=" + pageUrl + vd.getStoreSeoUrl() + " ><img src=\"" + image + "\" alt=" + vd.getStoreName() + "/></a></figure></li>");
              strBuffer.append("<li class=\"offer-desc\">");
              strBuffer.append("<h2 class=\"screen\"><a class=\"couponDetails " + vd.getId() + " cursor-href\">" + vd.getOfferHeading() + "</a></h2>");
              strBuffer.append("<h2 class=\"mobile\"><a class=\"couponDetails " + vd.getId() + " cursor-href\">" + vd.getOfferHeading() + "</a></h2>");
              strBuffer.append("<p class=\"screen tagline-p\"></p>");
              strBuffer.append("<a data-of=\"" + vd.getId() + "\" data-type=\"" + tab + "\" data-lang=" + vd.getLanguageId() + " class=\"cursor-href " + voucherClass + "\" id=" + tab + "-" + vd.getId() + ">" + voucherDesc + "</a><a href=" + pageUrl + vd.getStoreSeoUrl() + ">" + p.getProperty("public.home.seeall_coupons") + " »</a>");
              strBuffer.append("<ul class=\"offer-icons clearfix\">");
              if ("1".equals(homeConfig.getVote())) {
                strBuffer.append("<li class=\"vote-up " + vd.getId() + "\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-vote-up.png\" alt=\"image\"/></a></li>");
                strBuffer.append("<li class=\"vote-down " + vd.getId() + "\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-vote-down.png\" alt=\"image\"/></a></li>");
                strBuffer.append("<li class=\"vote-count count-" + vd.getId() + "\"><div class=\"vote-" + vd.getId() + "\">Vote: " + vd.getOfferLike() + "</div></li>");
              }
              if ("1".equals(homeConfig.getFavouriteStores())) {
                //strBuffer.append("<li class=\"like\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-like.png\" alt=\"image\"/></a></li>");
                if (session.getAttribute("favStore") != null) {
                  idInSession = (String) session.getAttribute("favStore");
                }
                src = idInSession.contains("," + vd.getStoreId() + ",") ? SystemConstant.PATH + "images/icon-fav.png" : SystemConstant.PATH + "images/dis-fav.png";
                href = session.getAttribute("userObj") == null ? "javascript:logFav(1)" : "javascript:fav(1, " + vd.getStoreId() + ")";

                strBuffer.append("<li class=\"favourite\">");
                strBuffer.append("<a href=\"" + href + "\" class=\"fav-" + vd.getStoreId() + "\">");
                strBuffer.append("<img src=\"" + src + "\" alt=\"image\"/>");
                strBuffer.append("</a>");
                strBuffer.append("</li>");
              }
              if ("1".equals(homeConfig.getSavedCoupons())) {
                //strBuffer.append("<li class=\"like\"><a class=\"cursor-href\"><img src=\"" + SystemConstant.PATH + "images/icon-star.png\" alt=\"image\"/></a></li>");
                if (session.getAttribute("savedOffer") != null) {
                  idInSession = (String) session.getAttribute("savedOffer");
                }
                src = idInSession.contains("," + vd.getId() + ",") ? SystemConstant.PATH + "images/icon-save.png" : SystemConstant.PATH + "images/dis-save.png";
                href = session.getAttribute("userObj") == null ? "javascript:logFav(2)" : "javascript:fav(2, " + vd.getId() + ")";

                strBuffer.append("<li class=\"rated\">");
                strBuffer.append("<a href=\"" + href + "\" class=\"save-" + vd.getId() + "\">");
                strBuffer.append("<img src=\"" + src + "\" alt=\"image\"/>");
                strBuffer.append("</a>");
                strBuffer.append("</li>");
              }
              if ("1".equals(homeConfig.getExpiryDate())) {
                strBuffer.append("<li class=\"expiry\">" + p.getProperty("public.home.ends_on") + " " + vd.getEndDate() + "</li>");
              }
              strBuffer.append("</ul>");
              strBuffer.append("</li>");
              strBuffer.append("</ul>");
              strBuffer.append("</li>");
              rowCount++;             
            }
          }
        }

        strBuffer.append("</ul>");
        strBuffer.append("</div>");
    }

  } catch (Throwable e) {
    Logger.getLogger("ajaxFilterBy.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    db.select().clean();
    Connect.close(db);
  }
  response.setContentType("text/html");
  response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
  response.setHeader("Pragma", "no-cache"); //HTTP 1.0
  response.setDateHeader("Expires", 0); //prevents caching at the proxy server
  response.getWriter().write(strBuffer.toString());
%>