<%-- 
    Document   : indexProduct
    Created on : 6 Jul, 2016, 11:47:30 AM
    Author     : IshahaqKhan
--%>

<%@page import="sdigital.vcpublic.home.MetaTags"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.pl.products.domains.Product"%>
<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>


<%      
        String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
        String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
        String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
        String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");   
        int storeRows = 0;
        
        String domainName = "";
        String pageName = "";
        String pageType = "-1";
        domainName = (String) session.getAttribute("domainName");
        pageName = (String) session.getAttribute("pageName");
        VcHome home = VcHome.instance();
        VcSession vcsession = VcSession.instance();
        String domainId = home.getDomainId(domainName);
        List<Domains> domains = home.getDomains(domainId);
        Domains domain = home.getDomain(domains, domainId); // active domain    
        String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
        
        List<Language> languages = home.getLanguages(domain.getId());
        Language language = vcsession.getLanguage(session, domain.getId(), languages);
        Properties p = home.getLabels(language.getId());
        HomeConfig homeConfig = home.getConfig(domainId);
        List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
        List<MetaTags> metaList = home.getMetaByDomainId(domainId);
        List<Banner> bannerList = home.getBannerByDomainId(domainId);
        String desc = "";
        String topBannerPath = "";
        List<Testimonial> testimonialList = home.getTestimonialByDomainId(domainId);
        FeedMeta meta = SolrUtils.getFeedMeta(domainId, "home", domain.getThemeType());
        String outURL= "http://"+(String)session.getAttribute("domainName") +"/out";   
        List<Category> popCategoryList = home.getPopCatByDomainId(domainId);    
        List<VoucherDeals> popOfferList = home.getPopOfferByDomainId(domainId); 
        String langId = CommonUtils.getcntryLangCd(domainId);
                
%>

<%
    String currenySysmbol = "";
    if("1".equals(domain.getCurrencyType())){
        currenySysmbol = "Rs&nbsp;";
      } else if("2".equals(domain.getCurrencyType())){
        currenySysmbol = "$";
      }else if("3".equals(domain.getCurrencyType())){
        currenySysmbol = "RM";
      }else if("4".equals(domain.getCurrencyType())){
        currenySysmbol = "HKD";
      }else if("5".equals(domain.getCurrencyType())){
        currenySysmbol = "&#x20B9;";
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
      
     %> 
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
<head>
 <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">		
        <%if("www.stagingserver.co.in".equals(domainName)){%>
                <meta name="robots" content="noindex">
        <%}%>			
                         
        <title itemprop="name"><%=meta.getTitle() %></title>
        <meta name="description" content="<%=meta.getMetaDescription()%>">
        <meta name="keywords" content="<%=meta.getMetaKeyword()%>">
        <meta property="og:url"           content="<%=pageUrl%>" />
        <meta property="og:type"          content="website" />
        <meta property="og:image"          content="<%=SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length())%>/images/logo.svg" />
        <meta property="og:title"         content="<%=meta.getTitle()%>" />
        <meta property="og:description"   content="<%=meta.getMetaDescription()%>" /> 
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %> 

 <%@include file="products/common/header.jsp" %> 
 
 
<style>

@media (max-width: 650px)
{
	#paylesseron .my-coupon {
	    height:31px !important;
	}
}
</style>

</head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
<body class="cms-index-index cms-home-page feed">
<link rel="canonical" href="<%=pageUrl%>offers">              
    
