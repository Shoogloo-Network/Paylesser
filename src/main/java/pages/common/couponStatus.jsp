<%-- 
    Document   : relatedBrand
    Created on : 7 Mar, 2016, 7 Mar, 2016 5:08:31 PM
    Author     : Ishahaq
--%>

<%@page import="wawo.sql.Cleaner"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%
    java.sql.ResultSet rsSharedCnt = null;
    java.sql.ResultSet rsWorkedCnt = null;
    java.sql.ResultSet rsCommentCnt = null;
    java.sql.ResultSet rsUsedCnt = null;
    
    String qrySharedCnt = "SELECT COUNT(VO.id) FROM vc_offer VO, vc_store VS WHERE VO.store_id = VS.id AND VO.public_user_id = ? AND "
            + "VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0";

    String qryWorkedCnt = "SELECT COUNT(DISTINCT VO.id) FROM vc_offer_acceptance VOA, vc_offer VO, vc_store VS WHERE VO.id = VOA.offer_id AND VO.store_id = VS.id "
            + "AND VOA.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0 AND VOA.like_dislike = ?";

    String qryCommentCnt = "SELECT COUNT(VO.id) FROM vc_comments VOA, vc_offer VO, vc_store VS WHERE VO.id = VOA.offer_id AND VO.store_id = VS.id "
            + "AND VOA.public_user_id = ? AND VO.publish = 1 AND VO.trash = 0 AND VS.publish = 1 AND VS.trash = 0";

    String qryUsedCnt = "SELECT COUNT(DISTINCT id) FROM vc_used_coupon WHERE public_user_id = ?";
%>
<div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs">
                    <div class="sidebar">
                        <!-- -----Related Category------>
                        <div class="related-category">
                            <h2 class="custom-icon"><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Stats.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.stats")%></h2>
                            <div class=" box">
                                <ul>
                                    <li>
                                      <a href="#"><%=p.getProperty("public.saved_coupon.coupon_used")%>
                                        <span class="stats">
                                            <%rsUsedCnt = db.select().resultSet(qryUsedCnt, new Object[]{lInfo.getPublicUserId()});
                                                if (rsUsedCnt.next()) {
                                                    out.print(rsUsedCnt.getInt(1));
                                                     } else {
                                                         out.print(0);
                                                     }%>
                                        </span></a> 
                                    </li>
                                    <li><a href="#">
                                        <%=p.getProperty("public.saved_coupon.coupon_submitted")%>
                                            <span class="stats">
                                                <%rsSharedCnt = db.select().resultSet(qrySharedCnt, new Object[]{lInfo.getPublicUserId()});
                                                    if (rsSharedCnt.next()) {
                                                        out.print(rsSharedCnt.getInt(1));
                                                         } else {
                                                             out.print(0);
                                                         }%>
                                            </span>
                                            
                                        </a></li>
                                        <li><a href="#">
                                           <%=p.getProperty("public.saved_coupon.worked")%>
                                            <span class="stats">
                                                <%rsWorkedCnt = db.select().resultSet(qryWorkedCnt, new Object[]{lInfo.getPublicUserId(), 1});
                                                    if (rsWorkedCnt.next()) {
                                                        out.print(rsWorkedCnt.getInt(1));
                                                         } else {
                                                             out.print(0);
                                                         }%>
                                            </span> 
                                                
                                            </a></li>
                                            <li><a href="#">
                                                <%=p.getProperty("public.saved_coupon.not_worked")%>
                                                <span class="stats">
                                                    <%rsWorkedCnt = db.select().resultSet(qryWorkedCnt, new Object[]{lInfo.getPublicUserId(), 0});
                                                        if (rsWorkedCnt.next()) {
                                                            out.print(rsWorkedCnt.getInt(1));
                                                             } else {
                                                                 out.print(0);
                                                             }%>
                                                </span>
                                                </a></li>
                                                <li><a href="#">
                                                    <%=p.getProperty("public.saved_coupon.comments")%>
                                                    <span class="stats">
                                                        <%rsCommentCnt = db.select().resultSet(qryCommentCnt, new Object[]{lInfo.getPublicUserId()});
                                                            if (rsCommentCnt.next()) {
                                                                out.print(rsCommentCnt.getInt(1));
                                                                 } else {
                                                                     out.print(0);
                                                                 }%>
                                                    </span>
                                                    </a></li>
                                </ul>
                            </div>    
                        </div>
                                                    
    <%
    if (rsSharedCnt != null) {
        Cleaner.close(rsSharedCnt);
    }  
    if (rsWorkedCnt != null) {
        Cleaner.close(rsWorkedCnt);
    } 
    if (rsCommentCnt != null) {
        Cleaner.close(rsCommentCnt);
    } 
    if (rsUsedCnt != null) {
        Cleaner.close(rsUsedCnt);
    } 
    %>