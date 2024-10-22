<%-- 
    Document   : special
    Created on : Jan 20, 2015, 3:50:28 PM
    Author     : sanith.e
--%>

<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.*" %>
<%
try {
String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");  
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
boolean top = true;
boolean vouchers = true;
boolean deals = true;
//out.println(request.getRequestURL());
String requestUrl = request.getRequestURL().toString();
//String requestUrl = "test.vouchercodes.in:8080/vcadmin/faces/public/index.jsp";
String domainName = "";
String pageName = "";
domainName = (String)session.getAttribute("domainName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
String voucherClass = "";
String voucherDesc = "";
String pageType = "0";
pageType = SystemConstant.SPECIAL;
String pageTypeFk = "";
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId); // active domain
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage(session, domain.getId(), languages);
Properties p = home.getLabels(language.getId());
HomeConfig homeConfig = home.getConfig(domainId);
List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
List<Specials> allSpecialList = home.getAllSpecial(domainId);
String spHeading = "";
String imageUrl = "";
String specialId = request.getParameter("s") == null ? "" : request.getParameter("s").replaceAll("\\<.*?>", "");
pageTypeFk = specialId;
String spImage = "";
if(allSpecialList != null){
    for(Specials sp : allSpecialList){
        if(specialId.equals(sp.getId())){
            spImage = sp.getImage();
            spHeading = sp.getHeading();
            imageUrl = sp.getImageUrl();
        }
    }   
}
String speDet = home.getSpecialDet(specialId);
String[] speDets ;
String speName = "";
String speDes = "";
if(speDet != null && speDet.contains("###")){
    speDets = speDet.split("###");
    speName = speDets[0];
    speDes = speDets.length == 1 ? "" : speDets[1];
}
List<VoucherDeals> offerDealList = home.getSpecialOfferByDomainId(domainId,specialId);
List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId); 
String storeId = "0";
String catName = "";
String imagePath = "";
String langId = CommonUtils.getcntryLangCd(domainId);
List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">	
				
        <%
          if(seoList != null) {
            for(SeoUrl seo: seoList) {
              if(specialId.equals(seo.getPageTypeFk()) && pageType.equals(seo.getPageType()) && "0".equals(seo.getArchived())){
                  if(language.getId().equals(seo.getLanguageId())) {%>
                      <title itemprop="name"><%=seo.getPageTitle()%></title>
                      <meta name="description" content="<%=seo.getMetaDesc()%>">
                      <meta name="keywords" content="<%=seo.getMetaKeyword()%>">
        <%
                  break;
                  }
              }
            }
          }
        %>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %> 
    <%@include file="common/header.jsp" %>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body>
    <div id="wraper" class="inner">   
    <%@include file="common/topMenu.jsp" %> 
    <div class="Special-page">
        <div class="container">

            <div class="row">  
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="special-head">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="offer-info">
                                        <h1><%=spHeading==null?speName:spHeading%></h1>
                                    </div>
                                </div>
                            </div> 
                    </div>   
                </div>
            </div>
            
            <div class="row">  
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="special-banner">
                        <a href="<%=(imageUrl!=null && !"".equals(imageUrl))?imageUrl:"#"%>" alt="<%=spHeading==null?speName:spHeading%>" target="_blank"><img src="<%=cdnPath + spImage%>"></a>
                    </div>   
                </div>
            </div> 
                    
            <div class="row">  
                <%
                List<VoucherDeals> mobileVdListById = new ArrayList<VoucherDeals>();
                List<VoucherDeals> deskVdListById = new ArrayList<VoucherDeals>();
                if (offerDealList != null) {
                for (VoucherDeals vd : offerDealList) {
                    if("1".equals(vd.getExclusive())){ 
                     if("1".equals(vd.getViewType())){
                         mobileVdListById.add(0,vd);
                     }else if("0".equals(vd.getViewType())){
                        deskVdListById.add(0,vd);
                     }
                    }else{
                      if("1".equals(vd.getViewType())){
                         mobileVdListById.add(vd);
                     }else if("0".equals(vd.getViewType())){
                        deskVdListById.add(vd);
                     }  
                    }
                  }
                }  

                String currenySysmbol = "";
                String currenyValue = "";

                if("1".equals(domain.getCurrencyType())){
                    currenySysmbol = "Rs&nbsp;";
                  } else if("2".equals(domain.getCurrencyType())){
                    currenySysmbol = "$";
                  }else if("3".equals(domain.getCurrencyType())){
                    currenySysmbol = "RM";
                  }else if("4".equals(domain.getCurrencyType())){
                    currenySysmbol = "HKD";
                  }else if("5".equals(domain.getCurrencyType())){
                    currenySysmbol = "RP";
                  }else if("6".equals(domain.getCurrencyType())){
                    currenySysmbol = "NZ$";
                  }else if("7".equals(domain.getCurrencyType())){
                    currenySysmbol = "P";
                  }else if("8".equals(domain.getCurrencyType())){
                    currenySysmbol = "R";
                  }else if("9".equals(domain.getCurrencyType())){
                    currenySysmbol = "VND";
                  }else if("10".equals(domain.getCurrencyType())){
                    currenySysmbol = "AED";
                  }else if("11".equals(domain.getCurrencyType())){
                    currenySysmbol = "?";
                  }else if("12".equals(domain.getCurrencyType())){
                    currenySysmbol = "R$";
                  }else if("13".equals(domain.getCurrencyType())){
                    currenySysmbol = "PLN";
                  }else if("14".equals(domain.getCurrencyType())){
                    currenySysmbol = "QAR";
                  }else if("15".equals(domain.getCurrencyType())){
                    currenySysmbol = "UAR";
                  }else if("16".equals(domain.getCurrencyType())){
                    currenySysmbol = "IDR";
                  }else if("17".equals(domain.getCurrencyType())){
                    currenySysmbol = "Kr";
                  }else if("18".equals(domain.getCurrencyType())){
                    currenySysmbol = "LKR";
                  }else if("19".equals(domain.getCurrencyType())){
                    currenySysmbol = "?";
                  }else if("20".equals(domain.getCurrencyType())){
                    currenySysmbol = "£";
                 } else if ("37".equals(domain.getCurrencyType())) {
                  currenySysmbol = "&euro;";
                 }else if ("39".equals(domain.getCurrencyType())) {
                currenySysmbol = "SAR";
                }  

            int couponCount = 0;    
            if(mobileVdListById != null) {
              for(VoucherDeals vd : mobileVdListById) {
                 if(couponCount>30)
                    break;  
                if(language.getId().equals(vd.getLanguageId())) {
                   couponCount++;  
                  if ("1".equals(vd.getOfferType())) {
                      voucherClass = "click-to-code vpop";
                      voucherDesc = p.getProperty("public.home.get_voucher");
                  } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                      voucherClass = "activate-deal-2 u-deal";
                      voucherDesc = p.getProperty("public.category.activate_deal");
                  } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                      voucherClass = "activate-deal u-deal";
                      voucherDesc = p.getProperty("public.category.activate_deal");
                  }
                  if(vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                    imagePath = cdnPath + vd.getOfferImage();
                  } else {
                    imagePath = cdnPath + vd.getImageSmall();
                  } 
                  storeId += ","+vd.getStoreId();

                if(vd.getBenifitValue() != null && !"".equals(vd.getBenifitValue())) {
                    currenyValue = vd.getBenifitValue().trim();
                }
                %>
                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6">
                    <div class="special-item">
                        <div class="s-logo">
                           
                            <a href="javascript:console.log($(document.activeElement).parents('div.special-item').find('.my-coupon').click();">
                                <img src="<%=imagePath%>" alt="<%=vd.getStoreName()%>" />
                            </a>
                           
                        </div>    
                            <h3>
                            <% if ("2".equals(vd.getBenifitType())) { %>
                            <a><%=currenyValue%>%<span><%=" "+p.getProperty("public.store.discount")%></span></a>
                            <% } else if ("1".equals(vd.getBenifitType())) { %>
                            <a><%=currenySysmbol%><%=currenyValue%><span><%=" "+p.getProperty("public.store.off")%></span></a>
                            <% } else if ("3".equals(vd.getBenifitType())) { %>
                            <a><%=vd.getBenifitValue()%></a>
                            <% }%>
                            </h3>
                            <p><%=vd.getOfferHeading()%></p>
                            <%if ("1".equals(vd.getOfferType())) { %>
                            <div class="button-bar">
                            <% } else { %>
                            <div class="button-bar offer">
                            <% } %>
                            <%if ("1".equals(vd.getOfferType())) {%>
                            <a data-type="20" data-lang="<%=vd.getLanguageId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-coupon"><span class="coupon-text"><%=vd.getCouponCode()%></span><span class="get-coupon coupon-wrap"><%=voucherDesc%></span></a>
                            <%} else {%>
                            <a data-of="<%=vd.getId()%>" data-href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="my-coupon btn-deal"><span class="get-coupon"><%=voucherDesc%></span></a>
                            <%}%>
                            </div>
                        </div>    
                    </div>  
                <% } } } 
                if(deskVdListById != null) {
                  for(VoucherDeals vd : deskVdListById) {
                    if(couponCount>30)
                        break;  
                    if(language.getId().equals(vd.getLanguageId())) {
                      couponCount++;  
                      if ("1".equals(vd.getOfferType())) {
                          voucherClass = "click-to-code vpop";
                          voucherDesc = p.getProperty("public.home.get_voucher");
                      } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                          voucherClass = "activate-deal-2 u-deal";
                          voucherDesc = p.getProperty("public.category.activate_deal");
                      } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                          voucherClass = "activate-deal u-deal";
                          voucherDesc = p.getProperty("public.category.activate_deal");
                      }
                      if(vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                        imagePath = cdnPath + vd.getOfferImage();
                      } else {
                        imagePath = cdnPath + vd.getImageSmall();
                      } 
                      storeId += ","+vd.getStoreId();

                    if(vd.getBenifitValue() != null && !"".equals(vd.getBenifitValue())) {
                      currenyValue = vd.getBenifitValue().trim();
                    }
                %>                
                <div class="col-lg-3 col-md-3 col-sm-4 col-xs-6">
                    <div class="special-item">
                        <div class="s-logo">                        
                        <a href="javascript:$(document.activeElement).parents('div.special-item').find('.my-coupon')[0].click();"><img src="<%=imagePath%>" alt="<%=vd.getStoreName()%>" /></a>
                        
                        </div>
                        <h3>
                        <% if ("2".equals(vd.getBenifitType())) { %>
                        <a><%=currenyValue%>%<span><%=" "+p.getProperty("public.store.discount")%></span></a>
                        <% } else if ("1".equals(vd.getBenifitType())) { %>
                        <a><%=currenySysmbol%><%=currenyValue%><span><%=" "+p.getProperty("public.store.off")%></span></a>
                        <% } else if ("3".equals(vd.getBenifitType())) { %>
                        <a><%=vd.getBenifitValue()%></a>
                        <% }%>
                        </h3>
                        <p><%=vd.getOfferHeading()%></p>
                        <%if ("1".equals(vd.getOfferType())) { %>
                            <div class="button-bar">
                        <% } else { %>
                          <div class="button-bar offer">
                        <% } %>
                        <%if ("1".equals(vd.getOfferType())) {%>
                        <a data-type="20" data-lang="<%=vd.getLanguageId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-coupon"><span class="coupon-text"><%=vd.getCouponCode()%></span><span class="get-coupon coupon-wrap"><%=voucherDesc%></span></a>
                        <%} else {%>
                        <a data-of="<%=vd.getId()%>" data-href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="my-coupon btn-deal"><span class="get-coupon"><%=voucherDesc%></span></a>
                        <%}%>
                        </div>
                    </div>    
                 </div>
            <% } } } %>
        </div>
    </div> 
        
    <% if(speDes != null && !"".equals(speDes)) { %>
    <section class="category">
    <div class="container">
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
                <div id="home-intro" class="box">
                    <!--<h4><//%=speName == null ? "" : speName%></h4>-->
                    <%=speDes == null ? "" : speDes%>
                </div>
            </div>
        </div>
      </div>
    </section>
    <% } %>
 </div>          
<%@include file="common/bottomMenu.jsp" %>
<%@include file="common/footer.jsp" %>
    <script>
        catId = <%=specialId%>;
    </script>
    </body>
</compress:html>
</html>
<%}
catch(Throwable e) {
    Logger.getLogger("category.jsp").log(Level.SEVERE, null, e);
}
%>


