<%-- 
    Document   : mobileNavigation
    Created on : Jul 21, 2016, 12:16:09 PM
    Author     : Shubhra Sinha
--%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.MenuData"%>
<%@page import="java.util.Map"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


   <div class="mobile-header">
        <a class="open-left" href="#menu"><i class="fa fa-bars" aria-hidden="true"></i></a>		
        <nav id="menu">
            <ul>
                <%if (session.getAttribute("userObj") == null) {%>
                <li><a href="<%=pageUrl%>user-login"  rel="nofollow"><%=p.getProperty("public.home.login")%></a></li>
                <li><a href="<%=pageUrl + signupUrl%>" rel="nofollow"><%=p.getProperty("public.home.signup")%></a></li>
                <%} else {%>
                <li><a href="<%=pageUrl%>user-profile"><%=p.getProperty("public.home.profile")%></a></li>
                <li><a href="<%=pageUrl%>logout"><%=p.getProperty("public.home.logout")%></a></li>
                <%}%>
                <c:forEach items="${rootCategories}" var="rootCategory">
                <c:url value="${rootCategory.url}" var="myURL"></c:url>
                        <li><a href="${myURL}"><c:out value="${rootCategory.name}" /></a>
                            <ul>
                                <c:forEach items="${subCategories}" var="subCategory">
                                <c:if test = "${fn:toLowerCase(rootCategory.name) eq fn:toLowerCase(subCategory.parent) }">
                                <c:url value="${subCategory.url}" var="myURL"></c:url>
                                <li><a href="${myURL}"><c:out value="${subCategory.name}" /></a>
                                    <ul>
                                        <c:forEach items="${endCategories}" var="endCategory">
                                        <c:if test = "${fn:toLowerCase(subCategory.name) == fn:toLowerCase(endCategory.parent) && fn:toLowerCase(rootCategory.name) eq fn:toLowerCase(endCategory.rootParent)}">
                                        <c:url value="${endCategory.url}" var="myURL"></c:url>
                                        <li><a href="${myURL}"><c:out value="${endCategory.name}" /></a></li>
                                        </c:if>
                                        </c:forEach> 
                                    </ul>
                                </li>
                                </c:if>
                                </c:forEach>
                            </ul>

                        </li>
                        </c:forEach> 
                    </ul>
                </nav>
       
      <a class="mobile-logo" href="/"><img alt="Paylesser" src="<%=SystemConstant.PATH%>images/pl-logo.png"></a>   
      <div class="user-account-mm">
          <div id="sb-search" class="sb-search">
                
            <form method="get" action="/searchRedirect" id="solr_search_form">                                              
                <input id="solr_search_mob" type="text" name="q" placeholder="Search Products..." class="sb-search-input" maxlength="128">
                <button class="sb-search-submit" id="solr_search_bttn"  type="submit" value=""></button>
                <span class="sb-icon-search"><i class="fa fa-search"></i></span>
            </form>
              
            </div>
          <a class="go-copupon" href="/<%=cUrl%>"><i class="fa fa-tags" aria-hidden="true"></i></a>
      </div>
    
    </div>
