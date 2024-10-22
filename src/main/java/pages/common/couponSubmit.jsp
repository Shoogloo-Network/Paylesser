<%-- 
    Document   : couponSubmit
    Created on : 4 Apr, 2016, 11:23:27 AM
    Author     : IshahaqKhan
--%>

    <%@page import="sdigital.vcpublic.config.SystemConstant"%>
    
<%String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg").replaceAll("\\<.*?>", "");%>    
<div class="related-stores">
                            <h2 class="custom-icon"><span class="icon1"><img src="<%=SystemConstant.PATH%>images/Submit-Coupon.png" alt="image" /></span><%=p.getProperty("public.saved_coupon.submit")%></h2>
                            <div class="box">
                                <form role="form" name="frmcoupon" id="frmcoupon" action="/submitcoupondb" method="post">
                                 <div class="form-group">
                                     <p id="showMsg" style="display:none"></p>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.saved_coupon.store_website")%></label>
                                    <input id="website" name="website" type="text" class="form-control autocomplete" maxlength="255"/>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.home.offer_type")%></label>
                                    <select id="profile-select" name="profile-select" class="form-control">
                                        <option value="<%=SystemConstant.COUPON_CODES%>">COUPON CODES</option>
                                        <option value="<%=SystemConstant.PROMOTIONAL_CODES%>">PROMOTIONAL CODES</option>
                                        <option value="<%=SystemConstant.PRINTABLE_CODES%>">PRINTABLE CODES</option>
                                        <option value="<%=SystemConstant.OFFERS%>">OFFERS</option>
                                        <option value="<%=SystemConstant.DEALS%>">DEALS</option>
                                        <option value="<%=SystemConstant.SALES%>">SALES</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.saved_coupon.code")%></label>
                                    <input id="code" name="code" type="text" class="form-control" maxlength="15"/>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.saved_coupon.expiry")%></label>
                                     <input id="expiry" name="expiry" type="text" class="form-control datepicker" />
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.saved_coupon.discount")%></label>
                                    <textarea id="discount" name="discount" maxlength="1000"></textarea>
                                </div> 
                                <input type="hidden" name="domainId" id="domainId" value="<%=domainId%>"/>
                                <input type="hidden" name="languageId" id="languageId" value="<%=language.getId()%>"/>
                                <input type="hidden" name="msg" id="msg" value="<%=msg%>"/>    
                                <div class="form-group">
                                    <button type="submit" class="btn green" onclick="javascript:frmCouponSubmit();" disabled="disabled"><%=p.getProperty("public.saved_coupon.submit")%></button>
                                </div>
                            </form> 
                            </div>                  
                        </div> 
