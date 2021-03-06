<!--
 * Copyright 2014 tgrape Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
<title>Fingra.ph Opensource - <spring:message code="app.list.title"/></title>
<script type="text/javascript">
$(function() {
    $('.dropdown-toggle').dropdown();
    $('div.appkey div p#appName').click(function(){
        var appkey = $(this).parents('.appkey').attr('id');
        var url = '<c:url value="/dashboard/"/>' + appkey;
        location.href=url;
    });
    $('#addApp').click(function(){
        location.href='<c:url value="/app/form"/>';
    });
    $( "span.app_name" ).each(function( index ) {
        if($(this).text().length>40){
            $(this).addClass('fontSize18');
        }
    });
    $('.deleteBtn').click(function(){
        var id = $(this).attr('id').replace('delete_','');
        var heading='Delete App';
        var question='Are you sure to delete this app?';
        var cancelButtonTxt = '<spring:message code="btn.cancel.text"/>';
        var okButtonTxt = '<spring:message code="btn.ok.text"/>';
        var callback = function() {
        	location.href='<c:url value="/app/delete?appkey='+id+'"/>';
        };
        confirm(heading, question, cancelButtonTxt, okButtonTxt, callback);
    });
});
</script>
</head>
<body>
    <div id="applist-body">
        <div class="app-list-wrap">
            <div class="list-title">
                <h1><spring:message code="app.list.title"/></h1>
            </div>
        </div>
        <div class="app-pannel">
            <c:forEach items="${list}" var="list">
                <div class="item appkey" id="${list.appkey}">
                    <div class="inner <c:choose><c:when test="${list.platform eq 1}">ios</c:when><c:when test="${list.platform eq 2}">android</c:when></c:choose>">
                    <div class="pannel-inner">
                           <p class="tx-platform"><c:choose><c:when test="${list.platform eq 1}"><i class="icon-ios"></i>iOS</c:when><c:when test="${list.platform eq 2}"><i class="icon-android"></i>ANDROID</c:when></c:choose></p>
                           <p class="tx-padding"></p>
                           <p class="tx-app-name" id="appName" style="cursor: pointer;"><span class="app_name">${list.appname}</span><br/><span class="tx-app-key">APPKEY : ${list.appkey}</span></p>
                           <p class="tx-padding"></p>
                           <sec:authorize ifAnyGranted="ROLE_ADMIN">
                               <div class="pannel-btn">
                                   <img class="del deleteBtn" id="delete_${list.appkey}" src="<c:url value="/resources/img/btn_app_del.png"/>" alt="app delete" title="app delete" style="cursor: pointer;"/>
                                   <a class="edit" href="<c:url value="/app/edit?appkey=${list.appkey}"/>"><img src="<c:url value="/resources/img/btn_app_edit.png"/>" alt="<spring:message code="btn.appedit.text"/>" title="app edit"/></a>
                               </div>
                           </sec:authorize>
                       </div>
                   </div>
               </div>
            </c:forEach>
            <sec:authorize ifAnyGranted="ROLE_ADMIN">
                <div class="item">
                    <div class="inner flat"><img src="${pageContext.request.contextPath}<spring:message code="img.applist.newapp"/>" style="cursor: pointer;" id="addApp"/></div>
                </div>
            </sec:authorize>
        </div>
   </div>
</body>
</html>