<div id="page">     
 <%@include file="products/common/topmenu.jsp" %> 

    <!-- ================================Banner Start===================================-->
      <section id="banner">
        <div class="container">
            <div class="row">
                <!-------Main Banner Start-------->
                <div class="col-md-8 col-sm-8 col-xs-12" style="padding-right: 0"> 
                    <div id="main-banner" >
                        <div class="slider-items">
                            <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for left banner
                                        if ("2".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                    <a href="<%=b.getRedirectUrl()%>" rel="nofollow">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div>
                            <% } } } }%>
                        </div>    
                    </div>
                </div>
                <!-------Main Banner End-------->
                
                <!-------Side Upper banner Start-------->
                <div class="col-md-4 col-sm-4 hidden-xs">  
                    <div id="side-upper-banner" style="margin-bottom: 17px">
                        <div class="slider-items">
                            <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for right top banner
                                        if ("3".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                     <a href="<%=b.getRedirectUrl()%>" rel="nofollow">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div> 
                            <% } } } }%>
                        </div>    
                    </div>
                </div>
                <!-------Side Upper banner End-------->
                
                <!-------Side Bottom banner Start-------->
                <div class="col-md-4 col-sm-4 hidden-xs">  
                    <div id="side-bottom-banner" >
                        <div class="slider-items">
                              <%
                                if (bannerList != null) {
                                    for (Banner b : bannerList) { // for right bottom banner
                                        if ("4".equals(b.getBannerType())) {
                                            if (language.getId().equals(b.getLanguageId())) {
                                                if ("".equals(b.getImage()) || b.getImage() == null) {
                                                    topBannerPath = b.getImageUrl();
                                                } else {
                                                    topBannerPath = b.getImage();
                            }%>
                              <div class="item">
                                <div class="item-inner"> 
                                     <a href="<%=b.getRedirectUrl()%>" rel="nofollow">
                                    <img src="<%=cdnPath + topBannerPath%>" alt="<%=b.getTitle()%>" title="<%=b.getTitle()%>"/>
                                    </a>
                                </div>
                              </div> 
                            <% } } } }%> 
                        </div>    
                    </div>
                </div>
                <!-------Side Bottom banner End-------->
                
            </div>
        </div>    
      </section>
    <!-- ================================Banner End===================================-->
  <% int dynamic = 1;
     if(dynamic==0){
  %>
     <%@ include file="products/common/staticStores.html" %>
    
  <%  }else{
      if (popCategoryList != null) {  %>
     <!-- ================================Paylesser On Start===================================-->       
    <section id="paylesseron" >
        <div class="container">
          <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
              <ul class="nav nav-tabs" id="myTab">
           <%  int i = 0;
               String clss = "";
               for (Category cat : popCategoryList) {
                if (cat.getLanguageId().equals(language.getId())) { 
                    i++; 
                    clss = (i==1)?"active":"";
              %>
               
              <li class="<%=clss%>"><a data-toggle="tab" href="<%="#"+cat.getId()%>"><%=cat.getName()%></a></li>
                         
            
    <%  }
            }  %>
                </ul>
                <div class="tab-content" id="myTabContent">   
                   <%  int j = 0;
                    String clss1 = "";
                    for (Category cat : popCategoryList) {
                     if (cat.getLanguageId().equals(language.getId())) { 
                         j++; 
                         clss1 = (j==1)?"active":"";
                   %> 
                   
                    <div id="<%=cat.getId()%>" class="tab-pane fade in <%=clss1%>">
                        <div class="slider-items">                      
                            <%  if (popOfferList != null) {  
                                  for (VoucherDeals vd : popOfferList) {
                                      if(vd.getCategoryId().equals(cat.getId())){
                            %>   
                               
                              <div class="item">
                                    <div class="item-img">
                                        <a href="<%=pageUrl + vd.getStoreSeoUrl() %>"><img src="<%=cdnPath + vd.getImageSmall()%>" class="pointer" alt="<%=vd.getStoreCaption()!=null?vd.getStoreCaption():vd.getStoreName()%>"></a>
                                    </div>
                                    <div class="item-ttl">
                                        <a href="javascript:void(0)"><%=vd.getOfferHeading()%></a>        
                                    </div>
                                     <%if ("1".equals(vd.getOfferType())) {%>
                                       <div class="button-bar">
                                         <a data-type="20" data-lang="<%=vd.getLanguageId()%>" data-of="<%=vd.getId()%>" id="20-<%=vd.getId()%>" class="click-to-code vpop my-btn my-coupon"><span class="get-coupon">Get Coupon</span></a>
                                       </div>
                                       <%} else {%>
                                       <div class="button-bar offer">
                                         <a data-of="<%=vd.getId()%>" href="/cout?id=<%=vd.getId()%>" target="_blank" rel="nofollow" class="my-coupon"><span class="get-coupon"><%=p.getProperty("public.category.activate_deal")%></span></a>
                                       </div>
                                       <% } %>                                   
                                </div>
                            <%}}}%>
                        </div>
                    </div>    
                   
                   <%  }
                          }  %>

                </div>  
                </div>
              </div>
            </div>
          </section>
          <!-- ================================Paylesser On End===================================-->

   
            
     <%  } }%>

  <!-- ================================Top Categories Start===================================--> 
 <section id="recommended-products" class="hidden-sm hidden-xs">
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          
              <h2>Top Products</h2>
        <ul class="nav nav-tabs">
            <%if(topCat!=null){
                int i = 0;
                String active = "active";
                for(ProductCategory cat : topCat){
                    i++;
                  if(i>1){
                      active = "";
                  }  
                %>
                <li class="<%=active%>"><a data-toggle="tab" href="#<%=cat.getName().replaceAll("[^\\p{IsAlphabetic}]+", "") %>"><%=SolrUtils.toDisplayCase(cat.getName())%></a></li>
             <%}}%> 
            </ul>
        </div>
      </div>    
        <div class="tab-content">
            
             <%if(topCat!=null){
                    int i = 0;
                    String active = "in active";
                    for(ProductCategory cat : topCat){
                         i++;
                        if(i>1){
                            active = "";
                        }    
             %>
            
              <div id="<%=cat.getName().replaceAll("[^\\p{IsAlphabetic}]+", "")%>" class="tab-pane bhoechie-tab-content fade <%=active%>">
                <div class="row">
                    
                    <%List<Product> products = home.getCatProductByName(domainId, cat.getName());
                        if(products!=null){
                            int j = 0;
                            for(Product pro : products){
                                j++;
                                if(j>15){
                                    break;
                                }
                        %>
                          <%@include file="products/common/productIndia.jsp" %>                          
                         <%}}%> 
                       
              </div>    
                
            </div>  
           <%}}%> 
     </div>  
    </div>
     
  </section> 
     <div class="container">
     <div id="top-category">         
        <div class="top-category-mm hidden-lg hidden-md">
                <h2 style="margin-top:0">Top Products</h2>
                <div class="row">
                    <div class="col-lg-12 col-md-3 col-sm-3 col-xs-6">
                        <div class="item">
                            <div class="item-img">
                                <a class="product-image" href="#"> <img alt="" src=""> </a>
                                <div class="add-to-cart"><a class="" href="#"><span></span> </a></div>
                            </div>
                            <div class="item-info">
                                <h4><a href="#"></a> </h4>
                                <p class="discount"><span></span></p>  
                                <p class="price">
                                    <span class="old">
                                        <img src="" alt="">
                                    </span>
                                    <span class="new"></span></p>
                            </div>
                        </div>
                    </div>                    
                </div>
            </div> 
     </div>
    </div>
