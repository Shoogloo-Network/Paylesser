<%-- 
    Document   : nl_general
    Created on : Oct 16, 2014, 3:44:34 PM
    Author     : paulson.j
--%>



<%@page import="java.io.File"%>
<%@page import="java.awt.image.RenderedImage"%>
<%@page import="java.io.OutputStream"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="sdigital.vc.nl.utils.ClickManager"%>
<%@page import="wawo.util.StringUtil"%>

<%
    String urlHeaderLower = "http://";
    String urlHeaderUpper = "HTTP://";
    String redirectPath = "";
    String nlLogId = request.getParameter("nllog") == null ? "" : request.getParameter("nllog").replaceAll("\\<.*?>", "");
    String pubUserId = request.getParameter("user") == null ? "" : request.getParameter("user").replaceAll("\\<.*?>", "");
    String bannerUrl = request.getParameter("banner") == null ? "" : request.getParameter("banner").replaceAll("\\<.*?>", "");
    String domainUrl = request.getParameter("domain") == null ? "" : request.getParameter("domain").replaceAll("\\<.*?>", "");
    String storeUrl = request.getParameter("store") == null ? "" : request.getParameter("store").replaceAll("\\<.*?>", "");
    nlLogId = new String(wawo.security.Base64.decode(nlLogId));
    pubUserId = new String(wawo.security.Base64.decode(pubUserId));
    bannerUrl = new String(wawo.security.Base64.decode(bannerUrl));
    domainUrl = new String(wawo.security.Base64.decode(domainUrl));
    storeUrl = new String(wawo.security.Base64.decode(storeUrl));
    String offerId = request.getParameter("offer") == null ? "" : request.getParameter("offer").replaceAll("\\<.*?>", "");
    String offerUrl = request.getParameter("offerlink") == null ? "" : request.getParameter("offerlink").replaceAll("\\<.*?>", "");
    offerId = new String(wawo.security.Base64.decode(offerId));
    offerUrl = new String(wawo.security.Base64.decode(offerUrl));
    try {
        ClickManager cmanager = new ClickManager();
        //IF USER CLICKED ON BANNER
        if (!nlLogId.equals("") && !bannerUrl.equals("")) {
            cmanager.manageBannerClickFromNewsletter(nlLogId);
            if (!bannerUrl.startsWith(urlHeaderLower) && !bannerUrl.startsWith(urlHeaderUpper)) {
                bannerUrl = urlHeaderLower + bannerUrl;
            }           
            redirectPath = bannerUrl;
        }
        //IF USER CLICKED ON STORE IMAGE
        if (!nlLogId.equals("") && !domainUrl.equals("") && !storeUrl.equals("")) {
            if (!domainUrl.startsWith(urlHeaderLower) && !domainUrl.startsWith(urlHeaderUpper)) {
                domainUrl = urlHeaderLower + domainUrl;
            }
            if (storeUrl.startsWith("/")) {
            } else {
                if (!domainUrl.endsWith("/")) {
                    storeUrl = "/" + storeUrl;
                }
            }           
            redirectPath = domainUrl + storeUrl;
        }
        //IF USER CLICKED ON GET COUPON LINK
        if (!nlLogId.equals("") && !offerId.equals("") && !offerUrl.equals("")) {
            String ipAddress = request.getRemoteAddr();
            String userAgent = request.getHeader("user-agent");
            cmanager.manageOfferClickFromNewsletter(nlLogId, offerId, pubUserId, ipAddress, userAgent);
            if (!offerUrl.startsWith(urlHeaderLower) && !offerUrl.startsWith(urlHeaderUpper)) {
                offerUrl = urlHeaderLower + offerUrl;
            }
            if (offerUrl.endsWith("/")) {
            } else {
                offerUrl = offerUrl + "/";
            }          
            redirectPath = offerUrl;
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
    }
%> 
<html> 
    <head> 
        <script>
            function submitIt() {
                document.frmSubmit.submit();         
            }
        </script> 
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true"> 
    <body onload="submitIt()"> 
        <form action="<%=redirectPath%>" method="POST" name="frmSubmit">      
        </form> 
    </body>
</compress:html>
</html>
