<%-- 
    Document   : ogimage
    Created on : 19 Jan, 2017, 12:36:15 PM
    Author     : IshahaqKhan
--%>
<%@page import="sdigital.vcpublic.config.CommonUtils"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.awt.image.BufferedImage"%>
<%
 String image = request.getParameter("image") == null ? "" : request.getParameter("image").replaceAll("\\<.*?>", "");       
BufferedImage imageData = CommonUtils.getOgImage(image);
OutputStream output = response.getOutputStream();
response.setContentType("image/png");
ImageIO.write(imageData, "png", output);
output.close();
%>