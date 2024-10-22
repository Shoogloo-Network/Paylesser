<%-- 
    Document   : mobOffer
    Created on : 16 Mar, 2016, 16 Mar, 2016 4:08:06 PM
    Author     : Vivek
--%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.config.CommonUtils"%>
<%@page import="com.ocpsoft.pretty.time.PrettyTime"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%
    String currenySysmbol = "";
    String currenyValue = "";
    String endDate = "";
    SeoUrl seoObj1 = (SeoUrl)request.getAttribute("seo");
    currenySysmbol = CommonUtils.getCurrency(domainId);
    Date date1 = new Date(vd.getEndDate());
    Date date2 = new Date();
    endDate = new SimpleDateFormat("yyyy-MM-dd\'T\'HH:mm:ss.SSSZ", Locale.ENGLISH).format(date1.getTime());
    String strtDate = new SimpleDateFormat("MM-dd-yyyy", Locale.ENGLISH).format(date2.getTime());
    String enDate = new SimpleDateFormat("MM-dd-yyyy", Locale.ENGLISH).format(date1.getTime());
    if(vd.getBenifitValue() != null && !"".equals(vd.getBenifitValue())) {
      currenyValue = vd.getBenifitValue().trim();
    } 
%> 
<%if ("1".equals(vd.getOfferType())) {
 if("1".equals(vd.getExclusive())){%>                
    <div class="offer-item exclusive mobile-offer-content coupon">
<%}else{%> 
    <div class="offer-item mobile-offer-content coupon">
<%} } else {
 if("1".equals(vd.getExclusive())){
%>                
    <div class="offer-item exclusive mobile-offer-content offer">
<%}else{%> 
    <div class="offer-item mobile-offer-content offer">
<% } } %>
    <div class="row">
        <div class="item-top">
            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
                <div class="offer-value">
                  <%
                   if ("2".equals(vd.getOfferType()) && vd.getOfferImage() != null && !"".equals(vd.getOfferImage())) {
                    if (SystemConstant.COUPON_DATILS.equals(seoObj1.getPageType())) {  
                         if(vd.getStoreSeoUrl()!=null){%>
                           <figure class="lazy"><a href="<%=pageUrl + vd.getStoreSeoUrl()%>"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers" /></a></figure>
                         <%}else{%>
                           <figure class="lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers"></figure>
                         <% }
                    }else if ("3".equals(vd.getBenifitType())) {
                   %>
                  <p> <%=vd.getBenifitValue()%> </p>                  
                  <%} else if(vd.getStoreSeoUrl()!=null){%>
                  <figure class="lazy"><a href="<%=pageUrl + vd.getStoreSeoUrl()%>"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getOfferImage()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers" /></a></figure>
                  <%}else{%> 
                  <figure class="lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getOfferImage()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers" /></figure>
                  <%}
                    } else {
                    if (SystemConstant.COUPON_DATILS.equals(seoObj1.getPageType())) {  
                     if(vd.getStoreSeoUrl()!=null
                        && !(SystemConstant.STORE.equals(seoObj1.getPageType())||SystemConstant.STORE_CATEGORY.equals(seoObj1.getPageType()) || SystemConstant.STORE_BRAND.equals(seoObj1.getPageType()))){%>
                       <figure class="lazy"><a href="<%=pageUrl + vd.getStoreSeoUrl()%>"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers" /></a></figure>
                     <%}else{%>
                       <figure class="lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers"></figure>
                     <% }
                   }else if ("2".equals(vd.getBenifitType())) {
                    %>  
                  <p><%=currenyValue%>%<span><%=p.getProperty("public.store.discount")%></span> </p>
                  <% } else if ("1".equals(vd.getBenifitType())) { %>
                  <p><%=currenySysmbol%><%=currenyValue%> <span><%=p.getProperty("public.store.off")%></span> </p>
                  <% } else if ("3".equals(vd.getBenifitType())) { %>
                  <p><%=vd.getBenifitValue()%><span></span> </p>
                  <% } else { %>
                  <%if(vd.getStoreSeoUrl()!=null
                          && !(SystemConstant.STORE.equals(seoObj1.getPageType())||SystemConstant.STORE_CATEGORY.equals(seoObj1.getPageType()) || SystemConstant.STORE_BRAND.equals(seoObj1.getPageType()))){%>
                  <figure class="lazy"><a href="<%=pageUrl + vd.getStoreSeoUrl()%>"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers" /></a></figure>
                  <%}else{%>
                  <figure class="lazy"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + vd.getImageSmall()%>" alt="<%=vd.getStoreName()%> voucher" title="<%=vd.getStoreName()%> offers"></figure>
                  <% } } }
                  if ("1".equals(vd.getOfferType())) { %>
                  <span class="tag"><%=p.getProperty("public.home.coupondetails.coupon")%></span>
                  <% } else { %>
                  <span class="tag"><%=p.getProperty("public.home.coupondetails.offer")%></span>
                  <% } %>
                </div>
            </div>
            <div class="col-lg-7 col-md-7 col-sm-7 col-xs-8">
                <div class="offer-info">
                    <h3 class="couponDetails <%=vd.getId()%> cursor-href pointer"><%=vd.getOfferHeading()%></h3>
                    <div class="hidden-xs"><%=vd.getOfferDesc()%></div>
                </div>
                
               <div class="info-bar">
               
                    <%
                        if ("0".equals(vd.getUsedCountToday())){
                        if ("1".equals(homeConfig.getUpdatedDate())) {
                    %> 
                   
                        <span><i class="fa fa-check-square"></i><%//=p.getProperty("public.category.updated_on")%> <%//=vd.getModifiedAt() != null ? vd.getModifiedAt() : ""%><%=p.getProperty("public.coupon.verified")%></span>
                    
                    <%
                        } if ("1".equals(homeConfig.getNumberPeoples())) {
                    %> 
                    
                        <span><i class="fa fa-users"></i><%=vd.getUsedCountToday()%>&nbsp;<%=p.getProperty("public.category.used")%></span>
                   
                   <% } } %>
                   
                    <%
                     if ("1".equals(homeConfig.getExpiryDate())) {
                         PrettyTime t = new PrettyTime();
                    %> 
                    <span class="expire"><i class="fa fa-calendar"></i><%=p.getProperty("public.category.expires_on")%><%=enDate%></span>
                    <%}%>
    
                   <% if ("1".equals(homeConfig.getVote())) { %>
                    <!--<span>
                        <a class="vote-up <%=vd.getId()%> pointer">
                            <i class="fa fa-thumbs-o-up"></i>
                            <span class="count-<%=vd.getId()%>"><%=vd.getOfferLike()%></span>
                        </a>
                        <a class="heartstar heart pointer"><i class="fa fa-heart-o" cid="<%=vd.getId()%>"></i></a>
                        <a class="heartstar star pointer"><i class="fa fa-star-o" cid="<%=vd.getId()%>"></i></a>
                      </span>-->
                    <% } %> 
            </div> 
                
                
                
            </div>
                    
           <div class="col-lg-3 col-md-3 col-sm-3 col-xs-1">
            <div class="button-bar">
                    <%if ("1".equals(vd.getOfferType())) {%>
                    <a data-type="20" data-lang="<%=vd.getLanguageId()%>" data-of="<%=vd.getId()%>" id="20-<%=vd.getId()%>" class="<%=voucherClass%> my-coupon"><span class="coupon-text"><%=vd.getCouponCode()%></span><span class="get-coupon coupon-wrap"><%=voucherDesc%></span></a>
                    <%} else {%>
                    <a data-of="<%=vd.getId()%>" data-href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="my-coupon btn-deal"><span class="get-coupon"><%=voucherDesc%></span></a>
                    <%}%> 
                  <% /* for (SeoUrl s : home.getSeoByDomainId(domainId)) {
                            if (SystemConstant.COUPON_DATILS.equals(s.getPageType())) {                             
                              if (language.getId().equals(s.getLanguageId())) { */%>
                    <!--        <a class="whatsapp hidden-lg hidden-md hidden-sm" rel="nofollow" href="whatsapp://send?text=Hey! Look what I found on Paylesser. <%=" "+vd.getOfferHeading() + " "%><%=pageUrl+seoObj1.getSeoUrl()+"?vc="%><%=vd.getId()%>" data-action="share/whatsapp/share"> 
                              <i class="fa fa-whatsapp" aria-hidden="true"></i>
                           </a>  -->
                     <% /* } } } */%>
                </div>
            </div>
              <div class="mobile-btn">
                    <%if ("1".equals(vd.getOfferType())) {%>
                    <a data-type="20" data-lang="<%=vd.getLanguageId()%>" data-of="<%=vd.getId()%>" id="20-<%=vd.getId()%>" class="click-to-code vpop"></a>
                    <%} else {%>
                    <a data-of="<%=vd.getId()%>" data-href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="btn-deal"></a>
                    <%}%> 
                    <% /*for (SeoUrl s : home.getSeoByDomainId(domainId)) { 
                            if (SystemConstant.COUPON_DATILS.equals(seoObj1.getPageType())) {                              
                              if (language.getId().equals(seoObj1.getLanguageId())) { */%>
                    <!--        <a class="whatsapp hidden-lg hidden-md hidden-sm" rel="nofollow" href="whatsapp://send?text=Hey! Look what I found on Paylesser. <%=" "+vd.getOfferHeading() + " "%> <%=pageUrl+ seoObj1.getSeoUrl()+"?vc="%><%=vd.getId()%>" data-action="share/whatsapp/share"> 
                              <i class="fa fa-whatsapp" aria-hidden="true"></i>
                           </a>   -->
                     <% /* } }  } */%>
                    
            </div>  
        </div>
    </div> 
   <%if("1".equals(vd.getExclusive())){%> 
   <div class="exclusive-tag2"><img src="<%=SystemConstant.PATH%>images/exclusive.png" /> </div>
   <%}%> 
</div>
   
<%eventCount++;
if(eventCount<10){
%>
<script type="application/ld+json">
{
       "@context": "http://schema.org",
        "@type": "SaleEvent",
        "name": "<%=vd.getOfferHeading().replaceAll("\"", "")%>",
        "url": "<%=pageUrl + couponDetails %>?vc=<%=vd.getId()%>",
        "startDate": "<%= strtDate %>",
        "endDate": "<%= enDate %>",
        "image": "<%=cdnPath + vd.getImageSmall()%>",
        "location": {
            "@type": "Place",
            "name": "<%=vd.getStoreName()%>",
            "url": "<%=pageUrl + vd.getStoreSeoUrl()%>",
            "address": "<%=vd.getStoreName()%>"
    }

}
</script>

<%}%>