<!-- ================================Content Start===================================-->     
    <%if("17".equals(domainId)){ %>
         <%@include file="common/pr.jsp"%>        
    <%}%>  

    <%@include file="products/common/bottomMenu.jsp" %> 
    
</div>   
    <%@include file="products/common/footer.jsp" %> 
    <script src="<%=SystemConstant.PATH%>js/clipboard.min.js"></script>
    <script>   
        var clipboard = new Clipboard('.btn');
        clipboard.on('success', function(e) {
        $(".copy-voucher").tooltip('enable');
        $(".copy-voucher").tooltip('show');
        setTimeout(function(){ $(".copy-voucher").tooltip('hide');$(".copy-voucher").tooltip('disable'); }, 1000);
        });
    </script>
    <script>
        $(document).ready(function(){
            $('.trending-search').hide();
            $("ul.nav-tabs a").on( 'click',function(e){
                console.log(this);    
                $("img.feed-prod-img").unveil();
                setTimeout(function(){
                 $(document.body).scrollTop($(document.body).scrollTop()+2); },400);                 
            });
        });

    </script>  
    
    
  <script>
   
    $(document).ready(function(){
        $('.notification').slideToggle(900);
	});
       
    $('.close').click(function () {
        $('.notification').slideToggle(500);
    });
       
    setTimeout(function() {
        $('.notification').slideToggle(500);
    }, 5000);
       
       
    !function ($) {

    "use strict";

    // TABCOLLAPSE CLASS DEFINITION
    // ======================

    var TabCollapse = function (el, options) {
        this.options   = options;
        this.$tabs  = $(el);

        this._accordionVisible = false; //content is attached to tabs at first
        this._initAccordion();
        this._checkStateOnResize();


        // checkState() has gone to setTimeout for making it possible to attach listeners to
        // shown-accordion.bs.tabcollapse event on page load.
        // See https://github.com/flatlogic/bootstrap-tabcollapse/issues/23
        var that = this;
        setTimeout(function() {
          that.checkState();
        }, 0);
    };

    TabCollapse.DEFAULTS = {
        accordionClass: 'visible-xs',
        tabsClass: 'hidden-xs',
        accordionTemplate: function(heading, groupId, parentId, active) {
            return  '<div class="panel panel-default">' +
                    '   <div class="panel-heading">' +
                    '      <h4 class="panel-title">' +
                    '      </h4>' +
                    '   </div>' +
                    '   <div id="' + groupId + '" class="panel-collapse collapse ' + (active ? 'in' : '') + '">' +
                    '       <div class="panel-body js-tabcollapse-panel-body">' +
                    '       </div>' +
                    '   </div>' +
                    '</div>'

        }
    };

    TabCollapse.prototype.checkState = function(){
        if (this.$tabs.is(':visible') && this._accordionVisible){
            this.showTabs();
            this._accordionVisible = false;
        } else if (this.$accordion.is(':visible') && !this._accordionVisible){
            this.showAccordion();
            this._accordionVisible = true;
        }
    };

    TabCollapse.prototype.showTabs = function(){
        var view = this;
        this.$tabs.trigger($.Event('show-tabs.bs.tabcollapse'));

        var $panelHeadings = this.$accordion.find('.js-tabcollapse-panel-heading').detach();
        $panelHeadings.each(function() {
            var $panelHeading = $(this),
                $parentLi = $panelHeading.data('bs.tabcollapse.parentLi');
            view._panelHeadingToTabHeading($panelHeading);
            $parentLi.append($panelHeading);
        });

        var $panelBodies = this.$accordion.find('.js-tabcollapse-panel-body');
        $panelBodies.each(function(){
            var $panelBody = $(this),
                $tabPane = $panelBody.data('bs.tabcollapse.tabpane');
            $tabPane.append($panelBody.children('*').detach());
        });
        this.$accordion.html('');

        this.$tabs.trigger($.Event('shown-tabs.bs.tabcollapse'));
    };

    TabCollapse.prototype.showAccordion = function(){
        this.$tabs.trigger($.Event('show-accordion.bs.tabcollapse'));

        var $headings = this.$tabs.find('li:not(.dropdown) [data-toggle="tab"], li:not(.dropdown) [data-toggle="pill"]'),
            view = this;
        $headings.each(function(){
            var $heading = $(this),
                $parentLi = $heading.parent();
            $heading.data('bs.tabcollapse.parentLi', $parentLi);
            view.$accordion.append(view._createAccordionGroup(view.$accordion.attr('id'), $heading.detach()));
        });

        this.$tabs.trigger($.Event('shown-accordion.bs.tabcollapse'));
    };

    TabCollapse.prototype._panelHeadingToTabHeading = function($heading) {
        var href = $heading.attr('href').replace(/-collapse$/g, '');
        $heading.attr({
            'data-toggle': 'tab',
            'href': href,
            'data-parent': ''
        });
        return $heading;
    };

    TabCollapse.prototype._tabHeadingToPanelHeading = function($heading, groupId, parentId, active) {
        $heading.addClass('js-tabcollapse-panel-heading ' + (active ? '' : 'collapsed'));
        $heading.attr({
            'data-toggle': 'collapse',
            'data-parent': '#' + parentId,
            'href': '#' + groupId
        });
        return $heading;
    };

    TabCollapse.prototype._checkStateOnResize = function(){
        var view = this;
        $(window).resize(function(){
            clearTimeout(view._resizeTimeout);
            view._resizeTimeout = setTimeout(function(){
                view.checkState();
            }, 100);
        });
    };


    TabCollapse.prototype._initAccordion = function(){
        this.$accordion = $('<div class="panel-group ' + this.options.accordionClass + '" id="' + this.$tabs.attr('id') + '-accordion' +'"></div>');
        this.$tabs.after(this.$accordion);
        this.$tabs.addClass(this.options.tabsClass);
        this.$tabs.siblings('.tab-content').addClass(this.options.tabsClass);
    };

    TabCollapse.prototype._createAccordionGroup = function(parentId, $heading){
        var tabSelector = $heading.attr('data-target'),
            active = $heading.data('bs.tabcollapse.parentLi').is('.active');

        if (!tabSelector) {
            tabSelector = $heading.attr('href');
            tabSelector = tabSelector && tabSelector.replace(/.*(?=#[^\s]*$)/, ''); //strip for ie7
        }

        var $tabPane = $(tabSelector),
            groupId = $tabPane.attr('id') + '-collapse',
            $panel = $(this.options.accordionTemplate($heading, groupId, parentId, active));
        $panel.find('.panel-heading > .panel-title').append(this._tabHeadingToPanelHeading($heading, groupId, parentId, active));
        $panel.find('.panel-body').append($tabPane.children('*').detach())
            .data('bs.tabcollapse.tabpane', $tabPane);

        return $panel;
    };



    // TABCOLLAPSE PLUGIN DEFINITION
    // =======================

    $.fn.tabCollapse = function (option) {
        return this.each(function () {
            var $this   = $(this);
            var data    = $this.data('bs.tabcollapse');
            var options = $.extend({}, TabCollapse.DEFAULTS, $this.data(), typeof option === 'object' && option);

            if (!data) $this.data('bs.tabcollapse', new TabCollapse(this, options));
        });
    };

    $.fn.tabCollapse.Constructor = TabCollapse;


}(window.jQuery);   
    
</script> 

 <script type="text/javascript">
    $('#myTab').tabCollapse();
</script>
    
</body>
</html>
</compress:html>
