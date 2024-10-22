<%-- 
    Document   : ajaxCouponPopup
    Created on : Nov 1, 2014, 7:19:42 PM
    Author     : sanith.e
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcpublic.home.*"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.Properties"%>
<%
  String strType = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
  int intOffer = Integer.parseInt(request.getParameter("offerId")==null ? "0" : request.getParameter("offerId"));
  String strLang = request.getParameter("languageId") == null ? "" : request.getParameter("languageId").replaceAll("\\<.*?>", "");
  String strQuery = "";
  String savedOffers = "";
  String src = "";
  StringBuffer strBuffer = new StringBuffer();
  PreparedStatement psUsedCoupon = null;
  PreparedStatement psVote = null;
  ResultSet rs = null;
  ResultSet rsOffer = null;
  ResultSet rsUsedCount = null;
  PreparedStatement psUsedCount = null;
  ResultSet rs1 = null;
  PreparedStatement psURlKey = null;
  ResultSet rsURlKey = null;
  //Getting active domain
  String requestUrl = request.getRequestURL().toString();
  String domainName = "";
  domainName = (String) session.getAttribute("domainName");
  VcHome home = VcHome.instance();
  VcSession vcsession = VcSession.instance();
  String domainId = home.getDomainId(domainName);
  List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domains, domainId); // active domain
  List<Language> languages = home.getLanguages(domain.getId());
  Language language = vcsession.getLanguage(session, domain.getId(), languages);
  Properties p = home.getLabels(language.getId());
  //int intDomain = Integer.parseInt(request.getParameter("domainId"));
  String cdnPath = "";
   if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
  Db db = Connect.newDb();
  String paraMeter = "";
  /*
  Integer uId = null;
  String sessId = session.getId();
 
  if (session.getAttribute("userObj") != null) {
    LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
    uId = linfo.getPublicUserId();
  }
  
  String ipAddress = request.getHeader("X-FORWARDED-FOR");
  if ("127.0.0.1".equals(ipAddress)) {
    ipAddress = request.getHeader("X-Real-IP");
  }
  if (ipAddress == null) {
    ipAddress = request.getRemoteAddr();
  } */

  try {
    if ("1".equals(strType)) {
      //long lastId = db.execute().insert("INSERT INTO vc_used_coupon (offer_id, public_user_id, domain_id, ip, user_agent, used_date, session_id, id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", new Object[]{intOffer, uId, Integer.parseInt(domainId), ipAddress, request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime()), sessId}, "vc_used_coupon_seq");
      String lastId = (session.getAttribute("fPrint")!=null)?(String)session.getAttribute("fPrint"):"";
      strQuery = "SELECT used_count, offer_url FROM vc_offer WHERE id = ?";
      psUsedCoupon = db.select().getPreparedStatement(strQuery);
      psUsedCoupon.clearParameters();
      psUsedCoupon.setInt(1, intOffer);
      rsOffer = psUsedCoupon.executeQuery();

      if (rsOffer.next()) {
        db.execute().update("UPDATE vc_offer SET used_count = ? WHERE id = ?", new Object[]{rsOffer.getInt(1) + 1, intOffer});
        String url = rsOffer.getString(2);
        String replace = "";
        String Q1[];

        //Appending UID = last inserted used coupon id, to affiliate url to track the user
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
                url = Q1[0] + "&" + paraMeter + "=" + lastId + Q1[1];
                strBuffer.append(url);
              } else {
                replace = Q1[1].substring(0, Q1[1].indexOf("&"));
                url = url.replace(replace, lastId);
                strBuffer.append(url);
              }
            } else {
              replace = url.substring(url.indexOf("&" + paraMeter + "=") + 5, url.length());
              url = url.replace(replace, lastId);
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
              url = url.replace(replace, lastId);
              strBuffer.append(url);
            }
          } else {
            strBuffer.append(url);
            if (url.indexOf("?") != -1) {
              strBuffer.append("&" + paraMeter + "=");
            } else {
              strBuffer.append("?" + paraMeter + "=");
            }
            strBuffer.append(lastId);
          }
        } else {
          strBuffer.append(url);
        }
      }
    } else if ("2".equals(strType)) {
      if (session.getAttribute("savedOffer") != null) {
        savedOffers = (String) session.getAttribute("savedOffer");
      }
      src = savedOffers.contains("," + intOffer + ",") ? SystemConstant.PATH + "images/icon-save.png" : SystemConstant.PATH + "images/dis-save.png";
      strQuery = "SELECT VO.coupon_code AS coupon_code, VO.offer_url AS offer_url, VOL.offer_heading AS offer_heading, VOL.offer_description AS offer_description, "
              + "VS.affiliate_url AS store_url, VSL.name AS store_name,VS.image_small FROM vc_offer VO, vc_offer_lang VOL, vc_store VS, vc_store_lang "
              + "VSL WHERE VO.id = VOL.offer_id AND VO.store_id = VS.id AND VO.store_id = VSL.store_id AND VO.id = ? AND "
              + "VOL.language_id = ? AND VSL.language_id = ?";
      psUsedCoupon = db.select().getPreparedStatement(strQuery);
      psUsedCoupon.clearParameters();
      psUsedCoupon.setInt(1, intOffer);
      psUsedCoupon.setInt(2, Integer.parseInt(strLang));
      psUsedCoupon.setInt(3, Integer.parseInt(strLang));
      rsOffer = psUsedCoupon.executeQuery();
      if (rsOffer.next()) {            
        strBuffer.append("                <div class=''>");
        strBuffer.append("                    <div class='row'>");
        strBuffer.append("                        <div class='col-lg-12 col-md-12 col-sm-12 col-xs-12'>");
        strBuffer.append("                            <div class='logo-box'>");
        strBuffer.append("                               <div> <img src='"+cdnPath+rsOffer.getString("image_small")+"'/></div>");
        strBuffer.append("                            </div>    ");
        strBuffer.append("                        </div>");
        strBuffer.append("                        <div class='col-lg-12 col-md-12 col-sm-12 col-xs-12'>");
        strBuffer.append("                            <div class='voucher-content'>");
        strBuffer.append("                    <h4 class='modal-title'>"+rsOffer.getString("offer_heading")+"</h4>");
        
        strBuffer.append("                            </div>");
        strBuffer.append("                        </div>");
        strBuffer.append("                    </div>");
        strBuffer.append("                    <div class='des_cont1'>");
        strBuffer.append("                                <div class='voucher-msg voucher-code'>");
        strBuffer.append("                                    <input type='text' id='foo' value='"+ rsOffer.getString("coupon_code") +"'>");
        strBuffer.append("                                    <button data-toggle='tooltip' data-placement='left' data-original-title='Copied!' class='btn copy-voucher' data-clipboard-target='#foo'>"+p.getProperty("public.couponpopup.copy_code")+"</button> ");
        strBuffer.append("                                </div>");
        strBuffer.append("                                <a href='" + rsOffer.getString("offer_url") + "' target='_blank' class='popup-btn btn orange'>"+p.getProperty("public.couponpopup.goto")+" "+rsOffer.getString("store_name")+" "+p.getProperty("public.couponpopup.pasteNcheckout")+"</a>");                       
        strBuffer.append("<p>"+rsOffer.getString("offer_description")+"</p></div>");
        strBuffer.append("                </div>");
      /*  strBuffer.append("                <div class='modal-footer'>");
        strBuffer.append("                    <h2 class='hidden-xs hidden-sm'>"+p.getProperty("public.couponpopup.headSubscribe")+"</h2>");
        strBuffer.append("                    <p>"+p.getProperty("public.couponpopup.descSubscribe")+"</p>");
        strBuffer.append("                    <form class='formpanel'>");
        strBuffer.append("						<div class='emailinput'>");
        strBuffer.append("                        <input type='text' name='email' id='email-popup' placeholder='"+p.getProperty("public.home.email_address")+"'>");
        strBuffer.append("						</div>");
        strBuffer.append("						<div class='popemailsubmit' id='popemailsubmit'>");
        strBuffer.append("                            <div id='poploading' class='loading' style='display:none'><img src='"+ SystemConstant.PATH+"images/loading.gif' alt='loading' /></div>");
        strBuffer.append("                            <button type='button' class='popsubmit btn'>"+p.getProperty("public.home.newsletter.subscribe")+"</button>");
        strBuffer.append("                        </div>");
        strBuffer.append("                    </form>");
        strBuffer.append("                </div>");   */

        /*strBuffer.append("<div class='modal-header'>");
        strBuffer.append("     <button type='button' class='close' data-dismiss='modal'>&times;</button>");
        strBuffer.append("     <h4 class='modal-title'>"+p.getProperty("public.couponpopup.no_couponcode")+"</h4>");
        strBuffer.append("     </div>");
        strBuffer.append("     <div class='modal-body'>");
        strBuffer.append("              <div class='voucher-content'><div class='hidden-lg hidden-md text-center'><h4>Long press to copy code</h4></div>");
        strBuffer.append("                  <div class='voucher-msg voucher-code'>");
        strBuffer.append("                      <input type='text' value='"+ rsOffer.getString("coupon_code") +"'>");
        strBuffer.append("                      <a class='hidden-xs copy-voucher click-to-copy'>"+p.getProperty("public.couponpopup.copy_code")+"</a>");
        strBuffer.append("                  </div>");
        strBuffer.append("                  <a class='popup-btn btn orange'>");
        strBuffer.append(                    p.getProperty("public.couponpopup.goto")+" "+rsOffer.getString("store_name")+" "+p.getProperty("public.couponpopup.pasteNcheckout"));
        strBuffer.append("                  </a></span>");
        strBuffer.append("              </div>");
        strBuffer.append("          </div>");
        strBuffer.append("          <div class='modal-footer'>");
        strBuffer.append("            <h2>"+rsOffer.getString("offer_heading")+"</h2>");
        strBuffer.append("              <p>"+rsOffer.getString("offer_description")+"</p>");
        strBuffer.append("</div>"); */ 
        /*strBuffer.append("<div class='voucher-area'>");
        strBuffer.append("<div class='voucher-content'>");
        strBuffer.append("<h3 class='clearfix'>" + p.getProperty("public.couponpopup.no_couponcode"));
        //strBuffer.append("<a href='#' class='save-coupon'>" + p.getProperty("public.couponpopup.save_coupon") + "</a>");
        if (session.getAttribute("userObj") != null) {
          strBuffer.append("<a class=\"save-" + intOffer + " pop-save\" href=\"javascript:fav(2, " + intOffer + ")\">" + p.getProperty("public.couponpopup.save_coupon") + "<img alt=\"save\" src=\"" + src + "\"></a>");
        }
        strBuffer.append("</h3>");
        strBuffer.append("<div class='voucher-msg voucher-code'>");
        //strBuffer.append("<p>" + rsOffer.getString("coupon_code") + "</p>");
        strBuffer.append("<input type=\"text\" value=\"" + rsOffer.getString("coupon_code") + "\"/>");
        strBuffer.append("<a class='copy-voucher click-to-copy'>" + p.getProperty("public.couponpopup.copy_code") + "</a>");
        strBuffer.append("</div>");
        strBuffer.append("<span class='popup-btn'>" + p.getProperty("public.couponpopup.goto") + "<a href='" + rsOffer.getString("store_url") + "' target='_blank'>" + rsOffer.getString("store_name") + "</a> " + p.getProperty("public.couponpopup.pasteNcheckout") + "</span>");
        strBuffer.append("</div>");
        strBuffer.append("</div>");
        strBuffer.append("<div class='popup-info'>");
        strBuffer.append("<h3>" + rsOffer.getString("offer_heading") + "</h3>");
        strBuffer.append("<p>");
        strBuffer.append(rsOffer.getString("offer_description"));
        strBuffer.append("</p>");
        strBuffer.append("</div>"); */

        //db.execute().insert("INSERT INTO vc_used_coupon (offer_id, public_user_id, domain_id, ip, user_agent, used_date, id) VALUES (?, ?, ?, ?, ?, ?, ?)", new Object[]{intOffer, null, Integer.parseInt(domainId), request.getRemoteAddr(), request.getHeader("User-Agent"), new java.sql.Timestamp(new java.util.Date().getTime())}, "vc_used_coupon_seq");
      }
    }
    String query = "SELECT TUC.offer_id AS o_id,TVO.used_count AS used_cnt,TVO.offer_like,TS.id FROM vc_used_coupon TUC,vc_offer TVO,vc_store TS WHERE TUC.used_date >= current_date AND TUC.offer_id = ? AND TUC.offer_id = TVO.id AND TS.id = TVO.store_id GROUP BY TUC.offer_id,TVO.offer_like,TS.id,TVO.used_count";
    psUsedCount = db.select().getPreparedStatement(query);
    psUsedCount.clearParameters();
    psUsedCount.setInt(1, intOffer);
    rs1 = psUsedCount.executeQuery();
    while (rs1.next()) {
      List<VoucherDeals> vdListById = home.getAllVDById(rs1.getString("id"));
      if (vdListById != null) {
        for (VoucherDeals vd : vdListById) {
          if (vd.getId().equals(rs1.getString("o_id"))) {
            vd.setOfferLike(rs1.getString("offer_like"));
            vd.setUsedCountToday(rs1.getString("used_cnt"));
          }
        }
      }
    }
    /*response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.getWriter().write(strBuffer.toString()); */
    out.println( strBuffer.toString() );
  } catch (Throwable e) {
    Logger.getLogger("ajaxCouponPopup.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(psUsedCoupon);
    Cleaner.close(psVote);
    Cleaner.close(psUsedCount);
    Cleaner.close(psURlKey);
    Cleaner.close(rs1);
    Cleaner.close(rsOffer);
    Cleaner.close(rs);
    Cleaner.close(rsUsedCount);
    Cleaner.close(rsURlKey);
    db.select().clean();
    Connect.close(db);
  }%>
  