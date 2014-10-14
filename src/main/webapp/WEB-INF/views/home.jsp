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
	<title><spring:message code="test.title"/></title>
    <script type="text/javascript">
    $(function() {
    });
    </script>
</head>
<body>
<h1>
	<spring:message code="test.head"/>  
</h1>

<P> <spring:message code="test.message"/> ${serverTime}. </P>

<hr/>

<table>
    <tr>
        <td>email</td>
        <td>name</td>
        <td>department</td>
        <td>created</td>
        <td>role</td>
    </tr>
	<c:forEach items="${memberlist}" var="list">
    <tr>
        <td>${list.email}</td>
        <td>${list.name}</td>
        <td>${list.department}</td>
        <td>${list.created}</td>
        <td>${list.role}</td>
    </tr>
	</c:forEach>
</table>

<hr/>

<h1>
    admin.properties  
</h1>

name : ${admin.name}<br/>
email : ${admin.email}<br/>
password : ${admin.password}<br/>
role : ${admin.role}<br/>

<hr/>

<h1>
    login  
</h1>

<a class="btn btn-svc" href="<c:url value="/login/form"/>"> login </a>
&nbsp;&nbsp;&nbsp;
<!-- <button class="btn btn-svc" id="signOutBtn" name="signOutBtn"> logout </button> -->
<a class="btn btn-svc" href="<c:url value="/logout"/>"> logout </a>

</body>
</html>
