<%-- 
    Document   : getImage
    Created on : 5 Jul, 2016, 2:46:18 PM
    Author     : IshahaqKhan
--%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%  
String imageId = (String)request.getParameter("imageId");
BufferedImage imageData = SolrUtils.getImageFromUrl(imageId, request.getServletContext());
OutputStream output = response.getOutputStream();
response.setContentType("image/jpeg");
ImageIO.write(imageData, "jpg", output);
output.close();
%>