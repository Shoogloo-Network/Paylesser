<%-- 
        Document   : navigation
        Created on : Jul 15, 2016, Jul 15, 2016 9:53:39 AM
        Author     : Vivek
    --%>
<%@page import="sdigital.vcpublic.config.CommonUtils"%>
<%@page import="sdigital.vcpublic.home.FeedMeta"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="sdigital.pl.products.domains.ProductBrand"%>
<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.MenuData"%>
<%@page import="java.util.Map"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <%
        Map<String, List<MenuData>> menuItems = home.getMenuData(domainId);
        Map<String, List<ProductBrand>> catBrand = home.getBrandsByCategory(domainId);
        List<MenuData> rootCategories=null;
        List<MenuData> subCategories=null;  
        List<MenuData> endCategories=null;        
        if(menuItems!=null){
            rootCategories = menuItems.get("root");
            subCategories = menuItems.get("sub");
            endCategories = menuItems.get("end"); 
        }
        
        subCategories = CommonUtils.menuSortOnName(subCategories);
        endCategories = CommonUtils.menuSortOnName(endCategories);
        
        String cUrl = "";
        List<SeoUrl> seoListN = home.getSeoByDomainId(domainId);
        for (SeoUrl s : seoListN) {
            if (SystemConstant.HOME.equals(s.getPageType())) {
                cUrl = s.getSeoUrl();
            }
        }      
        
        pageContext.setAttribute("rootCategories", rootCategories);
        pageContext.setAttribute("subCategories", subCategories);
        pageContext.setAttribute("endCategories", endCategories);
        pageContext.setAttribute("catBrand", catBrand);
    %>
        <nav>
            <div class="container">
                <a href="#" id="toggle"><i class="fa fa-bars"></i></a>
                <ul id="nav" class="hidden-xs1">
                    <c:forEach items="${rootCategories}" var="rootCategory">
                    <c:url value="${rootCategory.url}" var="myURL"> </c:url>
                    <li><a href="${myURL}" class="active"><span><c:out value="${rootCategory.name}" /></span></a>
                      <div class="my-megamenu">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <ul>
                                <c:forEach items="${subCategories}" var="subCategory">
                                        <c:if test = "${fn:toLowerCase(rootCategory.name) eq fn:toLowerCase(subCategory.parent) }">
                                                <c:url value="${subCategory.url}" var="myURL">
                                                </c:url>
                                                
                                                    <li><h4><a href="${myURL}"><c:out value="${subCategory.name}" /></a></h4></li>                                              
                                                    <c:forEach items="${endCategories}" var="endCategory">
                                                    <c:if test = "${fn:toLowerCase(subCategory.name) == fn:toLowerCase(endCategory.parent) && fn:toLowerCase(rootCategory.name) eq fn:toLowerCase(endCategory.rootParent)}">
                                                        <c:url value="${endCategory.url}" var="myURL">
                                                        </c:url>
                                                        <li><a href="${myURL}"><span><c:out value="${endCategory.name}" /></span></a></li>
                                                    </c:if>
                                                    </c:forEach> 
                                                
                                        </c:if>

                                </c:forEach> 
                             </ul>                           
                        </div> 
                      </div>
                    </li>   
                    </c:forEach>      
                        <li class="coupon-link"><a href="/<%=cUrl%>"><span><i class="fa fa-tags" aria-hidden="true"></i> Coupons</span></a> </li>
                </ul>
            </div>
        </nav>
                