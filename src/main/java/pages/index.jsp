<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.*" %>

<%
    String domainName = (String) session.getAttribute("24");
    String pageName = (String) session.getAttribute("index.jsp");
    System.out.println(domainName);
    // Ensure domainName is not null
    if (domainName == null) {
        System.out.println("not found");
        System.out.println("Domain name is not set in session.");
        return; // Exit if domainName is not set
    }

    VcHome home = VcHome.instance();
    String domainId = home.getDomainId(domainName);

    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    List<SeoUrl> seoListMain = home.getSeoByDomainId(domainId);

    String couponSeo = "";
    for (SeoUrl s : seoListMain) {
        if (SystemConstant.HOME.equals(s.getPageType())) {
            couponSeo = s.getSeoUrl();
            break;
        }
    }

    String pageUrl = (String) session.getAttribute("scheme") + "://" + domainName + "/";

    String indexFile = "indexcoupon.jsp"; // Default file
    if ("COUPON".equals(domain.getThemeType())) {
        indexFile = "indexcoupon.jsp";
    } else if ("FEED".equals(domain.getThemeType())) {
        if (pageName.startsWith(SystemConstant.ROOT_URL)) {
            if ("36".equals(domainId) || "19".equals(domainId) || "17".equals(domainId)) {
                indexFile = "indexProductIndia.jsp";
            } else {
                indexFile = "indexProduct.jsp";
            }
        } else {
            indexFile = "indexcoupon.jsp";
        }
    }
%>

<jsp:include page="<%= indexFile %>" />
<%--<%@ page import="java.util.Date" %>--%>
<%--<html>--%>
<%--<body>--%>
<%--<h1>Current Date</h1>--%>
<%--<p>The date is: <%= new Date() %></p>--%>
<%--</body>--%>
<%--</html>--%>