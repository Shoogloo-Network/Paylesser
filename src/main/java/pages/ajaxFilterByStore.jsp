<%-- 
    Document   : ajaxFilterByStore
    Created on : Nov 17, 2014, 12:06:59 PM
    Author     : sanith.e
--%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>
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
  PreparedStatement psStore = null;
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
  StringBuffer strBuffer = new StringBuffer();
  String type = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
  String domainId = request.getParameter("domainId") == null ? "" : request.getParameter("domainId").replaceAll("\\<.*?>", "");
  String languageId = request.getParameter("languageId") == null ? "" : request.getParameter("languageId").replaceAll("\\<.*?>", "");
  String storeId = request.getParameter("storeId") == null ? "" : request.getParameter("storeId").replaceAll("\\<.*?>", "");
  String cordStore = request.getParameter("cordStore") == null ? "" : request.getParameter("cordStore").replaceAll("\\<.*?>", "");
  String pageType = request.getParameter("pageType") == null ? "" : request.getParameter("pageType").replaceAll("\\<.*?>", "");
  String categoryId = request.getParameter("categoryId") == null ? "" : request.getParameter("categoryId").replaceAll("\\<.*?>", "");
  String brandId = request.getParameter("brandId") == null ? "" : request.getParameter("brandId").replaceAll("\\<.*?>", "");
  String orderBy = "";
  String idInSession = "";
  String src = "";
  String href = "";
  String imagePath = "";
  String domainName = (String)session.getAttribute("domainName");
  String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
  String cdnPath = "";
  if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
  VcHome home = VcHome.instance();
  Properties p = home.getLabels(languageId);
  HomeConfig homeConfig = home.getConfig(domainId);
  List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domains, domainId); // active domain
  List<VoucherDeals> mobileOfferList = new ArrayList<VoucherDeals>();
  List<VoucherDeals> deskOfferList = new ArrayList<VoucherDeals>();
  VcSession vcsession = VcSession.instance();
  
  List<Language> languages = home.getLanguages(domain.getId());
  Language language = vcsession.getLanguage(session, domain.getId(), languages);
  
      
   
 
  if ("1".equals(type) || "4".equals(type)) {
    orderBy = "TOF.store_id DESC,TOF.used_count DESC";
  } else if ("2".equals(type)) {
    orderBy = "TOF.offer_like DESC";
  } else if ("3".equals(type)) {
    orderBy = "TOF.store_id DESC,TOFL.modified_at DESC";
  } else if ("5".equals(type)) {
    orderBy = "TOF.offer_type ASC";
  } else if ("6".equals(type)) {
    orderBy = "TOF.offer_type DESC";
  }
  String filterCorD = "";
  if ("1".equals(cordStore)) {
    filterCorD = "AND TOF.offer_type = 1 ";
  } else if ("2".equals(cordStore)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 5 ";
  } else if ("4".equals(cordStore)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 4 ";
  } else if ("5".equals(cordStore)) {
    filterCorD = "AND TOF.offer_type = 2 AND TOF.offer_subtype = 6 ";
  } else {
    filterCorD = "";
  }
  int couponCount = 0;
  int rowCount = 0;
  String voucherClass = "";
  String voucherDesc = "";
  try {
    String query = "";
    db = Connect.newDb();
    //if ("1".equals(type) || "2".equals(type) || "3".equals(type)) {
    if (SystemConstant.STORE.equals(pageType)) {
      query = "SELECT TOF.used_count AS used_count_today,TOF.id, TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,"
              + "TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type,TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,"
              + "TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,"
              + "TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST, vc_store_lang TSL,vc_domain_seo_config TSEO "
              + "WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date "
              + "AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 "
              + "AND TST.trash = 0  AND TOFL.language_id = TSL.language_id AND TST.publish = 1 "
              + "AND TST.id= ? AND TOFL.language_id = ?  AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.archieved = 0 AND TSEO.language_id = TSL.language_id "
              + filterCorD
              + "ORDER BY " + orderBy + "";
      psStore = db.select().getPreparedStatement(query);
      psStore.clearParameters();
      psStore.setInt(1, Integer.parseInt(storeId));
      psStore.setInt(2, Integer.parseInt(languageId));
      rs = psStore.executeQuery();
    } else if (SystemConstant.STORE_CATEGORY.equals(pageType)) {
      query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.view_type,TOF.exclusive_coupon, TOF.store_id,TST.domain_id,TOFL.language_id,TOB.category_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_category TOB,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TST.id= ? AND TOFL.language_id = ? AND TOB.category_id = ? AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.archieved = 0 AND TSEO.language_id = TSL.language_id " + filterCorD + " ORDER BY " + orderBy + "";
      psStore = db.select().getPreparedStatement(query);
      psStore.clearParameters();
      psStore.setInt(1, Integer.parseInt(storeId));
      psStore.setInt(2, Integer.parseInt(languageId));
      psStore.setInt(3, Integer.parseInt(categoryId));
      rs = psStore.executeQuery();
    } else if (SystemConstant.STORE_BRAND.equals(pageType)) {
      query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.view_type, TOF.exclusive_coupon, TOF.store_id,TST.domain_id,TOFL.language_id,TOB.brand_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_brand_offer TOB,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TST.id= ? AND TOFL.language_id = ? AND TOB.brand_id = ? AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.archieved = 0 AND TSEO.language_id = TSL.language_id " + filterCorD + " ORDER BY " + orderBy + "";
      psStore = db.select().getPreparedStatement(query);
      psStore.clearParameters();
      psStore.setInt(1, Integer.parseInt(storeId));
      psStore.setInt(2, Integer.parseInt(languageId));
      psStore.setInt(3, Integer.parseInt(brandId));
      rs = psStore.executeQuery();
    }

    
    while (rs.next()) {       
          VoucherDeals vd = new VoucherDeals();
          vd.setId(rs.getString("id"));
          vd.setDomainId(rs.getString("domain_id"));
          vd.setStoreId(rs.getString("store_id"));
          vd.setCouponCode(rs.getString("coupon_code"));
          vd.setImageSmall(rs.getString("image_small"));
          vd.setLanguageId(rs.getString("language_id"));
          vd.setOfferLike(rs.getString("offer_like"));
          vd.setOfferType(rs.getString("offer_type"));
          vd.setOfferHeading(rs.getString("offer_heading"));
          vd.setStoreName(rs.getString("name"));
          vd.setStoreSeoUrl(rs.getString("seo_url"));
          vd.setOfferImage(rs.getString("image"));
          vd.setOfferDesc(rs.getString("offer_description"));
          vd.setExclusive(rs.getString("exclusive_coupon"));
          vd.setUsedCountToday(rs.getString("used_count_today"));
          vd.setEndDate(sdf.format(rs.getDate("end_date")));
          vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
          vd.setBenifitType(rs.getString("benefit_type"));
          vd.setBenifitValue(rs.getString("benefit_value"));
          if("1".equals(vd.getExclusive())){ 
            if("1".equals(rs.getString("view_type"))){
                mobileOfferList.add(0,vd);
                vd = null;
            }else if("0".equals(rs.getString("view_type"))){
               deskOfferList.add(0,vd);
               vd = null;
            }
           }else{
             if("1".equals(rs.getString("view_type"))){
                mobileOfferList.add(vd);
                vd = null;
            }else if("0".equals(rs.getString("view_type"))){
               deskOfferList.add(vd);
               vd = null;
            }  
               }
    }   
            
    
                        couponCount = 0;
                        if (mobileOfferList != null) {
                          for (VoucherDeals vd : mobileOfferList) {
                             if(couponCount>30)
                                break;
                            if (vd.getLanguageId().equals(languageId)) {
                              couponCount++;
                              if ("1".equals(vd.getOfferType())) {
                                  voucherClass = "vpop click-to-code";
                                  voucherDesc = p.getProperty("public.home.get_voucher");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                  voucherClass = "activate-deal-2 u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                  voucherClass = "activate-deal u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              }
                       %>
                       <%@include file="common/mobOffer.jsp" %> 
                       <% } } }
                       couponCount = 0;
                        if (deskOfferList != null) {
                          for (VoucherDeals vd : deskOfferList) {
                             if(couponCount>30)
                                break;
                            if (vd.getLanguageId().equals(languageId)) {
                              couponCount++;
                              if ("1".equals(vd.getOfferType())) {
                                  voucherClass = "vpop click-to-code";
                                  voucherDesc = p.getProperty("public.home.get_voucher");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                  voucherClass = "activate-deal-2 u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                  voucherClass = "activate-deal u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              }
                        %>
                        <%@include file="common/deskOffer.jsp" %> 
                        <% } } } %>
                       <%if(deskOfferList!=null && deskOfferList.size()==0 
                               && mobileOfferList!=null && mobileOfferList.size()==0){%>
         
                        <div class="offer-item desk-offer-content offer">
                       <div class="row">
                          <div class="item-top">
                             
                             <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="offer-info">
                                   <a><%=p.getProperty("public.store.no_current_offers")%></a> 
                                   <p><%=p.getProperty("public.store.no_current_offers_desc")%></p>
                                </div>
                             </div>
                             <div class="col-lg-3 col-md-3 col-sm-3 col-xs-8"> &nbsp; </div>
                          </div>
                       </div>
                    </div>
  <%}} catch (Throwable e) {
    Logger.getLogger("ajaxFilterByStore.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(psStore);
    Cleaner.close(rs);
    db.select().clean();
    db.close();
  }
%>
                        